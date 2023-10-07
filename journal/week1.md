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

### considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about terraform.

It may likely produce older examples that have since been updated.



[aws_s3_object documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)

[aws_s3_bucket_website_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)

## Working with Files in Terraform

### File Exist Function

This is a file exist function built in by terraform to confirm if a file exists for validation.

```tf
validation {
  condition     = fileexists(var.error_html_filepath)
  error_message = "The specified file does not exist."
}
```

[fileexists function](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### FileMD5 Function

built in terraform function that creates an MD5 Hash for changes.

```tf
resource "aws_s3_object" "error_html" {
  etag = filemd5(var.index_html_filepath)
}
```

[md5 function](https://developer.hashicorp.com/terraform/language/functions/md5)

### JSONEncode Function

used to create json policy inline for the bucket policy.

```tf
resource "aws_s3_bucket_policy" "bucket_policy" {
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
        "Sid"=  "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" = "Allow",
        "Principal" = {
            "Service" = "cloudfront.amazonaws.com"
        },
        "Action" = "s3:GetObject",
        "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
        "Condition" = {
            "StringEquals" = {
                "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                }
            }
        }
    })
}
```

[jsonencode function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

### Path Variables

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module

example `source = "${path.root}/public/index.html"`

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references)

### Terraform Local Values

Locals allow us to define local variables.

Can be useful when we need to transform data into another format.

```tf
locals {
    s3_origin_id = "MyS3Origin"
}
```

[Terraform Locals](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Sources

This allows us to source data from cloud resources.

Useful when wanting to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

### Changing the Lifecycle of Resources



```tf
resource "aws_instance" "example" {
  # ...

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }
}
```

[Meta Arguments: Lifecycles](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Provisioners

Provisioners allow you to execute commands on compute instances eg. `aws cli`

They are not recommended by Hashicorp because configuration tools such as ansible are a better fit.

[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This executes locally on the machine running the terraform commands (eg. plan/apply)

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```
[local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This executes remotely on the machine you target and you will be required to provide credentials such as ssh keys.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
[remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)