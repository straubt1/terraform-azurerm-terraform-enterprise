variable "tfe_license_path" {
  description = "Full local path to a valid TFE license file (*.rli)"
}

variable "console_password" {
  description = "Console password used for TFE console."
}

variable "encrypt_password" {
  description = "Encryption password used for TFE instances."
}

variable "public_ip_whitelist" {
  description = "List of IP addresses to allow into the bastion box."
  type        = list
  default     = []
}
