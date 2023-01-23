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
  region = "eu-west-1"
  profile = "fmcmincs"
  #shared_credentials_files = ["~/.aws/config"]
}

resource "aws_instance" "app_server_christopher1234323422" {
  ami           = "ami-0fe0b2cf0e1f25c8a"
  instance_type = "t2.micro"

  tags = {
    Name = "fairmarchristopherschmidt"
  }
}
