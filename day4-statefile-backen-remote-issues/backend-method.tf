terraform {
  backend "s3" {
    bucket = "mybucketstatefile9343"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
