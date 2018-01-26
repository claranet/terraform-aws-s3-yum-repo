variable "codebuild_name" {
  description = "The CodeBuild project name"
  type        = "string"
}

variable "codebuild_status" {
  description = "A list of CodeBuild status values (e.g. SUCCEEDED) that should trigger the Lambda function"
  type        = "list"
}

variable "lambda_function_arn" {
  description = "The ARN of the Lambda function to trigger"
  type        = "string"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function to trigger"
  type        = "string"
}
