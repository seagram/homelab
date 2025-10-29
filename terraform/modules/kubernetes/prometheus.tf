# resource "helm_release" "prometheus" {
#   name             = "prometheus"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   chart            = "prometheus"
#   namespace        = "prometheus"
#   create_namespace = true

#   set = [
#     {
#       name  = "server.persistentVolume.enabled"
#       value = "true"
#     },
#     {
#       name  = "server.persistentVolume.size"
#       value = "8Gi"
#     },
#     {
#       name  = "server.persistentVolume.storageClass"
#       value = "longhorn"
#     },
#     {
#       name  = "alertmanager.persistentVolume.enabled"
#       value = "true"
#     },
#     {
#       name  = "alertmanager.persistentVolume.storageClass"
#       value = "longhorn"
#     },
#     {
#       name  = "kubeStateMetrics.enabled"
#       value = "true"
#     },
#     {
#       name  = "nodeExporter.enabled"
#       value = "true"
#     },
#     {
#       name  = "server.global.scrape_interval"
#       value = "30s"
#     }
#   ]

#   depends_on = [helm_release.longhorn]
# }

# resource "kubernetes_ingress_v1" "prometheus" {
#   metadata {
#     name      = "prometheus-ingress"
#     namespace = helm_release.prometheus.namespace
#   }
#   spec {
#     ingress_class_name = "tailscale"
#     default_backend {
#       service {
#         name = "prometheus-server"
#         port {
#           number = 80
#         }
#       }
#     }
#     tls {
#       hosts = ["prometheus"]
#     }
#   }

#   depends_on = [helm_release.prometheus]
# }