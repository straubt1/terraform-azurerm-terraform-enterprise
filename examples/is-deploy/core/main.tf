resource "azurerm_resource_group" "networking" {
  name     = "${var.namespace}-rg"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_virtual_network" "networking" {
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  name                = "${var.namespace}-vnet"
  address_space       = [var.vnet_address_space]
  tags                = var.common_tags
}

resource "azurerm_subnet" "networking" {
  resource_group_name  = azurerm_resource_group.networking.name
  virtual_network_name = azurerm_virtual_network.networking.name
  count                = length(var.subnet_address_spaces)
  name                 = "${var.subnet_address_spaces[count.index].name}-subnet"
  address_prefix       = var.subnet_address_spaces[count.index].address_space

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
  # NSG must be assigned twice. See issue https://github.com/terraform-providers/terraform-provider-azurerm/issues/2526
  network_security_group_id = azurerm_network_security_group.networking.id
}

resource "azurerm_network_security_group" "networking" {
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  # count               = length(var.subnet_address_spaces)
  name = "${var.namespace}-nsg"
  tags = var.common_tags
}

resource "azurerm_subnet_network_security_group_association" "networking" {
  count                     = length(var.subnet_address_spaces)
  subnet_id                 = azurerm_subnet.networking[count.index].id
  network_security_group_id = azurerm_network_security_group.networking.id
}
