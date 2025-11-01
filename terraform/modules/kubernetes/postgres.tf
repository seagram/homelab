resource "helm_release" "cloudnative_pg" {
  name             = "cnpg"
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  namespace        = "cnpg-system"
  create_namespace = true

  depends_on = [helm_release.longhorn]
}

resource "helm_release" "pgadmin4" {
  name             = "pgadmin4"
  repository       = "https://helm.runix.net"
  chart            = "pgadmin4"
  namespace        = "pgadmin4"
  create_namespace = true

  set = [
    {
      name  = "persistentVolume.storageClass"
      value = "longhorn-static"
    }
  ]

  depends_on = [helm_release.longhorn]
}

resource "kubernetes_ingress_v1" "pgadmin4" {
  metadata {
    name      = "pgadmin4-ingress"
    namespace = helm_release.pgadmin4.namespace
  }
  spec {
    ingress_class_name = "tailscale"
    default_backend {
      service {
        name = "pgadmin4"
        port {
          number = 80
        }
      }
    }
    tls {
      hosts = ["pgadmin"]
    }
  }

  depends_on = [helm_release.pgadmin4]
}
