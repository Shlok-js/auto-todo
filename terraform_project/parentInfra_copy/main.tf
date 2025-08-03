

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





module "virtual_machine" {
  depends_on = [
    module.backend_subnet,
    module.public_ip_frontend
  ]
  source               = "../modules/azurerm_virtual_machine"
  resource_group_name  = module.resource_group.name
  location             = "West Europe"
  vm_name              = "vm-bhavastorage"
  vm_size              = "Standard_B1s"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-vm-bhavastorage"
  frontend_ip_name     = module.public_ip_frontend.public_ip_name
  vnet_name            = module.virtual_network.name
  frontend_subnet_name = module.frontend_subnet.subnet_name
  admin_username       = var.admin_username
  admin_password       = var.admin_password
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
  sensitive   = true
}


 

