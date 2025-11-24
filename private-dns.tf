locals {
  location_normalized = lower(replace(var.location, " ", ""))
}

# Private DNS Zone for AKS
resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.${local.location_normalized}.azmk8s.io"
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "aks" {
  name                  = "aks-dns-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.aks.name
  virtual_network_id    = azurerm_virtual_network.main.id
  tags                  = var.tags
}
