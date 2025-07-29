terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
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
  create_roles  = true
  create_policies = true
  create_user_group_memberships = true
  create_role_policy_attachments = true

  users = {
    developer = {
      name = "developer"
      path = "/developers/"
      tags = {
        Department = "Engineering"
        Role       = "Developer"
        Environment = "development"
      }
    }
    admin = {
      name = "admin"
      path = "/admins/"
      permissions_boundary = "arn:aws:iam::123456789012:policy/AdminBoundary"
      tags = {
        Department = "IT"
        Role       = "Administrator"
        Environment = "production"
      }
    }
    readonly = {
      name = "readonly"
      path = "/readonly/"
      tags = {
        Department = "Operations"
        Role       = "ReadOnly"
        Environment = "production"
      }
    }
  }

  groups = {
    developers = {
      name = "developers"
      path = "/groups/"
    }
    admins = {
      name = "admins"
      path = "/groups/"
    }
    readonly_users = {
      name = "readonly-users"
      path = "/groups/"
    }
  }

  roles = {
    ec2_role = {
      name = "EC2InstanceRole"
      path = "/roles/"
      description = "Role for EC2 instances to access S3 and CloudWatch"
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
        Service = "EC2"
        Purpose = "InstanceRole"
        Environment = "production"
      }
    }
    lambda_role = {
      name = "LambdaExecutionRole"
      path = "/roles/"
      description = "Role for Lambda functions"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "lambda.amazonaws.com"
            }
          }
        ]
      })
      tags = {
        Service = "Lambda"
        Purpose = "ExecutionRole"
        Environment = "production"
      }
    }
  }

  policies = {
    s3_read_only = {
      name        = "S3ReadOnlyPolicy"
      description = "Policy for read-only access to S3 buckets"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:ListBucket",
              "s3:GetBucketLocation"
            ]
            Resource = [
              "arn:aws:s3:::my-data-bucket",
              "arn:aws:s3:::my-data-bucket/*"
            ]
          }
        ]
      })
      tags = {
        Service = "S3"
        Access  = "ReadOnly"
        Environment = "production"
      }
    }
    cloudwatch_logs = {
      name        = "CloudWatchLogsPolicy"
      description = "Policy for CloudWatch Logs access"
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
            Resource = "arn:aws:logs:*:*:*"
          }
        ]
      })
      tags = {
        Service = "CloudWatch"
        Access  = "Logs"
        Environment = "production"
      }
    }
    ec2_basic = {
      name        = "EC2BasicPolicy"
      description = "Basic EC2 permissions"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ec2:DescribeInstances",
              "ec2:DescribeSecurityGroups",
              "ec2:DescribeVpcs",
              "ec2:DescribeSubnets"
            ]
            Resource = "*"
          }
        ]
      })
      tags = {
        Service = "EC2"
        Access  = "ReadOnly"
        Environment = "production"
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
    readonly_membership = {
      user_key = "readonly"
      groups   = ["readonly_users"]
    }
  }

  role_policy_attachments = {
    ec2_s3_access = {
      role_key   = "ec2_role"
      policy_key = "s3_read_only"
    }
    ec2_cloudwatch = {
      role_key   = "ec2_role"
      policy_key = "cloudwatch_logs"
    }
    lambda_cloudwatch = {
      role_key   = "lambda_role"
      policy_key = "cloudwatch_logs"
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
    ManagedBy   = "terraform"
    Owner       = "DevOps Team"
  }
} 