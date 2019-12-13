resource "local_file" "replicated_ptfe_config" {
  filename = "./work/replicated_ptfe_config.json"
  content  = data.template_file.replicated_ptfe_config.rendered
}

resource "local_file" "replicated_config" {
  filename = "./work/replicated_config.json"
  content  = data.template_file.replicated_config.rendered
}

resource "local_file" "cloud_config-primary" {
  count    = var.primary_count
  filename = "./work/cloud_config-primary-${count.index}.sh"
  content  = data.template_file.cloud_config[count.index].rendered
}

resource "local_file" "cloud_config-secondary" {
  filename = "./work/cloud_config-secondary.sh"
  content  = data.template_file.cloud_config_secondary.rendered
}

resource "local_file" "cloud_config-primary_vmss" {
  filename = "./work/cloud_config-primary-vmss.sh"
  content  = data.template_file.cloud_config_primary_vmss.rendered
}
