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

# Requisitos:

- [kind](https://kind.sigs.k8s.io/)

        # Install kind - https://kind.sigs.k8s.io/docs/user/quick-start/
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
- Docker
- Helm
- Helm repos
                             
        for repo_name repo_url in (ingress-nginx https://kubernetes.github.io/ingress-nginx
        jetstack                        https://charts.jetstack.io
        metallb                         https://metallb.github.io/metallb
        grafana                         https://grafana.github.io/helm-charts
        prometheus-community            https://prometheus-community.github.io/helm-charts
        metrics-server                  https://kubernetes-sigs.github.io/metrics-server/
        minio                           https://charts.min.io/
        projectcalico                   https://projectcalico.docs.tigera.io/charts

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
