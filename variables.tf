variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-aks-private"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "vnet-aks-private"
}

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "management_subnet_name" {
  description = "Name of the management cluster subnet"
  type        = string
  default     = "snet-aks-management"
}

variable "management_subnet_prefix" {
  description = "Address prefix for management subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "runtime_subnet_name" {
  description = "Name of the runtime cluster subnet"
  type        = string
  default     = "snet-aks-runtime"
}

variable "runtime_subnet_prefix" {
  description = "Address prefix for runtime subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "management_cluster_name" {
  description = "Name of the management AKS cluster"
  type        = string
  default     = "aks-management"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "management_node_count" {
  description = "Number of nodes in management cluster"
  type        = number
  default     = 3
}

variable "management_vm_size" {
  description = "VM size for management cluster nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Purpose     = "AKS-Private-Setup"
  }
}
