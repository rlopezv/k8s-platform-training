output "release_name" {
  description = "Release Helm gestionado por Terraform."
  value       = helm_release.platform_api.name
}

output "release_namespace" {
  description = "Namespace donde se instala platform-api."
  value       = helm_release.platform_api.namespace
}

output "release_status" {
  description = "Estado reportado por el provider Helm."
  value       = helm_release.platform_api.status
}

output "chart_path" {
  description = "Ruta absoluta al chart Helm local reutilizado."
  value       = local.chart_full_path
}

output "ingress_host" {
  description = "Host local esperado para el Ingress."
  value       = var.ingress_host
}

output "observation_commands" {
  description = "Comandos no sensibles para inspeccionar el estado resultante."
  value = [
    "terraform -chdir=labs/07-local-terraform-automation/terraform state list",
    "helm status ${var.release_name} --namespace ${var.namespace}",
    "kubectl -n ${var.namespace} rollout status deployment/platform-api",
    "kubectl -n ${var.namespace} get deploy,svc,endpointslice,ingress,pvc,pdb",
  ]
}
