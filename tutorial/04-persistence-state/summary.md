# Summary - Unidad 04

## Identificación

| Campo | Valor |
|---|---|
| Unidad | 04 - Persistencia y estado |
| Identificador | `04-persistence-state` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada, validada funcionalmente y aprobada; saneamiento documental de fase 4 aplicado y aprobado |
| Fecha de cierre o actualización | 2026-07-27 |
| Revisión pedagógica del usuario | Unidad aprobada el 2026-07-19; saneamiento documental de fase 4 aprobado el 2026-07-27 |

## Resumen ejecutivo

La Unidad 04 introduce persistencia en `platform-api` mediante un `PersistentVolumeClaim` llamado `platform-api-data`, montado en `/usr/share/nginx/html/persistent`.

La solución final queda en `labs/04-persistence-state/solution/` y conserva namespace `platform-training`, Deployment `platform-api`, ConfigMap, Secret ficticio, probes, requests/limits, Service `ClusterIP` e Ingress HTTP local heredados de Unidad 03. La unidad añade un PVC con `storageClassName: microk8s-hostpath` y documenta el addon local `hostpath-storage` de MicroK8s como dependencia de laboratorio.

La validación funcional se ejecutó correctamente en MicroK8s. El addon `hostpath-storage` quedó habilitado, la StorageClass `microk8s-hostpath` quedó disponible como default, el PVC `platform-api-data` quedó `Bound`, el volumen se montó en `platform-api`, el dato de laboratorio sobrevivió a la recreación de un Pod y el fichero persistente fue servido por Ingress.

El 2026-07-22 se añadió `tutorial/04-persistence-state/student-reference.md` como backfill documental del nuevo contrato global de unidades. La referencia profundiza en almacenamiento Kubernetes, PV, PVC, StorageClass, access modes, CSI, StatefulSet, headless Service, snapshots, backup, restore, límites de `hostpath-storage` y continuidad hacia cloud y fiabilidad. No modifica manifiestos, scripts, laboratorios ni estado técnico del clúster.

El 2026-07-27 se aplicó y aprobó el saneamiento documental de fase 4 sobre la Unidad 04 antes de ejecutar `TD-022`. Se regeneró `playbooks/units/04-persistence-state.md` contra el contrato documental cerrado y se ajustaron `README.md`, `student-notes.md` y `student-reference.md` desde ese playbook. `.work/detail.md` se usó solo como checklist de cobertura. No se modificaron laboratorios, manifiestos Kubernetes, scripts ni estado técnico del clúster, y no se ejecutaron validaciones funcionales nuevas. `GAP-004` queda cubierto documentalmente en cuanto a criterio de `StatefulSet`, headless Service y volumen por réplica, pero no cerrado funcionalmente hasta implementar y validar `TD-023`.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Reutilizar `platform-api`, `platform-training` y la solución de Unidad 03 | Alcanzado | `labs/04-persistence-state/solution/` conserva nombres y selectors base |
| Crear tutorial de entrada | Alcanzado | `tutorial/04-persistence-state/README.md` |
| Crear material pedagógico profundo | Alcanzado | `tutorial/04-persistence-state/student-notes.md` |
| Crear referencia profesional del alumno | Alcanzado documentalmente | `tutorial/04-persistence-state/student-reference.md` |
| Ajustar referencia profesional del alumno al contrato documental | Alcanzado documentalmente y aprobado | `tutorial/04-persistence-state/student-reference.md`; `GAP-004` cubierto como criterio y `TD-023` diferido como práctica |
| Crear notas del instructor | Alcanzado | `tutorial/04-persistence-state/instructor-notes.md` |
| Crear laboratorio operativo | Alcanzado | `labs/04-persistence-state/README.md` |
| Crear PVC de laboratorio | Alcanzado | `labs/04-persistence-state/solution/pvc.yaml` |
| Montar PVC en `platform-api` | Alcanzado en manifiestos | `labs/04-persistence-state/solution/deployment.yaml` |
| Conservar Service `ClusterIP` e Ingress local | Alcanzado | `labs/04-persistence-state/solution/service.yaml`, `labs/04-persistence-state/solution/ingress.yaml` |
| Crear validación de Unidad 04 | Alcanzado | `labs/04-persistence-state/validation/validate.sh` |
| Validar funcionalmente persistencia en MicroK8s | Alcanzado | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado en Unidad 00.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` heredados.
- Addons `dns` e `ingress` habilitados.
- Helm y Terraform disponibles como CLI, sin gestionar recursos del curso.
- No existía StorageClass disponible al inicio de la sesión.

## Aplicación

- `platform-api` existía como Deployment con dos réplicas.
- El Service `platform-api` era `ClusterIP`.
- Existian ConfigMap, Secret ficticio, probes, resources e Ingress desde Unidad 03.
- No existian PVC de `platform-api` creados por unidades anteriores.

## Automatizacion

- Existía `labs/03-networking-ingress/solution/` como estado final de Unidad 03.
- Existía `labs/03-networking-ingress/validation/validate.sh` como precondición funcional.
- No existian charts Helm ni modulos Terraform del curso.

## Observabilidad

- Estado, eventos, logs, EndpointSlice e Ingress estaban disponibles como diagnóstico nativo.
- No existía stack de observabilidad avanzada.

## Seguridad

- El Secret heredado contiene valores ficticios.
- No se versionaron credenciales reales, certificados privados, kubeconfigs ni datos sensibles.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 03 | `tutorial/03-networking-ingress/summary.md` | Continuidad técnica y decisiones |
| Student notes Unidad 03 | `tutorial/03-networking-ingress/student-notes.md` | Continuidad pedagógica |
| Manifiestos Unidad 03 | `labs/03-networking-ingress/solution/` | Base acumulativa de Unidad 04 |
| Validación Unidad 03 | `labs/03-networking-ingress/validation/validate.sh` | Precondición funcional |
| Playbook Unidad 04 | `playbooks/units/04-persistence-state.md` | Alcance, restricciones y criterios |

## Cambios introducidos

## Capacidades incorporadas

- persistencia de laboratorio mediante PVC;
- montaje persistente en `platform-api`;
- diferenciación entre configuración, Secret ficticio y dato persistente;
- procedimiento de escritura, lectura, recreación de Pod, copia y restauración básica;
- diagnóstico de StorageClass, PVC, PV, mount, permisos, Service e Ingress;
- comparación entre API Kubernetes estándar y almacenamiento local de MicroK8s.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 04 | `tutorial/04-persistence-state/README.md` | Guía conceptual del alumno |
| Student notes Unidad 04 | `tutorial/04-persistence-state/student-notes.md` | Material pedagógico profundo sobre persistencia |
| Student reference Unidad 04 | `tutorial/04-persistence-state/student-reference.md` | Referencia profesional sobre almacenamiento Kubernetes, CSI, StatefulSet, headless Service, `volumeClaimTemplates`, snapshots, backup y límites de hostpath |
| Instructor notes | `tutorial/04-persistence-state/instructor-notes.md` | Guía de impartición y evaluación |
| Summary Unidad 04 | `tutorial/04-persistence-state/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 04 | `labs/04-persistence-state/README.md` | Referencia operativa |
| Starter | `labs/04-persistence-state/starter/` | Punto de partida con PVC sin montaje en Deployment |
| Solution | `labs/04-persistence-state/solution/` | Estado final reutilizable por Unidad 05 |
| PVC | `labs/04-persistence-state/solution/pvc.yaml` | Solicitud de almacenamiento persistente |
| Validación | `labs/04-persistence-state/validation/validate.sh` | Comprobación de estado esperado y persistencia |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Playbook Unidad 04 | `playbooks/units/04-persistence-state.md` | Regenerado contra el contrato documental cerrado; declara `GAP-004`, `TD-023`, frontera notas/referencia y cobertura de `.work/detail.md` |
| Estado del proyecto | `project/project-state.md` | Registra Unidad 04 completada, aprobada pedagógicamente, validada funcionalmente y saneada documentalmente |
| Saneamiento documental de fase 4 | `tutorial/04-persistence-state/README.md`, `tutorial/04-persistence-state/student-notes.md`, `tutorial/04-persistence-state/student-reference.md`, `tutorial/04-persistence-state/summary.md` | Ajuste documental contra el contrato cerrado; sin cambios funcionales |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/04-persistence-state/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

labs/04-persistence-state/
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
| MicroK8s local | Heredado; no modificado por archivos generados | `project/project-state.md` |
| Addon DNS | Heredado | `microk8s status --wait-ready` |
| Addon Ingress | Heredado y validado por Unidad 03 | `bash labs/03-networking-ingress/validation/validate.sh` |
| Addon `hostpath-storage` | Habilitado | `microk8s enable hostpath-storage`; `microk8s status --wait-ready` |
| StorageClass `microk8s-hostpath` | Disponible como default | `kubectl get storageclass` |

## Aplicación

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicación evolutiva | Conservada como `platform-api` | `labs/04-persistence-state/solution/deployment.yaml` |
| Namespace | Conservado como `platform-training` | `labs/04-persistence-state/solution/namespace.yaml` |
| Deployment | Declara montaje del PVC en `/usr/share/nginx/html/persistent` | `labs/04-persistence-state/solution/deployment.yaml` |
| PVC | Declarado como `platform-api-data` | `labs/04-persistence-state/solution/pvc.yaml` |
| Service | Conservado como `ClusterIP` | `labs/04-persistence-state/solution/service.yaml` |
| Ingress | Conservado para `platform-api.local` | `labs/04-persistence-state/solution/ingress.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles y aceptados por dry-run cliente | `kubectl apply --dry-run=client -f labs/04-persistence-state/solution/` |
| Validación de laboratorio | Ejecutada correctamente | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |
| Helm charts | No creados | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` sin resultados |
| Terraform modules | No creados | `find . -path ./.git -prune -o -type f '(' -name '*.tf' -o -name '*.tfvars' ')' -print` sin resultados |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado | `labs/04-persistence-state/README.md` |
| Eventos | Documentados para diagnóstico | `labs/04-persistence-state/README.md` |
| PVC/PV/StorageClass | Documentados para diagnóstico | `tutorial/04-persistence-state/student-notes.md` |
| EndpointSlice e Ingress | Conservados como diagnóstico de red | `labs/04-persistence-state/validation/validate.sh` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Conservado con valores ficticios | `labs/04-persistence-state/solution/secret.yaml` |
| Datos persistentes | Solo datos inocuos de laboratorio documentados | `labs/04-persistence-state/README.md` |
| Credenciales reales | No versionadas | Revisión de manifiestos |
| Backup productivo | No incorporado | Diferido |

## Inventario relevante

## Namespaces

| Namespace | Proposito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/04-persistence-state/solution/deployment.yaml` | 2 réplicas disponibles cuando se aplique |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running` y `Ready` cuando PVC este Bound |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Proposito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable |
| EndpointSlice de `platform-api` | Interno del clúster | Evidencia de Pods Ready |
| `ingress/platform-api` | Host `platform-api.local`, path `/` | Entrada HTTP local hacia el Service |
| `/persistent/message.txt` | HTTP por Ingress cuando exista dato | Validar dato persistente desde fuera del clúster |

## Configuración, secretos y almacenamiento

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/04-persistence-state/solution/configmap.yaml` | Configuración no sensible y contenido HTML |
| Secret | `platform-api-secret`, `labs/04-persistence-state/solution/secret.yaml` | Valores ficticios; no contiene credenciales reales |
| PVC | `platform-api-data`, `labs/04-persistence-state/solution/pvc.yaml` | Solicitud de almacenamiento local de laboratorio |
| Mount | `/usr/share/nginx/html/persistent` | Ruta de datos persistentes de laboratorio |

## Herramientas y versiones

| Herramienta | Version validada | Metodo de comprobacion |
|---|---|---|
| Kubernetes | `v1.35.6` heredado | `project/project-state.md` |
| `kubectl` | `v1.35.6` heredado | `bash labs/03-networking-ingress/validation/validate.sh` |
| MicroK8s | `v1.35.6` heredado | `microk8s status --wait-ready` |
| Helm | `v3.21.0+ge0878d4` heredado | `project/project-state.md` |
| Terraform | `1.15.7` heredado | `project/project-state.md` |

## Decisiones tomadas

## D-04-01 - Persistencia como evolución de `platform-api`

`platform-api` se mantiene como aplicación evolutiva. No se crea una base de datos ni una aplicación alternativa.

## D-04-02 - PVC como interfaz principal

El alumno consume almacenamiento mediante `PersistentVolumeClaim`; no administra PV estático como camino principal.

## D-04-03 - MicroK8s hostpath aislado como detalle local

`microk8s-hostpath` se usa como StorageClass de laboratorio, pero no se presenta como equivalente productivo a storage cloud.

## D-04-04 - Recuperación básica, no backup productivo

La unidad incluye copia y restauración de un fichero inocuo, sin snapshots CSI, Velero, restic ni políticas RPO/RTO.

## D-04-05 - Deployment conservado

No se migra a StatefulSet porque `platform-api` no requiere identidad estable por réplica en esta unidad. StatefulSet queda como continuidad conceptual.

## D-04-06 - `TD-023` separado del saneamiento documental

La práctica de `StatefulSet`, headless Service y `volumeClaimTemplates` se mantiene como cierre funcional posterior de `GAP-004`. No forma parte del saneamiento documental de fase 4 porque implica crear un workload auxiliar, modificar laboratorio y ejecutar validación funcional.

## Cobertura de `.work/detail.md`

| Punto de cobertura | Estado | Evidencia |
|---|---|---|
| Almacenamiento efímero frente a persistente, `emptyDir` y access modes | Cubierto | `tutorial/04-persistence-state/student-notes.md`; `tutorial/04-persistence-state/student-reference.md` |
| PVC y aprovisionamiento dinámico mediante `microk8s-hostpath` | Cubierto como práctica existente | `labs/04-persistence-state/solution/pvc.yaml`; `tutorial/04-persistence-state/student-notes.md` |
| Desacoplamiento cloud y parametrización de StorageClass | Cubierto como criterio; práctica diferida | `tutorial/04-persistence-state/student-reference.md`; Helm en Unidad 06 y cloud en Unidades 20/21 |
| `reclaimPolicy`, `Retain`, `Delete` y estado huérfano | Reforzado como criterio; laguna real tratada sin práctica nueva | `tutorial/04-persistence-state/student-reference.md` |
| Resistencia y consistencia de datos | Cubierto parcialmente como práctica de recreación de Pod | El laboratorio valida persistencia tras recrear Pods; no simula fallo físico ni pérdida de nodo |

## Validaciones realizadas

| Validación | Resultado |
|---|---|
| Unidad 03 heredada | `bash labs/03-networking-ingress/validation/validate.sh`: 0 fallos, 0 avisos |
| Estado StorageClass inicial | `kubectl get storageclass`: sin recursos |
| Habilitación de hostpath-storage | `microk8s enable hostpath-storage`: StorageClass `microk8s-hostpath` creada |
| StorageClass tras habilitación | `kubectl get storageclass`: `microk8s-hostpath (default)` |
| Despliegue Unidad 04 | `kubectl apply -f labs/04-persistence-state/solution/`: recursos aplicados |
| Estado PVC/PV | PVC `platform-api-data` `Bound` a PV `pvc-d7b0bce5-dab0-40e4-9542-2bd9b4f3b638` |
| Persistencia funcional | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |
| Sintaxis Bash | `bash -n labs/04-persistence-state/validation/validate.sh`: 0 |
| Dry-run cliente | `kubectl apply --dry-run=client -f labs/04-persistence-state/solution/`: aceptado |
| Ausencia de charts Helm | Sin resultados |
| Ausencia de Terraform | Sin resultados |
| Búsqueda de secretos reales | Solo referencias a Secret ficticio heredado y texto pedagógico |
| Saneamiento documental de fase 4 | `git diff --check`: sin errores |

## Validaciones pendientes

- Ninguna validación funcional nueva se ejecutó durante el saneamiento documental de fase 4.
- Aprobación específica del usuario para el saneamiento documental de Unidad 04.
- Las validaciones Windows/WSL desde PowerShell siguen siendo validaciones por equipo al replicar el laboratorio, como en unidades anteriores.

## Limitaciones activas

- `hostpath-storage` es específico de MicroK8s y no portable a cloud.
- Los datos del laboratorio quedan ligados al nodo local.
- No se incorporan backups productivos, snapshots, cifrado, políticas de datos ni storage cloud.
- La aprobación pedagógica original de la unidad fue recibida el 2026-07-19; la aprobación específica del saneamiento documental fue recibida el 2026-07-27.

## Continuidad para Unidad 05

La Unidad 05 deberá reutilizar:

```text
labs/04-persistence-state/solution/
tutorial/04-persistence-state/summary.md
```

La Unidad 05 ya reutiliza la solución validada de Unidad 04 como base para scheduling, resiliencia y mantenimiento.

## Continuidad para el saneamiento

Tras aprobar el saneamiento documental de Unidad 04, el siguiente incremento permitido es la auditoría de autosuficiencia `TD-022`. La práctica funcional `TD-023` queda después de esa auditoría y antes de desbloquear la Unidad 08.
