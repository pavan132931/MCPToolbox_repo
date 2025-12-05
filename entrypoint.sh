#!/bin/sh

# Check if service account key is provided via environment variable
if [ ! -z "$GOOGLE_SERVICE_ACCOUNT_KEY" ]; then
  echo "Using service account key from environment variable..."
  mkdir -p /app/credentials
  echo "$GOOGLE_SERVICE_ACCOUNT_KEY" | base64 -d > /app/credentials/service-account-key.json
  export GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/service-account-key.json"
  
  # Activate service account
  gcloud auth activate-service-account --key-file=/app/credentials/service-account-key.json
  
elif [ -f "/app/credentials/service-account-key.json" ]; then
  echo "Using mounted service account key..."
  export GOOGLE_APPLICATION_CREDENTIALS="/app/credentials/service-account-key.json"
  
  # Activate service account
  gcloud auth activate-service-account --key-file=/app/credentials/service-account-key.json
  
else
  echo "No credentials found. Please provide:"
  echo "  - GOOGLE_SERVICE_ACCOUNT_KEY environment variable (base64 encoded)"
  echo "  - Or mount service-account-key.json file"
  exit 1
fi

# Set up impersonation if needed
if [ ! -z "$IMPERSONATE_SERVICE_ACCOUNT" ]; then
  echo "Setting up impersonation for $IMPERSONATE_SERVICE_ACCOUNT"
  gcloud config set auth/impersonate_service_account $IMPERSONATE_SERVICE_ACCOUNT
fi

echo "Starting MCP Toolbox..."

# Start the toolbox
exec ./toolbox --tools-file "tools.yaml"
