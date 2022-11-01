Este proyecto sirve para hacer pruebas locales en k8s utilizando kind

Instala y configura:
- kind
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

Requisitos:

- Docker
- [kind](https://kind.sigs.k8s.io/)

        # Install kind - https://kind.sigs.k8s.io/docs/user/quick-start/
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind

Uso

Inicializar cluster ejecutando cluster-provision.sh script

    time bash cluster-provision.sh

Añadir hosts a /etc/hosts

    CONTROL_PLANE_DOCKER_IP ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local localstack.local console.minio.local minio.local

    Ejemplo:
    172.18.0.3 ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local localstack.local console.minio.local minio.local

Borrar cluster
    kind delete cluster --name kind

Acceder a servicios
- https://grafana.local - admin/admin
- https://console.minio.local - loki/loki1234
- https://prometheus.local
- https://alertmanager.local
- https://pushgateway.local
