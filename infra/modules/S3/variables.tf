variable "bucket_names" {
  description = "Nomes dos Buckets criados"
  type    = list(string)
  default = ["dl2-camada-bronze", "dl2-camada-prata", "dl2-camada-ouro"]
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3 onde armazenamos o script"
  type        = string
  default     = "dl-script"
}