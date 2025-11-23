data "aws_iam_policy_document" "sm_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.sm.arn]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "sm_policy" {
  name        = "k8s-secrets-manager-readonly"
  path        = "/"
  description = "Give k8s access to retrive secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets",
          "secretsmanager:GetResourcePolicy"
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


resource "aws_iam_policy" "sm_user_assume_role" {
  name        = "k8s-external-secrets-assume-role"
  description = "Allow k8s to assume k8s-secrets-manager-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.sm.arn
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "sm_user_assume_role_attach" {
  user       = aws_iam_user.sm.name
  policy_arn = aws_iam_policy.sm_user_assume_role.arn
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


output "sm_access_key_id" {
  value     = aws_iam_access_key.sm.id
  sensitive = true
}

output "sm_secret_access_key" {
  value     = aws_iam_access_key.sm.secret
  sensitive = true
}

output "sm_role_arn" {
  value     = aws_iam_role.sm.arn
  sensitive = true
}
