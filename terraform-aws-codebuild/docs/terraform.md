
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| artifact_type | The build output artifact's type. Valid values for this parameter are: CODEPIPELINE, NO_ARTIFACTS or S3. | string | `CODEPIPELINE` | no |
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| aws_account_id | (Optional) AWS Account ID. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | `` | no |
| aws_region | (Optional) AWS Region, e.g. us-east-1. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | `` | no |
| build_compute_type | Instance type of the build instance | string | `BUILD_GENERAL1_SMALL` | no |
| build_image | Docker image for build environment, e.g. 'aws/codebuild/docker:1.12.1' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html | string | `aws/codebuild/docker:1.12.1` | no |
| buildspec | Optional buildspec declaration to use for building the project | string | `` | no |
| cache_bucket_suffix_enabled | The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value | string | `true` | no |
| cache_enabled | If cache_enabled is true, create an S3 bucket for storing codebuild cache inside | string | `true` | no |
| cache_expiration_days | How many days should the build cache be kept | string | `7` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| enabled | A boolean to enable/disable resource creation | string | `true` | no |
| environment_variables | A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build. | list | `<list>` | no |
| github_token | (Optional) GitHub auth token environment variable (`GITHUB_TOKEN`) | string | `` | no |
| image_repo_name | (Optional) ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | `UNSET` | no |
| image_tag | (Optional) Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html | string | `latest` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `codebuild` | no |
| namespace | Namespace, which could be your organization name, e.g. 'cp' or 'cloudposse' | string | `global` | no |
| privileged_mode | (Optional) If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | string | `false` | no |
| source_location | The location of the source code from git or s3. | string | `` | no |
| source_type | The type of repository that contains the source code to be built. Valid values for this parameter are: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET or S3. | string | `CODEPIPELINE` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `default` | no |
| tags | Additional tags (e.g. `map('BusinessUnit', 'XYZ')` | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| cache_bucket_name | Cache S3 bucket name |
| project_id | Project ID |
| project_name | Project name |
| role_arn | IAM Role ARN |

