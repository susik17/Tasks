#!/bin/bash

# mail -> settings-> IMAP enable 
# Zoho SMTP Details
SMTP_SERVER="smtp.zoho.in"  
SMTP_PORT="587"
FROM_EMAIL="susi.k@zohointern.com" 

# Get inputs
echo "=== Zoho Mail Sender ==="
read -p "Receiver Email: " TO_EMAIL
read -p "Subject: " SUBJECT
read -p "Message: " MESSAGE
read -sp "Enter Zoho App Password: " APP_PASSWORD
echo "" 
#App password => zohoAccount -> security -> generate app password -> generate


# Construct Email Content
# Header & Body separate 
EMAIL_CONTENT=$(cat <<EOF
Subject: $SUBJECT
From: $FROM_EMAIL
To: $TO_EMAIL

$MESSAGE
EOF
)

# send => Curl Command
echo "Sending mail..."

echo "$EMAIL_CONTENT" | curl --url "smtp://$SMTP_SERVER:$SMTP_PORT" \
  --ssl-reqd \
  --mail-from "$FROM_EMAIL" \
  --mail-rcpt "$TO_EMAIL" \
  --user "$FROM_EMAIL:$APP_PASSWORD" \
  --upload-file -

# Status Check
if [ $? -eq 0 ]; then
    echo "Mail Successfully Sent!"
else
    echo "Failed to send mail. Check password or internet."
fi