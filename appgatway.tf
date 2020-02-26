



resource "azurerm_public_ip" "pf_ApplicationGateway_Pub_IP" {
  name                = "acsprodagpip1"
  location            = "${azurerm_resource_group.APIManagment.location}"
  resource_group_name = "${azurerm_resource_group.APIManagment.name}"
  allocation_method   = "Dynamic"
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name_API      = "${azurerm_virtual_network.PaymentSecVNet.name}-api"
  frontend_port_name_API             = "${azurerm_virtual_network.PaymentSecVNet.name}-api-feport"
  frontend_ip_configuration_name_API = "${azurerm_virtual_network.PaymentSecVNet.name}-api-feip"
  http_setting_name_API              = "${azurerm_virtual_network.PaymentSecVNet.name}-api-htst"
  listener_name_API                  = "${azurerm_virtual_network.PaymentSecVNet.name}-api-httplstn"
  request_routing_rule_name_API      = "${azurerm_virtual_network.PaymentSecVNet.name}-api-rqrt"


  backend_address_pool_name_Web      = "${azurerm_virtual_network.PaymentSecVNet.name}-web"
  frontend_port_name_Web             = "${azurerm_virtual_network.PaymentSecVNet.name}-web-feport"
  frontend_ip_configuration_name_Web = "${azurerm_virtual_network.PaymentSecVNet.name}-web-feip"
  http_setting_name_Web              = "${azurerm_virtual_network.PaymentSecVNet.name}-web-htst"
  listener_name_Web                  = "${azurerm_virtual_network.PaymentSecVNet.name}-web-httplstn"
  request_routing_rule_name_Web      = "${azurerm_virtual_network.PaymentSecVNet.name}-web-rqrt"



}

resource "azurerm_application_gateway" "PF_ApplicationGateway" {
  name                = "acsprodappgateway1"
  resource_group_name = "${azurerm_resource_group.APIManagment.name}"
  location            = "${azurerm_resource_group.APIManagment.location}"

  sku {
    name     = "WAF_Medium"
    tier     = "WAF"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = "${azurerm_subnet.pfAGsubnet.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name_API}"
    port = 80
  }

  frontend_port {
    name = "${local.frontend_port_name_Web}"
    port = 80
  }

  
  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name_API}"
    public_ip_address_id = "${azurerm_public_ip.pf_ApplicationGateway_Pub_IP.id}"
  }

  

  

  

  backend_address_pool {
  
    name = "${local.backend_address_pool_name_API}"
    ip_address_list = ["10.245.0.67"]
  }

  backend_address_pool {
  
    name = "${local.backend_address_pool_name_Web}"
    ip_address_list = ["10.245.0.68"]
  }
    


  backend_http_settings {
    name                  = "${local.http_setting_name_API}"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  backend_http_settings {
    name                  = "${local.http_setting_name_Web}"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = "${local.listener_name_API}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name_API}"
    frontend_port_name             = "${local.frontend_port_name_API}"
    protocol                       = "Http"
  }

#   http_listener {
#     name                           = "${local.listener_name_Web}"
#     frontend_ip_configuration_name = "${local.frontend_ip_configuration_name_Web}"
#     frontend_port_name             = "${local.frontend_port_name_Web}"
#     protocol                       = "Http"
#   }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name_API}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name_API}"
    backend_address_pool_name  = "${local.backend_address_pool_name_API}"
    backend_http_settings_name = "${local.http_setting_name_API}"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name_Web}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name_Web}"
    backend_address_pool_name  = "${local.backend_address_pool_name_Web}"
    backend_http_settings_name = "${local.http_setting_name_Web}"
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