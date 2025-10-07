# IAM Role for Lambda function

resource "aws_iam_role" "lambda_role" {
  name = "lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "lambda"
  }
}


# lamdba Policy

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_ec2_control_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "sns:Publish"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}



# Lambda function
resource "aws_lambda_function" "stopec2" {
  filename         = data.archive_file.stop_ec2_lambda.output_path
  function_name    = "stopec2"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.stop_ec2_lambda.output_base64sha256

  runtime = "python3.11"

  environment {
    variables = {
      INSTANCE_IDS  = module.ec2_instance.id
      SNS_TOPIC_ARN = aws_sns_topic.autosns.arn
  }
  }

  tags = {
    Environment = "dev"
    Application = "stop Instance"
  }
}




# Lambda function
resource "aws_lambda_function" "startec2" {
  filename         = data.archive_file.start_ec2_lambda.output_path
  function_name    = "startec2"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.start_ec2_lambda.output_base64sha256

  runtime = "python3.11"

  environment {
    variables = {
      INSTANCE_IDS  = module.ec2_instance.id
      SNS_TOPIC_ARN = aws_sns_topic.autosns.arn
  }
  }

  tags = {
    Environment = "dev"
    Application = "start Instance"
  }
}






resource "aws_lambda_permission" "allow_cloudwatch_start" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.startec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start.arn
  
}

resource "aws_lambda_permission" "allow_cloudwatch_stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stopec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop.arn
  
}







data "archive_file" "stop_ec2_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/functions/stop"
  output_path = "${path.module}/functions/stop.zip"
}

data "archive_file" "start_ec2_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/functions/start"
  output_path = "${path.module}/functions/start.zip"
}