resource "template_dir" "cloudinit" {
  count = length(var.device_list)
  source_dir      = "${path.root}/${var.cloudinit_path}"
  destination_dir = "${path.cwd}/ISO/${var.device_list[count.index].name}"

  vars = {
    ipv4_address = lookup(var.device_list[count.index], "ipv4_address", "dhcp")
    ipv4_gateway = lookup(var.device_list[count.index], "ipv4_gateway", "")
  }
}

resource "null_resource" "iso" {
  count = length(var.device_list)

  triggers = {
    cloudinit = "${fileexists("${var.cloudinit_path}/user-data") ? filemd5("${var.cloudinit_path}/user-data") : ""}"
    address = md5(var.device_list[count.index].ipv4_address)
  #  gateway = md5("${var.device_list[count.index].ipv4_gateway}")
  #  device = "${join(",", template_dir.cloudinit.*.source_dir)}"
  #  device = "${template_dir.cloudinit[count.index].destination_dir}"
  }

  provisioner "local-exec" {
    command = "mkisofs -output ${path.cwd}/ISO/${var.device_list[count.index].name}.iso -volid cidata -joliet -rock ${path.cwd}/ISO/${var.device_list[count.index].name}/user-data ${path.cwd}/ISO/${var.device_list[count.index].name}/meta-data"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm ${path.cwd}/ISO/${var.device_list[count.index].name}.iso"
    on_failure = continue
  }

  depends_on = [
    template_dir.cloudinit
  ]
}

resource "vsphere_file" "iso" {
  count = length(var.device_list)

  datacenter       = var.datacenter
  datastore        = var.iso_datastore
  source_file      = "${path.cwd}/ISO/${var.device_list[count.index].name}.iso"
  destination_file = "${var.iso_path}/${var.device_list[count.index].name}.iso"

  depends_on = [
    null_resource.iso,
    template_dir.cloudinit
  ]
}