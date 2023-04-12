provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "backend" {
  count = var.create_vpc ? 1 : 0 #Count a meta argument that changes/alters the state/behavior of a resource
#We are using with "?" a tenary operator to check for the condition of our defined variable
# ? --> conditions, checks if the create_vpc = true it should create one bucket else dont create which is "0"
  bucket =  random_pet.pet_name.id    #bootcamp30-$(random-number)-(yourname)
  #We used the resource random_pet to generate the name and a range of number

  tags = {
    Name = "Dev"
    Environment = "HR"
  }
}

resource "aws_s3_bucket_ownership_controls" "owner_controls" {
  bucket = aws_s3_bucket.backend[0].id #b/c of the condition we added we had to introduce index to anywhere we see bucket referenced
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "myacl" {
  depends_on = [aws_s3_bucket_ownership_controls.owner_controls]

  bucket = aws_s3_bucket.backend[0].id
  acl    = "private"
}

resource "aws_kms_key" "backendkey" {
  description             = "KMS key for backend bucket"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend[0].id
  rule {
    apply_server_side_encryption_by_default {
    sse_algorithm = "aws:kms"
    kms_master_key_id = aws_kms_key.backendkey.arn
  }
}
}
#Since versioning is deprecated by passing it directly, we are creating it as a resource..
resource "aws_s3_bucket_versioning" "backend_version" {
  bucket = aws_s3_bucket.backend[0].id
  versioning_configuration {
    status = "Enabled"
  }
}
#Changing the bucket name to random names

resource "random_pet" "pet_name" { #randompet has prefix can any name length can be any number
  prefix = "bootcamp30"
  length = 2

}

/*resource "random_integer" "num" {
  max = 100
  min = 2
  
}*/
#Lets use conditions to determine weather a bucket should be created or not

variable "create_vpc" {
  type = bool
  default = true
}