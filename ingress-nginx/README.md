# https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    --version 4.5.2 \
    --kube-context=kind-kind \
    --namespace ingress-nginx \
    --create-namespace \
    -f ./ingress-nginx/values-ingress-nginx.yaml