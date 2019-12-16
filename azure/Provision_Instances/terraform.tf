variable "vbond_image" {}
variable "vbond_count" {}
variable "vmanage_image" {}
variable "vmanage_count" {}
variable "vsmart_image" {}
variable "vsmart_count" {}
variable "vbond_instances_type" {}
variable "vmanage_instances_type" {}
variable "vsmart_instances_type" {}
variable "username" {}
variable "password" {}


data "terraform_remote_state" "spam" {
  backend = "local"

  config = {
    path = "../Provision_VNET/terraform.tfstate"
  }
}
