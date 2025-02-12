variable "s3_bucket_names" {
  description = "Nomes dos Buckets criados"
  type    = list(string)
  default = ["dl2-camada-bronze", "dl2-camada-prata", "dl2-camada-ouro"]
}