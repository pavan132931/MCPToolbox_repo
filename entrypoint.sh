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
RENDER_PORT=${PORT:-5000}

echo "Port: $RENDER_PORT"
echo "Working directory: $(pwd)"
echo "Toolbox file: $(ls -lh toolbox)"

echo ""
echo "=== Starting toolbox on 0.0.0.0:$RENDER_PORT ==="

# The toolbox uses separate --address and --port flags
exec ./toolbox --tools-file "tools.yaml" --address "0.0.0.0" --port "$RENDER_PORT" 2>&1
