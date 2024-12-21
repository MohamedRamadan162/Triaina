#!/bin/bash
# Start localstack
echo "Starting localstack..."
localstack start -d -e ENFORCE_IAM=1 -e EKS_K3S_IMAGE_TAG=v1.29.12-rc1-k3s1 -e DEBUG=1 -e PERSISTENCE=1
echo "Localstack started."

# Start skaffold
cd ..
skaffold dev
