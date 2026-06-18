#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h" 

int main(int argc, char *argv[]) {
    printf("Starting CPU Hog Test...\n");
    
    //heavy task
    for(long i = 0; i < 100000000; i++) {
        
        if (i % 10000000 == 0) {
            printf("Still working... (loop index: %ld)\n", i);
        }
    }
    
    printf("Test finished!\n");
    exit(0);
}