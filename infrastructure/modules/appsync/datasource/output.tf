output "datasource" {
  value = merge(
    aws_appsync_datasource.dynamodb,
    aws_appsync_datasource.lambda
  )
}

