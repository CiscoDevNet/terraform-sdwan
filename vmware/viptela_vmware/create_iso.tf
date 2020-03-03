resource "template_dir" "cloudinit" {
  for_each        = var.device_list
  source_dir      = "${path.root}/${var.cloudinit_path}"
  destination_dir = "${path.cwd}/ISO/${each.key}"

  vars = {
    ipv4_address = lookup(each.value, "ipv4_address", "dhcp")
    ipv4_gateway = lookup(each.value, "ipv4_gateway", "")
  }
}

resource "null_resource" "iso" {
  for_each = var.device_list

  triggers = {
    cloudinit = fileexists("${var.cloudinit_path}/user-data") ? filemd5("${var.cloudinit_path}/user-data") : ""
    address   = md5(each.value.ipv4_address)
    data_dir  = "${path.cwd}/ISO/${each.key}"
    iso_file  = "${path.cwd}/ISO/${each.key}.iso"
  }

  provisioner "local-exec" {
    command = "mkisofs -output ${self.triggers.iso_file} -volid cidata -joliet -rock ${self.triggers.data_dir}/user-data ${self.triggers.data_dir}/meta-data"
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm ${self.triggers.iso_file}"
    on_failure = continue
  }

  depends_on = [
    template_dir.cloudinit
  ]
}

resource "vsphere_file" "iso" {
  for_each         = var.device_list

  datacenter       = var.datacenter
  datastore        = var.iso_datastore
  source_file      = "${path.cwd}/ISO/${each.key}.iso"
  destination_file = "${var.iso_path}/${each.key}.iso"

  depends_on = [
    null_resource.iso,
    template_dir.cloudinit
  ]
}