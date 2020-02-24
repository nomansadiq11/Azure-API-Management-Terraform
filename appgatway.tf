



resource "azurerm_public_ip" "pf_ApplicationGateway_Pub_IP" {
  name                = "acsprodagpip"
  location            = "${azurerm_resource_group.APIManagment.location}"
  resource_group_name = "${azurerm_resource_group.APIManagment.name}"
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.PaymentSecVNet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.PaymentSecVNet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.PaymentSecVNet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.PaymentSecVNet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.PaymentSecVNet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.PaymentSecVNet.name}-rqrt"
}

resource "azurerm_application_gateway" "PF_ApplicationGateway" {
  name                = "acsprodappgateway"
  resource_group_name = "${azurerm_resource_group.PaymentFacade.name}"
  location            = "${azurerm_resource_group.PaymentFacade.location}"

  sku {
    name     = "WAF_Medium"
    tier     = "WAF"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = "${azurerm_subnet.pfvmsubnet.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.pf_ApplicationGateway_Pub_IP.id}"
  }

  

  backend_address_pool {
    name = "API and Web"
    ip_addresses  = ["10.245.0.67", "10.245.0.68"]
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }
}

# resource "azurerm_network_interface" "pf_nic_appgateway1" {
#   name                = "pf-nic-appgateway1"
#   location            = "${azurerm_resource_group.PaymentFacade.location}"
#   resource_group_name = "${azurerm_resource_group.PaymentFacade.name}"

#   ip_configuration {
#     name                          = "configuration1fornic"
#     subnet_id                     = "${azurerm_subnet.pf_appgateway.id}"
#     private_ip_address_allocation = "Dynamic"
#   }
# }



# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "example" {
#   network_interface_id    = "${azurerm_network_interface.pf_nic_appgateway1.id}"
#   ip_configuration_name   = "configuration-nic-appgateway-backendpool"
#   backend_address_pool_id = "${azurerm_application_gateway.PF_ApplicationGateway.backend_address_pool.0.id}"
# }