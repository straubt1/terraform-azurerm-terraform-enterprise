resource "azurerm_network_security_rule" "rule-SSH" {
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.networking.name
  name                        = "SSH"
  description                 = "Temporary SSH open for debugging."
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "rule-tfe-application" {
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.networking.name
  name                        = "TFEApp"
  description                 = "Allow HTTPS (443) traffic for the TFE Application."
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "rule-tfe-console" {
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.networking.name
  name                        = "TFEConsole"
  description                 = "Allow port 8800 traffic for the TFE Console."
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8800"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}


# update this
resource "azurerm_network_security_rule" "rule-tfe-all" {
  resource_group_name         = azurerm_resource_group.networking.name
  network_security_group_name = azurerm_network_security_group.networking.name
  name                        = "TFEALL"
  description                 = "Allow all the things..."
  priority                    = 2002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}


