output "install-config-yaml-path" {
  value       = local_file.install-config.filename
  description = "The path to the generated install-config.yaml file. Used by the installer at deploy time."
}

output "osServicePrincipal-json-path" {
  value       = local_file.osServicePrincipal.filename
  description = "The path to the generated osServicePrincipal.json file. Place this in your ~/.azure directory."
}
