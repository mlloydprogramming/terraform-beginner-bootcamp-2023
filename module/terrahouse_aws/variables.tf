variable "user_uuid" {
  description = "The UUID of the user"
  type        = string
  validation {
    condition        = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$", var.user_uuid))
    error_message    = "The user_uuid value is not a valid UUID."
  }
}

variable "bucket_name" {
  description = "AWS S3 bucket name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,63}$", var.bucket_name))
    error_message = "Bucket name must be between 3 and 63 characters and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "index_html_filepath" {
  description = "Path to the index.html file"
  type = string

  validation {
    condition     = fileexists(var.index_html_filepath)
    error_message = "The specified file does not exist."
  }
}

variable "error_html_filepath" {
  description = "Path to the error.html file"
  type = string

  validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified file does not exist."
  }
}

variable "content_version" {
  description = "The version of the content. Should be a positive integer starting at one."

  type = number

  validation {
    condition     = var.content_version >= 1 && var.content_version == floor(var.content_version)
    error_message = "The content_version must be a positive integer starting at one."
  }
}

variable "assets_path" {
  description = "Path to the assets folder"
  type = string
}