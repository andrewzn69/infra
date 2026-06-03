output "auth_keys" {
  value       = { for k, v in tailscale_tailnet_key.this : k => v.key }
  description = "Auth keys created in this workspace, keyed by name"
  sensitive   = true
}
