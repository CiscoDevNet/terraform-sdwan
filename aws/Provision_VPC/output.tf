output "region" {
  value = "${var.region}"
}

output "sdwan_cp_vpc_id" {
  value = "${aws_vpc.sdwan_cp.id}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}

output "sdwan_cp_sg_id" {
  value = "${aws_security_group.sdwan_cp.id}"
}

output "mgmt_subnets" {
  value = ["${aws_subnet.mgmt_subnet_az_1.id}", "${aws_subnet.mgmt_subnet_az_2.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public_subnet_az_1.id}", "${aws_subnet.public_subnet_az_2.id}"]
}
