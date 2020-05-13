resource "template_dir" "cloudinit" {
  for_each        = var.device_list
  source_dir      = var.cloudinit_path
  destination_dir = "${path.cwd}/ISO/${each.key}"

  vars = {
    ipv4_address = lookup(each.value, "ipv4_address", "dhcp")
    ipv4_gateway = lookup(each.value, "ipv4_gateway", "")
    day0         = lookup(each.value, "day0", "")
    otp          = lookup(each.value, "otp", "")
    vbond        = lookup(each.value, "vbond", "")
    uuid         = lookup(each.value, "uuid", "")
    org          = lookup(each.value, "org", "")
  }
}

resource "null_resource" "iso" {
  for_each = var.device_list

  triggers = {
    cloudinit = fileexists("${var.cloudinit_path}/ciscosdwan_cloud_init.cfg") ? filemd5("${var.cloudinit_path}/ciscosdwan_cloud_init.cfg") : ""
    data_dir  = "${path.cwd}/ISO/${each.key}"
    iso_file  = "${path.cwd}/ISO/${each.key}.iso"
  }

  provisioner "local-exec" {
    command = "mkisofs -output ${self.triggers.iso_file} -volid cidata -joliet -rock ${self.triggers.data_dir}/ciscosdwan_cloud_init.cfg"
  }

  # Requires terraform 0.12.23+ for issue #24139 fix (for_each destroy provisioner in module)
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
  for_each = var.device_list

  datacenter       = var.datacenter
  datastore        = var.iso_datastore
  source_file      = "${path.cwd}/ISO/${each.key}.iso"
  destination_file = "${var.iso_path}/${var.folder}/${each.key}.iso"

  depends_on = [
    null_resource.iso,
    template_dir.cloudinit
  ]
}