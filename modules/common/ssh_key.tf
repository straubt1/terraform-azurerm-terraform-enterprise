resource "tls_private_key" "default" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.default.private_key_pem
  filename = local.private_key_filename
}

resource "null_resource" "chmod" {
  triggers = {
    key_data = local_file.private_key_pem.content
  }

  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_filename}"
  }
}

