variable "location" {
  type    = string
  default = "westeurope"
}

variable "failover_location" {
  type    = string
  default = "uksouth"
}

variable "prefix" {
  type    = string
  default = "testmssql"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "private-cidr" {
  type    = string
  #default = "10.0.0.0/24"
  default = "192.168.1.0/24"
}
