FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copy wrapper and build configurations
COPY gradlew ./
COPY gradle/ gradle/
COPY build.gradle settings.gradle ./

# Ensure gradlew is executable before any run command
RUN chmod +x gradlew

# Pre-download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy source code and build
COPY . .
RUN ./gradlew bootJar --no-daemon

EXPOSE 8085
ENTRYPOINT ["java", "-jar", "build/libs/*.jar"]