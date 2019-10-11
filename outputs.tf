output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = module.codebuild.project_name
}

output "codebuild_project_id" {
  description = "CodeBuild project ID"
  value       = module.codebuild.project_id
}

output "codebuild_role_id" {
  description = "CodeBuild IAM Role ID"
  value       = module.codebuild.role_id
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM Role ARN"
  value       = module.codebuild.role_arn
}

output "codebuild_cache_bucket_name" {
  description = "CodeBuild cache S3 bucket name"
  value       = module.codebuild.cache_bucket_name
}

output "codebuild_cache_bucket_arn" {
  description = "CodeBuild cache S3 bucket ARN"
  value       = module.codebuild.cache_bucket_arn
}

output "codebuild_badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.codebuild.badge_url
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = join("", aws_codepipeline.default.*.id)
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = join("", aws_codepipeline.default.*.arn)
}
