output "vpc_id" {
  description = "ID of the created VPC"
  value       = ibm_is_vpc.vpc.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = ibm_is_subnet.subnet.id
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = ibm_is_security_group.sg.id
}

output "vsi_id" {
  description = "ID of the created VSI"
  value       = ibm_is_instance.vsi.id
}

output "vsi_private_ip" {
  description = "Private IP address of the VSI"
  value       = ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address
}
