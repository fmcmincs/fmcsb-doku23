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
  profile = "fmcsbtestcs"
}

# erstelle eine vpc mit insg 6 subnetzen (3public+3private)
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  count = 1
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-count-${count.index}"
  cidr = "10.0.0.0/16" #check in https://cidr.xyz/

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# ertelle in jedem privaten subnetz eine ec2 instance (insg. 3)
# https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = {for k in range(length(module.vpc[0].private_subnets)): k=>k} 

  name = "instance-${each.value}"

  ami                    = "ami-0b752bf1df193a6c4"
  instance_type          = "t2.micro"
  #key_name               = "user1"
  monitoring             = true
  #vpc_security_group_ids = ["sg-07882342e1e2ad555"]
  subnet_id              = module.vpc[0].private_subnets[each.value]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

/*
resource "aws_instance" "app_server_fmctest" {
  ami           = "ami-0fe0b2cf0e1f25c8a"
  instance_type = "t2.micro"

  tags = {
    # Eigenen Namen hier eingeben
    Name = "gruppe62instanztest"

    Umgebung = "sandbox"
  }

}
*/