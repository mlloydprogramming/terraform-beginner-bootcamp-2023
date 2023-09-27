# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`:

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

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes