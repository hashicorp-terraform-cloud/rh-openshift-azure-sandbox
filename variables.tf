variable "resource_group" {
  description = "The name of the resource group to create to hold the prereqs"
  type        = string
  default     = "cluster"
}

variable "base_domain" {
  description = "The base domain for the cluster"
  type        = string
}

variable "pull_secret" {
  description = "The base64-encoded pull secret for the cluster"
  type        = string
}

variable "public_key_path" {
  description = "The path to the public key to use for the cluster"
  type        = string
}
