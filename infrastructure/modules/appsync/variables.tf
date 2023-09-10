variable "commons" {}
variable "name" {}
variable "schema_file" {}
variable "dynamodb" {}
variable "function" {}
variable "resolver" {}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
  ])
}
