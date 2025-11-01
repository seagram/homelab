resource "kubernetes_manifest" "grafana_postgres" {
  manifest = {
    apiVersion = "postgresql.cnpg.io/v1"
    kind       = "Cluster"
    metadata = {
      name      = "grafana-postgres"
      namespace = "grafana"
    }
    spec = {
      instances = 1
      storage = {
        size         = "10Gi"
        storageClass = "longhorn-static"
      }
      bootstrap = {
        initdb = {
          database = "grafana"
          owner    = "grafana"
        }
      }
    }
  }

  depends_on = [
    helm_release.cloudnative_pg,
    kubernetes_namespace.grafana
  ]
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
  }
}

resource "helm_release" "grafana" {
  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = kubernetes_namespace.grafana.metadata[0].name
  create_namespace = false

  set = [
    {
      name  = "adminPassword"
      value = var.admin_password
    },
    {
      name  = "persistence.enabled"
      value = "false"
    },
    {
      name  = "database.type"
      value = "postgres"
    },
    {
      name  = "database.host"
      value = "grafana-postgres-rw.grafana.svc.cluster.local:5432"
    },
    {
      name  = "database.name"
      value = "grafana"
    },
    {
      name  = "database.user"
      value = "grafana"
    },
    {
      name  = "database.passwordSecret"
      value = "grafana-postgres-app"
    },
    {
      name  = "database.passwordKey"
      value = "password"
    },
    {
      name  = "database.sslmode"
      value = "disable"
    }
  ]

  depends_on = [kubernetes_manifest.grafana_postgres]
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
