# terraform-ibm-vpcstack

Terraform module that provisions a complete VPC stack for a single student
environment: VPC, Subnet, Security Group (with SSH inbound and full outbound
rules), and a Virtual Server Instance with optional boot volume encryption
via IBM Cloud Key Protect.

## Usage

```hcl
module "vpcstack" {
  source  = "app.terraform.io/<ORG>/vpcstack/ibm"
  version = "1.3.1"

  student_id          = "student01"
  resource_group_name = "student01-rg"
  ssh_key_name        = "lab-key"
}
```

With all options enabled:

```hcl
module "vpcstack" {
  source  = "app.terraform.io/<ORG>/vpcstack/ibm"
  version = "1.3.1"

  student_id          = "demo-compliant"
  resource_group_name = "demo-compliant-rg"
  ssh_key_name        = "lab-key"
  allowed_ssh_cidr    = "10.0.0.0/8"

  no_sg_acl_rules             = true
  boot_volume_encryption_mode = "byok"
}
```

When `boot_volume_encryption_mode = "byok"`, the module looks up the shared Key
Protect instance (`lab-kms`) and root key (`lab-boot-key`) automatically — no
CRN needs to be supplied manually.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| IBM-Cloud/ibm | ~> 1.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `student_id` | Student or workspace identifier (e.g. `student01`, `demo-compliant`) | `string` | — | yes |
| `resource_group_name` | Resource group dedicated to this workspace | `string` | — | yes |
| `ssh_key_name` | Pre-registered SSH public key name in the target region | `string` | — | yes |
| `region` | Deployment region | `string` | `"us-south"` | no |
| `vsi_profile` | VSI instance profile | `string` | `"bx2-2x8"` | no |
| `vsi_image_name` | VSI OS image name | `string` | `"ibm-ubuntu-22-04-1-minimal-amd64-1"` | no |
| `allowed_ssh_cidr` | CIDR allowed for inbound SSH — set a restricted range to pass Sentinel policy | `string` | `"0.0.0.0/0"` | no |
| `no_sg_acl_rules` | When `true`, removes all auto-created rules from the VPC default security group and default network ACL | `bool` | `false` | no |
| `boot_volume_encryption_mode` | Boot volume encryption: `"default"` (IBM provider-managed) or `"byok"` (customer-managed via Key Protect) | `string` | `"default"` | no |

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
| `ibm_is_vpc` | VPC scoped to the workspace |
| `ibm_is_subnet` | /24 subnet in zone `<region>-1` |
| `ibm_is_security_group` | Security group attached to the VSI |
| `ibm_is_security_group_rule` (×2) | SSH inbound from `allowed_ssh_cidr`; full outbound |
| `ibm_is_instance` | Virtual Server Instance |

## Data Sources

| Data Source | Condition | Description |
|-------------|-----------|-------------|
| `ibm_resource_group` | always | Looks up the resource group by name |
| `ibm_is_image` | always | Looks up the OS image by name |
| `ibm_is_ssh_key` | always | Looks up the SSH key by name |
| `ibm_resource_instance` | `boot_volume_encryption_mode = "byok"` | Looks up `lab-kms` Key Protect instance |
| `ibm_kms_keys` | `boot_volume_encryption_mode = "byok"` | Looks up `lab-boot-key` root key CRN |

## Notes

- `allowed_ssh_cidr` defaults to `0.0.0.0/0`. The lab Sentinel policy
  (`restrict-ssh`, soft-mandatory) will warn on apply — override to intentionally
  generate an SCC Workload Protection finding, or set a restricted CIDR to pass.
- SSH key lookup is by name via `data "ibm_is_ssh_key"` — the key must be
  pre-registered in the target region.
- `no_sg_acl_rules` removes rules from both the **default security group** and
  the **default network ACL** that IBM Cloud auto-creates at VPC creation time.
  Requires IBM Cloud Terraform provider ≥ 1.35.
- `boot_volume_encryption_mode` accepts two values:
  - `"default"` — IBM provider-managed encryption key (IBM controls the key automatically)
  - `"byok"` — customer-managed key via Key Protect; requires `lab-kms` instance and
    `lab-boot-key` root key to exist in the account (provisioned by `ibmcloud-setup/`),
    and an IAM authorization policy allowing VPC Block Storage (`server-protect`) to use
    the key
