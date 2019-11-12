locals {
  namespace          = "clustering-tfe"
  location           = "centralus"
  vnet_address_space = "10.0.0.0/16"
  address_space      = "10.0.0.0/24"
  vm_admin           = "tfeadmin"

  hostname = "digitalinnovation.dev"
  # domain                           = "cluster-tfe"
  hostname_tfe                     = "${local.namespace}.${local.hostname}"
  letsencrypt_account_key_pem_path = "./keys/acccount_key.pem"

  tags = {
    owner = "tstraub"
    IaC   = "Terraform"
  }
}
