output "vpc_id" {
  value = ibm_is_vpc.vpc.id
}

output "vsi_public_ip" {
  value = ibm_is_instance.vsi.primary_network_interface[0].primary_ip[0].address
}