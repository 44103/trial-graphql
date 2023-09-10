data "aws_caller_identity" "_" {}

module "appsync" {
  source      = "../modules/appsync"
  commons     = local.commons
  name        = "post"
  schema_file = "./schema.graphql"
  dynamodb    = module.dynamodb
  function    = "../functions/appsync/function/get.js"
  resolver    = "../functions/appsync/resolver/get.js"
}

module "dynamodb" {
  source        = "../modules/dynamodb"
  commons       = local.commons
  name          = "todo"
  partition_key = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}
