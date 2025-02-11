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
