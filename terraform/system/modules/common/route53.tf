resource "aws_route53_zone" "study_infra_tk" {
  name = "study-infra.tk"
}

resource "aws_route53_record" "acm_validation_study_infra_tk" {
  for_each = {
    for dvo in aws_acm_certificate.study_infra_tk.domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [each.value.record]
  ttl = 60
  type = each.value.type
  zone_id = aws_route53_zone.study_infra_tk.id
}