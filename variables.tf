variable "codebuild_name" {
  description = "CodeBuild project name"
  type        = "string"
}

variable "repo_bucket" {
  description = "S3 bucket for the repo"
  type        = "string"
}

variable "repo_dir" {
  description = "S3 key for the repo directory, no leading or trailing slashes"
  type        = "string"
  default     = ""
}

variable "build_timeout" {
  description = "Maximum number of minutes for the build to run before timing out"
  type        = "string"
  default     = "5"
}
