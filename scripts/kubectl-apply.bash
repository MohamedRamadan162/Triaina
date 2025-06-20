#!/bin/bash

# Load environment variables from container_registry.env file
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "ROOT_DIR is set to $ROOT_DIR"
MANIFEST_DIR="$(cd "$ROOT_DIR/../k8s" && pwd)"
echo "MANIFEST_DIR is set to $MANIFEST_DIR"

manifests=("$MANIFEST_DIR"/*.yaml)
manifests+=("$MANIFEST_DIR"/configmaps/*.yaml)
manifests+=("$MANIFEST_DIR"/secrets/*.yaml)
manifests+=("$MANIFEST_DIR"/api-gateway/*.yaml)
manifests+=("$MANIFEST_DIR"/triaina/*.yaml)

kubectl create namespace kong
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
for file in "${manifests[@]}"; do
    echo "Applying $file"
    kubectl apply -f "$file"
done

helm install kong kong/ingress \
    --namespace kong \
    --create-namespace \
    --set ingressController.installCRDs=false \
    --set proxy.type=LoadBalancer \
    --values ./../k8s/api-gateway/config/kong-values.yaml

kubectl patch deployment cluster-autoscaler \
    -n kube-system \
    -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
