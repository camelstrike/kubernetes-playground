# Install Chaos Mesh - https://charts.chaos-mesh.org

helm repo add chaos-mesh https://charts.chaos-mesh.org

helm upgrade --install chaos-mesh chaos-mesh/chaos-mesh \
 --version 2.5.1 \
 --kube-context=kind-kind \
 --namespace chaos-mesh \
 --create-namespace \
 -f ./chaos-mesh/values-chaos-mesh.yaml
