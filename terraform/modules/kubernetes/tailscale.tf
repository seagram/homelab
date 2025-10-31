resource "helm_release" "tailscale_operator" {
  depends_on       = [null_resource.wait_for_k8s]
  name             = "tailscale-operator"
  repository       = "https://pkgs.tailscale.com/helmcharts"
  chart            = "tailscale-operator"
  namespace        = "tailscale"
  create_namespace = true

  set = [
    {
      name  = "oauth.clientId"
      value = var.tailscale_oauth_client_id
    },
    {
      name  = "operatorConfig.hostname"
      value = "tailscale-operator"
    }
  ]

  set_sensitive = [
    {
      name  = "oauth.clientSecret"
      value = var.tailscale_oauth_client_secret
    }
  ]
}