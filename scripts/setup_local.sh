#!/bin/bash

# Load environment variables from container_registry.env file
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "ROOT_DIR is set to $ROOT_DIR"
if [ -f $ROOT_DIR/.env ]; then
    source $ROOT_DIR/container_registry.env
    echo "Loaded environment variables from container_registry.env"
else
    echo "container_registry.env file not found!"
    exit 1
fi

# Start localstack
echo "Starting localstack..."
LOCALSTACK_AUTH_TOKEN=$LOCALSTACK_AUTH docker compose -f $ROOT_DIR/../localstack/localstack.docker-compose.yaml up -d
echo "Localstack started."

# Run tflocal apply and display the output
echo "Running tflocal apply..."
cd $ROOT_DIR/../terraform
tflocal init --upgrade
tflocal apply --auto-approve
echo "tflocal apply completed."

# Update kubeconfig to connect to the EKS cluster using awslocal
echo "Updating kubeconfig for EKS cluster..."
awslocal eks update-kubeconfig --name triaina-eks-cluster
echo "Kubeconfig update completed."

# Create the Docker registry secret in Kubernetes
echo "Creating Docker registry secret..."
kubectl create secret docker-registry ghcr-secret \
    --docker-server=$SERVER \
    --docker-username=$USERNAME \
    --docker-password=$PASSWORD \
    --docker-email=$EMAIL
echo "Docker registry secret created."

# Define repository names in an array
repo_names=(
    "triaina-auth-module",
    "triaina-user-module",
    "triaina-course-module",
    "triaina-static-content-module"
)

for repo_name in "${repo_names[@]}"; do
    echo "Creating ECR repository: $repo_name"
    awslocal ecr create-repository \
        --repository-name "$repo_name" \
        --image-scanning-configuration scanOnPush=true \
        --region us-west-1

    # Check if the command was successful
    if [ $? -eq 0 ]; then
        echo "Successfully created repository: $repo_name"
    else
        echo "Failed to create repository: $repo_name"
    fi
    echo "----------------------------------------"
done

# Cluster specific settings to save network
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
helm repo add kong https://charts.konghq.com
helm repo update
helm install kong kong/ingress -f "${ROOT_DIR}/../k8s/api-gateway/config/kong-values.yaml" --namespace kong --create-namespace --wait
