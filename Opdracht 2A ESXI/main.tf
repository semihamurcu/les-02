locals {
  vms = {
    web1 = "web"
    web2 = "web"
    db1  = "db"
  }
}

resource "esxi_guest" "vm" {
  for_each    = local.vms
  guest_name  = each.key
  disk_store  = var.disk_store
  ovf_source  = var.ovf_url
  memsize     = var.memory
  numvcpus    = var.vcpu

  network_interfaces {
    virtual_network = var.network_name
  }

  guestinfo = {
    "metadata"          = base64encode(templatefile("${path.module}/metadata.yaml.tftpl", {
                              hostname = each.key
                              ssh_key  = file("${var.ssh_key_path}.pub")
                              username = var.vm_user
                          }))
    "metadata.encoding" = "base64"
    "userdata"          = filebase64("${path.module}/userdata.yaml")
    "userdata.encoding" = "base64"
  }
}

resource "local_file" "ansible_inventory" {
  content = <<EOF
[web]
%{ for name, role in local.vms ~}
%{ if role == "web" }${name} ansible_host=${esxi_guest.vm[name].ip_address} ansible_user=${var.vm_user} ansible_ssh_private_key_file=${var.ssh_key_path}
%{ endif ~}
%{ endfor ~}

[db]
%{ for name, role in local.vms ~}
%{ if role == "db" }${name} ansible_host=${esxi_guest.vm[name].ip_address} ansible_user=${var.vm_user} ansible_ssh_private_key_file=${var.ssh_key_path}
%{ endif ~}
%{ endfor ~}
EOF

  filename = "${path.module}/inventory.ini"
}
