FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy Gradle wrapper and configuration files
COPY gradlew ./
COPY gradle/ gradle/
COPY build.gradle settings.gradle ./

# Pre-download dependencies
RUN ./gradlew dependencies --no-daemon

# Copy the rest of the project source code
COPY . .

# Build the application jar
RUN ./gradlew bootJar --no-daemon

EXPOSE 8085
ENTRYPOINT ["java", "-jar", "build/libs/*.jar"]