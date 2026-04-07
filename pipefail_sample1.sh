#!/bin/bash

ls /etc | grep  "susi" | cat 
echo "Exit code(without pipefail): $?" 
#output: Exit code(without pipefail): 0
set -o pipefail
ls /etc | grep  "susi" | cat
echo "Exit code(with pipefail): $?"
#output: Exit code(with pipefail): 1


#first line of script should be 
#set -euo pipefail to make sure that script exits on any error, unset variable or any command in a pipeline fails. This is a best practice for writing robust bash scripts.
#-e -> exit on error(fail fast), -u -> treat unset/undefined variables as error(prevents typos), -o pipefail -> exit if any command in a pipeline fails