data "aws_ami" "ubuntu-kinetic" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-kinetic-22.10-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "devbox" {
    ami                         = "${data.aws_ami.ubuntu-kinetic.id}"
    instance_type               = "${var.devbox_instance_type}"
    vpc_security_group_ids      = ["${aws_security_group.sdwan_cp.id}"]
    subnet_id                   = "${aws_subnet.public_subnet_az_1.id}"
    private_ip                  = cidrhost(aws_subnet.public_subnet_az_1.cidr_block, 10)
    associate_public_ip_address = true
    user_data                   = <<EOF
#cloud-config
hostname: devbox
users:
- name: cisco
  gecos: Cisco user
  shell: /bin/bash
  groups: [adm, users, crontab, kvm, tcpdump, _ssh, admin, netdev]
  ssh_authorized_keys:
  - ${var.ssh_pubkey}
  sudo: ALL=(ALL) NOPASSWD:ALL
packages:
- net-tools
- tinyproxy
- kitty-terminfo
runcmd:
- sed -i 's/^Port 8888/Port 8443/' /etc/tinyproxy/tinyproxy.conf
- sed -i 's/^Timeout 600/Timeout 30/' /etc/tinyproxy/tinyproxy.conf
- sed -i 's/^Allow/#Allow/' /etc/tinyproxy/tinyproxy.conf
- sed -i 's/^ConnectPort/#ConnectPort/' /etc/tinyproxy/tinyproxy.conf
- systemctl restart tinyproxy
- chown -R cisco:cisco /home/cisco
write_files:
- path: /home/cisco/.bash_history
  permissions: '0600'
  content: |
    sudo systemctl restart tinyproxy
    sudo journalctl -f -u tinyproxy
EOF

    tags = merge(
        var.common_tags,
        {
            Name = "devbox"
        }
    )
}

output "devbox_public_ip" {
    value = aws_instance.devbox.public_ip
}
