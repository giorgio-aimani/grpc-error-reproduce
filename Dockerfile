FROM docker:20.10.15

# Install Java and required dependencies
RUN apk update && apk --no-cache add openjdk17
RUN apk add gcompat libstdc++

# Set a working directory
WORKDIR /app

# Copy your project files
COPY . .

# Set environment variables
ENV MVN_CACHE=.m2/repository
ENV MAVEN_OPTS="-Dmaven.repo.local=/root/$MVN_CACHE -Dorg.slf4j.simpleLogger.log.org.openapitools=off -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn"
ENV MAVEN_CLI_OPTS="--batch-mode --errors --fail-at-end --show-version"

# Verify files are copied and run build
RUN ls -la && \
    uname -a && \
    echo "Building project" && \
    chmod +x mvnw && \
    ./mvnw clean install -DskipTests -X && \
    echo "Listing target directory after build:" && \
    ls -l target/ && \
    echo "Resolving Maven dependencies..." && \
    ./mvnw dependency:resolve

CMD ["tail", "-f", "/dev/null"]
