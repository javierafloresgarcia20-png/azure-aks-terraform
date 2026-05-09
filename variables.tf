variable "location" {
  description = "Azure region"
  default     = "westus2"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  default     = "aks-demo"
}

variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  default     = "aksdemo"
}

variable "node_size" {
  description = "VM size for nodes"
  default     = "Standard_B2s_v2"
}