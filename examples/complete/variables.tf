variable "region" {
  type        = string
  description = "AWS region"
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub Oauth Token"
}

variable "repo_owner" {
  type        = string
  description = "GitHub Organization or Person name"
}

variable "repo_name" {
  type        = string
  description = "GitHub repository name of the application to be built (and deployed to Elastic Beanstalk if configured)"
}

variable "branch" {
  type        = string
  description = "Branch of the GitHub repository, _e.g._ `master`"
}

variable "poll_source_changes" {
  type        = bool
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

variable "environment_variables" {
  type = list(object(
    {
      name  = string
      value = string
  }))

  default = [
    {
      name  = "NO_ADDITIONAL_BUILD_VARS"
      value = "TRUE"
  }]

  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build"
}

variable "codebuild_cache_bucket_suffix_enabled" {
  type        = bool
  description = "The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value"
}

variable "force_destroy" {
  type        = bool
  description = "Force destroy the CI/CD S3 bucket even if it's not empty"
}
