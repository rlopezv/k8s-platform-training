# Unidad 08 - Integración continua con Tekton

## Contexto

Hasta la Unidad 07, `platform-api` ya existe como aplicación evolutiva desplegable con Kubernetes, empaquetada con Helm y gestionada localmente con Terraform. Eso permite validar y aplicar cambios desde la máquina del alumno, pero todavía deja una pregunta abierta: ¿cómo convertimos esas comprobaciones en una ejecución repetible dentro del clúster?

La Unidad 08 introduce Tekton Pipelines para responder a esa pregunta. Tekton añade recursos Kubernetes de CI/CD, como `Task`, `Pipeline`, `TaskRun` y `PipelineRun`, y ejecuta cada paso como Pods efímeros dentro del clúster.

La unidad no convierte Tekton en motor de despliegue continuo. El pipeline valida el repositorio, ejecuta Helm, valida Terraform y genera `terraform plan`; no ejecuta `terraform apply`. Esta frontera prepara la Unidad 09, donde Argo CD introducirá GitOps y resolverá el reparto de propiedad sobre el despliegue.

## Objetivos

Al completar la unidad podrás:

- instalar Tekton Pipelines con una versión oficial fija;
- reconocer los CRDs principales de Tekton;
- definir Tasks modulares para validar artefactos de `platform-api`;
- componer una Pipeline con Workspaces, Params, Results y `when`;
- ejecutar un `PipelineRun` con PVC temporal por ejecución;
- inspeccionar TaskRuns, logs, condiciones y resultados;
- explicar por qué esta unidad ejecuta `terraform plan` y no `terraform apply`;
- comparar Tekton con `Job` y `CronJob` como criterio de diseño.

## Conocimientos previos

Necesitas haber completado:

- Unidad 00: entorno local, `kubectl`, Helm y Terraform;
- Unidad 01: Pods, Deployments, Services, labels y logs;
- Unidad 02: configuración, Secrets ficticios, probes y recursos;
- Unidad 03: Service, EndpointSlice e Ingress;
- Unidad 04: PVC y persistencia local;
- Unidad 05: rollout, réplicas, scheduling y PDB;
- Unidad 06: chart Helm de `platform-api`;
- Unidad 07: Terraform local, `helm_release`, state y plan.

## Estado inicial

La unidad parte de:

```text
platform-api
platform-training
platform-api-local
labs/06-helm-packaging/chart/platform-api/
labs/07-local-terraform-automation/terraform/
```

Tekton todavía no forma parte del clúster antes de esta unidad. Se instala en `tekton-pipelines` solo dentro del alcance aprobado de la Unidad 08.

## Mapa de aprendizaje

| Bloque | Pregunta central | Evidencia |
|---|---|---|
| Tekton como extensión de Kubernetes | ¿Qué añade Tekton al API server? | CRDs y controladores instalados |
| Task y Step | ¿Cómo se empaqueta trabajo ejecutable? | `tasks.yaml` |
| Pipeline | ¿Cómo se ordenan tareas con contrato declarativo? | `pipeline.yaml` |
| Workspace | ¿Cómo comparten estado tareas efímeras? | PVC temporal del `PipelineRun` |
| Params y Results | ¿Cómo entra y sale información no sensible? | parámetros y resultados de la ejecución |
| `when` | ¿Cómo se evita una acción no permitida? | tarea `apply-blocked` omitida o fallida |
| Terraform plan | ¿Qué puede hacer CI sin tomar ownership de despliegue? | plan no mutante |

## Material de la unidad

Lee primero `student-notes.md` para construir el modelo mental y entender el laboratorio. Usa `labs/08-tekton-continuous-integration/README.md` para ejecutar la práctica.

La referencia profesional está en `student-reference.md`. Ahí se desarrollan errores de razonamiento y criterios que no deben saturar el laboratorio: Tekton frente a GitOps, Jobs/CronJobs, build de imágenes, Triggers, Chains, Results, credenciales e identidad corporativa.

## Conclusión

Al terminar, el repositorio tendrá una primera pipeline CI nativa de Kubernetes para validar `platform-api`. El resultado importante no es solo que una ejecución termine en `Succeeded`: es que el alumno pueda separar integración continua, empaquetado Helm, plan Terraform y reconciliación GitOps.

La Unidad 09 reutilizará esta frontera para introducir Argo CD sin convertir Tekton en reconciliador continuo.
