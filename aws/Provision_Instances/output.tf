output "vbonds_vbondEth0Ip" {
  value = "${module.vbond.vbonds_vbondEth0Ip}"
}

output "vbonds_vbondEth0EIP" {
  value = var.enable_eip_mgmt ? "${module.vbond.vbonds_vbondEth0EIP}" : null
}

output "vbonds_vbondEth1Ip" {
  value = "${module.vbond.vbonds_vbondEth1Ip}"
}

output "vbonds_vbondEth1EIP" {
  value = "${module.vbond.vbonds_vbondEth1EIP}"
}

output "vmanages_vmanageEth0Ip" {
  value = "${module.vmanage.vmanages_vmanageEth0Ip}"
}

output "vmanages_vmanageEth0EIP" {
  value = var.enable_eip_mgmt ? "${module.vmanage.vmanages_vmanageEth0EIP}" : null
}

output "vmanages_vmanageEth1Ip" {
  value = "${module.vmanage.vmanages_vmanageEth1Ip}"
}

output "vmanages_vmanageEth1EIP" {
  value = "${module.vmanage.vmanages_vmanageEth1EIP}"
}

output "vsmarts_vsmartEth0Ip" {
  value = "${module.vsmart.vsmarts_vsmartEth0Ip}"
}

output "vsmarts_vsmartEth0EIP" {
  value = var.enable_eip_mgmt ? "${module.vsmart.vsmarts_vsmartEth0EIP}" : null
}

output "vsmarts_vsmartEth1Ip" {
  value = "${module.vsmart.vsmarts_vsmartEth1Ip}"
}

output "vsmarts_vsmartEth1EIP" {
  value = "${module.vsmart.vsmarts_vsmartEth1EIP}"
}