# Student notes - Unidad 04

## Propósito

Estas notas explican qué significa persistir datos en Kubernetes. Hasta ahora `platform-api` podía recrear Pods sin conservar nada escrito dentro del contenedor. Esta unidad introduce el modelo que permite separar una aplicación reemplazable de ciertos datos que deben sobrevivir.

Para una capa de referencia más amplia, con criterios profesionales sobre StorageClass, CSI, StatefulSet, snapshots, backup y límites de `hostpath-storage`, consulta `tutorial/04-persistence-state/student-reference.md`.

La idea central es:

```text
El Pod es efímero.
El dato importante debe vivir fuera del ciclo de vida del Pod.
El PVC es la solicitud que conecta el workload con almacenamiento persistente.
```

## Qué se va a cubrir

| Bloque | Qué aporta | Nivel en esta unidad |
|---|---|---|
| Filesystem de contenedor | Entender que se pierde al reemplazar Pods | Conceptual |
| Volume | Punto de montaje dentro del Pod | Práctico |
| `emptyDir` | Contraste con almacenamiento efímero | Conceptual |
| PersistentVolume | Representación del almacenamiento disponible | Conceptual y observado |
| PersistentVolumeClaim | Solicitud de almacenamiento del workload | Práctico |
| StorageClass | Política de aprovisionamiento | Práctico en MicroK8s |
| Access modes | Condiciones de acceso al volumen | Conceptual |
| Mount path | Ruta que ve la aplicación | Práctico |
| Copia y restauración | Verificación básica de datos de laboratorio | Práctico |

No se cubren bases de datos reales, snapshots CSI, Velero, backups productivos, cifrado, replicación ni almacenamiento cloud gestionado. Esos temas quedan explicados o anclados en `tutorial/04-persistence-state/student-reference.md`. La práctica independiente de StatefulSet, headless Service y `volumeClaimTemplates` queda implementada y validada en `labs/04-persistence-state/statefulset-demo/` para `TD-023`, sin migrar `platform-api`.

## Qué representa cada componente

| Componente | Qué representa | Qué problema resuelve | Qué no es |
|---|---|---|---|
| Filesystem de la imagen | Contenido inicial del contenedor | Da una base reproducible al proceso | No conserva escrituras entre Pods reemplazados |
| Escritura dentro del contenedor | Cambio local en el filesystem del contenedor | Permite trabajo temporal | No es persistencia fiable |
| Volume | Directorio montado dentro de un Pod | Da al contenedor una ruta respaldada por algún origen | No define por sí solo almacenamiento duradero |
| `emptyDir` | Volumen ligado al ciclo de vida del Pod | Sirve para datos temporales compartidos dentro del Pod | No sobrevive al reemplazo del Pod |
| PersistentVolume | Recurso que representa almacenamiento disponible | Conecta Kubernetes con capacidad real o aprovisionada | No es lo que la aplicación pide directamente |
| PersistentVolumeClaim | Solicitud de almacenamiento hecha por el workload | Permite pedir capacidad sin conocer el detalle de la plataforma | No contiene el dato por sí mismo |
| StorageClass | Política para crear o seleccionar almacenamiento | Permite aprovisionamiento dinámico | No se comporta igual en local que en cloud |
| Access mode | Condición de acceso declarada | Expresa cómo puede montarse un volumen | No garantiza concurrencia segura de la aplicación |
| `volumeMount` | Ruta visible dentro del contenedor | Hace que el volumen sea usable por el proceso | No crea el volumen |

Frase clave:

```text
PVC pide almacenamiento; volume lo referencia; volumeMount lo expone en una ruta.
```

## Qué vas a construir

La unidad conserva configuración, Secret ficticio, probes, resources, Service e Ingress. Añade persistencia local de laboratorio.

| Elemento | Valor |
|---|---|
| PVC | `platform-api-data` |
| StorageClass | `microk8s-hostpath` |
| Capacidad solicitada | `1Gi` |
| Access mode | `ReadWriteOnce` |
| Volumen en el Pod | `platform-api-data` |
| Ruta montada | `/usr/share/nginx/html/persistent` |
| Ajuste de permisos | `fsGroup: 101` |
| Dato de prueba | `/persistent/message.txt` |

Este almacenamiento es útil para aprender el modelo, pero no debe confundirse con una solución productiva de datos.

## Cómo se relacionan

La cadena de almacenamiento es:

```text
StorageClass
  define cómo se aprovisiona
PVC
  solicita almacenamiento
PV
  queda enlazado al PVC
Pod volume
  referencia el PVC
volumeMount
  expone una ruta dentro del contenedor
Aplicación
  lee y escribe en esa ruta
```

Si el PVC está `Bound` pero la aplicación escribe fuera de la ruta montada, el dato se perderá al reemplazar el Pod. La persistencia no depende solo de crear un PVC; depende de que el workload lo monte y use la ruta correcta.

## Qué ocurre cuando aplicas los manifiestos

Flujo mental:

```text
1. La API guarda el PVC.
2. La StorageClass local aprovisiona o enlaza un PV.
3. El PVC pasa a estado Bound.
4. El Deployment declara un volume que referencia el PVC.
5. El contenedor monta ese volumen en /usr/share/nginx/html/persistent.
6. Lo escrito en esa ruta queda fuera del filesystem efímero del contenedor.
7. Si el Pod se reemplaza, el nuevo Pod monta el mismo claim.
```

En MicroK8s, `microk8s-hostpath` usa almacenamiento local del nodo. Eso simplifica el laboratorio, pero también limita la portabilidad: en un clúster multi-nodo o cloud la implementación cambia.

## Cómo comprobar que funciona

Comprueba StorageClass y PVC:

```bash
kubectl get storageclass
kubectl -n platform-training get pvc platform-api-data
```

Resultado esperado:

```text
El PVC aparece en estado Bound.
```

Comprueba que el Deployment monta el volumen:

```bash
kubectl -n platform-training describe deployment platform-api
```

Escribe un dato de laboratorio:

```bash
kubectl -n platform-training exec deploy/platform-api -- sh -c 'echo "dato persistente" > /usr/share/nginx/html/persistent/message.txt'
```

Recrea un Pod de forma controlada y comprueba que el dato sigue:

```bash
kubectl -n platform-training delete pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training exec deploy/platform-api -- cat /usr/share/nginx/html/persistent/message.txt
```

La validación automatizada de la unidad es:

```bash
bash labs/04-persistence-state/validation/validate.sh
```

## Cómo diagnosticar los 4 fallos típicos

### 1. El PVC se queda `Pending`

Comprueba:

```bash
kubectl get storageclass
kubectl -n platform-training describe pvc platform-api-data
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Idea clave: el problema está antes del Pod. Si el claim no enlaza, el workload no tiene almacenamiento que montar.

### 2. El Pod no arranca por fallo de montaje

Comprueba:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training describe pvc platform-api-data
```

Idea clave: antes de mirar logs de la aplicación, mira eventos de volumen y montaje.

### 3. El dato desaparece tras recrear el Pod

Comprueba:

```bash
kubectl -n platform-training exec deploy/platform-api -- mount
kubectl -n platform-training exec deploy/platform-api -- ls -la /usr/share/nginx/html/persistent
```

Idea clave: probablemente escribiste fuera del mount persistente. Solo persiste lo escrito en la ruta respaldada por el PVC.

### 4. Permiso denegado al escribir

Comprueba:

```bash
kubectl -n platform-training describe deployment platform-api
kubectl -n platform-training exec deploy/platform-api -- id
kubectl -n platform-training exec deploy/platform-api -- ls -ld /usr/share/nginx/html/persistent
```

Idea clave: montar un volumen no garantiza que el usuario del contenedor pueda escribir. En esta unidad se usa `fsGroup` para facilitar permisos de laboratorio.

## Qué debes recordar para la Unidad 05

La Unidad 05 tratará scheduling, resiliencia y mantenimiento. La persistencia cambia esas conversaciones.

| Idea | Por qué importa después |
|---|---|
| Un PVC local ata datos a una implementación concreta | Puede condicionar dónde puede arrancar un Pod |
| Dos réplicas no significan dos copias independientes de datos | La aplicación y el almacenamiento deben ser compatibles |
| Persistencia no es backup | Sobrevivir a reemplazar Pods no equivale a recuperarse de pérdida de datos |

Resumen:

```text
Persistencia conserva datos frente a Pods efimeros.
También introduce restricciones físicas.
La Unidad 05 estudiará esas restricciones al hablar de ubicación y mantenimiento.
```

## Fuentes de referencia

| Fuente | Qué leer | Para qué sirve |
|---|---|---|
| [Kubernetes - Volumes](https://kubernetes.io/docs/concepts/storage/volumes/) | Tipos de volumen y montajes | Distinguir volumen efímero, config y persistente |
| [Kubernetes - Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) | PV, PVC y ciclo de vida | Entender el contrato de almacenamiento |
| [Kubernetes - Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/) | Aprovisionamiento dinámico | Entender el papel de la plataforma |
| [Kubernetes - Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/) | Creación automática de PV | Relacionar PVC y StorageClass |
| [Kubernetes - Configure a Pod to Use a PersistentVolume](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/) | Ejemplo guiado | Ver el flujo completo PVC -> Pod |
