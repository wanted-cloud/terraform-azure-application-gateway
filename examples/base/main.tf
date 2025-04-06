resource "azurerm_subnet" "this" {
    name                 = "example-subnet"
    virtual_network_name = "example-vnet"
    resource_group_name  = "example-rg"
    address_prefixes = ["10.0.0.0/24"]
}

locals {
  backend_address_pool_name      = "a-beap"
  frontend_port_name             = "a-feport"
  frontend_ip_configuration_name = "a-feip"
  http_setting_name              = "a-be-htst"
  listener_name                  = "a-httplstn"
  request_routing_rule_name      = "a-rqrt"
  redirect_configuration_name    = "a-rdrcfg"
}

module "template" {
    depends_on = [ azurerm_subnet.this ]
    source = "../.."

    name = "example"
    resource_group_name = "example-rg"

    frontend_ip_configurations = [{
        name                 = "example-frontend-ip-configuration"
        public_ip_address_id = "public-ip-id"
    }]
    frontend_ports = [
        {
            name = "example-frontend-port"
            port = 80
        }
    ]
    gateway_ip_configurations = [
        {
            name      = "example-gateway-ip-configuration"
            subnet_id = azurerm_subnet.this.id
        }
    ]
    backend_address_pools = [{
        fqdns = []
        ip_addresses = []
        name = "example-backend-address-pool"
    }]
    backend_http_settings = [{
        name                  = local.http_setting_name
        cookie_based_affinity = "Disabled"
        path                  = "/path1/"
        port                  = 80
        protocol              = "Http"
        request_timeout       = 60
    }]
    http_listeners = [{
        name                           = local.listener_name
        frontend_ip_config = local.frontend_ip_configuration_name
        frontend_port             = local.frontend_port_name
        protocol                       = "Http"
    }]
    request_routing_rules = [{
        name                       = local.request_routing_rule_name
        priority                   = 9
        rule_type                  = "Basic"
        http_listener_name         = local.listener_name
        backend_address_pool_name  = local.backend_address_pool_name
        backend_http_settings_name = local.http_setting_name
    }]
}