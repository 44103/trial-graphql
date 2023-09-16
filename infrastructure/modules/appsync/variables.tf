variable "commons" {}
variable "name" {}
variable "schema_file" {}
variable "dynamodb" {
  default = null
}
variable "lambda" {
  default = null
}
variable "data_source" {
  type = object({
    dynamodb = optional(map(any), {})
    lambda   = optional(map(any), {})
  })
}
variable "resolvers" {
  type = map(object({
    type        = string
    data_source = string
    kind        = string
    code        = string
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
