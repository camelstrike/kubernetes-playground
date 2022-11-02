Este proyecto se puede utilizar para hacer pruebas locales en K8s

Instala y configura:
- kind
- calico
- metrics-server
- monitoring CRDs
  - monitoring.coreos.com_probes
  - monitoring.coreos.com_servicemonitors
  - monitoring.coreos.com_prometheusrules
- cert-manager
- ingress-nginx
- minio
- prometheus
- grafana
- loki
- promtail

TODO:
- Instalar ingress-nginx via helm
- Instalar metallb para hacer pruebas con loadbalancer
- Tweak services
- Añadir network policies
- Implementar kind en Gitlab Pipeline
- Aplicar resource limits/claims a pods que falten
- Utilizar imagenes del registry interno (harbor), para ser compatible con kyverno policies

# Requisitos:

- [kind](https://kind.sigs.k8s.io/)

        # Install kind - https://kind.sigs.k8s.io/docs/user/quick-start/
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
- Docker
- Helm
- Helm repos
                             
        helm repo add jetstack https://charts.jetstack.io
        helm repo add metallb https://metallb.github.io/metallb
        helm repo add grafana https://grafana.github.io/helm-charts
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
        helm repo add minio https://charts.min.io/
        helm repo add projectcalico https://projectcalico.docs.tigera.io/charts

# Uso

Inicializar cluster ejecutando cluster-provision.sh script

    time bash cluster-provision.sh

Añadir hosts a /etc/hosts

    CONTROL_PLANE_DOCKER_IP ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local localstack.local console.minio.local minio.local

    Ejemplo:
    172.18.0.3 ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local localstack.local console.minio.local minio.local

Borrar cluster

    kind delete cluster --name kind

Pausar/Reanudar cluster

        # Pausar
        for node in kind-control-plane kind-worker kind-worker2; do docker pause $node;done

        # Reanudar
        for node in kind-control-plane kind-worker kind-worker2; do docker unpause $node;done

Acceder a servicios
- https://grafana.local - admin/admin
- https://console.minio.local - loki/loki1234
- https://prometheus.local
- https://alertmanager.local
- https://pushgateway.local
