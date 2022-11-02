# Install weavescope - https://www.weave.works/docs/scope/latest/installing/#k8s

kubectl apply \
    --context=kind-kind \
    -f https://github.com/weaveworks/scope/releases/download/v1.13.2/k8s-scope.yaml

# Open Scope in Your Browser

kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040
