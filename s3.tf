// Bucket Block
//https://cloudanddevopstech.com/2020/11/01/terraform-aws-ec2-with-ssm-agent-installed/
resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.bucket_name}.${var.environment}.${aws_instance.web_server.id}"
  tags = {
    Environment = var.environment
  }
}
resource "aws_s3_bucket_acl" "bucket_log_acl" {
  bucket = aws_s3_bucket.log_bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.log_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_public_access_block" "bucket_public_access_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "AllowCloudwatch",
  "Statement": [
    {
        "Action": "s3:GetBucketAcl",
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.bucket_name}.${var.environment}.${aws_instance.web_server.id}",
        "Principal": { "Service": "logs.${var.region}.amazonaws.com" }
    },
    {
        "Action": "s3:PutObject" ,
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.bucket_name}.${var.environment}.${aws_instance.web_server.id}/randomprefix1837/*",
        "Condition": { "StringEquals": { "s3:x-amz-acl": "bucket-owner-full-control" } },
        "Principal": { "Service": "logs.${var.region}.amazonaws.com" }
    }
  ]
}
POLICY
}
