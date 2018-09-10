#!/bin/sh

### Get command line options
POSTGRES_URL=$1
POSTGRES_LOGIN=$2
POSTGRES_PASS=$3

### Download/Install dependencies
# Java, 7zip

apt-get update -y
apt-get install default-jdk -y

### Download the jar

### Extract it

### Generate the application.properties file
echo "spring.datasource.url= jdbc:postgresql://$POSTGRES_URL
spring.database.driverClassName=org.postgresql.Driver
spring.jpa.properties.hibernate.default_schema=public
spring.datasource.username=$POSTGRES_LOGIN
spring.datasource.password=$POSTGRES_PASS" > ./application.properties

### Run the jar
java -jar ./rewards-0.0.3-DEV.war
