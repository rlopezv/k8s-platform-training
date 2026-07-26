# SESSION_HANDOFF

## 1. Proyecto

Repositorio para construir y mantener un itinerario profesional de formación sobre Kubernetes y platform engineering.

El repositorio es la fuente única de verdad. El curso evoluciona de forma incremental sobre un único laboratorio, una única aplicación evolutiva (`platform-api`) y documentación/playbooks versionados. Cada unidad debe partir del estado anterior, reutilizar artefactos existentes y distinguir contenido generado, validado técnicamente y aprobado pedagógicamente.

## 2. Objetivos

El objetivo activo no es generar una unidad nueva. La Unidad 08 queda congelada.

El trabajo actual es el saneamiento documental posterior a la revisión de coherencia de Unidades 00-07:

- revisar playbooks contra el contrato documental cerrado;
- después retroajustar las unidades no conformes;
- mantener alineados `project/project-state.md`, `project/content-gap-register.md`, playbooks y summaries.

## 3. Arquitectura

El laboratorio local parte de Windows 11, WSL2, Ubuntu LTS y MicroK8s, y evolucionará hacia AKS y EKS en unidades futuras.

La solución técnica es acumulativa:

- namespace funcional: `platform-training`;
- aplicación evolutiva: `platform-api`;
- manifiestos Kubernetes en Unidades 01-05;
- chart Helm local en `labs/06-helm-packaging/chart/platform-api/`;
- proyecto Terraform local en `labs/07-local-terraform-automation/terraform/`.

Los documentos de gobierno principales son:

- `project/architecture.md`;
- `project/project-state.md`;
- `project/roadmap.md`;
- `project/project-planning.md`;
- `project/how-to.md`;
- `project/content-gap-register.md`.

Los playbooks gobiernan la generación y revisión:

- `playbooks/master.md`;
- `playbooks/unit-template.md`;
- `playbooks/student-reference-template.md`;
- `playbooks/summary-template.md`;
- `playbooks/project-state-template.md`;
- `playbooks/units/*.md`.

## 4. Estado Actual

Unidades generadas y registradas: 00-07.

Última unidad completada: Unidad 07 - Automatización local con Terraform. Está generada, validada funcionalmente y aprobada pedagógicamente.

Fase activa: saneamiento documental de Unidades 00-07 contra el contrato cerrado de `student-reference.md`.

Último incremento completado: fase 2 del saneamiento documental; contrato documental cerrado y estado/arquitectura alineados.

Siguiente incremento permitido: fase 3 del saneamiento documental.

Tabla de fases vigente:

| Fase | Trabajo | Estado |
|---|---|---|
| 0 | Decisiones bloqueantes D1-D5 | Completada |
| 1 | Compactación y saneamiento de registros de estado | Completada |
| 2 | Contrato documental: ampliar `student-reference-template.md`, declarar frontera en `unit-template.md`, regla ortográfica en `master.md` | Completada |
| 3 | Revisión de playbooks contra el contrato cerrado | Pendiente |
| 4 | Retroajuste de unidades: 07 como piloto, después 06, después 00 y 01, y por último auditoría de autosuficiencia de 02-05 | Pendiente |
| 5 | Incremento funcional de Unidad 04 (`TD-023`), con validación ejecutada | Pendiente |

La Unidad 08 no debe generarse hasta cerrar las fases 3 y 4.

Estado de lagunas de contenido: `project/content-gap-register.md` registra 11 lagunas: 4 cerradas, 7 abordadas, 0 abiertas.

Deuda relevante:

- `TD-019`: conformidad de `student-reference.md` en unidades 00, 01, 06 y 07. Abierta.
- `TD-020`: ortografía incompleta en material del alumno. Parcialmente cerrada; queda barrido editorial en fase 4.
- `TD-021`: frontera entre `student-notes.md` y `student-reference.md`. Cerrada.
- `TD-022`: auditoría de autosuficiencia de referencias conformes 02-05. Abierta.
- `TD-023`: práctica de `StatefulSet`, `volumeClaimTemplates` y headless Service en Unidad 04 sobre workload auxiliar desechable. Abierta; no bloquea por sí sola Unidad 08 salvo decisión posterior.
- `TD-024`: tratamiento de lagunas delegado a `project/content-gap-register.md`.

## 5. Estado del Laboratorio

Entorno y herramientas registradas:

- MicroK8s local validado;
- Kubernetes disponible en MicroK8s;
- `kubectl`, Helm y Terraform validados;
- Helm `v3.21.0+ge0878d4`;
- Terraform `1.15.7`;
- providers Terraform de Unidad 07: `hashicorp/helm` `2.17.0` y `hashicorp/kubernetes` `2.38.0`.

Estado técnico principal:

- `platform-api` desplegada como release Helm local `platform-api-local`;
- release gestionado por Terraform desde Unidad 07;
- backend Terraform local;
- state local no versionado;
- chart Helm local conservado en Unidad 06;
- no existen Tekton, Argo CD, observabilidad avanzada, KEDA, AKS ni EKS.

Laboratorios existentes:

- `platform/environment/`;
- `labs/01-kubernetes/`;
- `labs/02-configuration-lifecycle/`;
- `labs/03-networking-ingress/`;
- `labs/04-persistence-state/`;
- `labs/05-scheduling-resilience-maintenance/`;
- `labs/06-helm-packaging/`;
- `labs/07-local-terraform-automation/`.

## 6. Flujo de Generación

Antes de modificar una unidad o generar nuevo contenido, leer:

- `playbooks/master.md`;
- `project/architecture.md`;
- `project/project-state.md`;
- `project/roadmap.md`;
- `playbooks/student-reference-template.md`;
- `playbooks/unit-template.md`;
- playbook específico afectado;
- summary de la unidad anterior o de la unidad afectada;
- artefactos que se vayan a reutilizar o modificar.

Cada unidad debe mantener:

- `tutorial/<unidad>/README.md`;
- `tutorial/<unidad>/student-notes.md`;
- `tutorial/<unidad>/student-reference.md`;
- `tutorial/<unidad>/instructor-notes.md`;
- `tutorial/<unidad>/summary.md`;
- laboratorio o artefactos ejecutables;
- `project/project-state.md` actualizado.

Validación técnica y aprobación pedagógica no son lo mismo. No declarar una validación como ejecutada si solo se revisó documentalmente.

## 7. Restricciones

Restricciones activas:

- reutilizar el laboratorio existente;
- no generar ejemplos independientes ni aplicaciones paralelas;
- mantener `platform-api` como aplicación evolutiva;
- mantener `platform-training` como namespace funcional;
- no modificar `platform-api` para la práctica de `StatefulSet` de Unidad 04;
- el workload auxiliar de Unidad 04 será desechable y no formará parte de la solución evolutiva;
- no generar unidades nuevas con `student-reference.md` fuera de `playbooks/student-reference-template.md`;
- no instalar Tekton;
- no instalar Argo CD;
- no desplegar Prometheus, Grafana, Loki, Tempo u OpenTelemetry;
- no introducir KEDA;
- no crear recursos AKS o EKS;
- no configurar backends remotos ni módulos cloud;
- no versionar `terraform.tfstate`, `.terraform/`, `terraform.tfvars` locales, planes binarios, kubeconfigs, tokens ni secretos reales;
- no ejecutar `terraform destroy` como limpieza normal;
- no usar Minikube, kind ni Docker Desktop Kubernetes como plataforma paralela.

Contrato documental vigente:

- `student-notes.md` explica y diagnostica lo que ocurre dentro del laboratorio;
- `student-reference.md` explica lo que existe fuera y corrige modelos mentales;
- no debe haber contenido duplicado entre ambos;
- los errores de concepto pertenecen a `student-reference.md`;
- el diagnóstico de fallos del laboratorio pertenece a `student-notes.md`;
- `instructor-notes.md` queda exento de la regla de no duplicación porque tiene otro lector y función.

## 8. Objetivo de la Nueva Conversación

Ejecutar la fase 3 del saneamiento documental: revisar los playbooks existentes contra el contrato documental cerrado.

La revisión debe determinar qué playbooks requieren ajuste antes de iniciar la fase 4 de retroajuste de unidades.

No generar Unidad 08.

## 8bis. Decisiones de la sesión anterior no reflejadas arriba

- La fase 5 se disuelve dentro de la fase 4: el retroajuste de la Unidad 04 se
  ejecuta como incremento único, editorial y funcional a la vez, con validación
  ejecutada. El plan pasa a cuatro fases.
- La fase 3 tiene dos entregables: la revisión de los ocho playbooks y el
  playbook de retroajuste de la Unidad 04 ya redactado como incremento
  combinado, que resuelve `Q-010` (nombre, imagen y ciclo de limpieza del
  workload auxiliar desechable) dentro.
- La Unidad 07 es el piloto del retroajuste: valida el contrato sobre contenido
  real antes de aplicarlo a las otras siete, y cierra `GAP-010`, que la Unidad 09
  necesita.
- Pendiente de decisión del usuario: partir la fase 4 en 4a (retroajuste de las
  cuatro unidades no conformes) y 4b (Unidad 04 funcional y auditoría `TD-022`),
  para desbloquear la Unidad 08 al cerrar 4a en lugar de la fase 4 completa.
  Sin esa decisión, la 08 espera a una auditoría de alcance desconocido.
  
## 9. Primeras Acciones

1. Leer `project/project-state.md`, `project/content-gap-register.md`, `playbooks/master.md`, `playbooks/unit-template.md` y `playbooks/student-reference-template.md`.
2. Revisar los playbooks específicos existentes en `playbooks/units/00-environment.md` a `playbooks/units/07-local-terraform-automation.md`.
3. Comprobar si cada playbook declara correctamente la frontera entre `student-notes.md` y `student-reference.md`.
4. Comprobar si cada playbook declara lagunas cubiertas, tipos de cobertura, exclusiones y simplificaciones de laboratorio que obligan a práctica profesional.
5. Registrar hallazgos como fase 3 sin modificar unidades todavía.
6. Si se aplican correcciones, actualizar `project/project-state.md` y dejar claro cuándo se puede iniciar la fase 4.

