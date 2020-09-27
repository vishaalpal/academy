#############################################
### Lambda Function
#############################################
resource "aws_lambda_function" "lambda_file" {

  function_name               = var.lambda_function_name
  filename                    = var.lambda_file_name
  description                 = var.lambda_description
  runtime                     = var.lambda_runtime
  handler                     = var.lambda_handler
  role                        = var.lambda_role
  timeout                     = var.lambda_timeout
  source_code_hash = filebase64sha256(var.lambda_file_name)
  memory_size                 = "128"

  environment {
    variables                 = {
      DB_NAME = var.ssm_database_name_param
    }
  }

  tags = var.tags
}