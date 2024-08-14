output "install-config-yaml" {
  value       = module.configuration.install-config-yaml-path
  description = "The path to the generated install-config.yaml file. Used by the installer at deploy time."
}

output "osServicePrincipal-json" {
  value       = module.configuration.osServicePrincipal-json-path
  description = "The path to the generated osServicePrincipal.json file. Place this in your ~/.azure directory."
}
output "dns" {
  value       = module.dns.name_servers
  description = "The DNS servers for the Azure DNS zone."
}
