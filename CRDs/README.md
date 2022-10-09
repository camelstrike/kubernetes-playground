Monitoring CRDs - prometheus-operato v0.60.0
https://github.com/prometheus-operator/prometheus-operator/tree/v0.60.0/example/prometheus-operator-crd-full

k apply -f ./CRDs/monitoring.coreos.com_probes.yaml
k apply -f ./CRDs/monitoring.coreos.com_servicemonitors.yaml