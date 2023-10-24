#Resource to create dynamodb table 
resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "${var.project_name}-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "location"

  attribute {
    name = "location"
    type = "S"
  }
}

locals {
  city_list = csvdecode(file("${path.module}/cities.csv"))
  current_temp = 0
}

resource "aws_dynamodb_table_item" "city_put" {
  for_each = var.load_city_data ? {for row in local.city_list : row.city => row } : {}

  table_name = aws_dynamodb_table.dynamodb-table.name
  hash_key = aws_dynamodb_table.dynamodb-table.hash_key

  item = <<EOF
  {
    "location": {"S": "${each.value.city}"},
    "current_temp": {"N": "${local.current_temp}"}
  }
  EOF

  #Ignore subsequent changes to items. Remember to set flag to false after data load
  lifecycle {
    ignore_changes = [ item ]
  }
}