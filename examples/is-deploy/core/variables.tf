variable "namespace" {
  description = "Name to assign to resources for easy organization."
}

variable "location" {
  description = "The Azure region to deploy all infrastructure to."
}

variable "vnet_address_space" {
  description = "The network address CIDR for the Vnet address space."
}

variable "subnet_address_spaces" {
  description = "A list of subnet address spaces and names"
  type = list(object({
    name          = string
    address_space = string
  }))
}

variable "public_ip_whitelist" {
  description = "List of public IPs that need direct access to the PaaS in the Vnet (Optional)."
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "The tags to apply to all resources."
  type        = map
  default     = {}
}

variable "bastion" {
  description = "Bastion public ssh key."
  type = object({
    username   = string
    public_key = string
  })
  default = {
    username   = ""
    public_key = ""
  }
}