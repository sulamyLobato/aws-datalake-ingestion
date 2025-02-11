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

resource "aws_glue_catalog_database" "datalake" {
  count  = length(var.glue_databases_names)
  name = var.glue_databases_names[count.index]

  tags = {
    Environment = "Development"
    Layer       = var.glue_databases_names[count.index]
  }
}
