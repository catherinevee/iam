terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2.0"
    }
  }
}

module "main" {
  source = "../"
  
  create_users = true
  create_roles = true
  
  users = {
    test_user = {
      name = "test-user"
      path = "/test/"
      tags = {
        Environment = "test"
      }
    }
  }
  
  roles = {
    test_role = {
      name = "test-role"
      path = "/test/"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
          }
        ]
      })
      tags = {
        Environment = "test"
      }
    }
  }
}

run "create_user" {
  command = plan

  assert {
    condition     = length(module.main.iam_users) == 1
    error_message = "Expected one IAM user to be created"
  }
}

run "create_role" {
  command = plan

  assert {
    condition     = length(module.main.iam_roles) == 1
    error_message = "Expected one IAM role to be created"
  }
}
