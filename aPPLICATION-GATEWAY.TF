// Public Ip creation for Application Gateway

resource "azurerm_public_ip" "agw" {
  name                = var.appgw_pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  sku_name = "Standard_v2" #Sku with WAF is : WAF_v2
  sku_tier = "Standard_v2"
  zones    = ["1", "2", "3"] #Availability zones to spread the Application Gateway over. They are also only supported for v2 SKUs.
  capacity = {
    min = 1 #Minimum capacity for autoscaling. Accepted values are in the range 0 to 100.
    max = 3 #Maximum capacity for autoscaling. Accepted values are in the range 2 to 125.
  }

}

///Application Gateway

resource "azurerm_application_gateway" "agw" {
  name                = "${var.prefix}-hub-agw1"
  location            = var.location
  resource_group_name = var.resource_group_name
  enable_http2        = true
  zones               = local.zones
  

  sku {
    name = local.sku_name
    tier = local.sku_tier
  }

  autoscale_configuration {
    min_capacity = local.capacity.min
    max_capacity = local.capacity.max
  }


  gateway_ip_configuration {
    name      = "${var.prefix}-hub-agw1-ip-configuration"
    subnet_id = local.subnet_id
  }

  frontend_ip_configuration {
    name                 = "${var.appgw_pip_name}-public"
    public_ip_address_id = azurerm_public_ip.agw.id
  }

  frontend_port {
    name = "${local.frontend_port_name}-80"
    port = 80
  }

  frontend_port {
    name = "${local.frontend_port_name}-443"
    port = 443
  }
#############################WEB_APP-01#################################################
  backend_address_pool {
    name  = "${var.wepapp01}-pool"
    fqdns = var.wepapp01-fqdn
  }

  ssl_certificate {
    name                = var.ssl_certificate_webapp01
    key_vault_secret_id = data.azurerm_key_vault.kv.id
  }

  backend_http_settings {
    name                  = "${var.wepapp01}-http_setting_name"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    pick_host_name_from_backend_address = true
    request_timeout       = 1
  }


  http_listener {
    name                           = "${var.wepapp01}-https"
    frontend_ip_configuration_name = "${var.wepapp01}-public"
    frontend_port_name             = "${var.wepapp01}-443"
    protocol                       = "Https"
    ssl_certificate_name           = var.wepapp01
  }

  request_routing_rule {
    name                       = "${var.wepapp01}-https"
    rule_type                  = "Basic"
    http_listener_name         = "${var.wepapp01}-https"
    backend_address_pool_name  = "${var.wepapp01}-pool"
    backend_http_settings_name = "${var.wepapp01}-http_setting_name"
  }

################WEB_APP-02###############
  backend_address_pool {
    name  = "${var.wepapp02}-pool"
    fqdns = var.wepapp01-fqdn
  }

  ssl_certificate {
    name                = var.ssl_certificate_webapp02
    key_vault_secret_id = data.azurerm_key_vault.kv.id
  }

  backend_http_settings {
    name                  = "${var.wepapp02}-http_setting_name"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    pick_host_name_from_backend_address = true
    request_timeout       = 1
  }


  http_listener {
    name                           = "${var.wepapp02}-https"
    frontend_ip_configuration_name = "${var.wepapp02}-public"
    frontend_port_name             = "${var.wepapp02}-443"
    protocol                       = "Https"
    ssl_certificate_name           = var.wepapp02
  }

  request_routing_rule {
    name                       = "${var.wepapp02}-https"
    rule_type                  = "Basic"
    http_listener_name         = "${var.wepapp02}-https"
    backend_address_pool_name  = "${var.wepapp02}-pool"
    backend_http_settings_name = "${var.wepapp02}-http_setting_name"
  }
  // Ignore most changes as they will be managed manually
  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_port,
      http_listener,
      probe,
      request_routing_rule,
      ssl_certificate,
       ]
  }
}