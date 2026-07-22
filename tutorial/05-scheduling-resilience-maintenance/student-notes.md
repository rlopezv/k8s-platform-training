# Student notes - Unidad 05

## Proposito

Estas notas explican como Kubernetes decide donde ejecutar Pods y como una aplicacion se comporta durante cambios, fallos controlados e interrupciones voluntarias. La unidad parte de `platform-api` ya configurada, expuesta y con persistencia local de laboratorio.

Para una capa de referencia más amplia, con criterios profesionales sobre scheduling, PDB, rollouts, mantenimiento, alta disponibilidad y límites de MicroK8s local, consulta `tutorial/05-scheduling-resilience-maintenance/student-reference.md`.

La idea central es:

```text
Kubernetes puede recrear Pods.
Pero no puede ignorar capacidad, nodos, politicas, probes ni almacenamiento.
La resiliencia depende de todas esas restricciones a la vez.
```

## Que se va a cubrir

| Bloque | Que aporta | Nivel en esta unidad |
|---|---|---|
| Scheduler | Decision de ubicacion de Pods | Conceptual y observado |
| Node labels | Datos usados para seleccionar nodos | Practico |
| `nodeSelector` | Restriccion simple de ubicacion | Practico |
| Node affinity | Preferencias o requisitos mas expresivos | Conceptual/practico ligero |
| Pod anti-affinity | Intentar separar replicas | Practico como preferencia |
| Taints y tolerations | Rechazo desde el nodo y permiso desde el Pod | Conceptual |
| Requests | Capacidad necesaria para planificar | Retomado |
| PVC local | Restriccion de ubicacion por datos | Retomado |
| RollingUpdate | Cambio progresivo de Pods | Practico |
| PodDisruptionBudget | Limite ante interrupciones voluntarias | Practico |
| Rollback | Vuelta a una revision anterior del Deployment | Practico |

No se cubren alta disponibilidad real multi-nodo, autoscaling, KEDA, blue/green, canary, chaos engineering, mantenimiento productivo de nodos, AKS ni EKS.

## Que representa cada componente

### Scheduling

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| Scheduler | Decisor de ubicacion de Pods pendientes | Elige nodos candidatos segun recursos y restricciones | No ejecuta los contenedores |
| Node | Maquina o instancia donde pueden ejecutarse Pods | Aporta CPU, memoria, red y almacenamiento local | No es intercambiable si contiene datos locales relevantes |
| Node label | Metadato del nodo | Permite seleccionar o preferir nodos | No prueba capacidad ni salud por si solo |
| `nodeSelector` | Filtro estricto basado en labels | Fuerza que un Pod solo pueda ir a nodos con ciertas labels | No expresa preferencias ni alternativas |
| Node affinity | Reglas de ubicacion mas expresivas | Permite requisitos y preferencias | No mueve Pods ya arrancados en esta unidad |
| Pod anti-affinity | Regla para separar Pods entre dominios | Reduce concentracion de replicas | No crea nodos donde no existen |
| Taint | Rechazo declarado desde un nodo | Evita que cualquier Pod entre salvo tolerancia | No atrae Pods |
| Toleration | Permiso del Pod para aceptar un taint | Permite entrar a nodos que rechazan por defecto | No obliga al scheduler a elegir ese nodo |

### Resiliencia y mantenimiento

| Componente | Que representa | Que problema resuelve | Que no es |
|---|---|---|---|
| Replica | Copia deseada de un Pod | Permite reemplazo y reparto potencial | No garantiza alta disponibilidad si todas caen en el mismo nodo |
| Readiness | Elegibilidad para trafico | Evita enviar peticiones a Pods no listos | No evita que el Pod exista |
| RollingUpdate | Estrategia de reemplazo gradual | Controla cuantos Pods nuevos y viejos conviven | No arregla una configuracion rota |
| `maxUnavailable` | Cuantos Pods pueden faltar durante rollout | Limita perdida temporal de capacidad | No protege ante caidas involuntarias |
| `maxSurge` | Cuantos Pods extra pueden crearse durante rollout | Permite avanzar sin bajar tanto la capacidad | No crea recursos si el cluster no tiene capacidad |
| `minReadySeconds` | Tiempo minimo que un Pod debe estar listo | Evita aceptar disponibilidad demasiado pronto | No prueba la aplicacion en profundidad |
| PodDisruptionBudget | Politica ante interrupciones voluntarias | Limita cuantos Pods pueden desalojarse por mantenimiento | No evita fallos de nodo ni caidas inesperadas |
| Rollback | Cambio del Deployment a una revision previa | Recupera un template anterior | No modifica el repositorio ni arregla causas externas |

Frase clave:

```text
Scheduling decide donde puede vivir un Pod.
Resiliencia decide que ocurre cuando cambia o se interrumpe.
```

## Que vas a construir

La unidad conserva configuracion, Secret ficticio, probes, resources, Service, Ingress y PVC. Añade restricciones y politicas de operacion.

| Elemento | Valor o cambio |
|---|---|
| Replicas | `2` |
| Estrategia | `RollingUpdate` |
| `maxUnavailable` | `1` |
| `maxSurge` | `1` |
| `minReadySeconds` | `5` |
| `revisionHistoryLimit` | `5` |
| `nodeSelector` | `kubernetes.io/os: linux` |
| Node affinity | Preferida sobre nodos con `kubernetes.io/hostname` |
| Pod anti-affinity | Preferida para separar replicas por hostname |
| PDB | `poddisruptionbudget/platform-api` |
| `minAvailable` del PDB | `1` |

En un cluster local de un solo nodo, algunas decisiones solo pueden observarse parcialmente. Eso es parte del aprendizaje: declarar anti-affinity no crea mas nodos.

## Como se relacionan

Hay dos preguntas distintas:

```text
1. Donde puede arrancar este Pod?
2. Que ocurre mientras cambio o mantengo la aplicacion?
```

La primera la responde el scheduler:

```text
Pod pendiente
  + requests
  + nodeSelector / affinity
  + taints y tolerations
  + volumenes
  -> nodo elegido o Pod Pending
```

La segunda la responden Deployment, probes, Service, EndpointSlice y PDB:

```text
Deployment RollingUpdate
  crea Pods nuevos
  espera readiness
  mantiene endpoints utiles
  respeta estrategia

PDB
  limita interrupciones voluntarias
```

No mezcles las dos preguntas. Un Pod `Pending` es un problema de ubicacion. Un rollout que no avanza suele ser un problema de readiness, capacidad o template nuevo.

## Que ocurre cuando aplicas los manifiestos

Flujo mental:

```text
1. El Deployment actualizado cambia su estrategia y su template.
2. Kubernetes inicia un rollout si el template cambia.
3. El scheduler evalua los Pods nuevos.
4. Node selector, affinity, requests y PVC condicionan nodos candidatos.
5. Los Pods arrancan y deben pasar probes.
6. Readiness decide si entran en endpoints.
7. RollingUpdate controla cuantos Pods pueden faltar o sobrar.
8. El PDB queda disponible para limitar interrupciones voluntarias.
```

Con un solo nodo, el laboratorio puede demostrar recuperacion de Pods y comportamiento de rollout, pero no alta disponibilidad real ante perdida del nodo.

## Como comprobar que funciona

Comprueba rollout y Pods:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get pods -o wide
```

Comprueba estrategia:

```bash
kubectl -n platform-training describe deployment platform-api
```

Comprueba PDB:

```bash
kubectl -n platform-training get pdb platform-api
kubectl -n platform-training describe pdb platform-api
```

Comprueba endpoints:

```bash
kubectl -n platform-training get endpoints platform-api
```

La validacion automatizada de la unidad es:

```bash
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
```

## Como diagnosticar los 4 fallos tipicos

### 1. Un Pod queda `Pending`

Comprueba:

```bash
kubectl -n platform-training describe pod <pod>
kubectl get nodes --show-labels
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Idea clave: mira scheduling, no logs. Si el Pod no arranco, la aplicacion aun no ha tenido oportunidad de fallar.

### 2. El rollout no avanza

Comprueba:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training describe deployment platform-api
kubectl -n platform-training get pods
```

Idea clave: el Deployment espera Pods nuevos disponibles. Si readiness falla o el cluster no puede crear Pods nuevos, el rollout se bloquea.

### 3. Las replicas no se distribuyen

Comprueba:

```bash
kubectl -n platform-training get pods -o wide
kubectl get nodes
```

Idea clave: con un solo nodo no hay distribucion posible. La anti-affinity preferida expresa una intencion, no crea topologia.

### 4. El PDB no evita un fallo

Comprueba:

```bash
kubectl -n platform-training describe pdb platform-api
kubectl -n platform-training get pods
```

Idea clave: un PDB protege frente a interrupciones voluntarias, como un eviction durante mantenimiento. No evita que un nodo falle ni que un contenedor muera.

## Que debes recordar para la Unidad 06

La Unidad 06 introducira Helm. Antes de empaquetar manifiestos, necesitas tener claro que ya contienen decisiones operativas.

| Idea | Por que importa despues |
|---|---|
| Los manifiestos ya expresan politica | Helm no debe ocultar que significan strategy, affinity o PDB |
| Scheduling y resiliencia dependen del entorno | Los valores empaquetados deben ser parametrizables con cuidado |
| El laboratorio local no demuestra HA real | No se debe vender una plantilla local como arquitectura productiva |

Resumen:

```text
Helm empaquetara decisiones.
No debe convertirlas en magia.
Primero hay que entender que representa cada campo.
```

## Fuentes de referencia

| Fuente | Que leer | Para que sirve |
|---|---|---|
| [Kubernetes - Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) | nodeSelector, affinity y anti-affinity | Entender restricciones de ubicacion |
| [Kubernetes - Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) | Rechazo y tolerancia | Separar permiso de atraccion |
| [Kubernetes - Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) | Requests y limits | Relacionar recursos con scheduling |
| [Kubernetes - Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) | RollingUpdate y rollback | Entender cambios controlados |
| [Kubernetes - Pod Disruption Budgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/) | Interrupciones voluntarias y PDB | Entender que protege un PDB |
| [Kubernetes - Safely Drain a Node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/) | Drain y mantenimiento | Relacionar mantenimiento con evictions |
