#!/bin/bash

set -e

# Kind
echo "Setting up Kind cluster"
if [[ $(kind get clusters) == "kind" ]]
    then
        echo "Cluster kind exists already"
else
    echo "Cluster doesnt exist, creating..."
    kind create cluster --config "$PWD"/kind/kind-config.yaml --kubeconfig ~/.kube/config
fi

# Create namespaces
NAMESPACES=(
tigera-operator
cert-manager
ingress-nginx
kube-prometheus-stack
minio
loki
promtail
)

for namespace in "${NAMESPACES[@]}"; do kubectl create ns "$namespace"; done

# Install Calico
helm upgrade --install calico projectcalico/tigera-operator \
    --version v3.25.0 \
    --kube-context=kind-kind \
    --namespace tigera-operator \
    --create-namespace \
    --wait \
    -f ./calico/values-calico.yaml

kubectl wait --context=kind-kind --for=condition=Ready node/kind-control-plane --timeout=300s
kubectl wait --context=kind-kind --for=condition=Ready node/kind-worker --timeout=300s
kubectl wait --context=kind-kind --for=condition=Ready node/kind-worker2 --timeout=300s

# # Install Monitoring CRDs
echo "Installing CRDs"
COREOS_MON_CRDS_VERSION="v0.63.0"
COREOS_MON_CRDS="https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$COREOS_MON_CRDS_VERSION/example/prometheus-operator-crd"
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_alertmanagerconfigs.yaml
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_alertmanagers.yaml
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_podmonitors.yaml
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_probes.yaml
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_prometheuses.yaml
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_prometheusrules.yaml
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_servicemonitors.yaml
kubectl apply --server-side -f "$COREOS_MON_CRDS"/monitoring.coreos.com_thanosrulers.yaml

# Install metrics
echo "Installing metrics"
helm upgrade --install metrics-server metrics-server/metrics-server \
    --version 3.8.4 \
    --kube-context=kind-kind \
    --namespace kube-system \
    --set args="{--kubelet-insecure-tls}" \
    -f ./metrics/values-metrics.yaml

## Install Cert Manager
echo "Installing Cert Manager"
helm upgrade --install cert-manager jetstack/cert-manager \
  --version v1.11.0 \
  --kube-context=kind-kind \
  --namespace cert-manager \
  --create-namespace \
  --wait \
  -f ./cert-manager/values-cert-manager.yaml

# Install ingress nginx
# echo "Installing Nginx Ingress"
# kubectl apply \
#     --context=kind-kind \
#     --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    --version 4.5.2 \
    --kube-context=kind-kind \
    --namespace ingress-nginx \
    --create-namespace \
    -f ./ingress-nginx/values-ingress-nginx.yaml

kubectl wait --namespace ingress-nginx \
    --context=kind-kind \
    --for=condition=Ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=300s
    
# Install KPS
echo "Installing KPS"
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
    --version 45.7.1 \
    --kube-context=kind-kind \
    --namespace kube-prometheus-stack \
    --create-namespace \
    --wait \
    -f ./kube-prometheus-stack/values-kps.yaml
    
# Install MinIO
echo "Installing MinIO"
helm upgrade --install minio minio/minio \
    --version 5.0.7 \
    --kube-context=kind-kind \
    --namespace minio \
    --create-namespace \
    --wait \
    -f ./minio/values-minio.yaml

# Install Loki
echo "Installing Loki"
helm upgrade --install loki grafana/loki \
    --version 4.8.0 \
    --kube-context=kind-kind \
    --namespace loki \
    --create-namespace \
    --wait \
    -f ./loki/values-loki.yaml

# Install Promtail
echo "Installing Promtail"
helm upgrade --install promtail grafana/promtail \
    --version 6.9.3 \
    --kube-context=kind-kind \
    --namespace promtail \
    --create-namespace \
    --set "loki.serviceName=loki" \
    --wait \
    -f ./promtail/values-promtail.yaml

# Install Chaos Mesh
helm upgrade --install chaos-mesh chaos-mesh/chaos-mesh \
    --version 2.5.1 \
    --kube-context=kind-kind \
    --namespace chaos-mesh \
    --create-namespace \
    -f ./chaos-mesh/values-chaos-mesh.yaml

# # Install ArgoCD
# echo "Installing ArgoCD"
# helm upgrade --install argocd argo/argo-cd \
#     --version 5.24.0 \
#     --kube-context=kind-kind \
#     --namespace argo-cd \
#     --create-namespace \
#     -f ./argo-cd/values-argo-cd.yaml
