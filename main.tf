##https://prod.liveshare.vsengsaas.visualstudio.com/join?76B0F2772B421B2CF84F445BD12C2658B9A5
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
https://llama3-2-lightweight.llamameta.net/*?Policy=eyJTdGF0ZW1lbnQiOlt7InVuaXF1ZV9oYXNoIjoiemxoM3o4YjhncW90cDE1dHl1cDRiaHZtIiwiUmVzb3VyY2UiOiJodHRwczpcL1wvbGxhbWEzLTItbGlnaHR3ZWlnaHQubGxhbWFtZXRhLm5ldFwvKiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTc0MTYxNjgyNn19fV19&Signature=UB%7E9Em2jCps0HOz3MrjNKe0xbB2s9OVKKfUGqMl-VhRB1DXgv-2-WAJPSocc2OzaRpNv0sbLSh-KSKTKVQG87vD6PhJpIRSihpcSBbmvqSlhmPNCnE8YulV-yBm1Ijtp3LML%7EwvvaK92ZBcPizvCohx17MpSy9votcK1XkhDODOMZFLbnZKnvp1OnGWe94BuHYusQ5FjGe411QzuHyxUo9q9LIFcvAyctKKJnzgS7WVHhCEz6%7Eqvopoc6Eju7pJfmIpY-7f8vUhnxwtkh7B-aoQ9jbrdzBBluiySmAAibvuQ3eeF8T6j08NpuWx7QXGRFBz32EWj9T2-Ln1Ov8euKw__&Key-Pair-Id=K15QRJLYKIFSLZ&Download-Request-ID=1129766372166543
https://llama3-2-lightweight.llamameta.net/*?Policy=eyJTdGF0ZW1lbnQiOlt7InVuaXF1ZV9oYXNoIjoiMTg4MWx5cnR0c3k4cTB3ZDNodDdzc2V5IiwiUmVzb3VyY2UiOiJodHRwczpcL1wvbGxhbWEzLTItbGlnaHR3ZWlnaHQubGxhbWFtZXRhLm5ldFwvKiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTc0MDQ4ODU2N319fV19&Signature=rQumQcO5jtIZ67pso7C-E-z3vZV%7EeoMeX8OfU4zUGY4itWafsxqbfrAiHYlVwcJWqJunzAVlVD906a55nXriR6dlu39bFOr1VktOtxyRHNBob-IJEl22T8TGO8ya209PrWy-MjFJykBxz6vg9ZoL285u3aJRBIFBLUMpNfkIy-8RdPS68nvO%7EqdOv8La3qXu9raYAILHFgtHx0aekYb7NyXiLi5AuiYSkoJvt5dog4BwLKbfidgPcOb8Q%7EZgNu-uKtpOSVLy%7ES49BqpxzZN6LGO0eZMW%7EyeB-JL9rw17WjluLGoou-1MzMfMRq7B%7EhFmuwCgl0-mA-1nOdME05%7ETsg__&Key-Pair-Id=K15QRJLYKIFSLZ&Download-Request-ID=1046741213930234
