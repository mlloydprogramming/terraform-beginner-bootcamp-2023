terraform {
#   cloud {
#     organization = "Mlloydprojects"

#     workspaces {
#       name = "terra-house-1"
#     }
#   }
}

module "terrahouse_aws" {
  source = "./module/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}