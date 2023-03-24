#!/bin/bash

set -e

# Kind
echo "Setting up Kind cluster"
if [[ $(kind get clusters) == "kind" ]]
    then
        echo "Cluster kind exists already"
else
    echo "Cluster doesnt exist, creating..."
    kind create cluster --config "$PWD"/kind/kind-config.yaml --kubeconfig ~/.kube/config
fi

helmfile apply