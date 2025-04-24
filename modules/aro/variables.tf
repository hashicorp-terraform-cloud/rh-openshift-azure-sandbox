variable "aro_spn_client_id" {
  description = "The id of the service principal used to create the ARO cluster"
  type        = string
}

variable "region" {
  description = "The Azure region to deploy the ARO cluster"
  type        = string
}

variable "domain_name" {
  description = "The top level domain name for the ARO cluster"
  type        = string
}

variable "openshift_version" {
  description = "The version of ARO to deploy"
  type        = string
  default     = "4.16.30"
}

variable "pull_secret_path" {
  description = "The path to the ARO pull secret"
  type        = string
  default     = ""
}

variable "acme_client_id" {
  description = "value of the acme client id"
  type        = string
}

variable "acme_client_secret" {
  description = "value of the acme client secret"
  type        = string
}

variable "arm_subscription_id" {
  description = "value of the subscription id for the acme client"
  type        = string
}

variable "arm_tenant_id" {
  description = "value of the tenant id for the acme client"
  type        = string
}
