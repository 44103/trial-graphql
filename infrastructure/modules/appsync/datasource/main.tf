resource "aws_iam_role" "_" {
  name = local.iam_name
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

resource "aws_iam_role_policy" "dynamodb" {
  for_each = var.data_sources.dynamodb
  name     = local.iam_name
  role     = aws_iam_role._.id
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
          each.value.table.arn,
          "${each.value.table.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda" {
  for_each = var.data_sources.lambda
  name     = local.iam_name
  role     = aws_iam_role._.id
  policy = jsonencode({
    Statement : [
      {
        Action : [
          "lambda:InvokeFunction"
        ],
        Effect : "Allow",
        Resource : [
          each.value.function.arn
        ]
      }
    ]
  })
}

resource "aws_appsync_datasource" "dynamodb" {
  for_each         = var.data_sources.dynamodb
  api_id           = var.graphql_api.id
  name             = each.key
  type             = "AMAZON_DYNAMODB"
  service_role_arn = aws_iam_role._.arn

  dynamodb_config {
    table_name = each.value.table.name
  }
}

resource "aws_appsync_datasource" "lambda" {
  for_each         = var.data_sources.lambda
  api_id           = var.graphql_api.id
  name             = each.key
  type             = "AWS_LAMBDA"
  service_role_arn = aws_iam_role._.arn

  lambda_config {
    function_arn = each.value.function.arn
  }
}
