Easily set up a K8S cluster locally using helm charts with observability tools ready to go!

This project will install/configure:
- calico
- metrics-server
- monitoring CRDs
- cert-manager
- ingress-nginx
- minio
- kube-prometheus-stack
- loki
- promtail

TODO:
- Instalar metallb para hacer pruebas con loadbalancer
- Tweak services
- Añadir network policies
- Implementar kind en Github Pipeline
- Aplicar resource limits/claims a pods que falten

# Requisitos:

- [kind](https://kind.sigs.k8s.io/)

        # Install kind - https://kind.sigs.k8s.io/docs/user/quick-start/
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-linux-amd64
        chmod +x ./kind
        sudo mv ./kind /usr/local/bin/kind
- Docker
- Helm
- Helm repos
                             
        helm repo add jetstack https://charts.jetstack.io
        helm repo add grafana https://grafana.github.io/helm-charts
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
        helm repo add minio https://charts.min.io/
        helm repo add projectcalico https://projectcalico.docs.tigera.io/charts

# Uso

Inicializar cluster ejecutando cluster-provision.sh script

    time bash cluster-provision.sh

Añadir hosts a /etc/hosts

    CONTROL_PLANE_DOCKER_IP ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local console.minio.local minio.local

    Example:
    172.18.0.3 ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local console.minio.local minio.local argocd.local chaos-mesh.local

Delete cluster

    kind delete cluster --name kind

Pause/Resume cluster

        # Pause
        for node in kind-control-plane kind-worker kind-worker2; do docker pause $node;done

        # Resume
        for node in kind-control-plane kind-worker kind-worker2; do docker unpause $node;done

Access services:
- https://grafana.local - admin/prom-operator
- https://console.minio.local - loki/loki1234 or admin/admin123
- https://prometheus.local
- https://alertmanager.local
- https://pushgateway.local
