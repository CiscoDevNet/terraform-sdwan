output "vmanage_ip_addresses" {
  value = "${module.provision_vmanage_vmware.ip_addresses}"
}

output "vsmart_ip_addresses" {
  value = "${module.provision_vsmart_vmware.ip_addresses}"
}

output "vbond_ip_addresses" {
  value = "${module.provision_vbond_vmware.ip_addresses}"
}

output "vedge_ip_addresses" {
  value = "${module.provision_vedge_vmware.ip_addresses}"
}

output "cedge_ip_addresses" {
  value = "${module.provision_cedge_vmware.ip_addresses}"
}
