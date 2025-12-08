#!/bin/sh
set -e  # Exit on any error

echo "=== Starting Setup ==="

# Check if service account key is provided via environment variable
if [ ! -z "$GOOGLE_SERVICE_ACCOUNT_KEY" ]; then
  echo "Using service account key from environment variable..."
  mkdir -p /app/credentials
  echo "$GOOGLE_SERVICE_ACCOUNT_KEY" | base64 -d > /app/credentials/service-account-key.json
  
  if [ ! -f "/app/credentials/service-account-key.json" ]; then
    echo "ERROR: Failed to create service account key file"
    exit 1
  fi
  
  export GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/service-account-key.json"
  
  echo "Activating service account..."
  gcloud auth activate-service-account --key-file=/app/credentials/service-account-key.json
  
elif [ -f "/app/credentials/service-account-key.json" ]; then
  echo "Using mounted service account key..."
  export GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/service-account-key.json"
  gcloud auth activate-service-account --key-file=/app/credentials/service-account-key.json
  
else
  echo "ERROR: No credentials found. Please provide:"
  echo "  - GOOGLE_SERVICE_ACCOUNT_KEY environment variable (base64 encoded)"
  echo "  - Or mount service-account-key.json file"
  exit 1
fi

echo "Authentication successful!"

# Set up impersonation if needed
if [ ! -z "$IMPERSONATE_SERVICE_ACCOUNT" ]; then
  echo "Setting up impersonation for $IMPERSONATE_SERVICE_ACCOUNT"
  gcloud config set auth/impersonate_service_account $IMPERSONATE_SERVICE_ACCOUNT
fi

echo "=== Starting MCP Toolbox ==="

# Use Render's PORT environment variable if available
export PORT=${PORT:-5000}
export MCP_PORT=$PORT
export MCP_HOST=0.0.0.0

echo "Port: $PORT"
echo "Host: 0.0.0.0"
echo "Working directory: $(pwd)"
echo "Toolbox file: $(ls -lh toolbox)"

# Start the toolbox with explicit host and port binding
# Google MCP Toolbox uses --http-address for the server binding
exec ./toolbox --tools-file "tools.yaml" --http-address "0.0.0.0:$PORT" 2>&1
