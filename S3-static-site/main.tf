#Create S3 buckit

resource "aws_s3_bucket" "test-buckit" {
  bucket = var.buckitname

  tags = {
    name        = "my-buckit"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket-ownership" {
  bucket = aws_s3_bucket.test-buckit.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "Access-block" {
  bucket = aws_s3_bucket.test-buckit.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket-ownership,
    aws_s3_bucket_public_access_block.Access-block,
    ]

  bucket = aws_s3_bucket.test-buckit.id
  acl    = "public-read"
}
