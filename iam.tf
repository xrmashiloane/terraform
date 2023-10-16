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

data "aws_iam_policy_document" "sns_policy_doc" {
  statement {
    sid       = "SendNotification"
    actions   = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.results_updates.arn
    ]
  }
}

resource "aws_iam_policy" "sns_send_notification" {
  name   = "${var.project_name}-send-notification"
  policy = data.aws_iam_policy_document.sns_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.sns_send_notification.arn
}
