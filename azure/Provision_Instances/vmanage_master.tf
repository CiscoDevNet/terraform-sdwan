module "vmanage" {
  source                 = "./vmanage"
  region                 = "${data.terraform_remote_state.spam.outputs.region}"
  avsetvmanage           = "${data.terraform_remote_state.spam.outputs.avsetvmanage}"
  Vipela_Control_Plane   = "${data.terraform_remote_state.spam.outputs.Vipela_Control_Plane}"
  vmanage_image          = "${var.vmanage_image}"
  viptela_instances_type = "${var.vmanage_instances_type}"
  counter                = "${var.vmanage_count}"
  subnet                 = "${data.terraform_remote_state.spam.outputs.subnet}"
  resource_group_name    = "${data.terraform_remote_state.spam.outputs.resource_group_name}"
  username               = "${var.username}"
  password               = "${var.password}"
}
