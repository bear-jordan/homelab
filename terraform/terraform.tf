terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.15"
    }
  }
  required_version = ">= 1.13.3"
  backend "s3" {
    bucket = "tf-state-xa2jioz9"
    key    = "tf.state"
    region = "us-east-1"
  }
}
