output "bastion" {
  value = {
    fqdn     = module.core.bastion.fqdn
    username = module.core.bastion.username
    # key = padirnamethexpand(local_file.bastion-pem.filename)
  }
}
