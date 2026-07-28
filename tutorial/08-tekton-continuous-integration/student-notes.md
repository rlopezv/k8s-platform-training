# Student notes - Unidad 08

## Propósito

Estas notas explican Tekton desde el problema real del curso: ya tenemos scripts y comandos locales para validar `platform-api`, pero queremos que esa validación sea una ejecución declarativa dentro del clúster.

La idea central es:

```text
Tekton ejecuta trabajo de CI dentro de Kubernetes.
Helm sigue empaquetando.
Terraform sigue planificando.
Argo CD todavía no existe en esta unidad.
```

## Qué se va a cubrir

| Bloque | Qué aporta | Nivel en esta unidad |
|---|---|---|
| Tekton Pipelines | Motor CI/CD Kubernetes-native | Práctico |
| `Task` y `Step` | Unidad modular de trabajo | Práctico |
| `Pipeline` | Composición ordenada de tareas | Práctico |
| `PipelineRun` y `TaskRun` | Ejecución concreta | Práctico |
| Workspace | Estado temporal compartido | Práctico |
| Params | Entradas declarativas | Práctico |
| Results | Salidas no sensibles | Práctico |
| `when` | Condición declarativa | Práctico |
| `Job` y `CronJob` | Comparativa de criterio | Referencia |
| Triggers, Chains, build y registry | Continuidad profesional | Referencia |

No se cubren Argo CD, Tekton Triggers, Tekton Chains, Tekton Results, dashboard, build de imagen, registry, credenciales reales, `terraform apply`, AKS ni EKS. La referencia `tutorial/08-tekton-continuous-integration/student-reference.md` explica el destino de esas exclusiones y mantiene cerrada la parte de `GAP-004` sobre Jobs/CronJobs como criterio comparativo.

## Qué representa cada componente

| Componente | Qué representa | Qué problema resuelve | Qué no es |
|---|---|---|---|
| CRD de Tekton | Nueva API dentro de Kubernetes | Permite declarar CI como recursos | No es un servicio SaaS externo |
| `Task` | Receta reutilizable de pasos | Encapsula una validación | No es una ejecución concreta |
| `Step` | Contenedor dentro de una Task | Ejecuta un comando acotado | No comparte filesystem salvo por volumen |
| `Pipeline` | Grafo de tareas | Ordena trabajo y dependencias | No ejecuta nada por sí sola |
| `PipelineRun` | Instancia de ejecución | Materializa una Pipeline | No es definición reutilizable |
| `TaskRun` | Ejecución de una Task | Permite inspeccionar estado y logs | No se escribe a mano normalmente |
| Workspace | Volumen compartido | Pasa archivos entre tareas | No es almacén permanente |
| Param | Entrada de configuración | Evita editar YAML para cada ejecución | No debe transportar secretos reales |
| Result | Salida pequeña | Expone datos no sensibles | No es sistema histórico de trazabilidad |
| `when` | Condición declarativa | Omite tareas según contexto | No reemplaza aprobaciones reales |

## Qué vas a construir

Construirás una pipeline llamada `platform-api-ci` en `platform-training`.

La ejecución hará:

```text
ConfigMap con fuente local
  -> prepare-source
  -> repository-preflight
  -> helm-validate
  -> terraform-plan
  -> results no sensibles
```

El `PipelineRun` crea un PVC temporal con `volumeClaimTemplate` para compartir la copia de los artefactos entre tareas.

## Cómo se relacionan las piezas

Tekton no puede leer automáticamente el directorio local del alumno. En un CI productivo, la fuente vendría de Git mediante credenciales, webhooks o resolvers. Esta unidad evita ese salto: `create-source-configmap.sh` empaqueta únicamente el chart Helm y el proyecto Terraform en un `ConfigMap` local.

Dentro del clúster:

```text
Task prepare-source
  recibe el ConfigMap como Workspace de solo lectura
  descomprime el bundle
  escribe en el Workspace

Task repository-preflight
  comprueba rutas esperadas

Task helm-validate
  ejecuta helm lint y helm template

Task terraform-plan
  ejecuta fmt, init, validate y plan sin refresh

Task apply-blocked
  solo se activa si execution_mode=apply
  falla de forma intencional
```

`terraform plan -refresh=false` se usa porque el Workspace no contiene el state local no versionado de la Unidad 07. La unidad practica la mecánica de CI y el plan no mutante; no intenta adoptar ni aplicar infraestructura desde dentro del clúster.

## Qué ocurre al aplicar los manifiestos

Cuando instalas Tekton, Kubernetes registra CRDs como `tasks.tekton.dev`, `pipelines.tekton.dev`, `taskruns.tekton.dev` y `pipelineruns.tekton.dev`. A partir de ese momento, el API server acepta esos recursos y los controladores de Tekton los reconcilian.

Cuando aplicas `Task` y `Pipeline`, solo guardas definiciones. Cuando aplicas `PipelineRun`, Tekton crea `TaskRun` y Pods efímeros. Cada Step se ejecuta como contenedor y escribe sus resultados en rutas especiales que Tekton recoge al finalizar.

El PVC temporal permite que una tarea prepare archivos y otra los consuma. Sin ese Workspace, cada Task tendría su propio filesystem efímero y no vería los archivos preparados por la anterior.

## Cómo comprobar que funciona

Instalación:

```bash
kubectl -n tekton-pipelines wait --for=condition=Available deployment --all --timeout=300s
kubectl api-resources --api-group=tekton.dev
```

Definiciones:

```bash
kubectl -n platform-training get tasks,pipelines
```

Ejecución:

```bash
kubectl -n platform-training get pipelinerun platform-api-ci-run
kubectl -n platform-training get taskrun -l tekton.dev/pipelineRun=platform-api-ci-run
kubectl -n platform-training describe pipelinerun platform-api-ci-run
```

Logs:

```bash
kubectl -n platform-training logs -l tekton.dev/pipelineRun=platform-api-ci-run --all-containers=true --prefix=true
```

Results:

```bash
kubectl -n platform-training get pipelinerun platform-api-ci-run -o jsonpath='{.status.results}'
```

## Cómo diagnosticar los 4 fallos típicos

Esta sección trata fallos del laboratorio. Los errores de modelo mental, como creer que Tekton reemplaza GitOps o que un Workspace es almacenamiento permanente, están en `tutorial/08-tekton-continuous-integration/student-reference.md`.

### 1. Kubernetes no reconoce `Task` o `Pipeline`

Síntoma: `no matches for kind "Task"`.

Comprueba:

```bash
kubectl api-resources --api-group=tekton.dev
kubectl -n tekton-pipelines get deploy
```

Idea clave: los CRDs de Tekton deben existir antes de aplicar recursos Tekton.

### 2. La fuente local no existe dentro del pipeline

Síntoma: `source bundle not mounted from ConfigMap`.

Comprueba:

```bash
kubectl -n platform-training get configmap platform-api-ci-source
```

Recuperación:

```bash
bash labs/08-tekton-continuous-integration/scripts/create-source-configmap.sh
```

Idea clave: el clúster no ve tu filesystem local. Hay que entregar la fuente al pipeline mediante un mecanismo explícito.

### 3. Un TaskRun falla

Síntoma: el `PipelineRun` termina `Failed`.

Comprueba:

```bash
kubectl -n platform-training describe pipelinerun platform-api-ci-run
kubectl -n platform-training get taskrun -l tekton.dev/pipelineRun=platform-api-ci-run
kubectl -n platform-training logs -l tekton.dev/taskRun=<taskrun-name> --all-containers=true
```

Idea clave: la unidad de diagnóstico real suele ser el `TaskRun`, no solo la Pipeline.

### 4. El modo `apply` falla

Síntoma: `apply-blocked` termina con error.

Comprueba:

```bash
kubectl -n platform-training describe pipelinerun platform-api-ci-run
```

Idea clave: es el comportamiento esperado. La Unidad 08 bloquea acciones mutantes para no adelantar ownership, state compartido, aprobaciones y GitOps.

## Qué debes recordar para la Unidad 09

Tekton ha quedado como motor de CI: valida, prepara y produce resultados. Argo CD aparecerá después como reconciliador GitOps.

La frontera importante es:

- CI responde si los artefactos son válidos y qué plan producirían;
- Helm mantiene el paquete de `platform-api`;
- Terraform conserva el lenguaje de planificación de infraestructura;
- GitOps decidirá cómo reconciliar continuamente el estado deseado.

## Fuentes de referencia

| Fuente | Qué leer | Para qué sirve |
|---|---|---|
| [Tekton Pipelines - Install](https://tekton.dev/vault/pipelines-main/install/) | Instalación por release oficial | Ver la diferencia entre `latest` y release versionada |
| [Tekton Pipelines - Pipelines](https://tekton.dev/docs/pipelines/pipelines/) | `Pipeline`, `PipelineRun` y tareas | Relacionar definición y ejecución |
| [Tekton Pipelines - Tasks](https://tekton.dev/docs/pipelines/tasks/) | `Task`, `Step`, Params y Results | Leer `tasks.yaml` con criterio |
| [Tekton Pipelines - Workspaces](https://tekton.dev/docs/pipelines/workspaces/) | Workspaces y PVCs | Entender el estado temporal compartido |
| [Tekton Pipelines - Variables](https://tekton.dev/docs/pipelines/variables/) | Sustitución de valores | Interpretar `$(params...)` y `$(results...)` |
