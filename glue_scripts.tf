# 🚀 Criar um arquivo local do script PySpark

resource "local_file" "glue_pyspark_script" {
  filename = "${path.module}/${var.glue_job_cadastro}"
  content  = <<EOF

import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql import SparkSession
from datetime import datetime
from pyspark.sql.functions import lit
import requests
import pandas as pd

# Inicializando o Glue job
args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)


# Função para pegar data corrente
def get_partition_date():
    """Retorna a data atual no formato 'yyyy-MM-dd'."""
    return datetime.today().strftime('%Y-%m-%d')


def generate_fake_brazilian_users(count=1000):
    # Endpoint para gerar usuários brasileiros
    url = f"https://randomuser.me/api/?results={count}&nat=br"
    
    # Fazendo a requisição para a API
    response = requests.get(url)
    data = response.json()

    # Extraindo dados dos usuários
    users = [{
        "Cpf": user['id']['value'],
        "Nome": f"{user['name']['first']} {user['name']['last']}",
        "Gênero": user['gender'],
        "Email": user['email'],
        "Telefone": user['phone'],
        "Endereço": user['location']['street']['name'],
        "Cidade": user['location']['city'],
        "Estado": user['location']['state'],
        "CEP": user['location']['postcode'],
        "País": user['location']['country'],
        "Data de Nascimento": user['dob']['date'],
        "Idade": user['dob']['age'],
        "Foto": user['picture']['large']
        
    } for user in data['results']]

    # Criando um DataFrame com os dados
    df = pd.DataFrame(users)
    
    return df

df = generate_fake_brazilian_users(5000)

# Convertendo o DataFrame do Pandas para Spark DataFrame
df = spark.createDataFrame(df)

# Adiciona a coluna de partição com a data atual
df = df.withColumn("data_particao", lit(get_partition_date()))


# Criando a tabela no catálogo de dados do Glue (caso ela não exista)
df.write.format("parquet") \
    .mode("overwrite") \
    .partitionBy("data_particao") \
    .option("path", "s3://dl-camada-bronze/tb_bronze_cadastro_usuarios/") \
    .saveAsTable("db_bronze.tb_bronze_cadastro_usuarios")


job.commit()


EOF
}

# 🚀 Criar o bucket S3 para armazenar o script, caso não exista
#resource "aws_s3_bucket" "script_bucket" {
 # bucket = var.s3_bucket_name
#}

# 🚀 Subir o script PySpark para o S3
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.script_bucket.id
  key    = var.glue_job_cadastro
  source = local_file.glue_pyspark_script.filename
}
