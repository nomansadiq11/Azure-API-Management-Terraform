resource "azurerm_resource_group" "APIManagment" {

    name     = "${var.resouce_group_name}"
    location = "${var.location}"

    tags = {
        environment = "${var.tag}"
    }
  
}



resource "azurerm_api_management" "test" {
  name                = "paymentfacadeTest"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.APIManagment.name}"
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"

  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />
      <on-error />
    </policies>
XML
  }
}



resource "azurerm_api_management_api" "example" {
  name                = "test-api"
  resource_group_name = "${azurerm_resource_group.APIManagment.name}"
  api_management_name = "${azurerm_api_management.test.name}"
  revision            = "1"
  display_name        = "Example API"
  path                = "example"
  protocols           = ["https"]

  import {
    content_format = "swagger-link-json"
    content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  }
}