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

  namespaces = {
    for f in fileset(local.apps_path, "*/") :
    trimsuffix(f, "/") => trimsuffix(f, "/")
  }
  manifests = {
    for f in fileset(local.apps_path, "**/*.{yml,yaml}") :
    f => "${local.apps_path}/${f}"
  }
}

resource "kubernetes_namespace" "namespaces" {
  for_each = local.namespaces

  metadata {
    name = each.value
  }
}

resource "kubernetes_manifest" "manifests" {
  for_each = local.manifests

  manifest = yamldecode(file(each.value))
}