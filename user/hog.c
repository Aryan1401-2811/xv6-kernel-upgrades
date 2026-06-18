#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
    volatile int dummy = 0;
    
    // A loop big enough to take a few seconds, but not infinite
    for(long long i = 0; i < 500000000; i++) {
        dummy = dummy + 1; 
    }
    
    printf("Hog finally finished!\n");
    exit(0); 
}