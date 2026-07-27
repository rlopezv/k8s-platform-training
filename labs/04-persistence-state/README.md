# Laboratorio - Unidad 04

## Proposito

Este laboratorio evoluciona `platform-api` desde el estado final de la Unidad 03 hacia una aplicacion con almacenamiento persistente de laboratorio.

La unidad incorpora:

- inspeccion de `StorageClass`;
- habilitacion del addon local `hostpath-storage` de MicroK8s cuando sea necesario;
- `PersistentVolumeClaim` para `platform-api`;
- montaje del PVC en `/usr/share/nginx/html/persistent`;
- escritura y lectura de un dato no sensible;
- recreacion controlada de Pods para validar persistencia;
- copia y restauracion basica de datos de laboratorio;
- diagnostico de PVC, PV, mounts, eventos, Service e Ingress.

Helm y Terraform siguen disponibles como herramientas base, pero no gestionan ningun recurso de este laboratorio.

## Estructura

```text
labs/04-persistence-state/
├── README.md
├── statefulset-demo/
│   ├── README.md
│   ├── service.yaml
│   ├── statefulset.yaml
│   └── validate.sh
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
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Artefactos

| Ruta | Uso |
|---|---|
| `starter/` | Punto de partida. Incluye el PVC, pero el Deployment todavia no monta el volumen persistente. |
| `solution/` | Estado final de la unidad. Esta ruta es la base que debe reutilizar la Unidad 05. |
| `validation/validate.sh` | Validacion del estado esperado. Escribe un dato de laboratorio y elimina un Pod para comprobar persistencia tras recreacion. |
| `statefulset-demo/` | Practica independiente de `StatefulSet`, headless Service y `volumeClaimTemplates` sobre `scratch-stateful`. No forma parte de `solution/`. |

## Precondiciones

Ejecutar desde la raiz del repositorio dentro de Ubuntu WSL:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/03-networking-ingress/validation/validate.sh
kubectl config current-context
kubectl get nodes
microk8s status --wait-ready
kubectl get storageclass
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
El contexto de kubectl apunta al MicroK8s local.
El Deployment platform-api de Unidad 03 esta disponible.
El Ingress local responde para platform-api.local.
Existe una StorageClass util o se confirma que debe habilitarse hostpath-storage.
```

Si la Unidad 03 no esta aplicada, recuperar el estado base:

```bash
microk8s enable ingress
kubectl apply -f labs/03-networking-ingress/solution/
bash labs/03-networking-ingress/validation/validate.sh
```

## StorageClass local en MicroK8s

El laboratorio usa la clase:

```text
microk8s-hostpath
```

Esa clase procede del addon local `hostpath-storage` de MicroK8s. Es suficiente para practicar PV/PVC en un laboratorio de un nodo, pero no representa durabilidad, disponibilidad ni rendimiento de almacenamiento cloud gestionado.

Si no aparece ninguna StorageClass util:

```bash
microk8s enable hostpath-storage
microk8s status --wait-ready
kubectl get storageclass
```

Resultado esperado:

```text
storageclass.storage.k8s.io/microk8s-hostpath aparece disponible.
```

## Despliegue

Aplicar la solucion en orden explicito:

```bash
kubectl apply -f labs/04-persistence-state/solution/namespace.yaml
kubectl apply -f labs/04-persistence-state/solution/configmap.yaml
kubectl apply -f labs/04-persistence-state/solution/secret.yaml
kubectl apply -f labs/04-persistence-state/solution/pvc.yaml
kubectl apply -f labs/04-persistence-state/solution/deployment.yaml
kubectl apply -f labs/04-persistence-state/solution/service.yaml
kubectl apply -f labs/04-persistence-state/solution/ingress.yaml
```

Comprobar el rollout y el almacenamiento:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress,pvc
kubectl get pv
```

Resultado esperado:

```text
deployment/platform-api esta disponible.
persistentvolumeclaim/platform-api-data esta Bound.
service/platform-api sigue siendo ClusterIP.
ingress/platform-api conserva host platform-api.local.
```

## Escritura y lectura de un dato persistente

Seleccionar un Pod listo:

```bash
POD="$(kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local -o jsonpath='{.items[0].metadata.name}')"
echo "$POD"
```

Escribir un dato no sensible en la ruta persistente:

```bash
kubectl -n platform-training exec "$POD" -- sh -c "printf '%s\n' 'Unidad 04 persistent data' > /usr/share/nginx/html/persistent/message.txt"
kubectl -n platform-training exec "$POD" -- cat /usr/share/nginx/html/persistent/message.txt
```

Probarlo por HTTP mediante el Ingress heredado:

```bash
curl -i -H 'Host: platform-api.local' http://127.0.0.1/persistent/message.txt
```

Resultado esperado:

```text
HTTP/1.1 200 OK
Unidad 04 persistent data
```

## Persistencia tras recreacion de Pods

Eliminar un Pod gestionado por el Deployment:

```bash
kubectl -n platform-training delete pod "$POD"
kubectl -n platform-training rollout status deployment/platform-api
```

Leer el dato desde un Pod listo:

```bash
NEW_POD="$(kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api,app.kubernetes.io/instance=platform-api-local -o jsonpath='{.items[0].metadata.name}')"
kubectl -n platform-training exec "$NEW_POD" -- cat /usr/share/nginx/html/persistent/message.txt
```

Resultado esperado:

```text
Unidad 04 persistent data
```

Si el dato desaparece, revisar que se escribio en `/usr/share/nginx/html/persistent` y no en otra ruta del filesystem del contenedor.

## Copia y restauracion basica

Crear una copia temporal fuera del repositorio:

```bash
mkdir -p /tmp/k8s-platform-training/unit04
kubectl -n platform-training cp "$NEW_POD":/usr/share/nginx/html/persistent/message.txt /tmp/k8s-platform-training/unit04/message.txt
```

Borrar el dato de laboratorio:

```bash
kubectl -n platform-training exec "$NEW_POD" -- rm -f /usr/share/nginx/html/persistent/message.txt
```

Restaurar la copia:

```bash
kubectl -n platform-training cp /tmp/k8s-platform-training/unit04/message.txt "$NEW_POD":/usr/share/nginx/html/persistent/message.txt
kubectl -n platform-training exec "$NEW_POD" -- cat /usr/share/nginx/html/persistent/message.txt
```

Esta copia no es un backup productivo. Solo demuestra que persistencia y recuperacion son problemas distintos.

## Validacion automatizada

Ejecutar:

```bash
bash labs/04-persistence-state/validation/validate.sh
```

La validacion comprueba:

- disponibilidad de `kubectl`;
- acceso al cluster;
- `StorageClass` `microk8s-hostpath`;
- namespace, Deployment, Service, EndpointSlice e Ingress;
- PVC `platform-api-data` en estado `Bound`;
- PV asociado al claim;
- montaje escribible en `/usr/share/nginx/html/persistent`;
- escritura y lectura de `message.txt`;
- persistencia tras eliminar un Pod de `platform-api`;
- acceso HTTP al dato persistente por Ingress.

Puede parametrizarse:

```bash
INGRESS_URL=http://<direccion-del-nodo>/ bash labs/04-persistence-state/validation/validate.sh
```

## Practica independiente de StatefulSet

`statefulset-demo/` contiene la practica implementada para `TD-023`. Es una practica auxiliar y desechable para observar identidad estable y volumen por replica sin migrar `platform-api`.

Ejecutar:

```bash
bash labs/04-persistence-state/statefulset-demo/validate.sh
```

La validacion independiente comprueba:

- `statefulset/scratch-stateful` con dos replicas;
- `service/scratch-stateful` como headless Service con `clusterIP: None`;
- Pods estables `scratch-stateful-0` y `scratch-stateful-1`;
- PVCs exactos `scratch-data-scratch-stateful-0` y `scratch-data-scratch-stateful-1`;
- escritura de identidad propia en el volumen de cada replica;
- resolucion DNS interna de los ordinales del StatefulSet;
- preservacion de `persistentvolumeclaim/platform-api-data`.

Limpiar solo la demo:

```bash
bash labs/04-persistence-state/statefulset-demo/validate.sh --cleanup
```

La limpieza borra recursos por nombre exacto y no toca `platform-api`, `platform-api-data`, `solution/` ni los artefactos reutilizados por unidades posteriores.

## Diagnostico rapido

StorageClass, PVC y PV:

```bash
kubectl get storageclass
kubectl -n platform-training get pvc platform-api-data
kubectl -n platform-training describe pvc platform-api-data
kubectl get pv
```

Pods y eventos:

```bash
kubectl -n platform-training get deploy,rs,pods
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Montaje:

```bash
kubectl -n platform-training exec "$NEW_POD" -- mount | grep /usr/share/nginx/html/persistent
kubectl -n platform-training exec "$NEW_POD" -- ls -la /usr/share/nginx/html/persistent
```

Service e Ingress:

```bash
kubectl -n platform-training get service platform-api
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
kubectl -n platform-training describe ingress platform-api
curl -i -H 'Host: platform-api.local' http://127.0.0.1/
```

## Recuperacion

Si el PVC queda `Pending`, revisar primero la StorageClass:

```bash
kubectl get storageclass
kubectl -n platform-training describe pvc platform-api-data
microk8s enable hostpath-storage
```

Si el Pod no monta el volumen:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Reaplicar el estado declarado:

```bash
kubectl apply -f labs/04-persistence-state/solution/
kubectl -n platform-training rollout status deployment/platform-api
bash labs/04-persistence-state/validation/validate.sh
```

## Limpieza opcional

Borrar solo el dato de prueba:

```bash
kubectl -n platform-training exec "$NEW_POD" -- rm -f /usr/share/nginx/html/persistent/message.txt
```

Eliminar el PVC puede borrar o desconectar datos segun la politica de reclamacion del PV. Hacerlo solo si se acepta perder el contenido persistente de laboratorio:

```bash
kubectl -n platform-training delete pvc platform-api-data
```

No usar `platform/environment/microk8s/reset.sh --confirm-reset` como limpieza de esta unidad.
