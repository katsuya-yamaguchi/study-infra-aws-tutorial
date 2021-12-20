output "s3_logging_bucket" {
  value = aws_s3_bucket.logging.bucket
}

output "ssl_certificate_study_infra_tk_arn" {
  value = aws_acm_certificate.study_infra_tk.arn
}
