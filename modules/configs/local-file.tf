resource "local_file" "replicated_ptfe_config" {
  filename = "./work/replicated_ptfe_config.json"
  content  = data.template_file.replicated_ptfe_config.rendered
}
