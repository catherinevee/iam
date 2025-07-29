terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

module "iam_test" {
  source = "../"

  create_users  = true
  create_groups = true
  create_roles  = true
  create_policies = true
  create_user_group_memberships = true
  create_role_policy_attachments = true

  users = {
    test_user = {
      name = "test-user"
      path = "/test/"
      tags = {
        Environment = "test"
        Purpose     = "testing"
      }
    }
  }

  groups = {
    test_group = {
      name = "test-group"
      path = "/test/"
      tags = {
        Environment = "test"
        Purpose     = "testing"
      }
    }
  }

  policies = {
    test_policy = {
      name        = "TestPolicy"
      description = "Test policy for validation"
      path        = "/test/"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:ListBucket"
            ]
            Resource = [
              "arn:aws:s3:::test-bucket"
            ]
          }
        ]
      })
      tags = {
        Environment = "test"
        Purpose     = "testing"
      }
    }
  }

  roles = {
    test_role = {
      name        = "TestRole"
      description = "Test role for validation"
      path        = "/test/"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              Service = "lambda.amazonaws.com"
            }
            Action = "sts:AssumeRole"
          }
        ]
      })
      tags = {
        Environment = "test"
        Purpose     = "testing"
      }
    }
  }

  user_group_memberships = {
    test_membership = {
      user_key = "test_user"
      groups   = ["test_group"]
    }
  }

  role_policy_attachments = {
    test_attachment = {
      role_key   = "test_role"
      policy_key = "test_policy"
    }
  }

  tags = {
    Environment = "test"
    Project     = "terraform-iam-test"
    ManagedBy   = "terraform"
  }
} 