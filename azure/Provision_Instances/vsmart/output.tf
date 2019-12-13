output "vsmarts_vsmartEth0Ip" {
  value = azurerm_network_interface.vsmart_1[*].private_ip_address
}

output "vsmarts_vsmartEth0PIP" {
  value = azurerm_public_ip.vsmart_1[*].ip_address
}

output "vsmarts_vsmartEth1Ip" {
  value = azurerm_network_interface.vsmart_2[*].private_ip_address
}

output "vsmarts_vsmartEth1PIP" {
  value = azurerm_public_ip.vsmart_2[*].ip_address
}
