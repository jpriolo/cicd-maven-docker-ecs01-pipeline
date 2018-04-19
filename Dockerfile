## Dockerfile_0.1.0

## For building war file. Onbuild is a functionality to create the war file
From maven:3.3-jdk-8-onbuild

##Downloading the tomcat
From tomcat:8.0-jre8

#Deploying to tomcat server
COPY --from=0 /usr/src/app/target/mywebapp.war ${CATALINA_HOME}/webapps/mywebapp.war

##Running the tomcat
CMD ["catalina.sh", "run"]
EXPOSE 8081:8080
