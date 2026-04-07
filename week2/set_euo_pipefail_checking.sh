
set -euo pipefail 

#check -u => unset variable => error
echo "Checking -u"
read -p  "enter name:" 
echo "hello $name"
echo "Printing Done" 

#check -e => command error => exit
echo "Checking -e"
echo "start"
ls /tmp/hello.txt #fiel not exits => error
echo "still continue even file not exits"
echo "contine.....script"
echo "end"

#check -o pipefail => command error in pipe => exit
echo "Pipefail checking"
echo "start"
ls /tmp/hello.txt | grep "hello" #fiel not exits => error
echo "still continue even file not exits"
echo "contine.....script"
echo "end"

#witghout -u => without name -> enter press => op:hello

