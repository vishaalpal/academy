
#Global
region = "ap-southeast-2"
project = "DevOps-Serverless-Project"
  
#API Gateway
api_gw_method = "POST"

#Lambda
lambda_function_name = "ServerLess01-Lambda"
lambda_description = "ServerLess01 HTTP Endpoint Lambda"
lambda_runtime = "python3.8"
lambda_handler = "lambda_handler.lambda_handler"
lambda_timeout = 30
lambda_zip_path = "src/lambda.zip"
lambda_memory_size = 128
lambda_file_name = "../src/lambda.zip"

dynamodb_policy_action_list = ["dynamodb:PutItem", "dynamodb:DescribeTable", "dynamodb:DeleteItem", "dynamodb:GetItem", "dynamodb:Scan", "dynamodb:Query"]
    
#Tags
tags = {
  project = "Serverlessc06-Project"
  managedby = "Terraform"
}