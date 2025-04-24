
data "azuread_service_principal" "acme" {
  client_id = var.acme_client_id
}

resource "azurerm_role_assignment" "acme" {
  scope                = azurerm_dns_zone.aro.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = data.azuread_service_principal.acme.object_id
}

resource "acme_registration" "reg" {
  email_address = "cluster@${random_pet.resource_group_name.id}.${var.domain_name}"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "api.${random_pet.resource_group_name.id}.${var.domain_name}"
  subject_alternative_names = ["*.apps.${random_pet.resource_group_name.id}.${var.domain_name}"]

  dns_challenge {
    provider = "azuredns"

    config = {
      AZURE_ENVIRONMENT     = "public"
      AZURE_CLIENT_ID       = var.acme_client_id
      AZURE_CLIENT_SECRET   = var.acme_client_secret
      AZURE_TENANT_ID       = var.arm_tenant_id
      AZURE_SUBSCRIPTION_ID = var.arm_subscription_id
      AZURE_RESOURCE_GROUP  = "${random_pet.resource_group_name.id}"
      AZURE_ZONE_NAME       = "${random_pet.resource_group_name.id}.${var.domain_name}"
    }
  }
  depends_on = [azurerm_redhat_openshift_cluster.aro]
}

# resource "local_file" "fullchain" {
#   content = templatefile("${path.module}/templates/fullchain.pem.tpl", {
#     fullchain_pem = nonsensitive("${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}")
#   })
#   filename   = "${path.module}/../../generated/fullchain.pem"
#   depends_on = [acme_certificate.certificate]
# }

# resource "local_file" "cert" {
#   content = templatefile("${path.module}/templates/cert.pem.tpl", {
#     cert_pem = nonsensitive("${acme_certificate.certificate.certificate_pem}")
#   })
#   filename   = "${path.module}/../../generated/cert.pem"
#   depends_on = [acme_certificate.certificate]
# }

# resource "local_file" "key" {
#   content = templatefile("${path.module}/templates/key.pem.tpl", {
#     key_pem = nonsensitive("${acme_certificate.certificate.private_key_pem}")
#   })
#   filename   = "${path.module}/../../generated/key.pem"
#   depends_on = [acme_certificate.certificate]
# }

resource "local_file" "ingress_tls_yaml" {
  filename = "${path.module}/../../generated/ingress-tls-secret.yaml"

  content = templatefile("${path.module}/templates/ingress-tls-secret.yaml.tpl", {
    name      = "ingress-certs"
    namespace = "openshift-ingress"
    crt       = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    key       = acme_certificate.certificate.private_key_pem
  })

  depends_on = [
    acme_certificate.certificate,
  ]
}

resource "local_file" "api_tls_yaml" {
  filename = "${path.module}/../../generated/api-tls-secret.yaml"

  content = templatefile("${path.module}/templates/api-tls-secret.yaml.tpl", {
    name      = "api-certs"
    namespace = "openshift-config"
    crt       = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    key       = acme_certificate.certificate.private_key_pem
  })

  depends_on = [
    acme_certificate.certificate,
  ]
}

resource "null_resource" "deploy_tls_manifests" {
  depends_on = [
    local_file.kubeconfig,
    local_file.ingress_tls_yaml,
    local_file.api_tls_yaml,
  ]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOF
      export KUBECONFIG="${path.module}/../../generated/kubeconfig"

      # Apply the generated TLS secret manifests
      oc --insecure-skip-tls-verify apply -f "${path.module}/../../generated/ingress-tls-secret.yaml"
      oc --insecure-skip-tls-verify apply -f "${path.module}/../../generated/api-tls-secret.yaml"

      # Patch the default IngressController to use ingress-certs
      oc --insecure-skip-tls-verify patch ingresscontroller default \
        -n openshift-ingress-operator \
        --type=merge \
        --patch='{"spec":{"defaultCertificate":{"name":"ingress-certs"}}}'

      # Patch the APIServer to reference api-certs for your API hostname
      oc --insecure-skip-tls-verify patch apiserver cluster \
        --type=merge \
        --patch='{"spec":{"servingCerts":{"namedCertificates":[{"names":["${acme_certificate.certificate.common_name}"],"servingCertificate":{"name":"api-certs"}}]}}}'
    EOF
  }
}

