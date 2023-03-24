### https://cert-manager.io/docs/installation/helm/

helm repo add jetstack https://charts.jetstack.io

## Install CRDs
helm upgrade --install cert-manager jetstack/cert-manager \
  --version v1.11.0 \
  --kube-context=kind-kind \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  -f ./cert-manager/values-cert-manager.yaml
