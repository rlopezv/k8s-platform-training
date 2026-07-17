# How to Work with the Repository

## 1. Objetivo

Este documento define el mecanismo operativo para trabajar con el repositorio utilizando asistentes de IA.

Describe:

* cómo preparar una sesión;
* qué contexto debe proporcionarse;
* cómo trabajar con un asistente con o sin acceso al repositorio;
* cómo validar los resultados;
* cómo cerrar una sesión;
* cómo iniciar una nueva sesión;
* cómo mantener el repositorio como fuente única de verdad.

El plan de fases, unidades y sesiones se define en `project/project-planning.md`.

---

## 2. Principios operativos

### 2.1. El repositorio es la fuente única de verdad

Las conversaciones no deben contener información esencial que no esté registrada posteriormente en el repositorio.

Toda decisión relevante debe reflejarse en uno o varios de los siguientes documentos:

* `project/architecture.md`;
* `project/roadmap.md`;
* `project/project-state.md`;
* `tutorial/<unidad>/summary.md`;
* playbooks afectados;
* documentación técnica correspondiente.

El historial de una conversación nunca debe considerarse una dependencia permanente.

---

### 2.2. El trabajo debe ser incremental

Cada sesión debe producir un incremento coherente y limitado.

Debe evitarse:

* mezclar varias unidades sin necesidad;
* generar artefactos sin rutas de destino;
* modificar documentos anteriores sin justificación;
* introducir decisiones que contradigan la arquitectura;
* declarar completado trabajo no validado.

---

### 2.3. Las unidades reutilizan el trabajo anterior

No deben crearse ejemplos independientes salvo que exista una necesidad explícita y documentada.

Cada unidad debe reutilizar:

* el entorno existente;
* la aplicación base;
* los manifiestos;
* los charts;
* las configuraciones;
* los laboratorios;
* las decisiones técnicas anteriores.

---

### 2.4. Generación y validación son actividades distintas

Que un asistente genere un archivo no implica que el contenido esté validado.

El flujo correcto es:

```text
Generar
   ↓
Incorporar al repositorio
   ↓
Ejecutar o revisar
   ↓
Registrar resultados
   ↓
Corregir
   ↓
Aprobar
```

---

## 3. Modalidades de trabajo

El proyecto admite dos modalidades principales.

---

### 3.1. Asistente con acceso al workspace

Esta modalidad se aplica cuando el asistente puede inspeccionar directamente el repositorio desde un IDE, extensión o herramienta equivalente.

Ejemplos:

* asistente integrado en Visual Studio Code;
* herramienta con acceso al workspace;
* agente conectado al repositorio.

#### Ventajas

* acceso directo a la estructura;
* lectura de múltiples archivos;
* modificación coordinada de artefactos;
* menor necesidad de adjuntar contexto manualmente.

#### Procedimiento

El asistente debe leer, como mínimo:

```text
README.md
project/architecture.md
project/roadmap.md
project/project-state.md
project/project-planning.md
project/how-to.md
playbooks/master.md
```

Para una unidad también debe leer:

```text
playbooks/unit-template.md
playbooks/units/<unidad>.md
tutorial/<unidad-anterior>/summary.md
```

Cuando vaya a modificar artefactos existentes, debe inspeccionar sus versiones actuales.

El acceso al workspace facilita el proceso, pero no cambia las reglas de gobierno del proyecto.

---

### 3.2. Asistente conversacional sin acceso al workspace

Esta modalidad se aplica cuando el asistente no puede leer directamente el repositorio.

Ejemplo:

* una conversación independiente en ChatGPT.

En este caso, el usuario debe proporcionar un paquete de contexto suficiente.

No es obligatorio adjuntar todo el repositorio.

#### Paquete mínimo recomendado

```text
SESSION_HANDOFF.md
project/project-state.md
playbooks/master.md
playbooks/units/<unidad>.md
tutorial/<unidad-anterior>/summary.md
```

Cuando sean relevantes, añadir:

```text
project/architecture.md
project/roadmap.md
playbooks/unit-template.md
archivos existentes que deban modificarse
artefactos anteriores que deban reutilizarse
resultados de validación
mensajes de error
```

#### Regla

El asistente no debe exigir acceso completo al repositorio cuando el paquete proporcionado sea suficiente para realizar el trabajo.

---

## 4. Preparación de una sesión

Antes de comenzar una sesión, definir claramente:

* objetivo;
* alcance;
* unidad o fase afectada;
* archivos de entrada;
* archivos que pueden modificarse;
* resultado esperado;
* criterio de cierre.

### Plantilla recomendada

```markdown
# Inicio de sesión

## Objetivo

<objetivo concreto>

## Alcance

<fase, unidad o incremento afectado>

## Contexto proporcionado

- <archivo>
- <archivo>
- <archivo>

## Artefactos que pueden modificarse

- <ruta>
- <ruta>

## Resultado esperado

<resultado verificable>

## Criterio de cierre

<condiciones que deben cumplirse>
```

---

## 5. Lectura obligatoria por tipo de trabajo

### 5.1. Nueva unidad

Leer:

```text
README.md
project/architecture.md
project/roadmap.md
project/project-state.md
playbooks/master.md
playbooks/unit-template.md
playbooks/units/<unidad>.md
tutorial/<unidad-anterior>/summary.md
```

También deben leerse los artefactos que la unidad reutilizará.

---

### 5.2. Corrección de una unidad

Leer:

```text
project/project-state.md
playbooks/master.md
playbooks/units/<unidad>.md
tutorial/<unidad>/summary.md
archivos que contienen el error
resultados de validación
```

---

### 5.3. Revisión de arquitectura

Leer:

```text
README.md
project/architecture.md
project/roadmap.md
project/project-state.md
resúmenes de unidades afectadas
```

---

### 5.4. Actualización del roadmap

Leer:

```text
project/roadmap.md
project/project-state.md
project/architecture.md
project/project-planning.md
```

---

### 5.5. Reanudación tras una pausa prolongada

Leer:

```text
SESSION_HANDOFF.md
project/project-state.md
project/roadmap.md
project/architecture.md
último summary.md aprobado
```

---

## 6. Desarrollo de una sesión

Durante la sesión, el asistente debe:

1. comprobar la consistencia del contexto;
2. identificar el estado actual;
3. respetar la arquitectura y las restricciones;
4. reutilizar los artefactos existentes;
5. generar cambios con rutas de destino explícitas;
6. diferenciar entre contenido generado y contenido validado;
7. registrar decisiones y pendientes;
8. evitar modificar archivos fuera del alcance acordado.

---

## 7. Presentación de los resultados

Cuando el asistente no pueda editar directamente el repositorio, debe entregar cada artefacto indicando su ruta.

Ejemplo:

```text
Ruta: tutorial/01-kubernetes/README.md
```

Después debe proporcionar el contenido completo del archivo.

Para archivos modificados, debe generar preferentemente la versión completa resultante, salvo que se haya acordado explícitamente utilizar un parche.

Al finalizar, debe incluir un resumen de cambios:

```markdown
## Archivos nuevos

- `ruta/archivo.md`

## Archivos modificados

- `ruta/archivo.md`

## Validaciones pendientes

- <validación>

## Decisiones tomadas

- <decisión>

## Actualización de estado requerida

- <cambio en project-state.md>
```

---

## 8. Validación

La validación debe realizarse fuera del asistente cuando dependa del entorno real.

Ejemplos:

* ejecutar scripts;
* instalar herramientas;
* desplegar recursos;
* validar manifiestos;
* ejecutar `helm lint`;
* ejecutar `terraform validate`;
* ejecutar `terraform plan`;
* comprobar el estado de Kubernetes;
* verificar conectividad;
* ejecutar pruebas.

Los resultados deben volver a incorporarse a la siguiente sesión.

### Formato recomendado

````markdown
## Resultado de validación

### Comando

```bash
<comando>
````

### Resultado

<salida relevante>

### Estado

* Correcto
* Incorrecto
* Parcial

### Observaciones

<errores, advertencias o diferencias>

````

---

## 9. Cierre de una sesión

Una sesión debe cerrarse cuando:

- se ha completado un incremento coherente;
- cambia el objetivo del trabajo;
- se requiere validación externa;
- comienza una nueva unidad;
- se ha alcanzado un punto estable;
- el contexto acumulado deja de ser eficiente.

No es necesario esperar al final de una unidad completa.

---

### 9.1. Revisar el incremento

Comprobar:

- archivos creados;
- archivos modificados;
- validaciones realizadas;
- validaciones pendientes;
- decisiones nuevas;
- problemas conocidos;
- impacto sobre arquitectura y roadmap.

---

### 9.2. Actualizar el resumen de unidad

Cuando exista una unidad activa, actualizar:

```text
tutorial/<unidad>/summary.md
````

El resumen debe incluir:

* objetivos completados;
* artefactos creados;
* rutas relevantes;
* decisiones técnicas;
* estado del entorno;
* dependencias;
* restricciones;
* problemas conocidos;
* trabajo pendiente;
* entradas necesarias para la siguiente unidad.

---

### 9.3. Actualizar el estado del proyecto

Actualizar siempre:

```text
project/project-state.md
```

El estado debe reflejar la situación real.

Debe evitarse:

* declarar completada una unidad no validada;
* registrar artefactos que todavía no existen;
* ocultar errores pendientes;
* confundir trabajo previsto con trabajo completado.

---

### 9.4. Actualizar otros documentos

Cuando corresponda, actualizar:

```text
project/architecture.md
project/roadmap.md
project/project-planning.md
playbooks/
```

---

### 9.5. Revisar Git

Antes del commit:

```bash
git status
git diff
```

Comprobar:

* que no existen archivos accidentales;
* que las rutas son correctas;
* que no se han incluido secretos;
* que el alcance coincide con la sesión.

---

### 9.6. Realizar el commit

Ejemplos:

```bash
git add .
git commit -m "docs: add project planning and working guide"
```

```bash
git add .
git commit -m "feat: complete unit 0 environment setup"
```

```bash
git add .
git commit -m "fix: correct microk8s validation workflow"
```

El repositorio debería quedar limpio:

```bash
git status
```

---

### 9.7. Generar el handoff

Utilizar:

```text
playbooks/generate-session-handoff.md
```

El handoff debe generarse desde el estado actual del repositorio.

No debe mantenerse manualmente como una fuente de verdad.

El objetivo de la siguiente conversación debe ser explícito.

Ejemplo:

```text
Generar y validar la Unidad 1 de Kubernetes utilizando el entorno
MicroK8s aprobado en la Unidad 0.
```

---

## 10. Inicio de una nueva sesión

### 10.1. Con acceso al workspace

Proporcionar al asistente el objetivo de la sesión y pedirle que lea los documentos obligatorios.

Ejemplo:

```markdown
Revisa el estado actual del repositorio y comienza la Unidad 1 cuando su playbook exista.

Lee:

- `project/project-state.md`
- `project/architecture.md`
- `project/roadmap.md`
- `playbooks/master.md`
- `playbooks/units/01-kubernetes.md` cuando exista
- `tutorial/00-environment/summary.md`

Antes de generar artefactos, identifica las dependencias y confirma el
primer incremento recomendado.
```

---

### 10.2. Sin acceso al workspace

Adjuntar el paquete de contexto y utilizar un mensaje como este:

```markdown
# Inicio de sesión

Adjunto el `SESSION_HANDOFF.md` generado desde el estado actual del
repositorio.

## Objetivo

Generar y validar la Unidad 1 — Kubernetes.

## Contexto proporcionado

- `project/project-state.md`
- `playbooks/master.md`
- `playbooks/units/01-kubernetes.md` cuando exista
- `tutorial/00-environment/summary.md`
- artefactos relevantes de `platform/environment/`

## Reglas de trabajo

- El repositorio es la fuente única de verdad.
- La unidad debe ampliar el estado existente.
- No se debe crear un caso práctico independiente.
- No se deben modificar unidades anteriores salvo necesidad justificada.
- Cada archivo generado debe indicar su ruta de destino.
- Al terminar se debe generar o actualizar `summary.md`.
- Se debe proponer la actualización completa de `project-state.md`.
- La unidad no se considerará completada hasta validar sus artefactos.

Comienza revisando la consistencia del paquete de contexto.
```

---

## 11. Patrones de trabajo

### 11.1. Crear una nueva unidad

1. Revisar el estado del proyecto.
2. Leer el resumen anterior.
3. Leer el playbook de la unidad.
4. Identificar artefactos reutilizables.
5. Diseñar la unidad.
6. Generar tutorial, notas y laboratorio.
7. Ejecutar validaciones.
8. Corregir.
9. Actualizar `summary.md`.
10. Actualizar `project-state.md`.
11. Realizar commit.
12. Generar handoff.

---

### 11.2. Corregir un laboratorio

1. Proporcionar el error y el comando ejecutado.
2. Leer el laboratorio y los artefactos relacionados.
3. Identificar la causa.
4. Modificar el mínimo número de archivos.
5. Repetir la validación.
6. Registrar el problema y la solución.
7. Actualizar resumen y estado si el cambio es relevante.

---

### 11.3. Revisar una unidad existente

1. Definir el alcance de la revisión.
2. Leer tutorial, laboratorio, notas y resumen.
3. Comparar el contenido con los playbooks.
4. Identificar inconsistencias.
5. Proponer cambios.
6. Validar que no se rompen unidades posteriores.
7. Actualizar documentación de estado.

---

### 11.4. Cambiar la arquitectura

1. Identificar la motivación.
2. Evaluar impacto sobre unidades completadas y futuras.
3. Actualizar `architecture.md`.
4. Actualizar `roadmap.md`.
5. Actualizar `project-state.md`.
6. Ajustar playbooks afectados.
7. Registrar migraciones o trabajo pendiente.

---

### 11.5. Actualizar el roadmap

1. Revisar el estado actual.
2. Identificar el cambio de prioridad o secuencia.
3. Comprobar dependencias.
4. Actualizar `roadmap.md`.
5. Actualizar `project-planning.md` cuando cambien fases o sesiones.
6. Actualizar `project-state.md`.
7. Revisar playbooks afectados.

---

### 11.6. Generar un handoff

1. Confirmar que `project-state.md` está actualizado.
2. Confirmar que el resumen activo está actualizado.
3. Definir el objetivo de la siguiente sesión.
4. Ejecutar `playbooks/generate-session-handoff.md`.
5. Revisar que el handoff no incluya información obsoleta.
6. Utilizarlo como entrada de la nueva conversación.

---

### 11.7. Reanudar el proyecto tras varias semanas

1. Leer el último handoff disponible.
2. Leer `project-state.md`.
3. Leer `roadmap.md`.
4. Leer el último resumen aprobado.
5. Ejecutar `git log` y `git status`.
6. Confirmar que el repositorio coincide con el estado documentado.
7. Definir un nuevo objetivo de sesión.
8. Generar un handoff actualizado si fuera necesario.

---

## 12. Reglas para asistentes de IA

Todo asistente que trabaje con el repositorio debe:

* considerar el repositorio como fuente única de verdad;
* no depender del historial de conversaciones;
* no inventar estados, artefactos o validaciones;
* diferenciar entre trabajo generado y trabajo probado;
* respetar las rutas existentes;
* reutilizar artefactos previos;
* evitar ejemplos independientes;
* indicar claramente cualquier supuesto;
* registrar decisiones relevantes;
* actualizar el estado del proyecto;
* generar un resumen útil para la siguiente sesión;
* limitar los cambios al alcance acordado.

---

## 13. Flujo operativo completo

```text
Repositorio en estado válido
        ↓
Definir objetivo de sesión
        ↓
Preparar contexto
        ↓
Revisar estado y dependencias
        ↓
Diseñar el incremento
        ↓
Generar artefactos
        ↓
Incorporarlos al repositorio
        ↓
Ejecutar validaciones
        ↓
Corregir resultados
        ↓
Actualizar summary.md
        ↓
Actualizar project-state.md
        ↓
Revisar cambios
        ↓
Commit Git
        ↓
Generar SESSION_HANDOFF.md
        ↓
Iniciar nueva sesión
```

---

## 14. Criterio de calidad del mecanismo

El mecanismo de trabajo se considera correcto cuando:

* una nueva sesión puede comenzar sin consultar conversaciones anteriores;
* el asistente recibe únicamente el contexto necesario;
* el repositorio refleja el estado real;
* los resultados pueden validarse;
* los errores y pendientes permanecen documentados;
* cualquier asistente puede continuar el proyecto siguiendo este documento.
