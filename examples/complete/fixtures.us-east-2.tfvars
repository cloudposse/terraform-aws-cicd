region = "us-east-2"

namespace = "eg"

stage = "test"

name = "cicd"

github_oauth_token = "test"

repo_owner = "cloudposse"

repo_name = "terraform-aws-cicd"

branch = "master"

poll_source_changes = false

codebuild_cache_bucket_suffix_enabled = false

force_destroy = true

environment_variables = [
  {
    name  = "APP_URL"
    value = "https://app.example.com"
  },
  {
    name  = "COMPANY_NAME"
    value = "Cloud Posse"
  },
  {
    name  = "TIME_ZONE"
    value = "America/Los_Angeles"

  }
]
