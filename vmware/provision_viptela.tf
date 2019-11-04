terraform {
  backend "s3" {
    region          = "us-east-1"
    bucket          = "terraform-state-sdwan-jenkins"
    key             = "global/s3/terraform.tfstate"
    dynamodb_table  = "terraform-locks-sdwan-jenkins"
    encrypt         = true
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

module "provision_vmanage_vmware" {
  source = "./viptela_vmware"
  device_list = "${var.vmanage_device_list}"
  datacenter = "${var.datacenter}"
  cluster = "${var.cluster}"
  datastore = "${var.datastore}"
  iso_datastore = "${var.iso_datastore}"
  iso_path = "${var.iso_path}"
  template = "${var.vmanage_template}"
  vm_num_cpus = 2
  vm_memory = 32768
  vm_add_disks = [100]
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vmanage/"
}

module "provision_vsmart_vmware" {
  source = "./viptela_vmware"
  device_list = "${var.vsmart_device_list}"
  datacenter = "${var.datacenter}"
  cluster = "${var.cluster}"
  datastore = "${var.datastore}"
  iso_datastore = "${var.iso_datastore}"
  iso_path = "${var.iso_path}"
  template = "${var.vsmart_template}"
  vm_num_cpus = 2
  vm_memory = 4096
  vm_add_disks = []
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vsmart/"
}

module "provision_vbond_vmware" {
  source = "./viptela_vmware"
  device_list = "${var.vbond_device_list}"
  datacenter = "${var.datacenter}"
  cluster = "${var.cluster}"
  datastore = "${var.datastore}"
  iso_datastore = "${var.iso_datastore}"
  iso_path = "${var.iso_path}"
  template = "${var.vbond_template}"
  vm_num_cpus = 4
  vm_memory = 4096
  vm_add_disks = []
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vbond/"
}

module "provision_vedge_vmware" {
  source = "./viptela_vmware"
  device_list = "${var.vedge_device_list}"
  datacenter = "${var.datacenter}"
  cluster = "${var.cluster}"
  datastore = "${var.datastore}"
  iso_datastore = "${var.iso_datastore}"
  iso_path = "${var.iso_path}"
  template = "${var.vedge_template}"
  vm_num_cpus = 4
  vm_memory = 4096
  vm_add_disks = []
  vm_thin_provisioned = true
  cloudinit_path = "${path.root}/cloud-init/vedge/"
}

output "vmanage_ip_addresses" {
    value = "${module.provision_vmanage_vmware.ip_addresses}"
}

output "vsmart_ip_addresses" {
    value = "${module.provision_vsmart_vmware.ip_addresses}"
}

output "vbond_ip_addresses" {
    value = "${module.provision_vbond_vmware.ip_addresses}"
}

output "vedge_ip_addresses" {
    value = "${module.provision_vedge_vmware.ip_addresses}"
}
