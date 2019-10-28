output "vsmarts_vsmartEth0Ip" {
  value = aws_instance.vsmart[*].private_ip
}

output "vsmarts_vsmartEth0EIP" {
  value = aws_eip.vsmart_1[*].public_ip
}

output "vsmarts_vsmartEth1Ip" {
  value = aws_network_interface.vsmart[*].private_ips
}

output "vsmarts_vsmartEth1EIP" {
  value = aws_eip.vsmart_2[*].public_ip
}
