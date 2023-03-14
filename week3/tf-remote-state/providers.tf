# Define providers to be used
terraform {
  required_version = "~> 1.3.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.57.1"
    }
  }

  backend "s3" {
    bucket = "alexg-academy-tfstate"
    key = "project/terraform.tfstate"
    region = "eu-west-1"
  }
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
