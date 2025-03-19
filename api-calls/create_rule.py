import json
import requests
from google.oauth2 import service_account
from google.auth.transport.requests import Request

# Path to your service account JSON file
SERVICE_ACCOUNT_FILE = "./malachite-demo.json"

# Define the required scope
SCOPES = ["https://www.googleapis.com/auth/chronicle-backstory"]

# Authenticate using the service account
credentials = service_account.Credentials.from_service_account_file(
    SERVICE_ACCOUNT_FILE, scopes=SCOPES
)

# Refresh credentials to obtain an access token
credentials.refresh(Request())

# Get the access token
access_token = credentials.token

# API endpoint
url = "https://europe-backstory.googleapis.com/v2/detect/rules"

# Request headers
headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json",
}

# Request payload
payload = {
  "ruleText": """rule mySecondTestRule {
        meta:
            author = "securityuser"
            description = "single event rule that should generate detections"

        events:
            $e.metadata.event_type = "NETWORK_DNS"

        condition:
            $e
    }"""}

# Make the API request
response = requests.post(url, headers=headers, data=json.dumps(payload))

# Print the response
print(response.json())

