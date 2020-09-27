#TAGS
variable "tags" {
  type = map(string)
  description = "Tags for lambda"
  default = {}
}

#SETUP
variable "region" {
  description = "Region of Lambda & S3 source code"
}

variable "ssm_database_name_param" {
  description = "Database name"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
}

variable "lambda_description" {
  description = "Lambda description"
}

variable "lambda_runtime" {
  description = "The runtime of the Lambda to create"
}

variable "lambda_handler" {
  description = "The name of Lambda function handler"
}

variable "lambda_role" {
  description = "IAM role attached to Lambda function - ARN"
}

variable "lambda_timeout" {
  description = "Maximum runtime for Lambda"
  default = 30
}

variable "lambda_file_name" {
  description = "Path to lambda code zip"
}

variable "lambda_zip_path" {
  description = "Local path to Lambda source dist"
}

variable "lambda_memory_size" {
  description = "Lambda memory size"
  default = 128
}