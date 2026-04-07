#!/bin/bash

echo "=== Zoho Mail Sender ==="
echo ""

# Get inputs from user
# zoho api console => create self client => get client id, secret, grant token(from get code button)
read -p "Enter Client ID: " CLIENT_ID
read -p "Enter Client Secret: " CLIENT_SECRET
read -s -p "Enter Grant Token: " GRANT_TOKEN
read -p "Enter Your Zoho Email: " FROM_EMAIL
read -p "Enter To Email: " TO_EMAIL
read -p "Enter Subject: " SUBJECT
read -p "Enter Message: " MESSAGE

echo ""
echo "Getting access token..."

# Get Access Token
TOKEN_RESPONSE=$(curl -s -X POST "https://accounts.zoho.in/oauth/v2/token" \
    -d "code=$GRANT_TOKEN" \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "redirect_uri=http://localhost:3000" \
    -d "grant_type=authorization_code")

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$ACCESS_TOKEN" ]; then
    echo "ERROR: Failed to get access token"
    echo "Response: $TOKEN_RESPONSE"
    exit 1
fi

echo "Access token obtained"

# Get Account ID
echo "Getting account ID..."
ACCOUNTS_RESPONSE=$(curl -s -X GET "https://mail.zoho.in/api/accounts" \
    -H "Authorization: Zoho-oauthtoken $ACCESS_TOKEN")

ACCOUNT_ID=$(echo "$ACCOUNTS_RESPONSE" | grep -o '"accountId":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$ACCOUNT_ID" ]; then
    echo "ERROR: Failed to get account ID"
    echo "Response: $ACCOUNTS_RESPONSE"
    exit 1
fi

echo "Account ID: $ACCOUNT_ID"

# Send Email
echo "Sending email..."
SEND_RESPONSE=$(curl -s -X POST "https://mail.zoho.in/api/accounts/$ACCOUNT_ID/messages" \
    -H "Authorization: Zoho-oauthtoken $ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
        \"fromAddress\": \"$FROM_EMAIL\",
        \"toAddress\": \"$TO_EMAIL\",
        \"subject\": \"$SUBJECT\",
        \"content\": \"$MESSAGE\"
    }")

if echo "$SEND_RESPONSE" | grep -q '"status":"success"'; then
    echo "SUCCESS: Email sent to $TO_EMAIL"
else
    echo "FAILED: $SEND_RESPONSE"
fi