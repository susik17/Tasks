#!/bin/bash


# can also check  in single line => ^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[@#$%&*]).{8,}$ => readability > cleverness
check_password() {
    local pass="$1"

    # 1. Check length (min 8 chars)
    if [ ${#pass} -lt 8 ]; then
        echo "FAIL: Password too short (min 8 chars)."
        return 1
    fi

    # 2. Check Uppercase
    # -q => quit mode -> not to print anything,only changes exit code ->  match = 0 notmatch =1 
    # -E => Extended Regex -> allow advanced pattern symbols like +, ?, and | directly without needing backslash escapes.
    if ! echo "$pass" | grep -q -E '[A-Z]'; then
        echo "FAIL: Missing Uppercase letter."
        return 1
    fi

    # 3. Check Lowercase
    if ! echo "$pass" | grep -q -E '[a-z]'; then
        echo "FAIL: Missing Lowercase letter."
        return 1
    fi

    # 4. Check Number
    if ! echo "$pass" | grep -q -E '[0-9]'; then
        echo "FAIL: Missing Number."
        return 1
    fi

    # 5. Check Special Character
    if ! echo "$pass" | grep -q -E '[@#$%&*]'; then
        echo "FAIL: Missing Special Character (@#$%&*)."
        return 1
    fi

    echo "SUCCESS: Password is strong!"
    return 0
}

# Interactive Loop
echo "SS Password Validator Started. Type 'stop' to exit."

while true; do
    read -p "Enter password to test: " user_input
    
    if [ "$user_input" == "stop" ]; then
        echo "Bye Bye! Stay secure!"
        break
    fi

    check_password "$user_input"
    echo "--------------------------"
done