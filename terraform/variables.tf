variable "default_tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Environment = "prod"
    Project     = "homelab"
  }
}
