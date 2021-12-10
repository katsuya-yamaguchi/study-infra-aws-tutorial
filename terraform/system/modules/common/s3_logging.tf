resource "aws_s3_bucket" "logging" {
  bucket = var.logging_bucket["name"]
  acl    = "private"
  versioning {
    enabled = false
  }
  lifecycle_rule {
    enabled = true
    expiration {
      days = var.logging_bucket["expiration_days"]
    }
    transition {
      days          = var.logging_bucket["transition_days"]
      storage_class = var.logging_bucket["transition_storage_class"]
    }
  }
  # 遠隔地へのデータ転送の高速化機能。使用しない。
  acceleration_status = "Suspended"

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" # SSE-S3を使用。
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
