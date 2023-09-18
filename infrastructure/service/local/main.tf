data "aws_caller_identity" "_" {}

module "appsync" {
  source      = "../../modules/appsync"
  commons     = local.commons
  name        = "channel"
  schema_file = "./schema.graphql"
  data_source = {
    local = {
      page = null
    }
  }
  resolvers = {
    publish = {
      type        = "Mutation"
      data_source = "page"
      kind        = "UNIT"
      code        = "../../functions/appsync/resolver/pubsub.js"
    }
  }
}
