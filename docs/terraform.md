<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >=2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_codebuild"></a> [codebuild](#module\_codebuild) | cloudposse/codebuild/aws | 0.33.0 |
| <a name="module_github_webhook"></a> [github\_webhook](#module\_github\_webhook) | cloudposse/repository-webhooks/github | 0.12.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_codepipeline.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline) | resource |
| [aws_codepipeline_webhook.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_webhook) | resource |
| [aws_iam_policy.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.codebuild_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [random_password.webhook_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_bucket.website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_bucket_name"></a> [access\_log\_bucket\_name](#input\_access\_log\_bucket\_name) | Name of the S3 bucket where s3 access log will be sent to | `string` | `""` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `""` | no |
| <a name="input_branch"></a> [branch](#input\_branch) | Branch of the GitHub repository, _e.g._ `master` | `string` | n/a | yes |
| <a name="input_build_compute_type"></a> [build\_compute\_type](#input\_build\_compute\_type) | `CodeBuild` instance size.  Possible values are:<pre>BUILD_GENERAL1_SMALL</pre><pre>BUILD_GENERAL1_MEDIUM</pre><pre>BUILD_GENERAL1_LARGE</pre> | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| <a name="input_build_image"></a> [build\_image](#input\_build\_image) | Docker image for build environment, _e.g._ `aws/codebuild/standard:2.0` or `aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0` | `string` | `"aws/codebuild/standard:2.0"` | no |
| <a name="input_buildspec"></a> [buildspec](#input\_buildspec) | Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | `string` | `""` | no |
| <a name="input_cache_type"></a> [cache\_type](#input\_cache\_type) | The type of storage that will be used for the AWS CodeBuild project cache. Valid values: NO\_CACHE, LOCAL, and S3.  Defaults to S3 to keep same behavior as before upgrading `codebuild` module to 0.18+ version.  If cache\_type is S3, it will create an S3 bucket for storing codebuild cache inside | `string` | `"S3"` | no |
| <a name="input_codebuild_cache_bucket_suffix_enabled"></a> [codebuild\_cache\_bucket\_suffix\_enabled](#input\_codebuild\_cache\_bucket\_suffix\_enabled) | The cache bucket generates a random 13 character string to generate a unique bucket name. If set to false it uses terraform-null-label's id value | `bool` | `true` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_elastic_beanstalk_application_name"></a> [elastic\_beanstalk\_application\_name](#input\_elastic\_beanstalk\_application\_name) | Elastic Beanstalk application name. If not provided or set to empty string, the `Deploy` stage of the pipeline will not be created | `string` | `""` | no |
| <a name="input_elastic_beanstalk_environment_name"></a> [elastic\_beanstalk\_environment\_name](#input\_elastic\_beanstalk\_environment\_name) | Elastic Beanstalk environment name. If not provided or set to empty string, the `Deploy` stage of the pipeline will not be created | `string` | `""` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "NO_ADDITIONAL_BUILD_VARS",<br>    "value": "TRUE"<br>  }<br>]</pre> | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Force destroy the CI/CD S3 bucket even if it's not empty | `bool` | `false` | no |
| <a name="input_github_oauth_token"></a> [github\_oauth\_token](#input\_github\_oauth\_token) | GitHub Oauth Token | `string` | n/a | yes |
| <a name="input_github_webhook_events"></a> [github\_webhook\_events](#input\_github\_webhook\_events) | A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/) | `list(string)` | <pre>[<br>  "push"<br>]</pre> | no |
| <a name="input_github_webhooks_token"></a> [github\_webhooks\_token](#input\_github\_webhooks\_token) | GitHub OAuth Token with permissions to create webhooks. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable | `string` | `""` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_image_repo_name"></a> [image\_repo\_name](#input\_image\_repo\_name) | ECR repository name to store the Docker image built by this module. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `"UNSET"` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Docker image tag in the ECR repository, e.g. 'latest'. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `"latest"` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_poll_source_changes"></a> [poll\_source\_changes](#input\_poll\_source\_changes) | Periodically check the location of your source content and run the pipeline if changes are detected | `bool` | `true` | no |
| <a name="input_privileged_mode"></a> [privileged\_mode](#input\_privileged\_mode) | If set to true, enables running the Docker daemon inside a Docker container on the CodeBuild instance. Used when building Docker images | `bool` | `false` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region, e.g. `us-east-1`. Used as CodeBuild ENV variable when building Docker images. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html) | `string` | `""` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | GitHub repository name of the application to be built (and deployed to Elastic Beanstalk if configured) | `string` | n/a | yes |
| <a name="input_repo_owner"></a> [repo\_owner](#input\_repo\_owner) | GitHub Organization or Person name | `string` | n/a | yes |
| <a name="input_s3_bucket_encryption_enabled"></a> [s3\_bucket\_encryption\_enabled](#input\_s3\_bucket\_encryption\_enabled) | When set to 'true' the 'aws\_s3\_bucket' resource will have AES256 encryption enabled by default | `bool` | `true` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket | `bool` | `true` | no |
| <a name="input_webhook_authentication"></a> [webhook\_authentication](#input\_webhook\_authentication) | The type of authentication to use. One of IP, GITHUB\_HMAC, or UNAUTHENTICATED | `string` | `"GITHUB_HMAC"` | no |
| <a name="input_webhook_enabled"></a> [webhook\_enabled](#input\_webhook\_enabled) | Set to false to prevent the module from creating any webhook resources | `bool` | `false` | no |
| <a name="input_webhook_filter_json_path"></a> [webhook\_filter\_json\_path](#input\_webhook\_filter\_json\_path) | The JSON path to filter on | `string` | `"$.ref"` | no |
| <a name="input_webhook_filter_match_equals"></a> [webhook\_filter\_match\_equals](#input\_webhook\_filter\_match\_equals) | The value to match on (e.g. refs/heads/{Branch}) | `string` | `"refs/heads/{Branch}"` | no |
| <a name="input_webhook_target_action"></a> [webhook\_target\_action](#input\_webhook\_target\_action) | The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline | `string` | `"Source"` | no |
| <a name="input_website_bucket_acl"></a> [website\_bucket\_acl](#input\_website\_bucket\_acl) | Canned ACL of the S3 bucket objects that get served as a website, can be private if using CloudFront with OAI | `string` | `"public-read"` | no |
| <a name="input_website_bucket_name"></a> [website\_bucket\_name](#input\_website\_bucket\_name) | Name of the S3 bucket where the website will be deployed | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_codebuild_badge_url"></a> [codebuild\_badge\_url](#output\_codebuild\_badge\_url) | The URL of the build badge when badge\_enabled is enabled |
| <a name="output_codebuild_cache_bucket_arn"></a> [codebuild\_cache\_bucket\_arn](#output\_codebuild\_cache\_bucket\_arn) | CodeBuild cache S3 bucket ARN |
| <a name="output_codebuild_cache_bucket_name"></a> [codebuild\_cache\_bucket\_name](#output\_codebuild\_cache\_bucket\_name) | CodeBuild cache S3 bucket name |
| <a name="output_codebuild_project_id"></a> [codebuild\_project\_id](#output\_codebuild\_project\_id) | CodeBuild project ID |
| <a name="output_codebuild_project_name"></a> [codebuild\_project\_name](#output\_codebuild\_project\_name) | CodeBuild project name |
| <a name="output_codebuild_role_arn"></a> [codebuild\_role\_arn](#output\_codebuild\_role\_arn) | CodeBuild IAM Role ARN |
| <a name="output_codebuild_role_id"></a> [codebuild\_role\_id](#output\_codebuild\_role\_id) | CodeBuild IAM Role ID |
| <a name="output_codepipeline_arn"></a> [codepipeline\_arn](#output\_codepipeline\_arn) | CodePipeline ARN |
| <a name="output_codepipeline_id"></a> [codepipeline\_id](#output\_codepipeline\_id) | CodePipeline ID |
<!-- markdownlint-restore -->
