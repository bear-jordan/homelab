data "aws_iam_policy_document" "sm_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sm.amazonaws.com"]
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

