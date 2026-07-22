# Summary - Unidad 05

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 05 - Scheduling, resiliencia y mantenimiento |
| Identificador | `05-scheduling-resilience-maintenance` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada con revision pedagogica pendiente |
| Fecha de cierre o actualizacion | 2026-07-22 |
| Revision pedagogica del usuario | Pendiente; `student-reference.md` añadido posteriormente con aprobación pedagógica específica pendiente |

## Resumen ejecutivo

La Unidad 05 incorpora scheduling seguro, resiliencia basica y mantenimiento no destructivo sobre `platform-api`, reutilizando la salida validada de la Unidad 04.

La solucion final queda en `labs/05-scheduling-resilience-maintenance/solution/` y conserva namespace `platform-training`, Deployment `platform-api`, ConfigMap, Secret ficticio, PVC `platform-api-data`, Service `ClusterIP` e Ingress HTTP local. La unidad anade un `PodDisruptionBudget` llamado `platform-api`, declara estrategia `RollingUpdate`, conserva dos replicas y configura constraints compatibles con MicroK8s local.

La validacion funcional se ejecuto correctamente en MicroK8s. El Deployment quedo disponible, el PDB mostro `minAvailable: 1` y `disruptionsAllowed: 1`, los Pods quedaron asignados al nodo local `gmktecg2`, el Service mantuvo endpoints, el Ingress sirvio contenido de Unidad 05 y la eliminacion controlada de un Pod fue recuperada por el Deployment.

El 2026-07-22 se añadió `tutorial/05-scheduling-resilience-maintenance/student-reference.md` como backfill documental del nuevo contrato global de unidades. La referencia profundiza en scheduler, node labels, `nodeSelector`, affinity, anti-affinity, taints, tolerations, requests, PVC y topología, `RollingUpdate`, rollback, PDB, mantenimiento, alta disponibilidad real, cloud y límites de MicroK8s local. No modifica manifiestos, scripts, laboratorios ni estado técnico del clúster.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Reutilizar `platform-api`, `platform-training` y la solucion de Unidad 04 | Alcanzado | `labs/05-scheduling-resilience-maintenance/starter/` y `solution/` derivan de `labs/04-persistence-state/solution/` |
| Crear tutorial de entrada | Alcanzado | `tutorial/05-scheduling-resilience-maintenance/README.md` |
| Crear material pedagogico profundo | Alcanzado | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` |
| Crear referencia profesional del alumno | Alcanzado documentalmente con aprobación pendiente | `tutorial/05-scheduling-resilience-maintenance/student-reference.md` |
| Crear notas del instructor | Alcanzado | `tutorial/05-scheduling-resilience-maintenance/instructor-notes.md` |
| Crear laboratorio operativo | Alcanzado | `labs/05-scheduling-resilience-maintenance/README.md` |
| Crear PDB de `platform-api` | Alcanzado | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` |
| Declarar estrategia de rolling update | Alcanzado | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` |
| Mantener probes, resources, PVC, Service e Ingress heredados | Alcanzado | `labs/05-scheduling-resilience-maintenance/solution/` |
| Validar scheduling seguro y recuperacion de Pod | Alcanzado | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 fallos, 0 avisos |
| Evitar Helm, Terraform, drain, borrado de PVC y recursos cloud | Alcanzado | Revision de artefactos y validaciones estaticas |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` disponibles.
- Addons `dns`, `ingress` y `hostpath-storage` habilitados.
- Nodo local `gmktecg2` en estado `Ready`.
- Helm y Terraform disponibles como CLI, sin gestionar recursos del curso.

## Aplicacion

- `platform-api` existia como Deployment con dos replicas.
- El Service `platform-api` era `ClusterIP`.
- Existian ConfigMap, Secret ficticio, probes, resources, Ingress y PVC desde Unidad 04.
- PVC `platform-api-data` estaba `Bound` a `microk8s-hostpath`.
- No existian PDB de `platform-api` previos a esta unidad.

## Automatizacion

- Existia `labs/04-persistence-state/solution/` como estado final de Unidad 04.
- Existia `labs/04-persistence-state/validation/validate.sh` como precondicion funcional.
- No existian charts Helm ni modulos Terraform del curso.

## Observabilidad

- Estado, eventos, logs, EndpointSlice, Ingress, PVC y rollout estaban disponibles como diagnostico nativo.
- No existia stack de observabilidad avanzada.

## Seguridad

- El Secret heredado contiene valores ficticios.
- No se versionaron credenciales reales, certificados privados, kubeconfigs ni datos sensibles.
- Las operaciones de nodo destructivas quedaron fuera de la validacion.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 04 | `tutorial/04-persistence-state/summary.md` | Continuidad tecnica y decisiones |
| Student notes Unidad 04 | `tutorial/04-persistence-state/student-notes.md` | Continuidad pedagogica sobre persistencia |
| Manifiestos Unidad 04 | `labs/04-persistence-state/solution/` | Base acumulativa de Unidad 05 |
| Validacion Unidad 04 | `labs/04-persistence-state/validation/validate.sh` | Precondicion funcional |
| Playbook Unidad 05 | `playbooks/units/05-scheduling-resilience-maintenance.md` | Alcance, restricciones y criterios |

## Cambios introducidos

## Capacidades incorporadas

- scheduling basico observable mediante labels, `nodeSelector`, affinity preferida y eventos;
- anti-affinity preferida para intentar separar replicas sin bloquear un cluster de un nodo;
- `PodDisruptionBudget` para interrupciones voluntarias;
- estrategia explicita `RollingUpdate`;
- historial de revisiones limitado;
- validacion de rollout, PDB, Pods asignados, EndpointSlice, Ingress y PVC;
- simulacion no destructiva de recuperacion tras eliminar un Pod;
- diagnostico documentado de Pods `Pending`, constraints imposibles y rollouts bloqueados.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/README.md` | Guia conceptual del alumno |
| Student notes Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` | Material pedagogico profundo sobre scheduling y resiliencia |
| Student reference Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/student-reference.md` | Referencia profesional sobre scheduling, PDB, rollouts, mantenimiento, HA real, cloud y límites de MicroK8s |
| Instructor notes | `tutorial/05-scheduling-resilience-maintenance/instructor-notes.md` | Guia de imparticion y evaluacion |
| Summary Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 05 | `labs/05-scheduling-resilience-maintenance/README.md` | Referencia operativa |
| Starter | `labs/05-scheduling-resilience-maintenance/starter/` | Punto de partida heredado de Unidad 04 |
| Solution | `labs/05-scheduling-resilience-maintenance/solution/` | Estado final reutilizable por Unidad 06 |
| PDB | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` | Presupuesto de interrupcion voluntaria |
| Validacion | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Comprobacion de estado esperado y recuperacion controlada |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Deployment | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | Anade `strategy`, `revisionHistoryLimit`, `minReadySeconds`, `nodeSelector`, node affinity preferida y pod anti-affinity preferida |
| ConfigMap | `labs/05-scheduling-resilience-maintenance/solution/configmap.yaml` | Actualiza texto visible y `FEATURE_GREETING` para Unidad 05 |
| Manifiestos heredados | `labs/05-scheduling-resilience-maintenance/solution/*.yaml` | Actualizan label de unidad a `"05"` y conservan contrato funcional |
| Estado del proyecto | `project/project-state.md` | Registra Unidad 05 generada y validada funcionalmente, con aprobacion pedagogica pendiente |

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

## Estado tecnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Validado | `bash platform/environment/validation/validate-environment.sh`: 0 fallos, 0 avisos |
| Kubernetes | `v1.35.6` | `kubectl get nodes --show-labels` |
| Nodo local | `gmktecg2` `Ready` | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh` |
| Addon Ingress | Heredado y activo | HTTP por Ingress validado |
| Addon `hostpath-storage` | Heredado y activo | PVC `platform-api-data` `Bound` |

## Aplicacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicacion evolutiva | Conservada como `platform-api` | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` |
| Namespace | Conservado como `platform-training` | `labs/05-scheduling-resilience-maintenance/solution/namespace.yaml` |
| Deployment | 2 replicas, `RollingUpdate`, constraints seguros y rollout disponible | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh` |
| PDB | `minAvailable: 1`, `disruptionsAllowed: 1` observado | `kubectl -n platform-training get pdb platform-api` |
| PVC | `platform-api-data` `Bound` | `kubectl -n platform-training get pvc platform-api-data` |
| Service | Conservado como `ClusterIP` | `labs/05-scheduling-resilience-maintenance/solution/service.yaml` |
| Ingress | Conservado para `platform-api.local` | `labs/05-scheduling-resilience-maintenance/solution/ingress.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles y aceptados por dry-run cliente | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/` |
| Validacion de laboratorio | Ejecutada correctamente | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 fallos, 0 avisos |
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
| Credenciales reales | No versionadas | Revision de manifiestos |
| Operaciones destructivas de nodo | No automatizadas | `validation/validate.sh` no ejecuta `drain`, taints ni reset |
| PVC | Conservado; no se borra en validacion | `validation/validate.sh` |

## Inventario relevante

## Namespaces

| Namespace | Proposito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | 2 replicas disponibles cuando se aplique |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running`, `Ready` y asignados a nodo |
| `poddisruptionbudget/platform-api` | `platform-training` | `labs/05-scheduling-resilience-maintenance/solution/pdb.yaml` | `minAvailable: 1` |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Proposito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable |
| EndpointSlice de `platform-api` | Interno del cluster | Evidencia de Pods Ready |
| `ingress/platform-api` | Host `platform-api.local`, path `/` | Entrada HTTP local hacia el Service |
| `/persistent/message.txt` | HTTP por Ingress cuando exista dato | Validar persistencia heredada |

## Configuracion, secretos y almacenamiento

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/05-scheduling-resilience-maintenance/solution/configmap.yaml` | Configuracion no sensible y contenido HTML |
| Secret | `platform-api-secret`, `labs/05-scheduling-resilience-maintenance/solution/secret.yaml` | Valores ficticios; no contiene credenciales reales |
| PVC | `platform-api-data`, `labs/05-scheduling-resilience-maintenance/solution/pvc.yaml` | Solicitud de almacenamiento local de laboratorio |
| Scheduling | `labs/05-scheduling-resilience-maintenance/solution/deployment.yaml` | `nodeSelector` Linux y affinity preferida |

## Herramientas y versiones

| Herramienta | Version validada | Metodo de comprobacion |
|---|---|---|
| Kubernetes | `v1.35.6` | `bash platform/environment/validation/validate-environment.sh` |
| `kubectl` | `v1.35.6` | `bash platform/environment/validation/validate-environment.sh` |
| MicroK8s | `v1.35.6` | `bash platform/environment/validation/validate-environment.sh` |
| Helm | `v3.21.0+ge0878d4` | `bash platform/environment/validation/validate-environment.sh` |
| Terraform | `1.15.7` | `bash platform/environment/validation/validate-environment.sh` |

## Decisiones tomadas

## D-05-01 - Resiliencia explicada desde el Deployment existente

`platform-api` se mantiene como aplicacion evolutiva. No se crea workload alternativo.

## D-05-02 - Constraints no bloqueantes

La solucion final usa `nodeSelector` seguro y affinity preferida. La anti-affinity obligatoria queda fuera del estado final porque MicroK8s local puede tener un solo nodo.

## D-05-03 - PDB como proteccion limitada

`poddisruptionbudget/platform-api` usa `minAvailable: 1`. Se documenta como proteccion ante interrupciones voluntarias, no como garantia ante fallos involuntarios.

## D-05-04 - Rollout y rollback nativos

La unidad usa `kubectl rollout` y Deployment nativo antes de introducir Helm.

## D-05-05 - Mantenimiento seguro

La validacion automatica elimina un Pod gestionado por Deployment, pero no ejecuta `drain`, no modifica taints y no borra PVC.

## D-05-06 - Laboratorio acumulativo con ruta propia

`labs/05-scheduling-resilience-maintenance/solution/` es la nueva base prevista para Unidad 06.

## Validaciones realizadas

| Validacion | Resultado |
|---|---|
| Entorno integrado | `bash platform/environment/validation/validate-environment.sh`: 0 fallos, 0 avisos |
| Unidad 04 heredada | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |
| Sintaxis Bash | `bash -n labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 |
| Dry-run cliente | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/`: aceptado |
| Despliegue Unidad 05 | `kubectl apply -f labs/05-scheduling-resilience-maintenance/solution/`: recursos aplicados |
| Validacion funcional Unidad 05 | `bash labs/05-scheduling-resilience-maintenance/validation/validate.sh`: 0 fallos, 0 avisos |
| PDB | `platform-api` con `minAvailable: 1` y `disruptionsAllowed: 1` |
| Recuperacion de Pod | Pod eliminado y Deployment recuperado correctamente |
| HTTP por Ingress | Respuesta contiene `Unidad 05` |
| Ausencia de charts Helm | Sin resultados |
| Ausencia de Terraform | Sin resultados |

## Validaciones pendientes

- Revision pedagogica y aprobacion final del usuario.
- Validaciones Windows/WSL desde PowerShell siguen siendo validaciones por equipo al replicar el laboratorio.
- `shellcheck` no se ejecuto porque no esta disponible en este entorno.

## Limitaciones activas

- El cluster validado tiene un solo nodo `gmktecg2`; no demuestra alta disponibilidad multi-nodo.
- `hostpath-storage` y el PVC local siguen siendo especificos de MicroK8s y no portables a cloud.
- El PDB no protege ante fallos involuntarios de nodo, proceso o almacenamiento.
- No se ejecuta `kubectl drain` como validacion automatica.
- La aprobacion pedagogica del usuario queda pendiente.

## Continuidad para Unidad 06

La Unidad 06 debera reutilizar:

```text
labs/05-scheduling-resilience-maintenance/solution/
tutorial/05-scheduling-resilience-maintenance/summary.md
```

La Unidad 06 puede introducir Helm sobre una base que ya incluye Namespace, ConfigMap, Secret ficticio, PVC, Deployment con rollout y scheduling seguro, PDB, Service, Ingress y validacion no destructiva.
