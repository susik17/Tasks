#!/usr/bin/env python3

def fcfs(processes, burst_times):
    """First Come First Serve"""
    print("\n=== FCFS (First Come First Serve) ===")
    waiting_time = 0
    total_wt = 0
    total_tat = 0
    
    print(f"{'Process':<10} {'Burst':<10} {'Waiting':<10} {'Turnaround':<10}")
    print("-" * 45)
    
    for i in range(len(processes)):
        turnaround = waiting_time + burst_times[i]
        print(f"{processes[i]:<10} {burst_times[i]:<10} {waiting_time:<10} {turnaround:<10}")
        total_wt += waiting_time
        total_tat += turnaround
        waiting_time += burst_times[i]
    
    print("-" * 45)
    print(f"Average Waiting Time: {total_wt/len(processes):.2f}")
    print(f"Average Turnaround Time: {total_tat/len(processes):.2f}")

def sjf(processes, burst_times):
    """Shortest Job First (Non-Preemptive)"""
    print("\n=== SJF (Shortest Job First) ===")
    
    # Sort by burst time
    combined = list(zip(processes, burst_times))
    combined.sort(key=lambda x: x[1])
    processes = [x[0] for x in combined]
    burst_times = [x[1] for x in combined]
    
    waiting_time = 0
    total_wt = 0
    total_tat = 0
    
    print(f"{'Process':<10} {'Burst':<10} {'Waiting':<10} {'Turnaround':<10}")
    print("-" * 45)
    
    for i in range(len(processes)):
        turnaround = waiting_time + burst_times[i]
        print(f"{processes[i]:<10} {burst_times[i]:<10} {waiting_time:<10} {turnaround:<10}")
        total_wt += waiting_time
        total_tat += turnaround
        waiting_time += burst_times[i]
    
    print("-" * 45)
    print(f"Average Waiting Time: {total_wt/len(processes):.2f}")
    print(f"Average Turnaround Time: {total_tat/len(processes):.2f}")

def rr(processes, burst_times, time_quantum):
    """Round Robin"""
    print(f"\n=== Round Robin (Time Quantum: {time_quantum}) ===")
    
    remaining_burst = burst_times.copy()
    waiting_time = [0] * len(processes)
    turnaround_time = [0] * len(processes)
    time = 0
    completed = 0
    n = len(processes)
    
    print(f"Execution Order: ", end="")
    
    while completed < n:
        for i in range(n):
            if remaining_burst[i] > 0:
                if remaining_burst[i] <= time_quantum:
                    time += remaining_burst[i]
                    turnaround_time[i] = time
                    remaining_burst[i] = 0
                    completed += 1
                    print(f"{processes[i]} ", end="")
                else:
                    time += time_quantum
                    remaining_burst[i] -= time_quantum
                    print(f"{processes[i]} ", end="")
    
    print("\n")
    print(f"{'Process':<10} {'Burst':<10} {'Turnaround':<10} {'Waiting':<10}")
    print("-" * 45)
    
    total_wt = 0
    total_tat = 0
    for i in range(n):
        waiting_time[i] = turnaround_time[i] - burst_times[i]
        total_wt += waiting_time[i]
        total_tat += turnaround_time[i]
        print(f"{processes[i]:<10} {burst_times[i]:<10} {turnaround_time[i]:<10} {waiting_time[i]:<10}")
    
    print("-" * 45)
    print(f"Average Waiting Time: {total_wt/n:.2f}")
    print(f"Average Turnaround Time: {total_tat/n:.2f}")

def cfs_simulation(processes, burst_times):
    """CFS Simulation (Simplified - Based on Nice Values)"""
    print("\n=== CFS (Completely Fair Scheduler) Simulation ===")
    print("Note: CFS uses virtual runtime (vruntime) for fairness")
    
    # Simulate with nice values (lower nice = higher priority)
    nice_values = [0] * len(processes)  # Default nice = 0
    
    print(f"{'Process':<10} {'Burst':<10} {'Nice':<10} {'Weight':<10}")
    print("-" * 45)
    
    # CFS weights based on nice values (simplified)
    weights = [1024] * len(processes)  # Default weight for nice 0
    
    for i in range(len(processes)):
        print(f"{processes[i]:<10} {burst_times[i]:<10} {nice_values[i]:<10} {weights[i]:<10}")
    
    print("-" * 45)
    print("CFS Logic: Each process gets CPU time proportional to its weight")
    print("Lower nice value = Higher weight = More CPU time")
    print("All processes run fairly based on vruntime")

def main():
    print("=" * 50)
    print("CPU Scheduling Algorithm Simulator")
    print("=" * 50)
    
    # Get input
    n = int(input("\nEnter number of processes: "))
    processes = []
    burst_times = []
    
    for i in range(n):
        processes.append(f"P{i+1}")
        burst = int(input(f"Enter burst time for {processes[i]}: "))
        burst_times.append(burst)
    
    # Run all algorithms
    fcfs(processes.copy(), burst_times.copy())
    sjf(processes.copy(), burst_times.copy())
    
    tq = int(input("\nEnter Time Quantum for Round Robin: "))
    rr(processes.copy(), burst_times.copy(), tq)
    
    cfs_simulation(processes.copy(), burst_times.copy())
    
    print("\n" + "=" * 50)
    print("Simulation Complete!")
    print("=" * 50)

if __name__ == "__main__":
    main()