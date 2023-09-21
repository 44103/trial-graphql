data "aws_caller_identity" "_" {}

module "appsync" {
  source      = "../../modules/appsync"
  commons     = local.commons
  name        = "post"
  schema_file = "./schema.graphql"
  data_source = {
    dynamodb = {
      post = module.dynamodb
    }
  }
  resolvers = {
    getPost = {
      type        = "Query"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/get_post.js"
    }
    allPost = {
      type        = "Query"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/all_post.js"
    }
    allPostsByAuthor = {
      type        = "Query"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/all_posts_by_author.js"
    }
    allPostsByTag = {
      type        = "Query"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/all_posts_by_tag.js"
    }
    addTag = {
      type        = "Mutation"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/add_tag.js"
    }
    removeTag = {
      type        = "Mutation"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/remove_tag.js"
    }
    deletePost = {
      type        = "Mutation"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/delete_post.js"
    }
    vote = {
      type        = "Mutation"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/vote.js"
    }
    updatePost = {
      type        = "Mutation"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/update_post.js"
    }
    addPost = {
      type        = "Mutation"
      data_source = "post"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/add_post.js"
    }
  }
}

module "dynamodb" {
  source        = "../../modules/dynamodb"
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
