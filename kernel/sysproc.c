#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"
#include "uproc.h"
uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if (t == SBRK_EAGER || n < 0) {
    if (growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
      return -1;
    if (addr + n > TRAPFRAME)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if (n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
uint64
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  // Call it directly. No 'if' statement because it returns void!
  argint(0, &n);
    
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
extern struct proc proc[NPROC];
uint64
sys_getprocinfo(void)
{
  uint64 uaddr;
  // Get the pointer argument where user space wants the data stored
  argaddr(0, &uaddr);

  struct proc *p;
  struct uproc up;
  int idx = 0;

  // Loop through all process slots in the kernel
  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    
    // Only capture active processes
    if(p->state != UNUSED) {
      up.pid = p->pid;
      up.priority = p->priority;     // Your custom MLFQ priority field
      up.total_ticks = p->ticks_used; // Your custom tick counter field
      safestrcpy(up.name, p->name, sizeof(p->name));
      
      // Copy this single uproc struct to the user space buffer
      if(copyout(myproc()->pagetable, uaddr + idx * sizeof(struct uproc), (char *)&up, sizeof(struct uproc)) < 0) {
        release(&p->lock);
        return -1;
      }
      idx++;
    }
    release(&p->lock);
  }

  return idx; // Return the total number of active processes found
}
