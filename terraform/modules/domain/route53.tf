// data "aws_route53_zone" "ecs_domain" {
//   name         = var.ecs_domain_name
//   private_zone = false
// }

// data "aws_acm_certificate" "ecs_domain_certificate" {
//   domain      = "*.${var.ecs_domain_name}"
//   types       = ["AMAZON_ISSUED"]
//   most_recent = true
// }

// // data "aws_route53_zone" "ecs_domain" {
// //   name         = data.terraform_remote_state.platform.outputs.ecs_domain_name
// //   private_zone = false
// // }

// resource "aws_route53_record" "ecs_load_balancer_record" {
//   name    = "${var.ecs_service_name}.${var.ecs_domain_name}"
//   type    = "A"
//   zone_id = data.aws_route53_zone.ecs_domain.zone_id

//   alias {
//     evaluate_target_health = false
//     name                   = data.terraform_remote_state.platform.outputs.alb_dns_name
//     zone_id                = data.terraform_remote_state.platform.outputs.alb_zone_id
//   }
// }
