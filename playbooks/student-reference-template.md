# Plantilla de referencia del alumno

## Propósito

Esta plantilla define la estructura obligatoria y las obligaciones comprobables de:

```text
tutorial/NN-unit-name/student-reference.md
```

`student-reference.md` es la capa de referencia profesional de la unidad. Completa a `student-notes.md` con visión general, profundidad técnica, variantes, herramientas habituales y criterios de decisión que no deben saturar el flujo principal de aprendizaje ni el laboratorio.

No es una segunda guía de laboratorio. Puede incluir ejemplos breves de lectura, observación o razonamiento, pero las secuencias operativas completas pertenecen al README del laboratorio.

Las secciones 1 a 4 establecen obligaciones que sustituyen al criterio del generador. La sección 5 define la estructura canónica. Una referencia que respete la estructura pero incumpla las obligaciones no es conforme.

---

# 1. Frontera con `student-notes.md`

Es la regla que decide dónde va cada contenido, y precede a cualquier otra consideración de esta plantilla.

> `student-notes.md` explica y diagnostica lo que ocurre **dentro** del laboratorio. `student-reference.md` explica lo que existe **fuera** y corrige modelos mentales. El diagnóstico de fallos del laboratorio pertenece siempre a las notas; los errores de concepto, siempre a la referencia. Ningún contenido aparece en ambos: si ambos lo necesitan, uno lo desarrolla y el otro lo cita por ruta.

| Documento | Función | Prueba |
|---|---|---|
| `student-notes.md` | Explica y diagnostica lo que ocurre **dentro** del laboratorio | ¿Lo necesita para terminar la unidad? |
| `student-reference.md` | Explica lo que existe **fuera** del laboratorio y corrige modelos mentales | ¿Lo necesita para decidir bien más adelante? |

Consecuencias operativas:

- **El diagnóstico de fallos del laboratorio pertenece a las notas.** La referencia no repite tablas de síntoma, comando y recuperación. Si un fallo solo se produce ejecutando el laboratorio, es de las notas.
- **Los errores frecuentes pertenecen a la referencia**, y son de naturaleza distinta: creencias equivocadas, no fallos técnicos. «Pensar que todo debe ser un `Deployment`» es de la referencia; «el Pod queda `Pending`» es de las notas. La regla no admite excepciones, tampoco en unidades sin laboratorio de aplicación.
- **Ningún contenido aparece en los dos documentos.** Si ambos lo necesitan, uno lo desarrolla y el otro lo referencia por ruta.
- **La referencia nunca es requisito previo del laboratorio.** El alumno debe poder completar la unidad sin haberla leído.

## 1.1 Alcance de la regla de no duplicación

La regla gobierna el par `student-notes.md` / `student-reference.md`. Los otros dos entregables del alumno se rigen así:

| Documento | Tratamiento |
|---|---|
| `README.md` de la unidad | Puede nombrar un error de razonamiento como parte del mapa de aprendizaje, pero no lo desarrolla: remite a `student-reference.md` por ruta |
| `instructor-notes.md` | **Exento.** Su lector es otro y su función es la intervención en aula, no la referencia del alumno. Puede desarrollar los mismos errores con enfoque de facilitación |

---

# 2. Cuándo debe existir

Una unidad **debe** llevar `student-reference.md` cuando se cumple al menos una de estas condiciones:

- el laboratorio usa una opción entre varias y el criterio de elección importa;
- el mecanismo que el alumno acaba de usar tiene comportamientos internos que sorprenden en operación real;
- la unidad cubre una laguna registrada en `project/content-gap-register.md`;
- existe una distancia relevante entre lo que hace el laboratorio y lo que se hace en producción;
- la lista de exclusiones de alcance de `student-notes.md` contiene algún elemento con relevancia profesional.

En la práctica, la última condición se cumple casi siempre: toda unidad declara lo que no cubre. La ausencia de referencia es la excepción y debe justificarse en el playbook de la unidad, no al revés.

---

# 3. Garantía de cobertura

Obligaciones comprobables. No son recomendaciones y no dependen del criterio de quien genera la unidad.

## 3.1 Obligación derivada del alcance declarado

`student-notes.md` declara siempre qué queda fuera de la unidad, en su apartado de alcance.

**Cada elemento de esa lista genera deber.** La referencia debe resolverlo de una de estas tres formas, y solo de estas:

| Resolución | Significa | Dónde queda |
|---|---|---|
| Cubierto | Se explica aquí en su dimensión conceptual, sin practicarlo | Secciones 5.5 o 5.6 |
| Anclado | Se practicará en la unidad N, con número explícito | Sección 5.9 |
| Fuera del itinerario | El curso no lo tratará, y se dice así | Sección 5.7 |

Un elemento excluido que no aparezca en ninguna de las tres es un defecto de la unidad. La comprobación es mecánica: se cruza la lista de exclusiones de las notas contra la referencia.

Esta regla existe porque el alumno lee «no se cubre X» y necesita saber si eso significa «todavía no», «nunca» o «no hace falta». Sin respuesta, la exclusión se convierte en un hueco silencioso.

## 3.2 Obligación derivada de las simplificaciones del laboratorio

Un laboratorio local simplifica. Algunas simplificaciones son inocuas y otras serían mala práctica si alguien las trasladara a producción: un `Secret` con valores ficticios, `hostpath-storage` atado al nodo, un clúster de un solo nodo presentado como si demostrara disponibilidad, HTTP sin TLS.

**Cuando el laboratorio toma una decisión que sería incorrecta en producción, el bloque de práctica profesional deja de ser opcional.** La referencia debe declarar tres cosas:

1. qué hace el laboratorio;
2. por qué eso no es aceptable fuera del laboratorio, con la razón técnica y no solo con la advertencia;
3. qué se hace en su lugar, aunque no se implemente aquí.

El segundo punto es el que importa. «No uses secretos reales» es una regla que el alumno obedecerá sin entender; «los valores del release quedan almacenados en un Secret del namespace, legible por cualquiera con permiso de lectura y persistido en cada revisión del historial» es una razón que puede aplicar en otro contexto.

## 3.3 Cierre bidireccional con el registro de lagunas

Si `project/content-gap-register.md` asigna una laguna a esta unidad, la referencia debe declararlo en su propósito, con el identificador `GAP-NNN`, y cerrarla.

El cierre se registra de vuelta en `tutorial/NN-unit-name/summary.md`, como decisión de la unidad, citando el mismo identificador. Una laguna cerrada sin rastro en ambos documentos no está cerrada.

La relación es bidireccional porque la referencia es el instrumento habitual con el que el itinerario cubre lagunas sin añadir laboratorio, y una laguna que se cierra solo en un lado reaparece en la siguiente revisión de coherencia.

## 3.4 Prueba de suficiencia

Antes de dar la referencia por completa, se comprueba que el alumno puede responder, solo con las notas y la referencia:

- ¿por qué el laboratorio hizo esta elección y no otra?
- ¿qué hago distinto si esto fuera producción?
- ¿qué de lo que acabo de hacer es Kubernetes y qué es MicroK8s, Helm o una decisión de este curso?
- ¿qué he dejado fuera y cuándo lo veré?

Si alguna no tiene respuesta en los dos documentos, la referencia está incompleta. Estas cuatro preguntas son la formulación mínima; la sección 5.10 las concreta por unidad mediante la columna de preguntas de la tabla de fuentes.

---

# 4. Autosuficiencia

Las obligaciones anteriores solo se cumplen si el documento se sostiene solo. Enlazar la documentación oficial no es cubrir un contenido: es delegarlo en una lectura que nadie garantiza.

> Todo lo necesario para responder a la prueba de suficiencia debe estar escrito en `student-notes.md` o en `student-reference.md`. Las fuentes externas amplían; nunca completan.

Aplicada a la práctica, la referencia **sí** explica el mecanismo cuando el alumno lo necesita para razonar sobre lo que acaba de hacer, aunque ese mecanismo esté documentado oficialmente. Un alumno que no puede leer las plantillas de su propio chart, o interpretar el plan de su propio Terraform, sin abrir otra pestaña, tiene una referencia incompleta por mucho que la tabla de fuentes sea impecable.

Lo que no se hace es **transcribir catálogos**: listas completas de funciones, tablas exhaustivas de operadores, inventarios de flags. Eso envejece, es inabarcable y sí pertenece a la fuente primaria.

| Se escribe aquí | Se deja a la fuente |
|---|---|
| El modelo mental del mecanismo | La lista completa de funciones |
| Las construcciones que aparecen en los artefactos del laboratorio | Las que no aparecen |
| Lectura anotada de un artefacto real de la unidad | Ejemplos genéricos equivalentes |
| Los comportamientos que sorprenden y su causa | La referencia exhaustiva de la API |

El criterio no es si el contenido está documentado fuera —todo lo está—, sino si el alumno lo necesita para razonar sobre lo que acaba de hacer.

**Instrumento preferente: la lectura anotada.** Recorrer un fichero real del laboratorio explicando qué hace cada línea y por qué se decidió así. Enseña la sintaxis en contexto y, además, expone decisiones de diseño del curso que ninguna documentación externa contiene, porque no son del producto sino del itinerario.

## 4.1 Tipos de cobertura

La referencia se construye con cuatro tipos de contenido. **No son secciones obligatorias**: son una paleta. El propósito declara cuáles aplican.

| Tipo | Responde a | Límite de profundidad |
|---|---|---|
| Panorama | Dónde encaja esto y qué no resuelve | Hasta poder situar la herramienta frente a lo que no es |
| Profundidad | Qué hace por dentro y qué sorprende | Hasta poder leer los artefactos del propio laboratorio |
| Criterio | Qué alternativas existen y cómo se elige | Hasta poder justificar por qué se eligió esta |
| Práctica | Qué se hace en producción y por qué aquí no | Hasta poder nombrar la distancia con el laboratorio |

El límite es funcional, no proporcional. La prueba de la profundidad: si el alumno no puede leer un fichero del laboratorio sin abrir otra pestaña, la referencia se quedó corta; si transcribe el catálogo de funciones de la documentación oficial, se pasó.

---

# 5. Estructura canónica

Título más nueve secciones, en este orden.

## 5.1 Título

```markdown
# Referencia del alumno — Unidad NN: <tema>
```

El título identifica la unidad con número. Un título temático sin número impide referenciar el documento desde unidades posteriores, que es su uso principal.

## 5.2 Propósito de la referencia

Tres párrafos como máximo:

1. qué amplía, con la ruta exacta de `student-notes.md`;
2. qué tipos de cobertura aplica y por qué, según la sección 4.1; si la unidad tiene laguna asignada, se declara aquí con su identificador `GAP-NNN`;
3. **qué no hace**, en forma de lista de negaciones verificables: qué no instala, qué no crea, qué no modifica del estado técnico del clúster.

El tercer párrafo no es una fórmula de cortesía. Es lo que impide que la referencia se convierta en una segunda guía de laboratorio.

## 5.3 Relación con la unidad

Qué practica la unidad, en lista breve, y la tabla de artefactos que el alumno debe tener delante mientras lee:

```markdown
| Artefacto | Ruta | Qué observar |
|---|---|---|
```

Reglas de esta tabla:

- solo artefactos visibles para el alumno, que pueda abrir y leer;
- **`summary.md` no es material didáctico y no aparece nunca en esta tabla.** Es el contrato de continuidad entre unidades y sesiones, regido por `playbooks/summary-template.md`;
- rutas exactas y verificables;
- no repetir la tabla «Qué vas a construir» de las notas: aquí se listan ficheros, allí se listan valores.

## 5.4 Mapa conceptual

La cadena de responsabilidades de la unidad, en bloque de texto plano, seguida de las distinciones conceptuales que el alumno necesita y que las notas no introducen.

Esta sección es la que más justifica que exista el documento: no añade contenido, reorganiza lo que el alumno acaba de hacer. Debe ayudarle a distinguir conceptos principales, responsabilidades de cada componente, límites de cada abstracción y relación con Kubernetes estándar, con MicroK8s y con las herramientas habituales del ecosistema.

## 5.5 Conceptos y mecanismos

El cuerpo. Un subapartado por concepto, en el orden en que aparecen en la cadena del mapa conceptual.

Reglas:

- cada subapartado dice qué resuelve el mecanismo **y qué no resuelve**;
- se puede citar YAML o HCL del laboratorio para anotarlo, nunca para proponer cambios;
- se explica el mecanismo hasta donde el alumno lo necesite para razonar sobre los artefactos de la unidad, aunque esté documentado oficialmente; lo que no se hace es transcribir catálogos, según la sección 4;
- las anotaciones sobre decisiones de diseño de los artefactos del laboratorio son contenido de máximo valor, porque no existen en ninguna fuente externa.

## 5.6 Criterios de decisión

Subapartados con forma «Cuándo usar X» o «Cómo evaluar Y».

Cada criterio debe poder responderse sin ejecutar nada, y debe incluir la justificación de la elección concreta del laboratorio cuando difiera de la recomendación profesional. Los trade-offs que suelen importar: simplicidad, seguridad, coste, portabilidad, mantenibilidad y operación.

## 5.7 Relación con el laboratorio

Dos listas explícitas y una restricción:

```markdown
El laboratorio practica:
- ...

El laboratorio menciona, pero no practica:
- ...
```

Seguidas de la restricción de la unidad: qué no debe modificarse del laboratorio y por qué.

**Regla de cierre**: todo elemento de la segunda lista debe aparecer en la sección de continuidad con número de unidad, o declararse explícitamente fuera del itinerario. Un elemento que se menciona como no practicado y nunca se retoma deja al alumno sin saber si lo verá.

## 5.8 Errores frecuentes

Tabla de dos columnas:

```markdown
| Error | Por qué importa |
|---|---|
```

Son errores de modelo mental, no fallos de laboratorio, según la frontera de la sección 1. Entre seis y diez filas. Cada fila debe ser un error que alguien comete de verdad, no un despiste.

## 5.9 Continuidad

Un párrafo corto por unidad futura que retoma algo de esta, en orden numérico, empezando siempre por el número de unidad.

Cada párrafo es un compromiso: la unidad citada debe cumplirlo. Los compromisos declarados aquí son anclajes verificables y se comprueban al generar la unidad destino.

## 5.10 Fuentes de referencia

Tabla de tres columnas:

```markdown
| Fuente | Qué leer | Pregunta que deberías poder responder |
|---|---|---|
```

Reglas:

- enlace real en la primera columna;
- la tercera columna convierte el enlace en comprobación, y es obligatoria;
- **las fuentes amplían, no completan.** El documento debe sostenerse sin ellas. Si retirar la tabla dejara sin respuesta alguna pregunta de la prueba de suficiencia, falta contenido en la sección 5.5;
- **no repetir fuentes ya enlazadas desde `student-notes.md`**, salvo que se apunte a una sección distinta, y en ese caso se indica cuál;
- fuentes primarias: documentación oficial del proyecto, no agregadores.

---

# 6. Reglas de redacción

| Regla | Detalle |
|---|---|
| Ortografía | Español con ortografía completa, tildes incluidas, en toda la prosa. Regla general en `playbooks/master.md` |
| Código | Comandos, rutas, identificadores y nombres de recursos, sin alterar |
| No anticipación | Ninguna implementación de una unidad posterior. La frontera de responsabilidad sí; el código, no |
| Sin segunda guía | Ningún paso ejecutable nuevo. Los comandos que aparecen son de lectura o inspección |
| Trazabilidad | Toda referencia a otra unidad lleva número |
| Extensión | Orientativa: entre 200 y 400 líneas. Por encima, revisar si hay contenido que pertenece a la fuente primaria |

---

# 7. Criterios de cierre

Una referencia se considera completa cuando:

- [ ] cada exclusión declarada en el alcance de `student-notes.md` está cubierta, anclada con número o declarada fuera del itinerario;
- [ ] toda simplificación del laboratorio que sería incorrecta en producción está nombrada, razonada técnicamente y acompañada de la alternativa real;
- [ ] las lagunas asignadas a la unidad están declaradas con su identificador y su cierre está registrado en `summary.md`;
- [ ] las cuatro preguntas de la prueba de suficiencia tienen respuesta;
- [ ] el documento se sostiene sin las fuentes externas: ningún enlace es carga estructural;
- [ ] el título identifica la unidad con número;
- [ ] el propósito declara los tipos de cobertura que aplica;
- [ ] el propósito incluye la lista de negaciones verificables;
- [ ] las nueve secciones están presentes en orden;
- [ ] ninguna ruta de la tabla de artefactos es incorrecta y `summary.md` no aparece en ella;
- [ ] no hay contenido duplicado con `student-notes.md`;
- [ ] el diagnóstico de fallos del laboratorio **no** está aquí;
- [ ] los errores frecuentes están aquí y no en las notas;
- [ ] todo elemento de «menciona pero no practica» tiene destino en continuidad o se declara fuera del itinerario;
- [ ] las fuentes no repiten las de las notas y todas llevan pregunta;
- [ ] la prosa lleva tildes;
- [ ] no hay implementación de unidades posteriores.
