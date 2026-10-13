output "managed_iam_policy_arn" {
  description = "The official AWS Resource Number mapping for your custom DevOps policy block"
  value       = aws_iam_policy.ec2_management.arn
}

output "policy_json_document" {
  description = "The raw compiled JSON structure of the generated policy file for debugging"
  value       = data.aws_iam_policy_document.sai_devops.json
}

output "executing_account_id" {
  description = "The AWS account ID where this IAM policy was created"
  value       = data.aws_caller_identity.current.account_id
}
