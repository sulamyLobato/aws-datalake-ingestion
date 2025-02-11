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

# Criar o banco de dados no AWS Glue
resource "aws_glue_catalog_database" "datalake" {
  count  = length(var.glue_databases_names)
  name = var.glue_databases_names[count.index]

  tags = {
    Environment = "Development"
    Layer       = var.glue_databases_names[count.index]
  }
}

# 🚀 Criar a Role IAM para AWS Glue
resource "aws_iam_role" "glue_role" {
  name = var.glue_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

# 📌 Anexar políticas necessárias à Role
resource "aws_iam_role_policy_attachment" "glue_s3_access" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}