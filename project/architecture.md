# Arquitectura del proyecto

## Propósito

Este documento define la arquitectura del repositorio de formación Kubernetes y las reglas estructurales que deben conservarse durante toda su evolución.

Su función es establecer una base estable para:

- organizar el contenido;
- separar gobierno, planificación, operación, documentación y artefactos ejecutables;
- mantener continuidad entre unidades y sesiones;
- permitir generación asistida por IA sin depender del historial de conversación;
- soportar asistentes con y sin acceso directo al workspace;
- evitar divergencias entre documentación, laboratorios y estado real del proyecto.

Este documento forma parte de la fuente única de verdad del repositorio.

---

# Principios arquitectónicos

## 1. Repositorio como sistema de construcción del curso

El repositorio no contiene únicamente documentación.

Debe entenderse como un sistema compuesto por:

- documentos de gobierno;
- planificación del trabajo;
- procedimientos operativos;
- estado consolidado;
- instrucciones de generación;
- contenido formativo;
- laboratorios ejecutables;
- artefactos de plataforma;
- recursos compartidos.

La arquitectura debe permitir que una nueva sesión de IA reconstruya el contexto del proyecto leyendo exclusivamente los archivos versionados y, cuando proceda, un handoff derivado de ellos.

## 2. Evolución incremental

El curso se construye mediante incrementos sucesivos.

Cada unidad debe:

- partir del estado dejado por la unidad anterior;
- reutilizar la aplicación, infraestructura y configuraciones existentes;
- introducir cambios explícitos y trazables;
- actualizar el estado consolidado;
- producir un resumen que permita continuar el trabajo en una sesión posterior.

No se deben crear laboratorios independientes cuando sea posible ampliar los existentes.

La unidad de trabajo operativa es una sesión con un objetivo concreto y verificable. Una unidad formativa puede ocupar varias sesiones de diseño, generación, validación, corrección y cierre.

## 3. Separación de responsabilidades

El repositorio separa claramente:

- presentación general;
- arquitectura;
- planificación;
- mecanismo operativo;
- estado del proyecto;
- roadmap;
- contenido del alumno;
- notas del instructor;
- artefactos ejecutables;
- recursos de plataforma;
- recursos visuales o compartidos;
- instrucciones para asistentes de IA.

Esta separación evita que el contenido pedagógico o una conversación se conviertan en la única fuente de información técnica.

## 4. Coherencia sobre completitud aislada

Una unidad no se considera válida únicamente porque su documentación o laboratorio funcionen de forma independiente.

Debe ser coherente con:

- la arquitectura global;
- el roadmap;
- la planificación;
- el estado anterior;
- los artefactos ya existentes;
- las unidades siguientes previstas;
- las reglas operativas del repositorio.

La coherencia acumulativa tiene prioridad sobre la optimización local de una unidad.

## 5. Automatización reproducible

Los procedimientos deberán priorizar:

- comandos reproducibles;
- scripts idempotentes;
- validaciones explícitas;
- configuraciones versionadas;
- mínima dependencia de operaciones manuales no documentadas;
- separación entre contenido generado y contenido validado.

La generación de un artefacto no implica que dicho artefacto esté validado.

## 6. Neutralidad progresiva de plataforma

El laboratorio inicial utiliza MicroK8s sobre WSL2, pero la arquitectura debe facilitar la evolución hacia AKS y EKS.

Los conceptos, manifiestos y automatizaciones deberán evitar acoplamientos innecesarios a una distribución concreta.

Cuando exista una dependencia específica de plataforma, deberá identificarse y aislarse.

## 7. Independencia del asistente

La arquitectura no debe obligar al uso de una herramienta concreta.

El proyecto debe poder operarse mediante:

- un asistente con acceso directo al workspace;
- un asistente conversacional al que se proporciona un paquete mínimo de contexto;
- futuras automatizaciones basadas en API o CI.

El acceso directo al repositorio mejora la automatización, pero no constituye un requisito arquitectónico.

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
│   ├── generate-session-handoff.md
│   ├── master.md
│   ├── project-state-template.md
│   ├── student-reference-template.md
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
- mecanismo de continuidad;
- estado general del proyecto;
- siguiente incremento recomendado.

No debe duplicar en detalle la información de arquitectura, planificación, operación, roadmap o estado.

## `project/`

Contiene la información consolidada y los documentos de gobierno del proyecto.

### `project/architecture.md`

Define:

- estructura del repositorio;
- responsabilidades de cada componente;
- reglas de dependencia;
- flujo de generación;
- restricciones arquitectónicas;
- decisiones técnicas de alto nivel.

### `project/project-planning.md`

Define:

- fases del proyecto;
- secuencia recomendada de ejecución;
- sesiones recomendadas;
- objetivos y entregables por sesión;
- criterios de entrada y salida;
- criterios de cierre de fases y unidades.

No debe describir en detalle cómo interactuar con un asistente de IA.

### `project/how-to.md`

Define el mecanismo operativo de trabajo.

Debe describir:

- modalidades de trabajo;
- preparación de sesiones;
- contexto mínimo requerido;
- presentación de resultados;
- validación;
- cierre de sesiones;
- commits;
- generación de handoffs;
- arranque de nuevas sesiones;
- patrones operativos frecuentes.

No debe sustituir al roadmap ni al estado del proyecto.

### `project/project-state.md`

Representa el estado actual y verificable del proyecto.

Debe permitir responder:

- qué unidades existen;
- qué artefactos están implementados;
- qué componentes están desplegados;
- qué decisiones están activas;
- qué dependencias existen;
- qué limitaciones o deuda técnica permanecen;
- qué trabajo está validado y qué trabajo continúa pendiente.

No debe utilizarse como roadmap, manual operativo ni histórico detallado.

### `project/documentation-cleanup-plan.md`

Documento de gobierno temporal. Fija el plan de saneamiento de las Unidades 00-07 contra el contrato documental cerrado en la fase 2: qué se regenera, qué se ajusta, en qué orden y con qué modelo de sesión.

Es la fuente del plan mientras el saneamiento esté en curso. La tabla de fases de `project/project-state.md` lo resume y no debe divergir de él. Se retira cuando el saneamiento cierre, dejando su rastro en el historial de incrementos y en las deudas cerradas.

### `project/roadmap.md`

Define la evolución prevista del itinerario.

Debe incluir:

- secuencia de unidades;
- objetivos;
- dependencias;
- tecnologías incorporadas;
- resultados esperados;
- criterios de entrada y salida.

El roadmap puede evolucionar, pero cualquier cambio debe preservar la coherencia con el estado real y con `project/project-planning.md`.

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

### `playbooks/student-reference-template.md`

Define la estructura canónica y las obligaciones comprobables de `student-reference.md`, incluida la frontera de contenido con `student-notes.md`.

### `playbooks/summary-template.md`

Define el contenido obligatorio del resumen de continuidad de cada unidad.

### `playbooks/project-state-template.md`

Define la estructura y reglas de actualización de `project/project-state.md`.

### `playbooks/generate-session-handoff.md`

Define el procedimiento para generar un `SESSION_HANDOFF.md` temporal a partir de la fuente de verdad versionada.

El handoff:

- no constituye una fuente de verdad;
- no debe mantenerse manualmente;
- debe reflejar el estado actual del repositorio;
- debe incluir un objetivo concreto para la siguiente sesión;
- debe permitir iniciar una conversación sin depender del historial anterior.

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
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md
```

### `README.md`

Puerta de entrada de la unidad para el alumno: contexto, objetivos, mapa de aprendizaje, alcance, relación con unidades anteriores y orientación para usar el material.

### `student-notes.md`

Guía de aprendizaje de la unidad. Explica qué se va a cubrir, qué representa académicamente cada componente, qué se construye en el laboratorio, cómo se relacionan las piezas, qué ocurre al aplicar los artefactos, cómo comprobar el resultado, cómo diagnosticar fallos típicos, qué debe recordarse para la unidad siguiente y qué fuentes oficiales consultar.

No debe convertirse en una enciclopedia interna ni en una referencia densa de invariantes, glosarios y anexos. Su función es dar estructura académica y utilidad práctica al alumno antes y durante el laboratorio.

### `student-reference.md`

Referencia profesional obligatoria de la unidad. Completa a `student-notes.md` con visión general, profundidad técnica, variantes, herramientas habituales, límites y criterios de decisión que no deben saturar el tutorial ni el laboratorio.

Debe seguir `playbooks/student-reference-template.md`, enlazarse desde `README.md` y `student-notes.md`, y distinguir qué es conceptual, qué es práctica habitual y qué se ejecuta realmente en el curso.

La frontera con `student-notes.md` es de obligado cumplimiento: las notas explican y diagnostican lo que ocurre dentro del laboratorio, la referencia explica lo que existe fuera y corrige modelos mentales, y ningún contenido aparece en ambos documentos.

### `instructor-notes.md`

Información adicional para impartición, revisión o facilitación.

### `summary.md`

Resumen técnico y pedagógico que conecta la unidad con la siguiente y permite continuar el trabajo en nuevas sesiones.

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

Los componentes de clúster instalados por unidades posteriores se catalogan en:

```text
platform/tools/
```

Este catálogo distingue controladores, CRDs y operadores desplegados dentro de Kubernetes de los CLIs locales de `platform/environment/tools/`. La decisión de instalar un componente, su versión, namespace, persistencia y limpieza pertenece al playbook y al README del laboratorio de la unidad que lo introduce.

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

Cuando el trabajo afecte a planificación, operación o secuencia, también deberá consultar:

- `project/roadmap.md`;
- `project/project-planning.md`;
- `project/how-to.md`.

Además, deberá inspeccionar los artefactos existentes que vaya a reutilizar o modificar.

## Procesamiento

La IA deberá:

1. verificar que las dependencias de entrada existen;
2. detectar inconsistencias entre arquitectura, planificación, estado y roadmap;
3. identificar artefactos reutilizables;
4. diseñar el incremento mínimo necesario;
5. generar documentación y laboratorio coherentes;
6. incluir validaciones técnicas;
7. diferenciar explícitamente entre trabajo generado y trabajo validado;
8. actualizar el estado consolidado;
9. producir el resumen de continuidad.

## Salida obligatoria

Cada unidad deberá generar:

- documentación del alumno;
- laboratorio o artefactos ejecutables;
- notas del instructor;
- resumen de continuidad;
- actualización de `project/project-state.md`.

Cuando el asistente no pueda modificar directamente el repositorio, deberá proporcionar:

- ruta exacta de cada archivo;
- contenido completo o parche acordado;
- resumen de archivos nuevos y modificados;
- validaciones pendientes;
- decisiones tomadas;
- actualización requerida del estado.

## Validación

Antes de considerar cerrada una unidad se deberá comprobar:

- coherencia con la arquitectura;
- coherencia con la planificación y el roadmap;
- reutilización de artefactos previos;
- correspondencia entre documentación y laboratorio;
- comandos reproducibles;
- ausencia de secretos reales;
- validaciones ejecutables;
- actualización correcta del estado;
- continuidad suficiente para la siguiente unidad.

---

# Arquitectura de sesiones y continuidad

## Unidad operativa

La sesión constituye la unidad operativa recomendada.

Una sesión debe tener:

- objetivo concreto;
- alcance limitado;
- entradas identificadas;
- artefactos que pueden modificarse;
- resultado esperado;
- criterio de cierre.

Una unidad puede dividirse en sesiones de:

- diseño;
- generación;
- validación;
- corrección;
- cierre.

## Cierre de sesión

Antes de cerrar una sesión se deberá:

1. revisar los artefactos creados o modificados;
2. registrar validaciones realizadas y pendientes;
3. actualizar `tutorial/<unidad>/summary.md`, cuando exista una unidad activa;
4. actualizar `project/project-state.md`;
5. actualizar arquitectura, roadmap o planificación cuando corresponda;
6. revisar `git status` y `git diff`;
7. realizar el commit;
8. generar un handoff cuando vaya a iniciarse una nueva conversación.

## Arranque de sesión

Una nueva sesión podrá iniciarse:

- con acceso directo al workspace, leyendo los archivos obligatorios;
- sin acceso al workspace, mediante un paquete mínimo de contexto.

El paquete conversacional deberá contener como mínimo:

```text
SESSION_HANDOFF.md
project/project-state.md
playbooks/master.md
playbooks/units/<unidad>.md
tutorial/<unidad-anterior>/summary.md
```

Se añadirán los artefactos que deban consultarse o modificarse.

---

# Modelo de dependencias

Las dependencias deben fluir en una única dirección lógica:

```text
architecture + planning + roadmap + state
                 + previous summary
                 + unit playbook
                         ↓
                session increment
                         ↓
              generated unit artifacts
                         ↓
                 external validation
                         ↓
              updated summary and state
                         ↓
                 commit and handoff
                         ↓
                 next session or unit
```

No se permite que una unidad redefina unilateralmente la arquitectura global.

Cuando una unidad requiera un cambio arquitectónico:

1. se actualizará primero `project/architecture.md`;
2. se revisará el impacto en `project/roadmap.md`;
3. se actualizará `project/project-planning.md` si cambia la secuencia de trabajo;
4. se actualizará el playbook correspondiente;
5. se generará posteriormente la unidad.

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
- obligar al uso de un asistente o IDE concreto;
- mantener manualmente un handoff como fuente de verdad;
- almacenar credenciales reales;
- omitir validaciones;
- declarar validado contenido que solo ha sido generado;
- cerrar una unidad sin resumen;
- cerrar una unidad sin actualizar el estado.

## Permitido con justificación

- crear prototipos aislados;
- mantener snapshots;
- introducir variantes de plataforma;
- sustituir componentes;
- reorganizar directorios;
- dividir una unidad;
- fusionar unidades;
- dividir una unidad en varias sesiones;
- utilizar herramientas distintas para ejecutar el mismo mecanismo de trabajo.

La justificación deberá registrarse en arquitectura, roadmap, planificación o estado según corresponda.

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

## ADR-006 — Planificación y mecanismo operativo separados

La planificación se mantiene en:

```text
project/project-planning.md
```

El mecanismo operativo se mantiene en:

```text
project/how-to.md
```

Motivo:

Separar qué debe hacerse y en qué orden de cómo se ejecuta el trabajo con asistentes de IA.

## ADR-007 — Handoff como artefacto derivado

`SESSION_HANDOFF.md` se genera mediante:

```text
playbooks/generate-session-handoff.md
```

Motivo:

Evitar mantener una fuente de contexto duplicada y potencialmente obsoleta.

## ADR-008 — Neutralidad respecto al asistente

El framework debe soportar asistentes con acceso al workspace y asistentes conversacionales.

Motivo:

Evitar que el proyecto dependa de Visual Studio Code, una extensión concreta o una plataforma de IA determinada.

---

# Gestión de cambios arquitectónicos

Cualquier cambio estructural deberá evaluar:

- impacto en unidades existentes;
- impacto en playbooks;
- impacto en rutas;
- impacto en automatizaciones;
- impacto en planificación y sesiones;
- necesidad de migración;
- compatibilidad con asistentes con y sin acceso al workspace;
- compatibilidad con sesiones futuras;
- actualización del README;
- actualización de `project/how-to.md` y `project/project-planning.md` cuando corresponda.

Los cambios arquitectónicos deberán realizarse en un incremento independiente cuando su impacto sea significativo.

---

# Estado arquitectónico actual

La fase de Bootstrap está completada y el Framework V1 está cerrado.

La arquitectura del repositorio incluye actualmente:

- documentos de gobierno;
- planificación del trabajo;
- mecanismo operativo;
- estado consolidado;
- roadmap;
- playbooks versionados;
- generación de handoffs;
- soporte para sesiones con y sin acceso al workspace.

El primer incremento arquitectónicamente permitido tras cerrar el framework fue la Unidad 00 — Preparación del entorno. Esa condición histórica ya se cumplió. El siguiente incremento operativo vigente debe consultarse en `project/project-state.md`.

El Framework V1 ya ha validado:

- coherencia de los playbooks base;
- entradas y salidas de la Unidad 00;
- mecanismo de continuidad;
- playbook específico de la Unidad 00;
- funcionamiento del framework sin depender del historial de conversación.

---

# Criterios de calidad arquitectónica

La arquitectura se considerará correctamente aplicada cuando:

- una nueva sesión pueda comprender el proyecto leyendo los archivos obligatorios;
- un asistente conversacional pueda trabajar con un paquete mínimo de contexto;
- el proyecto no dependa de una herramienta concreta;
- cada unidad pueda identificar con precisión sus entradas y salidas;
- cada sesión tenga un alcance y criterio de cierre verificables;
- no existan duplicidades innecesarias;
- la plataforma evolucione de forma acumulativa;
- documentación y artefactos ejecutables permanezcan alineados;
- se diferencie entre contenido generado y contenido validado;
- el estado consolidado sea suficiente para continuar;
- las decisiones técnicas relevantes estén documentadas;
- el repositorio pueda revisarse mediante commits pequeños y coherentes;
- el handoff pueda regenerarse desde la fuente de verdad versionada.
