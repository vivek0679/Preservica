


// Resource Group Creation for Applications
resource "azurerm_resource_group" "application-rg" {
  name                     = var.resource_group_name
  location                 = var.location
}

resource "azurerm_service_plan" "application" {
  name                = var.app_service_plan
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku
  os_type             = "Windows"
}

resource "azurerm_windows_web_app" "application-1" {
  name                = var.wepapp01
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.application.id

  site_config {
    application_insights_connection_string = "${azurerm_application_insights.app_insight.connection_string}"
    application_insights_key = "${azurerm_application_insights.app_insight.instrumentation_key}"  
  }
}


resource "azurerm_windows_web_app" "application-2" {
  name                = var.wepapp02
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.application.id

  site_config {

    application_insights_connection_string = "${azurerm_application_insights.app_insight.connection_string}"
    application_insights_key = "${azurerm_application_insights.app_insight.instrumentation_key}"  
  }
}

