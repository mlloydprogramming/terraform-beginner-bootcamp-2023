# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root modules structure is as follows:

```
PROJECT_ROOT/
│
├── main.tf                - everything else.
├── variables.tf           - stores the structure of input variables
├── providers.tf           - defines required providers and their configuration
├── outputs.tf             - stores outputs
├── terraform.tfvars       - The data of variables we want to load into our Terraform project
└── README.md              - required for root modules
```

[Standard Module Structure] (https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform cloud we can set two kinds of variables:
- Environment Variables - Those that you would set in your bash terminal eg. AWS credentials
- Terraform Variables - Those that you would normally set in your tfvars file

We can set these values to sensative so they are not visibly shown in the UI.

### Loading Terraform Input Variables

We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_uuid="my-user_uuid"`

### var-file flag

Similar the the `-var` flag you can use the `-var-file` flag to pass in multiple values at once.
https://build5nines.com/use-terraform-input-variables-to-parameterize-infrastructure-deployments/

### terraform.tfvars

This is the default file to load in terraform variable in bulk.

### auto.tfvars

this file extension allows you to name your vars file whatever you want and by including `.auto.tfvars` terraform knows to automatically load these variables in. eg. `example.auto.tfvars`
https://spacelift.io/blog/terraform-tfvars

### order of terraform variables

The following is the order in which variables are loaded in.

1. Environment variables
2. `terraform.tfvars` file
3. `terraform.tfvars.json` file
4. `*.auto.tfvars` or `*.auto.tfvars.json`
5. `-var` `-var-file` command line flags. this also includes TF Cloud Workspace variables.

The means that variables lower on the list may overwrite values set above.

https://learning-ocean.com/tutorials/terraform/terraform-variable-precedence

## Dealing with Configuration Drift

### Fix Missing Resources with Terrform Import

You can fix missing resources using the `terraform import`

Documentation on importing from various providers can be found at [Terraform Registry](https://registry.terraform.io/)

Below is an example of using terraform import via the CLI

```sh
% terraform import aws_s3_bucket.bucket bucket-name
```

If you lose your statefile, you most likely have to tear down all your infrastructure manually. Not all resources provide an import function.

Imports can also be managed via the `imports.tf` file.

### Fix Manual Configuration

If drift occurs you can run terraform plan and it will attempt to put the infrastructure state back into its expected state.

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a modules directory but you can name it however you like.

### Passing Input Variables

We can pass input variables to our module

The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./module/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules sources

using the source we can import the module from various places eg.:
- locally
- github
- terraform Registry

```tf
module "terrahouse_aws" {
  source = "./module/terrahouse_aws"
}
```

[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)
