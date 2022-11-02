# Install calico - https://projectcalico.docs.tigera.io/getting-started/kubernetes/helm

helm upgrade --install calico projectcalico/tigera-operator \
    --version v3.24.3 \
    --kube-context=kind-kind \
    --namespace tigera-operator \
    --create-namespace \
    -f ./calico/values-calico.yaml
