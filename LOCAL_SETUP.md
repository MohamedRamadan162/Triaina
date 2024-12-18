# Local Dev Setup Guide

This guide will walk you through installing and setting up the dependencies to start working with Triaina backend development.

---

## Prerequisites

- **Docker Desktop** (for running LocalStack in a Docker container)
- **Kubernetes (k8s)** (for managing containers)
- **Terraform** (for infrastructure management)
- **LocalStack** (for mocking AWS services)
- **tflocal** (for interacting with LocalStack using Terraform)
- **awslocal** (for interacting with LocalStack using AWS CLI commands)
- **Skaffold** (for automating Kubernetes workflows)

---

## Step 1: Install Docker Desktop

Docker Desktop is required to run LocalStack in a container.

### Docker Desktop Installation Links:
- **Windows**: [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop)
- **macOS**: [Docker Desktop for macOS](https://www.docker.com/products/docker-desktop)
- **Linux**: [Docker for Linux](https://docs.docker.com/get-docker/)

1. Download and install Docker Desktop based on your operating system.
2. Launch Docker Desktop. Ensure it is running properly.

---

## Step 2: Install Kubernetes (k8s)

Kubernetes is a container orchestration tool for managing containerized applications.

### Kubernetes Installation Links:
- **Kubernetes Documentation**: [Kubernetes Installation Guide](https://kubernetes.io/docs/setup/)

For **Windows**/**macOS**/**Linux**, follow the instructions on the official website.

After installation, verify the installation,
```bash
kubectl version
```

---

## Step 3: Install Terraform

Terraform is a tool for managing infrastructure as code, used to define and provision AWS resources.

### Terraform Installation Links:
- **Terraform Downloads**: [Terraform Official Website](https://www.terraform.io/downloads)

#### Install Terraform:

For **Windows**/**macOS**/**Linux**, follow the instructions on the official website.

After installation, verify the installation:
```bash
terraform --version
```

---

## Step 4: Install LocalStack

LocalStack is a tool to mock AWS services locally for testing and development.

### LocalStack Installation Links:
- **LocalStack Official Documentation**: [LocalStack Docs](https://docs.localstack.cloud/)

#### Install LocalStack:
For x86-64:
```bash
curl --output localstack-cli-4.0.0-linux-amd64-onefile.tar.gz \
    --location https://github.com/localstack/localstack-cli/releases/download/v4.0.0/localstack-cli-4.0.0-linux-amd64-onefile.tar.gz

```

Then extract it
```bash
sudo tar xvzf localstack-cli-4.0.0-linux-*-onefile.tar.gz -C /usr/local/bin
```

You have to authenticate localstack before using
```bash
localstack auth set-token <PLACE-YOUR-TOKEN-HERE>
```

To start LocalStack:
```bash
localstack start
```

You can check the status of LocalStack:
```bash
localstack status
```

---

## Step 5: Install tflocal

`tflocal` is a wrapper around Terraform to easily interact with LocalStack services.

### tflocal Installation Links:
- **tflocal GitHub**: [tflocal GitHub Repository](https://github.com/localstack/tflocal)

#### Install tflocal:
```bash
pip install tflocal
```

---

## Step 6: Install awslocal

`awslocal` is a CLI tool to interact with LocalStack's AWS services via AWS CLI commands.

### awslocal Installation Links:
- **awscli-local GitHub**: [awscli-local GitHub](https://github.com/localstack/awscli-local)

#### Install awslocal:
```bash
pip install awscli-local
```

---

## Step 7: Install Skaffold

Skaffold is a tool that helps you develop Kubernetes applications.

### Skaffold Installation Links:
- **Skaffold Documentation**: [Skaffold Docs](https://skaffold.dev/docs/)

#### Install Skaffold:
```bash
# For Linux x86_64 (amd64)
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
sudo install skaffold /usr/local/bin/

After installation, verify with:
```bash
skaffold version
```
---
## Step 8: Start Dev Server
To start the dev server simply run the ```setup_local.sh``` (make sure to place ```container_registry.env``` first before running) script in the root directory. It will set up the environment and run ```skaffold dev```.

After setting up the environment, running the script is unnecessary. (You have to rerun the script after every localstack restart)
Start skaffold instead using
```bash
skaffold dev
```

After starting the server you need to forward port ```32069:80``` using
```bash
kubectl port-forward service/kong-gateway-proxy 32069:80 -n kong
```
to access the EKS cluster in local dev on ```localhost:32069```

Use [localstack web app](https://app.localstack.cloud) to view your localstack resources
---
## Troubleshooting

- **Docker Desktop not running**:
  - Ensure Docker Desktop is running. Start it manually from the application if necessary.

- **AWS CLI command errors with awslocal**:
  - Make sure LocalStack is running and accessible on the correct endpoint.
  - You can verify LocalStack status using `localstack status`.

---
For more detailed documentation, refer to the official documentation for each tool:

- [LocalStack Docs](https://docs.localstack.cloud/)
- [tflocal GitHub](https://github.com/localstack/tflocal)
- [awscli-local GitHub](https://github.com/localstack/awscli-local)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Kubernetes Docs](https://kubernetes.io/docs/setup/)
- [Terraform Docs](https://www.terraform.io/docs/)
- [Skaffold Docs](https://skaffold.dev/docs/)