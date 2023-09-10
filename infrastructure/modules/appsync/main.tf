resource "aws_iam_role" "_" {
  name = local.name
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "appsync.amazonaws.com"
        },
        Effect : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "_" {
  name = local.name
  role = aws_iam_role._.id
  policy = jsonencode({
    Statement : [
      {
        Action : [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
        ],
        Effect : "Allow",
        Resource : [
          "${var.dynamodb.table.arn}",
          "${var.dynamodb.table.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_appsync_graphql_api" "_" {
  authentication_type = "API_KEY"
  name                = local.name
  schema              = file(var.schema_file)
}

resource "aws_appsync_api_key" "_" {
  api_id = aws_appsync_graphql_api._.id
}

resource "aws_appsync_datasource" "_" {
  api_id           = aws_appsync_graphql_api._.id
  name             = local.name
  type             = "AMAZON_DYNAMODB"
  service_role_arn = aws_iam_role._.arn

  dynamodb_config {
    table_name = var.dynamodb.table.name
  }
}

resource "aws_appsync_resolver" "_" {
  for_each    = var.resolvers
  api_id      = aws_appsync_graphql_api._.id
  data_source = aws_appsync_datasource._.name
  field       = each.key
  type        = each.value.type
  kind        = each.value.kind
  code        = file(each.value.code)

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}
