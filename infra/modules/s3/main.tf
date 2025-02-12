
resource "aws_s3_bucket" "datalake" {
  count  = length(var.s3_bucket_names)
  bucket = var.s3_bucket_names[count.index]

  tags = {
    Environment = "Development"
    Layer       = var.s3_bucket_names[count.index]
  }
}