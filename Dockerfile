FROM alpine:3.20 AS alpine
WORKDIR /app
COPY server ./server
COPY webapp ./webapp
COPY pom.xml .
COPY about.html ./webapp/src/main/webapp
COPY contact.html ./webapp/src/main/webapp
COPY index.html ./webapp/src/main/webapp
COPY shop.html ./webapp/src/main/webapp
COPY shop-single.html ./webapp/src/main/webapp

FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY --from=alpine /app .
WORKDIR /app/webapp
RUN mvn clean package

FROM tomcat:9.0.65-jdk17-corretto
COPY --from=build /app/webapp/target/*.war /usr/local/tomcat/webapps/ROOT.war
CMD ["catalina.sh", "run"]
