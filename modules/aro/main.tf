terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
    }
    acme = {
      source = "vancluever/acme"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}

locals {
  pull_secret = var.pull_secret_path != null && var.pull_secret_path != "" ? file(var.pull_secret_path) : null
}

resource "random_pet" "resource_group_name" {
  length = 2
}

data "azurerm_client_config" "aro" {}

data "azuread_client_config" "aro" {}

data "azurerm_dns_zone" "aro" {
  name = var.domain_name
}

data "azuread_service_principal" "aro" {
  client_id = var.aro_spn_client_id
}

resource "azuread_service_principal_password" "aro" {
  service_principal_id = data.azuread_service_principal.aro.id
}

resource "azurerm_resource_group" "aro" {
  name     = random_pet.resource_group_name.id
  location = var.region
}

resource "azurerm_dns_zone" "aro" {
  name                = "${random_pet.resource_group_name.id}.${var.domain_name}"
  resource_group_name = azurerm_resource_group.aro.name
}

resource "azurerm_dns_ns_record" "aro" {

  name                = random_pet.resource_group_name.id
  zone_name           = data.azurerm_dns_zone.aro.name
  resource_group_name = data.azurerm_dns_zone.aro.resource_group_name
  ttl                 = 300
  records             = azurerm_dns_zone.aro.name_servers
  tags                = {}
}


data "azuread_service_principal" "redhatopenshift" {
  // This is the Azure Red Hat OpenShift RP service principal id, do NOT delete it
  client_id = "f1dd0a37-89c6-4e07-bcd1-ffd3d43d8875"
}

resource "azurerm_role_assignment" "aro_role_network1" {
  scope                = azurerm_virtual_network.aro.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.aro.object_id
}

resource "azurerm_role_assignment" "aro_role_network2" {
  scope                = azurerm_virtual_network.aro.id
  role_definition_name = "Network Contributor"
  principal_id         = data.azuread_service_principal.redhatopenshift.object_id
}

resource "azurerm_virtual_network" "aro" {
  name                = "aro-vnet"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.aro.location
  resource_group_name = azurerm_resource_group.aro.name
}

resource "azurerm_subnet" "aro_main_subnet" {
  name                                          = "main-subnet"
  resource_group_name                           = azurerm_resource_group.aro.name
  virtual_network_name                          = azurerm_virtual_network.aro.name
  address_prefixes                              = ["10.0.0.0/23"]
  service_endpoints                             = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
  private_link_service_network_policies_enabled = false
}

resource "azurerm_subnet" "aro_worker_subnet" {
  name                 = "worker-subnet"
  resource_group_name  = azurerm_resource_group.aro.name
  virtual_network_name = azurerm_virtual_network.aro.name
  address_prefixes     = ["10.0.2.0/23"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

resource "azurerm_redhat_openshift_cluster" "aro" {
  name                = random_pet.resource_group_name.id
  location            = azurerm_resource_group.aro.location
  resource_group_name = azurerm_resource_group.aro.name

  cluster_profile {
    domain      = azurerm_dns_zone.aro.name
    version     = var.openshift_version
    pull_secret = local.pull_secret
  }

  network_profile {
    pod_cidr     = "10.128.0.0/14"
    service_cidr = "172.30.0.0/16"
  }

  main_profile {
    vm_size   = "Standard_D8as_v5"
    subnet_id = azurerm_subnet.aro_main_subnet.id
  }

  api_server_profile {
    visibility = "Public"
  }

  ingress_profile {
    visibility = "Public"
  }

  worker_profile {
    vm_size      = "Standard_D4as_v5"
    disk_size_gb = 128
    node_count   = 3
    subnet_id    = azurerm_subnet.aro_worker_subnet.id
  }

  service_principal {
    client_id     = data.azuread_service_principal.aro.client_id
    client_secret = azuread_service_principal_password.aro.value
  }

  depends_on = [
    azurerm_role_assignment.aro_role_network1,
    azurerm_role_assignment.aro_role_network2,
  ]
}

resource "azurerm_dns_a_record" "api" {
  name                = "api"
  zone_name           = azurerm_dns_zone.aro.name
  resource_group_name = azurerm_dns_zone.aro.resource_group_name
  ttl                 = 300
  records             = [azurerm_redhat_openshift_cluster.aro.api_server_profile[0].ip_address]
}

resource "azurerm_dns_a_record" "ingress" {
  name                = "*.apps"
  zone_name           = azurerm_dns_zone.aro.name
  resource_group_name = azurerm_dns_zone.aro.resource_group_name
  ttl                 = 300
  records             = [azurerm_redhat_openshift_cluster.aro.ingress_profile[0].ip_address]
}

#az aro get-admin-kubeconfig --name MyCluster --resource-group MyResourceGroup --debug
#the date might change if there is an update in the api
data "azapi_resource_action" "kubeconfig" {
  type                   = "Microsoft.RedHatOpenShift/openShiftClusters@2022-09-04"
  resource_id            = azurerm_redhat_openshift_cluster.aro.id
  action                 = "listAdminCredentials"
  response_export_values = ["*"]

  depends_on = [
    azurerm_redhat_openshift_cluster.aro
  ]
}

#az aro list-credentials  --name cluster  --resource-group aro-rg --debug
#the date might change if there is an update in the api
data "azapi_resource_action" "admin_credential" {
  type                   = "Microsoft.RedHatOpenShift/openShiftClusters@2022-09-04"
  resource_id            = azurerm_redhat_openshift_cluster.aro.id
  action                 = "listCredentials"
  response_export_values = ["kubeadminPassword"]

  depends_on = [
    azurerm_redhat_openshift_cluster.aro
  ]
}

resource "local_file" "kubeconfig" {
  content = templatefile("${path.module}/templates/kubeconfig.tpl", {
    var_kubeconfig = base64decode(data.azapi_resource_action.kubeconfig.output.kubeconfig)
  })
  filename = "${path.module}/../../generated/kubeconfig"
}

resource "local_file" "kubeadmin" {
  content = templatefile("${path.module}/templates/kubeadmin-credential.tpl", {
    var_kubeadmin_credential = data.azapi_resource_action.admin_credential.output.kubeadminPassword
  })
  filename = "${path.module}/../../generated/kubeadmin-credential"
}

resource "local_file" "acme-service-principal" {
  content = templatefile("${path.module}/templates/acme.source.tpl", {
    var_acme_subscription_id = var.arm_subscription_id,
    var_acme_tenant_id       = var.arm_tenant_id,
    var_acme_client_id       = var.acme_client_id,
    var_acme_client_secret   = var.acme_client_secret,
  })
  filename = "${path.module}/../../generated/acme.source"
}
