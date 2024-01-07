resource "aws_s3_bucket" "tf_secrets_bucket" {
  bucket = "seantcanavan_tf_secrets_bucket_${var.stage}"
}

resource "aws_s3_bucket_ownership_controls" "tf_secrets_bucket" {
  bucket = aws_s3_bucket.tf_secrets_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tf_secrets_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.tf_secrets_bucket]

  bucket = aws_s3_bucket.tf_secrets_bucket.id
  acl    = "private"
}

# Bucket Versioning
resource "aws_s3_bucket_versioning" "tf_secrets_bucket" {
  bucket = aws_s3_bucket.tf_secrets_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Server-Side Encryption Configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_secrets_bucket" {
  bucket = aws_s3_bucket.tf_secrets_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
