terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
    }
  }
}

locals {
  apps_path = "${path.module}/apps"

  app_files = {
    for file in fileset(local.apps_path, "*.yaml") :
    trimsuffix(file, ".yaml") => "${local.apps_path}/${file}"
  }

  manifests = merge([
    for app_name, file_path in local.app_files : {
      for idx, doc in split("---", file(file_path)) :
      "${app_name}-${idx}" => yamldecode(doc)
      if trimspace(doc) != ""
    }
  ]...)
}

resource "helm_release" "tailscale_operator" {
  name             = "tailscale-operator"
  repository       = "https://pkgs.tailscale.com/helmcharts"
  chart            = "tailscale-operator"
  namespace        = "tailscale"
  create_namespace = true

  set = [
    {
      name  = "oauth.clientId"
      value = var.tailscale_oauth_client_id
    },
    {
      name  = "operatorConfig.hostname"
      value = "tailscale-operator"
    }
  ]

  set_sensitive = [
    {
      name  = "oauth.clientSecret"
      value = var.tailscale_oauth_client_secret
    }
  ]
}

resource "kubernetes_manifest" "apps" {
  for_each = local.manifests
  manifest = each.value
  depends_on = [helm_release.tailscale_operator]
}