output "dynamodb_table_arns" {
  value = aws_dynamodb_table.basic_dynamodb_table.*.arn
}