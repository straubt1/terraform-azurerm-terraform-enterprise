resource "random_string" "postgres-password" {
  length  = 24
  special = false
}

resource "random_pet" "postgres-name" {
  length = 3
  # separator = "" #can't be empty string??
}

resource "azurerm_postgresql_server" "main" {
  resource_group_name = module.core.resource_group_name
  location            = module.core.location
  name                = replace(random_pet.postgres-name.id, "-", "")

  sku {
    name     = var.postgres_server.name
    capacity = var.postgres_server.capacity
    tier     = var.postgres_server.tier
    family   = var.postgres_server.family
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = var.postgres_user
  administrator_login_password = random_string.postgres-password.result
  version                      = "9.5"
  ssl_enforcement              = "Enabled"
  tags                         = local.tags
}

resource "azurerm_postgresql_database" "main" {
  resource_group_name = module.core.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  name                = "tfe_primary"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "main" {
  resource_group_name = module.core.resource_group_name
  server_name         = azurerm_postgresql_server.main.name
  subnet_id           = module.core.networking.subnets[0].id
  name                = "postgresql-vnet-rule"
  # ignore_missing_vnet_service_endpoint = true
}
