# Kubernetes Platform Engineering Training

Framework de repositorio para generar, mantener y evolucionar un itinerario completo de formación sobre plataformas Kubernetes con apoyo de inteligencia artificial.

El repositorio actúa como **fuente única de verdad** del proyecto. Su finalidad no es almacenar unidades formativas aisladas, sino proporcionar un sistema reproducible para construir, validar y mantener un curso incremental, coherente y técnicamente consistente.

## Objetivo del proyecto

Construir una formación profesional orientada a ingenieros de plataforma que evolucione progresivamente desde un laboratorio Kubernetes local hasta plataformas gestionadas en cloud.

El itinerario comenzará sobre:

- Windows 11
- WSL2
- Ubuntu LTS
- MicroK8s

Y evolucionará hacia:

- Azure Kubernetes Service (AKS)
- Amazon Elastic Kubernetes Service (EKS)

A lo largo del itinerario se incorporarán, entre otras, las siguientes tecnologías:

- Kubernetes
- Helm
- Terraform
- Argo CD
- Tekton
- Prometheus
- Grafana
- Loki
- Tempo
- OpenTelemetry
- OpenMetrics
- Seguridad de plataformas Kubernetes
- KEDA

## Principios de diseño

### Un único laboratorio evolutivo

Todo el curso utiliza una única solución técnica que se amplía de forma progresiva.

Cada unidad:

- parte del estado dejado por la unidad anterior;
- reutiliza los artefactos existentes;
- incorpora nuevas capacidades sobre la misma plataforma;
- evita ejemplos independientes o aplicaciones desechables;
- documenta explícitamente los cambios introducidos.

La creación de una aplicación o laboratorio alternativo solo estará permitida cuando exista una justificación técnica o pedagógica explícita.

### Desarrollo incremental

El contenido del curso se gestiona como software:

- cada cambio debe ser coherente y revisable;
- cada incremento debe poder corresponderse con uno o varios commits Git relacionados;
- el estado del proyecto debe permanecer actualizado;
- las decisiones arquitectónicas deben quedar documentadas;
- las unidades deben generarse siguiendo playbooks versionados;
- ningún contenido posterior debe contradecir el estado consolidado del repositorio.

### Fuente única de verdad

La IA no debe depender exclusivamente del contexto de una conversación.

Antes de generar o modificar una unidad, deberá leer los documentos de gobierno, el estado actual y los artefactos relevantes del repositorio.

El proyecto admite dos modalidades de trabajo:

- asistentes con acceso directo al workspace;
- asistentes conversacionales sin acceso directo al repositorio.

En modalidad conversacional se utilizará un paquete mínimo de contexto y, cuando sea necesario, un `SESSION_HANDOFF.md` generado desde el estado actual del repositorio.

El procedimiento operativo se define en `project/how-to.md`.

## Estructura del repositorio

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

### `playbooks/`

Contiene las instrucciones que gobiernan la generación y mantenimiento del curso.

Incluye:

- reglas globales del proyecto;
- plantilla común de las unidades;
- plantilla de resúmenes;
- plantilla del estado del proyecto;
- playbooks específicos para cada unidad;
- procedimiento para generar handoffs entre sesiones.

Los playbooks son instrucciones operativas para la IA y forman parte del código fuente del framework.

### `project/`

Contiene los documentos de gobierno, arquitectura, planificación, operación y estado consolidado del proyecto.

- `architecture.md`: arquitectura, principios técnicos y decisiones estructurales.
- `project-planning.md`: fases, secuencia de trabajo, sesiones recomendadas y criterios de cierre.
- `how-to.md`: mecanismo operativo para trabajar con el repositorio y asistentes de IA.
- `project-state.md`: estado actual y verificable del laboratorio y del contenido generado.
- `roadmap.md`: secuencia prevista de unidades, capacidades y dependencias.

### `tutorial/`

Contiene la documentación dirigida al alumno.

Cada unidad dispondrá de su propio directorio y deberá explicar:

- objetivos;
- conceptos;
- contexto;
- procedimiento;
- validaciones;
- resultados esperados;
- relación con unidades anteriores y posteriores.

### `labs/`

Contiene los artefactos ejecutables de los laboratorios:

- manifiestos Kubernetes;
- charts de Helm;
- código Terraform;
- pipelines;
- scripts auxiliares;
- configuraciones de observabilidad;
- políticas y recursos de seguridad;
- instrucciones de validación técnica.

Los laboratorios deben ser acumulativos y reutilizar los artefactos producidos anteriormente.

### `platform/`

Contiene componentes asociados a la plataforma base y a su ciclo de vida.

La preparación del entorno local constituye una excepción estructural denominada **Unidad 0**. Sus scripts y configuraciones vivirán en:

```text
platform/environment/
```

El contenido formativo de esa unidad seguirá residiendo en `tutorial/`, mientras que sus artefactos de plataforma se mantendrán en `platform/environment/`.

### `assets/`

Contiene recursos compartidos, por ejemplo:

- diagramas;
- imágenes;
- ficheros de referencia;
- plantillas auxiliares;
- recursos utilizados por varias unidades.

## Gobierno y operación del proyecto

La documentación de gobierno se distribuye de la siguiente forma:

| Documento | Responsabilidad |
|---|---|
| `README.md` | Presentar el proyecto y servir como punto de entrada |
| `project/architecture.md` | Definir la arquitectura y las restricciones estructurales |
| `project/project-planning.md` | Definir las fases, sesiones y criterios de cierre |
| `project/how-to.md` | Definir el mecanismo operativo de trabajo |
| `project/project-state.md` | Registrar el estado actual y verificable |
| `project/roadmap.md` | Definir la evolución prevista del itinerario |

Estos documentos no deben duplicarse entre sí. Cada uno debe mantener una responsabilidad clara.

## Mecanismo de generación de unidades

Antes de generar o modificar una unidad, la IA deberá leer obligatoriamente:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. el `summary.md` de la unidad anterior;
5. el playbook específico de la unidad.

Cuando sea relevante para el alcance de la sesión, también deberá consultar:

- `project/roadmap.md`;
- `project/project-planning.md`;
- `project/how-to.md`;
- artefactos existentes que deban reutilizarse o modificarse.

Para la Unidad 0 no existirá un resumen anterior. Esta excepción deberá estar contemplada expresamente en su playbook.

Cada unidad deberá generar como mínimo:

- documentación del alumno;
- laboratorio o artefactos ejecutables;
- notas del instructor;
- resumen de continuidad;
- actualización de `project/project-state.md`.

Una unidad no se considerará terminada mientras estos artefactos no sean coherentes entre sí y sus validaciones obligatorias no hayan sido ejecutadas o documentadas como pendientes.

## Estructura prevista de una unidad

La estructura exacta será definida por los playbooks, pero cada unidad deberá producir una organización equivalente a:

```text
tutorial/<unidad>/
├── README.md
├── student-notes.md
├── instructor-notes.md
└── summary.md

labs/<unidad>/
└── ...
```

Para la Unidad 0, los artefactos ejecutables se ubicarán en:

```text
platform/environment/
```

en lugar de `labs/`.

## Flujo de trabajo

El flujo general del proyecto será:

1. definir el objetivo y alcance de la sesión;
2. revisar el estado actual del repositorio;
3. preparar el contexto necesario;
4. leer los documentos obligatorios;
5. diseñar el incremento;
6. generar o actualizar los artefactos;
7. incorporar los cambios al repositorio;
8. ejecutar las validaciones aplicables;
9. corregir los resultados;
10. actualizar `summary.md` cuando exista una unidad activa;
11. actualizar `project/project-state.md`;
12. revisar los cambios;
13. realizar el commit Git;
14. generar un handoff cuando vaya a iniciarse una nueva sesión.

El mecanismo detallado de cierre y arranque de sesiones se documenta en `project/how-to.md`.

## Continuidad entre sesiones

El historial de conversación no forma parte de la fuente de verdad.

Antes de cerrar una sesión se deberá:

- actualizar `project/project-state.md`;
- actualizar el `summary.md` de la unidad activa;
- registrar decisiones, problemas y pendientes;
- revisar los cambios Git;
- realizar el commit correspondiente;
- generar, cuando sea necesario, un `SESSION_HANDOFF.md`.

`SESSION_HANDOFF.md` es un artefacto derivado y temporal.

Se genera mediante:

```text
playbooks/generate-session-handoff.md
```

No debe mantenerse manualmente como fuente de verdad ni sustituir a los documentos versionados del repositorio.

## Convenciones

### Nomenclatura de unidades

Las unidades utilizarán un prefijo numérico de dos dígitos y un nombre descriptivo en kebab-case.

Ejemplos:

```text
00-environment
01-kubernetes-foundations
02-workloads
03-configuration
```

### Idioma

La documentación formativa se redactará inicialmente en español.

Los nombres técnicos, comandos, APIs, recursos Kubernetes y términos cuyo uso habitual sea en inglés conservarán su denominación original.

### Comandos y configuraciones

Todos los comandos deberán:

- indicar el contexto de ejecución;
- ser reproducibles;
- evitar dependencias implícitas;
- incluir validaciones;
- documentar efectos secundarios relevantes.

### Idempotencia

Los scripts y automatizaciones deberán ser idempotentes siempre que sea razonablemente posible.

Cuando una operación no pueda ser idempotente, deberá documentarse:

- la condición previa;
- el efecto producido;
- el procedimiento de repetición;
- el procedimiento de recuperación.

### Seguridad

No se almacenarán en el repositorio:

- contraseñas;
- tokens;
- claves privadas;
- credenciales cloud;
- secretos Kubernetes reales;
- valores sensibles específicos de una organización.

Los ejemplos utilizarán placeholders, secretos locales ignorados por Git o mecanismos de gestión de secretos definidos expresamente.

## Estado del proyecto

La fase de **Bootstrap** está completada y el **Framework V1** está cerrado.

El repositorio dispone de:

- estructura base;
- arquitectura;
- planificación;
- mecanismo operativo;
- estado consolidado;
- roadmap;
- playbook maestro;
- plantillas comunes;
- playbooks de las Unidades 00 y 01;
- contenido y laboratorios de las Unidades 00 y 01;
- procedimiento de generación de handoffs.

El siguiente incremento recomendado se registra siempre en `project/project-state.md`. En el estado actual, el siguiente paso es generar el playbook de la **Unidad 02 — Configuración, secretos y ciclo de vida**.

El Framework V1 ya ha validado:

- la coherencia de los playbooks;
- las entradas y salidas de la Unidad 00;
- el mecanismo de continuidad;
- la preparación del playbook de la Unidad 00;
- el funcionamiento del framework sin depender del historial de conversación.

No se generará contenido de una unidad posterior hasta completar y cerrar su unidad precedente y aprobar el playbook específico que la gobierna.

## Criterios de finalización del framework de generación

La Fase 2 se considera completa porque:

- los playbooks base hayan sido revisados y aprobados;
- existe el playbook específico necesario para iniciar el itinerario;
- las entradas, salidas y validaciones de la Unidad 00 estén definidas;
- el mecanismo de continuidad entre sesiones haya sido probado;
- una nueva sesión pueda comenzar utilizando únicamente el repositorio y el contexto mínimo documentado;
- la Unidad 0 pueda iniciarse sin depender de decisiones no registradas.

## Licencia

La licencia del repositorio se definirá antes de publicar o distribuir el contenido fuera de su ámbito inicial.
