output "vbonds_vbondEth0Ip" {
  value = aws_instance.vbond[*].private_ip
}

output "vbonds_vbondEth0EIP" {
  value = aws_eip.vbond_1[*].public_ip
}

output "vbonds_vbondEth1Ip" {
  value = aws_network_interface.vbond[*].private_ips
}

output "vbonds_vbondEth1EIP" {
  value = aws_eip.vbond_2[*].public_ip
}
