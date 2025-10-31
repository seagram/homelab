resource "null_resource" "wait_for_k8s" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
}
