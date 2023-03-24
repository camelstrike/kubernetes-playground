helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm repo update

helm upgrade --install metrics-server metrics-server/metrics-server \
    --version 3.8.4 \
    --kube-context=kind-kind \
    --namespace kube-system \
    --set args={--kubelet-insecure-tls} \
    -f ./metrics/values-metrics.yaml
