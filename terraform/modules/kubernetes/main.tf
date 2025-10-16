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
  apps_path = "${path.root}/../kubernetes/apps"

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


resource "kubernetes_namespace" "tailscale" {
    metadata {
        name = "tailscale"
        labels = {
            "pod-security.kubernetes.io/enforce" = "privileged"
        }
    }
}

resource "helm_release" "tailscale_operator" {
    name = "tailscale-operator"
    repository = "https://pkgs.tailscale.com/helmcharts"
    chart = "tailscale-operator"
    namespace = "tailscale"

    set_sensitive = [{
      name  = "oauth.clientId"
      value = var.tailscale_oauth_id
    },
    {
      name  = "oauth.clientSecret"
      value = var.tailscale_oauth_key
    }]
    wait = true
}