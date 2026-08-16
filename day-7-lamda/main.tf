# -------------------------
# SNS Topic
# -------------------------

resource "aws_sns_topic" "ec2_alerts" {
  name = "ec2-alerts"
}


# -------------------------
# IAM Role for Lambda
# -------------------------

resource "aws_iam_role" "lambda_role" {
  name = "ec2-sns-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}


# -------------------------
# Lambda permission to publish SNS
# -------------------------

resource "aws_iam_role_policy" "lambda_sns_policy" {
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "sns:Publish"
      ]

      Resource = aws_sns_topic.ec2_alerts.arn
    }]
  })
}


# -------------------------
# Lambda Function
# -------------------------

resource "aws_lambda_function" "ec2_notification" {
  function_name = "ec2-start-notification"

  filename = "lambda.zip"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  role = aws_iam_role.lambda_role.arn
}


# -------------------------
# EventBridge Rule
# -------------------------

resource "aws_cloudwatch_event_rule" "ec2_running" {
  name = "ec2-running-rule"

  event_pattern = jsonencode({
    source = [
      "aws.ec2"
    ]

    detail-type = [
      "EC2 Instance State-change Notification"
    ]

    detail = {
      state = [
        "running"
      ]
    }
  })
}


# -------------------------
# EventBridge → Lambda
# -------------------------

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.ec2_running.name
  arn  = aws_lambda_function.ec2_notification.arn
}


# -------------------------
# Allow EventBridge to invoke Lambda
# -------------------------

resource "aws_lambda_permission" "eventbridge" {
  statement_id = "AllowEventBridge"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.ec2_notification.function_name

  principal = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.ec2_running.arn
}
