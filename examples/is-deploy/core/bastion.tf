locals {
  bastion_vm_user = "bastionadmin"
}

resource "random_pet" "bastion" {
  length = 2
}

resource "azurerm_public_ip" "bastion" {
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  name                = "${var.namespace}-bastion"
  allocation_method   = "Static"
  domain_name_label   = "bastion-${random_pet.bastion.id}"
  tags                = var.common_tags
}

resource "azurerm_network_interface" "bastion" {
  resource_group_name = azurerm_resource_group.networking.name
  location            = azurerm_resource_group.networking.location
  name                = "bastion-nic"

  ip_configuration {
    name = "ipconfig"
    # just drop in first subnet - hacky
    subnet_id                     = azurerm_subnet.networking[0].id
    public_ip_address_id          = azurerm_public_ip.bastion.id
    private_ip_address_allocation = "dynamic"
  }
  tags = var.common_tags
}


resource "azurerm_virtual_machine" "bastion" {
  resource_group_name              = azurerm_resource_group.networking.name
  location                         = azurerm_resource_group.networking.location
  name                             = "bastion-vm"
  network_interface_ids            = [azurerm_network_interface.bastion.id]
  vm_size                          = "Standard_D1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "bastionvm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "bastionvm"
    admin_username = var.bastion.username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.bastion.username}/.ssh/authorized_keys"
      key_data = var.bastion.public_key
    }
  }
  tags = var.common_tags
}