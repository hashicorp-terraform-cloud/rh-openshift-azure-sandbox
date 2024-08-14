# rh-openshift-azure-sandbox

Set up the prerequisites to allow Red Hat OpenShift Container Platform to be deployed into a Doormat-vendez Azure account.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_configuration"></a> [configuration](#module\_configuration) | ./modules/configure | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ./modules/dns | n/a |
| <a name="module_service-principals"></a> [service-principals](#module\_service-principals) | ./modules/service-principals | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | The base domain for the cluster | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | The path to the public key to use for the cluster | `string` | n/a | yes |
| <a name="input_pull_secret"></a> [pull\_secret](#input\_pull\_secret) | The base64-encoded pull secret for the cluster | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group to create to hold the prereqs | `string` | `"cluster"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acme-source"></a> [acme-source](#output\_acme-source) | The path to the generated acme.source file. Source this file to set the ACME service principal credentials. |
| <a name="output_dns"></a> [dns](#output\_dns) | The DNS servers for the Azure DNS zone. |
| <a name="output_install-config-yaml"></a> [install-config-yaml](#output\_install-config-yaml) | The path to the generated install-config.yaml file. Used by the installer at deploy time. |
| <a name="output_osServicePrincipal-json"></a> [osServicePrincipal-json](#output\_osServicePrincipal-json) | The path to the generated osServicePrincipal.json file. Place this in your ~/.azure directory. |
<!-- END_TF_DOCS -->