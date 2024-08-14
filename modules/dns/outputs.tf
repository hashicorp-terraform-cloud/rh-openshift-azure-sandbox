output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "base_domain_name" {
  value = azurerm_dns_zone.dns-zone.name
}

output "region" {
  value = azurerm_resource_group.resource_group.location
}

output "name_servers" {
  value = azurerm_dns_zone.dns-zone.name_servers
}

