terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azuread = {
      source = "hashicorp/azuread"
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
}

provider "azuread" {}

provider "local" {}

provider "random" {}

module "dns" {
  source         = "./modules/dns"
  resource_group = var.resource_group
  base_domain    = var.base_domain
}

module "service-principals" {
  source              = "./modules/service-principals"
  resource_group_name = module.dns.resource_group_name
  base_domain_name    = module.dns.base_domain_name
  depends_on          = [module.dns]
}

module "configuration" {
  source              = "./modules/configure"
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
  pull_secret         = var.pull_secret
  depends_on          = [module.dns, module.service-principals]
}
