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

module "iam_advanced" {
  source = "../../"

  create_users         = true
  create_roles         = true
  create_policies      = true
  create_access_keys   = true
  create_login_profiles = true
  create_role_policy_attachments = true

  users = {
    api_user = {
      name = "api-user"
      path = "/users/"
      tags = {
        Environment = "production"
        Purpose     = "api-access"
        Team        = "backend"
      }
    }
    lambda_user = {
      name = "lambda-user"
      path = "/users/"
      tags = {
        Environment = "production"
        Purpose     = "lambda-execution"
        Team        = "backend"
      }
    }
  }

  roles = {
    ec2_role = {
      name        = "EC2InstanceRole"
      description = "Role for EC2 instances to access S3 and CloudWatch"
      path        = "/roles/"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
          }
        ]
      })
      tags = {
        Environment = "production"
        Service     = "ec2"
        Purpose     = "instance-role"
      }
    }
    lambda_role = {
      name        = "LambdaExecutionRole"
      description = "Role for Lambda functions to access DynamoDB and S3"
      path        = "/roles/"
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
        Environment = "production"
        Service     = "lambda"
        Purpose     = "execution-role"
      }
    }
  }

  policies = {
    s3_access = {
      name        = "S3AccessPolicy"
      description = "Policy for S3 bucket access"
      path        = "/policies/"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject",
              "s3:DeleteObject",
              "s3:ListBucket"
            ]
            Resource = [
              "arn:aws:s3:::my-app-bucket",
              "arn:aws:s3:::my-app-bucket/*"
            ]
          }
        ]
      })
      tags = {
        Environment = "production"
        Service     = "s3"
        Access      = "read-write"
      }
    }
    dynamodb_access = {
      name        = "DynamoDBAccessPolicy"
      description = "Policy for DynamoDB table access"
      path        = "/policies/"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "dynamodb:GetItem",
              "dynamodb:PutItem",
              "dynamodb:UpdateItem",
              "dynamodb:DeleteItem",
              "dynamodb:Query",
              "dynamodb:Scan"
            ]
            Resource = [
              "arn:aws:dynamodb:us-west-2:123456789012:table/my-app-table"
            ]
          }
        ]
      })
      tags = {
        Environment = "production"
        Service     = "dynamodb"
        Access      = "read-write"
      }
    }
    cloudwatch_access = {
      name        = "CloudWatchAccessPolicy"
      description = "Policy for CloudWatch Logs access"
      path        = "/policies/"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents",
              "logs:DescribeLogGroups",
              "logs:DescribeLogStreams"
            ]
            Resource = [
              "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/*",
              "arn:aws:logs:us-west-2:123456789012:log-group:/aws/lambda/*:log-stream:*"
            ]
          }
        ]
      })
      tags = {
        Environment = "production"
        Service     = "cloudwatch"
        Access      = "logs"
      }
    }
  }

  access_keys = {
    api_user_key = {
      user_key = "api_user"
      status   = "Active"
    }
  }

  login_profiles = {
    api_user_profile = {
      user_key                = "api_user"
      password_reset_required = true
      password_length         = 20
    }
  }

  role_policy_attachments = {
    ec2_s3_access = {
      role_key   = "ec2_role"
      policy_key = "s3_access"
    }
    ec2_cloudwatch_access = {
      role_key   = "ec2_role"
      policy_key = "cloudwatch_access"
    }
    lambda_dynamodb_access = {
      role_key   = "lambda_role"
      policy_key = "dynamodb_access"
    }
    lambda_s3_access = {
      role_key   = "lambda_role"
      policy_key = "s3_access"
    }
    lambda_cloudwatch_access = {
      role_key   = "lambda_role"
      policy_key = "cloudwatch_access"
    }
  }

  tags = {
    Environment = "production"
    Project     = "terraform-iam-advanced"
    ManagedBy   = "terraform"
  }
} 