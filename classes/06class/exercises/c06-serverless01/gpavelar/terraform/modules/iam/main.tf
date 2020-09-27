#############################################
### IAM for LAmbda function
#############################################

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "template_file" "lambda_dynamodb_policy" {
  template                                              = file("${path.module}/dynamodb-policy.json")
  vars = {
    policy_arn_list    = "${join(", ", formatlist("\"%s\"", var.dynamodb_arn_list))}"
    policy_action_list = "${join(", ", formatlist("\"%s\"", "${var.dynamodb_policy_action_list}"))}"
  }
}

#LAMBDA
resource "aws_iam_role" "lambda-role" {
  name = "${var.lambda_name}_role"
  assume_role_policy = file("${path.module}/lambda-role.json")
}

#API GW
resource "aws_iam_role" "apigw-role" {
  name                                                  = "${var.api_gw_name}-Role"
  assume_role_policy                                    = file("${path.module}/apigw-role.json")
}

# Dynamo
resource "aws_iam_role_policy" "DynamoDB-Policy" {
  name                                                  = "${aws_iam_role.lambda-role.name}-Policy"
  role                                                  = aws_iam_role.lambda-role.id
  policy                                                = data.template_file.lambda_dynamodb_policy.rendered
}

resource "aws_iam_role_policy_attachment" "Lambda-CloudWatch-Logs-ReadWrite" {
  policy_arn                                            = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role                                                  = aws_iam_role.lambda-role.name
}

resource "aws_iam_role_policy_attachment" "API-GW-CloudWatch-Logs-ReadWrite" {
  policy_arn                                            = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  role                                                  = aws_iam_role.apigw-role.name
}