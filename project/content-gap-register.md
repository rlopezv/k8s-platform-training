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
| GAP-004 | Workloads no Deployment | La Unidad 01 introduce Deployment, pero necesitaba un mapa general de workloads; StatefulSet, headless Service, Jobs, CronJobs y DaemonSet pueden parecer rarezas aisladas si aparecen tarde y sin criterio de elección | `student-reference.md` de Unidad 01; laboratorios distribuidos en unidades naturales | Cerrado documentalmente con `tutorial/01-kubernetes/student-reference.md` como mapa de workloads; `tutorial/04-persistence-state/student-reference.md` añade criterio profesional para StatefulSet y headless Service sin migrar el laboratorio; Jobs/CronJobs quedan para Unidad 08 y DaemonSet para observabilidad | Cerrada |
| GAP-005 | Progressive delivery | La promoción entre entornos no cubre canary, blue-green, Argo Rollouts o Flagger; sin SLI/SLO, la promoción progresiva queda como cambio de tráfico sin criterio operativo | `student-reference.md` futuro de Unidad 10; práctica diferida hasta después de observabilidad básica | Abordado con decisión pedagógica: introducir progressive delivery en Unidad 10 como referencia sobre canary, blue-green, rolling, feature flags, Argo Rollouts, Flagger y relación con Argo CD; no añadir laboratorio antes de contar con SLI/SLO en Unidad 12 o observabilidad integrada en Unidad 15 | Abordada |
| GAP-006 | Multi-tenancy y gobierno de recursos | Faltan ResourceQuota, LimitRange, jerarquía de namespaces y ownership por equipo; sin estos controles, RBAC y seguridad de workloads quedan desconectados del gobierno operativo de plataforma | Unidad 16 para controles base; Unidad 24 como gobierno de plataforma; conexión ligera desde Unidad 02 | Abordado con decisión pedagógica: cubrir en Unidad 16 namespaces como frontera administrativa, ResourceQuota, LimitRange, ownership y relación con RBAC, ServiceAccounts, NetworkPolicies y PSS; cubrir en Unidad 24 jerarquía de namespaces, golden paths, catálogo, estándares, lifecycle y modelo operativo; Unidad 02 solo enlazará requests/limits con cuotas y coste | Abordada |
| GAP-007 | Ciclo de vida del clúster | Upgrades, deprecaciones de API, compatibilidad de `kubectl`, kubelet/control plane, addons, CRDs y node pools aparecen solo de forma indirecta; sin esto, la fiabilidad queda desconectada del mantenimiento real del clúster | Unidad 22 como comparativa operativa; Unidad 23 como bloque fuerte de fiabilidad y recuperación | Abordado con decisión pedagógica: Unidad 22 comparará diferencias de upgrades entre MicroK8s, AKS y EKS; Unidad 23 incorporará ciclo de vida del clúster como bloque fuerte con versiones, skew, deprecaciones, release notes, estrategia por entorno, ventanas de mantenimiento, node pools, addons, CRDs, backup previo, rollback realista, runbook y validación posterior; no crear unidad nueva salvo que el alcance de Unidad 23 resulte inmanejable | Abordada |
| GAP-008 | Coste y FinOps | Requests/limits afectan scheduling, densidad, escalado y coste cloud; si el coste aparece solo como precio de proveedor, el alumno no ve que muchas decisiones de coste nacen en el diseño operativo | Hilo transversal en Unidad 02, Unidad 18 y Unidad 22 | Abordado con decisión pedagógica: Unidad 02 ya conecta requests/limits, QoS, cuotas y coste en `student-reference.md` sin ampliar laboratorio; Unidad 18 conectará HPA/KEDA, métricas de escalado, escala a cero, límites y coste; Unidad 22 convertirá coste en criterio operativo comparando nodos, control plane, storage, load balancers, observabilidad, tráfico y autoscaling; no crear unidad propia ni tabla de precios estable | Abordada |
| GAP-009 | Desacoplamiento de MicroK8s | La Unidad 19 es crítica para distinguir Kubernetes estándar de supuestos locales; si no se hace explícito, el curso puede enseñar Kubernetes en MicroK8s como si fuese equivalente a operar una plataforma gestionada real | Unidad 19 como puente obligatorio entre laboratorio local y cloud | Abordado con decisión pedagógica: Unidad 19 deberá incluir un inventario formal de supuestos locales para separar Kubernetes estándar, MicroK8s y AKS/EKS; la matriz cubrirá StorageClass, LoadBalancer, DNS, Ingress, identidad, registry, RBAC/workload identity, red/CNI/subnets, persistencia, backups/snapshots, observabilidad, disponibilidad, coste y operación; no crear unidad nueva, pero dar más peso a Unidad 19 | Abordada |

## Siguiente decisión recomendada

`GAP-001` queda resuelta como referencia conceptual de Unidad 00, acompañada por un laboratorio de lectura y observacion de solo lectura.

`GAP-002` queda cerrada como decisión pedagógica para la Unidad 09. La Unidad 02 conserva Secrets ficticios para aprender el objeto Kubernetes y documenta sus límites en `tutorial/02-configuration-lifecycle/student-reference.md`; la gestión real de secretos se explicará en Unidad 09 desde el patrón GitOps y se retomará en cloud y seguridad avanzada cuando aparezcan identidad, secret managers y controles de supply chain.

`GAP-003` queda cerrada documentalmente con `tutorial/03-networking-ingress/student-reference.md`. El laboratorio actual sigue limitado a Ingress HTTP local y no incorpora TLS, `cert-manager` ni Gateway API aplicada por ahora.

`GAP-004` queda cerrada documentalmente con `tutorial/01-kubernetes/student-reference.md` como mapa general de workloads. La Unidad 04 añade criterio profesional para StatefulSet y headless Service en `tutorial/04-persistence-state/student-reference.md`, sin migrar el laboratorio. La práctica queda repartida por problema real: Jobs/CronJobs en CI/CD y DaemonSet en observabilidad.

`GAP-005` queda abordada como decisión pedagógica para la Unidad 10. Progressive delivery se presentará como referencia conceptual vinculada a promoción entre entornos y Argo CD, pero su práctica se diferirá hasta que el alumno disponga de señales de observabilidad, SLI/SLO y criterios de rollback.

`GAP-006` queda abordada como decisión pedagógica repartida. La Unidad 16 deberá cubrir los controles Kubernetes concretos de aislamiento y recursos, con posibilidad de laboratorio real para ResourceQuota y LimitRange. La Unidad 24 deberá cubrir el gobierno de plataforma como modelo operativo, no solo como colección de políticas.

`GAP-007` queda abordada como decisión pedagógica para Unidad 23, con apoyo de la comparativa de Unidad 22. El ciclo de vida del clúster deberá tratarse como operación real de fiabilidad: versiones, deprecaciones, compatibilidad, node pools, addons, CRDs, backup, rollback, runbook y validación posterior. Riesgo: si la Unidad 23 queda demasiado cargada junto con backup/restore/RPO/RTO, se deberá reevaluar el alcance antes de generarla.

`GAP-008` queda abordada como hilo transversal FinOps. El curso deberá enseñar mecanismos estables de coste, no tablas de precios: requests/limits y QoS ya quedan conectados en `tutorial/02-configuration-lifecycle/student-reference.md`, escalado y coste se retomarán en Unidad 18, y coste operativo comparado entre MicroK8s, AKS y EKS se tratará en Unidad 22.

`GAP-009` queda abordada como decisión estructural para Unidad 19. La unidad deberá incluir una matriz formal de supuestos locales con columnas equivalentes a supuesto local, cómo aparece en MicroK8s, riesgo al migrar, sustituto en AKS, sustituto en EKS y decisión pendiente.

Todas las lagunas iniciales de la revisión de Unidades 00-07 quedan cerradas o abordadas con decisión pedagógica. El siguiente incremento permitido puede volver a ser generar el playbook de Unidad 08, salvo que el usuario decida materializar alguna referencia pendiente antes.
