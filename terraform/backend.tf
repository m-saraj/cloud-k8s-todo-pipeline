terraform {
  backend "s3" {
    bucket         = "cloud-k8s-tf-state-bucket"
    key            = "eks/dev/terraform.tfstate"
    region         = "eu-west-2"
     use_lockfile   = true 
  }
}
