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

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-test1"
  location = "koreacentral"
}
