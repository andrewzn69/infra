resource "cloudflare_email_routing_settings" "this" {
  for_each = var.zones

  zone_id = cloudflare_zone.this[each.key].id
  enabled = each.value.email_routing
}

resource "cloudflare_email_routing_rule" "this" {
  for_each = var.email_routing_rules

  zone_id  = cloudflare_zone.this[each.value.zone_name].id
  enabled  = each.value.enabled
  name     = each.key
  priority = each.value.priority

  matchers = each.value.matchers
  actions  = each.value.actions
}

resource "cloudflare_email_routing_rule" "catch_all" {
  for_each = var.email_catch_all

  zone_id = cloudflare_zone.this[each.value.zone_name].id
  enabled = each.value.enabled
  name    = each.key

  matchers = [{
    type = "all"
  }]

  actions = [{
    type = each.value.action
  }]
}
