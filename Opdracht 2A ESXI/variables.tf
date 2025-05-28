variable "disk_store" {
  description = "De naam van de datastore waarop de VM-disks worden geplaatst."
  type        = string
  default     = "Datastore1"
}

variable "ovf_url" {
  description = "De URL van het Ubuntu 24.04 OVA image."
  type        = string
  default     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"
}

variable "memory" {
  description = "Het geheugen per VM in MB."
  type        = number
  default     = 2048
}

variable "vcpu" {
  description = "Het aantal vCPUs per VM."
  type        = number
  default     = 1
}

variable "network_name" {
  description = "Naam van het virtuele netwerk op ESXi."
  type        = string
  default     = "VM Network"
}

variable "vm_user" {
  description = "De gebruikersnaam die via cloud-init wordt aangemaakt."
  type        = string
  default     = "ubuntu"
}

variable "ssh_key_path" {
  description = "Pad naar de private SSH key (ED25519). De public key wordt automatisch gezocht via `.pub` extensie."
  type        = string
  default     = "~/.ssh/devhostnieuw"
}
