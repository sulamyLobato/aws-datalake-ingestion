#Criação de buckets no Data Lake

resource "aws_s3_bucket" "datalake" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]

  tags = {
    Environment = "Development"
    Layer       = var.bucket_names[count.index]
  }
}

# 🚀 Criar o bucket S3 para armazenar o script, caso não exista
resource "aws_s3_bucket" "script_bucket" {
  bucket = var.s3_bucket_name
}


