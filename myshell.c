#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

#define MAX_LINE 1024
#define MAX_ARGS 64

void handle_sigint(int sig) {
    // Prevent shell from exiting on Ctrl+C
    printf("\nmyshell> ");
    fflush(stdout);
}

int main() {
    char line[MAX_LINE];
    char *args[MAX_ARGS];

    signal(SIGINT, handle_sigint);

    while (1) {
        printf("myshell> ");
        fflush(stdout);

        if (!fgets(line, MAX_LINE, stdin)) {
            printf("\n");
            break;
        }

        // Remove newline
        line[strcspn(line, "\n")] = 0;

        if (strlen(line) == 0)
            continue;

        // Parse arguments
        int i = 0;
        args[i] = strtok(line, " ");
        while (args[i] != NULL && i < MAX_ARGS - 1) {
            i++;
            args[i] = strtok(NULL, " ");
        }

        // Built-in: exit
        if (strcmp(args[0], "exit") == 0)
            break;

        pid_t pid = fork();

        if (pid < 0) {
            perror("fork failed");
            continue;
        }

        if (pid == 0) {
            // Child
            execvp(args[0], args);
            perror("exec failed");
            exit(1);
        } else {
            // Parent
            waitpid(pid, NULL, 0);
        }
    }

    return 0;
}
