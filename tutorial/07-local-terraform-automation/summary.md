# Summary - Unidad 07

## Identificacion

| Campo | Valor |
|---|---|
| Unidad | 07 - Automatización local con Terraform |
| Identificador | `07-local-terraform-automation` |
| Fase del roadmap | Fase 3 - Empaquetado e infraestructura como código |
| Estado | Completada, validada funcionalmente y aprobada pedagógicamente |
| Fecha de cierre o actualización | 2026-07-27 |
| Revisión pedagógica del usuario | Aprobada el 2026-07-20 |
| Actualización documental | Fase 4 de saneamiento documental; aprobación específica registrada el 2026-07-27 |

## Resumen ejecutivo

La Unidad 07 incorpora Terraform como capa declarativa local para gestionar el release Helm `platform-api-local` de `platform-api`. La unidad reutiliza el chart Helm de Unidad 06 ubicado en `labs/06-helm-packaging/chart/platform-api/` y crea un proyecto Terraform local en `labs/07-local-terraform-automation/terraform/`.

Terraform declara `helm_release.platform_api`, variables tipadas, un values file renderizado con `templatefile()`, `set_sensitive` con secreto ficticio, outputs no sensibles y validación automatizada. El backend sigue siendo local y el state queda como artefacto no versionado.

La unidad deja preparada la Unidad 08 para ejecutar validación, plan y apply desde CI/CD con Tekton, manteniendo la frontera entre Kubernetes, Helm y Terraform.

El 2026-07-26 se regeneraron `playbooks/units/07-local-terraform-automation.md` y `tutorial/07-local-terraform-automation/student-reference.md` contra el contrato documental cerrado en `playbooks/student-reference-template.md`. El ajuste no modifica laboratorios, validaciones ni artefactos Terraform, no ejecuta nuevas validaciones técnicas y cierra documentalmente `GAP-010` declarando la frontera de propiedad entre Terraform y GitOps.

## Objetivos alcanzados

| Objetivo | Estado | Evidencia |
|---|---|---|
| Crear proyecto Terraform local | Alcanzado | `labs/07-local-terraform-automation/terraform/` |
| Reutilizar chart Helm de Unidad 06 | Alcanzado | `main.tf` usa `../../06-helm-packaging/chart/platform-api` |
| Declarar `helm_release.platform_api` | Alcanzado | `labs/07-local-terraform-automation/terraform/main.tf` |
| Crear variables tipadas y ejemplo de tfvars | Alcanzado | `variables.tf`, `terraform.tfvars.example` |
| Crear outputs no sensibles | Alcanzado | `outputs.tf` |
| Ignorar state, tfvars locales y planes | Alcanzado | `terraform/.gitignore` |
| Crear documentacion del alumno | Alcanzado | `README.md`, `student-notes.md`, `student-reference.md` |
| Crear laboratorio operativo | Alcanzado | `labs/07-local-terraform-automation/README.md` |
| Crear validación automatizada | Alcanzado | `labs/07-local-terraform-automation/validation/validate.sh` |
| Ejecutar validaciones estáticas | Alcanzado | `bash -n`, `terraform fmt`, `terraform init`, `terraform validate` |
| Ejecutar apply funcional | Alcanzado | `terraform apply`: 0 added, 1 changed, 0 destroyed |
| Regenerar playbook contra contrato documental | Alcanzado | `playbooks/units/07-local-terraform-automation.md` |
| Regenerar referencia del alumno contra plantilla canónica | Alcanzado | `tutorial/07-local-terraform-automation/student-reference.md` |
| Cerrar documentalmente `GAP-010` | Alcanzado | `student-reference.md`, sección "Conceptos y mecanismos"; `project/content-gap-register.md` |

## Estado inicial utilizado

## Plataforma

- MicroK8s local y Kubernetes disponibles segun `project/project-state.md`.
- Helm validado y chart de Unidad 06 existente.
- Terraform instalado como CLI desde Unidad 00.

## Aplicacion

- `platform-api` existe como aplicación evolutiva.
- El chart Helm local conserva Namespace, ConfigMap, Secret ficticio, PVC, Deployment, Service, Ingress y PDB.
- El release documentado se llama `platform-api-local`.

## Automatización

- Unidad 06 instalaba y actualizaba el release con Helm CLI.
- No existian archivos `.tf` ni state Terraform del curso antes de generar Unidad 07.

## Seguridad

- Los secretos son ficticios.
- No se introdujeron credenciales reales, kubeconfigs ni tokens.

## Artefactos de entrada principales

| Artefacto | Ruta | Uso |
|---|---|---|
| Summary Unidad 06 | `tutorial/06-helm-packaging/summary.md` | Continuidad técnica |
| Student reference Unidad 06 | `tutorial/06-helm-packaging/student-reference.md` | Frontera Helm/Terraform |
| Chart Helm | `labs/06-helm-packaging/chart/platform-api/` | Paquete instalado por Terraform |
| Validacion Unidad 06 | `labs/06-helm-packaging/validation/validate.sh` | Validacion funcional heredada |
| Playbook Unidad 07 | `playbooks/units/07-local-terraform-automation.md` | Alcance y criterios |

## Cambios introducidos

## Capacidades incorporadas

- automatizacion local del release Helm mediante Terraform;
- providers Helm y Kubernetes;
- variables tipadas con validaciones;
- renderizado de values con `templatefile()`;
- `set_sensitive` con Secret ficticio de laboratorio;
- outputs no sensibles para inspeccion;
- validación automatizada de Terraform, Helm y Kubernetes;
- referencia avanzada de Terraform para state, variables, expresiones, módulos e integración Kubernetes/Helm.

## Componentes creados

| Componente | Ruta | Responsabilidad |
|---|---|---|
| Tutorial Unidad 07 | `tutorial/07-local-terraform-automation/README.md` | Puerta de entrada |
| Student notes | `tutorial/07-local-terraform-automation/student-notes.md` | Guia de aprendizaje |
| Student reference | `tutorial/07-local-terraform-automation/student-reference.md` | Referencia técnica avanzada |
| Instructor notes | `tutorial/07-local-terraform-automation/instructor-notes.md` | Guia de imparticion |
| Summary Unidad 07 | `tutorial/07-local-terraform-automation/summary.md` | Continuidad |
| Laboratorio | `labs/07-local-terraform-automation/README.md` | Operacion Terraform |
| Proyecto Terraform | `labs/07-local-terraform-automation/terraform/` | Gestion de `helm_release.platform_api` |
| Validacion | `labs/07-local-terraform-automation/validation/validate.sh` | Comprobacion de IaC, Helm y Kubernetes |

## Componentes modificados

| Componente | Ruta | Cambio realizado |
|---|---|---|
| Estado del proyecto | `project/project-state.md` | Registra Unidad 07 generada, validada funcionalmente y aprobada pedagógicamente |
| Playbook Unidad 07 | `playbooks/units/07-local-terraform-automation.md` | Regenerado contra el contrato documental de fase 4 |
| Student reference | `tutorial/07-local-terraform-automation/student-reference.md` | Regenerada con estructura canónica y cierre de `GAP-010` |
| README de alumno | `tutorial/07-local-terraform-automation/README.md` | Ajustado para remitir los errores conceptuales a la referencia |
| Student notes | `tutorial/07-local-terraform-automation/student-notes.md` | Ajustadas para mantener diagnóstico operativo y remitir modelos mentales a la referencia |
| Registro de lagunas | `project/content-gap-register.md` | `GAP-010` marcado como cerrado documentalmente |

## Componentes retirados

Ninguno.

## Estructura final de artefactos

```text
tutorial/07-local-terraform-automation/
├── README.md
├── student-notes.md
├── student-reference.md
├── instructor-notes.md
└── summary.md

labs/07-local-terraform-automation/
├── README.md
├── terraform/
│   ├── versions.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── .terraform.lock.hcl
│   ├── terraform.tfvars.example
│   ├── values/
│   │   └── platform-api-values.yaml.tftpl
│   └── .gitignore
└── validation/
    └── validate.sh
```

## Estado tecnico final

## Plataforma

| Elemento | Estado final | Evidencia |
|---|---|---|
| MicroK8s | Reutilizado | `project/project-state.md` |
| Kubernetes local | Reutilizado | `project/project-state.md` |
| Recursos cloud | No creados | Revisión de artefactos |

## Aplicacion

| Elemento | Estado final | Evidencia |
|---|---|---|
| Aplicacion evolutiva | Conservada como `platform-api` | Chart heredado de Unidad 06 |
| Namespace | Conservado como `platform-training` | Variable `namespace` |
| Release Helm | Gestionado por Terraform como `platform-api-local`, revision Helm 4 | `helm_release.platform_api`; `helm status` |
| PVC | Conservado como `platform-api-data` | Chart heredado; destroy advertido como destructivo |

## Automatización

| Elemento | Estado final | Evidencia |
|---|---|---|
| Terraform | Proyecto local creado y aplicado | `labs/07-local-terraform-automation/terraform/` |
| State local | Creado por import/apply y no versionado | `terraform/.gitignore`; `terraform state list` |
| Backend remoto | No configurado | `versions.tf` sin bloque backend |
| Módulo local | No creado | Decisión de claridad pedagógica |

## Seguridad

| Elemento | Estado final | Evidencia |
|---|---|---|
| Secret de laboratorio | Valores ficticios | `terraform.tfvars.example` |
| Credenciales reales | No introducidas | Revisión de artefactos |
| Archivos sensibles Terraform | Ignorados | `terraform/.gitignore` |

## Inventario relevante

## Namespaces

| Namespace | Propósito | Creado en esta unidad |
|---|---|---|
| `platform-training` | Namespace funcional del curso | No; gestionado por chart/release |

## Workloads

| Recurso | Namespace | Ruta de definicion | Estado esperado |
|---|---|---|---|
| `deployment/platform-api` | `platform-training` | `labs/06-helm-packaging/chart/platform-api/templates/deployment.yaml` | Disponible tras apply |
| `poddisruptionbudget/platform-api` | `platform-training` | `labs/06-helm-packaging/chart/platform-api/templates/pdb.yaml` | Presente tras apply |

## Servicios y endpoints

| Servicio o endpoint | Acceso | Propósito |
|---|---|---|
| `service/platform-api` | `ClusterIP`, puerto 80 | Acceso interno |
| `ingress/platform-api` | `platform-api.local` | Entrada HTTP local |

## Configuracion y secretos

| Elemento | Ruta o recurso | Tratamiento |
|---|---|---|
| Variables Terraform | `variables.tf` | Tipadas y validadas |
| Valores de ejemplo | `terraform.tfvars.example` | Placeholders inocuos |
| Secret ficticio | `set_sensitive` y chart Helm | Laboratorio, no productivo |
| State | `terraform.tfstate` | No versionado |

## Herramientas y versiones

| Herramienta | Version validada | Metodo de comprobacion |
|---|---|---|
| Terraform | CLI disponible; providers `hashicorp/helm` `2.17.0` y `hashicorp/kubernetes` `2.38.0` inicializados | `terraform init`, `.terraform.lock.hcl` |
| Helm | Heredada de Unidad 06; release revision 4 tras apply Terraform | `helm status platform-api-local --namespace platform-training` |

## Decisiones tomadas

## D-07-01 - Terraform orquesta el release Helm existente

Terraform gestiona `helm_release.platform_api` y no reescribe los templates Kubernetes.

## D-07-02 - Backend local

No se configura backend remoto para evitar cloud, credenciales, locking externo y costes.

## D-07-03 - Sin modulo local ejecutable

La primera version mantiene providers, variables, resource y outputs en un proyecto plano para mejorar lectura.

## D-07-04 - Secrets ficticios y state no versionado

El laboratorio usa placeholders y advierte que el state puede contener datos sensibles.

## D-07-05 - Plan antes de apply

El laboratorio exige revisar `terraform plan` antes de mutar el entorno.

## D-07-06 - Cierre documental de `GAP-010`

La referencia de la Unidad 07 declara que Terraform puede gestionar `helm_release.platform_api` durante el laboratorio local, pero no debe competir indefinidamente con Argo CD cuando GitOps aparezca en la Unidad 09. La Unidad 09 conserva el compromiso de resolver el patrón operativo definitivo.

## Validaciones realizadas

Las siguientes validaciones pertenecen al cierre funcional original de la Unidad 07, registrado el 2026-07-20. No se han repetido durante el saneamiento documental del 2026-07-26.

| Validacion | Resultado |
|---|---|
| Sintaxis Bash Unidad 07 | `bash -n labs/07-local-terraform-automation/validation/validate.sh`: 0 |
| Terraform fmt | `terraform -chdir=labs/07-local-terraform-automation/terraform fmt -check -recursive`: 0 |
| Terraform init | Providers descargados: Helm `2.17.0`, Kubernetes `2.38.0` |
| Terraform validate | `Success! The configuration is valid.` |
| Terraform plan antes de import | `1 to add, 0 to change, 0 to destroy`; revelo release existente fuera de state |
| Terraform import | `helm_release.platform_api` importado desde `platform-training/platform-api-local` |
| Terraform plan tras import | `0 to add, 1 to change, 0 to destroy` |
| Terraform apply | `0 added, 1 changed, 0 destroyed`; outputs no sensibles generados |
| Terraform plan final | `No changes. Your infrastructure matches the configuration.` |
| Terraform state | `data.kubernetes_namespace.platform_training` y `helm_release.platform_api` presentes |
| Validacion funcional Unidad 07 | `bash labs/07-local-terraform-automation/validation/validate.sh`: 0 fallos, 0 avisos |
| Validacion heredada Unidad 06 | `bash labs/06-helm-packaging/validation/validate.sh`: 0 fallos, 0 avisos; release revision 4 `deployed` |

## Validaciones pendientes

- `shellcheck` si esta disponible.
- Revisión pedagógica específica del saneamiento documental de la Unidad 07: aprobada por el usuario el 2026-07-27.
- No se ejecutaron nuevas validaciones técnicas durante la fase 4.

## Aprobacion del usuario

El usuario aprobó pedagógicamente la Unidad 07 el 2026-07-20.

El usuario confirmó la aprobación específica del saneamiento documental de la Unidad 07 el 2026-07-27.

## Limitaciones activas

- Backend local no es arquitectura productiva.
- `terraform destroy` puede desinstalar el release Helm y no debe usarse como limpieza normal.
- `set_sensitive` no elimina la necesidad de proteger state.
- El release existente se importo a Terraform antes del apply; no se recreo.
- `terraform destroy` no fue ejecutado.
- No se crean módulos cloud, backends remotos, Tekton, Argo CD, observabilidad avanzada, AKS ni EKS.
- El laboratorio sigue dependiendo de MicroK8s local, `microk8s-hostpath` e Ingress local.

## Continuidad para Unidad 08

La Unidad 08 deberá reutilizar:

```text
labs/07-local-terraform-automation/terraform/
labs/07-local-terraform-automation/validation/validate.sh
labs/06-helm-packaging/chart/platform-api/
tutorial/07-local-terraform-automation/summary.md
```

La siguiente unidad puede introducir Tekton para ejecutar validación, plan y apply controlado. No debe sustituir Helm ni Terraform por una pipeline imperativa.
