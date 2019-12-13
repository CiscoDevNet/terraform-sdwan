module "vbond" {
  source                 = "./vbond"
  region                 = "${data.terraform_remote_state.spam.outputs.region}"
  avsetvbond             = "${data.terraform_remote_state.spam.outputs.avsetvbond}"
  Vipela_Control_Plane   = "${data.terraform_remote_state.spam.outputs.Vipela_Control_Plane}"
  vbond_image            = "${var.vbond_image}"
  viptela_instances_type = "${var.vbond_instances_type}"
  counter                = "${var.vbond_count}"
  subnet                 = "${data.terraform_remote_state.spam.outputs.subnet}"
  resource_group_name    = "${data.terraform_remote_state.spam.outputs.resource_group_name}"
  username               = "${var.username}"
  password               = "${var.password}"
}
