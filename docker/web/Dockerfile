FROM python:3.7

WORKDIR /usr/src/app

COPY practica_big_data_2019 /usr/src/app/
ENV PROJECT_HOME=/usr/src/app/practica_big_data_2019

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "resources/web/predict_flask.py"]