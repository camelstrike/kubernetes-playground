# Install kind - https://kind.sigs.k8s.io/docs/user/quick-start/

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Increase inotify resource limits (you may hit "too many open files" errors otherwise)

https://kind.sigs.k8s.io/docs/user/known-issues/#pod-errors-due-to-too-many-open-files

# Create cluster

kind create cluster --config ./kind/kind-config.yaml --kubeconfig ~/.kube/config

# Extras

- Install metrics
- Install Monitoring CRDs
- Install cert-manager
- Install ingress-nginx

# Install ingress nginx

kubectl apply --context=kind-kind --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
