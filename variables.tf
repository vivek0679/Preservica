variable "prefix" {
  type        = string
  description = "Prefix"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Application Gateway."
}

variable "resource_group_name_shared" {
  type        = string
  description = "The name of the resource group in which to create the Application Gateway."
}

variable "location" {
  type        = string
  description = "The location/region where the Application Gateway is created."
}

variable "appgw_pip_name" {
  type        = string
  description = "Public Ip name for the application gateway"
}

variable "ssl_certificate_webapp01" {
  type        = string
  description = "ssl certificate name for the webapps"
}

variable "ssl_certificate_webapp02" {
  type        = string
  description = "ssl certificate name for the webapps"
}

variable "sku" {
  type        = string
  description = "Web apps sku"
}

variable "wepapp01" {
  type        = string
  description = "Web App name"
}

variable "wepapp02" {
  type        = string
  description = "Web App name"
}

variable "wepapp01-fqdn" {
  type        = string
  description = "Hostname Web App name"
}

variable "wepapp02-fqdn" {
  type        = string
  description = "Hostname Web App name"
}

variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
 
}

variable "mssql_server_name" {
  type        = string
  description = "The name of the SQL Server."

}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}

variable "app_service_plan" {
  type        = string
  description = "The name of the App service plan."

}


