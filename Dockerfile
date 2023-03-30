#FROM openjdk:17-jdk-alpine AS build
FROM gradle:7.6-jdk17-alpine as build
ENV APP_HOME=/apps
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME
COPY gradle $APP_HOME/gradle
RUN chmod +x gradlew
RUN ./gradlew build || return 0
COPY src $APP_HOME/src
RUN ./gradlew clean build

FROM openjdk:17-jdk-alpine AS publish
ENV APP_HOME=/apps
ARG ARTIFACT_NAME=app.jar
ARG JAR_FILE_PATH=build/libs/*.jar
COPY --from=build $APP_HOME/$JAR_FILE_PATH $ARTIFACT_NAME

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
