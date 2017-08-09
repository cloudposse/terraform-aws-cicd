# Define composite variables for resources
module "label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=tags/0.1.0"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
}

resource "aws_s3_bucket" "default" {
  bucket = "${module.label.id}"
  acl    = "private"

  tags = "${module.label.tags}"
}

resource "aws_iam_role" "default" {
  name = "${module.label.id}"

  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

data "aws_iam_policy_document" "assume" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  role   = "${aws_iam_role.default.id}"
  policy_arn = "${aws_iam_policy.default.arn}"
}

resource "aws_iam_policy" "default" {
  name   = "${module.label.id}"
  policy = "${data.aws_iam_policy_document.default.json}"
}

data "aws_iam_policy_document" "default" {
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
    ]

    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "s3" {
  role   = "${aws_iam_role.default.id}"
  policy_arn = "${aws_iam_policy.s3.arn}"
}

resource "aws_iam_policy" "s3" {
  name   = "${module.label.id}-s3"
  policy = "${data.aws_iam_policy_document.s3.json}"
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = ""

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.default.arn}",
      "${aws_s3_bucket.default.arn}/*",
      "arn:aws:s3:::elasticbeanstalk*",
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role   = "${aws_iam_role.default.id}"
  policy_arn = "${aws_iam_policy.codebuild.arn}"
}


resource "aws_iam_policy" "codebuild" {
  name   = "${module.label.id}-codebuild"
  policy = "${data.aws_iam_policy_document.codebuild.json}"
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid = ""

    actions = [
      "codebuild:*",
    ]

    resources = ["${module.build.project_id}"]
    effect    = "Allow"
  }
}

module "build" {
  source    = "git::https://github.com/cloudposse/tf_codebuild.git?ref=tags/0.1.0"
  namespace = "${var.namespace}"
  name      = "${var.name}-build"
  stage     = "${var.stage}"

  image         = "${var.build_image}"
  instance_size = "${var.build_instance_size}"
}

resource "aws_iam_role_policy_attachment" "codebuild_s3" {
  role   = "${module.build.role_arn}"
  policy_arn = "${aws_iam_policy.s3.arn}"
}

resource "aws_codepipeline" "default" {
  count    = "${var.enabled}"
  name     = "${module.label.id}"
  role_arn = "${aws_iam_role.default.arn}"

  artifact_store {
    location = "${aws_s3_bucket.default.bucket}"
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

      configuration {
        OAuthToken = "${var.github_oauth_token}"
        Owner      = "${var.repo_owner}"
        Repo       = "${var.repo_name}"
        Branch     = "${var.branch}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name     = "Compose"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["code"]
      output_artifacts = ["package"]

      configuration {
        ProjectName = "${module.build.project_name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["package"]
      version         = "1"

      configuration {
        ApplicationName = "${var.app}"
        EnvironmentName = "${var.env}"
      }
    }
  }

  tags = "${module.label.tags}"
}
