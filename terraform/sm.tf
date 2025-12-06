resource "aws_secretsmanager_secret" "aws_sm_secrets" {
  name                    = "external-secrets/aws-access"
  description             = "secrets manager access"
  recovery_window_in_days = 7
  tags = merge(
    var.default_tags,
    {
      Name = "secret-manager"
    }
  )
}

resource "aws_secretsmanager_secret" "renovate_secrets" {
  name                    = "homelab/renovate"
  description             = "renovate secrets"
  recovery_window_in_days = 7
  tags = merge(
    var.default_tags,
    {
      Name = "secret-manager"
    }
  )
}

resource "aws_secretsmanager_secret" "tailscale_secrets" {
  name                    = "homelab/tailscale"
  description             = "tailscale secrets"
  recovery_window_in_days = 7
  tags = merge(
    var.default_tags,
    {
      Name = "secret-manager"
    }
  )
}

resource "aws_secretsmanager_secret" "grafana_secrets" {
  name                    = "homelab/grafana"
  description             = "grafana secrets"
  recovery_window_in_days = 7
  tags = merge(
    var.default_tags,
    {
      Name = "secret-manager"
    }
  )
}
