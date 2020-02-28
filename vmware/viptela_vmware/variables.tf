variable "datacenter" {
  type = string
}
variable "cluster" {
  type = string
}
variable "resource_pool" {
  type = string
}
variable "datastore" {
  type = string
}
variable "iso_datastore" {
  type = string
}
variable "iso_path" {
  type = string
}
variable "template" {
  type = string
}
variable "vm_num_cpus" {
  type = number
}
variable "vm_memory" {
  type = number
}
variable "vm_add_disks" {
  type = list(number)
}
variable "vm_thin_provisioned" {
  type = bool
}

# The device_list object keys should have type constraints, but ipv4_gateway is optional
#
# type = map(object({
#   networks = list(string)
#   ipv4_address = string
#   ipv4_gateway = string
# }))

variable "device_list" {
  type = map(object({}))
}
variable "cloudinit_path" {
  type = string
}
