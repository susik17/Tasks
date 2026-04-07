#include<stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main()
{
	pid_t pid = fork();
        /*
        pid_t -> datatypes for process ids like int,short..
       	fork() ->   
        0: In the child process.
        A positive number: In the parent process (this is the actual PID of the new child).
        -1: If the fork failed (error).
        */
	if(pid > 0){
		//parent process
                printf("Parent PID: %d\n", getpid());
		sleep(100);
		printf("Parent Process Exit..");


	}
	else if ( pid == 0){
		//child process 
		printf("Child Process exit...");
                exit(0);
	}
        return 0;
}


//check 
/*
here ppid;981577 the next chid : pid:981578 -> goes into zombie state
ps -eo pid,ppid,state,cmd | grep "zombie"
 ppid     pid  state  cmd
 981577  446067 S ./zombie
 981578  981577 Z [zombie] <defunct>
 981714  463740 S grep --color=auto zombie
*/
