# rh-openshift-azure-sandbox

Set up the prerequisites to allow Red Hat OpenShift Container Platform to be deployed into a Doormat-vendez Azure account.

## Requirements

* `base_domain` - the top-level domain name for the cluster
* `pull_secret` - the Red Hat pull secret - available from `cloud.redhat.com`
* `public_key_path` - the path to the public key, required for node access

## Outputs

* `generated/install-config.yaml` - the install configuration required by the installer.
* `generated/osServicePrincipal.json` - the details of the OCP-specific service principal required by the installer.
* `dns` - the DNS nameservers that allow public resolution of cluster endpoints. Should be added to your domain configuration before commencing install.