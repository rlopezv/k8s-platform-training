# Summary - Unidad 06

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 06 - Empaquetado con Helm |
| Identificador | `06-helm-packaging` |
| Fase del roadmap | Fase 3 - Empaquetado e infraestructura como codigo |
| Estado | Completada y validada funcionalmente con revision pedagogica pendiente |
| Fecha de cierre o actualizacion | 2026-07-19 |
| Revision pedagogica del usuario | Pendiente |

## Resumen ejecutivo

La Unidad 06 incorpora Helm como mecanismo de empaquetado, parametrizacion y gestion de releases para `platform-api`. La unidad reutiliza `labs/05-scheduling-resilience-maintenance/solution/` y convierte sus manifiestos en un chart local ubicado en `labs/06-helm-packaging/chart/platform-api/`.

El chart conserva el contrato funcional acumulado: namespace `platform-training`, Deployment `platform-api`, ConfigMap, Secret ficticio, PVC `platform-api-data`, Service `ClusterIP`, Ingress `platform-api.local`, PDB, probes, resources, rollout y scheduling seguro. El release local documentado se llama `platform-api-local`.

La unidad deja preparado el paso a Terraform en la Unidad 07, pero no crea archivos `.tf`, no usa `helm_release` y no introduce modulos Terraform.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Crear chart local para `platform-api` | Alcanzado | `labs/06-helm-packaging/chart/platform-api/Chart.yaml` |
| Convertir manifiestos de Unidad 05 en templates Helm | Alcanzado | `labs/06-helm-packaging/chart/platform-api/templates/` |
| Parametrizar valores relevantes sin ocultar comportamiento | Alcanzado | `values.yaml` y `values-local.yaml` |
| Crear documentacion del alumno | Alcanzado | `tutorial/06-helm-packaging/README.md` y `student-notes.md` |
| Crear referencia avanzada requerida | Alcanzado | `tutorial/06-helm-packaging/student-reference.md` |
| Crear laboratorio operativo | Alcanzado | `labs/06-helm-packaging/README.md` |
| Crear validacion automatizada | Alcanzado | `labs/06-helm-packaging/validation/validate.sh` |
| Crear adopcion controlada de recursos heredados | Alcanzado | `labs/06-helm-packaging/validation/adopt-existing-resources.sh` |
| Evitar Terraform ejecutable | Alcanzado | Sin archivos `.tf` ni `.tfvars` |
| Ejecutar validaciones estaticas principales | Alcanzado | `bash -n`, `helm lint`, `helm template`, dry-run cliente |
| Ejecutar instalacion funcional del release | Alcanzado | `helm upgrade --install platform-api-local ...`: revision 1 desplegada |
| Ejecutar upgrade y rollback real | Alcanzado | Upgrade temporal a revision 2 y rollback a revision 1, dejando revision 3 desplegada |

## Estado inicial utilizado

## Plataforma

- MicroK8s local y Kubernetes disponibles segun estado heredado.
- Helm `v3.21.0+ge0878d4` comprobado con `helm version --short`.
- `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/` acepto los manifiestos heredados.

## Aplicacion

- `platform-api` existia como aplicacion evolutiva.
- La Unidad 05 dejo Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB.
- No existian charts Helm previos del curso.

## Automatizacion

- La Unidad 05 usaba manifiestos Kubernetes nativos.
- Terraform estaba instalado pero no gestionaba recursos del curso.

## Seguridad

- Los secretos del laboratorio son ficticios.
- No se introdujeron credenciales reales.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/summary.md` | Continuidad tecnica |
| Student notes Unidad 05 | `tutorial/05-scheduling-resilience-maintenance/student-notes.md` | Continuidad pedagogica |
| Manifiestos Unidad 05 | `labs/05-scheduling-resilience-maintenance/solution/` | Base del chart |
| Validacion Unidad 05 | `labs/05-scheduling-resilience-maintenance/validation/validate.sh` | Precondicion heredada |
| Playbook Unidad 06 | `playbooks/units/06-helm-packaging.md` | Alcance y criterios |

## Cambios introducidos

## Capacidades incorporadas

- empaquetado local de `platform-api` con Helm;
- renderizado previo con `helm template`;
- validacion con `helm lint` y dry-run cliente;
- instalacion, upgrade, inspeccion, historial y rollback documentados;
- helpers para nombres, labels y selectors;
- separacion entre defaults del chart y valores locales;
- referencia avanzada sobre templates, valores y frontera con Terraform.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 06 | `tutorial/06-helm-packaging/README.md` | Puerta de entrada |
| Student notes | `tutorial/06-helm-packaging/student-notes.md` | Guia de aprendizaje |
| Student reference | `tutorial/06-helm-packaging/student-reference.md` | Referencia tecnica avanzada |
| Instructor notes | `tutorial/06-helm-packaging/instructor-notes.md` | Guia de imparticion |
| Summary Unidad 06 | `tutorial/06-helm-packaging/summary.md` | Continuidad |
| Laboratorio | `labs/06-helm-packaging/README.md` | Operacion del chart |
| Chart | `labs/06-helm-packaging/chart/platform-api/` | Paquete Helm local |
| Validacion | `labs/06-helm-packaging/validation/validate.sh` | Comprobacion de chart y release |
| Adopcion de recursos existentes | `labs/06-helm-packaging/validation/adopt-existing-resources.sh` | Anade metadatos de ownership Helm a recursos heredados de Unidad 05 |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Estado del proyecto | `project/project-state.md` | Debe registrar Unidad 06 generada y validaciones ejecutadas |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/06-helm-packaging/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

labs/06-helm-packaging/
├── README.md
├── chart/
│   └── platform-api/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-local.yaml
│       └── templates/
│           ├── _helpers.tpl
│           ├── namespace.yaml
│           ├── configmap.yaml
│           ├── secret.yaml
│           ├── pvc.yaml
│           ├── pdb.yaml
│           ├── deployment.yaml
│           ├── service.yaml
│           └── ingress.yaml
└── validation/
    ├── adopt-existing-resources.sh
    └── validate.sh
```

## Estado tecnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| Helm | Disponible | `helm version --short`: `v3.21.0+ge0878d4` |
| Kubernetes local | Disponible para dry-run y despliegue funcional | `bash labs/06-helm-packaging/validation/validate.sh`: 0 fallos, 0 avisos |

## Aplicacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicacion evolutiva | Conservada como `platform-api` | `values.yaml` y templates |
| Namespace | Conservado como `platform-training` | `templates/namespace.yaml` |
| Deployment | Gestionado por Helm con 2 replicas, probes, resources, rollout y scheduling | `bash labs/06-helm-packaging/validation/validate.sh`: 2 Pods Ready |
| Service | Conservado como `ClusterIP` | `templates/service.yaml` |
| Ingress | Conservado para `platform-api.local` | `templates/ingress.yaml` |
| PVC | Conservado como `platform-api-data` | `templates/pvc.yaml` |
| PDB | Conservado como `platform-api` | `templates/pdb.yaml` |

## Automatizacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Chart Helm | Creado y validado | `labs/06-helm-packaging/chart/platform-api/` |
| Release local | Instalado como `platform-api-local` | `helm status platform-api-local --namespace platform-training`: `deployed`, revision 3 tras rollback |
| Terraform | No creado | `find` sin `.tf` ni `.tfvars` |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Valores ficticios | `values.yaml` y `templates/secret.yaml` |
| Credenciales reales | No introducidas | Revision de artefactos |

## Inventario relevante

## Namespaces

| Namespace | Proposito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Namespace funcional del curso | Renderizado por chart; heredado conceptualmente |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/06-helm-packaging/chart/platform-api/templates/deployment.yaml` | 2 replicas disponibles tras instalar release |
| `poddisruptionbudget/platform-api` | `platform-training` | `labs/06-helm-packaging/chart/platform-api/templates/pdb.yaml` | `minAvailable: 1` |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Proposito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 | Acceso interno estable |
| `ingress/platform-api` | `platform-api.local` | Entrada HTTP local |

## Configuracion y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| ConfigMap | `templates/configmap.yaml` | Configuracion no sensible |
| Secret | `templates/secret.yaml` | Secret ficticio de laboratorio |
| Values locales | `values-local.yaml` | Overrides locales sin secretos reales |

## Herramientas y versiones

| Herramienta | Version validada | Metodo de comprobacion |
|---|---|---|
| Helm | `v3.21.0+ge0878d4` | `helm version --short` |

## Decisiones tomadas

## D-06-01 - Helm empaqueta `platform-api`

El chart empaqueta la aplicacion evolutiva existente y no introduce aplicaciones alternativas.

## D-06-02 - Nombres funcionales conservados

`fullnameOverride: platform-api` conserva nombres de recursos y reduce friccion al migrar desde manifiestos de Unidad 05.

## D-06-03 - Parametrizacion con criterio

Se parametrizan imagen, replicas, Ingress, configuracion visible, Secret ficticio, PVC, resources, rollout, probes y scheduling. No se parametriza todo el YAML.

## D-06-04 - Renderizado antes de instalacion

El laboratorio exige `helm template` y dry-run antes de `helm upgrade --install`.

## D-06-05 - Terraform diferido

`student-reference.md` explica la frontera conceptual con Terraform, pero no crea artefactos Terraform.

## Validaciones realizadas

| Validacion | Resultado |
|---|---|
| Helm disponible | `helm version --short`: `v3.21.0+ge0878d4` |
| Ausencia previa de charts | `find ... -name Chart.yaml`: sin resultados antes de crear Unidad 06 |
| Ausencia de Terraform | `find ... '*.tf' '*.tfvars'`: sin resultados |
| Dry-run Unidad 05 heredada | `kubectl apply --dry-run=client -f labs/05-scheduling-resilience-maintenance/solution/`: aceptado |
| Sintaxis Bash | `bash -n labs/06-helm-packaging/validation/validate.sh`: 0 |
| Sintaxis Bash adopcion | `bash -n labs/06-helm-packaging/validation/adopt-existing-resources.sh`: 0 |
| Helm lint | `helm lint labs/06-helm-packaging/chart/platform-api`: 0 charts failed |
| Renderizado Helm | `helm template platform-api-local ...`: generado correctamente |
| Dry-run cliente del renderizado | `helm template ... | kubectl apply --dry-run=client -f -`: aceptado |
| Adopcion de recursos heredados | `bash labs/06-helm-packaging/validation/adopt-existing-resources.sh`: metadatos aplicados sin borrar recursos |
| Instalacion Helm | `helm upgrade --install platform-api-local ...`: release instalado, revision 1 |
| Rollback Helm | Upgrade temporal a revision 2 y `helm rollback platform-api-local 1 --namespace platform-training`: revision 3 desplegada |
| Validacion funcional final | `bash labs/06-helm-packaging/validation/validate.sh`: 0 fallos, 0 avisos |

## Validaciones pendientes

- `shellcheck` queda pendiente si no esta disponible en el entorno.
- Revision pedagogica y aprobacion final del usuario quedan pendientes.

## Limitaciones activas

- El chart esta orientado a laboratorio local y usa `microk8s-hostpath`.
- La migracion desde recursos aplicados con `kubectl` a recursos gestionados por Helm puede requerir atencion a metadatos de ownership si ya existen recursos en el cluster.
- Los secretos siguen siendo ficticios; no hay gestion productiva de secretos.
- No se publica el chart en repositorio remoto u OCI.
- No se demuestra alta disponibilidad multi-nodo.

## Continuidad para Unidad 07

La Unidad 07 debera reutilizar:

```text
labs/06-helm-packaging/chart/platform-api/
tutorial/06-helm-packaging/summary.md
tutorial/06-helm-packaging/student-reference.md
```

La siguiente unidad puede introducir Terraform como capa que gestiona el release Helm, manteniendo la frontera:

```text
Helm empaqueta y renderiza.
Terraform orquesta y declara la instalacion.
```
