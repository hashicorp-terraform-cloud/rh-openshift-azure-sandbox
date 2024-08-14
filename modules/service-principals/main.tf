resource "azuread_application" "openshift" {
  display_name = "${var.resource_group_name}-openshift-principal"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "openshift" {
  client_id = azuread_application.openshift.client_id
  owners    = [data.azuread_client_config.current.object_id]

  feature_tags {
    enterprise = true
  }
}

resource "azurerm_role_assignment" "contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.openshift.object_id
}

resource "azurerm_role_assignment" "uaa" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.openshift.object_id
}

resource "azuread_service_principal_password" "openshift" {
  service_principal_id = azuread_service_principal.openshift.id
}

resource "azuread_service_principal_password" "acme" {
  service_principal_id = azuread_service_principal.acme.id
}

resource "azuread_application" "acme" {
  display_name = "${var.resource_group_name}-AcmeDnsValidator"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "acme" {
  client_id = azuread_application.acme.client_id
  owners    = [data.azuread_client_config.current.object_id]

  feature_tags {
    enterprise = true
  }
}

data "azurerm_dns_zone" "hosted-zone" {
  name                = var.base_domain_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "acme" {
  scope                = data.azurerm_dns_zone.hosted-zone.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = azuread_service_principal.acme.object_id
}
