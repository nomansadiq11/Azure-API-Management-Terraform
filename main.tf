resource "azurerm_resource_group" "APIManagment" {

    name     = "${var.resouce_group_name}"
    location = "${var.location}"

    tags = {
        environment = "${var.tag}"
    }
  
}
