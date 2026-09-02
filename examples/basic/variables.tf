variable "ibmcloud_api_key" {
  type      = string
  sensitive = true
}

variable "student_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "region" {
  type    = string
  default = "us-south"
}

variable "ssh_key_name" {
  type = string
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "no_sg_acl_rules" {
  type    = bool
  default = false
}

variable "boot_volume_encryption_mode" {
  type    = string
  default = "default"
}
