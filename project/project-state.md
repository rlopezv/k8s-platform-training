# Estado del proyecto

## Propósito

Este documento representa el estado actual, consolidado y verificable del repositorio.

Debe permitir que una nueva sesión de trabajo determine con precisión:

- qué artefactos existen;
- qué fase está activa;
- qué decisiones arquitectónicas están vigentes;
- qué trabajo está completado;
- qué trabajo permanece pendiente;
- qué restricciones deben respetarse;
- cuál es el siguiente incremento permitido.

Este archivo describe el estado real del proyecto. No sustituye al roadmap ni debe contener contenido aspiracional no implementado.

---

# Resumen ejecutivo

| Campo | Estado |
|---|---|
| Fase actual | Preparado para generar el playbook de Unidad 08 tras cierre documental de GAP-001 |
| Estado general | Unidades 00-07 completadas; GAP-001 resuelto documentalmente mediante referencia y laboratorio de Unidad 00 |
| Último incremento completado | Referencia y laboratorio de contenedores, imagenes y registros añadidos a Unidad 00 |
| Unidad activa | Ninguna |
| Última unidad completada | 07 — Automatizacion local con Terraform, generada, validada funcionalmente y aprobada pedagogicamente |
| Laboratorio disponible | Sí, entorno base local y primera aplicación |
| Plataforma local desplegada | Sí, MicroK8s local validado |
| Contenido formativo generado | Sí, Unidades 00, 01, 02, 03, 04, 05, 06 y 07 |
| Framework de generación | Framework V1 validado; Framework V2 didactico simplificado para `student-reference.md`, vision general y lagunas |
| Siguiente incremento permitido | Generar el playbook de la Unidad 08 — Integración continua con Tekton |

---

# Fase actual

El proyecto ha completado la **Unidad 00 — Preparación del entorno**, la **Unidad 01 — Fundamentos operativos y primera aplicación**, la **Unidad 02 — Configuración, secretos y ciclo de vida**, la **Unidad 03 — Networking e ingreso**, la **Unidad 04 — Persistencia y estado** y la **Unidad 05 — Scheduling, resiliencia y mantenimiento**. La Unidad 04 fue aprobada por el usuario y validada funcionalmente el 2026-07-19. La Unidad 05 fue generada y validada funcionalmente el 2026-07-19.

La Unidad 01 incorporó la primera aplicación evolutiva del curso, `platform-api`, desplegada sobre MicroK8s mediante manifiestos Kubernetes estándar. El laboratorio local ya contiene un namespace funcional, un Deployment, Pods gestionados por ReplicaSet y un Service interno.

La revisión del usuario aprobó la Unidad 01. También identificó que el contenido tiene un nivel de entrada exigente y está más orientado a explicar el laboratorio que a construir una visión amplia sobre Kubernetes. Esta observación queda registrada como deuda pedagógica para una futura sesión de hardening global, preferiblemente cuando existan varias unidades y pueda revisarse la progresión completa.

El 2026-07-18 se generó un hardening pedagógico global inicial sobre las Unidades 00, 01 y 02. El cambio refuerza los tutoriales como material formativo principal, separa mejor teoría y operación, añade modelos mentales, decisiones de diseño, errores de razonamiento y lectura guiada. No modifica manifiestos, scripts ni el estado funcional del clúster. El usuario aceptó estos cambios como cambios mínimos, pero indicó que el nivel pedagógico de los README sigue siendo realmente pobre para formar a personas que todavía no conocen los temas tratados.

Como consecuencia, se actualizaron `playbooks/master.md` y `playbooks/unit-template.md` para exigir que futuras unidades no asuman dominio previo del tema, construyan modelo mental desde el problema real, expliquen conceptos con progresión didáctica y mantengan una separación más estricta entre tutorial formativo y laboratorio operativo.

El usuario y el proyecto acuerdan que el nivel pedagógico deseado no debe resolverse cargando indefinidamente los `README.md`. Cada unidad debe separar el `README.md` como puerta de entrada y `student-notes.md` como guía de aprendizaje académica y aplicada. Esta guía debe explicar qué se va a cubrir, qué representa cada componente, qué se construye, cómo se relacionan las piezas, qué ocurre al aplicar los artefactos, cómo comprobar resultados, cómo diagnosticar fallos típicos, qué recordar para la unidad siguiente y qué fuentes consultar.

La Unidad 03 generó el acceso HTTP local para `platform-api` mediante un recurso `Ingress` y el addon Ingress de MicroK8s. La validación técnica se ejecutó contra el MicroK8s local con 0 fallos y 0 avisos. La revisión pedagógica final fue aprobada por el usuario el 2026-07-19 junto con el refuerzo `student-notes.md`.

El 2026-07-18 se inicio esta fase pedagogica transversal sobre `tutorial/00-environment/README.md`, `tutorial/01-kubernetes/README.md`, `tutorial/02-configuration-lifecycle/README.md` y `tutorial/03-networking-ingress/README.md`. El incremento añade una guia pedagogica inicial, mapas de aprendizaje, preguntas centrales y separacion mas explicita entre capitulo formativo y laboratorio. No modifica manifiestos, scripts ni estado del cluster.

El 2026-07-19 se incorpora `student-notes.md` como artefacto pedagógico estructural de cada unidad. Se crean notas del alumno para las Unidades 00, 01, 02 y 03, con explicaciones desde cero de los conceptos principales, modelos mentales, relaciones entre recursos, errores frecuentes, preguntas de comprobación y continuidad con unidades posteriores. Los README quedan enlazados a estas notas y conservan su función de entrada y orientación. No se modifican manifiestos, scripts, laboratorios ni estado del clúster.

El usuario aceptó los cambios y confirmó que fueron comiteados en `b842f33 Add student notes for units 00-03`. La fase pedagógica transversal queda cerrada para poder continuar con la Unidad 04.

El 2026-07-19 se generó `playbooks/units/05-scheduling-resilience-maintenance.md` y fue comiteado en `361b2df Generate unit 05 scheduling playbook`. El usuario confirmó que el playbook queda aprobado. El playbook define alcance, supuestos pedagógicos, entregables, restricciones, decisiones y criterios de aceptación para scheduling, resiliencia y mantenimiento.

El 2026-07-19 se generó la Unidad 05. La unidad reutiliza `tutorial/04-persistence-state/summary.md` y `labs/04-persistence-state/solution/`, crea `tutorial/05-scheduling-resilience-maintenance/`, crea `labs/05-scheduling-resilience-maintenance/`, añade `poddisruptionbudget/platform-api`, declara estrategia `RollingUpdate` y constraints de scheduling seguros en `deployment/platform-api`, conserva el PVC, Service e Ingress heredados y deja `labs/05-scheduling-resilience-maintenance/solution/` como base prevista para la Unidad 06.

La validacion funcional de Unidad 05 se ejecuto correctamente en MicroK8s con 0 fallos y 0 avisos. El PDB mostro `minAvailable: 1` y `disruptionsAllowed: 1`, los Pods quedaron asignados al nodo `gmktecg2`, el Service mantuvo EndpointSlices con endpoints, el Ingress sirvio contenido de Unidad 05 y la eliminacion controlada de un Pod fue recuperada por el Deployment.

El 2026-07-19 se reestructuraron `tutorial/01-kubernetes/student-notes.md`, `tutorial/02-configuration-lifecycle/student-notes.md`, `tutorial/03-networking-ingress/student-notes.md`, `tutorial/04-persistence-state/student-notes.md` y `tutorial/05-scheduling-resilience-maintenance/student-notes.md` como guías de aprendizaje con una estructura común: propósito, alcance académico, representación de componentes, construcción de laboratorio, relaciones, comportamiento al aplicar artefactos, comprobación, diagnóstico de cuatro fallos típicos, continuidad y fuentes de referencia. El usuario aprobó este contenido y pidió adaptar playbooks y documentos de `project/` a la estructura generada.

La alineacion documental posterior a la aprobacion de `student-notes.md` actualizo el contrato de `student-notes.md` en los documentos de gobierno y playbooks.

El 2026-07-19 se genero `playbooks/units/06-helm-packaging.md` como playbook de la Unidad 06. El playbook fue usado para generar la unidad por instruccion del usuario y define Helm como mecanismo de empaquetado de `platform-api`, reutilizando `labs/05-scheduling-resilience-maintenance/solution/`. Tambien incorpora `tutorial/06-helm-packaging/student-reference.md` como entregable obligatorio para cubrir arquitectura avanzada de plantillas, jerarquia de valores, control de flujo, helpers y frontera conceptual con Terraform. Terraform queda diferido como ejecucion a la Unidad 07.

El 2026-07-19 se genero la Unidad 06 por instruccion del usuario. La unidad crea `tutorial/06-helm-packaging/`, `labs/06-helm-packaging/`, un chart Helm local en `labs/06-helm-packaging/chart/platform-api/`, `student-reference.md`, un script de adopcion de recursos heredados y `labs/06-helm-packaging/validation/validate.sh`. La generacion conserva `platform-api`, namespace `platform-training`, PVC `platform-api-data`, Service, Ingress, PDB, rollout, probes, resources y scheduling seguro. Se ejecutaron validaciones estaticas, renderizado, dry-run cliente, adopcion de metadatos Helm, instalacion real del release `platform-api-local`, upgrade temporal, rollback real y validacion funcional final con 0 fallos y 0 avisos. El usuario aprobo pedagogicamente la Unidad 06 el 2026-07-19.

El 2026-07-20 se genero la Unidad 07 por instruccion del usuario. La unidad crea `tutorial/07-local-terraform-automation/`, `labs/07-local-terraform-automation/`, un proyecto Terraform local en `labs/07-local-terraform-automation/terraform/`, `student-reference.md` avanzado y `labs/07-local-terraform-automation/validation/validate.sh`. La unidad reutiliza el chart Helm de Unidad 06 y declara `helm_release.platform_api` para gestionar el release `platform-api-local` en `platform-training`.

Durante la validacion funcional de Unidad 07, Terraform descargo los providers `hashicorp/helm` `2.17.0` y `hashicorp/kubernetes` `2.38.0`, genero `.terraform.lock.hcl`, importo el release existente mediante `terraform import helm_release.platform_api platform-training/platform-api-local`, ejecuto `terraform apply` con resultado `0 added, 1 changed, 0 destroyed` y dejo `helm_release.platform_api` en el state local no versionado. La validacion de Unidad 07 finalizo con 0 fallos y 0 avisos. La validacion heredada de Unidad 06 tambien finalizo con 0 fallos y 0 avisos; `platform-api-local` quedo `deployed` en revision 4. El usuario aprobo pedagogicamente la Unidad 07 el 2026-07-20.

El 2026-07-20 se resolvio `GAP-001` como mejora pedagogica de Unidad 00 mediante `tutorial/00-environment/student-reference.md` y `platform/environment/container-images/README.md`. La referencia cubre contenedores, imagenes y registros como vision general previa a Unidad 01 y continuidad hacia CI/CD, supply chain y cloud registries. El laboratorio asociado es de solo lectura y ayuda a leer `image`, `imagePullPolicy`, `kubectl explain` y fallos de descarga de imagenes sin construir imagenes ni modificar el cluster. No se modificaron scripts, manifests, charts, Terraform ni estado funcional del cluster. La aprobacion pedagogica final de esta referencia y su laboratorio queda pendiente del usuario.

A partir de este estado se permite:

- crear o reforzar `student-reference.md` en unidades donde falte vision general, contexto de herramientas habituales o profundidad de referencia;
- generar el playbook de la Unidad 08 — Integración continua con Tekton;
- revisar contenido generado de Unidades 00-07 sin cambiar capacidades tecnicas salvo contradiccion real;
- conservar `labs/07-local-terraform-automation/terraform/` como base tecnica para CI/CD.

Todavía no se permite:

- instalar Tekton;
- instalar Argo CD;
- desplegar Prometheus, Grafana, Loki, Tempo u OpenTelemetry;
- introducir KEDA;
- crear recursos en AKS o EKS;
- sustituir la aplicación evolutiva por otra aplicación sin justificación documentada.

---

# Artefactos de gobierno

| Artefacto | Estado | Última modificación relevante | Responsabilidad |
|---|---|---|---|
| `README.md` | Actualizado | Student-Notes-Learning-Guide | Punto de entrada y visión general; refleja `student-notes.md` como artefacto por unidad |
| `project/architecture.md` | Actualizado | Student-Notes-Learning-Guide | Arquitectura y decisiones estructurales; separa README y guías de aprendizaje del alumno |
| `project/project-state.md` | Actualizado | GAP-001 | Estado consolidado; registra cierre documental de GAP-001 y siguiente incremento permitido |
| `project/content-gap-register.md` | Actualizado | GAP-001 | Registro ligero de lagunas; GAP-001 cerrado como referencia y laboratorio de Unidad 00 |
| `project/roadmap.md` | Completo y aprobado | Unit-00-01 | Evolución prevista del itinerario |
| `project/project-planning.md` | Actualizado | Framework-V2-Didactic-Review | Planificación incremental del trabajo; incluye sesiones de reapertura de framework didactico y revisión transversal |
| `project/how-to.md` | Actualizado | Unit-01-Review-Flow | Mecanismo operativo de trabajo con asistentes de IA; distingue validación técnica de aprobación del usuario |
| `playbooks/master.md` | Actualizado | Framework-V2-Didactic-Review | Reglas globales; incorpora `student-reference.md` opcional para vision general/profundidad y registro de lagunas |
| `playbooks/unit-template.md` | Actualizado | Framework-V2-Didactic-Review | Plantilla de playbooks específicos; declara `student-reference.md` como opcional |
| `playbooks/summary-template.md` | Actualizado | Framework-V2-Didactic-Review | Contrato de continuidad; registra `student-reference.md` y lagunas de contenido |
| `playbooks/project-state-template.md` | Actualizado | Framework-V2-Didactic-Review | Reglas de mantenimiento del estado; incorpora registro compacto de lagunas |
| `playbooks/generate-session-handoff.md` | Completo y aprobado | Framework-03 | Generación del handoff derivado de sesión |
| `playbooks/units/00-environment.md` | Completo y aprobado | Unit-00-01 | Gobierno de la Unidad 00 |
| `playbooks/units/01-kubernetes.md` | Completo y aprobado | Unit-01-Concept-Scope | Gobierno de la Unidad 01 |
| `playbooks/units/02-configuration-lifecycle.md` | Completo y aprobado | Unit-02-Playbook-Approval | Gobierno de la Unidad 02 |
| `playbooks/units/03-networking-ingress.md` | Completo y aprobado | Unit-03-Playbook-Approval | Gobierno de la Unidad 03 |
| `playbooks/units/04-persistence-state.md` | Completo y aprobado por instrucción de generación | Unit-04-Generation | Gobierno de la Unidad 04 |
| `playbooks/units/05-scheduling-resilience-maintenance.md` | Completo y aprobado | Unit-05-Playbook-Approval | Gobierno de la Unidad 05 |
| `playbooks/units/06-helm-packaging.md` | Usado para generar Unidad 06 por instruccion del usuario | Unit-06-Generation | Gobierno de la Unidad 06; incluye `student-reference.md` como entregable requerido |
| `playbooks/units/07-local-terraform-automation.md` | Completo y aprobado | Unit-07-Playbook-Approval | Gobierno de la Unidad 07; incluye `student-reference.md` de arquitectura avanzada de Terraform |
| `AGENTS.md` | Completo | Unit-00-01 | Guía operativa para agentes con acceso al repositorio |

---

# Estructura actual del repositorio

```text
.
├── README.md
├── assets/
│   └── .gitkeep
├── labs/
│   ├── .gitkeep
│   ├── 01-kubernetes/
│       ├── README.md
│       ├── starter/
│       │   ├── deployment.yaml
│       │   ├── namespace.yaml
│       │   └── service.yaml
│       ├── solution/
│       │   ├── deployment.yaml
│       │   ├── namespace.yaml
│       │   └── service.yaml
│       └── validation/
│           └── validate.sh
│   └── 02-configuration-lifecycle/
│       ├── README.md
│       ├── starter/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── namespace.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       ├── solution/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── namespace.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       └── validation/
│           └── validate.sh
│   └── 03-networking-ingress/
│       ├── README.md
│       ├── starter/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── namespace.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       ├── solution/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── namespace.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       └── validation/
│           └── validate.sh
│   └── 04-persistence-state/
│       ├── README.md
│       ├── starter/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── namespace.yaml
│       │   ├── pvc.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       ├── solution/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── namespace.yaml
│       │   ├── pvc.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       └── validation/
│           └── validate.sh
│   └── 05-scheduling-resilience-maintenance/
│       ├── README.md
│       ├── starter/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── namespace.yaml
│       │   ├── pvc.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       ├── solution/
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── ingress.yaml
│       │   ├── namespace.yaml
│       │   ├── pdb.yaml
│       │   ├── pvc.yaml
│       │   ├── secret.yaml
│       │   └── service.yaml
│       └── validation/
│           └── validate.sh
├── platform/
│   ├── .gitkeep
│   └── environment/
│       ├── .gitkeep
│       ├── README.md
│       ├── linux/
│       │   └── check-prerequisites.sh
│       ├── microk8s/
│       │   ├── configure.sh
│       │   ├── install.sh
│       │   ├── reset.sh
│       │   └── validate.sh
│       ├── tools/
│       │   ├── install-helm.sh
│       │   ├── install-terraform.sh
│       │   └── validate-tools.sh
│       ├── validation/
│       │   └── validate-environment.sh
│       └── windows/
│           ├── check-prerequisites.ps1
│           └── prepare-ubuntu-wsl.ps1
├── playbooks/
│   ├── generate-session-handoff.md
│   ├── master.md
│   ├── project-state-template.md
│   ├── summary-template.md
│   ├── unit-template.md
│   └── units/
│       ├── 00-environment.md
│       ├── 01-kubernetes.md
│       ├── 02-configuration-lifecycle.md
│       ├── 03-networking-ingress.md
│       ├── 04-persistence-state.md
│       ├── 05-scheduling-resilience-maintenance.md
│       ├── 06-helm-packaging.md
│       └── 07-local-terraform-automation.md
├── project/
│   ├── architecture.md
│   ├── content-gap-register.md
│   ├── how-to.md
│   ├── project-planning.md
│   ├── project-state.md
│   └── roadmap.md
└── tutorial/
    ├── .gitkeep
    ├── 00-environment/
    │   ├── instructor-notes.md
    │   ├── README.md
    │   ├── student-notes.md
    │   └── summary.md
    ├── 01-kubernetes/
    │   ├── instructor-notes.md
    │   ├── README.md
    │   ├── student-notes.md
    │   └── summary.md
    ├── 02-configuration-lifecycle/
    │   ├── instructor-notes.md
    │   ├── README.md
    │   ├── student-notes.md
    │   └── summary.md
    └── 03-networking-ingress/
        ├── instructor-notes.md
        ├── README.md
        ├── student-notes.md
        └── summary.md
    └── 04-persistence-state/
        ├── instructor-notes.md
        ├── README.md
        ├── student-notes.md
        └── summary.md
    └── 05-scheduling-resilience-maintenance/
        ├── instructor-notes.md
        ├── README.md
        ├── student-notes.md
        └── summary.md
```

## Estado de directorios

| Directorio | Estado | Contenido actual |
|---|---|---|
| `assets/` | Previsto y materializado | Solo `.gitkeep`; sin artefactos formativos |
| `labs/` | Materializado con Unidades 01, 02, 03, 04, 05, 06 y 07 | `.gitkeep`, `01-kubernetes/`, `02-configuration-lifecycle/`, `03-networking-ingress/`, `04-persistence-state/`, `05-scheduling-resilience-maintenance/`, `06-helm-packaging/` y `07-local-terraform-automation/` |
| `platform/environment/` | Completo para la Unidad 00 | Scripts de preparación, validación y herramientas base; laboratorio de acompañamiento de imagenes de solo lectura |
| `playbooks/` | Operativo | Framework completo y playbooks de Unidades 00, 01, 02, 03, 04, 05, 06 y 07 |
| `project/` | Operativo | Arquitectura, estado, roadmap y registro de lagunas de contenido |
| `tutorial/` | Unidades 00, 01, 02, 03, 04, 05, 06 y 07 generadas | README de entrada, `student-notes.md`, instructor notes y summaries; Unidades 00, 06 y 07 anaden `student-reference.md` |

---

# Estado de las unidades

| Unidad | Estado | Tutorial | Student notes | Student reference | Laboratorio o plataforma | Instructor notes | Summary |
|---|---|---|---|---|---|---|---|
| 00 — Preparación del entorno | Completada con limitaciones; referencia y laboratorio de acompañamiento añadidos para GAP-001 con aprobación pendiente | Sí | Sí | Sí | Sí, `platform/environment/` | Sí | Sí |
| 01 — Fundamentos operativos y primera aplicación | Completada y aprobada; `student-notes.md` aprobado | Sí | Sí | No aplica | Sí, `labs/01-kubernetes/` | Sí | Sí |
| 02 — Configuración, secretos y ciclo de vida | Completada y aprobada; `student-notes.md` aprobado | Sí | Sí | No aplica | Sí, `labs/02-configuration-lifecycle/` | Sí | Sí |
| 03 — Networking e ingreso | Completada, validada técnicamente y aprobada | Sí | Sí | No aplica | Sí, `labs/03-networking-ingress/` | Sí | Sí |
| 04 — Persistencia y estado | Completada, validada funcionalmente y aprobada | Sí | Sí | No aplica | Sí, `labs/04-persistence-state/` | Sí | Sí |
| 05 — Scheduling, resiliencia y mantenimiento | Completada, validada funcionalmente y aprobada pedagogicamente en sus guias del alumno | Sí | Sí | No aplica | Sí, `labs/05-scheduling-resilience-maintenance/` | Sí | Sí |
| 06 — Empaquetado con Helm | Completada, validada funcionalmente y aprobada pedagogicamente | Sí | Sí | Sí | Sí, `labs/06-helm-packaging/` | Sí | Sí |
| 07 — Automatizacion local con Terraform | Completada, validada funcionalmente y aprobada pedagogicamente | Sí | Sí | Sí | Sí, `labs/07-local-terraform-automation/` | Sí | Sí |
| 08–25 | Previstas en roadmap | No | No | No | No | No | No |

## Unidad 00 — Preparación del entorno

| Campo | Estado |
|---|---|
| Estado | Completada y aprobada con limitaciones; hardening pedagógico inicial mínimo aceptado |
| Fecha de inicio | 2026-07-17 |
| Fecha de cierre | 2026-07-18 |
| Playbook | `playbooks/units/00-environment.md` |
| Tutorial | `tutorial/00-environment/README.md` |
| Student notes | `tutorial/00-environment/student-notes.md` |
| Student reference | `tutorial/00-environment/student-reference.md` |
| Artefactos ejecutables | `platform/environment/` |
| Laboratorio de acompañamiento | `platform/environment/container-images/README.md` |
| Instructor notes | `tutorial/00-environment/instructor-notes.md` |
| Summary | `tutorial/00-environment/summary.md` |

Limitaciones activas:

- Windows 11, virtualización, salida completa de `wsl --status` y `wsl --list --verbose` siguen siendo validaciones por equipo al replicar el laboratorio.
- Los scripts de Unidad 00 no deben modificarse salvo corrección justificada.
- La referencia y el laboratorio de acompañamiento de contenedores, imagenes y registros no cambian el estado tecnico del cluster ni validan build, registry o credenciales.

## Unidad 01 — Fundamentos operativos y primera aplicación

| Campo | Estado |
|---|---|
| Estado | Completada con limitaciones documentadas; hardening pedagógico inicial mínimo aceptado |
| Fecha de inicio | 2026-07-18 |
| Fecha de cierre | 2026-07-18 |
| Playbook | `playbooks/units/01-kubernetes.md` |
| Tutorial | `tutorial/01-kubernetes/README.md` |
| Student notes | `tutorial/01-kubernetes/student-notes.md` |
| Laboratorio | `labs/01-kubernetes/` |
| Instructor notes | `tutorial/01-kubernetes/instructor-notes.md` |
| Summary | `tutorial/01-kubernetes/summary.md` |

Capacidades incorporadas:

- aplicación evolutiva inicial `platform-api`;
- namespace funcional `platform-training`;
- manifiestos declarativos para `Namespace`, `Deployment` y `Service`;
- labels y selectors base;
- validación no destructiva del laboratorio;
- diagnóstico básico con estado, eventos, logs y endpoints;
- prueba HTTP local mediante `kubectl port-forward`.

Limitaciones al cierre de la Unidad 01:

- antes de la Unidad 02, la aplicación todavía no usaba ConfigMaps, Secrets, probes, requests ni limits;
- el Service es interno y no hay Ingress ni Gateway API;
- `kubectl get endpoints` funciona para la práctica, pero Kubernetes `v1.35.6` muestra advertencia de deprecación de `Endpoints` en favor de `EndpointSlice`;
- ShellCheck no está disponible en este entorno para validar scripts;
- Windows/WSL desde PowerShell sigue pendiente de validación por equipo.
- el usuario aprobó la unidad y considera que el nivel de entrada es exigente y que el contenido está más orientado a explicar el laboratorio que a proporcionar una visión amplia del tema; se difiere a una sesión de hardening pedagógico global.

## Unidad 02 — Configuración, secretos y ciclo de vida

| Campo | Estado |
|---|---|
| Estado | Completada, validada técnicamente y aprobada; hardening pedagógico inicial mínimo aceptado |
| Fecha de inicio | 2026-07-18 |
| Fecha de cierre | 2026-07-18 |
| Playbook | `playbooks/units/02-configuration-lifecycle.md` |
| Tutorial | `tutorial/02-configuration-lifecycle/README.md` |
| Student notes | `tutorial/02-configuration-lifecycle/student-notes.md` |
| Laboratorio | `labs/02-configuration-lifecycle/` |
| Instructor notes | `tutorial/02-configuration-lifecycle/instructor-notes.md` |
| Summary | `tutorial/02-configuration-lifecycle/summary.md` |

Capacidades incorporadas:

- ConfigMaps para configuración no sensible;
- Secrets de laboratorio con valores ficticios;
- variables de entorno y volúmenes de configuración;
- `startupProbe`, `readinessProbe` y `livenessProbe`;
- requests y limits iniciales;
- observación de rollouts y ciclo de vida básico.

Limitaciones activas:

- ShellCheck no está disponible en este entorno para validar scripts;
- los Secrets son únicamente de laboratorio y no representan gestión corporativa de secretos;
- Ingress y DNS interno ya fueron incorporados en Unidad 03; Gateway API operativa y TLS productivo siguen diferidos;
- Helm y Terraform siguen sin gestionar recursos del curso.

## Unidad 03 — Networking e ingreso

| Campo | Estado |
|---|---|
| Estado | Completada, validada técnicamente y aprobada con limitaciones |
| Fecha de inicio | 2026-07-18 |
| Fecha de cierre | 2026-07-18 |
| Playbook | `playbooks/units/03-networking-ingress.md` |
| Tutorial | `tutorial/03-networking-ingress/README.md` |
| Student notes | `tutorial/03-networking-ingress/student-notes.md` |
| Laboratorio | `labs/03-networking-ingress/` |
| Instructor notes | `tutorial/03-networking-ingress/instructor-notes.md` |
| Summary | `tutorial/03-networking-ingress/summary.md` |

Capacidades incorporadas:

- reutilizar `platform-api`, `platform-training` y `labs/02-configuration-lifecycle/solution/`;
- conservar el Service `platform-api` como `ClusterIP`;
- validar DNS interno de Kubernetes para `platform-api.platform-training.svc.cluster.local`;
- habilitar el addon Ingress de MicroK8s como controlador local;
- desplegar Traefik `v3.6.2` en namespace `ingress` mediante el addon local;
- crear `ingress/platform-api` con host `platform-api.local`, `ingressClassName: public` y backend `service/platform-api:80`;
- validar HTTP por Ingress con `curl -H 'Host: platform-api.local' http://127.0.0.1/`;
- tratar Gateway API como comparación conceptual, aunque el addon haya instalado CRDs como efecto de plataforma local.

Limitaciones activas:

- ShellCheck no está disponible en este entorno para validar scripts;
- la revisión pedagógica final del usuario fue aprobada el 2026-07-19;
- el addon Ingress de MicroK8s es específico de plataforma local y no debe extrapolarse a AKS, EKS o entornos corporativos;
- no se crearon recursos `GatewayClass`, `Gateway` ni `HTTPRoute` gestionados por el curso;
- TLS productivo, DNS público, LoadBalancer cloud, NetworkPolicies, Helm, Terraform, CI/CD, GitOps, observabilidad avanzada y cloud siguen diferidos.

## Unidad 04 — Persistencia y estado

| Campo | Estado |
|---|---|
| Estado | Completada, validada funcionalmente y aprobada |
| Fecha de inicio | 2026-07-19 |
| Fecha de cierre | No aplica |
| Playbook | `playbooks/units/04-persistence-state.md` |
| Tutorial | `tutorial/04-persistence-state/README.md` |
| Student notes | `tutorial/04-persistence-state/student-notes.md` |
| Laboratorio | `labs/04-persistence-state/` |
| Instructor notes | `tutorial/04-persistence-state/instructor-notes.md` |
| Summary | `tutorial/04-persistence-state/summary.md` |

Capacidades incorporadas:

- PVC `platform-api-data` para almacenamiento persistente de laboratorio;
- montaje del PVC en `/usr/share/nginx/html/persistent`;
- procedimiento de escritura, lectura, recreación de Pod, copia y restauración básica;
- validación automatizada de StorageClass, PVC, PV, montaje, persistencia, Service e Ingress;
- explicación pedagógica de filesystem efímero, `Volume`, `PersistentVolume`, `PersistentVolumeClaim`, `StorageClass`, access modes, permisos y recuperación básica.

Limitaciones activas:

- `hostpath-storage` de MicroK8s fue habilitado para el laboratorio local;
- `storageclass.storage.k8s.io/microk8s-hostpath` quedó disponible como default;
- PVC `platform-api-data` quedó `Bound` a PV `pvc-d7b0bce5-dab0-40e4-9542-2bd9b4f3b638`;
- el montaje `/usr/share/nginx/html/persistent` fue validado como escribible;
- el dato `message.txt` sobrevivió a la recreación de un Pod;
- el dato persistente fue servido por Ingress en `/persistent/message.txt`;
- la revisión pedagógica final del usuario fue aprobada el 2026-07-19.

## Unidad 05 — Scheduling, resiliencia y mantenimiento

| Campo | Estado |
|---|---|
| Estado | Completada, validada funcionalmente y aprobada pedagogicamente en sus guias del alumno |
| Fecha de inicio | 2026-07-19 |
| Fecha de cierre | 2026-07-19 |
| Playbook | `playbooks/units/05-scheduling-resilience-maintenance.md` |
| Tutorial | `tutorial/05-scheduling-resilience-maintenance/README.md` |
| Student notes | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` |
| Laboratorio | `labs/05-scheduling-resilience-maintenance/` |
| Instructor notes | `tutorial/05-scheduling-resilience-maintenance/instructor-notes.md` |
| Summary | `tutorial/05-scheduling-resilience-maintenance/summary.md` |

Capacidades incorporadas:

- scheduler, colocación de Pods y eventos de scheduling documentados;
- `nodeSelector` seguro, node affinity preferida y pod anti-affinity preferida en `deployment/platform-api`;
- `PodDisruptionBudget` `platform-api` con `minAvailable: 1`;
- estrategia `RollingUpdate`, `maxUnavailable: 1`, `maxSurge: 1`, `revisionHistoryLimit: 5` y `minReadySeconds: 5`;
- simulación controlada de eliminacion de Pod y recuperacion por Deployment;
- validacion de Deployment, PDB, Pods asignados, Service, EndpointSlice, Ingress, PVC, HTTP y rollout history;
- continuidad hacia Helm en Unidad 06.

Limitaciones activas:

- el cluster validado tiene un solo nodo `gmktecg2`; la unidad no demuestra alta disponibilidad multi-nodo;
- `hostpath-storage` y el PVC local siguen siendo especificos de MicroK8s;
- el PDB no protege ante fallos involuntarios de nodo, proceso o almacenamiento;
- no se automatiza `kubectl drain`, modificacion de taints ni borrado de PVC;
- Helm, Terraform, CI/CD, GitOps, observabilidad avanzada, autoscaling y cloud siguen diferidos.

## Unidad 06 — Empaquetado con Helm

| Campo | Estado |
|---|---|
| Estado | Completada, validada funcionalmente y aprobada pedagogicamente |
| Fecha de inicio | 2026-07-19 |
| Fecha de cierre | 2026-07-19 |
| Playbook | `playbooks/units/06-helm-packaging.md` |
| Tutorial | `tutorial/06-helm-packaging/README.md` |
| Student notes | `tutorial/06-helm-packaging/student-notes.md` |
| Student reference | `tutorial/06-helm-packaging/student-reference.md` |
| Laboratorio | `labs/06-helm-packaging/` |
| Instructor notes | `tutorial/06-helm-packaging/instructor-notes.md` |
| Summary | `tutorial/06-helm-packaging/summary.md` |

Capacidades incorporadas:

- empaquetar `platform-api` con Helm reutilizando `labs/05-scheduling-resilience-maintenance/solution/`;
- crear un chart local con `Chart.yaml`, `values.yaml`, `values-local.yaml`, templates y `_helpers.tpl`;
- renderizar Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB;
- documentar linting, renderizado, instalacion, upgrade, inspeccion, rollback y validacion;
- incorporar `student-reference.md` sobre arquitectura avanzada de plantillas y gestion de variables;
- tratar `helm_release`, `templatefile()` y `set_sensitive` como continuidad conceptual hacia Unidad 07, no como ejecucion de Terraform.

Limitaciones activas:

- puede requerirse atencion a ownership de recursos si se migra un estado aplicado previamente con `kubectl` a Helm;
- el release Helm ahora esta gestionado por Terraform desde Unidad 07.

## Unidad 07 — Automatizacion local con Terraform

| Campo | Estado |
|---|---|
| Estado | Completada, validada funcionalmente y aprobada pedagogicamente |
| Fecha de inicio | 2026-07-20 |
| Fecha de cierre | 2026-07-20 |
| Playbook | `playbooks/units/07-local-terraform-automation.md` |
| Tutorial | `tutorial/07-local-terraform-automation/README.md` |
| Student notes | `tutorial/07-local-terraform-automation/student-notes.md` |
| Student reference | `tutorial/07-local-terraform-automation/student-reference.md` |
| Laboratorio | `labs/07-local-terraform-automation/` |
| Instructor notes | `tutorial/07-local-terraform-automation/instructor-notes.md` |
| Summary | `tutorial/07-local-terraform-automation/summary.md` |

Capacidades incorporadas:

- proyecto Terraform local para gestionar `helm_release.platform_api`;
- providers Helm y Kubernetes inicializados;
- `.terraform.lock.hcl` versionable con providers `hashicorp/helm` `2.17.0` y `hashicorp/kubernetes` `2.38.0`;
- variables tipadas, validaciones, `terraform.tfvars.example`, `templatefile()` y outputs no sensibles;
- import del release existente `platform-training/platform-api-local`;
- apply funcional con `0 added, 1 changed, 0 destroyed`;
- validacion automatizada de Terraform, Helm y Kubernetes;
- referencia avanzada de Terraform sobre state, variables, expresiones, modulos e integracion Kubernetes/Helm.

Limitaciones activas:

- aprobacion pedagogica del usuario registrada el 2026-07-20;
- backend local y state local no versionado;
- `terraform destroy` no fue ejecutado y no debe usarse como limpieza normal;
- no se crearon backends remotos, modulos cloud, Tekton, Argo CD, observabilidad avanzada, AKS ni EKS.

---

# Estado del laboratorio

## Host

| Componente | Estado | Versión o detalle | Evidencia |
|---|---|---|---|
| Windows 11 | Requisito previsto, pendiente de validar por cada entorno | Pendiente | `platform/environment/windows/check-prerequisites.ps1` |
| Virtualización | Requisito previsto, pendiente de validar por cada entorno | Pendiente | `platform/environment/windows/check-prerequisites.ps1` |
| WSL2 | Requisito previsto; Ubuntu objetivo ejecutándose sobre WSL2 según resultados aportados | Versión 2 | `wsl --status` y `wsl --list --verbose` pendientes por equipo |
| Ubuntu LTS | Validada | Ubuntu 24.04.4 LTS (`noble`) sobre WSL2 | `bash platform/environment/validation/validate-environment.sh` |

## Plataforma Kubernetes

| Componente | Estado | Versión | Evidencia |
|---|---|---|---|
| MicroK8s | Instalado y validado | `v1.35.6`, canal `1.35/stable`, revisión `9072` | `bash platform/environment/validation/validate-environment.sh` |
| Kubernetes | Disponible y validado en MicroK8s | `v1.35.6` | `kubectl get nodes`: nodo `gmktecg2` en `Ready` |
| Clúster local | Disponible y validado | Nodo `gmktecg2` en `Ready` | `kubectl get nodes` |
| Addons | `dns`, `ingress` y `hostpath-storage` habilitados; addons core adicionales observados por MicroK8s | `dns`, `ha-cluster`, `helm`, `helm3`, `hostpath-storage`, `ingress`, `storage` | `microk8s status --wait-ready` |

## Namespaces

| Namespace | Estado | Propósito | Definición |
|---|---|---|---|
| `default` | Activo | Namespace estándar | Kubernetes |
| `kube-node-lease` | Activo | Sistema | Kubernetes |
| `kube-public` | Activo | Sistema | Kubernetes |
| `kube-system` | Activo | Sistema | Kubernetes |
| `platform-training` | Activo | Recursos funcionales del curso | `labs/05-scheduling-resilience-maintenance/solution/namespace.yaml` |
| `ingress` | Activo | Controlador Ingress local de MicroK8s | Addon `microk8s enable ingress` |

## Workloads

| Recurso | Namespace | Estado esperado | Definición |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `2/2` replicas disponibles con PVC montado, estrategia `RollingUpdate` y scheduling seguro | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` |
| `replicaset/platform-api-678c7ddc89` | `platform-training` | 2 deseadas, 2 actuales, 2 ready observadas durante validacion de Unidad 05 | Generado por Deployment |
| Pods `platform-api-678c7ddc89-*` | `platform-training` | 2 Pods `Running`, `1/1`, 0 restarts observados durante validacion | Generados por ReplicaSet |
| `poddisruptionbudget/platform-api` | `platform-training` | `minAvailable: 1`, `disruptionsAllowed: 1` observado | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` |
| `pod/traefik-rp75h` | `ingress` | `Running`, `1/1`, 0 restarts observado | Addon Ingress de MicroK8s |

## Endpoints

| Servicio | Acceso | Estado | Propósito |
|---|---|---|---|
| `service/platform-api` | `ClusterIP` `10.152.183.150`, puerto `80/TCP` hacia contenedor `8080` | Activo | Acceso interno estable a `platform-api` |
| `endpointslice/platform-api-fbxzx` | `10.1.16.87:8080`, `10.1.16.88:8080` observados durante validacion final | Activo | Evidencia preferente de selección de Pods Ready por el Service |
| `ingress/platform-api` | Host `platform-api.local`, path `/`, clase `public` | Activo | Entrada HTTP local hacia `service/platform-api:80` |
| HTTP por Ingress local | `http://127.0.0.1/` con cabecera `Host: platform-api.local` | Validado con contenido de Unidad 05 desde ConfigMap | Prueba HTTP desde la máquina local |

---

# Herramientas y versiones

| Herramienta | Estado | Versión activa | Método de comprobación | Incorporada en |
|---|---|---|---|---|
| Git | Validado en Ubuntu WSL | `/usr/bin/git` | `platform/environment/linux/check-prerequisites.sh` | Unidad 00 |
| kubectl | Instalado y operativo contra MicroK8s | `v1.35.6` | `kubectl version --client`, `kubectl get nodes` | Unidad 00 |
| Helm | Instalado y validado como CLI; Unidad 06 crea el primer chart local del curso | `v3.21.0+ge0878d4` | `platform/environment/tools/validate-tools.sh`, `helm version --short`, `helm lint` | Unidad 00; chart en Unidad 06 |
| Terraform | Instalado y validado como CLI; gestiona el release Helm local desde Unidad 07 | `1.15.7`; providers Helm `2.17.0` y Kubernetes `2.38.0` | `platform/environment/tools/validate-tools.sh`, `terraform init`, `terraform validate`, `terraform state list` | Unidad 00; gestion de release en Unidad 07 |
| Argo CD | No incorporado | No aplica | No aplica | Unidad 09 |
| Tekton | No incorporado | No aplica | No aplica | Unidad 08 |
| Prometheus | No incorporado | No aplica | No aplica | Unidad 11 |
| Grafana | No incorporado | No aplica | No aplica | Unidad 12 |
| Loki | No incorporado | No aplica | No aplica | Unidad 13 |
| Tempo | No incorporado | No aplica | No aplica | Unidad 14 |
| OpenTelemetry | No incorporado | No aplica | No aplica | Unidad 14 |
| KEDA | No incorporado | No aplica | No aplica | Unidad 18 |

---

# Estado de la aplicación evolutiva

## Identificación

| Campo | Valor |
|---|---|
| Nombre | `platform-api` |
| Propósito | Servicio HTTP mínimo para evolucionar configuración, red, salud, observabilidad, seguridad, escalado y despliegue cloud |
| Versión actual | Unidad 07 desplegada como release Helm local `platform-api-local` gestionado por Terraform; validacion funcional completada |
| Repositorio o ruta | `labs/06-helm-packaging/chart/platform-api/` y `labs/07-local-terraform-automation/terraform/` |

## Componentes

| Componente | Estado | Imagen o versión | Definición |
|---|---|---|---|
| `Deployment/platform-api` | Renderizado por chart; desplegado funcionalmente desde Unidad 05 | `nginxinc/nginx-unprivileged:1.27.4-alpine` | `labs/06-helm-packaging/chart/platform-api/templates/deployment.yaml` |
| `PodDisruptionBudget/platform-api` | Renderizado por chart; desplegado funcionalmente desde Unidad 05 | `minAvailable: 1` | `labs/06-helm-packaging/chart/platform-api/templates/pdb.yaml` |
| `Service/platform-api` | Renderizado por chart como `ClusterIP`; validado funcionalmente desde Unidad 05 | `ClusterIP` | `labs/06-helm-packaging/chart/platform-api/templates/service.yaml` |
| `ConfigMap/platform-api-config` | Renderizado por chart para Unidad 06 | 4 claves | `labs/06-helm-packaging/chart/platform-api/templates/configmap.yaml` |
| `Secret/platform-api-secret` | Renderizado con valores ficticios | `Opaque`, 2 claves ficticias | `labs/06-helm-packaging/chart/platform-api/templates/secret.yaml` |
| `Ingress/platform-api` | Renderizado para host `platform-api.local` | Clase `public` | `labs/06-helm-packaging/chart/platform-api/templates/ingress.yaml` |
| `PersistentVolumeClaim/platform-api-data` | Renderizado por chart; PVC funcional validado desde Unidad 05 | `1Gi`, `ReadWriteOnce`, `microk8s-hostpath` | `labs/06-helm-packaging/chart/platform-api/templates/pvc.yaml` |

## Capacidades activas

- HTTP interno mediante Service;
- dos réplicas gestionadas por Deployment;
- configuración no sensible mediante ConfigMap;
- Secret de laboratorio con valores ficticios;
- variables de entorno y volumen de configuración;
- `startupProbe`, `readinessProbe` y `livenessProbe`;
- requests y limits iniciales;
- logs de contenedor legibles;
- validación de rollout, Pods, EndpointSlice y HTTP por Ingress local;
- DNS interno validado para `platform-api.platform-training.svc.cluster.local`;
- entrada HTTP local mediante `ingress/platform-api`;
- PVC montado en `/usr/share/nginx/html/persistent` y persistencia validada tras recreación de Pod;
- estrategia `RollingUpdate` declarada con `maxUnavailable: 1` y `maxSurge: 1`;
- scheduling seguro con `nodeSelector` Linux, node affinity preferida y pod anti-affinity preferida;
- PDB `platform-api` con `minAvailable: 1`;
- recuperacion validada tras eliminacion controlada de un Pod;
- empaquetado Helm local generado y renderizado para Unidad 06;
- release Helm local gestionado por Terraform desde Unidad 07.

## Capacidades todavía no incorporadas

- Gateway API operativa como artefacto del curso;
- CI/CD, GitOps, observabilidad avanzada, seguridad avanzada, KEDA, AKS y EKS.

---

# Estado de automatización

## Manifiestos Kubernetes

- `labs/01-kubernetes/solution/` se conserva como evidencia de Unidad 01;
- `labs/02-configuration-lifecycle/solution/namespace.yaml`;
- `labs/02-configuration-lifecycle/solution/configmap.yaml`;
- `labs/02-configuration-lifecycle/solution/secret.yaml`;
- `labs/02-configuration-lifecycle/solution/deployment.yaml`;
- `labs/02-configuration-lifecycle/solution/service.yaml`;
- `labs/02-configuration-lifecycle/validation/validate.sh`;
- `labs/03-networking-ingress/solution/namespace.yaml`;
- `labs/03-networking-ingress/solution/configmap.yaml`;
- `labs/03-networking-ingress/solution/secret.yaml`;
- `labs/03-networking-ingress/solution/deployment.yaml`;
- `labs/03-networking-ingress/solution/service.yaml`;
- `labs/03-networking-ingress/solution/ingress.yaml`;
- `labs/03-networking-ingress/validation/validate.sh`.
- `labs/04-persistence-state/solution/namespace.yaml`;
- `labs/04-persistence-state/solution/configmap.yaml`;
- `labs/04-persistence-state/solution/secret.yaml`;
- `labs/04-persistence-state/solution/pvc.yaml`;
- `labs/04-persistence-state/solution/deployment.yaml`;
- `labs/04-persistence-state/solution/service.yaml`;
- `labs/04-persistence-state/solution/ingress.yaml`;
- `labs/04-persistence-state/validation/validate.sh`.
- `labs/05-scheduling-resilience-maintenance/solution/namespace.yaml`;
- `labs/05-scheduling-resilience-maintenance/solution/configmap.yaml`;
- `labs/05-scheduling-resilience-maintenance/solution/secret.yaml`;
- `labs/05-scheduling-resilience-maintenance/solution/pvc.yaml`;
- `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml`;
- `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml`;
- `labs/05-scheduling-resilience-maintenance/solution/service.yaml`;
- `labs/05-scheduling-resilience-maintenance/solution/ingress.yaml`;
- `labs/05-scheduling-resilience-maintenance/validation/validate.sh`.

## Helm

- Existe el primer chart Helm local del curso en `labs/06-helm-packaging/chart/platform-api/`.
- El release de laboratorio `platform-api-local` esta desplegado en namespace `platform-training` y queda gestionado por Terraform desde Unidad 07.
- La validacion funcional heredada de Unidad 06 se ejecuto tras apply de Unidad 07 con 0 fallos y 0 avisos.
- El addon Ingress de MicroK8s despliega Traefik mediante Helm como componente de plataforma local, no como artefacto gestionado por el curso.
- Helm permanece como CLI validada desde Unidad 00.

## Terraform

- Existe un proyecto Terraform local en `labs/07-local-terraform-automation/terraform/`.
- El recurso `helm_release.platform_api` gestiona el release Helm `platform-api-local`.
- El release existente fue importado con `terraform import helm_release.platform_api platform-training/platform-api-local`.
- El apply funcional de Unidad 07 completo `0 added, 1 changed, 0 destroyed`.
- El state local existe como artefacto de ejecucion no versionado; `.terraform/`, `terraform.tfstate`, `terraform.tfvars` locales y planes binarios estan ignorados por Git.
- `.terraform.lock.hcl` queda versionable para fijar providers.
- No existen módulos Terraform cloud ni backends remotos del curso.

---

# Estado de observabilidad

| Señal | Estado | Evidencia |
|---|---|---|
| Estado Kubernetes | Disponible | `kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,pdb` |
| Eventos | Disponible | `kubectl -n platform-training get events --sort-by=.lastTimestamp` |
| Logs | Disponible | `kubectl -n platform-training logs deployment/platform-api --tail=20` |
| EndpointSlice | Disponible | `kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api` |
| Rollout history | Disponible | `kubectl -n platform-training rollout history deployment/platform-api` |
| PDB | Disponible | `kubectl -n platform-training get pdb platform-api` |
| Métricas avanzadas | No incorporadas | Diferidas a Unidades 11-12 |
| Logs centralizados | No incorporados | Diferidos a Unidad 13 |
| Trazas | No incorporadas | Diferidas a Unidad 14 |

---

# Estado de seguridad

| Control | Estado | Ámbito | Evidencia |
|---|---|---|---|
| Namespace de aislamiento | Activo | `platform-training` | `labs/05-scheduling-resilience-maintenance/solution/namespace.yaml` |
| Secret de aplicación | Implementado solo como laboratorio ficticio | `platform-api-secret` | `labs/05-scheduling-resilience-maintenance/solution/secret.yaml` |
| Ingress HTTP local | Activo sin TLS productivo | `platform-api.local` | `labs/05-scheduling-resilience-maintenance/solution/ingress.yaml` |
| PVC de laboratorio | Activo y validado | `platform-api-data` | `labs/05-scheduling-resilience-maintenance/solution/pvc.yaml` |
| PDB de laboratorio | Activo y validado | `platform-api` | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` |
| Credenciales reales | No versionadas | Repositorio | Revisión de manifiestos de Unidad 05 |

---

# Plataformas gestionadas

| Plataforma | Estado |
|---|---|
| AKS | No iniciada |
| EKS | No iniciada |

No existen actualmente:

- módulos Terraform cloud;
- clústeres gestionados;
- redes cloud;
- registros de imágenes privados;
- configuraciones de identidad;
- pipelines de despliegue cloud;
- procedimientos de teardown cloud.

---

# Decisiones arquitectónicas activas

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| ADR-001 — MicroK8s como plataforma local inicial | Activa | `project/architecture.md` | Gobierna el laboratorio local |
| ADR-002 — Unidad 0 fuera de `labs/` | Activa | `project/architecture.md` | Artefactos de entorno en `platform/environment/` |
| ADR-003 — Resumen por unidad | Activa | `project/architecture.md` | Obligatorio al cerrar cada unidad |
| ADR-004 — Estado consolidado central | Activa | `project/architecture.md` | Este archivo es fuente de estado |
| ADR-005 — Playbooks versionados | Activa | `project/architecture.md` | Cada unidad debe gobernarse por playbook |
| ADR-006 — Planificación y mecanismo operativo separados | Activa | `project/architecture.md` | Separa `project-planning.md` de `how-to.md` |
| ADR-007 — Handoff como artefacto derivado | Activa | `project/architecture.md` | `SESSION_HANDOFF.md` se regenera desde fuentes versionadas |
| ADR-008 — Neutralidad respecto al asistente | Activa | `project/architecture.md` | Permite sesiones con y sin acceso al workspace |

## Decisiones específicas de la Unidad 00

| Decisión | Estado | Documento fuente |
|---|---|---|
| D-00-01 — MicroK8s como distribución local | Activa | `playbooks/units/00-environment.md` |
| D-00-02 — Scripts separados por contexto | Activa | `playbooks/units/00-environment.md` |
| D-00-03 — Validación antes de instalación | Activa | `playbooks/units/00-environment.md` |
| D-00-04 — Addons mínimos | Activa; baseline inicial `dns` | `playbooks/units/00-environment.md` |
| D-00-05 — Terraform solo se instala y valida | Activa | `playbooks/units/00-environment.md` |
| D-00-06 — Helm se instala sin crear charts | Activa | `playbooks/units/00-environment.md` |
| D-00-07 — `kubectl` como cliente operativo principal | Activa | `playbooks/units/00-environment.md` |
| D-00-08 — Política inicial de versiones | Activa | `playbooks/units/00-environment.md` |

## Decisiones específicas de la Unidad 01

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| D-01-01 — Manifiestos Kubernetes como artefacto primario | Activa | `playbooks/units/01-kubernetes.md` | Unidad 01 gestionada con YAML y `kubectl` |
| D-01-02 — Aplicación evolutiva simple, observable y portable | Activa | `playbooks/units/01-kubernetes.md` y `tutorial/01-kubernetes/summary.md` | `platform-api` queda como aplicación base |
| D-01-03 — Namespace funcional único inicial | Activa | `playbooks/units/01-kubernetes.md` y `labs/01-kubernetes/solution/namespace.yaml` | `platform-training` |
| D-01-04 — Starter y solution sin duplicar laboratorios completos | Activa | `playbooks/units/01-kubernetes.md` | `starter/` y `solution/` creados |
| D-01-05 — Nombre y alcance de la aplicación evolutiva | Activa | `tutorial/01-kubernetes/summary.md` | Las unidades posteriores deben extender `platform-api` |
| D-01-06 — Imagen HTTP inicial versionada | Activa | `tutorial/01-kubernetes/summary.md` | `nginxinc/nginx-unprivileged:1.27.4-alpine` |
| D-01-07 — Service interno como primera exposición | Activa | `tutorial/01-kubernetes/summary.md` | `ClusterIP` y validación con port-forward |
| D-01-08 — Aprobación de contenido por el usuario | Activa | `project/how-to.md`, `playbooks/master.md`, `tutorial/01-kubernetes/summary.md` | La IA valida técnicamente; el usuario aprueba el contenido formativo |

## Decisiones específicas de la Unidad 02

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| D-02-01 — Configuración externa sin cambiar la aplicación evolutiva | Activa | `playbooks/units/02-configuration-lifecycle.md` y `tutorial/02-configuration-lifecycle/summary.md` | `platform-api` se mantiene y evoluciona mediante manifiestos |
| D-02-02 — Secrets solo de laboratorio | Activa | `playbooks/units/02-configuration-lifecycle.md` y `tutorial/02-configuration-lifecycle/summary.md` | `platform-api-secret` contiene valores ficticios |
| D-02-03 — Probes HTTP sobre el contenedor existente | Activa | `playbooks/units/02-configuration-lifecycle.md` | `startupProbe`, `readinessProbe` y `livenessProbe` usan `/` en puerto `http` |
| D-02-04 — Requests y limits iniciales conservadores | Activa | `playbooks/units/02-configuration-lifecycle.md` | CPU y memoria acotadas para laboratorio local |
| D-02-05 — Laboratorio acumulativo con ruta propia | Activa | `playbooks/units/02-configuration-lifecycle.md` | `labs/02-configuration-lifecycle/solution/` es la nueva base para Unidad 03 |
| D-02-06 — EndpointSlice como comprobación principal de endpoints | Activa | `tutorial/02-configuration-lifecycle/summary.md` | Validación de Unidad 02 consulta EndpointSlice y conserva fallback a `Endpoints` |

## Decisiones específicas de la Unidad 03

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| D-03-01 — Service interno conservado como backend estable | Activa | `playbooks/units/03-networking-ingress.md` y `tutorial/03-networking-ingress/summary.md` | `service/platform-api` sigue siendo `ClusterIP` y backend del Ingress |
| D-03-02 — Ingress Controller local como dependencia explícita de MicroK8s | Activa | `playbooks/units/03-networking-ingress.md` y `tutorial/03-networking-ingress/summary.md` | Addon `ingress` habilitado; Traefik `v3.6.2` desplegado en namespace `ingress` |
| D-03-03 — HTTP local antes que TLS productivo | Activa | `playbooks/units/03-networking-ingress.md` y `tutorial/03-networking-ingress/summary.md` | Host local `platform-api.local`; TLS queda diferido |
| D-03-04 — Gateway API como comparación, no como eje operativo | Activa | `playbooks/units/03-networking-ingress.md` y `tutorial/03-networking-ingress/summary.md` | CRDs instalados por el addon, pero sin recursos Gateway API gestionados por el curso |
| D-03-05 — Laboratorio acumulativo con ruta propia | Activa | `playbooks/units/03-networking-ingress.md` | `labs/03-networking-ingress/solution/` es la nueva base para Unidad 04 |

## Decisiones específicas de la Unidad 04

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| D-04-01 — Persistencia como evolución de `platform-api` | Activa | `playbooks/units/04-persistence-state.md` y `tutorial/04-persistence-state/summary.md` | No se crea aplicación alternativa ni base de datos real |
| D-04-02 — PVC como interfaz principal | Activa | `playbooks/units/04-persistence-state.md` y `tutorial/04-persistence-state/summary.md` | `platform-api-data` solicita almacenamiento; PV y StorageClass se diagnostican como plataforma |
| D-04-03 — MicroK8s hostpath aislado como detalle local | Activa y validada | `playbooks/units/04-persistence-state.md` y `tutorial/04-persistence-state/summary.md` | `microk8s-hostpath` está habilitada como StorageClass local; sigue siendo no productiva |
| D-04-04 — Recuperación básica, no backup productivo | Activa | `playbooks/units/04-persistence-state.md` y `tutorial/04-persistence-state/summary.md` | Se documenta copia/restauración de fichero inocuo; backups productivos quedan diferidos |
| D-04-05 — Deployment conservado | Activa | `tutorial/04-persistence-state/summary.md` | No se migra a StatefulSet en esta unidad |
| D-04-06 — Laboratorio acumulativo con ruta propia | Activa | `playbooks/units/04-persistence-state.md` | `labs/04-persistence-state/solution/` es la base validada para Unidad 05 |

## Decisiones específicas de la Unidad 05

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| D-05-01 — Resiliencia explicada desde el Deployment existente | Activa | `playbooks/units/05-scheduling-resilience-maintenance.md` | Mantener `platform-api` como eje de scheduling, rollout y recuperacion |
| D-05-02 — Preferir constraints no bloqueantes en laboratorio local | Activa | `playbooks/units/05-scheduling-resilience-maintenance.md` | Evitar que anti-affinity estricta bloquee MicroK8s de un nodo |
| D-05-03 — PDB como proteccion ante interrupciones voluntarias | Activa | `playbooks/units/05-scheduling-resilience-maintenance.md` | Introducir mantenimiento responsable sin prometer tolerancia a todos los fallos |
| D-05-04 — Rollout y rollback antes de Helm | Activa | `playbooks/units/05-scheduling-resilience-maintenance.md` | Preparar la Unidad 06 desde comportamiento nativo de Deployment |
| D-05-05 — Mantenimiento seguro, no destruccion del entorno | Activa | `playbooks/units/05-scheduling-resilience-maintenance.md` | Evitar automatizar `drain`, reset de MicroK8s o borrado de PVC |
| D-05-06 — Laboratorio acumulativo con ruta propia | Activa | `playbooks/units/05-scheduling-resilience-maintenance.md` | `labs/05-scheduling-resilience-maintenance/solution/` sera la base prevista para Unidad 06 |

## Decisiones específicas de la Unidad 06

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| D-06-01 — Helm empaqueta `platform-api` | Activa | `playbooks/units/06-helm-packaging.md` y `tutorial/06-helm-packaging/summary.md` | La solucion acumulada se convierte en chart sin crear aplicacion alternativa |
| D-06-02 — Parametrizacion con criterio | Activa | `playbooks/units/06-helm-packaging.md` y `labs/06-helm-packaging/chart/platform-api/values.yaml` | No todos los campos se convierten en valores configurables |
| D-06-03 — `student-reference.md` avanzado | Activa | `playbooks/units/06-helm-packaging.md` y `tutorial/06-helm-packaging/student-reference.md` | La unidad incluye referencia tecnica sobre templates, valores, helpers y frontera con Terraform |
| D-06-04 — Terraform queda diferido como ejecucion | Activa | `playbooks/units/06-helm-packaging.md` y `tutorial/06-helm-packaging/summary.md` | `helm_release`, `templatefile()` y `set_sensitive` se explican como continuidad, pero no se ejecutan en Unidad 06 |
| D-06-05 — Renderizado antes de instalacion | Activa | `playbooks/units/06-helm-packaging.md` y `labs/06-helm-packaging/README.md` | El alumno debe inspeccionar YAML renderizado antes de instalar un release |

## Decisiones específicas de la Unidad 07

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| D-07-01 — Terraform orquesta el release Helm existente | Activa | `playbooks/units/07-local-terraform-automation.md` y `tutorial/07-local-terraform-automation/summary.md` | `helm_release.platform_api` gestiona `platform-api-local`; no se reescriben templates Kubernetes |
| D-07-02 — Backend local para laboratorio | Activa | `playbooks/units/07-local-terraform-automation.md` | El state local es artefacto de ejecucion no versionado; backends remotos quedan diferidos |
| D-07-03 — Variables tipadas antes de multi-entorno complejo | Activa | `playbooks/units/07-local-terraform-automation.md` y `variables.tf` | La unidad usa defaults, validaciones y `terraform.tfvars.example` sin crear promocion formal |
| D-07-04 — Secrets solo ficticios y advertencia sobre state | Activa | `playbooks/units/07-local-terraform-automation.md` y `terraform/.gitignore` | No se introducen secretos reales; `set_sensitive` no sustituye proteccion de state |
| D-07-05 — Plan antes de apply | Activa | `playbooks/units/07-local-terraform-automation.md` y `labs/07-local-terraform-automation/README.md` | El apply se ejecuto tras plan sin destrucciones |
| D-07-06 — Sin modulo local ejecutable inicial | Activa | `tutorial/07-local-terraform-automation/summary.md` | El proyecto Terraform queda plano para favorecer trazabilidad pedagogica |

---

# Restricciones activas

Tras generar y validar funcionalmente la Unidad 07:

- la Unidad 06 conserva `platform-api`, `platform-training` y la evolucion acumulativa desde `labs/05-scheduling-resilience-maintenance/solution/`;
- `labs/06-helm-packaging/chart/platform-api/` sigue siendo el chart local de aplicacion;
- `labs/07-local-terraform-automation/terraform/` gestiona el release Helm local mediante Terraform;
- conservar la separación pedagógica reforzada: los README actúan como entrada, `student-notes.md` como guía de aprendizaje y los README de laboratorio como guía operativa;
- no sustituir la aplicación evolutiva sin justificación técnica o pedagógica explícita;
- no crear Terraform fuera del alcance ya definido por Unidad 07;
- no configurar backends remotos, modulos cloud, cuentas cloud, IAM, VPC, VNet, AKS ni EKS antes de sus unidades previstas;
- no versionar `terraform.tfstate`, `.terraform/`, `terraform.tfvars` locales, planes binarios, kubeconfigs, tokens ni secretos reales;
- no ejecutar `terraform destroy` como limpieza normal;
- no crear recursos Gateway API como eje operativo salvo decisión explícita posterior;
- no introducir TLS productivo, DNS público, LoadBalancer cloud ni NetworkPolicies antes de su unidad prevista;
- no presentar `hostpath-storage` como almacenamiento productivo ni cloud;
- no instalar Tekton;
- no instalar Argo CD;
- no desplegar observabilidad avanzada;
- no introducir KEDA;
- no crear recursos AKS o EKS;
- no almacenar credenciales ni configuración corporativa sensible;
- no utilizar Minikube, kind o Docker Desktop Kubernetes como plataforma paralela.

---

# Riesgos y cuestiones abiertas

## Riesgos

| ID | Riesgo | Probabilidad | Impacto | Mitigación | Estado |
|---|---|---|---|---|---|
| R-001 | Git no conserva directorios vacíos | Alta | Bajo | Rutas base materializadas con `.gitkeep` | Mitigado |
| R-002 | Diferencias entre versiones de WSL | Media | Alto | Detectar versión y documentar variantes | Abierto |
| R-003 | Virtualización no disponible | Baja | Alto | Validación temprana | Abierto |
| R-004 | Proxy o restricciones corporativas | Media | Alto | Parametrizar sin versionar credenciales | Abierto |
| R-005 | Entorno parcialmente configurado | Alta | Medio | Validar antes de instalar o desplegar | Mitigado para el entorno actual; abierto al replicar |
| R-006 | Addons de MicroK8s no portables | Media | Medio | Usar APIs Kubernetes estándar y aislar dependencias MicroK8s | Abierto |
| R-007 | Operaciones destructivas del entorno | Baja | Alto | Confirmación explícita y separación entre limpieza de unidad y reset de plataforma | Abierto |
| R-008 | Recursos insuficientes en el host | Media | Medio | Validar requisitos mínimos | Abierto |
| R-009 | Disponibilidad futura de imagen externa | Media | Medio | Imagen versionada y pull real validado; sustituir solo con registro en summary y estado | Mitigado |
| R-010 | Uso de `Endpoints` con advertencia de deprecación en Kubernetes 1.35 | Media | Bajo | Unidad 02 incorpora EndpointSlice como comprobación principal; mantener `Endpoints` solo como referencia histórica o fallback | Mitigado |
| R-011 | Contenido pedagógico demasiado orientado al laboratorio y exigente como entrada | Alta | Alto | `student-notes.md` de Unidades 01-05 reestructurado como guia de aprendizaje con capa academica, desarrollo aplicado, diagnostico y fuentes; aprobado por el usuario | Mitigado |
| R-012 | Futuras unidades especializadas pueden volverse difíciles de seguir si los materiales siguen asumiendo conocimiento previo | Media | Alto | Playbooks y plantillas actualizados para exigir `student-notes.md` como guia de aprendizaje academica y aplicada | Mitigado |

## Cuestiones abiertas

| ID | Cuestión | Bloqueante | Resolución prevista | Estado |
|---|---|---|---|---|
| Q-001 | Versiones exactas de Ubuntu, MicroK8s, Helm y Terraform | No | Versiones principales observadas y registradas; validación Windows/WSL completa queda como comprobación por equipo | Cerrada con limitación |
| Q-002 | Addons mínimos exactos | No | Baseline inicial `dns`; addons core `ha-cluster`, `helm` y `helm3` observados en MicroK8s | Cerrada para Unidad 00 |
| Q-003 | Alias o instalación independiente de `kubectl` | No | Resuelto: `kubectl` será cliente principal; `microk8s kubectl` queda como fallback | Cerrada |
| Q-004 | Requisitos mínimos de CPU, memoria y disco | No para cierre de Unidad 01 | Validación por equipo antes de replicar laboratorio | Abierta |
| Q-005 | Uso de systemd en WSL2 objetivo | No | Validado en el entorno aportado; revisar si otro equipo difiere | Cerrada con limitación |
| Q-006 | Necesidad de soporte para proxy corporativo | No | Cuando el entorno lo requiera | Abierta |
| Q-007 | Estrategia definitiva para directorios vacíos | No | Resuelta mediante `.gitkeep` hasta crear artefactos reales | Cerrada |
| Q-008 | Aplicación evolutiva del curso | No | Resuelta como `platform-api` en Unidad 01 | Cerrada |
| Q-009 | Nombre definitivo del namespace funcional de Unidad 01 | No | Resuelto como `platform-training` | Cerrada |

---

# Deuda técnica

| ID | Descripción | Prioridad | Origen | Resolución prevista | Estado |
|---|---|---|---|---|---|
| TD-001 | Definir estrategia de validación automatizada del repositorio | Media | Bootstrap | Evolución del framework | Abierta |
| TD-002 | Definir aplicación evolutiva | Alta durante Unidad 01 | Roadmap y `playbooks/units/01-kubernetes.md` | Resuelto en Unidad 01 | Cerrada |
| TD-003 | Definir política de versiones de herramientas | Alta | Unidad 00 | Política inicial definida y versiones reales registradas | Cerrada para Unidad 00 |
| TD-004 | Decidir tratamiento de directorios vacíos | Baja | Bootstrap | Resuelto mediante `.gitkeep` | Cerrada |
| TD-005 | Incorporar `EndpointSlice` como observación posterior al Service clásico | Baja | Unidad 01 | Resuelto en Unidad 02 como comprobación principal de endpoints | Cerrada |
| TD-006 | Hardening pedagógico global del itinerario | Alta | Revisión de Unidad 01 y feedback posterior del usuario | `student-notes.md` de Unidades 01-05 reestructurado y aprobado como guia de aprendizaje; Unidad 00 conserva su formato previo aprobado | Cerrada para Unidades 01-05; aplicar criterio en futuras unidades |
| TD-007 | Reforzar prompts y plantillas de generación pedagógica | Alta | Feedback del usuario tras hardening mínimo y revisión de `student-notes.md` | `playbooks/master.md` y `playbooks/unit-template.md` actualizados para describir guías de aprendizaje academicas y aplicadas, evitando estructuras enciclopédicas por defecto | Cerrada |
| TD-008 | Reabrir Framework V2 para reforzar contrato didactico y revisar lagunas de Unidades 00-07 | Alta | Feedback del usuario tras aprobar Unidad 07 | Framework simplificado; `student-reference.md` queda como recurso opcional y las lagunas se registran en `project/content-gap-register.md` | Cerrada |
| TD-009 | Decidir si falta una unidad de contenedores, imagen y registro antes de Tekton | Alta | `project/content-gap-register.md` `GAP-001` | Resuelto como `tutorial/00-environment/student-reference.md` y laboratorio de acompañamiento de solo lectura, sin unidad nueva ni cambios tecnicos | Cerrada |

## Lagunas de contenido

| Registro | Estado | Siguiente acción |
|---|---|---|
| `project/content-gap-register.md` | 1 laguna cerrada y 8 abiertas | Revisar lagunas restantes cuando afecten al siguiente bloque; Unidad 08 puede avanzar a playbook |

---

# Validaciones globales disponibles

| Validación | Método | Resultado esperado |
|---|---|---|
| Validación integrada del entorno | `bash platform/environment/validation/validate-environment.sh` | Sin fallos bloqueantes |
| Estado del cluster | `kubectl get nodes` | Nodo `gmktecg2` en `Ready` |
| Estado de namespaces | `kubectl get namespaces` | `platform-training` activo junto a namespaces de sistema |
| Sintaxis cliente de Unidad 01 | `kubectl apply --dry-run=client -f labs/01-kubernetes/solution/` | Manifiestos aceptados por el cliente |
| Despliegue Unidad 01 | `kubectl apply -f labs/01-kubernetes/solution/namespace.yaml -f labs/01-kubernetes/solution/deployment.yaml -f labs/01-kubernetes/solution/service.yaml` | Namespace, Deployment y Service aplicados |
| Estado de la aplicación | `bash labs/01-kubernetes/validation/validate.sh` | 0 fallos; Deployment 2/2; Pods Running; Service con endpoints; logs legibles |
| Sintaxis cliente de Unidad 02 | `kubectl apply --dry-run=client -f labs/02-configuration-lifecycle/solution/` | Manifiestos aceptados por el cliente |
| Despliegue Unidad 02 | `kubectl apply -f labs/02-configuration-lifecycle/solution/namespace.yaml -f labs/02-configuration-lifecycle/solution/configmap.yaml -f labs/02-configuration-lifecycle/solution/secret.yaml -f labs/02-configuration-lifecycle/solution/deployment.yaml -f labs/02-configuration-lifecycle/solution/service.yaml` | Namespace y recursos aplicados; ConfigMap y Secret creados; Deployment y Service configurados |
| Estado de la aplicación | `bash labs/02-configuration-lifecycle/validation/validate.sh` | 0 fallos; Deployment 2/2; Pods Ready; ConfigMap, Secret, probes, resources, Service y EndpointSlice validados |
| Inventario de aplicación | `kubectl -n platform-training get deploy,rs,pods,svc,endpointslice -l app.kubernetes.io/name=platform-api` | Recursos de `platform-api` visibles |
| HTTP local | `kubectl -n platform-training port-forward service/platform-api 18080:80` y `curl -i http://127.0.0.1:18080/` | `HTTP/1.1 200 OK`; contenido de Unidad 02 servido desde ConfigMap |
| Sintaxis cliente de Unidad 03 | `kubectl apply --dry-run=client -f labs/03-networking-ingress/solution/` | Manifiestos aceptados por el cliente |
| Despliegue Unidad 03 | `kubectl apply -f labs/03-networking-ingress/solution/` | Namespace, ConfigMap, Secret, Deployment, Service e Ingress aplicados |
| Addon Ingress MicroK8s | `microk8s enable ingress` y `microk8s status --wait-ready` | Addon `ingress` habilitado; Traefik `v3.6.2` desplegado; `IngressClass/public` disponible |
| Estado de la aplicación por Ingress | `bash labs/03-networking-ingress/validation/validate.sh` | 0 fallos; Deployment 2/2; Service `ClusterIP`; EndpointSlice, DNS interno, Ingress Controller, Ingress y HTTP validados |
| HTTP por Ingress local | `curl -i -H 'Host: platform-api.local' http://127.0.0.1/` | `HTTP/1.1 200 OK`; contenido de Unidad 05 servido desde ConfigMap |
| Sintaxis cliente de Unidad 04 | `kubectl apply --dry-run=client -f labs/04-persistence-state/solution/` | Manifiestos aceptados por el cliente |
| Despliegue Unidad 04 | `kubectl apply -f labs/04-persistence-state/solution/` | Recursos aplicados |
| Addon storage MicroK8s | `microk8s enable hostpath-storage` | Addon habilitado; `storage` aparece como alias de `hostpath-storage` |
| StorageClass Unidad 04 | `kubectl get storageclass` | `microk8s-hostpath (default)` disponible |
| Estado de persistencia Unidad 04 | `bash labs/04-persistence-state/validation/validate.sh` | 0 fallos, 0 avisos; PVC `Bound`, PV, mount, escritura, recreación de Pod, Service e Ingress validados |
| Revisión pedagógica Unidad 04 | Aprobación del usuario el 2026-07-19 | Aprobada |
| Sintaxis cliente de Unidad 05 | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/` | Manifiestos aceptados por el cliente |
| Despliegue Unidad 05 | `kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/` | Namespace, ConfigMap, Secret, PVC, PDB, Deployment, Service e Ingress aplicados |
| Estado de scheduling y resiliencia Unidad 05 | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh` | 0 fallos, 0 avisos; Deployment, PDB, Pods asignados, Service, EndpointSlice, Ingress, PVC, HTTP, recreacion de Pod y rollout history validados |
| Sintaxis Bash Unidad 06 | `bash -n labs/06-helm-packaging/validation/validate.sh` | 0 |
| Sintaxis Bash adopcion Unidad 06 | `bash -n labs/06-helm-packaging/validation/adopt-existing-resources.sh` | 0 |
| Helm lint Unidad 06 | `helm lint labs/06-helm-packaging/chart/platform-api` | 1 chart linted, 0 failed; recomendacion informativa de icon no bloqueante |
| Renderizado Helm Unidad 06 | `helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml` | Manifiestos renderizados correctamente |
| Sintaxis cliente del renderizado Unidad 06 | `helm template platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training -f labs/06-helm-packaging/chart/platform-api/values-local.yaml \| kubectl apply --dry-run=client -f -` | Namespace, PDB, Secret, ConfigMap, PVC, Service, Deployment e Ingress aceptados por dry-run cliente |
| Adopcion Helm Unidad 06 | `bash labs/06-helm-packaging/validation/adopt-existing-resources.sh` | Metadatos Helm aplicados a recursos heredados sin borrar recursos ni PVC |
| Instalacion Helm Unidad 06 | `helm upgrade --install platform-api-local labs/06-helm-packaging/chart/platform-api --namespace platform-training --create-namespace -f labs/06-helm-packaging/chart/platform-api/values-local.yaml` | Release instalado en revision 1 |
| Rollback Helm Unidad 06 | Upgrade temporal a revision 2 con `replicaCount=1` y `helm rollback platform-api-local 1 --namespace platform-training` | Rollback correcto; revision 3 desplegada |
| Validacion funcional Unidad 06 | `bash labs/06-helm-packaging/validation/validate.sh` tras rollback | 0 fallos, 0 avisos; release deployed, 2 Pods Ready, Service, EndpointSlice, Ingress, PVC, PDB y HTTP validados |
| Revision pedagogica Unidad 06 | Aprobacion del usuario el 2026-07-19 | Aprobada |
| Sintaxis Bash Unidad 07 | `bash -n labs/07-local-terraform-automation/validation/validate.sh` | 0 |
| Terraform fmt Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform fmt -check -recursive` | 0 |
| Terraform init Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform init` | Providers instalados: `hashicorp/helm` `2.17.0`, `hashicorp/kubernetes` `2.38.0`; `.terraform.lock.hcl` creado |
| Terraform validate Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform validate` | `Success! The configuration is valid.` |
| Terraform plan Unidad 07 antes de import | `terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example` | `1 to add, 0 to change, 0 to destroy`; evidencio release existente fuera de state |
| Terraform import Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform import -var-file=terraform.tfvars.example helm_release.platform_api platform-training/platform-api-local` | Import correcto; `helm_release.platform_api` queda en state local |
| Terraform plan Unidad 07 tras import | `terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example` | `0 to add, 1 to change, 0 to destroy` |
| Terraform apply Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform apply -var-file=terraform.tfvars.example -auto-approve` | `0 added, 1 changed, 0 destroyed`; outputs no sensibles generados |
| Terraform plan final Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example` | `No changes. Your infrastructure matches the configuration.` |
| Terraform state Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform state list` | `data.kubernetes_namespace.platform_training` y `helm_release.platform_api` |
| Terraform output Unidad 07 | `terraform -chdir=labs/07-local-terraform-automation/terraform output` | `release_status = "deployed"`, `release_namespace = "platform-training"` |
| Validacion funcional Unidad 07 | `bash labs/07-local-terraform-automation/validation/validate.sh` | 0 fallos, 0 avisos; Terraform, Helm release, Deployment, Service, Ingress, PVC, PDB y secret scan validados |
| Validacion heredada tras Unidad 07 | `bash labs/06-helm-packaging/validation/validate.sh` | 0 fallos, 0 avisos; `platform-api-local` revision 4 `deployed` |
| Revision pedagogica Unidad 07 | Aprobacion del usuario el 2026-07-20 | Aprobada |
| Revisión pedagógica `student-notes.md` Unidades 01-05 | Aprobación del usuario el 2026-07-19 tras reestructuración como guías de aprendizaje | Aprobada |
| Revisión pedagógica Unidad 01 | Aprobación del usuario con observación sobre nivel de entrada y enfoque del contenido | Aprobada; deuda registrada para hardening global |
| Revisión pedagógica Unidad 02 | Aprobación del usuario el 2026-07-18 | Aprobada |
| Revisión pedagógica Unidad 03 | Aprobación del usuario el 2026-07-19 junto con el refuerzo `student-notes.md` | Aprobada |
| Hardening pedagógico global inicial | Revisión documental de `tutorial/00-environment/`, `tutorial/01-kubernetes/`, `tutorial/02-configuration-lifecycle/` y summaries | Aceptado por el usuario como cambio mínimo; deuda pedagógica profunda sigue abierta |
| Refuerzo pedagógico README Unidades 00-03 | Revisión documental de `tutorial/00-environment/README.md`, `tutorial/01-kubernetes/README.md`, `tutorial/02-configuration-lifecycle/README.md` y `tutorial/03-networking-ingress/README.md` | Guías pedagógicas, mapas de aprendizaje y preguntas centrales añadidas; aprobado por el usuario |
| Student notes Unidades 00-03 | Revisión documental de `tutorial/00-environment/student-notes.md`, `tutorial/01-kubernetes/student-notes.md`, `tutorial/02-configuration-lifecycle/student-notes.md` y `tutorial/03-networking-ingress/student-notes.md` | Notas pedagógicas creadas, enlazadas desde los README, aprobadas por el usuario y comiteadas en `b842f33`; Unidades 01-03 reestructuradas posteriormente como guías de aprendizaje |
| Chart Helm Unidad 06 | `find labs/06-helm-packaging -type f -name 'Chart.yaml' -print` | `labs/06-helm-packaging/chart/platform-api/Chart.yaml` |
| Proyecto Terraform Unidad 07 | `find labs/07-local-terraform-automation/terraform -maxdepth 2 -type f -print` | Configuracion Terraform local, `.terraform.lock.hcl`, plantilla de values y `.gitignore` presentes |

Validaciones no disponibles en esta sesión:

- `shellcheck`, no instalado;
- validaciones Windows/WSL desde PowerShell, por ejecutarse desde el host Windows cuando se replique el laboratorio.

---

# Historial de incrementos

| Orden | Incremento | Estado | Resultado |
|---|---|---|---|
| 1 | `README.md` | Completado | Marco general del repositorio |
| 2 | `project/architecture.md` | Completado | Arquitectura y decisiones iniciales |
| 3 | `project/project-state.md` | Completado | Estado inicial del bootstrap |
| 4 | `project/roadmap.md` | Completado | Itinerario y dependencias |
| 5 | `playbooks/master.md` | Completado | Reglas globales |
| 6 | `playbooks/unit-template.md` | Completado | Plantilla de unidades |
| 7 | `playbooks/summary-template.md` | Completado | Contrato de continuidad |
| 8 | `playbooks/project-state-template.md` | Completado | Gobierno del estado |
| 9 | `playbooks/units/00-environment.md` | Completado | Playbook de Unidad 00 |
| 10 | Revisión y cierre del bootstrap | Completado | Contenido aprobado y framework operativo |
| 11 | Actualización de `project/project-state.md` | Completado | Bootstrap declarado formalmente completo |
| 12 | Cierre y sincronización del Framework V1 | Completado | Inventario, árbol, ADR y estado sincronizados; Framework V1 congelado |
| 13 | Corrección de inconsistencias del framework | Completado | Handoff alineado, estado documental sincronizado y rutas base materializadas con `.gitkeep` |
| 14 | Inicio de diseño de la Unidad 00 | Completado | Unidad 00 iniciada; `kubectl` definido como cliente principal; diseño inicial creado |
| 15 | Política inicial de versiones de Unidad 00 | Completado | Baseline definida para Ubuntu, MicroK8s, Kubernetes, kubectl, Helm y Terraform |
| 16 | Scripts iniciales de validación de Unidad 00 | Completado | Validaciones no destructivas creadas para Windows y Ubuntu/WSL |
| 17 | Ajuste de validaciones iniciales | Completado | Validaciones expresadas como criterios del entorno objetivo |
| 18 | Preparación de Ubuntu WSL | Completado | Script Windows creado para validar e instalar explícitamente `Ubuntu-24.04` |
| 19 | Instalación de Ubuntu WSL | Completado | El usuario instaló `Ubuntu-24.04` y obtuvo primer arranque correcto |
| 20 | Validación Linux inicial | Completado | Ubuntu 24.04.4 LTS validada en WSL2 |
| 21 | Guía WSL/Ubuntu y continuidad VS Code WSL | Completado | Tutorial y referencia técnica actualizados |
| 22 | Scripts y documentación MicroK8s/kubectl | Completado | Scripts idempotentes generados |
| 23 | Instalación real MicroK8s/kubectl y corrección de validación | Completado | MicroK8s `v1.35.6` y `kubectl` `v1.35.6` instalados |
| 24 | Validación real MicroK8s/kubectl | Completado | Validaciones sin fallos bloqueantes |
| 25 | Scripts Helm/Terraform | Completado | Scripts idempotentes generados |
| 26 | Validación real Helm/Terraform | Completado | Helm `v3.21.0+ge0878d4` y Terraform `1.15.7` instalados y validados |
| 27 | Cierre de Unidad 00 | Completado | Unidad 00 cerrada con limitaciones Windows/WSL documentadas |
| 28 | Playbook de Unidad 01 | Completado | `playbooks/units/01-kubernetes.md` creado y planning alineado |
| 29 | Ajuste conceptual de Unidad 01 | Completado | Playbook ampliado con arquitectura, CRI/CNI/CSI, configuración, Gateway API y mapa de observabilidad |
| 30 | Generación y validación de Unidad 01 | Completado con limitaciones | Tutorial, instructor notes, summary, laboratorio, manifiestos y validación creados; `platform-api` desplegada y validada en MicroK8s |
| 31 | Ajuste de flujo de revisión y referencias de Unidad 01 | Completado con limitaciones | Flujo actualizado para distinguir validación técnica y aprobación del usuario; README de Unidad 01 ampliado con guía inicial y referencias oficiales |
| 32 | Registro de deuda de hardening pedagógico global | Completado | Observación del usuario registrada: Unidad 01 tiene entrada exigente y enfoque demasiado centrado en laboratorio; revisión pedagógica profunda diferida |
| 33 | Aprobación de Unidad 01 | Completado | El usuario aprueba la Unidad 01 y se permite continuar con el playbook de Unidad 02 |
| 34 | Playbook de Unidad 02 | Completado con revisión pendiente | `playbooks/units/02-configuration-lifecycle.md` creado; `project/project-state.md` actualizado |
| 35 | Mejora de plantilla de unidades | Completado | `playbooks/unit-template.md` actualizado para exigir referencias oficiales o fuentes primarias en tutoriales; playbook de Unidad 02 alineado |
| 36 | Aprobación del playbook de Unidad 02 | Completado | El usuario aprueba `playbooks/units/02-configuration-lifecycle.md`; se permite generar la Unidad 02 |
| 37 | Generación y validación técnica de Unidad 02 | Completado | Tutorial, instructor notes, summary, laboratorio, manifiestos y validación creados; `platform-api` evolucionada con ConfigMap, Secret ficticio, probes, resources y validación funcional en MicroK8s |
| 38 | Aprobación de Unidad 02 | Completado | El usuario revisa y aprueba la Unidad 02; se permite generar el playbook de la Unidad 03 |
| 39 | Hardening pedagógico global inicial de Unidades 00-02 | Completado como cambio mínimo | Tutoriales reforzados como material formativo principal; instructor notes y summaries actualizados; sin cambios en manifiestos ni scripts; el usuario lo acepta como mínimo |
| 40 | Actualización de reglas pedagógicas de generación | Completado | El usuario acepta el hardening como cambio mínimo, registra que el nivel pedagógico sigue siendo pobre y se actualizan `playbooks/master.md` y `playbooks/unit-template.md` |
| 41 | Acuerdo de fase pedagógica posterior para README | Completado | Se registra que el desarrollo profundo de README puede abordarse como fase posterior sin avanzar capacidades técnicas; `project/project-planning.md` actualizado |
| 42 | Playbook de Unidad 03 | Completado con revisión pendiente | `playbooks/units/03-networking-ingress.md` creado en borrador; `project/project-state.md` actualizado |
| 43 | Aprobación del playbook de Unidad 03 | Completado | El usuario aprueba `playbooks/units/03-networking-ingress.md`; se permite generar la Unidad 03 |
| 44 | Generación y validación técnica de Unidad 03 | Completado y aprobado | Tutorial, instructor notes, summary, laboratorio, manifiestos y validación creados; `platform-api` expuesta por Ingress HTTP local, validada en MicroK8s y aprobada pedagógicamente |
| 45 | Refuerzo pedagógico README Unidades 00-03 | Completado y aprobado | Se añaden guías pedagógicas, mapas de aprendizaje y preguntas centrales sin modificar laboratorios ni capacidades técnicas |
| 46 | Estructura `student-notes.md` y notas de alumno Unidades 00-03 | Completado y aprobado | `student-notes.md` incorporado al contrato de unidad; notas de alumno creadas, README enlazados, summaries actualizados y commit `b842f33` confirmado |
| 47 | Cierre de revisión pedagógica transversal | Completado | `project-state.md` y `tutorial/03-networking-ingress/summary.md` actualizados para registrar aprobación y permitir el playbook de Unidad 04 |
| 48 | Generación de Unidad 04 | Completado | Tutorial, student notes, instructor notes, summary, laboratorio, manifiestos y validación creados; dry-run cliente correcto |
| 49 | Aprobación pedagógica de Unidad 04 | Completado | El usuario aprueba la Unidad 04 el 2026-07-19 y confirma commit `1a588fa Generate and approve unit 04 persistence` |
| 50 | Validación funcional de Unidad 04 | Completado | `hostpath-storage` habilitado; PVC `platform-api-data` `Bound`; `bash labs/04-persistence-state/validation/validate.sh` con 0 fallos y 0 avisos |
| 51 | Playbook de Unidad 05 | Completado | `playbooks/units/05-scheduling-resilience-maintenance.md` creado; `project/project-state.md` actualizado |
| 52 | Aprobación del playbook de Unidad 05 | Completado | El usuario aprueba el playbook de Unidad 05 el 2026-07-19 y confirma commit `361b2df Generate unit 05 scheduling playbook` |
| 53 | Generación y validación funcional de Unidad 05 | Completado | Tutorial, student notes, instructor notes, summary, laboratorio, manifiestos y validación creados; `platform-api` evolucionada con scheduling seguro, `RollingUpdate`, PDB y validación funcional en MicroK8s |
| 54 | Reestructuración y aprobación de `student-notes.md` Unidades 01-05 | Completado y aprobado | Guías de aprendizaje reestructuradas con capa académica, construcción aplicada, relaciones, comprobación, diagnóstico de fallos típicos, continuidad y fuentes; aprobación del usuario el 2026-07-19 |
| 55 | Alineación de playbooks y documentos de `project/` con guías del alumno | Completado | `project/architecture.md`, `project/project-planning.md`, `project/project-state.md`, `playbooks/master.md`, `playbooks/unit-template.md` y playbooks específicos 04-05 ajustados al nuevo contrato |
| 56 | Playbook de Unidad 06 | Aprobado por instruccion de generacion | `playbooks/units/06-helm-packaging.md` creado; incorpora `student-reference.md` avanzado como entregable requerido y difiere Terraform ejecutable a Unidad 07 |
| 57 | Generacion, validacion funcional y aprobacion de Unidad 06 | Completado y aprobado | Tutorial, student notes, student reference, instructor notes, summary, laboratorio, chart Helm local, script de adopcion y validacion creados; release `platform-api-local` instalado, rollback validado, validacion final con 0 fallos, 0 avisos y aprobacion pedagogica del usuario |
| 58 | Playbook de Unidad 07 | Completado y aprobado | `playbooks/units/07-local-terraform-automation.md` creado y aprobado por el usuario el 2026-07-20; define Terraform como automatizacion local del release Helm de `platform-api` e incorpora `student-reference.md` avanzado sobre arquitectura Terraform |
| 59 | Generacion, validacion funcional y aprobacion de Unidad 07 | Completado y aprobado | Tutorial, student notes, student reference, instructor notes, summary, laboratorio, proyecto Terraform local y validacion creados; release importado a Terraform, apply ejecutado con 0 destrucciones, validaciones finales con 0 fallos, 0 avisos y aprobacion pedagogica del usuario |
| 60 | Apertura Framework V2 didactico | Completado | `project/project-planning.md` y `project/project-state.md` registran la pausa de Unidad 08 y el inicio de ajuste didactico transversal |
| 61 | Simplificacion Framework V2 y registro de lagunas | Completado | Playbooks base ajustados de forma ligera para `student-reference.md` como referencia amplia; `project/content-gap-register.md` registra lagunas de contenedores, secretos, TLS, workloads, progressive delivery, multi-tenancy, ciclo de vida, coste y desacoplamiento de MicroK8s |
| 62 | Resolucion documental de GAP-001 | Completado con aprobación pedagógica pendiente | `tutorial/00-environment/student-reference.md` y `platform/environment/container-images/README.md` creados sobre contenedores, imagenes y registros; Unidad 01 enlazada; no cambia scripts, manifests ni estado tecnico del cluster |

---

# Siguiente incremento permitido

El siguiente incremento principal es:

```text
Generar el playbook de la Unidad 08 — Integración continua con Tekton
```

## Fuentes obligatorias

La sesión deberá leer:

```text
project/project-state.md
project/content-gap-register.md
playbooks/master.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
project/project-planning.md
project/architecture.md
playbooks/units/00-environment.md
playbooks/units/01-kubernetes.md
playbooks/units/02-configuration-lifecycle.md
playbooks/units/03-networking-ingress.md
playbooks/units/04-persistence-state.md
playbooks/units/05-scheduling-resilience-maintenance.md
playbooks/units/06-helm-packaging.md
playbooks/units/07-local-terraform-automation.md
tutorial/00-environment/
tutorial/01-kubernetes/
tutorial/02-configuration-lifecycle/
tutorial/03-networking-ingress/
tutorial/04-persistence-state/
tutorial/05-scheduling-resilience-maintenance/
tutorial/06-helm-packaging/
tutorial/07-local-terraform-automation/
project/roadmap.md
```

## Trabajo permitido

- generar `playbooks/units/08-tekton.md`;
- definir alcance, dependencias, entregables y validaciones de Unidad 08;
- reutilizar `tutorial/07-local-terraform-automation/summary.md`, `labs/07-local-terraform-automation/` y el chart Helm de Unidad 06;
- tener en cuenta `tutorial/00-environment/student-reference.md` y `platform/environment/container-images/README.md` como base conceptual y laboratorio de lectura de imagenes antes de diseñar CI.

## Trabajo todavía prohibido

- instalar Tekton o crear recursos Tekton;
- crear Terraform cloud o backends remotos fuera del alcance futuro aprobado;
- incorporar CI/CD, GitOps, observabilidad avanzada, seguridad avanzada o cloud;
- sustituir MicroK8s por otra plataforma local;
- sustituir la aplicación evolutiva sin decisión documentada.

---

# Regla de actualización

Este documento deberá actualizarse:

1. al generar el playbook de la siguiente unidad permitida;
2. al iniciar formalmente una nueva unidad;
3. después de generar artefactos;
4. después de recibir resultados reales de validación;
5. al cerrar cada unidad;
6. antes de permitir contenido que dependa de trabajo todavía no validado.

Las actualizaciones deberán reflejar únicamente hechos verificables en el repositorio o resultados de ejecución proporcionados por el usuario.
