# Summary - Unidad 08

## Identificación

| Campo | Valor |
|---|---|
| Unidad | 08 - Integración continua con Tekton |
| Identificador | `08-tekton-continuous-integration` |
| Fase del roadmap | Fase 4 - Entrega continua y GitOps |
| Estado | Generada y validada funcionalmente; aprobación pedagógica pendiente |
| Fecha de cierre o actualización | 2026-07-28 |
| Revisión pedagógica del usuario | Pendiente |

## Resumen ejecutivo

La Unidad 08 incorpora Tekton Pipelines como componente de clúster y crea una pipeline CI inicial para `platform-api`. La unidad reutiliza el chart Helm de Unidad 06 y el proyecto Terraform de Unidad 07, valida ambos desde Tasks de Tekton y ejecuta `terraform plan` sin `terraform apply`.

La versión fijada es Tekton Pipelines `v1.12.2`, verificada el 2026-07-28 contra fuentes oficiales como línea LTS soportada hasta mayo de 2027. La release general más reciente publicada al verificar era `v1.14.1`, no LTS.

La unidad deja preparada la Unidad 09 para introducir Argo CD y resolver la frontera GitOps. No instala Argo CD, no crea Triggers, no construye imágenes, no usa registry y no introduce credenciales reales.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Crear tutorial de Unidad 08 | Alcanzado | `tutorial/08-tekton-continuous-integration/README.md` |
| Crear notas del alumno | Alcanzado | `tutorial/08-tekton-continuous-integration/student-notes.md` |
| Crear referencia del alumno | Alcanzado | `tutorial/08-tekton-continuous-integration/student-reference.md` |
| Crear notas del instructor | Alcanzado | `tutorial/08-tekton-continuous-integration/instructor-notes.md` |
| Crear laboratorio Tekton | Alcanzado | `labs/08-tekton-continuous-integration/` |
| Fijar versión Tekton verificada | Alcanzado | `v1.12.2`; fuentes oficiales de Tekton consultadas el 2026-07-28 |
| Practicar Tasks, Pipeline, PipelineRun, Workspace, Params, Results y `when` | Alcanzado como artefacto generado | `tekton/tasks.yaml`, `tekton/pipeline.yaml`, `tekton/pipelinerun.yaml` |
| Ejecutar `terraform plan` y no `apply` | Alcanzado como diseño de pipeline | `platform-api-terraform-plan` usa `terraform plan -refresh=false`; escaneo sin `terraform apply` |
| Mantener `GAP-004` cerrado | Alcanzado documentalmente | `student-reference.md` compara Jobs/CronJobs y ancla práctica a Unidad 23 |
| Actualizar catálogo de componentes | Alcanzado | `platform/tools/README.md` |

## Estado inicial utilizado

## Plataforma

- MicroK8s, Kubernetes, `kubectl`, Helm y Terraform figuraban como validados en `project/project-state.md`.
- Tekton no estaba incorporado antes de generar la unidad.

## Aplicación

- `platform-api` seguía siendo la aplicación evolutiva.
- `platform-training` seguía siendo el namespace funcional.
- `platform-api-local` seguía siendo el release Helm gestionado por Terraform local.

## Automatización

- Unidad 06 aportaba el chart Helm.
- Unidad 07 aportaba el proyecto Terraform local.
- La Unidad 08 añade una pipeline CI Tekton sobre esos artefactos.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 07 | `tutorial/07-local-terraform-automation/summary.md` | Continuidad y contradicción corregida sobre `apply` |
| Chart Helm | `labs/06-helm-packaging/chart/platform-api/` | Validación Helm desde CI |
| Validación Helm | `labs/06-helm-packaging/validation/validate.sh` | Referencia heredada |
| Proyecto Terraform | `labs/07-local-terraform-automation/terraform/` | Validación y plan desde CI |
| Validación Terraform | `labs/07-local-terraform-automation/validation/validate.sh` | Referencia heredada |
| Catálogo de componentes | `platform/tools/README.md` | Registro de ciclo de vida de Tekton |

## Cambios introducidos

## Capacidades incorporadas

- instalación documentada de Tekton Pipelines `v1.12.2`;
- pipeline CI `platform-api-ci`;
- Tasks modulares para preparar fuente local, validar repositorio, validar Helm y ejecutar plan Terraform;
- Workspace con PVC temporal por `PipelineRun`;
- Params simples para namespace, release, rutas y modo de ejecución;
- Results no sensibles;
- `when` para bloquear modo `apply`;
- ServiceAccount y RBAC local mínimo;
- script idempotente para preparar fuente local sin credenciales;
- validador estático y funcional opcional.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 08 | `tutorial/08-tekton-continuous-integration/README.md` | Puerta de entrada |
| Student notes | `tutorial/08-tekton-continuous-integration/student-notes.md` | Guía de aprendizaje |
| Student reference | `tutorial/08-tekton-continuous-integration/student-reference.md` | Referencia profesional |
| Instructor notes | `tutorial/08-tekton-continuous-integration/instructor-notes.md` | Guía de impartición |
| Summary Unidad 08 | `tutorial/08-tekton-continuous-integration/summary.md` | Continuidad |
| Laboratorio | `labs/08-tekton-continuous-integration/README.md` | Operación |
| Manifiestos Tekton | `labs/08-tekton-continuous-integration/tekton/` | CI declarativa |
| Script de fuente | `labs/08-tekton-continuous-integration/scripts/create-source-configmap.sh` | Bundle local |
| Validación | `labs/08-tekton-continuous-integration/validation/validate.sh` | Comprobación estática y funcional opcional |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Catálogo de componentes | `platform/tools/README.md` | Tekton Pipelines pasa a versión fija `v1.12.2` |
| Estado del proyecto | `project/project-state.md` | Registra Unidad 08 generada y siguiente incremento |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/08-tekton-continuous-integration/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

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

## Validaciones

## Validaciones ejecutadas

| Validación | Comando o procedimiento | Resultado observado |
|---|---|---|
| Sintaxis Bash del script de fuente | `bash -n labs/08-tekton-continuous-integration/scripts/create-source-configmap.sh` | 0 |
| Sintaxis Bash del validador | `bash -n labs/08-tekton-continuous-integration/validation/validate.sh` | 0 |
| `shellcheck` | `shellcheck labs/08-tekton-continuous-integration/scripts/create-source-configmap.sh labs/08-tekton-continuous-integration/validation/validate.sh` | 0 |
| Validación estática de Unidad 08 antes de instalar CRDs | `bash labs/08-tekton-continuous-integration/validation/validate.sh` | 0 fallos, 2 avisos: dry-run Tekton no resolvía CRDs y validación funcional omitida |
| Validación funcional inicial de Unidad 08 | `TEKTON_VERSION=v1.12.2 RUN_FUNCTIONAL=true bash labs/08-tekton-continuous-integration/validation/validate.sh` | Primer intento bloqueado por controladores Tekton no `Available`; posteriormente resuelto |
| Diagnóstico de Pods Tekton | `kubectl -n tekton-pipelines get deployment` | `tekton-events-controller`, `tekton-pipelines-controller` y `tekton-pipelines-webhook` quedaron `1/1 Available` |
| CRDs Tekton | `kubectl api-resources --api-group=tekton.dev` | `tasks`, `taskruns`, `pipelines`, `pipelineruns`, `customruns`, `stepactions` y `verificationpolicies` presentes |
| Validación estática tras CRDs | `bash labs/08-tekton-continuous-integration/validation/validate.sh` | 0 fallos, 1 aviso: manifests Tekton aceptados por dry-run; funcional omitida |
| Validación estática final de Unidad 08 | `bash labs/08-tekton-continuous-integration/validation/validate.sh` | 0 fallos, 1 aviso: funcional omitida sin `RUN_FUNCTIONAL=true` |
| Validación funcional final de Unidad 08 | `TEKTON_VERSION=v1.12.2 RUN_FUNCTIONAL=true bash labs/08-tekton-continuous-integration/validation/validate.sh` | 0 fallos, 0 avisos; `PipelineRun` y `TaskRuns` completados |
| Helm heredado | `helm lint labs/06-helm-packaging/chart/platform-api` | 1 chart linted, 0 failed; aviso informativo de icon recomendado |
| Terraform heredado | `terraform -chdir=labs/07-local-terraform-automation/terraform validate` | `Success! The configuration is valid.` |
| Gobierno documental | `bash project/validation/validate-governance.sh` | 0 fallos, 0 avisos |

## Validaciones funcionales verificadas

| Validación | Evidencia | Estado |
|---|---|---|
| `PipelineRun` completo hasta `Succeeded` | `platform-api-ci-run` completó con `prepare-source`, `repository-preflight`, `helm-validate` y `terraform-plan` en `Succeeded` | Validado |
| Logs y Results reales del `PipelineRun` | Results observados: `source-revision`, `checked-files`, `helm-status=helm-ok`, `terraform-plan-summary=terraform-plan-ok` | Validado |
| PVC temporal del `PipelineRun` | `PipelineRun` ejecutado con Workspace por `volumeClaimTemplate` y fuente montada desde `ConfigMap` | Validado |

## Decisiones tomadas

## D-08-01 - Tekton ejecuta validación y plan, no apply

La pipeline valida Helm y Terraform y ejecuta `terraform plan -refresh=false`. No ejecuta `terraform apply` para no adelantar ownership, aprobaciones, state compartido ni GitOps.

## D-08-02 - Tekton se fija en `v1.12.2` LTS

La versión se eligió tras verificar fuentes oficiales el 2026-07-28. `v1.12.2` es el patch seleccionado de la línea LTS `v1.12`, soportada hasta mayo de 2027; `v1.14.1` era la release general más reciente publicada.

## D-08-03 - Fuente local mediante ConfigMap

La unidad evita credenciales Git y webhooks reales. El script `create-source-configmap.sh` empaqueta solo artefactos necesarios y excluye state, planes y variables locales.

## D-08-04 - Jobs/CronJobs como criterio

La unidad compara `Job` y `CronJob` frente a Tekton, pero su práctica ejecutable queda diferida a Unidad 23.

## Reutilización obligatoria

La siguiente unidad deberá reutilizar:

| Elemento | Ruta o referencia | Forma de reutilización |
|---|---|---|
| Chart Helm | `labs/06-helm-packaging/chart/platform-api/` | Paquete de aplicación |
| Proyecto Terraform | `labs/07-local-terraform-automation/terraform/` | Frontera de ownership y plan |
| Pipeline CI | `labs/08-tekton-continuous-integration/tekton/` | Validación previa a GitOps |
| Catálogo Tekton | `platform/tools/README.md` | Componente persistente de clúster |

## Seguridad

No se introducen credenciales reales, tokens, kubeconfigs ni secretos corporativos. Los Results son no sensibles. El bundle local excluye state Terraform, planes binarios, `.terraform/` y `terraform.tfvars`.

## Limitaciones conocidas

| Limitación | Impacto | Motivo | Resolución prevista |
|---|---|---|---|
| Fuente por ConfigMap | No equivale a Git remoto productivo | Evita credenciales y Triggers antes de tiempo | Unidad 10 o laboratorio avanzado |
| `terraform plan -refresh=false` | No es plan productivo completo | No se versiona state local ni se ejecuta apply | Unidad 09 o posterior |
| PVC temporal local | Depende de `microk8s-hostpath` | Laboratorio local de un nodo | Unidad 19 y cloud |
| Sin build de imagen | No valida supply chain | Falta Dockerfile, registry y credenciales | Unidad 17 o laboratorio avanzado |

## Diferencias respecto al playbook

Ninguna. Se aplica la corrección de alcance indicada por el usuario: Unidad 08 ejecuta `terraform plan`, no `terraform apply`, aunque el summary de Unidad 07 mencionara plan y apply.

## Preparación de la siguiente unidad

## Siguiente unidad prevista

```text
09 - GitOps con Argo CD
```

## Estado de entrada que puede asumir

- Unidad 08 generada con pipeline CI inicial.
- Tekton Pipelines catalogado como componente de clúster `v1.12.2`.
- `terraform apply` sigue fuera de Tekton.
- No existe recurso Argo CD creado por Unidad 08.

## Archivos que deberá leer

```text
tutorial/08-tekton-continuous-integration/summary.md
labs/08-tekton-continuous-integration/
platform/tools/README.md
labs/06-helm-packaging/chart/platform-api/
labs/07-local-terraform-automation/terraform/
```
