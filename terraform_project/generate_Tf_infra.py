import os

# Project root
parent_dir = "terraform_project"

# New structure folders
parent_infra_dir = os.path.join(parent_dir, "parentInfra")
modules_dir = os.path.join(parent_dir, "modules")

# Files for parentInfra
parent_files = ["main.tf", "provider.tf"]

# Child modules and their file templates
child_modules = [
    "azurerm_resource_group",
    "azurerm_virtual_network",
    "azurerm_virtual_machine",
    "azurerm_public_ip",
    "azurerm_subnet",
    "azurerm_sql_server",
    "azurerm_sql_database",
    "azurerm_key_vault",
    "azurerm_key_vault_secret",
]

# Create base directories
os.makedirs(parent_infra_dir, exist_ok=True)
os.makedirs(modules_dir, exist_ok=True)

# Create files in parentInfra folder
for file in parent_files:
    path = os.path.join(parent_infra_dir, file)
    if not os.path.exists(path):
        with open(path, "w") as f:
            f.write(f"// {file} for parentInfra\n")

# Create child module folders and files
for module in child_modules:
    module_path = os.path.join(modules_dir, module)
    os.makedirs(module_path, exist_ok=True)

    for tf_file in ["main.tf", "variables.tf"]:
        file_path = os.path.join(module_path, tf_file)
        with open(file_path, "w") as f:
            f.write(f"// {tf_file} for {module}\n")

