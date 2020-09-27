#SETUP
variable "region" {
  description = "Region of DynamoDB"
}

#TAGS
variable "tags" {
  type = map(string)
  description = "Tags for lambda"
  default = {}
}

variable "kms_key_arn" {
  description = "KMS key"
}

variable "db_name_ssm_parameter" {
  description = "DB name via ssm"
}