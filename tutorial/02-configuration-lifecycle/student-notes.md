# Student notes - Unidad 02

## Propósito

Estas notas explican cómo una aplicación Kubernetes deja de ser solo un contenedor en marcha y empieza a ser un workload configurable, observable y gobernado por ciclo de vida. El laboratorio extiende `platform-api`; estas notas explican qué representa cada pieza antes de ver cómo se usa.

Para una capa de referencia más amplia, con criterios profesionales y límites de los mecanismos, consulta `tutorial/02-configuration-lifecycle/student-reference.md`.

La idea central es:

```text
La imagen contiene el software.
El Deployment declara cómo debe ejecutarse.
ConfigMaps, Secrets, probes y resources describen lo que necesita para operar.
```

## Qué se va a cubrir

| Bloque | Qué aporta | Nivel en esta unidad |
|---|---|---|
| Configuración externa | Separar valores modificables de la imagen | Práctico |
| ConfigMap | Guardar configuración no sensible | Práctico |
| Secret | Representar datos sensibles de laboratorio | Práctico, con límites explícitos |
| Variables de entorno | Inyectar valores al proceso al arrancar | Práctico |
| Volumen de configuración | Entregar ficheros desde un ConfigMap | Práctico |
| Probes | Declarar arranque, disponibilidad y salud | Práctico |
| Requests y limits | Declarar necesidades y fronteras de CPU/memoria | Práctico |
| Terminación básica | Declarar `terminationGracePeriodSeconds` | Práctico parcial |
| Rollout | Observar cambios del template del Pod | Práctico |
| Eventos y logs | Diagnosticar configuración, salud y recursos | Práctico |

No se cubren Ingress, DNS externo, persistencia real, Helm, Terraform, observabilidad avanzada, gestión productiva de secretos, `preStop`, autoscaling ni cuotas de namespace. Todo eso aparece más adelante.

## Qué representa cada componente

### Componentes de configuración y datos

| Componente | Qué representa | Qué problema resuelve | Qué no es |
|---|---|---|---|
| ConfigMap | Configuración no sensible almacenada como objeto Kubernetes | Permite cambiar valores o ficheros sin reconstruir la imagen | No es almacenamiento persistente ni lugar para secretos |
| Secret | Datos sensibles o credenciales representados como objeto Kubernetes | Separa secretos de la imagen y del manifiesto principal del Deployment | No es seguridad completa por sí mismo; no deben guardarse valores reales en el repo |
| Variable de entorno | Valor entregado al proceso al arrancar | Permite que la aplicación lea configuración simple | No se actualiza dentro de un proceso ya arrancado |
| Volumen de ConfigMap | Ficheros proyectados dentro del contenedor | Permite entregar configuración como archivo | No conserva datos escritos por la aplicación |
| `stringData` | Forma legible de declarar datos de un Secret en laboratorio | Evita escribir base64 manualmente | No cambia la obligación de no versionar secretos reales |

### Componentes de salud, recursos y ciclo de vida

| Componente | Qué representa | Qué problema resuelve | Qué no es |
|---|---|---|---|
| `startupProbe` | Comprobación de arranque inicial | Da tiempo a una aplicación lenta antes de aplicar otras probes | No decide tráfico estable por sí sola |
| `readinessProbe` | Comprobación de disponibilidad para recibir tráfico | Evita enviar peticiones a Pods que aún no están listos | No reinicia contenedores |
| `livenessProbe` | Comprobación de que el contenedor sigue vivo | Permite reiniciar un contenedor bloqueado | No debe comprobar dependencias externas frágiles |
| `requests` | Recursos mínimos que el scheduler usa para planificar | Ayuda a decidir si un Pod cabe en un nodo | No limita el consumo máximo |
| `limits` | Frontera máxima de consumo | Evita que un contenedor consuma sin límite | No garantiza rendimiento |
| `terminationGracePeriodSeconds` | Tiempo que Kubernetes concede antes de forzar terminación | Da margen al proceso para cerrar | No sustituye una aplicación que atienda SIGTERM ni un hook `preStop` |
| Rollout | Transición controlada entre versiones del template | Permite reemplazar Pods cuando cambia la declaración | No ocurre por cualquier cambio del clúster |

Una forma corta de recordarlo:

```text
ConfigMap y Secret entregan datos.
Probes deciden tráfico y reinicio.
Requests hablan con el scheduler.
Limits hablan con el nodo y el runtime.
La terminación graceful requiere cooperación del proceso.
Rollout reemplaza Pods cuando cambia el template.
```

## Qué vas a construir

Extenderás el `Deployment` de `platform-api` que venía de la Unidad 01.

| Elemento | Valor o cambio |
|---|---|
| ConfigMap | `platform-api-config` |
| Secret de laboratorio | `platform-api-secret` |
| Variables de entorno | `APP_ENV`, `LOG_LEVEL`, `FEATURE_GREETING`, `LAB_CLIENT_ID`, `LAB_API_TOKEN` |
| Fichero configurado | `index.html` montado desde ConfigMap |
| Probes | `startupProbe`, `readinessProbe`, `livenessProbe` HTTP sobre `/` |
| Recursos | `requests` de `25m` CPU y `64Mi`; `limits` de `100m` CPU y `128Mi` |
| Terminación | `terminationGracePeriodSeconds: 20` |

El resultado sigue siendo la misma aplicación, el mismo namespace y el mismo Service interno. La diferencia es que ahora el Pod declara de forma explícita cómo recibe configuración, cómo expone salud y con qué recursos opera.

## Cómo se relacionan

La Unidad 02 modifica el template del Pod dentro del Deployment:

```text
ConfigMap ----\
Secret --------\
Probes ---------> Deployment.spec.template -> ReplicaSet -> Pods
Resources -----/
```

El Service sigue seleccionando Pods por labels, pero ahora hay una condición adicional:

```text
Service selecciona Pods por labels
EndpointSlice solo incluye destinos que están listos
readinessProbe influye en esa disponibilidad
```

Por eso un Pod puede estar `Running` y aun así no recibir tráfico: ejecutarse no es lo mismo que estar listo.

## Qué ocurre cuando aplicas los manifiestos

Cuando aplicas ConfigMap o Secret, creas objetos de datos. Cuando aplicas el Deployment, su template referencia esos objetos y Kubernetes crea Pods que los consumen.

Flujo mental:

```text
1. La API guarda ConfigMap y Secret.
2. La API guarda el Deployment actualizado.
3. Como cambia el template, el Deployment inicia un rollout.
4. Se crea un ReplicaSet nuevo.
5. Los Pods nuevos arrancan con variables, volumen, probes y resources.
6. La startup probe protege el arranque.
7. La readiness probe decide si entran en endpoints.
8. La liveness probe puede reiniciar contenedores bloqueados.
9. Requests influyen en scheduling; limits en consumo durante ejecución.
10. Si el Pod termina, Kubernetes concede el grace period antes de forzar el cierre.
```

No todos los cambios tienen el mismo efecto. Cambiar el template del Deployment provoca rollout. Cambiar solo el contenido de un ConfigMap puede no recrear Pods automáticamente; depende de cómo se consuma y de si reaplicas o reinicias el workload.

## Cómo comprobar que funciona

Comprueba que existen los objetos nuevos:

```bash
kubectl -n platform-training get configmap platform-api-config
kubectl -n platform-training get secret platform-api-secret
```

Comprueba el rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
```

Comprueba que las probes, recursos y terminación están declarados:

```bash
kubectl -n platform-training describe deployment platform-api
```

Comprueba Pods y endpoints:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

Comprueba logs:

```bash
kubectl -n platform-training logs deployment/platform-api --tail=50
```

La validación automatizada de la unidad es:

```bash
bash labs/02-configuration-lifecycle/validation/validate.sh
```

## Cómo diagnosticar los 4 fallos típicos

### 1. El Pod no arranca por configuración ausente

Síntoma: Pods en error o eventos indicando que falta una clave de ConfigMap o Secret.

Comprueba:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get configmap platform-api-config -o yaml
kubectl -n platform-training get secret platform-api-secret
```

Idea clave: el template referencia nombres y claves. Si el objeto o la clave no existen, el Pod no puede construirse correctamente. No imprimas ni decodifiques valores de Secret.

### 2. Cambio el ConfigMap y no veo el cambio

Síntoma: el objeto ConfigMap cambió, pero la aplicación sigue mostrando contenido anterior.

Comprueba:

```bash
kubectl -n platform-training get configmap platform-api-config -o yaml
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get pods
```

Idea clave: una variable de entorno queda fijada al arrancar el proceso. Un fichero montado puede actualizarse, pero la aplicación tiene que leerlo de nuevo. Si quieres recrear Pods, cambia el template o reinicia el Deployment de forma controlada.

### 3. El Service no tiene endpoints aunque hay Pods

Síntoma: Pods `Running`, pero sin destinos listos en EndpointSlice.

Comprueba:

```bash
kubectl -n platform-training get pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

Idea clave: readiness decide si un Pod está listo para tráfico. `Running` solo indica que el contenedor existe.

### 4. El Pod queda `Pending` o el contenedor muere por recursos

Síntoma: Pod pendiente, eventos de scheduling, `OOMKilled` o aplicación lenta.

Comprueba:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Idea clave: `requests` influyen antes de arrancar, durante scheduling. `limits` actúan durante ejecución. CPU suele degradar; memoria puede terminar el contenedor.

## Qué debes recordar para la Unidad 03

La Unidad 03 introducirá entrada HTTP estable desde fuera del clúster. Para entenderla necesitas conservar tres ideas de esta unidad:

| Idea | Por qué importa después |
|---|---|
| Readiness decide tráfico | Ingress solo podrá enviar tráfico útil si el Service tiene destinos listos |
| Service sigue siendo interno | Ingress no reemplaza al Service; lo usa como backend |
| Configuración y probes viven en el template | Cambios relevantes siguen provocando rollouts |

Resumen:

```text
Deployment configura Pods.
Readiness decide si esos Pods entran en endpoints.
Ingress, en la Unidad 03, dependerá de esa cadena.
```

## Fuentes de referencia

| Fuente | Qué leer | Para qué sirve |
|---|---|---|
| [Kubernetes - Configuration](https://kubernetes.io/docs/concepts/configuration/) | Vista general de configuración | Ubicar los mecanismos de configuración |
| [Kubernetes - Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/) | Fases, condiciones y terminación de Pods | Entender que `Running`, `Ready` y terminación son estados distintos |
| [Kubernetes - Container Resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Requests y limits | Entender scheduling y consumo |
| [Laboratorio Unidad 02](../../labs/02-configuration-lifecycle/README.md) | Procedimiento operativo | Ejecutar y recuperar la práctica |
