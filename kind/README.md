# Cluster deployment

# Create cluster
kind create cluster --config ~/kind-config.yaml --kubeconfig ~/.kube/config

# Install nginx ingress
kubectl apply  --context=kind-kind --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# Wait for ingress service to come up
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

# Install metrics server (for HPA or VPA to work)
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm upgrade --kube-context=kind-kind --install --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server --namespace kube-system