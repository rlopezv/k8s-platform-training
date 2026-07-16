# Kubernetes Platform Engineering Training

Framework de repositorio para generar, mantener y evolucionar un itinerario completo de formación sobre plataformas Kubernetes con apoyo de inteligencia artificial.

El repositorio actúa como **fuente única de verdad** del proyecto. Su finalidad no es almacenar unidades formativas aisladas, sino proporcionar un sistema reproducible para construir un curso incremental, coherente y técnicamente consistente.

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
- cada incremento debe poder corresponderse con un commit Git;
- el estado del proyecto debe permanecer actualizado;
- las decisiones arquitectónicas deben quedar documentadas;
- las unidades deben generarse siguiendo playbooks versionados;
- ningún contenido posterior debe contradecir el estado consolidado del repositorio.

### Fuente única de verdad

La IA no debe depender exclusivamente del contexto de una conversación.

Antes de generar una unidad, deberá leer los documentos de gobierno y el estado actual del repositorio. De esta forma, el contenido podrá evolucionar entre sesiones sin perder continuidad.

## Estructura del repositorio

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

### `playbooks/`

Contiene las instrucciones que gobiernan la generación y mantenimiento del curso.

Incluye:

- reglas globales del proyecto;
- plantilla común de las unidades;
- plantilla de resúmenes;
- plantilla del estado del proyecto;
- playbooks específicos para cada unidad.

Los playbooks son instrucciones operativas para la IA y forman parte del código fuente del framework.

### `project/`

Contiene la información consolidada del proyecto.

- `architecture.md`: arquitectura, principios técnicos y decisiones estructurales.
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

## Mecanismo de generación de unidades

Antes de generar o modificar una unidad, la IA deberá leer obligatoriamente:

1. `playbooks/master.md`
2. `project/architecture.md`
3. `project/project-state.md`
4. el `summary.md` de la unidad anterior;
5. el playbook específico de la unidad.

Para la primera unidad no existirá un resumen anterior. Esta excepción deberá estar contemplada expresamente en su playbook.

Cada unidad deberá generar como mínimo:

- documentación del alumno;
- laboratorio ejecutable;
- notas del instructor;
- resumen de continuidad;
- actualización de `project/project-state.md`.

Una unidad no se considerará terminada mientras estos artefactos no sean coherentes entre sí.

## Estructura prevista de una unidad

La estructura exacta será definida por los playbooks, pero cada unidad deberá producir una organización equivalente a:

```text
tutorial/<unidad>/
├── README.md
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

1. revisar el estado actual del repositorio;
2. seleccionar la siguiente unidad del roadmap;
3. leer los documentos obligatorios;
4. generar o actualizar los artefactos;
5. validar coherencia técnica y pedagógica;
6. actualizar `project/project-state.md`;
7. revisar el incremento;
8. realizar el commit Git.

Cada respuesta de IA deberá producir un incremento autocontenido, revisable y compatible con el estado anterior del repositorio.

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

El proyecto se encuentra actualmente en fase de **Bootstrap**.

En esta fase se construirá únicamente el framework del repositorio:

1. `README.md`
2. `project/architecture.md`
3. `project/project-state.md`
4. `project/roadmap.md`
5. `playbooks/master.md`
6. `playbooks/unit-template.md`
7. `playbooks/summary-template.md`
8. `playbooks/project-state-template.md`
9. `playbooks/units/00-environment.md`

No se generará contenido formativo de la Unidad 0 hasta completar y revisar todos los elementos del bootstrap.

## Criterios de finalización del bootstrap

El bootstrap se considerará completo cuando:

- exista la estructura base del repositorio;
- estén definidos los documentos de arquitectura, estado y roadmap;
- exista un playbook maestro;
- existan las plantillas comunes;
- exista el playbook específico de la Unidad 0;
- el mecanismo de continuidad entre unidades esté documentado;
- el repositorio pueda utilizarse desde una nueva sesión de IA sin depender del historial de conversación.

## Licencia

La licencia del repositorio se definirá antes de publicar o distribuir el contenido fuera de su ámbito inicial.
