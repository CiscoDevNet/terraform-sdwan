locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  networks = flatten([
    for device_key, device in var.device_list : [
      for network_key, network in device.networks : {
        device_key  = device_key
        network_key = network_key
        network_name  = var.device_list[device_key].networks[network_key]
      }
    ]
  ])
}


data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = "${var.cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "resource_pool" {
  name          = "${var.resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "iso_datastore" {
  name          = "${var.iso_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  for_each = {
    for network in local.networks : "${network.device_key}.${network.network_key}" => network
  }

  name          = each.value.network_name
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  count = var.template == "" ? 0 : 1

  name          = "${var.template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  count = length(var.device_list)

  name              = "${var.device_list[count.index].name}"
  resource_pool_id  = "${data.vsphere_resource_pool.resource_pool.id}"
  datastore_id      = "${data.vsphere_datastore.datastore.id}"

  num_cpus  = "${var.vm_num_cpus}"
  memory    = "${var.vm_memory}"
  guest_id  = "${data.vsphere_virtual_machine.template[0].guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template[0].scsi_type}"

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template[0].disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template[0].disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template[0].disks.0.thin_provisioned}"
  } 

  # Add additional data disks
  dynamic "disk" {
    for_each = var.vm_add_disks
    
    content {
      label             = format("disk%d", disk.key + 1)
      size              = disk.value
      thin_provisioned  = "${var.vm_thin_provisioned}"
      unit_number       = disk.key + 1
    }
  }

  cdrom {
    datastore_id = "${data.vsphere_datastore.iso_datastore.id}"
    path         = "${var.iso_path}/${var.device_list[count.index].name}.iso"
  }

  dynamic "network_interface" {
    for_each = var.device_list[count.index].networks

    content {
      network_id   = "${data.vsphere_network.network["${count.index}.${network_interface.key}"].id}"
      adapter_type = "${data.vsphere_virtual_machine.template[0].network_interface_types[0]}"
    }
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template[0].id}"
  }

  depends_on = [
    vsphere_file.iso,
    null_resource.iso,
    template_dir.cloudinit
  ]
}

output "ip_addresses" {
  value = "${vsphere_virtual_machine.vm.*.default_ip_address}"
}
