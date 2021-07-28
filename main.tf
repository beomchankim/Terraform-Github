terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-test"
    storage_account_name = "terraformazuretf"
    container_name       = "terraform-state-test"
    key                  = "PZFjC7Ljc1tXSotnB7r1WwuPKxwshUBgtuUUM3fucU/lWzfVTjEcOoAeYxkVBD/fcnUfckKohkMFslHtdItp8A=="
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-terraform-test-1"
  location = "koreacentral"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-webapp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-webapp"
  virtual_network_name = azurerm_virtual_network.main.name
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_app_service_plan" "main" {
  name                = "example-service-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "main" {
  name                = "example-app-service"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id
}

resource "azurerm_app_service_virtual_network_swift_connection" "main" {
  app_service_id = azurerm_app_service.main.id
  subnet_id      = azurerm_subnet.main.id
}

# # Create public IPs
# resource "azurerm_public_ip" "main" {
#   name                  = "pip-webapp"
#   location              = azurerm_resource_group.rg.location
#   resource_group_name   = azurerm_resource_group.rg.name
#   allocation_method     = "Static"
#   sku                   = "Standard"
#   availability_zone     = "No-Zone"
# }
