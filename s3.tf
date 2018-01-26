# Create an S3 bucket and object (zip file containing just the buildspec)
# so that CodeBuild can use it as a build source.

resource "random_id" "bucket_name" {
  byte_length = 8
  prefix      = "${var.codebuild_name}-"
}

resource "aws_s3_bucket" "codebuild" {
  bucket = "${random_id.bucket_name.hex}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

data "archive_file" "source" {
  type        = "zip"
  source_file = "${path.module}/buildspec.yml"
  output_path = ".terraform/terraform-aws-s3-yum-repo-${var.codebuild_name}.zip"
}

resource "aws_s3_bucket_object" "source" {
  bucket = "${aws_s3_bucket.codebuild.bucket}"
  key    = "source.zip"
  source = "${data.archive_file.source.output_path}"
  etag   = "${data.archive_file.source.output_md5}"
}
