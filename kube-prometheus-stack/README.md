# Install KPS

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
    --version 45.7.1 \
    --kube-context=kind-kind \
    --namespace kube-prometheus-stack \
    --create-namespace \
    --wait \
    -f ./kube-prometheus-stack/values-kps.yaml