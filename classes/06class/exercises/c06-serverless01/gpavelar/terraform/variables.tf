#TAGS
variable "tags" {
  type = map(string)
  description = "Tags for lambda"
  default = {}
}

#SETUP

#Global
variable "region" {
  description = "Region to deploy in"
}

variable "project" {
  description = "Name of project"
}

#Lambda
variable "lambda_function_name" {
  description = "Local path to Lambda zip code"
}

variable "lambda_description" {
  default = ""
  description = "Lambda description"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
}

variable "lambda_handler" {
  description = "Lambda handler path"
}

variable "lambda_timeout" {
  description = "Maximum runtime for Lambda"
  default = 30
}

variable "lambda_file_name" {
  default = "lambda.zip"
  description = "Path to lambda code zip"
}

variable "lambda_zip_path" {
  default = "defaultZipPath"
  description = "Local path to Lambda zip code"
}

variable "lambda_memory_size" {
  description = "Lambda memory size"
}

#API Gateway Setup
variable "api_gw_method" {
  description = "API Gateway method (GET,POST...)"
  default = "POST"
}

variable "api_gw_endpoint_configuration_type" {
  description = "Specify the type of endpoint for API GW to be setup as. [EDGE, REGIONAL, PRIVATE]. Defaults to EDGE"
  default = "EDGE"
}

variable "dynamodb_policy_action_list" {
  description = "List of Actions to be executed"
  type = list(string)
  default = ["dynamodb:DescribeTable", "dynamodb:DeleteItem", "dynamodb:GetItem", "dynamodb:Scan", "dynamodb:Query"]
}