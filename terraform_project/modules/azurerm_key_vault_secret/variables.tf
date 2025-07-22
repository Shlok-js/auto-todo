variable "secret_name" {
  description = "The name of the Key Vault secret"
  type        = string
}

variable "secret_value" {
  description = "The value of the Key Vault secret"
  type        = string
  sensitive   = true
}

variable "key_vault_id" {
  description = "The ID of the Key Vault where the secret will be stored"
  type        = string
}

variable "manual_dependencies" {
  description = "Explicit dependencies (optional)"
  type        = list(any)
  default     = []
}

