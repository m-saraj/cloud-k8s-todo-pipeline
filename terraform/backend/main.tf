provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "cloud-k8s-tf-state-bucket"
  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "cloud-k8s-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}
