# Summary - Unidad 04

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 04 - Persistencia y estado |
| Identificador | `04-persistence-state` |
| Fase del roadmap | Fase 2 - Fundamentos Kubernetes |
| Estado | Completada, validada funcionalmente y aprobada |
| Fecha de cierre o actualizacion | 2026-07-19 |
| Revision pedagogica del usuario | Aprobada el 2026-07-19 |

## Resumen ejecutivo

La Unidad 04 introduce persistencia en `platform-api` mediante un `PersistentVolumeClaim` llamado `platform-api-data`, montado en `/usr/share/nginx/html/persistent`.

La solucion final queda en `labs/04-persistence-state/solution/` y conserva namespace `platform-training`, Deployment `platform-api`, ConfigMap, Secret ficticio, probes, requests/limits, Service `ClusterIP` e Ingress HTTP local heredados de Unidad 03. La unidad anade un PVC con `storageClassName: microk8s-hostpath` y documenta el addon local `hostpath-storage` de MicroK8s como dependencia de laboratorio.

La validacion funcional se ejecuto correctamente en MicroK8s. El addon `hostpath-storage` quedo habilitado, la StorageClass `microk8s-hostpath` quedo disponible como default, el PVC `platform-api-data` quedo `Bound`, el volumen se monto en `platform-api`, el dato de laboratorio sobrevivio a la recreacion de un Pod y el fichero persistente fue servido por Ingress.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Reutilizar `platform-api`, `platform-training` y la solucion de Unidad 03 | Alcanzado | `labs/04-persistence-state/solution/` conserva nombres y selectors base |
| Crear tutorial de entrada | Alcanzado | `tutorial/04-persistence-state/README.md` |
| Crear material pedagogico profundo | Alcanzado | `tutorial/04-persistence-state/student-notes.md` |
| Crear notas del instructor | Alcanzado | `tutorial/04-persistence-state/instructor-notes.md` |
| Crear laboratorio operativo | Alcanzado | `labs/04-persistence-state/README.md` |
| Crear PVC de laboratorio | Alcanzado | `labs/04-persistence-state/solution/pvc.yaml` |
| Montar PVC en `platform-api` | Alcanzado en manifiestos | `labs/04-persistence-state/solution/deployment.yaml` |
| Conservar Service `ClusterIP` e Ingress local | Alcanzado | `labs/04-persistence-state/solution/service.yaml`, `labs/04-persistence-state/solution/ingress.yaml` |
| Crear validacion de Unidad 04 | Alcanzado | `labs/04-persistence-state/validation/validate.sh` |
| Validar funcionalmente persistencia en MicroK8s | Alcanzado | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |

## Estado inicial utilizado

## Plataforma

- Ubuntu 24.04.4 LTS sobre WSL2 validado en Unidad 00.
- MicroK8s `v1.35.6` y Kubernetes `v1.35.6` heredados.
- Addons `dns` e `ingress` habilitados.
- Helm y Terraform disponibles como CLI, sin gestionar recursos del curso.
- No existia StorageClass disponible al inicio de la sesion.

## Aplicacion

- `platform-api` existia como Deployment con dos replicas.
- El Service `platform-api` era `ClusterIP`.
- Existian ConfigMap, Secret ficticio, probes, resources e Ingress desde Unidad 03.
- No existian PVC de `platform-api` creados por unidades anteriores.

## Automatizacion

- Existia `labs/03-networking-ingress/solution/` como estado final de Unidad 03.
- Existia `labs/03-networking-ingress/validation/validate.sh` como precondicion funcional.
- No existian charts Helm ni modulos Terraform del curso.

## Observabilidad

- Estado, eventos, logs, EndpointSlice e Ingress estaban disponibles como diagnostico nativo.
- No existia stack de observabilidad avanzada.

## Seguridad

- El Secret heredado contiene valores ficticios.
- No se versionaron credenciales reales, certificados privados, kubeconfigs ni datos sensibles.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 03 | `tutorial/03-networking-ingress/summary.md` | Continuidad tecnica y decisiones |
| Student notes Unidad 03 | `tutorial/03-networking-ingress/student-notes.md` | Continuidad pedagogica |
| Manifiestos Unidad 03 | `labs/03-networking-ingress/solution/` | Base acumulativa de Unidad 04 |
| Validacion Unidad 03 | `labs/03-networking-ingress/validation/validate.sh` | Precondicion funcional |
| Playbook Unidad 04 | `playbooks/units/04-persistence-state.md` | Alcance, restricciones y criterios |

## Cambios introducidos

## Capacidades incorporadas

- persistencia de laboratorio mediante PVC;
- montaje persistente en `platform-api`;
- diferenciacion entre configuracion, Secret ficticio y dato persistente;
- procedimiento de escritura, lectura, recreacion de Pod, copia y restauracion basica;
- diagnostico de StorageClass, PVC, PV, mount, permisos, Service e Ingress;
- comparacion entre API Kubernetes estandar y almacenamiento local de MicroK8s.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 04 | `tutorial/04-persistence-state/README.md` | Guia conceptual del alumno |
| Student notes Unidad 04 | `tutorial/04-persistence-state/student-notes.md` | Material pedagogico profundo sobre persistencia |
| Instructor notes | `tutorial/04-persistence-state/instructor-notes.md` | Guia de imparticion y evaluacion |
| Summary Unidad 04 | `tutorial/04-persistence-state/summary.md` | Contrato de continuidad |
| Laboratorio Unidad 04 | `labs/04-persistence-state/README.md` | Referencia operativa |
| Starter | `labs/04-persistence-state/starter/` | Punto de partida con PVC sin montaje en Deployment |
| Solution | `labs/04-persistence-state/solution/` | Estado final reutilizable por Unidad 05 |
| PVC | `labs/04-persistence-state/solution/pvc.yaml` | Solicitud de almacenamiento persistente |
| Validacion | `labs/04-persistence-state/validation/validate.sh` | Comprobacion de estado esperado y persistencia |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Playbook Unidad 04 | `playbooks/units/04-persistence-state.md` | Marcado como aprobado por instruccion del usuario de generar la unidad |
| Estado del proyecto | `project/project-state.md` | Registra Unidad 04 completada, aprobada pedagogicamente y validada funcionalmente |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/04-persistence-state/
├── README.md
├── student-notes.md
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

## Estado tecnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s local | Heredado; no modificado por archivos generados | `project/project-state.md` |
| Addon DNS | Heredado | `microk8s status --wait-ready` |
| Addon Ingress | Heredado y validado por Unidad 03 | `bash labs/03-networking-ingress/validation/validate.sh` |
| Addon `hostpath-storage` | Habilitado | `microk8s enable hostpath-storage`; `microk8s status --wait-ready` |
| StorageClass `microk8s-hostpath` | Disponible como default | `kubectl get storageclass` |

## Aplicacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicacion evolutiva | Conservada como `platform-api` | `labs/04-persistence-state/solution/deployment.yaml` |
| Namespace | Conservado como `platform-training` | `labs/04-persistence-state/solution/namespace.yaml` |
| Deployment | Declara montaje del PVC en `/usr/share/nginx/html/persistent` | `labs/04-persistence-state/solution/deployment.yaml` |
| PVC | Declarado como `platform-api-data` | `labs/04-persistence-state/solution/pvc.yaml` |
| Service | Conservado como `ClusterIP` | `labs/04-persistence-state/solution/service.yaml` |
| Ingress | Conservado para `platform-api.local` | `labs/04-persistence-state/solution/ingress.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Manifiestos Kubernetes | Disponibles y aceptados por dry-run cliente | `kubectl apply --dry-run=client -f labs/04-persistence-state/solution/` |
| Validacion de laboratorio | Ejecutada correctamente | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |
| Helm charts | No creados | `find . -path ./.git -prune -o -type f -name 'Chart.yaml' -print` sin resultados |
| Terraform modules | No creados | `find . -path ./.git -prune -o -type f '(' -name '*.tf' -o -name '*.tfvars' ')' -print` sin resultados |

## Observabilidad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Estado Kubernetes | Documentado | `labs/04-persistence-state/README.md` |
| Eventos | Documentados para diagnostico | `labs/04-persistence-state/README.md` |
| PVC/PV/StorageClass | Documentados para diagnostico | `tutorial/04-persistence-state/student-notes.md` |
| EndpointSlice e Ingress | Conservados como diagnostico de red | `labs/04-persistence-state/validation/validate.sh` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Conservado con valores ficticios | `labs/04-persistence-state/solution/secret.yaml` |
| Datos persistentes | Solo datos inocuos de laboratorio documentados | `labs/04-persistence-state/README.md` |
| Credenciales reales | No versionadas | Revision de manifiestos |
| Backup productivo | No incorporado | Diferido |

## Inventario relevante

## Namespaces

| Namespace | Proposito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Aislar recursos funcionales del curso | No; heredado y redeclarado |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/04-persistence-state/solution/deployment.yaml` | 2 replicas disponibles cuando se aplique |
| Pods `platform-api-*` | `platform-training` | Generados por ReplicaSet | `Running` y `Ready` cuando PVC este Bound |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Proposito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 hacia contenedor 8080 | Acceso interno estable |
| EndpointSlice de `platform-api` | Interno del cluster | Evidencia de Pods Ready |
| `ingress/platform-api` | Host `platform-api.local`, path `/` | Entrada HTTP local hacia el Service |
| `/persistent/message.txt` | HTTP por Ingress cuando exista dato | Validar dato persistente desde fuera del cluster |

## Configuracion, secretos y almacenamiento

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `platform-api-config`, `labs/04-persistence-state/solution/configmap.yaml` | Configuracion no sensible y contenido HTML |
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

## D-04-01 - Persistencia como evolucion de `platform-api`

`platform-api` se mantiene como aplicacion evolutiva. No se crea una base de datos ni una aplicacion alternativa.

## D-04-02 - PVC como interfaz principal

El alumno consume almacenamiento mediante `PersistentVolumeClaim`; no administra PV estatico como camino principal.

## D-04-03 - MicroK8s hostpath aislado como detalle local

`microk8s-hostpath` se usa como StorageClass de laboratorio, pero no se presenta como equivalente productivo a storage cloud.

## D-04-04 - Recuperacion basica, no backup productivo

La unidad incluye copia y restauracion de un fichero inocuo, sin snapshots CSI, Velero, restic ni politicas RPO/RTO.

## D-04-05 - Deployment conservado

No se migra a StatefulSet porque `platform-api` no requiere identidad estable por replica en esta unidad. StatefulSet queda como continuidad conceptual.

## Validaciones realizadas

| Validacion | Resultado |
|---|---|
| Unidad 03 heredada | `bash labs/03-networking-ingress/validation/validate.sh`: 0 fallos, 0 avisos |
| Estado StorageClass inicial | `kubectl get storageclass`: sin recursos |
| Habilitacion de hostpath-storage | `microk8s enable hostpath-storage`: StorageClass `microk8s-hostpath` creada |
| StorageClass tras habilitacion | `kubectl get storageclass`: `microk8s-hostpath (default)` |
| Despliegue Unidad 04 | `kubectl apply -f labs/04-persistence-state/solution/`: recursos aplicados |
| Estado PVC/PV | PVC `platform-api-data` `Bound` a PV `pvc-d7b0bce5-dab0-40e4-9542-2bd9b4f3b638` |
| Persistencia funcional | `bash labs/04-persistence-state/validation/validate.sh`: 0 fallos, 0 avisos |
| Sintaxis Bash | `bash -n labs/04-persistence-state/validation/validate.sh`: 0 |
| Dry-run cliente | `kubectl apply --dry-run=client -f labs/04-persistence-state/solution/`: aceptado |
| Ausencia de charts Helm | Sin resultados |
| Ausencia de Terraform | Sin resultados |
| Busqueda de secretos reales | Solo referencias a Secret ficticio heredado y texto pedagogico |

## Validaciones pendientes

- Ninguna validacion funcional de la Unidad 04 queda pendiente en este entorno.
- Las validaciones Windows/WSL desde PowerShell siguen siendo validaciones por equipo al replicar el laboratorio, como en unidades anteriores.

## Limitaciones activas

- `hostpath-storage` es especifico de MicroK8s y no portable a cloud.
- Los datos del laboratorio quedan ligados al nodo local.
- No se incorporan backups productivos, snapshots, cifrado, politicas de datos ni storage cloud.
- La aprobacion pedagogica del usuario fue recibida el 2026-07-19.

## Continuidad para Unidad 05

La Unidad 05 debera reutilizar:

```text
labs/04-persistence-state/solution/
tutorial/04-persistence-state/summary.md
```

La Unidad 05 puede reutilizar la solucion validada de Unidad 04 como base para scheduling, resiliencia y mantenimiento.
