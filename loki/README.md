# https://github.com/grafana/loki/tree/main/production/helm/loki

helm repo add grafana https://grafana.github.io/helm-charts

h install loki grafana/loki -f ./loki/values-loki.yaml --namespace loki --create-namespace