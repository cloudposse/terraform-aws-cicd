variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "deploy"
}

variable "enabled" {
  default = 1
}

variable "app" {}

variable "env" {}

variable "github_oauth_token" {}

variable "repo_owner" {}

variable "repo_name" {}

variable "branch" {}
