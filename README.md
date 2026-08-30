# terraform-vpcstack

Terraform module that provisions a complete VPC stack for a single student
environment: VPC, Subnet, Security Group (with SSH inbound and full outbound
rules), and a Virtual Server Instance.

## Usage

```hcl
module "vpcstack" {
  source  = "app.terraform.io/<ORG>/vpcstack/student"
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
| IBM-Cloud/ibm | ~> 1.70 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `student_id` | Student identifier (e.g. student01) | `string` | — |
| `resource_group_name` | Resource group dedicated to this student | `string` | — |
| `region` | Deployment region | `string` | `"us-south"` |
| `vsi_profile` | VM instance profile | `string` | `"bx2-2x8"` |
| `vsi_image_name` | VM image (OS) | `string` | `"ibm-ubuntu-22-04-1-minimal-amd64-1"` |
| `ssh_key_name` | Pre-registered SSH public key name | `string` | — |
| `allowed_ssh_cidr` | CIDR allowed for SSH inbound access | `string` | `"0.0.0.0/0"` |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | ID of the created VPC |
| `subnet_id` | ID of the created subnet |
| `security_group_id` | ID of the created security group |
| `vsi_id` | ID of the created VSI |
| `vsi_private_ip` | Private IP address of the VSI |

## Resources

| Resource | Description |
|----------|-------------|
| `ibm_is_vpc` | VPC scoped to the student |
| `ibm_is_subnet` | /24 subnet in zone `<region>-1` |
| `ibm_is_security_group` | Security group attached to the VSI |
| `ibm_is_security_group_rule` (×2) | SSH inbound from `allowed_ssh_cidr`; full outbound |
| `ibm_is_instance` | Virtual Server Instance |

## Notes

- `allowed_ssh_cidr` defaults to `0.0.0.0/0`; restrict this value in
  production or enforce it via policy before apply.
- SSH key lookup is performed by name via `data "ibm_is_ssh_key"` — the key
  must be pre-registered in the target region.
