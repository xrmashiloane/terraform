#
# lambda assume role policy
#

# trust relationships
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
  statement {
    actions = ["ssm:GetParameter"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]

    }
    resources = [aws_ssm_parameter.access_key.arn]
  }
  statement {
    actions = ["sns:Publish"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    resources = [aws_sns_topic.results_updates.arn]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}
