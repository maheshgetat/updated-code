terraform {
  backend "s3" {
    bucket = "crawcostatefilebucket-011"
    key    = "tfstate"
    region = "us-east-1"
  }
}
