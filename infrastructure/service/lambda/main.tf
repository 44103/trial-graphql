data "aws_caller_identity" "_" {}

module "lambda" {
  source  = "../../modules/lambda"
  commons = local.commons
  name    = "blog"
}

module "appsync" {
  source      = "../../modules/appsync"
  commons     = local.commons
  name        = "blog"
  schema_file = "./schema.graphql"
  lambda      = module.lambda
  data_source = {
    lambda = {
      blog = module.lambda
    }
  }
  resolvers = {
    getPost = {
      type        = "Query"
      data_source = "blog"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/lambda.js"
    }
    allPosts = {
      type        = "Query"
      data_source = "blog"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/lambda.js"
    }
    addPost = {
      type        = "Mutation"
      data_source = "blog"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/lambda.js"
    }
    relatedPosts = {
      type        = "Post"
      data_source = "blog"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/related_posts.js"
    }
  }
}
