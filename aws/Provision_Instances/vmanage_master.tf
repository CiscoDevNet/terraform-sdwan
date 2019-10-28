module "vmanage" {
  source                 = "./vmanage"
  region                 = "${data.terraform_remote_state.spam.outputs.region}"
  Vipela_Control_Plane   = "${data.terraform_remote_state.spam.outputs.Vipela_Control_Plane}"
  vmanage_ami              = "${var.vmanage_ami}"
  viptela_instances_type = "${var.vmanage_instances_type}"
  counter = "${var.vmanage_count}"
  subnets = "${data.terraform_remote_state.spam.outputs.subnets}"
}
