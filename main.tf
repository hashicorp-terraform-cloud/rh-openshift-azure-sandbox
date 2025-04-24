terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    azapi = {
      source = "Azure/azapi"
    }
    acme = {
      source = "vancluever/acme"
    }
    local = {
      source = "hashicorp/local"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "core"
  subscription_id                 = var.subscription_id
  resource_providers_to_register  = ["Microsoft.RedHatOpenShift"]
}

provider "azapi" {}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "azuread" {}

provider "local" {}

provider "random" {}

provider "null" {}

module "dns" {
  source         = "./modules/dns"
  resource_group = var.resource_group
  region         = var.region
  base_domain    = var.base_domain
}

module "service-principals" {
  source              = "./modules/service-principals"
  resource_group_name = module.dns.resource_group_name
  base_domain_name    = module.dns.base_domain_name
  depends_on          = [module.dns]
}

module "configuration" {
  source = "./modules/configure"
  count  = var.deployment_type == "self_managed" ? 1 : 0

  resource_group      = module.dns.resource_group_name
  base_domain         = module.dns.base_domain_name
  region              = module.dns.region
  arm_client_id       = module.service-principals.arm_client_id
  arm_client_secret   = module.service-principals.arm_client_secret
  arm_subscription_id = module.service-principals.arm_subscription_id
  arm_tenant_id       = module.service-principals.arm_tenant_id
  acme_client_id      = module.service-principals.acme_client_id
  acme_client_secret  = module.service-principals.acme_client_secret
  public_key_path     = var.public_key_path
  pull_secret_path    = var.pull_secret_path
  depends_on          = [module.dns, module.service-principals]

}

module "aro" {
  source = "./modules/aro"
  count  = var.deployment_type == "hosted" ? 1 : 0

  region              = var.region
  pull_secret_path    = var.pull_secret_path
  aro_spn_client_id   = module.service-principals.arm_client_id
  domain_name         = module.dns.base_domain_name
  arm_subscription_id = module.service-principals.arm_subscription_id
  arm_tenant_id       = module.service-principals.arm_tenant_id
  acme_client_id      = module.service-principals.acme_client_id
  acme_client_secret  = module.service-principals.acme_client_secret
  depends_on          = [module.dns, module.service-principals]
}
