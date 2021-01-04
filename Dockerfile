#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM maven:3.6.3-openjdk-11-slim AS base
WORKDIR /app

FROM maven:3.6.3-openjdk-11-slim AS build
WORKDIR /src
COPY ./TradingEAC-Config-Server .
RUN ls
#RUN mvn install
#RUN mvn compile

FROM build AS publish
RUN mvn dependency:go-offline -B
RUN mvn package -DskipTests
RUN ls target

FROM base AS final
WORKDIR /app
COPY --from=publish /src/target/*.jar ./app.jar
ENTRYPOINT ["java", "-jar", "/app/app.jar"]