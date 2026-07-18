# Laboratorio - Unidad 01

## Proposito

Este laboratorio contiene los primeros manifiestos Kubernetes de la solucion evolutiva del curso.

La aplicacion inicial se llama `platform-api` y se despliega en el namespace `platform-training`.

La unidad usa unicamente recursos Kubernetes estandar:

- `Namespace`;
- `Deployment`;
- `ReplicaSet` y `Pod` como recursos generados y observados;
- `Service` de tipo `ClusterIP`;
- labels y selectors.

Helm y Terraform estan disponibles como herramientas base desde la Unidad 00, pero no gestionan ningun recurso de este laboratorio.

## Estructura

```text
labs/01-kubernetes/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── solution/
│   ├── namespace.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── validation/
    └── validate.sh
```

## Artefactos

| Ruta | Uso |
|---|---|
| `starter/` | Punto de partida para el ejercicio guiado. Mantiene la misma aplicacion, pero empieza con una replica y un selector de Service menos estricto para facilitar la comparacion. |
| `solution/` | Estado final de la unidad. Esta ruta es la fuente que deben reutilizar las unidades posteriores. |
| `validation/validate.sh` | Validacion no destructiva del estado esperado tras aplicar `solution/`. |

## Aplicacion evolutiva

| Campo | Valor |
|---|---|
| Nombre logico | `platform-api` |
| Namespace | `platform-training` |
| Imagen inicial | `nginxinc/nginx-unprivileged:1.27.4-alpine` |
| Puerto de contenedor | `8080` |
| Service | `platform-api`, `ClusterIP`, puerto `80` hacia `http` |

La imagen inicial se eligio porque permite ejecutar un servidor HTTP sin privilegios dentro del contenedor, genera logs de acceso y puede evolucionar en unidades posteriores con configuracion, probes, recursos, ingreso y observabilidad.

## Precondiciones

Ejecutar desde la raiz del repositorio dentro de Ubuntu WSL:

```bash
bash platform/environment/validation/validate-environment.sh
kubectl config current-context
kubectl get nodes
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
El contexto de kubectl apunta al MicroK8s local.
El nodo local aparece en Ready.
```

## Despliegue

Aplicar la solucion final en orden explicito. El namespace debe existir antes de crear recursos dentro de el:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
```

Comprobar el rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
```

Inspeccionar recursos:

```bash
kubectl -n platform-training get deploy,rs,pods,svc,endpoints
kubectl -n platform-training get pods -l app.kubernetes.io/name=platform-api
```

## Validacion

Validar de forma automatizada:

```bash
bash labs/01-kubernetes/validation/validate.sh
```

La validacion comprueba:

- disponibilidad de `kubectl`;
- lectura del contexto actual;
- acceso a nodos;
- existencia del namespace;
- rollout del Deployment;
- ReplicaSet y Pods seleccionables por labels;
- existencia del Service;
- endpoints del Service;
- lectura de logs del Deployment.

## Prueba HTTP local

El Service es interno al cluster. Para probarlo desde la maquina local, abrir un port-forward:

```bash
kubectl -n platform-training port-forward service/platform-api 8080:80
```

En otra terminal:

```bash
curl -i http://127.0.0.1:8080/
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

Detener el port-forward con `Ctrl+C`.

## Diagnostico rapido

Eventos del namespace:

```bash
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Detalle de un Pod:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
```

Logs:

```bash
kubectl -n platform-training logs deployment/platform-api --tail=50
```

Comprobar selectors:

```bash
kubectl -n platform-training get deployment platform-api -o jsonpath='{.spec.selector.matchLabels}'
kubectl -n platform-training get service platform-api -o jsonpath='{.spec.selector}'
kubectl -n platform-training get endpoints platform-api
```

## Recuperacion

Reaplicar el estado declarado:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
bash labs/01-kubernetes/validation/validate.sh
```

Si una imagen no descarga:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Corregir la imagen en el manifiesto y reaplicar.

Si el Service no tiene endpoints, comparar labels del Pod con el selector del Service y reaplicar el manifiesto corregido.

## Limpieza opcional

La limpieza elimina la aplicacion que la Unidad 02 espera reutilizar. Ejecutarla solo si se quiere devolver el cluster a un estado sin recursos funcionales del curso:

```bash
kubectl delete namespace platform-training
```

Para recuperar el estado de salida de la Unidad 01:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
bash labs/01-kubernetes/validation/validate.sh
```
