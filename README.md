<!-- BEGIN_TF_DOCS -->
# wanted-cloud/terraform-azure-application-gateway

Terraform building block providing simple management of Azure Application Gateway.

## Table of contents

- [Requirements](#requirements)
- [Providers](#providers)
- [Variables](#inputs)
- [Outputs](#outputs)
- [Resources](#resources)
- [Usage](#usage)
- [Contributing](#contributing)

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>=4.20.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>=4.20.0)

## Required Inputs

The following input variables are required:

### <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools)

Description: Backend address pools for the Application gateway.

Type:

```hcl
list(object({
    name         = string
    ip_addresses = optional(list(string))
    fqdns        = optional(list(string))
  }))
```

### <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings)

Description: Backend HTTP settings for the Application gateway.

Type:

```hcl
list(object({
    name                  = string
    cookie_based_affinity = optional(string)
    path                  = optional(string)
    port                  = optional(number)
    protocol              = optional(string, "Http")
    request_timeout       = optional(number, 20)
  }))
```

### <a name="input_frontend_ip_configurations"></a> [frontend\_ip\_configurations](#input\_frontend\_ip\_configurations)

Description: Frontend IP configurations of the Application gateway.

Type:

```hcl
list(object({
    name                            = string
    public_ip_address_id            = optional(string)
    private_ip_address              = optional(string)
    private_ip_address_allocation   = optional(string)
    private_link_configuration_name = optional(string)
  }))
```

### <a name="input_frontend_ports"></a> [frontend\_ports](#input\_frontend\_ports)

Description: Frontend ports of the Application gateway.

Type:

```hcl
list(object({
    name = string
    port = number
  }))
```

### <a name="input_gateway_ip_configurations"></a> [gateway\_ip\_configurations](#input\_gateway\_ip\_configurations)

Description: Application gateway private IP configurations.

Type:

```hcl
list(object({
    name      = string
    subnet_id = string
  }))
```

### <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners)

Description: HTTP listeners for the Application gateway.

Type:

```hcl
list(object({
    name               = string
    frontend_ip_config = string
    frontend_port      = string
    protocol           = optional(string, "Http")
    host_name          = optional(string)
    require_sni        = optional(bool)
  }))
```

### <a name="input_name"></a> [name](#input\_name)

Description: Name of the Application gateway resource.

Type: `string`

### <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules)

Description: Request routing rules for the Application gateway.

Type:

```hcl
list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    redirect_configuration_name = optional(string)
  }))
```

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: Name of the resource group in which the Application gateway will be created.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_capacity"></a> [capacity](#input\_capacity)

Description: Capacity of the Application gateway.

Type: `number`

Default: `1`

### <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2)

Description: Enable HTTP/2 for the Application gateway.

Type: `bool`

Default: `false`

### <a name="input_fips_enabled"></a> [fips\_enabled](#input\_fips\_enabled)

Description: Enable FIPS mode for the Application gateway.

Type: `bool`

Default: `false`

### <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id)

Description: ID of the firewall policy to be associated with the Application gateway.

Type: `string`

Default: `""`

### <a name="input_force_firewall_policy_association"></a> [force\_firewall\_policy\_association](#input\_force\_firewall\_policy\_association)

Description: Force association of the firewall policy to the Application gateway.

Type: `bool`

Default: `false`

### <a name="input_location"></a> [location](#input\_location)

Description: Location of the resource group in which the Application gateway will be created, if not set it will be the same as the resource group.

Type: `string`

Default: `""`

### <a name="input_metadata"></a> [metadata](#input\_metadata)

Description: Metadata definitions for the module, this is optional construct allowing override of the module defaults defintions of validation expressions, error messages, resource timeouts and default tags.

Type:

```hcl
object({
    resource_timeouts = optional(
      map(
        object({
          create = optional(string, "30m")
          read   = optional(string, "5m")
          update = optional(string, "30m")
          delete = optional(string, "30m")
        })
      ), {}
    )
    tags                     = optional(map(string), {})
    validator_error_messages = optional(map(string), {})
    validator_expressions    = optional(map(string), {})
  })
```

Default: `{}`

### <a name="input_rewrite_rules"></a> [rewrite\_rules](#input\_rewrite\_rules)

Description: Rewrite rules for the Application gateway.

Type:

```hcl
list(object({
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
```

Default: `[]`

### <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name)

Description: Name of the SKU for the Application gateway.

Type: `string`

Default: `"Basic"`

### <a name="input_ssl_certificates"></a> [ssl\_certificates](#input\_ssl\_certificates)

Description: SSL certificates for the Application gateway.

Type:

```hcl
list(object({
    name     = string
    data     = string
    password = optional(string)
  }))
```

Default: `[]`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Tags to be applied to the Application gateway.

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_identities"></a> [user\_assigned\_identities](#input\_user\_assigned\_identities)

Description: List of user assigned identities for the Application gateway.

Type: `list(string)`

Default: `[]`

### <a name="input_zones"></a> [zones](#input\_zones)

Description: Availability zones for the Application gateway.

Type: `list(string)`

Default: `[]`

## Outputs

No outputs.

## Resources

The following resources are used by this module:

- [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

## Usage

> For more detailed examples navigate to `examples` folder of this repository.

Module was also published via Terraform Registry and can be used as a module from the registry.

```hcl
module "example" {
  source  = "wanted-cloud/application-gateway/azure"
  version = "x.y.z"
}
```

### Basic usage example

The minimal usage for the module is as follows:

```hcl
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
```
## Contributing

_Contributions are welcomed and must follow [Code of Conduct](https://github.com/wanted-cloud/.github?tab=coc-ov-file) and common [Contributions guidelines](https://github.com/wanted-cloud/.github/blob/main/docs/CONTRIBUTING.md)._

> If you'd like to report security issue please follow [security guidelines](https://github.com/wanted-cloud/.github?tab=security-ov-file).
---
<sup><sub>_2025 &copy; All rights reserved - WANTED.solutions s.r.o._</sub></sup>
<!-- END_TF_DOCS -->