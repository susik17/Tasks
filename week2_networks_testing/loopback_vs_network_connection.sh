echo "Now wifi/ethernet turn offed state"

# loopback => kernal software feature => if localhost ip => no need for go outside => direct route for local process&response to browser
echo "Test loopback"
ping 127.0.0.1
echo "It works well even no internet connection"


echo "Test Google(internet needs for connection)"
ping 8.8.8.8