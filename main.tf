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
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}