variable "infisical_host" {
  type        = string
  description = "Infisical host URL"
}

variable "infisical_client_id" {
  type        = string
  description = "Infisical machine identity client ID for Terraform authentication"
  sensitive   = true
}

variable "infisical_client_secret" {
  type        = string
  description = "Infisical machine identity client secret for Terraform Authentication"
  sensitive   = true
}

variable "org_id" {
  type        = string
  description = "Infisical organization ID"
}

variable "projects" {
  type = map(object({
    project_name                = string
    project_slug                = string
    environment_slug            = string
    folders                     = list(string)
    access_token_ttl            = number
    access_token_max_ttl        = number
    access_token_num_uses_limit = number
  }))
  description = "Infisical projects to create, keyed by identity name"
}
