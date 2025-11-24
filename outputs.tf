output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "management_subnet_id" {
  description = "ID of the management subnet"
  value       = azurerm_subnet.management.id
}

output "runtime_subnet_id" {
  description = "ID of the runtime subnet"
  value       = azurerm_subnet.runtime.id
}

output "management_cluster_name" {
  description = "Name of the management AKS cluster"
  value       = azurerm_kubernetes_cluster.management.name
}

output "management_cluster_id" {
  description = "ID of the management AKS cluster"
  value       = azurerm_kubernetes_cluster.management.id
}

output "management_cluster_fqdn" {
  description = "FQDN of the management AKS cluster"
  value       = azurerm_kubernetes_cluster.management.fqdn
}

output "management_cluster_private_fqdn" {
  description = "Private FQDN of the management AKS cluster"
  value       = azurerm_kubernetes_cluster.management.private_fqdn
}

output "management_cluster_principal_id" {
  description = "Principal ID of the management cluster identity"
  value       = azurerm_kubernetes_cluster.management.identity[0].principal_id
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.aks.id
}

output "private_dns_zone_id" {
  description = "ID of the private DNS zone"
  value       = azurerm_private_dns_zone.aks.id
}

output "kube_config_raw" {
  description = "Raw kubeconfig for management cluster"
  value       = azurerm_kubernetes_cluster.management.kube_config_raw
  sensitive   = true
}
