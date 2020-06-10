resource "random_string" "random-name" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "azurerm_sql_server" "testmssql" {
  name                         = "sqlserver-${random_string.random-name.result}"
  resource_group_name          = azurerm_resource_group.testmssql.name
  location                     = azurerm_resource_group.testmssql.location
  version                      = "12.0"
  administrator_login          = "mssqladmin"
  administrator_login_password = "P@s$w0rd!"
}

#resource "azurerm_sql_server" "testmssql-secondary" {
#  name                         = "sqlserver-s${random_string.random-name.result}"
#  resource_group_name          = azurerm_resource_group.testmssql.name
#  location                     = var.failover_location
#  version                      = "12.0"
#  administrator_login          = "mssqladmin"
#  administrator_login_password = "P@s$w0rd!"
#}

#resource "azurerm_sql_failover_group" "failover" {
#  name                = "sqlserver-failover-group-${random_string.random-name.result}"
#  resource_group_name = azurerm_resource_group.testmssql.name
#  server_name         = azurerm_sql_server.testmssql.name
#  databases           = [azurerm_sql_database.training.id]
#
#  partner_servers {
#    id = azurerm_sql_server.testmssql-secondary.id
#  }
#
#  read_write_endpoint_failover_policy {
#    mode          = "Automatic"
#    grace_minutes = 60
#  }
#}

resource "azurerm_sql_database" "training" {
  name                             = "testmssqldb"
  resource_group_name              = azurerm_resource_group.testmssql.name
  location                         = azurerm_resource_group.testmssql.location
  server_name                      = azurerm_sql_server.testmssql.name
  edition                          = "Standard"
  requested_service_objective_name = "S1"
}

resource "azurerm_sql_virtual_network_rule" "testmssql-database-subnet-vnet-rule" {
  name                = "mssql-vnet-rule"
  resource_group_name = azurerm_resource_group.testmssql.name
  server_name         = azurerm_sql_server.testmssql.name
  subnet_id           = azurerm_subnet.testmssql-database-1.id
}

resource "azurerm_sql_virtual_network_rule" "testmssql-subnet-vnet-rule" {
  name                = "mssql-testmssql-subnet-vnet-rule"
  resource_group_name = azurerm_resource_group.testmssql.name
  server_name         = azurerm_sql_server.testmssql.name
  subnet_id           = azurerm_subnet.testmssql-internal-1.id
}

resource "azurerm_sql_firewall_rule" "testmssql-allow-testmssql-instance" {
  name                = "mssql-testmssql-instance"
  resource_group_name = azurerm_resource_group.testmssql.name
  server_name         = azurerm_sql_server.testmssql.name
  start_ip_address    = azurerm_network_interface.testmssql-instance.private_ip_address
  end_ip_address      = azurerm_network_interface.testmssql-instance.private_ip_address
}
