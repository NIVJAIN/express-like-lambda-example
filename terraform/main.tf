terraform {
  backend "s3" {
    key="LAMBDA/expressapp.tfstate"
    bucket="ecs-fargate-terraform-remote-state-jain"
    region="ap-southeast-1"
  }
}

module "archive" {
  source = "./modules/archive"
}


module "iam" {
  source = "./modules/iam"
}

module "lambda" {
  source                                       = "./modules/lambda"
  data-archive-file-placeholder-output-path    = module.archive.data-archive-file-placeholder-output-path
  aws-iam-role-express-like-lambda-example-arn = module.iam.aws-iam-role-express-like-lambda-example-arn
}

module "api-gateway" {
  source                                                     = "./modules/api-gateway"
  aws-lambda-function-express-like-lambda-example-arn        = module.lambda.aws-lambda-function-express-like-lambda-example-arn
  aws-lambda-function-express-like-lambda-example-invoke-arn = module.lambda.aws-lambda-function-express-like-lambda-example-invoke-arn
  domain_name               = var.domain_name
  domain_host_header           = var.domain_host_header

}

variable "domain_name" {
  description = "url"
  type = string
  default = "vama-dsl.com"
}

variable "domain_host_header" {
    type = string
    default = "lambda"
}



# Set the generated URL as an output. Run `terraform output url` to get this.
output "endpoint" {
  value = module.api-gateway.endpoint
}

output "public_url" {
  value = module.api-gateway.public_url
}
