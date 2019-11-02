terraform {
  backend "s3" {
    bucket = "pgr301bucket"
    key    = "kristiania-pgr301/terraform.tfstate"
    region = "eu-north-1"
  }
}