output "codebuild_name" {
  description = "CodeBuild project name"
  value       = "${aws_codebuild_project.yum_repo.name}"
}

output "repo_bucket" {
  description = "S3 bucket for the repo"
  value       = "${var.repo_bucket}"
}

output "repo_bucket_arn" {
  description = "S3 bucket ARN"
  value       = "arn:aws:s3:::${var.repo_bucket}"
}

output "repo_dir" {
  description = "S3 key for the repo directory"
  value       = "${var.repo_dir}"
}

output "repo_dir_arn" {
  description = "S3 bucket and directory ARN"
  value       = "arn:aws:s3:::${var.repo_bucket}/${var.repo_dir == "" ? "" : "${var.repo_dir}/"}*"
}
