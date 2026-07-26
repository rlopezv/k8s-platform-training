# Plan de saneamiento documental de las Unidades 00-07

## Propósito

Este documento gobierna el saneamiento de las ocho unidades escritas (00-07) para alinearlas con el contrato documental cerrado en la fase 2.

Es la fuente única del plan. La tabla de fases de `project/project-state.md` resume este documento y no debe divergir de él. Mientras el saneamiento esté en curso, cualquier sesión de trabajo lo lee antes de actuar.

Fecha: 2026-07-23.

---

# 1. Qué problema resuelve

Las ocho unidades escritas son anteriores al contrato documental que la fase 2 dejó cerrado en `playbooks/student-reference-template.md`, `playbooks/unit-template.md` y `playbooks/master.md`. Como consecuencia:

- las referencias de las Unidades 00, 01, 06 y 07 no son conformes; es la deuda `TD-019`;
- las referencias de las Unidades 02, 03, 04 y 05 sí son conformes, porque se rehicieron contra la plantilla el 2026-07-22, pero conservan defectos puntuales;
- los ocho playbooks de unidad son no conformes y ninguno sirve hoy como fuente para regenerar su unidad sin perder conformidad;
- el material del alumno arrastra ortografía incompleta; es la deuda `TD-020`;
- la Unidad 04 tiene además una laguna funcional pendiente: la práctica de `StatefulSet`, registrada como `TD-023`.

El saneamiento no afecta a las unidades 08-25, que no están escritas y se generarán desde las plantillas ya conformes.

---

# 2. Principios del saneamiento

Regeneración distinta de aplicación. Regenerar un documento es reescribirlo entero desde su playbook corregido. Ajustar es corregir defectos puntuales conservando el contenido aprobado. No todo se regenera: donde ya hay conformidad, se ajusta.

El playbook es la fuente. Por cada unidad se regenera primero su playbook contra el contrato, y desde el playbook corregido se regenera o ajusta la referencia. No se corrige la referencia por un lado y el playbook por otro.

Los laboratorios no se tocan. Los manifiestos, charts, proyecto Terraform y scripts de validación existentes se conservan. La única excepción es el cierre funcional de la Unidad 04 (`TD-023`), que es la fase 5.

La aprobación pedagógica se protege. El material del alumno de las unidades aprobadas costó varias iteraciones de revisión. Donde el contrato solo exige forma, se alinea forma; no se reabre contenido aprobado sin motivo del contrato.

Nada se declara validado sin ejecución. El saneamiento documental no ejecuta laboratorio. El único incremento con validación técnica es la fase 5, y su evidencia la aporta el usuario.

La lista de cobertura entra al principio, no al final. Antes de regenerar el playbook de una unidad, el usuario aporta la lista exhaustiva de lo que esa unidad debe cubrir. Esa lista es la materia prima de la sección de cobertura del playbook: tipos de cobertura, simplificaciones que obligan a práctica profesional y laguna asignada salen de ella, no de la lectura de la unidad antigua. No es una pasada posterior de enriquecimiento; es la especificación de partida. Aplicarla al final obligaría a reescribir el playbook y la referencia una segunda vez.

El contrato manda sobre el reparto. La lista fija qué se cubre; el contrato fija en qué documento. Cuando un punto de la lista pertenezca a las notas, al README o a la fuente primaria en lugar de a la referencia —código de un CSI cloud, un catálogo, diagnóstico de laboratorio—, se señala al usuario y se coloca donde corresponde, o se eleva como motivo para revisar la plantilla. La lista no reubica contenido por sí sola.

---

# 3. Clasificación de las ocho unidades

| Unidad | Referencia actual | Acción sobre la referencia | Origen |
|---|---|---|---|
| 00 — Preparación del entorno | No conforme | Regenerar | `TD-019` |
| 01 — Fundamentos operativos | No conforme | Regenerar | `TD-019` |
| 02 — Configuración y secretos | Conforme | Ajustar | — |
| 03 — Networking e ingreso | Conforme | Ajustar | — |
| 04 — Persistencia y estado | Conforme | Ajustar; más cierre funcional en fase 5 | `TD-023` |
| 05 — Scheduling y resiliencia | Conforme | Ajustar | — |
| 06 — Empaquetado con Helm | No conforme | Regenerar | `TD-019` |
| 07 — Automatización con Terraform | No conforme | Regenerar | `TD-019` |

En las cuatro unidades a regenerar, el playbook se regenera y la referencia sale de él. En las cuatro a ajustar, el playbook se regenera igual por homogeneidad, pero la referencia solo recibe correcciones puntuales.

---

# 4. Diagnóstico por playbook

Resultado de la revisión de la fase 3. Cada playbook se comprobó contra cinco criterios derivados del contrato: frontera entre notas y referencia declarada (C1), laguna cubierta con identificador `GAP-NNN` o declaración de que no cubre ninguna (C2), tipos de cobertura declarados (C3), exclusiones con destino anclado o fuera del itinerario (C4), y simplificaciones que obligan a bloque de práctica profesional (C5).

Ningún playbook cumple C1, C2, C3 ni C5. Todos cumplen C4 solo parcialmente.

| Playbook | Defecto dominante | Trabajo de regeneración |
|---|---|---|
| `00-environment.md` | No menciona `student-reference.md`. Debe declarar `GAP-001` | Añadir referencia como entregable; declarar C1-C5 |
| `01-kubernetes.md` | No menciona `student-reference.md`. Debe declarar `GAP-004` (mapa de workloads). Ortografía incompleta | Añadir referencia como entregable; declarar C1-C5; ortografía |
| `02-configuration-lifecycle.md` | No menciona `student-reference.md`. Sin laguna asignada | Alinear con la referencia ya conforme; declarar C1-C5 |
| `03-networking-ingress.md` | No menciona `student-reference.md`. Debe declarar `GAP-003`. Faltan secciones de cierre del `unit-template.md` | Alinear; declarar C1-C5; completar secciones |
| `04-persistence-state.md` | No menciona `student-reference.md`. Debe declarar `GAP-004`. Es el más divergente del `unit-template.md`: le faltan siete secciones de cierre. Debe incorporar `TD-023` en su alcance y resolver `Q-010` | Alinear; declarar C1-C5; completar secciones; añadir alcance funcional |
| `05-scheduling-resilience-maintenance.md` | No menciona `student-reference.md`. Sin laguna asignada. Faltan secciones de cierre | Alinear; declarar C1-C5; completar secciones |
| `06-helm-packaging.md` | Prescribe índice por módulos y exige tabla de diagnóstico dentro de la referencia. Es el playbook más incompleto de los ocho | Sustituir molde por remisión a la plantilla; declarar C1-C5; reconstruir secciones ausentes |
| `07-local-terraform-automation.md` | Prescribe índice por módulos y exige tabla de diagnóstico dentro de la referencia. No declara `GAP-010`, que la Unidad 09 necesita | Sustituir molde; declarar C1-C5; añadir `GAP-010` |

Los playbooks 06 y 07 son los más graves porque no omiten el contrato: lo contradicen. Su exigencia de tabla de diagnóstico dentro de `student-reference.md` es la causa directa de que sus referencias dupliquen contenido que pertenece a `student-notes.md`. Por eso encabezan el orden: regenerar su unidad sin corregir antes el playbook dejaría la contradicción viva.

Siete de los ocho playbooks carecen además de ortografía completa en su prosa; el barrido de `TD-020` los incluye.

---

# 5. Trabajo por unidad

Por cada una de las ocho unidades, en su sesión:

0. el usuario aporta la lista de cobertura de la unidad: qué conceptos y criterios debe cubrir. Es la entrada de la que se nutre el playbook y no se empieza sin ella;
1. regenerar `playbooks/units/<unidad>.md` contra el contrato, declarando frontera, laguna con identificador, tipos de cobertura, exclusiones con destino y simplificaciones, todo ello derivado de la lista del paso 0;
2. desde el playbook corregido, regenerar `tutorial/<unidad>/student-reference.md` (Unidades 00, 01, 06, 07) o ajustarla contra el playbook (Unidades 02, 03, 04, 05);
3. alinear `tutorial/<unidad>/student-notes.md`: formato, y traslado a la referencia del contenido conceptual que el contrato saca de las notas;
4. barrido ortográfico de los documentos del alumno de la unidad, conservando literales técnicos;
5. añadir al `tutorial/<unidad>/summary.md` la línea de cierre de laguna que corresponda;
6. verificar la cobertura: comparar la referencia resultante contra la lista del paso 0, punto por punto. Si algún punto no aparece, el playbook lo perdió y se corrige antes de cerrar. Esta comprobación es verificación, no generación; la cobertura ya debía estar puesta desde el paso 1;
7. actualizar `project/project-state.md` y, cuando se cierre una laguna, `project/content-gap-register.md`.

La Unidad 04 recibe además, en la fase 5, el cierre funcional de `TD-023`, descrito en el apartado 7.

---

# 6. Orden y modelo de sesiones

## Orden

```text
07 (piloto) → 06 → 01 → 00 → 02 → 03 → 05 → 04 documental → TD-022 → 04 funcional (TD-023)
```

La Unidad 07 es el piloto: valida el contrato sobre contenido real antes de aplicarlo a las otras siete, y su referencia debe cerrar `GAP-010`, que la Unidad 09 necesita. Los playbooks 06 y 07, los que contradicen el contrato, se corrigen primero. Después las dos no conformes restantes, 01 y 00. Después las cuatro conformes, cuyo trabajo es de ajuste: 02, 03, 05 y 04 documental. Tras ajustar esas cuatro referencias se ejecuta la auditoría `TD-022`. Y al final queda el cierre funcional de la 04.

## Una unidad por sesión

El reparto es por unidad y no por lote porque cada sesión debe cargar el contrato completo más los artefactos de la unidad, y repartir esa carga entre dos unidades degrada la calidad. Estimación: entre diez y once sesiones, según cuánta revisión del usuario se intercale. Las cuatro unidades a regenerar son las más largas; las cuatro a ajustar podrían emparejarse si alguna resulta liviana, pero no se compromete de antemano. La auditoría `TD-022` puede cerrarse en una sesión propia o incorporarse al cierre del último ajuste documental si la evidencia es suficiente.

## Entradas de cada sesión

El usuario abre la sesión con:

- un `SESSION_HANDOFF.md` generado con `playbooks/generate-session-handoff.md`, apuntando a la unidad de esa sesión;
- la lista de cobertura de la unidad, según el paso 0 del apartado 5. Es obligatoria: sin ella no se empieza el playbook;
- un ZIP acotado con: `playbooks/master.md`, `playbooks/unit-template.md`, `playbooks/student-reference-template.md`, `playbooks/summary-template.md`, `project/architecture.md`, `project/project-state.md`, `project/content-gap-register.md`, este plan, la carpeta `tutorial/<unidad>/` completa, `playbooks/units/<unidad>.md` y `labs/<unidad>/README.md`.

El ZIP debe incluir las carpetas de unidad; el handoff por sí solo no basta.

## Salidas de cada sesión

Ficheros completos listos para colocar en el repositorio, no parches: el playbook regenerado, la referencia regenerada o ajustada, las notas alineadas, el summary con su línea y `project/project-state.md` actualizado. Más el chequeo de cobertura del paso 6: la lista del usuario contrastada punto por punto contra la referencia resultante, indicando dónde queda cubierto cada punto y señalando lo que el contrato haya reubicado a otra pieza. Y una nota de validación: en las unidades documentales, ninguna acción técnica; en la fase 5, la lista de comprobaciones que el usuario ejecuta contra MicroK8s.

---

# 7. Fase 5 — Cierre funcional de la Unidad 04

`TD-023` es la práctica de `StatefulSet`, `volumeClaimTemplates` y headless Service sobre un workload auxiliar desechable, sin migrar `platform-api`. Se ejecuta al final del saneamiento porque es el único incremento con validación técnica y su evidencia la aporta el usuario.

Decisiones ya tomadas, que resuelven `Q-010` y se incorporarán al playbook de la Unidad 04 al regenerarlo:

- nombre `scratch-stateful`, con prefijo que lo señala como desechable en la salida de `kubectl`;
- imagen y tag ya usados por `platform-api`, con el comando sobrescrito para escribir la identidad de la réplica; sin introducir imágenes nuevas;
- dos réplicas, para que se observe un PVC por ordinal;
- el workload vive en `labs/04-persistence-state/statefulset-demo/`, fuera de `solution/`, para no propagarse a las Unidades 05, 06 y 07;
- limpieza obligatoria con borrado de los PVC por nombre exacto, nunca por selector ni con `--all`, y sin tocar `platform-api-data`;
- la validación heredada `labs/04-persistence-state/validation/validate.sh` no se modifica; la práctica se valida con un script independiente.

El cierre de `TD-023` requiere validación ejecutada contra MicroK8s. No se declara cerrado sin evidencia del usuario.

---

# 8. Impacto en deudas y cuestiones

| Elemento | Efecto del saneamiento |
|---|---|
| `TD-019` | Se cierra al regenerar las referencias de 00, 01, 06 y 07 |
| `TD-020` | Se cierra con el barrido ortográfico de las ocho unidades. Alcance limitado al material del alumno |
| `TD-022` | Auditoría de autosuficiencia de las referencias conformes 02-05. Se ejecuta tras el ajuste de esas unidades y antes de desbloquear la 08 |
| `TD-023` | Se cierra en la fase 5, con validación ejecutada |
| `Q-010` | Se cierra al regenerar el playbook de la Unidad 04 |
| `GAP-003` | Candidata a cierre al regenerar la referencia de la Unidad 03 |
| `GAP-004` | Se cierra al ejecutar la fase 5 de la Unidad 04 |
| `GAP-010` | Se cierra al regenerar la referencia de la Unidad 07 |

Los cierres de laguna se registran en `project/content-gap-register.md` a medida que ocurren, no por adelantado.

---

# 9. Qué desbloquea el saneamiento

La Unidad 08 espera al cierre completo de las fases 4 y 5, incluida la auditoría `TD-022`. Por decisión del usuario del 2026-07-23, el plan no se parte para adelantarla.

Las unidades 09 en adelante no dependen del saneamiento salvo por `GAP-010`, que la referencia de la Unidad 07 debe cerrar y que la Unidad 09 necesita.

---

# 10. Decisiones registradas de esta planificación

- El saneamiento se organiza como regeneración de playbook seguida de regeneración o ajuste de referencia, unidad por unidad, no como fases separadas de especificación y aplicación.
- No se introduce ninguna categoría de artefacto nueva. La corrección de cada unidad vive en su propio playbook y sus propios entregables.
- Las referencias de 02-05 se ajustan, no se regeneran, para no reabrir contenido pedagógico aprobado.
- El cierre funcional de la Unidad 04 se aparta como fase 5 y se ejecuta al final, con validación del usuario.
- La corrección de los ocho playbooks es parte del trabajo por unidad, no una deuda separada.
- La lista de cobertura que aporta el usuario es una entrada de sesión obligatoria y previa al playbook, no una pasada final. El playbook la absorbe en su sección de cobertura, la referencia nace cubriéndola, y el cierre de la unidad la verifica punto por punto. El reparto de cada punto entre referencia, notas, README y fuente primaria lo decide el contrato, no la lista.
