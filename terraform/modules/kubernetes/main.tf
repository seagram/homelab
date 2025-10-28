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

  # Each app has a single manifest file named <app>.yaml in the apps directory
  app_files = {
    for file in fileset(local.apps_path, "*.yaml") :
    trimsuffix(file, ".yaml") => "${local.apps_path}/${file}"
  }

  # Parse all manifests and create individual resources
  manifests = merge([
    for app_name, file_path in local.app_files : {
      for idx, doc in split("---", file(file_path)) :
      "${app_name}-${idx}" => yamldecode(doc)
      if trimspace(doc) != ""
    }
  ]...)
}

resource "kubernetes_manifest" "apps" {
  for_each = local.manifests

  manifest = each.value
}