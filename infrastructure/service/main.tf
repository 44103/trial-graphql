data "aws_caller_identity" "_" {}

module "appsync" {
  source      = "../modules/appsync"
  commons     = local.commons
  name        = "post"
  schema_file = "./schema.graphql"
  dynamodb    = module.dynamodb
  resolvers = {
    getPost = {
      type = "Query"
      kind = "UNIT"
      code = "../functions/appsync/resolver/get_post.js"
    }
    deletePost = {
      type = "Mutation"
      kind = "UNIT"
      code = "../functions/appsync/resolver/delete_post.js"
    }
    vote = {
      type = "Mutation"
      kind = "UNIT"
      code = "../functions/appsync/resolver/vote.js"
    }
    updatePost = {
      type = "Mutation"
      kind = "UNIT"
      code = "../functions/appsync/resolver/update_post.js"
    }
    addPost = {
      type = "Mutation"
      kind = "UNIT"
      code = "../functions/appsync/resolver/add_post.js"
    }
  }
}

module "dynamodb" {
  source        = "../modules/dynamodb"
  commons       = local.commons
  name          = "post"
  partition_key = "id"
  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "author"
      type = "S"
    }
  ]
  gsi_parameters = [
    {
      name            = "author"
      projection_type = "ALL"
      partition_key   = "author"
    }
  ]
}
