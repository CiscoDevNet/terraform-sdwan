output "default_ip_addresses" {
  value = concat(module.provision_vmanage_vmware.ip_addresses,
                 module.provision_vsmart_vmware.ip_addresses,
                 module.provision_vbond_vmware.ip_addresses,
                 module.provision_vedge_vmware.ip_addresses,
                 module.provision_cedge_vmware.ip_addresses)
}