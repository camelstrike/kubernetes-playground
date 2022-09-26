k apply -f projects/ilimit/paas/loki/metallb/1-namespace.yaml

helm install metallb metallb/metallb -f projects/ilimit/paas/loki/metallb/2-values-metallb.yaml --namespace metallb-system

k apply -f projects/ilimit/paas/loki/metallb/3-deploy_resources.yaml