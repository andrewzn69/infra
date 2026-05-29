output "project_ids" {
  value       = { for k, v in module.projects : k => v.project_id }
  description = "Project IDs keyed by identity name"
}

output "credentials" {
  value = { for k, v in module.projects : k => {
    client_id     = v.client_id
    client_secret = v.client_secret
  } }
  description = "Client credentials for Kubernetes operator, keyed by identity name"
  sensitive   = true
}
