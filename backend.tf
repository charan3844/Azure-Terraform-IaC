# Terraform block -1000
terraform {
backend "azurerm" {
      resource_group_name  = "RG"
      storage_account_name = "stoargeazurepipeline"
      container_name       = "azurecontainer"
      key                  = "remote.tfstate" #.tfstate give same
  }
}