output "kubeconfig_raw" {
  value       = module.talos_cluster.kubeconfig_raw
  description = "Raw kubeconfig for kubectl"
  sensitive   = true
}

output "talosconfig" {
  value       = module.talos_cluster.talosconfig
  description = "Talos client configuration for talosctl"
  sensitive   = true
}
