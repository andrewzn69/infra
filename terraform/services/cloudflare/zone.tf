resource "cloudflare_zone" "this" {
  for_each = var.zones

  name   = each.key
  paused = each.value.paused
  type   = each.value.type

  account = {
    id = var.account_id
  }
}
