locals {
  chart_full_path = abspath("${path.module}/${var.chart_path}")

  rendered_values = templatefile("${path.module}/values/platform-api-values.yaml.tftpl", {
    namespace          = var.namespace
    ingress_host       = var.ingress_host
    replica_count      = var.replica_count
    feature_greeting   = var.feature_greeting
    storage_class_name = var.storage_class_name
    lab_client_id      = var.lab_client_id
  })
}

resource "helm_release" "platform_api" {
  name             = var.release_name
  namespace        = var.namespace
  create_namespace = true
  chart            = local.chart_full_path
  wait             = true
  timeout          = 300

  values = [
    local.rendered_values
  ]

  set_sensitive {
    name  = "secret.labApiToken"
    value = var.lab_api_token
  }
}

data "kubernetes_namespace" "platform_training" {
  metadata {
    name = var.namespace
  }

  depends_on = [
    helm_release.platform_api
  ]
}
