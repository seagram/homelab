resource "digitalocean_database_db" "grafana" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "grafana"
}

resource "digitalocean_database_user" "grafana" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "grafana"
}

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
      value = "false"
    },
    {
      name  = "database.type"
      value = "postgres"
    },
    {
      name  = "database.host"
      value = "${digitalocean_database_cluster.postgres.host}:${digitalocean_database_cluster.postgres.port}"
    },
    {
      name  = "database.name"
      value = digitalocean_database_db.grafana.name
    },
    {
      name  = "database.user"
      value = digitalocean_database_user.grafana.name
    },
    {
      name  = "database.password"
      value = digitalocean_database_user.grafana.password
    },
    {
      name  = "database.sslmode"
      value = "require"
    }
  ]

  depends_on = [
    digitalocean_database_cluster.postgres,
    digitalocean_database_db.grafana,
    digitalocean_database_user.grafana
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
