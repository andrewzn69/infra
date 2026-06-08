output "lb_subnet_id" {
  value       = module.oke.lb_subnet_id
  description = "OCID of the public LB subnet"
}

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
