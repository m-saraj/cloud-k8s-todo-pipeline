terraform {
  backend "s3" {
    bucket         = "cloud-k8s-tf-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "cloud-k8s-tf-locks"
    encrypt        = true
  }
}
