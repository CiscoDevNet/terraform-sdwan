output "ip_addresses" {
  value = [for v in vsphere_virtual_machine.vm : {name = v.name, default_ip_address = v.default_ip_address}]
}
