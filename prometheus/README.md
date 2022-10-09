---
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus --kube-context=kind-kind --namespace prometheus --create-namespace -f ./prometheus/values-prometheus.yaml