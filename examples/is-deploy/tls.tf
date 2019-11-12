provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "acme_registration" "tls" {
  account_key_pem = file(local.letsencrypt_account_key_pem_path)
  email_address   = "${local.hostname}@domainsbyproxy.com"
}

resource "acme_certificate" "tls" {
  account_key_pem = file(local.letsencrypt_account_key_pem_path)
  common_name     = "*.${local.hostname}"

  dns_challenge {
    provider = "godaddy"
  }
}

resource "local_file" "pfx" {
  filename = "./keys/acme.pfx"
  content_base64   = acme_certificate.tls.certificate_p12
}

resource "local_file" "tls-issuer" {
  filename = "./keys/issuer.cert"
  content  = acme_certificate.tls.issuer_pem
}

resource "local_file" "tls-certificate" {
  filename = "./keys/certificate.cert"
  content  = acme_certificate.tls.certificate_pem
}

resource "local_file" "tls-key" {
  filename = "./keys/private.key"
  content  = acme_certificate.tls.private_key_pem
}

resource "null_resource" "pfx-generation" {
  provisioner "local-exec" {
    command = "openssl pkcs12 -export -out ./keys/certificate.pfx -inkey ./keys/private.key -in ./keys/certificate.cert -certfile ./keys/issuer.cert -password pass:"
  }
  depends_on = [local_file.tls-issuer, local_file.tls-certificate, local_file.tls-key]
}
