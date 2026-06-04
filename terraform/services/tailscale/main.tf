# acl

resource "tailscale_acl" "this" {
  acl = jsonencode({
    autoApprovers = {
      routes = var.auto_approvers
    }
    grants    = var.grants
    ssh       = var.ssh_rules
    tagOwners = var.tag_owners
    tests     = var.acl_tests
  })

  overwrite_existing_content = true
}

# contacts

resource "tailscale_contacts" "this" {
  account {
    email = var.contact_account_email
  }

  security {
    email = var.contact_security_email
  }

  support {
    email = var.contact_support_email
  }
}

# dns

resource "tailscale_dns_nameservers" "this" {
  count       = length(var.dns_nameservers) > 0 ? 1 : 0
  nameservers = var.dns_nameservers
}

resource "tailscale_dns_preferences" "this" {
  magic_dns = var.dns_magic_dns
}

resource "tailscale_dns_search_paths" "this" {
  search_paths = var.dns_search_paths
}

# keys

resource "tailscale_tailnet_key" "this" {
  for_each = var.keys

  description   = each.value.description
  ephemeral     = each.value.ephemeral
  expiry        = each.value.expiry
  preauthorized = each.value.preauthorized
  reusable      = each.value.reusable
  tags          = each.value.tags
}

# settings

resource "tailscale_tailnet_settings" "this" {
  acls_external_link                          = var.acls_external_link != "" ? var.acls_external_link : null
  acls_externally_managed_on                  = var.acls_externally_managed_on
  devices_approval_on                         = var.devices_approval_on
  devices_auto_updates_on                     = var.devices_auto_updates_on
  devices_key_duration_days                   = var.devices_key_duration_days
  https_enabled                               = var.https_enabled
  network_flow_logging_on                     = var.network_flow_logging_on
  posture_identity_collection_on              = var.posture_identity_collection_on
  regional_routing_on                         = var.regional_routing_on
  users_approval_on                           = var.users_approval_on
  users_role_allowed_to_join_external_tailnet = var.users_role_allowed_to_join_external_tailnet
}

# webhooks

resource "tailscale_webhook" "this" {
  for_each = var.webhooks

  endpoint_url  = each.value.endpoint_url
  provider_type = each.value.provider_type
  subscriptions = each.value.subscriptions
}
