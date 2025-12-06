# --- trust policy ---
data "aws_iam_policy_document" "sm_trust" {
  statement {
    sid    = "AllowServiceUserAssumeRole"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.sm.arn]
    }

    actions = ["sts:AssumeRole"]
  }

  statement {
    sid    = "AllowSsoAdminAssumeRole"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        local.sso_admin_role
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}


# --- secrets manager role ---
data "aws_iam_policy_document" "sm_read_secrets" {
  statement {
    sid    = "SecretsManagerReadOnly"
    effect = "Allow"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecrets",
      "secretsmanager:GetResourcePolicy",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "sm" {
  name               = "k8s-secrets-manager-role"
  assume_role_policy = data.aws_iam_policy_document.sm_trust.json
}

resource "aws_iam_role_policy" "sm_read_secrets" {
  name   = "k8s-secrets-manager-readonly"
  role   = aws_iam_role.sm.id
  policy = data.aws_iam_policy_document.sm_read_secrets.json
}


# --- service user ---
resource "aws_iam_user" "sm" {
  name = "k8s-external-secrets-manager-user"
  path = "/service/"
}

resource "aws_iam_access_key" "sm" {
  user = aws_iam_user.sm.name
}

data "aws_iam_policy_document" "sm_user_assume_role" {
  statement {
    sid    = "AllowAssumeSecretsManagerRole"
    effect = "Allow"

    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.sm.arn]
  }
}

resource "aws_iam_user_policy" "sm_user_assume_role" {
  name   = "k8s-external-secrets-assume-role"
  user   = aws_iam_user.sm.name
  policy = data.aws_iam_policy_document.sm_user_assume_role.json
}


# --- outputs ---
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
