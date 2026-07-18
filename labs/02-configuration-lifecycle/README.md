# Laboratorio - Unidad 02

## Proposito

Este laboratorio evoluciona `platform-api` desde el estado final de la Unidad 01 hacia un workload configurable y operable con recursos Kubernetes estandar.

La unidad incorpora:

- `ConfigMap` para configuracion no sensible;
- `Secret` de laboratorio con valores ficticios;
- variables de entorno desde ConfigMap y Secret;
- volumen de configuracion desde ConfigMap;
- `startupProbe`, `readinessProbe` y `livenessProbe`;
- `resources.requests` y `resources.limits`;
- validacion no destructiva del estado esperado.

Helm y Terraform siguen disponibles como herramientas base, pero no gestionan ningun recurso de este laboratorio.

## Estructura

```text
labs/02-configuration-lifecycle/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── deployment.yaml
│   └── service.yaml
└── validation/
    └── validate.sh
```

## Artefactos

| Ruta | Uso |
|---|---|
| `starter/` | Punto de partida para completar probes, limits y consumo de configuracion. |
| `solution/` | Estado final de la unidad. Esta ruta es la base que debe reutilizar la Unidad 03. |
| `validation/validate.sh` | Validacion no destructiva del estado esperado tras aplicar `solution/`. |

## Precondiciones

Ejecutar desde la raiz del repositorio dentro de Ubuntu WSL:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/01-kubernetes/validation/validate.sh
kubectl config current-context
kubectl get nodes
```

Resultado esperado:

```text
La validacion heredada no muestra fallos bloqueantes.
El Deployment platform-api de Unidad 01 esta disponible.
El contexto de kubectl apunta al MicroK8s local.
El nodo local aparece en Ready.
```

Si la Unidad 01 no esta aplicada, recuperar el estado base:

```bash
kubectl apply -f labs/01-kubernetes/solution/namespace.yaml
kubectl apply -f labs/01-kubernetes/solution/deployment.yaml
kubectl apply -f labs/01-kubernetes/solution/service.yaml
bash labs/01-kubernetes/validation/validate.sh
```

## Despliegue

Aplicar la solucion en orden explicito:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
```

Comprobar el rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice
```

## Validacion

Validar de forma automatizada:

```bash
bash labs/02-configuration-lifecycle/validation/validate.sh
```

La validacion comprueba:

- disponibilidad de `kubectl`;
- acceso al cluster;
- existencia del namespace;
- existencia de ConfigMap y claves esperadas;
- existencia de Secret y claves esperadas sin imprimir valores;
- rollout del Deployment;
- referencias a ConfigMap, Secret, probes, volumen y recursos;
- Pods listos;
- Service y endpoints mediante EndpointSlice;
- lectura de logs del Deployment.

## Prueba HTTP local

El Service sigue siendo interno. Para probar el contenido montado desde ConfigMap, abrir un port-forward:

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

El cuerpo HTML debe mencionar `Unidad 02: configuracion externa desde ConfigMap`.

Detener el port-forward con `Ctrl+C`.

## Diagnostico rapido

Estado y rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training rollout history deployment/platform-api
kubectl -n platform-training get deploy,rs,pods
```

Configuracion sin exponer secretos:

```bash
kubectl -n platform-training get configmap platform-api-config
kubectl -n platform-training describe configmap platform-api-config
kubectl -n platform-training get secret platform-api-secret
kubectl -n platform-training describe secret platform-api-secret
```

Detalle de Pods y probes:

```bash
kubectl -n platform-training describe pod -l app.kubernetes.io/name=platform-api
kubectl -n platform-training get events --sort-by=.lastTimestamp
```

Service y endpoints listos:

```bash
kubectl -n platform-training get service platform-api
kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api
```

Logs:

```bash
kubectl -n platform-training logs deployment/platform-api --tail=50
```

## Recuperacion

Reaplicar el estado declarado:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
kubectl -n platform-training rollout status deployment/platform-api
bash labs/02-configuration-lifecycle/validation/validate.sh
```

Si falta el ConfigMap o el Secret, reaplicar primero esos manifiestos y despues forzar un nuevo rollout:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl -n platform-training rollout restart deployment/platform-api
kubectl -n platform-training rollout status deployment/platform-api
```

Si una probe esta mal configurada, revisar eventos y restaurar el Deployment de `solution/`.

## Limpieza opcional

La limpieza elimina la aplicacion que la Unidad 03 espera reutilizar. Ejecutarla solo si se quiere devolver el cluster a un estado sin recursos funcionales del curso:

```bash
kubectl delete namespace platform-training
```

Para recuperar el estado de salida de la Unidad 02:

```bash
kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/configmap.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/secret.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/deployment.yaml
kubectl apply -f labs/02-configuration-lifecycle/solution/service.yaml
bash labs/02-configuration-lifecycle/validation/validate.sh
```
