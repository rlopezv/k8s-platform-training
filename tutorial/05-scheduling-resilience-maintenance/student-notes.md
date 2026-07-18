# Student notes - Unidad 05

## Proposito de estas notas

Estas notas explican como pensar sobre scheduling, resiliencia y mantenimiento antes de editar YAML.

La idea mas importante: Kubernetes puede recrear Pods, pero no puede eliminar las restricciones fisicas y operativas del cluster.

## La palabra "disponible" necesita contexto

En Kubernetes se puede hablar de disponibilidad en varias capas:

| Capa | Pregunta |
|---|---|
| Deployment | Hay replicas disponibles segun el controlador? |
| Pod | El contenedor esta arrancado y Ready? |
| Service | Hay EndpointSlices con endpoints listos? |
| Ingress | Llega trafico HTTP al Service? |
| Nodo | Existe capacidad real para ejecutar el Pod? |
| Almacenamiento | El volumen puede montarse donde hace falta? |

Decir "hay dos replicas" solo responde una parte. Si las dos estan en el mismo nodo, el fallo de ese nodo afecta a las dos. Si una replica no pasa readiness, no debe entrar en endpoints. Si el PVC depende de almacenamiento local, no todos los nodos son equivalentes.

## Scheduler

El scheduler observa Pods que todavia no tienen nodo asignado y decide donde colocarlos.

Un Pod recien creado puede estar `Pending` por motivos distintos:

- todavia no fue asignado;
- no hay nodo con labels compatibles;
- faltan CPU o memoria segun requests;
- hay taints que el Pod no tolera;
- hay restricciones de afinidad imposibles;
- el volumen requerido no puede satisfacerse.

El scheduler no arranca contenedores. Solo escribe una decision de asignacion. Despues el kubelet del nodo intenta materializar el Pod.

Modelo simple:

```text
Pod sin nodeName
  -> scheduler filtra nodos candidatos
  -> scheduler puntua preferencias
  -> Pod queda asignado a un nodo
  -> kubelet arranca contenedores
```

La evidencia basica esta en:

```bash
kubectl -n platform-training get pods -o wide
kubectl -n platform-training describe pod <pod>
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

## Node labels

Los nodos tienen labels. Algunas describen propiedades estandar, como sistema operativo, arquitectura o hostname. Otras pueden ser propias de la plataforma.

Ejemplo:

```bash
kubectl get nodes --show-labels
```

Un label usado en scheduling se convierte en contrato. Si escribes un `nodeSelector` para una label que no existe, el Pod puede quedar `Pending`.

## `nodeSelector`

`nodeSelector` es una condicion estricta y simple:

```text
Este Pod solo puede ejecutarse en nodos que tengan estas labels con estos valores.
```

En la solucion:

```yaml
nodeSelector:
  kubernetes.io/os: linux
```

Es seguro para el laboratorio porque los nodos Kubernetes que ejecutan contenedores Linux declaran esa label. Sigue siendo una restriccion: si ningun nodo la cumple, el Pod no se programa.

## Node affinity

Node affinity permite expresar reglas mas ricas que `nodeSelector`.

Puede funcionar como:

- requisito obligatorio: `requiredDuringSchedulingIgnoredDuringExecution`;
- preferencia: `preferredDuringSchedulingIgnoredDuringExecution`.

La parte "IgnoredDuringExecution" significa que la regla se evalua para programar el Pod, pero si las labels cambian despues, Kubernetes no expulsa automaticamente el Pod ya ejecutandose solo por esa diferencia.

La solucion usa preferencia, no requisito, para favorecer nodos con hostname sin bloquear el laboratorio.

## Pod anti-affinity

Pod anti-affinity expresa una preferencia o requisito sobre la relacion entre Pods.

La pregunta es:

```text
Quiero evitar que replicas equivalentes caigan en el mismo dominio de fallo?
```

El dominio de fallo puede ser un nodo, una zona o una region, segun `topologyKey`.

En la solucion:

```text
topologyKey: kubernetes.io/hostname
```

Eso significa "si puedes, separa replicas por nodo". Es preferida porque MicroK8s local suele tener un solo nodo. Si fuera obligatoria, una de las dos replicas podria quedar `Pending`.

## Taints y tolerations

Los taints viven en los nodos y funcionan como rechazo:

```text
Este nodo no acepta ciertos Pods salvo que los toleren.
```

Las tolerations viven en los Pods y dicen:

```text
Este Pod acepta ese rechazo.
```

Un error frecuente es creer que una toleration selecciona un nodo. No lo hace. Solo permite que el Pod pueda entrar en un nodo que de otro modo lo rechazaria. Para atraer Pods hacia nodos concretos se usan labels, affinity u otros mecanismos.

En esta unidad no se deja un taint como estado final porque modificar nodos afecta a otros workloads del cluster local. El laboratorio lo trata como demostracion conceptual y manual.

## Requests, capacidad y scheduling

Los `requests` de CPU y memoria son promesas de capacidad minima. El scheduler los usa para decidir si un nodo puede alojar el Pod.

Si pides demasiado, el Pod puede quedar `Pending` aunque la imagen sea correcta y el YAML tenga sintaxis valida.

En `platform-api` los requests siguen siendo conservadores:

```text
cpu: 25m
memory: 64Mi
```

Esto reduce el riesgo de bloquear el laboratorio local por recursos.

## PVC local y colocacion

La Unidad 04 introdujo `platform-api-data` con `microk8s-hostpath`.

Esto tiene una consecuencia importante: el dato esta asociado al almacenamiento local del nodo. En un cluster de un nodo no se ve como problema porque todos los Pods acaban en el mismo sitio. En un cluster real, el tipo de volumen, access mode, provisionador y zona pueden condicionar donde puede arrancar un Pod.

Por eso la unidad evita prometer resiliencia multi-nodo. Primero se aprende el modelo; mas adelante se estudiaran plataformas gestionadas y storage cloud.

## Fallo involuntario e interrupcion voluntaria

No todos los eventos son iguales.

| Tipo | Ejemplo | Que significa |
|---|---|---|
| Fallo involuntario | Proceso muere, Pod desaparece, nodo falla | Algo se rompio o desaparecio |
| Interrupcion voluntaria | Eviction por mantenimiento, drain, actualizacion controlada | La plataforma intenta cambiar algo de forma gobernada |

Un Deployment reacciona a muchos fallos creando Pods nuevos. Eso no garantiza que el usuario no note impacto.

Un PDB solo interviene en interrupciones voluntarias que pasan por la API de eviction. No evita que un nodo se apague ni que un proceso falle.

## PodDisruptionBudget

Un `PodDisruptionBudget` declara cuanta disponibilidad minima debe respetarse durante interrupciones voluntarias.

En la solucion:

```yaml
minAvailable: 1
```

Con dos replicas, esto comunica:

```text
Durante una interrupcion voluntaria, intenta mantener al menos una replica disponible.
```

No significa:

- "nunca habra downtime";
- "los nodos no fallaran";
- "el almacenamiento esta replicado";
- "puedo drenar un cluster de un nodo sin consecuencias";
- "el PDB arregla probes o readiness".

## Deployment, ReplicaSet y rollout

Un Deployment controla ReplicaSets. En una actualizacion crea un ReplicaSet nuevo y reduce el anterior gradualmente.

La estrategia `RollingUpdate` decide cuanta capacidad puede faltar o sobrar durante el cambio:

```text
maxUnavailable: 1
maxSurge: 1
```

Con dos replicas:

- puede haber como maximo una replica no disponible durante el rollout;
- puede crearse una replica extra temporal para facilitar el reemplazo;
- el Service solo deberia enviar trafico a Pods Ready.

`revisionHistoryLimit: 5` conserva historial suficiente para rollback sin acumular indefinidamente ReplicaSets antiguos.

`minReadySeconds: 5` evita declarar disponible un Pod inmediatamente despues de readiness.

## Readiness, EndpointSlice, Service e Ingress

La ruta del trafico depende de varias piezas:

```text
Ingress
  -> Service
    -> EndpointSlice
      -> Pods Ready
```

Si un Pod existe pero no esta Ready, no debe aparecer como endpoint util. Por eso durante un rollout no basta con mirar `kubectl get pods`; tambien conviene observar:

```bash
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
kubectl -n platform-training describe deployment platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

## Rollback

Rollback no es magia. Kubernetes vuelve a una revision anterior del Deployment.

Comandos utiles:

```bash
kubectl -n platform-training rollout history deployment/platform-api
kubectl -n platform-training rollout undo deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

Despues de un rollback en laboratorio, reaplicar la solucion versionada ayuda a volver al estado esperado por el repo:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/
```

## Lectura de los manifiestos de Unidad 05

La solucion final esta en:

```text
labs/05-scheduling-resilience-maintenance/solution/
```

Cambios clave:

| Archivo | Que observar |
|---|---|
| `deployment.yaml` | `strategy`, `revisionHistoryLimit`, `minReadySeconds`, `nodeSelector`, affinity y anti-affinity preferida |
| `pdb.yaml` | `minAvailable: 1` y selector de `platform-api` |
| `configmap.yaml` | Texto visible de Unidad 05 sin informacion sensible |
| `pvc.yaml` | PVC heredado con `microk8s-hostpath` |
| `service.yaml` | `ClusterIP` y selector conservados |
| `ingress.yaml` | Host `platform-api.local` conservado |

## Diagnostico por capas

Cuando algo falla, usar este orden:

| Capa | Pregunta |
|---|---|
| Contexto | Estoy en el cluster correcto? |
| Nodo | Hay nodos `Ready`? |
| Labels | El selector o affinity coincide con algun nodo? |
| Taints | El nodo rechaza este Pod? |
| Recursos | Requests caben en algun nodo? |
| PVC | El volumen esta `Bound` y puede montarse? |
| Pod | Esta asignado, arrancado y Ready? |
| Deployment | El rollout progresa? |
| EndpointSlice | Hay endpoints listos? |
| Service/Ingress | El trafico llega al backend correcto? |

Este orden evita confundir un fallo de scheduling con un fallo HTTP.

## Errores frecuentes

| Error | Correccion |
|---|---|
| "Dos replicas son alta disponibilidad" | Solo si estan distribuidas y la plataforma soporta el fallo esperado. |
| "Anti-affinity obligatoria mejora siempre" | Puede dejar replicas `Pending` si no hay nodos suficientes. |
| "Una toleration elige nodo" | Solo permite tolerar un rechazo; no atrae el Pod. |
| "PDB evita caidas" | Solo limita interrupciones voluntarias compatibles. |
| "Running equivale a recibir trafico" | El Service usa readiness para endpoints. |
| "Rollback arregla cualquier cosa" | Vuelve a una revision; no corrige PVC, nodos ni capacidad. |
| "hostpath local demuestra resiliencia cloud" | Solo demuestra persistencia local de laboratorio. |

## Preguntas de comprobacion

- Que diferencia hay entre `nodeSelector` y node affinity?
- Por que la anti-affinity final es preferida y no obligatoria?
- Que protege exactamente un PDB?
- Que ocurre si todas las replicas dependen de un unico nodo?
- Por que un Pod puede estar `Running` y aun asi no recibir trafico?
- Que comandos usarias para diagnosticar un rollout bloqueado?
- Que aporta `maxUnavailable: 1` cuando hay dos replicas?
- Por que el PVC local limita las conclusiones de resiliencia?

## Continuidad

La Unidad 06 podra introducir Helm con una base mas madura:

```text
Namespace
ConfigMap
Secret ficticio
PVC
Deployment con strategy y scheduling seguro
PDB
Service
Ingress
validacion no destructiva
```

Antes de empaquetar, el alumno ya habra visto que los manifiestos no solo "crean recursos": tambien expresan decisiones operativas.
