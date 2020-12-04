## kubernetes metrics-server

locals {
  namespace      = lookup(var.helm, "namespace", "kube-system")
  serviceaccount = lookup(var.helm, "serviceaccount", "eks-alb-aws-alb-ingress-controller")
}

resource "helm_release" "metrics" {
  count           = var.enabled ? 1 : 0
  name            = lookup(var.helm, "name", "metrics-server")
  chart           = lookup(var.helm, "chart", "metrics-server")
  version         = lookup(var.helm, "version", null)
  repository      = lookup(var.helm, "repository", "https://kubernetes-charts.storage.googleapis.com")
  namespace       = local.namespace
  cleanup_on_fail = lookup(var.helm, "cleanup_on_fail", true)

  dynamic "set" {
    for_each = {
      "args[0]" = "--kubelet-preferred-address-types=InternalIP"
    }
    content {
      name  = set.key
      value = set.value
    }
  }
}