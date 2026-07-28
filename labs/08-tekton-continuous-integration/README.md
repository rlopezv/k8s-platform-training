# Laboratorio - Unidad 08

## Propósito

Este laboratorio introduce Tekton Pipelines como motor de integración continua dentro del clúster local. Reutiliza `platform-api`, el namespace `platform-training`, el chart Helm de la Unidad 06 y el proyecto Terraform de la Unidad 07.

El pipeline valida artefactos y ejecuta `terraform plan`. No ejecuta `terraform apply`, no despliega Argo CD, no crea otra aplicación, no construye imágenes, no usa registry y no guarda credenciales reales.

## Versión de Tekton

Versión fijada para la unidad:

```text
Tekton Pipelines v1.12.2
```

La versión se verificó el 2026-07-28 contra fuentes oficiales de Tekton: `v1.12.2` es línea LTS soportada hasta mayo de 2027, mientras que `v1.14.1` era la release general más reciente publicada, no LTS. El laboratorio usa el manifiesto oficial versionado:

```bash
kubectl apply -f https://infra.tekton.dev/tekton-releases/pipeline/previous/v1.12.2/release.yaml
```

## Estructura

```text
labs/08-tekton-continuous-integration/
├── README.md
├── scripts/
│   └── create-source-configmap.sh
├── tekton/
│   ├── namespace-or-prerequisites.md
│   ├── serviceaccount.yaml
│   ├── rbac.yaml
│   ├── tasks.yaml
│   ├── pipeline.yaml
│   └── pipelinerun.yaml
└── validation/
    └── validate.sh
```

## Precondiciones

Ejecuta desde la raíz del repositorio:

```bash
microk8s status --wait-ready
kubectl get nodes
helm version --short
terraform version
helm lint labs/06-helm-packaging/chart/platform-api
terraform -chdir=labs/07-local-terraform-automation/terraform init
terraform -chdir=labs/07-local-terraform-automation/terraform validate
```

Resultado esperado:

```text
MicroK8s está Ready.
Helm y Terraform están disponibles.
El chart de Unidad 06 y el proyecto Terraform de Unidad 07 son validables.
```

## Instalación de Tekton Pipelines

Instala Tekton solo dentro del alcance de esta unidad:

```bash
kubectl apply -f https://infra.tekton.dev/tekton-releases/pipeline/previous/v1.12.2/release.yaml
```

Comprueba los controladores:

```bash
kubectl -n tekton-pipelines wait --for=condition=Available deployment --all --timeout=300s
kubectl api-resources --api-group=tekton.dev
```

Resultado esperado:

```text
El namespace tekton-pipelines existe.
Los deployments de Tekton están Available.
La API expone taskruns, tasks, pipelineruns y pipelines.
```

## Preparar la fuente local

El pipeline corre dentro de Kubernetes y no puede leer directamente el directorio local del alumno. Para evitar credenciales Git o repos remotos antes de la unidad de Triggers, este laboratorio empaqueta solo los artefactos necesarios en un `ConfigMap` local.

```bash
bash labs/08-tekton-continuous-integration/scripts/create-source-configmap.sh
```

Efecto:

```text
Se crea o actualiza configmap/platform-api-ci-source en platform-training.
Incluye el chart Helm de Unidad 06 y el proyecto Terraform de Unidad 07.
No incluye .terraform/, terraform.tfstate, planes binarios ni terraform.tfvars locales.
```

## Aplicar identidad, RBAC y definiciones Tekton

```bash
kubectl apply -f labs/08-tekton-continuous-integration/tekton/serviceaccount.yaml
kubectl apply -f labs/08-tekton-continuous-integration/tekton/rbac.yaml
kubectl apply -f labs/08-tekton-continuous-integration/tekton/tasks.yaml
kubectl apply -f labs/08-tekton-continuous-integration/tekton/pipeline.yaml
```

Comprueba:

```bash
kubectl -n platform-training get serviceaccount platform-api-ci
kubectl -n platform-training get role,rolebinding platform-api-ci-read
kubectl -n platform-training get tasks,pipelines
```

## Ejecutar el PipelineRun

```bash
kubectl apply -f labs/08-tekton-continuous-integration/tekton/pipelinerun.yaml
```

Observa la ejecución:

```bash
kubectl -n platform-training get pipelinerun platform-api-ci-run
kubectl -n platform-training get taskrun -l tekton.dev/pipelineRun=platform-api-ci-run
kubectl -n platform-training describe pipelinerun platform-api-ci-run
```

Cuando termine, revisa los resultados no sensibles:

```bash
kubectl -n platform-training get pipelinerun platform-api-ci-run -o jsonpath='{.status.results}'
```

Resultado esperado:

```text
prepare-source copia la fuente al Workspace.
repository-preflight valida que existen los ficheros principales.
helm-validate ejecuta helm lint y helm template.
terraform-plan ejecuta fmt, init, validate y terraform plan -refresh=false.
apply-blocked queda omitida porque execution_mode=plan.
```

## Leer logs

Sin instalar el CLI `tkn`, usa `kubectl`:

```bash
kubectl -n platform-training logs -l tekton.dev/pipelineRun=platform-api-ci-run --all-containers=true --prefix=true
```

Para una Task concreta:

```bash
kubectl -n platform-training get taskrun -l tekton.dev/pipelineTask=terraform-plan
kubectl -n platform-training logs -l tekton.dev/taskRun=<taskrun-name> --all-containers=true
```

## Comprobar el Workspace temporal

El `PipelineRun` crea un PVC temporal mediante `volumeClaimTemplate`:

```bash
kubectl -n platform-training get pvc -l tekton.dev/pipelineRun=platform-api-ci-run
```

Ese PVC contiene datos temporales de ejecución, no artefactos permanentes. No sustituye a un repositorio Git, a un registry ni a Tekton Results.

## Probar la condición `when`

El modo normal es `plan`. Si cambias `execution_mode` a `apply`, la tarea `apply-blocked` se ejecuta y falla de forma intencional:

```bash
kubectl -n platform-training delete pipelinerun platform-api-ci-run --ignore-not-found=true
kubectl -n platform-training create -f labs/08-tekton-continuous-integration/tekton/pipelinerun.yaml
```

Para probarlo, edita una copia temporal del `PipelineRun`, cambia `execution_mode` a `apply` y aplícala. No modifiques el manifiesto versionado para dejarlo en modo `apply`.

## Validación automatizada

Validación estática:

```bash
bash labs/08-tekton-continuous-integration/validation/validate.sh
```

Validación funcional, solo cuando quieras instalar y ejecutar Tekton dentro del alcance aprobado de la unidad:

```bash
RUN_FUNCTIONAL=true bash labs/08-tekton-continuous-integration/validation/validate.sh
```

## Repetición

Para repetir la ejecución con el mismo nombre:

```bash
kubectl -n platform-training delete pipelinerun platform-api-ci-run --ignore-not-found=true
bash labs/08-tekton-continuous-integration/scripts/create-source-configmap.sh
kubectl apply -f labs/08-tekton-continuous-integration/tekton/pipelinerun.yaml
```

El script de fuente es idempotente. Las definiciones `Task` y `Pipeline` también pueden aplicarse varias veces.

## Limpieza de la unidad

Limpieza de ejecuciones y recursos de laboratorio en `platform-training`:

```bash
kubectl -n platform-training delete pipelinerun platform-api-ci-run --ignore-not-found=true
kubectl -n platform-training delete pipeline platform-api-ci --ignore-not-found=true
kubectl -n platform-training delete task platform-api-prepare-source platform-api-repository-preflight platform-api-helm-validate platform-api-terraform-plan platform-api-apply-blocked --ignore-not-found=true
kubectl -n platform-training delete rolebinding platform-api-ci-read --ignore-not-found=true
kubectl -n platform-training delete role platform-api-ci-read --ignore-not-found=true
kubectl -n platform-training delete serviceaccount platform-api-ci --ignore-not-found=true
kubectl -n platform-training delete configmap platform-api-ci-source --ignore-not-found=true
```

No borres `platform-api-data` como parte de esta limpieza.

Retirada completa de Tekton Pipelines, solo si el instructor decide que no debe persistir hacia Unidades 09-10:

```bash
kubectl delete -f https://infra.tekton.dev/tekton-releases/pipeline/previous/v1.12.2/release.yaml
```

## Diagnóstico rápido

| Síntoma | Comando útil | Recuperación |
|---|---|---|
| `no matches for kind "Task"` | `kubectl api-resources --api-group=tekton.dev` | Instalar Tekton Pipelines `v1.12.2` |
| `ConfigMap platform-api-ci-source not found` | `kubectl -n platform-training get configmap platform-api-ci-source` | Ejecutar `create-source-configmap.sh` |
| `PipelineRun` no avanza | `kubectl -n platform-training describe pipelinerun platform-api-ci-run` | Revisar eventos y TaskRuns |
| Fallo en Helm | Logs de `helm-validate` | Ejecutar `helm lint` local sobre el chart |
| Fallo en Terraform | Logs de `terraform-plan` | Ejecutar `terraform init` y `terraform validate` localmente |
| Permisos insuficientes | `kubectl -n platform-training auth can-i get configmaps --as=system:serviceaccount:platform-training:platform-api-ci` | Revisar `rbac.yaml` |
