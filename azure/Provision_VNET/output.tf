output "region" {
  value = "${var.region}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.ViptelaControllers777.name}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}

output "Vipela_Control_Plane" {
  value = "${azurerm_network_security_group.ViptelaControllers777.id}"
}

output "subnet" {
  value = "${azurerm_subnet.ViptelaControllers777.id}"
}

output "avsetvsmart" {
  value = "${azurerm_availability_set.avsetvsmart.id}"
}

output "avsetvmanage" {
  value = "${azurerm_availability_set.avsetvmanage.id}"
}

output "avsetvbond" {
  value = "${azurerm_availability_set.avsetvbond.id}"
}
