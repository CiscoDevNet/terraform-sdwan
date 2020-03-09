variable "vsphere_user" {
  type = string
}
variable "vsphere_password" {
  type = string
}
variable "vsphere_server" {
  type = string
}
variable "vmanage_template" {
  type = string
  default = ""
}
variable "vbond_template" {
  type = string
  default = ""
}
variable "vedge_template" {
  type = string
  default = ""
}
variable "vsmart_template" {
  type = string
  default = ""
}
variable "cedge_template" {
  type = string
  default = ""
}
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
  default = ""
}
variable "iso_datastore" {
  type = string
}
variable "iso_path" {
  type = string
}
variable "vmanage_device_list" {
  type = any
  default = {}
}
variable "vsmart_device_list" {
  type = any
  default = {}
}
variable "vbond_device_list" {
  type = any
  default = {}
}
variable "vedge_device_list" {
  type = any
  default = {}
}
variable "cedge_device_list" {
  type = any
  default = {}
}