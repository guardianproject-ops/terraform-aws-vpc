
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      aws    = ">= 2.0, < 4.0"
    }
  }
}
