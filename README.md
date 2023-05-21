# kubernetes-playground

Easily set up a K8S cluster locally using helm charts with observability tools ready to go!

We overcome the chicken/egg paradigm by bootstrapping the cluster with helmfile and then provisioning the services with argocd.

The script cluster-provision-helmfile.sh will:

- Create a kind cluster with 3 nodes
- Run helmfile to bootstrap the cluster with the following charts:
  - calico
  - metrics-server
  - cert-manager
  - ingress-nginx
  - argocd
  - argocd-apps

After bootstrapping we can manage the following charts with argocd:

- kube-prometheus-stack
- prometheus-adapter
- minio
- loki
- promtail
- chaos mesh

## TODO

- Add cluster bootstrap charts to argocd-apps
- Install metallb to test loadbalancer
- Tweak services
- Add network policies
- Implement gh pipeline
- Apply resource limits/claims

## Requirements

- [kind](https://kind.sigs.k8s.io/)
- [Docker](https://github.com/docker/docker-install)
- [Helm](https://github.com/docker/docker-install)
- [Helmfile](https://github.com/helmfile/helmfile#installation)

## Usage

- Add Helm repos

      helm repo add jetstack https://charts.jetstack.io
      helm repo add grafana https://grafana.github.io/helm-charts
      helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
      helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
      helm repo add minio https://charts.min.io/
      helm repo add projectcalico https://projectcalico.docs.tigera.io/charts

- Initialize cluster

      time bash cluster-provision-helmfile.sh

- Update hosts file for ingress

  - Linux (/etc/hosts)

        CONTROL_PLANE_DOCKER_IP ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local console.minio.local minio.local

        Example:
        172.18.0.3 ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local console.minio.local minio.local argocd.local chaos-mesh.local

  - Windows (%WINDIR%\System32\drivers\etc\hosts)

        LOCALHOST ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local console.minio.local minio.local

        127.0.0.1 ingress.local grafana.local loki.local prometheus.local pushgateway.local alertmanager.local console.minio.local minio.local argocd.local chaos-mesh.local

- Access argocd and sync charts

      # Get initial admin password
      kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

- Delete cluster

      kind delete cluster --name kind

- Pause/Resume cluster

      # Pause
      for node in kind-control-plane kind-worker kind-worker2; do docker pause $node;done

      # Resume
      for node in kind-control-plane kind-worker kind-worker2; do docker unpause $node;done

Access services:

- https://argocd.local - admin/
- https://grafana.local - admin/prom-operator
- https://console.minio.local - loki/loki1234 or admin/admin123
- https://chaos-mesh.local
- https://prometheus.local
- https://alertmanager.local
- https://pushgateway.local
