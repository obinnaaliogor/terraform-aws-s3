provider "aws" {
  region = "us-east-2"
}
# Create a KMS key for S3 server-side encryption
resource "aws_kms_key" "s3_key" {
  description = "KMS key for S3 server-side encryption"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "obinnatfstate-bucket"
  acl = "private"
  versioning {
    enabled = true
  }
   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_key.key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name   =  "TfBucket"
    Environment = "Dev"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.mybucket.id
}

