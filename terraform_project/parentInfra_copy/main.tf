

module "resource_group" {
  source              = "../modules/azurerm_resource_group"
  resource_group_name = "rg-bhai"
  location            = "West Europe"
}

module "storage_account" {
  source               = "../modules/azurerm_storage_account"
  storage_account_name = "billugstorage"
  location             = module.resource_group.location
  resource_group_name  = module.resource_group.name
  tags = {
    environment = "dev"
  }
}

module "virtual_network" {
  depends_on               = [module.resource_group]
  source                   = "../modules/azurerm_virtual_network"
  virtual_network_name     = "vnet-bhavastorage"
  virtual_network_location = "West Europe"
  resource_group_name      = module.resource_group.name
  address_space            = ["10.10.0.0/16"]
}

module "frontend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  subnet_name          = "frontend-subnet"
  address_prefixes     = ["10.10.1.0/24"]
}

module "backend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  subnet_name          = "backend-subnet"
  address_prefixes     = ["10.10.2.0/24"]
}

module "public_ip_frontend" {
  source              = "../modules/azurerm_public_ip"
  public_ip_name      = "pip-bhavastorage-frontend"
  resource_group_name = module.resource_group.name
  location            = "West Europe"
  allocation_method   = "Static"
}

module "key_vault" {
  source              = "../modules/azurerm_key_vault"
  name                = "bhauvault"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

module "key_vault_secret_username" {
  source              = "../modules/azurerm_key_vault_secret"
  secret_name         = "vm-username"
  secret_value        = var.vm_admin_username
  key_vault_id        = module.key_vault.id
  manual_dependencies = [module.key_vault]
}

module "key_vault_secret_password" {
  source              = "../modules/azurerm_key_vault_secret"
  secret_name         = "vm-password"
  secret_value        = var.vm_admin_password
  key_vault_id        = module.key_vault.id
  manual_dependencies = [module.key_vault]
}

module "virtual_machine" {
  depends_on = [
    module.backend_subnet,
    module.key_vault,
    module.key_vault_secret_username,
    module.key_vault_secret_password,
    module.public_ip_frontend
  ]
  source               = "../modules/azurerm_virtual_machine"
  resource_group_name  = module.resource_group.name
  location             = "West Europe"
  vm_name              = "vm-bhavastorage"
  vm_size              = "Standard_B1s"
  admin_username       = "devopsadmin"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-vm-bhavastorage"
  frontend_ip_name     = module.public_ip_frontend.public_ip_name
  vnet_name            = module.virtual_network.name
  frontend_subnet_name = module.frontend_subnet.subnet_name
  key_vault_name       = module.key_vault.name
  username_secret_name = "vm-username"
  password_secret_name = "vm-password"
}

variable "vm_admin_username" {
  description = "VM admin username"
  type        = string
}

variable "vm_admin_password" {
  description = "VM admin password"
  type        = string
  sensitive   = true
}
