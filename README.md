# Ptáctica Big Data 2022

Como código y práctica base se ha utilizado el repositorio y curso comentado a continuació
Code for [Agile Data Science 2.0](http://shop.oreilly.com/product/0636920051619.do), O'Reilly 2017. Now available at the [O'Reilly Store](http://shop.oreilly.com/product/0636920051619.do), on [Amazon](https://www.amazon.com/Agile-Data-Science-2-0-Applications/dp/1491960116) (in Paperback and Kindle) and on [O'Reilly Safari](https://www.safaribooksonline.com/library/view/agile-data-science/9781491960103/). Also available anywhere technical books are sold!

This is also the code for the [Realtime Predictive Analytics](http://datasyndrome.com/video) video course and [Introduction to PySpark](http://datasyndrome.com/training) live course!

Have problems? Please file an issue!


## Realtime Predictive Analytics Course

There is now a video course using code from chapter 8, [Realtime Predictive Analytics with Kafka, PySpark, Spark MLlib and Spark Streaming](http://datasyndrome.com/video). Check it out now at [datasyndrome.com/video](http://datasyndrome.com/video).

A free preview of the course is available at [https://vimeo.com/202336113](https://vimeo.com/202336113)

[<img src="images/video_course_cover.png">](http://datasyndrome.com/video)

# The Data Value Pyramid

Originally by Pete Warden, the data value pyramid is how the book is organized and structured. We climb it as we go forward each chapter.

![Data Value Pyramid](images/climbing_the_pyramid_chapter_intro.png)

# System Architecture

The following diagrams are pulled from the book, and express the basic concepts in the system architecture. The front and back end architectures work together to make a complete predictive system.

## Front End Architecture

This diagram shows how the front end architecture works in our flight delay prediction application. The user fills out a form with some basic information in a form on a web page, which is submitted to the server. The server fills out some neccesary fields derived from those in the form like "day of year" and emits a Kafka message containing a prediction request. Spark Streaming is listening on a Kafka queue for these requests, and makes the prediction, storing the result in MongoDB. Meanwhile, the client has received a UUID in the form's response, and has been polling another endpoint every second. Once the data is available in Mongo, the client's next request picks it up. Finally, the client displays the result of the prediction to the user! 

This setup is extremely fun to setup, operate and watch. Check out chapters 7 and 8 for more information!

![Front End Architecture](images/front_end_realtime_architecture.png)

## Back End Architecture

The back end architecture diagram shows how we train a classifier model using historical data (all flights from 2015) on disk (HDFS or Amazon S3, etc.) to predict flight delays in batch in Spark. We save the model to disk when it is ready. Next, we launch Zookeeper and a Kafka queue. We use Spark Streaming to load the classifier model, and then listen for prediction requests in a Kafka queue. When a prediction request arrives, Spark Streaming makes the prediction, storing the result in MongoDB where the web application can pick it up.

This architecture is extremely powerful, and it is a huge benefit that we get to use the same code in batch and in realtime with PySpark Streaming.

![Backend Architecture](images/back_end_realtime_architecture.png)

# Screenshots

Below are some examples of parts of the application we build in this book and in this repo. Check out the book for more!

## Airline Entity Page

Each airline gets its own entity page, complete with a summary of its fleet and a description pulled from Wikipedia.

![Airline Page](images/airline_page_enriched_wikipedia.png)

## Airplane Fleet Page

We demonstrate summarizing an entity with an airplane fleet page which describes the entire fleet.

![Airplane Fleet Page](images/airplanes_page_chart_v1_v2.png)

## Flight Delay Prediction UI

We create an entire realtime predictive system with a web front-end to submit prediction requests.

![Predicting Flight Delays UI](images/predicting_flight_kafka_waiting.png)

## Correr la práctica

Para instalar y ejecutar la práctica, se pueden utilizar los scripts de python añadidos a dicha carpeta, donde ahora veremos la funcionalidad de cada uno de ellos:

## 1.- Installations.sh

Realiza la instalación de todos los componentes necesarios para realizar la práctica, con las versiones definidas en el apartado instalación con los correspondientes comandos mencionados. Si no se ha realizado la instalación de las aplicaciones mencionadas, no se puede inicializar la práctica.

## 2.- Environment.sh

Realiza la configuracion de variables de entorno necesarias en el repositorio. Realiza la expertación de todas ellas para un funcionamiento correcto en todos los terminales necesarios y especifica los pasos necesarios para ejecutar la práctica. En todos los terminales que se utilicen en la práctica, se tiene que ejecutar previamente este script.

## 3.- Start-primal-services.sh

Con dicho script comenzamos con la descarga de datos de la práctica, rellenando los datos de vuelos de diferentes años para disponer de la información para nuestra base de datos.
Posteriormente el comando corre los scripts de Zookeper y Kafka para arracncarlos, y crea el topic 'flight_delay_classification_request'.

Inicializa la base de datos en MongoDB e importa en ella las distancias.
Posteriormente realiza el entrenamiento del modelo a través de PySpark mllib y almacena el modelo en la base de datos.

Por último crea un usuario airflow por defecto con el nombre de uno de los alumnos que realizarón la práctica y una contraseña e inicializa la base de datos en airflow. Finalmente instala el DAG de datos necesarios para el uso de Apache Airflow.

## 4.- Spark-app.sh

Arranca la aplicación de predicción de vuelos 'Flight Predicator' a través de spark submit y con los datos almacenados en mongo. Requiere que estén instalados todos los componentes para un correcto funcionamiento del comando. Se usa en vez de utilizar intellIJ para realizar las predicciones y lanzar la aplicacion. (Mejora 1).

## 5.- Flask.sh

Arranca la aplicación de flask para visualizar la predicción de nuevos vuelos introduccidos por el usuario. Se puede observar a través del puerto 5000 de localhost en un navegador.

## 6.- Airflow-web.sh 

Arranca Airflow para tener acceso desde el puerto 3000 de localhost.

## 7.- Airflow-scheduler.sh

Arranca Airflow Scheduler para su uso.

## 8.- Stop-primal-services.sh

Este comando pone fin a la práctica y sirve para parar todos los recursos lanzados en el terminal con start-primal-services.sh. Pausa y elimina los procesos de Kafka, Mongo y Zookeper.

## Inicio de la práctica: Descarga de datos

Una vez hemos visto el objetivo de la práctica y realizado una brebe introducción a ella, iniciamos con la descarga de datos necesarios para realizar la parte básica del proyecto (Posteriormente se comentarán las mejoras realizadas). Primero creamos un nuevo directorio y accedemos a el `practica_big_data_2019`.

```
cd practica_big_data_2019
sudo sh ../installations.sh
```
Una vez ha acabado, realizamos la descarga de datos.
Para utilizar los datos de [Realtime Predictive Analytics](http://datasyndrome.com/video) hay que correr el siguiente comando: 

 ```
resources/download_data.sh
 ```

## Instalación

es necesario realizar la instalación de cada uno de los siguientes componentes incluidos en la arquitectura. En el caso de IntellIJ no es del todo necesario siempre y cuando se instale Apache-Submit, como se verá en el apartado de dicha mejora.
En la siguiente lista, se incluye los comandos necesarios para realizar la instalación.

 - [Intellij](https://www.jetbrains.com/help/idea/installation-guide.html) (jdk_1.8)
 ```
   sudo apt install -y openjdk-8-jdk-headless
   sudo snap install intellij-idea-community --classic
 ```

 - [Pyhton3](https://realpython.com/installing-python/) (Suggested version 3.7)
 - [PIP](https://pip.pypa.io/en/stable/installing/)
 ```
   sudo apt-get install -y python3 python3-pip
 ```
 
 - [SBT](https://www.scala-sbt.org/release/docs/Setup.html) 
 ```
   sudo apt-get install apt-transport-https curl gnupg -yqq
   echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee   /etc/apt/sources.list.d/sbt.list
  echo "deb https://repo.scala-sbt.org/scalasbt/debian /" | sudo tee /etc/apt/sources.list.d/sbt_old.list
   curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo -H gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/scalasbt-release.gpg --import
   sudo chmod 644 /etc/apt/trusted.gpg.d/scalasbt-release.gpg
   sudo apt-get update
   sudo apt-get install sbt
 ```
 
 - [MongoDB](https://docs.mongodb.com/manual/installation/)
 ```
   wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
  sudo apt-get update
```

Aqui reside un problema y es que en MongoDB no esta soportado oficialmente en ubuntu 22.04 y hay que instalar este paquete para que sea posible compatibilizarlo:
```
  wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
  sudo dpkg -i ./libssl1.1_1.1.1f-1ubuntu2_amd64.deb
  rm libssl1.1_1.1.1f-1ubuntu2_amd64.deb
  sudo apt-get install -y mongodb-org
```

 - [Spark](https://spark.apache.org/docs/latest/) (Mandatory version 3.1.2)
 ```
   wget https://archive.apache.org/dist/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
   tar -xvzf spark-3.1.2-bin-hadoop3.2.tgz
   sudo mv spark-3.1.2-bin-hadoop3.2 /opt/spark
   echo 'export SPARK_HOME=/opt/spark' >> ~/.profile
   echo 'export PATH=$PATH:/opt/spark/bin:/opt/spark/sbin' >> ~/.profile
   echo 'export PYSPARK_PYTHON=/usr/bin/python3' >> ~/.profile
   source ~/.profile
 ```
 - [Scala](https://www.scala-lang.org)(Suggested version 2.12)
 
 ```
   wget https://downloads.lightbend.com/scala/2.12.17/scala-2.12.17.deb
   sudo dpkg -i ./scala-2.12.17.deb
   rm scala-2.12.17.deb 
 ```
 
 - [Zookeeper](https://zookeeper.apache.org/releases.html)
 ```
   wget https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz
   tar -xvzf apache-zookeeper-3.7.1-bin.tar.gz
   rm apache-zookeeper-3.7.1-bin.tar.gz
 ```
 
 - [Kafka](https://kafka.apache.org/quickstart) (Mandatory version kafka_2.12-3.0.0)
 ```
   wget https://downloads.apache.org/kafka/3.1.2/kafka_2.12-3.1.2.tgz
   tar -xvzf kafka_2.12-3.1.2.tgz
   rm kafka_2.12-3.1.2.tgz
 ```
 
 ### Arrancar Zookeper y Kafka
 
 Se instalan las librerias de python necesarias:
 ```
   pip install -r requirements.txt
 ```
 ### Arrancar Zookeper
 
 En la refencia del proyecto, se utiliza un comando desactualizado para las versiones actuales de Zookeper, por lo que mejor tengan en cuenta el comando facilitado a continuación:
 Ejecutar el comando en otro terminal dentro del mismo directorio de la práctica (Donde se ha instalado Zookeper).
 ```
  apache-zookeeper-3.7.1-bin/bin/zkServer.sh start apache-zookeeper-3.7.1-bin/conf/zoo_sample.cfg 
 ```
 Y se para con 
 ```
   apache-zookeeper-3.7.1-bin/bin/zkServer.sh stop apache-zookeeper-3.7.1-bin/conf/zoo_sample.cfg
 ```
   bin/zookeeper-server-start.sh config/zookeeper.properties
  ```
  ### Arrancar Kafka
  
  Desde otro Terminal en el mismo directorio, ejecutar el siguiente comando:
  
  ```
   kafka_2.12-3.1.2/bin/kafka-server-start.sh kafka_2.12-3.1.2/config/server.properties
   ```
  Crear un nuevo topic de Kafka en otro terminal:
  ```
   kafka_2.12-3.1.2/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic flight_delay_classification_request
   ```
  Se debería observar el siguiente mensaje
  ```
    Created topic "flight_delay_classification_request".
  ```
  Se puede obserbar la lista de topics con el siguiente comando:
  ```
     kafka_2.12-3.1.2/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
  ```
  Output:
  ```
    flight_delay_classification_request
  ```
  (Optional) Se puede abrir una consola con un consumidor para ver los mensajes que llega al topic
  ```
    kafka_2.12-3.1.2/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic flight_delay_classification_request --from-beginning

  ```
  ## Importar los datos a mongo
  Arrancar mongo y comprobar que está en funcionamiento:
  ```
    sudo systemctl start mongod
    sudo systemctl status mongod
  ```
  
  Run the import_distances.sh script
  ```
  ./resources/import_distances.sh
  ```
  Output:
  ```
  2019-10-01T17:06:46.957+0200	connected to: mongodb://localhost/
  2019-10-01T17:06:47.035+0200	4696 document(s) imported successfully. 0 document(s) failed to import.
  MongoDB shell version v4.2.0
  connecting to: mongodb://127.0.0.1:27017/agile_data_science?compressors=disabled&gssapiServiceName=mongodb
  Implicit session: session { "id" : UUID("9bda4bb6-5727-4e91-8855-71db2b818232") }
  MongoDB server version: 4.2.0
  {
  	"createdCollectionAutomatically" : false,
  	"numIndexesBefore" : 1,
  	"numIndexesAfter" : 2,
  	"ok" : 1
  }

  ```
  ## Entrenar el modelo y guardarlo con PySpark mllib
  
  Set the `JAVA_HOME`:
  ```
    export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
  ```
  
  Ejecutar el script `train_spark_mllib_model.py`
  ```
      python3 resources/train_spark_mllib_model.py .
  ```
  Los resultados deberían haberse almacenado sin problemas en /models, para comporbarlo:  
  ```
  ls ../models
  ```   
  ## Arrancarla la Predicción de Vuelos "Flight Predictor":
  First, you need to change the base_paht val in the MakePrediction scala class,
  change that val for the path where you clone repo is placed:
  ```
    val base_path= "/home/user/Desktop/practica_big_data_2019"
    
  ``` 
  Then run the code using Intellij or spark-submit with their respective arguments. 
  
Please, note that in order to use spark-submit you first need to compile the code and build a JAR file using sbt. Also, when running the spark-submit command, you have to add at least these two packages with the --packages option:
  ```
  --packages org.mongodb.spark:mongo-spark-connector_2.12:3.0.1,org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.2
     
  ``` 
   Be carefull with the packages version because if you are using another version of spark, kafka or mongo you have to choose the correspondent version to your installation. This packages work with Spark 3.1.2, kafka_2.12-3.1.2 and mongo superior to 2.6
  
  ## Start the prediction request Web Application
  
  Set the `PROJECT_HOME` env variable with teh path of you cloned repository, for example:
   ```
  export PROJECT_HOME=/home/user/Desktop/practica_big_data_2019
   ```
  Go to the `web` directory under `resources` and execute the flask web application file `predict_flask.py`:
  ```
  cd practica_big_data_2019/resources/web
  python3 predict_flask.py
  
  ```
  Now, visit http://localhost:5000/flights/delays/predict_kafka and, for fun, open the JavaScript console. Enter a nonzero departure delay, an ISO-formatted date (I used 2016-12-25, which was in the future at the time I was writing this), a valid carrier code (use AA or DL if you don’t know one), an origin and destination (my favorite is ATL → SFO), and a valid flight number (e.g., 1519), and hit Submit. Watch the debug output in the JavaScript console as the client polls for data from the response endpoint at /flights/delays/predict/classify_realtime/response/.
  
  Quickly switch windows to your Spark console. Within 10 seconds, the length we’ve configured of a minibatch, you should see something like the following:
  
  ## Check the predictions records inserted in MongoDB
  ```
   $ mongo
   > use use agile_data_science;
   >db.flight_delay_classification_response.find();
  
  ```
  You must have a similar output as:
  
  ```
  { "_id" : ObjectId("5d8dcb105e8b5622696d6f2e"), "Origin" : "ATL", "DayOfWeek" : 6, "DayOfYear" : 360, "DayOfMonth" : 25, "Dest" : "SFO", "DepDelay" : 290, "Timestamp" : ISODate("2019-09-27T08:40:48.175Z"), "FlightDate" : ISODate("2016-12-24T23:00:00Z"), "Carrier" : "AA", "UUID" : "8e90da7e-63f5-45f9-8f3d-7d948120e5a2", "Distance" : 2139, "Route" : "ATL-SFO", "Prediction" : 3 }
  { "_id" : ObjectId("5d8dcba85e8b562d1d0f9cb8"), "Origin" : "ATL", "DayOfWeek" : 6, "DayOfYear" : 360, "DayOfMonth" : 25, "Dest" : "SFO", "DepDelay" : 291, "Timestamp" : ISODate("2019-09-27T08:43:20.222Z"), "FlightDate" : ISODate("2016-12-24T23:00:00Z"), "Carrier" : "AA", "UUID" : "d3e44ea5-d42c-4874-b5f7-e8a62b006176", "Distance" : 2139, "Route" : "ATL-SFO", "Prediction" : 3 }
  { "_id" : ObjectId("5d8dcbe05e8b562d1d0f9cba"), "Origin" : "ATL", "DayOfWeek" : 6, "DayOfYear" : 360, "DayOfMonth" : 25, "Dest" : "SFO", "DepDelay" : 5, "Timestamp" : ISODate("2019-09-27T08:44:16.432Z"), "FlightDate" : ISODate("2016-12-24T23:00:00Z"), "Carrier" : "AA", "UUID" : "a153dfb1-172d-4232-819c-8f3687af8600", "Distance" : 2139, "Route" : "ATL-SFO", "Prediction" : 1 }


```

### Train the model with Apache Airflow (optional)

- The version of Apache Airflow used is the 2.1.4 and it is installed with pip. For development it uses SQLite as database but it is not recommended for production. For the laboratory SQLite is sufficient.

- Install python libraries for Apache Airflow (suggested Python 3.7)

```shell
cd resources/airflow
pip install -r requirements.txt -c constraints.txt
```
- Set the `PROJECT_HOME` env variable with the path of you cloned repository, for example:
```
export PROJECT_HOME=/home/user/Desktop/practica_big_data_2019
```
- Configure airflow environment

```shell
export AIRFLOW_HOME=~/airflow
mkdir $AIRFLOW_HOME/dags
mkdir $AIRFLOW_HOME/logs
mkdir $AIRFLOW_HOME/plugins

airflow users create \
    --username admin \
    --firstname Jack \
    --lastname  Sparrow\
    --role Admin \
    --email example@mail.org
```
- Start airflow scheduler and webserver
```shell
airflow webserver --port 8080
airflow sheduler
```
Vistit http://localhost:8080/home for the web version of Apache Airflow.

- The DAG is defined in `resources/airflow/setup.py`.
- **TODO**: add the DAG and execute it to train the model (see the official documentation of Apache Airflow to learn how to exectue and add a DAG with the airflow command).
- **TODO**: explain the architecture of apache airflow (see the official documentation of Apache Airflow).
- **TODO**: analyzing the setup.py: what happens if the task fails?, what is the peridocity of the task?

![Apache Airflow DAG success](images/airflow.jpeg)








