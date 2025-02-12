provider "aws" {
  region = var.aws_region
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

# 🚀 Criar o Glue Job e apontá-lo para o script no S3
resource "aws_glue_job" "glue_job" {
  name     = var.glue_job_cadastro
  role_arn = aws_iam_role.glue_role.arn

  command {
    script_location = "s3://${var.s3_bucket_name}/${var.glue_job_cadastro}"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"       = var.s3_output_path
    "--job-language"  = "python"
    "--enable-continuous-cloudwatch-log" = "true"
  }

  glue_version = "3.0"
  worker_type  = "G.1X"
  number_of_workers = 2
}