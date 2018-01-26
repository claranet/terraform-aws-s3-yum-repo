# terraform-aws-s3-yum-repo

This module manages a YUM repository on S3. It uses CodeBuild to build the repository. It uses Lambda to trigger a build when files have been uploaded.

## Usage

```js
resource "aws_s3_bucket" "yum_repo" {
  bucket = "yum-repo"
  acl    = "private"
}

module "yum_repo" {
  source = "github.com/claranet/terraform-aws-s3-yum-repo"

  codebuild_name = "yum-repo"
  repo_bucket    = "${aws_s3_bucket.yum_repo.bucket}"
  repo_dir       = "yum-repo"
}
```

## Multiple repos in one bucket

Due to limitations of S3 bucket notifications in Terraform, this module does not support multiple repos in one bucket. Use separate buckets instead.

## Helper modules

* [codebuild-lambda](./modules/codebuild-lambda)
  * Use this to invoke a Lambda function after CodeBuild finishes building the YUM repository.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| build_timeout | Maximum number of minutes for the build to run before timing out | string | `5` | no |
| codebuild_name | CodeBuild project name | string | - | yes |
| repo_bucket | S3 bucket for the repo | string | - | yes |
| repo_dir | S3 key for the repo directory, no leading or trailing slashes | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| codebuild_name | CodeBuild project name |
| repo_bucket | S3 bucket for the repo |
| repo_bucket_arn | S3 bucket ARN |
| repo_dir | S3 key for the repo directory |
| repo_dir_arn | S3 bucket and directory ARN |
