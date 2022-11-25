output "vbonds_vbondEth0Ip" {
  value = aws_instance.vbond.private_ip
}

output "vbonds_vbondEth0EIP" {
  value = var.enable_eip_mgmt ? aws_eip.vbond_mgmt[*].public_ip : null
}

output "vbonds_vbondEth1Ip" {
  value = aws_network_interface.vbond.private_ips
}

output "vbonds_vbondEth1EIP" {
  value = aws_eip_association.vbond_public.public_ip
}
