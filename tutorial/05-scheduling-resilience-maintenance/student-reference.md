# Referencia del alumno - Unidad 05: Scheduling, resiliencia y mantenimiento

## Propósito de la referencia

Esta referencia amplía `tutorial/05-scheduling-resilience-maintenance/student-notes.md` con una visión profesional sobre scheduling, resiliencia, mantenimiento, `PodDisruptionBudget`, rollouts, disponibilidad y límites de un laboratorio local.

El laboratorio de la Unidad 05 practica constraints seguros, `RollingUpdate`, rollback y PDB sobre `platform-api`. Esta referencia no cierra una laguna nueva del registro, pero aplica cobertura de panorama, profundidad, criterio y práctica: explica cómo razonar sobre esas piezas cuando existen varios nodos, zonas, almacenamiento, mantenimiento planificado, políticas de plataforma y expectativas reales de disponibilidad.

No es una segunda guía de laboratorio. No ejecuta `kubectl drain`, no modifica labels ni taints de nodos, no cambia el PDB, no introduce autoscaling, no instala herramientas de progressive delivery y no modifica el estado técnico del clúster.

## Relación con la unidad

La Unidad 05 añade política operativa al `Deployment` acumulado:

- `replicas: 2`;
- `strategy.type: RollingUpdate`;
- `maxUnavailable: 1`;
- `maxSurge: 1`;
- `revisionHistoryLimit: 5`;
- `minReadySeconds: 5`;
- `nodeSelector` para `kubernetes.io/os: linux`;
- node affinity preferida;
- pod anti-affinity preferida por `kubernetes.io/hostname`;
- `PodDisruptionBudget` con `minAvailable: 1`.

Los artefactos principales para leer esta referencia son:

| Artefacto | Ruta | Qué observar |
|---|---|---|
| Deployment | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | Estrategia, scheduling, affinity, probes, resources y PVC |
| PDB | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` | Selector y `minAvailable: 1` |
| Validación | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Comprobación no destructiva y recuperación de Pod |

Parte del contenido se practica en la unidad. Otra parte queda como referencia para cloud, gobierno de recursos, escalado, progressive delivery y operación avanzada.

## Mapa conceptual

La unidad conecta tres planos:

```text
Scheduling
  decide dónde puede arrancar un Pod

Resiliencia
  decide qué ocurre cuando Pods cambian, fallan o se recrean

Mantenimiento
  decide cómo reducir impacto durante interrupciones voluntarias
```

La disponibilidad observable aparece al final de una cadena:

```text
Pod creado
  -> scheduler asigna nodo
  -> kubelet arranca contenedor
  -> volumen se monta
  -> probes pasan
  -> EndpointSlice incluye el Pod
  -> Service e Ingress pueden enviar tráfico
```

Si una pieza falla, mirar solo el último síntoma puede confundir. Un 503 puede empezar en readiness, un rollout bloqueado puede empezar en scheduling, y una réplica adicional puede no aportar resiliencia si todo depende de un único nodo o de almacenamiento local.

## Conceptos y mecanismos

### Scheduler

El scheduler observa Pods `Pending` y elige un nodo. No ejecuta contenedores; esa tarea corresponde al kubelet del nodo elegido.

La decisión combina:

- recursos solicitados con `requests`;
- `nodeSelector`;
- node affinity;
- pod affinity y anti-affinity;
- taints y tolerations;
- volúmenes y restricciones de topología;
- políticas internas del scheduler;
- capacidad disponible.

El scheduler decide en dos fases. Primero **filtra**: descarta los nodos que no pueden alojar el Pod porque incumplen una condición obligatoria, como `requests` que no caben, un `nodeSelector` que no coincide, una regla `required...` o un taint sin toleration. Si tras filtrar no queda ningún nodo, el Pod permanece `Pending`. Después **puntúa**: entre los nodos que sobrevivieron al filtro, asigna una puntuación según las preferencias, como reglas `preferred...`, reparto de carga o affinity blanda, y elige el de mayor puntuación.

La diferencia entre las dos fases explica el comportamiento que practica esta unidad. Una condición `required...` o un `nodeSelector` actúan en el filtrado: si nadie las cumple, no hay nodo y el Pod no arranca. Una condición `preferred...`, como la anti-affinity de la solución, actúa en la puntuación: si no puede satisfacerse, el nodo pierde puntos pero no queda descartado, y el Pod se programa igual. Por eso la anti-affinity preferida no bloquea un clúster de un solo nodo.

Cuando un Pod queda `Pending`, los logs de la aplicación rara vez ayudan. El contenedor todavía no se ha ejecutado. La evidencia principal está en `kubectl describe pod` y en eventos de scheduling.

### Node labels y nodeSelector

Las labels de nodo son metadatos. Pueden describir sistema operativo, zona, tipo de máquina, capacidad especial, ownership o cualquier atributo que la plataforma decida exponer.

`nodeSelector` es un filtro estricto. En la Unidad 05 se usa:

```yaml
nodeSelector:
  kubernetes.io/os: linux
```

Es seguro para el laboratorio porque los nodos Kubernetes que ejecutan contenedores Linux deben cumplir esa condición. Un selector demasiado específico puede bloquear todos los Pods.

### Node affinity

Node affinity permite expresar reglas más ricas que `nodeSelector`.

Hay dos familias importantes:

| Tipo | Comportamiento |
|---|---|
| `requiredDuringSchedulingIgnoredDuringExecution` | Requisito estricto durante scheduling |
| `preferredDuringSchedulingIgnoredDuringExecution` | Preferencia ponderada durante scheduling |

La palabra `IgnoredDuringExecution` importa: si las labels cambian después de asignar el Pod, Kubernetes no expulsa automáticamente el Pod por dejar de cumplir esa regla.

La Unidad 05 usa preferencia, no requisito, para evitar que el laboratorio local de un nodo quede bloqueado.

### Pod anti-affinity

Pod anti-affinity permite intentar separar Pods entre dominios de topología, por ejemplo nodos, zonas o racks. En esta unidad se usa como preferencia con `topologyKey: kubernetes.io/hostname`.

En un clúster de varios nodos, esto intenta repartir réplicas de `platform-api`. En un clúster de un solo nodo, no hay dónde repartirlas. La preferencia no crea capacidad.

Anti-affinity obligatoria puede ser útil para workloads críticos, pero también puede impedir despliegues durante falta de capacidad, mantenimiento o entornos pequeños.

### Taints y tolerations

Un taint expresa rechazo desde el nodo. Una toleration expresa que el Pod acepta ese rechazo.

Esto no es lo mismo que seleccionar un nodo.

| Mecanismo | Dirección mental |
|---|---|
| Node affinity | El Pod busca o prefiere nodos |
| Taint | El nodo rechaza Pods |
| Toleration | El Pod puede entrar a pesar del rechazo |

Tolerar un taint no obliga al scheduler a elegir ese nodo. Solo elimina una barrera.

### Requests, limits y scheduling

El scheduler usa `requests`, no consumo real futuro, para decidir si un Pod cabe en un nodo. Por eso requests mal definidos afectan tanto a fiabilidad como a coste.

Requests demasiado bajos permiten sobrecargar nodos. Requests demasiado altos reducen densidad y pueden dejar Pods `Pending` aunque exista capacidad real no solicitada por otros workloads.

La Unidad 05 no cambia los resources de Unidad 02, pero los retoma porque scheduling sin requests es una conversación incompleta.

### Volúmenes y topología

El PVC `platform-api-data` viene de Unidad 04 y usa `microk8s-hostpath`. Ese almacenamiento está ligado al nodo local.

En cloud, el storage también puede imponer topología:

- un disco puede estar en una zona concreta;
- un volumen `ReadWriteOnce` puede limitar dónde arrancan réplicas;
- un filesystem compartido puede permitir otros patrones, con otros costes;
- un nodo puede no poder montar el volumen por permisos, zona o driver.

La resiliencia de un Pod con estado no depende solo del número de réplicas. Depende de si el dato puede estar disponible donde Kubernetes quiera arrancar el Pod.

### RollingUpdate

`RollingUpdate` reemplaza Pods de forma gradual. En esta unidad:

```yaml
maxUnavailable: 1
maxSurge: 1
minReadySeconds: 5
revisionHistoryLimit: 5
```

Con dos réplicas, `maxUnavailable: 1` permite que falte una durante el rollout. `maxSurge: 1` permite crear una extra temporalmente. `minReadySeconds` evita contar un Pod como disponible demasiado pronto.

Un rollout no garantiza que el cambio sea correcto. Solo controla la mecánica de sustitución. La calidad de la versión depende de probes, validaciones, observabilidad y señales de negocio.

### Rollback

Un rollback de Deployment vuelve a un template anterior registrado en el historial. Es útil si el problema está en el template desplegado.

No resuelve:

- datos corruptos;
- migraciones irreversibles;
- errores en ConfigMaps o Secrets externos si no forman parte del template;
- problemas del clúster;
- falta de capacidad;
- una imagen mutable que cambió sin cambiar el tag.

Por eso rollback técnico y recuperación operativa no son sinónimos.

### PodDisruptionBudget

Un `PodDisruptionBudget` limita interrupciones voluntarias. En esta unidad:

```yaml
minAvailable: 1
```

El PDB intenta impedir que operaciones voluntarias, como evictions durante mantenimiento, reduzcan la disponibilidad por debajo del presupuesto. Su nombre puede llevar a una expectativa excesiva: no mitiga caídas imprevistas del servicio por sí solo; limita desalojos voluntarios cuando Kubernetes usa la API de eviction y hay Pods disponibles suficientes.

No protege frente a:

- fallo inesperado de nodo;
- caída del proceso;
- `kubectl delete pod` directo;
- errores de la aplicación;
- pérdida del volumen;
- falta de capacidad para crear reemplazos.

El PDB es una pieza de mantenimiento responsable, no una garantía de alta disponibilidad.

### Alta disponibilidad real

Dos réplicas no equivalen automáticamente a alta disponibilidad. Para hablar de HA hay que revisar:

- número de nodos;
- distribución por zonas;
- dependencia de almacenamiento;
- requests y capacidad;
- probes correctas;
- Service y EndpointSlice;
- PDB;
- estrategia de rollout;
- observabilidad y alertas;
- procedimientos de mantenimiento;
- recuperación de datos.

El laboratorio local de MicroK8s permite aprender mecanismos, pero no demuestra HA multi-nodo.

## Criterios de decisión

### Cuándo usar constraints estrictos

Usa requisitos estrictos cuando ejecutar en el nodo equivocado sea peor que no ejecutar:

- hardware específico;
- sistema operativo obligatorio;
- cumplimiento normativo;
- aislamiento fuerte;
- dependencia de zona o almacenamiento;
- licencias o afinidad física.

Evita requisitos estrictos si solo estás expresando una preferencia. Un requisito imposible deja Pods `Pending`.

### Cuándo usar preferencias

Usa preferencias cuando quieras orientar al scheduler sin bloquear el despliegue:

- repartir réplicas si hay nodos suficientes;
- preferir familias de nodos;
- favorecer una zona;
- mejorar disponibilidad en entornos con capacidad variable.

La Unidad 05 usa anti-affinity preferida porque el laboratorio debe funcionar en un solo nodo y seguir explicando la intención profesional.

### Cómo diseñar un PDB

Un PDB debe partir de:

- número de réplicas;
- capacidad mínima necesaria;
- probes fiables;
- tiempo de arranque;
- estrategia de rollout;
- operaciones de mantenimiento esperadas;
- tolerancia real a indisponibilidad.

Con dos réplicas, `minAvailable: 1` es didáctico y razonable para mostrar el mecanismo. En producción, la decisión debe validarse con SLO, tráfico, capacidad y comportamiento de la aplicación.

### Cómo pensar mantenimiento

El mantenimiento responsable requiere saber qué se puede interrumpir y qué debe permanecer disponible. Antes de un `drain` real conviene revisar:

- PDBs;
- réplicas disponibles;
- PVCs y topología;
- capacidad en otros nodos;
- DaemonSets;
- workloads críticos;
- ventanas de cambio;
- plan de rollback;
- observabilidad durante la operación.

La unidad evita automatizar `drain` para no convertir una operación de plataforma en un ejercicio mecánico.

### Qué cambia en cloud

En AKS/EKS aparecen decisiones que MicroK8s local no demuestra:

- node pools;
- zonas de disponibilidad;
- cluster autoscaler;
- taints por pool;
- labels gestionadas por proveedor;
- discos por zona;
- mantenimiento gestionado;
- límites de pods por nodo;
- coste por sobredimensionamiento;
- políticas de actualización de nodos.

La Unidad 19 y la comparativa de Unidad 22 deberán separar estos supuestos de la experiencia local.

## Relación con el laboratorio

El laboratorio practica:

- `nodeSelector` seguro;
- node affinity preferida;
- pod anti-affinity preferida;
- `RollingUpdate`;
- rollback nativo de Deployment;
- PDB con `minAvailable: 1`;
- observación de Pods asignados a nodo;
- eliminación controlada de un Pod;
- validación de Service, EndpointSlice, Ingress y PVC.

El laboratorio menciona, pero no practica:

- alta disponibilidad real multi-nodo;
- `kubectl drain`;
- `kubectl cordon` y `kubectl uncordon`;
- taints aplicados a nodos;
- autoscaling;
- topology spread constraints;
- cluster autoscaler;
- chaos engineering;
- progressive delivery;
- mantenimiento productivo de node pools.

No deben endurecerse las reglas de affinity del laboratorio sin añadir nodos y sin documentar el riesgo. El objetivo es enseñar intención operativa sin bloquear MicroK8s local.

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Confundir réplicas con alta disponibilidad | Dos Pods en un nodo comparten un único punto de fallo |
| Usar anti-affinity obligatoria en un clúster pequeño | Puede dejar Pods `Pending` |
| Pensar que PDB protege ante fallos involuntarios | PDB se aplica a interrupciones voluntarias |
| Diagnosticar logs cuando el Pod está `Pending` | La aplicación todavía no se ejecutó |
| Tratar tolerations como nodeSelector | Tolerar no significa atraer |
| Ignorar PVC y topología | El almacenamiento puede limitar dónde arranca el Pod |
| Hacer rollback sin revisar qué cambió | Puede volver al template anterior sin arreglar datos, capacidad o configuración externa |
| Vender MicroK8s de un nodo como HA | El laboratorio demuestra mecanismos, no arquitectura productiva |

## Continuidad

La Unidad 06 empaquetará estas decisiones con Helm. El chart deberá hacer visibles y parametrizables las decisiones operativas sin ocultar su significado.

La Unidad 10 retomará promoción entre entornos. Progressive delivery deberá conectarse con señales operativas, no solo con cambiar tráfico.

La Unidad 12 y la Unidad 15 aportarán métricas, alertas, SLI/SLO y observabilidad integrada para decidir si un rollout o una operación de mantenimiento fue saludable.

La Unidad 16 retomará scheduling y recursos desde gobierno: ResourceQuota, LimitRange, namespaces, ownership, políticas y segregación de workloads por equipo.

La Unidad 18 conectará requests, limits, HPA, KEDA, capacidad, coste y topology spread constraints.

La Unidad 19 separará supuestos locales de MicroK8s frente a AKS/EKS, incluyendo node pools, zonas, storage, Ingress, identidad, coste y operación.

La Unidad 22 comparará mantenimiento y upgrades entre MicroK8s, AKS y EKS, incluyendo diferencias de node pools gestionados y ventanas de operación.

La Unidad 23 deberá tratar ciclo de vida del clúster, upgrades, deprecaciones, node pools, backup previo, rollback realista, runbooks y validación posterior.

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Kubernetes - Scheduling, Preemption and Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/) | Visión general de scheduling y desalojo | ¿Qué componentes participan antes de que un Pod arranque? |
| [Kubernetes - Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) | `nodeSelector`, node affinity y pod affinity | ¿Cuándo una regla bloquea y cuándo solo expresa preferencia? |
| [Kubernetes - Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) | Taints, tolerations y casos de uso | ¿Por qué tolerar un taint no fuerza la colocación? |
| [Kubernetes - Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Requests, limits y capacidad | ¿Cómo afectan los requests al scheduling y al coste? |
| [Kubernetes - Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | RollingUpdate, history y rollback | ¿Qué controla un Deployment durante un cambio? |
| [Kubernetes - Pod Disruption Budgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) | Interrupciones voluntarias y PDB | ¿Qué protege un PDB y qué no protege? |
| [Kubernetes - Safely Drain a Node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/) | Mantenimiento y evictions | ¿Qué deberías revisar antes de drenar un nodo? |
| [Kubernetes - Topology Spread Constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) | Distribución por dominios de topología | ¿Cuándo conviene expresar distribución de forma más explícita que anti-affinity? |
