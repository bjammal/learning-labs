terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

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