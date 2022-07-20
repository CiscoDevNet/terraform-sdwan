resource "aws_instance" "vbond" {
  count = "${var.counter}"
  ami                         = "${var.vbond_ami}"
  instance_type               = "${var.viptela_instances_type}"
  vpc_security_group_ids      = ["${var.sdwan_cp_sg_id}"]
  subnet_id                   = "${var.subnets[ count.index % length(var.subnets) ]}"
  associate_public_ip_address = true
  source_dest_check           = true
  user_data                   = templatefile("cloud-init/vbond.user_data", {
    hostname   = format("sdwan-vbond-%02d", count.index)
    ssh_pubkey = file(pathexpand(var.ssh_pubkey_file))
    sdwan_org  = var.sdwan_org
  })
  tags = {
    Name  = "${format("sdwan-vbond-%02d", count.index)}"
  }
}

resource "aws_network_interface" "vbond" {
  count = "${var.counter}"
  subnet_id                   = "${var.subnets[ count.index % length(var.subnets) ]}"
  security_groups             = ["${var.sdwan_cp_sg_id}"]
  source_dest_check           = true

  attachment {
    instance     = "${aws_instance.vbond[count.index].id}"
    device_index = 1
  }
}

resource "aws_eip" "vbond_1" {
  count = "${var.counter}"
  network_interface = "${aws_instance.vbond[count.index].primary_network_interface_id}"
  vpc               = true
  tags = {
    Name  = "${format("eip1_vbond-%02d", count.index)}"
  }
}

resource "aws_eip" "vbond_2" {
  count = "${var.counter}"
  network_interface = "${aws_network_interface.vbond[count.index].id}"
  vpc               = true
  tags = {
    Name  = "${format("eip_2vbond-%02d", count.index)}"
  }
}
