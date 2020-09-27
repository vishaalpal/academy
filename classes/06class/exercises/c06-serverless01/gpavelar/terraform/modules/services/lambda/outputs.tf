output "lambda_name" {
  value = join(",", aws_lambda_function.lambda_file.*.function_name)
}

output "lambda_arn" {
  value = join(",", aws_lambda_function.lambda_file.*.arn)
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda_file.invoke_arn
}