resource "aws_acm_certificate" "study_infra_tk" {
  domain_name       = "study-infra.tk"
  subject_alternative_names = ["*.study-infra.tk"]
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "study_infra_tk" {
  certificate_arn = aws_acm_certificate.study_infra_tk.arn
  validation_record_fqdns = [ for record in aws_route53_record.acm_validation_study_infra_tk : record.fqdn]
}
