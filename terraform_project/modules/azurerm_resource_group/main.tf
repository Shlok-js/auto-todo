resource "azurerm_resource_group" "pompu" {
    name     = var.resource_group_name
    location = var.location 
}