output "zone_ids" {
  value       = { for k, v in cloudflare_zone.this : k => v.id }
  description = "Zone IDs keyed by zone name"
}

output "tunnel_ids" {
  value       = { for k, v in cloudflare_zero_trust_tunnel_cloudflared.this : k => v.id }
  description = "Tunnel IDs keyed by tunnel name"
}
