resource "azurerm_resource_group" "APIManagment" {

    name     = "${var.resouce_group_name}"
    location = "${var.location}"

    tags = {
        environment = "${var.tag}"
    }
  
}



resource "azurerm_api_management" "test" {
  name                = "paymentfacadeTest"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
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