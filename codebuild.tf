# Create the CodeBuild project.

resource "aws_codebuild_project" "yum_repo" {
  name          = "${var.codebuild_name}"
  build_timeout = "${var.build_timeout}"
  service_role  = "${aws_iam_role.codebuild.arn}"

  source {
    type     = "S3"
    location = "${aws_s3_bucket_object.source.bucket}/${aws_s3_bucket_object.source.key}"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/eb-python-2.7-amazonlinux-64:2.3.2"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "REPO_S3_URL"
      value = "s3://${var.repo_bucket}/${var.repo_dir}"
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }
}
