variable "aws-lambda-function-express-like-lambda-example-arn" {
  description = "express-like-lambda-example Lambda ARN"
  type = string
}

variable "aws-lambda-function-express-like-lambda-example-invoke-arn" {
  description = "express-like-lambda-example Lambda invoke ARN"
  type = string
}


variable "domain_name" {
  description = "url"
  // default = "dsldemo.site"
  // default = "vama-dsl.com"
  type = string
}

variable "domain_host_header" {
  // default = "lambda"
    type = string
}