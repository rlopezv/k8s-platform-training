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
| Fase actual | Bootstrap del repositorio |
| Estado general | En progreso |
| Último incremento completado | Arquitectura del repositorio |
| Unidad activa | Ninguna |
| Unidades completadas | Ninguna |
| Laboratorio disponible | No |
| Plataforma local desplegada | No |
| Contenido formativo generado | No |
| Siguiente incremento permitido | `project/roadmap.md` |

---

# Fase actual

El proyecto se encuentra en la fase **Bootstrap**.

El objetivo de esta fase es construir el framework mínimo necesario para generar posteriormente las unidades formativas de manera incremental y coherente.

Durante esta fase:

- no se genera contenido para alumnos;
- no se crean laboratorios;
- no se instala MicroK8s;
- no se despliegan workloads;
- no se crean recursos en AKS ni EKS;
- no se ejecuta todavía ningún playbook de unidad.

La Unidad 0 no debe comenzar hasta completar y revisar todos los artefactos definidos para el bootstrap.

---

# Artefactos existentes

## Raíz del repositorio

### `README.md`

Estado: **completado**

Responsabilidad:

- presentar el propósito del repositorio;
- describir su estructura;
- documentar los principios generales;
- explicar el mecanismo de generación;
- declarar el orden del bootstrap.

## Directorio `project/`

### `project/architecture.md`

Estado: **completado**

Responsabilidad:

- definir la arquitectura lógica;
- establecer responsabilidades por directorio;
- documentar el flujo de generación;
- definir restricciones;
- registrar las decisiones arquitectónicas iniciales.

### `project/project-state.md`

Estado: **archivo actual**

Responsabilidad:

- consolidar el estado real del proyecto;
- identificar el último incremento completado;
- declarar el siguiente incremento permitido;
- evitar que sesiones posteriores infieran estado no implementado.

---

# Artefactos pendientes del bootstrap

Los siguientes archivos todavía no existen o no han sido completados:

1. `project/roadmap.md`
2. `playbooks/master.md`
3. `playbooks/unit-template.md`
4. `playbooks/summary-template.md`
5. `playbooks/project-state-template.md`
6. `playbooks/units/00-environment.md`

El orden de creación es obligatorio salvo que se documente previamente un cambio de arquitectura.

---

# Estructura prevista y estado

```text
.
├── README.md                              # completado
├── assets/                               # previsto, sin contenido
├── labs/                                 # previsto, sin contenido
├── platform/
│   └── environment/                      # previsto, sin contenido
├── playbooks/
│   ├── master.md                         # pendiente
│   ├── project-state-template.md         # pendiente
│   ├── summary-template.md               # pendiente
│   ├── unit-template.md                  # pendiente
│   └── units/
│       └── 00-environment.md             # pendiente
├── project/
│   ├── architecture.md                   # completado
│   ├── project-state.md                  # completado con este incremento
│   └── roadmap.md                        # pendiente
└── tutorial/                             # previsto, sin contenido
```

Los directorios vacíos pueden requerir archivos `.gitkeep` si se desea conservarlos en Git antes de que contengan artefactos reales. Esta decisión todavía no se ha formalizado.

---

# Estado de las unidades

| Unidad | Estado | Tutorial | Laboratorio | Instructor notes | Summary |
|---|---|---|---|---|---|
| 00 — Environment | No iniciada | No | No | No | No |

No existen otras unidades formalmente definidas hasta completar `project/roadmap.md`.

---

# Estado del laboratorio

## Host

| Componente | Estado |
|---|---|
| Windows 11 | Requisito previsto, no validado por el repositorio |
| WSL2 | Requisito previsto, no validado por el repositorio |
| Ubuntu LTS | Requisito previsto, no validado por el repositorio |

## Plataforma Kubernetes

| Componente | Estado |
|---|---|
| MicroK8s | No instalado ni configurado por este proyecto |
| Clúster local | No disponible |
| Addons | No definidos |
| Namespaces del curso | No definidos |
| Workloads | No desplegados |

## Herramientas

| Herramienta | Estado |
|---|---|
| Helm | Prevista, no instalada por el proyecto |
| Terraform | Prevista, no instalada por el proyecto |
| Argo CD | Prevista, no incorporada |
| Tekton | Prevista, no incorporada |
| Prometheus | Previsto, no incorporado |
| Grafana | Previsto, no incorporado |
| Loki | Previsto, no incorporado |
| Tempo | Previsto, no incorporado |
| OpenTelemetry | Previsto, no incorporado |
| OpenMetrics | Previsto, no incorporado |
| KEDA | Previsto, no incorporado |

La presencia de estas herramientas en el equipo del autor no debe asumirse hasta que la Unidad 0 las valide o las instale explícitamente.

---

# Estado de plataformas gestionadas

| Plataforma | Estado |
|---|---|
| AKS | No iniciada |
| EKS | No iniciada |

No existen actualmente:

- suscripciones o cuentas documentadas;
- módulos Terraform;
- clústeres;
- configuraciones de identidad;
- redes;
- pipelines de despliegue;
- procedimientos de validación.

---

# Decisiones arquitectónicas activas

Las siguientes decisiones registradas en `project/architecture.md` están vigentes:

| Decisión | Estado |
|---|---|
| ADR-001 — MicroK8s como plataforma local inicial | Activa |
| ADR-002 — Unidad 0 fuera de `labs/` | Activa |
| ADR-003 — Resumen por unidad | Activa |
| ADR-004 — Estado consolidado central | Activa |
| ADR-005 — Playbooks versionados | Activa |

No existen decisiones revocadas ni sustituidas.

---

# Restricciones activas

Durante el bootstrap se aplican las siguientes restricciones:

- no generar contenido formativo;
- no crear laboratorios;
- no ejecutar la Unidad 0;
- no asumir herramientas instaladas;
- no definir unidades fuera del roadmap antes de crear `project/roadmap.md`;
- no introducir aplicaciones de ejemplo;
- no crear artefactos que contradigan `project/architecture.md`;
- no avanzar fuera del orden acordado;
- mantener cada incremento apto para un commit Git independiente.

---

# Riesgos y cuestiones abiertas

## R-001 — Directorios vacíos en Git

Git no conserva directorios vacíos.

Pendiente decidir si se crearán archivos `.gitkeep` durante el bootstrap o si los directorios se crearán cuando aparezca su primer artefacto real.

## R-002 — Alcance exacto del roadmap

La lista completa y la granularidad de las unidades aún no están formalizadas.

Debe resolverse en `project/roadmap.md`.

## R-003 — Aplicación evolutiva del curso

Todavía no se ha definido la aplicación o sistema funcional que evolucionará durante el itinerario.

Su selección deberá realizarse antes de la primera unidad que necesite workloads, manteniendo el principio de laboratorio único.

## R-004 — Versiones de herramientas

No se han fijado versiones de:

- Ubuntu;
- MicroK8s;
- Kubernetes;
- Helm;
- Terraform;
- herramientas adicionales.

Las versiones deberán definirse cuando sean necesarias y registrarse en el estado del proyecto.

## R-005 — Estrategia de validación automatizada

Todavía no se han definido mecanismos de linting, pruebas, validación de Markdown, manifiestos, Helm o Terraform.

El framework deberá permitir incorporarlos posteriormente.

---

# Deuda técnica

No existe deuda técnica de implementación porque todavía no se han generado componentes ejecutables.

Existe deuda de definición pendiente asociada a:

- roadmap;
- reglas maestras de generación;
- plantillas;
- playbook de la Unidad 0;
- estrategia de directorios vacíos;
- estrategia de validación automatizada.

---

# Historial de incrementos

| Orden | Incremento | Estado |
|---|---|---|
| 1 | `README.md` | Completado |
| 2 | `project/architecture.md` | Completado |
| 3 | `project/project-state.md` | Completado con este cambio |
| 4 | `project/roadmap.md` | Pendiente |
| 5 | `playbooks/master.md` | Pendiente |
| 6 | `playbooks/unit-template.md` | Pendiente |
| 7 | `playbooks/summary-template.md` | Pendiente |
| 8 | `playbooks/project-state-template.md` | Pendiente |
| 9 | `playbooks/units/00-environment.md` | Pendiente |

---

# Siguiente incremento permitido

El siguiente archivo que debe generarse es:

```text
project/roadmap.md
```

Su finalidad será definir la secuencia completa del itinerario, sus dependencias y la incorporación progresiva de capacidades.

No debe iniciarse `playbooks/master.md` ni contenido de la Unidad 0 antes de completar y revisar el roadmap.

---

# Regla de actualización

Este documento deberá actualizarse:

- al cerrar cada incremento del bootstrap;
- al completar cada unidad;
- cuando cambie la arquitectura desplegada;
- cuando se incorpore o retire una tecnología;
- cuando cambien dependencias relevantes;
- cuando se identifique deuda técnica;
- cuando se modifique el siguiente incremento permitido.

Las actualizaciones deberán describir únicamente hechos representados por archivos o artefactos verificables en el repositorio.
