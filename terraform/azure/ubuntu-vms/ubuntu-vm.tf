
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}ResourceGroup"
  location = "eastus"

  tags = {
    environment = "Bilal Terraform Lab"
  }
}

resource "azurerm_virtual_network" "primary" {
  name                = "${var.prefix}Vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "Bilal Terraform Lab"
  }
}

resource "azurerm_subnet" "primary" {
  name                 = "${var.prefix}subnet1"
  address_prefixes     = ["10.10.1.0/24"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.primary.name
}

resource "azurerm_public_ip" "mypublicip" {
  name                = "${var.prefix}PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Bilal Terraform Lab"
  }
}

resource "azurerm_network_security_group" "mynsg" {
  name                = "${var.prefix}NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Bilal Terraform Lab"
  }
}

resource "azurerm_network_interface" "primary-nic-01" {
  name                = "${var.prefix}nic-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testIpConfiguration"
    subnet_id                     = azurerm_subnet.primary.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }

  tags = {
    environment = "Bilal Terraform Lab"
  }
}

resource "azurerm_network_interface_security_group_association" "nicsga-01" {
  network_interface_id      = azurerm_network_interface.primary-nic-01.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}

resource "azurerm_virtual_machine" "ubuntu-vm-01" {
  name                  = "${var.prefix}vm-01"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.primary-nic-01.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "bilalhost"
    admin_username = "bilaladmin"
    admin_password = "bilalAdmin1234!"
  }

  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    create_option     = "FromImage"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Bilal Terraform Lab"
  }
}



