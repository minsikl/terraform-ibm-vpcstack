data "ibm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "ibm_is_vpc" "vpc" {
  name           = "${var.student_id}-vpc"
  resource_group = data.ibm_resource_group.rg.id
}

resource "ibm_is_subnet" "subnet" {
  name                     = "${var.student_id}-subnet"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "${var.region}-1"
  resource_group           = data.ibm_resource_group.rg.id
  total_ipv4_address_count = 256
}

resource "ibm_is_security_group" "sg" {
  name           = "${var.student_id}-sg"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = data.ibm_resource_group.rg.id
}

resource "ibm_is_security_group_rule" "ssh_in" {
  group     = ibm_is_security_group.sg.id
  direction = "inbound"
  remote    = var.allowed_ssh_cidr
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_instance" "vsi" {
  name           = "${var.student_id}-vm"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-1"
  profile        = var.vsi_profile
  image          = var.vsi_image_name
  keys           = [var.ssh_key_name]
  resource_group = data.ibm_resource_group.rg.id

  primary_network_interface {
    subnet          = ibm_is_subnet.subnet.id
    security_groups = [ibm_is_security_group.sg.id]
  }

  boot_volume {
    name = "${var.student_id}-boot"
  }
}