# https://github.com/grafana/loki/tree/main/production/helm/loki

helm repo add grafana https://grafana.github.io/helm-charts

h install loki grafana/loki \
    --kube-context=kind-kind \
    --namespace loki \
    --create-namespace \
    -f ./loki/values-loki.yaml 