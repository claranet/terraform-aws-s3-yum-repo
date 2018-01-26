# Create the IAM role.

resource "aws_iam_role" "codebuild" {
  name               = "${var.codebuild_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

# Create the IAM policy.

resource "aws_iam_policy" "codebuild" {
  name        = "${var.codebuild_name}"
  path        = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"
  policy      = "${data.aws_iam_policy_document.codebuild.json}"
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket_object.source.bucket}",
      "arn:aws:s3:::${aws_s3_bucket_object.source.bucket}/${aws_s3_bucket_object.source.key}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.repo_bucket}",
      "arn:aws:s3:::${var.repo_bucket}/${var.repo_dir == "" ? "" : "${var.repo_dir}/"}*",
    ]
  }
}

# Attach the policy to the role.

resource "aws_iam_policy_attachment" "codebuild" {
  name       = "${var.codebuild_name}"
  policy_arn = "${aws_iam_policy.codebuild.arn}"
  roles      = ["${aws_iam_role.codebuild.id}"]
}
