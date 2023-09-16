data "aws_caller_identity" "_" {}

module "lambda_blog" {
  source  = "../../modules/lambda"
  commons = local.commons
  name    = "blog"
}
