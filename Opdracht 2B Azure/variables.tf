variable "resource_group_name" {
  type        = string
  description = "De naam van de Azure resource group"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "De regio waar resources gedeployed worden"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Pad naar je publieke SSH key"
}
