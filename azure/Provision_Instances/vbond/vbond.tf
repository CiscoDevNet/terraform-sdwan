resource "azurerm_public_ip" "vbond_1" {
  count = "${var.counter}"
  name                         = "${format("pip1_vbond-%02d", count.index)}"
  location                     = "${var.region}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"

  tags = {
    Name  = "${format("vbond-%02d", count.index)}"
  }
}

resource "azurerm_public_ip" "vbond_2" {
  count = "${var.counter}"
  name                         = "${format("pip2_vbond-%02d", count.index)}"
  location                     = "${var.region}"
  resource_group_name          = "${var.resource_group_name}"
  allocation_method            = "Static"

  tags = {
    Name  = "${format("vbond-%02d", count.index)}"
  }
}

resource "azurerm_network_interface" "vbond_1" {
  count = "${var.counter}"
  name                = "${format("nic1_vbond-%02d", count.index)}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  network_security_group_id = "${var.Vipela_Control_Plane}"

  ip_configuration {
    name                          = "${format("nic1_vbond-%02d", count.index)}"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vbond_1[count.index].id}"
  }
}

resource "azurerm_network_interface" "vbond_2" {
  count               = "${var.counter}"
  name                = "${format("nic2_vbond-%02d", count.index)}"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"
  network_security_group_id = "${var.Vipela_Control_Plane}"

  ip_configuration {
    name                          = "${format("nic2_vbond-%02d", count.index)}"
    subnet_id                     = "${var.subnet}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vbond_2[count.index].id}"
  }
}

resource "azurerm_virtual_machine" "vbond" {
  count                 = "${var.counter}"
  name                  = "${format("vbond-%02d", count.index)}"
  location              = "${var.region}"
  resource_group_name   = "${var.resource_group_name}"
  vm_size               = "${var.viptela_instances_type}"
  availability_set_id   = "${var.avsetvbond}"
  primary_network_interface_id = "${azurerm_network_interface.vbond_1[count.index].id}"
  network_interface_ids = ["${azurerm_network_interface.vbond_1[count.index].id}", "${azurerm_network_interface.vbond_2[count.index].id}"]
  storage_os_disk {
    name          = "${format("vbond-os-disk-%02d", count.index)}"
    os_type       = "Linux"
    create_option = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    id = "${var.vbond_image}"
  }
  os_profile {
    computer_name  = "${format("vbond-%02d", count.index)}"
    admin_username = "${var.username}"
    admin_password = "${var.password}"
    custom_data    = "${file("cloud-init/vbond.user_data")}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}