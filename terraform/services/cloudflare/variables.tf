# auth

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token"
  sensitive   = true
}

# account

variable "account_id" {
  type        = string
  description = "Cloudflare account ID"
}

# zones

variable "zones" {
  type = map(object({
    paused = bool
    type   = string
  }))
  description = "DNS zones to manage, keyed by zone name"
}

# dns

variable "dns_records" {
  type = map(object({
    zone_name = string
    name      = string
    type      = string
    content   = string
    proxied   = bool
    ttl       = number
    priority  = optional(number)
    comment   = string
  }))
  description = "Static DNS records to manage, keyed by unique identifier"
}

# tunnels

variable "tunnels" {
  type = map(object({
    config_src = string
  }))
  description = "Cloudflare tunnels to manage, keyed by name"
}

# email

variable "email_routing_rules" {
  type = map(object({
    zone_name = string
    enabled   = bool
    priority  = number
    matchers = list(object({
      type  = string
      field = string
      value = string
    }))
    actions = list(object({
      type  = string
      value = list(string)
    }))
  }))
  description = "Email forwarding rules, keyed by unique identifier"
}

variable "email_catch_all" {
  type = map(object({
    zone_name = string
    enabled   = bool
    action    = string
  }))
  description = "Catch-all email routing rules keyed by zone name"
}
