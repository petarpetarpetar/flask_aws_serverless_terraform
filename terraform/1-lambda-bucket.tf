# Create a random pet name for the lambda bucket
resource "random_pet" "lambda_bucket_name" {
  prefix = "lambda"
  length = 2
}

# Create a bucket for the lambda function
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  force_destroy = true
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "lambda_bucket" {
  bucket = aws_s3_bucket.lambda_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}