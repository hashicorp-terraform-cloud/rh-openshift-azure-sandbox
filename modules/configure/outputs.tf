output "installConfig_yaml_path" {
  value       = local_file.install-config.filename
  description = "The path to the generated install-config.yaml file. Used by the installer at deploy time."
}

output "osServicePrincipal_json_path" {
  value       = local_file.osServicePrincipal.filename
  description = "The path to the generated osServicePrincipal.json file. Place this in your ~/.azure directory."
}

output "acme_source_path" {
  value       = local_file.acme-service-principal.filename
  description = "The path to the generated acme.source file. Source this file to set the ACME service principal credentials."
}
