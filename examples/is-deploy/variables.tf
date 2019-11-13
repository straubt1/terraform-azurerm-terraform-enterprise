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



variable "postgres_server" {
  description = "Postgres server Azure settings."
  type = object({
    tier     = string
    name     = string
    family   = string
    capacity = number
  })
  default = {
    tier     = "GeneralPurpose"
    name     = "GP_Gen5_2"
    family   = "Gen5"
    capacity = 2
  }
}

variable "postgres_user" {
  description = "Postgres user name."
  default     = "psqladmin"
}

variable "storage_account" {
  description = "Storage Account Azure settings."
  type = object({
    tier = string
    type = string
  })
  default = {
    tier = "Standard"
    type = "LRS"
  }
}
