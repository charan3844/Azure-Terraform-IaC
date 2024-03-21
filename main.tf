# Terraform block -1000
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.86.0"
    }
  }
}

# Provider Block
# Terraform authenticating using the Azure CLI, Service Principal, OpenID Connect (OIDC) and Managed Service Identity (MSI).
provider "azurerm" {
  features {} 
  Charan
  Devara Saicharan
  client_id       = "2d673968-6dc2-4ad9-90bb-34b5350ebde9"
  client_secret   = "LSD8Q~noOZhEiEO~epgqNLeSJVnXgjawuqAYZcau"
  client_secret   = "LSD8Q~noOZhEiEO~epgqNLeSJVnXgjawuqAYZcau"
  client_id       = "2d673968-6dc2-4ad9-90bb-34b5350ebde9"
}

#Resorce Block
#Creating Resource group
resource "azurerm_resource_group" "RG" {
  name     = join("",[var.prefix], [var.rgname])   #Comma mandatory
  location = var.rglocation
}

#Creating Vnet
resource "azurerm_virtual_network" "VNET" {
  name                = join("",[var.prefix], [var.vnetname])
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}

#Creating Subnet
resource "azurerm_subnet" "SUBNET" {
  name                 = var.subnetname
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.VNET.name
  address_prefixes     = ["10.0.0.0/24"]
}

#Creating public IP to access (If you want to access the VM using Public IP then only you can create Public IP)
resource "azurerm_public_ip" "PUBLIC_IP" {
  name                = var.vm_public_ip
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  allocation_method   = "Static" #Static
}

#Creating azurerm_network_interface to access (Prefer access the VM using Private IP, in general Org are using Privite IP only)
resource "azurerm_network_interface" "PRIVATE_IP" {
  name                = var.privatenic
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location


  #Assigning NICs
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SUBNET.id
    private_ip_address_allocation = "Dynamic" #Static
    public_ip_address_id          = azurerm_public_ip.PUBLIC_IP.id #If we want to associcate the Public Ip Directly atthat time add it, other wise manually 

  }
}

#Creating VM
resource "azurerm_windows_virtual_machine" "VM" {
  name                  = var.vmname
  resource_group_name   = azurerm_resource_group.RG.name
  location              = azurerm_resource_group.RG.location
  size                  = var.vmsize
  admin_username        = var.username
  admin_password        = var.pswd
  network_interface_ids = [azurerm_network_interface.PRIVATE_IP.id]

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  tags = {
    environment = "Test"
  }

  provisioner "file" {

    source      = "./test.ps1"
    destination = "./temp/test.ps1"  #upload file into the remote server with all scripts or what ever

  }

      connection {
      type     = "winrm"
      user     = var.username
      password = var.pswd
      host     = self.public_ip_address
      port     = 5986
      timeout  = "3m"
      https    = true
      use_ntlm = true
      insecure = true
    }

}

# Define a network security group (NSG) for the VM
resource "azurerm_network_security_group" "NSGRULE" {
  name                = var.nsg
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  security_rule {
    name                       = "RDP"
    priority                   = 200 #100-4096
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# To attach a any additional disk, we must need the managed disk.
resource "azurerm_managed_disk" "ManagedDisk" {
  name                 = var.manageddiskname
  location             = azurerm_resource_group.RG.location
  resource_group_name  = azurerm_resource_group.RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    environment = "staging"
  }
}

#Attaching the additional data disk
resource "azurerm_virtual_machine_data_disk_attachment" "datadisk1" {
  managed_disk_id    = azurerm_managed_disk.ManagedDisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.VM.id
  lun                = "1"
  caching            = "ReadWrite"
}
