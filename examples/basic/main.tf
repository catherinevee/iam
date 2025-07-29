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

module "iam_basic" {
  source = "../../"

  create_users  = true
  create_groups = true
  create_policies = true
  create_user_group_memberships = true

  users = {
    developer = {
      name = "developer"
      path = "/users/"
      tags = {
        Environment = "development"
        Role        = "developer"
        Team        = "engineering"
      }
    }
    admin = {
      name = "admin"
      path = "/users/"
      tags = {
        Environment = "development"
        Role        = "admin"
        Team        = "operations"
      }
    }
  }

  groups = {
    developers = {
      name = "developers"
      path = "/groups/"
      tags = {
        Environment = "development"
        Team        = "engineering"
      }
    }
    admins = {
      name = "admins"
      path = "/groups/"
      tags = {
        Environment = "development"
        Team        = "operations"
      }
    }
  }

  policies = {
    s3_read_only = {
      name        = "S3ReadOnlyPolicy"
      description = "Policy for read-only access to S3 buckets"
      path        = "/policies/"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:ListBucket"
            ]
            Resource = [
              "arn:aws:s3:::example-bucket",
              "arn:aws:s3:::example-bucket/*"
            ]
          }
        ]
      })
      tags = {
        Environment = "development"
        Service     = "s3"
        Access      = "read-only"
      }
    }
    ec2_read_only = {
      name        = "EC2ReadOnlyPolicy"
      description = "Policy for read-only access to EC2 resources"
      path        = "/policies/"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ec2:Describe*",
              "ec2:Get*",
              "ec2:List*"
            ]
            Resource = "*"
          }
        ]
      })
      tags = {
        Environment = "development"
        Service     = "ec2"
        Access      = "read-only"
      }
    }
  }

  user_group_memberships = {
    developer_membership = {
      user_key = "developer"
      groups   = ["developers"]
    }
    admin_membership = {
      user_key = "admin"
      groups   = ["admins", "developers"]
    }
  }

  tags = {
    Environment = "development"
    Project     = "terraform-iam-example"
    ManagedBy   = "terraform"
  }
} 