#!/bin/sh

### Get command line options
POSTGRES_URL=$1
POSTGRES_PORT=$2
POSTGRES_DBNAME=$3
POSTGRES_LOGIN=$4
POSTGRES_PASS=$5
PASS=$6 # Not supplied by user

### Download/Install dependencies
apt-get update -y
# Java
apt-get install default-jre -y
# 7zip
apt-get install p7zip-full -y

### Download the jar
wget https://github.com/BCSTech-CordaTeam/RewardsAzure/blob/master/rewards-0.0.3-DEV.7z?raw=true
mv rewards-0.0.3-DEV.7z?raw=true rewards-0.0.3-DEV.7z

### Extract it
# password: fh2fhq8fhy48hSDF43Gfde
7z x rewards-0.0.3-DEV.7z -p$PASS

### Generate the application.properties file
mkdir ./WEB-INF/classes -p

echo "
spring.jpa.hibernate.ddl-auto=update
spring.jpa.hibernate.generate-ddl=true
spring.datasource.initialization-mode=always
spring.batch.initialize-schema=always
spring.datasource.platform=postgres
spring.jpa.properties.hibernate.temp.use_jdbc_metadata_defaults = false
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQL9Dialect
spring.jpa.properties.hibernate.jdbc.time_zone = UTC
logging.file=framework.log
logging.level.org.springframework.web=ERROR
logging.level.com.framework.rewards=DEBUG
logging.pattern.console= "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
logging.pattern.file= "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
spring.datasource.url= jdbc:postgresql://$POSTGRES_URL:$POSTGRES_PORT/$POSTGRES_DBNAME?user=$POSTGRES_LOGIN&password=$POSTGRES_PASS&sslmode=require
spring.database.driverClassName=org.postgresql.Driver
spring.jpa.properties.hibernate.default_schema=public
spring.datasource.username=$POSTGRES_LOGIN
spring.datasource.password=$POSTGRES_PASS" > ./WEB-INF/classes/application.properties

### Move application.properties into the WAR
7z u rewards-0.0.3-DEV.war ./WEB-INF

### Run the jar
nohup java -jar ./rewards-0.0.3-DEV.war & 
