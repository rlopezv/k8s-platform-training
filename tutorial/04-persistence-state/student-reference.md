# Referencia del alumno - Unidad 04: Persistencia y estado

## Propósito de la referencia

Esta referencia amplía `tutorial/04-persistence-state/student-notes.md` con una visión profesional sobre almacenamiento en Kubernetes, persistencia, estado, `PersistentVolume`, `PersistentVolumeClaim`, `StorageClass`, CSI, backups, snapshots y workloads con identidad estable.

El laboratorio de la Unidad 04 practica un PVC local montado en `platform-api`. Esta referencia aplica cobertura de panorama, profundidad, criterio y práctica profesional: explica qué decisiones aparecen cuando la persistencia deja de ser un fichero de laboratorio y pasa a formar parte de una plataforma real. También cubre el criterio profesional de `StatefulSet`, headless Service y volumen por réplica asociado a `GAP-004`, pero su práctica funcional queda diferida a `TD-023`.

No es una segunda guía de laboratorio. No crea bases de datos, no migra `platform-api` a `StatefulSet`, no instala Velero, no crea snapshots CSI, no cambia la `StorageClass` local y no modifica el estado técnico del clúster.

## Relación con la unidad

La Unidad 04 introduce una frontera fundamental:

```text
Pod reemplazable
  -> ejecuta el proceso

Volumen persistente
  -> conserva datos fuera del ciclo de vida del Pod
```

La unidad practica:

- un `PersistentVolumeClaim` llamado `platform-api-data`;
- `storageClassName: microk8s-hostpath`;
- `accessModes: ReadWriteOnce`;
- `resources.requests.storage: 1Gi`;
- montaje en `/usr/share/nginx/html/persistent`;
- `fsGroup: 101` para permisos de escritura de laboratorio;
- prueba de persistencia al recrear Pods.

Los artefactos principales para leer esta referencia son:

| Artefacto | Ruta | Qué observar |
|---|---|---|
| PVC | `labs/04-persistence-state/solution/pvc.yaml` | Solicitud de capacidad, StorageClass y access mode |
| Deployment | `labs/04-persistence-state/solution/deployment.yaml` | `persistentVolumeClaim`, `volumeMount` y `fsGroup` |
| Validación | `labs/04-persistence-state/validation/validate.sh` | Comprobación de PVC, mount, escritura, recreación y acceso HTTP |

## Mapa conceptual

Persistencia en Kubernetes no es una sola API. Es una cadena de responsabilidades:

```text
Aplicación
  lee y escribe datos

volumeMount
  expone una ruta dentro del contenedor

volume
  conecta el Pod con una fuente de datos

PersistentVolumeClaim
  solicita almacenamiento

PersistentVolume
  representa almacenamiento asignado

StorageClass
  define cómo se aprovisiona

CSI driver o proveedor
  implementa almacenamiento real
```

El alumno debe distinguir tres ideas:

- persistencia: el dato sobrevive al reemplazo de un Pod;
- durabilidad: el dato sobrevive a fallos del soporte de almacenamiento;
- recuperación: existe un procedimiento probado para restaurar datos tras pérdida, corrupción o borrado.

La Unidad 04 practica persistencia básica. No enseña durabilidad productiva ni recuperación completa.

## Conceptos y mecanismos

### Filesystem del contenedor

El filesystem de un contenedor parte de la imagen. Puede recibir escrituras durante la ejecución, pero esas escrituras pertenecen a la instancia. Si el Pod se elimina y Kubernetes crea otro, el nuevo contenedor parte de nuevo de la imagen y de los volúmenes montados.

Esto no es un fallo de Kubernetes. Es una propiedad deliberada: los Pods deben ser reemplazables.

### Volume y volumeMount

Un `volume` define una fuente de datos disponible para el Pod. Un `volumeMount` indica dónde aparece esa fuente dentro de un contenedor.

El mismo concepto sirve para fuentes muy distintas:

| Tipo de volumen | Persistencia | Uso típico |
|---|---|---|
| `emptyDir` | Vive mientras vive el Pod | Datos temporales compartidos entre contenedores del Pod |
| `configMap` | Proyecta configuración | Ficheros no sensibles gestionados por Kubernetes |
| `secret` | Proyecta datos sensibles o ficticios | Credenciales o valores que no deben ir como ConfigMap |
| `persistentVolumeClaim` | Depende del PV/proveedor | Datos que deben sobrevivir al reemplazo del Pod |

Un mount no convierte cualquier ruta en persistente. Solo persiste lo escrito dentro de la ruta respaldada por el volumen adecuado.

`emptyDir` merece una mención aparte porque es útil, pero fácil de malinterpretar. Puede servir para scratch space, intercambio temporal entre contenedores del mismo Pod, descargas intermedias, sockets o ficheros generados durante una ejecución. No debe usarse para estado que deba sobrevivir a la recreación del Pod. Si el Pod desaparece, desaparece también el `emptyDir`; que el contenedor haya escrito ahí no cambia su ciclo de vida.

### PersistentVolumeClaim

Un `PersistentVolumeClaim` es una solicitud de almacenamiento hecha por un workload. El PVC expresa qué necesita la aplicación sin obligarla a conocer el detalle físico del almacenamiento.

En esta unidad:

```yaml
accessModes:
  - ReadWriteOnce
storageClassName: microk8s-hostpath
resources:
  requests:
    storage: 1Gi
```

El PVC no es el disco ni el dato. Es el contrato entre el workload y la plataforma.

### PersistentVolume

Un `PersistentVolume` representa almacenamiento disponible o aprovisionado para Kubernetes. Puede crearse dinámicamente mediante una `StorageClass` o declararse de forma estática por un administrador.

El ciclo habitual en esta unidad es:

```text
PVC creado
  -> StorageClass aprovisiona PV
  -> PVC queda Bound
  -> Pod puede montar el claim
```

Si el PVC se queda `Pending`, el problema suele estar en la StorageClass, el aprovisionador, la capacidad, el access mode o la política de binding.

### StorageClass

Una `StorageClass` define una clase de almacenamiento y su aprovisionador. En MicroK8s, `microk8s-hostpath` permite aprender el flujo localmente.

En cloud, una StorageClass puede representar discos gestionados, volúmenes de bloque, sistemas de fichero compartidos o integraciones específicas del proveedor.

Algunas propiedades relevantes son:

- `provisioner`;
- `reclaimPolicy`;
- `volumeBindingMode`;
- parámetros del proveedor;
- soporte de expansión;
- soporte de snapshots;
- topología o zona.

La API Kubernetes es común, pero el comportamiento real depende mucho del proveedor.

`reclaimPolicy` decide qué ocurre con el `PersistentVolume` cuando el claim que lo usaba se elimina. Con `Delete`, el PV y el almacenamiento subyacente suelen eliminarse como parte de la limpieza. Es cómodo para entornos efímeros, pero peligroso si alguien borra un PVC pensando que solo retira el vínculo con el workload. Con `Retain`, Kubernetes conserva el PV y normalmente deja el soporte de almacenamiento detrás; el dato no desaparece automáticamente, pero el volumen queda fuera del flujo normal hasta que un operador lo revise, limpie, reasigne o retire.

Ese estado intermedio es lo que suele llamarse PV huérfano: el objeto o el disco pueden seguir existiendo, pero ya no hay un PVC activo que lo consuma de forma normal. No es necesariamente un error; a veces es una decisión deliberada para proteger datos antes de una restauración o análisis. El riesgo aparece cuando nadie tiene ownership claro: se acumulan volúmenes, se paga almacenamiento olvidado, se exponen datos residuales o se intenta reutilizar un PV con contenido antiguo sin limpiar. Por eso una plataforma profesional define política de reclamación, etiquetas de ownership, procedimiento de borrado y revisión periódica de PV retenidos.

El laboratorio no cambia la `reclaimPolicy` de `microk8s-hostpath`. La referencia sí debe dejar el criterio: borrar un Pod, borrar un Deployment y borrar un PVC no son operaciones equivalentes. El PVC es la frontera delicada; antes de eliminarlo hay que saber si el PV se borrará, quedará retenido o requerirá una acción manual posterior.

### Access modes

Los access modes expresan cómo puede montarse un volumen desde el punto de vista de Kubernetes.

| Access mode | Idea general |
|---|---|
| `ReadWriteOnce` | Lectura/escritura por un nodo |
| `ReadOnlyMany` | Lectura por varios nodos |
| `ReadWriteMany` | Lectura/escritura por varios nodos |
| `ReadWriteOncePod` | Lectura/escritura por un solo Pod |

Un access mode no garantiza que la aplicación soporte concurrencia. Que un volumen pueda montarse desde varios lugares no significa que dos procesos puedan escribir sin corrupción.

### CSI

CSI, Container Storage Interface, es la interfaz estándar que permite integrar Kubernetes con proveedores de almacenamiento.

Un driver CSI puede implementar:

- aprovisionamiento dinámico;
- attach y detach;
- mount y unmount;
- expansión de volúmenes;
- snapshots;
- clones;
- topología por zonas;
- métricas o capacidades específicas.

El laboratorio no instala ni gestiona un driver CSI. MicroK8s simplifica el aprendizaje con `hostpath-storage`.

### StatefulSet y headless Service

La Unidad 04 conserva `Deployment` porque `platform-api` no necesita identidad estable por réplica. Eso es deliberado.

`StatefulSet` aparece cuando el problema cambia:

- cada réplica necesita identidad estable;
- el nombre del Pod importa;
- cada réplica necesita su propio volumen;
- el orden de creación, actualización o eliminación importa;
- la aplicación forma parte de un sistema con estado distribuido.

Un headless Service permite descubrir Pods individuales sin una IP virtual de Service. Suele acompañar a StatefulSets cuando las réplicas deben encontrarse por identidad estable.

`volumeClaimTemplates` permite que un StatefulSet cree un PVC por réplica siguiendo una plantilla común. En vez de compartir un único claim, cada Pod estable recibe su propio claim asociado a su identidad. Ese patrón encaja con sistemas que necesitan dato por miembro, como algunos motores de base de datos o colas, pero también aumenta el coste operativo: migración, backup, restore, escalado y eliminación deben considerar cada réplica y cada volumen.

No toda persistencia implica StatefulSet. Una aplicación puede usar un `Deployment` con PVC si el patrón de acceso, las réplicas y el almacenamiento son compatibles. En esta unidad, el objetivo es aprender PVC/PV/StorageClass antes de añadir identidad estable por réplica. La práctica técnica de `StatefulSet`, headless Service y `volumeClaimTemplates` queda diferida a `TD-023`.

### Snapshots, backup y restore

Persistencia no es backup.

Un volumen persistente puede conservar datos aunque el Pod se reemplace, pero no protege por sí solo frente a:

- borrado accidental;
- corrupción lógica;
- eliminación del PVC/PV;
- fallo del nodo o proveedor;
- ransomware;
- error humano durante mantenimiento;
- necesidad de restaurar a un punto anterior.

Los snapshots CSI capturan el estado de un volumen cuando el driver lo soporta. Herramientas como Velero pueden coordinar backup de objetos Kubernetes y snapshots o copias de volúmenes. Aun así, backup real exige políticas, pruebas de restauración, RPO, RTO, cifrado, retención y ownership.

La Unidad 04 solo practica copia/restauración básica de un fichero inocuo para reforzar el razonamiento. La recuperación productiva queda para la Unidad 23.

## Criterios de decisión

### Cuándo usar almacenamiento persistente

Usa persistencia cuando el dato:

- se produce durante la ejecución;
- debe sobrevivir al reemplazo de Pods;
- no puede reconstruirse fácilmente desde la imagen o configuración;
- tiene valor operativo o de negocio.

No uses PVC para configuración estática que pertenece a `ConfigMap`, secretos que pertenecen a una estrategia de secretos o cachés que pueden regenerarse.

### Cuándo conservar Deployment

Un `Deployment` puede seguir siendo razonable si:

- la aplicación no necesita identidad estable por réplica;
- el almacenamiento soporta el patrón de acceso elegido;
- solo una instancia escribe o la concurrencia está controlada;
- el volumen representa un dato simple de laboratorio o un caso acotado.

La Unidad 04 usa `Deployment` para no mezclar dos aprendizajes grandes: persistencia y StatefulSet.

### Cuándo considerar StatefulSet

Considera `StatefulSet` cuando:

- cada réplica necesita un volumen distinto;
- la identidad de red de cada réplica importa;
- hay quorum, replicación o coordinación interna;
- el orden de actualización afecta a la seguridad del dato;
- la aplicación tiene instrucciones específicas para Kubernetes stateful.

La práctica técnica de StatefulSet y headless Service queda como continuidad natural de persistencia, no como sustitución automática de cualquier Deployment con PVC.

### Cómo evaluar una StorageClass

Antes de elegir una StorageClass, pregunta:

- qué proveedor la implementa;
- qué `reclaimPolicy` aplica;
- si aprovisiona en una zona concreta;
- si soporta expansión;
- si soporta snapshots;
- qué access modes ofrece;
- qué latencia y rendimiento promete;
- cómo se cifra;
- cómo se factura;
- cómo se restaura.

En MicroK8s, `microk8s-hostpath` sirve para aprender. En AKS/EKS, la elección dependerá de discos gestionados, sistemas de fichero, CSI drivers, zonas y requisitos de disponibilidad.

En manifiestos planos, fijar `storageClassName: microk8s-hostpath` es aceptable para un laboratorio local porque hace explícita la dependencia. En un artefacto reutilizable entre entornos, ese valor no debería quedar incrustado sin una capa de parametrización. Helm, que aparece en la Unidad 06, permitirá convertir el nombre de la StorageClass en un valor por entorno; cloud lo resolverá después con clases gestionadas, políticas de cifrado, zonas y drivers CSI. El criterio no es ocultar la StorageClass, sino hacer visible que pertenece a la plataforma, no a la lógica de negocio de `platform-api`.

### Cómo pensar backup

Una política mínima de backup debería responder:

- qué datos se respaldan;
- con qué frecuencia;
- durante cuánto tiempo;
- dónde se guardan;
- quién puede restaurar;
- cuánto dato se puede perder;
- cuánto tarda la restauración;
- cuándo se probó por última vez.

Sin prueba de restauración, el backup es una hipótesis.

## Relación con el laboratorio

El laboratorio practica:

- inspección de StorageClasses;
- habilitación o verificación de `hostpath-storage`;
- creación de `platform-api-data`;
- montaje del PVC en `platform-api`;
- escritura de un dato no sensible en `/usr/share/nginx/html/persistent`;
- recreación de Pods;
- validación del dato por `kubectl exec` y por Ingress;
- copia y restauración básica de un fichero de laboratorio.

El laboratorio menciona, pero no practica:

- StatefulSet;
- headless Service;
- `volumeClaimTemplates`;
- bases de datos reales;
- CSI snapshots;
- Velero;
- replicación;
- cifrado de datos;
- backup productivo;
- storage cloud gestionado.

No debe borrarse el PVC como limpieza rutinaria. El PVC representa una frontera distinta a la de Pods y Deployments: al eliminarlo, se puede perder o desconectar el dato según la política de reclamación del PV.

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Creer que PVC es el dato | El PVC es la solicitud; el dato vive en el volumen aprovisionado |
| Escribir fuera del mount persistente | El dato seguirá atado al filesystem efímero del contenedor |
| Confundir ConfigMap con persistencia | ConfigMap entrega configuración, no datos generados por la aplicación |
| Decir que hay backup porque hay PVC | Persistencia y recuperación son problemas distintos |
| Presentar `hostpath-storage` como patrón productivo | Liga datos al nodo local y no ofrece garantías cloud |
| Usar varias réplicas sin entender el modo de acceso | El almacenamiento y la aplicación deben soportar el patrón de concurrencia |
| Elegir StatefulSet por reflejo | StatefulSet resuelve identidad estable, no todos los problemas de datos |
| Ignorar permisos del volumen | El contenedor puede montar un volumen y no poder escribir en él |

## Continuidad

La Unidad 05 retomará la persistencia como restricción de scheduling y mantenimiento. Un PVC local puede condicionar dónde puede ejecutarse un Pod y qué ocurre durante interrupciones voluntarias.

La Unidad 06 empaquetará el PVC y sus montajes en Helm, manteniendo la diferencia entre configuración, datos persistentes y recursos derivados del chart.

`TD-023` retomará la Unidad 04 con una práctica funcional de `StatefulSet`, headless Service y `volumeClaimTemplates` sobre un workload auxiliar desechable, sin migrar `platform-api`.

La Unidad 16 conectará almacenamiento con seguridad de workloads, ownership, RBAC, ServiceAccounts y políticas de acceso.

La Unidad 19 comparará `microk8s-hostpath` con almacenamiento de AKS/EKS y registrará qué supuestos locales deben sustituirse antes de migrar.

La Unidad 20 y la Unidad 21 deberán decidir StorageClasses cloud, CSI drivers, zonas, cifrado, snapshots y políticas de datos.

La Unidad 23 retomará backup, restore, RPO/RTO, continuidad y runbooks de recuperación como operación real.

La práctica de StatefulSet y headless Service debe aparecer cuando el problema lo justifique: aplicaciones con identidad estable, almacenamiento por réplica o coordinación stateful.

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Kubernetes - Volumes](https://kubernetes.io/docs/concepts/storage/volumes/) | Tipos de volumen y `volumeMounts` | ¿Qué diferencia hay entre volumen efímero, proyectado y persistente? |
| [Kubernetes - Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) | PV, PVC, binding, reclaim y access modes | ¿Qué pide un PVC y qué representa un PV? |
| [Kubernetes - Storage Classes](https://kubernetes.io/docs/concepts/storage/storage-classes/) | Aprovisionamiento dinámico y parámetros | ¿Qué decisiones de plataforma se esconden detrás de una StorageClass? |
| [Kubernetes - Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/) | Relación entre PVC y StorageClass | ¿Cómo aparece un PV sin crearlo manualmente? |
| [Kubernetes - StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) | Identidad estable, ordinales y volumen por réplica | ¿Cuándo un Deployment deja de ser suficiente para workloads con estado? |
| [Kubernetes - Volume Snapshots](https://kubernetes.io/docs/concepts/storage/volume-snapshots/) | Snapshots CSI y recursos asociados | ¿Por qué snapshot no es lo mismo que backup completo? |
| [CSI Documentation](https://kubernetes-csi.github.io/docs/) | Capacidades de drivers CSI | ¿Qué parte del almacenamiento implementa el proveedor? |
| [Velero Documentation](https://velero.io/docs/) | Backup y restore de recursos Kubernetes y volúmenes | ¿Qué necesita una estrategia de recuperación más allá de un PVC? |
| [Canonical MicroK8s hostpath storage addon](https://microk8s.io/docs/addon-hostpath-storage) | Funcionamiento y límites del addon local | ¿Qué parte del laboratorio es específica de MicroK8s? |
