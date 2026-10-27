terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

variable "bucket_name" {
  type    = string
  default = "wordcount-bucket-981237"
}

resource "aws_s3_bucket" "wordcount_bucket" {
  bucket = var.bucket_name
}

output "bucket_name" {
  value = aws_s3_bucket.wordcount_bucket.bucket
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "wordcount_lambda_execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_s3_read" {
  name = "wordcount_lambda_s3_read"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.wordcount_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_sns_topic" "wordcount_topic" {
  name = "wordcount-topic"
}

resource "aws_iam_role_policy" "lambda_sns_publish" {
  name = "wordcount_lambda_sns_publish"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish"
        ]
        Effect   = "Allow"
        Resource = aws_sns_topic.wordcount_topic.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_logging" {
  name = "wordcount_lambda_logging"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "${aws_cloudwatch_log_group.lambda_logs.arn}:*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/wordcount-processor"
  retention_in_days = 14
}


resource "aws_lambda_function" "wordcount_processor" {
  function_name = "wordcount-processor"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "textfile_wordcount_processor.handler.lambda_handler"
  runtime       = "python3.12"

  filename         = "../build/lambda_package/deployment.zip"
  source_code_hash = filebase64sha256("../build/lambda_package/deployment.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.wordcount_topic.arn
    }
  }
}