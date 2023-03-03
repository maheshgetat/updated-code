terraform {
  backend "s3" {
    bucket = "CCS-EKS-DEV-statefile"
    key    = "tfstate"
    region = "us-east-1"
  }
}
