
# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Tận dụng cache cho dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source bao gồm cả file keystore trong resources
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy file jar thành phẩm
COPY --from=build /app/target/api-gateway-0.0.1-SNAPSHOT.jar app.jar

# Gateway chạy cổng 8443 cho HTTPS
EXPOSE 8443

ENTRYPOINT ["java", "-jar", "app.jar"]