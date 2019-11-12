data "azurerm_client_config" "current" {}

resource "random_pet" "kv-name" {
  length = 3
}

resource "azurerm_key_vault" "keyvault" {
  resource_group_name    = azurerm_resource_group.networking.name
  location               = azurerm_resource_group.networking.location
  name                   = substr(replace(random_pet.kv-name.id, "-", ""), 0, 24)
  tenant_id              = data.azurerm_client_config.current.tenant_id
  enabled_for_deployment = true
  sku_name               = "standard"

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = formatlist("%s/32", var.public_ip_whitelist)
    virtual_network_subnet_ids = azurerm_subnet.networking.*.id
  }

  tags = var.common_tags
}

# (Optional)
# Grant access to the calling SPN or `az login` user to see things in the portal
resource "azurerm_key_vault_access_policy" "access" {
  key_vault_id = azurerm_key_vault.keyvault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = "51d9fd0e-4160-4986-90af-2500415200df"
  # object_id = data.azurerm_client_config.current.client_id

  key_permissions = [
    "get",
    "List",
    "Update",
    "Restore",
    "Backup",
    "Recover",
    "Delete",
    "Import",
    "Create",
  ]

  secret_permissions = [
    "get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
  ]
  certificate_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "ManageContacts",
    "DeleteIssuers",
    "SetIssuers",
    "ListIssuers",
    "ManageIssuers",
    "GetIssuers",
  ]
}