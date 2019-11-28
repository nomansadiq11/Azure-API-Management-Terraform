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


resource "azurerm_storage_account" "sapffunc" {
  name                     = "sapffunc"
  resource_group_name      = "${azurerm_resource_group.APIManagment.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.tag}"
  }

}

resource "azurerm_app_service_plan" "asppffunc" {
  name                = "asppffunc"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.APIManagment.name}"

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = {
    environment = "${var.tag}"
  }
}

resource "azurerm_function_app" "AF_OsnCloudPaymentsProxy" {
  name                      = "afpffunc"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.APIManagment.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.asppffunc.id}"
  storage_connection_string = "${azurerm_storage_account.sapffunc.primary_connection_string}"

  tags = {
    environment = "${var.tag}"
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