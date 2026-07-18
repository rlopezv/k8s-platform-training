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
| Fase actual | Unidad 01 — Fundamentos operativos y primera aplicación |
| Estado general | Unidad 01 preparada mediante playbook aprobado |
| Último incremento completado | Playbook de la Unidad 01 |
| Unidad activa | Ninguna |
| Última unidad completada | 00 — Preparación del entorno |
| Laboratorio disponible | Sí, entorno base local |
| Plataforma local desplegada | Sí, MicroK8s local validado |
| Contenido formativo generado | Sí |
| Framework de generación | Validado y congelado (Framework V1) |
| Siguiente incremento permitido | Generar la Unidad 01 siguiendo `playbooks/units/01-kubernetes.md` |

---

# Fase actual

El proyecto ha completado formalmente la fase **Bootstrap** y ha cerrado el **Framework V1**.

El framework del repositorio ha sido:

- generado;
- revisado;
- aprobado;
- validado mediante la revisión de sus documentos, playbooks y mecanismos de continuidad;
- sincronizado con la arquitectura y la estructura actual del repositorio;
- congelado como **Framework V1**;
- incorporado al repositorio.

La **Unidad 00 — Preparación del entorno** está completada con limitaciones documentadas. Cuenta con guia, scripts de validacion, resultados reales aportados por el usuario para Ubuntu 24.04.4 LTS sobre WSL2, MicroK8s, Kubernetes, `kubectl`, Helm y Terraform. El framework solo deberá reabrirse si una unidad futura identifica una carencia real y verificable.

Durante la siguiente fase se permitirá:

- generar el contenido formativo y el laboratorio de la Unidad 01 siguiendo `playbooks/units/01-kubernetes.md`;
- usar `tutorial/00-environment/summary.md` como fuente de continuidad;
- mantener visibles las limitaciones Windows/WSL pendientes por equipo;
- definir la aplicación evolutiva inicial dentro del alcance de la Unidad 01;
- crear el primer namespace funcional, Deployment y Service del curso;
- actualizar este documento con el estado real al iniciar, validar y cerrar la Unidad 01.

Todavía no se permite:

- crear charts Helm;
- crear módulos Terraform;
- instalar Tekton;
- instalar Argo CD;
- desplegar el stack de observabilidad;
- introducir KEDA;
- crear recursos en AKS o EKS.

---

# Estado del bootstrap

## Resultado

```text
Cerrado
```

## Fecha de cierre

```text
2026-07-17
```

## Criterios de cierre

| Criterio | Estado |
|---|---|
| Estructura conceptual del repositorio definida | Cumplido |
| Arquitectura documentada | Cumplido |
| Estado inicial consolidado | Cumplido |
| Roadmap completo definido | Cumplido |
| Playbook maestro disponible | Cumplido |
| Plantilla de unidades disponible | Cumplido |
| Plantilla de summaries disponible | Cumplido |
| Plantilla de project-state disponible | Cumplido |
| Playbook de la Unidad 00 disponible | Cumplido |
| Mecanismo de continuidad entre sesiones definido | Cumplido |
| Contenido revisado y aprobado | Cumplido |
| Repositorio utilizable sin historial de conversación | Cumplido |

---

# Artefactos de gobierno

| Artefacto | Estado | Última modificación relevante | Responsabilidad |
|---|---|---|---|
| `README.md` | Completo y aprobado | Bootstrap-01 | Punto de entrada y visión general |
| `project/architecture.md` | Completo y aprobado | Bootstrap-02 | Arquitectura y decisiones estructurales |
| `project/project-state.md` | Actualizado con cierre de Unidad 00 | Unit-00-Closure | Estado consolidado |
| `project/roadmap.md` | Completo y aprobado | Unit-00-01 | Evolución prevista del itinerario |
| `project/project-planning.md` | Completo y aprobado | Unit-01-Concept-Scope | Planificación incremental del trabajo |
| `project/how-to.md` | Completo y aprobado | Framework-04 | Mecanismo operativo de trabajo con asistentes de IA |
| `playbooks/master.md` | Completo y aprobado | Bootstrap-05 | Reglas globales de generación |
| `playbooks/unit-template.md` | Completo y aprobado | Bootstrap-06 | Plantilla de playbooks específicos |
| `playbooks/summary-template.md` | Completo y aprobado | Bootstrap-07 | Contrato de continuidad |
| `playbooks/project-state-template.md` | Completo y aprobado | Bootstrap-08 | Reglas de mantenimiento del estado |
| `playbooks/generate-session-handoff.md` | Completo y aprobado | Framework-03 | Generación del handoff derivado de sesión |
| `playbooks/units/00-environment.md` | Completo y aprobado | Unit-00-01 | Gobierno de la Unidad 00 |
| `playbooks/units/01-kubernetes.md` | Completo y aprobado | Unit-01-Concept-Scope | Gobierno de la Unidad 01 |
| `AGENTS.md` | Completo | Unit-00-01 | Guía operativa para agentes con acceso al repositorio |

---

# Estructura actual del repositorio

```text
.
├── README.md
├── assets/
│   └── .gitkeep
├── labs/
│   └── .gitkeep
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
│       └── 01-kubernetes.md
├── project/
│   ├── architecture.md
│   ├── how-to.md
│   ├── project-planning.md
│   ├── project-state.md
│   └── roadmap.md
└── tutorial/
    ├── .gitkeep
    └── 00-environment/
        ├── instructor-notes.md
        ├── README.md
        └── summary.md
```

## Estado de directorios

| Directorio | Estado | Contenido actual |
|---|---|---|
| `assets/` | Previsto y materializado | Solo `.gitkeep`; sin artefactos formativos |
| `labs/` | Previsto y materializado | Solo `.gitkeep`; sin laboratorios |
| `platform/` | Previsto y materializado | Solo `.gitkeep` y `environment/` |
| `platform/environment/` | Completo para la Unidad 00 | `README.md`, validaciones iniciales, preparacion Ubuntu WSL, scripts MicroK8s/kubectl y scripts Helm/Terraform |
| `playbooks/` | Operativo | Framework completo |
| `project/` | Operativo | Arquitectura, estado y roadmap |
| `tutorial/` | Unidad 00 completada | `00-environment/` y `.gitkeep` |

Git no conserva directorios vacíos. Las rutas base previstas se mantienen actualmente mediante `.gitkeep` hasta que existan artefactos reales.

---

# Estado de las unidades

| Unidad | Estado | Tutorial | Laboratorio o plataforma | Instructor notes | Summary |
|---|---|---|---|---|---|
| 00 — Preparación del entorno | Completada con limitaciones | Sí | Sí | Sí | Sí |
| 01 — Fundamentos operativos y primera aplicación | Playbook aprobado; unidad no generada | No | No | No | No |
| 02–25 | Previstas en roadmap | No | No | No | No |

## Unidad 00 — Preparación del entorno

| Campo | Estado |
|---|---|
| Estado | Completada con limitaciones documentadas |
| Fecha de inicio | 2026-07-17 |
| Fecha de cierre | 2026-07-18 |
| Playbook | `playbooks/units/00-environment.md` |
| Tutorial | `tutorial/00-environment/README.md` completo para Windows/WSL2/Ubuntu, MicroK8s/kubectl y Helm/Terraform |
| Artefactos ejecutables | Scripts iniciales, preparacion Ubuntu WSL, scripts MicroK8s/kubectl y scripts Helm/Terraform presentes; ejecuciones funcionales principales validadas |
| Instructor notes | `tutorial/00-environment/instructor-notes.md` creado |
| Summary | `tutorial/00-environment/summary.md` cerrado con limitaciones |

### Precondiciones documentales

Todas las precondiciones documentales están cumplidas.

### Precondiciones técnicas

Quedan como validaciones por equipo, especialmente al replicar el laboratorio:

- Windows 11;
- virtualización;
- acceso administrativo;
- conectividad;
- espacio en disco;
- Git.

WSL2 y Ubuntu 24.04.4 LTS ya cuentan con resultados iniciales aportados. DNS hacia `snapcraft.io` resolvio correctamente durante la instalacion real de MicroK8s.

## Unidad 01 — Fundamentos operativos y primera aplicación

| Campo | Estado |
|---|---|
| Estado | Playbook aprobado; contenido formativo y laboratorio no generados |
| Fecha de inicio | No aplica |
| Fecha de cierre | No aplica |
| Playbook | `playbooks/units/01-kubernetes.md` |
| Tutorial | No existe |
| Laboratorio | No existe |
| Instructor notes | No existe |
| Summary | No existe |

### Alcance aprobado

La Unidad 01 debe introducir la primera versión funcional de la solución evolutiva sobre MicroK8s mediante manifiestos Kubernetes declarativos.

El playbook aprobado permite, durante la generación de la unidad:

- explicar la arquitectura del clúster: control plane, nodos worker y flujo de reconciliacion;
- cubrir conceptualmente `kube-apiserver`, `etcd`, `kube-scheduler`, `kube-controller-manager`, `kubelet`, `kube-proxy`, container runtime, CRI, CNI y CSI;
- introducir conceptualmente la gestion de configuracion con ConfigMaps, Secrets, variables de entorno y volumenes de configuracion;
- introducir conceptualmente probes, requests, limits, Ingress, Gateway API y almacenamiento persistente;
- explicar el mapa de observabilidad: estado, eventos y logs en Unidad 01; Prometheus, Grafana, Loki, Tempo, OpenTelemetry y OpenMetrics en Unidades 11-15;
- definir la aplicación evolutiva inicial;
- crear `tutorial/01-kubernetes/`;
- crear `labs/01-kubernetes/`;
- crear un namespace funcional del curso;
- crear manifiestos para `Deployment` y `Service`;
- validar estado, eventos, logs, labels y selectors con `kubectl`.

No se han creado todavía artefactos formativos ni recursos Kubernetes de Unidad 01.

La implementacion practica de ConfigMaps, Secrets, probes, requests, limits, Ingress, Gateway API y almacenamiento persistente sigue diferida a las unidades posteriores previstas en el roadmap.

---

# Estado del laboratorio

## Host

| Componente | Estado | Versión o detalle | Evidencia |
|---|---|---|---|
| Windows 11 | Requisito previsto, pendiente de validar por cada entorno | Pendiente | `platform/environment/windows/check-prerequisites.ps1` |
| Virtualización | Requisito previsto, pendiente de validar por cada entorno | Pendiente | `platform/environment/windows/check-prerequisites.ps1` |
| WSL2 | Requisito previsto; Ubuntu objetivo ejecutandose sobre WSL2 segun resultados aportados | Version 2 | `wsl --status` y `wsl --list --verbose` |
| Ubuntu LTS | Validada | Ubuntu 24.04.4 LTS (`noble`) sobre WSL2; usuario inicial `ramon` | `cat /etc/os-release` y validacion integrada aportada por el usuario |

## Plataforma Kubernetes

| Componente | Estado | Versión | Evidencia |
|---|---|---|---|
| MicroK8s | Instalado y validado por el usuario | `v1.35.6`, canal `1.35/stable`, revision `9072` | `platform/environment/microk8s/install.sh` y `platform/environment/microk8s/validate.sh` aportados por el usuario |
| Kubernetes | Disponible y validado en MicroK8s | `v1.35.6` | `kubectl get nodes` aportado por el usuario |
| Clúster local | Disponible y validado | Nodo `gmktecg2` en `Ready` | `kubectl get nodes` aportado por el usuario |
| Addons | `dns` habilitado; addons core adicionales observados por MicroK8s | `dns`, `ha-cluster`, `helm`, `helm3` | `platform/environment/microk8s/validate.sh` aportado por el usuario |

## Namespaces

No existen namespaces funcionales del curso.

## Workloads

No existen workloads funcionales del curso.

## Endpoints

No existen endpoints de aplicación.

---

# Herramientas y versiones

| Herramienta | Estado | Versión activa | Método de comprobación | Incorporación prevista |
|---|---|---|---|---|
| Git | Validado en Ubuntu WSL | `/usr/bin/git` | `platform/environment/linux/check-prerequisites.sh` | Unidad 00 |
| kubectl | Instalado por el usuario desde `1.35/stable`; operativo contra MicroK8s | `v1.35.6` | `kubectl version --client`, `kubectl get nodes` | Unidad 00 |
| Helm | Instalado y validado por el usuario como CLI | `v3.21.0+ge0878d4` | `platform/environment/tools/install-helm.sh`, `helm version --short` | Unidad 00 |
| Terraform | Instalado y validado por el usuario como CLI | `1.15.7` | `platform/environment/tools/install-terraform.sh`, `terraform version` | Unidad 00 |
| Argo CD | No incorporado | No aplica | No aplica | Unidad 09 |
| Tekton | No incorporado | No aplica | No aplica | Unidad 08 |
| Prometheus | No incorporado | No aplica | No aplica | Unidad 11 |
| Grafana | No incorporado | No aplica | No aplica | Unidad 12 |
| Loki | No incorporado | No aplica | No aplica | Unidad 13 |
| Tempo | No incorporado | No aplica | No aplica | Unidad 14 |
| OpenTelemetry | No incorporado | No aplica | No aplica | Unidad 14 |
| KEDA | No incorporado | No aplica | No aplica | Unidad 18 |

No debe asumirse que una herramienta está disponible por estar instalada manualmente en el equipo. Su disponibilidad deberá comprobarse y registrarse.

---

# Estado de la aplicación evolutiva

La aplicación evolutiva todavía no ha sido definida.

Durante la primera sesión de generación de la Unidad 01 deberá seleccionarse una solución que permita incorporar progresivamente:

- configuración;
- secretos;
- networking;
- persistencia;
- métricas;
- logs;
- trazas;
- escalado;
- seguridad;
- despliegue en AKS y EKS.

No debe crearse ninguna aplicación durante la Unidad 00.

El playbook `playbooks/units/01-kubernetes.md` ya define los criterios para esa selección, pero no crea todavía aplicación, imagen, manifiestos ni workloads.

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
- registros de imágenes;
- configuraciones de identidad;
- pipelines de despliegue cloud;
- procedimientos de teardown.

---

# Decisiones arquitectónicas activas

| Decisión | Estado | Documento fuente | Impacto actual |
|---|---|---|---|
| ADR-001 — MicroK8s como plataforma local inicial | Activa | `project/architecture.md` | Gobierna la Unidad 00 |
| ADR-002 — Unidad 0 fuera de `labs/` | Activa | `project/architecture.md` | Artefactos en `platform/environment/` |
| ADR-003 — Resumen por unidad | Activa | `project/architecture.md` | Obligatorio al cerrar Unidad 00 |
| ADR-004 — Estado consolidado central | Activa | `project/architecture.md` | Este archivo es fuente de estado |
| ADR-005 — Playbooks versionados | Activa | `project/architecture.md` | Framework gobernado mediante control de versiones |
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

| Decisión | Estado | Documento fuente |
|---|---|---|
| D-01-01 — Manifiestos Kubernetes como artefacto primario | Activa para la generación de Unidad 01 | `playbooks/units/01-kubernetes.md` |
| D-01-02 — Aplicación evolutiva simple, observable y portable | Activa como criterio de selección | `playbooks/units/01-kubernetes.md` |
| D-01-03 — Namespace funcional único inicial | Activa para la generación de Unidad 01 | `playbooks/units/01-kubernetes.md` |
| D-01-04 — Starter y solution sin duplicar laboratorios completos | Activa para la generación de Unidad 01 | `playbooks/units/01-kubernetes.md` |

---

# Restricciones activas

Tras generar el playbook de Unidad 01 y hasta cerrar la unidad:

- la aplicación evolutiva solo puede definirse dentro del alcance de `playbooks/units/01-kubernetes.md`;
- los workloads funcionales solo pueden ser los recursos básicos previstos para Unidad 01;
- no crear charts Helm;
- no crear módulos Terraform;
- no instalar Tekton;
- no instalar Argo CD;
- no desplegar observabilidad;
- no introducir KEDA;
- no crear recursos AKS o EKS;
- no asumir versiones sin validarlas;
- no afirmar que el entorno fue ejecutado si solo se revisó estáticamente;
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
| R-005 | Entorno parcialmente configurado | Alta | Medio | Validar antes de instalar | Abierto |
| R-006 | Addons de MicroK8s no portables | Media | Medio | Aislar y documentar | Abierto |
| R-007 | Operaciones destructivas del entorno | Baja | Alto | Confirmación explícita y separación | Abierto |
| R-008 | Recursos insuficientes en el host | Media | Medio | Definir y validar requisitos mínimos | Abierto |

## Cuestiones abiertas

| ID | Cuestión | Bloqueante | Resolución prevista | Estado |
|---|---|---|---|---|
| Q-001 | Versiones exactas de Ubuntu, MicroK8s, Helm y Terraform | No | Versiones principales observadas y registradas; validacion Windows/WSL completa queda como comprobacion por equipo | Cerrada con limitacion |
| Q-002 | Addons mínimos exactos | No | Baseline inicial `dns`; addons core `ha-cluster`, `helm` y `helm3` observados en MicroK8s | Cerrada para Unidad 00 |
| Q-003 | Alias o instalación independiente de `kubectl` | No | Resuelto: `kubectl` será cliente principal; `microk8s kubectl` queda como fallback | Cerrada |
| Q-004 | Requisitos mínimos de CPU, memoria y disco | No para cierre de Unidad 00 | Validacion por equipo antes de replicar laboratorio | Abierta |
| Q-005 | Uso de systemd en WSL2 objetivo | No | Validado en el entorno aportado; revisar si otro equipo difiere | Cerrada con limitacion |
| Q-006 | Necesidad de soporte para proxy corporativo | No | Cuando el entorno lo requiera | Abierta |
| Q-007 | Estrategia definitiva para directorios vacíos | No | Resuelta mediante `.gitkeep` hasta crear artefactos reales | Cerrada |
| Q-008 | Aplicación evolutiva del curso | No para playbook de Unidad 01; sí para generar y cerrar la Unidad 01 | Primera sesión de Unidad 01, siguiendo `playbooks/units/01-kubernetes.md` | Abierta |
| Q-009 | Nombre definitivo del namespace funcional de Unidad 01 | No para playbook; sí para manifiestos | Primera sesión de Unidad 01 | Abierta |

---

# Deuda técnica

| ID | Descripción | Prioridad | Origen | Resolución prevista | Estado |
|---|---|---|---|---|---|
| TD-001 | Definir estrategia de validación automatizada del repositorio | Media | Bootstrap | Evolución del framework | Abierta |
| TD-002 | Definir aplicación evolutiva | Alta durante Unidad 01 | Roadmap y `playbooks/units/01-kubernetes.md` | Primera sesión de Unidad 01 | Abierta |
| TD-003 | Definir política de versiones de herramientas | Alta | Unidad 00 | Política inicial definida y versiones reales registradas | Cerrada para Unidad 00 |
| TD-004 | Decidir tratamiento de directorios vacíos | Baja | Bootstrap | Resuelto mediante `.gitkeep` | Cerrada |

---

# Validaciones globales disponibles

Validaciones registradas actualmente:

| Validación | Método | Resultado esperado |
|---|---|---|
| Existencia de documentos del framework | Revisión del repositorio | Doce documentos de gobierno y generación presentes |
| Coherencia de rutas | Revisión estática | Rutas alineadas |
| Orden del bootstrap | Comparación con README y estado | Completado |
| Existencia del playbook de Unidad 00 | Revisión del repositorio | Archivo presente |
| Existencia del playbook de Unidad 01 | Revisión del repositorio | `playbooks/units/01-kubernetes.md` presente y alineado con el estado actual |
| Ausencia de contenido formativo prematuro | Revisión del repositorio | Sin contenido de unidades posteriores ni laboratorios funcionales |
| Diseño inicial de Unidad 00 | Revisión del repositorio | `tutorial/00-environment/README.md`, `tutorial/00-environment/summary.md` y `platform/environment/README.md` presentes |
| Validación Windows inicial | `platform/environment/windows/check-prerequisites.ps1` | Disponible para comprobar Windows, WSL2 y distribucion Ubuntu objetivo |
| Preparacion Ubuntu WSL | `platform/environment/windows/prepare-ubuntu-wsl.ps1` | Disponible; modo revision por defecto e instalacion solo con `-Install` |
| Instalacion Ubuntu WSL | `platform/environment/windows/prepare-ubuntu-wsl.ps1 -Install` | Ejecutada por el usuario; `Ubuntu-24.04` instalada correctamente |
| Validacion Linux inicial | `platform/environment/linux/check-prerequisites.sh` | Ejecutada por el usuario; 0 fallos y 4 avisos esperados por herramientas pendientes |
| Validacion integrada Linux | `platform/environment/validation/validate-environment.sh` | Ejecutada por el usuario; completada sin fallos bloqueantes |
| Validacion integrada Linux previa a herramientas | `bash platform/environment/validation/validate-environment.sh` | Ejecutada por el usuario; completada sin fallos bloqueantes, 2 avisos esperados por Helm y Terraform pendientes en esa fase |
| Guia de Unidad 00 | `tutorial/00-environment/README.md` | Documenta validacion Windows/WSL2, instalacion Ubuntu 24.04, validacion Ubuntu, MicroK8s/kubectl, Helm/Terraform, troubleshooting y continuidad VS Code WSL |
| Referencia tecnica de entorno | `platform/environment/README.md` | Documenta contexto de ejecucion, efectos, repeticion, recuperacion, validaciones y limitaciones de scripts |
| Sintaxis Bash de validaciones iniciales | Ejecucion de scripts | Scripts ejecutados correctamente desde Ubuntu 24.04.4 LTS |
| Sintaxis PowerShell de validación Windows | Ejecución de script | Script PowerShell ajustado para tratar comprobaciones no concluyentes como avisos |
| Scripts MicroK8s/kubectl | `platform/environment/microk8s/*.sh` | Creados con instalacion, configuracion, validacion y reset protegido |
| Sintaxis Bash MicroK8s/kubectl | `bash -n platform/environment/microk8s/*.sh` | Ejecutada en esta sesion; codigo de salida 0 |
| ShellCheck | `shellcheck` | No disponible en este entorno |
| Reset MicroK8s dry run | `bash platform/environment/microk8s/reset.sh` | Ejecutada en esta sesion; no ejecuta reset sin `--confirm-reset` |
| Validacion integrada con bloque MicroK8s | `bash platform/environment/validation/validate-environment.sh` | Ejecutada por el usuario; MicroK8s y `kubectl` completados sin fallos |
| DNS snapcraft.io | `getent hosts snapcraft.io` | Ejecutado por el usuario; resuelve direcciones IPv6 |
| Instalacion MicroK8s/kubectl | `bash platform/environment/microk8s/install.sh` | Ejecutada por el usuario; MicroK8s `v1.35.6` y `kubectl` `1.35.6` instalados desde `1.35/stable` |
| Validacion MicroK8s/kubectl aportada | `bash platform/environment/microk8s/validate.sh` | Ejecutada por el usuario; 0 fallos, 0 avisos |
| Correccion parser addon dns | `platform/environment/microk8s/validate.sh` | Corregido para detectar addons en el formato MicroK8s 1.35 |
| Scripts Helm/Terraform | `platform/environment/tools/*.sh` | Creados con instalacion versionada, checksum y validacion |
| Sintaxis Bash Helm/Terraform | `bash -n platform/environment/tools/*.sh` | Ejecutada en esta sesion; codigo de salida 0 |
| Validacion Helm/Terraform previa | `bash platform/environment/tools/validate-tools.sh` | Ejecutada antes de instalar herramientas; fallaba porque Helm y Terraform no estaban instalados todavia |
| Instalacion Helm | `bash platform/environment/tools/install-helm.sh` | Ejecutada por el usuario; Helm `v3.21.0+ge0878d4` instalado con checksum correcto |
| Instalacion Terraform | `bash platform/environment/tools/install-terraform.sh` | Ejecutada por el usuario; Terraform `1.15.7` instalado con checksum correcto; falso fallo previo de parser JSON corregido |
| Validacion Helm/Terraform | `bash platform/environment/tools/validate-tools.sh` | Ejecutada por el usuario; 0 fallos, 0 avisos |
| Validacion Helm/Terraform post-correccion | `bash platform/environment/tools/validate-tools.sh` | Ejecutada en esta sesion; 0 fallos, 0 avisos |
| Validacion integrada final | `bash platform/environment/validation/validate-environment.sh` | Ejecutada por el usuario; completada sin fallos bloqueantes |
| Revalidacion integrada desde Codex | `bash platform/environment/validation/validate-environment.sh` | Ubuntu, DNS, `kubectl get nodes`, Helm y Terraform correctos; `microk8s status/version` no ejecutables desde esta sesion no interactiva sin grupo `microk8s` activo |
| Ausencia de charts Helm | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` | Ejecutada en esta sesion; sin resultados |
| Ausencia de archivos Terraform | `find . -path ./.git -prune -o -type f \( -name '*.tf' -o -name '*.tfvars' -o -name '*.yaml' -o -name '*.yml' \) -print` | Ejecutada en esta sesion; sin resultados |
| Ausencia de laboratorios funcionales | `find labs -type f -not -name .gitkeep -print` | Ejecutada en esta sesion; sin resultados |
| Cierre documental de Unidad 00 | Revisión de `tutorial/00-environment/README.md`, `summary.md`, `instructor-notes.md` y `platform/environment/README.md` | Ejecutada en esta sesion; estado final actualizado |

No existen todavía validaciones funcionales registradas para Windows/WSL desde PowerShell en esta sesion Linux.

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
| 12 | Cierre y sincronización del Framework V1 | Completado con este cambio | Inventario, árbol, ADR y estado sincronizados; Framework V1 congelado |
| 13 | Corrección de inconsistencias del framework | Completado con este cambio | Handoff alineado, estado documental sincronizado y rutas base materializadas con `.gitkeep` |
| 14 | Inicio de diseño de la Unidad 00 | Completado con este cambio | Unidad 00 iniciada; `kubectl` definido como cliente principal; diseño inicial creado |
| 15 | Política inicial de versiones de Unidad 00 | Completado con este cambio | Baseline definida para Ubuntu, MicroK8s, Kubernetes, kubectl, Helm y Terraform |
| 16 | Scripts iniciales de validación de Unidad 00 | Completado con este cambio | Validaciones no destructivas creadas para Windows y Ubuntu/WSL |
| 17 | Ajuste de validaciones iniciales | Completado con este cambio | Validaciones expresadas como criterios del entorno objetivo; Ubuntu 24.04 LTS sobre WSL2 sigue siendo el requisito |
| 18 | Preparacion de Ubuntu WSL | Completado con este cambio | Script Windows creado para validar y ejecutar explicitamente la instalacion de `Ubuntu-24.04` |
| 19 | Instalacion de Ubuntu WSL | Completado con este cambio | El usuario ejecuto la instalacion de `Ubuntu-24.04`, creo el usuario Linux `ramon` y obtuvo primer arranque correcto |
| 20 | Validacion Linux inicial | Completado | Ubuntu 24.04.4 LTS validada en WSL2; systemd, snap, Git, conectividad DNS y espacio libre correctos |
| 21 | Guia WSL/Ubuntu y continuidad VS Code WSL | Completado con este cambio | Tutorial y referencia tecnica actualizados; validacion integrada actual sin fallos bloqueantes pero con aviso DNS; siguiente bloque preparado para MicroK8s y `kubectl` |
| 22 | Scripts y documentacion MicroK8s/kubectl | Completado | Scripts idempotentes generados; instructor notes creadas; validaciones funcionales pendientes de ejecucion real |
| 23 | Instalacion real MicroK8s/kubectl y correccion de validacion | Completado | MicroK8s `v1.35.6` y `kubectl` `1.35.6` instalados; parser de addon `dns` corregido |
| 24 | Validacion real MicroK8s/kubectl | Completado con este cambio | `validate.sh` e integrada ejecutadas sin fallos bloqueantes; siguiente bloque permitido Helm y Terraform |
| 25 | Scripts Helm/Terraform | Completado | Scripts idempotentes generados; validacion funcional pendiente de ejecucion real |
| 26 | Validacion real Helm/Terraform | Completado con este cambio | Helm `v3.21.0+ge0878d4` y Terraform `1.15.7` instalados y validados; integrada sin fallos bloqueantes |
| 27 | Cierre de Unidad 00 | Completado con este cambio | Unidad 00 cerrada con limitaciones Windows/WSL documentadas; siguiente paso gobernado: playbook de Unidad 01 |
| 28 | Playbook de Unidad 01 | Completado con este cambio | `playbooks/units/01-kubernetes.md` creado y `project/project-planning.md` alineado con roadmap; siguiente paso permitido: generar Unidad 01 |
| 29 | Ajuste conceptual de Unidad 01 | Completado con este cambio | Playbook y planning ajustados para incluir arquitectura Kubernetes, componentes de control plane/nodo, CRI/CNI/CSI, gestion de configuracion, Gateway API y mapa conceptual de observabilidad |

---

# Siguiente incremento permitido

El siguiente incremento principal es:

```text
Generar la Unidad 01 siguiendo `playbooks/units/01-kubernetes.md`
```

## Fuentes obligatorias

La sesión deberá leer:

```text
playbooks/master.md
project/architecture.md
project/project-state.md
project/roadmap.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
tutorial/00-environment/summary.md
playbooks/units/01-kubernetes.md
```

Para generar contenido de Unidad 01 se debe usar el playbook versionado existente en `playbooks/units/01-kubernetes.md`.

## Trabajo permitido

- usar el summary cerrado de Unidad 00 como entrada;
- crear `tutorial/01-kubernetes/`;
- crear `labs/01-kubernetes/`;
- definir la aplicacion evolutiva inicial dentro de los criterios del playbook;
- crear el primer namespace funcional, Deployment y Service del curso;
- definir validaciones, diagnostico, recuperacion y continuidad de Unidad 01;
- mantener MicroK8s, Kubernetes, `kubectl`, Helm y Terraform como baseline ya validada;
- registrar cualquier validacion Windows/WSL adicional si el usuario la aporta.

## Trabajo todavía prohibido

- crear charts Helm;
- crear módulos Terraform;
- incorporar CI/CD, GitOps, observabilidad, seguridad avanzada o cloud.

---

# Regla de actualización

Este documento deberá actualizarse:

1. al generar el playbook de Unidad 01;
2. al iniciar formalmente una nueva unidad;
3. después de generar artefactos;
4. después de recibir resultados reales de validación;
5. al cerrar cada unidad;
6. antes de permitir contenido que dependa de trabajo todavía no validado.

Las actualizaciones deberán reflejar únicamente hechos verificables en el repositorio o resultados de ejecución proporcionados por el usuario.
