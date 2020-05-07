terraform {
  required_version = ">= 0.12.23"
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

resource "vsphere_folder" "folder" {
  count         = var.folder == "" ? 0 : 1

  path          = var.folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "provision_vmanage_vmware" {
  source = "./viptela_vmware"
  device_list = var.vmanage_device_list
  datacenter = var.datacenter
  cluster = var.cluster
  resource_pool = var.resource_pool
  folder = var.folder == "" ? "" : "${vsphere_folder.folder[0].path}"
  datastore = var.datastore
  iso_datastore = var.iso_datastore
  iso_path = var.iso_path
  template = var.vmanage_template
  vm_num_cpus = 2
  vm_memory = 32768
  vm_add_disks = [100]
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vmanage/"
}

module "provision_vsmart_vmware" {
  source = "./viptela_vmware"
  device_list = var.vsmart_device_list
  datacenter = var.datacenter
  cluster = var.cluster
  resource_pool = var.resource_pool
  folder = var.folder == "" ? "" : "${vsphere_folder.folder[0].path}"
  datastore = var.datastore
  iso_datastore = var.iso_datastore
  iso_path = var.iso_path
  template = var.vsmart_template
  vm_num_cpus = 2
  vm_memory = 4096
  vm_add_disks = []
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vsmart/"
}

module "provision_vbond_vmware" {
  source = "./viptela_vmware"
  device_list = var.vbond_device_list
  datacenter = var.datacenter
  cluster = var.cluster
  datastore = var.datastore
  resource_pool = var.resource_pool
  folder = var.folder == "" ? "" : "${vsphere_folder.folder[0].path}"
  iso_datastore = var.iso_datastore
  iso_path = var.iso_path
  template = var.vbond_template
  vm_num_cpus = 2
  vm_memory = 4096
  vm_add_disks = []
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vbond/"
}

module "provision_vedge_vmware" {
  source = "./viptela_vmware"
  device_list = var.vedge_device_list
  datacenter = var.datacenter
  cluster = var.cluster
  datastore = var.datastore
  resource_pool = var.resource_pool
  folder = var.folder == "" ? "" : "${vsphere_folder.folder[0].path}"
  iso_datastore = var.iso_datastore
  iso_path = var.iso_path
  template = var.vedge_template
  vm_num_cpus = 2
  vm_memory = 4096
  vm_add_disks = []
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vedge/"
}

module "provision_cedge_vmware" {
  source = "./cedge_vmware"
  device_list = var.cedge_device_list
  datacenter = var.datacenter
  cluster = var.cluster
  datastore = var.datastore
  resource_pool = var.resource_pool
  folder = var.folder == "" ? "" : "${vsphere_folder.folder[0].path}"
  iso_datastore = var.iso_datastore
  iso_path = var.iso_path
  template = var.cedge_template
  vm_num_cpus = 1
  vm_memory = 4096
  vm_add_disks = []
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/cedge/"
}