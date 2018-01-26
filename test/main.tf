terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "random_id" "name" {
  prefix      = "terraform-aws-s3-yum-repo-test-"
  byte_length = 4
}

resource "aws_s3_bucket" "yum_repo" {
  bucket = "${random_id.name.hex}"
  acl    = "private"
}

module "yum_repo" {
  source = "../"

  codebuild_name = "${random_id.name.hex}"
  repo_bucket    = "${aws_s3_bucket.yum_repo.bucket}"
  repo_dir       = "yum-repo"
}
