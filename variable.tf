variable "location" {
  default = "West Europe"
}


variable "tag" {
  default = "DEV"
}


variable "resouce_group_name" {
  default = "ACS_DEV_Payment_Cloud_Project_incons"
}



resource "random_integer" "ri" {
  min = 10000
  max = 99999
}