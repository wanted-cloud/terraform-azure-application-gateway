variable "name" {
  description = "Name of the Application gateway resource."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group in which the Application gateway will be created."
  type        = string
}

variable "location" {
  description = "Location of the resource group in which the Application gateway will be created, if not set it will be the same as the resource group."
  type        = string
  default     = ""
}

variable "sku_name" {
  description = "Name of the SKU for the Application gateway."
  type        = string
  default     = "Basic"

}

variable "capacity" {
  description = "Capacity of the Application gateway."
  type        = number
  default     = 1
}

variable "gateway_ip_configurations" {
  description = "Application gateway private IP configurations."
  type = list(object({
    name      = string
    subnet_id = string
  }))
}

variable "frontend_ports" {
  description = "Frontend ports of the Application gateway."
  type = list(object({
    name = string
    port = number
  }))
}

variable "frontend_ip_configurations" {
  description = "Frontend IP configurations of the Application gateway."
  type = list(object({
    name                            = string
    public_ip_address_id            = optional(string)
    private_ip_address              = optional(string)
    private_ip_address_allocation   = optional(string)
    private_link_configuration_name = optional(string)
  }))
}

variable "zones" {
  description = "Availability zones for the Application gateway."
  type        = list(string)
  default     = []

}

variable "fips_enabled" {
  description = "Enable FIPS mode for the Application gateway."
  type        = bool
  default     = false

}

variable "enable_http2" {
  description = "Enable HTTP/2 for the Application gateway."
  type        = bool
  default     = false
}

variable "force_firewall_policy_association" {
  description = "Force association of the firewall policy to the Application gateway."
  type        = bool
  default     = false
}

variable "firewall_policy_id" {
  description = "ID of the firewall policy to be associated with the Application gateway."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to the Application gateway."
  type        = map(string)
  default     = {}
}

variable "user_assigned_identities" {
  description = "List of user assigned identities for the Application gateway."
  type        = list(string)
  default     = []
}

variable "backend_address_pools" {
  description = "Backend address pools for the Application gateway."
  type = list(object({
    name         = string
    ip_addresses = optional(list(string))
    fqdns        = optional(list(string))
  }))
}

variable "http_listeners" {
  description = "HTTP listeners for the Application gateway."
  type = list(object({
    name               = string
    frontend_ip_config = string
    frontend_port      = string
    protocol           = optional(string, "Http")
    host_name          = optional(string)
    require_sni        = optional(bool)
  }))
}

variable "request_routing_rules" {
  description = "Request routing rules for the Application gateway."
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    redirect_configuration_name = optional(string)
  }))
}

variable "backend_http_settings" {
  description = "Backend HTTP settings for the Application gateway."
  type = list(object({
    name                  = string
    cookie_based_affinity = optional(string)
    path                  = optional(string)
    port                  = optional(number)
    protocol              = optional(string, "Http")
    request_timeout       = optional(number, 20)
  }))
}

variable "ssl_certificates" {
  description = "SSL certificates for the Application gateway."
  type = list(object({
    name     = string
    data     = string
    password = optional(string)
  }))
  default = []
}

variable "rewrite_rules" {
  description = "Rewrite rules for the Application gateway."
  type = list(object({
    name = string
    actions = list(object({
      action_set_name = string
      action_type     = string
      request_header  = optional(string)
      response_header = optional(string)
    }))
    conditions = list(object({
      variable    = string
      operator    = string
      value       = string
      ignore_case = optional(bool, false)
    }))
  }))
  default = []
}