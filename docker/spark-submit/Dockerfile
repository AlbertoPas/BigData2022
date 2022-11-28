# Base image
FROM apache/spark-py:v3.1.3

COPY requirements.txt /opt/bitnami/spark/requirements.txt
RUN pip install -r /opt/bitnami/spark/requirements.txt
COPY train_spark_mllib_model.py /opt/bitnami/spark/python/train_spark_mllib_model.py

USER 1001
# Update image
COPY flight_prediction_2.12-0.1.jar /opt/bitnami/spark/jars/flight_prediction_2.12-0.1.jar
