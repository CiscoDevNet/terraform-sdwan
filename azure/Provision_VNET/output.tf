output "region" {
  value = "${var.region}"
}

output "resource_group" {
  value = "${azurerm_resource_group.ViptelaControllers.name}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}

output "viptela_security_group" {
  value = "${azurerm_network_security_group.ViptelaControllers.id}"
}

output "subnet" {
  value = "${azurerm_subnet.ViptelaControllers.id}"
}
