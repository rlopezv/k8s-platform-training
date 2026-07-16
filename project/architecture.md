# Arquitectura del proyecto

## Propósito

Este documento define la arquitectura del repositorio de formación Kubernetes y las reglas estructurales que deben conservarse durante toda su evolución.

Su función es establecer una base estable para:

- organizar el contenido;
- separar gobierno, documentación y artefactos ejecutables;
- mantener continuidad entre unidades;
- permitir generación asistida por IA sin depender del historial de conversación;
- evitar divergencias entre documentación, laboratorios y estado real del proyecto.

Este documento forma parte de la fuente única de verdad del repositorio.

---

# Principios arquitectónicos

## 1. Repositorio como sistema de construcción del curso

El repositorio no contiene únicamente documentación.

Debe entenderse como un sistema compuesto por:

- documentos de gobierno;
- estado consolidado;
- instrucciones de generación;
- contenido formativo;
- laboratorios ejecutables;
- artefactos de plataforma;
- recursos compartidos.

La arquitectura debe permitir que una nueva sesión de IA pueda reconstruir el contexto del proyecto leyendo exclusivamente los archivos versionados.

## 2. Evolución incremental

El curso se construye mediante incrementos sucesivos.

Cada unidad debe:

- partir del estado dejado por la unidad anterior;
- reutilizar la aplicación, infraestructura y configuraciones existentes;
- introducir cambios explícitos y trazables;
- actualizar el estado consolidado;
- producir un resumen que permita continuar el trabajo en una sesión posterior.

No se deben crear laboratorios independientes cuando sea posible ampliar los existentes.

## 3. Separación de responsabilidades

El repositorio separa claramente:

- gobierno del proyecto;
- estado del proyecto;
- contenido del alumno;
- notas del instructor;
- artefactos ejecutables;
- recursos de plataforma;
- recursos visuales o compartidos.

Esta separación evita que el contenido pedagógico se convierta en la única fuente de información técnica.

## 4. Coherencia sobre completitud aislada

Una unidad no se considera válida únicamente porque su documentación o laboratorio funcionen de forma independiente.

Debe ser coherente con:

- la arquitectura global;
- el roadmap;
- el estado anterior;
- los artefactos ya existentes;
- las unidades siguientes previstas.

La coherencia acumulativa tiene prioridad sobre la optimización local de una unidad.

## 5. Automatización reproducible

Los procedimientos deberán priorizar:

- comandos reproducibles;
- scripts idempotentes;
- validaciones explícitas;
- configuraciones versionadas;
- mínima dependencia de operaciones manuales no documentadas.

## 6. Neutralidad progresiva de plataforma

El laboratorio inicial utiliza MicroK8s sobre WSL2, pero la arquitectura debe facilitar la evolución hacia AKS y EKS.

Los conceptos, manifiestos y automatizaciones deberán evitar acoplamientos innecesarios a una distribución concreta.

Cuando exista una dependencia específica de plataforma, deberá identificarse y aislarse.

---

# Arquitectura lógica del repositorio

```text
.
├── README.md
├── assets/
├── labs/
├── platform/
│   └── environment/
├── playbooks/
│   ├── master.md
│   ├── project-state-template.md
│   ├── summary-template.md
│   ├── unit-template.md
│   └── units/
│       └── 00-environment.md
├── project/
│   ├── architecture.md
│   ├── project-state.md
│   └── roadmap.md
└── tutorial/
```

---

# Componentes

## `README.md`

Es el punto de entrada del repositorio.

Debe explicar:

- finalidad;
- estructura;
- principios de trabajo;
- mecanismo de generación;
- estado general del proyecto;
- criterios de bootstrap.

No debe duplicar en detalle la información de arquitectura, roadmap o estado.

## `project/`

Contiene la información consolidada del proyecto.

### `project/architecture.md`

Define:

- estructura del repositorio;
- responsabilidades de cada componente;
- reglas de dependencia;
- flujo de generación;
- restricciones arquitectónicas;
- decisiones técnicas de alto nivel.

### `project/project-state.md`

Representa el estado actual y verificable del proyecto.

Debe permitir responder:

- qué unidades existen;
- qué artefactos están implementados;
- qué componentes están desplegados;
- qué decisiones están activas;
- qué dependencias existen;
- qué limitaciones o deuda técnica permanecen.

No debe utilizarse como roadmap ni como histórico detallado.

### `project/roadmap.md`

Define la evolución prevista del itinerario.

Debe incluir:

- secuencia de unidades;
- objetivos;
- dependencias;
- tecnologías incorporadas;
- resultados esperados;
- criterios de entrada y salida.

El roadmap puede evolucionar, pero cualquier cambio debe preservar la coherencia con el estado real.

## `playbooks/`

Contiene las instrucciones de generación para la IA.

### `playbooks/master.md`

Define las reglas globales obligatorias para todas las unidades.

Debe gobernar:

- lectura de contexto;
- uso de artefactos previos;
- estructura de salida;
- validación;
- actualización del estado;
- tratamiento de inconsistencias;
- criterios de finalización.

### `playbooks/unit-template.md`

Define la estructura mínima de un playbook específico de unidad.

### `playbooks/summary-template.md`

Define el contenido obligatorio del resumen de continuidad de cada unidad.

### `playbooks/project-state-template.md`

Define la estructura y reglas de actualización de `project/project-state.md`.

### `playbooks/units/`

Contiene un playbook por unidad.

Cada playbook específico deberá:

- declarar objetivos;
- identificar dependencias;
- indicar artefactos previos que deben reutilizarse;
- definir entregables;
- establecer validaciones;
- documentar decisiones permitidas y prohibidas.

## `tutorial/`

Contiene la documentación dirigida al alumno.

Cada unidad deberá disponer de un directorio propio:

```text
tutorial/<unidad>/
```

Como mínimo contendrá:

```text
tutorial/<unidad>/
├── README.md
├── instructor-notes.md
└── summary.md
```

### `README.md`

Contenido principal de la unidad para el alumno.

### `instructor-notes.md`

Información adicional para impartición, revisión o facilitación.

### `summary.md`

Resumen técnico y pedagógico que conecta la unidad con la siguiente.

El resumen no sustituye a `project-state.md`.

## `labs/`

Contiene artefactos ejecutables asociados a las unidades.

Ejemplos:

- manifiestos Kubernetes;
- charts Helm;
- código Terraform;
- pipelines Tekton;
- recursos Argo CD;
- configuraciones de observabilidad;
- políticas de seguridad;
- pruebas y scripts auxiliares.

Estructura recomendada:

```text
labs/<unidad>/
```

Los laboratorios deben evolucionar de forma acumulativa.

No se debe copiar una solución completa en cada unidad salvo que exista una necesidad de snapshot explícitamente documentada.

## `platform/`

Contiene artefactos estructurales de la plataforma base.

La Unidad 0 es una excepción deliberada.

Sus scripts y configuraciones se ubican en:

```text
platform/environment/
```

Este directorio podrá incluir:

- instalación y configuración de WSL2;
- preparación de Ubuntu;
- instalación y configuración de MicroK8s;
- instalación de herramientas auxiliares;
- validaciones del entorno;
- scripts de diagnóstico;
- operaciones de reset o recuperación.

Los artefactos de unidades posteriores deberán residir normalmente en `labs/`.

## `assets/`

Contiene recursos compartidos:

- diagramas;
- imágenes;
- plantillas;
- ejemplos de configuración reutilizables;
- ficheros de soporte;
- material gráfico.

No debe utilizarse como ubicación genérica para archivos sin clasificar.

---

# Flujo de generación de una unidad

## Entrada obligatoria

Antes de generar o modificar una unidad, la IA deberá leer:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `summary.md` de la unidad anterior;
5. playbook específico de la unidad.

Para la Unidad 0 no existirá resumen anterior.

Esta excepción deberá estar declarada en `playbooks/units/00-environment.md`.

## Procesamiento

La IA deberá:

1. verificar que las dependencias de entrada existen;
2. detectar inconsistencias entre arquitectura, estado y roadmap;
3. identificar artefactos reutilizables;
4. diseñar el incremento mínimo necesario;
5. generar documentación y laboratorio coherentes;
6. incluir validaciones técnicas;
7. actualizar el estado consolidado;
8. producir el resumen de continuidad.

## Salida obligatoria

Cada unidad deberá generar:

- documentación del alumno;
- laboratorio o artefactos ejecutables;
- notas del instructor;
- resumen de continuidad;
- actualización de `project/project-state.md`.

## Validación

Antes de considerar cerrada una unidad se deberá comprobar:

- coherencia con la arquitectura;
- reutilización de artefactos previos;
- correspondencia entre documentación y laboratorio;
- comandos reproducibles;
- ausencia de secretos reales;
- validaciones ejecutables;
- actualización correcta del estado;
- continuidad suficiente para la siguiente unidad.

---

# Modelo de dependencias

Las dependencias deben fluir en una única dirección lógica:

```text
architecture + roadmap + state + previous summary + unit playbook
                              ↓
                    generated unit artifacts
                              ↓
                   updated project state
                              ↓
                    next unit continuity
```

No se permite que una unidad redefina unilateralmente la arquitectura global.

Cuando una unidad requiera un cambio arquitectónico:

1. se actualizará primero `project/architecture.md`;
2. se revisará el impacto en `project/roadmap.md`;
3. se actualizará el playbook correspondiente;
4. se generará posteriormente la unidad.

---

# Arquitectura del laboratorio evolutivo

## Estado inicial

El laboratorio comienza sobre:

- Windows 11;
- WSL2;
- Ubuntu LTS;
- MicroK8s.

## Evolución prevista

La plataforma evolucionará progresivamente incorporando:

- workloads Kubernetes;
- configuración y secretos;
- almacenamiento;
- networking e ingress;
- empaquetado con Helm;
- infraestructura como código con Terraform;
- GitOps con Argo CD;
- CI con Tekton;
- observabilidad con Prometheus, Grafana, Loki y Tempo;
- telemetría con OpenTelemetry y OpenMetrics;
- seguridad;
- escalado con KEDA;
- despliegue en AKS;
- despliegue en EKS.

## Reutilización

La solución desarrollada debe mantenerse reconocible durante todo el itinerario.

Los cambios deberán realizarse preferentemente mediante:

- extensión de manifiestos existentes;
- incorporación de nuevos charts o valores;
- refactorización controlada;
- migración progresiva;
- parametrización;
- sustitución documentada de componentes.

---

# Restricciones arquitectónicas

## Prohibido

- crear una aplicación distinta por unidad sin justificación;
- duplicar laboratorios completos;
- introducir herramientas no declaradas sin actualizar arquitectura y roadmap;
- asumir estado no registrado en `project-state.md`;
- depender de información exclusiva de una conversación;
- almacenar credenciales reales;
- omitir validaciones;
- cerrar una unidad sin resumen;
- cerrar una unidad sin actualizar el estado.

## Permitido con justificación

- crear prototipos aislados;
- mantener snapshots;
- introducir variantes de plataforma;
- sustituir componentes;
- reorganizar directorios;
- dividir una unidad;
- fusionar unidades.

La justificación deberá registrarse en arquitectura, roadmap o estado según corresponda.

---

# Decisiones arquitectónicas iniciales

## ADR-001 — MicroK8s como plataforma local inicial

Se adopta MicroK8s como distribución Kubernetes local para la primera fase del itinerario.

Motivos:

- integración adecuada con Ubuntu sobre WSL2;
- instalación compacta;
- soporte de addons;
- similitud operativa con un clúster Kubernetes real;
- capacidad de evolución progresiva;
- menor dependencia de máquinas virtuales adicionales.

La formación deberá distinguir claramente entre:

- comportamiento estándar de Kubernetes;
- comportamiento específico de MicroK8s;
- diferencias posteriores con AKS y EKS.

## ADR-002 — Unidad 0 fuera de `labs/`

Los artefactos ejecutables de la preparación del entorno se ubican en:

```text
platform/environment/
```

Motivo:

La preparación de la plataforma es una capacidad transversal y previa al laboratorio funcional del curso.

## ADR-003 — Resumen por unidad

Cada unidad generará un `summary.md`.

Motivo:

El resumen constituye el contrato de continuidad entre unidades y sesiones de IA.

## ADR-004 — Estado consolidado central

El estado global se mantiene exclusivamente en:

```text
project/project-state.md
```

Motivo:

Evitar que la IA deba reconstruir el estado real leyendo todas las unidades anteriores.

## ADR-005 — Playbooks versionados

Las instrucciones de generación se almacenan en el repositorio.

Motivo:

Las reglas del proyecto deben evolucionar mediante control de versiones y revisión, igual que el resto del código.

---

# Gestión de cambios arquitectónicos

Cualquier cambio estructural deberá evaluar:

- impacto en unidades existentes;
- impacto en playbooks;
- impacto en rutas;
- impacto en automatizaciones;
- necesidad de migración;
- compatibilidad con sesiones futuras;
- actualización del README.

Los cambios arquitectónicos deberán realizarse en un incremento independiente cuando su impacto sea significativo.

---

# Criterios de calidad arquitectónica

La arquitectura se considerará correctamente aplicada cuando:

- una nueva sesión pueda comprender el proyecto leyendo los archivos obligatorios;
- cada unidad pueda identificar con precisión sus entradas y salidas;
- no existan duplicidades innecesarias;
- la plataforma evolucione de forma acumulativa;
- documentación y artefactos ejecutables permanezcan alineados;
- el estado consolidado sea suficiente para continuar;
- las decisiones técnicas relevantes estén documentadas;
- el repositorio pueda revisarse mediante commits pequeños y coherentes.
