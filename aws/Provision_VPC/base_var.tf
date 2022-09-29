variable "ssh_pubkey" {}
variable "region" {}
variable "cidr_block" {}
variable "acl_cidr_blocks" {
    default = ["0.0.0.0/0"]
}
variable "acl6_cidr_blocks" {
    default = ["::/0"]
}
variable "common_tags" {}
variable "devbox_instance_type" {}