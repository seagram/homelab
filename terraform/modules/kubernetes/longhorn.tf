resource "helm_release" "longhorn" {
  name             = "longhorn"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  namespace        = "longhorn-system"
  create_namespace = true

  set = [
    {
      name  = "defaultSettings.defaultReplicaCount"
      value = "\"3\""
    },
    {
      name  = "defaultSettings.defaultDataPath"
      value = "/var/lib/longhorn"
    },
    {
      name  = "persistence.defaultClass"
      value = "true"
    },
    {
      name  = "persistence.defaultClassReplicaCount"
      value = "\"3\""
    }
  ]
}

resource "kubernetes_ingress_v1" "longhorn" {
  metadata {
    name      = "longhorn-ingress"
    namespace = helm_release.longhorn.namespace
  }
  spec {
    ingress_class_name = "tailscale"
    default_backend {
      service {
        name = "longhorn-frontend"
        port {
          number = 80
        }
      }
    }
    tls {
      hosts = ["longhorn"]
    }
  }

  depends_on = [helm_release.longhorn]
}