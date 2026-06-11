output "cluster_endpoint" {
  value       = module.oke.cluster_endpoint
  description = "OKE cluster API endpoint"
}

output "cluster_id" {
  value       = module.oke.cluster_id
  description = "OKE cluster OCID"
}

output "kubeconfig" {
  value       = module.oke.kubeconfig
  description = "Kubeconfig for the OKE cluster"
  sensitive   = true
}

output "lb_subnet_id" {
  value       = oci_core_subnet.lb.id
  description = "OCID of the public load balancer subnet"
}
