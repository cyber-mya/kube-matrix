
locals {
  name_prefix = "${var.project}-${var.environment}"
}

resource "aws_ssm_parameter" "db_username" {
  name      = "/${local.name_prefix}/db/username"
  type      = "SecureString"
  value     = var.db_username
  overwrite = true
}


resource "aws_ssm_parameter" "db_endpoint" {
  name      = "/${local.name_prefix}/db/endpoint"
  type      = "String"
  value     = var.db_endpoint
  overwrite = true
}

resource "aws_ssm_parameter" "db_name" {
  name      = "/${local.name_prefix}/db/name"
  type      = "String"
  value     = var.db_name
  overwrite = true
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}




# --------------------------------------
# Store password in SSM
# --------------------------------------
resource "aws_ssm_parameter" "aurora_master_password" {
  name        = "/${var.project}/${var.environment}/db/master_password"
  type        = "SecureString"
  value       = random_password.db_password.result
  overwrite   = true
}
#Read Password
data "aws_ssm_parameter" "db_password" {
  name            = aws_ssm_parameter.aurora_master_password.name
  with_decryption = true
}

#Create password
resource "kubernetes_secret" "db_secret" {
  metadata {
    name      = "db-secret"
    namespace = "default"
  }

  data = {
    password = data.aws_ssm_parameter.db_password.value
  }
}
