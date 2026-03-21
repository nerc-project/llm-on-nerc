FROM python:3.10-slim-bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN pip install --upgrade pip && pip install mlflow[extras] psycopg2 boto3 cryptography pymysql

USER 0

EXPOSE 5000

RUN mkdir -p /mlflow
WORKDIR /mlflow
