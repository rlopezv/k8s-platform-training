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
| GAP-002 | Gestión real de secretos | El curso pasa de Secrets ficticios a seguridad avanzada sin cubrir cómo llegan secretos reales al clúster sin guardarlos en Git ni gestionarlos manualmente con `kubectl` | Unidad 09 como referencia GitOps; continuidad en cloud y seguridad avanzada | Abordado con decisión pedagógica: añadir `student-reference.md` en Unidad 09 sobre gestión de secretos en GitOps, comparando External Secrets Operator, Sealed Secrets, SOPS, Vault y secret managers cloud; no instalar herramientas ni crear laboratorio ahora | Cerrada |
| GAP-003 | TLS, cert-manager e Ingress/Gateway API | La Unidad 03 introduce Ingress HTTP local, pero no certificados ni criterio de evolución hacia Gateway API | Refuerzo de Unidad 03 o unidad posterior de entrada segura antes de cloud | Decidir si se enseña Ingress, Gateway API o ambos con criterio de migración | Abierta |
| GAP-004 | Workloads no Deployment | StatefulSet, headless Service, Jobs, CronJobs y DaemonSet no tienen tratamiento suficiente | StatefulSet en Unidad 04; Jobs/CronJobs en Unidad 02 u 08; DaemonSet en observabilidad o plataforma | Decidir si se refuerzan unidades existentes o se añade una unidad de workloads | Abierta |
| GAP-005 | Progressive delivery | La promoción entre entornos no cubre canary, blue-green, Argo Rollouts o Flagger | Después de Argo CD y antes o junto a observabilidad operativa; posible ajuste de Unidad 10 o nueva unidad entre 10 y 11 | Decidir si entra como extensión de promoción o como bloque propio vinculado a SLI | Abierta |
| GAP-006 | Multi-tenancy y gobierno de recursos | Faltan ResourceQuota, LimitRange, jerarquía de namespaces y ownership por equipo | Unidad 16 para controles base; Unidad 24 como gobierno de plataforma | Repartir entre seguridad operativa y gobierno de plataforma | Abierta |
| GAP-007 | Ciclo de vida del clúster | Upgrades, deprecaciones de API, compatibilidad de `kubectl` y node pools aparecen solo de forma indirecta | Unidad 22 o 23, con posible bloque propio de operación de clúster | Dar más peso que una comparativa; decidir si merece unidad dedicada | Abierta |
| GAP-008 | Coste y FinOps | Requests/limits afectan coste cloud y capacidad, pero el hilo de coste no está integrado | Hilo transversal 02, 18 y 22 | Añadir referencias y criterios de coste donde ya se tocan recursos, escalado y cloud | Abierta |
| GAP-009 | Desacoplamiento de MicroK8s | La Unidad 19 es crítica para distinguir Kubernetes estándar de supuestos locales: StorageClass, LoadBalancer, DNS, identidad y registro | Unidad 19 | Reforzar Unidad 19 con inventario formal de supuestos locales y plan de sustitución | Abierta |

## Siguiente decisión recomendada

`GAP-001` queda resuelta como referencia conceptual de Unidad 00, acompañada por un laboratorio de lectura y observacion de solo lectura.

`GAP-002` queda abordada como decisión pedagógica para la Unidad 09. La Unidad 02 conserva Secrets ficticios para aprender el objeto Kubernetes; la gestión real de secretos se explicará en Unidad 09 desde el patrón GitOps y se retomará en cloud y seguridad avanzada cuando aparezcan identidad, secret managers y controles de supply chain.

Siguiente decisión recomendada: revisar si alguna de las lagunas restantes debe resolverse antes de generar el playbook de Unidad 08 o si puede permanecer registrada para su unidad natural.
