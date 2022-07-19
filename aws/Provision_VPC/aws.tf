provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "terraform"
  region                   = "${var.region}"
}
