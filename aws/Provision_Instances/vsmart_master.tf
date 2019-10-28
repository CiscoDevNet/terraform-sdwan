module "vsmart" {
  source                 = "./vsmart"
  region                 = "${data.terraform_remote_state.spam.outputs.region}"
  Vipela_Control_Plane   = "${data.terraform_remote_state.spam.outputs.Vipela_Control_Plane}"
  vsmart_ami              = "${var.vsmart_ami}"
  viptela_instances_type = "${var.vsmart_instances_type}"
  counter = "${var.vsmart_count}"
  subnets = "${data.terraform_remote_state.spam.outputs.subnets}"
}
