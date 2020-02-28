variable "datacenter" {
  type = string
}
variable "cluster" {
  type = string
}
variable "datastore" {
  type = string
}
variable "resource_pool" {
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
variable "device_list" {
  type = map(object({}))
}
