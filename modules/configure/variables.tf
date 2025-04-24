variable "arm_client_id" {
  description = "The Azure Service Principal client ID for Red Hat OpenShift Container Platform"
  type        = string
}

variable "arm_client_secret" {
  description = "The Azure Service Principal client secret for Red Hat OpenShift Container Platform"
  type        = string
}

variable "acme_client_id" {
  description = "The Azure Service Principal client ID for the ACME process"
  type        = string
}

variable "acme_client_secret" {
  description = "The Azure Service Principal client secret for the ACME process"
  type        = string
}

variable "arm_tenant_id" {
  description = "The Azure Service Principal tenant ID"
  type        = string
}

variable "arm_subscription_id" {
  description = "The Azure subscription ID"
  type        = string
}

variable "base_domain" {
  description = "The base domain for the cluster"
  type        = string
}

variable "pull_secret_path" {
  description = "The path to the pull secret for the self-managed cluster"
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group to create"
  type        = string
}

variable "region" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key to use for the cluster"
  type        = string
}
