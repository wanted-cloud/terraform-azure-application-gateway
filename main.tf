/*
 * # wanted-cloud/terraform-azure-application-gateway
 * 
 * Terraform building block providing simple management of Azure Application Gateway.
 */

locals {
  backend_address_pool_name      = "${var.name}-beap"
  frontend_port_name             = "${var.name}-feport"
  frontend_ip_configuration_name = "${var.name}-feip"
  http_setting_name              = "${var.name}-be-htst"
  listener_name                  = "${var.name}-httplstn"
  request_routing_rule_name      = "${var.name}-rqrt"
  redirect_configuration_name    = "${var.name}-rdrcfg"
}

resource "azurerm_application_gateway" "this" {
  name                = var.name
  location            = var.location != "" ? var.location : data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  fips_enabled = var.fips_enabled
  zones        = var.zones
  tags         = merge(local.metadata.tags, var.tags)

  sku {
    name     = var.sku_name
    tier     = var.sku_name
    capacity = var.capacity
  }

  dynamic "gateway_ip_configuration" {
    for_each = {
      for ip_configuration in var.gateway_ip_configurations : ip_configuration.name => ip_configuration
    }

    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = gateway_ip_configuration.value.subnet_id
    }
  }

  dynamic "frontend_port" {
    for_each = {
      for frontend_port in var.frontend_ports : frontend_port.name => frontend_port
    }
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "identity" {
    for_each = length(var.user_assigned_identities) > 0 ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.user_assigned_identities
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = {
      for frontend_ip_configuration in var.frontend_ip_configurations : frontend_ip_configuration.name => frontend_ip_configuration
    }
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    }
  }

  dynamic "backend_address_pool" {
    for_each = {
      for backend_address_pool in var.backend_address_pools : backend_address_pool.name => backend_address_pool
    }
    content {
      name         = backend_address_pool.value.name
      ip_addresses = backend_address_pool.value.ip_addresses
      fqdns        = backend_address_pool.value.fqdns
    }
  }

  dynamic "backend_http_settings" {
    for_each = {
      for backend_http_setting in var.backend_http_settings : backend_http_setting.name => backend_http_setting
    }

    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = {
      for http_listener in var.http_listeners : http_listener.name => http_listener
    }
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_config
      frontend_port_name             = http_listener.value.frontend_port
      protocol                       = http_listener.value.protocol
    }
  }

  dynamic "request_routing_rule" {
    for_each = {
      for request_routing_rule in var.request_routing_rules : request_routing_rule.name => request_routing_rule
    }

    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }

  }
}