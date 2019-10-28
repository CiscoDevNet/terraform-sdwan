output "region" {
  value = "${var.region}"
}

output "viptela_vpc_id" {
  value = "${aws_vpc.viptela.id}"
}

output "cidr_block" {
  value = "${var.cidr_block}"
}

output "Vipela_Control_Plane" {
  value = "${aws_security_group.Vipela_Control_Plane.id}"
}

output "subnets" {
  value = ["${aws_subnet.public_subnet_az_1.id}", "${aws_subnet.public_subnet_az_2.id}"]
}
