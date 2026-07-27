# Demo StatefulSet - Unidad 04

## Proposito

Esta practica cierra `TD-023` con un workload auxiliar desechable llamado `scratch-stateful`.

La demo muestra:

- un `StatefulSet` con dos replicas;
- un headless Service con `clusterIP: None`;
- identidad estable por ordinal: `scratch-stateful-0` y `scratch-stateful-1`;
- un PVC independiente por replica mediante `volumeClaimTemplates`;
- retencion observable de los PVC tras borrar el controlador `StatefulSet`;
- orden por defecto `OrderedReady`, sin `podManagementPolicy: Parallel`;
- validacion funcional separada del laboratorio principal de `platform-api`;
- limpieza precisa de recursos de la demo.

No migra `platform-api`, no modifica `labs/04-persistence-state/solution/` y no debe propagarse a las Unidades 05, 06 ni 07.

## Estructura

```text
labs/04-persistence-state/statefulset-demo/
├── README.md
├── service.yaml
├── statefulset.yaml
└── validate.sh
```

## Precondiciones

Ejecutar desde la raiz del repositorio:

```bash
bash labs/04-persistence-state/validation/validate.sh
kubectl get storageclass microk8s-hostpath
```

Resultado esperado:

```text
La Unidad 04 principal esta funcional.
La StorageClass microk8s-hostpath existe.
```

## Despliegue manual

```bash
kubectl apply -f labs/04-persistence-state/solution/namespace.yaml
kubectl apply -f labs/04-persistence-state/statefulset-demo/service.yaml
kubectl apply -f labs/04-persistence-state/statefulset-demo/statefulset.yaml
kubectl -n platform-training rollout status statefulset/scratch-stateful
```

Comprobar identidad y volumenes:

```bash
kubectl -n platform-training get statefulset scratch-stateful
kubectl -n platform-training get pods scratch-stateful-0 scratch-stateful-1
kubectl -n platform-training get pvc scratch-data-scratch-stateful-0 scratch-data-scratch-stateful-1
kubectl -n platform-training exec scratch-stateful-0 -- cat /usr/share/nginx/html/stateful/identity.txt
kubectl -n platform-training exec scratch-stateful-1 -- cat /usr/share/nginx/html/stateful/identity.txt
```

Resultado esperado:

```text
Cada Pod escribe su propio nombre y referencia su propio claim.
Los PVC scratch-data-scratch-stateful-0 y scratch-data-scratch-stateful-1 quedan Bound.
```

## Validacion automatizada independiente

```bash
bash labs/04-persistence-state/statefulset-demo/validate.sh
```

La validacion aplica solo la demo, comprueba el StatefulSet, el headless Service, los Pods por ordinal, los PVC por nombre exacto, el contenido persistente de cada replica, la resolucion DNS interna del headless Service y la retencion de los PVC tras borrar `statefulset/scratch-stateful`.

Al finalizar correctamente, el validador borra solo el controlador `statefulset/scratch-stateful` para demostrar que los claims generados por `volumeClaimTemplates` siguen existiendo y quedan `Bound`. El headless Service y los PVC de demo permanecen hasta ejecutar la limpieza explicita.

Para limpiar la demo despues de validar:

```bash
bash labs/04-persistence-state/statefulset-demo/validate.sh --cleanup
```

La limpieza borra solo:

```text
statefulset/scratch-stateful
service/scratch-stateful
persistentvolumeclaim/scratch-data-scratch-stateful-0
persistentvolumeclaim/scratch-data-scratch-stateful-1
```

No usa selectores, no usa `--all` y no toca `persistentvolumeclaim/platform-api-data`.
