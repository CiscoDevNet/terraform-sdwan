output "vbonds_vbondEth0Ip" {
  value = azurerm_network_interface.vbond_1[*].private_ip_address
}

output "vbonds_vbondEth0PIP" {
  value = azurerm_public_ip.vbond_1[*].ip_address
}

output "vbonds_vbondEth1Ip" {
  value = azurerm_network_interface.vbond_2[*].private_ip_address
}

output "vbonds_vbondEth1PIP" {
  value = azurerm_public_ip.vbond_2[*].ip_address
}
