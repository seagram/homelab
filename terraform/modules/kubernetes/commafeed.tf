resource "kubernetes_namespace" "commafeed" {
  metadata {
    name = "commafeed"
  }
}

resource "kubernetes_persistent_volume" "commafeed" {
  metadata {
    name = "commafeed-pv"
  }
  spec {
    capacity = {
      storage = "5Gi"
    }
    access_modes                     = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name               = "manual"
    persistent_volume_source {
      host_path {
        path = "/var/lib/commafeed"
        type = "DirectoryOrCreate"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "commafeed" {
  metadata {
    name      = "commafeed-data"
    namespace = kubernetes_namespace.commafeed.metadata[0].name
  }
  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = "manual"
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_name = kubernetes_persistent_volume.commafeed.metadata[0].name
  }
}

resource "kubernetes_deployment" "commafeed" {
  metadata {
    name      = "commafeed"
    namespace = kubernetes_namespace.commafeed.metadata[0].name
    labels = {
      app = "commafeed"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "commafeed"
      }
    }
    template {
      metadata {
        labels = {
          app = "commafeed"
        }
      }
      spec {
        container {
          name  = "commafeed"
          image = "athou/commafeed:latest-h2"
          port {
            container_port = 8082
          }
          env {
            name  = "TZ"
            value = "America/New_York"
          }
          volume_mount {
            name       = "data"
            mount_path = "/commafeed/data"
          }
          resources {
            requests = {
              memory = "256Mi"
              cpu    = "250m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
          }
        }
        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.commafeed.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "commafeed" {
  metadata {
    name      = "commafeed-service"
    namespace = kubernetes_namespace.commafeed.metadata[0].name
  }
  spec {
    selector = {
      app = "commafeed"
    }
    type = "ClusterIP"
    port {
      protocol    = "TCP"
      port        = 8082
      target_port = 8082
    }
  }
}

resource "kubernetes_ingress_v1" "commafeed" {
  metadata {
    name      = "commafeed-ingress"
    namespace = kubernetes_namespace.commafeed.metadata[0].name
  }
  spec {
    ingress_class_name = "tailscale"
    default_backend {
      service {
        name = kubernetes_service.commafeed.metadata[0].name
        port {
          number = 8082
        }
      }
    }
    tls {
      hosts = ["rss"]
    }
  }
}
