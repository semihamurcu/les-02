# Gebruik bestaande resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Virtueel netwerk
resource "azurerm_virtual_network" "vnet" {
  name                = "iac-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "iac-subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Publieke IP’s
resource "azurerm_public_ip" "public_ip" {
  count               = 2
  name                = "iac-pip-${count.index}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interfaces
resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "iac-nic-${count.index}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
}

# Virtuele Machines
resource "azurerm_linux_virtual_machine" "vm" {
  count               = 2
  name                = "iac-vm-${count.index}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_B2ats_v2"
  admin_username      = "iac"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "iac"
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    name                 = "osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  # CloudInit: hello.txt maken in /home/iac
  custom_data = base64encode(<<EOF
#cloud-config
write_files:
  - path: /home/iac/hello.txt
    content: |
      Hello World
    permissions: '0644'
EOF
  )
}

# Output IP's naar bestand
resource "local_file" "ip_output" {
  content  = join("\n", azurerm_public_ip.public_ip[*].ip_address)
  filename = "${path.module}/public_ips.txt"
}
