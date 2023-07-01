
# After adding: locals, variables, expressions, data & output:

locals {
  suffix = "tfdemo"
  location = "westeurope"
  rgName = "rg-${local.suffix}"
  vnetName = "vnet1"
  vnetAddressSpace = ["10.0.0.0/16"]
  subnetAddressSpace = ["10.0.0.0/24"]
  subnetName = "subnet1"
  publicIpName = "pip1"
  publicIpAllocation = "Dynamic"
  nicName = "nic1"
  privateIpAllocation = "Dynamic"

}

variable "vmName" {
  type = string
}

variable "vmSku" {
  type = string
  default = "Standard_A4_v2"
  validation {
    condition = var.vmSku == "Standard_A4_v2" || var.vmSku == "Standard_A2_v2"
    error_message = "The vmSku must be one of the following: Standard_A4_v2 or Standard_A2_v2"
  }
}

variable "kvId" {
  type = string
  description = "id for the keyvault holding secrets"
}

variable "userNameSecret" {
  type = string
  default = "DefaultAdminUsername"
}

variable "passwordSecret" {
  type = string
  default = "DefaultAdminPassword"
}

data "azurerm_key_vault_secret" "userName" {
  name         = var.userNameSecret
  key_vault_id = var.kvId
}

data "azurerm_key_vault_secret" "password" {
  name         = var.passwordSecret
  key_vault_id = var.kvId
}

data "azurerm_public_ip" "pip_data" {
  name                = azurerm_public_ip.pip1.name
  resource_group_name = azurerm_resource_group.example.name
  depends_on = [
    azurerm_windows_virtual_machine.vm1
  ]
}

output "pubip" {
  value = data.azurerm_public_ip.pip_data.ip_address
}

resource "azurerm_resource_group" "example" {
  name     = local.rgName
  location = local.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = local.vnetName
  address_space       = local.vnetAddressSpace
  resource_group_name = azurerm_resource_group.example.name
  location            = local.location
}

resource "azurerm_subnet" "subnet1" {
  name                 = local.subnetName
  address_prefixes     = local.subnetAddressSpace
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = azurerm_resource_group.example.name
}

resource "azurerm_public_ip" "pip1" {
  name                = local.publicIpName
  allocation_method   = local.publicIpAllocation
  resource_group_name = azurerm_resource_group.example.name
  location            = local.location

}

resource "azurerm_network_interface" "nic1" {
  name                = local.nicName
  resource_group_name = azurerm_resource_group.example.name
  location            = local.location
  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = local.privateIpAllocation
    public_ip_address_id          = azurerm_public_ip.pip1.id
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = var.vmName
  resource_group_name = azurerm_resource_group.example.name
  location            = local.location
  size                = var.vmSku
  admin_username      = data.azurerm_key_vault_secret.userName.value
  admin_password      = data.azurerm_key_vault_secret.password.value
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg1"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-subnet1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
