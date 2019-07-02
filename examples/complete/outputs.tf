output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = module.cicd.codebuild_project_name
}

output "codebuild_project_id" {
  description = "CodeBuild project ID"
  value       = module.cicd.codebuild_project_id
}

output "codebuild_role_id" {
  description = "CodeBuild IAM Role ID"
  value       = module.cicd.codebuild_role_id
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM Role ARN"
  value       = module.cicd.codebuild_role_arn
}

output "codebuild_cache_bucket_name" {
  description = "CodeBuild cache S3 bucket name"
  value       = module.cicd.codebuild_cache_bucket_name
}

output "codebuild_cache_bucket_arn" {
  description = "CodeBuild cache S3 bucket ARN"
  value       = module.cicd.codebuild_cache_bucket_arn
}

output "codebuild_badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.cicd.codebuild_badge_url
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = module.cicd.codepipeline_id
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = module.cicd.codepipeline_arn
}
