# Install calico - https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm

helm repo add projectcalico https://projectcalico.docs.tigera.io/charts

helm upgrade --install calico projectcalico/tigera-operator \
    --version v3.25.0 \
    --kube-context=kind-kind \
    --namespace tigera-operator \
    --create-namespace \
    -f ./calico/values-calico.yaml
