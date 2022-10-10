### https://cert-manager.io/docs/installation/helm/

## Install CRDs
helm install \
  cert-manager jetstack/cert-manager \
  --kube-context=kind-kind \
  --namespace cert-manager \
  --create-namespace \
  --version v1.9.1 \
  --set installCRDs=true
