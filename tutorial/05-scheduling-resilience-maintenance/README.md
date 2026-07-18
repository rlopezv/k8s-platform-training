# Unidad 05 - Scheduling, resiliencia y mantenimiento

## Guia pedagogica de la unidad

Esta unidad trata sobre que ocurre cuando Kubernetes tiene que decidir donde ejecutar los Pods, como mantener una aplicacion disponible durante cambios y que limites reales tiene un laboratorio local.

Hasta la Unidad 04 `platform-api` podia desplegarse, configurarse, exponerse por Ingress y conservar un dato de laboratorio en un PVC. Ahora la pregunta cambia: que pasa cuando hay que actualizar la aplicacion, recrear Pods, respetar capacidad del cluster o preparar una interrupcion voluntaria?

La Unidad 05 cubre:

- como el scheduler convierte un Pod pendiente en un Pod asignado a un nodo;
- por que dos replicas no garantizan alta disponibilidad si todo ocurre en un solo nodo;
- como usar constraints seguros de scheduling sin romper MicroK8s local;
- que diferencia hay entre fallo involuntario e interrupcion voluntaria;
- que protege y que no protege un `PodDisruptionBudget`;
- como un Deployment realiza rolling updates y rollbacks;
- como observar Service, EndpointSlice, probes e Ingress durante cambios;
- como diagnosticar Pods `Pending` y rollouts bloqueados;
- por que el PVC local condiciona la resiliencia que puede demostrarse.

Para estudiar el modelo mental completo, usa `tutorial/05-scheduling-resilience-maintenance/student-notes.md`.

## Pregunta central

La pregunta de la unidad es:

```text
Que condiciones deben cumplirse para que platform-api siga disponible mientras Kubernetes coloca, actualiza o reemplaza Pods?
```

Si el alumno puede responderla, dejara de confundir replicas con disponibilidad garantizada, PDB con proteccion absoluta o affinity con una receta universal.

## Problema real

Kubernetes no ejecuta Pods "en el cluster" de forma abstracta. Cada Pod acaba en un nodo concreto. Ese nodo tiene labels, capacidad, taints, volumenes disponibles y fallos posibles.

Ademas, una aplicacion no se mantiene disponible solo porque exista un Deployment. Durante un rollout pueden coexistir ReplicaSets antiguos y nuevos. Durante una recreacion, los Pods deben pasar probes antes de entrar en los EndpointSlices del Service. Durante mantenimiento, Kubernetes puede necesitar desalojar Pods, pero no todos los desalojos son seguros.

La unidad une tres ideas que suelen estudiarse por separado:

- colocacion: donde puede arrancar un Pod;
- resiliencia: que ocurre cuando se reemplaza o falla una instancia;
- mantenimiento: como reducir impacto durante cambios voluntarios.

## Objetivos

Al finalizar la unidad podras:

- explicar como el scheduler filtra y prioriza nodos candidatos;
- observar labels de nodo, `nodeName`, eventos de scheduling y Pods `Pending`;
- comparar `nodeSelector`, node affinity, pod anti-affinity, taints y tolerations;
- justificar por que la solucion final usa anti-affinity preferida y no obligatoria;
- aplicar un `PodDisruptionBudget` coherente con dos replicas;
- ejecutar un rollout y un rollback de `platform-api`;
- validar que el Deployment recupera un Pod eliminado de forma controlada;
- relacionar probes, EndpointSlice, Service e Ingress con disponibilidad observable;
- explicar los limites de resiliencia de MicroK8s local y `hostpath-storage`;
- preparar los manifiestos para empaquetado Helm en la Unidad 06.

## Conocimientos previos

Debes venir de las Unidades 00 a 04. En particular:

- sabes aplicar manifiestos con `kubectl apply`;
- has visto Deployment, ReplicaSet, Pod, Service, ConfigMap, Secret, Ingress y PVC;
- entiendes que los Pods son reemplazables;
- sabes que `platform-api` tiene dos replicas;
- has usado probes, requests y limits;
- has validado EndpointSlice como evidencia de Pods listos detras del Service;
- has probado HTTP por Ingress local;
- has montado `platform-api-data` en `/usr/share/nginx/html/persistent`;
- has usado `kubectl get`, `describe`, `logs`, `exec`, `delete pod` y `rollout status`.

## Relacion con la Unidad 04

La Unidad 04 introdujo persistencia mediante:

```text
pvc/platform-api-data
mount /usr/share/nginx/html/persistent
StorageClass microk8s-hostpath
```

Esto cambia el analisis de resiliencia. Un Pod ya no es solo una instancia stateless: ahora monta almacenamiento local de laboratorio. En un cluster de un nodo funciona para aprender, pero no permite prometer disponibilidad multi-nodo ni recuperacion ante perdida del nodo.

La base reutilizada es:

```text
labs/04-persistence-state/solution/
```

La salida de esta unidad queda en:

```text
labs/05-scheduling-resilience-maintenance/solution/
```

## Estado inicial

La unidad parte de:

- namespace `platform-training`;
- Deployment `platform-api` con dos replicas;
- imagen `nginxinc/nginx-unprivileged:1.27.4-alpine`;
- ConfigMap `platform-api-config`;
- Secret ficticio `platform-api-secret`;
- probes y requests/limits;
- Service `platform-api` de tipo `ClusterIP`;
- Ingress `platform-api` para host `platform-api.local`;
- PVC `platform-api-data` montado en `/usr/share/nginx/html/persistent`;
- MicroK8s local con `dns`, `ingress` y `hostpath-storage`.

No se asume que el cluster este desplegado si no se ejecuta la validacion real.

## Mapa de aprendizaje

| Concepto | Responsabilidad | Pregunta de diagnostico |
|---|---|---|
| Scheduler | Asigna Pods pendientes a nodos | Por que este Pod fue o no fue asignado? |
| Node labels | Describen propiedades del nodo | Que labels estoy usando como contrato? |
| `nodeSelector` | Exige labels concretas | Existe algun nodo que cumpla el selector? |
| Node affinity | Expresa reglas mas ricas sobre nodos | Es requisito o preferencia? |
| Pod anti-affinity | Intenta separar Pods entre dominios | Hay suficientes nodos para cumplirla? |
| Taints/tolerations | Rechazan Pods salvo tolerancia | Estoy seleccionando nodo o aceptando una restriccion? |
| PDB | Limita interrupciones voluntarias | Cuantos Pods deben permanecer disponibles? |
| RollingUpdate | Sustituye Pods gradualmente | Cuantos Pods pueden caer o crearse durante el cambio? |
| EndpointSlice | Lista backends listos del Service | El trafico tiene Pods Ready detras? |
| PVC local | Ata datos al almacenamiento del nodo | Que pasa si el nodo no esta disponible? |

## Modelo mental

Un Deployment no "mueve" Pods existentes como si fueran procesos migrables. Si necesita recuperar o actualizar, crea Pods nuevos y elimina Pods antiguos.

Cada Pod nuevo atraviesa un camino:

```text
Deployment
  -> ReplicaSet
    -> Pod Pending
      -> scheduler elige nodo
        -> kubelet arranca contenedor
          -> probes declaran salud
            -> EndpointSlice lo incluye
              -> Service e Ingress pueden enviar trafico
```

La disponibilidad observable aparece al final de ese camino. Si el Pod esta `Running` pero no `Ready`, no debe recibir trafico normal del Service. Si los constraints de scheduling son imposibles, el Pod ni siquiera llega al kubelet. Si el PVC no puede montarse, el contenedor no arranca correctamente.

## Diseno del laboratorio

La solucion final conserva `platform-api` y anade:

- `pdb.yaml` con `minAvailable: 1`;
- `strategy: RollingUpdate`;
- `maxUnavailable: 1`;
- `maxSurge: 1`;
- `revisionHistoryLimit: 5`;
- `minReadySeconds: 5`;
- `nodeSelector` para nodos Linux;
- affinity preferida de nodo;
- pod anti-affinity preferida por `kubernetes.io/hostname`.

La anti-affinity es preferida, no obligatoria, porque el laboratorio local puede tener un solo nodo. En un cluster multi-nodo intentaria repartir replicas; en un nodo unico no bloquea el despliegue.

## Como usar los materiales

Lee primero `tutorial/05-scheduling-resilience-maintenance/student-notes.md` si no dominas scheduler, PDB o rollout. Despues ejecuta el laboratorio desde `labs/05-scheduling-resilience-maintenance/README.md`.

El README del laboratorio contiene comandos completos, recuperacion y validacion. Este README mantiene el mapa conceptual de la unidad.

## Validaciones

La unidad incluye validaciones estaticas y funcionales:

```bash
bash -n labs/05-scheduling-resilience-maintenance/validation/validate.sh
kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
```

La validacion funcional elimina un Pod de `platform-api` para comprobar recuperacion por Deployment. No ejecuta `kubectl drain`, no borra PVC y no modifica labels ni taints de nodo.

## Errores de razonamiento frecuentes

- Creer que dos replicas son alta disponibilidad en un cluster de un nodo.
- Usar anti-affinity obligatoria sin suficientes nodos.
- Pensar que tolerar un taint equivale a forzar colocacion.
- Presentar un PDB como proteccion ante todos los fallos.
- Diagnosticar Ingress antes de revisar Pods Ready y EndpointSlices.
- Ignorar que un PVC local puede limitar donde puede arrancar una replica.
- Hacer rollback sin comprobar que revision queda activa.
- Ejecutar `drain` como si fuera una limpieza inocua.

## Recuperacion

Si el laboratorio queda inconsistente:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/
kubectl -n platform-training rollout status deployment/platform-api
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
```

Si el problema procede de un experimento con selector imposible:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/deployment.yaml
```

No borrar el PVC como limpieza normal. No usar reset de MicroK8s para cerrar la unidad.

## Resultado final

Al cierre de la unidad, `platform-api` conserva configuracion, Secret ficticio, probes, resources, Service, Ingress y PVC heredados. Ademas, declara scheduling seguro, estrategia de rollout y PDB.

La Unidad 06 podra empaquetar con Helm un conjunto de manifiestos mas estable, con decisiones de disponibilidad y mantenimiento ya visibles.

## Lectura guiada

- Kubernetes Scheduling, Preemption and Eviction: https://kubernetes.io/docs/concepts/scheduling-eviction/
- Kubernetes: Assign Pods to Nodes: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
- Kubernetes: Node affinity: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity
- Kubernetes: Inter-pod affinity and anti-affinity: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity
- Kubernetes: Taints and Tolerations: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
- Kubernetes: Pod Disruption Budgets: https://kubernetes.io/docs/concepts/workloads/pods/disruptions/
- Kubernetes: Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Kubernetes: Rolling back a Deployment: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment
