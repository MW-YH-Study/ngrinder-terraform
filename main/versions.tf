terraform {
  required_version = ">= 1.0.0"

  cloud {
    organization = "yeonhyuk-me"
    hostname     = "app.terraform.io" # default

    workspaces {
      name = "chatting-server"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}