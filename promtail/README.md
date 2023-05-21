# Install Promtail - https://grafana.com/docs/loki/latest/clients/promtail/installation/#helm

helm upgrade --install promtail grafana/promtail \
 --version 6.6.0 \
 --kube-context=kind-kind \
 --namespace promtail \
 --create-namespace \
 --set "loki.serviceName=loki" \
 -f ./promtail/values-promtail.yaml
