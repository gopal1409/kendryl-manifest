##create the subnet
resource "azurerm_subnet" "websubnet" {
  depends_on           = [azurerm_resource_group.myrg1]
  name                 = "${local.resurce_name_prefix}-${var.web_subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.web_subnet_address
}

resource "azurerm_network_security_group" "web_subnet_nsg" {
  name                = "${azurerm_subnet.websubnet.name}-sg"
  location            = azurerm_resource_group.myrg1.location
  resource_group_name = azurerm_resource_group.myrg1.name
}

resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
  depends_on = [azurerm_network_security_rule.web_subnet_nsg_rule]
  #untile the nsg will cresate it will not assicate the rule
  subnet_id                 = azurerm_subnet.websubnet.id
  network_security_group_id = azurerm_network_security_group.web_subnet_nsg.id
}
locals {
  web_inbound_port = {
    ###in local the separtion of key and value is being done using == sign
    ###if your key is numerics use colon. 
    "110" : "80",
    "120" : "443",
    "130" : "22"
  }
}
##nsg inbound rule 
resource "azurerm_network_security_rule" "web_subnet_nsg_rule" {
  for_each                    = local.web_inbound_port
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myrg1.name
  network_security_group_name = azurerm_network_security_group.web_subnet_nsg.name
}

