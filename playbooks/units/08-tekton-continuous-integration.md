# Playbook de la Unidad 08 - Integracion continua con Tekton

## Identificacion

### Unidad

```text
08 - Integracion continua con Tekton
```

### Identificador

```text
08-tekton-continuous-integration
```

### Fase del roadmap

```text
Fase 4 - Entrega continua y GitOps
```

### Estado del playbook

```text
Borrador generado; pendiente de revision y aprobacion del usuario
```

### Propietario logico

```text
CI/CD
```

---

# Proposito de la unidad

La Unidad 08 introduce Tekton Pipelines como motor Kubernetes-native de integracion continua para la solucion evolutiva `platform-api`. La unidad parte del chart Helm validado en la Unidad 06 y del proyecto Terraform local validado en la Unidad 07, y traslada las comprobaciones repetibles del repositorio a un pipeline ejecutado dentro del cluster.

Tekton aparece antes de Argo CD porque primero se necesita un flujo de CI capaz de validar artefactos, producir resultados y preparar una nueva version sin convertir el despliegue en una secuencia imperativa. La unidad debe dejar claro que Tekton orquesta tareas de integracion continua, mientras Helm sigue empaquetando, Terraform sigue declarando el release local y la entrega continua basada en GitOps queda para la Unidad 09.

## Supuesto pedagogico

La unidad se escribe para alumnos con perfil tecnico que ya han usado Kubernetes, Helm y Terraform en el curso, pero que todavia no dominan CI/CD nativo de Kubernetes, CRDs de Tekton, Tasks, Pipelines, Workspaces, Params, Results, PipelineRuns, ServiceAccounts de pipeline ni el reparto de responsabilidades entre CI y GitOps.

Se explican desde cero:

- que problema resuelve Tekton frente a scripts locales y pipelines SaaS externos;
- que representan `Task`, `Step`, `Pipeline`, `PipelineRun`, `TaskRun`, `Workspace`, `Param`, `Result` y `when`;
- como Tekton usa CRDs, Pods efimeros y containers para ejecutar trabajo dentro de Kubernetes;
- como se comparte estado temporal entre tareas mediante Workspaces;
- como un `PipelineRun` materializa una ejecucion concreta de una definicion declarativa;
- como leer estado, condiciones, logs y eventos de `TaskRun` y `PipelineRun`;
- como separar validacion y plan Terraform sin ejecutar `apply` desde CI en esta unidad;
- como pensar en ServiceAccounts, RBAC y permisos minimos en un laboratorio local.

Se retoman de unidades anteriores:

- `platform-api` como aplicacion evolutiva;
- namespace funcional `platform-training`;
- chart Helm local `labs/06-helm-packaging/chart/platform-api/`;
- release Helm `platform-api-local`;
- proyecto Terraform local `labs/07-local-terraform-automation/terraform/`;
- validaciones existentes de Helm, Terraform y Kubernetes;
- Secret ficticio de laboratorio, PVC, Service, Ingress, PDB, probes, resources y rollout;
- la frontera de propiedad registrada en la Unidad 07 entre Terraform y GitOps.

Se mencionan solo para continuidad:

- Argo CD, GitOps y sincronizacion continua;
- promocion formal entre entornos;
- progressive delivery, canary, blue-green, Argo Rollouts y Flagger;
- firma, provenance, SBOM, escaneo de imagenes y supply chain security;
- Tekton Chains, Tekton Triggers, Tekton Results, dashboard y operadores;
- build productivo de imagenes con registry, credenciales y estrategia de tags;
- ServiceAccounts corporativas, identidad federada, OIDC y permisos de plataforma reales.

Errores de razonamiento que debe prevenir `student-reference.md`:

- creer que Tekton reemplaza GitOps o que debe hacer reconciliacion continua;
- convertir un pipeline en una coleccion de comandos imperativos sin contrato declarativo;
- asumir que un pipeline de CI debe ejecutar `terraform apply` antes de resolver ownership, state y aprobaciones;
- tratar Workspaces como almacenamiento permanente de artefactos;
- usar ServiceAccounts amplias por comodidad;
- guardar tokens, kubeconfigs o credenciales reales en manifests;
- creer que construir una imagen es solo ejecutar un comando, sin registry, tags, credenciales y politica de promocion;
- confundir resultados de CI con aprobacion pedagogica o validacion productiva.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno debera ser capaz de:

- instalar Tekton Pipelines en el cluster local usando el metodo oficial y una version fija verificada;
- explicar como Tekton extiende Kubernetes mediante CRDs y controladores;
- definir Tasks modulares para validar artefactos de `platform-api`;
- componer una Pipeline que ejecute validacion de repositorio, Helm y Terraform en orden controlado;
- configurar Workspaces con PVC temporal por `PipelineRun`;
- parametrizar la ejecucion con Params y publicar Results no sensibles;
- ejecutar e inspeccionar PipelineRuns y TaskRuns;
- leer logs, condiciones, eventos y estado de ejecucion para diagnosticar fallos;
- aplicar una condicion `when` sencilla para separar validacion de acciones mutantes;
- justificar que queda en CI, que queda en Terraform, que queda en Helm y que quedara en GitOps con Argo CD.

---

# Alcance

## Incluido

- instalacion de Tekton Pipelines como componente de cluster en `tekton-pipelines`, solo al generar la unidad aprobada;
- catalogacion del ciclo de vida de Tekton en `platform/tools/` y en el README del laboratorio;
- verificacion de version vigente contra fuentes oficiales antes de fijarla en los artefactos;
- Tasks de laboratorio para inspeccionar repositorio, ejecutar validaciones Helm y ejecutar validaciones Terraform;
- Pipeline compuesta por Tasks modulares;
- PipelineRun reproducible para el entorno local;
- Workspaces para compartir el workspace de trabajo entre Tasks;
- `volumeClaimTemplate` en PipelineRun para PVC temporal de ejecucion;
- Params basicos para namespace, release, chart path, ruta Terraform y modo de ejecucion;
- Results no sensibles para exponer revision, estado de validacion o salida resumida;
- uso basico de `when` para evitar acciones mutantes cuando el modo sea solo validacion;
- ServiceAccount y RBAC de laboratorio con permisos minimos razonables para ejecutar el pipeline;
- validacion de manifiestos, chart Helm y configuracion Terraform heredada;
- plan Terraform controlado como practica;
- `terraform apply` desde pipeline excluido de Unidad 08;
- comparativa conceptual de `Job`/`CronJob` frente a Tasks y TaskRuns como criterio de referencia, sin practica ejecutable en el laboratorio troncal;
- referencia del alumno conforme a `playbooks/student-reference-template.md`.

## Excluido

- instalacion de Tekton antes de aprobar este playbook;
- creacion de recursos ejecutables de Unidad 08 antes de aprobar este playbook;
- Argo CD, GitOps y reconciliacion continua;
- Tekton Triggers, EventListeners, TriggerTemplates y webhooks reales;
- Tekton Chains, firma, attestations, provenance y SBOM;
- Tekton Results, dashboard, notifications y observabilidad avanzada;
- instalacion mediante Tekton Operator;
- ejecucion de `terraform apply` desde Tekton;
- build productivo de imagen de `platform-api`;
- registry local, registry remoto, credenciales de pull/push o secretos reales;
- ServiceAccounts corporativas reales, OIDC, workload identity o integraciones con proveedores;
- Azure Pipelines, GitHub Actions, Jenkins u otros motores como practica ejecutable;
- publicacion de charts en repositorios remotos u OCI;
- promocion formal entre entornos;
- progressive delivery;
- AKS, EKS o recursos cloud;
- sustitucion de `platform-api`;
- cambio del namespace funcional `platform-training`;
- introduccion de Minikube, kind o Docker Desktop Kubernetes.

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| Argo CD y GitOps | Unidad 09 | La reconciliacion continua debe separarse de CI y resolver el ownership frente a Terraform |
| `terraform apply` desde automatizacion compartida | Unidad 09 o posterior | Requiere decidir ownership, aprobaciones, state y frontera con GitOps antes de mutar desde CI |
| Gestion real de secretos en GitOps | Unidad 09 | `GAP-002` la ancla a GitOps y no debe resolverse con secrets reales en Tekton |
| Promocion formal entre entornos | Unidad 10 | Requiere CI inicial y GitOps operativos |
| Progressive delivery | Unidad 10 como referencia; practica posterior | `GAP-005` requiere observabilidad y criterios SLI/SLO |
| Tekton Triggers y webhooks | Unidad 10 o laboratorio avanzado | Requiere fuente de eventos, autenticacion y exposicion HTTP segura |
| Tekton Chains, provenance, firma y SBOM | Unidad 17 | Encaja con supply chain security y politicas de admision |
| Escaneo de imagenes | Unidad 17 | Requiere estrategia de imagen y seguridad de supply chain |
| HPA, KEDA y escalado de pipelines/workloads | Unidad 18 | Pertenece a escalado y capacidad |
| Desacoplamiento formal de MicroK8s | Unidad 19 | Sera el puente hacia AKS/EKS |
| Operacion CI/CD en AKS/EKS | Unidades 20-25 | Requiere identidad, registry, storage y red cloud |
| Practica ejecutable de `Job` y `CronJob` | Unidad 23 | Encaja con backup, restore, runbooks y validaciones periodicas de continuidad; Unidad 08 solo los compara con Tekton |

## Candidatos a laboratorio avanzado

| Candidato | Motivo | Destino inicial |
|---|---|---|
| Build de imagen de `platform-api` con Kaniko, BuildKit o herramienta equivalente y push a registry | El repositorio no contiene `Dockerfile`, registry ni estrategia de credenciales; practicarlo en el tronco cambiaria el alcance de Unidad 08 | Registrar como candidato avanzado de Unidad 08; posible conexion con Unidad 17 |
| Tekton Triggers con webhook real | Requiere exposicion HTTP, autenticacion de eventos y seguridad de secretos | Registrar como candidato avanzado de Unidad 08 o revisar al generar Unidad 10 |
| ServiceAccounts corporativas con identidad real | Depende de proveedor, politicas corporativas y secretos que el laboratorio no debe guardar | Criterio profesional; no laboratorio local hasta unidades cloud o seguridad |

---

# Cobertura documental de la unidad

## Frontera entre `student-notes.md` y `student-reference.md`

`student-notes.md` explica lo que el alumno necesita para completar el laboratorio: que se instala, que representa cada CRD practicada, como se compone el pipeline, como se ejecuta un PipelineRun, como se leen logs y condiciones, como se usan Workspaces, Params, Results y `when`, y como diagnosticar fallos operativos.

`student-reference.md` explica lo que existe fuera del laboratorio y corrige modelos mentales: arquitectura interna de Tekton, relacion con Kubernetes Jobs y Pods, limites de Workspaces, seguridad de ServiceAccounts, catalogo de componentes del ecosistema Tekton, frontera CI/GitOps, estrategia de imagenes, credenciales, eventos, supply chain y diferencias con motores externos como Azure Pipelines.

No debe duplicarse contenido. Si ambos documentos necesitan un tema, uno lo desarrolla y el otro lo cita por ruta.

## Laguna asignada

| ID | Tratamiento en esta unidad | Cierre esperado |
|---|---|---|
| `GAP-004` | La unidad no practica `Job` ni `CronJob`; los cubre como criterio comparativo frente a Tasks, TaskRuns y PipelineRuns para no mezclar el tronco Tekton con workloads batch nativos | Mantener `GAP-004` cerrada por Unidad 01 y Unidad 04; la practica ejecutable de `Job`/`CronJob` queda diferida a Unidad 23 y no bloquea Unidad 08 |

`GAP-010` no se cierra aqui: la Unidad 08 debe respetar la frontera declarada en Unidad 07 y preparar la resolucion operativa de propiedad para Unidad 09.

## Tipos de cobertura requeridos para `student-reference.md`

| Tipo | Aplicacion en la Unidad 08 |
|---|---|
| Panorama | Situar Tekton frente a Kubernetes, Helm, Terraform, Argo CD, Azure Pipelines y GitOps |
| Profundidad | Explicar Tasks, Pipelines, Runs, Workspaces, Params, Results, condiciones y Pods efimeros hasta poder leer los manifests del laboratorio |
| Criterio | Decidir que debe validarse en CI, que no debe mutarse sin aprobacion, que permisos necesita el pipeline y cuando diferir build o triggers |
| Practica | Nombrar distancias con produccion: MicroK8s local, PVC temporal, secretos ficticios, ausencia de registry, ausencia de webhook y ausencia de identidad corporativa |

## Simplificaciones que obligan a practica profesional

| Simplificacion del laboratorio | Riesgo fuera del laboratorio | Alternativa profesional que debe explicar la referencia |
|---|---|---|
| Tekton instalado directamente con `release.yaml` | Sin gestion de ciclo de vida avanzada ni operador | Gestion de upgrades, compatibilidad de CRDs, pruebas previas y runbook de retirada |
| PVC temporal local para Workspaces | Rendimiento y persistencia dependen de MicroK8s y `hostpath` | StorageClass gestionada, limpieza automatizada y politicas de retencion |
| Tasks locales versionadas en el repo | No hay catalogo corporativo ni versionado compartido | Catalogo interno, bundles, resolvers o convenciones de plataforma |
| Params basicos | No cubre contratos complejos entre equipos | Esquemas, convenciones de nombres y validacion en pipelines corporativos |
| Results no sensibles | Limite de tamano y retencion; no son sistema de trazabilidad historica | Tekton Results, observabilidad y almacen de artefactos |
| `when` sobre modo o rama simulada | No equivale a politica de promocion | Politicas de branch/tag, aprobaciones, GitOps y entornos |
| Sin build de imagen | No valida Dockerfile, registry ni supply chain | Build reproducible, tags inmutables, firma, SBOM, escaneo y registry autenticado |
| ServiceAccount de laboratorio | Puede quedar demasiado amplia o demasiado local | RBAC minimo por namespace, identidad federada, rotacion y auditoria |

## Uso de `.work/detail.md`

La seccion `08 | Integracion continua con Tekton` de `.work/detail.md` se usa como checklist auxiliar y entrada explicita del usuario, no como fuente de verdad. Sus puntos se reparten asi:

| Punto de `detail` | Clasificacion | Tratamiento en Unidad 08 |
|---|---|---|
| Arquitectura basada en CRDs de Kubernetes | Criterio y practica | La referencia explica el modelo; el laboratorio instala Tekton y observa sus CRDs/controladores |
| `Task`, `Pipeline`, `TaskRun` y `PipelineRun` | Practica | Se crean Tasks, Pipeline y PipelineRun; TaskRuns se inspeccionan como resultado de ejecucion |
| Workspaces con PVCs locales | Practica | El pipeline comparte estado mediante Workspace |
| `volumeClaimTemplate` por PipelineRun | Practica | Se usa PVC temporal por ejecucion, con ciclo de vida documentado |
| Tareas modulares de clonado, linter, tests y build de imagen | Practica parcial, criterio y diferido | Se practican tareas modulares de validacion; clonado se adapta al repositorio disponible; build de imagen se difiere por falta de Dockerfile/registry/credenciales |
| Params estructurados `array` y `object` | Criterio | La practica usa params simples; la referencia explica params estructurados y sus limites |
| Results para alimentar pasos condicionales | Practica parcial | Se publican results no sensibles; su uso avanzado en condiciones queda como criterio |
| Expresiones `when` por rama o tag | Practica y criterio | Se practica una condicion sencilla; rama/tag reales quedan condicionados por el mecanismo de fuente de codigo |
| ServiceAccounts corporativas con minimo privilegio | Criterio y diferido | Se practica RBAC minimo local; identidad corporativa real se difiere a seguridad/cloud |

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `README.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `project/how-to.md`;
6. `project/project-planning.md`;
7. `project/content-gap-register.md`;
8. `project/advanced-labs-register.md`;
9. `platform/tools/README.md`;
10. `playbooks/master.md`;
11. `playbooks/unit-template.md`;
12. `playbooks/student-reference-template.md`;
13. `playbooks/summary-template.md`;
14. `playbooks/project-state-template.md`;
15. `playbooks/units/07-local-terraform-automation.md`;
16. `tutorial/07-local-terraform-automation/summary.md`;
17. este playbook;
18. `.work/detail.md`, solo seccion de Unidad 08 y solo como checklist de cobertura;
19. `labs/06-helm-packaging/chart/platform-api/`;
20. `labs/06-helm-packaging/validation/validate.sh`;
21. `labs/07-local-terraform-automation/terraform/`;
22. `labs/07-local-terraform-automation/validation/validate.sh`;
23. documentacion oficial de Tekton Pipelines y releases oficiales para fijar version, URL de instalacion y requisitos Kubernetes.

## Excepciones

Ninguna. La Unidad 07 existe y deja `tutorial/07-local-terraform-automation/summary.md`, `labs/07-local-terraform-automation/terraform/` y `labs/07-local-terraform-automation/validation/validate.sh` como base prevista para Unidad 08.

---

# Dependencias

## Dependencias documentales

- contrato documental cerrado en `playbooks/student-reference-template.md`;
- reglas de componentes de cluster en `platform/tools/README.md`;
- summary de la Unidad 07;
- registro de lagunas para mantener cerrado `GAP-004` y respetar `GAP-010`;
- registro de laboratorios avanzados para anotar candidatos detectados durante el reparto;
- seccion de Unidad 08 de `.work/detail.md` como checklist auxiliar declarado por el usuario.

## Dependencias tecnicas

| Dependencia | Estado requerido | Metodo de comprobacion |
|---|---|---|
| MicroK8s | Instalado y operativo segun estado ya registrado | `microk8s status --wait-ready` |
| Kubernetes local | Nodo `Ready` segun estado ya registrado | `kubectl get nodes` |
| `kubectl` | Cliente operativo contra MicroK8s | `kubectl version --client` |
| Helm | CLI disponible y chart de Unidad 06 validable | `helm version --short` y `helm lint labs/06-helm-packaging/chart/platform-api` |
| Terraform | CLI disponible y proyecto de Unidad 07 validable | `terraform version` y `terraform -chdir=labs/07-local-terraform-automation/terraform validate` |
| Chart `platform-api` | Disponible | `test -f labs/06-helm-packaging/chart/platform-api/Chart.yaml` |
| Proyecto Terraform Unidad 07 | Disponible | `test -f labs/07-local-terraform-automation/terraform/main.tf` |
| Tekton Pipelines | No instalado antes de aprobar el playbook | `kubectl get namespace tekton-pipelines` debe fallar o quedar documentado como no incorporado antes de la unidad |
| Version Tekton | LTS vigente verificada contra fuente oficial antes de fijar artefactos | Documentacion oficial de Tekton y release oficial versionado |

Durante la generacion de este playbook no se instala Tekton ni se crean recursos ejecutables de Unidad 08.

## Dependencias pedagogicas

El alumno debe haber completado o dominar:

- Unidad 00: entorno local, `kubectl`, Helm y Terraform como CLIs;
- Unidad 01: Pods, Deployments, ReplicaSets, Services, labels, selectors, logs y eventos;
- Unidad 02: ConfigMaps, Secrets ficticios, probes, requests y limits;
- Unidad 03: Service, EndpointSlice e Ingress;
- Unidad 04: PVC, StorageClass local, persistencia y `volumeClaimTemplates` como criterio/practica auxiliar;
- Unidad 05: rollout, PDB, replicas, scheduling y mantenimiento basico;
- Unidad 06: chart Helm, templates, values, release, upgrade y rollback;
- Unidad 07: Terraform local, providers, `helm_release`, state, plan, apply, import y frontera Terraform/GitOps.

## Dependencias del laboratorio

Artefactos que deben existir antes de generar la unidad:

```text
tutorial/07-local-terraform-automation/summary.md
labs/06-helm-packaging/chart/platform-api/
labs/06-helm-packaging/validation/validate.sh
labs/07-local-terraform-automation/terraform/
labs/07-local-terraform-automation/validation/validate.sh
platform/tools/README.md
```

---

# Estado inicial esperado

La unidad parte de un repositorio con Unidades 00-07 completadas, `platform-api` empaquetada como chart Helm local y el release `platform-api-local` gestionado por Terraform local. El namespace funcional sigue siendo `platform-training`. Tekton no esta incorporado todavia.

Estado verificable esperado:

- MicroK8s, Kubernetes, `kubectl`, Helm y Terraform figuran como validados en `project/project-state.md`;
- `labs/06-helm-packaging/chart/platform-api/Chart.yaml` existe;
- `labs/07-local-terraform-automation/terraform/main.tf` declara `helm_release.platform_api`;
- `labs/07-local-terraform-automation/validation/validate.sh` existe;
- `platform/tools/README.md` contiene la fila de Tekton Pipelines como componente pendiente de Unidad 08;
- no existe contenido versionado en `tutorial/08-tekton-continuous-integration/` ni `labs/08-tekton-continuous-integration/` antes de generar la unidad;
- no se han creado recursos Tekton de Unidad 08 antes de aprobar este playbook;
- los secretos versionados son ficticios y no se introducen credenciales reales.

## Validacion del estado inicial

Comprobaciones documentales y estaticas permitidas antes de aprobar este playbook:

```bash
test -f tutorial/07-local-terraform-automation/summary.md
test -f labs/06-helm-packaging/chart/platform-api/Chart.yaml
test -f labs/07-local-terraform-automation/terraform/main.tf
test -f labs/07-local-terraform-automation/validation/validate.sh
test -f platform/tools/README.md
```

Comprobaciones funcionales previstas al generar la unidad, no al crear este playbook:

```bash
microk8s status --wait-ready
kubectl get nodes
kubectl version --client
helm version --short
terraform version
helm lint labs/06-helm-packaging/chart/platform-api
terraform -chdir=labs/07-local-terraform-automation/terraform validate
```

Resultado esperado:

```text
La plataforma local, Helm, Terraform y los artefactos heredados estan disponibles; Tekton se instala solo dentro de la Unidad 08 aprobada.
```

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| Summary Unidad 07 | `tutorial/07-local-terraform-automation/summary.md` | Continuidad tecnica y frontera con Terraform/GitOps |
| Chart Helm Unidad 06 | `labs/06-helm-packaging/chart/platform-api/` | Artefacto a validar desde CI |
| Validacion Unidad 06 | `labs/06-helm-packaging/validation/validate.sh` | Comprobacion funcional heredada cuando proceda |
| Proyecto Terraform Unidad 07 | `labs/07-local-terraform-automation/terraform/` | Configuracion a validar y planificar desde Tekton |
| Validacion Unidad 07 | `labs/07-local-terraform-automation/validation/validate.sh` | Base de comprobaciones Terraform/Helm/Kubernetes |
| Catalogo de componentes | `platform/tools/README.md` | Ciclo de vida de Tekton como componente de cluster |
| Registro de lagunas | `project/content-gap-register.md` | Mantener decisiones `GAP-004` y `GAP-010` |
| Registro de laboratorios avanzados | `project/advanced-labs-register.md` | Registrar candidatos derivados de cobertura no practicada |

## Reglas de reutilizacion

- conservar `platform-api`;
- conservar `platform-training`;
- conservar `platform-api-local`;
- no duplicar el chart Helm;
- no crear un proyecto Terraform alternativo;
- no convertir Tekton en sustituto de Helm o Terraform;
- mantener Secrets ficticios y no introducir credenciales reales;
- no borrar `platform-api-data` como parte normal del pipeline;
- no instalar Argo CD ni resolver GitOps en esta unidad;
- no instalar Tekton Triggers, Chains, Results, dashboard u operador en el tronco de la unidad;
- no crear `Dockerfile`, registry ni flujo de build de imagen en el tronco sin decision documentada.

---

# Cambios previstos sobre la solucion

## Componentes nuevos

| Componente | Ruta prevista | Responsabilidad |
|---|---|---|
| Tutorial Unidad 08 | `tutorial/08-tekton-continuous-integration/README.md` | Puerta de entrada de la unidad |
| Student notes | `tutorial/08-tekton-continuous-integration/student-notes.md` | Guia de aprendizaje |
| Student reference | `tutorial/08-tekton-continuous-integration/student-reference.md` | Referencia profesional de Tekton y CI/CD |
| Instructor notes | `tutorial/08-tekton-continuous-integration/instructor-notes.md` | Guia de imparticion |
| Summary Unidad 08 | `tutorial/08-tekton-continuous-integration/summary.md` | Continuidad hacia Argo CD |
| Laboratorio Unidad 08 | `labs/08-tekton-continuous-integration/README.md` | Procedimiento operativo |
| Manifiestos Tekton | `labs/08-tekton-continuous-integration/tekton/` | Tasks, Pipeline, PipelineRun, ServiceAccount y RBAC |
| Validacion | `labs/08-tekton-continuous-integration/validation/validate.sh` | Comprobacion estatica y funcional de la unidad |
| Catalogo actualizado | `platform/tools/README.md` | Version, metodo, namespace, persistencia y limpieza de Tekton |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| `project/project-state.md` | Registrar Unidad 08 generada, estado de validacion y siguiente incremento | No debe afirmar aprobacion ni validacion funcional no ejecutada |
| `project/advanced-labs-register.md` | Registrar candidatos avanzados de Unidad 08 si el usuario acepta este reparto | No convierte candidatos en plan aprobado |
| `platform/tools/README.md` | Fijar version Tekton verificada y ciclo de vida al generar la unidad | No instala nada por si mismo |

## Componentes retirados

Ninguno.

---

# Decisiones de diseno de la unidad

## D-08-01 - Tekton ejecuta validacion y plan, no apply

### Decision

Tekton valida artefactos y ejecuta `terraform plan` controlado. La Unidad 08 no ejecuta `terraform apply` desde el pipeline y no se convierte en reconciliador continuo del estado deseado.

### Motivo

La Unidad 09 introduce Argo CD para GitOps y debe resolver el ownership operativo frente al release gestionado por Terraform en la Unidad 07. Ejecutar `apply` desde CI antes de esa decision mezcla integracion continua, mutacion de infraestructura y entrega declarativa.

### Consecuencias

- el pipeline puede validar Helm y Terraform;
- el pipeline puede producir un plan controlado y revisable;
- el pipeline no modifica el release Helm ni recursos gestionados por Terraform;
- la resolucion de ownership entre Terraform y Argo CD queda para la Unidad 09;
- no se introduce sincronizacion continua en esta unidad.

### Alternativas descartadas

- `terraform apply` desde Tekton en Unidad 08: adelanta una decision de ownership que pertenece a Unidad 09;
- pipeline que despliega todo imperativamente con `kubectl apply`: contradice Helm/Terraform y oculta GitOps;
- Argo CD adelantado: contradice roadmap y estado del proyecto.

## D-08-02 - Tekton se instala por release oficial versionado

### Decision

Tekton Pipelines se instala mediante `kubectl apply -f` contra `release.yaml` oficial versionado, con version LTS vigente verificada al generar la unidad.

Referencia temporal del playbook, verificada el 2026-07-28 contra fuentes oficiales de Tekton: Tekton Pipelines `v1.12.0` aparece como release LTS soportada hasta mayo de 2027, y `v1.13.0` aparece como release posterior no LTS. Fuentes de comprobacion: `https://tekton.dev/blog/` y `https://github.com/tektoncd/pipeline/releases`. La unidad final debe revalidar este dato antes de fijar manifests, comandos o `platform/tools/README.md`.

### Motivo

`platform/tools/README.md` fija esa convencion para componentes de cluster y evita usar `latest` o versiones recordadas de memoria.

### Consecuencias

- el README del laboratorio debe documentar version, fuente, namespace, persistencia y limpieza;
- la unidad debe registrar la version en `platform/tools/`;
- si la version LTS cambia antes de generar la unidad, debe revalidarse.

### Alternativas descartadas

- Tekton Operator: queda como criterio/candidato avanzado, no via troncal;
- manifiestos copiados sin fuente versionada: dificultan trazabilidad y upgrades.

## D-08-03 - El laboratorio valida artefactos existentes

### Decision

El pipeline practica validacion de chart Helm y proyecto Terraform heredados, en lugar de inventar una aplicacion o IaC alternativa.

### Motivo

El curso es acumulativo y la Unidad 07 dejo preparada la ejecucion de validacion y plan desde CI/CD. La mutacion mediante `apply` queda fuera del tronco de Unidad 08 hasta decidir ownership y aprobaciones.

### Consecuencias

- `platform-api` sigue siendo la aplicacion evolutiva;
- el alumno ve CI sobre artefactos reales del repositorio;
- los errores de Helm/Terraform siguen siendo diagnosticables con herramientas conocidas.

### Alternativas descartadas

- pipeline de ejemplo "hello world": rompe continuidad;
- aplicacion distinta para build: contradice el principio de laboratorio unico.

## D-08-04 - Build de imagen queda fuera del tronco inicial

### Decision

La unidad explica la construccion de imagenes como criterio profesional, pero no la practica en el tronco salvo que antes se apruebe una estrategia de imagen, `Dockerfile`, registry y credenciales de laboratorio.

### Motivo

El repositorio actual consume `nginxinc/nginx-unprivileged:1.27.4-alpine` y no contiene `Dockerfile` ni registry local. Practicar build sin esos elementos crearia una segunda linea tecnica.

### Consecuencias

- el pipeline se centra en validacion y preparacion;
- build de imagen pasa a candidato avanzado;
- supply chain security conserva su espacio natural en unidades posteriores.

### Alternativas descartadas

- crear una aplicacion nueva para demostrar build: contradice arquitectura;
- habilitar registry y credenciales sin unidad propietaria: amplia el alcance sin gobierno.

## D-08-05 - Workspaces temporales por ejecucion

### Decision

La practica usa un Workspace con `volumeClaimTemplate` asociado al `PipelineRun` para datos temporales de ejecucion.

### Motivo

Permite practicar Workspaces y ciclo de vida de datos temporales sin convertir el PVC en almacenamiento permanente de artefactos.

### Consecuencias

- se refuerza el aprendizaje de `volumeClaimTemplates` sin reabrir `GAP-004`;
- el README del laboratorio debe documentar limpieza y retencion observada;
- la referencia debe explicar diferencias con artifact stores reales.

### Alternativas descartadas

- PVC fijo compartido entre ejecuciones: aumenta riesgo de residuos y acoplamiento;
- `emptyDir` solamente: no ejercita la capacidad prevista de Workspaces con PVC.

## D-08-06 - RBAC local minimo

### Decision

La unidad crea una ServiceAccount de laboratorio con permisos limitados a lo necesario para ejecutar e inspeccionar el pipeline y validar los recursos del curso.

### Motivo

Tekton ejecuta Pods y consulta recursos de Kubernetes; el alumno debe ver que CI dentro del cluster necesita identidad y permisos.

### Consecuencias

- no se usan permisos de cluster-admin por comodidad;
- la referencia debe explicar como cambiaria en una plataforma corporativa;
- no se guardan credenciales reales.

### Alternativas descartadas

- usar la cuenta por defecto sin discusion: oculta el modelo de seguridad;
- simular ServiceAccounts corporativas: requiere proveedor y politicas reales.

---

# Estructura esperada de entregables

```text
tutorial/08-tekton-continuous-integration/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

labs/08-tekton-continuous-integration/
├── README.md
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

La estructura puede ajustarse durante la generacion si el README del laboratorio justifica una separacion mas clara, pero no debe omitir los entregables obligatorios.

---

# Validaciones requeridas para cerrar la unidad

## Validaciones estaticas

- `bash -n labs/08-tekton-continuous-integration/validation/validate.sh`;
- `shellcheck labs/08-tekton-continuous-integration/validation/validate.sh`, si `shellcheck` esta disponible;
- validacion YAML de los manifiestos Tekton con el mecanismo disponible en el entorno;
- revision de ausencia de secretos reales, kubeconfigs, tokens o credenciales.

## Validaciones funcionales

Solo se ejecutan cuando el playbook este aprobado y se genere la unidad:

- comprobar MicroK8s Ready;
- instalar Tekton Pipelines con version fija verificada;
- confirmar namespace `tekton-pipelines` y Pods/controladores Ready;
- aplicar ServiceAccount/RBAC local;
- aplicar Tasks, Pipeline y PipelineRun;
- ejecutar PipelineRun hasta estado `Succeeded`;
- inspeccionar TaskRuns generados;
- comprobar logs de Tasks;
- comprobar Results no sensibles;
- comprobar PVC temporal creado por `volumeClaimTemplate` y documentar su limpieza;
- ejecutar validaciones Helm y Terraform desde el pipeline;
- confirmar que no se borra `platform-api-data`;
- confirmar que no se instala Argo CD ni otros componentes fuera de alcance.

## Validaciones documentales

- comprobar que `README.md`, `student-notes.md`, `student-reference.md`, `instructor-notes.md`, `summary.md` y README del laboratorio se enlazan entre si;
- comprobar que `student-reference.md` sigue `playbooks/student-reference-template.md`;
- comprobar que el reparto de `.work/detail.md` queda declarado como practica, criterio, diferido o candidato avanzado;
- comprobar que `platform/tools/README.md` registra version, metodo, namespace, persistencia y limpieza de Tekton;
- comprobar que `project/project-state.md` distingue contenido generado, validacion funcional y aprobacion del usuario.

---

# Criterios de aceptacion

La Unidad 08 solo podra considerarse generada cuando:

- existan todos los entregables obligatorios de tutorial y laboratorio;
- Tekton Pipelines este instalado solo dentro del alcance aprobado de la unidad;
- la version de Tekton este fijada y verificada contra fuente oficial;
- el pipeline ejecute al menos una validacion Helm y una validacion Terraform sobre artefactos heredados;
- el pipeline ejecute `terraform plan` pero no `terraform apply`;
- Workspaces, Params, Results y PipelineRuns se practiquen de forma observable;
- el laboratorio documente precondiciones, repeticion, limpieza y recuperacion;
- no existan secretos reales ni credenciales corporativas;
- no se haya instalado Argo CD ni otro componente fuera de alcance;
- `summary.md` registre estado real y continuidad hacia Unidad 09;
- `project/project-state.md` registre el estado real sin declarar aprobacion no aportada por el usuario;
- la revision pedagogica del usuario quede registrada como pendiente o aprobada, segun corresponda.

---

# Continuidad hacia Unidad 09

La Unidad 08 debe dejar a la Unidad 09:

- Tekton Pipelines instalado y documentado como componente persistente;
- pipeline CI inicial para validar `platform-api`;
- frontera clara entre validacion/preparacion de CI y reconciliacion GitOps;
- decision documentada de que Terraform queda limitado a plan desde CI en Unidad 08;
- advertencia explicita de que Argo CD resolvera el ownership operativo del despliegue;
- ninguna credencial real ni secreto productivo versionado;
- ningun recurso Argo CD creado.

La Unidad 09 reutilizara el chart Helm y el pipeline CI inicial, pero no debe depender de historial de conversacion para entender que Tekton no es el reconciliador GitOps.
