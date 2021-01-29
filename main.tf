data "aws_caller_identity" "default" {
}

data "aws_region" "default" {
}

locals {
  enabled = module.this.enabled
}

resource "aws_s3_bucket" "default" {
  #bridgecrew:skip=BC_AWS_S3_13:Skipping `Enable S3 Bucket Logging` check until bridgecrew will support dynamic blocks (https://github.com/bridgecrewio/checkov/issues/776).
  #bridgecrew:skip=BC_AWS_S3_14:Skipping `Ensure all data stored in the S3 bucket is securely encrypted at rest` check until bridgecrew will support dynamic blocks (https://github.com/bridgecrewio/checkov/issues/776).
  #bridgecrew:skip=CKV_AWS_52:Skipping `Ensure S3 bucket has MFA delete enabled` due to issue in terraform (https://github.com/hashicorp/terraform-provider-aws/issues/629).
  count         = local.enabled ? 1 : 0
  bucket        = module.this.id
  acl           = "private"
  force_destroy = var.force_destroy
  tags          = module.this.tags

  versioning {
    enabled = var.versioning_enabled
  }

  dynamic "logging" {
    for_each = var.access_log_bucket_name != "" ? [1] : []
    content {
      target_bucket = var.access_log_bucket_name
      target_prefix = "logs/${module.this.id}/"
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.s3_bucket_encryption_enabled ? [1] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
      }
    }
  }

}

resource "aws_iam_role" "default" {
  count              = local.enabled ? 1 : 0
  name               = module.this.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume.*.json)
  tags               = module.this.tags
}

data "aws_iam_policy_document" "assume" {
  count = local.enabled ? 1 : 0

  statement {
    sid = ""

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  count      = local.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.default.*.arn)
}

resource "aws_iam_policy" "default" {
  count  = local.enabled ? 1 : 0
  name   = module.this.id
  policy = join("", data.aws_iam_policy_document.default.*.json)
}

data "aws_iam_policy_document" "default" {
  count = local.enabled ? 1 : 0

  statement {
    sid = ""

    actions = [
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole",
      "logs:PutRetentionPolicy",
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  count      = local.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

resource "aws_iam_policy" "s3" {
  count  = local.enabled ? 1 : 0
  name   = "${module.this.id}-s3"
  policy = join("", data.aws_iam_policy_document.s3.*.json)
}

data "aws_iam_policy_document" "s3" {
  count = local.enabled ? 1 : 0

  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      join("", aws_s3_bucket.default.*.arn),
      "${join("", aws_s3_bucket.default.*.arn)}/*",
      "arn:aws:s3:::elasticbeanstalk*"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  count      = local.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.codebuild.*.arn)
}

resource "aws_iam_policy" "codebuild" {
  count  = local.enabled ? 1 : 0
  name   = "${module.this.id}-codebuild"
  policy = join("", data.aws_iam_policy_document.codebuild.*.json)
}

data "aws_iam_policy_document" "codebuild" {
  count = local.enabled ? 1 : 0

  statement {
    sid = ""

    actions = [
      "codebuild:*"
    ]

    resources = [module.codebuild.project_id]
    effect    = "Allow"
  }
}

module "codebuild" {
  source                      = "cloudposse/codebuild/aws"
  version                     = "0.30.0"
  build_image                 = var.build_image
  build_compute_type          = var.build_compute_type
  buildspec                   = var.buildspec
  attributes                  = ["build"]
  privileged_mode             = var.privileged_mode
  aws_region                  = var.region != "" ? var.region : data.aws_region.default.name
  aws_account_id              = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.default.account_id
  image_repo_name             = var.image_repo_name
  image_tag                   = var.image_tag
  github_token                = var.github_oauth_token
  environment_variables       = var.environment_variables
  cache_bucket_suffix_enabled = var.codebuild_cache_bucket_suffix_enabled
  cache_type                  = var.cache_type

  context = module.this.context
}

resource "aws_iam_role_policy_attachment" "codebuild_s3" {
  count      = local.enabled ? 1 : 0
  role       = module.codebuild.role_id
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

# Only one of the `aws_codepipeline` resources below will be created:

# "source_build_deploy" will be created if `local.enabled` is set to `true` and the Elastic Beanstalk application name and environment name are specified

# This is used in two use-cases:

# 1. GitHub -> S3 -> Elastic Beanstalk (running application stack like Node, Go, Java, IIS, Python)

# 2. GitHub -> ECR (Docker image) -> Elastic Beanstalk (running Docker stack)

# "source_build" will be created if `local.enabled` is set to `true` and the Elastic Beanstalk application name or environment name are not specified

# This is used in this use-case:

# 1. GitHub -> ECR (Docker image)

resource "aws_codepipeline" "default" {
  # Elastic Beanstalk application name and environment name are specified
  count    = local.enabled ? 1 : 0
  name     = module.this.id
  role_arn = join("", aws_iam_role.default.*.arn)
  tags     = module.this.tags

  artifact_store {
    location = join("", aws_s3_bucket.default.*.bucket)
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["code"]

      configuration = {
        OAuthToken           = var.github_oauth_token
        Owner                = var.repo_owner
        Repo                 = var.repo_name
        Branch               = var.branch
        PollForSourceChanges = var.poll_source_changes
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["code"]
      output_artifacts = ["package"]

      configuration = {
        ProjectName = module.codebuild.project_name
      }
    }
  }

  dynamic "stage" {
    for_each = var.elastic_beanstalk_application_name != "" && var.elastic_beanstalk_environment_name != "" ? ["true"] : []
    content {
      name = "Deploy"

      action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ElasticBeanstalk"
        input_artifacts = ["package"]
        version         = "1"

        configuration = {
          ApplicationName = var.elastic_beanstalk_application_name
          EnvironmentName = var.elastic_beanstalk_environment_name
        }
      }
    }
  }
}
