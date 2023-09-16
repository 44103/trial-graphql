variable "name" {}
variable "data_sources" {
  type = object({
    dynamodb = map(any)
    lambda   = map(any)
  })
}
variable "graphql_api" {}

locals {
  iam_name = join("_", ["appsync", var.name])
}
