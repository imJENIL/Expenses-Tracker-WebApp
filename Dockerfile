# Stage 1 - Build the JAR (Java application runtime) using maven
FROM maven:3.9-eclipse-temurin-21 as builder

WORKDIR /app

COPY . .

# Create jar file

RUN mvn clean install -DskipTests=true

# Stage 2 - execute the JAR file from the above stage

FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY --from=builder /app/target/*.jar /app/expenseapp.jar

CMD ["java", "-jar", "expenseapp.jar"]


