# Create a Lambda function that starts CodeBuild.

module "auto_build_yum_repo" {
  source = "github.com/claranet/terraform-aws-lambda?ref=v0.7.0"

  function_name = "${var.codebuild_name}-auto-build"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.6"
  timeout       = 300

  source_path = "${path.module}/lambda.py"

  attach_policy = true
  policy        = "${data.aws_iam_policy_document.auto_build_yum_repo.json}"

  environment {
    variables {
      CODEBUILD_PROJECT_NAME = "${aws_codebuild_project.yum_repo.name}"
    }
  }
}

data "aws_iam_policy_document" "auto_build_yum_repo" {
  statement {
    effect = "Allow"

    actions = [
      "codebuild:StartBuild",
    ]

    resources = [
      "${aws_codebuild_project.yum_repo.id}",
    ]
  }
}

# Allow the S3 bucket to invoke the Lambda function.

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${module.auto_build_yum_repo.function_arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.repo_bucket}"
}

# Trigger the Lambda function when files are changed in the S3 bucket.

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${var.repo_bucket}"

  lambda_function {
    lambda_function_arn = "${module.auto_build_yum_repo.function_arn}"

    events = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:*",
    ]

    filter_prefix = "${var.repo_dir}/"
    filter_suffix = ".rpm"
  }
}
