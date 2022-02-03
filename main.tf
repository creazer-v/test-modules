##
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

resource "aws_cognito_user_pool" "pool" {
  name = "test-userpool2335"
  account_recovery_setting {
    recovery_mechanism {
        name   = "verified_email"
        priority = "1"
        }
    recovery_mechanism {
        name     = "verified_phone_number"
        priority = 2
        }
 }
admin_create_user_config{
    allow_admin_create_user_only = "false"
    }

  alias_attributes = [
  "email"]
  auto_verified_attributes = [
    "email"
  ]
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"

  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  schema {
    attribute_data_type          = "String"
    developer_only_attribute     = false
    mutable                      = true
    name                         = "email"
    required                     = true
    string_attribute_constraints{
      
        max_length = "2048"
        min_length = "0"
      }
  }
  mfa_configuration = "OFF"
  username_configuration {
    case_sensitive = false
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "test-userpool2335cli"
  user_pool_id                         = aws_cognito_user_pool.pool.id
  access_token_validity                = 0
  allowed_oauth_flows_user_pool_client = false
  enable_token_revocation              = true
  read_attributes = [
    "email",
    "email_verified",
    "preferred_username"
  ]
  refresh_token_validity = 30

}

