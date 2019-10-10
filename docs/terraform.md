## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list(string) | `<list>` | no |
| aws_account_id | AWS Account ID. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | string | `` | no |
| aws_region | AWS Region, e.g. `us-east-1`. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | string | `` | no |
| branch | Branch of the GitHub repository, _e.g._ `master` | string | - | yes |
| build_compute_type | `CodeBuild` instance size.  Possible values are: ```BUILD_GENERAL1_SMALL``` ```BUILD_GENERAL1_MEDIUM``` ```BUILD_GENERAL1_LARGE``` | string | `BUILD_GENERAL1_SMALL` | no |
| build_image | Docker image for build environment, _e.g._ `aws/codebuild/standard:2.0` or `aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0` | string | `aws/codebuild/standard:2.0` | no |
| buildspec | Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | string | `` | no |
| codebuild_cache_bucket_suffix_enabled | The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value | bool | `true` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| elastic_beanstalk_application_name | Elastic Beanstalk application name. If not provided or set to empty string, the ``Deploy`` stage of the pipeline will not be created | string | `` | no |
| elastic_beanstalk_environment_name | Elastic Beanstalk environment name. If not provided or set to empty string, the ``Deploy`` stage of the pipeline will not be created | string | `` | no |
| enabled | Enable ``CodePipeline`` creation | bool | `true` | no |
| environment_variables | A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build | object | `<list>` | no |
| github_oauth_token | GitHub Oauth Token | string | - | yes |
| image_repo_name | ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | string | `UNSET` | no |
| image_tag | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | string | `latest` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | - | yes |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | `` | no |
| poll_source_changes | Periodically check the location of your source content and run the pipeline if changes are detected | bool | `true` | no |
| privileged_mode | If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | bool | `false` | no |
| repo_name | GitHub repository name of the application to be built (and deployed to Elastic Beanstalk if configured) | string | - | yes |
| repo_owner | GitHub Organization or Person name | string | - | yes |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit', 'XYZ')` | map(string) | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| codebuild_badge_url | The URL of the build badge when badge_enabled is enabled |
| codebuild_cache_bucket_arn | CodeBuild cache S3 bucket ARN |
| codebuild_cache_bucket_name | CodeBuild cache S3 bucket name |
| codebuild_project_id | CodeBuild project ID |
| codebuild_project_name | CodeBuild project name |
| codebuild_role_arn | CodeBuild IAM Role ARN |
| codebuild_role_id | CodeBuild IAM Role ID |
| codepipeline_arn | CodePipeline ARN |
| codepipeline_id | CodePipeline ID |

