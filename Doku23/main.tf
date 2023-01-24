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
  # Verfügbare Regionen: us-east-1 (N.Virgina) und eu-west-1 (Irland)
  region = "eu-west-1"
  
  # Eigenes CLI SSO Profil hier eingeben
  profile = "fmcmincs"

  #bitte diese zwei Zeilen löschen...
  #shared_credentials_files = ["~/.aws/config"]
}

resource "aws_instance" "app_server_fmctest" {
  ami           = "ami-0fe0b2cf0e1f25c8a"
  instance_type = "t2.micro"

  tags = {
    # Eigenen Noomenaeoidn hier eingeben
    Name = "fairmarchristopherschmidt"

    Umgebung = "sandbox"
  }
}
