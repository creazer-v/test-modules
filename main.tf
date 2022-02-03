terraform {

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      Environment = "dev"
    }
  }
}

module "networking" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.10.0"

  name = "hostopia"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b"]
  public_subnets  = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/28"]

}

module "vpc_without-igw" {
  source = "./terraform-aws-modules/ec2"
  ankit  = "ami-05c029a4b57edda9e"
}


