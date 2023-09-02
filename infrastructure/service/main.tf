data "aws_caller_identity" "_" {}

module "dynamodb_todo" {
  source        = "../modules/dynamodb"
  commons       = local.commons
  name          = "todo"
  partition_key = "name"
  attributes = [
    {
      name = "name"
      type = "S"
    }
  ]
}
