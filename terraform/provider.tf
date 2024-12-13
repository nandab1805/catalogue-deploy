terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0" #Aws provider function not terraform
    }
  }

  backend "s3" {
    bucket = "nanda3s-dev"
    key    = "cat4"
    region = "us-east-1"
    dynamodb_table = "nandadb-locking-dev"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

