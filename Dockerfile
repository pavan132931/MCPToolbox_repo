FROM google/cloud-sdk:alpine

# Install necessary dependencies
RUN apk add --no-cache \
    ca-certificates \
    wget \
    curl

# Set working directory first
WORKDIR /app

# Download toolbox from official releases
ENV VERSION=0.22.0
RUN curl -L -o toolbox https://storage.googleapis.com/genai-toolbox/v$VERSION/linux/amd64/toolbox \
    && chmod +x toolbox

# Copy configuration files
COPY tools.yaml /app/tools.yaml

# Expose the MCP port
EXPOSE 5000

# Set environment variables
ENV BIGQUERY_PROJECT=my-project-13366-bugquery

# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
