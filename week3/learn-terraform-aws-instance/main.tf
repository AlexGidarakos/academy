terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0f29c8402f8cce65c"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
