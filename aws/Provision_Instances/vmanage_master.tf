module "vmanage" {
  source                 = "./vmanage"
  region                 = "${data.terraform_remote_state.spam.outputs.region}"
  sdwan_cp_sg_id         = "${data.terraform_remote_state.spam.outputs.sdwan_cp_sg_id}"
  vmanage_ami            = "${var.vmanage_ami}"
  viptela_instances_type = "${var.vmanage_instances_type}"
  ssh_pubkey_file        = "${var.ssh_pubkey_file}"
  sdwan_org              = "${var.sdwan_org}"
  counter                = "${var.vmanage_count}"
  mgmt_subnets           = "${data.terraform_remote_state.spam.outputs.mgmt_subnets}"
  public_subnets         = "${data.terraform_remote_state.spam.outputs.public_subnets}"
}
