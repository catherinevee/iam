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

module "iam_advanced" {
  source = "../../"

  create_users         = true
  create_groups        = true
  create_roles         = true
  create_policies      = true
  create_access_keys   = true
  create_login_profiles = true
  create_user_group_memberships = true
  create_role_policy_attachments = true
  create_user_policy_attachments = true

  users = {
    ci_user = {
      name = "ci-user"
      path = "/ci/"
      tags = {
        Purpose = "CI/CD"
        Environment = "production"
        Team = "DevOps"
      }
    }
    monitoring_user = {
      name = "monitoring-user"
      path = "/monitoring/"
      tags = {
        Purpose = "Monitoring"
        Environment = "production"
        Team = "SRE"
      }
    }
    backup_user = {
      name = "backup-user"
      path = "/backup/"
      permissions_boundary = "arn:aws:iam::123456789012:policy/BackupBoundary"
      tags = {
        Purpose = "Backup"
        Environment = "production"
        Team = "Operations"
      }
    }
  }

  groups = {
    ci_group = {
      name = "ci-group"
      path = "/groups/"
    }
    monitoring_group = {
      name = "monitoring-group"
      path = "/groups/"
    }
    backup_group = {
      name = "backup-group"
      path = "/groups/"
    }
  }

  roles = {
    ecs_task_role = {
      name = "ECSTaskRole"
      path = "/roles/"
      description = "Role for ECS tasks to access AWS services"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "ecs-tasks.amazonaws.com"
            }
          }
        ]
      })
      tags = {
        Service = "ECS"
        Purpose = "TaskRole"
        Environment = "production"
      }
    }
    codebuild_role = {
      name = "CodeBuildRole"
      path = "/roles/"
      description = "Role for CodeBuild to access AWS services"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "codebuild.amazonaws.com"
            }
          }
        ]
      })
      tags = {
        Service = "CodeBuild"
        Purpose = "BuildRole"
        Environment = "production"
      }
    }
  }

  policies = {
    ci_policy = {
      name        = "CIPolicy"
      description = "Policy for CI/CD operations"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "ecs:DescribeServices",
              "ecs:UpdateService",
              "ecs:DescribeTasks",
              "ecs:ListTasks",
              "ecs:DescribeTaskDefinition",
              "ecs:RegisterTaskDefinition"
            ]
            Resource = "*"
          },
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ]
            Resource = "arn:aws:logs:*:*:*"
          }
        ]
      })
      tags = {
        Service = "CI/CD"
        Access = "BuildDeploy"
        Environment = "production"
      }
    }
    monitoring_policy = {
      name        = "MonitoringPolicy"
      description = "Policy for monitoring and alerting"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "cloudwatch:GetMetricData",
              "cloudwatch:GetMetricStatistics",
              "cloudwatch:ListMetrics",
              "cloudwatch:DescribeAlarms",
              "cloudwatch:PutMetricData",
              "logs:DescribeLogGroups",
              "logs:DescribeLogStreams",
              "logs:GetLogEvents",
              "logs:FilterLogEvents"
            ]
            Resource = "*"
          },
          {
            Effect = "Allow"
            Action = [
              "sns:Publish",
              "sns:Subscribe",
              "sns:ListSubscriptions"
            ]
            Resource = "arn:aws:sns:*:*:*"
          }
        ]
      })
      tags = {
        Service = "Monitoring"
        Access = "ReadWrite"
        Environment = "production"
      }
    }
    backup_policy = {
      name        = "BackupPolicy"
      description = "Policy for backup operations"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject",
              "s3:DeleteObject",
              "s3:ListBucket",
              "s3:GetBucketLocation"
            ]
            Resource = [
              "arn:aws:s3:::backup-bucket",
              "arn:aws:s3:::backup-bucket/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "rds:DescribeDBInstances",
              "rds:CreateDBSnapshot",
              "rds:DescribeDBSnapshots",
              "rds:CopyDBSnapshot"
            ]
            Resource = "*"
          }
        ]
      })
      tags = {
        Service = "Backup"
        Access = "BackupOnly"
        Environment = "production"
      }
    }
  }

  user_group_memberships = {
    ci_membership = {
      user_key = "ci_user"
      groups   = ["ci_group"]
    }
    monitoring_membership = {
      user_key = "monitoring_user"
      groups   = ["monitoring_group"]
    }
    backup_membership = {
      user_key = "backup_user"
      groups   = ["backup_group"]
    }
  }

  access_keys = {
    ci_access_key = {
      user_key = "ci_user"
      status   = "Active"
    }
    monitoring_access_key = {
      user_key = "monitoring_user"
      status   = "Active"
    }
    backup_access_key = {
      user_key = "backup_user"
      status   = "Active"
    }
  }

  login_profiles = {
    ci_login = {
      user_key                = "ci_user"
      password_reset_required = true
      password_length         = 32
    }
    monitoring_login = {
      user_key                = "monitoring_user"
      password_reset_required = true
      password_length         = 32
    }
    backup_login = {
      user_key                = "backup_user"
      password_reset_required = true
      password_length         = 32
    }
  }

  user_policy_attachments = {
    ci_user_policy = {
      user_key   = "ci_user"
      policy_key = "ci_policy"
    }
    monitoring_user_policy = {
      user_key   = "monitoring_user"
      policy_key = "monitoring_policy"
    }
    backup_user_policy = {
      user_key   = "backup_user"
      policy_key = "backup_policy"
    }
  }

  role_policy_attachments = {
    ecs_ci_policy = {
      role_key   = "ecs_task_role"
      policy_key = "ci_policy"
    }
    codebuild_ci_policy = {
      role_key   = "codebuild_role"
      policy_key = "ci_policy"
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
    ManagedBy   = "terraform"
    Owner       = "DevOps Team"
    CostCenter  = "Engineering"
  }
} 