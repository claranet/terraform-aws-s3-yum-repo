# terraform-aws-s3-yum-repo codebuild-lambda

This module sets up CloudWatch events to trigger a Lambda function when CodeBuild events occur. For example, you could automatically run a deployment Lambda function after CodeBuild successfully builds a YUM repository.

## Usage

```js
module "yum_repo" {
  source = "github.com/claranet/terraform-aws-s3-yum-repo"

  codebuild_name = "yum-repo"
  repo_bucket    = "${aws_s3_bucket.yum_repo.bucket}"
  repo_dir       = "yum-repo"
}

module "yum_repo_build_events" {
  source = "github.com/claranet/terraform-aws-s3-yum-repo//modules/codebuild-lambda"

  codebuild_name   = "${module.yum_repo.codebuild_name}"
  codebuild_status = ["SUCCEEDED"]

  lambda_function_arn  = "${var.deploy_function_arn}"
  lambda_function_name = "${var.deploy_function_name}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| codebuild_name | The CodeBuild project name | string | - | yes |
| codebuild_status | A list of CodeBuild status values (e.g. SUCCEEDED) that should trigger the Lambda function | list | - | yes |
| lambda_function_arn | The ARN of the Lambda function to trigger | string | - | yes |
| lambda_function_name | The name of the Lambda function to trigger | string | - | yes |
