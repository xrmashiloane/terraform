resource "aws_ssm_parameter" "access_key" {
  name        = "access_key"
  description = "Access key for weather API"
  type        = "SecureString"
  value       = var.access_key_value
}