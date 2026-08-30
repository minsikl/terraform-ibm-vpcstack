data "ibm_resource_group" "rg" {
  name = var.resource_group_name
}

data "ibm_is_image" "vsi_image" {
  name = var.vsi_image_name
}

data "ibm_is_ssh_key" "ssh_key" {
  name = var.ssh_key_name
}

resource "ibm_is_vpc" "vpc" {
  name           = "${var.student_id}-vpc"
  resource_group = data.ibm_resource_group.rg.id
}

resource "ibm_is_subnet" "subnet" {
  name                     = "${var.student_id}-subnet"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = "${var.region}-1"
  total_ipv4_address_count = 256
  resource_group           = data.ibm_resource_group.rg.id
}

resource "ibm_is_security_group" "sg" {
  name           = "${var.student_id}-sg"
  vpc            = ibm_is_vpc.vpc.id
  resource_group = data.ibm_resource_group.rg.id
}

resource "ibm_is_security_group_rule" "allow_ssh" {
  group     = ibm_is_security_group.sg.id
  direction = "inbound"
  remote    = var.allowed_ssh_cidr
  protocol  = "tcp"
  port_min  = 22
  port_max  = 22
}

resource "ibm_is_security_group_rule" "allow_outbound" {
  group     = ibm_is_security_group.sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

resource "ibm_is_instance" "vsi" {
  name           = "${var.student_id}-vm"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-1"
  profile        = var.vsi_profile
  image          = data.ibm_is_image.vsi_image.id
  keys           = [data.ibm_is_ssh_key.ssh_key.id]
  resource_group = data.ibm_resource_group.rg.id

  primary_network_interface {
    subnet          = ibm_is_subnet.subnet.id
    security_groups = [ibm_is_security_group.sg.id]
  }

  boot_volume {
    name = "${var.student_id}-boot"
  }
}
