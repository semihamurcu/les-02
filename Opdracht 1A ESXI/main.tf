#Esxi

resource "esxi_guest" "vm_opdracht_1A_Semih" {
  guest_name     = "vm_opdracht_1A_Semih"  
  disk_store     = "Datastore1"
  ovf_source     = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"  # Ubuntu Cloud Image

  network_interfaces {
    virtual_network = "VM Network"          
  }
}


