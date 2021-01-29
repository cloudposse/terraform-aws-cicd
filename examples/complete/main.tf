provider "aws" {
  region = var.region
}

module "cicd" {
  source                                = "../../"
  region                                = var.region
  github_oauth_token                    = var.github_oauth_token
  repo_owner                            = var.repo_owner
  repo_name                             = var.repo_name
  branch                                = var.branch
  poll_source_changes                   = var.poll_source_changes
  environment_variables                 = var.environment_variables
  codebuild_cache_bucket_suffix_enabled = var.codebuild_cache_bucket_suffix_enabled
  force_destroy                         = var.force_destroy
  cache_type                            = var.cache_type

  context = module.this.context
}
