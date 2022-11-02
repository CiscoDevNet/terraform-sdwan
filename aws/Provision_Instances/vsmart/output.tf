output "vsmarts_vsmartEth0Ip" {
  value = aws_instance.vsmart[*].private_ip
}

output "vsmarts_vsmartEth0EIP" {
  value = var.enable_eip_mgmt ? aws_eip.vsmart_mgmt[*].public_ip : null
}

output "vsmarts_vsmartEth1Ip" {
  value = aws_network_interface.vsmart[*].private_ips
}

output "vsmarts_vsmartEth1EIP" {
  value = aws_eip.vsmart_public[*].public_ip
}
