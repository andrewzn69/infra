# acl

variable "auto_approvers" {
  type        = map(list(string))
  description = "Map of subnet routes to list of tags or users that auto-approve them"
}

variable "acl_tests" {
  description = "List of ACL policy assertions validated on every apply"
  type = list(object({
    src    = string
    accept = optional(list(string), [])
    deny   = optional(list(string), [])
  }))
  default = []
}

variable "grants" {
  type = list(object({
    dst = list(string)
    ip  = list(string)
    src = list(string)
  }))
  description = "List of ACL grant rules"
}

variable "ssh_rules" {
  type = list(object({
    action = string
    dst    = list(string)
    src    = list(string)
    users  = list(string)
  }))
  description = "List of Tailscale SSH rules"
}

variable "tag_owners" {
  type        = map(list(string))
  description = "Map of tag to list of owners"
}

# auth

variable "tailscale_api_key" {
  type        = string
  description = "Tailscale API key"
  sensitive   = true
}

# contacts

variable "contact_account_email" {
  type        = string
  description = "Email for important tailnet change communications"
}

variable "contact_security_email" {
  type        = string
  description = "Email for security issue communications"
}

variable "contact_support_email" {
  type        = string
  description = "Email for misconfiguration communications"
}

# dns

variable "dns_magic_dns" {
  type        = bool
  description = "Whether to enable Magic DNS"
}

variable "dns_nameservers" {
  type        = list(string)
  description = "Nameservers for the tailnet"
}

variable "dns_search_paths" {
  type        = list(string)
  description = "DNS search paths for the tailnet"
}

# keys

variable "keys" {
  type = map(object({
    description   = string
    ephemeral     = bool
    expiry        = number
    preauthorized = bool
    reusable      = bool
    tags          = set(string)
  }))
  description = "Auth keys to create, keyed by name"
}

# settings

variable "acls_external_link" {
  type        = string
  description = "Link to external ACL definition or management system"
}

variable "acls_externally_managed_on" {
  type        = bool
  description = "Prevent users from editing policies in the admin console"
}

variable "devices_approval_on" {
  type        = bool
  description = "Whether device approval is required before joining the tailnet"
}

variable "devices_auto_updates_on" {
  type        = bool
  description = "Whether auto updates are enabled for devices"
}

variable "devices_key_duration_days" {
  description = "Key expiry duration in days for devices"
  type        = number
}

variable "https_enabled" {
  type        = bool
  description = "Whether HTTPS certificate provisioning is enabled"
}

variable "network_flow_logging_on" {
  type        = bool
  description = "Whether network flow logs are enabled"
}

variable "posture_identity_collection_on" {
  type        = bool
  description = "Whether identity collection is enabled for device posture integrations"
}

variable "regional_routing_on" {
  type        = bool
  description = "Whether regional routing is enabled"
}

variable "users_approval_on" {
  type        = bool
  description = "Whether user approval is required"
}

variable "users_role_allowed_to_join_external_tailnet" {
  type        = string
  description = "Which user roles are allowed to join external tailnets"
}

# tailnet

variable "tailnet" {
  type        = string
  description = "Tailscale tailnet name"
}

# webhooks

variable "webhooks" {
  description = "Webhook endpoints to create, keyed by name"
  type = map(object({
    endpoint_url  = string
    provider_type = optional(string)
    subscriptions = set(string)
  }))
}
