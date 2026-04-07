#Integer Validation

read -p "Enter an integer to validate: " INTEGER_INPUT
read -p "Enter String to validate: " STRING_INPUT



integer_validation(){
if [[ $INTEGER_INPUT =~ ^[0-9]+$ ]]; then
    echo "Valid integer: $INTEGER_INPUT"
else
    echo "Invalid integer: $INTEGER_INPUT"
fi
}

string_validation(){
    if [[ $STRING_INPUT =~ ^[a-zA-Z]+$ ]]; then
        echo "Valid string: $STRING_INPUT"
    else
        echo "Invalid string: $STRING_INPUT"
    fi
}
integer_validation $INTEGER_INPUT
string_validation $STRING_INPUT

: '
   ^ = Start of string
    [0-9] = Any digit
    + = One or more times
    $ = End of string
'