variable "name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "location" {
  description = "The Azure location where the Key Vault will be created."
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Key Vault. Possible values are 'standard' and 'premium'."
  type        = string
  default     = "standard"
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  type        = string
}

variable "object_id" {
  description = "Object ID of the service principal or user for Key Vault access policy"
  type        = string
}


