output "console_url" {
  description = "The cluster console URL"
  value       = azurerm_redhat_openshift_cluster.aro.console_url
}

output "api_server_url" {
  description = "The fully qualified domain name of the api endpoint"
  value       = azurerm_dns_a_record.api.fqdn
}

output "ingress_domain" {
  description = "The fully qualified domain of the ingress endpoint"
  value       = azurerm_dns_a_record.ingress.fqdn
}

output "admin_credential" {
  description = "The admin credential for the ARO cluster"
  value       = data.azapi_resource_action.admin_credential.output

}

output "certificate_pem" {
  value     = acme_certificate.certificate.certificate_pem
  sensitive = true
}

output "issuer_pem" {
  value     = acme_certificate.certificate.issuer_pem
  sensitive = true
}

output "fullchain_pem" {
  value     = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
  sensitive = true
}
