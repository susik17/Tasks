#Strict mode for better error handling
set -euo pipefail

read -p "enter the port number: " PORT_NUMBER
read -p "Enter the environment name(development, staging, production): " ENVIRONMENT_NAME
read -p "Enter the filepath: " FILE_PATH

# Check if user give inputs
if [[ -z "$PORT_NUMBER" || -z "$ENVIRONMENT_NAME" || -z "$FILE_PATH" ]]; then
    echo "Please Enter all inputs"
    exit 1
fi

#Environment validation

environment_validation(){
if [[ "$ENVIRONMENT_NAME" != "development" ]] && [[ "$ENVIRONMENT_NAME" != "staging" ]] && [[ "$ENVIRONMENT_NAME" != "production" ]]; then
    echo "Invalid environment name. Please enter development, staging, or production."
    exit 1
else
    echo "Environment name is valid."
fi
}

# Port number validation

port_validation(){
    if ! [[ "$PORT_NUMBER" =~ ^[0-9]+$ ]] || [ "$PORT_NUMBER" -lt 1024 ] || [ "$PORT_NUMBER" -gt 65535 ]; then
        echo "Invalid port number. Please enter a number between 1024 and 65535."
        exit 1
    else
        echo "Port number is valid."
    fi
}

file_path_validation(){
    #order of checking is important, because if we check file existence before path traversal, it can lead to security issues. For example, if we check file existence first, an attacker could create a symbolic link to a sensitive file (e.g., /etc/passwd) and then provide that path as input.
    #The script would check for the existence of the symbolic link, which would succeed, and then proceed to read the contents of the sensitive file, leading to a potential security breach. By checking for path traversal first, we can prevent such attacks by rejecting any input that contains ".." before checking for file existence.
    #path traversal => e g. /home/user/../etc/passwd
    if [[ "$FILE_PATH" == *".."* ]]; then
        echo "Invalid file path. Path traversal is not allowed."
        exit 1
    fi

    #file extension validation
    # Regex: .json or .yaml at the end of the string
    if [[ ! "$FILE_PATH" =~ \.(json|yaml)$ ]]; then
        echo "Error: Only .json or .yaml files allowed!" >&2
        exit 1
    fi

    #file existence
    if [[ ! -f "$FILE_PATH" ]]; then
        echo "File does not exist. Please enter a valid file path."
        exit 1
    fi

    echo "File path is valid."
    
}


# Call validation functions
environment_validation "$ENVIRONMENT_NAME"
port_validation "$PORT_NUMBER"
file_path_validation "$FILE_PATH"