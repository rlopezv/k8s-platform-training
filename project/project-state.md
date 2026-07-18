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
| Fase actual | Unidad 03 — Networking e ingreso |
| Estado general | Playbook de Unidad 03 aprobado; Unidad 02 completada, validada técnicamente y aprobada |
| Último incremento completado | Aprobación del playbook de la Unidad 03 — Networking e ingreso |
| Unidad activa | 03 — Networking e ingreso, playbook aprobado; contenido no generado |
| Última unidad completada | 02 — Configuración, secretos y ciclo de vida |
| Laboratorio disponible | Sí, entorno base local y primera aplicación |
| Plataforma local desplegada | Sí, MicroK8s local validado |
| Contenido formativo generado | Sí, Unidades 00, 01 y 02 con hardening pedagógico inicial mínimo |
| Framework de generación | Validado y congelado (Framework V1) |
| Siguiente incremento permitido | Generar la Unidad 03 — Networking e ingreso |

---

# Fase actual

El proyecto ha completado la **Unidad 00 — Preparación del entorno**, la **Unidad 01 — Fundamentos operativos y primera aplicación** y la **Unidad 02 — Configuración, secretos y ciclo de vida**.

La Unidad 01 incorporó la primera aplicación evolutiva del curso, `platform-api`, desplegada sobre MicroK8s mediante manifiestos Kubernetes estándar. El laboratorio local ya contiene un namespace funcional, un Deployment, Pods gestionados por ReplicaSet y un Service interno.

La revisión del usuario aprobó la Unidad 01. También identificó que el contenido tiene un nivel de entrada exigente y está más orientado a explicar el laboratorio que a construir una visión amplia sobre Kubernetes. Esta observación queda registrada como deuda pedagógica para una futura sesión de hardening global, preferiblemente cuando existan varias unidades y pueda revisarse la progresión completa.

El 2026-07-18 se generó un hardening pedagógico global inicial sobre las Unidades 00, 01 y 02. El cambio refuerza los tutoriales como material formativo principal, separa mejor teoría y operación, añade modelos mentales, decisiones de diseño, errores de razonamiento y lectura guiada. No modifica manifiestos, scripts ni el estado funcional del clúster. El usuario aceptó estos cambios como cambios mínimos, pero indicó que el nivel pedagógico de los README sigue siendo realmente pobre para formar a personas que todavía no conocen los temas tratados.

Como consecuencia, se actualizaron `playbooks/master.md` y `playbooks/unit-template.md` para exigir que futuras unidades no asuman dominio previo del tema, construyan modelo mental desde el problema real, expliquen conceptos con progresión didáctica y mantengan una separación más estricta entre tutorial formativo y laboratorio operativo.

El usuario y el proyecto acuerdan que el nivel pedagógico deseado puede abordarse en una fase posterior dedicada específicamente a desarrollar los `README.md` como soporte formativo profundo. Esta fase no debe avanzar capacidades técnicas ni sustituir laboratorios; debe ampliar teoría, modelos mentales, ejemplos conceptuales, razonamiento, lectura guiada y progresión didáctica. La deuda queda abierta y no bloquea por sí sola la revisión del playbook de Unidad 03 ni la generación posterior de la unidad cuando el playbook sea aprobado.

La siguiente fase de trabajo es preparar la **Unidad 03 — Networking e ingreso**. El playbook de Unidad 03 existe y esta aprobado en `playbooks/units/03-networking-ingress.md`.

Durante esta fase se permite:

- generar la Unidad 03 — Networking e ingreso siguiendo el playbook aprobado;
- reutilizar `tutorial/02-configuration-lifecycle/summary.md` como fuente de continuidad;
- reutilizar `labs/02-configuration-lifecycle/solution/` como estado activo de la aplicación;
- mantener visible cualquier ajuste pedagógico posterior sin resolverlo dentro del playbook de Unidad 03 salvo decisión explícita.

Todavía no se permite:

- crear charts Helm;
- crear módulos Terraform;
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
| `README.md` | Completo y aprobado | Bootstrap-01 | Punto de entrada y visión general |
| `project/architecture.md` | Completo y aprobado | Bootstrap-02 | Arquitectura y decisiones estructurales |
| `project/project-state.md` | Actualizado con reglas pedagógicas y deuda reforzada | Pedagogical-Hardening-Rules | Estado consolidado |
| `project/roadmap.md` | Completo y aprobado | Unit-00-01 | Evolución prevista del itinerario |
| `project/project-planning.md` | Actualizado | Pedagogical-Deepening-Phase | Planificación incremental del trabajo; incluye sesiones de desarrollo pedagógico profundo |
| `project/how-to.md` | Actualizado | Unit-01-Review-Flow | Mecanismo operativo de trabajo con asistentes de IA; distingue validación técnica de aprobación del usuario |
| `playbooks/master.md` | Actualizado | Pedagogical-Hardening-Rules | Reglas globales de generación; exige tutoriales pedagógicos para alumnos que no dominan aún el tema |
| `playbooks/unit-template.md` | Actualizado | Pedagogical-Hardening-Rules | Plantilla de playbooks específicos; exige problema real, modelo mental, progresión conceptual, trade-offs y lectura guiada |
| `playbooks/summary-template.md` | Completo y aprobado | Bootstrap-07 | Contrato de continuidad |
| `playbooks/project-state-template.md` | Completo y aprobado | Bootstrap-08 | Reglas de mantenimiento del estado |
| `playbooks/generate-session-handoff.md` | Completo y aprobado | Framework-03 | Generación del handoff derivado de sesión |
| `playbooks/units/00-environment.md` | Completo y aprobado | Unit-00-01 | Gobierno de la Unidad 00 |
| `playbooks/units/01-kubernetes.md` | Completo y aprobado | Unit-01-Concept-Scope | Gobierno de la Unidad 01 |
| `playbooks/units/02-configuration-lifecycle.md` | Completo y aprobado | Unit-02-Playbook-Approval | Gobierno de la Unidad 02 |
| `playbooks/units/03-networking-ingress.md` | Completo y aprobado | Unit-03-Playbook-Approval | Gobierno de la Unidad 03 |
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
│       └── 03-networking-ingress.md
├── project/
│   ├── architecture.md
│   ├── how-to.md
│   ├── project-planning.md
│   ├── project-state.md
│   └── roadmap.md
└── tutorial/
    ├── .gitkeep
    ├── 00-environment/
    │   ├── instructor-notes.md
    │   ├── README.md
    │   └── summary.md
    ├── 01-kubernetes/
    │   ├── instructor-notes.md
    │   ├── README.md
    │   └── summary.md
    └── 02-configuration-lifecycle/
        ├── instructor-notes.md
        ├── README.md
        └── summary.md
```

## Estado de directorios

| Directorio | Estado | Contenido actual |
|---|---|---|
| `assets/` | Previsto y materializado | Solo `.gitkeep`; sin artefactos formativos |
| `labs/` | Materializado con Unidades 01 y 02 | `.gitkeep`, `01-kubernetes/` y `02-configuration-lifecycle/` |
| `platform/environment/` | Completo para la Unidad 00 | Scripts de preparación, validación y herramientas base |
| `playbooks/` | Operativo | Framework completo y playbooks de Unidades 00, 01 y 02 |
| `project/` | Operativo | Arquitectura, estado y roadmap |
| `tutorial/` | Unidades 00, 01 y 02 generadas | Documentación de alumno, instructor notes y summaries |

---

# Estado de las unidades

| Unidad | Estado | Tutorial | Laboratorio o plataforma | Instructor notes | Summary |
|---|---|---|---|---|---|
| 00 — Preparación del entorno | Completada con limitaciones; hardening pedagógico inicial mínimo aceptado | Sí | Sí, `platform/environment/` | Sí | Sí |
| 01 — Fundamentos operativos y primera aplicación | Completada y aprobada; hardening pedagógico inicial mínimo aceptado | Sí | Sí, `labs/01-kubernetes/` | Sí | Sí |
| 02 — Configuración, secretos y ciclo de vida | Completada y aprobada; hardening pedagógico inicial mínimo aceptado | Sí | Sí, `labs/02-configuration-lifecycle/` | Sí | Sí |
| 03 — Networking e ingreso | Playbook aprobado; unidad no generada | No | No | No | No |
| 04–25 | Previstas en roadmap | No | No | No | No |

## Unidad 00 — Preparación del entorno

| Campo | Estado |
|---|---|
| Estado | Completada y aprobada con limitaciones; hardening pedagógico inicial mínimo aceptado |
| Fecha de inicio | 2026-07-17 |
| Fecha de cierre | 2026-07-18 |
| Playbook | `playbooks/units/00-environment.md` |
| Tutorial | `tutorial/00-environment/README.md` |
| Artefactos ejecutables | `platform/environment/` |
| Instructor notes | `tutorial/00-environment/instructor-notes.md` |
| Summary | `tutorial/00-environment/summary.md` |

Limitaciones activas:

- Windows 11, virtualización, salida completa de `wsl --status` y `wsl --list --verbose` siguen siendo validaciones por equipo al replicar el laboratorio.
- Los scripts de Unidad 00 no deben modificarse salvo corrección justificada.

## Unidad 01 — Fundamentos operativos y primera aplicación

| Campo | Estado |
|---|---|
| Estado | Completada con limitaciones documentadas; hardening pedagógico inicial mínimo aceptado |
| Fecha de inicio | 2026-07-18 |
| Fecha de cierre | 2026-07-18 |
| Playbook | `playbooks/units/01-kubernetes.md` |
| Tutorial | `tutorial/01-kubernetes/README.md` |
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
- Ingress, Gateway API, DNS y TLS quedan diferidos a Unidad 03;
- Helm y Terraform siguen sin gestionar recursos del curso.

## Unidad 03 — Networking e ingreso

| Campo | Estado |
|---|---|
| Estado | Playbook aprobado; unidad no generada |
| Fecha de inicio | No aplica |
| Fecha de cierre | No aplica |
| Playbook | `playbooks/units/03-networking-ingress.md` |
| Tutorial | No existe |
| Laboratorio | No existe |
| Instructor notes | No existe |
| Summary | No existe |

Alcance aprobado del playbook:

- reutilizar `platform-api`, `platform-training` y `labs/02-configuration-lifecycle/solution/`;
- conservar el Service `platform-api` como `ClusterIP`;
- introducir DNS interno, EndpointSlice, Ingress Controller local de MicroK8s e `Ingress` HTTP;
- tratar Gateway API como comparación conceptual salvo decisión explícita y validación real;
- diferir TLS productivo, DNS público, LoadBalancer cloud, NetworkPolicies, Helm, Terraform, CI/CD, GitOps, observabilidad avanzada y cloud.

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
| Addons | `dns` habilitado; addons core adicionales observados por MicroK8s | `dns`, `ha-cluster`, `helm`, `helm3` | `bash platform/environment/validation/validate-environment.sh` |

## Namespaces

| Namespace | Estado | Propósito | Definición |
|---|---|---|---|
| `default` | Activo | Namespace estándar | Kubernetes |
| `kube-node-lease` | Activo | Sistema | Kubernetes |
| `kube-public` | Activo | Sistema | Kubernetes |
| `kube-system` | Activo | Sistema | Kubernetes |
| `platform-training` | Activo | Recursos funcionales del curso | `labs/02-configuration-lifecycle/solution/namespace.yaml` |

## Workloads

| Recurso | Namespace | Estado esperado | Definición |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `2/2` replicas disponibles, con ConfigMap, Secret, probes y resources | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| `replicaset/platform-api-66fb76b758` | `platform-training` | 2 deseadas, 2 actuales, 2 ready | Generado por Deployment |
| Pods `platform-api-66fb76b758-*` | `platform-training` | 2 Pods `Running`, `1/1`, 0 restarts | Generados por ReplicaSet |

## Endpoints

| Servicio | Acceso | Estado | Propósito |
|---|---|---|---|
| `service/platform-api` | `ClusterIP` `10.152.183.150`, puerto `80/TCP` hacia contenedor `8080` | Activo | Acceso interno estable a `platform-api` |
| `endpointslice/platform-api-fbxzx` | `10.1.16.71:8080`, `10.1.16.72:8080` observados durante validación | Activo | Evidencia preferente de selección de Pods Ready por el Service |
| Port-forward local | `http://127.0.0.1:18080/` durante la prueba | Validado con `HTTP/1.1 200 OK` y contenido de Unidad 02 desde ConfigMap | Prueba HTTP desde la máquina local |

---

# Herramientas y versiones

| Herramienta | Estado | Versión activa | Método de comprobación | Incorporada en |
|---|---|---|---|---|
| Git | Validado en Ubuntu WSL | `/usr/bin/git` | `platform/environment/linux/check-prerequisites.sh` | Unidad 00 |
| kubectl | Instalado y operativo contra MicroK8s | `v1.35.6` | `kubectl version --client`, `kubectl get nodes` | Unidad 00 |
| Helm | Instalado y validado como CLI; no gestiona recursos del curso | `v3.21.0+ge0878d4` | `platform/environment/tools/validate-tools.sh` | Unidad 00 |
| Terraform | Instalado y validado como CLI; no gestiona recursos del curso | `1.15.7` | `platform/environment/tools/validate-tools.sh` | Unidad 00 |
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
| Versión actual | Unidad 02 |
| Repositorio o ruta | `labs/02-configuration-lifecycle/solution/` |

## Componentes

| Componente | Estado | Imagen o versión | Definición |
|---|---|---|---|
| `Deployment/platform-api` | Desplegado y validado | `nginxinc/nginx-unprivileged:1.27.4-alpine` | `labs/02-configuration-lifecycle/solution/deployment.yaml` |
| `Service/platform-api` | Desplegado y validado | `ClusterIP` | `labs/02-configuration-lifecycle/solution/service.yaml` |
| `ConfigMap/platform-api-config` | Desplegado y validado | 4 claves | `labs/02-configuration-lifecycle/solution/configmap.yaml` |
| `Secret/platform-api-secret` | Desplegado y validado | `Opaque`, 2 claves ficticias | `labs/02-configuration-lifecycle/solution/secret.yaml` |

## Capacidades activas

- HTTP interno mediante Service;
- dos réplicas gestionadas por Deployment;
- configuración no sensible mediante ConfigMap;
- Secret de laboratorio con valores ficticios;
- variables de entorno y volumen de configuración;
- `startupProbe`, `readinessProbe` y `livenessProbe`;
- requests y limits iniciales;
- logs de contenedor legibles;
- validación de rollout, Pods, EndpointSlice y HTTP local.

## Capacidades todavía no incorporadas

- Ingress y Gateway API;
- almacenamiento persistente;
- empaquetado Helm;
- gestión Terraform;
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
- `labs/02-configuration-lifecycle/validation/validate.sh`.

## Helm

- No existen charts Helm del curso.
- No existen releases Helm del curso.
- Helm permanece como CLI validada desde Unidad 00.

## Terraform

- No existen módulos Terraform.
- No existen backends ni estados Terraform del curso.
- Terraform permanece como CLI validada desde Unidad 00.

---

# Estado de observabilidad

| Señal | Estado | Evidencia |
|---|---|---|
| Estado Kubernetes | Disponible | `kubectl -n platform-training get deploy,rs,pods,svc,endpoints` |
| Eventos | Disponible | `kubectl -n platform-training get events --sort-by=.lastTimestamp` |
| Logs | Disponible | `kubectl -n platform-training logs deployment/platform-api --tail=20` |
| EndpointSlice | Disponible | `kubectl -n platform-training get endpointslice -l kubernetes.io/service-name=platform-api` |
| Métricas avanzadas | No incorporadas | Diferidas a Unidades 11-12 |
| Logs centralizados | No incorporados | Diferidos a Unidad 13 |
| Trazas | No incorporadas | Diferidas a Unidad 14 |

---

# Estado de seguridad

| Control | Estado | Ámbito | Evidencia |
|---|---|---|---|
| Namespace de aislamiento | Activo | `platform-training` | `labs/02-configuration-lifecycle/solution/namespace.yaml` |
| Secret de aplicación | Implementado solo como laboratorio ficticio | `platform-api-secret` | `labs/02-configuration-lifecycle/solution/secret.yaml` |
| Credenciales reales | No versionadas | Repositorio | Revisión de manifiestos de Unidad 02 |

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

---

# Restricciones activas

Tras generar, validar técnicamente y aprobar la Unidad 02:

- la Unidad 03 deberá reutilizar `platform-api`, `platform-training` y `labs/02-configuration-lifecycle/solution/`;
- conservar la deuda pedagógica reforzada: los README actuales siguen siendo insuficientes como material formativo profundo para alumnos que no conocen el tema;
- no sustituir la aplicación evolutiva sin justificación técnica o pedagógica explícita;
- no crear charts Helm hasta la unidad prevista;
- no crear módulos Terraform hasta la unidad prevista;
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
| R-011 | Contenido pedagógico demasiado orientado al laboratorio y exigente como entrada | Alta | Alto | Hardening pedagógico global inicial aceptado solo como cambio mínimo; se acuerda una fase posterior posible de desarrollo profundo de README | Abierto |
| R-012 | Futuras unidades especializadas pueden volverse difíciles de seguir si los README siguen asumiendo conocimiento previo | Alta | Alto | Playbooks actualizados y `project-planning.md` incorpora sesión de desarrollo pedagógico profundo | Abierto |

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
| TD-006 | Hardening pedagógico global del itinerario | Alta | Revisión de Unidad 01 y feedback posterior del usuario | Hardening inicial aceptado como mínimo; acordada como posible fase posterior centrada en desarrollar README sin avanzar capacidad técnica | Abierta |
| TD-007 | Reforzar prompts y plantillas de generación pedagógica | Alta | Feedback del usuario tras hardening mínimo | `playbooks/master.md` y `playbooks/unit-template.md` actualizados con criterios pedagógicos más estrictos | Cerrada |

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
| Revisión pedagógica Unidad 01 | Aprobación del usuario con observación sobre nivel de entrada y enfoque del contenido | Aprobada; deuda registrada para hardening global |
| Revisión pedagógica Unidad 02 | Aprobación del usuario el 2026-07-18 | Aprobada |
| Hardening pedagógico global inicial | Revisión documental de `tutorial/00-environment/`, `tutorial/01-kubernetes/`, `tutorial/02-configuration-lifecycle/` y summaries | Aceptado por el usuario como cambio mínimo; deuda pedagógica profunda sigue abierta |
| Ausencia de charts Helm | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Sin resultados |
| Ausencia de módulos Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' \) -print` | Sin resultados |

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

---

# Siguiente incremento permitido

El siguiente incremento principal es:

```text
Generar la Unidad 03 - Networking e ingreso
```

## Fuentes obligatorias

La sesión deberá leer:

```text
playbooks/master.md
project/architecture.md
project/project-state.md
project/roadmap.md
project/project-planning.md
project/how-to.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
tutorial/02-configuration-lifecycle/summary.md
playbooks/units/03-networking-ingress.md
labs/02-configuration-lifecycle/solution/
labs/02-configuration-lifecycle/validation/validate.sh
```

## Trabajo permitido

- generar la Unidad 03 — Networking e ingreso siguiendo `playbooks/units/03-networking-ingress.md`;
- usar `tutorial/02-configuration-lifecycle/summary.md` como entrada;
- reutilizar `labs/02-configuration-lifecycle/solution/`;
- mantener `platform-api` y `platform-training` como base;
- no ampliar el hardening pedagógico dentro del playbook de Unidad 03 salvo decisión explícita;
- permitir que una fase posterior específica desarrolle en profundidad los `README.md` sin crear nuevas capacidades técnicas.

## Trabajo todavía prohibido

- crear charts Helm;
- crear módulos Terraform;
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
