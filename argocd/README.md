# Install ArgoCD - https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd

helm repo add argo https://argoproj.github.io/argo-helm

helm upgrade --install argocd argo/argo-cd \
    --version 5.24.0 \
    --kube-context=kind-kind \
    --namespace argo-cd \
    --create-namespace \
    -f ./argo-cd/values-argo-cd.yaml
