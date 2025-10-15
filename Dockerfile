# Start from an official JDK base image
FROM openjdk:17-jdk-slim

# Set working directory inside container
WORKDIR /app

# Copy everything to /app
COPY . /app

# Compile the Java file
RUN javac src/Main.java

# Set the default command to run your program
CMD ["java", "-cp", "src", "Main"]
