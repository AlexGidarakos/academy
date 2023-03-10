# Define providers to be used
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.57.1"
    }
  }

  required_version = ">= 1.3.9"
}

# Set AWS region to variable
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner = var.student
    }
  }
}
