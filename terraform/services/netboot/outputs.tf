output "id" {
  description = "Container VM ID"
  value       = module.lxc.id
}

output "ipv4_address" {
  description = "IPv4 address of the netboot.xyz container"
  value       = module.lxc.ipv4_address
}
