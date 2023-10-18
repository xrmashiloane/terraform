#Create Secure String
resource "aws_ssm_parameter" "api_access_key" {
  name        = "api_access_key_value"
  description = "Access key for API"
  type        = "SecureString"
  value       = var.api_access_key_value
}