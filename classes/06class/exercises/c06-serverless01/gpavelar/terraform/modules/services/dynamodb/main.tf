#############################################
### DynamoDB table
#############################################
resource "aws_dynamodb_table" "basic_dynamodb_table" {
  # Table name - uniq
  # name           = data.aws_ssm_parameter.database_name_param.value
  name = var.db_name_ssm_parameter
  # Controls charge on read and write
  billing_mode   = "PAY_PER_REQUEST"
  # Not required when use PAY_PER_REQUEST
  # read_capacity  = 20
  # write_capacity = 20
  # The attribute to use as the hash (partition)
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "firstname"
    type = "S"
  }

  attribute {
    name = "lastname"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  # KMS encryption
  server_side_encryption {
    enabled = true
    # kms_key_arn = aws_kms_key.a.arn
    kms_key_arn = var.kms_key_arn
  }

  ## all attributes must be indexes.
  global_secondary_index {
    name               = "firstnameIndex"
    hash_key           = "firstname"
    range_key          = "lastname"
    # write_capacity     = 10
    # read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["id"]
  }

  tags = var.tags
}