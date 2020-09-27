variable "api_gw_endpoint_configuration_type" {
  description = "Specify the type of endpoint for API GW to be setup as. [EDGE, REGIONAL, PRIVATE]. Defaults to EDGE"
}

variable "api_gw_name" {
  description = "The name of the REST API"
}

variable "stage_name" {
  description = "The stage name for the API deployment"
  default = "teste"
}

variable "method" {
  description = "The HTTP method"
  default = "POST"
}

variable "lambda_arn" {
  description = "The ARN of Lambda to invoke"
}

variable "lambda_name" {
  description = "The ARN of Lambda to invoke"
}

variable "region" {
  description = "The AWS region"
}

variable "lambda_invoke_arn" {
  description = "LAMBDA INVOKE ARN"
}