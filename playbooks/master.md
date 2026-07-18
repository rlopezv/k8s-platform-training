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
5. el `summary.md` de la unidad anterior;
6. el playbook específico de la unidad;
7. los artefactos existentes que la unidad deba reutilizar.

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

## Paso 5 — Generar los entregables

Cada unidad deberá generar obligatoriamente:

```text
tutorial/<unidad>/README.md
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

Debe incluir como mínimo:

- contexto;
- objetivos;
- conocimientos previos;
- relación con la unidad anterior;
- arquitectura o estado inicial;
- conceptos;
- procedimiento;
- validaciones;
- resultados esperados;
- problemas frecuentes;
- limpieza o recuperación cuando proceda;
- conclusión;
- conexión con la siguiente unidad.

El contenido deberá diferenciar claramente:

- explicación conceptual;
- instrucciones ejecutables;
- resultados esperados;
- notas específicas de plataforma.

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
- errores de razonamiento frecuentes;
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
