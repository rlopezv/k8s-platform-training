# Plantilla de playbook de unidad

## Propósito

Esta plantilla define la estructura mínima y obligatoria que debe seguir cualquier playbook específico de unidad almacenado en:

```text
playbooks/units/
```

Cada playbook de unidad concreta el alcance, las dependencias, los entregables y las validaciones de esa unidad sin contradecir:

- `project/architecture.md`;
- `project/project-state.md`;
- `project/roadmap.md`;
- `playbooks/master.md`.

El playbook específico no sustituye al playbook maestro. Lo complementa.

---

# Instrucciones de uso

Para crear un nuevo playbook:

1. copiar esta plantilla;
2. guardarla como:

```text
playbooks/units/NN-unit-name.md
```

3. sustituir todos los placeholders;
4. eliminar secciones no aplicables únicamente cuando la plantilla lo permita;
5. verificar coherencia con arquitectura, roadmap y estado;
6. revisar que los criterios de entrada y salida sean verificables.

No se debe comenzar la generación de una unidad mientras su playbook específico permanezca incompleto.

---

# Identificación

## Unidad

```text
NN — Nombre de la unidad
```

## Identificador

```text
NN-unit-name
```

## Fase del roadmap

```text
Fase X — Nombre de la fase
```

## Estado del playbook

Seleccionar uno:

- Borrador
- En revisión
- Aprobado
- Obsoleto

## Propietario lógico

Indicar el área responsable de mantener el alcance de la unidad.

Ejemplos:

- Plataforma local
- Fundamentos Kubernetes
- CI/CD
- Observabilidad
- Seguridad
- Cloud

---

# Propósito de la unidad

Describir en uno o dos párrafos:

- el problema que resuelve;
- por qué aparece en este punto del itinerario;
- qué capacidad añade a la solución evolutiva;
- cómo prepara las unidades posteriores.

La descripción no debe convertirse en contenido formativo.

## Supuesto pedagógico

Declarar explícitamente el nivel de partida esperado.

La unidad debe escribirse para alumnos con perfil técnico que todavía no dominan el tema tratado. No asumir que conocen las abstracciones principales de la unidad salvo que aparezcan como dependencia pedagógica real y verificable de una unidad anterior.

Indicar:

- qué conceptos se explicarán desde cero;
- qué conceptos se retomarán de unidades anteriores;
- qué conceptos solo se mencionarán para continuidad y se diferirán;
- qué errores de razonamiento deben prevenirse.

---

# Resultado de aprendizaje

Al completar la unidad, el alumno deberá ser capaz de:

- [resultado verificable 1];
- [resultado verificable 2];
- [resultado verificable 3];
- [resultado verificable 4].

Los resultados deben utilizar verbos observables, por ejemplo:

- desplegar;
- configurar;
- diagnosticar;
- validar;
- comparar;
- automatizar;
- recuperar;
- justificar.

Evitar verbos vagos como “conocer” o “entender” cuando no estén acompañados por una evidencia observable.

---

# Alcance

## Incluido

- [capacidad incluida 1];
- [capacidad incluida 2];
- [capacidad incluida 3].

## Excluido

- [capacidad excluida 1];
- [capacidad excluida 2].

## Diferido a unidades posteriores

| Capacidad | Unidad prevista | Motivo |
|---|---|---|
| [capacidad] | [unidad] | [razón] |

Esta sección evita anticipar contenido fuera de secuencia.

---

# Fuentes obligatorias

Antes de generar o modificar esta unidad, leer:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `playbooks/student-reference-template.md`;
6. `project/coverage-map.md`, cuando exista sección de cobertura para la unidad;
7. `tutorial/<unidad-anterior>/summary.md`;
8. este playbook;
9. [artefactos previos concretos].

## Excepciones

Declarar cualquier excepción válida.

Ejemplo para la Unidad 0:

```text
No existe summary de una unidad anterior porque esta es la primera unidad del itinerario.
```

No dejar esta sección vacía. Escribir `Ninguna` cuando no existan excepciones.

---

# Dependencias

## Dependencias documentales

- [documento 1];
- [documento 2].

## Dependencias técnicas

| Dependencia | Estado requerido | Método de comprobación |
|---|---|---|
| [componente] | [estado] | [comando o evidencia] |

## Dependencias pedagógicas

El alumno debe haber completado o dominar:

- [conocimiento previo 1];
- [conocimiento previo 2].

## Dependencias del laboratorio

Artefactos que deben existir antes de comenzar:

```text
[ruta exacta]
[ruta exacta]
```

---

# Estado inicial esperado

Describir el estado verificable desde el que parte la unidad.

Incluir:

- plataforma disponible;
- componentes desplegados;
- aplicación existente;
- namespaces;
- herramientas;
- artefactos;
- limitaciones activas.

No asumir estados no registrados en `project/project-state.md`.

## Validación del estado inicial

Incluir comandos o comprobaciones que permitan confirmar las precondiciones.

```bash
# Comando de ejemplo
```

Resultado esperado:

```text
[resultado]
```

---

# Artefactos que deben reutilizarse

| Artefacto | Ruta | Uso en esta unidad |
|---|---|---|
| [artefacto] | `[ruta]` | [uso] |

## Reglas de reutilización

- no duplicar [artefacto];
- extender [recurso];
- conservar [convención];
- migrar [componente] únicamente si se cumple [condición].

Cuando no existan artefactos previos, declararlo explícitamente.

---

# Cambios previstos sobre la solución

## Componentes nuevos

| Componente | Responsabilidad | Ubicación prevista |
|---|---|---|
| [componente] | [responsabilidad] | `[ruta]` |

## Componentes modificados

| Componente | Cambio | Compatibilidad esperada |
|---|---|---|
| [componente] | [cambio] | [impacto] |

## Componentes retirados

| Componente | Motivo | Migración |
|---|---|---|
| [componente] | [motivo] | [procedimiento] |

Escribir `Ninguno` cuando una subsección no aplique.

---

# Decisiones de diseño de la unidad

Registrar decisiones específicas que condicionen la generación.

## D-01 — [Título]

### Decisión

[decisión adoptada]

### Motivo

[justificación]

### Consecuencias

- [consecuencia 1];
- [consecuencia 2].

### Alternativas descartadas

- [alternativa]: [motivo].

Añadir tantas decisiones como sea necesario.

No utilizar esta sección para redefinir la arquitectura global.

---

# Estructura de entregables

## Tutorial

Ruta:

```text
tutorial/NN-unit-name/README.md
```

Debe actuar como puerta de entrada de la unidad. Debe incluir:

1. problema real que resuelve la unidad;
2. por qué aparece en este punto del itinerario;
3. contexto;
4. objetivos;
5. conocimientos previos;
6. relación con la unidad anterior;
7. estado inicial;
8. mapa de aprendizaje;
9. conceptos cubiertos a nivel introductorio;
10. cómo usar `student-notes.md`;
11. cómo usar el README del laboratorio;
12. decisiones de diseño principales;
13. conclusión;
14. lectura guiada con referencias oficiales, conceptuales y complementarias;
15. conexión con la siguiente unidad.

Las referencias deberán priorizar documentación oficial, especificaciones, documentación de proyecto o fuentes primarias. Cuando se usen artículos, blogs o materiales secundarios, deberán complementar y no sustituir las fuentes primarias.

El tutorial no debe escribirse como una guía de laboratorio extendida. Los comandos repetitivos, secuencias completas de despliegue, recuperación operacional y validación mecánica pertenecen al README del laboratorio, salvo comandos puntuales que ayuden a observar o razonar sobre un concepto.

## Notas del alumno

Ruta:

```text
tutorial/NN-unit-name/student-notes.md
```

Debe ser la guía de aprendizaje de la unidad. Debe construir comprensión antes de pedir ejecución, separando primero qué representa cada componente y después cómo se usa en los artefactos reales de la unidad.

Debe incluir una estructura equivalente a:

1. propósito;
2. qué se va a cubrir;
3. qué representa cada componente;
4. qué se va a construir;
5. cómo se relacionan las piezas;
6. qué ocurre al aplicar los manifiestos, scripts o artefactos;
7. cómo comprobar que funciona;
8. cómo diagnosticar los fallos típicos;
9. qué debe recordarse para la unidad siguiente;
10. fuentes de referencia oficiales o primarias.

Para cada componente central, explicar de forma sintética:

- qué representa;
- qué problema resuelve;
- qué no es;
- cómo aparece o se observa en la unidad.

No debe convertirse en una enciclopedia ni exigir por defecto glosarios extensos, invariantes numerados, anexos largos o matrices densas. Esos recursos solo deben usarse si hacen más clara la progresión de aprendizaje.

No debe duplicar el README del laboratorio. Puede incluir comandos puntuales de observación, pero no secuencias operativas completas.

Las referencias deberán priorizar documentación oficial, especificaciones o fuentes primarias, indicando qué leer y para qué sirve dentro de la unidad.

## Referencia del alumno

Ruta:

```text
tutorial/NN-unit-name/student-reference.md
```

Crear este archivo siempre. Es un entregable obligatorio de la unidad y deberá seguir `playbooks/student-reference-template.md`.

### Frontera con las notas del alumno

`student-notes.md` explica y diagnostica lo que ocurre **dentro** del laboratorio. `student-reference.md` explica lo que existe **fuera** y corrige modelos mentales.

El diagnóstico de fallos del laboratorio pertenece siempre a las notas. Los errores de concepto pertenecen siempre a la referencia. Ningún contenido aparece en ambos documentos: si los dos lo necesitan, uno lo desarrolla y el otro lo cita por ruta.

La referencia no debe ser requisito previo del laboratorio. El alumno debe poder completar la unidad sin haberla leído.

Esta frontera gobierna el par `student-notes.md` / `student-reference.md`. El `README.md` de la unidad puede nombrar un error de razonamiento pero no lo desarrolla: remite a la referencia por ruta. `instructor-notes.md` queda exento, porque su lector y su función son distintos.

### Declaraciones obligatorias del playbook

Declarar:

- qué laguna de `project/content-gap-register.md` cubre, con su identificador, o que no cubre ninguna;
- de qué fuentes versionadas o instrucciones explícitas del usuario procede la lista de cobertura de entrada;
- qué sección de `project/coverage-map.md` se usó, cuando exista, y cómo se subordinó al roadmap y al estado consolidado;
- qué partes de `student-notes.md` amplía;
- qué tipos de cobertura aplica: panorama, profundidad, criterio o práctica;
- cómo se repartió la lista de cobertura de entrada entre práctica, criterio y diferido, y por qué; qué puntos redactados como práctica se reclasificaron a criterio o diferido por no caber en el alcance de la unidad;
- qué relación tiene con el tema de la unidad, el ecosistema Kubernetes o las herramientas habituales;
- qué contenido es conceptual o de referencia aunque no se ejecute en el laboratorio;
- qué simplificaciones del laboratorio serían incorrectas en producción y obligan a bloque de práctica profesional;
- qué queda fuera para unidades posteriores, con número de unidad, o declarado fuera del itinerario.

No usar `student-reference.md` como una segunda guía de laboratorio. Su función es aportar visión general, profundidad técnica y contexto profesional que ayuden a comprender el itinerario completo.

## Notas del instructor

Ruta:

```text
tutorial/NN-unit-name/instructor-notes.md
```

Debe incluir:

- intención pedagógica;
- puntos de énfasis;
- demostraciones;
- errores frecuentes;
- errores de razonamiento;
- preguntas de comprobación;
- criterios de evaluación;
- riesgos técnicos.

Las notas deben ayudar a impartir a alumnos que todavía están formando el modelo mental. Deben incluir intervenciones para reconducir confusiones conceptuales, no solo fallos de comando.

## Resumen

Ruta:

```text
tutorial/NN-unit-name/summary.md
```

Debe seguir:

```text
playbooks/summary-template.md
```

## Laboratorio

Ruta normal:

```text
labs/NN-unit-name/
```

Excepción de ruta, cuando corresponda:

```text
[ruta excepcional]
```

### Componentes de clúster

Declarar los componentes de clúster que esta unidad instala, si los hay:

- componente y versión fija;
- método de instalación oficial, con referencia a `platform/tools/`;
- namespace;
- si persiste hacia unidades posteriores o se retira al cerrar la unidad;
- procedimiento de limpieza completa, incluidos recursos derivados.

Si la unidad no instala ningún componente de clúster, declararlo explícitamente.

## Estado del proyecto

Actualizar:

```text
project/project-state.md
```

siguiendo:

```text
playbooks/project-state-template.md
```

---

# Estructura prevista del laboratorio

Definir la estructura esperada sin generar todavía los archivos.

```text
labs/NN-unit-name/
├── README.md
├── [directorio]
│   └── [archivo]
└── [archivo]
```

Para rutas excepcionales, sustituir `labs/NN-unit-name/` por la ruta aprobada.

## Responsabilidad de cada artefacto

| Ruta | Responsabilidad |
|---|---|
| `[ruta]` | [responsabilidad] |

---

# Flujo pedagógico obligatorio

La unidad deberá seguir este orden conceptual:

1. problema real;
2. por qué este problema aparece ahora;
3. modelo mental;
4. conceptos base;
5. decisiones de diseño;
6. observación o demostración breve;
7. implementación en laboratorio;
8. validación;
9. fallo o diagnóstico;
10. consolidación;
11. continuidad con la siguiente unidad.

Explicar por qué este orden es necesario.

El flujo debe evitar saltar de una definición a un comando sin explicar la necesidad que conecta ambos.

---

# Procedimientos obligatorios

La documentación deberá cubrir como mínimo:

## Preparación

- [procedimiento].

## Implementación

- [procedimiento].

## Validación

- [procedimiento].

## Diagnóstico

- [procedimiento].

## Recuperación

- [procedimiento].

## Limpieza

- [procedimiento o indicar por qué no aplica].

---

# Validaciones obligatorias

## Validaciones estáticas

| Validación | Herramienta o comando | Resultado esperado |
|---|---|---|
| [validación] | `[comando]` | [resultado] |

## Validaciones funcionales

| Validación | Procedimiento | Resultado esperado |
|---|---|---|
| [validación] | [procedimiento] | [resultado] |

## Validaciones de continuidad

Comprobar que:

- los artefactos anteriores siguen disponibles;
- la nueva capacidad no rompe la solución;
- las rutas documentadas existen;
- la siguiente unidad puede reutilizar el resultado.

## Validaciones no ejecutables en el entorno de generación

Declarar cualquier validación que deba ejecutar manualmente el usuario.

No afirmar que fue realizada.

---

# Escenarios de error obligatorios

La unidad deberá cubrir al menos los siguientes escenarios:

| Escenario | Síntoma | Diagnóstico | Recuperación |
|---|---|---|---|
| [error] | [síntoma] | [método] | [acción] |

Los escenarios deben corresponder a fallos realistas del laboratorio.

---

# Requisitos de seguridad

## Datos sensibles

Especificar:

- placeholders requeridos;
- variables de entorno;
- archivos ignorados;
- secretos de laboratorio;
- credenciales que nunca deben versionarse.

## Privilegios

Documentar:

- comandos que requieren elevación;
- permisos Kubernetes;
- roles cloud, cuando proceda;
- impacto de los privilegios.

## Operaciones destructivas

Enumerar:

- operación;
- advertencia;
- alcance;
- recuperación;
- confirmación requerida.

Escribir `Ninguna` si no aplica.

---

# Requisitos de portabilidad

Diferenciar expresamente:

## Kubernetes estándar

- [capacidad estándar].

## Específico de MicroK8s

- [capacidad específica].

## Específico de AKS

- [capacidad específica o no aplica].

## Específico de EKS

- [capacidad específica o no aplica].

## Estrategia de desacoplamiento

- [parametrización];
- [abstracción];
- [documentación];
- [migración futura].

---

# Restricciones de generación

La IA no debe:

- [restricción específica 1];
- [restricción específica 2];
- anticipar [capacidad futura];
- crear [artefacto alternativo];
- modificar [componente protegido].

La IA sí puede:

- [acción permitida 1];
- [acción permitida 2].

---

# Criterios de aceptación

La unidad se considerará completada cuando:

- [ ] exista `tutorial/NN-unit-name/README.md`;
- [ ] exista `tutorial/NN-unit-name/student-notes.md`;
- [ ] exista `tutorial/NN-unit-name/student-reference.md`;
- [ ] exista `tutorial/NN-unit-name/instructor-notes.md`;
- [ ] exista `tutorial/NN-unit-name/summary.md`;
- [ ] existan los artefactos ejecutables previstos;
- [ ] las rutas documentadas coincidan con el repositorio;
- [ ] las validaciones estén definidas;
- [ ] se hayan ejecutado las validaciones posibles;
- [ ] las validaciones no ejecutadas estén declaradas;
- [ ] no existan secretos reales;
- [ ] se reutilicen los artefactos anteriores;
- [ ] el tutorial incluya referencias oficiales o fuentes primarias relevantes;
- [ ] cada exclusión declarada en el alcance de `student-notes.md` esté cubierta, anclada con número de unidad o declarada fuera del itinerario en `student-reference.md`;
- [ ] ningún contenido esté duplicado entre `student-notes.md` y `student-reference.md`;
- [ ] el diagnóstico de fallos del laboratorio esté solo en `student-notes.md` y los errores de concepto solo en `student-reference.md`;
- [ ] la laguna asignada a la unidad, si existe, esté declarada en `student-reference.md` y su cierre registrado en `summary.md`;
- [ ] `project/project-state.md` esté actualizado;
- [ ] el resultado prepare la siguiente unidad;
- [ ] no existan contradicciones abiertas.

Añadir criterios específicos de la unidad:

- [ ] [criterio específico 1];
- [ ] [criterio específico 2].

---

# Estado final esperado

Describir el estado técnico que deberá existir al cerrar la unidad.

## Plataforma

- [estado].

## Aplicación

- [estado].

## Automatización

- [estado].

## Observabilidad

- [estado].

## Seguridad

- [estado].

## Artefactos principales

```text
[ruta]
[ruta]
```

Solo incluir categorías aplicables.

---

# Información obligatoria para el summary

El `summary.md` deberá destacar:

- capacidad incorporada;
- artefactos creados;
- artefactos modificados;
- comandos de validación principales;
- decisiones específicas;
- referencias principales utilizadas;
- dependencias nuevas;
- limitaciones;
- deuda técnica;
- elementos que debe reutilizar la siguiente unidad;
- estado final verificable.

---

# Impacto esperado en project-state

Al cerrar la unidad, actualizar como mínimo:

- fase actual;
- última unidad completada;
- unidad siguiente;
- artefactos existentes;
- componentes desplegados;
- herramientas disponibles;
- versiones activas;
- decisiones;
- riesgos;
- deuda técnica;
- siguiente incremento permitido.

No registrar componentes previstos como si estuvieran implementados.

---

# Conexión con la siguiente unidad

## Siguiente unidad prevista

```text
NN — Nombre
```

## Capacidades que deja preparadas

- [capacidad];
- [artefacto];
- [estado].

## Elementos que la siguiente unidad deberá reutilizar

| Elemento | Ruta o referencia | Motivo |
|---|---|---|
| [elemento] | `[ruta]` | [motivo] |

## Elementos que no deben modificarse todavía

- [elemento];
- [elemento].

---

# Riesgos específicos

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| [riesgo] | Baja/Media/Alta | Bajo/Medio/Alto | [mitigación] |

---

# Cuestiones abiertas

| Cuestión | Bloqueante | Momento de resolución |
|---|---|---|
| [cuestión] | Sí/No | [momento] |

Una cuestión bloqueante impide aprobar el playbook.

---

# Checklist de revisión del playbook

Antes de aprobar este documento:

- [ ] la unidad existe en `project/roadmap.md`;
- [ ] el identificador y las rutas son consistentes;
- [ ] el alcance no invade unidades posteriores;
- [ ] las dependencias son verificables;
- [ ] los artefactos previos están identificados;
- [ ] los entregables están definidos;
- [ ] el reparto de contenido entre notas y referencia respeta la frontera;
- [ ] las simplificaciones del laboratorio que obligan a práctica profesional están identificadas;
- [ ] las validaciones son suficientes;
- [ ] los escenarios de error son realistas;
- [ ] las restricciones de seguridad están declaradas;
- [ ] la portabilidad está considerada;
- [ ] los criterios de aceptación son objetivos;
- [ ] el estado final está claramente definido;
- [ ] la conexión con la siguiente unidad es explícita;
- [ ] no contradice arquitectura, estado, roadmap ni playbook maestro.

---

# Metadatos de mantenimiento

## Fecha de creación

```text
YYYY-MM-DD
```

## Última revisión

```text
YYYY-MM-DD
```

## Motivo de la última revisión

[descripción]

## Documentos afectados por cambios futuros

- `project/roadmap.md`;
- `project/project-state.md`;
- [otros].
