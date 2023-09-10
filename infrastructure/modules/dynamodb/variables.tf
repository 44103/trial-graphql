variable "commons" {}
variable "name" {}
variable "partition_key" {}
variable "sort_key" {
  default = null
}
variable "attributes" {}
variable "lsi_parameters" {
  type = list(object({
    name               = string
    projection_type    = string
    sort_key           = string
    non_key_attributes = optional(list(string))
  }))
  default = []
}
variable "gsi_parameters" {
  type = list(object({
    name            = string
    partition_key   = string
    sort_key        = optional(string)
    projection_type = string
  }))
  default = []
}

locals {
  name = join("_", [
    var.commons.workspace,
    var.name,
    var.commons.service,
    var.commons.project
  ])
}
