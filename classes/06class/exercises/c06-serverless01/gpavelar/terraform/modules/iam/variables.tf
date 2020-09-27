variable "lambda_name" {
  description = "The name of the Lambda function"
  default = "lambda_c06serverless"
}

variable "api_gw_name" {
  description = "The name of the API Gateway"
}

variable "dynamodb_arn_list" {
  # Was necessary to keep without type
  # type = string
  description = "List of ARN's to allow permissions for"
}

variable "dynamodb_policy_action_list" {
  type = list(string)
  description = "List of ARN's to allow permissions for"
}
