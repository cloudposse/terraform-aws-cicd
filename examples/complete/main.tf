provider "aws" {
  region = var.region
}

module "cicd" {
  source                                = "../../"
  region                                = var.region
  codestar_connection_arn               = var.codestar_connection_arn
  repo_owner                            = var.repo_owner
  repo_name                             = var.repo_name
  branch                                = var.branch
  environment_variables                 = var.environment_variables
  codebuild_cache_bucket_suffix_enabled = var.codebuild_cache_bucket_suffix_enabled
  force_destroy                         = var.force_destroy
  cache_type                            = var.cache_type

  context = module.this.context
}
