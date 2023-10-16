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

#Get account details for use with KMS policy 

data "aws_caller_identity" "current" {}

#Update role with permission to send SNS Notifications

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid       = "SendNotification"
    actions   = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.results_updates.arn
    ]
  }
  statement {
    sid       = "DecryptKMS"
    actions   = [
      "kms:Decrypt"
    ]
    resources = [
      "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }
  statement {
    sid       = "GetSecureParameter"
    actions   = [
      "ssm:GetParameter"
    ]
    resources = [
      aws_ssm_parameter.api_access_key.arn
    ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.project_name}-policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

