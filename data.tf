data "azurerm_log_analytics_workspace" "webapp" {
  name                = "xxxxxxxxxxxx"
  resource_group_name = "xxxxxxxxxxxx"
}

//First Read the External Key Vault

data "azurerm_key_vault" "kv" {
  name                = "xxxxxxxxxxxx"
  resource_group_name = "xxxxxxxxxxxx"
}

