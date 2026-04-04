terraform {
  # Esta es la versión del programa Terraform que tienes instalado
  required_version = ">= 1.14.8"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # Esta es la versión del "traductor" de AWS (HashiCorp)
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}