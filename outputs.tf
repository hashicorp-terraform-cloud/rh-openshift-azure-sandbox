output "installConfig_yaml" {
  value       = var.deployment_type == "self_managed" ? module.configuration[0].installConfig_yaml_path : null
  description = "The path to the generated install-config.yaml file. Used by the installer at deploy time."
}

output "osServicePrincipal_json" {
  value       = var.deployment_type == "self_managed" ? module.configuration[0].osServicePrincipal_json_path : null
  description = "The path to the generated osServicePrincipal.json file. Place this in your ~/.azure directory."
}

output "acme_source" {
  value       = var.deployment_type == "self_managed" ? module.configuration[0].acme_source_path : null
  description = "The path to the generated acme.source file. Source this file to set the ACME service principal credentials."
}

output "cluster_console_url" {
  value       = var.deployment_type == "hosted" ? module.aro[0].console_url : null
  description = "The URL of the ARO cluster console."
}

output "api_server_url" {
  value       = var.deployment_type == "hosted" ? module.aro[0].api_server_url : null
  description = "The fully qualified domain name of the api endpoint"
}

output "ingress_domain" {
  value       = var.deployment_type == "hosted" ? module.aro[0].ingress_domain : null
  description = "The fully qualified domain name of the ingress domain"
}

output "admin_credential" {
  value       = var.deployment_type == "hosted" ? module.aro[0].admin_credential : null
  description = "The admin credential for the ARO cluster."
}

output "dns" {
  value       = module.dns.name_servers
  description = "The DNS servers for the Azure DNS zone."
}
