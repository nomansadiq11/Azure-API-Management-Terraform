
resource "azurerm_virtual_network" "PaymentSecVNet" {
  name                = "acsprodpaymentsec1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.PaymentFacade.name}"
  address_space       = ["10.245.0.0/16"]
  

  tags = {

    Owner = "${var.Owner}"
    CreatedDate = "${var.CreatedDate}"
    Project = "${var.Project}"
    Department = "${var.Department}"
    CreatedBy = "${var.CreatedBy}"
    
  }
  
}


resource "azurerm_subnet" "pfvmsubnet" {

  name                 = "acsprod_vm_subnet"
  resource_group_name  = "${azurerm_resource_group.PaymentFacade.name}"
  address_prefix       = "10.245.1.0/24"
  virtual_network_name = "${azurerm_virtual_network.PaymentSecVNet.name}"
 
  
}

resource "azurerm_subnet" "pfAGsubnet" {

  name                 = "acsprod_AG_subnet"
  resource_group_name  = "${azurerm_resource_group.PaymentFacade.name}"
  address_prefix       = "10.245.2.0/24"
  virtual_network_name = "${azurerm_virtual_network.PaymentSecVNet.name}"
 
  
}

# resource "azurerm_virtual_network" "PaymentIntegVNet" {
#   name                = "acsprodpaymentinteg"
#   location            = "${var.location}"
#   resource_group_name = "${azurerm_resource_group.PaymentFacade.name}"
#   address_space       = ["10.245.0.0/16"]
#   dns_servers         = ["10.245.0.4", "10.245.0.5"]


#   subnet {
#     name           = "subnet1"
#     address_prefix = "10.245.1.0/24"
#   }

  

#    tags = {

#     Owner = "${var.Owner}"
#     CreatedDate = "${var.CreatedDate}"
#     Project = "${var.Project}"
#     Department = "${var.Department}"
#     CreatedBy = "${var.CreatedBy}"
    
#   }


# }
