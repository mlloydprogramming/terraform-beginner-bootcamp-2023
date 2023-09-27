# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`:
- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation process have changed due to gpg keyring changes. Needed to refer to latest cli install instructions via terraform instructions and changing the script for intsall.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux distribution

This project is build against ubuntu 22.04
please consider your linux distro and see if this requires any changes to your distribution needs.

Example of checking OS version
```
$ cat /etc/os-release 

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```
### Refactoring into Bash Scripts

While fixing the terraform CLI gpg deprecation issues we noticed the bash script steps was more code than previously required. We decided to create a bash script to install the terraform CLI.

- This will keep the Gitpod task file tidy [.gitpod.yml](./.gitpod.yml).
- This will allow us an easier to debug and execute manual terraform install.
- This will allow better portability for other shells.

This script is located here: [./bin/install_terrform_cli](./bin/install_terraform_cli)

#### Shebang

A Shebang tells the bash script what program that will interpret the script. eg. `#!/bin/bash`

For portability with other OS distros `#!/usr/bin/env bash` which searches the users env variables.

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are suing a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions.

In order to make our bash scripts executable we must change the linux permissions to be executable as a user.

```sh
chmod 744 ./bin/install_terraform_cli
```

### Github Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

### Working Env Vars

#### env command

We can list out all Environment Variables (Env Vars) using the `eng` command

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

Wihtin a bash script we can set an env var without writing export eg.

```sh
#!/usr/bin/env bash
HELLO='world'

echo $HELLO
```

#### Printing Vars

We can print an envb var using echo eg. `echo $HELLO`

#### Scoping of Env Vars
When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to use Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars into git pod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals open in those workspaces.

You can also set env vars in the `.gitpod.yml` but this can only store non sensitive variables.

### AWS CLI Installation

AWS CLI is installed for this project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

can check if our AWS credentials are configured correctly using the following command:
```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like 

```json
{
    "UserId": "AIDAWF5PI4LOVWEXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credentials from and IAM user in order to use the AWS CLI.


## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** are an interface for connecting to APIS that will allow you to create resources in terraform.
- **Modules** are a way to make terraform code modular, portable, and shareable.

### Terraform Console

We can list all of the Terraform command by typing `terrform`.

#### Terraform Init

When starting a new terraform project we will run `terraform init` to download the binaries for the terraform providers we will use during this project.

#### Terraform Plan

This creates a change plan of the state of the infrastructure and what will be changed eg. `terraform plan`. This can be output to be passed to an apply but generally you can ignore outputting.

#### Terraform Apply

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt yes or no. eg. `terraform apply`

This can be run without prompting by running `terraform apply --auto-approve`

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File should be committed to your Version Control System (VCS) eg. Github

### Terraform State File

`.terraform.tfstate` can contain information about the current state of your infrastructure.

This file **should not be commited** as it may contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file.

### Terraform Directory

`.terraform` Directory contains binaries of terraform providers.

### Terraform Destroy

`terraform destroy`
This will destroy the terraformed items.

As with other commands you can use `--auto-approve` tag

### Terraform State

If you get in a wierd state you can do a `terraform state pull` to pull the cloud state file. I performed this because I got in a wierd state on my pod and spun up a new pod to set everything up. Might have been unnecessary but it is the steps I took.

## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it will launch a view to generate a token, however, it does not work as expected in gitpod vscode in the browser.

Work around is to generate a token in Terraform Cloud

[terraform token generation](https://app.terraform.io/app/settings/tokens?source=terraform-login)

Then create the file manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```