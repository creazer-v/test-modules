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

module "aws_cognito_user_pool_complete" {

  source  = "lgallard/cognito-user-pool/aws"
  version = "0.14.2"

  user_pool_name   = "aw-fiber-cms-prod-app04"
  alias_attributes = ["email"]
  #auto_verified_attributes = ["email"]

  # email_configuration = {
  #   email_sending_account = "DEVELOPER"
  #   source_arn            = "arn:aws:ses:us-east-1:123456789238:identity/example.com"
  # }

  admin_create_user_config = {
    allow_admin_create_user_only = false
  }

  #enable_username_case_insensitivity  = true

  password_policy = {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  # string_schemas = [
  #   {
  #     attribute_data_type      = "String"
  #     developer_only_attribute = false
  #     mutable                  = false
  #     name                     = "email"
  #     required                 = true

  #     string_attribute_constraints = {
  #       min_length = 7
  #       max_length = 15
  #     }
  #   }
  # ]

  recovery_mechanisms = [
    {
      name     = "verified_email"
      priority = 1
    },
    {
      name     = "verified_phone_number"
      priority = 2
    }
  ]

  tags = {
    Owner       = "user"
    Environment = "Production"
    Terraform   = true
  }

  clients = [
    {
      name            = "aw-cms-production"
      read_attributes = ["email", "email_verified", "preferred_username"]
      generate_secret = false
    }
  ]
}

