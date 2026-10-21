# Common infrastructure

Terraform for the Common landing zones in US Gov Virginia (`usva`) and US Gov Arizona (`usaz`).

`landingzone/` deploys the network resource group, spoke VNet, subnets, firewall routes, hub connection, flow logs, and private storage and Key Vault. `app/` deploys the application resource group, private Key Vault, encrypted Log Analytics cluster and workspace, and backup vault, and sends the landing-zone and app diagnostics to that Log Analytics workspace. In DEV, the Virginia run also creates the `ws-common-dev` workspace in `apim-app-o-usva-dev`.

## Layout

```text
azure-pipelines.yml
landingzone/
app/
regions/
  usva/<environment>-terraform.tfvars
  usaz/<environment>-terraform.tfvars
```

## Run

Queue the `common-iac` pipeline with the environment and region. On the first deployment, run `landingzone` before `app`, because `app` reads the landing-zone network.

