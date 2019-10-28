variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vmanage_template" {}
variable "vbond_template" {}
variable "vedge_template" {}
variable "vsmart_template" {}
variable "datacenter" {}
variable "cluster" {}
variable "datastore" {}
variable "iso_datastore" {}
variable "iso_path" {}
variable "vmanage_device_list" {
  type = any
}

variable "vsmart_device_list" {
  type = any
}

variable "vbond_device_list" {
  type = any
}

variable "vedge_device_list" {
  type = any
}