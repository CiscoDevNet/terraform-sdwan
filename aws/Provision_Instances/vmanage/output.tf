output "vmanages_vmanageEth0Ip" {
  value = aws_instance.vmanage[*].private_ip
}

output "vmanages_vmanageEth0EIP" {
  value = var.enable_eip_mgmt ? aws_eip.vmanage_mgmt[*].public_ip : null
}

output "vmanages_vmanageEth1Ip" {
  value = aws_network_interface.vmanage[*].private_ips
}

output "vmanages_vmanageEth1EIP" {
  value = aws_eip.vmanage_public[*].public_ip
}
