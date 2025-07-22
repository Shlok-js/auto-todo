resource "azurerm_key_vault" "example" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = var.sku_name

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
    "Get",
    "Set",
    "List",
    "Delete"
    ]
  }
}
