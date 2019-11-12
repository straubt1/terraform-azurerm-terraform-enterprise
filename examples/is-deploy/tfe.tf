module "tfe_cluster" {
  source = "../../"

  license_file                 = "./keys/tfe-license.rli"
  resource_group_name          = module.core.resource_group_name
  virtual_network_name         = module.core.networking.vnet_name
  subnet                       = module.core.networking.subnets[0].name
  key_vault_name               = module.core.keyvault.name
  domain                       = local.hostname
  tls_pfx_certificate          = "./keys/acme.pfx"
  tls_pfx_certificate_password = ""

  primary_vm_size   = "Standard_D2s_v3"
  secondary_vm_size = "Standard_D2s_v3"
  secondary_count   = 2
}


output "tfe_cluster" {
  value = {
    application_endpoint         = "${module.tfe_cluster.application_endpoint}"
    application_health_check     = "${module.tfe_cluster.application_health_check}"
    install_id                   = "${module.tfe_cluster.install_id}"
    installer_dashboard_endpoint = "${module.tfe_cluster.installer_dashboard_endpoint}"
    installer_dashboard_password = "${module.tfe_cluster.installer_dashboard_password}"
    primary_public_ip            = "${module.tfe_cluster.primary_public_ip}"
    ssh_config_file              = "${module.tfe_cluster.ssh_config_file}"
    ssh_private_key              = "${module.tfe_cluster.ssh_private_key}"
  }
}