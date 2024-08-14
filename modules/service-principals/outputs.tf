output "arm_client_id" {
  value = azuread_application.openshift.client_id
}

output "arm_client_secret" {
  value = azuread_service_principal_password.openshift.value
}

output "arm_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "arm_tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}

