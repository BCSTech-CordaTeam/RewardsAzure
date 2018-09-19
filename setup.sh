#!/bin/sh

### Get command line options
POSTGRES_URL=$1
POSTGRES_PORT=$2
POSTGRES_DBNAME=$3
POSTGRES_LOGIN=$4
POSTGRES_PASS=$5
PASS=$6 # Not supplied by user
USER=$7

FILE="rewards-0.0.3-DEV"

### Download/Install dependencies
apt-get update -y
# Java
apt-get install default-jre -y
# 7zip
apt-get install p7zip-full -y

### Move to a nice location
mkdir /home/$USER/rewards # && cd "$_"
cd /home/$USER/rewards

### Download the jar
wget https://github.com/BCSTech-CordaTeam/RewardsAzure/blob/master/$FILE.7z?raw=true
mv $FILE.7z?raw=true $FILE.7z

### Extract it
# password: fh2fhq8fhy48hSDF43Gfde
7z x $FILE.7z -p$PASS

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
7z u $FILE.war ./WEB-INF

### Cleanup
rm WEB-INF -r -f

### Generate script for starting server
echo "
#!/bin/sh
java -jar ./$FILE.war" > start.sh

### Run the jar
nohup ./start.sh & 

### Self destruct
# Get path
# Source: https://stackoverflow.com/questions/630372/determine-the-path-of-the-executing-bash-script
MY_PATH="`dirname \"$0\"`"              # relative
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"  # absolutized and normalized
if [ -z "$MY_PATH" ] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

rm $MY_PATH/${0##*/}

