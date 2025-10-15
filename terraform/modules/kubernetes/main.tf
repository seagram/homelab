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