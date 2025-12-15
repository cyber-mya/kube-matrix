terraform {
  backend "s3" {
    bucket         = "aderona"
    key            = "envs/dev/vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "km-terraform-locks"
    encrypt        = true
  }
}
