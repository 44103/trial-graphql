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
        Resource : "${var.dynamodb.table.arn}:*"
      }
    ]
  })
}

resource "aws_appsync_graphql_api" "_" {
  authentication_type = "API_KEY"
  name                = local.name
  schema              = file(var.schema_file)
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

resource "aws_appsync_function" "_" {
  api_id      = aws_appsync_graphql_api._.id
  data_source = aws_appsync_datasource._.name
  name        = local.name
  code        = file(var.function)

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }
}

resource "aws_appsync_resolver" "_" {
  api_id = aws_appsync_graphql_api._.id
  type   = "Query"
  field  = "getTodoList"
  kind   = "PIPELINE"
  code   = file(var.resolver)

  runtime {
    name            = "APPSYNC_JS"
    runtime_version = "1.0.0"
  }

  pipeline_config {
    functions = [
      aws_appsync_function._.function_id,
    ]
  }
}
