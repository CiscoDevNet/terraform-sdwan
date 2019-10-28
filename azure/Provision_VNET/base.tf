/*
  Requires:
  - Azzure Region
  - CIDR block with <= 28 bit prefix length

  Provisions:
  - VNET,
  - public route table,
  - subnet in different availability zones,
  - security group for the Viptela controllers
*/

/*
  VNET
*/
resource "azurerm_resource_group" "ViptelaControllers" {
  name     = "ViptelaControllers"
  location = "${var.region}"
}

/*
  Security Group
*/
resource "azurerm_network_security_group" "ViptelaControllers" {
  name = "ViptelaControllers"
  location = "${var.region}"
  resource_group_name = "${azurerm_resource_group.ViptelaControllers.name}"

  security_rule {
    name = "ControlTCP"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "23456-24156"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ControlUDP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "12346-13046"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "vManageWebServer"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "NETCONF"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "830"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "ViptelaControllers"
  }
}

/*
  VNET
*/
resource "azurerm_virtual_network" "ViptelaControllers" {
  name                = "ViptelaControllers"
  resource_group_name = "${azurerm_resource_group.ViptelaControllers.name}"
  address_space       = ["${var.cidr_block}"]
  location            = "${var.region}"
  dns_servers         = ["208.67.222.222"]

  tags = {
    environment = "ViptelaControllers"
  }
}

/*
  Route Table
*/
resource "azurerm_route_table" "ViptelaControllers" {
  name                = "ViptelaControllers"
  location            = "${var.region}"
  resource_group_name = "${azurerm_resource_group.ViptelaControllers.name}"

  route {
    name           = "DefaultInternet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = {
    environment = "ViptelaControllers"
  }
}

/*
  Subnet
*/
resource "azurerm_subnet" "ViptelaControllers" {
  name                 = "ViptelaControllers"
  resource_group_name  = "${azurerm_resource_group.ViptelaControllers.name}"
  virtual_network_name = "${azurerm_virtual_network.ViptelaControllers.name}"
  address_prefix       = "${var.cidr_block}"
}

resource "azurerm_subnet_route_table_association" "test" {
  subnet_id      = "${azurerm_subnet.ViptelaControllers.id}"
  route_table_id = "${azurerm_route_table.ViptelaControllers.id}"
}