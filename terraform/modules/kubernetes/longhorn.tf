# resource "kubernetes_namespace" "longhorn" {
#   metadata {
#     name = "longhorn-system"
#     labels = {
#       "pod-security.kubernetes.io/enforce" = "privileged"
#       "pod-security.kubernetes.io/audit"   = "privileged"
#       "pod-security.kubernetes.io/warn"    = "privileged"
#     }
#   }
# }

# resource "helm_release" "longhorn" {
#   name             = "longhorn"
#   repository       = "https://charts.longhorn.io"
#   chart            = "longhorn"
#   namespace        = kubernetes_namespace.longhorn.metadata[0].name
#   create_namespace = false

#   set = [
#     {
#       name  = "defaultSettings.defaultReplicaCount"
#       value = "\"3\""
#     },
#     {
#       name  = "persistence.defaultClassReplicaCount"
#       value = "\"3\""
#     }
#   ]
# }

# resource "kubernetes_ingress_v1" "longhorn" {
#   metadata {
#     name      = "longhorn-ingress"
#     namespace = helm_release.longhorn.namespace
#   }
#   spec {
#     ingress_class_name = "tailscale"
#     default_backend {
#       service {
#         name = "longhorn-frontend"
#         port {
#           number = 80
#         }
#       }
#     }
#     tls {
#       hosts = ["longhorn"]
#     }
#   }

#   depends_on = [helm_release.longhorn]
# }