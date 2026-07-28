# Referencia del alumno — Unidad 08: Integración continua con Tekton

## Propósito de la referencia

Esta referencia amplía `tutorial/08-tekton-continuous-integration/student-notes.md`. Las notas explican cómo completar el laboratorio; este documento organiza la visión profesional necesaria para razonar sobre Tekton, CI/CD, Jobs, permisos, eventos, artefactos y GitOps más allá del entorno local.

Aplica cobertura de panorama, profundidad, criterio y práctica. Cubre la arquitectura de Tekton, Tasks, Pipelines, Runs, Workspaces, Params, Results, condiciones, RBAC local, frontera CI/GitOps y la comparación con `Job` y `CronJob`. También mantiene cerrado `GAP-004`: Unidad 08 compara Jobs/CronJobs con Tekton como criterio, pero su práctica ejecutable queda diferida a Unidad 23.

No instala Argo CD, no crea Triggers, no instala Chains, Results ni dashboard, no construye imágenes, no crea registry, no guarda credenciales reales, no ejecuta `terraform apply`, no modifica `platform-api`, no cambia `platform-training` y no crea recursos cloud.

---

## Relación con la unidad

La Unidad 08 practica:

- instalación de Tekton Pipelines `v1.12.2` mediante release oficial versionada;
- definición de `Task`, `Pipeline` y `PipelineRun`;
- ejecución de validaciones Helm y Terraform sobre artefactos heredados;
- `volumeClaimTemplate` para Workspace temporal;
- Params y Results no sensibles;
- `when` para bloquear acciones mutantes;
- RBAC local mínimo para la ServiceAccount del pipeline.

Ten delante estos artefactos mientras lees:

| Artefacto | Ruta | Qué observar |
|---|---|---|
| Laboratorio operativo | `labs/08-tekton-continuous-integration/README.md` | Secuencia de instalación, ejecución, repetición y limpieza |
| Precondiciones Tekton | `labs/08-tekton-continuous-integration/tekton/namespace-or-prerequisites.md` | Versión, método oficial y namespace |
| ServiceAccount | `labs/08-tekton-continuous-integration/tekton/serviceaccount.yaml` | Identidad local del pipeline |
| RBAC | `labs/08-tekton-continuous-integration/tekton/rbac.yaml` | Permisos de lectura acotados |
| Tasks | `labs/08-tekton-continuous-integration/tekton/tasks.yaml` | Pasos modulares, Params, Results y scripts |
| Pipeline | `labs/08-tekton-continuous-integration/tekton/pipeline.yaml` | Orden, `when`, Workspaces y resultados agregados |
| PipelineRun | `labs/08-tekton-continuous-integration/tekton/pipelinerun.yaml` | Ejecución concreta y PVC temporal |
| Bundle local | `labs/08-tekton-continuous-integration/scripts/create-source-configmap.sh` | Adaptación local sin Git remoto ni credenciales |
| Validador | `labs/08-tekton-continuous-integration/validation/validate.sh` | Separación entre validación estática y funcional |

---

## Mapa conceptual

```text
Kubernetes API
  -> CRDs de Tekton declaran CI/CD
  -> controladores Tekton observan PipelineRuns
  -> PipelineRun instancia una Pipeline
  -> Pipeline crea TaskRuns
  -> TaskRun crea Pods efímeros
  -> Steps ejecutan containers
  -> Workspaces comparten archivos temporales
  -> Results publican datos pequeños no sensibles
  -> logs, condiciones y eventos explican la ejecución
```

Tekton no es "un Jenkins dentro de Kubernetes" en el sentido clásico. Su contrato principal no es una interfaz web ni un fichero de pipeline externo al clúster, sino recursos declarativos que Kubernetes almacena y que los controladores reconcilian.

La segunda distinción es entre integración continua y entrega continua. CI valida y prepara. CD muta entornos o reconcilia estado deseado. Esta unidad se queda deliberadamente en validación y plan para no mezclar `terraform apply`, state compartido, aprobaciones y GitOps antes de la Unidad 09.

---

## Conceptos y mecanismos

### Tekton como CRDs y controladores

Tekton instala CRDs bajo `tekton.dev`. A partir de ahí, `kubectl` puede crear objetos como:

```text
Task
Pipeline
TaskRun
PipelineRun
```

Qué resuelve: permite describir CI/CD con las mismas herramientas declarativas que el alumno ya usa para Kubernetes. Qué no resuelve: no aporta por sí solo estrategia de ramas, aprobaciones, secretos, registry, promoción ni observabilidad histórica.

El laboratorio instala solo Tekton Pipelines porque es el componente propietario de estas APIs. Triggers, Chains, Results y dashboard son componentes distintos con ciclos de vida propios.

### `Task`, `Step` y contenedores efímeros

Una `Task` define trabajo reutilizable. Cada `Step` usa una imagen de contenedor y ejecuta un script. En `tasks.yaml`, `platform-api-helm-validate` usa una imagen con Helm para ejecutar `helm lint` y `helm template`.

Qué resuelve: cada validación queda empaquetada con su runtime. Qué no resuelve: no elimina la necesidad de fijar versiones de imágenes, revisar supply chain o asegurar permisos.

Una Task no debería convertirse en una bolsa de comandos sin contrato. Si una tarea valida Helm, sus Params, Workspaces y Results deben expresar esa responsabilidad. Cuando una Task empieza a desplegar, borrar recursos, modificar state y publicar artefactos, probablemente está mezclando responsabilidades.

### `Pipeline`, orden y `when`

La `Pipeline` compone tareas. En la unidad, `terraform-plan` depende de `helm-validate`, y `apply-blocked` solo se activa cuando `execution_mode=apply`.

`when` no es una política de promoción completa. Es una condición declarativa útil para expresar ramas del grafo. La política real de promoción incluye ramas, tags, aprobaciones, ownership, entornos y auditoría; por eso se difiere a las Unidades 09 y 10.

### `PipelineRun` y `TaskRun`

La `Pipeline` es definición. El `PipelineRun` es ejecución. Tekton crea `TaskRun` para cada tarea ejecutada. Por eso el diagnóstico operativo suele mirar tres niveles:

```text
PipelineRun -> estado global
TaskRun -> tarea concreta
Pod/Step logs -> causa ejecutable
```

Un error frecuente es mirar solo la Pipeline y pensar que ahí vive el fallo. La Pipeline describe intención; el fallo casi siempre aparece en el TaskRun o en los logs de un Step.

### Workspaces y `volumeClaimTemplate`

Los Steps y Tasks son efímeros. Para compartir archivos, Tekton usa Workspaces. En esta unidad, el `PipelineRun` crea un PVC temporal mediante:

```yaml
volumeClaimTemplate:
  spec:
    accessModes:
      - ReadWriteOnce
    storageClassName: microk8s-hostpath
```

Qué resuelve: permite que `prepare-source` deje archivos para `helm-validate` y `terraform-plan`. Qué no resuelve: no es almacenamiento permanente ni repositorio de artefactos.

En producción, los artefactos de build suelen ir a registries, object storage, caches controladas o sistemas de resultados. Un PVC temporal local es suficiente para aprender el mecanismo, no para diseñar retención histórica.

### Params y Results

Los Params son entradas declarativas. En esta unidad controlan nombres como `platform-training`, `platform-api-local`, rutas del chart y modo de ejecución.

Los Results son salidas pequeñas. El laboratorio publica resultados como `helm-ok` o `terraform-plan-ok`. No deben contener secretos, planes completos, tokens ni logs extensos.

Tekton Results, como componente del ecosistema, resuelve retención y consulta histórica, pero queda fuera de esta unidad porque introduciría otro componente de clúster y observabilidad antes de tiempo.

### Fuente local sin credenciales

La unidad empaqueta los artefactos en un `ConfigMap` y lo monta como Workspace de solo lectura en el `PipelineRun`. Es una adaptación local para evitar repos remotos, tokens y webhooks. En un CI real, el pipeline normalmente obtiene fuente desde Git mediante un mecanismo autenticado, auditable y versionado.

Esta simplificación importa porque un pipeline sin fuente versionada no puede sostener trazabilidad productiva. Aquí la trazabilidad es pedagógica: el bundle procede de rutas exactas del repositorio local y excluye state, planes y `tfvars` locales.

### Terraform plan sin apply

`terraform plan -refresh=false` se ejecuta para practicar la revisión de cambios sin mutar recursos ni depender del state local no versionado. El punto no es producir el plan definitivo de producción; es demostrar que CI puede evaluar la configuración antes de que otra capa decida despliegue.

El `apply` queda fuera porque exige:

- state compartido protegido;
- locking;
- permisos mutantes;
- aprobación;
- ownership claro frente a GitOps;
- política de rollback;
- tratamiento de secretos.

La Unidad 09 resolverá la frontera operativa al introducir Argo CD.

---

## Criterios de decisión

### Cuándo usar Tekton

Usa Tekton cuando quieras que las tareas de CI/CD vivan cerca de Kubernetes, usen identidad del clúster, consuman Workspaces, se observen con `kubectl` y se integren con APIs Kubernetes.

No lo elijas solo porque "todo debe estar en Kubernetes". Si el equipo ya tiene un motor externo gobernado, con buenas integraciones, auditoría y secretos, Tekton debe competir por criterio operativo, no por estética.

### Tekton frente a `Job` y `CronJob`

`Job` ejecuta trabajo batch hasta completarlo. `CronJob` programa Jobs periódicos. Son recursos nativos de Kubernetes y encajan bien con tareas operativas acotadas, como una validación periódica o una copia de seguridad.

Tekton añade composición, Params, Results, Workspaces, grafo de tareas y trazabilidad de CI/CD. Si necesitas orquestar varias validaciones dependientes, publicar resultados y reutilizar tareas, Tekton expresa mejor el contrato. Si necesitas una tarea batch simple o periódica, `Job` o `CronJob` pueden ser suficientes.

Por decisión de curso, Unidad 08 los compara como criterio y Unidad 23 practicará Jobs/CronJobs en continuidad, backup, restore, runbooks y validaciones periódicas.

### Cuándo diferir build de imagen

Construir una imagen no es solo ejecutar `docker build`. Requiere Dockerfile o definición equivalente, usuario no root, tags inmutables, registry, credenciales, escaneo, firma, SBOM y política de promoción.

El curso todavía consume una imagen externa conocida para `platform-api`. Crear un build ahora obligaría a introducir una aplicación o estrategia de imagen no aprobada. Por eso queda como candidato avanzado y como continuidad hacia supply chain security.

### Qué permisos dar al pipeline

La ServiceAccount del laboratorio se usa como identidad de los `TaskRuns`: consume la fuente montada desde el `ConfigMap`, observa recursos acotados de `platform-training` y permite que Terraform use un kubeconfig efímero basado en el token montado por Kubernetes. No necesita `cluster-admin`, no necesita crear Deployments, no necesita borrar PVCs y no necesita secretos reales en manifests.

En producción, el criterio es separar identidad de lectura, validación, publicación de artefactos y despliegue. Cuanto más mutante sea una tarea, más fuerte debe ser su aislamiento, revisión y auditoría.

---

## Relación con el laboratorio

El laboratorio practica:

- Tekton Pipelines instalado desde release oficial versionada;
- Tasks, Pipeline, PipelineRun y TaskRuns observables;
- Workspace con PVC temporal por ejecución;
- Params simples;
- Results no sensibles;
- condición `when`;
- RBAC local mínimo;
- validación Helm;
- validación Terraform;
- `terraform plan` sin `apply`.

El laboratorio menciona, pero no practica:

- `Job` y `CronJob`: se practican en Unidad 23;
- Argo CD y GitOps: Unidad 09;
- `terraform apply` desde automatización compartida: Unidad 09 o posterior;
- gestión real de secretos en GitOps: Unidad 09;
- promoción entre entornos: Unidad 10;
- Tekton Triggers y webhooks: Unidad 10 o laboratorio avanzado;
- Tekton Chains, SBOM, firma y escaneo: Unidad 17;
- KEDA y escalado: Unidad 18;
- operación en AKS/EKS: Unidades 20-25;
- Tekton Operator: criterio de ciclo de vida, sin práctica troncal en esta unidad.

Restricción de la unidad: no modifiques el laboratorio para ejecutar `terraform apply` desde Tekton. Hacerlo adelanta una decisión de propiedad que el itinerario todavía no ha cerrado.

---

## Errores frecuentes

| Error | Por qué importa |
|---|---|
| Creer que Tekton reemplaza GitOps | Tekton ejecuta tareas; GitOps reconcilia estado deseado de forma continua |
| Tratar una Pipeline como un script largo | Se pierde modularidad, resultados, permisos y diagnóstico por Task |
| Asumir que CI debe aplicar Terraform | Sin state compartido, ownership y aprobación, `apply` desde CI puede crear drift o doble gobierno |
| Usar Workspaces como almacén permanente | Un PVC temporal no sustituye a registry, object storage ni Tekton Results |
| Poner secretos en Params o manifests | Los recursos quedan almacenados en el API server y pueden leerse con permisos |
| Dar `cluster-admin` al pipeline | Convierte un fallo de CI en riesgo de plataforma completa |
| Confundir Results con logs | Results son pequeños datos estructurados; los logs explican ejecución |
| Pensar que build de imagen es independiente del registry | Sin registry, tags y credenciales no hay cadena de entrega completa |
| Usar Triggers sin autenticar eventos | Un webhook expuesto puede convertirse en entrada no controlada al clúster |

---

## Continuidad

Unidad 09 retomará la frontera CI/GitOps. Argo CD se introducirá como reconciliador declarativo y deberá resolver cómo convive con Terraform y Helm sin que dos sistemas gobiernen indefinidamente el mismo release.

Unidad 10 retomará promoción entre entornos, ramas, tags, overlays y posible relación con eventos de CI. Tekton Triggers podrá revisarse allí o quedar como laboratorio avanzado.

Unidad 17 retomará supply chain security: SBOM, escaneo, firma, provenance, admisión y posible Tekton Chains.

Unidad 18 retomará escalado y capacidad, incluyendo KEDA, pero no como parte de este pipeline inicial.

Unidad 23 retomará `Job` y `CronJob` como práctica ejecutable vinculada a backup, restore, runbooks y validaciones periódicas.

Unidades 20-25 trasladarán decisiones de CI/CD a AKS/EKS, donde identidad, registry, storage, red y permisos cambian de forma sustancial.

---

## Fuentes de referencia

| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
| [Tekton Pipelines installation](https://tekton.dev/vault/pipelines-main/install/) | Instalación de release oficial y manifiestos versionados | ¿Por qué el laboratorio no usa `latest`? |
| [Tekton Pipelines v1.12.0 LTS](https://tekton.dev/blog/2026/05/04/tekton-pipelines-v1.12.0-lts-notifications-controllers-security-hardening-and-performance/) | Anuncio de la línea LTS `v1.12` y soporte | ¿Por qué se eligió la línea `v1.12` frente a una release posterior? |
| [Tekton Pipelines v1.12.2](https://github.com/tektoncd/pipeline/releases/tag/v1.12.2) | Patch LTS seleccionado y one-liner de instalación | ¿Qué URL versionada instala exactamente el laboratorio? |
| [Tekton Pipelines releases](https://github.com/tektoncd/pipeline/releases) | Releases versionadas y notas | ¿Qué debería revisar antes de actualizar Tekton? |
| [Tekton Tasks](https://tekton.dev/docs/pipelines/tasks/) | Modelo de Task, Step, Params y Results | ¿Dónde termina la definición y dónde empieza la ejecución? |
| [Tekton Pipelines](https://tekton.dev/docs/pipelines/pipelines/) | Pipeline, PipelineRun y grafo de tareas | ¿Cómo se compone trabajo sin escribir un script monolítico? |
| [Tekton Workspaces](https://tekton.dev/docs/pipelines/workspaces/) | Workspaces y volúmenes | ¿Qué problema resuelve un Workspace y qué no debe guardar? |
| [Kubernetes Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) | Job como batch nativo | ¿Cuándo basta un Job en lugar de Tekton? |
| [Kubernetes CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) | Ejecución periódica nativa | ¿Por qué la práctica de CronJob encaja mejor en Unidad 23? |
