variable "aws_region" {
  description = "Região da AWS onde o bucket será criado"
  type        = string
  default = "sa-east-1"

}

variable "bucket_names" {
  description = "Nomes dos Buckets criados"
  type    = list(string)
  default = ["dl2-camada-bronze", "dl2-camada-prata", "dl2-camada-ouro"]
}

variable "glue_databases_names" {
  description = "Nome do database no AWS Glue"
  type        = list(string)
  default     = ["db2-bronze", "db2-prata", "db2-ouro"]

}

