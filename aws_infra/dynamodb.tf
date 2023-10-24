#Resource to create dynamodb table 
resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "${var.project_name}-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Location"

  attribute {
    name = "Location"
    type = "S"
  }
  attribute {
    name = "Current_Temp"
    type = "N"
  }
}

