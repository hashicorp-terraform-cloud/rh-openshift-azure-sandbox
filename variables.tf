variable "subscription_id" {
  description = "The subscription ID to target for the terraform run"
  type        = string
}

variable "region" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "uksouth"
}

variable "resource_group" {
  description = "The name of the resource group to create to hold the prereqs"
  type        = string
  default     = "cluster"
}

variable "base_domain" {
  description = "The base domain for the cluster"
  type        = string
}

variable "pull_secret_path" {
  description = "The base64-encoded pull secret for the cluster"
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "The path to the public key to use for the cluster (self managed or hosted)"
  type        = string
}

variable "deployment_type" {
  description = "Type of deployment: 'self_managed' or 'hosted'"
  type        = string
}
