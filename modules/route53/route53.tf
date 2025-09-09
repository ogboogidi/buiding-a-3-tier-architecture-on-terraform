#pull or fetch the hosted zone (the apex doomain) on amazon route 53
data "aws_route53_zone" "my_hosted_domain" {
  name = "momentstravel.org"
}

# create an A record and point it to the ALB using an Alias

resource "aws_route53_record" "A_record" {
  zone_id = data.aws_route53_zone.my_hosted_domain.zone_id
  name = data.aws_route53_zone.my_hosted_domain.name
  type = "A"

  alias {
    name = var.alb_dns_name
    zone_id = var.alb_zone_id
    evaluate_target_health = true
  }
}
