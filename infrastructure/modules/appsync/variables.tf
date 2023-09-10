variable "commons" {}
variable "name" {}
variable "schema_file" {}
variable "dynamodb" {}
variable "resolvers" {
  type = map(object({
    type = string
    kind = string
    code = string
  }))
}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
  ])
}
