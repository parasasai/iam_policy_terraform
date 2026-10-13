terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

# Metadata discovery block context
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  common_tags = {
    Account   = data.aws_caller_identity.current.account_id
    Region    = data.aws_region.current.name
    ManagedBy = "Terraform"
    Owner     = "sai_devops"
  }
}

# Dynamic IAM policy document template compilation
data "aws_iam_policy_document" "sai_devops" {
  statement {
    sid    = "EC2LifecycleManagement"
    effect = "Allow"
    actions = [
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:RebootInstances"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EC2MonitoringAndRead"
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:DescribeSecurityGroups",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics"
    ]
    resources = ["*"]
  }
}

# The managed IAM policy resource instantiation
resource "aws_iam_policy" "ec2_management" {
  name        = "EC2AdminAccess-SaiDevOps"
  description = "Managed via Terraform - Allows lifecycle and tracking permissions for Sai DevOps"
  policy      = data.aws_iam_policy_document.sai_devops.json
  
  tags = merge(local.common_tags, {
    Env = var.environment
  })
}
