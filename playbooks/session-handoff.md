# Generate Session Handoff

## Objetivo

Generar un documento **SESSION_HANDOFF.md** que permita iniciar una nueva conversación con un asistente de IA manteniendo el contexto completo del proyecto.

El documento generado debe ser autosuficiente y no depender del historial de conversaciones anteriores.

El asistente debe asumir que únicamente dispondrá del contenido del repositorio y del SESSION_HANDOFF generado.

---

## Modalidad de trabajo

Este proyecto puede continuarse mediante:

1. Un asistente con acceso directo al repositorio.
2. Un asistente conversacional sin acceso al workspace.

En modalidad conversacional, proporcionar como mínimo:

- `README.md`
- `project/architecture.md`
- `project/project-state.md`
- `playbooks/master.md`
- el playbook de la unidad
- el resumen de la unidad anterior

Añadir únicamente los artefactos existentes que la nueva unidad deba
consultar o modificar.

El asistente no debe exigir acceso completo al repositorio cuando el paquete
de contexto sea suficiente.

---

# Entradas

Antes de generar el SESSION_HANDOFF, leer obligatoriamente:

- README.md
- project/architecture.md
- project/project-state.md
- project/roadmap.md

Si existen, también leer:

- tutorial/<última unidad>/summary.md
- project/decisions.md
- project/known-issues.md

No utilizar información que no esté presente en estos documentos.

---

# Objetivo del handoff

El documento debe proporcionar el contexto mínimo necesario para que un nuevo asistente pueda continuar el proyecto sin necesidad de acceder al historial de conversaciones.

Debe resumir el estado actual del proyecto, no reproducir toda la documentación existente.

---

# Estructura del documento generado

Generar un documento Markdown con la siguiente estructura.

## 1. Proyecto

Descripción breve del proyecto.

Debe explicar:

- propósito
- alcance
- filosofía

---

## 2. Objetivos

Objetivos actuales del proyecto.

No incluir objetivos ya completados.

---

## 3. Arquitectura

Resumir únicamente la arquitectura relevante para continuar el trabajo.

Por ejemplo:

- entorno del laboratorio
- herramientas corporativas
- plataformas destino

No copiar architecture.md completo.

---

## 4. Estado actual

Generar automáticamente a partir de project-state.md.

Debe incluir:

- unidades completadas
- unidad actual
- siguiente unidad
- tecnologías incorporadas
- artefactos existentes

---

## 5. Estado del laboratorio

Resumir:

- entorno disponible
- scripts existentes
- laboratorios implementados

---

## 6. Flujo de generación

Recordar al asistente el procedimiento obligatorio.

Cada unidad deberá leer:

- playbooks/master.md
- architecture.md
- project-state.md
- summary de la unidad anterior
- playbook específico

Cada unidad deberá actualizar:

- summary.md
- project-state.md

---

## 7. Restricciones

Incluir siempre:

- reutilizar el laboratorio existente
- no generar ejemplos independientes
- mantener coherencia entre unidades
- no modificar unidades anteriores salvo necesidad
- actualizar siempre el estado del proyecto

Añadir automáticamente cualquier restricción registrada en project-state.md.

---

## 8. Objetivo de la nueva conversación

Este apartado debe ser parametrizable.

Debe indicar cuál es el objetivo concreto de la conversación que se va a iniciar.

Ejemplos:

- Bootstrap del repositorio
- Generación de la Unidad 0
- Revisión de la Unidad Kubernetes
- Actualización del roadmap
- Refactorización del laboratorio

---

## 9. Primeras acciones

Generar una lista ordenada de las primeras tareas recomendadas para continuar el proyecto.

Deben derivarse del estado actual.

No inventar nuevas tareas.

---

# Reglas

El SESSION_HANDOFF debe ser:

- corto
- preciso
- completamente consistente con el estado del repositorio

No duplicar documentación existente.

No copiar documentos completos.

Resumir.

---

# Criterio de calidad

Un nuevo asistente debe ser capaz de continuar el proyecto correctamente leyendo únicamente:

- SESSION_HANDOFF.md

y el contenido del repositorio.

No debe necesitar ninguna conversación anterior.

Ese es el criterio de aceptación del documento generado.