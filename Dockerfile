# --- Stage 1: Build the application ---
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app

# Copy wrapper and build configurations
COPY gradlew ./
COPY gradle/ gradle/
COPY build.gradle settings.gradle ./

# Ensure gradlew is executable
RUN chmod +x gradlew

# Pre-download dependencies (cached if build.gradle doesn't change)
RUN ./gradlew dependencies --no-daemon

# Copy source code and build the JAR file
COPY . .
RUN ./gradlew bootJar --no-daemon

# --- Stage 2: Runtime image ---
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy only the compiled JAR from the builder stage
COPY --from=builder /app/build/libs/session-09-task-apis-v2-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8085
ENTRYPOINT ["java", "-jar", "app.jar"]