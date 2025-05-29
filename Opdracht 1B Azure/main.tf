
# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-ubuntu"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create a subnet within the VNet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet-ubuntu"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "public_ip" {
  name                = "ubuntu-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

# Create a network interface and associate with subnet and public IP
resource "azurerm_network_interface" "nic" {
  name                = "ubuntu-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Create the Ubuntu VM
resource "azurerm_linux_virtual_machine" "ubuntu_vm" {
  name                = "ubuntu-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2ats_v2"
  admin_username      = "semih"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # Gebruik eigen SSH key
  admin_ssh_key {
    username   = "semih"
    public_key = file("/home/student/.ssh/azure.pub")
  }

  disable_password_authentication = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts" # Specifiek de 24.04 gevonden
    sku       = "server"
    version   = "latest"
  }
}
