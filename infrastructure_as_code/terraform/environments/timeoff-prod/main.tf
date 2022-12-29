terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.48.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "timeoff-bucket-infrastructure"
    key    = "timeoff/terraform.tfstate"
    region = "us-east-1"
  }
}
