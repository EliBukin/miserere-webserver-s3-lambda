
resource "aws_s3_bucket_object" "object" {
  bucket = var.bucket_name
  key    = "packageParamiko.zip"
  source = "modules/s3-bucket/files/packageParamiko.zip"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  #etag = md5("files/packageParamiko.zip")
  depends_on = [aws_s3_bucket.b]
}

resource "aws_s3_bucket_object" "object2" {
  bucket = var.bucket_name
  key    = "lambda-payload.zip"
  source = "modules/s3-bucket/files/lambda-payload.zip"
  depends_on = [aws_s3_bucket.b]
}

resource "aws_s3_bucket_object" "object3" {
  bucket = var.bucket_name
  key    = "ssb.pem"
  source = "modules/s3-bucket/files/ssb.pem"
  depends_on = [aws_s3_bucket.b]
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "miserere-for-paramiko"
    Environment = "Dev"
  }
}
