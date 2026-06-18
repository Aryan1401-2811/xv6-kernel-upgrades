#include "kernel/types.h"
#include "user/user.h"

int main() {
    printf("--- RACE STARTING ---\n");

    int pid = fork(); // Create a second process

    if(pid == 0) {
        // CHILD PROCESS: Run the Hog
        char *argv[] = {"hog", 0};
        exec("hog", argv);
    } else {
        // PARENT PROCESS: Wait a tiny bit, then run the Task
        // This sleep gives the Hog time to use up its ticks and get demoted!
        sleep(20); 
        
        int pid2 = fork();
        if(pid2 == 0) {
            char *argv[] = {"task", 0};
            exec("task", argv);
        }
        
        // Wait for both to finish so the shell doesn't crash
        wait(0); 
        wait(0);
        printf("--- RACE FINISHED ---\n");
    }
    exit(0);
}