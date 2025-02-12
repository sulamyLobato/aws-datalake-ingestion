variable "aws_region" {
  description = "Região da AWS onde o bucket será criado"
  type        = string
  default = "sa-east-1"

}



variable "glue_databases_names" {
  description = "Nome do database no AWS Glue"
  type        = list(string)
  default     = ["db2-bronze", "db2-prata", "db2-ouro"]

}

variable "glue_role_name" {
  description = "Nome da role IAM para o AWS Glue"
  type        = string
  default     = "GlueServiceRole"
}

variable "glue_job_cadastro" {
  description = "Nome do AWS Glue Job"
  type        = string
  default     = "tb_bronze_cadastro_usuarios_2"
}

variable "s3_script_path" {
  description = "Caminho do script PySpark no S3"
  type        = string
  default     = "s3://dl-script/tb_bronze_cadastro_usuarios_2.py"
}


variable "s3_output_path" {
  description = "Caminho para salvar os resultados no S3"
  type        = string
  default     = "s3://dl-resultado-glue-output/"
}