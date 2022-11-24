output "region" {
  value = "${var.region}"
}

output "common_tags" {
  value = "${var.common_tags}"
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

output "vbond_eip_allocation" {
  value = "${aws_eip.vbond_public.allocation_id}"
}

output "vbond_ip" {
  value = "${aws_eip.vbond_public.public_ip}"
}
