variable "aws_region" {
  type        = string
  description = "The target AWS Region where the IAM resources are validated"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "The deployment environment stage tag classification"
  default     = "dev"
}
