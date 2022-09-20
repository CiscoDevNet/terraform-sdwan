variable "vbond_ami" {}
variable "vbond_count" {}
variable "vmanage_ami" {}
variable "vmanage_count" {}
variable "vsmart_ami" {}
variable "vsmart_count" {}
variable "vbond_instances_type" {}
variable "vmanage_instances_type" {}
variable "vsmart_instances_type" {}
variable "ssh_pubkey" {}
variable "sdwan_org" {}
variable "network_state_file" {
  default = "../Provision_VPC/terraform.tfstate"
}

data "terraform_remote_state" "spam" {
  backend = "local"

  config = {
    path = "${var.network_state_file}"
  }
}
