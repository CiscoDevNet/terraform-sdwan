provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraform"
  region                  = "${data.terraform_remote_state.spam.outputs.region}"
}
