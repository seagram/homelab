# resource "helm_release" "cloudnative_pg" {
#   name             = "cnpg"
#   repository       = "https://cloudnative-pg.github.io/charts"
#   chart            = "cloudnative-pg"
#   namespace        = "cnpg-system"
#   create_namespace = true
  
#   depends_on = [helm_release.longhorn]
# }