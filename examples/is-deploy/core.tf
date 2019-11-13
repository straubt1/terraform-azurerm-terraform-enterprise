provider "azurerm" {
  version = "~>1.32.1"
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
}

resource "local_file" "bastion-pem" {
  filename        = "./keys/bastion_rsa.pem"
  content         = tls_private_key.main.private_key_pem
  file_permission = "600"
}

resource "local_file" "bastion-pub" {
  filename = "./keys/bastion_rsa.pub"
  content  = tls_private_key.main.public_key_openssh

  provisioner "local-exec" {
    command = "chmod 600 ./keys/bastion_rsa.pub"
  }
}

module "core" {
  source = "./core"

  location            = local.location
  namespace           = local.namespace
  vnet_address_space  = local.vnet_address_space
  public_ip_whitelist = var.public_ip_whitelist

  subnet_address_spaces = [
    {
      name          = "tfecluster"
      address_space = local.address_space
    }
  ]

  bastion = {
    username   = local.vm_admin
    public_key = tls_private_key.main.public_key_openssh
  }

  common_tags = local.tags
}

resource "azurerm_dns_zone" "dns" {
  name                = local.hostname
  resource_group_name = module.core.resource_group_name
  zone_type           = "Public"
}
