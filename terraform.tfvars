# Example terraform.tfvars file

resource_group_name = "rg-aks-private-dev"
location            = "UK South"

vnet_name          = "vnet-aks-private"
vnet_address_space = ["10.0.0.0/16"]

management_subnet_name   = "snet-aks-management"
management_subnet_prefix = ["10.0.1.0/24"]

runtime_subnet_name   = "snet-aks-runtime"
runtime_subnet_prefix = ["10.0.2.0/24"]

management_cluster_name = "aks-management-dev"
kubernetes_version      = "1.29"
management_node_count   = 3
management_vm_size      = "Standard_D2s_v3"

environment = "dev"

tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Purpose     = "AKS-Private-Setup"
  Owner       = "DevOps-Team"
}
