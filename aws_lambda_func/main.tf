resource "aws_iam_role" "iam_for_lambda" {
  name_prefix = var.name
  description = "execution role for lambda function ${var.name}"

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
  tags = {
    Name        = var.name
    Terraformed = true
  }
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.retentionDays
  kms_key_id        = var.kmsKeyArn
  tags = {
    Name        = var.name
    Terraformed = true
  }
}


# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name_prefix = "${var.name}-logging"
  path        = "/"
  description = "IAM policy for logging from lambda ${var.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_lambda_function" "lambda_func" {
  filename         = var.zipFile
  function_name    = var.name
  description      = var.description
  publish          = var.publish
  timeout          = var.t0
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = var.handler
  source_code_hash = filebase64sha256(var.zipFile)
  runtime          = var.runtime
  environment {
    variables = var.environment
  }
  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.example,
  ]
  tags = {
    Name        = var.name
    Terraformed = true
  }
}
