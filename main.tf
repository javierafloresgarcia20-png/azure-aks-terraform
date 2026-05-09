terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

# =============================================
# Resource Group
# =============================================
resource "azurerm_resource_group" "rg" {
  name     = "rg-aks-lab"
  location = var.location

  tags = {
    Environment = "Lab"
    Project     = "AKS-HomeLab"
  }
}

# =============================================
# Random Suffix for Unique Names
# =============================================
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# =============================================
# Azure Container Registry (ACR)
# =============================================
resource "azurerm_container_registry" "acr" {
  name                = "acr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = { Environment = "Lab" }
}

# =============================================
# Azure Kubernetes Service (AKS)
# =============================================
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "system"
    vm_size             = var.node_size
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
    node_count          = 1
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = { Environment = "Lab" }
}

# Grant AKS cluster pull access to ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}

# =============================================
# Outputs
# =============================================
output "kube_config" {
  description = "Raw kubeconfig for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "acr_login_server" {
  description = "ACR login server"
  value       = azurerm_container_registry.acr.login_server
}