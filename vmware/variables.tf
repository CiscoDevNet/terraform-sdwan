variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vmanage_template" {
  default = ""
}
variable "vbond_template" {
  default = ""
}
variable "vedge_template" {
  default = ""
}
variable "vsmart_template" {
  default = ""
}
variable "cedge_template" {
  default = ""
}
variable "datacenter" {}
variable "cluster" {}
variable "datastore" {}
variable "iso_datastore" {}
variable "iso_path" {}
variable "vmanage_device_list" {
  type = any
  default = []
}
variable "vsmart_device_list" {
  type = any
  default = []
}
variable "vbond_device_list" {
  type = any
  default = []
}
variable "vedge_device_list" {
  type = any
  default = []
}
variable "cedge_device_list" {
  type = any
  default = []
}