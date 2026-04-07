#!/bin/bash

# Simple Zoho Mail Automation Script

# Get credentials
echo "Zoho Mail Automation"
echo "===================="
read -p "Client ID: " CLIENT_ID
read -s -p "Client Secret: " CLIENT_SECRET
echo
read -s -p "Refresh Token: " REFRESH_TOKEN
echo
read -p "From Email: " FROM_EMAIL
read -p "To Email: " TO_EMAIL
read -p "Subject: " SUBJECT
read -p "Message Body: " BODY

echo
echo "Generating access token..."
ACCESS_TOKEN=$(curl -s -X POST "https://accounts.zoho.com/oauth/v2/token" \
    -d "client_id=$CLIENT_ID" \
    -d "client_secret=$CLIENT_SECRET" \
    -d "grant_type=refresh_token" \
    -d "refresh_token=$REFRESH_TOKEN" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$ACCESS_TOKEN" ]; then
    echo "Failed to get access token"
    exit 1
fi

echo "Getting account ID..."
ACCOUNT_ID=$(curl -s -X GET "https://mail.zoho.com/api/accounts" \
    -H "Authorization: Zoho-oauthtoken $ACCESS_TOKEN" | grep -o '"accountId":"[^"]*' | cut -d'"' -f4 | head -1)

echo "Sending email..."
RESPONSE=$(curl -s -X POST "https://mail.zoho.com/api/accounts/$ACCOUNT_ID/messages" \
    -H "Authorization: Zoho-oauthtoken $ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"from\":\"$FROM_EMAIL\",\"to\":[{\"email\":\"$TO_EMAIL\"}],\"subject\":\"$SUBJECT\",\"content\":\"$BODY\"}")

if echo "$RESPONSE" | grep -q "messageId"; then
    echo "Email sent successfully!"
    echo "Response: $RESPONSE"
else
    echo "Failed to send email"
    echo "Response: $RESPONSE"
fi