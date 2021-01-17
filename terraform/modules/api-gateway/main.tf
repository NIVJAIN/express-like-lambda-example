resource "aws_api_gateway_rest_api" "express-like-lambda-example" {
  name = "express-like-lambda-example"
}

resource "aws_api_gateway_method" "proxy-root" {
  rest_api_id   = aws_api_gateway_rest_api.express-like-lambda-example.id
  resource_id   = aws_api_gateway_rest_api.express-like-lambda-example.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "express-like-lambda-example" {
  rest_api_id             = aws_api_gateway_rest_api.express-like-lambda-example.id
  resource_id             = aws_api_gateway_method.proxy-root.resource_id
  http_method             = aws_api_gateway_method.proxy-root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.aws-lambda-function-express-like-lambda-example-invoke-arn
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.express-like-lambda-example.id
  parent_id   = aws_api_gateway_rest_api.express-like-lambda-example.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.express-like-lambda-example.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.express-like-lambda-example.id
  resource_id             = aws_api_gateway_method.proxy.resource_id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.aws-lambda-function-express-like-lambda-example-invoke-arn
}

resource "aws_api_gateway_deployment" "express-like-lambda-example_v1" {
  depends_on = [
    aws_api_gateway_integration.express-like-lambda-example
  ]
  rest_api_id = aws_api_gateway_rest_api.express-like-lambda-example.id
  stage_name  = "v1"
}



data "aws_route53_zone" "ecs_domain" {
  name         = var.domain_name
  private_zone = false
}
// data "aws_route53_zone" "ecs_domain" {
//   name         = data.terraform_remote_state.platform.outputs.ecs_domain_name
//   private_zone = false
// }
data "aws_acm_certificate" "ecs_domain_certificate" {
  domain      = "*.${var.domain_name}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_api_gateway_domain_name" "example" {
  // domain_name              = "lambda.vama-dsl.com"
  domain_name = format("%s.%s",var.domain_host_header, var.domain_name)
  regional_certificate_arn = "arn:aws:acm:ap-southeast-1:541320134486:certificate/12e56969-b62c-4039-96c2-14268acf5906"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Example DNS record using Route53.
# Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "example" {
  // name    = aws_api_gateway_domain_name.example.domain_name
  // name = var.ecs_domain_name
  name = format("%s.%s",var.domain_host_header, var.domain_name)
  type    = "A"
  zone_id = data.aws_route53_zone.ecs_domain.id

  alias {
    evaluate_target_health = false
    name                   = aws_api_gateway_domain_name.example.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "billing" {
  api_id      = aws_api_gateway_rest_api.express-like-lambda-example.id
  stage_name  = aws_api_gateway_deployment.express-like-lambda-example_v1.stage_name
  domain_name = aws_api_gateway_domain_name.example.domain_name
}

output "endpoint" {
  value = aws_api_gateway_deployment.express-like-lambda-example_v1.invoke_url
}

output "public_url" {
  value = aws_route53_record.example.name
}