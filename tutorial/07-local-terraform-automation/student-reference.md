# Arquitectura avanzada de automatizacion con Terraform

## Proposito de la referencia

Este documento es una referencia tecnica para consultar durante la Unidad 07 y las unidades posteriores. No sustituye a `student-notes.md`: aqui el foco esta en motor Terraform, state, variables, expresiones, modulos e integracion con Kubernetes y Helm.

Los ejemplos usan `platform-api`, `helm_release` y el chart local del curso. Las secciones cloud son arquitectura de produccion no ejecutada en esta unidad.

## Modulo 1 - El motor de Terraform, ciclo de vida y gestion del estado

### 1.1 Anatomia del compilador y lenguaje HCL

Terraform lee HCL, resuelve variables, evalua expresiones, carga providers y construye un grafo dirigido aciclico. Ese grafo permite decidir que puede evaluarse en paralelo y que requiere dependencia previa.

Fases principales:

| Fase | Funcion | Mutacion |
|---|---|---|
| `init` | Inicializa backend y descarga providers | No cambia el cluster |
| `plan` | Evalua configuracion, state y realidad | No deberia cambiar recursos |
| `apply` | Ejecuta el plan aceptado | Puede cambiar recursos |
| `destroy` | Planifica eliminacion de recursos gestionados | Destructivo |

Ejemplo del laboratorio:

```hcl
resource "helm_release" "platform_api" {
  name      = var.release_name
  namespace = var.namespace
  chart     = local.chart_full_path
}
```

Terraform Core no sabe instalar Helm por si mismo. El provider Helm implementa esa operacion.

### 1.2 Arquitectura del estado en entornos de produccion

`terraform.tfstate` registra la relacion entre direcciones Terraform e IDs reales. En local puede contener entradas como:

```text
helm_release.platform_api -> platform-training/platform-api-local
```

El state no es un cache inocuo. Si se pierde, Terraform puede dejar de saber que gestiona. Si se filtra, puede exponer metadatos y, segun providers y configuracion, valores sensibles.

En produccion se usan backends remotos:

| Backend | Uso habitual | Locking |
|---|---|---|
| AWS S3 | State versionado en S3 | DynamoDB o S3 native locking segun patron |
| Azure Blob | State en Storage Account | Lease de Blob |
| HCP Terraform | State gestionado | Locking gestionado |
| Consul | State y coordinacion | Locking en Consul |

En esta unidad se usa backend local para evitar cuentas cloud, permisos y costes.

Operaciones de emergencia:

| Comando | Uso | Riesgo |
|---|---|---|
| `terraform state rm` | Desvincular sin borrar recurso real | Terraform puede recrear luego |
| `terraform state mv` | Renombrar direccion de recurso | Error de mapeo si se usa mal |
| `terraform import` | Adoptar recurso existente | Necesita ID exacto |

## Modulo 2 - Sistema de variables, tipos y jerarquia de sustitucion

### 2.1 Tipificacion estricta en HCL

Terraform permite tipos primitivos:

```hcl
variable "namespace" {
  type = string
}
```

Y tipos estructurales:

```hcl
variable "labels" {
  type = map(string)
}

variable "limits" {
  type = object({
    cpu    = string
    memory = string
  })
}
```

Las validaciones reducen errores tardios:

```hcl
validation {
  condition     = var.replica_count >= 1 && var.replica_count <= 3
  error_message = "replica_count debe estar entre 1 y 3."
}
```

### 2.2 Cascada de prioridades

Terraform resuelve variables de menor a mayor prioridad:

| Prioridad | Fuente | Uso |
|---|---|---|
| 1 | `default` | Valores seguros de laboratorio |
| 2 | `terraform.tfvars` | Configuracion local no versionada |
| 3 | `*.auto.tfvars` | Carga automatica local |
| 4 | `-var-file` | Archivo especifico de entorno |
| 5 | `TF_VAR_nombre` | Inyeccion desde entorno |
| 6 | `-var` | Override puntual |
| 7 | Consola interactiva | Evitar en automatizacion |

En el laboratorio se usa:

```bash
terraform -chdir=labs/07-local-terraform-automation/terraform plan -var-file=terraform.tfvars.example
```

`terraform.tfvars.example` se versiona porque contiene placeholders inocuos. `terraform.tfvars` real se ignora.

## Modulo 3 - Logica dinamica, expresiones e infraestructura

### 3.1 Condicionales

El operador ternario selecciona valores:

```hcl
replicas = var.enable_high_availability ? 3 : 1
```

`count` puede crear cero o una instancia:

```hcl
count = var.enabled ? 1 : 0
```

Riesgo: `count` sobre listas cambia identidad si cambia la posicion. Para colecciones con identidad propia, `for_each` suele ser mejor.

### 3.2 Bucles y comprensiones

`for_each` conserva identidad por clave:

```hcl
resource "kubernetes_namespace" "team" {
  for_each = var.namespaces

  metadata {
    name = each.key
  }
}
```

Comprension:

```hcl
[for name, enabled in var.features : name if enabled]
```

### 3.3 Bloques dinamicos

`dynamic` genera sub-bloques repetidos:

```hcl
dynamic "set" {
  for_each = var.helm_sets

  content {
    name  = set.key
    value = set.value
  }
}
```

En la Unidad 07 no se usa para mantener el flujo principal legible.

## Modulo 4 - Modularizacion y flujo transversal

### 4.1 Modulos reutilizables

Un modulo suele exponer:

```text
main.tf
variables.tf
outputs.tf
providers.tf
```

La interfaz importa mas que la cantidad de archivos. Un modulo bueno oculta complejidad estable, no decisiones que el alumno todavia necesita ver.

Esta unidad no crea modulo local ejecutable porque el objetivo es observar directamente providers, variables, `helm_release` y outputs.

### 4.2 Datos entre proyectos independientes

`terraform_remote_state` permite leer outputs de otro state:

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "example"
    key    = "network.tfstate"
    region = "eu-west-1"
  }
}
```

Es lectura de datos, no permiso magico para modificar el otro proyecto.

## Modulo 5 - Integracion avanzada con Kubernetes y Helm

### 5.1 Autenticacion dinamica entre providers

En local, los providers usan kubeconfig:

```hcl
provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kube_context
  }
}
```

En EKS o AKS futuros, el provider podria alimentarse de outputs del cluster y tokens dinamicos. Esa arquitectura queda diferida porque esta unidad no crea clusters cloud.

### 5.2 `helm_release` e inyeccion de datos

`helm_release` instala o actualiza un chart:

```hcl
resource "helm_release" "platform_api" {
  name      = var.release_name
  namespace = var.namespace
  chart     = local.chart_full_path
  values    = [local.rendered_values]
}
```

`templatefile()` permite generar un values YAML:

```hcl
templatefile("${path.module}/values/platform-api-values.yaml.tftpl", {
  namespace    = var.namespace
  ingress_host = var.ingress_host
})
```

`set_sensitive` oculta mejor un valor en CLI:

```hcl
set_sensitive {
  name  = "secret.labApiToken"
  value = var.lab_api_token
}
```

Advertencia: el state puede seguir conteniendo datos sensibles. No uses secretos reales.

### 5.3 Dependencias criticas

En cloud, Terraform podria crear red, cluster, node groups, controladores y releases. El orden importa: destruir un cluster antes de desinstalar releases puede dejar recursos colgados.

En la unidad local no se crean VPC, VNet, node groups ni controladores cloud. La dependencia principal es que MicroK8s exista antes de ejecutar Terraform.

## Diagnostico rapido

| Sintoma | Causa probable | Comando util | Recuperacion |
|---|---|---|---|
| Provider no instalado | Falta `init` | `terraform init` | Inicializar desde `terraform/` |
| Plan no conecta | Contexto incorrecto | `kubectl config current-context` | Ajustar `kube_context` |
| Release existe pero state no | Helm previo fuera de Terraform | `helm status`, `terraform state list` | Import o apply controlado |
| Plan destructivo | Variables/state desalineados | `terraform plan` | No aplicar; revisar inputs |
| Secret aparece | Valor no sensible o archivo versionado | `grep`, plan, outputs | Retirar y rotar si fuera real |
| PVC en riesgo | Uso de destroy o borrado manual | `kubectl get pvc` | No borrar; reaplicar release |

## Referencias oficiales

- Terraform Language: https://developer.hashicorp.com/terraform/language
- Terraform CLI: https://developer.hashicorp.com/terraform/cli
- Terraform State: https://developer.hashicorp.com/terraform/language/state
- Terraform Backends: https://developer.hashicorp.com/terraform/language/backend
- Terraform Variables: https://developer.hashicorp.com/terraform/language/values/variables
- Terraform Outputs: https://developer.hashicorp.com/terraform/language/values/outputs
- Terraform Expressions: https://developer.hashicorp.com/terraform/language/expressions
- Terraform Modules: https://developer.hashicorp.com/terraform/language/modules
- Terraform `templatefile`: https://developer.hashicorp.com/terraform/language/functions/templatefile
- Helm provider `helm_release`: https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release
- Kubernetes provider: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
- Helm Chart Template Guide: https://helm.sh/docs/chart_template_guide/
