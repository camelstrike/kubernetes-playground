#!/bin/bash

set -e

helmfile_run() {
  helmfile deps

  HELMFILE_APPLY=$(helmfile apply)

  if [[ ${HELMFILE_APPLY} ]]; then
    ARGOCD_INITIAL_PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    echo -e "\nTo continue go to https://argocd.local"
    echo "Username: admin"
    echo -e "Password: ${ARGOCD_INITIAL_PASS}\n"
  fi
}

# Set up Kind cluster
echo "Setting up Kind cluster"
if [[ $(kind get clusters) == "kind" ]]; then
	echo "Cluster kind exists already"
else
	echo "Cluster doesnt exist, creating..."
	kind create cluster --config "${PWD}"/kind/kind-config.yaml --kubeconfig ~/.kube/config
fi

# Bootstrap kind cluster with helmfile
helmfile_run
