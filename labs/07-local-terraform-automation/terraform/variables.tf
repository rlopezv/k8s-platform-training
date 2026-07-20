variable "kubeconfig_path" {
  description = "Ruta al kubeconfig local usado por los providers Helm y Kubernetes."
  type        = string
  default     = "~/.kube/config"

  validation {
    condition     = length(trimspace(var.kubeconfig_path)) > 0
    error_message = "kubeconfig_path no puede estar vacio."
  }
}

variable "kube_context" {
  description = "Contexto Kubernetes local. En MicroK8s suele ser microk8s."
  type        = string
  default     = "microk8s"

  validation {
    condition     = length(trimspace(var.kube_context)) > 0
    error_message = "kube_context no puede estar vacio."
  }
}

variable "release_name" {
  description = "Nombre del release Helm local gestionado por Terraform."
  type        = string
  default     = "platform-api-local"

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.release_name))
    error_message = "release_name debe usar formato DNS label en minusculas."
  }
}

variable "namespace" {
  description = "Namespace funcional del curso."
  type        = string
  default     = "platform-training"

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace))
    error_message = "namespace debe usar formato DNS label en minusculas."
  }
}

variable "chart_path" {
  description = "Ruta relativa al chart Helm local de Unidad 06."
  type        = string
  default     = "../../06-helm-packaging/chart/platform-api"
}

variable "ingress_host" {
  description = "Host HTTP local usado por el Ingress de platform-api."
  type        = string
  default     = "platform-api.local"

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*$", var.ingress_host))
    error_message = "ingress_host debe ser un host DNS valido en minusculas."
  }
}

variable "replica_count" {
  description = "Numero de replicas para el Deployment renderizado por el chart."
  type        = number
  default     = 2

  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 3
    error_message = "replica_count debe estar entre 1 y 3 para este laboratorio local."
  }
}

variable "feature_greeting" {
  description = "Valor visible de laboratorio inyectado en ConfigMap mediante values renderizados por Terraform."
  type        = string
  default     = "terraform-local"

  validation {
    condition     = length(trimspace(var.feature_greeting)) > 0
    error_message = "feature_greeting no puede estar vacio."
  }
}

variable "storage_class_name" {
  description = "StorageClass local usada por el PVC del laboratorio."
  type        = string
  default     = "microk8s-hostpath"
}

variable "lab_client_id" {
  description = "Identificador ficticio del laboratorio. No usar credenciales reales."
  type        = string
  default     = "lab-client-id-not-real"
}

variable "lab_api_token" {
  description = "Token ficticio del laboratorio. No usar credenciales reales."
  type        = string
  sensitive   = true
  default     = "lab-token-not-real"
}
