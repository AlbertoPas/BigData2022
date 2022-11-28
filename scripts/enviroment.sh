#!/bin/bash
##############################################
# Instalacion de Spark
export SPARK_HOME=/opt/spark
export PATH=$PATH:/opt/spark/bin:/opt/spark/sbin
export PYSPARK_PYTHON=/usr/bin/python3
##############################################
# Entrenar y guardar el modelo con PySpark mllib
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
##############################################
# Start the prediction request Web Application
# Crear la variable de entorno al repositorio clonado
export PROJECT_HOME=/home/hugo/Documentos/BDFI/FinalParte1/practica_big_data_2019
##############################################
export AIRFLOW_HOME=$PROJECT_HOME/airflow
##############################################

echo "Run start-primal-services.sh and wait for it to return to you the prompt"
echo "From now on execute spark-app.sh, flask.sh, airflow-web.sh and airflow-scheduler.sh in this order"
echo "Each one in other terminal after execute this shell script again previous to everyone"
