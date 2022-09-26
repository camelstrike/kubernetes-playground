k apply -f projects/ilimit/paas/loki/ingress-nginx/1-namespace.yaml

h install ingress-nginx ingress-nginx/ingress-nginx -f projects/ilimit/paas/loki/ingress-nginx/2-values-ingress-nginx.yaml -n ingress-nginx