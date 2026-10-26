# Session Handoff

## 1. Proyecto

Repositorio fuente de verdad para construir un itinerario incremental de formacion profesional sobre Kubernetes y platform engineering.

El curso usa un unico laboratorio evolutivo: empieza en Windows 11, WSL2, Ubuntu LTS y MicroK8s, y avanza hacia plataformas gestionadas como AKS y EKS. Cada unidad reutiliza el estado anterior, evita ejemplos independientes y deja artefactos, validaciones, resumen y estado consolidado actualizados.

## 2. Objetivos

Objetivo actual:

- generar la Unidad 08 - Integracion continua con Tekton, respetando `playbooks/units/08-tekton-continuous-integration.md`, que ya esta aprobado.

Objetivos de continuidad:

- mantener `platform-api` como aplicacion evolutiva;
- conservar `platform-training` como namespace funcional;
- reutilizar el chart Helm de Unidad 06 y el proyecto Terraform local de Unidad 07;
- instalar Tekton solo dentro del alcance aprobado de Unidad 08;
- preparar la continuidad hacia Unidad 09, donde se tratara Argo CD y GitOps.

## 3. Arquitectura

La arquitectura separa:

- gobierno en `project/`;
- instrucciones de generacion en `playbooks/`;
- contenido del alumno en `tutorial/`;
- artefactos ejecutables en `labs/`;
- entorno base en `platform/environment/`;
- componentes de cluster en `platform/tools/`.

`project/coverage-map.md` es un mapa versionado de cobertura candidata. No prevalece sobre `project/roadmap.md`, `project/project-state.md`, registros de lagunas ni playbooks especificos. Cada punto debe repartirse como practica, criterio, diferido, candidato avanzado o fuera del itinerario.

`project/validation/validate-governance.sh` valida consistencia de gobierno y debe ejecutarse cuando el incremento cambie estado, siguiente paso permitido o gobierno documental.

## 4. Estado Actual

Unidades 00-07:

- generadas;
- validadas funcionalmente cuando correspondia;
- aprobadas pedagogicamente o documentalmente segun consta en `project/project-state.md`;
- saneadas contra el contrato vigente de `student-reference.md`.

Estado de saneamiento:

- `TD-019`, `TD-020`, `TD-022` y `TD-023` cerradas;
- `GAP-004` cerrado documental y funcionalmente;
- `Q-010` cerrada mediante el workload auxiliar `scratch-stateful`;
- el plan temporal de saneamiento fue retirado y su rastro queda consolidado en `project/project-state.md`.

Unidad activa:

- 08 - Integracion continua con Tekton;
- playbook especifico generado y aprobado;
- unidad pendiente de generar.

Siguiente incremento permitido:

- generar la Unidad 08 respetando `playbooks/units/08-tekton-continuous-integration.md`.

## 5. Estado del Laboratorio

Entorno registrado:

- MicroK8s local validado;
- Kubernetes, `kubectl`, Helm y Terraform disponibles segun estado consolidado;
- aplicacion evolutiva `platform-api`;
- namespace funcional `platform-training`;
- release Helm `platform-api-local`;
- PVC principal `platform-api-data`.

Artefactos relevantes:

- chart Helm: `labs/06-helm-packaging/chart/platform-api/`;
- validacion Helm: `labs/06-helm-packaging/validation/validate.sh`;
- proyecto Terraform: `labs/07-local-terraform-automation/terraform/`;
- validacion Terraform: `labs/07-local-terraform-automation/validation/validate.sh`;
- demo StatefulSet validada y limpiable: `labs/04-persistence-state/statefulset-demo/`;
- catalogo de componentes de cluster: `platform/tools/README.md`;
- validador de gobierno: `project/validation/validate-governance.sh`.

Tekton no esta incorporado todavia. No existe contenido versionado en:

```text
tutorial/08-tekton-continuous-integration/
labs/08-tekton-continuous-integration/
```

## 6. Flujo De Generacion

Antes de generar la Unidad 08, leer:

1. `README.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `project/how-to.md`;
6. `project/project-planning.md`;
7. `project/content-gap-register.md`;
8. `project/advanced-labs-register.md`;
9. `project/coverage-map.md`;
10. `platform/tools/README.md`;
11. `playbooks/master.md`;
12. `playbooks/unit-template.md`;
13. `playbooks/student-reference-template.md`;
14. `playbooks/summary-template.md`;
15. `playbooks/project-state-template.md`;
16. `playbooks/units/07-local-terraform-automation.md`;
17. `tutorial/07-local-terraform-automation/summary.md`;
18. `playbooks/units/08-tekton-continuous-integration.md`;
19. artefactos Helm y Terraform heredados.

Durante la generacion:

- producir `README.md`, `student-notes.md`, `student-reference.md`, `instructor-notes.md`, `summary.md` y laboratorio de Unidad 08;
- actualizar `platform/tools/README.md` con version, metodo, namespace, persistencia y limpieza de Tekton;
- actualizar `project/project-state.md` con estado real;
- distinguir contenido generado, validacion tecnica ejecutada y aprobacion del usuario;
- ejecutar `bash project/validation/validate-governance.sh` al cerrar.

Nota de precedencia: `tutorial/07-local-terraform-automation/summary.md` menciona que Unidad 08 queda preparada para plan y apply desde CI/CD, pero `project/project-state.md` y el playbook aprobado de Unidad 08 corrigen el alcance vigente: Unidad 08 ejecuta `terraform plan`, no `terraform apply`.

## 7. Restricciones

Restricciones vigentes:

- reutilizar el laboratorio existente;
- no crear aplicaciones independientes;
- conservar `platform-api`;
- conservar `platform-training`;
- conservar `platform-api-local`;
- no modificar unidades anteriores salvo necesidad justificada;
- no introducir secretos reales, kubeconfigs, tokens ni credenciales corporativas;
- no versionar `terraform.tfstate`, `.terraform/`, `terraform.tfvars` locales ni planes binarios;
- no ejecutar `terraform destroy` como limpieza normal;
- no instalar Tekton fuera del alcance aprobado de Unidad 08;
- no instalar Argo CD antes de Unidad 09;
- no desplegar Prometheus, Grafana, Loki, Tempo, OpenTelemetry ni KEDA antes de sus unidades;
- no crear recursos AKS o EKS;
- no introducir Minikube, kind ni Docker Desktop Kubernetes como plataforma paralela.

Reglas especificas de Unidad 08:

- instalar Tekton Pipelines en `tekton-pipelines` solo al generar la unidad;
- verificar contra fuentes oficiales la version vigente antes de fijarla;
- practicar Tasks, Pipelines, PipelineRuns, Workspaces con `volumeClaimTemplate`, Params, Results, `when`, RBAC local minimo, validacion Helm/Terraform y `terraform plan`;
- excluir `terraform apply` desde Tekton;
- comparar `Job` y `CronJob` como criterio, sin practica ejecutable troncal;
- diferir build de imagen, Tekton Triggers y ServiceAccounts corporativas reales.

## 8. Objetivo De La Nueva Conversacion

Generar la Unidad 08 - Integracion continua con Tekton.

La unidad debe crear:

```text
tutorial/08-tekton-continuous-integration/README.md
tutorial/08-tekton-continuous-integration/student-notes.md
tutorial/08-tekton-continuous-integration/student-reference.md
tutorial/08-tekton-continuous-integration/instructor-notes.md
tutorial/08-tekton-continuous-integration/summary.md
labs/08-tekton-continuous-integration/
```

Debe instalar y validar Tekton solo si se esta ejecutando realmente la generacion funcional de la unidad y la version ha sido revalidada contra fuentes oficiales.

## 9. Primeras Acciones

1. Ejecutar `git status --short` y confirmar que no hay cambios pendientes ajenos.
2. Leer las fuentes obligatorias listadas en este handoff.
3. Revalidar la version vigente de Tekton Pipelines contra fuentes oficiales antes de fijar comandos o catalogo.
4. Inspeccionar `labs/06-helm-packaging/chart/platform-api/` y `labs/07-local-terraform-automation/terraform/`.
5. Disenar los artefactos de Unidad 08 siguiendo el playbook aprobado.
6. Generar tutorial, notas, referencia, notas del instructor, summary y laboratorio.
7. Ejecutar validaciones estaticas disponibles.
8. Si el entorno lo permite, ejecutar validacion funcional con MicroK8s, Tekton, PipelineRun, Helm y Terraform.
9. Actualizar `project/project-state.md` con lo realmente generado y validado.
10. Ejecutar `bash project/validation/validate-governance.sh`.
