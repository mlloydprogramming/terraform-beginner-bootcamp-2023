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

