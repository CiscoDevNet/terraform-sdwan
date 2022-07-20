module "vbond" {
  source                 = "./vbond"
  region                 = "${data.terraform_remote_state.spam.outputs.region}"
  sdwan_cp_sg_id         = "${data.terraform_remote_state.spam.outputs.sdwan_cp_sg_id}"
  vbond_ami              = "${var.vbond_ami}"
  viptela_instances_type = "${var.vbond_instances_type}"
  ssh_pubkey_file        = "${var.ssh_pubkey_file}"
  sdwan_org              = "${var.sdwan_org}"
  counter = "${var.vbond_count}"
  subnets = "${data.terraform_remote_state.spam.outputs.subnets}"
}