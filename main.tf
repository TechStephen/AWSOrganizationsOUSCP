terraform {
    #backend "s3" {
    #    bucket = "value"
    #    key    = "terraform.tfstate"
    #    region = "us-east-1"
    #}
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

module "Organizations" {
  source = "./Organizations"
}