# https://github.com/grafana/loki/tree/main/production/helm/loki

helm repo add grafana https://grafana.github.io/helm-charts

helm install loki grafana/loki \
    --version 3.2.1 \
    --kube-context=kind-kind \
    --namespace loki \
    --create-namespace \
    -f ./loki/values-loki.yaml 
