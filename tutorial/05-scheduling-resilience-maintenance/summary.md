# Summary - Unidad 05

## Identificación

| Campo | Valor |
|---|---|
| Unidad | 05 - Scheduling, resiliencia y mantenimiento |
| Identificador | `05-scheduling-resilience-maintenance` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada, validada funcionalmente y aprobada en sus guías del alumno; saneamiento documental de fase 4 aplicado y aprobado |
| Fecha de cierre o actualización | 2026-07-27 |
| Revisión pedagógica del usuario | Guías del alumno aprobadas el 2026-07-19; saneamiento documental de fase 4 aprobado el 2026-07-27 |

## Resumen ejecutivo

La Unidad 05 incorpora scheduling seguro, resiliencia básica y mantenimiento no destructivo sobre `platform-api`, reutilizando la salida validada de la Unidad 04.

La solución final queda en `labs/05-scheduling-resilience-maintenance/solution/` y conserva namespace `platform-training`, Deployment `platform-api`, ConfigMap, Secret ficticio, PVC `platform-api-data`, Service `ClusterIP` e Ingress HTTP local. La unidad añade un `PodDisruptionBudget` llamado `platform-api`, declara estrategia `RollingUpdate`, conserva dos réplicas y configura constraints compatibles con MicroK8s local.

La validación funcional se ejecutó correctamente en MicroK8s. El Deployment quedó disponible, el PDB mostró `minAvailable: 1` y `disruptionsAllowed: 1`, los Pods quedaron asignados al nodo local `gmktecg2`, el Service mantuvo endpoints, el Ingress sirvió contenido de Unidad 05 y la eliminación controlada de un Pod fue recuperada por el Deployment.

El 2026-07-22 se añadió `tutorial/05-scheduling-resilience-maintenance/student-reference.md` como backfill documental del nuevo contrato global de unidades. La referencia profundiza en scheduler, node labels, `nodeSelector`, affinity, anti-affinity, taints, tolerations, requests, PVC y topología, `RollingUpdate`, rollback, PDB, mantenimiento, alta disponibilidad real, cloud y límites de MicroK8s local. No modifica manifiestos, scripts, laboratorios ni estado técnico del clúster.

El 2026-07-27 se aplicó el saneamiento documental de fase 4 sobre la Unidad 05. Se regeneró `playbooks/units/05-scheduling-resilience-maintenance.md` contra el contrato documental cerrado, se ajustaron `tutorial/05-scheduling-resilience-maintenance/README.md`, `student-notes.md` y `student-reference.md` desde ese playbook, y se confirmó la cobertura de scheduler, filtrado, puntuación, affinity, anti-affinity, taints, tolerations, PDB, `drain`, `cordon`, `uncordon`, alta disponibilidad real y límites de MicroK8s local. `.work/detail.md` se usó solo como checklist de cobertura. No se modificaron laboratorios, manifiestos Kubernetes, scripts ni estado técnico del clúster, no se crearon workloads y no se ejecutaron validaciones funcionales nuevas.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Reutilizar `platform-api`, `platform-training` y la solución de Unidad 04 | Alcanzado | `labs/05-scheduling-resilience-maintenance/starter/` y `solution/` derivan de `labs/04-persistence-state/solution/` |
| Crear tutorial de entrada | Alcanzado | `tutorial/05-scheduling-resilience-maintenance/README.md` |
| Crear material pedagógico profundo | Alcanzado | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` |
| Crear referencia profesional del alumno | Alcanzado documentalmente y aprobado | `tutorial/05-scheduling-resilience-maintenance/student-reference.md` |
| Crear notas del instructor | Alcanzado | `tutorial/05-scheduling-resilience-maintenance/instructor-notes.md` |
| Crear laboratorio operativo | Alcanzado | `labs/05-scheduling-resilience-maintenance/README.md` |
| Crear PDB de `platform-api` | Alcanzado | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` |
| Declarar estrategia de rolling update | Alcanzado | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` |
| Mantener probes, resources, PVC, Service e Ingress heredados | Alcanzado | `labs/05-scheduling-resilience-maintenance/solution/` |
| Validar scheduling seguro y recuperación de Pod | Alcanzado | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 fallos, 0 avisos |
| Evitar Helm, Terraform, drain, borrado de PVC y recursos cloud | Alcanzado | Revisión de artefactos y validaciones estáticas |
| Regenerar playbook contra contrato documental | Alcanzado documentalmente | `playbooks/units/05-scheduling-resilience-maintenance.md` |
| Ajustar referencia del alumno contra contrato documental | Alcanzado documentalmente | `tutorial/05-scheduling-resilience-maintenance/student-reference.md` |
| Mantener laboratorios y manifiestos sin cambios en fase 4 | Alcanzado | Revisión documental; no se modificó `labs/05-scheduling-resilience-maintenance/` |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` disponibles.
- Addons `dns`, `ingress` y `hostpath-storage` habilitados.
- Nodo local `gmktecg2` en estado `Ready`.
- Helm y Terraform disponibles como CLI, sin gestionar recursos del curso.

## Aplicación

- `platform-api` existía como Deployment con dos réplicas.
- El Service `platform-api` era `ClusterIP`.
- Existían ConfigMap, Secret ficticio, probes, resources, Ingress y PVC desde Unidad 04.
- PVC `platform-api-data` estaba `Bound` a `microk8s-hostpath`.
- No existían PDB de `platform-api` previos a esta unidad.

## Automatización

- Existía `labs/04-persistence-state/solution/` como estado final de Unidad 04.
- Existía `labs/04-persistence-state/validation/validate.sh` como precondición funcional.
- No existían charts Helm ni módulos Terraform del curso.

## Observabilidad

- Estado, eventos, logs, EndpointSlice, Ingress, PVC y rollout estaban disponibles como diagnóstico nativo.
- No existía stack de observabilidad avanzada.

## Seguridad

- El Secret heredado contiene valores ficticios.
- No se versionaron credenciales reales, certificados privados, kubeconfigs ni datos sensibles.
- Las operaciones de nodo destructivas quedaron fuera de la validación.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 04 | `tutorial/04-persistence-state/summary.md` | Continuidad técnica y decisiones |
| Student notes Unidad 04 | `tutorial/04-persistence-state/student-notes.md` | Continuidad pedagógica sobre persistencia |
| Manifiestos Unidad 04 | `labs/04-persistence-state/solution/` | Base acumulativa de Unidad 05 |
| Validación Unidad 04 | `labs/04-persistence-state/validation/validate.sh` | Precondición funcional |
| Playbook Unidad 05 | `playbooks/units/05-scheduling-resilience-maintenance.md` | Alcance, restricciones y criterios |

## Cambios introducidos

## Capacidades incorporadas

- scheduling básico observable mediante labels, `nodeSelector`, affinity preferida y eventos;
- anti-affinity preferida para intentar separar réplicas sin bloquear un clúster de un nodo;
- `PodDisruptionBudget` para interrupciones voluntarias;
- estrategia explícita `RollingUpdate`;
- historial de revisiones limitado;
- validación de rollout, PDB, Pods asignados, EndpointSlice, Ingress y PVC;
- simulación no destructiva de recuperación tras eliminar un Pod;
- diagnóstico documentado de Pods `Pending`, constraints imposibles y rollouts bloqueados.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/README.md` | Guía conceptual del alumno |
| Student notes Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` | Material pedagógico profundo sobre scheduling y resiliencia |
| Student reference Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/student-reference.md` | Referencia profesional sobre scheduling, PDB, rollouts, mantenimiento, HA real, cloud y límites de MicroK8s |
| Instructor notes | `tutorial/05-scheduling-resilience-maintenance/instructor-notes.md` | Guía de impartición y evaluación |
| Summary Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 05 | `labs/05-scheduling-resilience-maintenance/README.md` | Referencia operativa |
| Starter | `labs/05-scheduling-resilience-maintenance/starter/` | Punto de partida heredado de Unidad 04 |
| Solution | `labs/05-scheduling-resilience-maintenance/solution/` | Estado final reutilizable por Unidad 06 |
| PDB | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` | Presupuesto de interrupción voluntaria |
| Validación | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Comprobación de estado esperado y recuperación controlada |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Deployment | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | Añade `strategy`, `revisionHistoryLimit`, `minReadySeconds`, `nodeSelector`, node affinity preferida y pod anti-affinity preferida |
| ConfigMap | `labs/05-scheduling-resilience-maintenance/solution/configmap.yaml` | Actualiza texto visible y `FEATURE_GREETING` para Unidad 05 |
| Manifiestos heredados | `labs/05-scheduling-resilience-maintenance/solution/*.yaml` | Actualizan label de unidad a `"05"` y conservan contrato funcional |
| Estado del proyecto | `project/project-state.md` | Registra Unidad 05 generada, validada funcionalmente, saneada documentalmente y aprobada |
| Saneamiento documental de fase 4 | `playbooks/units/05-scheduling-resilience-maintenance.md`, `tutorial/05-scheduling-resilience-maintenance/README.md`, `tutorial/05-scheduling-resilience-maintenance/student-notes.md`, `tutorial/05-scheduling-resilience-maintenance/student-reference.md`, `tutorial/05-scheduling-resilience-maintenance/summary.md` | Regeneración del playbook y ajuste documental contra el contrato cerrado; sin cambios funcionales |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/05-scheduling-resilience-maintenance/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

labs/05-scheduling-resilience-maintenance/
├── README.md
├── starter/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
├── solution/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── pvc.yaml
│   ├── pdb.yaml
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── validation/
    └── validate.sh
```

## Estado técnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Validado | `bash platform/environment/validation/validate-environment.sh`: 0 fallos, 0 avisos |
| Kubernetes | `v1.35.6` | `kubectl get nodes --show-labels` |
| Nodo local | `gmktecg2` `Ready` | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh` |
| Addon Ingress | Heredado y activo | HTTP por Ingress validado |
| Addon `hostpath-storage` | Heredado y activo | PVC `platform-api-data` `Bound` |

## Aplicación

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicación evolutiva | Conservada como `platform-api` | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` |
| Namespace | Conservado como `platform-training` | `labs/05-scheduling-resilience-maintenance/solution/namespace.yaml` |
| Deployment | 2 réplicas, `RollingUpdate`, constraints seguros y rollout disponible | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh` |
| PDB | `minAvailable: 1`, `disruptionsAllowed: 1` observado | `kubectl -n platform-training get pdb platform-api` |
| PVC | `platform-api-data` `Bound` | `kubectl -n platform-training get pvc platform-api-data` |
| Service | Conservado como `ClusterIP` | `labs/05-scheduling-resilience-maintenance/solution/service.yaml` |
| Ingress | Conservado para `platform-api.local` | `labs/05-scheduling-resilience-maintenance/solution/ingress.yaml` |

## Automatización

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles y aceptados por dry-run cliente | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/` |
| Validación de laboratorio | Ejecutada correctamente | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 fallos, 0 avisos |
| Helm charts | No creados | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` sin resultados |
| Terraform modules | No creados | `find . -path ./.git -prune -o -type f '(' -name '*.tf' -o -name '*.tfvars' ')' -print` sin resultados |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado y validado | `kubectl -n platform-training get deploy,rs,pods,svc,endpointslice,ingress,pvc,pdb` |
| Eventos de scheduling | Documentados | `labs/05-scheduling-resilience-maintenance/README.md` |
| EndpointSlice | Validado con endpoints | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh` |
| Rollout history | Validado como legible | `kubectl -n platform-training rollout history deployment/platform-api` |
| Observabilidad avanzada | No incorporada | Diferida |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Conservado con valores ficticios | `labs/05-scheduling-resilience-maintenance/solution/secret.yaml` |
| Credenciales reales | No versionadas | Revisión de manifiestos |
| Operaciones destructivas de nodo | No automatizadas | `validation/validate.sh` no ejecuta `drain`, taints ni reset |
| PVC | Conservado; no se borra en validación | `validation/validate.sh` |

## Inventario relevante

## Namespaces

| Namespace | Propósito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |

## Workloads

| Recurso | Namespace | Ruta de definición | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | 2 réplicas disponibles cuando se aplique |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running`, `Ready` y asignados a nodo |
| `poddisruptionbudget/platform-api` | `platform-training` | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` | `minAvailable: 1` |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Propósito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable |
| EndpointSlice de `platform-api` | Interno del clúster | Evidencia de Pods Ready |
| `ingress/platform-api` | Host `platform-api.local`, path `/` | Entrada HTTP local hacia el Service |
| `/persistent/message.txt` | HTTP por Ingress cuando exista dato | Validar persistencia heredada |

## Configuración, secretos y almacenamiento

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/05-scheduling-resilience-maintenance/solution/configmap.yaml` | Configuración no sensible y contenido HTML |
| Secret | `platform-api-secret`, `labs/05-scheduling-resilience-maintenance/solution/secret.yaml` | Valores ficticios; no contiene credenciales reales |
| PVC | `platform-api-data`, `labs/05-scheduling-resilience-maintenance/solution/pvc.yaml` | Solicitud de almacenamiento local de laboratorio |
| Scheduling | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | `nodeSelector` Linux y affinity preferida |

## Herramientas y versiones

| Herramienta | Versión validada | Método de comprobación |
|---|---|---|
| Kubernetes | `v1.35.6` | `bash platform/environment/validation/validate-environment.sh` |
| `kubectl` | `v1.35.6` | `bash platform/environment/validation/validate-environment.sh` |
| MicroK8s | `v1.35.6` | `bash platform/environment/validation/validate-environment.sh` |
| Helm | `v3.21.0+ge0878d4` | `bash platform/environment/validation/validate-environment.sh` |
| Terraform | `1.15.7` | `bash platform/environment/validation/validate-environment.sh` |

## Decisiones tomadas

## D-05-01 - Resiliencia explicada desde el Deployment existente

`platform-api` se mantiene como aplicación evolutiva. No se crea workload alternativo.

## D-05-02 - Constraints no bloqueantes

La solución final usa `nodeSelector` seguro y affinity preferida. La anti-affinity obligatoria queda fuera del estado final porque MicroK8s local puede tener un solo nodo.

## D-05-03 - PDB como protección limitada

`poddisruptionbudget/platform-api` usa `minAvailable: 1`. Se documenta como protección ante interrupciones voluntarias, no como garantía ante fallos involuntarios.

## D-05-04 - Rollout y rollback nativos

La unidad usa `kubectl rollout` y Deployment nativo antes de introducir Helm.

## D-05-05 - Mantenimiento seguro

La validación automática elimina un Pod gestionado por Deployment, pero no ejecuta `drain`, no modifica taints y no borra PVC.

## D-05-06 - Laboratorio acumulativo con ruta propia

`labs/05-scheduling-resilience-maintenance/solution/` es la nueva base prevista para Unidad 06.

## Validaciones realizadas

| Validación | Resultado |
|---|---|
| Entorno integrado | `bash platform/environment/validation/validate-environment.sh`: 0 fallos, 0 avisos |
| Unidad 04 heredada | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |
| Sintaxis Bash | `bash -n labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 |
| Dry-run cliente | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/`: aceptado |
| Despliegue Unidad 05 | `kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/`: recursos aplicados |
| Validación funcional Unidad 05 | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 fallos, 0 avisos |
| PDB | `platform-api` con `minAvailable: 1` y `disruptionsAllowed: 1` |
| Recuperación de Pod | Pod eliminado y Deployment recuperado correctamente |
| HTTP por Ingress | Respuesta contiene `Unidad 05` |
| Ausencia de charts Helm | Sin resultados |
| Ausencia de Terraform | Sin resultados |

## Validaciones pendientes

- Auditoría de autosuficiencia `TD-022` posterior al cierre de la Unidad 05.
- Validaciones Windows/WSL desde PowerShell siguen siendo validaciones por equipo al replicar el laboratorio.
- `shellcheck` no se ejecutó porque no está disponible en este entorno.
- Validaciones funcionales nuevas de fase 4 no ejecutadas por restricción explícita del alcance.

## Limitaciones activas

- El clúster validado tiene un solo nodo `gmktecg2`; no demuestra alta disponibilidad multi-nodo.
- `hostpath-storage` y el PVC local siguen siendo específicos de MicroK8s y no portables a cloud.
- El PDB no protege ante fallos involuntarios de nodo, proceso o almacenamiento.
- No se ejecuta `kubectl drain` como validación automática.
- El saneamiento documental de fase 4 no modificó `labs/05-scheduling-resilience-maintenance/`, no creó workloads nuevos y no cambió manifiestos Kubernetes.

## Cobertura contra `.work/detail.md`

| Punto de cobertura | Estado | Dónde queda cubierto | Reparto documental |
|---|---|---|---|
| Mecánica interna del scheduler, filtrado, puntuación y `nodeSelector` | Cubierto | `playbooks/units/05-scheduling-resilience-maintenance.md`; `student-reference.md`; `student-notes.md`; `labs/05-scheduling-resilience-maintenance/README.md` | Práctica existente para `nodeSelector`; criterio profesional en referencia |
| Affinity y anti-affinity con expresiones estrictas y blandas | Cubierto | `playbooks/units/05-scheduling-resilience-maintenance.md`; `student-reference.md`; `deployment.yaml` existente | Práctica parcial con preferencias; reglas estrictas como criterio, sin modificar manifiestos |
| Taints y tolerations para segregación de workloads | Cubierto | `playbooks/units/05-scheduling-resilience-maintenance.md`; `student-reference.md`; `student-notes.md` | Criterio conceptual; no se aplican taints a nodos ni se crean workloads |
| PDB para disponibilidad durante mantenimiento | Cubierto con corrección conceptual | `pdb.yaml` existente; `student-reference.md`; `student-notes.md` | Práctica existente; la referencia aclara que no protege caídas imprevistas |
| `drain`, `cordon` y `uncordon` | Cubierto como exclusión anclada | `playbooks/units/05-scheduling-resilience-maintenance.md`; `student-reference.md`; `labs/05-scheduling-resilience-maintenance/README.md` | Criterio profesional y diagnóstico operativo; práctica real diferida a Unidades 22 y 23 |

## Continuidad para Unidad 06

La Unidad 06 deberá reutilizar:

```text
labs/05-scheduling-resilience-maintenance/solution/
tutorial/05-scheduling-resilience-maintenance/summary.md
```

La Unidad 06 puede introducir Helm sobre una base que ya incluye Namespace, ConfigMap, Secret ficticio, PVC, Deployment con rollout y scheduling seguro, PDB, Service, Ingress y validación no destructiva.
