# Laboratorio - Unidad 06

## Proposito

Este laboratorio empaqueta `platform-api` como chart Helm local. Parte de los manifiestos de Unidad 05 y conserva el comportamiento funcional: namespace `platform-training`, Deployment `platform-api`, ConfigMap, Secret ficticio, PVC, Service, Ingress y PDB.

No crea modulos Terraform, no publica charts, no instala GitOps, no gestiona secretos productivos y no borra PVCs como parte normal del flujo.

## Estructura

```text
labs/06-helm-packaging/
├── README.md
├── chart/
│   └── platform-api/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-local.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── namespace.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── pvc.yaml
│           ├── pdb.yaml
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
└── validation/
    ├── adopt-existing-resources.sh
    └── validate.sh
```

## Precondiciones

Ejecutar desde la raiz del repositorio dentro de Ubuntu WSL:

```bash
bash platform/environment/validation/validate-environment.sh
bash labs/05-scheduling-resilience-maintenance/validation/validate.sh
helm version --short
kubectl config current-context
```

Resultado esperado:

```text
El entorno local no muestra fallos bloqueantes.
Helm informa su version.
platform-api esta disponible desde Unidad 05.
```

## Renderizado inicial

Renderizar el chart sin instalar:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

Validar que Kubernetes aceptaria el YAML renderizado:

```bash
helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml | kubectl apply --dry-run=client -f -
```

Resultado esperado:

```text
Namespace, ConfigMap, Secret, PVC, Deployment, Service, Ingress y PDB aparecen como configured/created en dry-run.
```

## Lint del chart

```bash
helm lint labs/06-helm-packaging/chart/platform-api
```

Resultado esperado:

```text
1 chart(s) linted, 0 chart(s) failed
```

Puede aparecer una recomendacion informativa sobre `icon`; no es bloqueante para este laboratorio.

## Instalacion o upgrade

Si vienes directamente de la Unidad 05, los recursos ya existen porque fueron aplicados con `kubectl`. Helm exige metadatos de ownership para adoptar recursos existentes. Antes del primer install, aplica solo esos metadatos:

```bash
bash labs/06-helm-packaging/validation/adopt-existing-resources.sh
```

El script anade labels y annotations de Helm a Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB. No borra recursos, no borra el PVC y no recrea la aplicacion.

Instalar o actualizar el release local:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training --create-namespace -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

Comprobar rollout:

```bash
kubectl -n platform-training rollout status deployment/platform-api
kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress,pvc,pdb
```

## Inspeccion del release

```bash
helm status platform-api-local --namespace platform-training
helm get values platform-api-local --namespace platform-training
helm get manifest platform-api-local --namespace platform-training
helm history platform-api-local --namespace platform-training
```

Relaciona la salida de `helm get manifest` con los templates del chart. Esa comparacion es el puente entre Helm y Kubernetes.

## Upgrade controlado

Cambiar temporalmente el texto visible:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml --set config.featureGreeting=helm-upgrade-demo
kubectl -n platform-training rollout status deployment/platform-api
helm history platform-api-local --namespace platform-training
```

Volver al valor local versionado:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
kubectl -n platform-training rollout status deployment/platform-api
```

No uses `--set` como mecanismo principal para estructuras grandes.

## Rollback

Ver historial:

```bash
helm history platform-api-local --namespace platform-training
```

Volver a una revision anterior:

```bash
helm rollback platform-api-local <revision> --namespace platform-training
kubectl -n platform-training rollout status deployment/platform-api
```

Despues de demostrar rollback, reinstalar el estado versionado:

```bash
helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml
```

## Validacion automatizada

```bash
bash labs/06-helm-packaging/validation/validate.sh
```

La validacion comprueba:

- `helm lint`;
- `helm template`;
- dry-run cliente del YAML renderizado;
- existencia del release;
- Deployment disponible;
- Service `ClusterIP` con endpoints;
- Ingress `platform-api.local`;
- PVC `platform-api-data`;
- PDB `platform-api`;
- labels principales de Helm;
- respuesta HTTP con texto de Unidad 06 cuando Ingress esta disponible;
- historial del release;
- busqueda basica de patrones de secretos reales.

## Diagnostico rapido

| Sintoma | Comando util | Recuperacion |
|---|---|---|
| Error de template | `helm template ...` | Revisar template, `nindent`, `quote` y contexto |
| Chart no pasa lint | `helm lint ...` | Corregir metadatos o sintaxis |
| YAML rechazado | `helm template ... | kubectl apply --dry-run=client -f -` | Revisar API, kind, spec y campos |
| Release no existe | `helm status platform-api-local -n platform-training` | Ejecutar `helm upgrade --install` |
| Service sin endpoints | `kubectl -n platform-training get pods --show-labels` | Revisar helpers de selector |
| HTTP no responde | `kubectl -n platform-training get ingress,endpointslice` | Validar Ingress y Pods Ready |

## Limpieza controlada

No borrar el PVC como limpieza normal. Si se necesita retirar solo el release:

```bash
helm uninstall platform-api-local --namespace platform-training
```

El PVC puede permanecer segun politica del cluster y estado previo. Para continuar el curso, reinstala el release con el comando de instalacion.
