resource "aws_appsync_graphql_api" "_" {
  authentication_type = "API_KEY"
  name                = local.name
  schema              = file(var.schema_file)
}

resource "aws_appsync_api_key" "_" {
  api_id = aws_appsync_graphql_api._.id
}

module "data_source" {
  source       = "./datasource"
  name         = local.name
  data_sources = var.data_source
  graphql_api  = aws_appsync_graphql_api._

}

resource "aws_appsync_resolver" "_" {
  for_each    = var.resolvers
  api_id      = aws_appsync_graphql_api._.id
  data_source = module.data_source.datasource[each.value.data_source].name
  field       = each.key
  type        = each.value.type
  kind        = each.value.kind
  code        = file(each.value.code)

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}
