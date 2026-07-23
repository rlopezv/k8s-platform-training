# Registro de lagunas de contenido

## Propósito

Este documento registra lagunas formativas detectadas al revisar las Unidades 00-07.

Su función es aceptar que el itinerario no puede convertir cada tutorial en una referencia completa de Kubernetes, y evitar dos errores:

- sobrecargar los README y `student-notes.md` con todo lo que falta;
- olvidar capacidades importantes que deben aparecer en el itinerario antes de que unidades posteriores las necesiten.

Cuando una laguna sea profunda o panorámica pero pertenezca a una unidad concreta, puede resolverse con `student-reference.md`, aunque no tenga ejercicio directo en el laboratorio. Cuando afecte a la secuencia del curso, deberá alimentar una decisión de roadmap antes de generar nuevas unidades.

## Criterio de uso

Cada entrada debe indicar:

- qué falta;
- por qué importa;
- dónde encaja mejor;
- si requiere nueva unidad, refuerzo de una unidad existente o solo `student-reference.md`;
- decisión pendiente.

## Lagunas identificadas

| ID | Laguna | Impacto formativo | Encaje natural | Tratamiento propuesto | Estado |
|---|---|---|---|---|---|
| GAP-001 | Contenedores, imagen y registro | La Unidad 01 despliega `platform-api` asumiendo una imagen existente; sin Dockerfile, usuario no root, tags inmutables y registro local, la seguridad de supply chain llega sin base suficiente | Unidad 00 como referencia; Unidad 01 como consumo de imagen | Resuelto con `tutorial/00-environment/student-reference.md`, laboratorio de acompañamiento en `platform/environment/container-images/README.md` y enlaces mínimos desde Unidad 01; no se añaden prácticas de build ni registry | Cerrada |
| GAP-002 | Gestión real de secretos | El curso pasa de Secrets ficticios a seguridad avanzada sin cubrir cómo llegan secretos reales al clúster sin guardarlos en Git ni gestionarlos manualmente con `kubectl` | Unidad 09 como referencia GitOps; continuidad en cloud y seguridad avanzada | Cerrada con decisión pedagógica: Unidad 02 documenta límites de `Secret` y conserva Secrets ficticios; Unidad 09 añadirá `student-reference.md` sobre gestión real de secretos en GitOps, comparando External Secrets Operator, Sealed Secrets, SOPS, Vault y secret managers cloud; no instalar herramientas ni crear laboratorio ahora | Cerrada |
| GAP-003 | TLS, cert-manager e Ingress/Gateway API | La Unidad 03 introduce Ingress HTTP local, pero no certificados ni criterio de evolución hacia Gateway API | `student-reference.md` de Unidad 03; continuidad futura en GitOps, cloud y gobierno de plataforma | Cerrado documentalmente con `tutorial/03-networking-ingress/student-reference.md` sobre TLS, certificados, `cert-manager`, terminación TLS, diferencias entre Ingress y Gateway API y criterio de migración; no cambia el laboratorio local de Unidad 03 | Cerrada |
| GAP-004 | Workloads no Deployment | La Unidad 01 introduce Deployment, pero necesitaba un mapa general de workloads; StatefulSet, headless Service, Jobs, CronJobs y DaemonSet pueden parecer rarezas aisladas si aparecen tarde y sin criterio de elección | `student-reference.md` de Unidad 01; práctica repartida en unidades naturales | Mapa de workloads en `tutorial/01-kubernetes/student-reference.md`; criterio profesional de StatefulSet y headless Service en `tutorial/04-persistence-state/student-reference.md`; **práctica de StatefulSet y headless Service incorporada a la Unidad 04 sobre workload auxiliar desechable, sin migrar `platform-api`**; Jobs/CronJobs en Unidad 08; DaemonSet en observabilidad | Cerrada |
| GAP-005 | Progressive delivery | La promoción entre entornos no cubre canary, blue-green, Argo Rollouts o Flagger; sin SLI/SLO, la promoción progresiva queda como cambio de tráfico sin criterio operativo | `student-reference.md` futuro de Unidad 10; práctica diferida hasta después de observabilidad básica | Abordado con decisión pedagógica: introducir progressive delivery en Unidad 10 como referencia sobre canary, blue-green, rolling, feature flags, Argo Rollouts, Flagger y relación con Argo CD; no añadir laboratorio antes de contar con SLI/SLO en Unidad 12 o observabilidad integrada en Unidad 15 | Abordada |
| GAP-006 | Multi-tenancy y gobierno de recursos | Faltan ResourceQuota, LimitRange, jerarquía de namespaces y ownership por equipo; sin estos controles, RBAC y seguridad de workloads quedan desconectados del gobierno operativo de plataforma | Unidad 16 para controles base; Unidad 24 como gobierno de plataforma; conexión ligera desde Unidad 02 | Abordado con decisión pedagógica: cubrir en Unidad 16 namespaces como frontera administrativa, ResourceQuota, LimitRange, ownership y relación con RBAC, ServiceAccounts, NetworkPolicies y PSS; cubrir en Unidad 24 jerarquía de namespaces, golden paths, catálogo, estándares, lifecycle y modelo operativo; Unidad 02 solo enlazará requests/limits con cuotas y coste | Abordada |
| GAP-007 | Ciclo de vida del clúster | Upgrades, deprecaciones de API, compatibilidad de `kubectl`, kubelet/control plane, addons, CRDs y node pools aparecen solo de forma indirecta; sin esto, la fiabilidad queda desconectada del mantenimiento real del clúster | Unidad 22 como comparativa operativa; Unidad 23 como bloque fuerte de fiabilidad y recuperación | Abordado con decisión pedagógica: Unidad 22 comparará diferencias de upgrades entre MicroK8s, AKS y EKS; Unidad 23 incorporará ciclo de vida del clúster como bloque fuerte con versiones, skew, deprecaciones, release notes, estrategia por entorno, ventanas de mantenimiento, node pools, addons, CRDs, backup previo, rollback realista, runbook y validación posterior; no crear unidad nueva salvo que el alcance de Unidad 23 resulte inmanejable | Abordada |
| GAP-008 | Coste y FinOps | Requests/limits afectan scheduling, densidad, escalado y coste cloud; si el coste aparece solo como precio de proveedor, el alumno no ve que muchas decisiones de coste nacen en el diseño operativo | Hilo transversal en Unidad 02, Unidad 18 y Unidad 22 | Abordado con decisión pedagógica: Unidad 02 ya conecta requests/limits, QoS, cuotas y coste en `student-reference.md` sin ampliar laboratorio; Unidad 18 conectará HPA/KEDA, métricas de escalado, escala a cero, límites y coste; Unidad 22 convertirá coste en criterio operativo comparando nodos, control plane, storage, load balancers, observabilidad, tráfico y autoscaling; no crear unidad propia ni tabla de precios estable | Abordada |
| GAP-009 | Desacoplamiento de MicroK8s | La Unidad 19 es crítica para distinguir Kubernetes estándar de supuestos locales; si no se hace explícito, el curso puede enseñar Kubernetes en MicroK8s como si fuese equivalente a operar una plataforma gestionada real | Unidad 19 como puente obligatorio entre laboratorio local y cloud | Abordado con decisión pedagógica: Unidad 19 deberá incluir un inventario formal de supuestos locales para separar Kubernetes estándar, MicroK8s y AKS/EKS; la matriz cubrirá StorageClass, LoadBalancer, DNS, Ingress, identidad, registry, RBAC/workload identity, red/CNI/subnets, persistencia, backups/snapshots, observabilidad, disponibilidad, coste y operación; no crear unidad nueva, pero dar más peso a Unidad 19 | Abordada |
| GAP-010 | Propiedad de un recurso entre Terraform y GitOps | La Unidad 07 deja `helm_release.platform_api` gestionado por Terraform con estado local; la Unidad 09 introduce Argo CD, que reconcilia de forma continua el mismo release desde Git. El itinerario no declara qué ocurre cuando dos sistemas reclaman propiedad del mismo recurso, ni qué responsabilidad conserva Terraform una vez existe GitOps. Es la frontera de responsabilidad que el curso declara como objetivo | `student-reference.md` de Unidad 07 para plantear la pregunta; `student-reference.md` de Unidad 09 para resolverla | Decisión pedagógica: la Unidad 07 declara el límite de propiedad de Terraform y anticipa el conflicto; la Unidad 09 resuelve el criterio de reparto entre Terraform y Argo CD. Sin laboratorio nuevo ni cambio de alcance en ninguna de las dos | Abordada |
| GAP-011 | Elementos declarados fuera de alcance sin destino | Service mesh, chaos engineering y topology spread constraints se declaran como no practicados y no se retoman en ninguna sección de continuidad ni se declaran fuera del itinerario. El alumno lee "no se cubre X" sin saber si significa "todavía no", "nunca" o "no hace falta" | Service mesh en Unidad 16; chaos engineering en Unidad 15; topology spread constraints en Unidad 18 | Destinos asignados como referencia, sin laboratorio nuevo: el mesh como criterio frente a `NetworkPolicy` y mTLS; el chaos como validación de observabilidad y runbooks, evitando cargar la Unidad 23 ya señalada en GAP-007; topology spread junto a escalado y distribución. Regla permanente asociada: todo elemento declarado como no practicado debe tener número de unidad en continuidad o declararse fuera del itinerario | Cerrada |

## Riesgos y advertencias

La tabla de lagunas es la fuente única del tratamiento de cada una. Esta sección
recoge solo lo que no cabe en ella.

| Laguna | Advertencia |
|---|---|
| GAP-007 | Si la Unidad 23 acumula ciclo de vida del clúster junto a backup, restore y RPO/RTO, su alcance resultará inmanejable. Reevaluar antes de generarla y, si procede, desplazar parte a la Unidad 22 |
| GAP-004 | Su cierre con práctica convierte el retroajuste de la Unidad 04 en incremento funcional, no editorial. Ver `TD-023` |
| GAP-010 | Depende de que la Unidad 07 se retroajuste antes de generar la Unidad 09 |

## Estado consolidado

11 lagunas registradas: 5 cerradas, 6 abordadas, 0 abiertas.
