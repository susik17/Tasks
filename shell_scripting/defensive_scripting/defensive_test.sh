read -p  "USER_NAME: " USER_NAME
read -s -p "PASSWORD: " PASSWORD




if [ ! $USER_NAME ~= "^a-zA-Z" ] && [ len($USER_NAME) -lt 5];
then 
    exit 1
fi

if [ -z "$USER_NAME" ] || [ -z "$PASSWORD" ]; then
    exit 1
fi

