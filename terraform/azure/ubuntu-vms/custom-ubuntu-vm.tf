resource "azurerm_network_interface" "primary-nic-02" {
  name                = "${var.prefix}nic-02"
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

resource "azurerm_network_interface_security_group_association" "nicsga-02" {
  network_interface_id      = azurerm_network_interface.primary-nic-02.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}

resource "azurerm_virtual_machine" "ubuntu-vm-02" {
  name                  = "${var.prefix}vm-02"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.primary-nic-02.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  os_profile {
    computer_name  = "bilalhost"
    admin_username = "bilaladmin"
    admin_password = "bilalAdmin1234!"
  }

  //update subscription-id
  storage_image_reference {
    id = "/subscriptions/{subscription-id}/resourceGroups/bilal-packer-rg/providers/Microsoft.Compute/images/BilalPackerUbuntuImage"
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



