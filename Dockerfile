# Stage 1: Build the application with Maven
FROM maven:3.8.3-openjdk-11 AS builder

WORKDIR /app

# Copy the necessary files for Maven build
COPY . .

# Copy the Maven wrapper and set permissions
COPY mvnw .
RUN chmod +x mvnw

# Build the application with Maven
RUN ./mvnw package -DskipTests

# Stage 2: Create the final Docker image
FROM registry.access.redhat.com/ubi8/openjdk-17:1.17

WORKDIR /deployments

# Copy the built JAR file from the previous stage
COPY --from=builder /app/target/*.jar /deployments/

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/deployments/quarkus-app.jar"]
