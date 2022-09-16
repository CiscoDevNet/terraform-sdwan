resource "aws_instance" "devbox" {
    ami                         = "${var.devbox_ami}"
    instance_type               = "${var.devbox_instance_type}"
    vpc_security_group_ids      = ["${aws_security_group.sdwan_cp.id}"]
    subnet_id                   = "${aws_subnet.public_subnet_az_1.id}"
    private_ip                  = cidrhost(aws_subnet.public_subnet_az_1.cidr_block, 10)
    associate_public_ip_address = true
    user_data                   = <<EOF
#cloud-config
hostname: devbox
ssh_pwauth: yes
users:
- name: cisco
  gecos: Cisco user
  shell: /bin/bash
  groups: [adm, users, crontab, kvm, tcpdump, _ssh, admin, netdev]
  passwd: $6$329577c85ea66998$tTtlYqQIpfCGvqNZ2nICRWOSfyIV0/RO0ZWtFwpSJ0bBvlQoCowl6fO9SjzerDwmKYutIbPMAub7B4K/JG4c/0
  lock_passwd: False
  sudo: ALL=(ALL) NOPASSWD:ALL
packages:
- net-tools
- tinyproxy
runcmd:
- sed -i 's/^Port 8888/Port 8443/' /etc/tinyproxy/tinyproxy.conf
- sed -i 's/^Allow/#Allow/' /etc/tinyproxy/tinyproxy.conf
- sed -i 's/^ConnectPort/#ConnectPort/' /etc/tinyproxy/tinyproxy.conf
- systemctl restart tinyproxy
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
