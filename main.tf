# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-storage"
#     storage_account_name = "saterrafrom"
#     container_name       = "con-terraform"
#     key                  = "eWyDSCS5KVJrG8pWvd2V3GIgH/VFje0VWALT8eGelQrja70djIjnZsjlyTRfaeJr8ewU4av83LI50Ueud91Epw=="
#   }
# }

# data "azurerm_client_config" "current" {}


provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-terraform-test-2"
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
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
  
#   delegation {
#     name = "subnet-webapp"

#     service_delegation {
#       name    = "Microsoft.Web/serverFarms"
#       actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#     }
#   }
}


# resource "azurerm_subnet" "db" {
#   name                 = "subnet-db"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.main.name
#   address_prefixes     = ["10.0.2.0/24"]
  
# }


resource "azurerm_kubernetes_cluster" "main" {
  name                = "aks-test-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "akstest01"

  
  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.main.id
  }

  service_principal {
    client_id     = "32fd6f81-a786-4246-9ea1-fc5bfbec52d4"
    client_secret = "IRv3oMHMd_8hELQ.iEuICI-l3aOzT99OCE"
  }
  
  network_profile {
    load_balancer_sku = "Standard"
    network_plugin = "kubenet"
  }
  
}
#   custom_data = "${base64encode(file("../script/script-mongodb.sh"))}"
