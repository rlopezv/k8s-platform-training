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
| Fase actual | Framework V1 cerrado |
| Estado general | Framework validado y congelado; preparado para iniciar la Unidad 00 |
| Último incremento completado | Corrección de inconsistencias del framework |
| Unidad activa | Ninguna |
| Última unidad completada | Ninguna |
| Laboratorio disponible | No |
| Plataforma local desplegada | No |
| Contenido formativo generado | No |
| Framework de generación | Validado y congelado (Framework V1) |
| Siguiente incremento permitido | Generación de la Unidad 00 — `00-environment` |

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

A partir de este estado se permite comenzar la generación de la **Unidad 00 — Preparación del entorno**. El framework solo deberá reabrirse si una unidad futura identifica una carencia real y verificable.

Durante la siguiente fase se permitirá:

- crear documentación en `tutorial/00-environment/`;
- crear artefactos ejecutables en `platform/environment/`;
- validar Windows 11, WSL2 y Ubuntu LTS;
- instalar y configurar MicroK8s;
- instalar y validar Helm y Terraform;
- generar notas del instructor;
- generar el resumen de continuidad;
- actualizar nuevamente este documento con resultados reales.

Todavía no se permite:

- generar contenido de la Unidad 01;
- desplegar la aplicación evolutiva;
- crear workloads funcionales del curso;
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
| `project/project-state.md` | Actualizado con este incremento | Framework-04 | Estado consolidado |
| `project/roadmap.md` | Completo y aprobado | Framework-04 | Evolución prevista del itinerario |
| `project/project-planning.md` | Completo y aprobado | Framework-04 | Planificación incremental del trabajo |
| `project/how-to.md` | Completo y aprobado | Framework-04 | Mecanismo operativo de trabajo con asistentes de IA |
| `playbooks/master.md` | Completo y aprobado | Bootstrap-05 | Reglas globales de generación |
| `playbooks/unit-template.md` | Completo y aprobado | Bootstrap-06 | Plantilla de playbooks específicos |
| `playbooks/summary-template.md` | Completo y aprobado | Bootstrap-07 | Contrato de continuidad |
| `playbooks/project-state-template.md` | Completo y aprobado | Bootstrap-08 | Reglas de mantenimiento del estado |
| `playbooks/generate-session-handoff.md` | Completo y aprobado | Framework-03 | Generación del handoff derivado de sesión |
| `playbooks/units/00-environment.md` | Completo y aprobado | Bootstrap-09 | Gobierno de la Unidad 00 |
| `AGENTS.md` | Completo | Framework-04 | Guía operativa para agentes con acceso al repositorio |

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
│       └── .gitkeep
├── playbooks/
│   ├── generate-session-handoff.md
│   ├── master.md
│   ├── project-state-template.md
│   ├── summary-template.md
│   ├── unit-template.md
│   └── units/
│       └── 00-environment.md
├── project/
│   ├── architecture.md
│   ├── how-to.md
│   ├── project-planning.md
│   ├── project-state.md
│   └── roadmap.md
└── tutorial/
    └── .gitkeep
```

## Estado de directorios

| Directorio | Estado | Contenido actual |
|---|---|---|
| `assets/` | Previsto y materializado | Solo `.gitkeep`; sin artefactos formativos |
| `labs/` | Previsto y materializado | Solo `.gitkeep`; sin laboratorios |
| `platform/` | Previsto y materializado | Solo `.gitkeep` y `environment/` |
| `platform/environment/` | Preparado para la Unidad 00 | Solo `.gitkeep`; sin scripts todavía |
| `playbooks/` | Operativo | Framework completo |
| `project/` | Operativo | Arquitectura, estado y roadmap |
| `tutorial/` | Preparado para la Unidad 00 | Solo `.gitkeep`; sin contenido formativo |

Git no conserva directorios vacíos. Las rutas base previstas se mantienen actualmente mediante `.gitkeep` hasta que existan artefactos reales.

---

# Estado de las unidades

| Unidad | Estado | Tutorial | Laboratorio o plataforma | Instructor notes | Summary |
|---|---|---|---|---|---|
| 00 — Preparación del entorno | Preparada para iniciar | No | No | No | No |
| 01 — Fundamentos operativos y primera aplicación | Prevista | No | No | No | No |
| 02–25 | Previstas en roadmap | No | No | No | No |

## Unidad 00 — Preparación del entorno

| Campo | Estado |
|---|---|
| Estado | Preparada para iniciar |
| Fecha de inicio | No iniciada |
| Fecha de cierre | No aplica |
| Playbook | `playbooks/units/00-environment.md` |
| Tutorial | Pendiente |
| Artefactos ejecutables | Pendientes |
| Instructor notes | Pendientes |
| Summary | Pendiente |

### Precondiciones documentales

Todas las precondiciones documentales están cumplidas.

### Precondiciones técnicas

Todavía deben validarse durante la unidad:

- Windows 11;
- virtualización;
- WSL2;
- Ubuntu LTS;
- acceso administrativo;
- conectividad;
- espacio en disco;
- Git.

---

# Estado del laboratorio

## Host

| Componente | Estado | Versión o detalle | Evidencia |
|---|---|---|---|
| Windows 11 | Requisito previsto, no validado | Pendiente | Debe validarse en la Unidad 00 |
| Virtualización | No validada | Pendiente | Debe validarse en la Unidad 00 |
| WSL2 | No validado por el proyecto | Pendiente | `wsl --status` |
| Ubuntu LTS | No validado por el proyecto | Pendiente | `wsl --list --verbose` y `/etc/os-release` |

## Plataforma Kubernetes

| Componente | Estado | Versión | Evidencia |
|---|---|---|---|
| MicroK8s | No instalado ni validado por el proyecto | Pendiente | Unidad 00 |
| Kubernetes | No disponible en el estado consolidado | Pendiente | Unidad 00 |
| Clúster local | No disponible | No aplica | Unidad 00 |
| Addons | No definidos ni habilitados | No aplica | Unidad 00 |

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
| Git | No validado por el proyecto | Pendiente | `git --version` | Unidad 00 |
| Helm | No validado por el proyecto | Pendiente | `helm version` | Unidad 00 |
| Terraform | No validado por el proyecto | Pendiente | `terraform version` | Unidad 00 |
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

Antes de la Unidad 01 deberá seleccionarse una solución que permita incorporar progresivamente:

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
| D-00-04 — Addons mínimos | Activa, pendiente de concreción | `playbooks/units/00-environment.md` |
| D-00-05 — Terraform solo se instala y valida | Activa | `playbooks/units/00-environment.md` |
| D-00-06 — Helm se instala sin crear charts | Activa | `playbooks/units/00-environment.md` |

---

# Restricciones activas

Durante la generación de la Unidad 00:

- no generar la aplicación evolutiva;
- no crear contenido de la Unidad 01;
- no crear workloads funcionales;
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
| R-001 | Git no conserva directorios vacíos | Alta | Bajo | Crear artefactos reales o `.gitkeep` | Abierto |
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
| Q-001 | Versiones exactas de Ubuntu, MicroK8s, Helm y Terraform | Sí para cerrar la Unidad 00 | Durante la Unidad 00 | Abierta |
| Q-002 | Addons mínimos exactos | Sí para aprobar scripts | Diseño técnico de la Unidad 00 | Abierta |
| Q-003 | Alias o instalación independiente de `kubectl` | No | Unidad 00 | Abierta |
| Q-004 | Requisitos mínimos de CPU, memoria y disco | Sí para publicar tutorial | Unidad 00 | Abierta |
| Q-005 | Uso de systemd en WSL2 objetivo | No | Validación de Unidad 00 | Abierta |
| Q-006 | Necesidad de soporte para proxy corporativo | No | Cuando el entorno lo requiera | Abierta |
| Q-007 | Estrategia definitiva para directorios vacíos | No | Al crear los primeros artefactos | Abierta |
| Q-008 | Aplicación evolutiva del curso | No para Unidad 00; sí para Unidad 01 | Antes de generar Unidad 01 | Abierta |

---

# Deuda técnica

| ID | Descripción | Prioridad | Origen | Resolución prevista | Estado |
|---|---|---|---|---|---|
| TD-001 | Definir estrategia de validación automatizada del repositorio | Media | Bootstrap | Evolución del framework | Abierta |
| TD-002 | Definir aplicación evolutiva | Alta antes de Unidad 01 | Roadmap | Antes de Unidad 01 | Abierta |
| TD-003 | Definir política de versiones de herramientas | Alta | Unidad 00 | Durante Unidad 00 | Abierta |
| TD-004 | Decidir tratamiento de directorios vacíos | Baja | Bootstrap | Primeros artefactos | Abierta |

---

# Validaciones globales disponibles

Actualmente solo pueden validarse documentalmente:

| Validación | Método | Resultado esperado |
|---|---|---|
| Existencia de documentos del framework | Revisión del repositorio | Doce documentos de gobierno y generación presentes |
| Coherencia de rutas | Revisión estática | Rutas alineadas |
| Orden del bootstrap | Comparación con README y estado | Completado |
| Existencia del playbook de Unidad 00 | Revisión del repositorio | Archivo presente |
| Ausencia de contenido formativo prematuro | Revisión del repositorio | Sin tutoriales ni laboratorios |

No existen todavía validaciones funcionales del entorno.

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

---

# Siguiente incremento permitido

El siguiente incremento principal es:

```text
Generar la Unidad 00 — Preparación del entorno
```

## Fuentes obligatorias

La sesión deberá leer:

```text
playbooks/master.md
project/architecture.md
project/project-state.md
project/roadmap.md
playbooks/units/00-environment.md
playbooks/unit-template.md
playbooks/summary-template.md
playbooks/project-state-template.md
```

No existe summary de una unidad anterior.

## Trabajo permitido

- generar `tutorial/00-environment/README.md`;
- generar `tutorial/00-environment/instructor-notes.md`;
- generar artefactos en `platform/environment/`;
- definir versiones objetivo justificadas;
- definir addons mínimos;
- crear scripts idempotentes;
- crear validaciones estáticas y funcionales;
- documentar validaciones manuales;
- preparar `tutorial/00-environment/summary.md`;
- actualizar nuevamente `project/project-state.md`.

## Trabajo todavía prohibido

- iniciar la Unidad 01;
- crear la aplicación evolutiva;
- desplegar workloads funcionales;
- crear charts Helm;
- crear módulos Terraform;
- incorporar CI/CD, GitOps, observabilidad, seguridad avanzada o cloud.

---

# Regla de actualización

Este documento deberá actualizarse durante la Unidad 00:

1. al iniciar formalmente la unidad;
2. después de definir versiones y addons;
3. después de generar los artefactos;
4. después de recibir resultados reales de validación;
5. al cerrar la unidad;
6. antes de permitir la generación del playbook o contenido de la Unidad 01.

Las actualizaciones deberán reflejar únicamente hechos verificables en el repositorio o resultados de ejecución proporcionados por el usuario.
