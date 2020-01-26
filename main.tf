resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller.metadata.0.name
    namespace = kubernetes_service_account.tiller.metadata.0.namespace
  }
}

provider "helm" {
  namespace       = kubernetes_cluster_role_binding.tiller.subject.0.namespace
  service_account = kubernetes_cluster_role_binding.tiller.subject.0.name
}

data "helm_repository" "argoproj" {
  name = "argo"
  url  = "https://argoproj.github.io/argo-helm"
}

resource "helm_release" "argocd" {
  name       = "argo-cd"
  namespace  = "argo-cd"
  repository = data.helm_repository.argoproj.metadata[0].name
  chart      = "argo-cd"
}