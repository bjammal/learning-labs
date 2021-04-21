module "windowsservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  is_windows_image    = true
  vm_os_id            = "/subscriptions/{subscription-id}/resourceGroups/bilal-packer-rg/providers/Microsoft.Compute/images/BilalPackerWindowsOSImage"
  vm_hostname         = "mywinvm" // line can be removed if only one VM module per resource group
  admin_password      = "ComplxP@ssw0rd!"
  #vm_os_simple        = "WindowsServer"
  nb_public_ip        = 1
  remote_port         = "3389"
  //public_ip_dns       = ["winsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]
  vm_size             = "Standard_DS1_v2"

  depends_on = [azurerm_resource_group.rg]
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  subnet_prefixes     = ["10.0.2.0/24"]
  subnet_names        = ["${var.prefix}subnet2"]

  depends_on = [azurerm_resource_group.rg]
}
