# terraform-viptela

This repo contains terraform code for deploying the Cisco SD-WAN (Viptela) control plane components in various cloud environments.

## Requirements

- [Terraform](https://www.terraform.io).  On a Mac, install with Homebrew:
    ```
    brew install terraform
    ```
- mkisofs is used to create the cloud-init ISOs.  On a Mac, install with Homebrew:
    ```
    brew install cdrtools
    ```

## VMware

### Creating the SD-WAN VM templates

#### vManage, vSmart and vEdge
In the vCenter UI, create the Viptela VM templates:

1. Deploy the Viptela OVF for vManage, vEdge and vSmart.
1. In the "Select storage" section, set the virtual disk format to "Thin provisioned" to make more efficient use of the datastore disk space.

On v19 and earlier, after all of the OVFs have been deployed, edit the settings of each Viptela VM template and:
1. Add a "SCSI Controller" of type "LSI Logic Parallel".
1. Change "Hard disk 1" "Virtual Device Node" setting from "IDE 0" to "New SCSI controller".
1. Click OK.
1. The VM is now ready to use as a template for use with terraform.

> Note: Do not add a second disk to the vManage template.  Terraform will do this dynamically.

> Note: You do not need to do these steps for 20.x and later. These OVFs alreday use a SCSI controller.

#### CSR1000v
In the vCenter UI, create the VM template for CSR1000v w/SD-WAN (aka cEdge):
1. Deploy the OVF. (`csr1000v-ucmk9.16.12.1e.ova` or similar)
1. In the "Select storage" section, set the virtual disk format to "Thin provisioned" to make more efficient use of the datastore disk space.
1. In the "Customize template" section, just leave the values blank and click "Next".  Terraform will set these properties when it clones the VM.
1. After the OVF is successfully deployed, go to the "Configure" section and select "vApp Options" from the menu on the left.  Click "Edit..." and unselect the "Enable vApp options" checkbox at the top.  Say "Yes" to the dialog box, then click "OK".
1. Power on the VM and watch the console.
1. Power off the VM immediately after the first reboot.  (If you miss this and power it off after it is fully up, delete the VM and repeat this process.)
1. The VM is now ready to use as a template for use with terraform.

### Using terraform to deploy SD-WAN components
There two main was to deploy on VMware.  The first is to let the module build out the bootstrap configuration for you, while you simply supply IPv4 addressing info.  The second way is to supply the full bootstrap configuration yourself.  The second method gives you much greater control over the bootstrap configuration.  The links below have examples of each method.

- [v20.4 and under](vmware/examples/v19.2.example)
- [v20.4 and under with bootstrap](vmware/examples/v19.2-day0.example)
- [v20.5 and up](vmware/examples/v20.7.example)
- [v20.5 and up with bootstrap](vmware/examples/v20.7-day0.example)

To use the examples:

Change to the vmware directory.

```
cd vmware
```

Copy the example you want to  a file named `terraform.tfvars`.

```
cp examples/v19.2.example terraform.tfvars
```

Change the variables and/or configuration to suit your environment, or pass in these variables some other way (e.g. Ansible, environment variables, etc.)  Keep in mind the following when updating the variables:

- `networks` is an ordered list of VM networks to use for each interface of the device.  For vManage/vSmart the order is eth0, eth1.  For vBond/vEdge the order is eth0, g0/0, g0/1, g0/2, g0/3.
- `*_template`, `datacenter`, `cluster`, `datastore` and `iso_datastore` values should be set to the names of the respective objects in vCenter.
- `ipv4_address` is applied to VPN 0 must be set to either "dhcp" or a static IP address.  Use address/prefix-length notation (i.e. 192.168.0.2/24) for Viptela components and address/netmask notation (i.e. 192.168.0.2 255.255.255.0) for CSR1000v.  When specifying a static IP address, `ipv4_gateway` is also required.
- `folder` is the VM folder to place all VMs.  It is optional.  If it is not specified then all VMs will be placed at the root of the datacenter.
- `cloudinit_type` should be set to "v2" for 20.5 and later and "v1" for 20.4 and earlier.
- The default password set on provisioned devices is "cisco".

You can set the server and login credentials for vCenter in your environment if you do not want to put these in the `terraform.tfvars` file.  Example:

```
export TF_VAR_vsphere_user=johndoe@xyz.com
export TF_VAR_vsphere_password=abc123
export TF_VAR_vsphere_server=vc1.xyz.com
```

Run terraform.

```
$ terraform init
$ terraform plan
$ terraform apply
```

Retreive the IP addressing assigned to all control plane components.

```
$ terraform output
vbond_ip_addresses = [
  "192.168.1.209",
  "192.168.1.210",
]
vmanage_ip_addresses = [
  "192.168.1.2",
  "192.168.1.202"
]
vsmart_ip_addresses = [
  "192.168.1.211",
  "192.168.1.213",
]
vedge_ip_addresses = [
  "192.168.1.208"
]
cedge_ip_addresses = [
  "192.168.1.214"
]

```

Stop the VMs and delete them from vCenter.

```
$ terraform destroy
```

## AWS
Contact workshop lead to share AMI's with your AWS account.
> Note: Ability to generate AMI's from qcow image is being developed.

Deploy AWS VPC for Cisco SD-WAN controllers:
Edit Provision_VPC/my_vpc_variables.auto.tfvars.json with your region and VPC cidr_block.
> Note: CIDR block must have a prefix length less than 28 to cover subnets in 2 availability zones
```
{
    "region": "us-east-1",
    "cidr_block": "10.100.100.0/24"
}
```

With Provision_VPC as your current working directory, run terraform.
```
$ terraform init
$ terraform plan
$ terraform apply
```

Deploy Controllers into VPC:
Edit Provision_Instances/my_instances_variables.auto.tfvars.json with appropriate settings.
```
{
    "vbond_instances_type": "c5.large",
    "vsmart_instances_type": "c5.xlarge",
    "vmanage_instances_type": "c5.4xlarge",
    "vbond_ami": "ami-085c4adc58506ad83",
    "vmanage_ami": "ami-06850b5d3d92800e7",
    "vsmart_ami": "ami-0079a97de83928496",
    "vbond_count": "1",
    "vmanage_count": "1",
    "vsmart_count": "1"
}
```

With Provision Instances as your current working directory, run terraform
```
$ terraform init
$ terraform plan
$ terraform apply
```

Retreive the IP addressing assigned to all control plane components.
```
$ terraform output
vbonds_vbondEth0EIP = [
  "3.231.238.177",
]
vbonds_vbondEth0Ip = [
  "10.100.100.80",
]
vbonds_vbondEth1EIP = [
  "3.231.90.13",
]
vbonds_vbondEth1Ip = [
  [
    "10.100.100.7",
  ],
]
vmanages_vmanageEth0EIP = [
  "3.232.23.107",
]
vmanages_vmanageEth0Ip = [
  "10.100.100.67",
]
vmanages_vmanageEth1EIP = [
  "3.230.210.217",
]
vmanages_vmanageEth1Ip = [
  [
    "10.100.100.59",
  ],
]
vsmarts_vsmartEth0EIP = [
  "3.230.217.130",
  "34.193.188.60",
]
vsmarts_vsmartEth0Ip = [
  "10.100.100.52",
  "10.100.100.212",
]
vsmarts_vsmartEth1EIP = [
  "3.232.82.69",
  "3.212.251.219",
]
vsmarts_vsmartEth1Ip = [
  [
    "10.100.100.85",
  ],
  [
    "10.100.100.134",
  ],
]
```

To terminate instances, go to the Provision_Instances directory and run:
```
$ terraform destroy -force
```

To destroy the empty controllers' VPC, go to the Provision_VPC directory and run:
```
$ terraform destroy -force
```

## Azure
Upload VHDs for vBond, vManage, and vSmart into an Azure Page Blob in the region in which you'd like to deploy controllers.
Note - Page blob must be untarred and unzipped before upload
Create images from the storage blobs.

You can set your ARM credentials in your environment.  See below:
```
export TF_VAR_ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export TF_VAR_ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
export TF_VAR_ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
export TF_VAR_ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

Deploy Azure VNET for Cisco SD-WAN controllers:
Edit Provision_VNET/my_vnet_variables.auto.tfvars.json with your region and VNET cidr_block.
```
{
    "region": "eastus",
    "cidr_block": "10.200.200.0/24"
}
```
With Provision_VNET as your current working directory, run terraform.
```
$ terraform init
$ terraform plan
$ terraform apply
```
Deploy Controllers into VNET:
Edit Provision_Instances/my_instances_variables.auto.tfvars.json with appropriate settings.
```
{
    "vbond_instances_type": "Standard_DS3_v2",
    "vbond_image": "/subscriptions/X-X-X-X/resourceGroups/csr_test/providers/Microsoft.Compute/images/vbond19_2_0",
    "vbond_count": "1",
    "vmanage_instances_type": "Standard_DS5_v2",
    "vmanage_image": "/subscriptions/X-X-X-X/resourceGroups/csr_test/providers/Microsoft.Compute/images/vmanage19_2_0",
    "vmanage_count": "1",
    "vsmart_instances_type": "Standard_DS3_v2",
    "vsmart_image": "/subscriptions/X-X-X-X/resourceGroups/csr_test/providers/Microsoft.Compute/images/vsmart19_2_0",
    "vsmart_count": "1",
    "username": "cisco",
    "password": "Cisco1234512345"
}
```
Retreive the IP addressing assigned to all control plane components.
```
$ terraform output
vbonds_vbondEth0Ip = [
  "10.200.200.4",
]
vbonds_vbondEth0PIP = [
  "23.96.36.204",
]
vbonds_vbondEth1Ip = [
  "10.200.200.8",
]
vbonds_vbondEth1PIP = [
  "23.96.46.156",
]
vmanages_vmanageEth0Ip = [
  "10.200.200.6",
]
vmanages_vmanageEth0PIP = [
  "23.96.46.123",
]
vmanages_vmanageEth1Ip = [
  "10.200.200.9",
]
vmanages_vmanageEth1PIP = [
  "23.96.46.174",
]
vsmarts_vsmartEth0Ip = [
  "10.200.200.7",
]
vsmarts_vsmartEth0PIP = [
  "23.96.46.20",
]
vsmarts_vsmartEth1Ip = [
  "10.200.200.5",
]
vsmarts_vsmartEth1PIP = [
  "23.96.39.76",
]
```
To terminate instances, go to the Provision_Instances directory and run:
```
$ terraform destroy -force
```
To destroy the empty controllers' VNET, go to the Provision_VNET directory and run:
```
$ terraform destroy -force
```
