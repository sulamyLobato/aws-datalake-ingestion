provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "datalake" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = {
    Environment = "Development"
    Layer       = var.bucket_names[count.index]
  }
}
