#############################################
### SSM
#############################################

data "aws_ssm_parameter" "database_name_param" {
  name      = "DB_NAME"
}

resource "aws_ssm_parameter" "api_key_param" {
  name  = "API_KEY"
  type  = "SecureString"
  value = module.apigw.api_gw_api_key

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_kms_key" "principal_kms_key" {
  description             = "Main KMS key"
  deletion_window_in_days = 10
}

#############################################
### Module Dyanmodb
#############################################
module "lambda" {
  source                                = "./modules/services/lambda"

  #Setup
  region                                = var.region
  lambda_function_name                  = local.lambda_function_name
  lambda_description                    = var.lambda_description
  lambda_runtime                        = var.lambda_runtime
  lambda_handler                        = var.lambda_handler
  lambda_timeout                        = var.lambda_timeout
  lambda_file_name                      = var.lambda_file_name
  lambda_zip_path                       = var.lambda_zip_path
  lambda_memory_size                    = var.lambda_memory_size

  ssm_database_name_param               = data.aws_ssm_parameter.database_name_param.value

  #Internal
  lambda_role                           = module.iam.lambda_role_arn

  #Tags
  tags                                  = var.tags
}

#############################################
### Module Dyanmodb
#############################################
module "dynamodb" {
  source                                = "./modules/services/dynamodb"

  #Global Setup
  region                                = var.region
  #Setup
  kms_key_arn = aws_kms_key.principal_kms_key.arn
  db_name_ssm_parameter = data.aws_ssm_parameter.database_name_param.value
  #Tags
  tags                                  = var.tags
}

#############################################
### Module API Gateway
#############################################
module "apigw" {
  source                                = "./modules/services/api-gateway"

  #Setup
  api_gw_name                           = "${var.project}-API-Gateway-${terraform.workspace}"
  api_gw_endpoint_configuration_type    = var.api_gw_endpoint_configuration_type
  stage_name                            = terraform.workspace
  method                                = var.api_gw_method
  lambda_arn                            = module.lambda.lambda_arn
  region                                = var.region
  lambda_name                           = module.lambda.lambda_name
  lambda_invoke_arn                     = module.lambda.lambda_invoke_arn
}

#############################################
### Locals
#############################################
#required otherwise circular dependency between IAM and Lambda
locals {
  lambda_function_name                  = "${var.project}-${var.lambda_function_name}-${terraform.workspace}"
}
#############################################
### IAM for LAmbda function
#############################################

module "iam" {
  source = "./modules/iam"

  # Setup
  lambda_name                           = local.lambda_function_name
  api_gw_name                           = module.apigw.api_gw_name
  dynamodb_arn_list                     = module.dynamodb.dynamodb_table_arns
  dynamodb_policy_action_list           = var.dynamodb_policy_action_list
}