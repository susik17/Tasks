echo "-----------------Generate Process States---------------------"

echo "------------------------------------"
echo "S -State => wait for event => interruptible sleep => signal -> wakeup(eg:sleep 10)"
echo "------------------------------------"

(sleep 100)&
PID_SLEEP=$!
echo "Created SLEEPING State => PID:$PID_SLEEP"
ps -p $PID_SLEEP -o pid,stat,cmd


echo "------------------------------------"
echo "R -State => running + waiting for CPU(run queue)" 
echo "------------------------------------"

while true ; do :;done &
PID_RUN=$!
echo "Created RUNNING State => PID:$PID_RUN"
ps -p $PID_RUN -o pid,stat,cmd

echo "------------------------------------"
echo "T -state => Stopped or paused process"
echo "------------------------------------"

sleep 100 &
PID_STOP=$!
kill -STOP $PID_STOP
echo "Created STOPPED State => PID:$PID_STOP"
ps -p $PID_STOP -o pid,stat,cmd

echo "------------------------------------"
echo "Z -state => finished but entry still in process table => parent process didn't read exit status => ZOMBIE"
echo "------------------------------------"

bash -c '(exit) & sleep 30'&
PID_ZOMBIE_PARENT=$!
echo "Created ZOMBIE State => ZOMBIE_PPID:$PID_ZOMBIE_PARENT"
echo "view parent state(zombie parent)"
ps -p $PID_ZOMBIE_PARENT -o pid,stat,cmd
echo "view child state(zombie)"
ps aux | awk '$8=="Z" {print "Zombie PID: "$2; exit}' 

echo "----------------------------------------"
# Cleanup -> kill all created processes 
kill $PID_SLEEP $PID_RUN $PID_STOP 2>/dev/null


#D-state => uninterruptible sleep => waiting for I/O => can't be killed => eg: waiting for disk I/O, network I/O, etc. 
#I-state => Idle kernel thread (doing nothing)




