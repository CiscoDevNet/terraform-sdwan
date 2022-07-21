resource "aws_instance" "vmanage" {
  count = "${var.counter}"
  ami                         = "${var.vmanage_ami}"
  instance_type               = "${var.viptela_instances_type}"
  vpc_security_group_ids      = ["${var.sdwan_cp_sg_id}"]
  subnet_id                   = "${var.mgmt_subnets[ count.index % length(var.mgmt_subnets) ]}"
  associate_public_ip_address = true
  source_dest_check           = true
  user_data                   = templatefile("cloud-init/vmanage.user_data", {
    index      = count.index + 1
    hostname   = format("sdwan-vmanage-%02d", count.index)
    ssh_pubkey = file(pathexpand(var.ssh_pubkey_file))
    sdwan_org  = var.sdwan_org
  })

  ebs_block_device {
      device_name           = "/dev/xvdb"
      delete_on_termination = true
      volume_size           = 30
  }

  tags = merge(
    var.common_tags,
    {
      Name  = "${format("sdwan-vmanage-%02d", count.index)}"
    }
  )
}

resource "aws_network_interface" "vmanage" {
  count = "${var.counter}"
  subnet_id                   = "${var.public_subnets[ count.index % length(var.public_subnets) ]}"
  security_groups             = ["${var.sdwan_cp_sg_id}"]
  source_dest_check           = true

  attachment {
    instance     = "${aws_instance.vmanage[count.index].id}"
    device_index = 1
  }
}

resource "aws_eip" "vmanage_1" {
  count = "${var.counter}"
  network_interface = "${aws_instance.vmanage[count.index].primary_network_interface_id}"
  vpc               = true
  tags = merge(
    var.common_tags,
    {
      Name  = "${format("eip1_vmanage-%02d", count.index)}"
    }
  )
}

resource "aws_eip" "vmanage_2" {
  count = "${var.counter}"
  network_interface = "${aws_network_interface.vmanage[count.index].id}"
  vpc               = true
  tags = merge(
    var.common_tags,
    {
      Name  = "${format("eip2_vmanage-%02d", count.index)}"
    }
  )
}
