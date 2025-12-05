# BigQuery MCP Toolbox - Dockerized

A containerized Google MCP Toolbox for BigQuery operations.

## 🚀 Quick Deploy to Cloud

### Deploy to Google Cloud Run
```bash
# Clone and setup
git clone <your-repo>
cd demo_bigquery_mcp

# Create service account key (upload your service-account-key.json)
gcloud iam service-accounts keys create service-account-key.json \
  --iam-account=aiagent-serivce-account@my-project-13366-bugquery.iam.gserviceaccount.com

# Deploy to Cloud Run
gcloud run deploy bigquery-mcp-toolbox \
  --source . \
  --port 5000 \
  --allow-unauthenticated \
  --region us-central1
```

### Deploy to Render
1. Connect your GitHub repo to Render
2. Create a new Web Service
3. Set environment variables in Render dashboard:
   - `BIGQUERY_PROJECT=my-project-13366-bugquery`
   - `GOOGLE_SERVICE_ACCOUNT_KEY=<your-base64-encoded-key>`
   - `IMPERSONATE_SERVICE_ACCOUNT=aiagent-serivce-account@my-project-13366-bugquery.iam.gserviceaccount.com`

**To get the base64 key:**
```powershell
# On Windows
[Convert]::ToBase64String([IO.File]::ReadAllBytes("service-account-key.json"))
```

## 🔧 Local Development (with Docker)
```bash
# Build and run
docker-compose up --build

# Access at: http://127.0.0.1:5000/mcp
```

## 📋 Environment Variables
- `BIGQUERY_PROJECT`: Your GCP project ID
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to service account key
- `IMPERSONATE_SERVICE_ACCOUNT`: Service account to impersonate

## 🔑 Authentication
The container uses service account key authentication for seamless cloud deployment.

## 🛠 Tools Available
- Execute SQL queries
- Get dataset metadata  
- Get table metadata
- List datasets and tables

## 📚 API Endpoint
Once deployed, the MCP server will be available at:
`https://your-deployment-url/mcp`