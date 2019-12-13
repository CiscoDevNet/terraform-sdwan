output "vmanages_vmanageEth0Ip" {
  value = azurerm_network_interface.vmanage_1[*].private_ip_address
}

output "vmanages_vmanageEth0PIP" {
  value = azurerm_public_ip.vmanage_1[*].ip_address
}

output "vmanages_vmanageEth1Ip" {
  value = azurerm_network_interface.vmanage_2[*].private_ip_address
}

output "vmanages_vmanageEth1PIP" {
  value = azurerm_public_ip.vmanage_2[*].ip_address
}
