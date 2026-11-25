variable "floci_port" {
  description = "Host port mapped to this implementation's Floci instance."
  type        = number
  default     = 4566

  validation {
    condition     = var.floci_port >= 1 && var.floci_port <= 65535 && floor(var.floci_port) == var.floci_port
    error_message = "The Floci port must be an integer between 1 and 65535."
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3 = "http://127.0.0.1:${var.floci_port}"
  }
}

resource "aws_s3_bucket" "lab" {
  bucket = "object-storage-floci-terraform"
}

output "bucket_name" {
  description = "Name of the bucket in this Floci instance."
  value       = aws_s3_bucket.lab.bucket
}
