# Azure AKS Terraform - Home Lab

This repository contains **Terraform IaC** to deploy a production-ready Azure Kubernetes Service (AKS) cluster with ACR integration.

## Architecture
- Resource Group
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS) Cluster
  - Auto-scaling node pool
  - System-assigned managed identity
  - Azure CNI networking
- Role Assignment (AKS → ACR Pull)

## Technologies Used
- **Terraform** ≥ 1.5
- **AzureRM Provider** ~> 4.0
- **Azure Kubernetes Service (AKS)**
- **Azure Container Registry (ACR)**
- Random provider (for unique naming)

## Features
- Auto-scaling node pool (1 → 3 nodes)
- Managed Identity (SystemAssigned)
- Integrated ACR with proper permissions
- Secure by default (no admin accounts)

## How to Deploy

```bash
# 1. Clone the repository
git clone https://github.com/javierafloresgarcia20-png/azure-aks-terraform.git
cd azure-aks-terraform

# 2. Copy and review variables
cp terraform.tfvars.example terraform.tfvars

# 3. Initialize Terraform
terraform init

# 4. Review what will be created
terraform plan

# 5. Deploy the AKS cluster
terraform apply

## After Deployment
# Export kubeconfig
terraform output -raw kube_config > kubeconfig

# Use the cluster
export KUBECONFIG=./kubeconfig
kubectl get nodes
