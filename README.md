# XV6 OS: Multi-Level Feedback Queue & Live Telemetry

This repository features a customized version of the **xv6 operating system**. I have taken the base xv6 kernel and completely rewritten its process scheduler to use a **Multi-Level Feedback Queue (MLFQ)**, alongside a custom system call and a live, user-space telemetry dashboard to monitor the CPU in real-time.

##  What's New in This Version?

### 1. The MLFQ Scheduler
The default xv6 uses a simple Round-Robin scheduler. This modified kernel replaces that with an intelligent, priority-based MLFQ:
* **Dynamic Priorities:** Processes are dynamically shifted between priority queues based on their real-time CPU usage.
* **Preemption:** Background "CPU hogs" are penalized and dropped to lower priorities, allowing quick, interactive tasks to preempt them instantly.
* **Kernel Timer Integration:** Modified the `trap.c` hardware timer interrupts to accurately track `ticks_used` per process and enforce strict time-slices.

### 2. Custom System Call (`sys_getprocinfo`)
To safely bridge kernel data to user space, I built a custom system call from scratch. It extracts the active process table (including `pid`, `state`, `priority`, and `total_ticks`) from kernel memory and securely copies it to a user-space struct.

### 3. Live Telemetry Dashboard (`monitor`)
Built a top-like activity monitor that runs in user space. It refreshes automatically (using a modified `sleep` call) to provide a real-time, visual dashboard of processes moving through the MLFQ queues.

---

##  Building and Running

To run this on your local machine, you will need a RISC-V "newlib" tool chain from [riscv-gnu-toolchain](https://github.com/riscv/riscv-gnu-toolchain), and `qemu` compiled for `riscv64-softmmu`.

Once installed and in your shell search path, open your terminal and run:

```bash
# Compile the OS and launch the QEMU emulator
make qemu
