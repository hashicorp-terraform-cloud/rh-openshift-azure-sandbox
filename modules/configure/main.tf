resource "random_pet" "cluster_name" {
  length = 2
}

locals {
  pull_secret = var.pull_secret_path != null && var.pull_secret_path != "" ? file(var.pull_secret_path) : null
}


resource "local_file" "install-config" {
  content = templatefile("${path.module}/templates/install-config.yaml.tpl", {
    var_cluster_name   = random_pet.cluster_name.id,
    var_base_domain    = var.base_domain,
    var_region         = var.region,
    var_resource_group = var.resource_group,
    var_pull_secret    = trimspace(base64decode(local.pull_secret)),
    var_ssh_key        = trimspace(file(var.public_key_path))
  })
  filename = "${path.module}/../../generated/install-config.yaml"
}

resource "local_file" "osServicePrincipal" {
  content = templatefile("${path.module}/templates/osServicePrincipal.json.tpl", {
    var_arm_subscription_id = var.arm_subscription_id,
    var_arm_tenant_id       = var.arm_tenant_id,
    var_arm_client_id       = var.arm_client_id,
    var_arm_client_secret   = var.arm_client_secret,
  })
  filename = "${path.module}/../../generated/osServicePrincipal.json"
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
