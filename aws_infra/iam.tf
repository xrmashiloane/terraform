#Get account details for use with KMS policy 

data "aws_caller_identity" "current" {}

#Lamda Execution Role
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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
}

#Update role with permission to send SNS Notifications, access SQS queue itens, decrypt secure parameter
data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid = "SendNotification"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.results_updates.arn
    ]
  }
  statement {
    sid = "DecryptKMS"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
    effect = "Allow"
  }
  statement {
    sid = "GetSecureParameter"
    actions = [
      "ssm:GetParameter*"
    ]
    resources = [
      aws_ssm_parameter.api_access_key_value.arn,
      aws_ssm_parameter.dynamodb_table_name.arn,
      aws_ssm_parameter.sqs_queue_url_value.arn
    ]
    effect = "Allow"
  }
  statement {
    sid = "ReceiveMessegesSQS"
    actions = [
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage",
      "sqs:GetQueueAttributes",
      "sqs:SendMessage"
    ]
    resources = [
      aws_sqs_queue.sqs_queue.arn
    ]
  }
  statement {
    sid = "DynamoDB"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.project_name}-table"
    ]
  }
  statement {
    sid = "WriteLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogDelivery",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

#Create IAM Policy from policy document
resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.project_name}-policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

#Attach IAM policy to Lambda function
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Create new IAM Policy document for EventBridge Scheduler
resource "aws_iam_policy" "sqs_access_policy" {
  name        = "${var.project_name}-sqs-access-policy"
  description = "Policy for EventBridge Scheduler to send messages to SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow"
        Resource = "${aws_sqs_queue.sqs_queue.arn}"
      }
    ]
  })
}
