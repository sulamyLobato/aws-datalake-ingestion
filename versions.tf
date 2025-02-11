terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "projeto-terraform-state"
    key            = "terraform.tfstate"
    region         = "sa-east-1"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
