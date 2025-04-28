# rh-openshift-azure-sandbox

This module allows for the deployment of Red Hat OpenShift into Azure either as a `self_managed` (IPI/UPI) deployment, or as a `hosted`(Azure Red Hat OpenShift) deployment.

## Common
This module creates:

 * Base Azure resources (resource groups)
 * DNS Zone(s)
 * SPNs for both OpenShift and ACME configuration


## Self Managed
This module creates the conifguration files required to deploy Red Hat OpenShift Container Platform into the Azure subscription

## Hosted
This module deployes Azure Red Hat OpenShift into the Azure subscription, and configures it with LetsEncrypt certificates.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aro"></a> [aro](#module\_aro) | ./modules/aro | n/a |
| <a name="module_configuration"></a> [configuration](#module\_configuration) | ./modules/configure | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ./modules/dns | n/a |
| <a name="module_service-principals"></a> [service-principals](#module\_service-principals) | ./modules/service-principals | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | The base domain for the cluster | `string` | n/a | yes |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | Type of deployment: 'self\_managed' or 'hosted' | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | The path to the public key to use for the cluster (self managed or hosted) | `string` | n/a | yes |
| <a name="input_pull_secret_path"></a> [pull\_secret\_path](#input\_pull\_secret\_path) | The base64-encoded pull secret for the cluster | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The Azure region to deploy resources | `string` | `"uksouth"` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group to create to hold the prereqs | `string` | `"cluster"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID to target for the terraform run | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acme_source"></a> [acme\_source](#output\_acme\_source) | The path to the generated acme.source file. Source this file to set the ACME service principal credentials. |
| <a name="output_admin_credential"></a> [admin\_credential](#output\_admin\_credential) | The admin credential for the ARO cluster. |
| <a name="output_api_server_url"></a> [api\_server\_url](#output\_api\_server\_url) | The fully qualified domain name of the api endpoint |
| <a name="output_cluster_console_url"></a> [cluster\_console\_url](#output\_cluster\_console\_url) | The URL of the ARO cluster console. |
| <a name="output_dns"></a> [dns](#output\_dns) | The DNS servers for the Azure DNS zone. |
| <a name="output_ingress_domain"></a> [ingress\_domain](#output\_ingress\_domain) | The fully qualified domain name of the ingress domain |
| <a name="output_installConfig_yaml"></a> [installConfig\_yaml](#output\_installConfig\_yaml) | The path to the generated install-config.yaml file. Used by the installer at deploy time. |
| <a name="output_osServicePrincipal_json"></a> [osServicePrincipal\_json](#output\_osServicePrincipal\_json) | The path to the generated osServicePrincipal.json file. Place this in your ~/.azure directory. |
<!-- END_TF_DOCS -->