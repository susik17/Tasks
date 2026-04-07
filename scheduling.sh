#!/bin/bash

# --- FCFS Function ---
run_fcfs() {
    echo ""
    echo "--- FCFS (First Come First Serve) ---"
    # Process IDs & Burst Times
    pids=(1 2 3)
    bursts=(10 5 8)
    # Number of processes || pids => array || [@]=> all elements || # => length of array
    n=${#pids[@]}
    
    waiting=0
    total_wait=0
    total_tat=0

    echo "P_ID   Burst   Waiting   Turnaround"
    for ((i=0; i<n; i++)); do
        tat=$((waiting + bursts[i]))
        echo "${pids[i]}      ${bursts[i]}       $waiting         $tat"
        
        total_wait=$((total_wait + waiting))
        total_tat=$((total_tat + tat))
        
        # Next process => waiting time = current burst + current waiting
        waiting=$((waiting + bursts[i]))
    done

    avg_wait=$((total_wait / n))
    avg_tat=$((total_tat / n))
    echo "Average Waiting Time: $avg_wait"
    echo "Average Turnaround Time: $avg_tat"
}

# --- SJF Function (Shortest Job First) ---
run_sjf() {
    echo ""
    echo "--- SJF (Shortest Job First) ---"
    # Data
    pids=(1 2 3 4)
    bursts=(6 8 7 3)
    n=${#pids[@]}

    # Bubble Sort for Burst Times 
    for ((i=0; i<n; i++)); do
        for ((j=0; j<n-i-1; j++)); do
            if [ ${bursts[j]} -gt ${bursts[$((j+1))]} ]; then
                # Swap Burst
                temp=${bursts[j]}
                bursts[j]=${bursts[$((j+1))]}
                bursts[$((j+1))]=$temp
                # Swap PID to match
                temp=${pids[j]}
                pids[j]=${pids[$((j+1))]}
                pids[$((j+1))]=$temp
            fi
        done
    done

    waiting=0
    total_wait=0
    total_tat=0

    echo "P_ID   Burst   Waiting   Turnaround"
    for ((i=0; i<n; i++)); do
        tat=$((waiting + bursts[i]))
        echo "${pids[i]}      ${bursts[i]}       $waiting         $tat"
        
        total_wait=$((total_wait + waiting))
        total_tat=$((total_tat + tat))
        waiting=$((waiting + bursts[i]))
    done

    avg_wait=$((total_wait / n))
    avg_tat=$((total_tat / n))
    echo "Average Waiting Time: $avg_wait"
}

# --- Priority Function ---
run_priority() {
    echo ""
    echo "--- Priority Scheduling ---"
    # Data (Priority: 1 is Highest)
    pids=(1 2 3)
    bursts=(10 5 8)
    prior=(3 1 2)
    n=${#pids[@]}

    # Sort based on Priority
    for ((i=0; i<n; i++)); do
        for ((j=0; j<n-i-1; j++)); do
            if [ ${prior[j]} -gt ${prior[$((j+1))]} ]; then
                # Swap Priority
                temp=${prior[j]}
                prior[j]=${prior[$((j+1))]}
                prior[$((j+1))]=$temp
                # Swap Burst
                temp=${bursts[j]}
                bursts[j]=${bursts[$((j+1))]}
                bursts[$((j+1))]=$temp
                # Swap PID
                temp=${pids[j]}
                pids[j]=${pids[$((j+1))]}
                pids[$((j+1))]=$temp
            fi
        done
    done

    waiting=0
    total_wait=0

    echo "P_ID   Burst   Priority   Waiting"
    for ((i=0; i<n; i++)); do
        echo "${pids[i]}      ${bursts[i]}       ${prior[i]}          $waiting"
        total_wait=$((total_wait + waiting))
        waiting=$((waiting + bursts[i]))
    done

    avg_wait=$((total_wait / n))
    echo "Average Waiting Time: $avg_wait"
}

# -------------- CFS Function ------------
run_cfs() {
    echo ""
    echo "--- CFS (Completely Fair Scheduler) ---"
    # Bash => No float support  => simple integer logic
    pids=(1 2 3)
    bursts=(5 3 4)
    weights=(1 2 1) # Weight high => priority high => vruntime increase slow
    n=${#pids[@]}
    
    # Remaining burst copy
    remaining=("${bursts[@]}")
    vruntime=(0 0 0)

    echo "Running Processes..."
    while true; do
        sum=0
        for r in "${remaining[@]}"; do sum=$((sum + r)); done
        [ $sum -eq 0 ] && break

        # Find min vruntime among active processes
        min_vr=999999
        selected=-1
        for ((i=0; i<n; i++)); do
            if [ ${remaining[i]} -gt 0 ]; then
                if [ ${vruntime[i]} -lt $min_vr ]; then
                    min_vr=${vruntime[i]}
                    selected=$i
                fi
            fi
        done

        if [ $selected -ne -1 ]; then
            # Execute 1 unit
            remaining[$selected]=$((remaining[$selected] - 1))
            # Update VRuntime (Simple: vruntime += 1/weight)
            vruntime[$selected]=$((vruntime[$selected] + 1)) 
            echo "Executed P${pids[$selected]} (Rem: ${remaining[$selected]})"
        fi
    done

    echo "Simulation Complete."
}

# --- Main Menu ---
while true; do
    echo ""
    echo "=============================="
    echo "  CPU Scheduling (Shell Script) "
    echo "=============================="
    echo "1. FCFS"
    echo "2. SJF"
    echo "3. Priority"
    echo "4. CFS"
    echo "5. Exit"
    echo ""
    read -p "Enter Choice (1-5): " choice

    case $choice in
        1) run_fcfs ;;
        2) run_sjf ;;
        3) run_priority ;;
        4) run_cfs ;;
        5) echo "Bye!"; exit 0 ;;
        *) echo "Invalid Choice!" ;;
    esac
done