struct uproc {
    int pid;
    int priority;
    unsigned int total_ticks; // Use standard C type to avoid dependency errors
    char name[16];
};