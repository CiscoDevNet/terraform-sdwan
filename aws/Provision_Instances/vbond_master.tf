module "vbond" {
  source                 = "./vbond"
  region                 = "${data.terraform_remote_state.spam.outputs.region}"
  Vipela_Control_Plane   = "${data.terraform_remote_state.spam.outputs.Vipela_Control_Plane}"
  vbond_ami              = "${var.vbond_ami}"
  viptela_instances_type = "${var.vbond_instances_type}"
  counter = "${var.vbond_count}"
  subnets = "${data.terraform_remote_state.spam.outputs.subnets}"
}