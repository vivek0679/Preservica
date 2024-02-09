// Resource Group Creation for Applications
resource "azurerm_resource_group" "shared-rg" {
  name                     = var.resource_group_name_shared
  location                 = var.location
}


/////////Random password for sql server
resource "random_password" "admin_password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  admin_password = try(random_password.admin_password[0].result, var.admin_password)
}


resource "azurerm_mssql_server" "server" {
  name                         = var.mssql_server_name
  resource_group_name          = var.resource_group_name_shared
  location                     = var.location
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"
}

resource "azurerm_mssql_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.server.id
}



///application insight for webapps

resource "azurerm_application_insights" "app_insight" {
  name                  = var.app_insight
  resource_group_name   = var.resource_group_name_shared
  location              = var.location
  workspace_id          = data.azurerm_log_analytics_workspace.webapp
  application_type      = "web"
}