provider "aws" {
  region                   = "${data.terraform_remote_state.spam.outputs.region}"
}
