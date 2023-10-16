resource "aws_ssm_parameter" "api_access_key" {
  name        = "api_access_key"
  description = "Access key for weather API"
  type        = "SecureString"
  value       = var.api_access_key_value
}