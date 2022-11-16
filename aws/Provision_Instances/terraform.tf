variable "vbond_ami" {}
variable "vbond_count" {}
variable "vbond_day0" {
  default = ""
}
variable "vmanage_ami" {}
variable "vmanage_count" {}
variable "vmanage_day0" {
  default = ""
}
variable "vsmart_ami" {}
variable "vsmart_count" {}
variable "vsmart_day0" {
  default = ""
}
variable "vbond_instances_type" {}
variable "vmanage_instances_type" {}
variable "vsmart_instances_type" {}
variable "enable_eip_mgmt" {
  default = false
}
variable "ssh_pubkey" {}
variable "sdwan_org" {}
variable "route53_zone" {
  default = ""
}
variable "network_state_file" {
  default = "../Provision_VPC/terraform.tfstate"
}

data "terraform_remote_state" "spam" {
  backend = "local"

  config = {
    path = "${var.network_state_file}"
  }
}
