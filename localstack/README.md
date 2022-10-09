helm repo add localstack https://localstack.github.io/helm-charts
helm repo update
helm install localstack localstack/localstack --kube-context=kind-kind --namespace localstack --create-namespace