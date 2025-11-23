data "aws_iam_policy_document" "sm_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["secretsmanager.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "sm_policy" {
  name        = "sm_policy"
  path        = "/"
  description = "Give k8s access to retrive secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetSecretValue*",
          "ssm:Describe*",
          "ssm:Get*",
          "ssm:List*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "sm" {
  name               = "k8s-secrets-manager-role"
  assume_role_policy = data.aws_iam_policy_document.sm_trust.json
}


resource "aws_iam_role_policy_attachment" "ssm_readonly" {
  role       = aws_iam_role.sm.name
  policy_arn = aws_iam_policy.sm_policy.arn
}

resource "aws_iam_user" "sm" {
  name = "k8s-external-secrets-manager-user"
  path = "/service/"
}

resource "aws_iam_access_key" "sm" {
  user = aws_iam_user.sm.name
}
