resource "azurerm_resource_group" "APIManagment" {

    name     = "${var.resouce_group_name}"
    location = "${var.location}"

    tags = {
        environment = "${var.tag}"
    }
  
}

# resource "azurerm_api_management" "paymentfacadeTest" {
#   name                = "paymentfacadeTest"
#   location            = "${var.location}"
#   resource_group_name = "${azurerm_resource_group.APIManagment.name}"
#   publisher_name      = "OSN"
#   publisher_email     = "noman.sadiq@osn.com"

#   sku_name = "Developer_1"

  
# }




# ## this is import the API from Json 

# resource "azurerm_api_management_api" "example" {
#   name                = "Payment-Facade-API"
#   resource_group_name = "${azurerm_resource_group.APIManagment.name}"
#   api_management_name = "${azurerm_api_management.paymentfacadeTest.name}"
#   revision            = "1"
#   display_name        = "Payment Facade API"
#   path                = "example"
#   protocols           = ["https"]

#   import {
#     content_format = "swagger-link-json"
#     content_value  = "https://paypaltestapi.osn.com/swagger/v1/swagger.json"
#   }
# }