data "ibm_is_image" "vsi_image" {
  name = var.vsi_image_name
}

resource "ibm_is_instance" "vsi" {
  name           = "${var.student_id}-vm"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-1"
  profile        = var.vsi_profile
  image          = data.ibm_is_image.vsi_image.id   # 이름이 아니라 조회된 ID 사용
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