FROM google/cloud-sdk:alpine

# Install necessary dependencies
RUN apk add --no-cache \
    ca-certificates \
    wget \
    curl

# Download toolbox from official releases
ENV VERSION=0.22.0
RUN curl -L -o /app/toolbox https://storage.googleapis.com/genai-toolbox/v$VERSION/linux/amd64/toolbox \
    && chmod +x /app/toolbox

# Copy configuration files
COPY tools.yaml /app/tools.yaml

# Set working directory
WORKDIR /app

# Expose the MCP port
EXPOSE 5000

# Set environment variables
ENV BIGQUERY_PROJECT=my-project-13366-bugquery

# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]