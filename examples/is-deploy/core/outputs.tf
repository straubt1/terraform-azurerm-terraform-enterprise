output "resource_group_name" {
  value = azurerm_resource_group.networking.name
}

output "location" {
  value = azurerm_resource_group.networking.location
}

output "networking" {
  value = {
    vnet_id   = azurerm_virtual_network.networking.id
    vnet_name = azurerm_virtual_network.networking.name
    subnets   = azurerm_subnet.networking[*]
  }
}

output "bastion" {
  value = {
    fqdn     = azurerm_public_ip.bastion.fqdn
    username = var.bastion.username
  }
}

output "keyvault" {
  value = {
    id   = azurerm_key_vault.keyvault.id
    name = azurerm_key_vault.keyvault.name
  }
}
