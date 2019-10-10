data "aws_caller_identity" "default" {
}

data "aws_region" "default" {
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  enabled    = var.enabled
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

resource "aws_s3_bucket" "default" {
  count  = var.enabled ? 1 : 0
  bucket = module.label.id
  acl    = "private"
  tags   = module.label.tags
}

resource "aws_iam_role" "default" {
  count              = var.enabled ? 1 : 0
  name               = module.label.id
  assume_role_policy = join("", data.aws_iam_policy_document.assume.*.json)
}

data "aws_iam_policy_document" "assume" {
  count = var.enabled ? 1 : 0

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
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.default.*.arn)
}

resource "aws_iam_policy" "default" {
  count  = var.enabled ? 1 : 0
  name   = module.label.id
  policy = join("", data.aws_iam_policy_document.default.*.json)
}

data "aws_iam_policy_document" "default" {
  count = var.enabled ? 1 : 0

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
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

resource "aws_iam_policy" "s3" {
  count  = var.enabled ? 1 : 0
  name   = "${module.label.id}-s3"
  policy = join("", data.aws_iam_policy_document.s3.*.json)
}

data "aws_iam_policy_document" "s3" {
  count = var.enabled ? 1 : 0

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
  count      = var.enabled ? 1 : 0
  role       = join("", aws_iam_role.default.*.id)
  policy_arn = join("", aws_iam_policy.codebuild.*.arn)
}

resource "aws_iam_policy" "codebuild" {
  count  = var.enabled ? 1 : 0
  name   = "${module.label.id}-codebuild"
  policy = join("", data.aws_iam_policy_document.codebuild.*.json)
}

data "aws_iam_policy_document" "codebuild" {
  count = var.enabled ? 1 : 0

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
  source                      = "git::https://github.com/cloudposse/terraform-aws-codebuild.git?ref=tags/0.17.0"
  enabled                     = var.enabled
  namespace                   = var.namespace
  name                        = var.name
  stage                       = var.stage
  build_image                 = var.build_image
  build_compute_type          = var.build_compute_type
  buildspec                   = var.buildspec
  delimiter                   = var.delimiter
  attributes                  = concat(var.attributes, ["build"])
  tags                        = var.tags
  privileged_mode             = var.privileged_mode
  aws_region                  = var.region != "" ? var.region : data.aws_region.default.name
  aws_account_id              = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.default.account_id
  image_repo_name             = var.image_repo_name
  image_tag                   = var.image_tag
  github_token                = var.github_oauth_token
  environment_variables       = var.environment_variables
  cache_bucket_suffix_enabled = var.codebuild_cache_bucket_suffix_enabled
}

resource "aws_iam_role_policy_attachment" "codebuild_s3" {
  count      = var.enabled ? 1 : 0
  role       = module.codebuild.role_id
  policy_arn = join("", aws_iam_policy.s3.*.arn)
}

# Only one of the `aws_codepipeline` resources below will be created:

# "source_build_deploy" will be created if `var.enabled` is set to `true` and the Elastic Beanstalk application name and environment name are specified

# This is used in two use-cases:

# 1. GitHub -> S3 -> Elastic Beanstalk (running application stack like Node, Go, Java, IIS, Python)

# 2. GitHub -> ECR (Docker image) -> Elastic Beanstalk (running Docker stack)

# "source_build" will be created if `var.enabled` is set to `true` and the Elastic Beanstalk application name or environment name are not specified

# This is used in this use-case:

# 1. GitHub -> ECR (Docker image)

resource "aws_codepipeline" "default" {
  # Elastic Beanstalk application name and environment name are specified
  count    = var.enabled ? 1 : 0
  name     = module.label.id
  role_arn = join("", aws_iam_role.default.*.arn)

  artifact_store {
    location = join("", aws_s3_bucket.default.*.bucket)
    type     = "S3"
  }

  stage {
    name = "Source"

    dynamic "action" {
      for_each = var.github_oauth_token != "" ? ["true"] : []
      content {
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

    dynamic "action" {
      for_each = var.github_oauth_token == "" ? ["true"] : []
      content {
        name             = "Source"
        category         = "Source"
        owner            = "ThirdParty"
        provider         = "GitHub"
        version          = "1"
        output_artifacts = ["code"]

        configuration = {
          Owner                = var.repo_owner
          Repo                 = var.repo_name
          Branch               = var.branch
          PollForSourceChanges = var.poll_source_changes
        }
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
