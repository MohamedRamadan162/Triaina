#!/bin/bash

minikube stop
minikube delete
docker rm -f registry-proxy
echo "Minikube stopped and deleted, registry proxy removed."
