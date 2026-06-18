// user/monitor.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/uproc.h"

int main() {
    struct uproc uproc_table[64]; // Array to hold process data

    while(1) {
        // Clear the screen using terminal escape codes
        printf("\033[2J\033[H"); 
        printf("=== XV6 MLFQ TELEMETRY DASHBOARD ===\n");
        printf("PID\tNAME\t\tPRIORITY\tTOTAL TICKS\n");
        printf("-------------------------------------------------\n");

        int count = getprocinfo(uproc_table);
        if(count < 0) {
            printf("Error fetching process info.\n");
            exit(1);
        }

        for(int i = 0; i < count; i++) {
            printf("%d\t%s\t\t%d\t\t%d\n", 
                   uproc_table[i].pid, 
                   uproc_table[i].name, 
                   uproc_table[i].priority, 
                   uproc_table[i].total_ticks);
        }

        sleep(50); // Refresh roughly every half second
    }
    exit(0);
}