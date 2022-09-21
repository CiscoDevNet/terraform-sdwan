resource "aws_instance" "vbond" {
  count = "${var.counter}"
  ami                         = "${var.vbond_ami}"
  instance_type               = "${var.viptela_instances_type}"
  vpc_security_group_ids      = ["${var.sdwan_cp_sg_id}"]
  subnet_id                   = "${var.mgmt_subnets[ count.index % length(var.mgmt_subnets) ]}"
  associate_public_ip_address = true
  source_dest_check           = true
  user_data                   = templatefile("cloud-init/vbond.user_data", {
    day0       = var.vbond_day0
    index      = count.index + 1
    hostname   = format("sdwan-vbond-%02d", count.index)
    ssh_pubkey = var.ssh_pubkey
    sdwan_org  = var.sdwan_org
  })

  tags = merge(
    var.common_tags,
    {
      Name  = "${format("sdwan-vbond-%02d", count.index)}"
    }
  )
}

resource "aws_network_interface" "vbond" {
  count = "${var.counter}"
  subnet_id                   = "${var.public_subnets[ count.index % length(var.public_subnets) ]}"
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
  tags = merge(
    var.common_tags,
    {
      Name  = "${format("eip1_vbond-%02d", count.index)}"
    }
  )
}

resource "aws_eip" "vbond_2" {
  count = "${var.counter}"
  network_interface = "${aws_network_interface.vbond[count.index].id}"
  vpc               = true
  tags = merge(
    var.common_tags,
    {
      Name  = "${format("eip2_vbond-%02d", count.index)}"
    }
  )
}
