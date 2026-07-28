# Playbook maestro

## Propósito

Este documento define las reglas globales y obligatorias para generar, modificar, revisar y cerrar cualquier unidad del itinerario de formación Kubernetes.

Su objetivo es garantizar que todas las sesiones de trabajo:

- utilicen el repositorio como fuente única de verdad;
- mantengan continuidad entre unidades;
- reutilicen los artefactos existentes;
- produzcan incrementos coherentes y revisables;
- actualicen el estado consolidado;
- eviten dependencias implícitas del historial de conversación.

Este playbook prevalece sobre cualquier instrucción específica de unidad cuando exista una contradicción, salvo que la arquitectura del proyecto haya sido actualizada previamente para autorizar la excepción.

---

# Alcance

Este playbook se aplica a:

- generación de nuevas unidades;
- ampliación de unidades existentes;
- corrección de contenido;
- refactorización de laboratorios;
- actualización de notas del instructor;
- revisión de resúmenes;
- actualización de `project/project-state.md`;
- cambios que afecten a la continuidad del itinerario.

No se utiliza para modificar la arquitectura global o el roadmap sin una decisión explícita previa.

---

# Fuentes de verdad

Antes de comenzar cualquier trabajo sobre una unidad, la IA deberá leer obligatoriamente:

1. `playbooks/master.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `playbooks/student-reference-template.md`;
6. el `summary.md` de la unidad anterior;
7. el playbook específico de la unidad;
8. los artefactos existentes que la unidad deba reutilizar.

Para la Unidad 0 no existirá un `summary.md` anterior. Esta excepción deberá estar declarada en su playbook específico.

Cuando se modifique una unidad ya existente, también deberán leerse:

- su documentación actual;
- sus notas del instructor;
- su resumen;
- sus artefactos ejecutables;
- las unidades posteriores que dependan directamente de ella, cuando el cambio pueda afectarlas.

---

# Precedencia documental

En caso de discrepancia, se aplicará el siguiente orden de precedencia:

1. `project/architecture.md`;
2. `playbooks/master.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. playbook específico de la unidad;
6. `summary.md` de la unidad anterior;
7. documentación y laboratorios existentes;
8. contexto de conversación.

La IA no deberá resolver silenciosamente una contradicción.

Cuando una discrepancia afecte al resultado, deberá:

1. identificarla;
2. explicar su impacto;
3. aplicar la fuente de mayor precedencia;
4. proponer o realizar la actualización documental necesaria;
5. registrar el resultado en `project/project-state.md` cuando corresponda.

---

# Principio de incremento mínimo coherente

Cada sesión deberá producir el menor incremento que:

- cumpla completamente el objetivo acordado;
- preserve la coherencia del repositorio;
- pueda revisarse de forma independiente;
- pueda corresponderse con un commit Git;
- no introduzca trabajo no solicitado;
- no anticipe contenido de unidades posteriores.

No se deben generar múltiples unidades en un único incremento salvo que el usuario lo solicite expresamente y las dependencias lo permitan.

---

# Principio de reutilización obligatoria

La IA deberá asumir que todos los artefactos existentes son reutilizables hasta que se demuestre lo contrario.

Antes de crear un nuevo recurso deberá comprobar si ya existe:

- una aplicación;
- un namespace;
- un manifiesto;
- un chart;
- un módulo Terraform;
- un script;
- una pipeline;
- una configuración de observabilidad;
- una política;
- una convención de nombres;
- una validación equivalente.

No se permite crear una aplicación distinta por conveniencia pedagógica.

Cuando sea necesario sustituir un artefacto, la unidad deberá documentar:

- el artefacto sustituido;
- la razón;
- el mecanismo de migración;
- el impacto;
- la compatibilidad con las unidades anteriores;
- el nuevo estado consolidado.

---

# Proceso obligatorio de generación

## Paso 1 — Identificar el objetivo exacto

La IA deberá determinar:

- unidad afectada;
- tipo de cambio;
- artefactos que deben generarse o modificarse;
- restricciones;
- dependencias;
- criterio de finalización.

Si el trabajo corresponde al bootstrap, deberá respetar el orden registrado en `project/project-state.md`.

## Paso 2 — Cargar el contexto

La IA deberá leer todas las fuentes obligatorias y extraer:

- estado actual;
- decisiones activas;
- herramientas disponibles;
- artefactos reutilizables;
- limitaciones;
- siguiente capacidad prevista;
- deuda técnica relevante.

## Paso 3 — Validar precondiciones

Antes de generar contenido deberá comprobar:

- que la unidad anterior está cerrada;
- que existe su `summary.md`, salvo Unidad 0;
- que el playbook específico existe;
- que las dependencias técnicas están registradas como disponibles;
- que no existen contradicciones bloqueantes;
- que la unidad está prevista en el roadmap;
- que el repositorio se encuentra en una fase compatible.

Si una precondición no se cumple, la IA no deberá inventar el estado faltante.

Deberá limitar el incremento a corregir la precondición o documentar el bloqueo.

## Paso 4 — Diseñar el incremento

La IA deberá definir:

- artefactos que se reutilizan;
- artefactos nuevos;
- cambios sobre artefactos existentes;
- flujo pedagógico;
- validaciones;
- impacto sobre el estado;
- información necesaria para la siguiente unidad.

## Paso 4bis — Clasificar la cobertura

Cuando la unidad parta de una lista de cobertura, la IA deberá clasificar cada punto antes de generar.

La lista de cobertura de entrada solo puede construirse a partir de:

- el alcance y las capacidades previstas en `project/roadmap.md`;
- el estado, restricciones, decisiones, lagunas y siguiente incremento permitido en `project/project-state.md`;
- la continuidad declarada en el `summary.md` de la unidad anterior;
- `project/content-gap-register.md`, cuando asigne una laguna o continuidad a la unidad;
- `project/advanced-labs-register.md`, cuando exista un candidato relacionado;
- instrucciones explícitas del usuario para la sesión, siempre que queden incorporadas al playbook o al estado si condicionan el resultado.

Los documentos privados o auxiliares, como `.work/detail.md`, pueden usarse como checklist de trabajo, pero no son fuente de verdad. Si un punto de un documento auxiliar condiciona la unidad, deberá trazarse hacia una de las fuentes anteriores o declararse como entrada explícita del usuario antes de entrar en el playbook.

Cada punto se clasifica como:

- **práctica**: se ejecuta en el laboratorio de esta unidad. Va al alcance incluido y a los procedimientos.
- **criterio**: se explica en `student-reference.md` pero no se ejecuta. Va a las declaraciones de cobertura de la referencia.
- **diferido**: pertenece a una unidad posterior, a un laboratorio avanzado o queda fuera del itinerario. Va a la tabla de diferidos y, si es candidato a laboratorio avanzado, a `project/advanced-labs-register.md`.

La regla de reparto la fija el alcance declarado de la unidad. Una unidad introductoria practica lo mínimo que da visión general del tema y difiere lo avanzado; una unidad de profundización puede practicar más.

Un punto redactado como práctica que el laboratorio no puede sostener, porque exige un entorno que la unidad no tiene o contradice una restricción activa, no se convierte en artefacto. Se reclasifica como criterio o diferido y se declara por qué. La IA no debe ampliar el alcance para acomodar la lista; es la lista la que se reparte contra el alcance.

El resultado de esta clasificación se declara en el playbook de la unidad, en las declaraciones obligatorias de la referencia.

## Paso 5 — Generar los entregables

Cada unidad deberá generar obligatoriamente:

```text
tutorial/<unidad>/README.md
tutorial/<unidad>/student-notes.md
tutorial/<unidad>/student-reference.md
tutorial/<unidad>/instructor-notes.md
tutorial/<unidad>/summary.md
```

Y sus artefactos ejecutables en:

```text
labs/<unidad>/
```

Excepción:

```text
platform/environment/
```

para los artefactos ejecutables de la Unidad 0.

La unidad deberá actualizar además:

```text
project/project-state.md
```

## Paso 6 — Validar la coherencia

La IA deberá revisar:

- alineación entre tutorial y laboratorio;
- reutilización efectiva de artefactos;
- coherencia de nombres y rutas;
- correspondencia entre comandos y ficheros;
- existencia de resultados esperados;
- ausencia de pasos implícitos;
- ausencia de secretos reales;
- compatibilidad con el estado registrado;
- continuidad con la siguiente unidad.

Esta revisión no equivale a aprobación del contenido formativo. La IA puede declarar validaciones técnicas ejecutadas y coherencia revisada, pero la validación pedagógica y la aprobación final del contenido generado corresponden al usuario responsable del curso.

Cuando el usuario no haya revisado el contenido, el `summary.md` y `project/project-state.md` deberán distinguir entre:

- contenido generado;
- validación técnica o funcional ejecutada;
- revisión pedagógica del usuario pendiente;
- contenido aprobado por el usuario.

## Paso 7 — Cerrar el incremento

La respuesta final deberá indicar:

- archivos creados o modificados;
- propósito del incremento;
- validaciones realizadas o pendientes;
- riesgos o limitaciones;
- estado de revisión o aprobación por parte del usuario;
- commit propuesto.

No deberá afirmar que una validación fue ejecutada si únicamente fue documentada o revisada estáticamente.

---

# Entregables obligatorios por unidad

## Tutorial del alumno

Ruta:

```text
tutorial/<unidad>/README.md
```

Debe actuar como puerta de entrada de la unidad. Debe incluir como mínimo:

- contexto;
- objetivos;
- conocimientos previos;
- relación con la unidad anterior;
- arquitectura o estado inicial;
- mapa de aprendizaje;
- conceptos cubiertos a nivel introductorio;
- referencia clara a `student-notes.md` como guía de aprendizaje de la unidad;
- referencia clara al README del laboratorio para los pasos operativos;
- conclusión;
- conexión con la siguiente unidad.

No debe convertirse en una guía de laboratorio extendida ni en el lugar principal para desarrollar todos los conceptos desde cero. Los comandos repetitivos, secuencias completas de despliegue, recuperación operacional y validación mecánica pertenecen al README del laboratorio.

## Notas del alumno

Ruta:

```text
tutorial/<unidad>/student-notes.md
```

Debe ser la guía de aprendizaje de la unidad. Su responsabilidad es construir comprensión antes del laboratorio, explicar qué representa cada componente y conectar esa comprensión con los artefactos reales.

No se debe asumir que un alumno sabe qué es un Pod, Deployment, Service, ConfigMap, Secret, Ingress, volumen o cualquier otro concepto solo porque el laboratorio lo usa.

Debe seguir una progresión clara, equivalente a:

- propósito de las notas;
- qué se va a cubrir;
- qué representa cada componente desde un punto de vista académico;
- qué se va a construir en la unidad;
- cómo se relacionan las piezas;
- qué ocurre al aplicar los manifiestos, scripts o artefactos;
- cómo comprobar que funciona;
- cómo diagnosticar los fallos típicos de la unidad;
- qué debe recordarse para la unidad siguiente;
- fuentes de referencia oficiales o primarias.

Debe diferenciar claramente:

- explicación conceptual;
- aplicación concreta en el laboratorio;
- ejemplos mínimos de observación o comprobación;
- límites y trade-offs;
- notas específicas de plataforma.

No debe convertirse en una enciclopedia, catálogo de invariantes, glosario extenso o colección de anexos. Si se usan tablas o matrices, deben servir a una progresión didáctica clara y no sustituirla.

Las instrucciones ejecutables completas pertenecen al README del laboratorio. `student-notes.md` puede incluir comandos puntuales solo cuando ayuden a observar o razonar sobre un concepto.

## Referencia del alumno

Ruta:

```text
tutorial/<unidad>/student-reference.md
```

Es un entregable obligatorio de cada unidad. Deberá seguir `playbooks/student-reference-template.md`, que define su estructura canónica y sus obligaciones comprobables.

Se utilizará para ofrecer visión general, profundidad técnica o contexto de herramientas habituales que no encajan en el flujo principal de `student-notes.md`.

### Frontera entre notas y referencia

`student-notes.md` explica y diagnostica lo que ocurre **dentro** del laboratorio. `student-reference.md` explica lo que existe **fuera** y corrige modelos mentales.

De esa frontera se derivan cuatro reglas de obligado cumplimiento:

- el diagnóstico de fallos del laboratorio pertenece siempre a `student-notes.md`;
- los errores de concepto pertenecen siempre a `student-reference.md`, sin excepciones, tampoco en unidades sin laboratorio de aplicación;
- ningún contenido aparece en ambos documentos: si los dos lo necesitan, uno lo desarrolla y el otro lo cita por ruta;
- `student-reference.md` no puede ser requisito previo del laboratorio.

La regla de no duplicación gobierna ese par. El `README.md` de la unidad puede nombrar un error de razonamiento, pero lo remite a la referencia por ruta en lugar de desarrollarlo. `instructor-notes.md` queda exento: su lector y su función son distintos.

### Obligaciones de cobertura

`student-reference.md` deberá:

- completar, no sustituir, a `student-notes.md`;
- profundizar en conceptos, mecanismos, APIs, herramientas, decisiones, límites y variantes;
- resolver cada elemento excluido en el alcance de `student-notes.md` como cubierto, anclado con número de unidad o declarado fuera del itinerario;
- nombrar toda simplificación del laboratorio que sería incorrecta en producción, con la razón técnica y la alternativa real;
- declarar y cerrar la laguna de `project/content-gap-register.md` asignada a la unidad, si existe, dejando rastro del cierre en `summary.md`;
- sostenerse sin las fuentes externas: las fuentes amplían, nunca completan;
- incluir contenido relevante aunque no se implemente en el laboratorio, dejando claro qué es conceptual, qué es práctica habitual y qué se ejecuta en el curso;
- enlazarse desde `README.md` y `student-notes.md`;
- mantener relación clara con el tema de la unidad y con la visión global del itinerario.

El tutorial y `student-notes.md` proporcionan la base necesaria para seguir la unidad. `student-reference.md` puede ampliar hacia la visión general de Kubernetes, herramientas habituales y prácticas profesionales aunque esa amplitud no se materialice todavía en artefactos ejecutables.

## Laboratorio

Ruta normal:

```text
labs/<unidad>/
```

Debe incluir:

- artefactos versionados;
- instrucciones mínimas de ejecución;
- parámetros;
- validaciones;
- mecanismos de repetición;
- recuperación ante errores;
- referencias explícitas a artefactos previos reutilizados.

Los ejemplos no deberán depender de acciones manuales no documentadas.

## Notas del instructor

Ruta:

```text
tutorial/<unidad>/instructor-notes.md
```

Debe incluir:

- intención pedagógica;
- puntos de énfasis;
- errores frecuentes;
- demostraciones recomendadas;
- alternativas;
- tiempos orientativos solo cuando se definan expresamente;
- criterios para evaluar el laboratorio;
- preguntas de comprobación;
- riesgos técnicos de la sesión.

No debe duplicar íntegramente el tutorial.

## Resumen de continuidad

Ruta:

```text
tutorial/<unidad>/summary.md
```

Debe seguir `playbooks/summary-template.md`.

Debe permitir que la siguiente sesión determine:

- qué se construyó;
- qué cambió;
- qué artefactos existen;
- qué decisiones se tomaron;
- qué validaciones se realizaron;
- qué limitaciones permanecen;
- qué debe reutilizar la siguiente unidad.

## Estado del proyecto

Ruta:

```text
project/project-state.md
```

Debe actualizarse siguiendo `playbooks/project-state-template.md`.

El estado deberá reflejar únicamente hechos verificables.

---

# Reglas pedagógicas

## Reglas de redacción

La prosa formativa deberá escribirse en español con ortografía completa: tildes, signos de apertura cuando correspondan, puntuación cuidada y frases comprensibles.

Es prosa formativa la de todos los entregables documentales de una unidad, sin excepción:

```text
tutorial/<unidad>/README.md
tutorial/<unidad>/student-notes.md
tutorial/<unidad>/student-reference.md
tutorial/<unidad>/instructor-notes.md
tutorial/<unidad>/summary.md
labs/<unidad>/README.md
```

La regla alcanza también a la prosa de los documentos de gobierno y de los playbooks.

Los nombres de código, comandos, rutas, APIs, recursos Kubernetes, campos de manifiestos, identificadores, nombres de herramientas y valores literales deberán conservarse tal cual aparezcan en su contexto técnico. No deberán traducirse, castellanizarse ni corregirse ortográficamente si eso cambia el identificador real.

## Orientación profesional

El público objetivo son ingenieros de plataforma.

La formación deberá priorizar:

- comprensión operativa;
- decisiones de arquitectura;
- automatización;
- diagnóstico;
- reproducibilidad;
- seguridad;
- mantenimiento;
- portabilidad;
- relación entre herramientas.

El público objetivo no debe tratarse como si ya conociera el tema de la unidad. Puede tener perfil técnico, pero cada unidad debe construir el modelo mental desde el problema real, introducir vocabulario de forma progresiva y explicar por qué cada abstracción existe antes de pedir que se use.

Un tutorial no se considera suficientemente pedagógico si solo:

- enumera recursos o comandos;
- explica el laboratorio ya construido;
- presupone conocimiento previo no declarado;
- presenta APIs sin contexto operativo;
- remite a referencias externas para cubrir la base conceptual que debería explicar la unidad.

Cuando el tema sea especializado, la unidad deberá dedicar más espacio a intuición, límites, comparaciones y criterios de decisión que a una secuencia mecánica de ejecución.

## Explicación antes de abstracción

Las abstracciones deberán introducirse después de mostrar el problema que resuelven.

Ejemplo:

- manifiestos antes de Helm;
- despliegue manual controlado antes de GitOps;
- métricas antes de alertas;
- operación local antes de plataformas gestionadas.

## Evitar ejemplos desechables

Los ejercicios deberán modificar la solución evolutiva.

Los ejemplos aislados solo se permiten para:

- explicar una sintaxis muy concreta;
- demostrar un fallo controlado;
- comparar comportamientos;
- validar una hipótesis.

Deberán estar claramente identificados como temporales y no formar parte del estado final.

## Validación visible

Cada sección práctica deberá incluir una forma de comprobar el resultado.

Las validaciones podrán ser:

- comandos;
- consultas;
- pruebas HTTP;
- inspección de recursos;
- logs;
- métricas;
- pruebas automatizadas;
- comparación de estado.

## Separación entre tutorial y laboratorio

El tutorial del alumno debe ser el material formativo principal. Debe explicar:

- el problema real que resuelve la unidad;
- por qué aparece en ese punto del itinerario;
- el modelo mental necesario antes del laboratorio;
- conceptos con profundidad progresiva;
- decisiones de diseño y trade-offs;
- errores de razonamiento frecuentes, nombrados aquí y desarrollados en `student-reference.md`;
- conexión con el mundo real;
- lectura guiada con preguntas concretas.

El laboratorio debe ser la guía operativa. Debe concentrar:

- comandos;
- despliegue;
- validación;
- diagnóstico;
- recuperación;
- comportamiento al repetir operaciones.

No se debe resolver la falta de explicación del tutorial aumentando comandos en el laboratorio. Si un concepto es necesario para entender una práctica, debe aparecer en el tutorial antes de la ejecución.

## Lectura guiada

Las referencias no deben ser una lista genérica al final de la unidad.

Cada tutorial deberá distinguir, cuando aplique:

- referencias oficiales o fuentes primarias;
- referencias conceptuales;
- lecturas complementarias.

Para cada referencia relevante deberá indicarse:

- qué leer;
- por qué importa para la unidad;
- qué pregunta debería poder responder el alumno después de leerla.

## Lagunas de contenido

Cuando durante una revisión aparezca una capacidad importante que no encaje en la unidad actual, no se debe resolver ampliando sin control el README.

La laguna deberá registrarse de forma breve en:

```text
project/content-gap-register.md
```

El registro debe indicar:

- laguna;
- impacto formativo;
- unidad o bloque donde encajaría;
- decisión pendiente.

---

# Reglas técnicas

## Comandos

Todos los comandos deberán indicar o hacer evidente:

- directorio de ejecución;
- shell esperado;
- permisos requeridos;
- variables necesarias;
- efecto esperado;
- validación posterior.

No se utilizarán comandos destructivos sin advertencia y procedimiento de recuperación.

## Idempotencia

Los scripts deberán ser idempotentes siempre que sea razonable.

Cuando no lo sean, deberán documentar:

- precondición;
- efecto;
- comportamiento al repetir;
- recuperación.

## Versiones

Cuando una unidad dependa de una versión concreta, deberá registrar:

- componente;
- versión o rango;
- motivo;
- compatibilidad;
- procedimiento de comprobación.

Las versiones activas deberán reflejarse en `project/project-state.md`.

## Componentes de clúster

Un componente de clúster es una herramienta que se despliega dentro de Kubernetes como controlador, CRD u operador, frente a un CLI local que se instala en el sistema de ficheros. Tekton, Argo CD, Prometheus, Grafana, KEDA y Velero son componentes de clúster; Helm, Terraform y `kubectl` son CLIs locales.

Los CLIs locales viven en `platform/environment/tools/` y se instalan en la Unidad 00. Los componentes de clúster se catalogan en `platform/tools/` y se instalan en la unidad cuyo tema es ese componente, nunca antes.

Cada componente de clúster que una unidad instale deberá:

- instalarse por su método oficial upstream, como `kubectl apply` de un release versionado, chart de Helm con versión fija o CLI propio, nunca con `latest`;
- fijar la versión, verificada contra la documentación oficial en el momento de generar la unidad, y registrarla según la regla de versiones;
- declararse en el README del laboratorio de la unidad como precondición de entorno, indicando método, versión, namespace, si persiste hacia unidades posteriores o se retira al cerrar, y la limpieza completa;
- documentar la limpieza incluyendo los recursos que el componente genera después de instalarse, que un borrado del manifiesto de instalación no retira.

El instalador o comando es una utilidad compartida catalogada en `platform/tools/`. La decisión de instalarlo, cuándo y con qué ciclo de vida pertenece al playbook y al README de la unidad, no al catálogo.

## Seguridad

Está prohibido versionar:

- contraseñas;
- tokens;
- claves privadas;
- kubeconfigs reales;
- credenciales cloud;
- secretos corporativos;
- endpoints internos sensibles.

Se utilizarán:

- placeholders;
- ficheros ignorados por Git;
- variables de entorno;
- gestores de secretos;
- mecanismos de identidad;
- secretos de laboratorio no reutilizables.

## Portabilidad

Los artefactos deberán separar:

- Kubernetes estándar;
- configuración específica de MicroK8s;
- configuración específica de AKS;
- configuración específica de EKS.

Los acoplamientos deberán documentarse.

## Destrucción y costes

Cualquier unidad que cree recursos cloud deberá incluir:

- estimación cualitativa de coste;
- comandos o procedimiento de destrucción;
- recursos que pueden permanecer;
- comprobación final;
- advertencias sobre servicios con coste residual.

Cualquier unidad que instale un componente de clúster, aunque no sea cloud, deberá documentar su retirada completa: el comando de desinstalación, los recursos derivados que no se retiran automáticamente, la comprobación final de que no quedan huérfanos y el efecto sobre componentes ya presentes en el clúster.

---

# Reglas de estructura

## Nombres de unidades

Formato:

```text
NN-nombre-en-kebab-case
```

Ejemplos:

```text
00-environment
01-kubernetes-foundations
06-helm-packaging
```

## Nombres de archivos

Se utilizarán nombres estables y descriptivos.

Se evitarán:

- `final.md`;
- `new.md`;
- `copy.md`;
- sufijos arbitrarios;
- versiones manuales como `v2`, salvo necesidad documentada.

## Rutas

Las rutas incluidas en documentación deberán coincidir exactamente con el repositorio.

La IA deberá evitar referencias ambiguas como:

- “el archivo anterior”;
- “la carpeta correspondiente”;
- “el manifiesto creado antes”.

Se utilizarán rutas explícitas.

---

# Gestión de inconsistencias

## Inconsistencia documental

Ejemplo:

El roadmap declara Helm disponible, pero el estado no lo registra.

Acción:

- prevalece el estado real;
- la unidad no debe asumir Helm;
- se documenta la discrepancia;
- se corrige el documento adecuado antes de continuar.

## Inconsistencia técnica

Ejemplo:

El tutorial referencia un manifiesto que no existe.

Acción:

- se corrige el tutorial o se crea el artefacto dentro del mismo incremento;
- no se cierra la unidad con referencias rotas.

## Inconsistencia arquitectónica

Ejemplo:

Una unidad requiere cambiar la estructura global.

Acción:

1. detener la generación de la unidad;
2. actualizar `project/architecture.md`;
3. revisar roadmap y estado;
4. continuar en un incremento posterior.

---

# Gestión de cambios sobre unidades existentes

Una modificación deberá clasificarse como:

- corrección editorial;
- corrección técnica;
- ampliación;
- refactorización;
- cambio arquitectónico;
- cambio incompatible.

## Corrección editorial

No cambia comportamiento ni estado técnico.

Puede actualizar:

- tutorial;
- instructor notes;
- summary, si mejora precisión.

## Corrección técnica

Cambia comandos, artefactos o validaciones.

Debe revisar:

- tutorial;
- laboratorio;
- summary;
- project-state;
- unidades posteriores afectadas.

## Ampliación

Añade una capacidad dentro del alcance de la unidad.

Debe comprobar que no invade una unidad posterior.

## Refactorización

Reorganiza sin cambiar el resultado funcional.

Debe preservar rutas públicas o documentar la migración.

## Cambio incompatible

Requiere:

- justificación;
- estrategia de migración;
- actualización de arquitectura;
- actualización de roadmap;
- revisión de unidades dependientes.

---

# Criterios de calidad

Una unidad debe cumplir:

## Coherencia

- no contradice arquitectura ni estado;
- reutiliza el laboratorio previo;
- mantiene nomenclatura consistente;
- refleja las mismas rutas en documentación y código.

## Reproducibilidad

- los pasos pueden repetirse;
- las precondiciones están declaradas;
- los comandos son completos;
- las validaciones son observables.

## Trazabilidad

- cada cambio queda descrito;
- el estado se actualiza;
- el resumen identifica artefactos;
- las decisiones relevantes quedan registradas.

## Mantenibilidad

- evita duplicación;
- separa configuración;
- utiliza estructuras previsibles;
- incluye recuperación;
- limita acoplamientos.

## Calidad pedagógica

- objetivos verificables;
- progresión clara;
- conceptos vinculados al laboratorio;
- errores frecuentes documentados;
- conclusión conectada con la siguiente unidad.

---

# Criterios de bloqueo

La IA no deberá cerrar una unidad cuando:

- falte un entregable obligatorio;
- el laboratorio no corresponda con el tutorial;
- no exista validación;
- se haya creado una aplicación paralela no autorizada;
- `project/project-state.md` no esté actualizado;
- el resumen no permita continuar;
- exista contenido duplicado entre `student-notes.md` y `student-reference.md`;
- una exclusión declarada en el alcance quede sin resolver en `student-reference.md`;
- existan secretos reales;
- haya una contradicción arquitectónica sin resolver;
- se afirme una ejecución no realizada;
- una dependencia necesaria no esté disponible.

---

# Formato esperado de cada incremento

Cada incremento deberá poder revisarse como un commit.

La respuesta deberá incluir:

1. identificador o nombre del incremento;
2. archivos creados;
3. archivos modificados;
4. resumen funcional;
5. decisiones tomadas;
6. validaciones;
7. limitaciones;
8. siguiente incremento permitido;
9. mensaje de commit propuesto.

Durante el bootstrap, el siguiente incremento permitido deberá coincidir con el orden registrado en `project/project-state.md`.

---

# Regla de no anticipación

La IA no deberá generar contenido de una unidad futura para “preparar” la actual, salvo que sea un artefacto compartido estrictamente necesario.

Cuando exista esa necesidad deberá:

- justificarla;
- limitar su alcance;
- identificar el propietario futuro;
- registrarla en el estado;
- evitar impartir conceptos fuera de secuencia.

---

# Regla de cierre de sesión

Al finalizar una sesión de generación o modificación, el repositorio deberá contener suficiente contexto para que otra sesión continúe sin acceder a la conversación anterior.

Esto exige que:

- los cambios estén reflejados en archivos;
- el estado esté actualizado;
- el resumen de la unidad esté completo;
- las limitaciones estén registradas;
- el siguiente paso esté identificado;
- no existan decisiones relevantes únicamente en el chat.

---

# Excepción de bootstrap

Durante el bootstrap:

- no se generan tutoriales;
- no se generan laboratorios;
- no se generan notas del instructor;
- no se generan resúmenes de unidad;
- no se instala ni configura la plataforma.

Cada incremento del bootstrap deberá limitarse al archivo previsto en el orden vigente.

El bootstrap finalizará cuando existan y hayan sido revisados:

1. `README.md`;
2. `project/architecture.md`;
3. `project/project-state.md`;
4. `project/roadmap.md`;
5. `playbooks/master.md`;
6. `playbooks/unit-template.md`;
7. `playbooks/summary-template.md`;
8. `playbooks/project-state-template.md`;
9. `playbooks/units/00-environment.md`.

Solo después podrá comenzar la Unidad 0.
