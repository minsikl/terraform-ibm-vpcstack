# ---- Variables the admin sets when creating the workspace (not exposed to students) ----
variable "student_id" {
  description = "e.g. student01"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group dedicated to this student"
  type        = string
}

variable "region" {
  description = "Fixed region"
  type        = string
  default     = "us-south"
}

# ---- Variables students adjust in the No-Code UI ----
variable "vsi_profile" {
  description = "VM instance profile"
  type        = string
  default     = "bx2-2x8"
}

variable "vsi_image_name" {
  description = "VM image (OS)"
  type        = string
  default     = "ibm-ubuntu-22-04-1-minimal-amd64-1"
}

variable "ssh_key_name" {
  description = "SSH public key name (pre-registered)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"  # Intentionally open — Sentinel will enforce a stricter value later
}