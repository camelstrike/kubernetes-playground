#!/bin/bash

set -e

# Kind
echo "Setting up Kind cluster"
if [[ $(kind get clusters) == "kind" ]]
    then
        echo "Cluster kind exists already"
else
    echo "Cluster doesnt exist, creating..."
    kind create cluster --config ./kind/kind-config.yaml --kubeconfig ~/.kube/config
fi

# Install metrics
echo "Installing metrics"
helm upgrade --install metrics-server metrics-server/metrics-server \
    --version 3.8.2 \
    --kube-context=kind-kind \
    --namespace kube-system \
    --set args={--kubelet-insecure-tls}

# Install Monitoring CRDs
echo "Installing CRDs"
kubectl apply --context=kind-kind -f ./CRDs/monitoring.coreos.com_probes.yaml
kubectl apply --context=kind-kind -f ./CRDs/monitoring.coreos.com_servicemonitors.yaml
kubectl apply --context=kind-kind -f ./CRDs/monitoring.coreos.com_prometheusrules.yaml

## Install Cert Manager
echo "Installing Cert Manager"
helm upgrade --install cert-manager jetstack/cert-manager \
  --version v1.9.1 \
  --kube-context=kind-kind \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true

# Install ingress nginx
echo "Installing Nginx Ingress"
kubectl apply \
    --context=kind-kind \
    --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
#     --version 4.2.5 \
#     --kube-context=kind-kind \
#     --namespace ingress-nginx \
#     --create-namespace \
#     -f ./ingress-nginx/values-ingress-nginx.yaml

kubectl wait --namespace ingress-nginx \
    --context=kind-kind \
    --for=condition=Ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=90s

# Install MinIO
echo "Installing MinIO"
helm upgrade --install minio minio/minio \
    --version 4.0.15 \
    --kube-context=kind-kind \
    --namespace minio \
    --create-namespace \
    -f ./minio/values-minio.yaml

# Install Prometheus
echo "Installing Prometheus"
helm upgrade --install prometheus prometheus-community/prometheus \
    --version 15.14.0 \
    --kube-context=kind-kind \
    --namespace prometheus \
    --create-namespace \
    -f ./prometheus/values-prometheus.yaml

# Install Grafana
echo "Installing Grafana"
helm upgrade --install grafana grafana/grafana \
    --version 6.38.7 \
    --kube-context=kind-kind \
    --namespace grafana \
    --create-namespace \
    -f ./grafana/values-grafana.yaml

# Install Loki
echo "Installing Loki"
helm upgrade --install loki grafana/loki \
    --version 3.2.1 \
    --kube-context=kind-kind \
    --namespace loki \
    --create-namespace \
    -f ./loki/values-loki.yaml

# Install Promtail
echo "Installing Promtail"
helm upgrade --install promtail grafana/promtail \
    --version 6.6.0 \
    --kube-context=kind-kind \
    --namespace promtail \
    --create-namespace \
    --set "loki.serviceName=loki" \
    -f ./promtail/values-promtail.yaml
