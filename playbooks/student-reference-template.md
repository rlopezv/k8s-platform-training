# Plantilla de referencia del alumno

## Propósito

Esta plantilla define la estructura obligatoria de:

```text
tutorial/NN-unit-name/student-reference.md
```

`student-reference.md` es la capa de referencia profesional de la unidad. Completa a `student-notes.md` con visión general, profundidad técnica, variantes, herramientas habituales y criterios de decisión que no deben saturar el flujo principal de aprendizaje ni el laboratorio.

No es una segunda guía de laboratorio. Puede incluir ejemplos breves de lectura, observación o razonamiento, pero las secuencias operativas completas pertenecen al README del laboratorio.

---

# Título

```text
# Referencia del alumno - Unidad NN
```

El título debe identificar la unidad y el tema de referencia.

---

# Propósito de la referencia

Explicar:

- qué amplía respecto a `student-notes.md`;
- por qué esta profundidad no pertenece al flujo principal del tutorial;
- cómo ayuda a entender el laboratorio actual o unidades posteriores;
- qué partes son conceptuales, qué partes son práctica habitual y qué partes se ejecutan realmente en el curso.

---

# Relación con la unidad

Incluir:

- qué conceptos de la unidad sirve para profundizar;
- qué artefactos reales del laboratorio ayudan a leer la referencia;
- qué decisiones del curso condiciona;
- qué continuidad prepara.

Cuando la referencia trate contenido que no se ejecuta todavía, indicarlo de forma explícita.

---

# Mapa conceptual

Presentar el mapa general del tema antes de entrar en detalles.

Debe ayudar al alumno a distinguir:

- conceptos principales;
- responsabilidades de cada componente;
- límites de cada abstracción;
- relación con Kubernetes estándar;
- relación con herramientas habituales del ecosistema;
- relación con MicroK8s, cloud u otras plataformas cuando aplique.

---

# Conceptos y mecanismos

Desarrollar las piezas importantes con profundidad de referencia.

Para cada concepto central, cubrir cuando aplique:

- qué problema resuelve;
- cómo funciona;
- qué API, campo, recurso o herramienta lo representa;
- qué variantes existen;
- qué límites tiene;
- qué errores de interpretación conviene evitar;
- cómo se relaciona con otras unidades.

---

# Criterios de decisión

Incluir criterios profesionales para elegir entre alternativas.

Ejemplos:

- cuándo usar una API frente a otra;
- cuándo diferir una herramienta;
- qué opción es adecuada para laboratorio local;
- qué cambiaría en cloud;
- qué trade-offs existen entre simplicidad, seguridad, coste, portabilidad, mantenibilidad y operación.

---

# Relación con el laboratorio

Explicar cómo se conecta la referencia con los artefactos reales de la unidad.

Debe quedar claro:

- qué se observa o practica en el laboratorio;
- qué se menciona solo como referencia;
- qué se aplaza a unidades posteriores;
- qué no debe modificarse en esta unidad.

---

# Errores frecuentes

Incluir errores conceptuales o profesionales que la referencia ayuda a prevenir.

Ejemplos:

- confundir una API con una implementación concreta;
- asumir que una práctica local equivale a producción;
- convertir una herramienta en solución universal;
- interpretar un síntoma operativo como causa raíz sin revisar el contexto.

---

# Continuidad

Indicar cómo se retomará el tema en unidades posteriores.

Usar rutas o números de unidad cuando existan decisiones registradas.

---

# Fuentes de referencia

Priorizar fuentes oficiales, especificaciones, documentación de proyectos y fuentes primarias.

Para cada fuente, indicar:

- qué leer;
- por qué importa;
- qué pregunta debería poder responder el alumno después de leerla.

No incluir listas genéricas de enlaces sin guía de lectura.
