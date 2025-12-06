# --- secrets manager policy ---
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

# --- service user ---
resource "aws_iam_user" "sm" {
  name = "k8s-external-secrets-manager-user"
  path = "/service/"
}

resource "aws_iam_access_key" "sm" {
  user = aws_iam_user.sm.name
}

resource "aws_iam_user_policy" "sm_user_read_only" {
  name   = "sm-user-read-only"
  user   = aws_iam_user.sm.name
  policy = data.aws_iam_policy_document.sm_read_secrets.json
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
