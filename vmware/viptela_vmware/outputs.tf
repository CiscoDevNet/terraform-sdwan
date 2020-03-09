output "ip_addresses" {
  value = [for v in vsphere_virtual_machine.vm : v.default_ip_address]
}
