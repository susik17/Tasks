

#!/bin/bash
CPU_USAGE=85.5
THRESHOLD=80.0
#================FLOATING POINT COMPARISON=================
IS_HIGH=$(awk -v cpu="$CPU_USAGE" -v thresh="$THRESHOLD" 'BEGIN {print (cpu > thresh) ? 1 : 0}')
#===============================================================================================
#bash can't compare floats directly, so we use awk to evaluate the expression and return 1 if true, 0 if false.
#-v cpu="$CPU_USAGE" → Variable Passing
# BEGIN: Input file ethavathu kudukka thevai illa, udane indha logic run pannu nu artham.

if [ "$IS_HIGH" -eq 1 ]; then
    echo "CPU usage is above threshold!"
else
    echo "CPU usage is within limits."
fi