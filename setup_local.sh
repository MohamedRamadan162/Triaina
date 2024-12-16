#!/bin/bash

# Load environment variables from container_registry.env file
if [ -f container_registry.env ]; then
    source container_registry.env
    echo "Loaded environment variables from container_registry.env"
else
    echo "container_registry.env file not found!"
    exit 1
fi

# Change directory to the Terraform configuration folder
echo "Changing directory to 'terraform'..."
cd terraform || {
    echo "Terraform directory not found!"
    exit 1
}

# Run tflocal apply and display the output
echo "Running tflocal apply..."
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

# Go back to the previous directory
echo "Changing back to the previous directory..."
cd ..

# Run skaffold dev and show the output
echo "Running skaffold dev..."
skaffold dev
