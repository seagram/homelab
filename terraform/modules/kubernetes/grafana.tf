resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "grafana"
  create_namespace = true

  set = [
    {
      name  = "adminPassword"
      value = var.admin_password
    },
    {
      name  = "persistence.enabled"
      value = "true"
    },
    {
      name  = "persistence.size"
      value = "5Gi"
    }
  ]
}

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana-ingress"
    namespace = helm_release.grafana.namespace
  }
  spec {
    ingress_class_name = "tailscale"
    default_backend {
      service {
        name = "grafana"
        port {
          number = 80
        }
      }
    }
    tls {
      hosts = ["grafana"]
    }
  }

  depends_on = [helm_release.grafana]
}
