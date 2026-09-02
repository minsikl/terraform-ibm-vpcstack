provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

module "vpcstack" {
  source = "../.."

  student_id          = var.student_id
  resource_group_name = var.resource_group_name
  region              = var.region
  ssh_key_name        = var.ssh_key_name
  allowed_ssh_cidr    = var.allowed_ssh_cidr

  no_sg_acl_rules             = var.no_sg_acl_rules
  boot_volume_encryption_mode = var.boot_volume_encryption_mode

  providers = {
    ibm = ibm
  }
}

output "vpc_id"         { value = module.vpcstack.vpc_id }
output "vsi_private_ip" { value = module.vpcstack.vsi_private_ip }
