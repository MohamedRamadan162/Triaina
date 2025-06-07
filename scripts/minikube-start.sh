#!/bin/bash

# Start minikube with Docker driver and enable registry addon
minikube start --driver=docker
echo "Minikube started"

# # Set up registry proxy
# docker run -d --name registry-proxy --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip):5000"
# echo "Registry proxy set up at $(minikube ip):5000"

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
