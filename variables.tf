variable "student_id" {
  description = "Student identifier (e.g. student01)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{0,30}[a-z0-9]$", var.student_id))
    error_message = "student_id must be lowercase alphanumeric and hyphens, 2–32 characters, and must not start or end with a hyphen."
  }
}

variable "resource_group_name" {
  description = "Resource group dedicated to this student"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "region" {
  description = "Deployment region"
  type        = string
  default     = "us-south"

  validation {
    condition     = contains(["us-south", "us-east", "eu-gb", "eu-de", "jp-tok", "jp-osa", "au-syd", "ca-tor", "br-sao"], var.region)
    error_message = "region must be a valid IBM Cloud VPC region."
  }
}

variable "vsi_profile" {
  description = "VM instance profile"
  type        = string
  default     = "bx2-2x8"

  validation {
    condition     = can(regex("^[a-z0-9]+-[0-9]+x[0-9]+$", var.vsi_profile))
    error_message = "vsi_profile must follow the IBM Cloud profile naming convention (e.g. bx2-2x8)."
  }
}

variable "vsi_image_name" {
  description = "VM image (OS)"
  type        = string
  default     = "ibm-ubuntu-22-04-1-minimal-amd64-1"

  validation {
    condition     = length(var.vsi_image_name) > 0
    error_message = "vsi_image_name must not be empty."
  }
}

variable "ssh_key_name" {
  description = "SSH public key name (pre-registered in the region)"
  type        = string

  validation {
    condition     = length(var.ssh_key_name) > 0
    error_message = "ssh_key_name must not be empty."
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH inbound access"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrnetmask(var.allowed_ssh_cidr))
    error_message = "allowed_ssh_cidr must be a valid CIDR block (e.g. 10.0.0.0/16)."
  }
}

variable "boot_volume_encryption" {
  description = "Enable boot volume encryption using the lab Key Protect instance (lab4193-kms / lab4193-boot-key). Defaults to false."
  type        = bool
  default     = false
}
