variable "datacenter" {}
variable "cluster" {}
variable "datastore" {}
variable "template" {}
variable "vm_num_cpus" {}
variable "vm_memory" {}
variable "vm_add_disks" {
  type = list(number)
}
variable "vm_thin_provisioned" {}
variable "device_list" {
  type = any
}
