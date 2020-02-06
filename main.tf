provider "helm" {
  version = "~> 1.0"
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