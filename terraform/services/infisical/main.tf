module "projects" {
  source   = "git::https://github.com/andrewzn69/tf-infisical-project.git?ref=v0.1.3"
  for_each = var.projects

  org_id                      = var.org_id
  identity_name               = "k8s-operator-${each.key}"
  project_name                = each.value.project_name
  project_slug                = each.value.project_slug
  environment_slug            = each.value.environment_slug
  folders                     = each.value.folders
  access_token_ttl            = each.value.access_token_ttl
  access_token_max_ttl        = each.value.access_token_max_ttl
  access_token_num_uses_limit = each.value.access_token_num_uses_limit
}
