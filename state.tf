terraform {
  backend "s3" {
    bucket = "uzeirsos-my-terraform-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock-file"
  }
}