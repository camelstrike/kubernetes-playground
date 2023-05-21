# https://github.com/grafana/loki/tree/main/production/helm/loki

helm repo add grafana https://grafana.github.io/helm-charts

helm upgrade --install loki grafana/loki \
 --version 3.3.1 \
 --kube-context=kind-kind \
 --namespace loki \
 --create-namespace \
 --wait \
 -f ./loki/values-loki.yaml
