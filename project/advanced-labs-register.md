# Registro de candidatos a laboratorio avanzado

## Propósito

Este documento recoge las prácticas que la revisión inicial de cobertura de las Unidades 00-07 detectó como **fuera del alcance actual de su unidad**, pero potencialmente valiosas como laboratorio avanzado.

Su origen es concreto: al cruzar las listas de cobertura del usuario contra cada referencia, playbook y README, varios puntos quedaron resueltos como criterio —la referencia los explica— en lugar de como práctica —el laboratorio los ejecuta—, porque practicarlos habría exigido cambiar el alcance de la unidad, introducir un workload nuevo, o disponer de algo que el laboratorio de un solo nodo no tiene. Cada uno de esos puntos es un candidato a laboratorio avanzado.

## Qué es y qué no es este documento

Es un **registro de candidatos detectados**, no un plan de trabajo. No obliga a construir ningún laboratorio. Recoge lo que la revisión encontró, con su motivo, para que el usuario decida más adelante qué asciende a laboratorio real, qué ya está cubierto por una unidad posterior del roadmap, y qué se archiva.

No es un registro de lagunas: las lagunas de contenido viven en `project/content-gap-register.md`. Un candidato aquí no es contenido que falte, sino práctica que la referencia ya cubre como criterio y que podría además ejercitarse.

## Alcance de esta revisión

Cubre las seis unidades cuya lista de cobertura se cruzó en la revisión inicial: 00, 01, 03, 05, 06 y 07. Las Unidades 02 y 04 se trataron por separado: la 02 no generó candidatos, y la práctica avanzada de la 04 ya está decidida como `TD-023`, no como candidato.

La Unidad 08 añade candidatos desde su playbook específico, al repartir la lista de cobertura aportada por el usuario contra el contrato mínimo del roadmap. Las Unidades 09-25 no están escritas; sus candidatos surgirán al generarlas y cruzar sus listas.

## Clasificación

Cada entrada se clasifica en una de tres categorías, porque no todo lo detectado es un laboratorio nuevo:

- **A — Candidato a laboratorio avanzado nuevo**: práctica ejecutable que no existe en el itinerario y que requeriría un laboratorio propio, normalmente con un workload auxiliar desechable.
- **B — Ya cubierto por una unidad posterior**: el roadmap ya lo trata más adelante; la lista del usuario pedía adelantarlo. No es un laboratorio nuevo, sino un recordatorio de dónde vive.
- **C — No es laboratorio**: pertenece a documentación de entorno u otra pieza, no a un ejercicio de Kubernetes.

La categoría de cada entrada es una **propuesta de la revisión**, pendiente de confirmación del usuario. El usuario conoce el roadmap mejor y decide si un candidato de categoría B está realmente cubierto o si asciende a A.

## Registro

| ID | Unidad origen | Práctica detectada | Por qué quedó fuera | Categoría propuesta | Destino o workload que requeriría |
|---|---|---|---|---|---|
| LAB-06-01 | 06 — Helm | Umbrella chart orquestando `platform-api` más una base de datos auxiliar como subchart, con activación por `condition` | El alcance del playbook 06 excluye subcharts y umbrella ejecutables; arrastra un workload con estado que la unidad no tiene | A | Subchart auxiliar desechable, fuera de la solución evolutiva, en la línea de `scratch-stateful` de la Unidad 04 |
| LAB-06-02 | 06 — Helm | Hooks ejecutables (`pre-install` para migración) y `helm test` posdespliegue | Mismo alcance excluido; requiere el workload con estado de LAB-06-01 | A | Depende de LAB-06-01; se practicarían juntos |
| LAB-03-01 | 03 — Networking | MetalLB en capa 2 para asignar IPs a Services `LoadBalancer` locales | La referencia lo excluye con argumento: instalarlo desplaza el foco de routing HTTP a operación de balanceo | B | La referencia lo ancla como criterio de la Unidad 19; confirmar si la 19 lo practica o solo lo compara |
| LAB-03-02 | 03 — Networking | TLS real en el Ingress: secretos TLS, `cert-manager`, CA local | `GAP-003` está cerrado documentalmente; la unidad practica HTTP local a propósito | B | La referencia ancla TLS/`cert-manager` hacia GitOps, cloud y gobierno; confirmar unidad exacta |
| LAB-03-03 | 03 — Networking | Anotaciones avanzadas de controlador (rewrite, CORS, rate-limiting) | No son portables entre controladores; la referencia las manda documentar por plataforma, no practicar como YAML universal | B | Criterio de plataforma; probable API gateway o Gateway API en unidad posterior |
| LAB-05-01 | 05 — Scheduling | Taints y tolerations para segregar cargas por rol de nodo | Requiere varios nodos con roles distintos; el laboratorio es de un solo nodo | B | La referencia lo ancla en "qué cambia en cloud", Unidades 19 y 22; confirmar |
| LAB-05-02 | 05 — Scheduling | `drain`, `cordon`, `uncordon` como evacuación real de nodo | En un nodo único `drain` se bloquea; la referencia evita automatizarlo para no volverlo mecánico | B | Requiere clúster multinodo; encaja en cloud, Unidades 20-22 |
| LAB-00-01 | 00 — Entorno | Tuning de `.wslconfig`: límites de CPU/RAM, swap, compactación de vhd del host Windows | No es referencia ni práctica de Kubernetes; es contención de recursos del host | C | Documentación de entorno en `platform/environment/`, no laboratorio |
| LAB-08-01 | 08 — Tekton | Build de imagen de `platform-api` con Kaniko, BuildKit o herramienta equivalente y push a registry | El repositorio no contiene `Dockerfile`, registry local/remoto ni estrategia de credenciales; practicarlo en el tronco cambiaría el alcance de CI inicial | A | Laboratorio avanzado de Tekton o supply chain; requiere estrategia de imagen, registry, tags inmutables y credenciales ficticias seguras |
| LAB-08-02 | 08 — Tekton | Tekton Triggers con webhook real para crear PipelineRuns desde eventos Git | Requiere exposición HTTP, autenticación de eventos, secreto de webhook y controles que no pertenecen al tronco inicial de CI | A | Laboratorio avanzado de Tekton o revisión al generar Unidad 10 |

## Observaciones de la revisión

Las categorías A se concentran ahora en dos zonas: Helm avanzado en Unidad 06 y CI/CD avanzado en Unidad 08. En la Unidad 06, LAB-06-02 depende del workload de LAB-06-01, así que un único laboratorio avanzado de Helm podría cubrir ambos. En la Unidad 08, LAB-08-01 y LAB-08-02 quedan separados porque build de imagen y webhooks reales tienen dependencias distintas: registry, estrategia de imagen y credenciales por un lado; exposición HTTP, autenticación de eventos y secretos por otro.

El patrón que requieren los candidatos avanzados de la Unidad 06 —un workload auxiliar desechable, fuera de la solución evolutiva, con su propio ciclo de validación y limpieza por nombre exacto— ya está probado: `scratch-stateful` de la Unidad 04, cerrado con `TD-023` el 2026-07-27, es un precedente ejecutado y validado contra MicroK8s. Quien aborde el laboratorio avanzado de la 06 parte de un modelo funcional real, no de una idea. Los candidatos de la Unidad 08 requieren otro tipo de base: estrategia de imagen, registry, credenciales ficticias seguras o entrada HTTP autenticada.

Las categorías B no son trabajo nuevo, sino verificación. Cada una afirma que el roadmap ya cubre la práctica más adelante; el usuario debe confirmar que esa unidad posterior la ejerce de verdad y no solo la menciona. Si alguna unidad posterior solo la compara sin practicarla, ese candidato asciende a A.

La categoría C no pertenece a este itinerario de laboratorios; se anota para no perderla, pero su destino es la documentación del entorno.

Un patrón transversal explica por qué existe este registro: las listas de cobertura del usuario tienden a redactar como práctica lo que las unidades cubren como criterio, y a pedir operación de infraestructura que el laboratorio de un solo nodo no puede sostener. Ninguna de esas peticiones fue un defecto de las unidades; todas se resolvieron correctamente como criterio. Este registro es donde esas peticiones quedan guardadas por si el itinerario decide, más adelante, darles un laboratorio propio.

## Estado

10 candidatos registrados: 4 en categoría A, 5 en categoría B, 1 en categoría C. Ningún candidato está aprobado como laboratorio a construir.

Las entradas B y C quedan **vivas y aplazadas por decisión del usuario del 2026-07-27**: no se confirman ni se descartan ahora. La decisión depende de cuánta profundidad quiera darse al itinerario más adelante —si conviene aumentar la complejidad de las unidades cloud o crear un itinerario experto separado—, y esa valoración se hará al avanzar hacia esas unidades, no antes. Se revisan cuando el itinerario llegue a las unidades de las que dependen (19-22 para las B) o cuando se decida sobre la documentación de entorno (la C).

Las entradas A no quedan aprobadas como trabajo por aparecer aquí. Las de Unidad 06 son práctica ejecutable de Helm avanzado con patrón de referencia probado en `scratch-stateful`; las de Unidad 08 requieren decisiones previas sobre imagen, registry, credenciales ficticias, webhooks y exposición segura antes de convertirse en laboratorio.
