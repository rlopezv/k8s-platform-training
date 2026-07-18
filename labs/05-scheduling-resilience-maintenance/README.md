# Laboratorio - Unidad 05

## Proposito

Este laboratorio evoluciona `platform-api` desde la salida validada de la Unidad 04 hacia una aplicacion con reglas explicitas de scheduling, estrategia de `RollingUpdate` y un `PodDisruptionBudget`.

La unidad incorpora:

- observacion de nodos, labels y eventos de scheduling;
- `nodeSelector` seguro para Linux;
- node affinity y pod anti-affinity preferidas para no bloquear MicroK8s local;
- `PodDisruptionBudget` con `minAvailable: 1`;
- estrategia de rollout declarada en el Deployment;
- revision de ReplicaSets, EndpointSlice, Service e Ingress durante cambios;
- recuperacion controlada tras eliminar un Pod gestionado por Deployment;
- diagnostico de constraints imposibles, PDB restrictivo y rollout bloqueado.

No usa Helm, Terraform, HPA, KEDA, observabilidad avanzada ni recursos cloud.

## Estructura

```text
labs/05-scheduling-resilience-maintenance/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── pdb.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Artefactos

| Ruta | Uso |
|---|---|
| `starter/` | Punto de partida heredado de Unidad 04. Todavia no declara PDB ni estrategia de scheduling/rollout de Unidad 05. |
| `solution/` | Estado final de la unidad y base prevista para Unidad 06. |
| `solution/pdb.yaml` | Presupuesto de interrupcion voluntaria para `platform-api`. |
| `validation/validate.sh` | Validacion no destructiva del estado esperado. Elimina un Pod de la aplicacion para comprobar recuperacion por Deployment. |

## Precondiciones

Ejecutar desde la raiz del repositorio dentro de Ubuntu WSL:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/04-persistence-state/validation/validate.sh
kubectl config current-context
kubectl get nodes --show-labels
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress,pvc
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
El contexto de kubectl apunta al MicroK8s local.
deployment/platform-api esta disponible.
persistentvolumeclaim/platform-api-data esta Bound.
service/platform-api sigue siendo ClusterIP.
ingress/platform-api conserva host platform-api.local.
Existe al menos un nodo Ready.
```

Si la Unidad 04 no esta aplicada:

```bash
microk8s enable ingress
microk8s enable hostpath-storage
kubectl apply -f labs/04-persistence-state/solution/
bash labs/04-persistence-state/validation/validate.sh
```

## Observacion inicial de scheduling

Ver los nodos y sus labels:

```bash
kubectl get nodes --show-labels
```

Ver en que nodo estan los Pods:

```bash
kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api -o wide
```

Revisar eventos recientes:

```bash
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

En MicroK8s local normalmente habra un solo nodo. Eso permite estudiar scheduling, pero no demuestra alta disponibilidad real.

## Despliegue

Aplicar la solucion en orden explicito:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/namespace.yaml
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/configmap.yaml
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/secret.yaml
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/pvc.yaml
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/pdb.yaml
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/deployment.yaml
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/service.yaml
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/ingress.yaml
```

Comprobar rollout y recursos:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress,pvc,pdb
kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api -o wide
```

Resultado esperado:

```text
deployment/platform-api esta disponible.
poddisruptionbudget/platform-api existe.
Los Pods estan asignados a un nodo.
El Service conserva tipo ClusterIP.
El Ingress conserva host platform-api.local.
El PVC sigue Bound.
```

## Lectura guiada de la solucion

Revisar la estrategia de rollout:

```bash
kubectl -n platform-training get deployment platform-api -o jsonpath='{.spec.strategy}{"\n"}'
kubectl -n platform-training rollout history deployment/platform-api
```

La solucion declara:

```text
strategy: RollingUpdate
maxUnavailable: 1
maxSurge: 1
revisionHistoryLimit: 5
minReadySeconds: 5
```

Revisar constraints de scheduling:

```bash
kubectl -n platform-training get deployment platform-api -o jsonpath='{.spec.template.spec.nodeSelector}{"\n"}'
kubectl -n platform-training get deployment platform-api -o jsonpath='{.spec.template.spec.affinity}{"\n"}'
```

El estado final usa constraints compatibles con un cluster local:

- `nodeSelector` exige nodos Linux;
- node affinity preferida favorece nodos con hostname;
- pod anti-affinity preferida intenta separar replicas por nodo cuando existan varios nodos, pero no bloquea un cluster de un solo nodo.

## PodDisruptionBudget

Comprobar el PDB:

```bash
kubectl -n platform-training get pdb platform-api
kubectl -n platform-training describe pdb platform-api
```

Con dos replicas y `minAvailable: 1`, Kubernetes puede permitir una interrupcion voluntaria compatible cuando hay suficientes Pods disponibles. El PDB no evita fallos espontaneos de proceso, nodo, red o almacenamiento.

No ejecutar `kubectl drain` como parte normal de este laboratorio. En un cluster local de un nodo puede bloquearse, afectar otros workloads o dejar la plataforma en un estado poco util para el curso.

## Simulacion controlada de fallo de Pod

Seleccionar un Pod listo:

```bash
POD="$(kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local -o jsonpath='{.items[0].metadata.name}')"
echo "$POD"
```

Eliminar solo ese Pod:

```bash
kubectl -n platform-training delete pod "$POD"
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api -o wide
```

Resultado esperado:

```text
El Deployment crea un Pod nuevo.
La aplicacion vuelve al estado disponible.
El PDB no convierte esta eliminacion en alta disponibilidad absoluta.
```

## Rollout y rollback controlados

El cambio declarativo normal es editar o reaplicar manifiestos. Para observar una revision sin cambiar imagen ni introducir herramientas nuevas, puedes anotar el Deployment:

```bash
kubectl -n platform-training annotate deployment/platform-api training.k8s-platform.io/rollout-demo="$(date -Iseconds)" --overwrite
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training rollout history deployment/platform-api
kubectl -n platform-training get rs
```

Para volver a la revision anterior:

```bash
kubectl -n platform-training rollout undo deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/
```

Reaplicar la solucion final deja el laboratorio alineado con los manifiestos versionados.

## Diagnostico de scheduling

Ejemplo seguro de fallo esperado, sin aplicarlo como estado final:

```bash
kubectl -n platform-training patch deployment platform-api --type merge -p '{"spec":{"template":{"spec":{"nodeSelector":{"training.k8s-platform.io/nonexistent-node":"true"}}}}}'
kubectl -n platform-training rollout status deployment/platform-api --timeout=30s
kubectl -n platform-training get pods -o wide
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Si aparecen Pods `Pending`, la recuperacion es reaplicar la solucion:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/deployment.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

No dejar constraints imposibles como estado final del laboratorio.

## Validacion automatizada

Ejecutar:

```bash
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
```

La validacion comprueba:

- disponibilidad de `kubectl`;
- nodo `Ready`;
- rollout del Deployment;
- replicas, estrategia `RollingUpdate`, `maxUnavailable`, `maxSurge` y `nodeSelector`;
- anti-affinity preferida;
- Pods asignados a nodos;
- PDB `platform-api`;
- PVC `platform-api-data` en estado `Bound`;
- Service `ClusterIP`;
- EndpointSlice con endpoints;
- Ingress heredado;
- HTTP local por Ingress;
- recreacion controlada de un Pod;
- historial de rollout.

Puede parametrizarse:

```bash
INGRESS_URL=http://<direccion-del-nodo>/ bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
```

## Recuperacion

Si el laboratorio queda inconsistente:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/
kubectl -n platform-training rollout status deployment/platform-api
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
```

Si el problema viene de un experimento con selector imposible, taint o label de nodo, revertir primero ese cambio de nodo o Deployment y despues reaplicar la solucion.

No borrar `platform-api-data` como limpieza normal. No ejecutar reset de MicroK8s para cerrar esta unidad.

## Limpieza opcional

Para retirar solo el PDB de Unidad 05:

```bash
kubectl -n platform-training delete pdb platform-api
```

Para restaurarlo:

```bash
kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/pdb.yaml
```

La solucion final que debe quedar para Unidad 06 es `labs/05-scheduling-resilience-maintenance/solution/`.
