output "name" {
  value       = "${join("", concat(aws_codepipeline.source_build.*.name, aws_codepipeline.source_build_deploy.*.name))}"
  description = "Pipeline name"
}

