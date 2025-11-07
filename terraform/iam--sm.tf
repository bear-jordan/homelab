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

resource "aws_iam_role" "sm" {
  name = "k8s-secrets-manager-role"

  assume_role_policy = data.aws_iam_policy_document.sm_trust.json
}


resource "aws_iam_role_policy_attachment" "ssm_readonly" {
  role       = aws_iam_role.sm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_user" "sm" {
  name = "k8s-external-secrets-manager-user"
  path = "/service/"
}

resource "aws_iam_access_key" "sm" {
  user = aws_iam_user.sm.name
}

output "sm_secret_id" {
  value     = aws_iam_access_key.sm.id
  sensitive = true
}

output "sm_secret_secret" {
  value     = aws_iam_access_key.sm.secret
  sensitive = true
}
