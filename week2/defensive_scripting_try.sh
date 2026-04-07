#!/bin/bash

#strict Mode 
# 1. Fail fast => exit immediately on error
set -euo pipefail


#2. Logging  setup (signal vs noise) -> sepeartely log info, error and warning messages => easier to read and analyze logs
# signal = important info(actionable insights, and critical warnings.), noise = less important info
# Defensive goal : filter,prioritize and separate signal from noise in logs
LOG_FILE="defensive_scripting.log"
log_info(){
    echo "$(date '+%Y-%m-%d %H:%M:%S')[INFO] $1" >> "$LOG_FILE"
}
log_error(){
    echo "$(date '+%Y-%m-%d %H:%M:%S')[ERROR] $1" >> "$LOG_FILE"
    echo "ERROR: $1" >&2  #print error on terminal 
}
log_warning(){
    echo "$(date '+%Y-%m-%d %H:%M:%S')[WARNING] $1" >> "$LOG_FILE"
}

DATA_DIR="/home/susi-pt8230/Tasks/week2"

#4. Input Validation => validate user input to prevent unexpected behavior and security vulnerabilities
validate_input(){
    local input="$1"
    if [[ ! $input =~ ^[a-zA-Z]{5,20}$ ]]; then
        echo "Invalid input. Please enter only letters (5-20 characters)."
        log_warning "Invalid input format: $input"
        return 1
    fi
    return 0
}


# Main script logic

main(){
   
    read -p "Enter your name: " name

    # Input validation
    if ! validate_input "$name"; then
        log_error "Process Exited....due to invalid input: $name"
        exit 1
    fi

    log_info "Script started."
    log_info "User entered valid name: $name"
    log_info "Script completed successfully."

    # Create folder safely
    mkdir -p "$DATA_DIR/$name" 2>/dev/null || {
    log_error "Failed to create directory"
    exit 1
    }
    log_info "Directory created for $name"


}

main