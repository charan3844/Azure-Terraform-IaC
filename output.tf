output "rgnamefunction" {
  value = join("",[var.prefix], [var.rgname])
}

output "rgid" {
  value = azurerm_resource_group.RG.id
}

output "vnetname" {
  value = azurerm_virtual_network.VNET.name
}

output "vnetid" {
  value = azurerm_resource_group.VNET.id
}

output "vnetfunction" {
  value = join("",[var.prefix], [var.vnetname])
}

output "publicipid" {
  value = azurerm_windows_virtual_machine.VM.id
}

output "private_ip" {
  value = azurerm_windows_virtual_machine.VM.private_ip_address
}

output "username" {
  value = lower(var.username)
}

output "password" {
  value     = azurerm_windows_virtual_machine.VM.admin_password
  sensitive = true
  description = "Output is the sensitive data"
}


