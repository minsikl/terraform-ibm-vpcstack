# terraform-ibm-lab4193-vpcstack

Terraform module for IBM TechXchange Lab 4193. Provisions a VPC, Subnet,
Security Group, and Virtual Server Instance in IBM Cloud for a single student
environment.

## Usage

```hcl
module "lab4193_stack" {
  source = "app.terraform.io/<ORG>/lab4193-vpcstack/ibm"
  version = "1.0.0"

  student_id           = "student01"
  resource_group_name  = "student01-rg"
  region               = "us-south"
  vsi_profile          = "bx2-2x8"
  vsi_image_name       = "ibm-ubuntu-22-04-1-minimal-amd64-1"
  ssh_key_name         = "student01-key"
  allowed_ssh_cidr     = "10.0.0.0/16"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| ibm | ~> 1.70 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| student_id | Student identifier (e.g. student01) | string | n/a |
| resource_group_name | Resource group dedicated to this student | string | n/a |
| region | Deployment region | string | "us-south" |
| vsi_profile | VM instance profile | string | "bx2-2x8" |
| vsi_image_name | VM image (OS) | string | "ibm-ubuntu-22-04-1-minimal-amd64-1" |
| ssh_key_name | Pre-registered SSH public key name | string | n/a |
| allowed_ssh_cidr | CIDR allowed for SSH access | string | "0.0.0.0/0" |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the created VPC |
| vsi_public_ip | Public IP address of the created VM |

## Notes

- Built specifically for IBM TechXchange Lab 4193 — not intended for general use.
- The `allowed_ssh_cidr` default is intentionally permissive; Sentinel policy
  enforces a restricted value before apply.