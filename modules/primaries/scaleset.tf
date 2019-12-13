resource "azurerm_virtual_machine_scale_set" "primary" {
  name                = "${local.prefix}-scaleset"
  resource_group_name = var.rg_name
  location            = var.location
  upgrade_policy_mode = "Manual"

  storage_profile_image_reference {
    publisher = var.storage_image["publisher"]
    offer     = var.storage_image["offer"]
    sku       = var.storage_image["sku"]
    version   = var.storage_image["version"]
  }

  sku {
    name     = var.vm["size"]
    tier     = "Standard" #var.vm["size_tier"]
    capacity = var.vm["count"] - 1
  }

  network_profile {
    name    = "${local.prefix}-network-profile"
    primary = true

    ip_configuration {
      name                                   = "${local.prefix}-ip-conf"
      subnet_id                              = var.subnet_id
      primary                                = true
      load_balancer_backend_address_pool_ids = [var.cluster_backend_pool_id]
    }
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = var.ssh["public_key"]
      path     = "/home/${var.username}/.ssh/authorized_keys"
    }
  }

  os_profile {
    computer_name_prefix = "${local.prefix}-"
    admin_username       = var.username
    custom_data          = var.cloud_init_vmss
  }

  os_profile_secrets {
    source_vault_id = var.key_vault["id"]

    vault_certificates {
      certificate_url = var.key_vault["cert_uri"]
    }
  }

  storage_profile_os_disk {
    create_option     = "FromImage"
    os_type           = "Linux"
    managed_disk_type = "StandardSSD_LRS"
  }

  tags = {
    "Name" = local.prefix
  }
}

