terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = "cb129d26-97d3-43a4-9782-7b2ca3e81cd4"
  tenant_id         = "9da468c6-2260-4466-9e2b-d0dbb15ef88b"
}

resource "azurerm_resource_group" "rsg" {
  name = "rsg_case1_mdl"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "acrCaseRestMarcio"
  resource_group_name = azurerm_resource_group.rsg.name
  location            = azurerm_resource_group.rsg.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications {
    location                = "Central US"
    zone_redundancy_enabled = false
    tags                    = {}
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = "aks_case1_marcio"
    location            = azurerm_resource_group.rsg.location
    resource_group_name = azurerm_resource_group.rsg.name
    dns_prefix          = "aksCaseHeart"

    default_node_pool {
    	name       = "default"
	node_count = 1
	vm_size    = "Standard_D2_v2"
    }
    identity {
	type = "SystemAssigned"
    }
    tags = {
        Environment = "Development"
    }
    role_based_access_control {
	enabled = true
    }
}

resource "azurerm_role_assignment" "kubweb_to_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
}
