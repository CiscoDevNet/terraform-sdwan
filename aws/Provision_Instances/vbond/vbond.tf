# temporary hack
data "aws_subnet" "public_subnet" {
  id    = "${var.public_subnets[0]}"
}

resource "aws_instance" "vbond" {
  ami                         = "${var.vbond_ami}"
  instance_type               = "${var.viptela_instances_type}"
  vpc_security_group_ids      = ["${var.sdwan_cp_sg_id}"]
  subnet_id                   = "${var.mgmt_subnets[0]}"
  associate_public_ip_address = true
  source_dest_check           = true
  user_data                   = templatefile("cloud-init/vbond.user_data", {
    day0       = var.vbond_day0
    hostname   = "sdwan-vbond"
    ssh_pubkey = var.ssh_pubkey
    sdwan_org  = var.sdwan_org
  })

  tags = merge(
    var.common_tags,
    {
      Name  = "sdwan-vbond"
    }
  )

  depends_on = [aws_network_interface.vbond]
}

resource "aws_network_interface" "vbond" {
  subnet_id                   = "${var.public_subnets[0]}"
  private_ips                 = [cidrhost(data.aws_subnet.public_subnet.cidr_block, 12)]
  security_groups             = ["${var.sdwan_cp_sg_id}"]
  source_dest_check           = true
}

resource "aws_network_interface_attachment" "vbond" {
  instance_id          = aws_instance.vbond.id
  network_interface_id = aws_network_interface.vbond.id
  device_index         = 1
}

resource "aws_eip" "vbond_mgmt" {
  count = var.enable_eip_mgmt ? 1 : 0
  network_interface = "${aws_instance.vbond.primary_network_interface_id}"
  vpc               = true
  tags = merge(
    var.common_tags,
    {
      Name  = "eip_mgmt_vbond"
    }
  )
}

resource "aws_eip_association" "vbond_public" {
  network_interface_id = "${aws_network_interface.vbond.id}"
  allocation_id = "${var.vbond_eip_allocation}"
}
