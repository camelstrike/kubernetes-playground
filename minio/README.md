helm repo add minio https://charts.min.io/

helm install minio minio/minio \
    --kube-context=kind-kind \
    --namespace minio \
    --create-namespace \
    -f ./minio/values-minio.yaml

# Client - https://min.io/docs/minio/linux/reference/minio-mc.html
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv ./mc /usr/local/bin

bash +o history
mc alias set loki https://minio.local loki loki1234 --insecure
bash -o history
