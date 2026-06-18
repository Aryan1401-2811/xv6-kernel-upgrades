
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	87010113          	addi	sp,sp,-1936 # 80007870 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63));
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdda87>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	e0a78793          	addi	a5,a5,-502 # 80000e82 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b0:	f6dff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000b4:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000b8:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000ba:	823e                	mv	tp,a5
  asm volatile("mret");
    800000bc:	30200073          	mret
}
    800000c0:	60a2                	ld	ra,8(sp)
    800000c2:	6402                	ld	s0,0(sp)
    800000c4:	0141                	addi	sp,sp,16
    800000c6:	8082                	ret

00000000800000c8 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000c8:	7119                	addi	sp,sp,-128
    800000ca:	fc86                	sd	ra,120(sp)
    800000cc:	f8a2                	sd	s0,112(sp)
    800000ce:	f4a6                	sd	s1,104(sp)
    800000d0:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000d2:	06c05b63          	blez	a2,80000148 <consolewrite+0x80>
    800000d6:	f0ca                	sd	s2,96(sp)
    800000d8:	ecce                	sd	s3,88(sp)
    800000da:	e8d2                	sd	s4,80(sp)
    800000dc:	e4d6                	sd	s5,72(sp)
    800000de:	e0da                	sd	s6,64(sp)
    800000e0:	fc5e                	sd	s7,56(sp)
    800000e2:	f862                	sd	s8,48(sp)
    800000e4:	f466                	sd	s9,40(sp)
    800000e6:	f06a                	sd	s10,32(sp)
    800000e8:	8b2a                	mv	s6,a0
    800000ea:	8bae                	mv	s7,a1
    800000ec:	8a32                	mv	s4,a2
  int i = 0;
    800000ee:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000f0:	02000c93          	li	s9,32
    800000f4:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    800000f8:	f8040a93          	addi	s5,s0,-128
    800000fc:	5c7d                	li	s8,-1
    800000fe:	a025                	j	80000126 <consolewrite+0x5e>
    if (nn > n - i)
    80000100:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000104:	86ce                	mv	a3,s3
    80000106:	01748633          	add	a2,s1,s7
    8000010a:	85da                	mv	a1,s6
    8000010c:	8556                	mv	a0,s5
    8000010e:	1c2020ef          	jal	800022d0 <either_copyin>
    80000112:	03850d63          	beq	a0,s8,8000014c <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000116:	85ce                	mv	a1,s3
    80000118:	8556                	mv	a0,s5
    8000011a:	7b4000ef          	jal	800008ce <uartwrite>
    i += nn;
    8000011e:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000122:	0144d963          	bge	s1,s4,80000134 <consolewrite+0x6c>
    if (nn > n - i)
    80000126:	409a07bb          	subw	a5,s4,s1
    8000012a:	893e                	mv	s2,a5
    8000012c:	fcfcdae3          	bge	s9,a5,80000100 <consolewrite+0x38>
    80000130:	896a                	mv	s2,s10
    80000132:	b7f9                	j	80000100 <consolewrite+0x38>
    80000134:	7906                	ld	s2,96(sp)
    80000136:	69e6                	ld	s3,88(sp)
    80000138:	6a46                	ld	s4,80(sp)
    8000013a:	6aa6                	ld	s5,72(sp)
    8000013c:	6b06                	ld	s6,64(sp)
    8000013e:	7be2                	ld	s7,56(sp)
    80000140:	7c42                	ld	s8,48(sp)
    80000142:	7ca2                	ld	s9,40(sp)
    80000144:	7d02                	ld	s10,32(sp)
    80000146:	a821                	j	8000015e <consolewrite+0x96>
  int i = 0;
    80000148:	4481                	li	s1,0
    8000014a:	a811                	j	8000015e <consolewrite+0x96>
    8000014c:	7906                	ld	s2,96(sp)
    8000014e:	69e6                	ld	s3,88(sp)
    80000150:	6a46                	ld	s4,80(sp)
    80000152:	6aa6                	ld	s5,72(sp)
    80000154:	6b06                	ld	s6,64(sp)
    80000156:	7be2                	ld	s7,56(sp)
    80000158:	7c42                	ld	s8,48(sp)
    8000015a:	7ca2                	ld	s9,40(sp)
    8000015c:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000015e:	8526                	mv	a0,s1
    80000160:	70e6                	ld	ra,120(sp)
    80000162:	7446                	ld	s0,112(sp)
    80000164:	74a6                	ld	s1,104(sp)
    80000166:	6109                	addi	sp,sp,128
    80000168:	8082                	ret

000000008000016a <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016a:	711d                	addi	sp,sp,-96
    8000016c:	ec86                	sd	ra,88(sp)
    8000016e:	e8a2                	sd	s0,80(sp)
    80000170:	e4a6                	sd	s1,72(sp)
    80000172:	e0ca                	sd	s2,64(sp)
    80000174:	fc4e                	sd	s3,56(sp)
    80000176:	f852                	sd	s4,48(sp)
    80000178:	f05a                	sd	s6,32(sp)
    8000017a:	ec5e                	sd	s7,24(sp)
    8000017c:	1080                	addi	s0,sp,96
    8000017e:	8b2a                	mv	s6,a0
    80000180:	8a2e                	mv	s4,a1
    80000182:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000184:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000186:	0000f517          	auipc	a0,0xf
    8000018a:	6ea50513          	addi	a0,a0,1770 # 8000f870 <cons>
    8000018e:	277000ef          	jal	80000c04 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    80000192:	0000f497          	auipc	s1,0xf
    80000196:	6de48493          	addi	s1,s1,1758 # 8000f870 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000019a:	0000f917          	auipc	s2,0xf
    8000019e:	76e90913          	addi	s2,s2,1902 # 8000f908 <cons+0x98>
  while (n > 0) {
    800001a2:	0b305b63          	blez	s3,80000258 <consoleread+0xee>
    while (cons.r == cons.w) {
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	0af71063          	bne	a4,a5,8000024e <consoleread+0xe4>
      if (killed(myproc())) {
    800001b2:	750010ef          	jal	80001902 <myproc>
    800001b6:	7b3010ef          	jal	80002168 <killed>
    800001ba:	e12d                	bnez	a0,8000021c <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001bc:	85a6                	mv	a1,s1
    800001be:	854a                	mv	a0,s2
    800001c0:	56d010ef          	jal	80001f2c <sleep>
    while (cons.r == cons.w) {
    800001c4:	0984a783          	lw	a5,152(s1)
    800001c8:	09c4a703          	lw	a4,156(s1)
    800001cc:	fef703e3          	beq	a4,a5,800001b2 <consoleread+0x48>
    800001d0:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001d2:	0000f717          	auipc	a4,0xf
    800001d6:	69e70713          	addi	a4,a4,1694 # 8000f870 <cons>
    800001da:	0017869b          	addiw	a3,a5,1
    800001de:	08d72c23          	sw	a3,152(a4)
    800001e2:	07f7f693          	andi	a3,a5,127
    800001e6:	9736                	add	a4,a4,a3
    800001e8:	01874703          	lbu	a4,24(a4)
    800001ec:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    800001f0:	4691                	li	a3,4
    800001f2:	04da8663          	beq	s5,a3,8000023e <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001f6:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001fa:	4685                	li	a3,1
    800001fc:	faf40613          	addi	a2,s0,-81
    80000200:	85d2                	mv	a1,s4
    80000202:	855a                	mv	a0,s6
    80000204:	082020ef          	jal	80002286 <either_copyout>
    80000208:	57fd                	li	a5,-1
    8000020a:	04f50663          	beq	a0,a5,80000256 <consoleread+0xec>
      break;

    dst++;
    8000020e:	0a05                	addi	s4,s4,1
    --n;
    80000210:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    80000212:	47a9                	li	a5,10
    80000214:	04fa8b63          	beq	s5,a5,8000026a <consoleread+0x100>
    80000218:	7aa2                	ld	s5,40(sp)
    8000021a:	b761                	j	800001a2 <consoleread+0x38>
        release(&cons.lock);
    8000021c:	0000f517          	auipc	a0,0xf
    80000220:	65450513          	addi	a0,a0,1620 # 8000f870 <cons>
    80000224:	271000ef          	jal	80000c94 <release>
        return -1;
    80000228:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000022a:	60e6                	ld	ra,88(sp)
    8000022c:	6446                	ld	s0,80(sp)
    8000022e:	64a6                	ld	s1,72(sp)
    80000230:	6906                	ld	s2,64(sp)
    80000232:	79e2                	ld	s3,56(sp)
    80000234:	7a42                	ld	s4,48(sp)
    80000236:	7b02                	ld	s6,32(sp)
    80000238:	6be2                	ld	s7,24(sp)
    8000023a:	6125                	addi	sp,sp,96
    8000023c:	8082                	ret
      if (n < target) {
    8000023e:	0179fa63          	bgeu	s3,s7,80000252 <consoleread+0xe8>
        cons.r--;
    80000242:	0000f717          	auipc	a4,0xf
    80000246:	6cf72323          	sw	a5,1734(a4) # 8000f908 <cons+0x98>
    8000024a:	7aa2                	ld	s5,40(sp)
    8000024c:	a031                	j	80000258 <consoleread+0xee>
    8000024e:	f456                	sd	s5,40(sp)
    80000250:	b749                	j	800001d2 <consoleread+0x68>
    80000252:	7aa2                	ld	s5,40(sp)
    80000254:	a011                	j	80000258 <consoleread+0xee>
    80000256:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000258:	0000f517          	auipc	a0,0xf
    8000025c:	61850513          	addi	a0,a0,1560 # 8000f870 <cons>
    80000260:	235000ef          	jal	80000c94 <release>
  return target - n;
    80000264:	413b853b          	subw	a0,s7,s3
    80000268:	b7c9                	j	8000022a <consoleread+0xc0>
    8000026a:	7aa2                	ld	s5,40(sp)
    8000026c:	b7f5                	j	80000258 <consoleread+0xee>

000000008000026e <consputc>:
{
    8000026e:	1141                	addi	sp,sp,-16
    80000270:	e406                	sd	ra,8(sp)
    80000272:	e022                	sd	s0,0(sp)
    80000274:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000276:	10000793          	li	a5,256
    8000027a:	00f50863          	beq	a0,a5,8000028a <consputc+0x1c>
    uartputc_sync(c);
    8000027e:	6e4000ef          	jal	80000962 <uartputc_sync>
}
    80000282:	60a2                	ld	ra,8(sp)
    80000284:	6402                	ld	s0,0(sp)
    80000286:	0141                	addi	sp,sp,16
    80000288:	8082                	ret
    uartputc_sync('\b');
    8000028a:	4521                	li	a0,8
    8000028c:	6d6000ef          	jal	80000962 <uartputc_sync>
    uartputc_sync(' ');
    80000290:	02000513          	li	a0,32
    80000294:	6ce000ef          	jal	80000962 <uartputc_sync>
    uartputc_sync('\b');
    80000298:	4521                	li	a0,8
    8000029a:	6c8000ef          	jal	80000962 <uartputc_sync>
    8000029e:	b7d5                	j	80000282 <consputc+0x14>

00000000800002a0 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002a0:	1101                	addi	sp,sp,-32
    800002a2:	ec06                	sd	ra,24(sp)
    800002a4:	e822                	sd	s0,16(sp)
    800002a6:	e426                	sd	s1,8(sp)
    800002a8:	1000                	addi	s0,sp,32
    800002aa:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ac:	0000f517          	auipc	a0,0xf
    800002b0:	5c450513          	addi	a0,a0,1476 # 8000f870 <cons>
    800002b4:	151000ef          	jal	80000c04 <acquire>

  switch (c) {
    800002b8:	47d5                	li	a5,21
    800002ba:	08f48d63          	beq	s1,a5,80000354 <consoleintr+0xb4>
    800002be:	0297c563          	blt	a5,s1,800002e8 <consoleintr+0x48>
    800002c2:	47a1                	li	a5,8
    800002c4:	0ef48263          	beq	s1,a5,800003a8 <consoleintr+0x108>
    800002c8:	47c1                	li	a5,16
    800002ca:	10f49363          	bne	s1,a5,800003d0 <consoleintr+0x130>
  case C('P'): // Print process list.
    procdump();
    800002ce:	04c020ef          	jal	8000231a <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002d2:	0000f517          	auipc	a0,0xf
    800002d6:	59e50513          	addi	a0,a0,1438 # 8000f870 <cons>
    800002da:	1bb000ef          	jal	80000c94 <release>
}
    800002de:	60e2                	ld	ra,24(sp)
    800002e0:	6442                	ld	s0,16(sp)
    800002e2:	64a2                	ld	s1,8(sp)
    800002e4:	6105                	addi	sp,sp,32
    800002e6:	8082                	ret
  switch (c) {
    800002e8:	07f00793          	li	a5,127
    800002ec:	0af48e63          	beq	s1,a5,800003a8 <consoleintr+0x108>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800002f0:	0000f717          	auipc	a4,0xf
    800002f4:	58070713          	addi	a4,a4,1408 # 8000f870 <cons>
    800002f8:	0a072783          	lw	a5,160(a4)
    800002fc:	09872703          	lw	a4,152(a4)
    80000300:	9f99                	subw	a5,a5,a4
    80000302:	07f00713          	li	a4,127
    80000306:	fcf766e3          	bltu	a4,a5,800002d2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    8000030a:	47b5                	li	a5,13
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x136>
      consputc(c);
    80000310:	8526                	mv	a0,s1
    80000312:	f5dff0ef          	jal	8000026e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000316:	0000f717          	auipc	a4,0xf
    8000031a:	55a70713          	addi	a4,a4,1370 # 8000f870 <cons>
    8000031e:	0a072683          	lw	a3,160(a4)
    80000322:	0016879b          	addiw	a5,a3,1
    80000326:	863e                	mv	a2,a5
    80000328:	0af72023          	sw	a5,160(a4)
    8000032c:	07f6f693          	andi	a3,a3,127
    80000330:	9736                	add	a4,a4,a3
    80000332:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000336:	ff648713          	addi	a4,s1,-10
    8000033a:	c371                	beqz	a4,800003fe <consoleintr+0x15e>
    8000033c:	14f1                	addi	s1,s1,-4
    8000033e:	c0e1                	beqz	s1,800003fe <consoleintr+0x15e>
    80000340:	0000f717          	auipc	a4,0xf
    80000344:	5c872703          	lw	a4,1480(a4) # 8000f908 <cons+0x98>
    80000348:	9f99                	subw	a5,a5,a4
    8000034a:	08000713          	li	a4,128
    8000034e:	f8e792e3          	bne	a5,a4,800002d2 <consoleintr+0x32>
    80000352:	a075                	j	800003fe <consoleintr+0x15e>
    80000354:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    80000356:	0000f717          	auipc	a4,0xf
    8000035a:	51a70713          	addi	a4,a4,1306 # 8000f870 <cons>
    8000035e:	0a072783          	lw	a5,160(a4)
    80000362:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000366:	0000f497          	auipc	s1,0xf
    8000036a:	50a48493          	addi	s1,s1,1290 # 8000f870 <cons>
    while (cons.e != cons.w &&
    8000036e:	4929                	li	s2,10
    80000370:	02f70863          	beq	a4,a5,800003a0 <consoleintr+0x100>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000374:	37fd                	addiw	a5,a5,-1
    80000376:	07f7f713          	andi	a4,a5,127
    8000037a:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    8000037c:	01874703          	lbu	a4,24(a4)
    80000380:	03270263          	beq	a4,s2,800003a4 <consoleintr+0x104>
      cons.e--;
    80000384:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000388:	10000513          	li	a0,256
    8000038c:	ee3ff0ef          	jal	8000026e <consputc>
    while (cons.e != cons.w &&
    80000390:	0a04a783          	lw	a5,160(s1)
    80000394:	09c4a703          	lw	a4,156(s1)
    80000398:	fcf71ee3          	bne	a4,a5,80000374 <consoleintr+0xd4>
    8000039c:	6902                	ld	s2,0(sp)
    8000039e:	bf15                	j	800002d2 <consoleintr+0x32>
    800003a0:	6902                	ld	s2,0(sp)
    800003a2:	bf05                	j	800002d2 <consoleintr+0x32>
    800003a4:	6902                	ld	s2,0(sp)
    800003a6:	b735                	j	800002d2 <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003a8:	0000f717          	auipc	a4,0xf
    800003ac:	4c870713          	addi	a4,a4,1224 # 8000f870 <cons>
    800003b0:	0a072783          	lw	a5,160(a4)
    800003b4:	09c72703          	lw	a4,156(a4)
    800003b8:	f0f70de3          	beq	a4,a5,800002d2 <consoleintr+0x32>
      cons.e--;
    800003bc:	37fd                	addiw	a5,a5,-1
    800003be:	0000f717          	auipc	a4,0xf
    800003c2:	54f72923          	sw	a5,1362(a4) # 8000f910 <cons+0xa0>
      consputc(BACKSPACE);
    800003c6:	10000513          	li	a0,256
    800003ca:	ea5ff0ef          	jal	8000026e <consputc>
    800003ce:	b711                	j	800002d2 <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003d0:	f00481e3          	beqz	s1,800002d2 <consoleintr+0x32>
    800003d4:	bf31                	j	800002f0 <consoleintr+0x50>
      consputc(c);
    800003d6:	4529                	li	a0,10
    800003d8:	e97ff0ef          	jal	8000026e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003dc:	0000f797          	auipc	a5,0xf
    800003e0:	49478793          	addi	a5,a5,1172 # 8000f870 <cons>
    800003e4:	0a07a703          	lw	a4,160(a5)
    800003e8:	0017069b          	addiw	a3,a4,1
    800003ec:	8636                	mv	a2,a3
    800003ee:	0ad7a023          	sw	a3,160(a5)
    800003f2:	07f77713          	andi	a4,a4,127
    800003f6:	97ba                	add	a5,a5,a4
    800003f8:	4729                	li	a4,10
    800003fa:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003fe:	0000f797          	auipc	a5,0xf
    80000402:	50c7a723          	sw	a2,1294(a5) # 8000f90c <cons+0x9c>
        wakeup(&cons.r);
    80000406:	0000f517          	auipc	a0,0xf
    8000040a:	50250513          	addi	a0,a0,1282 # 8000f908 <cons+0x98>
    8000040e:	36b010ef          	jal	80001f78 <wakeup>
    80000412:	b5c1                	j	800002d2 <consoleintr+0x32>

0000000080000414 <consoleinit>:

void
consoleinit(void)
{
    80000414:	1141                	addi	sp,sp,-16
    80000416:	e406                	sd	ra,8(sp)
    80000418:	e022                	sd	s0,0(sp)
    8000041a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000041c:	00007597          	auipc	a1,0x7
    80000420:	be458593          	addi	a1,a1,-1052 # 80007000 <etext>
    80000424:	0000f517          	auipc	a0,0xf
    80000428:	44c50513          	addi	a0,a0,1100 # 8000f870 <cons>
    8000042c:	74e000ef          	jal	80000b7a <initlock>

  uartinit();
    80000430:	448000ef          	jal	80000878 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000434:	0001f797          	auipc	a5,0x1f
    80000438:	7ac78793          	addi	a5,a5,1964 # 8001fbe0 <devsw>
    8000043c:	00000717          	auipc	a4,0x0
    80000440:	d2e70713          	addi	a4,a4,-722 # 8000016a <consoleread>
    80000444:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000446:	00000717          	auipc	a4,0x0
    8000044a:	c8270713          	addi	a4,a4,-894 # 800000c8 <consolewrite>
    8000044e:	ef98                	sd	a4,24(a5)
}
    80000450:	60a2                	ld	ra,8(sp)
    80000452:	6402                	ld	s0,0(sp)
    80000454:	0141                	addi	sp,sp,16
    80000456:	8082                	ret

0000000080000458 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000458:	7139                	addi	sp,sp,-64
    8000045a:	fc06                	sd	ra,56(sp)
    8000045c:	f822                	sd	s0,48(sp)
    8000045e:	f04a                	sd	s2,32(sp)
    80000460:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000462:	c219                	beqz	a2,80000468 <printint+0x10>
    80000464:	08054163          	bltz	a0,800004e6 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000468:	4301                	li	t1,0

  i = 0;
    8000046a:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000046e:	86ca                	mv	a3,s2
  i = 0;
    80000470:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000472:	00007817          	auipc	a6,0x7
    80000476:	29e80813          	addi	a6,a6,670 # 80007710 <digits>
    8000047a:	88ba                	mv	a7,a4
    8000047c:	0017061b          	addiw	a2,a4,1
    80000480:	8732                	mv	a4,a2
    80000482:	02b577b3          	remu	a5,a0,a1
    80000486:	97c2                	add	a5,a5,a6
    80000488:	0007c783          	lbu	a5,0(a5)
    8000048c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    80000490:	87aa                	mv	a5,a0
    80000492:	02b55533          	divu	a0,a0,a1
    80000496:	0685                	addi	a3,a3,1
    80000498:	feb7f1e3          	bgeu	a5,a1,8000047a <printint+0x22>

  if (sign)
    8000049c:	00030c63          	beqz	t1,800004b4 <printint+0x5c>
    buf[i++] = '-';
    800004a0:	fe060793          	addi	a5,a2,-32
    800004a4:	00878633          	add	a2,a5,s0
    800004a8:	02d00793          	li	a5,45
    800004ac:	fef60423          	sb	a5,-24(a2)
    800004b0:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004b4:	02e05463          	blez	a4,800004dc <printint+0x84>
    800004b8:	f426                	sd	s1,40(sp)
    800004ba:	377d                	addiw	a4,a4,-1
    800004bc:	00e904b3          	add	s1,s2,a4
    800004c0:	197d                	addi	s2,s2,-1
    800004c2:	993a                	add	s2,s2,a4
    800004c4:	1702                	slli	a4,a4,0x20
    800004c6:	9301                	srli	a4,a4,0x20
    800004c8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004cc:	0004c503          	lbu	a0,0(s1)
    800004d0:	d9fff0ef          	jal	8000026e <consputc>
  while (--i >= 0)
    800004d4:	14fd                	addi	s1,s1,-1
    800004d6:	ff249be3          	bne	s1,s2,800004cc <printint+0x74>
    800004da:	74a2                	ld	s1,40(sp)
}
    800004dc:	70e2                	ld	ra,56(sp)
    800004de:	7442                	ld	s0,48(sp)
    800004e0:	7902                	ld	s2,32(sp)
    800004e2:	6121                	addi	sp,sp,64
    800004e4:	8082                	ret
    x = -xx;
    800004e6:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    800004ea:	4305                	li	t1,1
    x = -xx;
    800004ec:	bfbd                	j	8000046a <printint+0x12>

00000000800004ee <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    800004ee:	7131                	addi	sp,sp,-192
    800004f0:	fc86                	sd	ra,120(sp)
    800004f2:	f8a2                	sd	s0,112(sp)
    800004f4:	f0ca                	sd	s2,96(sp)
    800004f6:	0100                	addi	s0,sp,128
    800004f8:	892a                	mv	s2,a0
    800004fa:	e40c                	sd	a1,8(s0)
    800004fc:	e810                	sd	a2,16(s0)
    800004fe:	ec14                	sd	a3,24(s0)
    80000500:	f018                	sd	a4,32(s0)
    80000502:	f41c                	sd	a5,40(s0)
    80000504:	03043823          	sd	a6,48(s0)
    80000508:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    8000050c:	00007797          	auipc	a5,0x7
    80000510:	3387a783          	lw	a5,824(a5) # 80007844 <panicking>
    80000514:	cf9d                	beqz	a5,80000552 <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000516:	00840793          	addi	a5,s0,8
    8000051a:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    8000051e:	00094503          	lbu	a0,0(s2)
    80000522:	22050663          	beqz	a0,8000074e <printk+0x260>
    80000526:	f4a6                	sd	s1,104(sp)
    80000528:	ecce                	sd	s3,88(sp)
    8000052a:	e8d2                	sd	s4,80(sp)
    8000052c:	e4d6                	sd	s5,72(sp)
    8000052e:	e0da                	sd	s6,64(sp)
    80000530:	fc5e                	sd	s7,56(sp)
    80000532:	f862                	sd	s8,48(sp)
    80000534:	f06a                	sd	s10,32(sp)
    80000536:	ec6e                	sd	s11,24(sp)
    80000538:	4a01                	li	s4,0
    if (cx != '%') {
    8000053a:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    8000053e:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000542:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000546:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000054a:	4b29                	li	s6,10
    if (c0 == 'd') {
    8000054c:	06400b93          	li	s7,100
    80000550:	a015                	j	80000574 <printk+0x86>
    acquire(&pr.lock);
    80000552:	0000f517          	auipc	a0,0xf
    80000556:	3c650513          	addi	a0,a0,966 # 8000f918 <pr>
    8000055a:	6aa000ef          	jal	80000c04 <acquire>
    8000055e:	bf65                	j	80000516 <printk+0x28>
      consputc(cx);
    80000560:	d0fff0ef          	jal	8000026e <consputc>
      continue;
    80000564:	84d2                	mv	s1,s4
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000566:	2485                	addiw	s1,s1,1
    80000568:	8a26                	mv	s4,s1
    8000056a:	94ca                	add	s1,s1,s2
    8000056c:	0004c503          	lbu	a0,0(s1)
    80000570:	1c050663          	beqz	a0,8000073c <printk+0x24e>
    if (cx != '%') {
    80000574:	ff3516e3          	bne	a0,s3,80000560 <printk+0x72>
    i++;
    80000578:	001a079b          	addiw	a5,s4,1
    8000057c:	84be                	mv	s1,a5
    c0 = fmt[i + 0] & 0xff;
    8000057e:	00f90733          	add	a4,s2,a5
    80000582:	00074a83          	lbu	s5,0(a4)
    if (c0)
    80000586:	200a8963          	beqz	s5,80000798 <printk+0x2aa>
      c1 = fmt[i + 1] & 0xff;
    8000058a:	00174683          	lbu	a3,1(a4)
    if (c1)
    8000058e:	1e068c63          	beqz	a3,80000786 <printk+0x298>
    if (c0 == 'd') {
    80000592:	037a8863          	beq	s5,s7,800005c2 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    80000596:	f94a8713          	addi	a4,s5,-108
    8000059a:	00173713          	seqz	a4,a4
    8000059e:	f9c68613          	addi	a2,a3,-100
    800005a2:	ee05                	bnez	a2,800005da <printk+0xec>
    800005a4:	cb1d                	beqz	a4,800005da <printk+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005a6:	f8843783          	ld	a5,-120(s0)
    800005aa:	00878713          	addi	a4,a5,8
    800005ae:	f8e43423          	sd	a4,-120(s0)
    800005b2:	4605                	li	a2,1
    800005b4:	85da                	mv	a1,s6
    800005b6:	6388                	ld	a0,0(a5)
    800005b8:	ea1ff0ef          	jal	80000458 <printint>
      i += 1;
    800005bc:	002a049b          	addiw	s1,s4,2
    800005c0:	b75d                	j	80000566 <printk+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005c2:	f8843783          	ld	a5,-120(s0)
    800005c6:	00878713          	addi	a4,a5,8
    800005ca:	f8e43423          	sd	a4,-120(s0)
    800005ce:	4605                	li	a2,1
    800005d0:	85da                	mv	a1,s6
    800005d2:	4388                	lw	a0,0(a5)
    800005d4:	e85ff0ef          	jal	80000458 <printint>
    800005d8:	b779                	j	80000566 <printk+0x78>
      c2 = fmt[i + 2] & 0xff;
    800005da:	97ca                	add	a5,a5,s2
    800005dc:	8636                	mv	a2,a3
    800005de:	0027c683          	lbu	a3,2(a5)
    800005e2:	a2c9                	j	800007a4 <printk+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800005e4:	f8843783          	ld	a5,-120(s0)
    800005e8:	00878713          	addi	a4,a5,8
    800005ec:	f8e43423          	sd	a4,-120(s0)
    800005f0:	4605                	li	a2,1
    800005f2:	45a9                	li	a1,10
    800005f4:	6388                	ld	a0,0(a5)
    800005f6:	e63ff0ef          	jal	80000458 <printint>
      i += 2;
    800005fa:	003a049b          	addiw	s1,s4,3
    800005fe:	b7a5                	j	80000566 <printk+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    80000600:	f8843783          	ld	a5,-120(s0)
    80000604:	00878713          	addi	a4,a5,8
    80000608:	f8e43423          	sd	a4,-120(s0)
    8000060c:	4601                	li	a2,0
    8000060e:	85da                	mv	a1,s6
    80000610:	0007e503          	lwu	a0,0(a5)
    80000614:	e45ff0ef          	jal	80000458 <printint>
    80000618:	b7b9                	j	80000566 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    8000061a:	f8843783          	ld	a5,-120(s0)
    8000061e:	00878713          	addi	a4,a5,8
    80000622:	f8e43423          	sd	a4,-120(s0)
    80000626:	4601                	li	a2,0
    80000628:	85da                	mv	a1,s6
    8000062a:	6388                	ld	a0,0(a5)
    8000062c:	e2dff0ef          	jal	80000458 <printint>
      i += 1;
    80000630:	002a049b          	addiw	s1,s4,2
    80000634:	bf0d                	j	80000566 <printk+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	45a9                	li	a1,10
    80000646:	6388                	ld	a0,0(a5)
    80000648:	e11ff0ef          	jal	80000458 <printint>
      i += 2;
    8000064c:	003a049b          	addiw	s1,s4,3
    80000650:	bf19                	j	80000566 <printk+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45c1                	li	a1,16
    80000662:	0007e503          	lwu	a0,0(a5)
    80000666:	df3ff0ef          	jal	80000458 <printint>
    8000066a:	bdf5                	j	80000566 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    8000066c:	f8843783          	ld	a5,-120(s0)
    80000670:	00878713          	addi	a4,a5,8
    80000674:	f8e43423          	sd	a4,-120(s0)
    80000678:	45c1                	li	a1,16
    8000067a:	6388                	ld	a0,0(a5)
    8000067c:	dddff0ef          	jal	80000458 <printint>
      i += 1;
    80000680:	002a049b          	addiw	s1,s4,2
    80000684:	b5cd                	j	80000566 <printk+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4601                	li	a2,0
    80000694:	45c1                	li	a1,16
    80000696:	6388                	ld	a0,0(a5)
    80000698:	dc1ff0ef          	jal	80000458 <printint>
      i += 2;
    8000069c:	003a049b          	addiw	s1,s4,3
    800006a0:	b5d9                	j	80000566 <printk+0x78>
    800006a2:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006a4:	f8843783          	ld	a5,-120(s0)
    800006a8:	00878713          	addi	a4,a5,8
    800006ac:	f8e43423          	sd	a4,-120(s0)
    800006b0:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006b4:	03000513          	li	a0,48
    800006b8:	bb7ff0ef          	jal	8000026e <consputc>
  consputc('x');
    800006bc:	07800513          	li	a0,120
    800006c0:	bafff0ef          	jal	8000026e <consputc>
    800006c4:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c6:	00007c97          	auipc	s9,0x7
    800006ca:	04ac8c93          	addi	s9,s9,74 # 80007710 <digits>
    800006ce:	03cad793          	srli	a5,s5,0x3c
    800006d2:	97e6                	add	a5,a5,s9
    800006d4:	0007c503          	lbu	a0,0(a5)
    800006d8:	b97ff0ef          	jal	8000026e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006dc:	0a92                	slli	s5,s5,0x4
    800006de:	3a7d                	addiw	s4,s4,-1
    800006e0:	fe0a17e3          	bnez	s4,800006ce <printk+0x1e0>
    800006e4:	7ca2                	ld	s9,40(sp)
    800006e6:	b541                	j	80000566 <printk+0x78>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	4388                	lw	a0,0(a5)
    800006f6:	b79ff0ef          	jal	8000026e <consputc>
    800006fa:	b5b5                	j	80000566 <printk+0x78>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    800006fc:	f8843783          	ld	a5,-120(s0)
    80000700:	00878713          	addi	a4,a5,8
    80000704:	f8e43423          	sd	a4,-120(s0)
    80000708:	0007ba03          	ld	s4,0(a5)
    8000070c:	000a0d63          	beqz	s4,80000726 <printk+0x238>
        s = "(null)";
      for (; *s; s++)
    80000710:	000a4503          	lbu	a0,0(s4)
    80000714:	e40509e3          	beqz	a0,80000566 <printk+0x78>
        consputc(*s);
    80000718:	b57ff0ef          	jal	8000026e <consputc>
      for (; *s; s++)
    8000071c:	0a05                	addi	s4,s4,1
    8000071e:	000a4503          	lbu	a0,0(s4)
    80000722:	f97d                	bnez	a0,80000718 <printk+0x22a>
    80000724:	b589                	j	80000566 <printk+0x78>
        s = "(null)";
    80000726:	00007a17          	auipc	s4,0x7
    8000072a:	8e2a0a13          	addi	s4,s4,-1822 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000072e:	02800513          	li	a0,40
    80000732:	b7dd                	j	80000718 <printk+0x22a>
    } else if (c0 == '%') {
      consputc('%');
    80000734:	8556                	mv	a0,s5
    80000736:	b39ff0ef          	jal	8000026e <consputc>
    8000073a:	b535                	j	80000566 <printk+0x78>
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	69e6                	ld	s3,88(sp)
    80000740:	6a46                	ld	s4,80(sp)
    80000742:	6aa6                	ld	s5,72(sp)
    80000744:	6b06                	ld	s6,64(sp)
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	7c42                	ld	s8,48(sp)
    8000074a:	7d02                	ld	s10,32(sp)
    8000074c:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000074e:	00007797          	auipc	a5,0x7
    80000752:	0f67a783          	lw	a5,246(a5) # 80007844 <panicking>
    80000756:	c38d                	beqz	a5,80000778 <printk+0x28a>
    release(&pr.lock);

  return 0;
}
    80000758:	4501                	li	a0,0
    8000075a:	70e6                	ld	ra,120(sp)
    8000075c:	7446                	ld	s0,112(sp)
    8000075e:	7906                	ld	s2,96(sp)
    80000760:	6129                	addi	sp,sp,192
    80000762:	8082                	ret
    80000764:	74a6                	ld	s1,104(sp)
    80000766:	69e6                	ld	s3,88(sp)
    80000768:	6a46                	ld	s4,80(sp)
    8000076a:	6aa6                	ld	s5,72(sp)
    8000076c:	6b06                	ld	s6,64(sp)
    8000076e:	7be2                	ld	s7,56(sp)
    80000770:	7c42                	ld	s8,48(sp)
    80000772:	7d02                	ld	s10,32(sp)
    80000774:	6de2                	ld	s11,24(sp)
    80000776:	bfe1                	j	8000074e <printk+0x260>
    release(&pr.lock);
    80000778:	0000f517          	auipc	a0,0xf
    8000077c:	1a050513          	addi	a0,a0,416 # 8000f918 <pr>
    80000780:	514000ef          	jal	80000c94 <release>
  return 0;
    80000784:	bfd1                	j	80000758 <printk+0x26a>
    if (c0 == 'd') {
    80000786:	e37a8ee3          	beq	s5,s7,800005c2 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    8000078a:	f94a8713          	addi	a4,s5,-108
    8000078e:	00173713          	seqz	a4,a4
    80000792:	8636                	mv	a2,a3
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80000794:	4781                	li	a5,0
    80000796:	a00d                	j	800007b8 <printk+0x2ca>
    } else if (c0 == 'l' && c1 == 'd') {
    80000798:	f94a8713          	addi	a4,s5,-108
    8000079c:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007a0:	8656                	mv	a2,s5
    800007a2:	86d6                	mv	a3,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007a4:	f9460793          	addi	a5,a2,-108
    800007a8:	0017b793          	seqz	a5,a5
    800007ac:	8ff9                	and	a5,a5,a4
    800007ae:	f9c68593          	addi	a1,a3,-100
    800007b2:	e199                	bnez	a1,800007b8 <printk+0x2ca>
    800007b4:	e20798e3          	bnez	a5,800005e4 <printk+0xf6>
    } else if (c0 == 'u') {
    800007b8:	e58a84e3          	beq	s5,s8,80000600 <printk+0x112>
    } else if (c0 == 'l' && c1 == 'u') {
    800007bc:	f8b60593          	addi	a1,a2,-117
    800007c0:	e199                	bnez	a1,800007c6 <printk+0x2d8>
    800007c2:	e4071ce3          	bnez	a4,8000061a <printk+0x12c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007c6:	f8b68593          	addi	a1,a3,-117
    800007ca:	e199                	bnez	a1,800007d0 <printk+0x2e2>
    800007cc:	e60795e3          	bnez	a5,80000636 <printk+0x148>
    } else if (c0 == 'x') {
    800007d0:	e9aa81e3          	beq	s5,s10,80000652 <printk+0x164>
    } else if (c0 == 'l' && c1 == 'x') {
    800007d4:	f8860613          	addi	a2,a2,-120
    800007d8:	e219                	bnez	a2,800007de <printk+0x2f0>
    800007da:	e80719e3          	bnez	a4,8000066c <printk+0x17e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    800007de:	f8868693          	addi	a3,a3,-120
    800007e2:	e299                	bnez	a3,800007e8 <printk+0x2fa>
    800007e4:	ea0791e3          	bnez	a5,80000686 <printk+0x198>
    } else if (c0 == 'p') {
    800007e8:	ebba8de3          	beq	s5,s11,800006a2 <printk+0x1b4>
    } else if (c0 == 'c') {
    800007ec:	06300793          	li	a5,99
    800007f0:	eefa8ce3          	beq	s5,a5,800006e8 <printk+0x1fa>
    } else if (c0 == 's') {
    800007f4:	07300793          	li	a5,115
    800007f8:	f0fa82e3          	beq	s5,a5,800006fc <printk+0x20e>
    } else if (c0 == '%') {
    800007fc:	02500793          	li	a5,37
    80000800:	f2fa8ae3          	beq	s5,a5,80000734 <printk+0x246>
    } else if (c0 == 0) {
    80000804:	f60a80e3          	beqz	s5,80000764 <printk+0x276>
      consputc('%');
    80000808:	02500513          	li	a0,37
    8000080c:	a63ff0ef          	jal	8000026e <consputc>
      consputc(c0);
    80000810:	8556                	mv	a0,s5
    80000812:	a5dff0ef          	jal	8000026e <consputc>
    80000816:	bb81                	j	80000566 <printk+0x78>

0000000080000818 <panic>:

void
panic(char *s)
{
    80000818:	1101                	addi	sp,sp,-32
    8000081a:	ec06                	sd	ra,24(sp)
    8000081c:	e822                	sd	s0,16(sp)
    8000081e:	e426                	sd	s1,8(sp)
    80000820:	e04a                	sd	s2,0(sp)
    80000822:	1000                	addi	s0,sp,32
    80000824:	892a                	mv	s2,a0
  panicking = 1;
    80000826:	4485                	li	s1,1
    80000828:	00007797          	auipc	a5,0x7
    8000082c:	0097ae23          	sw	s1,28(a5) # 80007844 <panicking>
  printk("panic: ");
    80000830:	00006517          	auipc	a0,0x6
    80000834:	7e850513          	addi	a0,a0,2024 # 80007018 <etext+0x18>
    80000838:	cb7ff0ef          	jal	800004ee <printk>
  printk("%s\n", s);
    8000083c:	85ca                	mv	a1,s2
    8000083e:	00006517          	auipc	a0,0x6
    80000842:	7e250513          	addi	a0,a0,2018 # 80007020 <etext+0x20>
    80000846:	ca9ff0ef          	jal	800004ee <printk>
  panicked = 1; // freeze uart output from other CPUs
    8000084a:	00007797          	auipc	a5,0x7
    8000084e:	fe97ab23          	sw	s1,-10(a5) # 80007840 <panicked>
  for (;;)
    80000852:	a001                	j	80000852 <panic+0x3a>

0000000080000854 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000854:	1141                	addi	sp,sp,-16
    80000856:	e406                	sd	ra,8(sp)
    80000858:	e022                	sd	s0,0(sp)
    8000085a:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000085c:	00006597          	auipc	a1,0x6
    80000860:	7cc58593          	addi	a1,a1,1996 # 80007028 <etext+0x28>
    80000864:	0000f517          	auipc	a0,0xf
    80000868:	0b450513          	addi	a0,a0,180 # 8000f918 <pr>
    8000086c:	30e000ef          	jal	80000b7a <initlock>
}
    80000870:	60a2                	ld	ra,8(sp)
    80000872:	6402                	ld	s0,0(sp)
    80000874:	0141                	addi	sp,sp,16
    80000876:	8082                	ret

0000000080000878 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    80000878:	1141                	addi	sp,sp,-16
    8000087a:	e406                	sd	ra,8(sp)
    8000087c:	e022                	sd	s0,0(sp)
    8000087e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000880:	100007b7          	lui	a5,0x10000
    80000884:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000888:	10000737          	lui	a4,0x10000
    8000088c:	f8000693          	li	a3,-128
    80000890:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000894:	468d                	li	a3,3
    80000896:	10000637          	lui	a2,0x10000
    8000089a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000089e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008a2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008a6:	8732                	mv	a4,a2
    800008a8:	461d                	li	a2,7
    800008aa:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ae:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008b2:	00006597          	auipc	a1,0x6
    800008b6:	77e58593          	addi	a1,a1,1918 # 80007030 <etext+0x30>
    800008ba:	0000f517          	auipc	a0,0xf
    800008be:	07650513          	addi	a0,a0,118 # 8000f930 <tx_lock>
    800008c2:	2b8000ef          	jal	80000b7a <initlock>
}
    800008c6:	60a2                	ld	ra,8(sp)
    800008c8:	6402                	ld	s0,0(sp)
    800008ca:	0141                	addi	sp,sp,16
    800008cc:	8082                	ret

00000000800008ce <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008ce:	715d                	addi	sp,sp,-80
    800008d0:	e486                	sd	ra,72(sp)
    800008d2:	e0a2                	sd	s0,64(sp)
    800008d4:	fc26                	sd	s1,56(sp)
    800008d6:	ec56                	sd	s5,24(sp)
    800008d8:	0880                	addi	s0,sp,80
    800008da:	8aaa                	mv	s5,a0
    800008dc:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008de:	0000f517          	auipc	a0,0xf
    800008e2:	05250513          	addi	a0,a0,82 # 8000f930 <tx_lock>
    800008e6:	31e000ef          	jal	80000c04 <acquire>

  int i = 0;
  while (i < n) {
    800008ea:	06905063          	blez	s1,8000094a <uartwrite+0x7c>
    800008ee:	f84a                	sd	s2,48(sp)
    800008f0:	f44e                	sd	s3,40(sp)
    800008f2:	f052                	sd	s4,32(sp)
    800008f4:	e85a                	sd	s6,16(sp)
    800008f6:	e45e                	sd	s7,8(sp)
    800008f8:	8a56                	mv	s4,s5
    800008fa:	9aa6                	add	s5,s5,s1
    while (tx_busy != 0) {
    800008fc:	00007497          	auipc	s1,0x7
    80000900:	f5048493          	addi	s1,s1,-176 # 8000784c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000904:	0000f997          	auipc	s3,0xf
    80000908:	02c98993          	addi	s3,s3,44 # 8000f930 <tx_lock>
    8000090c:	00007917          	auipc	s2,0x7
    80000910:	f3c90913          	addi	s2,s2,-196 # 80007848 <tx_chan>
    }

    WriteReg(THR, buf[i]);
    80000914:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000918:	4b05                	li	s6,1
    8000091a:	a005                	j	8000093a <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    8000091c:	85ce                	mv	a1,s3
    8000091e:	854a                	mv	a0,s2
    80000920:	60c010ef          	jal	80001f2c <sleep>
    while (tx_busy != 0) {
    80000924:	409c                	lw	a5,0(s1)
    80000926:	fbfd                	bnez	a5,8000091c <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000928:	000a4783          	lbu	a5,0(s4)
    8000092c:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80000930:	0164a023          	sw	s6,0(s1)
  while (i < n) {
    80000934:	0a05                	addi	s4,s4,1
    80000936:	015a0563          	beq	s4,s5,80000940 <uartwrite+0x72>
    while (tx_busy != 0) {
    8000093a:	409c                	lw	a5,0(s1)
    8000093c:	f3e5                	bnez	a5,8000091c <uartwrite+0x4e>
    8000093e:	b7ed                	j	80000928 <uartwrite+0x5a>
    80000940:	7942                	ld	s2,48(sp)
    80000942:	79a2                	ld	s3,40(sp)
    80000944:	7a02                	ld	s4,32(sp)
    80000946:	6b42                	ld	s6,16(sp)
    80000948:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    8000094a:	0000f517          	auipc	a0,0xf
    8000094e:	fe650513          	addi	a0,a0,-26 # 8000f930 <tx_lock>
    80000952:	342000ef          	jal	80000c94 <release>
}
    80000956:	60a6                	ld	ra,72(sp)
    80000958:	6406                	ld	s0,64(sp)
    8000095a:	74e2                	ld	s1,56(sp)
    8000095c:	6ae2                	ld	s5,24(sp)
    8000095e:	6161                	addi	sp,sp,80
    80000960:	8082                	ret

0000000080000962 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000962:	1101                	addi	sp,sp,-32
    80000964:	ec06                	sd	ra,24(sp)
    80000966:	e822                	sd	s0,16(sp)
    80000968:	e426                	sd	s1,8(sp)
    8000096a:	1000                	addi	s0,sp,32
    8000096c:	84aa                	mv	s1,a0
  if (panicking == 0)
    8000096e:	00007797          	auipc	a5,0x7
    80000972:	ed67a783          	lw	a5,-298(a5) # 80007844 <panicking>
    80000976:	cf95                	beqz	a5,800009b2 <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000978:	00007797          	auipc	a5,0x7
    8000097c:	ec87a783          	lw	a5,-312(a5) # 80007840 <panicked>
    80000980:	ef85                	bnez	a5,800009b8 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000982:	10000737          	lui	a4,0x10000
    80000986:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000988:	00074783          	lbu	a5,0(a4)
    8000098c:	0207f793          	andi	a5,a5,32
    80000990:	dfe5                	beqz	a5,80000988 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80000992:	0ff4f513          	zext.b	a0,s1
    80000996:	100007b7          	lui	a5,0x10000
    8000099a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    8000099e:	00007797          	auipc	a5,0x7
    800009a2:	ea67a783          	lw	a5,-346(a5) # 80007844 <panicking>
    800009a6:	cb91                	beqz	a5,800009ba <uartputc_sync+0x58>
    pop_off();
}
    800009a8:	60e2                	ld	ra,24(sp)
    800009aa:	6442                	ld	s0,16(sp)
    800009ac:	64a2                	ld	s1,8(sp)
    800009ae:	6105                	addi	sp,sp,32
    800009b0:	8082                	ret
    push_off();
    800009b2:	20e000ef          	jal	80000bc0 <push_off>
    800009b6:	b7c9                	j	80000978 <uartputc_sync+0x16>
    for (;;)
    800009b8:	a001                	j	800009b8 <uartputc_sync+0x56>
    pop_off();
    800009ba:	28a000ef          	jal	80000c44 <pop_off>
}
    800009be:	b7ed                	j	800009a8 <uartputc_sync+0x46>

00000000800009c0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009c0:	1101                	addi	sp,sp,-32
    800009c2:	ec06                	sd	ra,24(sp)
    800009c4:	e822                	sd	s0,16(sp)
    800009c6:	e426                	sd	s1,8(sp)
    800009c8:	e04a                	sd	s2,0(sp)
    800009ca:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009cc:	100007b7          	lui	a5,0x10000
    800009d0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    800009d4:	0000f517          	auipc	a0,0xf
    800009d8:	f5c50513          	addi	a0,a0,-164 # 8000f930 <tx_lock>
    800009dc:	228000ef          	jal	80000c04 <acquire>
  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e8:	0207f793          	andi	a5,a5,32
    800009ec:	e78d                	bnez	a5,80000a16 <uartintr+0x56>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800009ee:	0000f517          	auipc	a0,0xf
    800009f2:	f4250513          	addi	a0,a0,-190 # 8000f930 <tx_lock>
    800009f6:	29e000ef          	jal	80000c94 <release>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009fa:	100004b7          	lui	s1,0x10000
    800009fe:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    80000a00:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a04:	0004c783          	lbu	a5,0(s1)
    80000a08:	8b85                	andi	a5,a5,1
    80000a0a:	c38d                	beqz	a5,80000a2c <uartintr+0x6c>
    return ReadReg(RHR);
    80000a0c:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a10:	891ff0ef          	jal	800002a0 <consoleintr>
  while (1) {
    80000a14:	bfc5                	j	80000a04 <uartintr+0x44>
    tx_busy = 0;
    80000a16:	00007797          	auipc	a5,0x7
    80000a1a:	e207ab23          	sw	zero,-458(a5) # 8000784c <tx_busy>
    wakeup(&tx_chan);
    80000a1e:	00007517          	auipc	a0,0x7
    80000a22:	e2a50513          	addi	a0,a0,-470 # 80007848 <tx_chan>
    80000a26:	552010ef          	jal	80001f78 <wakeup>
    80000a2a:	b7d1                	j	800009ee <uartintr+0x2e>
  }
}
    80000a2c:	60e2                	ld	ra,24(sp)
    80000a2e:	6442                	ld	s0,16(sp)
    80000a30:	64a2                	ld	s1,8(sp)
    80000a32:	6902                	ld	s2,0(sp)
    80000a34:	6105                	addi	sp,sp,32
    80000a36:	8082                	ret

0000000080000a38 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a38:	1101                	addi	sp,sp,-32
    80000a3a:	ec06                	sd	ra,24(sp)
    80000a3c:	e822                	sd	s0,16(sp)
    80000a3e:	e426                	sd	s1,8(sp)
    80000a40:	e04a                	sd	s2,0(sp)
    80000a42:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a44:	00020797          	auipc	a5,0x20
    80000a48:	33478793          	addi	a5,a5,820 # 80020d78 <end>
    80000a4c:	00f53733          	sltu	a4,a0,a5
    80000a50:	47c5                	li	a5,17
    80000a52:	07ee                	slli	a5,a5,0x1b
    80000a54:	17fd                	addi	a5,a5,-1
    80000a56:	00a7b7b3          	sltu	a5,a5,a0
    80000a5a:	8fd9                	or	a5,a5,a4
    80000a5c:	ef95                	bnez	a5,80000a98 <kfree+0x60>
    80000a5e:	84aa                	mv	s1,a0
    80000a60:	03451793          	slli	a5,a0,0x34
    80000a64:	eb95                	bnez	a5,80000a98 <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a66:	6605                	lui	a2,0x1
    80000a68:	4585                	li	a1,1
    80000a6a:	262000ef          	jal	80000ccc <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a6e:	0000f917          	auipc	s2,0xf
    80000a72:	eda90913          	addi	s2,s2,-294 # 8000f948 <kmem>
    80000a76:	854a                	mv	a0,s2
    80000a78:	18c000ef          	jal	80000c04 <acquire>
  r->next = kmem.freelist;
    80000a7c:	01893783          	ld	a5,24(s2)
    80000a80:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a82:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a86:	854a                	mv	a0,s2
    80000a88:	20c000ef          	jal	80000c94 <release>
}
    80000a8c:	60e2                	ld	ra,24(sp)
    80000a8e:	6442                	ld	s0,16(sp)
    80000a90:	64a2                	ld	s1,8(sp)
    80000a92:	6902                	ld	s2,0(sp)
    80000a94:	6105                	addi	sp,sp,32
    80000a96:	8082                	ret
    panic("kfree");
    80000a98:	00006517          	auipc	a0,0x6
    80000a9c:	5a050513          	addi	a0,a0,1440 # 80007038 <etext+0x38>
    80000aa0:	d79ff0ef          	jal	80000818 <panic>

0000000080000aa4 <freerange>:
{
    80000aa4:	7179                	addi	sp,sp,-48
    80000aa6:	f406                	sd	ra,40(sp)
    80000aa8:	f022                	sd	s0,32(sp)
    80000aaa:	ec26                	sd	s1,24(sp)
    80000aac:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000aae:	6785                	lui	a5,0x1
    80000ab0:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab4:	00e504b3          	add	s1,a0,a4
    80000ab8:	777d                	lui	a4,0xfffff
    80000aba:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000abc:	94be                	add	s1,s1,a5
    80000abe:	0295e263          	bltu	a1,s1,80000ae2 <freerange+0x3e>
    80000ac2:	e84a                	sd	s2,16(sp)
    80000ac4:	e44e                	sd	s3,8(sp)
    80000ac6:	e052                	sd	s4,0(sp)
    80000ac8:	892e                	mv	s2,a1
    kfree(p);
    80000aca:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000acc:	89be                	mv	s3,a5
    kfree(p);
    80000ace:	01448533          	add	a0,s1,s4
    80000ad2:	f67ff0ef          	jal	80000a38 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ad6:	94ce                	add	s1,s1,s3
    80000ad8:	fe997be3          	bgeu	s2,s1,80000ace <freerange+0x2a>
    80000adc:	6942                	ld	s2,16(sp)
    80000ade:	69a2                	ld	s3,8(sp)
    80000ae0:	6a02                	ld	s4,0(sp)
}
    80000ae2:	70a2                	ld	ra,40(sp)
    80000ae4:	7402                	ld	s0,32(sp)
    80000ae6:	64e2                	ld	s1,24(sp)
    80000ae8:	6145                	addi	sp,sp,48
    80000aea:	8082                	ret

0000000080000aec <kinit>:
{
    80000aec:	1141                	addi	sp,sp,-16
    80000aee:	e406                	sd	ra,8(sp)
    80000af0:	e022                	sd	s0,0(sp)
    80000af2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af4:	00006597          	auipc	a1,0x6
    80000af8:	54c58593          	addi	a1,a1,1356 # 80007040 <etext+0x40>
    80000afc:	0000f517          	auipc	a0,0xf
    80000b00:	e4c50513          	addi	a0,a0,-436 # 8000f948 <kmem>
    80000b04:	076000ef          	jal	80000b7a <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b08:	45c5                	li	a1,17
    80000b0a:	05ee                	slli	a1,a1,0x1b
    80000b0c:	00020517          	auipc	a0,0x20
    80000b10:	26c50513          	addi	a0,a0,620 # 80020d78 <end>
    80000b14:	f91ff0ef          	jal	80000aa4 <freerange>
}
    80000b18:	60a2                	ld	ra,8(sp)
    80000b1a:	6402                	ld	s0,0(sp)
    80000b1c:	0141                	addi	sp,sp,16
    80000b1e:	8082                	ret

0000000080000b20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b20:	1101                	addi	sp,sp,-32
    80000b22:	ec06                	sd	ra,24(sp)
    80000b24:	e822                	sd	s0,16(sp)
    80000b26:	e426                	sd	s1,8(sp)
    80000b28:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2a:	0000f517          	auipc	a0,0xf
    80000b2e:	e1e50513          	addi	a0,a0,-482 # 8000f948 <kmem>
    80000b32:	0d2000ef          	jal	80000c04 <acquire>
  r = kmem.freelist;
    80000b36:	0000f497          	auipc	s1,0xf
    80000b3a:	e2a4b483          	ld	s1,-470(s1) # 8000f960 <kmem+0x18>
  if (r)
    80000b3e:	c49d                	beqz	s1,80000b6c <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	0000f717          	auipc	a4,0xf
    80000b46:	e0f73f23          	sd	a5,-482(a4) # 8000f960 <kmem+0x18>
  release(&kmem.lock);
    80000b4a:	0000f517          	auipc	a0,0xf
    80000b4e:	dfe50513          	addi	a0,a0,-514 # 8000f948 <kmem>
    80000b52:	142000ef          	jal	80000c94 <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b56:	6605                	lui	a2,0x1
    80000b58:	4595                	li	a1,5
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	170000ef          	jal	80000ccc <memset>
  return (void *)r;
}
    80000b60:	8526                	mv	a0,s1
    80000b62:	60e2                	ld	ra,24(sp)
    80000b64:	6442                	ld	s0,16(sp)
    80000b66:	64a2                	ld	s1,8(sp)
    80000b68:	6105                	addi	sp,sp,32
    80000b6a:	8082                	ret
  release(&kmem.lock);
    80000b6c:	0000f517          	auipc	a0,0xf
    80000b70:	ddc50513          	addi	a0,a0,-548 # 8000f948 <kmem>
    80000b74:	120000ef          	jal	80000c94 <release>
  if (r)
    80000b78:	b7e5                	j	80000b60 <kalloc+0x40>

0000000080000b7a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b7a:	1141                	addi	sp,sp,-16
    80000b7c:	e406                	sd	ra,8(sp)
    80000b7e:	e022                	sd	s0,0(sp)
    80000b80:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b82:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b84:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b88:	00053823          	sd	zero,16(a0)
}
    80000b8c:	60a2                	ld	ra,8(sp)
    80000b8e:	6402                	ld	s0,0(sp)
    80000b90:	0141                	addi	sp,sp,16
    80000b92:	8082                	ret

0000000080000b94 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b94:	411c                	lw	a5,0(a0)
    80000b96:	e399                	bnez	a5,80000b9c <holding+0x8>
    80000b98:	4501                	li	a0,0
  return r;
}
    80000b9a:	8082                	ret
{
    80000b9c:	1101                	addi	sp,sp,-32
    80000b9e:	ec06                	sd	ra,24(sp)
    80000ba0:	e822                	sd	s0,16(sp)
    80000ba2:	e426                	sd	s1,8(sp)
    80000ba4:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba6:	691c                	ld	a5,16(a0)
    80000ba8:	84be                	mv	s1,a5
    80000baa:	539000ef          	jal	800018e2 <mycpu>
    80000bae:	40a48533          	sub	a0,s1,a0
    80000bb2:	00153513          	seqz	a0,a0
}
    80000bb6:	60e2                	ld	ra,24(sp)
    80000bb8:	6442                	ld	s0,16(sp)
    80000bba:	64a2                	ld	s1,8(sp)
    80000bbc:	6105                	addi	sp,sp,32
    80000bbe:	8082                	ret

0000000080000bc0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bc0:	1101                	addi	sp,sp,-32
    80000bc2:	ec06                	sd	ra,24(sp)
    80000bc4:	e822                	sd	s0,16(sp)
    80000bc6:	e426                	sd	s1,8(sp)
    80000bc8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000bca:	100027f3          	csrr	a5,sstatus
    80000bce:	84be                	mv	s1,a5
    80000bd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000bd6:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if (mycpu()->noff == 0)
    80000bda:	509000ef          	jal	800018e2 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be2:	501000ef          	jal	800018e2 <mycpu>
    80000be6:	5d3c                	lw	a5,120(a0)
    80000be8:	2785                	addiw	a5,a5,1
    80000bea:	dd3c                	sw	a5,120(a0)
}
    80000bec:	60e2                	ld	ra,24(sp)
    80000bee:	6442                	ld	s0,16(sp)
    80000bf0:	64a2                	ld	s1,8(sp)
    80000bf2:	6105                	addi	sp,sp,32
    80000bf4:	8082                	ret
    mycpu()->intena = old;
    80000bf6:	4ed000ef          	jal	800018e2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bfa:	0014d793          	srli	a5,s1,0x1
    80000bfe:	8b85                	andi	a5,a5,1
    80000c00:	dd7c                	sw	a5,124(a0)
    80000c02:	b7c5                	j	80000be2 <push_off+0x22>

0000000080000c04 <acquire>:
{
    80000c04:	1101                	addi	sp,sp,-32
    80000c06:	ec06                	sd	ra,24(sp)
    80000c08:	e822                	sd	s0,16(sp)
    80000c0a:	e426                	sd	s1,8(sp)
    80000c0c:	1000                	addi	s0,sp,32
    80000c0e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c10:	fb1ff0ef          	jal	80000bc0 <push_off>
  if (holding(lk))
    80000c14:	8526                	mv	a0,s1
    80000c16:	f7fff0ef          	jal	80000b94 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c1a:	4705                	li	a4,1
  if (holding(lk))
    80000c1c:	ed11                	bnez	a0,80000c38 <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c1e:	87ba                	mv	a5,a4
    80000c20:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c24:	2781                	sext.w	a5,a5
    80000c26:	ffe5                	bnez	a5,80000c1e <acquire+0x1a>
  lk->cpu = mycpu();
    80000c28:	4bb000ef          	jal	800018e2 <mycpu>
    80000c2c:	e888                	sd	a0,16(s1)
}
    80000c2e:	60e2                	ld	ra,24(sp)
    80000c30:	6442                	ld	s0,16(sp)
    80000c32:	64a2                	ld	s1,8(sp)
    80000c34:	6105                	addi	sp,sp,32
    80000c36:	8082                	ret
    panic("acquire");
    80000c38:	00006517          	auipc	a0,0x6
    80000c3c:	41050513          	addi	a0,a0,1040 # 80007048 <etext+0x48>
    80000c40:	bd9ff0ef          	jal	80000818 <panic>

0000000080000c44 <pop_off>:

void
pop_off(void)
{
    80000c44:	1141                	addi	sp,sp,-16
    80000c46:	e406                	sd	ra,8(sp)
    80000c48:	e022                	sd	s0,0(sp)
    80000c4a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c4c:	497000ef          	jal	800018e2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c50:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c54:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c56:	e39d                	bnez	a5,80000c7c <pop_off+0x38>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c58:	5d3c                	lw	a5,120(a0)
    80000c5a:	02f05763          	blez	a5,80000c88 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c5e:	37fd                	addiw	a5,a5,-1
    80000c60:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c62:	eb89                	bnez	a5,80000c74 <pop_off+0x30>
    80000c64:	5d7c                	lw	a5,124(a0)
    80000c66:	c799                	beqz	a5,80000c74 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c68:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c6c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80000c70:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c74:	60a2                	ld	ra,8(sp)
    80000c76:	6402                	ld	s0,0(sp)
    80000c78:	0141                	addi	sp,sp,16
    80000c7a:	8082                	ret
    panic("pop_off - interruptible");
    80000c7c:	00006517          	auipc	a0,0x6
    80000c80:	3d450513          	addi	a0,a0,980 # 80007050 <etext+0x50>
    80000c84:	b95ff0ef          	jal	80000818 <panic>
    panic("pop_off");
    80000c88:	00006517          	auipc	a0,0x6
    80000c8c:	3e050513          	addi	a0,a0,992 # 80007068 <etext+0x68>
    80000c90:	b89ff0ef          	jal	80000818 <panic>

0000000080000c94 <release>:
{
    80000c94:	1101                	addi	sp,sp,-32
    80000c96:	ec06                	sd	ra,24(sp)
    80000c98:	e822                	sd	s0,16(sp)
    80000c9a:	e426                	sd	s1,8(sp)
    80000c9c:	1000                	addi	s0,sp,32
    80000c9e:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000ca0:	ef5ff0ef          	jal	80000b94 <holding>
    80000ca4:	cd11                	beqz	a0,80000cc0 <release+0x2c>
  lk->cpu = 0;
    80000ca6:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000caa:	0310000f          	fence	rw,w
    80000cae:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cb2:	f93ff0ef          	jal	80000c44 <pop_off>
}
    80000cb6:	60e2                	ld	ra,24(sp)
    80000cb8:	6442                	ld	s0,16(sp)
    80000cba:	64a2                	ld	s1,8(sp)
    80000cbc:	6105                	addi	sp,sp,32
    80000cbe:	8082                	ret
    panic("release");
    80000cc0:	00006517          	auipc	a0,0x6
    80000cc4:	3b050513          	addi	a0,a0,944 # 80007070 <etext+0x70>
    80000cc8:	b51ff0ef          	jal	80000818 <panic>

0000000080000ccc <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000ccc:	1141                	addi	sp,sp,-16
    80000cce:	e406                	sd	ra,8(sp)
    80000cd0:	e022                	sd	s0,0(sp)
    80000cd2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cd4:	ca19                	beqz	a2,80000cea <memset+0x1e>
    80000cd6:	87aa                	mv	a5,a0
    80000cd8:	1602                	slli	a2,a2,0x20
    80000cda:	9201                	srli	a2,a2,0x20
    80000cdc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000ce4:	0785                	addi	a5,a5,1
    80000ce6:	fee79de3          	bne	a5,a4,80000ce0 <memset+0x14>
  }
  return dst;
}
    80000cea:	60a2                	ld	ra,8(sp)
    80000cec:	6402                	ld	s0,0(sp)
    80000cee:	0141                	addi	sp,sp,16
    80000cf0:	8082                	ret

0000000080000cf2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf2:	1141                	addi	sp,sp,-16
    80000cf4:	e406                	sd	ra,8(sp)
    80000cf6:	e022                	sd	s0,0(sp)
    80000cf8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000cfa:	c61d                	beqz	a2,80000d28 <memcmp+0x36>
    80000cfc:	1602                	slli	a2,a2,0x20
    80000cfe:	9201                	srli	a2,a2,0x20
    80000d00:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000d04:	00054783          	lbu	a5,0(a0)
    80000d08:	0005c703          	lbu	a4,0(a1)
    80000d0c:	00e79863          	bne	a5,a4,80000d1c <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d10:	0505                	addi	a0,a0,1
    80000d12:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000d14:	fed518e3          	bne	a0,a3,80000d04 <memcmp+0x12>
  }

  return 0;
    80000d18:	4501                	li	a0,0
    80000d1a:	a019                	j	80000d20 <memcmp+0x2e>
      return *s1 - *s2;
    80000d1c:	40e7853b          	subw	a0,a5,a4
}
    80000d20:	60a2                	ld	ra,8(sp)
    80000d22:	6402                	ld	s0,0(sp)
    80000d24:	0141                	addi	sp,sp,16
    80000d26:	8082                	ret
  return 0;
    80000d28:	4501                	li	a0,0
    80000d2a:	bfdd                	j	80000d20 <memcmp+0x2e>

0000000080000d2c <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d2c:	1141                	addi	sp,sp,-16
    80000d2e:	e406                	sd	ra,8(sp)
    80000d30:	e022                	sd	s0,0(sp)
    80000d32:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d34:	c205                	beqz	a2,80000d54 <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d36:	02a5e363          	bltu	a1,a0,80000d5c <memmove+0x30>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d3a:	1602                	slli	a2,a2,0x20
    80000d3c:	9201                	srli	a2,a2,0x20
    80000d3e:	00c587b3          	add	a5,a1,a2
{
    80000d42:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d44:	0585                	addi	a1,a1,1
    80000d46:	0705                	addi	a4,a4,1
    80000d48:	fff5c683          	lbu	a3,-1(a1)
    80000d4c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d50:	feb79ae3          	bne	a5,a1,80000d44 <memmove+0x18>

  return dst;
}
    80000d54:	60a2                	ld	ra,8(sp)
    80000d56:	6402                	ld	s0,0(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret
  if (s < d && s + n > d) {
    80000d5c:	02061693          	slli	a3,a2,0x20
    80000d60:	9281                	srli	a3,a3,0x20
    80000d62:	00d58733          	add	a4,a1,a3
    80000d66:	fce57ae3          	bgeu	a0,a4,80000d3a <memmove+0xe>
    d += n;
    80000d6a:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d6c:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d70:	1782                	slli	a5,a5,0x20
    80000d72:	9381                	srli	a5,a5,0x20
    80000d74:	fff7c793          	not	a5,a5
    80000d78:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d7a:	177d                	addi	a4,a4,-1
    80000d7c:	16fd                	addi	a3,a3,-1
    80000d7e:	00074603          	lbu	a2,0(a4)
    80000d82:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d86:	fee79ae3          	bne	a5,a4,80000d7a <memmove+0x4e>
    80000d8a:	b7e9                	j	80000d54 <memmove+0x28>

0000000080000d8c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e406                	sd	ra,8(sp)
    80000d90:	e022                	sd	s0,0(sp)
    80000d92:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d94:	f99ff0ef          	jal	80000d2c <memmove>
}
    80000d98:	60a2                	ld	ra,8(sp)
    80000d9a:	6402                	ld	s0,0(sp)
    80000d9c:	0141                	addi	sp,sp,16
    80000d9e:	8082                	ret

0000000080000da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da0:	1141                	addi	sp,sp,-16
    80000da2:	e406                	sd	ra,8(sp)
    80000da4:	e022                	sd	s0,0(sp)
    80000da6:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x24>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x28>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x28>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0xa>
  if (n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a801                	j	80000dd2 <strncmp+0x32>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a031                	j	80000dd2 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000dc8:	00054503          	lbu	a0,0(a0)
    80000dcc:	0005c783          	lbu	a5,0(a1)
    80000dd0:	9d1d                	subw	a0,a0,a5
}
    80000dd2:	60a2                	ld	ra,8(sp)
    80000dd4:	6402                	ld	s0,0(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret

0000000080000dda <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000dda:	1141                	addi	sp,sp,-16
    80000ddc:	e406                	sd	ra,8(sp)
    80000dde:	e022                	sd	s0,0(sp)
    80000de0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000de2:	87aa                	mv	a5,a0
    80000de4:	a011                	j	80000de8 <strncpy+0xe>
    80000de6:	8636                	mv	a2,a3
    80000de8:	02c05863          	blez	a2,80000e18 <strncpy+0x3e>
    80000dec:	fff6069b          	addiw	a3,a2,-1
    80000df0:	8836                	mv	a6,a3
    80000df2:	0785                	addi	a5,a5,1
    80000df4:	0005c703          	lbu	a4,0(a1)
    80000df8:	fee78fa3          	sb	a4,-1(a5)
    80000dfc:	0585                	addi	a1,a1,1
    80000dfe:	f765                	bnez	a4,80000de6 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000e00:	873e                	mv	a4,a5
    80000e02:	01005b63          	blez	a6,80000e18 <strncpy+0x3e>
    80000e06:	9fb1                	addw	a5,a5,a2
    80000e08:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e0a:	0705                	addi	a4,a4,1
    80000e0c:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000e10:	40e786bb          	subw	a3,a5,a4
    80000e14:	fed04be3          	bgtz	a3,80000e0a <strncpy+0x30>
  return os;
}
    80000e18:	60a2                	ld	ra,8(sp)
    80000e1a:	6402                	ld	s0,0(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret

0000000080000e20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000e20:	1141                	addi	sp,sp,-16
    80000e22:	e406                	sd	ra,8(sp)
    80000e24:	e022                	sd	s0,0(sp)
    80000e26:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e28:	02c05363          	blez	a2,80000e4e <safestrcpy+0x2e>
    80000e2c:	fff6069b          	addiw	a3,a2,-1
    80000e30:	1682                	slli	a3,a3,0x20
    80000e32:	9281                	srli	a3,a3,0x20
    80000e34:	96ae                	add	a3,a3,a1
    80000e36:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e38:	00d58963          	beq	a1,a3,80000e4a <safestrcpy+0x2a>
    80000e3c:	0585                	addi	a1,a1,1
    80000e3e:	0785                	addi	a5,a5,1
    80000e40:	fff5c703          	lbu	a4,-1(a1)
    80000e44:	fee78fa3          	sb	a4,-1(a5)
    80000e48:	fb65                	bnez	a4,80000e38 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e4a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4e:	60a2                	ld	ra,8(sp)
    80000e50:	6402                	ld	s0,0(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret

0000000080000e56 <strlen>:

int
strlen(const char *s)
{
    80000e56:	1141                	addi	sp,sp,-16
    80000e58:	e406                	sd	ra,8(sp)
    80000e5a:	e022                	sd	s0,0(sp)
    80000e5c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e5e:	00054783          	lbu	a5,0(a0)
    80000e62:	cf91                	beqz	a5,80000e7e <strlen+0x28>
    80000e64:	00150793          	addi	a5,a0,1
    80000e68:	86be                	mv	a3,a5
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff7c703          	lbu	a4,-1(a5)
    80000e70:	ff65                	bnez	a4,80000e68 <strlen+0x12>
    80000e72:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e76:	60a2                	ld	ra,8(sp)
    80000e78:	6402                	ld	s0,0(sp)
    80000e7a:	0141                	addi	sp,sp,16
    80000e7c:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e7e:	4501                	li	a0,0
    80000e80:	bfdd                	j	80000e76 <strlen+0x20>

0000000080000e82 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e8a:	245000ef          	jal	800018ce <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    started = 1;
  } else {
    while (started == 0)
    80000e8e:	00007717          	auipc	a4,0x7
    80000e92:	9c270713          	addi	a4,a4,-1598 # 80007850 <started>
  if (cpuid() == 0) {
    80000e96:	c51d                	beqz	a0,80000ec4 <main+0x42>
    while (started == 0)
    80000e98:	431c                	lw	a5,0(a4)
    80000e9a:	2781                	sext.w	a5,a5
    80000e9c:	dff5                	beqz	a5,80000e98 <main+0x16>
      ;
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000e9e:	0330000f          	fence	rw,rw
    printk("hart %d starting\n", cpuid());
    80000ea2:	22d000ef          	jal	800018ce <cpuid>
    80000ea6:	85aa                	mv	a1,a0
    80000ea8:	00006517          	auipc	a0,0x6
    80000eac:	1f050513          	addi	a0,a0,496 # 80007098 <etext+0x98>
    80000eb0:	e3eff0ef          	jal	800004ee <printk>
    kvminithart();  // turn on paging
    80000eb4:	080000ef          	jal	80000f34 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000eb8:	594010ef          	jal	8000244c <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000ebc:	73c040ef          	jal	800055f8 <plicinithart>
  }

  scheduler();
    80000ec0:	6c1000ef          	jal	80001d80 <scheduler>
    consoleinit();
    80000ec4:	d50ff0ef          	jal	80000414 <consoleinit>
    printkinit();
    80000ec8:	98dff0ef          	jal	80000854 <printkinit>
    printk("\n");
    80000ecc:	00006517          	auipc	a0,0x6
    80000ed0:	1ac50513          	addi	a0,a0,428 # 80007078 <etext+0x78>
    80000ed4:	e1aff0ef          	jal	800004ee <printk>
    printk("xv6 kernel is booting\n");
    80000ed8:	00006517          	auipc	a0,0x6
    80000edc:	1a850513          	addi	a0,a0,424 # 80007080 <etext+0x80>
    80000ee0:	e0eff0ef          	jal	800004ee <printk>
    printk("\n");
    80000ee4:	00006517          	auipc	a0,0x6
    80000ee8:	19450513          	addi	a0,a0,404 # 80007078 <etext+0x78>
    80000eec:	e02ff0ef          	jal	800004ee <printk>
    kinit();            // physical page allocator
    80000ef0:	bfdff0ef          	jal	80000aec <kinit>
    kvminit();          // create kernel page table
    80000ef4:	2cc000ef          	jal	800011c0 <kvminit>
    kvminithart();      // turn on paging
    80000ef8:	03c000ef          	jal	80000f34 <kvminithart>
    procinit();         // process table
    80000efc:	11d000ef          	jal	80001818 <procinit>
    trapinit();         // trap vectors
    80000f00:	528010ef          	jal	80002428 <trapinit>
    trapinithart();     // install kernel trap vector
    80000f04:	548010ef          	jal	8000244c <trapinithart>
    plicinit();         // set up interrupt controller
    80000f08:	6d6040ef          	jal	800055de <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000f0c:	6ec040ef          	jal	800055f8 <plicinithart>
    binit();            // buffer cache
    80000f10:	563010ef          	jal	80002c72 <binit>
    iinit();            // inode table
    80000f14:	2b4020ef          	jal	800031c8 <iinit>
    fileinit();         // file table
    80000f18:	1e0030ef          	jal	800040f8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f1c:	7cc040ef          	jal	800056e8 <virtio_disk_init>
    userinit();         // first user process
    80000f20:	4b5000ef          	jal	80001bd4 <userinit>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000f24:	0330000f          	fence	rw,rw
    started = 1;
    80000f28:	4785                	li	a5,1
    80000f2a:	00007717          	auipc	a4,0x7
    80000f2e:	92f72323          	sw	a5,-1754(a4) # 80007850 <started>
    80000f32:	b779                	j	80000ec0 <main+0x3e>

0000000080000f34 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f34:	1141                	addi	sp,sp,-16
    80000f36:	e406                	sd	ra,8(sp)
    80000f38:	e022                	sd	s0,0(sp)
    80000f3a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f3c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f40:	00007797          	auipc	a5,0x7
    80000f44:	9187b783          	ld	a5,-1768(a5) # 80007858 <kernel_pagetable>
    80000f48:	83b1                	srli	a5,a5,0xc
    80000f4a:	577d                	li	a4,-1
    80000f4c:	177e                	slli	a4,a4,0x3f
    80000f4e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f50:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f54:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f58:	60a2                	ld	ra,8(sp)
    80000f5a:	6402                	ld	s0,0(sp)
    80000f5c:	0141                	addi	sp,sp,16
    80000f5e:	8082                	ret

0000000080000f60 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f60:	7139                	addi	sp,sp,-64
    80000f62:	fc06                	sd	ra,56(sp)
    80000f64:	f822                	sd	s0,48(sp)
    80000f66:	f426                	sd	s1,40(sp)
    80000f68:	f04a                	sd	s2,32(sp)
    80000f6a:	ec4e                	sd	s3,24(sp)
    80000f6c:	e852                	sd	s4,16(sp)
    80000f6e:	e456                	sd	s5,8(sp)
    80000f70:	e05a                	sd	s6,0(sp)
    80000f72:	0080                	addi	s0,sp,64
    80000f74:	84aa                	mv	s1,a0
    80000f76:	89ae                	mv	s3,a1
    80000f78:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f7a:	57fd                	li	a5,-1
    80000f7c:	83e9                	srli	a5,a5,0x1a
    80000f7e:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f80:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f82:	04b7e263          	bltu	a5,a1,80000fc6 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f86:	0149d933          	srl	s2,s3,s4
    80000f8a:	1ff97913          	andi	s2,s2,511
    80000f8e:	090e                	slli	s2,s2,0x3
    80000f90:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f92:	00093483          	ld	s1,0(s2)
    80000f96:	0014f793          	andi	a5,s1,1
    80000f9a:	cf85                	beqz	a5,80000fd2 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f9c:	80a9                	srli	s1,s1,0xa
    80000f9e:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--) {
    80000fa0:	3a5d                	addiw	s4,s4,-9
    80000fa2:	ff5a12e3          	bne	s4,s5,80000f86 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000fa6:	00c9d513          	srli	a0,s3,0xc
    80000faa:	1ff57513          	andi	a0,a0,511
    80000fae:	050e                	slli	a0,a0,0x3
    80000fb0:	9526                	add	a0,a0,s1
}
    80000fb2:	70e2                	ld	ra,56(sp)
    80000fb4:	7442                	ld	s0,48(sp)
    80000fb6:	74a2                	ld	s1,40(sp)
    80000fb8:	7902                	ld	s2,32(sp)
    80000fba:	69e2                	ld	s3,24(sp)
    80000fbc:	6a42                	ld	s4,16(sp)
    80000fbe:	6aa2                	ld	s5,8(sp)
    80000fc0:	6b02                	ld	s6,0(sp)
    80000fc2:	6121                	addi	sp,sp,64
    80000fc4:	8082                	ret
    panic("walk");
    80000fc6:	00006517          	auipc	a0,0x6
    80000fca:	0ea50513          	addi	a0,a0,234 # 800070b0 <etext+0xb0>
    80000fce:	84bff0ef          	jal	80000818 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000fd2:	020b0263          	beqz	s6,80000ff6 <walk+0x96>
    80000fd6:	b4bff0ef          	jal	80000b20 <kalloc>
    80000fda:	84aa                	mv	s1,a0
    80000fdc:	d979                	beqz	a0,80000fb2 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000fde:	6605                	lui	a2,0x1
    80000fe0:	4581                	li	a1,0
    80000fe2:	cebff0ef          	jal	80000ccc <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fe6:	00c4d793          	srli	a5,s1,0xc
    80000fea:	07aa                	slli	a5,a5,0xa
    80000fec:	0017e793          	ori	a5,a5,1
    80000ff0:	00f93023          	sd	a5,0(s2)
    80000ff4:	b775                	j	80000fa0 <walk+0x40>
        return 0;
    80000ff6:	4501                	li	a0,0
    80000ff8:	bf6d                	j	80000fb2 <walk+0x52>

0000000080000ffa <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000ffa:	57fd                	li	a5,-1
    80000ffc:	83e9                	srli	a5,a5,0x1a
    80000ffe:	00b7f463          	bgeu	a5,a1,80001006 <walkaddr+0xc>
    return 0;
    80001002:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001004:	8082                	ret
{
    80001006:	1141                	addi	sp,sp,-16
    80001008:	e406                	sd	ra,8(sp)
    8000100a:	e022                	sd	s0,0(sp)
    8000100c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000100e:	4601                	li	a2,0
    80001010:	f51ff0ef          	jal	80000f60 <walk>
  if (pte == 0)
    80001014:	c901                	beqz	a0,80001024 <walkaddr+0x2a>
  if ((*pte & PTE_V) == 0)
    80001016:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80001018:	0117f693          	andi	a3,a5,17
    8000101c:	4745                	li	a4,17
    return 0;
    8000101e:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80001020:	00e68663          	beq	a3,a4,8000102c <walkaddr+0x32>
}
    80001024:	60a2                	ld	ra,8(sp)
    80001026:	6402                	ld	s0,0(sp)
    80001028:	0141                	addi	sp,sp,16
    8000102a:	8082                	ret
  pa = PTE2PA(*pte);
    8000102c:	83a9                	srli	a5,a5,0xa
    8000102e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001032:	bfcd                	j	80001024 <walkaddr+0x2a>

0000000080001034 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001034:	715d                	addi	sp,sp,-80
    80001036:	e486                	sd	ra,72(sp)
    80001038:	e0a2                	sd	s0,64(sp)
    8000103a:	fc26                	sd	s1,56(sp)
    8000103c:	f84a                	sd	s2,48(sp)
    8000103e:	f44e                	sd	s3,40(sp)
    80001040:	f052                	sd	s4,32(sp)
    80001042:	ec56                	sd	s5,24(sp)
    80001044:	e85a                	sd	s6,16(sp)
    80001046:	e45e                	sd	s7,8(sp)
    80001048:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000104a:	03459793          	slli	a5,a1,0x34
    8000104e:	eba1                	bnez	a5,8000109e <mappages+0x6a>
    80001050:	8a2a                	mv	s4,a0
    80001052:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001054:	03461793          	slli	a5,a2,0x34
    80001058:	eba9                	bnez	a5,800010aa <mappages+0x76>
    panic("mappages: size not aligned");

  if (size == 0)
    8000105a:	ce31                	beqz	a2,800010b6 <mappages+0x82>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000105c:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80001060:	80060613          	addi	a2,a2,-2048
    80001064:	00b60933          	add	s2,a2,a1
  a = va;
    80001068:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000106a:	4b05                	li	s6,1
    8000106c:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001070:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001072:	865a                	mv	a2,s6
    80001074:	85a6                	mv	a1,s1
    80001076:	8552                	mv	a0,s4
    80001078:	ee9ff0ef          	jal	80000f60 <walk>
    8000107c:	c929                	beqz	a0,800010ce <mappages+0x9a>
    if (*pte & PTE_V)
    8000107e:	611c                	ld	a5,0(a0)
    80001080:	8b85                	andi	a5,a5,1
    80001082:	e3a1                	bnez	a5,800010c2 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001084:	013487b3          	add	a5,s1,s3
    80001088:	83b1                	srli	a5,a5,0xc
    8000108a:	07aa                	slli	a5,a5,0xa
    8000108c:	0157e7b3          	or	a5,a5,s5
    80001090:	0017e793          	ori	a5,a5,1
    80001094:	e11c                	sd	a5,0(a0)
    if (a == last)
    80001096:	05248863          	beq	s1,s2,800010e6 <mappages+0xb2>
    a += PGSIZE;
    8000109a:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000109c:	bfd9                	j	80001072 <mappages+0x3e>
    panic("mappages: va not aligned");
    8000109e:	00006517          	auipc	a0,0x6
    800010a2:	01a50513          	addi	a0,a0,26 # 800070b8 <etext+0xb8>
    800010a6:	f72ff0ef          	jal	80000818 <panic>
    panic("mappages: size not aligned");
    800010aa:	00006517          	auipc	a0,0x6
    800010ae:	02e50513          	addi	a0,a0,46 # 800070d8 <etext+0xd8>
    800010b2:	f66ff0ef          	jal	80000818 <panic>
    panic("mappages: size");
    800010b6:	00006517          	auipc	a0,0x6
    800010ba:	04250513          	addi	a0,a0,66 # 800070f8 <etext+0xf8>
    800010be:	f5aff0ef          	jal	80000818 <panic>
      panic("mappages: remap");
    800010c2:	00006517          	auipc	a0,0x6
    800010c6:	04650513          	addi	a0,a0,70 # 80007108 <etext+0x108>
    800010ca:	f4eff0ef          	jal	80000818 <panic>
      return -1;
    800010ce:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010d0:	60a6                	ld	ra,72(sp)
    800010d2:	6406                	ld	s0,64(sp)
    800010d4:	74e2                	ld	s1,56(sp)
    800010d6:	7942                	ld	s2,48(sp)
    800010d8:	79a2                	ld	s3,40(sp)
    800010da:	7a02                	ld	s4,32(sp)
    800010dc:	6ae2                	ld	s5,24(sp)
    800010de:	6b42                	ld	s6,16(sp)
    800010e0:	6ba2                	ld	s7,8(sp)
    800010e2:	6161                	addi	sp,sp,80
    800010e4:	8082                	ret
  return 0;
    800010e6:	4501                	li	a0,0
    800010e8:	b7e5                	j	800010d0 <mappages+0x9c>

00000000800010ea <kvmmap>:
{
    800010ea:	1141                	addi	sp,sp,-16
    800010ec:	e406                	sd	ra,8(sp)
    800010ee:	e022                	sd	s0,0(sp)
    800010f0:	0800                	addi	s0,sp,16
    800010f2:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010f4:	86b2                	mv	a3,a2
    800010f6:	863e                	mv	a2,a5
    800010f8:	f3dff0ef          	jal	80001034 <mappages>
    800010fc:	e509                	bnez	a0,80001106 <kvmmap+0x1c>
}
    800010fe:	60a2                	ld	ra,8(sp)
    80001100:	6402                	ld	s0,0(sp)
    80001102:	0141                	addi	sp,sp,16
    80001104:	8082                	ret
    panic("kvmmap");
    80001106:	00006517          	auipc	a0,0x6
    8000110a:	01250513          	addi	a0,a0,18 # 80007118 <etext+0x118>
    8000110e:	f0aff0ef          	jal	80000818 <panic>

0000000080001112 <kvmmake>:
{
    80001112:	1101                	addi	sp,sp,-32
    80001114:	ec06                	sd	ra,24(sp)
    80001116:	e822                	sd	s0,16(sp)
    80001118:	e426                	sd	s1,8(sp)
    8000111a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000111c:	a05ff0ef          	jal	80000b20 <kalloc>
    80001120:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001122:	6605                	lui	a2,0x1
    80001124:	4581                	li	a1,0
    80001126:	ba7ff0ef          	jal	80000ccc <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000112a:	4719                	li	a4,6
    8000112c:	6685                	lui	a3,0x1
    8000112e:	10000637          	lui	a2,0x10000
    80001132:	85b2                	mv	a1,a2
    80001134:	8526                	mv	a0,s1
    80001136:	fb5ff0ef          	jal	800010ea <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000113a:	4719                	li	a4,6
    8000113c:	6685                	lui	a3,0x1
    8000113e:	10001637          	lui	a2,0x10001
    80001142:	85b2                	mv	a1,a2
    80001144:	8526                	mv	a0,s1
    80001146:	fa5ff0ef          	jal	800010ea <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000114a:	4719                	li	a4,6
    8000114c:	040006b7          	lui	a3,0x4000
    80001150:	0c000637          	lui	a2,0xc000
    80001154:	85b2                	mv	a1,a2
    80001156:	8526                	mv	a0,s1
    80001158:	f93ff0ef          	jal	800010ea <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000115c:	4729                	li	a4,10
    8000115e:	80006697          	auipc	a3,0x80006
    80001162:	ea268693          	addi	a3,a3,-350 # 7000 <_entry-0x7fff9000>
    80001166:	4605                	li	a2,1
    80001168:	067e                	slli	a2,a2,0x1f
    8000116a:	85b2                	mv	a1,a2
    8000116c:	8526                	mv	a0,s1
    8000116e:	f7dff0ef          	jal	800010ea <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001172:	4719                	li	a4,6
    80001174:	00006697          	auipc	a3,0x6
    80001178:	e8c68693          	addi	a3,a3,-372 # 80007000 <etext>
    8000117c:	47c5                	li	a5,17
    8000117e:	07ee                	slli	a5,a5,0x1b
    80001180:	40d786b3          	sub	a3,a5,a3
    80001184:	00006617          	auipc	a2,0x6
    80001188:	e7c60613          	addi	a2,a2,-388 # 80007000 <etext>
    8000118c:	85b2                	mv	a1,a2
    8000118e:	8526                	mv	a0,s1
    80001190:	f5bff0ef          	jal	800010ea <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001194:	4729                	li	a4,10
    80001196:	6685                	lui	a3,0x1
    80001198:	00005617          	auipc	a2,0x5
    8000119c:	e6860613          	addi	a2,a2,-408 # 80006000 <_trampoline>
    800011a0:	040005b7          	lui	a1,0x4000
    800011a4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a6:	05b2                	slli	a1,a1,0xc
    800011a8:	8526                	mv	a0,s1
    800011aa:	f41ff0ef          	jal	800010ea <kvmmap>
  proc_mapstacks(kpgtbl);
    800011ae:	8526                	mv	a0,s1
    800011b0:	5c4000ef          	jal	80001774 <proc_mapstacks>
}
    800011b4:	8526                	mv	a0,s1
    800011b6:	60e2                	ld	ra,24(sp)
    800011b8:	6442                	ld	s0,16(sp)
    800011ba:	64a2                	ld	s1,8(sp)
    800011bc:	6105                	addi	sp,sp,32
    800011be:	8082                	ret

00000000800011c0 <kvminit>:
{
    800011c0:	1141                	addi	sp,sp,-16
    800011c2:	e406                	sd	ra,8(sp)
    800011c4:	e022                	sd	s0,0(sp)
    800011c6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011c8:	f4bff0ef          	jal	80001112 <kvmmake>
    800011cc:	00006797          	auipc	a5,0x6
    800011d0:	68a7b623          	sd	a0,1676(a5) # 80007858 <kernel_pagetable>
}
    800011d4:	60a2                	ld	ra,8(sp)
    800011d6:	6402                	ld	s0,0(sp)
    800011d8:	0141                	addi	sp,sp,16
    800011da:	8082                	ret

00000000800011dc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011dc:	1101                	addi	sp,sp,-32
    800011de:	ec06                	sd	ra,24(sp)
    800011e0:	e822                	sd	s0,16(sp)
    800011e2:	e426                	sd	s1,8(sp)
    800011e4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011e6:	93bff0ef          	jal	80000b20 <kalloc>
    800011ea:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011ec:	c509                	beqz	a0,800011f6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011ee:	6605                	lui	a2,0x1
    800011f0:	4581                	li	a1,0
    800011f2:	adbff0ef          	jal	80000ccc <memset>
  return pagetable;
}
    800011f6:	8526                	mv	a0,s1
    800011f8:	60e2                	ld	ra,24(sp)
    800011fa:	6442                	ld	s0,16(sp)
    800011fc:	64a2                	ld	s1,8(sp)
    800011fe:	6105                	addi	sp,sp,32
    80001200:	8082                	ret

0000000080001202 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001202:	7139                	addi	sp,sp,-64
    80001204:	fc06                	sd	ra,56(sp)
    80001206:	f822                	sd	s0,48(sp)
    80001208:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000120a:	03459793          	slli	a5,a1,0x34
    8000120e:	e38d                	bnez	a5,80001230 <uvmunmap+0x2e>
    80001210:	f04a                	sd	s2,32(sp)
    80001212:	ec4e                	sd	s3,24(sp)
    80001214:	e852                	sd	s4,16(sp)
    80001216:	e456                	sd	s5,8(sp)
    80001218:	e05a                	sd	s6,0(sp)
    8000121a:	8a2a                	mv	s4,a0
    8000121c:	892e                	mv	s2,a1
    8000121e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001220:	0632                	slli	a2,a2,0xc
    80001222:	00b609b3          	add	s3,a2,a1
    80001226:	6b05                	lui	s6,0x1
    80001228:	0535f963          	bgeu	a1,s3,8000127a <uvmunmap+0x78>
    8000122c:	f426                	sd	s1,40(sp)
    8000122e:	a015                	j	80001252 <uvmunmap+0x50>
    80001230:	f426                	sd	s1,40(sp)
    80001232:	f04a                	sd	s2,32(sp)
    80001234:	ec4e                	sd	s3,24(sp)
    80001236:	e852                	sd	s4,16(sp)
    80001238:	e456                	sd	s5,8(sp)
    8000123a:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000123c:	00006517          	auipc	a0,0x6
    80001240:	ee450513          	addi	a0,a0,-284 # 80007120 <etext+0x120>
    80001244:	dd4ff0ef          	jal	80000818 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    80001248:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000124c:	995a                	add	s2,s2,s6
    8000124e:	03397563          	bgeu	s2,s3,80001278 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001252:	4601                	li	a2,0
    80001254:	85ca                	mv	a1,s2
    80001256:	8552                	mv	a0,s4
    80001258:	d09ff0ef          	jal	80000f60 <walk>
    8000125c:	84aa                	mv	s1,a0
    8000125e:	d57d                	beqz	a0,8000124c <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001260:	611c                	ld	a5,0(a0)
    80001262:	0017f713          	andi	a4,a5,1
    80001266:	d37d                	beqz	a4,8000124c <uvmunmap+0x4a>
    if (do_free) {
    80001268:	fe0a80e3          	beqz	s5,80001248 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000126c:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    8000126e:	00c79513          	slli	a0,a5,0xc
    80001272:	fc6ff0ef          	jal	80000a38 <kfree>
    80001276:	bfc9                	j	80001248 <uvmunmap+0x46>
    80001278:	74a2                	ld	s1,40(sp)
    8000127a:	7902                	ld	s2,32(sp)
    8000127c:	69e2                	ld	s3,24(sp)
    8000127e:	6a42                	ld	s4,16(sp)
    80001280:	6aa2                	ld	s5,8(sp)
    80001282:	6b02                	ld	s6,0(sp)
  }
}
    80001284:	70e2                	ld	ra,56(sp)
    80001286:	7442                	ld	s0,48(sp)
    80001288:	6121                	addi	sp,sp,64
    8000128a:	8082                	ret

000000008000128c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000128c:	1101                	addi	sp,sp,-32
    8000128e:	ec06                	sd	ra,24(sp)
    80001290:	e822                	sd	s0,16(sp)
    80001292:	e426                	sd	s1,8(sp)
    80001294:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001296:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001298:	00b67d63          	bgeu	a2,a1,800012b2 <uvmdealloc+0x26>
    8000129c:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000129e:	6785                	lui	a5,0x1
    800012a0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012a2:	00f60733          	add	a4,a2,a5
    800012a6:	76fd                	lui	a3,0xfffff
    800012a8:	8f75                	and	a4,a4,a3
    800012aa:	97ae                	add	a5,a5,a1
    800012ac:	8ff5                	and	a5,a5,a3
    800012ae:	00f76863          	bltu	a4,a5,800012be <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800012b2:	8526                	mv	a0,s1
    800012b4:	60e2                	ld	ra,24(sp)
    800012b6:	6442                	ld	s0,16(sp)
    800012b8:	64a2                	ld	s1,8(sp)
    800012ba:	6105                	addi	sp,sp,32
    800012bc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012be:	8f99                	sub	a5,a5,a4
    800012c0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012c2:	4685                	li	a3,1
    800012c4:	0007861b          	sext.w	a2,a5
    800012c8:	85ba                	mv	a1,a4
    800012ca:	f39ff0ef          	jal	80001202 <uvmunmap>
    800012ce:	b7d5                	j	800012b2 <uvmdealloc+0x26>

00000000800012d0 <uvmalloc>:
  if (newsz < oldsz)
    800012d0:	0ab66163          	bltu	a2,a1,80001372 <uvmalloc+0xa2>
{
    800012d4:	715d                	addi	sp,sp,-80
    800012d6:	e486                	sd	ra,72(sp)
    800012d8:	e0a2                	sd	s0,64(sp)
    800012da:	f84a                	sd	s2,48(sp)
    800012dc:	f052                	sd	s4,32(sp)
    800012de:	ec56                	sd	s5,24(sp)
    800012e0:	e45e                	sd	s7,8(sp)
    800012e2:	0880                	addi	s0,sp,80
    800012e4:	8aaa                	mv	s5,a0
    800012e6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012e8:	6785                	lui	a5,0x1
    800012ea:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012ec:	95be                	add	a1,a1,a5
    800012ee:	77fd                	lui	a5,0xfffff
    800012f0:	00f5f933          	and	s2,a1,a5
    800012f4:	8bca                	mv	s7,s2
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012f6:	08c97063          	bgeu	s2,a2,80001376 <uvmalloc+0xa6>
    800012fa:	fc26                	sd	s1,56(sp)
    800012fc:	f44e                	sd	s3,40(sp)
    800012fe:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    80001300:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80001302:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001306:	81bff0ef          	jal	80000b20 <kalloc>
    8000130a:	84aa                	mv	s1,a0
    if (mem == 0) {
    8000130c:	c50d                	beqz	a0,80001336 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    8000130e:	864e                	mv	a2,s3
    80001310:	4581                	li	a1,0
    80001312:	9bbff0ef          	jal	80000ccc <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80001316:	875a                	mv	a4,s6
    80001318:	86a6                	mv	a3,s1
    8000131a:	864e                	mv	a2,s3
    8000131c:	85ca                	mv	a1,s2
    8000131e:	8556                	mv	a0,s5
    80001320:	d15ff0ef          	jal	80001034 <mappages>
    80001324:	e915                	bnez	a0,80001358 <uvmalloc+0x88>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001326:	994e                	add	s2,s2,s3
    80001328:	fd496fe3          	bltu	s2,s4,80001306 <uvmalloc+0x36>
  return newsz;
    8000132c:	8552                	mv	a0,s4
    8000132e:	74e2                	ld	s1,56(sp)
    80001330:	79a2                	ld	s3,40(sp)
    80001332:	6b42                	ld	s6,16(sp)
    80001334:	a811                	j	80001348 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80001336:	865e                	mv	a2,s7
    80001338:	85ca                	mv	a1,s2
    8000133a:	8556                	mv	a0,s5
    8000133c:	f51ff0ef          	jal	8000128c <uvmdealloc>
      return 0;
    80001340:	4501                	li	a0,0
    80001342:	74e2                	ld	s1,56(sp)
    80001344:	79a2                	ld	s3,40(sp)
    80001346:	6b42                	ld	s6,16(sp)
}
    80001348:	60a6                	ld	ra,72(sp)
    8000134a:	6406                	ld	s0,64(sp)
    8000134c:	7942                	ld	s2,48(sp)
    8000134e:	7a02                	ld	s4,32(sp)
    80001350:	6ae2                	ld	s5,24(sp)
    80001352:	6ba2                	ld	s7,8(sp)
    80001354:	6161                	addi	sp,sp,80
    80001356:	8082                	ret
      kfree(mem);
    80001358:	8526                	mv	a0,s1
    8000135a:	edeff0ef          	jal	80000a38 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000135e:	865e                	mv	a2,s7
    80001360:	85ca                	mv	a1,s2
    80001362:	8556                	mv	a0,s5
    80001364:	f29ff0ef          	jal	8000128c <uvmdealloc>
      return 0;
    80001368:	4501                	li	a0,0
    8000136a:	74e2                	ld	s1,56(sp)
    8000136c:	79a2                	ld	s3,40(sp)
    8000136e:	6b42                	ld	s6,16(sp)
    80001370:	bfe1                	j	80001348 <uvmalloc+0x78>
    return oldsz;
    80001372:	852e                	mv	a0,a1
}
    80001374:	8082                	ret
  return newsz;
    80001376:	8532                	mv	a0,a2
    80001378:	bfc1                	j	80001348 <uvmalloc+0x78>

000000008000137a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000137a:	7179                	addi	sp,sp,-48
    8000137c:	f406                	sd	ra,40(sp)
    8000137e:	f022                	sd	s0,32(sp)
    80001380:	ec26                	sd	s1,24(sp)
    80001382:	e84a                	sd	s2,16(sp)
    80001384:	e44e                	sd	s3,8(sp)
    80001386:	1800                	addi	s0,sp,48
    80001388:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000138a:	84aa                	mv	s1,a0
    8000138c:	6905                	lui	s2,0x1
    8000138e:	992a                	add	s2,s2,a0
    80001390:	a811                	j	800013a4 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    80001392:	00006517          	auipc	a0,0x6
    80001396:	da650513          	addi	a0,a0,-602 # 80007138 <etext+0x138>
    8000139a:	c7eff0ef          	jal	80000818 <panic>
  for (int i = 0; i < 512; i++) {
    8000139e:	04a1                	addi	s1,s1,8
    800013a0:	03248163          	beq	s1,s2,800013c2 <freewalk+0x48>
    pte_t pte = pagetable[i];
    800013a4:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013a6:	0017f713          	andi	a4,a5,1
    800013aa:	db75                	beqz	a4,8000139e <freewalk+0x24>
    800013ac:	00e7f713          	andi	a4,a5,14
    800013b0:	f36d                	bnez	a4,80001392 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800013b2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013b4:	00c79513          	slli	a0,a5,0xc
    800013b8:	fc3ff0ef          	jal	8000137a <freewalk>
      pagetable[i] = 0;
    800013bc:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013c0:	bff9                	j	8000139e <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013c2:	854e                	mv	a0,s3
    800013c4:	e74ff0ef          	jal	80000a38 <kfree>
}
    800013c8:	70a2                	ld	ra,40(sp)
    800013ca:	7402                	ld	s0,32(sp)
    800013cc:	64e2                	ld	s1,24(sp)
    800013ce:	6942                	ld	s2,16(sp)
    800013d0:	69a2                	ld	s3,8(sp)
    800013d2:	6145                	addi	sp,sp,48
    800013d4:	8082                	ret

00000000800013d6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013d6:	1101                	addi	sp,sp,-32
    800013d8:	ec06                	sd	ra,24(sp)
    800013da:	e822                	sd	s0,16(sp)
    800013dc:	e426                	sd	s1,8(sp)
    800013de:	1000                	addi	s0,sp,32
    800013e0:	84aa                	mv	s1,a0
  if (sz > 0)
    800013e2:	e989                	bnez	a1,800013f4 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013e4:	8526                	mv	a0,s1
    800013e6:	f95ff0ef          	jal	8000137a <freewalk>
}
    800013ea:	60e2                	ld	ra,24(sp)
    800013ec:	6442                	ld	s0,16(sp)
    800013ee:	64a2                	ld	s1,8(sp)
    800013f0:	6105                	addi	sp,sp,32
    800013f2:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013f4:	6785                	lui	a5,0x1
    800013f6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013f8:	95be                	add	a1,a1,a5
    800013fa:	4685                	li	a3,1
    800013fc:	00c5d613          	srli	a2,a1,0xc
    80001400:	4581                	li	a1,0
    80001402:	e01ff0ef          	jal	80001202 <uvmunmap>
    80001406:	bff9                	j	800013e4 <uvmfree+0xe>

0000000080001408 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    80001408:	ca59                	beqz	a2,8000149e <uvmcopy+0x96>
{
    8000140a:	715d                	addi	sp,sp,-80
    8000140c:	e486                	sd	ra,72(sp)
    8000140e:	e0a2                	sd	s0,64(sp)
    80001410:	fc26                	sd	s1,56(sp)
    80001412:	f84a                	sd	s2,48(sp)
    80001414:	f44e                	sd	s3,40(sp)
    80001416:	f052                	sd	s4,32(sp)
    80001418:	ec56                	sd	s5,24(sp)
    8000141a:	e85a                	sd	s6,16(sp)
    8000141c:	e45e                	sd	s7,8(sp)
    8000141e:	0880                	addi	s0,sp,80
    80001420:	8b2a                	mv	s6,a0
    80001422:	8bae                	mv	s7,a1
    80001424:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001426:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80001428:	6a05                	lui	s4,0x1
    8000142a:	a021                	j	80001432 <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    8000142c:	94d2                	add	s1,s1,s4
    8000142e:	0554fc63          	bgeu	s1,s5,80001486 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    80001432:	4601                	li	a2,0
    80001434:	85a6                	mv	a1,s1
    80001436:	855a                	mv	a0,s6
    80001438:	b29ff0ef          	jal	80000f60 <walk>
    8000143c:	d965                	beqz	a0,8000142c <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000143e:	00053983          	ld	s3,0(a0)
    80001442:	0019f793          	andi	a5,s3,1
    80001446:	d3fd                	beqz	a5,8000142c <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001448:	ed8ff0ef          	jal	80000b20 <kalloc>
    8000144c:	892a                	mv	s2,a0
    8000144e:	c11d                	beqz	a0,80001474 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    80001450:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001454:	8652                	mv	a2,s4
    80001456:	05b2                	slli	a1,a1,0xc
    80001458:	8d5ff0ef          	jal	80000d2c <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    8000145c:	3ff9f713          	andi	a4,s3,1023
    80001460:	86ca                	mv	a3,s2
    80001462:	8652                	mv	a2,s4
    80001464:	85a6                	mv	a1,s1
    80001466:	855e                	mv	a0,s7
    80001468:	bcdff0ef          	jal	80001034 <mappages>
    8000146c:	d161                	beqz	a0,8000142c <uvmcopy+0x24>
      kfree(mem);
    8000146e:	854a                	mv	a0,s2
    80001470:	dc8ff0ef          	jal	80000a38 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001474:	4685                	li	a3,1
    80001476:	00c4d613          	srli	a2,s1,0xc
    8000147a:	4581                	li	a1,0
    8000147c:	855e                	mv	a0,s7
    8000147e:	d85ff0ef          	jal	80001202 <uvmunmap>
  return -1;
    80001482:	557d                	li	a0,-1
    80001484:	a011                	j	80001488 <uvmcopy+0x80>
  return 0;
    80001486:	4501                	li	a0,0
}
    80001488:	60a6                	ld	ra,72(sp)
    8000148a:	6406                	ld	s0,64(sp)
    8000148c:	74e2                	ld	s1,56(sp)
    8000148e:	7942                	ld	s2,48(sp)
    80001490:	79a2                	ld	s3,40(sp)
    80001492:	7a02                	ld	s4,32(sp)
    80001494:	6ae2                	ld	s5,24(sp)
    80001496:	6b42                	ld	s6,16(sp)
    80001498:	6ba2                	ld	s7,8(sp)
    8000149a:	6161                	addi	sp,sp,80
    8000149c:	8082                	ret
  return 0;
    8000149e:	4501                	li	a0,0
}
    800014a0:	8082                	ret

00000000800014a2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800014a2:	1141                	addi	sp,sp,-16
    800014a4:	e406                	sd	ra,8(sp)
    800014a6:	e022                	sd	s0,0(sp)
    800014a8:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    800014aa:	4601                	li	a2,0
    800014ac:	ab5ff0ef          	jal	80000f60 <walk>
  if (pte == 0)
    800014b0:	c901                	beqz	a0,800014c0 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800014b2:	611c                	ld	a5,0(a0)
    800014b4:	9bbd                	andi	a5,a5,-17
    800014b6:	e11c                	sd	a5,0(a0)
}
    800014b8:	60a2                	ld	ra,8(sp)
    800014ba:	6402                	ld	s0,0(sp)
    800014bc:	0141                	addi	sp,sp,16
    800014be:	8082                	ret
    panic("uvmclear");
    800014c0:	00006517          	auipc	a0,0x6
    800014c4:	c8850513          	addi	a0,a0,-888 # 80007148 <etext+0x148>
    800014c8:	b50ff0ef          	jal	80000818 <panic>

00000000800014cc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    800014cc:	cac5                	beqz	a3,8000157c <copyinstr+0xb0>
{
    800014ce:	715d                	addi	sp,sp,-80
    800014d0:	e486                	sd	ra,72(sp)
    800014d2:	e0a2                	sd	s0,64(sp)
    800014d4:	fc26                	sd	s1,56(sp)
    800014d6:	f84a                	sd	s2,48(sp)
    800014d8:	f44e                	sd	s3,40(sp)
    800014da:	f052                	sd	s4,32(sp)
    800014dc:	ec56                	sd	s5,24(sp)
    800014de:	e85a                	sd	s6,16(sp)
    800014e0:	e45e                	sd	s7,8(sp)
    800014e2:	0880                	addi	s0,sp,80
    800014e4:	8aaa                	mv	s5,a0
    800014e6:	84ae                	mv	s1,a1
    800014e8:	8bb2                	mv	s7,a2
    800014ea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800014ec:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800014ee:	6a05                	lui	s4,0x1
    800014f0:	a82d                	j	8000152a <copyinstr+0x5e>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    800014f2:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800014f6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    800014f8:	0017c793          	xori	a5,a5,1
    800014fc:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001500:	60a6                	ld	ra,72(sp)
    80001502:	6406                	ld	s0,64(sp)
    80001504:	74e2                	ld	s1,56(sp)
    80001506:	7942                	ld	s2,48(sp)
    80001508:	79a2                	ld	s3,40(sp)
    8000150a:	7a02                	ld	s4,32(sp)
    8000150c:	6ae2                	ld	s5,24(sp)
    8000150e:	6b42                	ld	s6,16(sp)
    80001510:	6ba2                	ld	s7,8(sp)
    80001512:	6161                	addi	sp,sp,80
    80001514:	8082                	ret
    80001516:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    8000151a:	9726                	add	a4,a4,s1
      --max;
    8000151c:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001520:	01490bb3          	add	s7,s2,s4
  while (got_null == 0 && max > 0) {
    80001524:	04e58463          	beq	a1,a4,8000156c <copyinstr+0xa0>
{
    80001528:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    8000152a:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000152e:	85ca                	mv	a1,s2
    80001530:	8556                	mv	a0,s5
    80001532:	ac9ff0ef          	jal	80000ffa <walkaddr>
    if (pa0 == 0)
    80001536:	cd0d                	beqz	a0,80001570 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001538:	417906b3          	sub	a3,s2,s7
    8000153c:	96d2                	add	a3,a3,s4
    if (n > max)
    8000153e:	00d9f363          	bgeu	s3,a3,80001544 <copyinstr+0x78>
    80001542:	86ce                	mv	a3,s3
    while (n > 0) {
    80001544:	ca85                	beqz	a3,80001574 <copyinstr+0xa8>
    char *p = (char *)(pa0 + (srcva - va0));
    80001546:	01750633          	add	a2,a0,s7
    8000154a:	41260633          	sub	a2,a2,s2
    8000154e:	87a6                	mv	a5,s1
      if (*p == '\0') {
    80001550:	8e05                	sub	a2,a2,s1
    while (n > 0) {
    80001552:	96a6                	add	a3,a3,s1
    80001554:	85be                	mv	a1,a5
      if (*p == '\0') {
    80001556:	00f60733          	add	a4,a2,a5
    8000155a:	00074703          	lbu	a4,0(a4)
    8000155e:	db51                	beqz	a4,800014f2 <copyinstr+0x26>
        *dst = *p;
    80001560:	00e78023          	sb	a4,0(a5)
      dst++;
    80001564:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001566:	fed797e3          	bne	a5,a3,80001554 <copyinstr+0x88>
    8000156a:	b775                	j	80001516 <copyinstr+0x4a>
    8000156c:	4781                	li	a5,0
    8000156e:	b769                	j	800014f8 <copyinstr+0x2c>
      return -1;
    80001570:	557d                	li	a0,-1
    80001572:	b779                	j	80001500 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80001574:	6b85                	lui	s7,0x1
    80001576:	9bca                	add	s7,s7,s2
    80001578:	87a6                	mv	a5,s1
    8000157a:	b77d                	j	80001528 <copyinstr+0x5c>
  int got_null = 0;
    8000157c:	4781                	li	a5,0
  if (got_null) {
    8000157e:	0017c793          	xori	a5,a5,1
    80001582:	40f0053b          	negw	a0,a5
}
    80001586:	8082                	ret

0000000080001588 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001588:	1141                	addi	sp,sp,-16
    8000158a:	e406                	sd	ra,8(sp)
    8000158c:	e022                	sd	s0,0(sp)
    8000158e:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80001590:	4601                	li	a2,0
    80001592:	9cfff0ef          	jal	80000f60 <walk>
  if (pte == 0) {
    80001596:	c119                	beqz	a0,8000159c <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    80001598:	6108                	ld	a0,0(a0)
    8000159a:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    8000159c:	60a2                	ld	ra,8(sp)
    8000159e:	6402                	ld	s0,0(sp)
    800015a0:	0141                	addi	sp,sp,16
    800015a2:	8082                	ret

00000000800015a4 <vmfault>:
{
    800015a4:	7179                	addi	sp,sp,-48
    800015a6:	f406                	sd	ra,40(sp)
    800015a8:	f022                	sd	s0,32(sp)
    800015aa:	e84a                	sd	s2,16(sp)
    800015ac:	e44e                	sd	s3,8(sp)
    800015ae:	1800                	addi	s0,sp,48
    800015b0:	89aa                	mv	s3,a0
    800015b2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015b4:	34e000ef          	jal	80001902 <myproc>
  if (va >= p->sz)
    800015b8:	693c                	ld	a5,80(a0)
    800015ba:	00f96a63          	bltu	s2,a5,800015ce <vmfault+0x2a>
    return 0;
    800015be:	4981                	li	s3,0
}
    800015c0:	854e                	mv	a0,s3
    800015c2:	70a2                	ld	ra,40(sp)
    800015c4:	7402                	ld	s0,32(sp)
    800015c6:	6942                	ld	s2,16(sp)
    800015c8:	69a2                	ld	s3,8(sp)
    800015ca:	6145                	addi	sp,sp,48
    800015cc:	8082                	ret
    800015ce:	ec26                	sd	s1,24(sp)
    800015d0:	e052                	sd	s4,0(sp)
    800015d2:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    800015d4:	77fd                	lui	a5,0xfffff
    800015d6:	00f97a33          	and	s4,s2,a5
  if (ismapped(pagetable, va)) {
    800015da:	85d2                	mv	a1,s4
    800015dc:	854e                	mv	a0,s3
    800015de:	fabff0ef          	jal	80001588 <ismapped>
    return 0;
    800015e2:	4981                	li	s3,0
  if (ismapped(pagetable, va)) {
    800015e4:	c501                	beqz	a0,800015ec <vmfault+0x48>
    800015e6:	64e2                	ld	s1,24(sp)
    800015e8:	6a02                	ld	s4,0(sp)
    800015ea:	bfd9                	j	800015c0 <vmfault+0x1c>
  mem = (uint64)kalloc();
    800015ec:	d34ff0ef          	jal	80000b20 <kalloc>
    800015f0:	892a                	mv	s2,a0
  if (mem == 0)
    800015f2:	c905                	beqz	a0,80001622 <vmfault+0x7e>
  mem = (uint64)kalloc();
    800015f4:	89aa                	mv	s3,a0
  memset((void *)mem, 0, PGSIZE);
    800015f6:	6605                	lui	a2,0x1
    800015f8:	4581                	li	a1,0
    800015fa:	ed2ff0ef          	jal	80000ccc <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    800015fe:	4759                	li	a4,22
    80001600:	86ca                	mv	a3,s2
    80001602:	6605                	lui	a2,0x1
    80001604:	85d2                	mv	a1,s4
    80001606:	6ca8                	ld	a0,88(s1)
    80001608:	a2dff0ef          	jal	80001034 <mappages>
    8000160c:	e501                	bnez	a0,80001614 <vmfault+0x70>
    8000160e:	64e2                	ld	s1,24(sp)
    80001610:	6a02                	ld	s4,0(sp)
    80001612:	b77d                	j	800015c0 <vmfault+0x1c>
    kfree((void *)mem);
    80001614:	854a                	mv	a0,s2
    80001616:	c22ff0ef          	jal	80000a38 <kfree>
    return 0;
    8000161a:	4981                	li	s3,0
    8000161c:	64e2                	ld	s1,24(sp)
    8000161e:	6a02                	ld	s4,0(sp)
    80001620:	b745                	j	800015c0 <vmfault+0x1c>
    80001622:	64e2                	ld	s1,24(sp)
    80001624:	6a02                	ld	s4,0(sp)
    80001626:	bf69                	j	800015c0 <vmfault+0x1c>

0000000080001628 <copyout>:
  while (len > 0) {
    80001628:	cad1                	beqz	a3,800016bc <copyout+0x94>
{
    8000162a:	711d                	addi	sp,sp,-96
    8000162c:	ec86                	sd	ra,88(sp)
    8000162e:	e8a2                	sd	s0,80(sp)
    80001630:	e4a6                	sd	s1,72(sp)
    80001632:	e0ca                	sd	s2,64(sp)
    80001634:	fc4e                	sd	s3,56(sp)
    80001636:	f852                	sd	s4,48(sp)
    80001638:	f456                	sd	s5,40(sp)
    8000163a:	f05a                	sd	s6,32(sp)
    8000163c:	ec5e                	sd	s7,24(sp)
    8000163e:	e862                	sd	s8,16(sp)
    80001640:	e466                	sd	s9,8(sp)
    80001642:	e06a                	sd	s10,0(sp)
    80001644:	1080                	addi	s0,sp,96
    80001646:	8baa                	mv	s7,a0
    80001648:	8a2e                	mv	s4,a1
    8000164a:	8b32                	mv	s6,a2
    8000164c:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    8000164e:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001650:	5cfd                	li	s9,-1
    80001652:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001656:	6c05                	lui	s8,0x1
    80001658:	a005                	j	80001678 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000165a:	409a0533          	sub	a0,s4,s1
    8000165e:	0009061b          	sext.w	a2,s2
    80001662:	85da                	mv	a1,s6
    80001664:	954e                	add	a0,a0,s3
    80001666:	ec6ff0ef          	jal	80000d2c <memmove>
    len -= n;
    8000166a:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000166e:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80001670:	01848a33          	add	s4,s1,s8
  while (len > 0) {
    80001674:	040a8263          	beqz	s5,800016b8 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80001678:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    8000167c:	049ce263          	bltu	s9,s1,800016c0 <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80001680:	85a6                	mv	a1,s1
    80001682:	855e                	mv	a0,s7
    80001684:	977ff0ef          	jal	80000ffa <walkaddr>
    80001688:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    8000168a:	e901                	bnez	a0,8000169a <copyout+0x72>
      if ((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000168c:	4601                	li	a2,0
    8000168e:	85a6                	mv	a1,s1
    80001690:	855e                	mv	a0,s7
    80001692:	f13ff0ef          	jal	800015a4 <vmfault>
    80001696:	89aa                	mv	s3,a0
    80001698:	c139                	beqz	a0,800016de <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    8000169a:	4601                	li	a2,0
    8000169c:	85a6                	mv	a1,s1
    8000169e:	855e                	mv	a0,s7
    800016a0:	8c1ff0ef          	jal	80000f60 <walk>
    if ((*pte & PTE_W) == 0)
    800016a4:	611c                	ld	a5,0(a0)
    800016a6:	8b91                	andi	a5,a5,4
    800016a8:	cf8d                	beqz	a5,800016e2 <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    800016aa:	41448933          	sub	s2,s1,s4
    800016ae:	9962                	add	s2,s2,s8
    if (n > len)
    800016b0:	fb2af5e3          	bgeu	s5,s2,8000165a <copyout+0x32>
    800016b4:	8956                	mv	s2,s5
    800016b6:	b755                	j	8000165a <copyout+0x32>
  return 0;
    800016b8:	4501                	li	a0,0
    800016ba:	a021                	j	800016c2 <copyout+0x9a>
    800016bc:	4501                	li	a0,0
}
    800016be:	8082                	ret
      return -1;
    800016c0:	557d                	li	a0,-1
}
    800016c2:	60e6                	ld	ra,88(sp)
    800016c4:	6446                	ld	s0,80(sp)
    800016c6:	64a6                	ld	s1,72(sp)
    800016c8:	6906                	ld	s2,64(sp)
    800016ca:	79e2                	ld	s3,56(sp)
    800016cc:	7a42                	ld	s4,48(sp)
    800016ce:	7aa2                	ld	s5,40(sp)
    800016d0:	7b02                	ld	s6,32(sp)
    800016d2:	6be2                	ld	s7,24(sp)
    800016d4:	6c42                	ld	s8,16(sp)
    800016d6:	6ca2                	ld	s9,8(sp)
    800016d8:	6d02                	ld	s10,0(sp)
    800016da:	6125                	addi	sp,sp,96
    800016dc:	8082                	ret
        return -1;
    800016de:	557d                	li	a0,-1
    800016e0:	b7cd                	j	800016c2 <copyout+0x9a>
      return -1;
    800016e2:	557d                	li	a0,-1
    800016e4:	bff9                	j	800016c2 <copyout+0x9a>

00000000800016e6 <copyin>:
  while (len > 0) {
    800016e6:	c6c9                	beqz	a3,80001770 <copyin+0x8a>
{
    800016e8:	715d                	addi	sp,sp,-80
    800016ea:	e486                	sd	ra,72(sp)
    800016ec:	e0a2                	sd	s0,64(sp)
    800016ee:	fc26                	sd	s1,56(sp)
    800016f0:	f84a                	sd	s2,48(sp)
    800016f2:	f44e                	sd	s3,40(sp)
    800016f4:	f052                	sd	s4,32(sp)
    800016f6:	ec56                	sd	s5,24(sp)
    800016f8:	e85a                	sd	s6,16(sp)
    800016fa:	e45e                	sd	s7,8(sp)
    800016fc:	e062                	sd	s8,0(sp)
    800016fe:	0880                	addi	s0,sp,80
    80001700:	8baa                	mv	s7,a0
    80001702:	8aae                	mv	s5,a1
    80001704:	8932                	mv	s2,a2
    80001706:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001708:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    8000170a:	6b05                	lui	s6,0x1
    8000170c:	a035                	j	80001738 <copyin+0x52>
    8000170e:	412984b3          	sub	s1,s3,s2
    80001712:	94da                	add	s1,s1,s6
    if (n > len)
    80001714:	009a7363          	bgeu	s4,s1,8000171a <copyin+0x34>
    80001718:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8000171a:	413905b3          	sub	a1,s2,s3
    8000171e:	0004861b          	sext.w	a2,s1
    80001722:	95aa                	add	a1,a1,a0
    80001724:	8556                	mv	a0,s5
    80001726:	e06ff0ef          	jal	80000d2c <memmove>
    len -= n;
    8000172a:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000172e:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001730:	01698933          	add	s2,s3,s6
  while (len > 0) {
    80001734:	020a0163          	beqz	s4,80001756 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001738:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    8000173c:	85ce                	mv	a1,s3
    8000173e:	855e                	mv	a0,s7
    80001740:	8bbff0ef          	jal	80000ffa <walkaddr>
    if (pa0 == 0) {
    80001744:	f569                	bnez	a0,8000170e <copyin+0x28>
      if ((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001746:	4601                	li	a2,0
    80001748:	85ce                	mv	a1,s3
    8000174a:	855e                	mv	a0,s7
    8000174c:	e59ff0ef          	jal	800015a4 <vmfault>
    80001750:	fd5d                	bnez	a0,8000170e <copyin+0x28>
        return -1;
    80001752:	557d                	li	a0,-1
    80001754:	a011                	j	80001758 <copyin+0x72>
  return 0;
    80001756:	4501                	li	a0,0
}
    80001758:	60a6                	ld	ra,72(sp)
    8000175a:	6406                	ld	s0,64(sp)
    8000175c:	74e2                	ld	s1,56(sp)
    8000175e:	7942                	ld	s2,48(sp)
    80001760:	79a2                	ld	s3,40(sp)
    80001762:	7a02                	ld	s4,32(sp)
    80001764:	6ae2                	ld	s5,24(sp)
    80001766:	6b42                	ld	s6,16(sp)
    80001768:	6ba2                	ld	s7,8(sp)
    8000176a:	6c02                	ld	s8,0(sp)
    8000176c:	6161                	addi	sp,sp,80
    8000176e:	8082                	ret
  return 0;
    80001770:	4501                	li	a0,0
}
    80001772:	8082                	ret

0000000080001774 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001774:	715d                	addi	sp,sp,-80
    80001776:	e486                	sd	ra,72(sp)
    80001778:	e0a2                	sd	s0,64(sp)
    8000177a:	fc26                	sd	s1,56(sp)
    8000177c:	f84a                	sd	s2,48(sp)
    8000177e:	f44e                	sd	s3,40(sp)
    80001780:	f052                	sd	s4,32(sp)
    80001782:	ec56                	sd	s5,24(sp)
    80001784:	e85a                	sd	s6,16(sp)
    80001786:	e45e                	sd	s7,8(sp)
    80001788:	e062                	sd	s8,0(sp)
    8000178a:	0880                	addi	s0,sp,80
    8000178c:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000178e:	0000e497          	auipc	s1,0xe
    80001792:	60a48493          	addi	s1,s1,1546 # 8000fd98 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001796:	8c26                	mv	s8,s1
    80001798:	ff4df937          	lui	s2,0xff4df
    8000179c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bdc45>
    800017a0:	0936                	slli	s2,s2,0xd
    800017a2:	6f590913          	addi	s2,s2,1781
    800017a6:	0936                	slli	s2,s2,0xd
    800017a8:	bd390913          	addi	s2,s2,-1069
    800017ac:	0932                	slli	s2,s2,0xc
    800017ae:	7a790913          	addi	s2,s2,1959
    800017b2:	040009b7          	lui	s3,0x4000
    800017b6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017b8:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017ba:	4b99                	li	s7,6
    800017bc:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017be:	00014a97          	auipc	s5,0x14
    800017c2:	1daa8a93          	addi	s5,s5,474 # 80015998 <tickslock>
    char *pa = kalloc();
    800017c6:	b5aff0ef          	jal	80000b20 <kalloc>
    800017ca:	862a                	mv	a2,a0
    if (pa == 0)
    800017cc:	c121                	beqz	a0,8000180c <proc_mapstacks+0x98>
    uint64 va = KSTACK((int)(p - proc));
    800017ce:	418485b3          	sub	a1,s1,s8
    800017d2:	8591                	srai	a1,a1,0x4
    800017d4:	032585b3          	mul	a1,a1,s2
    800017d8:	05b6                	slli	a1,a1,0xd
    800017da:	6789                	lui	a5,0x2
    800017dc:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017de:	875e                	mv	a4,s7
    800017e0:	86da                	mv	a3,s6
    800017e2:	40b985b3          	sub	a1,s3,a1
    800017e6:	8552                	mv	a0,s4
    800017e8:	903ff0ef          	jal	800010ea <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017ec:	17048493          	addi	s1,s1,368
    800017f0:	fd549be3          	bne	s1,s5,800017c6 <proc_mapstacks+0x52>
  }
}
    800017f4:	60a6                	ld	ra,72(sp)
    800017f6:	6406                	ld	s0,64(sp)
    800017f8:	74e2                	ld	s1,56(sp)
    800017fa:	7942                	ld	s2,48(sp)
    800017fc:	79a2                	ld	s3,40(sp)
    800017fe:	7a02                	ld	s4,32(sp)
    80001800:	6ae2                	ld	s5,24(sp)
    80001802:	6b42                	ld	s6,16(sp)
    80001804:	6ba2                	ld	s7,8(sp)
    80001806:	6c02                	ld	s8,0(sp)
    80001808:	6161                	addi	sp,sp,80
    8000180a:	8082                	ret
      panic("kalloc");
    8000180c:	00006517          	auipc	a0,0x6
    80001810:	94c50513          	addi	a0,a0,-1716 # 80007158 <etext+0x158>
    80001814:	804ff0ef          	jal	80000818 <panic>

0000000080001818 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001818:	7139                	addi	sp,sp,-64
    8000181a:	fc06                	sd	ra,56(sp)
    8000181c:	f822                	sd	s0,48(sp)
    8000181e:	f426                	sd	s1,40(sp)
    80001820:	f04a                	sd	s2,32(sp)
    80001822:	ec4e                	sd	s3,24(sp)
    80001824:	e852                	sd	s4,16(sp)
    80001826:	e456                	sd	s5,8(sp)
    80001828:	e05a                	sd	s6,0(sp)
    8000182a:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000182c:	00006597          	auipc	a1,0x6
    80001830:	93458593          	addi	a1,a1,-1740 # 80007160 <etext+0x160>
    80001834:	0000e517          	auipc	a0,0xe
    80001838:	13450513          	addi	a0,a0,308 # 8000f968 <pid_lock>
    8000183c:	b3eff0ef          	jal	80000b7a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001840:	00006597          	auipc	a1,0x6
    80001844:	92858593          	addi	a1,a1,-1752 # 80007168 <etext+0x168>
    80001848:	0000e517          	auipc	a0,0xe
    8000184c:	13850513          	addi	a0,a0,312 # 8000f980 <wait_lock>
    80001850:	b2aff0ef          	jal	80000b7a <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001854:	0000e497          	auipc	s1,0xe
    80001858:	54448493          	addi	s1,s1,1348 # 8000fd98 <proc>
    initlock(&p->lock, "proc");
    8000185c:	00006b17          	auipc	s6,0x6
    80001860:	91cb0b13          	addi	s6,s6,-1764 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001864:	8aa6                	mv	s5,s1
    80001866:	ff4df937          	lui	s2,0xff4df
    8000186a:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bdc45>
    8000186e:	0936                	slli	s2,s2,0xd
    80001870:	6f590913          	addi	s2,s2,1781
    80001874:	0936                	slli	s2,s2,0xd
    80001876:	bd390913          	addi	s2,s2,-1069
    8000187a:	0932                	slli	s2,s2,0xc
    8000187c:	7a790913          	addi	s2,s2,1959
    80001880:	040009b7          	lui	s3,0x4000
    80001884:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001886:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001888:	00014a17          	auipc	s4,0x14
    8000188c:	110a0a13          	addi	s4,s4,272 # 80015998 <tickslock>
    initlock(&p->lock, "proc");
    80001890:	85da                	mv	a1,s6
    80001892:	8526                	mv	a0,s1
    80001894:	ae6ff0ef          	jal	80000b7a <initlock>
    p->state = UNUSED;
    80001898:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000189c:	415487b3          	sub	a5,s1,s5
    800018a0:	8791                	srai	a5,a5,0x4
    800018a2:	032787b3          	mul	a5,a5,s2
    800018a6:	07b6                	slli	a5,a5,0xd
    800018a8:	6709                	lui	a4,0x2
    800018aa:	9fb9                	addw	a5,a5,a4
    800018ac:	40f987b3          	sub	a5,s3,a5
    800018b0:	e4bc                	sd	a5,72(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    800018b2:	17048493          	addi	s1,s1,368
    800018b6:	fd449de3          	bne	s1,s4,80001890 <procinit+0x78>
  }
}
    800018ba:	70e2                	ld	ra,56(sp)
    800018bc:	7442                	ld	s0,48(sp)
    800018be:	74a2                	ld	s1,40(sp)
    800018c0:	7902                	ld	s2,32(sp)
    800018c2:	69e2                	ld	s3,24(sp)
    800018c4:	6a42                	ld	s4,16(sp)
    800018c6:	6aa2                	ld	s5,8(sp)
    800018c8:	6b02                	ld	s6,0(sp)
    800018ca:	6121                	addi	sp,sp,64
    800018cc:	8082                	ret

00000000800018ce <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018ce:	1141                	addi	sp,sp,-16
    800018d0:	e406                	sd	ra,8(sp)
    800018d2:	e022                	sd	s0,0(sp)
    800018d4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018d6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018d8:	2501                	sext.w	a0,a0
    800018da:	60a2                	ld	ra,8(sp)
    800018dc:	6402                	ld	s0,0(sp)
    800018de:	0141                	addi	sp,sp,16
    800018e0:	8082                	ret

00000000800018e2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800018e2:	1141                	addi	sp,sp,-16
    800018e4:	e406                	sd	ra,8(sp)
    800018e6:	e022                	sd	s0,0(sp)
    800018e8:	0800                	addi	s0,sp,16
    800018ea:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
  return c;
}
    800018f0:	0000e517          	auipc	a0,0xe
    800018f4:	0a850513          	addi	a0,a0,168 # 8000f998 <cpus>
    800018f8:	953e                	add	a0,a0,a5
    800018fa:	60a2                	ld	ra,8(sp)
    800018fc:	6402                	ld	s0,0(sp)
    800018fe:	0141                	addi	sp,sp,16
    80001900:	8082                	ret

0000000080001902 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001902:	1101                	addi	sp,sp,-32
    80001904:	ec06                	sd	ra,24(sp)
    80001906:	e822                	sd	s0,16(sp)
    80001908:	e426                	sd	s1,8(sp)
    8000190a:	1000                	addi	s0,sp,32
  push_off();
    8000190c:	ab4ff0ef          	jal	80000bc0 <push_off>
    80001910:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001912:	2781                	sext.w	a5,a5
    80001914:	079e                	slli	a5,a5,0x7
    80001916:	0000e717          	auipc	a4,0xe
    8000191a:	05270713          	addi	a4,a4,82 # 8000f968 <pid_lock>
    8000191e:	97ba                	add	a5,a5,a4
    80001920:	7b9c                	ld	a5,48(a5)
    80001922:	84be                	mv	s1,a5
  pop_off();
    80001924:	b20ff0ef          	jal	80000c44 <pop_off>
  return p;
}
    80001928:	8526                	mv	a0,s1
    8000192a:	60e2                	ld	ra,24(sp)
    8000192c:	6442                	ld	s0,16(sp)
    8000192e:	64a2                	ld	s1,8(sp)
    80001930:	6105                	addi	sp,sp,32
    80001932:	8082                	ret

0000000080001934 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001934:	7179                	addi	sp,sp,-48
    80001936:	f406                	sd	ra,40(sp)
    80001938:	f022                	sd	s0,32(sp)
    8000193a:	ec26                	sd	s1,24(sp)
    8000193c:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000193e:	fc5ff0ef          	jal	80001902 <myproc>
    80001942:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001944:	b50ff0ef          	jal	80000c94 <release>

  if (first) {
    80001948:	00006797          	auipc	a5,0x6
    8000194c:	ee87a783          	lw	a5,-280(a5) # 80007830 <first.1>
    80001950:	cf95                	beqz	a5,8000198c <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001952:	4505                	li	a0,1
    80001954:	531010ef          	jal	80003684 <fsinit>

    first = 0;
    80001958:	00006797          	auipc	a5,0x6
    8000195c:	ec07ac23          	sw	zero,-296(a5) # 80007830 <first.1>
    // ensure other cores see first=0.
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80001960:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001964:	00006797          	auipc	a5,0x6
    80001968:	81c78793          	addi	a5,a5,-2020 # 80007180 <etext+0x180>
    8000196c:	fcf43823          	sd	a5,-48(s0)
    80001970:	fc043c23          	sd	zero,-40(s0)
    80001974:	fd040593          	addi	a1,s0,-48
    80001978:	853e                	mv	a0,a5
    8000197a:	693020ef          	jal	8000480c <kexec>
    8000197e:	70bc                	ld	a5,96(s1)
    80001980:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001982:	70bc                	ld	a5,96(s1)
    80001984:	7bb8                	ld	a4,112(a5)
    80001986:	57fd                	li	a5,-1
    80001988:	02f70d63          	beq	a4,a5,800019c2 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    8000198c:	2dd000ef          	jal	80002468 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001990:	6ca8                	ld	a0,88(s1)
    80001992:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001994:	04000737          	lui	a4,0x4000
    80001998:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000199a:	0732                	slli	a4,a4,0xc
    8000199c:	00004797          	auipc	a5,0x4
    800019a0:	70078793          	addi	a5,a5,1792 # 8000609c <userret>
    800019a4:	00004697          	auipc	a3,0x4
    800019a8:	65c68693          	addi	a3,a3,1628 # 80006000 <_trampoline>
    800019ac:	8f95                	sub	a5,a5,a3
    800019ae:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800019b0:	577d                	li	a4,-1
    800019b2:	177e                	slli	a4,a4,0x3f
    800019b4:	8d59                	or	a0,a0,a4
    800019b6:	9782                	jalr	a5
}
    800019b8:	70a2                	ld	ra,40(sp)
    800019ba:	7402                	ld	s0,32(sp)
    800019bc:	64e2                	ld	s1,24(sp)
    800019be:	6145                	addi	sp,sp,48
    800019c0:	8082                	ret
      panic("exec");
    800019c2:	00005517          	auipc	a0,0x5
    800019c6:	7c650513          	addi	a0,a0,1990 # 80007188 <etext+0x188>
    800019ca:	e4ffe0ef          	jal	80000818 <panic>

00000000800019ce <allocpid>:
{
    800019ce:	1101                	addi	sp,sp,-32
    800019d0:	ec06                	sd	ra,24(sp)
    800019d2:	e822                	sd	s0,16(sp)
    800019d4:	e426                	sd	s1,8(sp)
    800019d6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019d8:	0000e517          	auipc	a0,0xe
    800019dc:	f9050513          	addi	a0,a0,-112 # 8000f968 <pid_lock>
    800019e0:	a24ff0ef          	jal	80000c04 <acquire>
  pid = nextpid;
    800019e4:	00006797          	auipc	a5,0x6
    800019e8:	e5078793          	addi	a5,a5,-432 # 80007834 <nextpid>
    800019ec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019ee:	0014871b          	addiw	a4,s1,1
    800019f2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019f4:	0000e517          	auipc	a0,0xe
    800019f8:	f7450513          	addi	a0,a0,-140 # 8000f968 <pid_lock>
    800019fc:	a98ff0ef          	jal	80000c94 <release>
}
    80001a00:	8526                	mv	a0,s1
    80001a02:	60e2                	ld	ra,24(sp)
    80001a04:	6442                	ld	s0,16(sp)
    80001a06:	64a2                	ld	s1,8(sp)
    80001a08:	6105                	addi	sp,sp,32
    80001a0a:	8082                	ret

0000000080001a0c <proc_pagetable>:
{
    80001a0c:	1101                	addi	sp,sp,-32
    80001a0e:	ec06                	sd	ra,24(sp)
    80001a10:	e822                	sd	s0,16(sp)
    80001a12:	e426                	sd	s1,8(sp)
    80001a14:	e04a                	sd	s2,0(sp)
    80001a16:	1000                	addi	s0,sp,32
    80001a18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a1a:	fc2ff0ef          	jal	800011dc <uvmcreate>
    80001a1e:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a20:	cd05                	beqz	a0,80001a58 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001a22:	4729                	li	a4,10
    80001a24:	00004697          	auipc	a3,0x4
    80001a28:	5dc68693          	addi	a3,a3,1500 # 80006000 <_trampoline>
    80001a2c:	6605                	lui	a2,0x1
    80001a2e:	040005b7          	lui	a1,0x4000
    80001a32:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a34:	05b2                	slli	a1,a1,0xc
    80001a36:	dfeff0ef          	jal	80001034 <mappages>
    80001a3a:	02054663          	bltz	a0,80001a66 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a3e:	4719                	li	a4,6
    80001a40:	06093683          	ld	a3,96(s2)
    80001a44:	6605                	lui	a2,0x1
    80001a46:	020005b7          	lui	a1,0x2000
    80001a4a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a4c:	05b6                	slli	a1,a1,0xd
    80001a4e:	8526                	mv	a0,s1
    80001a50:	de4ff0ef          	jal	80001034 <mappages>
    80001a54:	00054f63          	bltz	a0,80001a72 <proc_pagetable+0x66>
}
    80001a58:	8526                	mv	a0,s1
    80001a5a:	60e2                	ld	ra,24(sp)
    80001a5c:	6442                	ld	s0,16(sp)
    80001a5e:	64a2                	ld	s1,8(sp)
    80001a60:	6902                	ld	s2,0(sp)
    80001a62:	6105                	addi	sp,sp,32
    80001a64:	8082                	ret
    uvmfree(pagetable, 0);
    80001a66:	4581                	li	a1,0
    80001a68:	8526                	mv	a0,s1
    80001a6a:	96dff0ef          	jal	800013d6 <uvmfree>
    return 0;
    80001a6e:	4481                	li	s1,0
    80001a70:	b7e5                	j	80001a58 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a72:	4681                	li	a3,0
    80001a74:	4605                	li	a2,1
    80001a76:	040005b7          	lui	a1,0x4000
    80001a7a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a7c:	05b2                	slli	a1,a1,0xc
    80001a7e:	8526                	mv	a0,s1
    80001a80:	f82ff0ef          	jal	80001202 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a84:	4581                	li	a1,0
    80001a86:	8526                	mv	a0,s1
    80001a88:	94fff0ef          	jal	800013d6 <uvmfree>
    return 0;
    80001a8c:	4481                	li	s1,0
    80001a8e:	b7e9                	j	80001a58 <proc_pagetable+0x4c>

0000000080001a90 <proc_freepagetable>:
{
    80001a90:	1101                	addi	sp,sp,-32
    80001a92:	ec06                	sd	ra,24(sp)
    80001a94:	e822                	sd	s0,16(sp)
    80001a96:	e426                	sd	s1,8(sp)
    80001a98:	e04a                	sd	s2,0(sp)
    80001a9a:	1000                	addi	s0,sp,32
    80001a9c:	84aa                	mv	s1,a0
    80001a9e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aa0:	4681                	li	a3,0
    80001aa2:	4605                	li	a2,1
    80001aa4:	040005b7          	lui	a1,0x4000
    80001aa8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001aaa:	05b2                	slli	a1,a1,0xc
    80001aac:	f56ff0ef          	jal	80001202 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ab0:	4681                	li	a3,0
    80001ab2:	4605                	li	a2,1
    80001ab4:	020005b7          	lui	a1,0x2000
    80001ab8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001aba:	05b6                	slli	a1,a1,0xd
    80001abc:	8526                	mv	a0,s1
    80001abe:	f44ff0ef          	jal	80001202 <uvmunmap>
  uvmfree(pagetable, sz);
    80001ac2:	85ca                	mv	a1,s2
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	911ff0ef          	jal	800013d6 <uvmfree>
}
    80001aca:	60e2                	ld	ra,24(sp)
    80001acc:	6442                	ld	s0,16(sp)
    80001ace:	64a2                	ld	s1,8(sp)
    80001ad0:	6902                	ld	s2,0(sp)
    80001ad2:	6105                	addi	sp,sp,32
    80001ad4:	8082                	ret

0000000080001ad6 <freeproc>:
{
    80001ad6:	1101                	addi	sp,sp,-32
    80001ad8:	ec06                	sd	ra,24(sp)
    80001ada:	e822                	sd	s0,16(sp)
    80001adc:	e426                	sd	s1,8(sp)
    80001ade:	1000                	addi	s0,sp,32
    80001ae0:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001ae2:	7128                	ld	a0,96(a0)
    80001ae4:	c119                	beqz	a0,80001aea <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001ae6:	f53fe0ef          	jal	80000a38 <kfree>
  p->trapframe = 0;
    80001aea:	0604b023          	sd	zero,96(s1)
  if (p->pagetable)
    80001aee:	6ca8                	ld	a0,88(s1)
    80001af0:	c501                	beqz	a0,80001af8 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001af2:	68ac                	ld	a1,80(s1)
    80001af4:	f9dff0ef          	jal	80001a90 <proc_freepagetable>
  p->pagetable = 0;
    80001af8:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001afc:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001b00:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001b04:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001b08:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001b0c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b10:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b14:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b18:	0004ac23          	sw	zero,24(s1)
}
    80001b1c:	60e2                	ld	ra,24(sp)
    80001b1e:	6442                	ld	s0,16(sp)
    80001b20:	64a2                	ld	s1,8(sp)
    80001b22:	6105                	addi	sp,sp,32
    80001b24:	8082                	ret

0000000080001b26 <allocproc>:
{
    80001b26:	1101                	addi	sp,sp,-32
    80001b28:	ec06                	sd	ra,24(sp)
    80001b2a:	e822                	sd	s0,16(sp)
    80001b2c:	e426                	sd	s1,8(sp)
    80001b2e:	e04a                	sd	s2,0(sp)
    80001b30:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b32:	0000e497          	auipc	s1,0xe
    80001b36:	26648493          	addi	s1,s1,614 # 8000fd98 <proc>
    80001b3a:	00014917          	auipc	s2,0x14
    80001b3e:	e5e90913          	addi	s2,s2,-418 # 80015998 <tickslock>
    acquire(&p->lock);
    80001b42:	8526                	mv	a0,s1
    80001b44:	8c0ff0ef          	jal	80000c04 <acquire>
    if (p->state == UNUSED) {
    80001b48:	4c9c                	lw	a5,24(s1)
    80001b4a:	cb91                	beqz	a5,80001b5e <allocproc+0x38>
      release(&p->lock);
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	946ff0ef          	jal	80000c94 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b52:	17048493          	addi	s1,s1,368
    80001b56:	ff2496e3          	bne	s1,s2,80001b42 <allocproc+0x1c>
  return 0;
    80001b5a:	4481                	li	s1,0
    80001b5c:	a0a9                	j	80001ba6 <allocproc+0x80>
  p->pid = allocpid();
    80001b5e:	e71ff0ef          	jal	800019ce <allocpid>
    80001b62:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001b64:	4785                	li	a5,1
    80001b66:	cc9c                	sw	a5,24(s1)
  p->priority = 0;     //lane 
    80001b68:	0204a823          	sw	zero,48(s1)
  p->ticks_used = 0;    // Stopwatch 
    80001b6c:	0204aa23          	sw	zero,52(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b70:	fb1fe0ef          	jal	80000b20 <kalloc>
    80001b74:	892a                	mv	s2,a0
    80001b76:	f0a8                	sd	a0,96(s1)
    80001b78:	cd15                	beqz	a0,80001bb4 <allocproc+0x8e>
  p->pagetable = proc_pagetable(p);
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	e91ff0ef          	jal	80001a0c <proc_pagetable>
    80001b80:	892a                	mv	s2,a0
    80001b82:	eca8                	sd	a0,88(s1)
  if (p->pagetable == 0) {
    80001b84:	c121                	beqz	a0,80001bc4 <allocproc+0x9e>
  memset(&p->context, 0, sizeof(p->context));
    80001b86:	07000613          	li	a2,112
    80001b8a:	4581                	li	a1,0
    80001b8c:	06848513          	addi	a0,s1,104
    80001b90:	93cff0ef          	jal	80000ccc <memset>
  p->context.ra = (uint64)forkret;
    80001b94:	00000797          	auipc	a5,0x0
    80001b98:	da078793          	addi	a5,a5,-608 # 80001934 <forkret>
    80001b9c:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b9e:	64bc                	ld	a5,72(s1)
    80001ba0:	6705                	lui	a4,0x1
    80001ba2:	97ba                	add	a5,a5,a4
    80001ba4:	f8bc                	sd	a5,112(s1)
}
    80001ba6:	8526                	mv	a0,s1
    80001ba8:	60e2                	ld	ra,24(sp)
    80001baa:	6442                	ld	s0,16(sp)
    80001bac:	64a2                	ld	s1,8(sp)
    80001bae:	6902                	ld	s2,0(sp)
    80001bb0:	6105                	addi	sp,sp,32
    80001bb2:	8082                	ret
    freeproc(p);
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	f21ff0ef          	jal	80001ad6 <freeproc>
    release(&p->lock);
    80001bba:	8526                	mv	a0,s1
    80001bbc:	8d8ff0ef          	jal	80000c94 <release>
    return 0;
    80001bc0:	84ca                	mv	s1,s2
    80001bc2:	b7d5                	j	80001ba6 <allocproc+0x80>
    freeproc(p);
    80001bc4:	8526                	mv	a0,s1
    80001bc6:	f11ff0ef          	jal	80001ad6 <freeproc>
    release(&p->lock);
    80001bca:	8526                	mv	a0,s1
    80001bcc:	8c8ff0ef          	jal	80000c94 <release>
    return 0;
    80001bd0:	84ca                	mv	s1,s2
    80001bd2:	bfd1                	j	80001ba6 <allocproc+0x80>

0000000080001bd4 <userinit>:
{
    80001bd4:	1101                	addi	sp,sp,-32
    80001bd6:	ec06                	sd	ra,24(sp)
    80001bd8:	e822                	sd	s0,16(sp)
    80001bda:	e426                	sd	s1,8(sp)
    80001bdc:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bde:	f49ff0ef          	jal	80001b26 <allocproc>
    80001be2:	84aa                	mv	s1,a0
  initproc = p;
    80001be4:	00006797          	auipc	a5,0x6
    80001be8:	c6a7be23          	sd	a0,-900(a5) # 80007860 <initproc>
  p->cwd = namei("/");
    80001bec:	00005517          	auipc	a0,0x5
    80001bf0:	5a450513          	addi	a0,a0,1444 # 80007190 <etext+0x190>
    80001bf4:	7cb010ef          	jal	80003bbe <namei>
    80001bf8:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001bfc:	478d                	li	a5,3
    80001bfe:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c00:	8526                	mv	a0,s1
    80001c02:	892ff0ef          	jal	80000c94 <release>
}
    80001c06:	60e2                	ld	ra,24(sp)
    80001c08:	6442                	ld	s0,16(sp)
    80001c0a:	64a2                	ld	s1,8(sp)
    80001c0c:	6105                	addi	sp,sp,32
    80001c0e:	8082                	ret

0000000080001c10 <growproc>:
{
    80001c10:	1101                	addi	sp,sp,-32
    80001c12:	ec06                	sd	ra,24(sp)
    80001c14:	e822                	sd	s0,16(sp)
    80001c16:	e426                	sd	s1,8(sp)
    80001c18:	e04a                	sd	s2,0(sp)
    80001c1a:	1000                	addi	s0,sp,32
    80001c1c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c1e:	ce5ff0ef          	jal	80001902 <myproc>
    80001c22:	892a                	mv	s2,a0
  sz = p->sz;
    80001c24:	692c                	ld	a1,80(a0)
  if (n > 0) {
    80001c26:	02905963          	blez	s1,80001c58 <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    80001c2a:	00b48633          	add	a2,s1,a1
    80001c2e:	020007b7          	lui	a5,0x2000
    80001c32:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c34:	07b6                	slli	a5,a5,0xd
    80001c36:	02c7ea63          	bltu	a5,a2,80001c6a <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c3a:	4691                	li	a3,4
    80001c3c:	6d28                	ld	a0,88(a0)
    80001c3e:	e92ff0ef          	jal	800012d0 <uvmalloc>
    80001c42:	85aa                	mv	a1,a0
    80001c44:	c50d                	beqz	a0,80001c6e <growproc+0x5e>
  p->sz = sz;
    80001c46:	04b93823          	sd	a1,80(s2)
  return 0;
    80001c4a:	4501                	li	a0,0
}
    80001c4c:	60e2                	ld	ra,24(sp)
    80001c4e:	6442                	ld	s0,16(sp)
    80001c50:	64a2                	ld	s1,8(sp)
    80001c52:	6902                	ld	s2,0(sp)
    80001c54:	6105                	addi	sp,sp,32
    80001c56:	8082                	ret
  } else if (n < 0) {
    80001c58:	fe04d7e3          	bgez	s1,80001c46 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c5c:	00b48633          	add	a2,s1,a1
    80001c60:	6d28                	ld	a0,88(a0)
    80001c62:	e2aff0ef          	jal	8000128c <uvmdealloc>
    80001c66:	85aa                	mv	a1,a0
    80001c68:	bff9                	j	80001c46 <growproc+0x36>
      return -1;
    80001c6a:	557d                	li	a0,-1
    80001c6c:	b7c5                	j	80001c4c <growproc+0x3c>
      return -1;
    80001c6e:	557d                	li	a0,-1
    80001c70:	bff1                	j	80001c4c <growproc+0x3c>

0000000080001c72 <kfork>:
{
    80001c72:	7139                	addi	sp,sp,-64
    80001c74:	fc06                	sd	ra,56(sp)
    80001c76:	f822                	sd	s0,48(sp)
    80001c78:	f426                	sd	s1,40(sp)
    80001c7a:	e456                	sd	s5,8(sp)
    80001c7c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c7e:	c85ff0ef          	jal	80001902 <myproc>
    80001c82:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c84:	ea3ff0ef          	jal	80001b26 <allocproc>
    80001c88:	0e050a63          	beqz	a0,80001d7c <kfork+0x10a>
    80001c8c:	e852                	sd	s4,16(sp)
    80001c8e:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c90:	050ab603          	ld	a2,80(s5)
    80001c94:	6d2c                	ld	a1,88(a0)
    80001c96:	058ab503          	ld	a0,88(s5)
    80001c9a:	f6eff0ef          	jal	80001408 <uvmcopy>
    80001c9e:	04054863          	bltz	a0,80001cee <kfork+0x7c>
    80001ca2:	f04a                	sd	s2,32(sp)
    80001ca4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001ca6:	050ab783          	ld	a5,80(s5)
    80001caa:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    80001cae:	060ab683          	ld	a3,96(s5)
    80001cb2:	87b6                	mv	a5,a3
    80001cb4:	060a3703          	ld	a4,96(s4)
    80001cb8:	12068693          	addi	a3,a3,288
    80001cbc:	6388                	ld	a0,0(a5)
    80001cbe:	678c                	ld	a1,8(a5)
    80001cc0:	6b90                	ld	a2,16(a5)
    80001cc2:	e308                	sd	a0,0(a4)
    80001cc4:	e70c                	sd	a1,8(a4)
    80001cc6:	eb10                	sd	a2,16(a4)
    80001cc8:	6f90                	ld	a2,24(a5)
    80001cca:	ef10                	sd	a2,24(a4)
    80001ccc:	02078793          	addi	a5,a5,32
    80001cd0:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001cd4:	fed794e3          	bne	a5,a3,80001cbc <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001cd8:	060a3783          	ld	a5,96(s4)
    80001cdc:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001ce0:	0d8a8493          	addi	s1,s5,216
    80001ce4:	0d8a0913          	addi	s2,s4,216
    80001ce8:	158a8993          	addi	s3,s5,344
    80001cec:	a831                	j	80001d08 <kfork+0x96>
    freeproc(np);
    80001cee:	8552                	mv	a0,s4
    80001cf0:	de7ff0ef          	jal	80001ad6 <freeproc>
    release(&np->lock);
    80001cf4:	8552                	mv	a0,s4
    80001cf6:	f9ffe0ef          	jal	80000c94 <release>
    return -1;
    80001cfa:	54fd                	li	s1,-1
    80001cfc:	6a42                	ld	s4,16(sp)
    80001cfe:	a885                	j	80001d6e <kfork+0xfc>
  for (i = 0; i < NOFILE; i++)
    80001d00:	04a1                	addi	s1,s1,8
    80001d02:	0921                	addi	s2,s2,8
    80001d04:	01348963          	beq	s1,s3,80001d16 <kfork+0xa4>
    if (p->ofile[i])
    80001d08:	6088                	ld	a0,0(s1)
    80001d0a:	d97d                	beqz	a0,80001d00 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d0c:	46e020ef          	jal	8000417a <filedup>
    80001d10:	00a93023          	sd	a0,0(s2)
    80001d14:	b7f5                	j	80001d00 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001d16:	158ab503          	ld	a0,344(s5)
    80001d1a:	640010ef          	jal	8000335a <idup>
    80001d1e:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d22:	4641                	li	a2,16
    80001d24:	160a8593          	addi	a1,s5,352
    80001d28:	160a0513          	addi	a0,s4,352
    80001d2c:	8f4ff0ef          	jal	80000e20 <safestrcpy>
  pid = np->pid;
    80001d30:	038a2483          	lw	s1,56(s4)
  release(&np->lock);
    80001d34:	8552                	mv	a0,s4
    80001d36:	f5ffe0ef          	jal	80000c94 <release>
  acquire(&wait_lock);
    80001d3a:	0000e517          	auipc	a0,0xe
    80001d3e:	c4650513          	addi	a0,a0,-954 # 8000f980 <wait_lock>
    80001d42:	ec3fe0ef          	jal	80000c04 <acquire>
  np->parent = p;
    80001d46:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001d4a:	0000e517          	auipc	a0,0xe
    80001d4e:	c3650513          	addi	a0,a0,-970 # 8000f980 <wait_lock>
    80001d52:	f43fe0ef          	jal	80000c94 <release>
  acquire(&np->lock);
    80001d56:	8552                	mv	a0,s4
    80001d58:	eadfe0ef          	jal	80000c04 <acquire>
  np->state = RUNNABLE;
    80001d5c:	478d                	li	a5,3
    80001d5e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001d62:	8552                	mv	a0,s4
    80001d64:	f31fe0ef          	jal	80000c94 <release>
  return pid;
    80001d68:	7902                	ld	s2,32(sp)
    80001d6a:	69e2                	ld	s3,24(sp)
    80001d6c:	6a42                	ld	s4,16(sp)
}
    80001d6e:	8526                	mv	a0,s1
    80001d70:	70e2                	ld	ra,56(sp)
    80001d72:	7442                	ld	s0,48(sp)
    80001d74:	74a2                	ld	s1,40(sp)
    80001d76:	6aa2                	ld	s5,8(sp)
    80001d78:	6121                	addi	sp,sp,64
    80001d7a:	8082                	ret
    return -1;
    80001d7c:	54fd                	li	s1,-1
    80001d7e:	bfc5                	j	80001d6e <kfork+0xfc>

0000000080001d80 <scheduler>:
{
    80001d80:	715d                	addi	sp,sp,-80
    80001d82:	e486                	sd	ra,72(sp)
    80001d84:	e0a2                	sd	s0,64(sp)
    80001d86:	fc26                	sd	s1,56(sp)
    80001d88:	f84a                	sd	s2,48(sp)
    80001d8a:	f44e                	sd	s3,40(sp)
    80001d8c:	f052                	sd	s4,32(sp)
    80001d8e:	ec56                	sd	s5,24(sp)
    80001d90:	e85a                	sd	s6,16(sp)
    80001d92:	e45e                	sd	s7,8(sp)
    80001d94:	0880                	addi	s0,sp,80
    80001d96:	8792                	mv	a5,tp
  int id = r_tp();
    80001d98:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d9a:	00779b93          	slli	s7,a5,0x7
    80001d9e:	0000e717          	auipc	a4,0xe
    80001da2:	bca70713          	addi	a4,a4,-1078 # 8000f968 <pid_lock>
    80001da6:	975e                	add	a4,a4,s7
    80001da8:	02073823          	sd	zero,48(a4)
          swtch(&c->context, &p->context);
    80001dac:	0000e717          	auipc	a4,0xe
    80001db0:	bf470713          	addi	a4,a4,-1036 # 8000f9a0 <cpus+0x8>
    80001db4:	9bba                	add	s7,s7,a4
        if (p->state == RUNNABLE && p->priority == priority) {
    80001db6:	490d                	li	s2,3
      for (p = proc; p < &proc[NPROC]; p++) {
    80001db8:	00014997          	auipc	s3,0x14
    80001dbc:	be098993          	addi	s3,s3,-1056 # 80015998 <tickslock>
          c->proc = p;
    80001dc0:	079e                	slli	a5,a5,0x7
    80001dc2:	0000ea97          	auipc	s5,0xe
    80001dc6:	ba6a8a93          	addi	s5,s5,-1114 # 8000f968 <pid_lock>
    80001dca:	9abe                	add	s5,s5,a5
    80001dcc:	a895                	j	80001e40 <scheduler+0xc0>
        release(&p->lock);
    80001dce:	8526                	mv	a0,s1
    80001dd0:	ec5fe0ef          	jal	80000c94 <release>
      for (p = proc; p < &proc[NPROC]; p++) {
    80001dd4:	17048493          	addi	s1,s1,368
    80001dd8:	05348a63          	beq	s1,s3,80001e2c <scheduler+0xac>
        acquire(&p->lock);
    80001ddc:	8526                	mv	a0,s1
    80001dde:	e27fe0ef          	jal	80000c04 <acquire>
        if (p->state == RUNNABLE && p->priority == priority) {
    80001de2:	4c9c                	lw	a5,24(s1)
    80001de4:	ff2795e3          	bne	a5,s2,80001dce <scheduler+0x4e>
    80001de8:	589c                	lw	a5,48(s1)
    80001dea:	ff4792e3          	bne	a5,s4,80001dce <scheduler+0x4e>
          p->state = RUNNING;
    80001dee:	0164ac23          	sw	s6,24(s1)
          c->proc = p;
    80001df2:	029ab823          	sd	s1,48(s5)
          swtch(&c->context, &p->context);
    80001df6:	06848593          	addi	a1,s1,104
    80001dfa:	855e                	mv	a0,s7
    80001dfc:	5c2000ef          	jal	800023be <swtch>
          c->proc = 0;
    80001e00:	020ab823          	sd	zero,48(s5)
          release(&p->lock);
    80001e04:	8526                	mv	a0,s1
    80001e06:	e8ffe0ef          	jal	80000c94 <release>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e0a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e0e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e12:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e16:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e1a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e1c:	10079073          	csrw	sstatus,a5
    for (int priority = 0; priority < 3; priority++){ //Check which lane is to be used 0 be the 1st prioroty     
    80001e20:	4a01                	li	s4,0
      for (p = proc; p < &proc[NPROC]; p++) {
    80001e22:	0000e497          	auipc	s1,0xe
    80001e26:	f7648493          	addi	s1,s1,-138 # 8000fd98 <proc>
    80001e2a:	bf4d                	j	80001ddc <scheduler+0x5c>
    for (int priority = 0; priority < 3; priority++){ //Check which lane is to be used 0 be the 1st prioroty     
    80001e2c:	2a05                	addiw	s4,s4,1
    80001e2e:	ff2a1ae3          	bne	s4,s2,80001e22 <scheduler+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e32:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001e36:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80001e38:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e3c:	10500073          	wfi
          p->state = RUNNING;
    80001e40:	4b11                	li	s6,4
    80001e42:	b7e1                	j	80001e0a <scheduler+0x8a>

0000000080001e44 <sched>:
{
    80001e44:	7179                	addi	sp,sp,-48
    80001e46:	f406                	sd	ra,40(sp)
    80001e48:	f022                	sd	s0,32(sp)
    80001e4a:	ec26                	sd	s1,24(sp)
    80001e4c:	e84a                	sd	s2,16(sp)
    80001e4e:	e44e                	sd	s3,8(sp)
    80001e50:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e52:	ab1ff0ef          	jal	80001902 <myproc>
    80001e56:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e58:	d3dfe0ef          	jal	80000b94 <holding>
    80001e5c:	c935                	beqz	a0,80001ed0 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e5e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e60:	2781                	sext.w	a5,a5
    80001e62:	079e                	slli	a5,a5,0x7
    80001e64:	0000e717          	auipc	a4,0xe
    80001e68:	b0470713          	addi	a4,a4,-1276 # 8000f968 <pid_lock>
    80001e6c:	97ba                	add	a5,a5,a4
    80001e6e:	0a87a703          	lw	a4,168(a5)
    80001e72:	4785                	li	a5,1
    80001e74:	06f71463          	bne	a4,a5,80001edc <sched+0x98>
  if (p->state == RUNNING)
    80001e78:	4c98                	lw	a4,24(s1)
    80001e7a:	4791                	li	a5,4
    80001e7c:	06f70663          	beq	a4,a5,80001ee8 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e80:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e84:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e86:	e7bd                	bnez	a5,80001ef4 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e88:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e8a:	0000e917          	auipc	s2,0xe
    80001e8e:	ade90913          	addi	s2,s2,-1314 # 8000f968 <pid_lock>
    80001e92:	2781                	sext.w	a5,a5
    80001e94:	079e                	slli	a5,a5,0x7
    80001e96:	97ca                	add	a5,a5,s2
    80001e98:	0ac7a983          	lw	s3,172(a5)
    80001e9c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e9e:	2781                	sext.w	a5,a5
    80001ea0:	079e                	slli	a5,a5,0x7
    80001ea2:	07a1                	addi	a5,a5,8
    80001ea4:	0000e597          	auipc	a1,0xe
    80001ea8:	af458593          	addi	a1,a1,-1292 # 8000f998 <cpus>
    80001eac:	95be                	add	a1,a1,a5
    80001eae:	06848513          	addi	a0,s1,104
    80001eb2:	50c000ef          	jal	800023be <swtch>
    80001eb6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001eb8:	2781                	sext.w	a5,a5
    80001eba:	079e                	slli	a5,a5,0x7
    80001ebc:	993e                	add	s2,s2,a5
    80001ebe:	0b392623          	sw	s3,172(s2)
}
    80001ec2:	70a2                	ld	ra,40(sp)
    80001ec4:	7402                	ld	s0,32(sp)
    80001ec6:	64e2                	ld	s1,24(sp)
    80001ec8:	6942                	ld	s2,16(sp)
    80001eca:	69a2                	ld	s3,8(sp)
    80001ecc:	6145                	addi	sp,sp,48
    80001ece:	8082                	ret
    panic("sched p->lock");
    80001ed0:	00005517          	auipc	a0,0x5
    80001ed4:	2c850513          	addi	a0,a0,712 # 80007198 <etext+0x198>
    80001ed8:	941fe0ef          	jal	80000818 <panic>
    panic("sched locks");
    80001edc:	00005517          	auipc	a0,0x5
    80001ee0:	2cc50513          	addi	a0,a0,716 # 800071a8 <etext+0x1a8>
    80001ee4:	935fe0ef          	jal	80000818 <panic>
    panic("sched RUNNING");
    80001ee8:	00005517          	auipc	a0,0x5
    80001eec:	2d050513          	addi	a0,a0,720 # 800071b8 <etext+0x1b8>
    80001ef0:	929fe0ef          	jal	80000818 <panic>
    panic("sched interruptible");
    80001ef4:	00005517          	auipc	a0,0x5
    80001ef8:	2d450513          	addi	a0,a0,724 # 800071c8 <etext+0x1c8>
    80001efc:	91dfe0ef          	jal	80000818 <panic>

0000000080001f00 <yield>:
{
    80001f00:	1101                	addi	sp,sp,-32
    80001f02:	ec06                	sd	ra,24(sp)
    80001f04:	e822                	sd	s0,16(sp)
    80001f06:	e426                	sd	s1,8(sp)
    80001f08:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f0a:	9f9ff0ef          	jal	80001902 <myproc>
    80001f0e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f10:	cf5fe0ef          	jal	80000c04 <acquire>
  p->state = RUNNABLE;
    80001f14:	478d                	li	a5,3
    80001f16:	cc9c                	sw	a5,24(s1)
  sched();
    80001f18:	f2dff0ef          	jal	80001e44 <sched>
  release(&p->lock);
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	d77fe0ef          	jal	80000c94 <release>
}
    80001f22:	60e2                	ld	ra,24(sp)
    80001f24:	6442                	ld	s0,16(sp)
    80001f26:	64a2                	ld	s1,8(sp)
    80001f28:	6105                	addi	sp,sp,32
    80001f2a:	8082                	ret

0000000080001f2c <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f2c:	7179                	addi	sp,sp,-48
    80001f2e:	f406                	sd	ra,40(sp)
    80001f30:	f022                	sd	s0,32(sp)
    80001f32:	ec26                	sd	s1,24(sp)
    80001f34:	e84a                	sd	s2,16(sp)
    80001f36:	e44e                	sd	s3,8(sp)
    80001f38:	1800                	addi	s0,sp,48
    80001f3a:	89aa                	mv	s3,a0
    80001f3c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f3e:	9c5ff0ef          	jal	80001902 <myproc>
    80001f42:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); //DOC: sleeplock1
    80001f44:	cc1fe0ef          	jal	80000c04 <acquire>
  release(lk);
    80001f48:	854a                	mv	a0,s2
    80001f4a:	d4bfe0ef          	jal	80000c94 <release>

  // Go to sleep.
  p->chan = chan;
    80001f4e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f52:	4789                	li	a5,2
    80001f54:	cc9c                	sw	a5,24(s1)

  sched();
    80001f56:	eefff0ef          	jal	80001e44 <sched>

  // Tidy up.
  p->chan = 0;
    80001f5a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	d35fe0ef          	jal	80000c94 <release>
  acquire(lk);
    80001f64:	854a                	mv	a0,s2
    80001f66:	c9ffe0ef          	jal	80000c04 <acquire>
}
    80001f6a:	70a2                	ld	ra,40(sp)
    80001f6c:	7402                	ld	s0,32(sp)
    80001f6e:	64e2                	ld	s1,24(sp)
    80001f70:	6942                	ld	s2,16(sp)
    80001f72:	69a2                	ld	s3,8(sp)
    80001f74:	6145                	addi	sp,sp,48
    80001f76:	8082                	ret

0000000080001f78 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f78:	7139                	addi	sp,sp,-64
    80001f7a:	fc06                	sd	ra,56(sp)
    80001f7c:	f822                	sd	s0,48(sp)
    80001f7e:	f426                	sd	s1,40(sp)
    80001f80:	f04a                	sd	s2,32(sp)
    80001f82:	ec4e                	sd	s3,24(sp)
    80001f84:	e852                	sd	s4,16(sp)
    80001f86:	e456                	sd	s5,8(sp)
    80001f88:	0080                	addi	s0,sp,64
    80001f8a:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001f8c:	0000e497          	auipc	s1,0xe
    80001f90:	e0c48493          	addi	s1,s1,-500 # 8000fd98 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001f94:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f96:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f98:	00014917          	auipc	s2,0x14
    80001f9c:	a0090913          	addi	s2,s2,-1536 # 80015998 <tickslock>
    80001fa0:	a801                	j	80001fb0 <wakeup+0x38>
      }
      release(&p->lock);
    80001fa2:	8526                	mv	a0,s1
    80001fa4:	cf1fe0ef          	jal	80000c94 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fa8:	17048493          	addi	s1,s1,368
    80001fac:	03248263          	beq	s1,s2,80001fd0 <wakeup+0x58>
    if (p != myproc()) {
    80001fb0:	953ff0ef          	jal	80001902 <myproc>
    80001fb4:	fe950ae3          	beq	a0,s1,80001fa8 <wakeup+0x30>
      acquire(&p->lock);
    80001fb8:	8526                	mv	a0,s1
    80001fba:	c4bfe0ef          	jal	80000c04 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    80001fbe:	4c9c                	lw	a5,24(s1)
    80001fc0:	ff3791e3          	bne	a5,s3,80001fa2 <wakeup+0x2a>
    80001fc4:	709c                	ld	a5,32(s1)
    80001fc6:	fd479ee3          	bne	a5,s4,80001fa2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001fca:	0154ac23          	sw	s5,24(s1)
    80001fce:	bfd1                	j	80001fa2 <wakeup+0x2a>
    }
  }
}
    80001fd0:	70e2                	ld	ra,56(sp)
    80001fd2:	7442                	ld	s0,48(sp)
    80001fd4:	74a2                	ld	s1,40(sp)
    80001fd6:	7902                	ld	s2,32(sp)
    80001fd8:	69e2                	ld	s3,24(sp)
    80001fda:	6a42                	ld	s4,16(sp)
    80001fdc:	6aa2                	ld	s5,8(sp)
    80001fde:	6121                	addi	sp,sp,64
    80001fe0:	8082                	ret

0000000080001fe2 <reparent>:
{
    80001fe2:	7179                	addi	sp,sp,-48
    80001fe4:	f406                	sd	ra,40(sp)
    80001fe6:	f022                	sd	s0,32(sp)
    80001fe8:	ec26                	sd	s1,24(sp)
    80001fea:	e84a                	sd	s2,16(sp)
    80001fec:	e44e                	sd	s3,8(sp)
    80001fee:	e052                	sd	s4,0(sp)
    80001ff0:	1800                	addi	s0,sp,48
    80001ff2:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001ff4:	0000e497          	auipc	s1,0xe
    80001ff8:	da448493          	addi	s1,s1,-604 # 8000fd98 <proc>
      pp->parent = initproc;
    80001ffc:	00006a17          	auipc	s4,0x6
    80002000:	864a0a13          	addi	s4,s4,-1948 # 80007860 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002004:	00014997          	auipc	s3,0x14
    80002008:	99498993          	addi	s3,s3,-1644 # 80015998 <tickslock>
    8000200c:	a029                	j	80002016 <reparent+0x34>
    8000200e:	17048493          	addi	s1,s1,368
    80002012:	01348b63          	beq	s1,s3,80002028 <reparent+0x46>
    if (pp->parent == p) {
    80002016:	60bc                	ld	a5,64(s1)
    80002018:	ff279be3          	bne	a5,s2,8000200e <reparent+0x2c>
      pp->parent = initproc;
    8000201c:	000a3503          	ld	a0,0(s4)
    80002020:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80002022:	f57ff0ef          	jal	80001f78 <wakeup>
    80002026:	b7e5                	j	8000200e <reparent+0x2c>
}
    80002028:	70a2                	ld	ra,40(sp)
    8000202a:	7402                	ld	s0,32(sp)
    8000202c:	64e2                	ld	s1,24(sp)
    8000202e:	6942                	ld	s2,16(sp)
    80002030:	69a2                	ld	s3,8(sp)
    80002032:	6a02                	ld	s4,0(sp)
    80002034:	6145                	addi	sp,sp,48
    80002036:	8082                	ret

0000000080002038 <kexit>:
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	e052                	sd	s4,0(sp)
    80002046:	1800                	addi	s0,sp,48
    80002048:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000204a:	8b9ff0ef          	jal	80001902 <myproc>
    8000204e:	89aa                	mv	s3,a0
  if (p == initproc)
    80002050:	00006797          	auipc	a5,0x6
    80002054:	8107b783          	ld	a5,-2032(a5) # 80007860 <initproc>
    80002058:	0d850493          	addi	s1,a0,216
    8000205c:	15850913          	addi	s2,a0,344
    80002060:	00a79b63          	bne	a5,a0,80002076 <kexit+0x3e>
    panic("init exiting");
    80002064:	00005517          	auipc	a0,0x5
    80002068:	17c50513          	addi	a0,a0,380 # 800071e0 <etext+0x1e0>
    8000206c:	facfe0ef          	jal	80000818 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    80002070:	04a1                	addi	s1,s1,8
    80002072:	01248963          	beq	s1,s2,80002084 <kexit+0x4c>
    if (p->ofile[fd]) {
    80002076:	6088                	ld	a0,0(s1)
    80002078:	dd65                	beqz	a0,80002070 <kexit+0x38>
      fileclose(f);
    8000207a:	146020ef          	jal	800041c0 <fileclose>
      p->ofile[fd] = 0;
    8000207e:	0004b023          	sd	zero,0(s1)
    80002082:	b7fd                	j	80002070 <kexit+0x38>
  begin_op();
    80002084:	519010ef          	jal	80003d9c <begin_op>
  iput(p->cwd);
    80002088:	1589b503          	ld	a0,344(s3)
    8000208c:	486010ef          	jal	80003512 <iput>
  end_op();
    80002090:	57d010ef          	jal	80003e0c <end_op>
  p->cwd = 0;
    80002094:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80002098:	0000e517          	auipc	a0,0xe
    8000209c:	8e850513          	addi	a0,a0,-1816 # 8000f980 <wait_lock>
    800020a0:	b65fe0ef          	jal	80000c04 <acquire>
  reparent(p);
    800020a4:	854e                	mv	a0,s3
    800020a6:	f3dff0ef          	jal	80001fe2 <reparent>
  wakeup(p->parent);
    800020aa:	0409b503          	ld	a0,64(s3)
    800020ae:	ecbff0ef          	jal	80001f78 <wakeup>
  acquire(&p->lock);
    800020b2:	854e                	mv	a0,s3
    800020b4:	b51fe0ef          	jal	80000c04 <acquire>
  p->xstate = status;
    800020b8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800020bc:	4795                	li	a5,5
    800020be:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800020c2:	0000e517          	auipc	a0,0xe
    800020c6:	8be50513          	addi	a0,a0,-1858 # 8000f980 <wait_lock>
    800020ca:	bcbfe0ef          	jal	80000c94 <release>
  sched();
    800020ce:	d77ff0ef          	jal	80001e44 <sched>
  panic("zombie exit");
    800020d2:	00005517          	auipc	a0,0x5
    800020d6:	11e50513          	addi	a0,a0,286 # 800071f0 <etext+0x1f0>
    800020da:	f3efe0ef          	jal	80000818 <panic>

00000000800020de <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020de:	7179                	addi	sp,sp,-48
    800020e0:	f406                	sd	ra,40(sp)
    800020e2:	f022                	sd	s0,32(sp)
    800020e4:	ec26                	sd	s1,24(sp)
    800020e6:	e84a                	sd	s2,16(sp)
    800020e8:	e44e                	sd	s3,8(sp)
    800020ea:	1800                	addi	s0,sp,48
    800020ec:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800020ee:	0000e497          	auipc	s1,0xe
    800020f2:	caa48493          	addi	s1,s1,-854 # 8000fd98 <proc>
    800020f6:	00014997          	auipc	s3,0x14
    800020fa:	8a298993          	addi	s3,s3,-1886 # 80015998 <tickslock>
    acquire(&p->lock);
    800020fe:	8526                	mv	a0,s1
    80002100:	b05fe0ef          	jal	80000c04 <acquire>
    if (p->pid == pid) {
    80002104:	5c9c                	lw	a5,56(s1)
    80002106:	01278b63          	beq	a5,s2,8000211c <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	b89fe0ef          	jal	80000c94 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002110:	17048493          	addi	s1,s1,368
    80002114:	ff3495e3          	bne	s1,s3,800020fe <kkill+0x20>
  }
  return -1;
    80002118:	557d                	li	a0,-1
    8000211a:	a819                	j	80002130 <kkill+0x52>
      p->killed = 1;
    8000211c:	4785                	li	a5,1
    8000211e:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80002120:	4c98                	lw	a4,24(s1)
    80002122:	4789                	li	a5,2
    80002124:	00f70d63          	beq	a4,a5,8000213e <kkill+0x60>
      release(&p->lock);
    80002128:	8526                	mv	a0,s1
    8000212a:	b6bfe0ef          	jal	80000c94 <release>
      return 0;
    8000212e:	4501                	li	a0,0
}
    80002130:	70a2                	ld	ra,40(sp)
    80002132:	7402                	ld	s0,32(sp)
    80002134:	64e2                	ld	s1,24(sp)
    80002136:	6942                	ld	s2,16(sp)
    80002138:	69a2                	ld	s3,8(sp)
    8000213a:	6145                	addi	sp,sp,48
    8000213c:	8082                	ret
        p->state = RUNNABLE;
    8000213e:	478d                	li	a5,3
    80002140:	cc9c                	sw	a5,24(s1)
    80002142:	b7dd                	j	80002128 <kkill+0x4a>

0000000080002144 <setkilled>:

void
setkilled(struct proc *p)
{
    80002144:	1101                	addi	sp,sp,-32
    80002146:	ec06                	sd	ra,24(sp)
    80002148:	e822                	sd	s0,16(sp)
    8000214a:	e426                	sd	s1,8(sp)
    8000214c:	1000                	addi	s0,sp,32
    8000214e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002150:	ab5fe0ef          	jal	80000c04 <acquire>
  p->killed = 1;
    80002154:	4785                	li	a5,1
    80002156:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002158:	8526                	mv	a0,s1
    8000215a:	b3bfe0ef          	jal	80000c94 <release>
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6105                	addi	sp,sp,32
    80002166:	8082                	ret

0000000080002168 <killed>:

int
killed(struct proc *p)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	e426                	sd	s1,8(sp)
    80002170:	e04a                	sd	s2,0(sp)
    80002172:	1000                	addi	s0,sp,32
    80002174:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002176:	a8ffe0ef          	jal	80000c04 <acquire>
  k = p->killed;
    8000217a:	549c                	lw	a5,40(s1)
    8000217c:	893e                	mv	s2,a5
  release(&p->lock);
    8000217e:	8526                	mv	a0,s1
    80002180:	b15fe0ef          	jal	80000c94 <release>
  return k;
}
    80002184:	854a                	mv	a0,s2
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	64a2                	ld	s1,8(sp)
    8000218c:	6902                	ld	s2,0(sp)
    8000218e:	6105                	addi	sp,sp,32
    80002190:	8082                	ret

0000000080002192 <kwait>:
{
    80002192:	715d                	addi	sp,sp,-80
    80002194:	e486                	sd	ra,72(sp)
    80002196:	e0a2                	sd	s0,64(sp)
    80002198:	fc26                	sd	s1,56(sp)
    8000219a:	f84a                	sd	s2,48(sp)
    8000219c:	f44e                	sd	s3,40(sp)
    8000219e:	f052                	sd	s4,32(sp)
    800021a0:	ec56                	sd	s5,24(sp)
    800021a2:	e85a                	sd	s6,16(sp)
    800021a4:	e45e                	sd	s7,8(sp)
    800021a6:	0880                	addi	s0,sp,80
    800021a8:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800021aa:	f58ff0ef          	jal	80001902 <myproc>
    800021ae:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800021b0:	0000d517          	auipc	a0,0xd
    800021b4:	7d050513          	addi	a0,a0,2000 # 8000f980 <wait_lock>
    800021b8:	a4dfe0ef          	jal	80000c04 <acquire>
        if (pp->state == ZOMBIE) {
    800021bc:	4a15                	li	s4,5
        havekids = 1;
    800021be:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800021c0:	00013997          	auipc	s3,0x13
    800021c4:	7d898993          	addi	s3,s3,2008 # 80015998 <tickslock>
    sleep(p, &wait_lock); //DOC: wait-sleep
    800021c8:	0000db17          	auipc	s6,0xd
    800021cc:	7b8b0b13          	addi	s6,s6,1976 # 8000f980 <wait_lock>
    800021d0:	a869                	j	8000226a <kwait+0xd8>
          pid = pp->pid;
    800021d2:	0384a983          	lw	s3,56(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800021d6:	000b8c63          	beqz	s7,800021ee <kwait+0x5c>
    800021da:	4691                	li	a3,4
    800021dc:	02c48613          	addi	a2,s1,44
    800021e0:	85de                	mv	a1,s7
    800021e2:	05893503          	ld	a0,88(s2)
    800021e6:	c42ff0ef          	jal	80001628 <copyout>
    800021ea:	02054a63          	bltz	a0,8000221e <kwait+0x8c>
          freeproc(pp);
    800021ee:	8526                	mv	a0,s1
    800021f0:	8e7ff0ef          	jal	80001ad6 <freeproc>
          release(&pp->lock);
    800021f4:	8526                	mv	a0,s1
    800021f6:	a9ffe0ef          	jal	80000c94 <release>
          release(&wait_lock);
    800021fa:	0000d517          	auipc	a0,0xd
    800021fe:	78650513          	addi	a0,a0,1926 # 8000f980 <wait_lock>
    80002202:	a93fe0ef          	jal	80000c94 <release>
}
    80002206:	854e                	mv	a0,s3
    80002208:	60a6                	ld	ra,72(sp)
    8000220a:	6406                	ld	s0,64(sp)
    8000220c:	74e2                	ld	s1,56(sp)
    8000220e:	7942                	ld	s2,48(sp)
    80002210:	79a2                	ld	s3,40(sp)
    80002212:	7a02                	ld	s4,32(sp)
    80002214:	6ae2                	ld	s5,24(sp)
    80002216:	6b42                	ld	s6,16(sp)
    80002218:	6ba2                	ld	s7,8(sp)
    8000221a:	6161                	addi	sp,sp,80
    8000221c:	8082                	ret
            release(&pp->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	a75fe0ef          	jal	80000c94 <release>
            release(&wait_lock);
    80002224:	0000d517          	auipc	a0,0xd
    80002228:	75c50513          	addi	a0,a0,1884 # 8000f980 <wait_lock>
    8000222c:	a69fe0ef          	jal	80000c94 <release>
            return -1;
    80002230:	59fd                	li	s3,-1
    80002232:	bfd1                	j	80002206 <kwait+0x74>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002234:	17048493          	addi	s1,s1,368
    80002238:	03348063          	beq	s1,s3,80002258 <kwait+0xc6>
      if (pp->parent == p) {
    8000223c:	60bc                	ld	a5,64(s1)
    8000223e:	ff279be3          	bne	a5,s2,80002234 <kwait+0xa2>
        acquire(&pp->lock);
    80002242:	8526                	mv	a0,s1
    80002244:	9c1fe0ef          	jal	80000c04 <acquire>
        if (pp->state == ZOMBIE) {
    80002248:	4c9c                	lw	a5,24(s1)
    8000224a:	f94784e3          	beq	a5,s4,800021d2 <kwait+0x40>
        release(&pp->lock);
    8000224e:	8526                	mv	a0,s1
    80002250:	a45fe0ef          	jal	80000c94 <release>
        havekids = 1;
    80002254:	8756                	mv	a4,s5
    80002256:	bff9                	j	80002234 <kwait+0xa2>
    if (!havekids || killed(p)) {
    80002258:	cf19                	beqz	a4,80002276 <kwait+0xe4>
    8000225a:	854a                	mv	a0,s2
    8000225c:	f0dff0ef          	jal	80002168 <killed>
    80002260:	e919                	bnez	a0,80002276 <kwait+0xe4>
    sleep(p, &wait_lock); //DOC: wait-sleep
    80002262:	85da                	mv	a1,s6
    80002264:	854a                	mv	a0,s2
    80002266:	cc7ff0ef          	jal	80001f2c <sleep>
    havekids = 0;
    8000226a:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000226c:	0000e497          	auipc	s1,0xe
    80002270:	b2c48493          	addi	s1,s1,-1236 # 8000fd98 <proc>
    80002274:	b7e1                	j	8000223c <kwait+0xaa>
      release(&wait_lock);
    80002276:	0000d517          	auipc	a0,0xd
    8000227a:	70a50513          	addi	a0,a0,1802 # 8000f980 <wait_lock>
    8000227e:	a17fe0ef          	jal	80000c94 <release>
      return -1;
    80002282:	59fd                	li	s3,-1
    80002284:	b749                	j	80002206 <kwait+0x74>

0000000080002286 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002286:	7179                	addi	sp,sp,-48
    80002288:	f406                	sd	ra,40(sp)
    8000228a:	f022                	sd	s0,32(sp)
    8000228c:	ec26                	sd	s1,24(sp)
    8000228e:	e84a                	sd	s2,16(sp)
    80002290:	e44e                	sd	s3,8(sp)
    80002292:	e052                	sd	s4,0(sp)
    80002294:	1800                	addi	s0,sp,48
    80002296:	84aa                	mv	s1,a0
    80002298:	8a2e                	mv	s4,a1
    8000229a:	89b2                	mv	s3,a2
    8000229c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000229e:	e64ff0ef          	jal	80001902 <myproc>
  if (user_dst) {
    800022a2:	cc99                	beqz	s1,800022c0 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800022a4:	86ca                	mv	a3,s2
    800022a6:	864e                	mv	a2,s3
    800022a8:	85d2                	mv	a1,s4
    800022aa:	6d28                	ld	a0,88(a0)
    800022ac:	b7cff0ef          	jal	80001628 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800022b0:	70a2                	ld	ra,40(sp)
    800022b2:	7402                	ld	s0,32(sp)
    800022b4:	64e2                	ld	s1,24(sp)
    800022b6:	6942                	ld	s2,16(sp)
    800022b8:	69a2                	ld	s3,8(sp)
    800022ba:	6a02                	ld	s4,0(sp)
    800022bc:	6145                	addi	sp,sp,48
    800022be:	8082                	ret
    memmove((char *)dst, src, len);
    800022c0:	0009061b          	sext.w	a2,s2
    800022c4:	85ce                	mv	a1,s3
    800022c6:	8552                	mv	a0,s4
    800022c8:	a65fe0ef          	jal	80000d2c <memmove>
    return 0;
    800022cc:	8526                	mv	a0,s1
    800022ce:	b7cd                	j	800022b0 <either_copyout+0x2a>

00000000800022d0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022d0:	7179                	addi	sp,sp,-48
    800022d2:	f406                	sd	ra,40(sp)
    800022d4:	f022                	sd	s0,32(sp)
    800022d6:	ec26                	sd	s1,24(sp)
    800022d8:	e84a                	sd	s2,16(sp)
    800022da:	e44e                	sd	s3,8(sp)
    800022dc:	e052                	sd	s4,0(sp)
    800022de:	1800                	addi	s0,sp,48
    800022e0:	8a2a                	mv	s4,a0
    800022e2:	84ae                	mv	s1,a1
    800022e4:	89b2                	mv	s3,a2
    800022e6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022e8:	e1aff0ef          	jal	80001902 <myproc>
  if (user_src) {
    800022ec:	cc99                	beqz	s1,8000230a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800022ee:	86ca                	mv	a3,s2
    800022f0:	864e                	mv	a2,s3
    800022f2:	85d2                	mv	a1,s4
    800022f4:	6d28                	ld	a0,88(a0)
    800022f6:	bf0ff0ef          	jal	800016e6 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800022fa:	70a2                	ld	ra,40(sp)
    800022fc:	7402                	ld	s0,32(sp)
    800022fe:	64e2                	ld	s1,24(sp)
    80002300:	6942                	ld	s2,16(sp)
    80002302:	69a2                	ld	s3,8(sp)
    80002304:	6a02                	ld	s4,0(sp)
    80002306:	6145                	addi	sp,sp,48
    80002308:	8082                	ret
    memmove(dst, (char *)src, len);
    8000230a:	0009061b          	sext.w	a2,s2
    8000230e:	85ce                	mv	a1,s3
    80002310:	8552                	mv	a0,s4
    80002312:	a1bfe0ef          	jal	80000d2c <memmove>
    return 0;
    80002316:	8526                	mv	a0,s1
    80002318:	b7cd                	j	800022fa <either_copyin+0x2a>

000000008000231a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000231a:	715d                	addi	sp,sp,-80
    8000231c:	e486                	sd	ra,72(sp)
    8000231e:	e0a2                	sd	s0,64(sp)
    80002320:	fc26                	sd	s1,56(sp)
    80002322:	f84a                	sd	s2,48(sp)
    80002324:	f44e                	sd	s3,40(sp)
    80002326:	f052                	sd	s4,32(sp)
    80002328:	ec56                	sd	s5,24(sp)
    8000232a:	e85a                	sd	s6,16(sp)
    8000232c:	e45e                	sd	s7,8(sp)
    8000232e:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    80002330:	00005517          	auipc	a0,0x5
    80002334:	d4850513          	addi	a0,a0,-696 # 80007078 <etext+0x78>
    80002338:	9b6fe0ef          	jal	800004ee <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000233c:	0000e497          	auipc	s1,0xe
    80002340:	bbc48493          	addi	s1,s1,-1092 # 8000fef8 <proc+0x160>
    80002344:	00013917          	auipc	s2,0x13
    80002348:	7b490913          	addi	s2,s2,1972 # 80015af8 <bcache+0x148>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000234c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000234e:	00005997          	auipc	s3,0x5
    80002352:	eb298993          	addi	s3,s3,-334 # 80007200 <etext+0x200>
    printk("%d %s %s", p->pid, state, p->name);
    80002356:	00005a97          	auipc	s5,0x5
    8000235a:	eb2a8a93          	addi	s5,s5,-334 # 80007208 <etext+0x208>
    printk("\n");
    8000235e:	00005a17          	auipc	s4,0x5
    80002362:	d1aa0a13          	addi	s4,s4,-742 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002366:	00005b97          	auipc	s7,0x5
    8000236a:	3c2b8b93          	addi	s7,s7,962 # 80007728 <states.0>
    8000236e:	a829                	j	80002388 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    80002370:	ed86a583          	lw	a1,-296(a3)
    80002374:	8556                	mv	a0,s5
    80002376:	978fe0ef          	jal	800004ee <printk>
    printk("\n");
    8000237a:	8552                	mv	a0,s4
    8000237c:	972fe0ef          	jal	800004ee <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002380:	17048493          	addi	s1,s1,368
    80002384:	03248263          	beq	s1,s2,800023a8 <procdump+0x8e>
    if (p->state == UNUSED)
    80002388:	86a6                	mv	a3,s1
    8000238a:	eb84a783          	lw	a5,-328(s1)
    8000238e:	dbed                	beqz	a5,80002380 <procdump+0x66>
      state = "???";
    80002390:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002392:	fcfb6fe3          	bltu	s6,a5,80002370 <procdump+0x56>
    80002396:	02079713          	slli	a4,a5,0x20
    8000239a:	01d75793          	srli	a5,a4,0x1d
    8000239e:	97de                	add	a5,a5,s7
    800023a0:	6390                	ld	a2,0(a5)
    800023a2:	f679                	bnez	a2,80002370 <procdump+0x56>
      state = "???";
    800023a4:	864e                	mv	a2,s3
    800023a6:	b7e9                	j	80002370 <procdump+0x56>
  }
}
    800023a8:	60a6                	ld	ra,72(sp)
    800023aa:	6406                	ld	s0,64(sp)
    800023ac:	74e2                	ld	s1,56(sp)
    800023ae:	7942                	ld	s2,48(sp)
    800023b0:	79a2                	ld	s3,40(sp)
    800023b2:	7a02                	ld	s4,32(sp)
    800023b4:	6ae2                	ld	s5,24(sp)
    800023b6:	6b42                	ld	s6,16(sp)
    800023b8:	6ba2                	ld	s7,8(sp)
    800023ba:	6161                	addi	sp,sp,80
    800023bc:	8082                	ret

00000000800023be <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023be:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023c2:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023c6:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023c8:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023ca:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023ce:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023d2:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023d6:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023da:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023de:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023e2:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800023e6:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800023ea:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800023ee:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800023f2:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800023f6:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023fa:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800023fc:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023fe:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002402:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002406:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000240a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000240e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002412:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002416:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000241a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000241e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002422:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002426:	8082                	ret

0000000080002428 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002428:	1141                	addi	sp,sp,-16
    8000242a:	e406                	sd	ra,8(sp)
    8000242c:	e022                	sd	s0,0(sp)
    8000242e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002430:	00005597          	auipc	a1,0x5
    80002434:	e1858593          	addi	a1,a1,-488 # 80007248 <etext+0x248>
    80002438:	00013517          	auipc	a0,0x13
    8000243c:	56050513          	addi	a0,a0,1376 # 80015998 <tickslock>
    80002440:	f3afe0ef          	jal	80000b7a <initlock>
}
    80002444:	60a2                	ld	ra,8(sp)
    80002446:	6402                	ld	s0,0(sp)
    80002448:	0141                	addi	sp,sp,16
    8000244a:	8082                	ret

000000008000244c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000244c:	1141                	addi	sp,sp,-16
    8000244e:	e406                	sd	ra,8(sp)
    80002450:	e022                	sd	s0,0(sp)
    80002452:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002454:	00003797          	auipc	a5,0x3
    80002458:	12c78793          	addi	a5,a5,300 # 80005580 <kernelvec>
    8000245c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002460:	60a2                	ld	ra,8(sp)
    80002462:	6402                	ld	s0,0(sp)
    80002464:	0141                	addi	sp,sp,16
    80002466:	8082                	ret

0000000080002468 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002468:	1141                	addi	sp,sp,-16
    8000246a:	e406                	sd	ra,8(sp)
    8000246c:	e022                	sd	s0,0(sp)
    8000246e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002470:	c92ff0ef          	jal	80001902 <myproc>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002474:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002478:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000247a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000247e:	04000737          	lui	a4,0x4000
    80002482:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002484:	0732                	slli	a4,a4,0xc
    80002486:	00004797          	auipc	a5,0x4
    8000248a:	b7a78793          	addi	a5,a5,-1158 # 80006000 <_trampoline>
    8000248e:	00004697          	auipc	a3,0x4
    80002492:	b7268693          	addi	a3,a3,-1166 # 80006000 <_trampoline>
    80002496:	8f95                	sub	a5,a5,a3
    80002498:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000249a:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000249e:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    800024a0:	18002773          	csrr	a4,satp
    800024a4:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800024a6:	7138                	ld	a4,96(a0)
    800024a8:	653c                	ld	a5,72(a0)
    800024aa:	6685                	lui	a3,0x1
    800024ac:	97b6                	add	a5,a5,a3
    800024ae:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800024b0:	713c                	ld	a5,96(a0)
    800024b2:	00000717          	auipc	a4,0x0
    800024b6:	0fc70713          	addi	a4,a4,252 # 800025ae <usertrap>
    800024ba:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    800024bc:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800024be:	8712                	mv	a4,tp
    800024c0:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800024c2:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024c6:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024ca:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800024ce:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024d2:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800024d4:	6f9c                	ld	a5,24(a5)
    800024d6:	14179073          	csrw	sepc,a5
}
    800024da:	60a2                	ld	ra,8(sp)
    800024dc:	6402                	ld	s0,0(sp)
    800024de:	0141                	addi	sp,sp,16
    800024e0:	8082                	ret

00000000800024e2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024e2:	1141                	addi	sp,sp,-16
    800024e4:	e406                	sd	ra,8(sp)
    800024e6:	e022                	sd	s0,0(sp)
    800024e8:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800024ea:	be4ff0ef          	jal	800018ce <cpuid>
    800024ee:	cd11                	beqz	a0,8000250a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    800024f0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024f4:	000f4737          	lui	a4,0xf4
    800024f8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024fc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    800024fe:	14d79073          	csrw	stimecmp,a5
}
    80002502:	60a2                	ld	ra,8(sp)
    80002504:	6402                	ld	s0,0(sp)
    80002506:	0141                	addi	sp,sp,16
    80002508:	8082                	ret
    acquire(&tickslock);
    8000250a:	00013517          	auipc	a0,0x13
    8000250e:	48e50513          	addi	a0,a0,1166 # 80015998 <tickslock>
    80002512:	ef2fe0ef          	jal	80000c04 <acquire>
    ticks++;
    80002516:	00005717          	auipc	a4,0x5
    8000251a:	35270713          	addi	a4,a4,850 # 80007868 <ticks>
    8000251e:	431c                	lw	a5,0(a4)
    80002520:	2785                	addiw	a5,a5,1
    80002522:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002524:	853a                	mv	a0,a4
    80002526:	a53ff0ef          	jal	80001f78 <wakeup>
    release(&tickslock);
    8000252a:	00013517          	auipc	a0,0x13
    8000252e:	46e50513          	addi	a0,a0,1134 # 80015998 <tickslock>
    80002532:	f62fe0ef          	jal	80000c94 <release>
    80002536:	bf6d                	j	800024f0 <clockintr+0xe>

0000000080002538 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002538:	1101                	addi	sp,sp,-32
    8000253a:	ec06                	sd	ra,24(sp)
    8000253c:	e822                	sd	s0,16(sp)
    8000253e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002540:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80002544:	57fd                	li	a5,-1
    80002546:	17fe                	slli	a5,a5,0x3f
    80002548:	07a5                	addi	a5,a5,9
    8000254a:	00f70c63          	beq	a4,a5,80002562 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    8000254e:	57fd                	li	a5,-1
    80002550:	17fe                	slli	a5,a5,0x3f
    80002552:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002554:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    80002556:	04f70863          	beq	a4,a5,800025a6 <devintr+0x6e>
  }
}
    8000255a:	60e2                	ld	ra,24(sp)
    8000255c:	6442                	ld	s0,16(sp)
    8000255e:	6105                	addi	sp,sp,32
    80002560:	8082                	ret
    80002562:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002564:	0c8030ef          	jal	8000562c <plic_claim>
    80002568:	872a                	mv	a4,a0
    8000256a:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    8000256c:	47a9                	li	a5,10
    8000256e:	00f50963          	beq	a0,a5,80002580 <devintr+0x48>
    } else if (irq == VIRTIO0_IRQ) {
    80002572:	4785                	li	a5,1
    80002574:	00f50963          	beq	a0,a5,80002586 <devintr+0x4e>
    return 1;
    80002578:	4505                	li	a0,1
    } else if (irq) {
    8000257a:	eb09                	bnez	a4,8000258c <devintr+0x54>
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	bff1                	j	8000255a <devintr+0x22>
      uartintr();
    80002580:	c40fe0ef          	jal	800009c0 <uartintr>
    if (irq)
    80002584:	a819                	j	8000259a <devintr+0x62>
      virtio_disk_intr();
    80002586:	53c030ef          	jal	80005ac2 <virtio_disk_intr>
    if (irq)
    8000258a:	a801                	j	8000259a <devintr+0x62>
      printk("unexpected interrupt irq=%d\n", irq);
    8000258c:	85ba                	mv	a1,a4
    8000258e:	00005517          	auipc	a0,0x5
    80002592:	cc250513          	addi	a0,a0,-830 # 80007250 <etext+0x250>
    80002596:	f59fd0ef          	jal	800004ee <printk>
      plic_complete(irq);
    8000259a:	8526                	mv	a0,s1
    8000259c:	0b0030ef          	jal	8000564c <plic_complete>
    return 1;
    800025a0:	4505                	li	a0,1
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	bf5d                	j	8000255a <devintr+0x22>
    clockintr();
    800025a6:	f3dff0ef          	jal	800024e2 <clockintr>
    return 2;
    800025aa:	4509                	li	a0,2
    800025ac:	b77d                	j	8000255a <devintr+0x22>

00000000800025ae <usertrap>:
{
    800025ae:	1101                	addi	sp,sp,-32
    800025b0:	ec06                	sd	ra,24(sp)
    800025b2:	e822                	sd	s0,16(sp)
    800025b4:	e426                	sd	s1,8(sp)
    800025b6:	e04a                	sd	s2,0(sp)
    800025b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800025ba:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    800025be:	1007f793          	andi	a5,a5,256
    800025c2:	eba5                	bnez	a5,80002632 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    800025c4:	00003797          	auipc	a5,0x3
    800025c8:	fbc78793          	addi	a5,a5,-68 # 80005580 <kernelvec>
    800025cc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025d0:	b32ff0ef          	jal	80001902 <myproc>
    800025d4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025d6:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025d8:	14102773          	csrr	a4,sepc
    800025dc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    800025de:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    800025e2:	47a1                	li	a5,8
    800025e4:	04f70d63          	beq	a4,a5,8000263e <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    800025e8:	f51ff0ef          	jal	80002538 <devintr>
    800025ec:	892a                	mv	s2,a0
    800025ee:	e945                	bnez	a0,8000269e <usertrap+0xf0>
    800025f0:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800025f4:	47bd                	li	a5,15
    800025f6:	08f70863          	beq	a4,a5,80002686 <usertrap+0xd8>
    800025fa:	14202773          	csrr	a4,scause
    800025fe:	47b5                	li	a5,13
    80002600:	08f70363          	beq	a4,a5,80002686 <usertrap+0xd8>
    80002604:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002608:	5c90                	lw	a2,56(s1)
    8000260a:	00005517          	auipc	a0,0x5
    8000260e:	c8650513          	addi	a0,a0,-890 # 80007290 <etext+0x290>
    80002612:	eddfd0ef          	jal	800004ee <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002616:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    8000261a:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    8000261e:	00005517          	auipc	a0,0x5
    80002622:	ca250513          	addi	a0,a0,-862 # 800072c0 <etext+0x2c0>
    80002626:	ec9fd0ef          	jal	800004ee <printk>
    setkilled(p);
    8000262a:	8526                	mv	a0,s1
    8000262c:	b19ff0ef          	jal	80002144 <setkilled>
    80002630:	a035                	j	8000265c <usertrap+0xae>
    panic("usertrap: not from user mode");
    80002632:	00005517          	auipc	a0,0x5
    80002636:	c3e50513          	addi	a0,a0,-962 # 80007270 <etext+0x270>
    8000263a:	9defe0ef          	jal	80000818 <panic>
    if (killed(p))
    8000263e:	b2bff0ef          	jal	80002168 <killed>
    80002642:	ed15                	bnez	a0,8000267e <usertrap+0xd0>
    p->trapframe->epc += 4;
    80002644:	70b8                	ld	a4,96(s1)
    80002646:	6f1c                	ld	a5,24(a4)
    80002648:	0791                	addi	a5,a5,4
    8000264a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000264c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002650:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002654:	10079073          	csrw	sstatus,a5
    syscall();
    80002658:	27c000ef          	jal	800028d4 <syscall>
  if (killed(p))
    8000265c:	8526                	mv	a0,s1
    8000265e:	b0bff0ef          	jal	80002168 <killed>
    80002662:	e139                	bnez	a0,800026a8 <usertrap+0xfa>
  prepare_return();
    80002664:	e05ff0ef          	jal	80002468 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002668:	6ca8                	ld	a0,88(s1)
    8000266a:	8131                	srli	a0,a0,0xc
    8000266c:	57fd                	li	a5,-1
    8000266e:	17fe                	slli	a5,a5,0x3f
    80002670:	8d5d                	or	a0,a0,a5
}
    80002672:	60e2                	ld	ra,24(sp)
    80002674:	6442                	ld	s0,16(sp)
    80002676:	64a2                	ld	s1,8(sp)
    80002678:	6902                	ld	s2,0(sp)
    8000267a:	6105                	addi	sp,sp,32
    8000267c:	8082                	ret
      kexit(-1);
    8000267e:	557d                	li	a0,-1
    80002680:	9b9ff0ef          	jal	80002038 <kexit>
    80002684:	b7c1                	j	80002644 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002686:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    8000268a:	14202673          	csrr	a2,scause
             vmfault(p->pagetable, r_stval(), (r_scause() == 13) ? 1 : 0) !=
    8000268e:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002690:	00163613          	seqz	a2,a2
    80002694:	6ca8                	ld	a0,88(s1)
    80002696:	f0ffe0ef          	jal	800015a4 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000269a:	f169                	bnez	a0,8000265c <usertrap+0xae>
    8000269c:	b7a5                	j	80002604 <usertrap+0x56>
  if (killed(p))
    8000269e:	8526                	mv	a0,s1
    800026a0:	ac9ff0ef          	jal	80002168 <killed>
    800026a4:	c511                	beqz	a0,800026b0 <usertrap+0x102>
    800026a6:	a011                	j	800026aa <usertrap+0xfc>
    800026a8:	4901                	li	s2,0
    kexit(-1);
    800026aa:	557d                	li	a0,-1
    800026ac:	98dff0ef          	jal	80002038 <kexit>
 if(which_dev == 2) { //Demotion of a task p1=5 tickets , p2=10 tickets;
    800026b0:	4789                	li	a5,2
    800026b2:	faf919e3          	bne	s2,a5,80002664 <usertrap+0xb6>
    struct proc *p = myproc();
    800026b6:	a4cff0ef          	jal	80001902 <myproc>
    if(p != 0 && p->state == RUNNING) {
    800026ba:	c509                	beqz	a0,800026c4 <usertrap+0x116>
    800026bc:	4d18                	lw	a4,24(a0)
    800026be:	4791                	li	a5,4
    800026c0:	00f70563          	beq	a4,a5,800026ca <usertrap+0x11c>
    yield(); // Force the scheduler to re-check priorities
    800026c4:	83dff0ef          	jal	80001f00 <yield>
    800026c8:	bf71                	j	80002664 <usertrap+0xb6>
      p->ticks_used++; // The stopwatch is ticking!
    800026ca:	595c                	lw	a5,52(a0)
    800026cc:	2785                	addiw	a5,a5,1
    800026ce:	d95c                	sw	a5,52(a0)
      if(p->priority == 0 && p->ticks_used >= 5) {
    800026d0:	5918                	lw	a4,48(a0)
    800026d2:	4691                	li	a3,4
    800026d4:	00f6d363          	bge	a3,a5,800026da <usertrap+0x12c>
    800026d8:	cb19                	beqz	a4,800026ee <usertrap+0x140>
      } else if(p->priority == 1 && p->ticks_used >= 10) {
    800026da:	46a5                	li	a3,9
    800026dc:	fef6d4e3          	bge	a3,a5,800026c4 <usertrap+0x116>
    800026e0:	177d                	addi	a4,a4,-1
    800026e2:	f36d                	bnez	a4,800026c4 <usertrap+0x116>
        p->priority = 2;
    800026e4:	4789                	li	a5,2
    800026e6:	d91c                	sw	a5,48(a0)
        p->ticks_used = 0;
    800026e8:	02052a23          	sw	zero,52(a0)
    800026ec:	bfe1                	j	800026c4 <usertrap+0x116>
        p->priority = 1;
    800026ee:	4785                	li	a5,1
    800026f0:	d91c                	sw	a5,48(a0)
        p->ticks_used = 0;
    800026f2:	02052a23          	sw	zero,52(a0)
    800026f6:	b7f9                	j	800026c4 <usertrap+0x116>

00000000800026f8 <kerneltrap>:
{
    800026f8:	7179                	addi	sp,sp,-48
    800026fa:	f406                	sd	ra,40(sp)
    800026fc:	f022                	sd	s0,32(sp)
    800026fe:	ec26                	sd	s1,24(sp)
    80002700:	e84a                	sd	s2,16(sp)
    80002702:	e44e                	sd	s3,8(sp)
    80002704:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002706:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000270a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    8000270e:	142027f3          	csrr	a5,scause
    80002712:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    80002714:	1004f793          	andi	a5,s1,256
    80002718:	c795                	beqz	a5,80002744 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000271a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000271e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002720:	eb85                	bnez	a5,80002750 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    80002722:	e17ff0ef          	jal	80002538 <devintr>
    80002726:	c91d                	beqz	a0,8000275c <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    80002728:	4789                	li	a5,2
    8000272a:	04f50a63          	beq	a0,a5,8000277e <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000272e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002732:	10049073          	csrw	sstatus,s1
}
    80002736:	70a2                	ld	ra,40(sp)
    80002738:	7402                	ld	s0,32(sp)
    8000273a:	64e2                	ld	s1,24(sp)
    8000273c:	6942                	ld	s2,16(sp)
    8000273e:	69a2                	ld	s3,8(sp)
    80002740:	6145                	addi	sp,sp,48
    80002742:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002744:	00005517          	auipc	a0,0x5
    80002748:	ba450513          	addi	a0,a0,-1116 # 800072e8 <etext+0x2e8>
    8000274c:	8ccfe0ef          	jal	80000818 <panic>
    panic("kerneltrap: interrupts enabled");
    80002750:	00005517          	auipc	a0,0x5
    80002754:	bc050513          	addi	a0,a0,-1088 # 80007310 <etext+0x310>
    80002758:	8c0fe0ef          	jal	80000818 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000275c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002760:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002764:	85ce                	mv	a1,s3
    80002766:	00005517          	auipc	a0,0x5
    8000276a:	bca50513          	addi	a0,a0,-1078 # 80007330 <etext+0x330>
    8000276e:	d81fd0ef          	jal	800004ee <printk>
    panic("kerneltrap");
    80002772:	00005517          	auipc	a0,0x5
    80002776:	be650513          	addi	a0,a0,-1050 # 80007358 <etext+0x358>
    8000277a:	89efe0ef          	jal	80000818 <panic>
  if (which_dev == 2 && myproc() != 0)
    8000277e:	984ff0ef          	jal	80001902 <myproc>
    80002782:	d555                	beqz	a0,8000272e <kerneltrap+0x36>
    yield();
    80002784:	f7cff0ef          	jal	80001f00 <yield>
    80002788:	b75d                	j	8000272e <kerneltrap+0x36>

000000008000278a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000278a:	1101                	addi	sp,sp,-32
    8000278c:	ec06                	sd	ra,24(sp)
    8000278e:	e822                	sd	s0,16(sp)
    80002790:	e426                	sd	s1,8(sp)
    80002792:	1000                	addi	s0,sp,32
    80002794:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002796:	96cff0ef          	jal	80001902 <myproc>
  switch (n) {
    8000279a:	4795                	li	a5,5
    8000279c:	0497e163          	bltu	a5,s1,800027de <argraw+0x54>
    800027a0:	048a                	slli	s1,s1,0x2
    800027a2:	00005717          	auipc	a4,0x5
    800027a6:	fb670713          	addi	a4,a4,-74 # 80007758 <states.0+0x30>
    800027aa:	94ba                	add	s1,s1,a4
    800027ac:	409c                	lw	a5,0(s1)
    800027ae:	97ba                	add	a5,a5,a4
    800027b0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800027b2:	713c                	ld	a5,96(a0)
    800027b4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800027b6:	60e2                	ld	ra,24(sp)
    800027b8:	6442                	ld	s0,16(sp)
    800027ba:	64a2                	ld	s1,8(sp)
    800027bc:	6105                	addi	sp,sp,32
    800027be:	8082                	ret
    return p->trapframe->a1;
    800027c0:	713c                	ld	a5,96(a0)
    800027c2:	7fa8                	ld	a0,120(a5)
    800027c4:	bfcd                	j	800027b6 <argraw+0x2c>
    return p->trapframe->a2;
    800027c6:	713c                	ld	a5,96(a0)
    800027c8:	63c8                	ld	a0,128(a5)
    800027ca:	b7f5                	j	800027b6 <argraw+0x2c>
    return p->trapframe->a3;
    800027cc:	713c                	ld	a5,96(a0)
    800027ce:	67c8                	ld	a0,136(a5)
    800027d0:	b7dd                	j	800027b6 <argraw+0x2c>
    return p->trapframe->a4;
    800027d2:	713c                	ld	a5,96(a0)
    800027d4:	6bc8                	ld	a0,144(a5)
    800027d6:	b7c5                	j	800027b6 <argraw+0x2c>
    return p->trapframe->a5;
    800027d8:	713c                	ld	a5,96(a0)
    800027da:	6fc8                	ld	a0,152(a5)
    800027dc:	bfe9                	j	800027b6 <argraw+0x2c>
  panic("argraw");
    800027de:	00005517          	auipc	a0,0x5
    800027e2:	b8a50513          	addi	a0,a0,-1142 # 80007368 <etext+0x368>
    800027e6:	832fe0ef          	jal	80000818 <panic>

00000000800027ea <fetchaddr>:
{
    800027ea:	1101                	addi	sp,sp,-32
    800027ec:	ec06                	sd	ra,24(sp)
    800027ee:	e822                	sd	s0,16(sp)
    800027f0:	e426                	sd	s1,8(sp)
    800027f2:	e04a                	sd	s2,0(sp)
    800027f4:	1000                	addi	s0,sp,32
    800027f6:	84aa                	mv	s1,a0
    800027f8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800027fa:	908ff0ef          	jal	80001902 <myproc>
  if (addr >= p->sz ||
    800027fe:	693c                	ld	a5,80(a0)
    80002800:	02f4f663          	bgeu	s1,a5,8000282c <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002804:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80002808:	02e7e463          	bltu	a5,a4,80002830 <fetchaddr+0x46>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000280c:	46a1                	li	a3,8
    8000280e:	8626                	mv	a2,s1
    80002810:	85ca                	mv	a1,s2
    80002812:	6d28                	ld	a0,88(a0)
    80002814:	ed3fe0ef          	jal	800016e6 <copyin>
    80002818:	00a03533          	snez	a0,a0
    8000281c:	40a0053b          	negw	a0,a0
}
    80002820:	60e2                	ld	ra,24(sp)
    80002822:	6442                	ld	s0,16(sp)
    80002824:	64a2                	ld	s1,8(sp)
    80002826:	6902                	ld	s2,0(sp)
    80002828:	6105                	addi	sp,sp,32
    8000282a:	8082                	ret
    return -1;
    8000282c:	557d                	li	a0,-1
    8000282e:	bfcd                	j	80002820 <fetchaddr+0x36>
    80002830:	557d                	li	a0,-1
    80002832:	b7fd                	j	80002820 <fetchaddr+0x36>

0000000080002834 <fetchstr>:
{
    80002834:	7179                	addi	sp,sp,-48
    80002836:	f406                	sd	ra,40(sp)
    80002838:	f022                	sd	s0,32(sp)
    8000283a:	ec26                	sd	s1,24(sp)
    8000283c:	e84a                	sd	s2,16(sp)
    8000283e:	e44e                	sd	s3,8(sp)
    80002840:	1800                	addi	s0,sp,48
    80002842:	89aa                	mv	s3,a0
    80002844:	84ae                	mv	s1,a1
    80002846:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002848:	8baff0ef          	jal	80001902 <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    8000284c:	86ca                	mv	a3,s2
    8000284e:	864e                	mv	a2,s3
    80002850:	85a6                	mv	a1,s1
    80002852:	6d28                	ld	a0,88(a0)
    80002854:	c79fe0ef          	jal	800014cc <copyinstr>
    80002858:	00054c63          	bltz	a0,80002870 <fetchstr+0x3c>
  return strlen(buf);
    8000285c:	8526                	mv	a0,s1
    8000285e:	df8fe0ef          	jal	80000e56 <strlen>
}
    80002862:	70a2                	ld	ra,40(sp)
    80002864:	7402                	ld	s0,32(sp)
    80002866:	64e2                	ld	s1,24(sp)
    80002868:	6942                	ld	s2,16(sp)
    8000286a:	69a2                	ld	s3,8(sp)
    8000286c:	6145                	addi	sp,sp,48
    8000286e:	8082                	ret
    return -1;
    80002870:	557d                	li	a0,-1
    80002872:	bfc5                	j	80002862 <fetchstr+0x2e>

0000000080002874 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002874:	1101                	addi	sp,sp,-32
    80002876:	ec06                	sd	ra,24(sp)
    80002878:	e822                	sd	s0,16(sp)
    8000287a:	e426                	sd	s1,8(sp)
    8000287c:	1000                	addi	s0,sp,32
    8000287e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002880:	f0bff0ef          	jal	8000278a <argraw>
    80002884:	c088                	sw	a0,0(s1)
}
    80002886:	60e2                	ld	ra,24(sp)
    80002888:	6442                	ld	s0,16(sp)
    8000288a:	64a2                	ld	s1,8(sp)
    8000288c:	6105                	addi	sp,sp,32
    8000288e:	8082                	ret

0000000080002890 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002890:	1101                	addi	sp,sp,-32
    80002892:	ec06                	sd	ra,24(sp)
    80002894:	e822                	sd	s0,16(sp)
    80002896:	e426                	sd	s1,8(sp)
    80002898:	1000                	addi	s0,sp,32
    8000289a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000289c:	eefff0ef          	jal	8000278a <argraw>
    800028a0:	e088                	sd	a0,0(s1)
}
    800028a2:	60e2                	ld	ra,24(sp)
    800028a4:	6442                	ld	s0,16(sp)
    800028a6:	64a2                	ld	s1,8(sp)
    800028a8:	6105                	addi	sp,sp,32
    800028aa:	8082                	ret

00000000800028ac <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800028ac:	1101                	addi	sp,sp,-32
    800028ae:	ec06                	sd	ra,24(sp)
    800028b0:	e822                	sd	s0,16(sp)
    800028b2:	e426                	sd	s1,8(sp)
    800028b4:	e04a                	sd	s2,0(sp)
    800028b6:	1000                	addi	s0,sp,32
    800028b8:	892e                	mv	s2,a1
    800028ba:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800028bc:	ecfff0ef          	jal	8000278a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800028c0:	8626                	mv	a2,s1
    800028c2:	85ca                	mv	a1,s2
    800028c4:	f71ff0ef          	jal	80002834 <fetchstr>
}
    800028c8:	60e2                	ld	ra,24(sp)
    800028ca:	6442                	ld	s0,16(sp)
    800028cc:	64a2                	ld	s1,8(sp)
    800028ce:	6902                	ld	s2,0(sp)
    800028d0:	6105                	addi	sp,sp,32
    800028d2:	8082                	ret

00000000800028d4 <syscall>:
  // clang-format on
};

void
syscall(void)
{
    800028d4:	1101                	addi	sp,sp,-32
    800028d6:	ec06                	sd	ra,24(sp)
    800028d8:	e822                	sd	s0,16(sp)
    800028da:	e426                	sd	s1,8(sp)
    800028dc:	e04a                	sd	s2,0(sp)
    800028de:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800028e0:	822ff0ef          	jal	80001902 <myproc>
    800028e4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800028e6:	06053903          	ld	s2,96(a0)
    800028ea:	0a893783          	ld	a5,168(s2)
    800028ee:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800028f2:	37fd                	addiw	a5,a5,-1
    800028f4:	4759                	li	a4,22
    800028f6:	00f76f63          	bltu	a4,a5,80002914 <syscall+0x40>
    800028fa:	00369713          	slli	a4,a3,0x3
    800028fe:	00005797          	auipc	a5,0x5
    80002902:	e7278793          	addi	a5,a5,-398 # 80007770 <syscalls>
    80002906:	97ba                	add	a5,a5,a4
    80002908:	639c                	ld	a5,0(a5)
    8000290a:	c789                	beqz	a5,80002914 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000290c:	9782                	jalr	a5
    8000290e:	06a93823          	sd	a0,112(s2)
    80002912:	a829                	j	8000292c <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002914:	16048613          	addi	a2,s1,352
    80002918:	5c8c                	lw	a1,56(s1)
    8000291a:	00005517          	auipc	a0,0x5
    8000291e:	a5650513          	addi	a0,a0,-1450 # 80007370 <etext+0x370>
    80002922:	bcdfd0ef          	jal	800004ee <printk>
    p->trapframe->a0 = -1;
    80002926:	70bc                	ld	a5,96(s1)
    80002928:	577d                	li	a4,-1
    8000292a:	fbb8                	sd	a4,112(a5)
  }
}
    8000292c:	60e2                	ld	ra,24(sp)
    8000292e:	6442                	ld	s0,16(sp)
    80002930:	64a2                	ld	s1,8(sp)
    80002932:	6902                	ld	s2,0(sp)
    80002934:	6105                	addi	sp,sp,32
    80002936:	8082                	ret

0000000080002938 <sys_exit>:
#include "proc.h"
#include "vm.h"
#include "uproc.h"
uint64
sys_exit(void)
{
    80002938:	1101                	addi	sp,sp,-32
    8000293a:	ec06                	sd	ra,24(sp)
    8000293c:	e822                	sd	s0,16(sp)
    8000293e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002940:	fec40593          	addi	a1,s0,-20
    80002944:	4501                	li	a0,0
    80002946:	f2fff0ef          	jal	80002874 <argint>
  kexit(n);
    8000294a:	fec42503          	lw	a0,-20(s0)
    8000294e:	eeaff0ef          	jal	80002038 <kexit>
  return 0; // not reached
}
    80002952:	4501                	li	a0,0
    80002954:	60e2                	ld	ra,24(sp)
    80002956:	6442                	ld	s0,16(sp)
    80002958:	6105                	addi	sp,sp,32
    8000295a:	8082                	ret

000000008000295c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000295c:	1141                	addi	sp,sp,-16
    8000295e:	e406                	sd	ra,8(sp)
    80002960:	e022                	sd	s0,0(sp)
    80002962:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002964:	f9ffe0ef          	jal	80001902 <myproc>
}
    80002968:	5d08                	lw	a0,56(a0)
    8000296a:	60a2                	ld	ra,8(sp)
    8000296c:	6402                	ld	s0,0(sp)
    8000296e:	0141                	addi	sp,sp,16
    80002970:	8082                	ret

0000000080002972 <sys_fork>:

uint64
sys_fork(void)
{
    80002972:	1141                	addi	sp,sp,-16
    80002974:	e406                	sd	ra,8(sp)
    80002976:	e022                	sd	s0,0(sp)
    80002978:	0800                	addi	s0,sp,16
  return kfork();
    8000297a:	af8ff0ef          	jal	80001c72 <kfork>
}
    8000297e:	60a2                	ld	ra,8(sp)
    80002980:	6402                	ld	s0,0(sp)
    80002982:	0141                	addi	sp,sp,16
    80002984:	8082                	ret

0000000080002986 <sys_wait>:

uint64
sys_wait(void)
{
    80002986:	1101                	addi	sp,sp,-32
    80002988:	ec06                	sd	ra,24(sp)
    8000298a:	e822                	sd	s0,16(sp)
    8000298c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000298e:	fe840593          	addi	a1,s0,-24
    80002992:	4501                	li	a0,0
    80002994:	efdff0ef          	jal	80002890 <argaddr>
  return kwait(p);
    80002998:	fe843503          	ld	a0,-24(s0)
    8000299c:	ff6ff0ef          	jal	80002192 <kwait>
}
    800029a0:	60e2                	ld	ra,24(sp)
    800029a2:	6442                	ld	s0,16(sp)
    800029a4:	6105                	addi	sp,sp,32
    800029a6:	8082                	ret

00000000800029a8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800029a8:	7179                	addi	sp,sp,-48
    800029aa:	f406                	sd	ra,40(sp)
    800029ac:	f022                	sd	s0,32(sp)
    800029ae:	ec26                	sd	s1,24(sp)
    800029b0:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800029b2:	fd840593          	addi	a1,s0,-40
    800029b6:	4501                	li	a0,0
    800029b8:	ebdff0ef          	jal	80002874 <argint>
  argint(1, &t);
    800029bc:	fdc40593          	addi	a1,s0,-36
    800029c0:	4505                	li	a0,1
    800029c2:	eb3ff0ef          	jal	80002874 <argint>
  addr = myproc()->sz;
    800029c6:	f3dfe0ef          	jal	80001902 <myproc>
    800029ca:	6924                	ld	s1,80(a0)

  if (t == SBRK_EAGER || n < 0) {
    800029cc:	fdc42703          	lw	a4,-36(s0)
    800029d0:	4785                	li	a5,1
    800029d2:	02f70763          	beq	a4,a5,80002a00 <sys_sbrk+0x58>
    800029d6:	fd842783          	lw	a5,-40(s0)
    800029da:	0207c363          	bltz	a5,80002a00 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    800029de:	97a6                	add	a5,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    800029e0:	02000737          	lui	a4,0x2000
    800029e4:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    800029e6:	0736                	slli	a4,a4,0xd
    800029e8:	02f76a63          	bltu	a4,a5,80002a1c <sys_sbrk+0x74>
    800029ec:	0297e863          	bltu	a5,s1,80002a1c <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    800029f0:	f13fe0ef          	jal	80001902 <myproc>
    800029f4:	fd842703          	lw	a4,-40(s0)
    800029f8:	693c                	ld	a5,80(a0)
    800029fa:	97ba                	add	a5,a5,a4
    800029fc:	e93c                	sd	a5,80(a0)
    800029fe:	a039                	j	80002a0c <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    80002a00:	fd842503          	lw	a0,-40(s0)
    80002a04:	a0cff0ef          	jal	80001c10 <growproc>
    80002a08:	00054863          	bltz	a0,80002a18 <sys_sbrk+0x70>
  }
  return addr;
}
    80002a0c:	8526                	mv	a0,s1
    80002a0e:	70a2                	ld	ra,40(sp)
    80002a10:	7402                	ld	s0,32(sp)
    80002a12:	64e2                	ld	s1,24(sp)
    80002a14:	6145                	addi	sp,sp,48
    80002a16:	8082                	ret
      return -1;
    80002a18:	54fd                	li	s1,-1
    80002a1a:	bfcd                	j	80002a0c <sys_sbrk+0x64>
      return -1;
    80002a1c:	54fd                	li	s1,-1
    80002a1e:	b7fd                	j	80002a0c <sys_sbrk+0x64>

0000000080002a20 <sys_pause>:

uint64
sys_pause(void)
{
    80002a20:	7139                	addi	sp,sp,-64
    80002a22:	fc06                	sd	ra,56(sp)
    80002a24:	f822                	sd	s0,48(sp)
    80002a26:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002a28:	fcc40593          	addi	a1,s0,-52
    80002a2c:	4501                	li	a0,0
    80002a2e:	e47ff0ef          	jal	80002874 <argint>
  if (n < 0)
    80002a32:	fcc42783          	lw	a5,-52(s0)
    80002a36:	0607c863          	bltz	a5,80002aa6 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002a3a:	00013517          	auipc	a0,0x13
    80002a3e:	f5e50513          	addi	a0,a0,-162 # 80015998 <tickslock>
    80002a42:	9c2fe0ef          	jal	80000c04 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002a46:	fcc42783          	lw	a5,-52(s0)
    80002a4a:	c3b9                	beqz	a5,80002a90 <sys_pause+0x70>
    80002a4c:	f426                	sd	s1,40(sp)
    80002a4e:	f04a                	sd	s2,32(sp)
    80002a50:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a52:	00005997          	auipc	s3,0x5
    80002a56:	e169a983          	lw	s3,-490(s3) # 80007868 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a5a:	00013917          	auipc	s2,0x13
    80002a5e:	f3e90913          	addi	s2,s2,-194 # 80015998 <tickslock>
    80002a62:	00005497          	auipc	s1,0x5
    80002a66:	e0648493          	addi	s1,s1,-506 # 80007868 <ticks>
    if (killed(myproc())) {
    80002a6a:	e99fe0ef          	jal	80001902 <myproc>
    80002a6e:	efaff0ef          	jal	80002168 <killed>
    80002a72:	ed0d                	bnez	a0,80002aac <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a74:	85ca                	mv	a1,s2
    80002a76:	8526                	mv	a0,s1
    80002a78:	cb4ff0ef          	jal	80001f2c <sleep>
  while (ticks - ticks0 < n) {
    80002a7c:	409c                	lw	a5,0(s1)
    80002a7e:	413787bb          	subw	a5,a5,s3
    80002a82:	fcc42703          	lw	a4,-52(s0)
    80002a86:	fee7e2e3          	bltu	a5,a4,80002a6a <sys_pause+0x4a>
    80002a8a:	74a2                	ld	s1,40(sp)
    80002a8c:	7902                	ld	s2,32(sp)
    80002a8e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a90:	00013517          	auipc	a0,0x13
    80002a94:	f0850513          	addi	a0,a0,-248 # 80015998 <tickslock>
    80002a98:	9fcfe0ef          	jal	80000c94 <release>
  return 0;
    80002a9c:	4501                	li	a0,0
}
    80002a9e:	70e2                	ld	ra,56(sp)
    80002aa0:	7442                	ld	s0,48(sp)
    80002aa2:	6121                	addi	sp,sp,64
    80002aa4:	8082                	ret
    n = 0;
    80002aa6:	fc042623          	sw	zero,-52(s0)
    80002aaa:	bf41                	j	80002a3a <sys_pause+0x1a>
      release(&tickslock);
    80002aac:	00013517          	auipc	a0,0x13
    80002ab0:	eec50513          	addi	a0,a0,-276 # 80015998 <tickslock>
    80002ab4:	9e0fe0ef          	jal	80000c94 <release>
      return -1;
    80002ab8:	557d                	li	a0,-1
    80002aba:	74a2                	ld	s1,40(sp)
    80002abc:	7902                	ld	s2,32(sp)
    80002abe:	69e2                	ld	s3,24(sp)
    80002ac0:	bff9                	j	80002a9e <sys_pause+0x7e>

0000000080002ac2 <sys_kill>:

uint64
sys_kill(void)
{
    80002ac2:	1101                	addi	sp,sp,-32
    80002ac4:	ec06                	sd	ra,24(sp)
    80002ac6:	e822                	sd	s0,16(sp)
    80002ac8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002aca:	fec40593          	addi	a1,s0,-20
    80002ace:	4501                	li	a0,0
    80002ad0:	da5ff0ef          	jal	80002874 <argint>
  return kkill(pid);
    80002ad4:	fec42503          	lw	a0,-20(s0)
    80002ad8:	e06ff0ef          	jal	800020de <kkill>
}
    80002adc:	60e2                	ld	ra,24(sp)
    80002ade:	6442                	ld	s0,16(sp)
    80002ae0:	6105                	addi	sp,sp,32
    80002ae2:	8082                	ret

0000000080002ae4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ae4:	1101                	addi	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	e426                	sd	s1,8(sp)
    80002aec:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002aee:	00013517          	auipc	a0,0x13
    80002af2:	eaa50513          	addi	a0,a0,-342 # 80015998 <tickslock>
    80002af6:	90efe0ef          	jal	80000c04 <acquire>
  xticks = ticks;
    80002afa:	00005797          	auipc	a5,0x5
    80002afe:	d6e7a783          	lw	a5,-658(a5) # 80007868 <ticks>
    80002b02:	84be                	mv	s1,a5
  release(&tickslock);
    80002b04:	00013517          	auipc	a0,0x13
    80002b08:	e9450513          	addi	a0,a0,-364 # 80015998 <tickslock>
    80002b0c:	988fe0ef          	jal	80000c94 <release>
  return xticks;
}
    80002b10:	02049513          	slli	a0,s1,0x20
    80002b14:	9101                	srli	a0,a0,0x20
    80002b16:	60e2                	ld	ra,24(sp)
    80002b18:	6442                	ld	s0,16(sp)
    80002b1a:	64a2                	ld	s1,8(sp)
    80002b1c:	6105                	addi	sp,sp,32
    80002b1e:	8082                	ret

0000000080002b20 <sys_sleep>:
uint64
sys_sleep(void)
{
    80002b20:	7139                	addi	sp,sp,-64
    80002b22:	fc06                	sd	ra,56(sp)
    80002b24:	f822                	sd	s0,48(sp)
    80002b26:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  
  // Call it directly. No 'if' statement because it returns void!
  argint(0, &n);
    80002b28:	fcc40593          	addi	a1,s0,-52
    80002b2c:	4501                	li	a0,0
    80002b2e:	d47ff0ef          	jal	80002874 <argint>
    
  acquire(&tickslock);
    80002b32:	00013517          	auipc	a0,0x13
    80002b36:	e6650513          	addi	a0,a0,-410 # 80015998 <tickslock>
    80002b3a:	8cafe0ef          	jal	80000c04 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002b3e:	fcc42783          	lw	a5,-52(s0)
    80002b42:	c3b9                	beqz	a5,80002b88 <sys_sleep+0x68>
    80002b44:	f426                	sd	s1,40(sp)
    80002b46:	f04a                	sd	s2,32(sp)
    80002b48:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002b4a:	00005997          	auipc	s3,0x5
    80002b4e:	d1e9a983          	lw	s3,-738(s3) # 80007868 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b52:	00013917          	auipc	s2,0x13
    80002b56:	e4690913          	addi	s2,s2,-442 # 80015998 <tickslock>
    80002b5a:	00005497          	auipc	s1,0x5
    80002b5e:	d0e48493          	addi	s1,s1,-754 # 80007868 <ticks>
    if(killed(myproc())){
    80002b62:	da1fe0ef          	jal	80001902 <myproc>
    80002b66:	e02ff0ef          	jal	80002168 <killed>
    80002b6a:	e915                	bnez	a0,80002b9e <sys_sleep+0x7e>
    sleep(&ticks, &tickslock);
    80002b6c:	85ca                	mv	a1,s2
    80002b6e:	8526                	mv	a0,s1
    80002b70:	bbcff0ef          	jal	80001f2c <sleep>
  while(ticks - ticks0 < n){
    80002b74:	409c                	lw	a5,0(s1)
    80002b76:	413787bb          	subw	a5,a5,s3
    80002b7a:	fcc42703          	lw	a4,-52(s0)
    80002b7e:	fee7e2e3          	bltu	a5,a4,80002b62 <sys_sleep+0x42>
    80002b82:	74a2                	ld	s1,40(sp)
    80002b84:	7902                	ld	s2,32(sp)
    80002b86:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002b88:	00013517          	auipc	a0,0x13
    80002b8c:	e1050513          	addi	a0,a0,-496 # 80015998 <tickslock>
    80002b90:	904fe0ef          	jal	80000c94 <release>
  return 0;
    80002b94:	4501                	li	a0,0
}
    80002b96:	70e2                	ld	ra,56(sp)
    80002b98:	7442                	ld	s0,48(sp)
    80002b9a:	6121                	addi	sp,sp,64
    80002b9c:	8082                	ret
      release(&tickslock);
    80002b9e:	00013517          	auipc	a0,0x13
    80002ba2:	dfa50513          	addi	a0,a0,-518 # 80015998 <tickslock>
    80002ba6:	8eefe0ef          	jal	80000c94 <release>
      return -1;
    80002baa:	557d                	li	a0,-1
    80002bac:	74a2                	ld	s1,40(sp)
    80002bae:	7902                	ld	s2,32(sp)
    80002bb0:	69e2                	ld	s3,24(sp)
    80002bb2:	b7d5                	j	80002b96 <sys_sleep+0x76>

0000000080002bb4 <sys_getprocinfo>:
extern struct proc proc[NPROC];
uint64
sys_getprocinfo(void)
{
    80002bb4:	7119                	addi	sp,sp,-128
    80002bb6:	fc86                	sd	ra,120(sp)
    80002bb8:	f8a2                	sd	s0,112(sp)
    80002bba:	f4a6                	sd	s1,104(sp)
    80002bbc:	f0ca                	sd	s2,96(sp)
    80002bbe:	ecce                	sd	s3,88(sp)
    80002bc0:	e8d2                	sd	s4,80(sp)
    80002bc2:	e4d6                	sd	s5,72(sp)
    80002bc4:	e0da                	sd	s6,64(sp)
    80002bc6:	fc5e                	sd	s7,56(sp)
    80002bc8:	0100                	addi	s0,sp,128
  uint64 uaddr;
  // Get the pointer argument where user space wants the data stored
  argaddr(0, &uaddr);
    80002bca:	fa840593          	addi	a1,s0,-88
    80002bce:	4501                	li	a0,0
    80002bd0:	cc1ff0ef          	jal	80002890 <argaddr>

  struct proc *p;
  struct uproc up;
  int idx = 0;
    80002bd4:	4901                	li	s2,0

  // Loop through all process slots in the kernel
  for(p = proc; p < &proc[NPROC]; p++) {
    80002bd6:	0000d497          	auipc	s1,0xd
    80002bda:	1c248493          	addi	s1,s1,450 # 8000fd98 <proc>
    // Only capture active processes
    if(p->state != UNUSED) {
      up.pid = p->pid;
      up.priority = p->priority;     // Your custom MLFQ priority field
      up.total_ticks = p->ticks_used; // Your custom tick counter field
      safestrcpy(up.name, p->name, sizeof(p->name));
    80002bde:	f8840b93          	addi	s7,s0,-120
    80002be2:	f9440b13          	addi	s6,s0,-108
    80002be6:	4ac1                	li	s5,16
      
      // Copy this single uproc struct to the user space buffer
      if(copyout(myproc()->pagetable, uaddr + idx * sizeof(struct uproc), (char *)&up, sizeof(struct uproc)) < 0) {
    80002be8:	4a71                	li	s4,28
  for(p = proc; p < &proc[NPROC]; p++) {
    80002bea:	00013997          	auipc	s3,0x13
    80002bee:	dae98993          	addi	s3,s3,-594 # 80015998 <tickslock>
    80002bf2:	a03d                	j	80002c20 <sys_getprocinfo+0x6c>
        release(&p->lock);
    80002bf4:	8526                	mv	a0,s1
    80002bf6:	89efe0ef          	jal	80000c94 <release>
        return -1;
    80002bfa:	557d                	li	a0,-1
    }
    release(&p->lock);
  }

  return idx; // Return the total number of active processes found
}
    80002bfc:	70e6                	ld	ra,120(sp)
    80002bfe:	7446                	ld	s0,112(sp)
    80002c00:	74a6                	ld	s1,104(sp)
    80002c02:	7906                	ld	s2,96(sp)
    80002c04:	69e6                	ld	s3,88(sp)
    80002c06:	6a46                	ld	s4,80(sp)
    80002c08:	6aa6                	ld	s5,72(sp)
    80002c0a:	6b06                	ld	s6,64(sp)
    80002c0c:	7be2                	ld	s7,56(sp)
    80002c0e:	6109                	addi	sp,sp,128
    80002c10:	8082                	ret
    release(&p->lock);
    80002c12:	8526                	mv	a0,s1
    80002c14:	880fe0ef          	jal	80000c94 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002c18:	17048493          	addi	s1,s1,368
    80002c1c:	05348963          	beq	s1,s3,80002c6e <sys_getprocinfo+0xba>
    acquire(&p->lock);
    80002c20:	8526                	mv	a0,s1
    80002c22:	fe3fd0ef          	jal	80000c04 <acquire>
    if(p->state != UNUSED) {
    80002c26:	4c9c                	lw	a5,24(s1)
    80002c28:	d7ed                	beqz	a5,80002c12 <sys_getprocinfo+0x5e>
      up.pid = p->pid;
    80002c2a:	5c9c                	lw	a5,56(s1)
    80002c2c:	f8f42423          	sw	a5,-120(s0)
      up.priority = p->priority;     // Your custom MLFQ priority field
    80002c30:	589c                	lw	a5,48(s1)
    80002c32:	f8f42623          	sw	a5,-116(s0)
      up.total_ticks = p->ticks_used; // Your custom tick counter field
    80002c36:	58dc                	lw	a5,52(s1)
    80002c38:	f8f42823          	sw	a5,-112(s0)
      safestrcpy(up.name, p->name, sizeof(p->name));
    80002c3c:	8656                	mv	a2,s5
    80002c3e:	16048593          	addi	a1,s1,352
    80002c42:	855a                	mv	a0,s6
    80002c44:	9dcfe0ef          	jal	80000e20 <safestrcpy>
      if(copyout(myproc()->pagetable, uaddr + idx * sizeof(struct uproc), (char *)&up, sizeof(struct uproc)) < 0) {
    80002c48:	cbbfe0ef          	jal	80001902 <myproc>
    80002c4c:	00391793          	slli	a5,s2,0x3
    80002c50:	412787b3          	sub	a5,a5,s2
    80002c54:	078a                	slli	a5,a5,0x2
    80002c56:	86d2                	mv	a3,s4
    80002c58:	865e                	mv	a2,s7
    80002c5a:	fa843583          	ld	a1,-88(s0)
    80002c5e:	95be                	add	a1,a1,a5
    80002c60:	6d28                	ld	a0,88(a0)
    80002c62:	9c7fe0ef          	jal	80001628 <copyout>
    80002c66:	f80547e3          	bltz	a0,80002bf4 <sys_getprocinfo+0x40>
      idx++;
    80002c6a:	2905                	addiw	s2,s2,1
    80002c6c:	b75d                	j	80002c12 <sys_getprocinfo+0x5e>
  return idx; // Return the total number of active processes found
    80002c6e:	854a                	mv	a0,s2
    80002c70:	b771                	j	80002bfc <sys_getprocinfo+0x48>

0000000080002c72 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c72:	7179                	addi	sp,sp,-48
    80002c74:	f406                	sd	ra,40(sp)
    80002c76:	f022                	sd	s0,32(sp)
    80002c78:	ec26                	sd	s1,24(sp)
    80002c7a:	e84a                	sd	s2,16(sp)
    80002c7c:	e44e                	sd	s3,8(sp)
    80002c7e:	e052                	sd	s4,0(sp)
    80002c80:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c82:	00004597          	auipc	a1,0x4
    80002c86:	70e58593          	addi	a1,a1,1806 # 80007390 <etext+0x390>
    80002c8a:	00013517          	auipc	a0,0x13
    80002c8e:	d2650513          	addi	a0,a0,-730 # 800159b0 <bcache>
    80002c92:	ee9fd0ef          	jal	80000b7a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c96:	0001b797          	auipc	a5,0x1b
    80002c9a:	d1a78793          	addi	a5,a5,-742 # 8001d9b0 <bcache+0x8000>
    80002c9e:	0001b717          	auipc	a4,0x1b
    80002ca2:	f7a70713          	addi	a4,a4,-134 # 8001dc18 <bcache+0x8268>
    80002ca6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002caa:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002cae:	00013497          	auipc	s1,0x13
    80002cb2:	d1a48493          	addi	s1,s1,-742 # 800159c8 <bcache+0x18>
    b->next = bcache.head.next;
    80002cb6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002cb8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002cba:	00004a17          	auipc	s4,0x4
    80002cbe:	6dea0a13          	addi	s4,s4,1758 # 80007398 <etext+0x398>
    b->next = bcache.head.next;
    80002cc2:	2b893783          	ld	a5,696(s2)
    80002cc6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002cc8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ccc:	85d2                	mv	a1,s4
    80002cce:	01048513          	addi	a0,s1,16
    80002cd2:	328010ef          	jal	80003ffa <initsleeplock>
    bcache.head.next->prev = b;
    80002cd6:	2b893783          	ld	a5,696(s2)
    80002cda:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002cdc:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002ce0:	45848493          	addi	s1,s1,1112
    80002ce4:	fd349fe3          	bne	s1,s3,80002cc2 <binit+0x50>
  }
}
    80002ce8:	70a2                	ld	ra,40(sp)
    80002cea:	7402                	ld	s0,32(sp)
    80002cec:	64e2                	ld	s1,24(sp)
    80002cee:	6942                	ld	s2,16(sp)
    80002cf0:	69a2                	ld	s3,8(sp)
    80002cf2:	6a02                	ld	s4,0(sp)
    80002cf4:	6145                	addi	sp,sp,48
    80002cf6:	8082                	ret

0000000080002cf8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002cf8:	7179                	addi	sp,sp,-48
    80002cfa:	f406                	sd	ra,40(sp)
    80002cfc:	f022                	sd	s0,32(sp)
    80002cfe:	ec26                	sd	s1,24(sp)
    80002d00:	e84a                	sd	s2,16(sp)
    80002d02:	e44e                	sd	s3,8(sp)
    80002d04:	1800                	addi	s0,sp,48
    80002d06:	892a                	mv	s2,a0
    80002d08:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002d0a:	00013517          	auipc	a0,0x13
    80002d0e:	ca650513          	addi	a0,a0,-858 # 800159b0 <bcache>
    80002d12:	ef3fd0ef          	jal	80000c04 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002d16:	0001b497          	auipc	s1,0x1b
    80002d1a:	f524b483          	ld	s1,-174(s1) # 8001dc68 <bcache+0x82b8>
    80002d1e:	0001b797          	auipc	a5,0x1b
    80002d22:	efa78793          	addi	a5,a5,-262 # 8001dc18 <bcache+0x8268>
    80002d26:	02f48b63          	beq	s1,a5,80002d5c <bread+0x64>
    80002d2a:	873e                	mv	a4,a5
    80002d2c:	a021                	j	80002d34 <bread+0x3c>
    80002d2e:	68a4                	ld	s1,80(s1)
    80002d30:	02e48663          	beq	s1,a4,80002d5c <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002d34:	449c                	lw	a5,8(s1)
    80002d36:	ff279ce3          	bne	a5,s2,80002d2e <bread+0x36>
    80002d3a:	44dc                	lw	a5,12(s1)
    80002d3c:	ff3799e3          	bne	a5,s3,80002d2e <bread+0x36>
      b->refcnt++;
    80002d40:	40bc                	lw	a5,64(s1)
    80002d42:	2785                	addiw	a5,a5,1
    80002d44:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d46:	00013517          	auipc	a0,0x13
    80002d4a:	c6a50513          	addi	a0,a0,-918 # 800159b0 <bcache>
    80002d4e:	f47fd0ef          	jal	80000c94 <release>
      acquiresleep(&b->lock);
    80002d52:	01048513          	addi	a0,s1,16
    80002d56:	2da010ef          	jal	80004030 <acquiresleep>
      return b;
    80002d5a:	a889                	j	80002dac <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002d5c:	0001b497          	auipc	s1,0x1b
    80002d60:	f044b483          	ld	s1,-252(s1) # 8001dc60 <bcache+0x82b0>
    80002d64:	0001b797          	auipc	a5,0x1b
    80002d68:	eb478793          	addi	a5,a5,-332 # 8001dc18 <bcache+0x8268>
    80002d6c:	00f48863          	beq	s1,a5,80002d7c <bread+0x84>
    80002d70:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002d72:	40bc                	lw	a5,64(s1)
    80002d74:	cb91                	beqz	a5,80002d88 <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002d76:	64a4                	ld	s1,72(s1)
    80002d78:	fee49de3          	bne	s1,a4,80002d72 <bread+0x7a>
  panic("bget: no buffers");
    80002d7c:	00004517          	auipc	a0,0x4
    80002d80:	62450513          	addi	a0,a0,1572 # 800073a0 <etext+0x3a0>
    80002d84:	a95fd0ef          	jal	80000818 <panic>
      b->dev = dev;
    80002d88:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d8c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d90:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d94:	4785                	li	a5,1
    80002d96:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d98:	00013517          	auipc	a0,0x13
    80002d9c:	c1850513          	addi	a0,a0,-1000 # 800159b0 <bcache>
    80002da0:	ef5fd0ef          	jal	80000c94 <release>
      acquiresleep(&b->lock);
    80002da4:	01048513          	addi	a0,s1,16
    80002da8:	288010ef          	jal	80004030 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002dac:	409c                	lw	a5,0(s1)
    80002dae:	cb89                	beqz	a5,80002dc0 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002db0:	8526                	mv	a0,s1
    80002db2:	70a2                	ld	ra,40(sp)
    80002db4:	7402                	ld	s0,32(sp)
    80002db6:	64e2                	ld	s1,24(sp)
    80002db8:	6942                	ld	s2,16(sp)
    80002dba:	69a2                	ld	s3,8(sp)
    80002dbc:	6145                	addi	sp,sp,48
    80002dbe:	8082                	ret
    virtio_disk_rw(b, 0);
    80002dc0:	4581                	li	a1,0
    80002dc2:	8526                	mv	a0,s1
    80002dc4:	2ed020ef          	jal	800058b0 <virtio_disk_rw>
    b->valid = 1;
    80002dc8:	4785                	li	a5,1
    80002dca:	c09c                	sw	a5,0(s1)
  return b;
    80002dcc:	b7d5                	j	80002db0 <bread+0xb8>

0000000080002dce <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002dce:	1101                	addi	sp,sp,-32
    80002dd0:	ec06                	sd	ra,24(sp)
    80002dd2:	e822                	sd	s0,16(sp)
    80002dd4:	e426                	sd	s1,8(sp)
    80002dd6:	1000                	addi	s0,sp,32
    80002dd8:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002dda:	0541                	addi	a0,a0,16
    80002ddc:	2d2010ef          	jal	800040ae <holdingsleep>
    80002de0:	c911                	beqz	a0,80002df4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002de2:	4585                	li	a1,1
    80002de4:	8526                	mv	a0,s1
    80002de6:	2cb020ef          	jal	800058b0 <virtio_disk_rw>
}
    80002dea:	60e2                	ld	ra,24(sp)
    80002dec:	6442                	ld	s0,16(sp)
    80002dee:	64a2                	ld	s1,8(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret
    panic("bwrite");
    80002df4:	00004517          	auipc	a0,0x4
    80002df8:	5c450513          	addi	a0,a0,1476 # 800073b8 <etext+0x3b8>
    80002dfc:	a1dfd0ef          	jal	80000818 <panic>

0000000080002e00 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002e00:	1101                	addi	sp,sp,-32
    80002e02:	ec06                	sd	ra,24(sp)
    80002e04:	e822                	sd	s0,16(sp)
    80002e06:	e426                	sd	s1,8(sp)
    80002e08:	e04a                	sd	s2,0(sp)
    80002e0a:	1000                	addi	s0,sp,32
    80002e0c:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002e0e:	01050913          	addi	s2,a0,16
    80002e12:	854a                	mv	a0,s2
    80002e14:	29a010ef          	jal	800040ae <holdingsleep>
    80002e18:	c125                	beqz	a0,80002e78 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002e1a:	854a                	mv	a0,s2
    80002e1c:	25a010ef          	jal	80004076 <releasesleep>

  acquire(&bcache.lock);
    80002e20:	00013517          	auipc	a0,0x13
    80002e24:	b9050513          	addi	a0,a0,-1136 # 800159b0 <bcache>
    80002e28:	dddfd0ef          	jal	80000c04 <acquire>
  b->refcnt--;
    80002e2c:	40bc                	lw	a5,64(s1)
    80002e2e:	37fd                	addiw	a5,a5,-1
    80002e30:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e32:	e79d                	bnez	a5,80002e60 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e34:	68b8                	ld	a4,80(s1)
    80002e36:	64bc                	ld	a5,72(s1)
    80002e38:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e3a:	68b8                	ld	a4,80(s1)
    80002e3c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e3e:	0001b797          	auipc	a5,0x1b
    80002e42:	b7278793          	addi	a5,a5,-1166 # 8001d9b0 <bcache+0x8000>
    80002e46:	2b87b703          	ld	a4,696(a5)
    80002e4a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e4c:	0001b717          	auipc	a4,0x1b
    80002e50:	dcc70713          	addi	a4,a4,-564 # 8001dc18 <bcache+0x8268>
    80002e54:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e56:	2b87b703          	ld	a4,696(a5)
    80002e5a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e5c:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002e60:	00013517          	auipc	a0,0x13
    80002e64:	b5050513          	addi	a0,a0,-1200 # 800159b0 <bcache>
    80002e68:	e2dfd0ef          	jal	80000c94 <release>
}
    80002e6c:	60e2                	ld	ra,24(sp)
    80002e6e:	6442                	ld	s0,16(sp)
    80002e70:	64a2                	ld	s1,8(sp)
    80002e72:	6902                	ld	s2,0(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret
    panic("brelse");
    80002e78:	00004517          	auipc	a0,0x4
    80002e7c:	54850513          	addi	a0,a0,1352 # 800073c0 <etext+0x3c0>
    80002e80:	999fd0ef          	jal	80000818 <panic>

0000000080002e84 <bpin>:

void
bpin(struct buf *b)
{
    80002e84:	1101                	addi	sp,sp,-32
    80002e86:	ec06                	sd	ra,24(sp)
    80002e88:	e822                	sd	s0,16(sp)
    80002e8a:	e426                	sd	s1,8(sp)
    80002e8c:	1000                	addi	s0,sp,32
    80002e8e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e90:	00013517          	auipc	a0,0x13
    80002e94:	b2050513          	addi	a0,a0,-1248 # 800159b0 <bcache>
    80002e98:	d6dfd0ef          	jal	80000c04 <acquire>
  b->refcnt++;
    80002e9c:	40bc                	lw	a5,64(s1)
    80002e9e:	2785                	addiw	a5,a5,1
    80002ea0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ea2:	00013517          	auipc	a0,0x13
    80002ea6:	b0e50513          	addi	a0,a0,-1266 # 800159b0 <bcache>
    80002eaa:	debfd0ef          	jal	80000c94 <release>
}
    80002eae:	60e2                	ld	ra,24(sp)
    80002eb0:	6442                	ld	s0,16(sp)
    80002eb2:	64a2                	ld	s1,8(sp)
    80002eb4:	6105                	addi	sp,sp,32
    80002eb6:	8082                	ret

0000000080002eb8 <bunpin>:

void
bunpin(struct buf *b)
{
    80002eb8:	1101                	addi	sp,sp,-32
    80002eba:	ec06                	sd	ra,24(sp)
    80002ebc:	e822                	sd	s0,16(sp)
    80002ebe:	e426                	sd	s1,8(sp)
    80002ec0:	1000                	addi	s0,sp,32
    80002ec2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ec4:	00013517          	auipc	a0,0x13
    80002ec8:	aec50513          	addi	a0,a0,-1300 # 800159b0 <bcache>
    80002ecc:	d39fd0ef          	jal	80000c04 <acquire>
  b->refcnt--;
    80002ed0:	40bc                	lw	a5,64(s1)
    80002ed2:	37fd                	addiw	a5,a5,-1
    80002ed4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ed6:	00013517          	auipc	a0,0x13
    80002eda:	ada50513          	addi	a0,a0,-1318 # 800159b0 <bcache>
    80002ede:	db7fd0ef          	jal	80000c94 <release>
}
    80002ee2:	60e2                	ld	ra,24(sp)
    80002ee4:	6442                	ld	s0,16(sp)
    80002ee6:	64a2                	ld	s1,8(sp)
    80002ee8:	6105                	addi	sp,sp,32
    80002eea:	8082                	ret

0000000080002eec <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002eec:	1101                	addi	sp,sp,-32
    80002eee:	ec06                	sd	ra,24(sp)
    80002ef0:	e822                	sd	s0,16(sp)
    80002ef2:	e426                	sd	s1,8(sp)
    80002ef4:	e04a                	sd	s2,0(sp)
    80002ef6:	1000                	addi	s0,sp,32
    80002ef8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002efa:	00d5d79b          	srliw	a5,a1,0xd
    80002efe:	0001b597          	auipc	a1,0x1b
    80002f02:	18e5a583          	lw	a1,398(a1) # 8001e08c <sb+0x1c>
    80002f06:	9dbd                	addw	a1,a1,a5
    80002f08:	df1ff0ef          	jal	80002cf8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002f0c:	0074f713          	andi	a4,s1,7
    80002f10:	4785                	li	a5,1
    80002f12:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002f16:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002f18:	90d9                	srli	s1,s1,0x36
    80002f1a:	00950733          	add	a4,a0,s1
    80002f1e:	05874703          	lbu	a4,88(a4)
    80002f22:	00e7f6b3          	and	a3,a5,a4
    80002f26:	c29d                	beqz	a3,80002f4c <bfree+0x60>
    80002f28:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002f2a:	94aa                	add	s1,s1,a0
    80002f2c:	fff7c793          	not	a5,a5
    80002f30:	8f7d                	and	a4,a4,a5
    80002f32:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f36:	000010ef          	jal	80003f36 <log_write>
  brelse(bp);
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	ec5ff0ef          	jal	80002e00 <brelse>
}
    80002f40:	60e2                	ld	ra,24(sp)
    80002f42:	6442                	ld	s0,16(sp)
    80002f44:	64a2                	ld	s1,8(sp)
    80002f46:	6902                	ld	s2,0(sp)
    80002f48:	6105                	addi	sp,sp,32
    80002f4a:	8082                	ret
    panic("freeing free block");
    80002f4c:	00004517          	auipc	a0,0x4
    80002f50:	47c50513          	addi	a0,a0,1148 # 800073c8 <etext+0x3c8>
    80002f54:	8c5fd0ef          	jal	80000818 <panic>

0000000080002f58 <balloc>:
{
    80002f58:	715d                	addi	sp,sp,-80
    80002f5a:	e486                	sd	ra,72(sp)
    80002f5c:	e0a2                	sd	s0,64(sp)
    80002f5e:	fc26                	sd	s1,56(sp)
    80002f60:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002f62:	0001b797          	auipc	a5,0x1b
    80002f66:	1127a783          	lw	a5,274(a5) # 8001e074 <sb+0x4>
    80002f6a:	0e078263          	beqz	a5,8000304e <balloc+0xf6>
    80002f6e:	f84a                	sd	s2,48(sp)
    80002f70:	f44e                	sd	s3,40(sp)
    80002f72:	f052                	sd	s4,32(sp)
    80002f74:	ec56                	sd	s5,24(sp)
    80002f76:	e85a                	sd	s6,16(sp)
    80002f78:	e45e                	sd	s7,8(sp)
    80002f7a:	e062                	sd	s8,0(sp)
    80002f7c:	8baa                	mv	s7,a0
    80002f7e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f80:	0001bb17          	auipc	s6,0x1b
    80002f84:	0f0b0b13          	addi	s6,s6,240 # 8001e070 <sb>
      m = 1 << (bi % 8);
    80002f88:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002f8a:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002f8c:	6c09                	lui	s8,0x2
    80002f8e:	a09d                	j	80002ff4 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002f90:	97ca                	add	a5,a5,s2
    80002f92:	8e55                	or	a2,a2,a3
    80002f94:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f98:	854a                	mv	a0,s2
    80002f9a:	79d000ef          	jal	80003f36 <log_write>
        brelse(bp);
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	e61ff0ef          	jal	80002e00 <brelse>
  bp = bread(dev, bno);
    80002fa4:	85a6                	mv	a1,s1
    80002fa6:	855e                	mv	a0,s7
    80002fa8:	d51ff0ef          	jal	80002cf8 <bread>
    80002fac:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002fae:	40000613          	li	a2,1024
    80002fb2:	4581                	li	a1,0
    80002fb4:	05850513          	addi	a0,a0,88
    80002fb8:	d15fd0ef          	jal	80000ccc <memset>
  log_write(bp);
    80002fbc:	854a                	mv	a0,s2
    80002fbe:	779000ef          	jal	80003f36 <log_write>
  brelse(bp);
    80002fc2:	854a                	mv	a0,s2
    80002fc4:	e3dff0ef          	jal	80002e00 <brelse>
}
    80002fc8:	7942                	ld	s2,48(sp)
    80002fca:	79a2                	ld	s3,40(sp)
    80002fcc:	7a02                	ld	s4,32(sp)
    80002fce:	6ae2                	ld	s5,24(sp)
    80002fd0:	6b42                	ld	s6,16(sp)
    80002fd2:	6ba2                	ld	s7,8(sp)
    80002fd4:	6c02                	ld	s8,0(sp)
}
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	60a6                	ld	ra,72(sp)
    80002fda:	6406                	ld	s0,64(sp)
    80002fdc:	74e2                	ld	s1,56(sp)
    80002fde:	6161                	addi	sp,sp,80
    80002fe0:	8082                	ret
    brelse(bp);
    80002fe2:	854a                	mv	a0,s2
    80002fe4:	e1dff0ef          	jal	80002e00 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002fe8:	015c0abb          	addw	s5,s8,s5
    80002fec:	004b2783          	lw	a5,4(s6)
    80002ff0:	04faf863          	bgeu	s5,a5,80003040 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002ff4:	40dad59b          	sraiw	a1,s5,0xd
    80002ff8:	01cb2783          	lw	a5,28(s6)
    80002ffc:	9dbd                	addw	a1,a1,a5
    80002ffe:	855e                	mv	a0,s7
    80003000:	cf9ff0ef          	jal	80002cf8 <bread>
    80003004:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003006:	004b2503          	lw	a0,4(s6)
    8000300a:	84d6                	mv	s1,s5
    8000300c:	4701                	li	a4,0
    8000300e:	fca4fae3          	bgeu	s1,a0,80002fe2 <balloc+0x8a>
      m = 1 << (bi % 8);
    80003012:	00777693          	andi	a3,a4,7
    80003016:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    8000301a:	41f7579b          	sraiw	a5,a4,0x1f
    8000301e:	01d7d79b          	srliw	a5,a5,0x1d
    80003022:	9fb9                	addw	a5,a5,a4
    80003024:	4037d79b          	sraiw	a5,a5,0x3
    80003028:	00f90633          	add	a2,s2,a5
    8000302c:	05864603          	lbu	a2,88(a2)
    80003030:	00c6f5b3          	and	a1,a3,a2
    80003034:	ddb1                	beqz	a1,80002f90 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003036:	2705                	addiw	a4,a4,1
    80003038:	2485                	addiw	s1,s1,1
    8000303a:	fd471ae3          	bne	a4,s4,8000300e <balloc+0xb6>
    8000303e:	b755                	j	80002fe2 <balloc+0x8a>
    80003040:	7942                	ld	s2,48(sp)
    80003042:	79a2                	ld	s3,40(sp)
    80003044:	7a02                	ld	s4,32(sp)
    80003046:	6ae2                	ld	s5,24(sp)
    80003048:	6b42                	ld	s6,16(sp)
    8000304a:	6ba2                	ld	s7,8(sp)
    8000304c:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    8000304e:	00004517          	auipc	a0,0x4
    80003052:	39250513          	addi	a0,a0,914 # 800073e0 <etext+0x3e0>
    80003056:	c98fd0ef          	jal	800004ee <printk>
  return 0;
    8000305a:	4481                	li	s1,0
    8000305c:	bfad                	j	80002fd6 <balloc+0x7e>

000000008000305e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000305e:	7179                	addi	sp,sp,-48
    80003060:	f406                	sd	ra,40(sp)
    80003062:	f022                	sd	s0,32(sp)
    80003064:	ec26                	sd	s1,24(sp)
    80003066:	e84a                	sd	s2,16(sp)
    80003068:	e44e                	sd	s3,8(sp)
    8000306a:	1800                	addi	s0,sp,48
    8000306c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    8000306e:	47ad                	li	a5,11
    80003070:	02b7e363          	bltu	a5,a1,80003096 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80003074:	02059793          	slli	a5,a1,0x20
    80003078:	01e7d593          	srli	a1,a5,0x1e
    8000307c:	00b509b3          	add	s3,a0,a1
    80003080:	0509a483          	lw	s1,80(s3)
    80003084:	e0b5                	bnez	s1,800030e8 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003086:	4108                	lw	a0,0(a0)
    80003088:	ed1ff0ef          	jal	80002f58 <balloc>
    8000308c:	84aa                	mv	s1,a0
      if (addr == 0)
    8000308e:	cd29                	beqz	a0,800030e8 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003090:	04a9a823          	sw	a0,80(s3)
    80003094:	a891                	j	800030e8 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003096:	ff45879b          	addiw	a5,a1,-12
    8000309a:	873e                	mv	a4,a5
    8000309c:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    8000309e:	0ff00793          	li	a5,255
    800030a2:	06e7e763          	bltu	a5,a4,80003110 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    800030a6:	08052483          	lw	s1,128(a0)
    800030aa:	e891                	bnez	s1,800030be <bmap+0x60>
      addr = balloc(ip->dev);
    800030ac:	4108                	lw	a0,0(a0)
    800030ae:	eabff0ef          	jal	80002f58 <balloc>
    800030b2:	84aa                	mv	s1,a0
      if (addr == 0)
    800030b4:	c915                	beqz	a0,800030e8 <bmap+0x8a>
    800030b6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800030b8:	08a92023          	sw	a0,128(s2)
    800030bc:	a011                	j	800030c0 <bmap+0x62>
    800030be:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800030c0:	85a6                	mv	a1,s1
    800030c2:	00092503          	lw	a0,0(s2)
    800030c6:	c33ff0ef          	jal	80002cf8 <bread>
    800030ca:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    800030cc:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800030d0:	02099713          	slli	a4,s3,0x20
    800030d4:	01e75593          	srli	a1,a4,0x1e
    800030d8:	97ae                	add	a5,a5,a1
    800030da:	89be                	mv	s3,a5
    800030dc:	4384                	lw	s1,0(a5)
    800030de:	cc89                	beqz	s1,800030f8 <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800030e0:	8552                	mv	a0,s4
    800030e2:	d1fff0ef          	jal	80002e00 <brelse>
    return addr;
    800030e6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800030e8:	8526                	mv	a0,s1
    800030ea:	70a2                	ld	ra,40(sp)
    800030ec:	7402                	ld	s0,32(sp)
    800030ee:	64e2                	ld	s1,24(sp)
    800030f0:	6942                	ld	s2,16(sp)
    800030f2:	69a2                	ld	s3,8(sp)
    800030f4:	6145                	addi	sp,sp,48
    800030f6:	8082                	ret
      addr = balloc(ip->dev);
    800030f8:	00092503          	lw	a0,0(s2)
    800030fc:	e5dff0ef          	jal	80002f58 <balloc>
    80003100:	84aa                	mv	s1,a0
      if (addr) {
    80003102:	dd79                	beqz	a0,800030e0 <bmap+0x82>
        a[bn] = addr;
    80003104:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003108:	8552                	mv	a0,s4
    8000310a:	62d000ef          	jal	80003f36 <log_write>
    8000310e:	bfc9                	j	800030e0 <bmap+0x82>
    80003110:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003112:	00004517          	auipc	a0,0x4
    80003116:	2e650513          	addi	a0,a0,742 # 800073f8 <etext+0x3f8>
    8000311a:	efefd0ef          	jal	80000818 <panic>

000000008000311e <iget>:
{
    8000311e:	7179                	addi	sp,sp,-48
    80003120:	f406                	sd	ra,40(sp)
    80003122:	f022                	sd	s0,32(sp)
    80003124:	ec26                	sd	s1,24(sp)
    80003126:	e84a                	sd	s2,16(sp)
    80003128:	e44e                	sd	s3,8(sp)
    8000312a:	e052                	sd	s4,0(sp)
    8000312c:	1800                	addi	s0,sp,48
    8000312e:	892a                	mv	s2,a0
    80003130:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003132:	0001b517          	auipc	a0,0x1b
    80003136:	f5e50513          	addi	a0,a0,-162 # 8001e090 <itable>
    8000313a:	acbfd0ef          	jal	80000c04 <acquire>
  empty = 0;
    8000313e:	4981                	li	s3,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003140:	0001b497          	auipc	s1,0x1b
    80003144:	f6848493          	addi	s1,s1,-152 # 8001e0a8 <itable+0x18>
    80003148:	0001d697          	auipc	a3,0x1d
    8000314c:	9f068693          	addi	a3,a3,-1552 # 8001fb38 <log>
    80003150:	a809                	j	80003162 <iget+0x44>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003152:	e781                	bnez	a5,8000315a <iget+0x3c>
    80003154:	00099363          	bnez	s3,8000315a <iget+0x3c>
      empty = ip;
    80003158:	89a6                	mv	s3,s1
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000315a:	08848493          	addi	s1,s1,136
    8000315e:	02d48563          	beq	s1,a3,80003188 <iget+0x6a>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80003162:	449c                	lw	a5,8(s1)
    80003164:	fef057e3          	blez	a5,80003152 <iget+0x34>
    80003168:	4098                	lw	a4,0(s1)
    8000316a:	ff2718e3          	bne	a4,s2,8000315a <iget+0x3c>
    8000316e:	40d8                	lw	a4,4(s1)
    80003170:	ff4715e3          	bne	a4,s4,8000315a <iget+0x3c>
      ip->ref++;
    80003174:	2785                	addiw	a5,a5,1
    80003176:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003178:	0001b517          	auipc	a0,0x1b
    8000317c:	f1850513          	addi	a0,a0,-232 # 8001e090 <itable>
    80003180:	b15fd0ef          	jal	80000c94 <release>
      return ip;
    80003184:	89a6                	mv	s3,s1
    80003186:	a015                	j	800031aa <iget+0x8c>
  if (empty == 0)
    80003188:	02098a63          	beqz	s3,800031bc <iget+0x9e>
  ip->dev = dev;
    8000318c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003190:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003194:	4785                	li	a5,1
    80003196:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000319a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000319e:	0001b517          	auipc	a0,0x1b
    800031a2:	ef250513          	addi	a0,a0,-270 # 8001e090 <itable>
    800031a6:	aeffd0ef          	jal	80000c94 <release>
}
    800031aa:	854e                	mv	a0,s3
    800031ac:	70a2                	ld	ra,40(sp)
    800031ae:	7402                	ld	s0,32(sp)
    800031b0:	64e2                	ld	s1,24(sp)
    800031b2:	6942                	ld	s2,16(sp)
    800031b4:	69a2                	ld	s3,8(sp)
    800031b6:	6a02                	ld	s4,0(sp)
    800031b8:	6145                	addi	sp,sp,48
    800031ba:	8082                	ret
    panic("iget: no inodes");
    800031bc:	00004517          	auipc	a0,0x4
    800031c0:	25450513          	addi	a0,a0,596 # 80007410 <etext+0x410>
    800031c4:	e54fd0ef          	jal	80000818 <panic>

00000000800031c8 <iinit>:
{
    800031c8:	7179                	addi	sp,sp,-48
    800031ca:	f406                	sd	ra,40(sp)
    800031cc:	f022                	sd	s0,32(sp)
    800031ce:	ec26                	sd	s1,24(sp)
    800031d0:	e84a                	sd	s2,16(sp)
    800031d2:	e44e                	sd	s3,8(sp)
    800031d4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800031d6:	00004597          	auipc	a1,0x4
    800031da:	24a58593          	addi	a1,a1,586 # 80007420 <etext+0x420>
    800031de:	0001b517          	auipc	a0,0x1b
    800031e2:	eb250513          	addi	a0,a0,-334 # 8001e090 <itable>
    800031e6:	995fd0ef          	jal	80000b7a <initlock>
  for (i = 0; i < NINODE; i++) {
    800031ea:	0001b497          	auipc	s1,0x1b
    800031ee:	ece48493          	addi	s1,s1,-306 # 8001e0b8 <itable+0x28>
    800031f2:	0001d997          	auipc	s3,0x1d
    800031f6:	95698993          	addi	s3,s3,-1706 # 8001fb48 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800031fa:	00004917          	auipc	s2,0x4
    800031fe:	22e90913          	addi	s2,s2,558 # 80007428 <etext+0x428>
    80003202:	85ca                	mv	a1,s2
    80003204:	8526                	mv	a0,s1
    80003206:	5f5000ef          	jal	80003ffa <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    8000320a:	08848493          	addi	s1,s1,136
    8000320e:	ff349ae3          	bne	s1,s3,80003202 <iinit+0x3a>
}
    80003212:	70a2                	ld	ra,40(sp)
    80003214:	7402                	ld	s0,32(sp)
    80003216:	64e2                	ld	s1,24(sp)
    80003218:	6942                	ld	s2,16(sp)
    8000321a:	69a2                	ld	s3,8(sp)
    8000321c:	6145                	addi	sp,sp,48
    8000321e:	8082                	ret

0000000080003220 <ialloc>:
{
    80003220:	7139                	addi	sp,sp,-64
    80003222:	fc06                	sd	ra,56(sp)
    80003224:	f822                	sd	s0,48(sp)
    80003226:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003228:	0001b717          	auipc	a4,0x1b
    8000322c:	e5472703          	lw	a4,-428(a4) # 8001e07c <sb+0xc>
    80003230:	4785                	li	a5,1
    80003232:	06e7f063          	bgeu	a5,a4,80003292 <ialloc+0x72>
    80003236:	f426                	sd	s1,40(sp)
    80003238:	f04a                	sd	s2,32(sp)
    8000323a:	ec4e                	sd	s3,24(sp)
    8000323c:	e852                	sd	s4,16(sp)
    8000323e:	e456                	sd	s5,8(sp)
    80003240:	e05a                	sd	s6,0(sp)
    80003242:	8aaa                	mv	s5,a0
    80003244:	8b2e                	mv	s6,a1
    80003246:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003248:	0001ba17          	auipc	s4,0x1b
    8000324c:	e28a0a13          	addi	s4,s4,-472 # 8001e070 <sb>
    80003250:	00495593          	srli	a1,s2,0x4
    80003254:	018a2783          	lw	a5,24(s4)
    80003258:	9dbd                	addw	a1,a1,a5
    8000325a:	8556                	mv	a0,s5
    8000325c:	a9dff0ef          	jal	80002cf8 <bread>
    80003260:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003262:	05850993          	addi	s3,a0,88
    80003266:	00f97793          	andi	a5,s2,15
    8000326a:	079a                	slli	a5,a5,0x6
    8000326c:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    8000326e:	00099783          	lh	a5,0(s3)
    80003272:	cb9d                	beqz	a5,800032a8 <ialloc+0x88>
    brelse(bp);
    80003274:	b8dff0ef          	jal	80002e00 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003278:	0905                	addi	s2,s2,1
    8000327a:	00ca2703          	lw	a4,12(s4)
    8000327e:	0009079b          	sext.w	a5,s2
    80003282:	fce7e7e3          	bltu	a5,a4,80003250 <ialloc+0x30>
    80003286:	74a2                	ld	s1,40(sp)
    80003288:	7902                	ld	s2,32(sp)
    8000328a:	69e2                	ld	s3,24(sp)
    8000328c:	6a42                	ld	s4,16(sp)
    8000328e:	6aa2                	ld	s5,8(sp)
    80003290:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003292:	00004517          	auipc	a0,0x4
    80003296:	19e50513          	addi	a0,a0,414 # 80007430 <etext+0x430>
    8000329a:	a54fd0ef          	jal	800004ee <printk>
  return 0;
    8000329e:	4501                	li	a0,0
}
    800032a0:	70e2                	ld	ra,56(sp)
    800032a2:	7442                	ld	s0,48(sp)
    800032a4:	6121                	addi	sp,sp,64
    800032a6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800032a8:	04000613          	li	a2,64
    800032ac:	4581                	li	a1,0
    800032ae:	854e                	mv	a0,s3
    800032b0:	a1dfd0ef          	jal	80000ccc <memset>
      dip->type = type;
    800032b4:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    800032b8:	8526                	mv	a0,s1
    800032ba:	47d000ef          	jal	80003f36 <log_write>
      brelse(bp);
    800032be:	8526                	mv	a0,s1
    800032c0:	b41ff0ef          	jal	80002e00 <brelse>
      return iget(dev, inum);
    800032c4:	0009059b          	sext.w	a1,s2
    800032c8:	8556                	mv	a0,s5
    800032ca:	e55ff0ef          	jal	8000311e <iget>
    800032ce:	74a2                	ld	s1,40(sp)
    800032d0:	7902                	ld	s2,32(sp)
    800032d2:	69e2                	ld	s3,24(sp)
    800032d4:	6a42                	ld	s4,16(sp)
    800032d6:	6aa2                	ld	s5,8(sp)
    800032d8:	6b02                	ld	s6,0(sp)
    800032da:	b7d9                	j	800032a0 <ialloc+0x80>

00000000800032dc <iupdate>:
{
    800032dc:	1101                	addi	sp,sp,-32
    800032de:	ec06                	sd	ra,24(sp)
    800032e0:	e822                	sd	s0,16(sp)
    800032e2:	e426                	sd	s1,8(sp)
    800032e4:	e04a                	sd	s2,0(sp)
    800032e6:	1000                	addi	s0,sp,32
    800032e8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032ea:	415c                	lw	a5,4(a0)
    800032ec:	0047d79b          	srliw	a5,a5,0x4
    800032f0:	0001b597          	auipc	a1,0x1b
    800032f4:	d985a583          	lw	a1,-616(a1) # 8001e088 <sb+0x18>
    800032f8:	9dbd                	addw	a1,a1,a5
    800032fa:	4108                	lw	a0,0(a0)
    800032fc:	9fdff0ef          	jal	80002cf8 <bread>
    80003300:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003302:	05850793          	addi	a5,a0,88
    80003306:	40d8                	lw	a4,4(s1)
    80003308:	8b3d                	andi	a4,a4,15
    8000330a:	071a                	slli	a4,a4,0x6
    8000330c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000330e:	04449703          	lh	a4,68(s1)
    80003312:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003316:	04649703          	lh	a4,70(s1)
    8000331a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000331e:	04849703          	lh	a4,72(s1)
    80003322:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003326:	04a49703          	lh	a4,74(s1)
    8000332a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000332e:	44f8                	lw	a4,76(s1)
    80003330:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003332:	03400613          	li	a2,52
    80003336:	05048593          	addi	a1,s1,80
    8000333a:	00c78513          	addi	a0,a5,12
    8000333e:	9effd0ef          	jal	80000d2c <memmove>
  log_write(bp);
    80003342:	854a                	mv	a0,s2
    80003344:	3f3000ef          	jal	80003f36 <log_write>
  brelse(bp);
    80003348:	854a                	mv	a0,s2
    8000334a:	ab7ff0ef          	jal	80002e00 <brelse>
}
    8000334e:	60e2                	ld	ra,24(sp)
    80003350:	6442                	ld	s0,16(sp)
    80003352:	64a2                	ld	s1,8(sp)
    80003354:	6902                	ld	s2,0(sp)
    80003356:	6105                	addi	sp,sp,32
    80003358:	8082                	ret

000000008000335a <idup>:
{
    8000335a:	1101                	addi	sp,sp,-32
    8000335c:	ec06                	sd	ra,24(sp)
    8000335e:	e822                	sd	s0,16(sp)
    80003360:	e426                	sd	s1,8(sp)
    80003362:	1000                	addi	s0,sp,32
    80003364:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003366:	0001b517          	auipc	a0,0x1b
    8000336a:	d2a50513          	addi	a0,a0,-726 # 8001e090 <itable>
    8000336e:	897fd0ef          	jal	80000c04 <acquire>
  ip->ref++;
    80003372:	449c                	lw	a5,8(s1)
    80003374:	2785                	addiw	a5,a5,1
    80003376:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003378:	0001b517          	auipc	a0,0x1b
    8000337c:	d1850513          	addi	a0,a0,-744 # 8001e090 <itable>
    80003380:	915fd0ef          	jal	80000c94 <release>
}
    80003384:	8526                	mv	a0,s1
    80003386:	60e2                	ld	ra,24(sp)
    80003388:	6442                	ld	s0,16(sp)
    8000338a:	64a2                	ld	s1,8(sp)
    8000338c:	6105                	addi	sp,sp,32
    8000338e:	8082                	ret

0000000080003390 <ilock>:
{
    80003390:	1101                	addi	sp,sp,-32
    80003392:	ec06                	sd	ra,24(sp)
    80003394:	e822                	sd	s0,16(sp)
    80003396:	e426                	sd	s1,8(sp)
    80003398:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    8000339a:	cd19                	beqz	a0,800033b8 <ilock+0x28>
    8000339c:	84aa                	mv	s1,a0
    8000339e:	451c                	lw	a5,8(a0)
    800033a0:	00f05c63          	blez	a5,800033b8 <ilock+0x28>
  acquiresleep(&ip->lock);
    800033a4:	0541                	addi	a0,a0,16
    800033a6:	48b000ef          	jal	80004030 <acquiresleep>
  if (ip->valid == 0) {
    800033aa:	40bc                	lw	a5,64(s1)
    800033ac:	cf89                	beqz	a5,800033c6 <ilock+0x36>
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	64a2                	ld	s1,8(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret
    800033b8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800033ba:	00004517          	auipc	a0,0x4
    800033be:	08e50513          	addi	a0,a0,142 # 80007448 <etext+0x448>
    800033c2:	c56fd0ef          	jal	80000818 <panic>
    800033c6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033c8:	40dc                	lw	a5,4(s1)
    800033ca:	0047d79b          	srliw	a5,a5,0x4
    800033ce:	0001b597          	auipc	a1,0x1b
    800033d2:	cba5a583          	lw	a1,-838(a1) # 8001e088 <sb+0x18>
    800033d6:	9dbd                	addw	a1,a1,a5
    800033d8:	4088                	lw	a0,0(s1)
    800033da:	91fff0ef          	jal	80002cf8 <bread>
    800033de:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800033e0:	05850593          	addi	a1,a0,88
    800033e4:	40dc                	lw	a5,4(s1)
    800033e6:	8bbd                	andi	a5,a5,15
    800033e8:	079a                	slli	a5,a5,0x6
    800033ea:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800033ec:	00059783          	lh	a5,0(a1)
    800033f0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800033f4:	00259783          	lh	a5,2(a1)
    800033f8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800033fc:	00459783          	lh	a5,4(a1)
    80003400:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003404:	00659783          	lh	a5,6(a1)
    80003408:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000340c:	459c                	lw	a5,8(a1)
    8000340e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003410:	03400613          	li	a2,52
    80003414:	05b1                	addi	a1,a1,12
    80003416:	05048513          	addi	a0,s1,80
    8000341a:	913fd0ef          	jal	80000d2c <memmove>
    brelse(bp);
    8000341e:	854a                	mv	a0,s2
    80003420:	9e1ff0ef          	jal	80002e00 <brelse>
    ip->valid = 1;
    80003424:	4785                	li	a5,1
    80003426:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003428:	04449783          	lh	a5,68(s1)
    8000342c:	c399                	beqz	a5,80003432 <ilock+0xa2>
    8000342e:	6902                	ld	s2,0(sp)
    80003430:	bfbd                	j	800033ae <ilock+0x1e>
      panic("ilock: no type");
    80003432:	00004517          	auipc	a0,0x4
    80003436:	01e50513          	addi	a0,a0,30 # 80007450 <etext+0x450>
    8000343a:	bdefd0ef          	jal	80000818 <panic>

000000008000343e <iunlock>:
{
    8000343e:	1101                	addi	sp,sp,-32
    80003440:	ec06                	sd	ra,24(sp)
    80003442:	e822                	sd	s0,16(sp)
    80003444:	e426                	sd	s1,8(sp)
    80003446:	e04a                	sd	s2,0(sp)
    80003448:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000344a:	c505                	beqz	a0,80003472 <iunlock+0x34>
    8000344c:	84aa                	mv	s1,a0
    8000344e:	01050913          	addi	s2,a0,16
    80003452:	854a                	mv	a0,s2
    80003454:	45b000ef          	jal	800040ae <holdingsleep>
    80003458:	cd09                	beqz	a0,80003472 <iunlock+0x34>
    8000345a:	449c                	lw	a5,8(s1)
    8000345c:	00f05b63          	blez	a5,80003472 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003460:	854a                	mv	a0,s2
    80003462:	415000ef          	jal	80004076 <releasesleep>
}
    80003466:	60e2                	ld	ra,24(sp)
    80003468:	6442                	ld	s0,16(sp)
    8000346a:	64a2                	ld	s1,8(sp)
    8000346c:	6902                	ld	s2,0(sp)
    8000346e:	6105                	addi	sp,sp,32
    80003470:	8082                	ret
    panic("iunlock");
    80003472:	00004517          	auipc	a0,0x4
    80003476:	fee50513          	addi	a0,a0,-18 # 80007460 <etext+0x460>
    8000347a:	b9efd0ef          	jal	80000818 <panic>

000000008000347e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000347e:	7179                	addi	sp,sp,-48
    80003480:	f406                	sd	ra,40(sp)
    80003482:	f022                	sd	s0,32(sp)
    80003484:	ec26                	sd	s1,24(sp)
    80003486:	e84a                	sd	s2,16(sp)
    80003488:	e44e                	sd	s3,8(sp)
    8000348a:	1800                	addi	s0,sp,48
    8000348c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    8000348e:	05050493          	addi	s1,a0,80
    80003492:	08050913          	addi	s2,a0,128
    80003496:	a021                	j	8000349e <itrunc+0x20>
    80003498:	0491                	addi	s1,s1,4
    8000349a:	01248b63          	beq	s1,s2,800034b0 <itrunc+0x32>
    if (ip->addrs[i]) {
    8000349e:	408c                	lw	a1,0(s1)
    800034a0:	dde5                	beqz	a1,80003498 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800034a2:	0009a503          	lw	a0,0(s3)
    800034a6:	a47ff0ef          	jal	80002eec <bfree>
      ip->addrs[i] = 0;
    800034aa:	0004a023          	sw	zero,0(s1)
    800034ae:	b7ed                	j	80003498 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    800034b0:	0809a583          	lw	a1,128(s3)
    800034b4:	ed89                	bnez	a1,800034ce <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800034b6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800034ba:	854e                	mv	a0,s3
    800034bc:	e21ff0ef          	jal	800032dc <iupdate>
}
    800034c0:	70a2                	ld	ra,40(sp)
    800034c2:	7402                	ld	s0,32(sp)
    800034c4:	64e2                	ld	s1,24(sp)
    800034c6:	6942                	ld	s2,16(sp)
    800034c8:	69a2                	ld	s3,8(sp)
    800034ca:	6145                	addi	sp,sp,48
    800034cc:	8082                	ret
    800034ce:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800034d0:	0009a503          	lw	a0,0(s3)
    800034d4:	825ff0ef          	jal	80002cf8 <bread>
    800034d8:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    800034da:	05850493          	addi	s1,a0,88
    800034de:	45850913          	addi	s2,a0,1112
    800034e2:	a021                	j	800034ea <itrunc+0x6c>
    800034e4:	0491                	addi	s1,s1,4
    800034e6:	01248963          	beq	s1,s2,800034f8 <itrunc+0x7a>
      if (a[j])
    800034ea:	408c                	lw	a1,0(s1)
    800034ec:	dde5                	beqz	a1,800034e4 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800034ee:	0009a503          	lw	a0,0(s3)
    800034f2:	9fbff0ef          	jal	80002eec <bfree>
    800034f6:	b7fd                	j	800034e4 <itrunc+0x66>
    brelse(bp);
    800034f8:	8552                	mv	a0,s4
    800034fa:	907ff0ef          	jal	80002e00 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800034fe:	0809a583          	lw	a1,128(s3)
    80003502:	0009a503          	lw	a0,0(s3)
    80003506:	9e7ff0ef          	jal	80002eec <bfree>
    ip->addrs[NDIRECT] = 0;
    8000350a:	0809a023          	sw	zero,128(s3)
    8000350e:	6a02                	ld	s4,0(sp)
    80003510:	b75d                	j	800034b6 <itrunc+0x38>

0000000080003512 <iput>:
{
    80003512:	1101                	addi	sp,sp,-32
    80003514:	ec06                	sd	ra,24(sp)
    80003516:	e822                	sd	s0,16(sp)
    80003518:	e426                	sd	s1,8(sp)
    8000351a:	1000                	addi	s0,sp,32
    8000351c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000351e:	0001b517          	auipc	a0,0x1b
    80003522:	b7250513          	addi	a0,a0,-1166 # 8001e090 <itable>
    80003526:	edefd0ef          	jal	80000c04 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    8000352a:	4498                	lw	a4,8(s1)
    8000352c:	4785                	li	a5,1
    8000352e:	02f70063          	beq	a4,a5,8000354e <iput+0x3c>
  ip->ref--;
    80003532:	449c                	lw	a5,8(s1)
    80003534:	37fd                	addiw	a5,a5,-1
    80003536:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003538:	0001b517          	auipc	a0,0x1b
    8000353c:	b5850513          	addi	a0,a0,-1192 # 8001e090 <itable>
    80003540:	f54fd0ef          	jal	80000c94 <release>
}
    80003544:	60e2                	ld	ra,24(sp)
    80003546:	6442                	ld	s0,16(sp)
    80003548:	64a2                	ld	s1,8(sp)
    8000354a:	6105                	addi	sp,sp,32
    8000354c:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    8000354e:	40bc                	lw	a5,64(s1)
    80003550:	d3ed                	beqz	a5,80003532 <iput+0x20>
    80003552:	04a49783          	lh	a5,74(s1)
    80003556:	fff1                	bnez	a5,80003532 <iput+0x20>
    80003558:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000355a:	01048793          	addi	a5,s1,16
    8000355e:	893e                	mv	s2,a5
    80003560:	853e                	mv	a0,a5
    80003562:	2cf000ef          	jal	80004030 <acquiresleep>
    release(&itable.lock);
    80003566:	0001b517          	auipc	a0,0x1b
    8000356a:	b2a50513          	addi	a0,a0,-1238 # 8001e090 <itable>
    8000356e:	f26fd0ef          	jal	80000c94 <release>
    itrunc(ip);
    80003572:	8526                	mv	a0,s1
    80003574:	f0bff0ef          	jal	8000347e <itrunc>
    ip->type = 0;
    80003578:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000357c:	8526                	mv	a0,s1
    8000357e:	d5fff0ef          	jal	800032dc <iupdate>
    ip->valid = 0;
    80003582:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003586:	854a                	mv	a0,s2
    80003588:	2ef000ef          	jal	80004076 <releasesleep>
    acquire(&itable.lock);
    8000358c:	0001b517          	auipc	a0,0x1b
    80003590:	b0450513          	addi	a0,a0,-1276 # 8001e090 <itable>
    80003594:	e70fd0ef          	jal	80000c04 <acquire>
    80003598:	6902                	ld	s2,0(sp)
    8000359a:	bf61                	j	80003532 <iput+0x20>

000000008000359c <iunlockput>:
{
    8000359c:	1101                	addi	sp,sp,-32
    8000359e:	ec06                	sd	ra,24(sp)
    800035a0:	e822                	sd	s0,16(sp)
    800035a2:	e426                	sd	s1,8(sp)
    800035a4:	1000                	addi	s0,sp,32
    800035a6:	84aa                	mv	s1,a0
  iunlock(ip);
    800035a8:	e97ff0ef          	jal	8000343e <iunlock>
  iput(ip);
    800035ac:	8526                	mv	a0,s1
    800035ae:	f65ff0ef          	jal	80003512 <iput>
}
    800035b2:	60e2                	ld	ra,24(sp)
    800035b4:	6442                	ld	s0,16(sp)
    800035b6:	64a2                	ld	s1,8(sp)
    800035b8:	6105                	addi	sp,sp,32
    800035ba:	8082                	ret

00000000800035bc <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035bc:	0001b717          	auipc	a4,0x1b
    800035c0:	ac072703          	lw	a4,-1344(a4) # 8001e07c <sb+0xc>
    800035c4:	4785                	li	a5,1
    800035c6:	0ae7fe63          	bgeu	a5,a4,80003682 <ireclaim+0xc6>
{
    800035ca:	7139                	addi	sp,sp,-64
    800035cc:	fc06                	sd	ra,56(sp)
    800035ce:	f822                	sd	s0,48(sp)
    800035d0:	f426                	sd	s1,40(sp)
    800035d2:	f04a                	sd	s2,32(sp)
    800035d4:	ec4e                	sd	s3,24(sp)
    800035d6:	e852                	sd	s4,16(sp)
    800035d8:	e456                	sd	s5,8(sp)
    800035da:	e05a                	sd	s6,0(sp)
    800035dc:	0080                	addi	s0,sp,64
    800035de:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035e0:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800035e2:	0001ba17          	auipc	s4,0x1b
    800035e6:	a8ea0a13          	addi	s4,s4,-1394 # 8001e070 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    800035ea:	00004b17          	auipc	s6,0x4
    800035ee:	e7eb0b13          	addi	s6,s6,-386 # 80007468 <etext+0x468>
    800035f2:	a099                	j	80003638 <ireclaim+0x7c>
    800035f4:	85ce                	mv	a1,s3
    800035f6:	855a                	mv	a0,s6
    800035f8:	ef7fc0ef          	jal	800004ee <printk>
      ip = iget(dev, inum);
    800035fc:	85ce                	mv	a1,s3
    800035fe:	8556                	mv	a0,s5
    80003600:	b1fff0ef          	jal	8000311e <iget>
    80003604:	89aa                	mv	s3,a0
    brelse(bp);
    80003606:	854a                	mv	a0,s2
    80003608:	ff8ff0ef          	jal	80002e00 <brelse>
    if (ip) {
    8000360c:	00098f63          	beqz	s3,8000362a <ireclaim+0x6e>
      begin_op();
    80003610:	78c000ef          	jal	80003d9c <begin_op>
      ilock(ip);
    80003614:	854e                	mv	a0,s3
    80003616:	d7bff0ef          	jal	80003390 <ilock>
      iunlock(ip);
    8000361a:	854e                	mv	a0,s3
    8000361c:	e23ff0ef          	jal	8000343e <iunlock>
      iput(ip);
    80003620:	854e                	mv	a0,s3
    80003622:	ef1ff0ef          	jal	80003512 <iput>
      end_op();
    80003626:	7e6000ef          	jal	80003e0c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000362a:	0485                	addi	s1,s1,1
    8000362c:	00ca2703          	lw	a4,12(s4)
    80003630:	0004879b          	sext.w	a5,s1
    80003634:	02e7fd63          	bgeu	a5,a4,8000366e <ireclaim+0xb2>
    80003638:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000363c:	0044d593          	srli	a1,s1,0x4
    80003640:	018a2783          	lw	a5,24(s4)
    80003644:	9dbd                	addw	a1,a1,a5
    80003646:	8556                	mv	a0,s5
    80003648:	eb0ff0ef          	jal	80002cf8 <bread>
    8000364c:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000364e:	05850793          	addi	a5,a0,88
    80003652:	00f9f713          	andi	a4,s3,15
    80003656:	071a                	slli	a4,a4,0x6
    80003658:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    8000365a:	00079703          	lh	a4,0(a5)
    8000365e:	c701                	beqz	a4,80003666 <ireclaim+0xaa>
    80003660:	00679783          	lh	a5,6(a5)
    80003664:	dbc1                	beqz	a5,800035f4 <ireclaim+0x38>
    brelse(bp);
    80003666:	854a                	mv	a0,s2
    80003668:	f98ff0ef          	jal	80002e00 <brelse>
    if (ip) {
    8000366c:	bf7d                	j	8000362a <ireclaim+0x6e>
}
    8000366e:	70e2                	ld	ra,56(sp)
    80003670:	7442                	ld	s0,48(sp)
    80003672:	74a2                	ld	s1,40(sp)
    80003674:	7902                	ld	s2,32(sp)
    80003676:	69e2                	ld	s3,24(sp)
    80003678:	6a42                	ld	s4,16(sp)
    8000367a:	6aa2                	ld	s5,8(sp)
    8000367c:	6b02                	ld	s6,0(sp)
    8000367e:	6121                	addi	sp,sp,64
    80003680:	8082                	ret
    80003682:	8082                	ret

0000000080003684 <fsinit>:
{
    80003684:	1101                	addi	sp,sp,-32
    80003686:	ec06                	sd	ra,24(sp)
    80003688:	e822                	sd	s0,16(sp)
    8000368a:	e426                	sd	s1,8(sp)
    8000368c:	e04a                	sd	s2,0(sp)
    8000368e:	1000                	addi	s0,sp,32
    80003690:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003692:	4585                	li	a1,1
    80003694:	e64ff0ef          	jal	80002cf8 <bread>
    80003698:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000369a:	02000613          	li	a2,32
    8000369e:	05850593          	addi	a1,a0,88
    800036a2:	0001b517          	auipc	a0,0x1b
    800036a6:	9ce50513          	addi	a0,a0,-1586 # 8001e070 <sb>
    800036aa:	e82fd0ef          	jal	80000d2c <memmove>
  brelse(bp);
    800036ae:	8526                	mv	a0,s1
    800036b0:	f50ff0ef          	jal	80002e00 <brelse>
  if (sb.magic != FSMAGIC)
    800036b4:	0001b717          	auipc	a4,0x1b
    800036b8:	9bc72703          	lw	a4,-1604(a4) # 8001e070 <sb>
    800036bc:	102037b7          	lui	a5,0x10203
    800036c0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800036c4:	02f71263          	bne	a4,a5,800036e8 <fsinit+0x64>
  initlog(dev, &sb);
    800036c8:	0001b597          	auipc	a1,0x1b
    800036cc:	9a858593          	addi	a1,a1,-1624 # 8001e070 <sb>
    800036d0:	854a                	mv	a0,s2
    800036d2:	648000ef          	jal	80003d1a <initlog>
  ireclaim(dev);
    800036d6:	854a                	mv	a0,s2
    800036d8:	ee5ff0ef          	jal	800035bc <ireclaim>
}
    800036dc:	60e2                	ld	ra,24(sp)
    800036de:	6442                	ld	s0,16(sp)
    800036e0:	64a2                	ld	s1,8(sp)
    800036e2:	6902                	ld	s2,0(sp)
    800036e4:	6105                	addi	sp,sp,32
    800036e6:	8082                	ret
    panic("invalid file system");
    800036e8:	00004517          	auipc	a0,0x4
    800036ec:	da050513          	addi	a0,a0,-608 # 80007488 <etext+0x488>
    800036f0:	928fd0ef          	jal	80000818 <panic>

00000000800036f4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800036f4:	1141                	addi	sp,sp,-16
    800036f6:	e406                	sd	ra,8(sp)
    800036f8:	e022                	sd	s0,0(sp)
    800036fa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800036fc:	411c                	lw	a5,0(a0)
    800036fe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003700:	415c                	lw	a5,4(a0)
    80003702:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003704:	04451783          	lh	a5,68(a0)
    80003708:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000370c:	04a51783          	lh	a5,74(a0)
    80003710:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003714:	04c56783          	lwu	a5,76(a0)
    80003718:	e99c                	sd	a5,16(a1)
}
    8000371a:	60a2                	ld	ra,8(sp)
    8000371c:	6402                	ld	s0,0(sp)
    8000371e:	0141                	addi	sp,sp,16
    80003720:	8082                	ret

0000000080003722 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003722:	457c                	lw	a5,76(a0)
    80003724:	0ed7e663          	bltu	a5,a3,80003810 <readi+0xee>
{
    80003728:	7159                	addi	sp,sp,-112
    8000372a:	f486                	sd	ra,104(sp)
    8000372c:	f0a2                	sd	s0,96(sp)
    8000372e:	eca6                	sd	s1,88(sp)
    80003730:	e0d2                	sd	s4,64(sp)
    80003732:	fc56                	sd	s5,56(sp)
    80003734:	f85a                	sd	s6,48(sp)
    80003736:	f45e                	sd	s7,40(sp)
    80003738:	1880                	addi	s0,sp,112
    8000373a:	8b2a                	mv	s6,a0
    8000373c:	8bae                	mv	s7,a1
    8000373e:	8a32                	mv	s4,a2
    80003740:	84b6                	mv	s1,a3
    80003742:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80003744:	9f35                	addw	a4,a4,a3
    return 0;
    80003746:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80003748:	0ad76b63          	bltu	a4,a3,800037fe <readi+0xdc>
    8000374c:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    8000374e:	00e7f463          	bgeu	a5,a4,80003756 <readi+0x34>
    n = ip->size - off;
    80003752:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003756:	080a8b63          	beqz	s5,800037ec <readi+0xca>
    8000375a:	e8ca                	sd	s2,80(sp)
    8000375c:	f062                	sd	s8,32(sp)
    8000375e:	ec66                	sd	s9,24(sp)
    80003760:	e86a                	sd	s10,16(sp)
    80003762:	e46e                	sd	s11,8(sp)
    80003764:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003766:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000376a:	5c7d                	li	s8,-1
    8000376c:	a80d                	j	8000379e <readi+0x7c>
    8000376e:	020d1d93          	slli	s11,s10,0x20
    80003772:	020ddd93          	srli	s11,s11,0x20
    80003776:	05890613          	addi	a2,s2,88
    8000377a:	86ee                	mv	a3,s11
    8000377c:	963e                	add	a2,a2,a5
    8000377e:	85d2                	mv	a1,s4
    80003780:	855e                	mv	a0,s7
    80003782:	b05fe0ef          	jal	80002286 <either_copyout>
    80003786:	05850363          	beq	a0,s8,800037cc <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000378a:	854a                	mv	a0,s2
    8000378c:	e74ff0ef          	jal	80002e00 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003790:	013d09bb          	addw	s3,s10,s3
    80003794:	009d04bb          	addw	s1,s10,s1
    80003798:	9a6e                	add	s4,s4,s11
    8000379a:	0559f363          	bgeu	s3,s5,800037e0 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    8000379e:	00a4d59b          	srliw	a1,s1,0xa
    800037a2:	855a                	mv	a0,s6
    800037a4:	8bbff0ef          	jal	8000305e <bmap>
    800037a8:	85aa                	mv	a1,a0
    if (addr == 0)
    800037aa:	c139                	beqz	a0,800037f0 <readi+0xce>
    bp = bread(ip->dev, addr);
    800037ac:	000b2503          	lw	a0,0(s6)
    800037b0:	d48ff0ef          	jal	80002cf8 <bread>
    800037b4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800037b6:	3ff4f793          	andi	a5,s1,1023
    800037ba:	40fc873b          	subw	a4,s9,a5
    800037be:	413a86bb          	subw	a3,s5,s3
    800037c2:	8d3a                	mv	s10,a4
    800037c4:	fae6f5e3          	bgeu	a3,a4,8000376e <readi+0x4c>
    800037c8:	8d36                	mv	s10,a3
    800037ca:	b755                	j	8000376e <readi+0x4c>
      brelse(bp);
    800037cc:	854a                	mv	a0,s2
    800037ce:	e32ff0ef          	jal	80002e00 <brelse>
      tot = -1;
    800037d2:	59fd                	li	s3,-1
      break;
    800037d4:	6946                	ld	s2,80(sp)
    800037d6:	7c02                	ld	s8,32(sp)
    800037d8:	6ce2                	ld	s9,24(sp)
    800037da:	6d42                	ld	s10,16(sp)
    800037dc:	6da2                	ld	s11,8(sp)
    800037de:	a831                	j	800037fa <readi+0xd8>
    800037e0:	6946                	ld	s2,80(sp)
    800037e2:	7c02                	ld	s8,32(sp)
    800037e4:	6ce2                	ld	s9,24(sp)
    800037e6:	6d42                	ld	s10,16(sp)
    800037e8:	6da2                	ld	s11,8(sp)
    800037ea:	a801                	j	800037fa <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800037ec:	89d6                	mv	s3,s5
    800037ee:	a031                	j	800037fa <readi+0xd8>
    800037f0:	6946                	ld	s2,80(sp)
    800037f2:	7c02                	ld	s8,32(sp)
    800037f4:	6ce2                	ld	s9,24(sp)
    800037f6:	6d42                	ld	s10,16(sp)
    800037f8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800037fa:	854e                	mv	a0,s3
    800037fc:	69a6                	ld	s3,72(sp)
}
    800037fe:	70a6                	ld	ra,104(sp)
    80003800:	7406                	ld	s0,96(sp)
    80003802:	64e6                	ld	s1,88(sp)
    80003804:	6a06                	ld	s4,64(sp)
    80003806:	7ae2                	ld	s5,56(sp)
    80003808:	7b42                	ld	s6,48(sp)
    8000380a:	7ba2                	ld	s7,40(sp)
    8000380c:	6165                	addi	sp,sp,112
    8000380e:	8082                	ret
    return 0;
    80003810:	4501                	li	a0,0
}
    80003812:	8082                	ret

0000000080003814 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003814:	457c                	lw	a5,76(a0)
    80003816:	0ed7eb63          	bltu	a5,a3,8000390c <writei+0xf8>
{
    8000381a:	7159                	addi	sp,sp,-112
    8000381c:	f486                	sd	ra,104(sp)
    8000381e:	f0a2                	sd	s0,96(sp)
    80003820:	e8ca                	sd	s2,80(sp)
    80003822:	e0d2                	sd	s4,64(sp)
    80003824:	fc56                	sd	s5,56(sp)
    80003826:	f85a                	sd	s6,48(sp)
    80003828:	f45e                	sd	s7,40(sp)
    8000382a:	1880                	addi	s0,sp,112
    8000382c:	8aaa                	mv	s5,a0
    8000382e:	8bae                	mv	s7,a1
    80003830:	8a32                	mv	s4,a2
    80003832:	8936                	mv	s2,a3
    80003834:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80003836:	00e687bb          	addw	a5,a3,a4
    return -1;
  if (off + n > MAXFILE * BSIZE)
    8000383a:	00043737          	lui	a4,0x43
    8000383e:	0cf76963          	bltu	a4,a5,80003910 <writei+0xfc>
    80003842:	0cd7e763          	bltu	a5,a3,80003910 <writei+0xfc>
    80003846:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003848:	0a0b0a63          	beqz	s6,800038fc <writei+0xe8>
    8000384c:	eca6                	sd	s1,88(sp)
    8000384e:	f062                	sd	s8,32(sp)
    80003850:	ec66                	sd	s9,24(sp)
    80003852:	e86a                	sd	s10,16(sp)
    80003854:	e46e                	sd	s11,8(sp)
    80003856:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003858:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000385c:	5c7d                	li	s8,-1
    8000385e:	a825                	j	80003896 <writei+0x82>
    80003860:	020d1d93          	slli	s11,s10,0x20
    80003864:	020ddd93          	srli	s11,s11,0x20
    80003868:	05848513          	addi	a0,s1,88
    8000386c:	86ee                	mv	a3,s11
    8000386e:	8652                	mv	a2,s4
    80003870:	85de                	mv	a1,s7
    80003872:	953e                	add	a0,a0,a5
    80003874:	a5dfe0ef          	jal	800022d0 <either_copyin>
    80003878:	05850663          	beq	a0,s8,800038c4 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000387c:	8526                	mv	a0,s1
    8000387e:	6b8000ef          	jal	80003f36 <log_write>
    brelse(bp);
    80003882:	8526                	mv	a0,s1
    80003884:	d7cff0ef          	jal	80002e00 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003888:	013d09bb          	addw	s3,s10,s3
    8000388c:	012d093b          	addw	s2,s10,s2
    80003890:	9a6e                	add	s4,s4,s11
    80003892:	0369fc63          	bgeu	s3,s6,800038ca <writei+0xb6>
    uint addr = bmap(ip, off / BSIZE);
    80003896:	00a9559b          	srliw	a1,s2,0xa
    8000389a:	8556                	mv	a0,s5
    8000389c:	fc2ff0ef          	jal	8000305e <bmap>
    800038a0:	85aa                	mv	a1,a0
    if (addr == 0)
    800038a2:	c505                	beqz	a0,800038ca <writei+0xb6>
    bp = bread(ip->dev, addr);
    800038a4:	000aa503          	lw	a0,0(s5)
    800038a8:	c50ff0ef          	jal	80002cf8 <bread>
    800038ac:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800038ae:	3ff97793          	andi	a5,s2,1023
    800038b2:	40fc873b          	subw	a4,s9,a5
    800038b6:	413b06bb          	subw	a3,s6,s3
    800038ba:	8d3a                	mv	s10,a4
    800038bc:	fae6f2e3          	bgeu	a3,a4,80003860 <writei+0x4c>
    800038c0:	8d36                	mv	s10,a3
    800038c2:	bf79                	j	80003860 <writei+0x4c>
      brelse(bp);
    800038c4:	8526                	mv	a0,s1
    800038c6:	d3aff0ef          	jal	80002e00 <brelse>
  }

  if (off > ip->size)
    800038ca:	04caa783          	lw	a5,76(s5)
    800038ce:	0327f963          	bgeu	a5,s2,80003900 <writei+0xec>
    ip->size = off;
    800038d2:	052aa623          	sw	s2,76(s5)
    800038d6:	64e6                	ld	s1,88(sp)
    800038d8:	7c02                	ld	s8,32(sp)
    800038da:	6ce2                	ld	s9,24(sp)
    800038dc:	6d42                	ld	s10,16(sp)
    800038de:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800038e0:	8556                	mv	a0,s5
    800038e2:	9fbff0ef          	jal	800032dc <iupdate>

  return tot;
    800038e6:	854e                	mv	a0,s3
    800038e8:	69a6                	ld	s3,72(sp)
}
    800038ea:	70a6                	ld	ra,104(sp)
    800038ec:	7406                	ld	s0,96(sp)
    800038ee:	6946                	ld	s2,80(sp)
    800038f0:	6a06                	ld	s4,64(sp)
    800038f2:	7ae2                	ld	s5,56(sp)
    800038f4:	7b42                	ld	s6,48(sp)
    800038f6:	7ba2                	ld	s7,40(sp)
    800038f8:	6165                	addi	sp,sp,112
    800038fa:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800038fc:	89da                	mv	s3,s6
    800038fe:	b7cd                	j	800038e0 <writei+0xcc>
    80003900:	64e6                	ld	s1,88(sp)
    80003902:	7c02                	ld	s8,32(sp)
    80003904:	6ce2                	ld	s9,24(sp)
    80003906:	6d42                	ld	s10,16(sp)
    80003908:	6da2                	ld	s11,8(sp)
    8000390a:	bfd9                	j	800038e0 <writei+0xcc>
    return -1;
    8000390c:	557d                	li	a0,-1
}
    8000390e:	8082                	ret
    return -1;
    80003910:	557d                	li	a0,-1
    80003912:	bfe1                	j	800038ea <writei+0xd6>

0000000080003914 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003914:	1141                	addi	sp,sp,-16
    80003916:	e406                	sd	ra,8(sp)
    80003918:	e022                	sd	s0,0(sp)
    8000391a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000391c:	4639                	li	a2,14
    8000391e:	c82fd0ef          	jal	80000da0 <strncmp>
}
    80003922:	60a2                	ld	ra,8(sp)
    80003924:	6402                	ld	s0,0(sp)
    80003926:	0141                	addi	sp,sp,16
    80003928:	8082                	ret

000000008000392a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000392a:	711d                	addi	sp,sp,-96
    8000392c:	ec86                	sd	ra,88(sp)
    8000392e:	e8a2                	sd	s0,80(sp)
    80003930:	e4a6                	sd	s1,72(sp)
    80003932:	e0ca                	sd	s2,64(sp)
    80003934:	fc4e                	sd	s3,56(sp)
    80003936:	f852                	sd	s4,48(sp)
    80003938:	f456                	sd	s5,40(sp)
    8000393a:	f05a                	sd	s6,32(sp)
    8000393c:	ec5e                	sd	s7,24(sp)
    8000393e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003940:	04451703          	lh	a4,68(a0)
    80003944:	4785                	li	a5,1
    80003946:	00f71f63          	bne	a4,a5,80003964 <dirlookup+0x3a>
    8000394a:	892a                	mv	s2,a0
    8000394c:	8aae                	mv	s5,a1
    8000394e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003950:	457c                	lw	a5,76(a0)
    80003952:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003954:	fa040a13          	addi	s4,s0,-96
    80003958:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    8000395a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000395e:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003960:	e39d                	bnez	a5,80003986 <dirlookup+0x5c>
    80003962:	a8b9                	j	800039c0 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80003964:	00004517          	auipc	a0,0x4
    80003968:	b3c50513          	addi	a0,a0,-1220 # 800074a0 <etext+0x4a0>
    8000396c:	eadfc0ef          	jal	80000818 <panic>
      panic("dirlookup read");
    80003970:	00004517          	auipc	a0,0x4
    80003974:	b4850513          	addi	a0,a0,-1208 # 800074b8 <etext+0x4b8>
    80003978:	ea1fc0ef          	jal	80000818 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000397c:	24c1                	addiw	s1,s1,16
    8000397e:	04c92783          	lw	a5,76(s2)
    80003982:	02f4fe63          	bgeu	s1,a5,800039be <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003986:	874e                	mv	a4,s3
    80003988:	86a6                	mv	a3,s1
    8000398a:	8652                	mv	a2,s4
    8000398c:	4581                	li	a1,0
    8000398e:	854a                	mv	a0,s2
    80003990:	d93ff0ef          	jal	80003722 <readi>
    80003994:	fd351ee3          	bne	a0,s3,80003970 <dirlookup+0x46>
    if (de.inum == 0)
    80003998:	fa045783          	lhu	a5,-96(s0)
    8000399c:	d3e5                	beqz	a5,8000397c <dirlookup+0x52>
    if (namecmp(name, de.name) == 0) {
    8000399e:	85da                	mv	a1,s6
    800039a0:	8556                	mv	a0,s5
    800039a2:	f73ff0ef          	jal	80003914 <namecmp>
    800039a6:	f979                	bnez	a0,8000397c <dirlookup+0x52>
      if (poff)
    800039a8:	000b8463          	beqz	s7,800039b0 <dirlookup+0x86>
        *poff = off;
    800039ac:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800039b0:	fa045583          	lhu	a1,-96(s0)
    800039b4:	00092503          	lw	a0,0(s2)
    800039b8:	f66ff0ef          	jal	8000311e <iget>
    800039bc:	a011                	j	800039c0 <dirlookup+0x96>
  return 0;
    800039be:	4501                	li	a0,0
}
    800039c0:	60e6                	ld	ra,88(sp)
    800039c2:	6446                	ld	s0,80(sp)
    800039c4:	64a6                	ld	s1,72(sp)
    800039c6:	6906                	ld	s2,64(sp)
    800039c8:	79e2                	ld	s3,56(sp)
    800039ca:	7a42                	ld	s4,48(sp)
    800039cc:	7aa2                	ld	s5,40(sp)
    800039ce:	7b02                	ld	s6,32(sp)
    800039d0:	6be2                	ld	s7,24(sp)
    800039d2:	6125                	addi	sp,sp,96
    800039d4:	8082                	ret

00000000800039d6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800039d6:	711d                	addi	sp,sp,-96
    800039d8:	ec86                	sd	ra,88(sp)
    800039da:	e8a2                	sd	s0,80(sp)
    800039dc:	e4a6                	sd	s1,72(sp)
    800039de:	e0ca                	sd	s2,64(sp)
    800039e0:	fc4e                	sd	s3,56(sp)
    800039e2:	f852                	sd	s4,48(sp)
    800039e4:	f456                	sd	s5,40(sp)
    800039e6:	f05a                	sd	s6,32(sp)
    800039e8:	ec5e                	sd	s7,24(sp)
    800039ea:	e862                	sd	s8,16(sp)
    800039ec:	e466                	sd	s9,8(sp)
    800039ee:	e06a                	sd	s10,0(sp)
    800039f0:	1080                	addi	s0,sp,96
    800039f2:	84aa                	mv	s1,a0
    800039f4:	8b2e                	mv	s6,a1
    800039f6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800039f8:	00054703          	lbu	a4,0(a0)
    800039fc:	02f00793          	li	a5,47
    80003a00:	00f70f63          	beq	a4,a5,80003a1e <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003a04:	efffd0ef          	jal	80001902 <myproc>
    80003a08:	15853503          	ld	a0,344(a0)
    80003a0c:	94fff0ef          	jal	8000335a <idup>
    80003a10:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003a12:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003a16:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003a18:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003a1a:	4b85                	li	s7,1
    80003a1c:	a879                	j	80003aba <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003a1e:	4585                	li	a1,1
    80003a20:	852e                	mv	a0,a1
    80003a22:	efcff0ef          	jal	8000311e <iget>
    80003a26:	8a2a                	mv	s4,a0
    80003a28:	b7ed                	j	80003a12 <namex+0x3c>
      iunlockput(ip);
    80003a2a:	8552                	mv	a0,s4
    80003a2c:	b71ff0ef          	jal	8000359c <iunlockput>
      return 0;
    80003a30:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a32:	8552                	mv	a0,s4
    80003a34:	60e6                	ld	ra,88(sp)
    80003a36:	6446                	ld	s0,80(sp)
    80003a38:	64a6                	ld	s1,72(sp)
    80003a3a:	6906                	ld	s2,64(sp)
    80003a3c:	79e2                	ld	s3,56(sp)
    80003a3e:	7a42                	ld	s4,48(sp)
    80003a40:	7aa2                	ld	s5,40(sp)
    80003a42:	7b02                	ld	s6,32(sp)
    80003a44:	6be2                	ld	s7,24(sp)
    80003a46:	6c42                	ld	s8,16(sp)
    80003a48:	6ca2                	ld	s9,8(sp)
    80003a4a:	6d02                	ld	s10,0(sp)
    80003a4c:	6125                	addi	sp,sp,96
    80003a4e:	8082                	ret
      iunlock(ip);
    80003a50:	8552                	mv	a0,s4
    80003a52:	9edff0ef          	jal	8000343e <iunlock>
      return ip;
    80003a56:	bff1                	j	80003a32 <namex+0x5c>
      iunlockput(ip);
    80003a58:	8552                	mv	a0,s4
    80003a5a:	b43ff0ef          	jal	8000359c <iunlockput>
      return 0;
    80003a5e:	8a4a                	mv	s4,s2
    80003a60:	bfc9                	j	80003a32 <namex+0x5c>
  len = path - s;
    80003a62:	40990633          	sub	a2,s2,s1
    80003a66:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003a6a:	09ac5463          	bge	s8,s10,80003af2 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003a6e:	8666                	mv	a2,s9
    80003a70:	85a6                	mv	a1,s1
    80003a72:	8556                	mv	a0,s5
    80003a74:	ab8fd0ef          	jal	80000d2c <memmove>
    80003a78:	84ca                	mv	s1,s2
  while (*path == '/')
    80003a7a:	0004c783          	lbu	a5,0(s1)
    80003a7e:	01379763          	bne	a5,s3,80003a8c <namex+0xb6>
    path++;
    80003a82:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003a84:	0004c783          	lbu	a5,0(s1)
    80003a88:	ff378de3          	beq	a5,s3,80003a82 <namex+0xac>
    ilock(ip);
    80003a8c:	8552                	mv	a0,s4
    80003a8e:	903ff0ef          	jal	80003390 <ilock>
    if (ip->type != T_DIR) {
    80003a92:	044a1783          	lh	a5,68(s4)
    80003a96:	f9779ae3          	bne	a5,s7,80003a2a <namex+0x54>
    if (nameiparent && *path == '\0') {
    80003a9a:	000b0563          	beqz	s6,80003aa4 <namex+0xce>
    80003a9e:	0004c783          	lbu	a5,0(s1)
    80003aa2:	d7dd                	beqz	a5,80003a50 <namex+0x7a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003aa4:	4601                	li	a2,0
    80003aa6:	85d6                	mv	a1,s5
    80003aa8:	8552                	mv	a0,s4
    80003aaa:	e81ff0ef          	jal	8000392a <dirlookup>
    80003aae:	892a                	mv	s2,a0
    80003ab0:	d545                	beqz	a0,80003a58 <namex+0x82>
    iunlockput(ip);
    80003ab2:	8552                	mv	a0,s4
    80003ab4:	ae9ff0ef          	jal	8000359c <iunlockput>
    ip = next;
    80003ab8:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003aba:	0004c783          	lbu	a5,0(s1)
    80003abe:	01379763          	bne	a5,s3,80003acc <namex+0xf6>
    path++;
    80003ac2:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003ac4:	0004c783          	lbu	a5,0(s1)
    80003ac8:	ff378de3          	beq	a5,s3,80003ac2 <namex+0xec>
  if (*path == 0)
    80003acc:	cf8d                	beqz	a5,80003b06 <namex+0x130>
  while (*path != '/' && *path != 0)
    80003ace:	0004c783          	lbu	a5,0(s1)
    80003ad2:	fd178713          	addi	a4,a5,-47
    80003ad6:	cb19                	beqz	a4,80003aec <namex+0x116>
    80003ad8:	cb91                	beqz	a5,80003aec <namex+0x116>
    80003ada:	8926                	mv	s2,s1
    path++;
    80003adc:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003ade:	00094783          	lbu	a5,0(s2)
    80003ae2:	fd178713          	addi	a4,a5,-47
    80003ae6:	df35                	beqz	a4,80003a62 <namex+0x8c>
    80003ae8:	fbf5                	bnez	a5,80003adc <namex+0x106>
    80003aea:	bfa5                	j	80003a62 <namex+0x8c>
    80003aec:	8926                	mv	s2,s1
  len = path - s;
    80003aee:	4d01                	li	s10,0
    80003af0:	4601                	li	a2,0
    memmove(name, s, len);
    80003af2:	2601                	sext.w	a2,a2
    80003af4:	85a6                	mv	a1,s1
    80003af6:	8556                	mv	a0,s5
    80003af8:	a34fd0ef          	jal	80000d2c <memmove>
    name[len] = 0;
    80003afc:	9d56                	add	s10,s10,s5
    80003afe:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde288>
    80003b02:	84ca                	mv	s1,s2
    80003b04:	bf9d                	j	80003a7a <namex+0xa4>
  if (nameiparent) {
    80003b06:	f20b06e3          	beqz	s6,80003a32 <namex+0x5c>
    iput(ip);
    80003b0a:	8552                	mv	a0,s4
    80003b0c:	a07ff0ef          	jal	80003512 <iput>
    return 0;
    80003b10:	4a01                	li	s4,0
    80003b12:	b705                	j	80003a32 <namex+0x5c>

0000000080003b14 <dirlink>:
{
    80003b14:	715d                	addi	sp,sp,-80
    80003b16:	e486                	sd	ra,72(sp)
    80003b18:	e0a2                	sd	s0,64(sp)
    80003b1a:	f84a                	sd	s2,48(sp)
    80003b1c:	ec56                	sd	s5,24(sp)
    80003b1e:	e85a                	sd	s6,16(sp)
    80003b20:	0880                	addi	s0,sp,80
    80003b22:	892a                	mv	s2,a0
    80003b24:	8aae                	mv	s5,a1
    80003b26:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003b28:	4601                	li	a2,0
    80003b2a:	e01ff0ef          	jal	8000392a <dirlookup>
    80003b2e:	ed1d                	bnez	a0,80003b6c <dirlink+0x58>
    80003b30:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003b32:	04c92483          	lw	s1,76(s2)
    80003b36:	c4b9                	beqz	s1,80003b84 <dirlink+0x70>
    80003b38:	f44e                	sd	s3,40(sp)
    80003b3a:	f052                	sd	s4,32(sp)
    80003b3c:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b3e:	fb040a13          	addi	s4,s0,-80
    80003b42:	49c1                	li	s3,16
    80003b44:	874e                	mv	a4,s3
    80003b46:	86a6                	mv	a3,s1
    80003b48:	8652                	mv	a2,s4
    80003b4a:	4581                	li	a1,0
    80003b4c:	854a                	mv	a0,s2
    80003b4e:	bd5ff0ef          	jal	80003722 <readi>
    80003b52:	03351163          	bne	a0,s3,80003b74 <dirlink+0x60>
    if (de.inum == 0)
    80003b56:	fb045783          	lhu	a5,-80(s0)
    80003b5a:	c39d                	beqz	a5,80003b80 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003b5c:	24c1                	addiw	s1,s1,16
    80003b5e:	04c92783          	lw	a5,76(s2)
    80003b62:	fef4e1e3          	bltu	s1,a5,80003b44 <dirlink+0x30>
    80003b66:	79a2                	ld	s3,40(sp)
    80003b68:	7a02                	ld	s4,32(sp)
    80003b6a:	a829                	j	80003b84 <dirlink+0x70>
    iput(ip);
    80003b6c:	9a7ff0ef          	jal	80003512 <iput>
    return -1;
    80003b70:	557d                	li	a0,-1
    80003b72:	a83d                	j	80003bb0 <dirlink+0x9c>
      panic("dirlink read");
    80003b74:	00004517          	auipc	a0,0x4
    80003b78:	95450513          	addi	a0,a0,-1708 # 800074c8 <etext+0x4c8>
    80003b7c:	c9dfc0ef          	jal	80000818 <panic>
    80003b80:	79a2                	ld	s3,40(sp)
    80003b82:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003b84:	4639                	li	a2,14
    80003b86:	85d6                	mv	a1,s5
    80003b88:	fb240513          	addi	a0,s0,-78
    80003b8c:	a4efd0ef          	jal	80000dda <strncpy>
  de.inum = inum;
    80003b90:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b94:	4741                	li	a4,16
    80003b96:	86a6                	mv	a3,s1
    80003b98:	fb040613          	addi	a2,s0,-80
    80003b9c:	4581                	li	a1,0
    80003b9e:	854a                	mv	a0,s2
    80003ba0:	c75ff0ef          	jal	80003814 <writei>
    80003ba4:	1541                	addi	a0,a0,-16
    80003ba6:	00a03533          	snez	a0,a0
    80003baa:	40a0053b          	negw	a0,a0
    80003bae:	74e2                	ld	s1,56(sp)
}
    80003bb0:	60a6                	ld	ra,72(sp)
    80003bb2:	6406                	ld	s0,64(sp)
    80003bb4:	7942                	ld	s2,48(sp)
    80003bb6:	6ae2                	ld	s5,24(sp)
    80003bb8:	6b42                	ld	s6,16(sp)
    80003bba:	6161                	addi	sp,sp,80
    80003bbc:	8082                	ret

0000000080003bbe <namei>:

struct inode *
namei(char *path)
{
    80003bbe:	1101                	addi	sp,sp,-32
    80003bc0:	ec06                	sd	ra,24(sp)
    80003bc2:	e822                	sd	s0,16(sp)
    80003bc4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003bc6:	fe040613          	addi	a2,s0,-32
    80003bca:	4581                	li	a1,0
    80003bcc:	e0bff0ef          	jal	800039d6 <namex>
}
    80003bd0:	60e2                	ld	ra,24(sp)
    80003bd2:	6442                	ld	s0,16(sp)
    80003bd4:	6105                	addi	sp,sp,32
    80003bd6:	8082                	ret

0000000080003bd8 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003bd8:	1141                	addi	sp,sp,-16
    80003bda:	e406                	sd	ra,8(sp)
    80003bdc:	e022                	sd	s0,0(sp)
    80003bde:	0800                	addi	s0,sp,16
    80003be0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003be2:	4585                	li	a1,1
    80003be4:	df3ff0ef          	jal	800039d6 <namex>
}
    80003be8:	60a2                	ld	ra,8(sp)
    80003bea:	6402                	ld	s0,0(sp)
    80003bec:	0141                	addi	sp,sp,16
    80003bee:	8082                	ret

0000000080003bf0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003bf0:	1101                	addi	sp,sp,-32
    80003bf2:	ec06                	sd	ra,24(sp)
    80003bf4:	e822                	sd	s0,16(sp)
    80003bf6:	e426                	sd	s1,8(sp)
    80003bf8:	e04a                	sd	s2,0(sp)
    80003bfa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003bfc:	0001c917          	auipc	s2,0x1c
    80003c00:	f3c90913          	addi	s2,s2,-196 # 8001fb38 <log>
    80003c04:	01892583          	lw	a1,24(s2)
    80003c08:	02492503          	lw	a0,36(s2)
    80003c0c:	8ecff0ef          	jal	80002cf8 <bread>
    80003c10:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003c12:	02892603          	lw	a2,40(s2)
    80003c16:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003c18:	00c05f63          	blez	a2,80003c36 <write_head+0x46>
    80003c1c:	0001c717          	auipc	a4,0x1c
    80003c20:	f4870713          	addi	a4,a4,-184 # 8001fb64 <log+0x2c>
    80003c24:	87aa                	mv	a5,a0
    80003c26:	060a                	slli	a2,a2,0x2
    80003c28:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003c2a:	4314                	lw	a3,0(a4)
    80003c2c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003c2e:	0711                	addi	a4,a4,4
    80003c30:	0791                	addi	a5,a5,4
    80003c32:	fec79ce3          	bne	a5,a2,80003c2a <write_head+0x3a>
  }
  bwrite(buf);
    80003c36:	8526                	mv	a0,s1
    80003c38:	996ff0ef          	jal	80002dce <bwrite>
  brelse(buf);
    80003c3c:	8526                	mv	a0,s1
    80003c3e:	9c2ff0ef          	jal	80002e00 <brelse>
}
    80003c42:	60e2                	ld	ra,24(sp)
    80003c44:	6442                	ld	s0,16(sp)
    80003c46:	64a2                	ld	s1,8(sp)
    80003c48:	6902                	ld	s2,0(sp)
    80003c4a:	6105                	addi	sp,sp,32
    80003c4c:	8082                	ret

0000000080003c4e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c4e:	0001c797          	auipc	a5,0x1c
    80003c52:	f127a783          	lw	a5,-238(a5) # 8001fb60 <log+0x28>
    80003c56:	0cf05163          	blez	a5,80003d18 <install_trans+0xca>
{
    80003c5a:	715d                	addi	sp,sp,-80
    80003c5c:	e486                	sd	ra,72(sp)
    80003c5e:	e0a2                	sd	s0,64(sp)
    80003c60:	fc26                	sd	s1,56(sp)
    80003c62:	f84a                	sd	s2,48(sp)
    80003c64:	f44e                	sd	s3,40(sp)
    80003c66:	f052                	sd	s4,32(sp)
    80003c68:	ec56                	sd	s5,24(sp)
    80003c6a:	e85a                	sd	s6,16(sp)
    80003c6c:	e45e                	sd	s7,8(sp)
    80003c6e:	e062                	sd	s8,0(sp)
    80003c70:	0880                	addi	s0,sp,80
    80003c72:	8b2a                	mv	s6,a0
    80003c74:	0001ca97          	auipc	s5,0x1c
    80003c78:	ef0a8a93          	addi	s5,s5,-272 # 8001fb64 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c7c:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c7e:	00004c17          	auipc	s8,0x4
    80003c82:	85ac0c13          	addi	s8,s8,-1958 # 800074d8 <etext+0x4d8>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003c86:	0001ca17          	auipc	s4,0x1c
    80003c8a:	eb2a0a13          	addi	s4,s4,-334 # 8001fb38 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003c8e:	40000b93          	li	s7,1024
    80003c92:	a025                	j	80003cba <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c94:	000aa603          	lw	a2,0(s5)
    80003c98:	85ce                	mv	a1,s3
    80003c9a:	8562                	mv	a0,s8
    80003c9c:	853fc0ef          	jal	800004ee <printk>
    80003ca0:	a839                	j	80003cbe <install_trans+0x70>
    brelse(lbuf);
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	95cff0ef          	jal	80002e00 <brelse>
    brelse(dbuf);
    80003ca8:	8526                	mv	a0,s1
    80003caa:	956ff0ef          	jal	80002e00 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cae:	2985                	addiw	s3,s3,1
    80003cb0:	0a91                	addi	s5,s5,4
    80003cb2:	028a2783          	lw	a5,40(s4)
    80003cb6:	04f9d563          	bge	s3,a5,80003d00 <install_trans+0xb2>
    if (recovering) {
    80003cba:	fc0b1de3          	bnez	s6,80003c94 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003cbe:	018a2583          	lw	a1,24(s4)
    80003cc2:	013585bb          	addw	a1,a1,s3
    80003cc6:	2585                	addiw	a1,a1,1
    80003cc8:	024a2503          	lw	a0,36(s4)
    80003ccc:	82cff0ef          	jal	80002cf8 <bread>
    80003cd0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003cd2:	000aa583          	lw	a1,0(s5)
    80003cd6:	024a2503          	lw	a0,36(s4)
    80003cda:	81eff0ef          	jal	80002cf8 <bread>
    80003cde:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003ce0:	865e                	mv	a2,s7
    80003ce2:	05890593          	addi	a1,s2,88
    80003ce6:	05850513          	addi	a0,a0,88
    80003cea:	842fd0ef          	jal	80000d2c <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003cee:	8526                	mv	a0,s1
    80003cf0:	8deff0ef          	jal	80002dce <bwrite>
    if (recovering == 0)
    80003cf4:	fa0b17e3          	bnez	s6,80003ca2 <install_trans+0x54>
      bunpin(dbuf);
    80003cf8:	8526                	mv	a0,s1
    80003cfa:	9beff0ef          	jal	80002eb8 <bunpin>
    80003cfe:	b755                	j	80003ca2 <install_trans+0x54>
}
    80003d00:	60a6                	ld	ra,72(sp)
    80003d02:	6406                	ld	s0,64(sp)
    80003d04:	74e2                	ld	s1,56(sp)
    80003d06:	7942                	ld	s2,48(sp)
    80003d08:	79a2                	ld	s3,40(sp)
    80003d0a:	7a02                	ld	s4,32(sp)
    80003d0c:	6ae2                	ld	s5,24(sp)
    80003d0e:	6b42                	ld	s6,16(sp)
    80003d10:	6ba2                	ld	s7,8(sp)
    80003d12:	6c02                	ld	s8,0(sp)
    80003d14:	6161                	addi	sp,sp,80
    80003d16:	8082                	ret
    80003d18:	8082                	ret

0000000080003d1a <initlog>:
{
    80003d1a:	7179                	addi	sp,sp,-48
    80003d1c:	f406                	sd	ra,40(sp)
    80003d1e:	f022                	sd	s0,32(sp)
    80003d20:	ec26                	sd	s1,24(sp)
    80003d22:	e84a                	sd	s2,16(sp)
    80003d24:	e44e                	sd	s3,8(sp)
    80003d26:	1800                	addi	s0,sp,48
    80003d28:	84aa                	mv	s1,a0
    80003d2a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003d2c:	0001c917          	auipc	s2,0x1c
    80003d30:	e0c90913          	addi	s2,s2,-500 # 8001fb38 <log>
    80003d34:	00003597          	auipc	a1,0x3
    80003d38:	7c458593          	addi	a1,a1,1988 # 800074f8 <etext+0x4f8>
    80003d3c:	854a                	mv	a0,s2
    80003d3e:	e3dfc0ef          	jal	80000b7a <initlock>
  log.start = sb->logstart;
    80003d42:	0149a583          	lw	a1,20(s3)
    80003d46:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003d4a:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003d4e:	8526                	mv	a0,s1
    80003d50:	fa9fe0ef          	jal	80002cf8 <bread>
  log.lh.n = lh->n;
    80003d54:	4d30                	lw	a2,88(a0)
    80003d56:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003d5a:	00c05f63          	blez	a2,80003d78 <initlog+0x5e>
    80003d5e:	87aa                	mv	a5,a0
    80003d60:	0001c717          	auipc	a4,0x1c
    80003d64:	e0470713          	addi	a4,a4,-508 # 8001fb64 <log+0x2c>
    80003d68:	060a                	slli	a2,a2,0x2
    80003d6a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003d6c:	4ff4                	lw	a3,92(a5)
    80003d6e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003d70:	0791                	addi	a5,a5,4
    80003d72:	0711                	addi	a4,a4,4
    80003d74:	fec79ce3          	bne	a5,a2,80003d6c <initlog+0x52>
  brelse(buf);
    80003d78:	888ff0ef          	jal	80002e00 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003d7c:	4505                	li	a0,1
    80003d7e:	ed1ff0ef          	jal	80003c4e <install_trans>
  log.lh.n = 0;
    80003d82:	0001c797          	auipc	a5,0x1c
    80003d86:	dc07af23          	sw	zero,-546(a5) # 8001fb60 <log+0x28>
  write_head(); // clear the log
    80003d8a:	e67ff0ef          	jal	80003bf0 <write_head>
}
    80003d8e:	70a2                	ld	ra,40(sp)
    80003d90:	7402                	ld	s0,32(sp)
    80003d92:	64e2                	ld	s1,24(sp)
    80003d94:	6942                	ld	s2,16(sp)
    80003d96:	69a2                	ld	s3,8(sp)
    80003d98:	6145                	addi	sp,sp,48
    80003d9a:	8082                	ret

0000000080003d9c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003d9c:	1101                	addi	sp,sp,-32
    80003d9e:	ec06                	sd	ra,24(sp)
    80003da0:	e822                	sd	s0,16(sp)
    80003da2:	e426                	sd	s1,8(sp)
    80003da4:	e04a                	sd	s2,0(sp)
    80003da6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003da8:	0001c517          	auipc	a0,0x1c
    80003dac:	d9050513          	addi	a0,a0,-624 # 8001fb38 <log>
    80003db0:	e55fc0ef          	jal	80000c04 <acquire>
  while (1) {
    if (log.committing) {
    80003db4:	0001c497          	auipc	s1,0x1c
    80003db8:	d8448493          	addi	s1,s1,-636 # 8001fb38 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003dbc:	4979                	li	s2,30
    80003dbe:	a029                	j	80003dc8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003dc0:	85a6                	mv	a1,s1
    80003dc2:	8526                	mv	a0,s1
    80003dc4:	968fe0ef          	jal	80001f2c <sleep>
    if (log.committing) {
    80003dc8:	509c                	lw	a5,32(s1)
    80003dca:	fbfd                	bnez	a5,80003dc0 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003dcc:	4cd8                	lw	a4,28(s1)
    80003dce:	2705                	addiw	a4,a4,1
    80003dd0:	0027179b          	slliw	a5,a4,0x2
    80003dd4:	9fb9                	addw	a5,a5,a4
    80003dd6:	0017979b          	slliw	a5,a5,0x1
    80003dda:	5494                	lw	a3,40(s1)
    80003ddc:	9fb5                	addw	a5,a5,a3
    80003dde:	00f95763          	bge	s2,a5,80003dec <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003de2:	85a6                	mv	a1,s1
    80003de4:	8526                	mv	a0,s1
    80003de6:	946fe0ef          	jal	80001f2c <sleep>
    80003dea:	bff9                	j	80003dc8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003dec:	0001c797          	auipc	a5,0x1c
    80003df0:	d6e7a423          	sw	a4,-664(a5) # 8001fb54 <log+0x1c>
      release(&log.lock);
    80003df4:	0001c517          	auipc	a0,0x1c
    80003df8:	d4450513          	addi	a0,a0,-700 # 8001fb38 <log>
    80003dfc:	e99fc0ef          	jal	80000c94 <release>
      break;
    }
  }
}
    80003e00:	60e2                	ld	ra,24(sp)
    80003e02:	6442                	ld	s0,16(sp)
    80003e04:	64a2                	ld	s1,8(sp)
    80003e06:	6902                	ld	s2,0(sp)
    80003e08:	6105                	addi	sp,sp,32
    80003e0a:	8082                	ret

0000000080003e0c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003e0c:	7139                	addi	sp,sp,-64
    80003e0e:	fc06                	sd	ra,56(sp)
    80003e10:	f822                	sd	s0,48(sp)
    80003e12:	f426                	sd	s1,40(sp)
    80003e14:	f04a                	sd	s2,32(sp)
    80003e16:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003e18:	0001c497          	auipc	s1,0x1c
    80003e1c:	d2048493          	addi	s1,s1,-736 # 8001fb38 <log>
    80003e20:	8526                	mv	a0,s1
    80003e22:	de3fc0ef          	jal	80000c04 <acquire>
  log.outstanding -= 1;
    80003e26:	4cdc                	lw	a5,28(s1)
    80003e28:	37fd                	addiw	a5,a5,-1
    80003e2a:	893e                	mv	s2,a5
    80003e2c:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003e2e:	509c                	lw	a5,32(s1)
    80003e30:	e7b1                	bnez	a5,80003e7c <end_op+0x70>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003e32:	04091e63          	bnez	s2,80003e8e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003e36:	0001c497          	auipc	s1,0x1c
    80003e3a:	d0248493          	addi	s1,s1,-766 # 8001fb38 <log>
    80003e3e:	4785                	li	a5,1
    80003e40:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003e42:	8526                	mv	a0,s1
    80003e44:	e51fc0ef          	jal	80000c94 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003e48:	549c                	lw	a5,40(s1)
    80003e4a:	06f04463          	bgtz	a5,80003eb2 <end_op+0xa6>
    acquire(&log.lock);
    80003e4e:	0001c517          	auipc	a0,0x1c
    80003e52:	cea50513          	addi	a0,a0,-790 # 8001fb38 <log>
    80003e56:	daffc0ef          	jal	80000c04 <acquire>
    log.committing = 0;
    80003e5a:	0001c797          	auipc	a5,0x1c
    80003e5e:	ce07af23          	sw	zero,-770(a5) # 8001fb58 <log+0x20>
    wakeup(&log);
    80003e62:	0001c517          	auipc	a0,0x1c
    80003e66:	cd650513          	addi	a0,a0,-810 # 8001fb38 <log>
    80003e6a:	90efe0ef          	jal	80001f78 <wakeup>
    release(&log.lock);
    80003e6e:	0001c517          	auipc	a0,0x1c
    80003e72:	cca50513          	addi	a0,a0,-822 # 8001fb38 <log>
    80003e76:	e1ffc0ef          	jal	80000c94 <release>
}
    80003e7a:	a035                	j	80003ea6 <end_op+0x9a>
    80003e7c:	ec4e                	sd	s3,24(sp)
    80003e7e:	e852                	sd	s4,16(sp)
    80003e80:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003e82:	00003517          	auipc	a0,0x3
    80003e86:	67e50513          	addi	a0,a0,1662 # 80007500 <etext+0x500>
    80003e8a:	98ffc0ef          	jal	80000818 <panic>
    wakeup(&log);
    80003e8e:	0001c517          	auipc	a0,0x1c
    80003e92:	caa50513          	addi	a0,a0,-854 # 8001fb38 <log>
    80003e96:	8e2fe0ef          	jal	80001f78 <wakeup>
  release(&log.lock);
    80003e9a:	0001c517          	auipc	a0,0x1c
    80003e9e:	c9e50513          	addi	a0,a0,-866 # 8001fb38 <log>
    80003ea2:	df3fc0ef          	jal	80000c94 <release>
}
    80003ea6:	70e2                	ld	ra,56(sp)
    80003ea8:	7442                	ld	s0,48(sp)
    80003eaa:	74a2                	ld	s1,40(sp)
    80003eac:	7902                	ld	s2,32(sp)
    80003eae:	6121                	addi	sp,sp,64
    80003eb0:	8082                	ret
    80003eb2:	ec4e                	sd	s3,24(sp)
    80003eb4:	e852                	sd	s4,16(sp)
    80003eb6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003eb8:	0001ca97          	auipc	s5,0x1c
    80003ebc:	caca8a93          	addi	s5,s5,-852 # 8001fb64 <log+0x2c>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003ec0:	0001ca17          	auipc	s4,0x1c
    80003ec4:	c78a0a13          	addi	s4,s4,-904 # 8001fb38 <log>
    80003ec8:	018a2583          	lw	a1,24(s4)
    80003ecc:	012585bb          	addw	a1,a1,s2
    80003ed0:	2585                	addiw	a1,a1,1
    80003ed2:	024a2503          	lw	a0,36(s4)
    80003ed6:	e23fe0ef          	jal	80002cf8 <bread>
    80003eda:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003edc:	000aa583          	lw	a1,0(s5)
    80003ee0:	024a2503          	lw	a0,36(s4)
    80003ee4:	e15fe0ef          	jal	80002cf8 <bread>
    80003ee8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003eea:	40000613          	li	a2,1024
    80003eee:	05850593          	addi	a1,a0,88
    80003ef2:	05848513          	addi	a0,s1,88
    80003ef6:	e37fc0ef          	jal	80000d2c <memmove>
    bwrite(to); // write the log
    80003efa:	8526                	mv	a0,s1
    80003efc:	ed3fe0ef          	jal	80002dce <bwrite>
    brelse(from);
    80003f00:	854e                	mv	a0,s3
    80003f02:	efffe0ef          	jal	80002e00 <brelse>
    brelse(to);
    80003f06:	8526                	mv	a0,s1
    80003f08:	ef9fe0ef          	jal	80002e00 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f0c:	2905                	addiw	s2,s2,1
    80003f0e:	0a91                	addi	s5,s5,4
    80003f10:	028a2783          	lw	a5,40(s4)
    80003f14:	faf94ae3          	blt	s2,a5,80003ec8 <end_op+0xbc>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003f18:	cd9ff0ef          	jal	80003bf0 <write_head>
    install_trans(0); // Now install writes to home locations
    80003f1c:	4501                	li	a0,0
    80003f1e:	d31ff0ef          	jal	80003c4e <install_trans>
    log.lh.n = 0;
    80003f22:	0001c797          	auipc	a5,0x1c
    80003f26:	c207af23          	sw	zero,-962(a5) # 8001fb60 <log+0x28>
    write_head(); // Erase the transaction from the log
    80003f2a:	cc7ff0ef          	jal	80003bf0 <write_head>
    80003f2e:	69e2                	ld	s3,24(sp)
    80003f30:	6a42                	ld	s4,16(sp)
    80003f32:	6aa2                	ld	s5,8(sp)
    80003f34:	bf29                	j	80003e4e <end_op+0x42>

0000000080003f36 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003f36:	1101                	addi	sp,sp,-32
    80003f38:	ec06                	sd	ra,24(sp)
    80003f3a:	e822                	sd	s0,16(sp)
    80003f3c:	e426                	sd	s1,8(sp)
    80003f3e:	1000                	addi	s0,sp,32
    80003f40:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003f42:	0001c517          	auipc	a0,0x1c
    80003f46:	bf650513          	addi	a0,a0,-1034 # 8001fb38 <log>
    80003f4a:	cbbfc0ef          	jal	80000c04 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003f4e:	0001c617          	auipc	a2,0x1c
    80003f52:	c1262603          	lw	a2,-1006(a2) # 8001fb60 <log+0x28>
    80003f56:	47f5                	li	a5,29
    80003f58:	04c7cd63          	blt	a5,a2,80003fb2 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003f5c:	0001c797          	auipc	a5,0x1c
    80003f60:	bf87a783          	lw	a5,-1032(a5) # 8001fb54 <log+0x1c>
    80003f64:	04f05d63          	blez	a5,80003fbe <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003f68:	4781                	li	a5,0
    80003f6a:	06c05063          	blez	a2,80003fca <log_write+0x94>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003f6e:	44cc                	lw	a1,12(s1)
    80003f70:	0001c717          	auipc	a4,0x1c
    80003f74:	bf470713          	addi	a4,a4,-1036 # 8001fb64 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003f78:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003f7a:	4314                	lw	a3,0(a4)
    80003f7c:	04b68763          	beq	a3,a1,80003fca <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003f80:	2785                	addiw	a5,a5,1
    80003f82:	0711                	addi	a4,a4,4
    80003f84:	fef61be3          	bne	a2,a5,80003f7a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003f88:	060a                	slli	a2,a2,0x2
    80003f8a:	02060613          	addi	a2,a2,32
    80003f8e:	0001c797          	auipc	a5,0x1c
    80003f92:	baa78793          	addi	a5,a5,-1110 # 8001fb38 <log>
    80003f96:	97b2                	add	a5,a5,a2
    80003f98:	44d8                	lw	a4,12(s1)
    80003f9a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	ee7fe0ef          	jal	80002e84 <bpin>
    log.lh.n++;
    80003fa2:	0001c717          	auipc	a4,0x1c
    80003fa6:	b9670713          	addi	a4,a4,-1130 # 8001fb38 <log>
    80003faa:	571c                	lw	a5,40(a4)
    80003fac:	2785                	addiw	a5,a5,1
    80003fae:	d71c                	sw	a5,40(a4)
    80003fb0:	a815                	j	80003fe4 <log_write+0xae>
    panic("too big a transaction");
    80003fb2:	00003517          	auipc	a0,0x3
    80003fb6:	55e50513          	addi	a0,a0,1374 # 80007510 <etext+0x510>
    80003fba:	85ffc0ef          	jal	80000818 <panic>
    panic("log_write outside of trans");
    80003fbe:	00003517          	auipc	a0,0x3
    80003fc2:	56a50513          	addi	a0,a0,1386 # 80007528 <etext+0x528>
    80003fc6:	853fc0ef          	jal	80000818 <panic>
  log.lh.block[i] = b->blockno;
    80003fca:	00279693          	slli	a3,a5,0x2
    80003fce:	02068693          	addi	a3,a3,32
    80003fd2:	0001c717          	auipc	a4,0x1c
    80003fd6:	b6670713          	addi	a4,a4,-1178 # 8001fb38 <log>
    80003fda:	9736                	add	a4,a4,a3
    80003fdc:	44d4                	lw	a3,12(s1)
    80003fde:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) { // Add new block to log?
    80003fe0:	faf60ee3          	beq	a2,a5,80003f9c <log_write+0x66>
  }
  release(&log.lock);
    80003fe4:	0001c517          	auipc	a0,0x1c
    80003fe8:	b5450513          	addi	a0,a0,-1196 # 8001fb38 <log>
    80003fec:	ca9fc0ef          	jal	80000c94 <release>
}
    80003ff0:	60e2                	ld	ra,24(sp)
    80003ff2:	6442                	ld	s0,16(sp)
    80003ff4:	64a2                	ld	s1,8(sp)
    80003ff6:	6105                	addi	sp,sp,32
    80003ff8:	8082                	ret

0000000080003ffa <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ffa:	1101                	addi	sp,sp,-32
    80003ffc:	ec06                	sd	ra,24(sp)
    80003ffe:	e822                	sd	s0,16(sp)
    80004000:	e426                	sd	s1,8(sp)
    80004002:	e04a                	sd	s2,0(sp)
    80004004:	1000                	addi	s0,sp,32
    80004006:	84aa                	mv	s1,a0
    80004008:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000400a:	00003597          	auipc	a1,0x3
    8000400e:	53e58593          	addi	a1,a1,1342 # 80007548 <etext+0x548>
    80004012:	0521                	addi	a0,a0,8
    80004014:	b67fc0ef          	jal	80000b7a <initlock>
  lk->name = name;
    80004018:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000401c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004020:	0204a423          	sw	zero,40(s1)
}
    80004024:	60e2                	ld	ra,24(sp)
    80004026:	6442                	ld	s0,16(sp)
    80004028:	64a2                	ld	s1,8(sp)
    8000402a:	6902                	ld	s2,0(sp)
    8000402c:	6105                	addi	sp,sp,32
    8000402e:	8082                	ret

0000000080004030 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004030:	1101                	addi	sp,sp,-32
    80004032:	ec06                	sd	ra,24(sp)
    80004034:	e822                	sd	s0,16(sp)
    80004036:	e426                	sd	s1,8(sp)
    80004038:	e04a                	sd	s2,0(sp)
    8000403a:	1000                	addi	s0,sp,32
    8000403c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000403e:	00850913          	addi	s2,a0,8
    80004042:	854a                	mv	a0,s2
    80004044:	bc1fc0ef          	jal	80000c04 <acquire>
  while (lk->locked) {
    80004048:	409c                	lw	a5,0(s1)
    8000404a:	c799                	beqz	a5,80004058 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000404c:	85ca                	mv	a1,s2
    8000404e:	8526                	mv	a0,s1
    80004050:	eddfd0ef          	jal	80001f2c <sleep>
  while (lk->locked) {
    80004054:	409c                	lw	a5,0(s1)
    80004056:	fbfd                	bnez	a5,8000404c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004058:	4785                	li	a5,1
    8000405a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000405c:	8a7fd0ef          	jal	80001902 <myproc>
    80004060:	5d1c                	lw	a5,56(a0)
    80004062:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004064:	854a                	mv	a0,s2
    80004066:	c2ffc0ef          	jal	80000c94 <release>
}
    8000406a:	60e2                	ld	ra,24(sp)
    8000406c:	6442                	ld	s0,16(sp)
    8000406e:	64a2                	ld	s1,8(sp)
    80004070:	6902                	ld	s2,0(sp)
    80004072:	6105                	addi	sp,sp,32
    80004074:	8082                	ret

0000000080004076 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004076:	1101                	addi	sp,sp,-32
    80004078:	ec06                	sd	ra,24(sp)
    8000407a:	e822                	sd	s0,16(sp)
    8000407c:	e426                	sd	s1,8(sp)
    8000407e:	e04a                	sd	s2,0(sp)
    80004080:	1000                	addi	s0,sp,32
    80004082:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004084:	00850913          	addi	s2,a0,8
    80004088:	854a                	mv	a0,s2
    8000408a:	b7bfc0ef          	jal	80000c04 <acquire>
  lk->locked = 0;
    8000408e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004092:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004096:	8526                	mv	a0,s1
    80004098:	ee1fd0ef          	jal	80001f78 <wakeup>
  release(&lk->lk);
    8000409c:	854a                	mv	a0,s2
    8000409e:	bf7fc0ef          	jal	80000c94 <release>
}
    800040a2:	60e2                	ld	ra,24(sp)
    800040a4:	6442                	ld	s0,16(sp)
    800040a6:	64a2                	ld	s1,8(sp)
    800040a8:	6902                	ld	s2,0(sp)
    800040aa:	6105                	addi	sp,sp,32
    800040ac:	8082                	ret

00000000800040ae <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800040ae:	7179                	addi	sp,sp,-48
    800040b0:	f406                	sd	ra,40(sp)
    800040b2:	f022                	sd	s0,32(sp)
    800040b4:	ec26                	sd	s1,24(sp)
    800040b6:	e84a                	sd	s2,16(sp)
    800040b8:	1800                	addi	s0,sp,48
    800040ba:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    800040bc:	00850913          	addi	s2,a0,8
    800040c0:	854a                	mv	a0,s2
    800040c2:	b43fc0ef          	jal	80000c04 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800040c6:	409c                	lw	a5,0(s1)
    800040c8:	ef81                	bnez	a5,800040e0 <holdingsleep+0x32>
    800040ca:	4481                	li	s1,0
  release(&lk->lk);
    800040cc:	854a                	mv	a0,s2
    800040ce:	bc7fc0ef          	jal	80000c94 <release>
  return r;
}
    800040d2:	8526                	mv	a0,s1
    800040d4:	70a2                	ld	ra,40(sp)
    800040d6:	7402                	ld	s0,32(sp)
    800040d8:	64e2                	ld	s1,24(sp)
    800040da:	6942                	ld	s2,16(sp)
    800040dc:	6145                	addi	sp,sp,48
    800040de:	8082                	ret
    800040e0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800040e2:	0284a983          	lw	s3,40(s1)
    800040e6:	81dfd0ef          	jal	80001902 <myproc>
    800040ea:	5d04                	lw	s1,56(a0)
    800040ec:	413484b3          	sub	s1,s1,s3
    800040f0:	0014b493          	seqz	s1,s1
    800040f4:	69a2                	ld	s3,8(sp)
    800040f6:	bfd9                	j	800040cc <holdingsleep+0x1e>

00000000800040f8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800040f8:	1141                	addi	sp,sp,-16
    800040fa:	e406                	sd	ra,8(sp)
    800040fc:	e022                	sd	s0,0(sp)
    800040fe:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004100:	00003597          	auipc	a1,0x3
    80004104:	45858593          	addi	a1,a1,1112 # 80007558 <etext+0x558>
    80004108:	0001c517          	auipc	a0,0x1c
    8000410c:	b7850513          	addi	a0,a0,-1160 # 8001fc80 <ftable>
    80004110:	a6bfc0ef          	jal	80000b7a <initlock>
}
    80004114:	60a2                	ld	ra,8(sp)
    80004116:	6402                	ld	s0,0(sp)
    80004118:	0141                	addi	sp,sp,16
    8000411a:	8082                	ret

000000008000411c <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    8000411c:	1101                	addi	sp,sp,-32
    8000411e:	ec06                	sd	ra,24(sp)
    80004120:	e822                	sd	s0,16(sp)
    80004122:	e426                	sd	s1,8(sp)
    80004124:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004126:	0001c517          	auipc	a0,0x1c
    8000412a:	b5a50513          	addi	a0,a0,-1190 # 8001fc80 <ftable>
    8000412e:	ad7fc0ef          	jal	80000c04 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004132:	0001c497          	auipc	s1,0x1c
    80004136:	b6648493          	addi	s1,s1,-1178 # 8001fc98 <ftable+0x18>
    8000413a:	0001d717          	auipc	a4,0x1d
    8000413e:	afe70713          	addi	a4,a4,-1282 # 80020c38 <disk>
    if (f->ref == 0) {
    80004142:	40dc                	lw	a5,4(s1)
    80004144:	cf89                	beqz	a5,8000415e <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004146:	02848493          	addi	s1,s1,40
    8000414a:	fee49ce3          	bne	s1,a4,80004142 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000414e:	0001c517          	auipc	a0,0x1c
    80004152:	b3250513          	addi	a0,a0,-1230 # 8001fc80 <ftable>
    80004156:	b3ffc0ef          	jal	80000c94 <release>
  return 0;
    8000415a:	4481                	li	s1,0
    8000415c:	a809                	j	8000416e <filealloc+0x52>
      f->ref = 1;
    8000415e:	4785                	li	a5,1
    80004160:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004162:	0001c517          	auipc	a0,0x1c
    80004166:	b1e50513          	addi	a0,a0,-1250 # 8001fc80 <ftable>
    8000416a:	b2bfc0ef          	jal	80000c94 <release>
}
    8000416e:	8526                	mv	a0,s1
    80004170:	60e2                	ld	ra,24(sp)
    80004172:	6442                	ld	s0,16(sp)
    80004174:	64a2                	ld	s1,8(sp)
    80004176:	6105                	addi	sp,sp,32
    80004178:	8082                	ret

000000008000417a <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    8000417a:	1101                	addi	sp,sp,-32
    8000417c:	ec06                	sd	ra,24(sp)
    8000417e:	e822                	sd	s0,16(sp)
    80004180:	e426                	sd	s1,8(sp)
    80004182:	1000                	addi	s0,sp,32
    80004184:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004186:	0001c517          	auipc	a0,0x1c
    8000418a:	afa50513          	addi	a0,a0,-1286 # 8001fc80 <ftable>
    8000418e:	a77fc0ef          	jal	80000c04 <acquire>
  if (f->ref < 1)
    80004192:	40dc                	lw	a5,4(s1)
    80004194:	02f05063          	blez	a5,800041b4 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004198:	2785                	addiw	a5,a5,1
    8000419a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000419c:	0001c517          	auipc	a0,0x1c
    800041a0:	ae450513          	addi	a0,a0,-1308 # 8001fc80 <ftable>
    800041a4:	af1fc0ef          	jal	80000c94 <release>
  return f;
}
    800041a8:	8526                	mv	a0,s1
    800041aa:	60e2                	ld	ra,24(sp)
    800041ac:	6442                	ld	s0,16(sp)
    800041ae:	64a2                	ld	s1,8(sp)
    800041b0:	6105                	addi	sp,sp,32
    800041b2:	8082                	ret
    panic("filedup");
    800041b4:	00003517          	auipc	a0,0x3
    800041b8:	3ac50513          	addi	a0,a0,940 # 80007560 <etext+0x560>
    800041bc:	e5cfc0ef          	jal	80000818 <panic>

00000000800041c0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800041c0:	7139                	addi	sp,sp,-64
    800041c2:	fc06                	sd	ra,56(sp)
    800041c4:	f822                	sd	s0,48(sp)
    800041c6:	f426                	sd	s1,40(sp)
    800041c8:	0080                	addi	s0,sp,64
    800041ca:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800041cc:	0001c517          	auipc	a0,0x1c
    800041d0:	ab450513          	addi	a0,a0,-1356 # 8001fc80 <ftable>
    800041d4:	a31fc0ef          	jal	80000c04 <acquire>
  if (f->ref < 1)
    800041d8:	40dc                	lw	a5,4(s1)
    800041da:	04f05a63          	blez	a5,8000422e <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    800041de:	37fd                	addiw	a5,a5,-1
    800041e0:	c0dc                	sw	a5,4(s1)
    800041e2:	06f04063          	bgtz	a5,80004242 <fileclose+0x82>
    800041e6:	f04a                	sd	s2,32(sp)
    800041e8:	ec4e                	sd	s3,24(sp)
    800041ea:	e852                	sd	s4,16(sp)
    800041ec:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800041ee:	0004a903          	lw	s2,0(s1)
    800041f2:	0094c783          	lbu	a5,9(s1)
    800041f6:	89be                	mv	s3,a5
    800041f8:	689c                	ld	a5,16(s1)
    800041fa:	8a3e                	mv	s4,a5
    800041fc:	6c9c                	ld	a5,24(s1)
    800041fe:	8abe                	mv	s5,a5
  f->ref = 0;
    80004200:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004204:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004208:	0001c517          	auipc	a0,0x1c
    8000420c:	a7850513          	addi	a0,a0,-1416 # 8001fc80 <ftable>
    80004210:	a85fc0ef          	jal	80000c94 <release>

  if (ff.type == FD_PIPE) {
    80004214:	4785                	li	a5,1
    80004216:	04f90163          	beq	s2,a5,80004258 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    8000421a:	ffe9079b          	addiw	a5,s2,-2
    8000421e:	4705                	li	a4,1
    80004220:	04f77563          	bgeu	a4,a5,8000426a <fileclose+0xaa>
    80004224:	7902                	ld	s2,32(sp)
    80004226:	69e2                	ld	s3,24(sp)
    80004228:	6a42                	ld	s4,16(sp)
    8000422a:	6aa2                	ld	s5,8(sp)
    8000422c:	a00d                	j	8000424e <fileclose+0x8e>
    8000422e:	f04a                	sd	s2,32(sp)
    80004230:	ec4e                	sd	s3,24(sp)
    80004232:	e852                	sd	s4,16(sp)
    80004234:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004236:	00003517          	auipc	a0,0x3
    8000423a:	33250513          	addi	a0,a0,818 # 80007568 <etext+0x568>
    8000423e:	ddafc0ef          	jal	80000818 <panic>
    release(&ftable.lock);
    80004242:	0001c517          	auipc	a0,0x1c
    80004246:	a3e50513          	addi	a0,a0,-1474 # 8001fc80 <ftable>
    8000424a:	a4bfc0ef          	jal	80000c94 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000424e:	70e2                	ld	ra,56(sp)
    80004250:	7442                	ld	s0,48(sp)
    80004252:	74a2                	ld	s1,40(sp)
    80004254:	6121                	addi	sp,sp,64
    80004256:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004258:	85ce                	mv	a1,s3
    8000425a:	8552                	mv	a0,s4
    8000425c:	348000ef          	jal	800045a4 <pipeclose>
    80004260:	7902                	ld	s2,32(sp)
    80004262:	69e2                	ld	s3,24(sp)
    80004264:	6a42                	ld	s4,16(sp)
    80004266:	6aa2                	ld	s5,8(sp)
    80004268:	b7dd                	j	8000424e <fileclose+0x8e>
    begin_op();
    8000426a:	b33ff0ef          	jal	80003d9c <begin_op>
    iput(ff.ip);
    8000426e:	8556                	mv	a0,s5
    80004270:	aa2ff0ef          	jal	80003512 <iput>
    end_op();
    80004274:	b99ff0ef          	jal	80003e0c <end_op>
    80004278:	7902                	ld	s2,32(sp)
    8000427a:	69e2                	ld	s3,24(sp)
    8000427c:	6a42                	ld	s4,16(sp)
    8000427e:	6aa2                	ld	s5,8(sp)
    80004280:	b7f9                	j	8000424e <fileclose+0x8e>

0000000080004282 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004282:	715d                	addi	sp,sp,-80
    80004284:	e486                	sd	ra,72(sp)
    80004286:	e0a2                	sd	s0,64(sp)
    80004288:	fc26                	sd	s1,56(sp)
    8000428a:	f052                	sd	s4,32(sp)
    8000428c:	0880                	addi	s0,sp,80
    8000428e:	84aa                	mv	s1,a0
    80004290:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004292:	e70fd0ef          	jal	80001902 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80004296:	409c                	lw	a5,0(s1)
    80004298:	37f9                	addiw	a5,a5,-2
    8000429a:	4705                	li	a4,1
    8000429c:	04f76263          	bltu	a4,a5,800042e0 <filestat+0x5e>
    800042a0:	f84a                	sd	s2,48(sp)
    800042a2:	f44e                	sd	s3,40(sp)
    800042a4:	89aa                	mv	s3,a0
    ilock(f->ip);
    800042a6:	6c88                	ld	a0,24(s1)
    800042a8:	8e8ff0ef          	jal	80003390 <ilock>
    stati(f->ip, &st);
    800042ac:	fb840913          	addi	s2,s0,-72
    800042b0:	85ca                	mv	a1,s2
    800042b2:	6c88                	ld	a0,24(s1)
    800042b4:	c40ff0ef          	jal	800036f4 <stati>
    iunlock(f->ip);
    800042b8:	6c88                	ld	a0,24(s1)
    800042ba:	984ff0ef          	jal	8000343e <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800042be:	46e1                	li	a3,24
    800042c0:	864a                	mv	a2,s2
    800042c2:	85d2                	mv	a1,s4
    800042c4:	0589b503          	ld	a0,88(s3)
    800042c8:	b60fd0ef          	jal	80001628 <copyout>
    800042cc:	41f5551b          	sraiw	a0,a0,0x1f
    800042d0:	7942                	ld	s2,48(sp)
    800042d2:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800042d4:	60a6                	ld	ra,72(sp)
    800042d6:	6406                	ld	s0,64(sp)
    800042d8:	74e2                	ld	s1,56(sp)
    800042da:	7a02                	ld	s4,32(sp)
    800042dc:	6161                	addi	sp,sp,80
    800042de:	8082                	ret
  return -1;
    800042e0:	557d                	li	a0,-1
    800042e2:	bfcd                	j	800042d4 <filestat+0x52>

00000000800042e4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042e4:	7179                	addi	sp,sp,-48
    800042e6:	f406                	sd	ra,40(sp)
    800042e8:	f022                	sd	s0,32(sp)
    800042ea:	e84a                	sd	s2,16(sp)
    800042ec:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0)
    800042ee:	00854783          	lbu	a5,8(a0)
    800042f2:	cfd1                	beqz	a5,8000438e <fileread+0xaa>
    800042f4:	ec26                	sd	s1,24(sp)
    800042f6:	e44e                	sd	s3,8(sp)
    800042f8:	84aa                	mv	s1,a0
    800042fa:	892e                	mv	s2,a1
    800042fc:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    800042fe:	411c                	lw	a5,0(a0)
    80004300:	4705                	li	a4,1
    80004302:	04e78363          	beq	a5,a4,80004348 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004306:	470d                	li	a4,3
    80004308:	04e78763          	beq	a5,a4,80004356 <fileread+0x72>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000430c:	4709                	li	a4,2
    8000430e:	06e79a63          	bne	a5,a4,80004382 <fileread+0x9e>
    ilock(f->ip);
    80004312:	6d08                	ld	a0,24(a0)
    80004314:	87cff0ef          	jal	80003390 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004318:	874e                	mv	a4,s3
    8000431a:	5094                	lw	a3,32(s1)
    8000431c:	864a                	mv	a2,s2
    8000431e:	4585                	li	a1,1
    80004320:	6c88                	ld	a0,24(s1)
    80004322:	c00ff0ef          	jal	80003722 <readi>
    80004326:	892a                	mv	s2,a0
    80004328:	00a05563          	blez	a0,80004332 <fileread+0x4e>
      f->off += r;
    8000432c:	509c                	lw	a5,32(s1)
    8000432e:	9fa9                	addw	a5,a5,a0
    80004330:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004332:	6c88                	ld	a0,24(s1)
    80004334:	90aff0ef          	jal	8000343e <iunlock>
    80004338:	64e2                	ld	s1,24(sp)
    8000433a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000433c:	854a                	mv	a0,s2
    8000433e:	70a2                	ld	ra,40(sp)
    80004340:	7402                	ld	s0,32(sp)
    80004342:	6942                	ld	s2,16(sp)
    80004344:	6145                	addi	sp,sp,48
    80004346:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004348:	6908                	ld	a0,16(a0)
    8000434a:	3b0000ef          	jal	800046fa <piperead>
    8000434e:	892a                	mv	s2,a0
    80004350:	64e2                	ld	s1,24(sp)
    80004352:	69a2                	ld	s3,8(sp)
    80004354:	b7e5                	j	8000433c <fileread+0x58>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004356:	02451783          	lh	a5,36(a0)
    8000435a:	03079693          	slli	a3,a5,0x30
    8000435e:	92c1                	srli	a3,a3,0x30
    80004360:	4725                	li	a4,9
    80004362:	02d76963          	bltu	a4,a3,80004394 <fileread+0xb0>
    80004366:	0792                	slli	a5,a5,0x4
    80004368:	0001c717          	auipc	a4,0x1c
    8000436c:	87870713          	addi	a4,a4,-1928 # 8001fbe0 <devsw>
    80004370:	97ba                	add	a5,a5,a4
    80004372:	639c                	ld	a5,0(a5)
    80004374:	c78d                	beqz	a5,8000439e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004376:	4505                	li	a0,1
    80004378:	9782                	jalr	a5
    8000437a:	892a                	mv	s2,a0
    8000437c:	64e2                	ld	s1,24(sp)
    8000437e:	69a2                	ld	s3,8(sp)
    80004380:	bf75                	j	8000433c <fileread+0x58>
    panic("fileread");
    80004382:	00003517          	auipc	a0,0x3
    80004386:	1f650513          	addi	a0,a0,502 # 80007578 <etext+0x578>
    8000438a:	c8efc0ef          	jal	80000818 <panic>
    return -1;
    8000438e:	57fd                	li	a5,-1
    80004390:	893e                	mv	s2,a5
    80004392:	b76d                	j	8000433c <fileread+0x58>
      return -1;
    80004394:	57fd                	li	a5,-1
    80004396:	893e                	mv	s2,a5
    80004398:	64e2                	ld	s1,24(sp)
    8000439a:	69a2                	ld	s3,8(sp)
    8000439c:	b745                	j	8000433c <fileread+0x58>
    8000439e:	57fd                	li	a5,-1
    800043a0:	893e                	mv	s2,a5
    800043a2:	64e2                	ld	s1,24(sp)
    800043a4:	69a2                	ld	s3,8(sp)
    800043a6:	bf59                	j	8000433c <fileread+0x58>

00000000800043a8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0)
    800043a8:	00954783          	lbu	a5,9(a0)
    800043ac:	10078f63          	beqz	a5,800044ca <filewrite+0x122>
{
    800043b0:	711d                	addi	sp,sp,-96
    800043b2:	ec86                	sd	ra,88(sp)
    800043b4:	e8a2                	sd	s0,80(sp)
    800043b6:	e0ca                	sd	s2,64(sp)
    800043b8:	f456                	sd	s5,40(sp)
    800043ba:	f05a                	sd	s6,32(sp)
    800043bc:	1080                	addi	s0,sp,96
    800043be:	892a                	mv	s2,a0
    800043c0:	8b2e                	mv	s6,a1
    800043c2:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    800043c4:	411c                	lw	a5,0(a0)
    800043c6:	4705                	li	a4,1
    800043c8:	02e78a63          	beq	a5,a4,800043fc <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800043cc:	470d                	li	a4,3
    800043ce:	02e78b63          	beq	a5,a4,80004404 <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    800043d2:	4709                	li	a4,2
    800043d4:	0ce79f63          	bne	a5,a4,800044b2 <filewrite+0x10a>
    800043d8:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    800043da:	0ac05a63          	blez	a2,8000448e <filewrite+0xe6>
    800043de:	e4a6                	sd	s1,72(sp)
    800043e0:	fc4e                	sd	s3,56(sp)
    800043e2:	ec5e                	sd	s7,24(sp)
    800043e4:	e862                	sd	s8,16(sp)
    800043e6:	e466                	sd	s9,8(sp)
    int i = 0;
    800043e8:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    800043ea:	6b85                	lui	s7,0x1
    800043ec:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800043f0:	6785                	lui	a5,0x1
    800043f2:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800043f6:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043f8:	4c05                	li	s8,1
    800043fa:	a8ad                	j	80004474 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800043fc:	6908                	ld	a0,16(a0)
    800043fe:	204000ef          	jal	80004602 <pipewrite>
    80004402:	a04d                	j	800044a4 <filewrite+0xfc>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004404:	02451783          	lh	a5,36(a0)
    80004408:	03079693          	slli	a3,a5,0x30
    8000440c:	92c1                	srli	a3,a3,0x30
    8000440e:	4725                	li	a4,9
    80004410:	0ad76f63          	bltu	a4,a3,800044ce <filewrite+0x126>
    80004414:	0792                	slli	a5,a5,0x4
    80004416:	0001b717          	auipc	a4,0x1b
    8000441a:	7ca70713          	addi	a4,a4,1994 # 8001fbe0 <devsw>
    8000441e:	97ba                	add	a5,a5,a4
    80004420:	679c                	ld	a5,8(a5)
    80004422:	cbc5                	beqz	a5,800044d2 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80004424:	4505                	li	a0,1
    80004426:	9782                	jalr	a5
    80004428:	a8b5                	j	800044a4 <filewrite+0xfc>
      if (n1 > max)
    8000442a:	2981                	sext.w	s3,s3
      begin_op();
    8000442c:	971ff0ef          	jal	80003d9c <begin_op>
      ilock(f->ip);
    80004430:	01893503          	ld	a0,24(s2)
    80004434:	f5dfe0ef          	jal	80003390 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004438:	874e                	mv	a4,s3
    8000443a:	02092683          	lw	a3,32(s2)
    8000443e:	016a0633          	add	a2,s4,s6
    80004442:	85e2                	mv	a1,s8
    80004444:	01893503          	ld	a0,24(s2)
    80004448:	bccff0ef          	jal	80003814 <writei>
    8000444c:	84aa                	mv	s1,a0
    8000444e:	00a05763          	blez	a0,8000445c <filewrite+0xb4>
        f->off += r;
    80004452:	02092783          	lw	a5,32(s2)
    80004456:	9fa9                	addw	a5,a5,a0
    80004458:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000445c:	01893503          	ld	a0,24(s2)
    80004460:	fdffe0ef          	jal	8000343e <iunlock>
      end_op();
    80004464:	9a9ff0ef          	jal	80003e0c <end_op>

      if (r != n1) {
    80004468:	02999563          	bne	s3,s1,80004492 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000446c:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    80004470:	015a5963          	bge	s4,s5,80004482 <filewrite+0xda>
      int n1 = n - i;
    80004474:	414a87bb          	subw	a5,s5,s4
    80004478:	89be                	mv	s3,a5
      if (n1 > max)
    8000447a:	fafbd8e3          	bge	s7,a5,8000442a <filewrite+0x82>
    8000447e:	89e6                	mv	s3,s9
    80004480:	b76d                	j	8000442a <filewrite+0x82>
    80004482:	64a6                	ld	s1,72(sp)
    80004484:	79e2                	ld	s3,56(sp)
    80004486:	6be2                	ld	s7,24(sp)
    80004488:	6c42                	ld	s8,16(sp)
    8000448a:	6ca2                	ld	s9,8(sp)
    8000448c:	a801                	j	8000449c <filewrite+0xf4>
    int i = 0;
    8000448e:	4a01                	li	s4,0
    80004490:	a031                	j	8000449c <filewrite+0xf4>
    80004492:	64a6                	ld	s1,72(sp)
    80004494:	79e2                	ld	s3,56(sp)
    80004496:	6be2                	ld	s7,24(sp)
    80004498:	6c42                	ld	s8,16(sp)
    8000449a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000449c:	034a9d63          	bne	s5,s4,800044d6 <filewrite+0x12e>
    800044a0:	8556                	mv	a0,s5
    800044a2:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800044a4:	60e6                	ld	ra,88(sp)
    800044a6:	6446                	ld	s0,80(sp)
    800044a8:	6906                	ld	s2,64(sp)
    800044aa:	7aa2                	ld	s5,40(sp)
    800044ac:	7b02                	ld	s6,32(sp)
    800044ae:	6125                	addi	sp,sp,96
    800044b0:	8082                	ret
    800044b2:	e4a6                	sd	s1,72(sp)
    800044b4:	fc4e                	sd	s3,56(sp)
    800044b6:	f852                	sd	s4,48(sp)
    800044b8:	ec5e                	sd	s7,24(sp)
    800044ba:	e862                	sd	s8,16(sp)
    800044bc:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800044be:	00003517          	auipc	a0,0x3
    800044c2:	0ca50513          	addi	a0,a0,202 # 80007588 <etext+0x588>
    800044c6:	b52fc0ef          	jal	80000818 <panic>
    return -1;
    800044ca:	557d                	li	a0,-1
}
    800044cc:	8082                	ret
      return -1;
    800044ce:	557d                	li	a0,-1
    800044d0:	bfd1                	j	800044a4 <filewrite+0xfc>
    800044d2:	557d                	li	a0,-1
    800044d4:	bfc1                	j	800044a4 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800044d6:	557d                	li	a0,-1
    800044d8:	7a42                	ld	s4,48(sp)
    800044da:	b7e9                	j	800044a4 <filewrite+0xfc>

00000000800044dc <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800044dc:	7179                	addi	sp,sp,-48
    800044de:	f406                	sd	ra,40(sp)
    800044e0:	f022                	sd	s0,32(sp)
    800044e2:	ec26                	sd	s1,24(sp)
    800044e4:	e052                	sd	s4,0(sp)
    800044e6:	1800                	addi	s0,sp,48
    800044e8:	84aa                	mv	s1,a0
    800044ea:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800044ec:	0005b023          	sd	zero,0(a1)
    800044f0:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044f4:	c29ff0ef          	jal	8000411c <filealloc>
    800044f8:	e088                	sd	a0,0(s1)
    800044fa:	c549                	beqz	a0,80004584 <pipealloc+0xa8>
    800044fc:	c21ff0ef          	jal	8000411c <filealloc>
    80004500:	00aa3023          	sd	a0,0(s4)
    80004504:	cd25                	beqz	a0,8000457c <pipealloc+0xa0>
    80004506:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80004508:	e18fc0ef          	jal	80000b20 <kalloc>
    8000450c:	892a                	mv	s2,a0
    8000450e:	c12d                	beqz	a0,80004570 <pipealloc+0x94>
    80004510:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004512:	4985                	li	s3,1
    80004514:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004518:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000451c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004520:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004524:	00003597          	auipc	a1,0x3
    80004528:	07458593          	addi	a1,a1,116 # 80007598 <etext+0x598>
    8000452c:	e4efc0ef          	jal	80000b7a <initlock>
  (*f0)->type = FD_PIPE;
    80004530:	609c                	ld	a5,0(s1)
    80004532:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004536:	609c                	ld	a5,0(s1)
    80004538:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000453c:	609c                	ld	a5,0(s1)
    8000453e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004542:	609c                	ld	a5,0(s1)
    80004544:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004548:	000a3783          	ld	a5,0(s4)
    8000454c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004550:	000a3783          	ld	a5,0(s4)
    80004554:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004558:	000a3783          	ld	a5,0(s4)
    8000455c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004560:	000a3783          	ld	a5,0(s4)
    80004564:	0127b823          	sd	s2,16(a5)
  return 0;
    80004568:	4501                	li	a0,0
    8000456a:	6942                	ld	s2,16(sp)
    8000456c:	69a2                	ld	s3,8(sp)
    8000456e:	a01d                	j	80004594 <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004570:	6088                	ld	a0,0(s1)
    80004572:	c119                	beqz	a0,80004578 <pipealloc+0x9c>
    80004574:	6942                	ld	s2,16(sp)
    80004576:	a029                	j	80004580 <pipealloc+0xa4>
    80004578:	6942                	ld	s2,16(sp)
    8000457a:	a029                	j	80004584 <pipealloc+0xa8>
    8000457c:	6088                	ld	a0,0(s1)
    8000457e:	c10d                	beqz	a0,800045a0 <pipealloc+0xc4>
    fileclose(*f0);
    80004580:	c41ff0ef          	jal	800041c0 <fileclose>
  if (*f1)
    80004584:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004588:	557d                	li	a0,-1
  if (*f1)
    8000458a:	c789                	beqz	a5,80004594 <pipealloc+0xb8>
    fileclose(*f1);
    8000458c:	853e                	mv	a0,a5
    8000458e:	c33ff0ef          	jal	800041c0 <fileclose>
  return -1;
    80004592:	557d                	li	a0,-1
}
    80004594:	70a2                	ld	ra,40(sp)
    80004596:	7402                	ld	s0,32(sp)
    80004598:	64e2                	ld	s1,24(sp)
    8000459a:	6a02                	ld	s4,0(sp)
    8000459c:	6145                	addi	sp,sp,48
    8000459e:	8082                	ret
  return -1;
    800045a0:	557d                	li	a0,-1
    800045a2:	bfcd                	j	80004594 <pipealloc+0xb8>

00000000800045a4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800045a4:	1101                	addi	sp,sp,-32
    800045a6:	ec06                	sd	ra,24(sp)
    800045a8:	e822                	sd	s0,16(sp)
    800045aa:	e426                	sd	s1,8(sp)
    800045ac:	e04a                	sd	s2,0(sp)
    800045ae:	1000                	addi	s0,sp,32
    800045b0:	84aa                	mv	s1,a0
    800045b2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800045b4:	e50fc0ef          	jal	80000c04 <acquire>
  if (writable) {
    800045b8:	02090763          	beqz	s2,800045e6 <pipeclose+0x42>
    pi->writeopen = 0;
    800045bc:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800045c0:	21848513          	addi	a0,s1,536
    800045c4:	9b5fd0ef          	jal	80001f78 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800045c8:	2204a783          	lw	a5,544(s1)
    800045cc:	e781                	bnez	a5,800045d4 <pipeclose+0x30>
    800045ce:	2244a783          	lw	a5,548(s1)
    800045d2:	c38d                	beqz	a5,800045f4 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    800045d4:	8526                	mv	a0,s1
    800045d6:	ebefc0ef          	jal	80000c94 <release>
}
    800045da:	60e2                	ld	ra,24(sp)
    800045dc:	6442                	ld	s0,16(sp)
    800045de:	64a2                	ld	s1,8(sp)
    800045e0:	6902                	ld	s2,0(sp)
    800045e2:	6105                	addi	sp,sp,32
    800045e4:	8082                	ret
    pi->readopen = 0;
    800045e6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800045ea:	21c48513          	addi	a0,s1,540
    800045ee:	98bfd0ef          	jal	80001f78 <wakeup>
    800045f2:	bfd9                	j	800045c8 <pipeclose+0x24>
    release(&pi->lock);
    800045f4:	8526                	mv	a0,s1
    800045f6:	e9efc0ef          	jal	80000c94 <release>
    kfree((char *)pi);
    800045fa:	8526                	mv	a0,s1
    800045fc:	c3cfc0ef          	jal	80000a38 <kfree>
    80004600:	bfe9                	j	800045da <pipeclose+0x36>

0000000080004602 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004602:	7159                	addi	sp,sp,-112
    80004604:	f486                	sd	ra,104(sp)
    80004606:	f0a2                	sd	s0,96(sp)
    80004608:	eca6                	sd	s1,88(sp)
    8000460a:	e8ca                	sd	s2,80(sp)
    8000460c:	e4ce                	sd	s3,72(sp)
    8000460e:	e0d2                	sd	s4,64(sp)
    80004610:	fc56                	sd	s5,56(sp)
    80004612:	1880                	addi	s0,sp,112
    80004614:	84aa                	mv	s1,a0
    80004616:	8aae                	mv	s5,a1
    80004618:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000461a:	ae8fd0ef          	jal	80001902 <myproc>
    8000461e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004620:	8526                	mv	a0,s1
    80004622:	de2fc0ef          	jal	80000c04 <acquire>
  while (i < n) {
    80004626:	0d405263          	blez	s4,800046ea <pipewrite+0xe8>
    8000462a:	f85a                	sd	s6,48(sp)
    8000462c:	f45e                	sd	s7,40(sp)
    8000462e:	f062                	sd	s8,32(sp)
    80004630:	ec66                	sd	s9,24(sp)
    80004632:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004634:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004636:	f9f40c13          	addi	s8,s0,-97
    8000463a:	4b85                	li	s7,1
    8000463c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000463e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004642:	21c48c93          	addi	s9,s1,540
    80004646:	a82d                	j	80004680 <pipewrite+0x7e>
      release(&pi->lock);
    80004648:	8526                	mv	a0,s1
    8000464a:	e4afc0ef          	jal	80000c94 <release>
      return -1;
    8000464e:	597d                	li	s2,-1
    80004650:	7b42                	ld	s6,48(sp)
    80004652:	7ba2                	ld	s7,40(sp)
    80004654:	7c02                	ld	s8,32(sp)
    80004656:	6ce2                	ld	s9,24(sp)
    80004658:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000465a:	854a                	mv	a0,s2
    8000465c:	70a6                	ld	ra,104(sp)
    8000465e:	7406                	ld	s0,96(sp)
    80004660:	64e6                	ld	s1,88(sp)
    80004662:	6946                	ld	s2,80(sp)
    80004664:	69a6                	ld	s3,72(sp)
    80004666:	6a06                	ld	s4,64(sp)
    80004668:	7ae2                	ld	s5,56(sp)
    8000466a:	6165                	addi	sp,sp,112
    8000466c:	8082                	ret
      wakeup(&pi->nread);
    8000466e:	856a                	mv	a0,s10
    80004670:	909fd0ef          	jal	80001f78 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004674:	85a6                	mv	a1,s1
    80004676:	8566                	mv	a0,s9
    80004678:	8b5fd0ef          	jal	80001f2c <sleep>
  while (i < n) {
    8000467c:	05495a63          	bge	s2,s4,800046d0 <pipewrite+0xce>
    if (pi->readopen == 0 || killed(pr)) {
    80004680:	2204a783          	lw	a5,544(s1)
    80004684:	d3f1                	beqz	a5,80004648 <pipewrite+0x46>
    80004686:	854e                	mv	a0,s3
    80004688:	ae1fd0ef          	jal	80002168 <killed>
    8000468c:	fd55                	bnez	a0,80004648 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    8000468e:	2184a783          	lw	a5,536(s1)
    80004692:	21c4a703          	lw	a4,540(s1)
    80004696:	2007879b          	addiw	a5,a5,512
    8000469a:	fcf70ae3          	beq	a4,a5,8000466e <pipewrite+0x6c>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000469e:	86de                	mv	a3,s7
    800046a0:	01590633          	add	a2,s2,s5
    800046a4:	85e2                	mv	a1,s8
    800046a6:	0589b503          	ld	a0,88(s3)
    800046aa:	83cfd0ef          	jal	800016e6 <copyin>
    800046ae:	05650063          	beq	a0,s6,800046ee <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800046b2:	21c4a783          	lw	a5,540(s1)
    800046b6:	0017871b          	addiw	a4,a5,1
    800046ba:	20e4ae23          	sw	a4,540(s1)
    800046be:	1ff7f793          	andi	a5,a5,511
    800046c2:	97a6                	add	a5,a5,s1
    800046c4:	f9f44703          	lbu	a4,-97(s0)
    800046c8:	00e78c23          	sb	a4,24(a5)
      i++;
    800046cc:	2905                	addiw	s2,s2,1
    800046ce:	b77d                	j	8000467c <pipewrite+0x7a>
    800046d0:	7b42                	ld	s6,48(sp)
    800046d2:	7ba2                	ld	s7,40(sp)
    800046d4:	7c02                	ld	s8,32(sp)
    800046d6:	6ce2                	ld	s9,24(sp)
    800046d8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800046da:	21848513          	addi	a0,s1,536
    800046de:	89bfd0ef          	jal	80001f78 <wakeup>
  release(&pi->lock);
    800046e2:	8526                	mv	a0,s1
    800046e4:	db0fc0ef          	jal	80000c94 <release>
  return i;
    800046e8:	bf8d                	j	8000465a <pipewrite+0x58>
  int i = 0;
    800046ea:	4901                	li	s2,0
    800046ec:	b7fd                	j	800046da <pipewrite+0xd8>
    800046ee:	7b42                	ld	s6,48(sp)
    800046f0:	7ba2                	ld	s7,40(sp)
    800046f2:	7c02                	ld	s8,32(sp)
    800046f4:	6ce2                	ld	s9,24(sp)
    800046f6:	6d42                	ld	s10,16(sp)
    800046f8:	b7cd                	j	800046da <pipewrite+0xd8>

00000000800046fa <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800046fa:	711d                	addi	sp,sp,-96
    800046fc:	ec86                	sd	ra,88(sp)
    800046fe:	e8a2                	sd	s0,80(sp)
    80004700:	e4a6                	sd	s1,72(sp)
    80004702:	e0ca                	sd	s2,64(sp)
    80004704:	fc4e                	sd	s3,56(sp)
    80004706:	f852                	sd	s4,48(sp)
    80004708:	f456                	sd	s5,40(sp)
    8000470a:	1080                	addi	s0,sp,96
    8000470c:	84aa                	mv	s1,a0
    8000470e:	892e                	mv	s2,a1
    80004710:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004712:	9f0fd0ef          	jal	80001902 <myproc>
    80004716:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004718:	8526                	mv	a0,s1
    8000471a:	ceafc0ef          	jal	80000c04 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000471e:	2184a703          	lw	a4,536(s1)
    80004722:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004726:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000472a:	02f71763          	bne	a4,a5,80004758 <piperead+0x5e>
    8000472e:	2244a783          	lw	a5,548(s1)
    80004732:	cf85                	beqz	a5,8000476a <piperead+0x70>
    if (killed(pr)) {
    80004734:	8552                	mv	a0,s4
    80004736:	a33fd0ef          	jal	80002168 <killed>
    8000473a:	e11d                	bnez	a0,80004760 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000473c:	85a6                	mv	a1,s1
    8000473e:	854e                	mv	a0,s3
    80004740:	fecfd0ef          	jal	80001f2c <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004744:	2184a703          	lw	a4,536(s1)
    80004748:	21c4a783          	lw	a5,540(s1)
    8000474c:	fef701e3          	beq	a4,a5,8000472e <piperead+0x34>
    80004750:	f05a                	sd	s6,32(sp)
    80004752:	ec5e                	sd	s7,24(sp)
    80004754:	e862                	sd	s8,16(sp)
    80004756:	a829                	j	80004770 <piperead+0x76>
    80004758:	f05a                	sd	s6,32(sp)
    8000475a:	ec5e                	sd	s7,24(sp)
    8000475c:	e862                	sd	s8,16(sp)
    8000475e:	a809                	j	80004770 <piperead+0x76>
      release(&pi->lock);
    80004760:	8526                	mv	a0,s1
    80004762:	d32fc0ef          	jal	80000c94 <release>
      return -1;
    80004766:	59fd                	li	s3,-1
    80004768:	a0a5                	j	800047d0 <piperead+0xd6>
    8000476a:	f05a                	sd	s6,32(sp)
    8000476c:	ec5e                	sd	s7,24(sp)
    8000476e:	e862                	sd	s8,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004770:	4981                	li	s3,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004772:	faf40c13          	addi	s8,s0,-81
    80004776:	4b85                	li	s7,1
    80004778:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000477a:	05505163          	blez	s5,800047bc <piperead+0xc2>
    if (pi->nread == pi->nwrite)
    8000477e:	2184a783          	lw	a5,536(s1)
    80004782:	21c4a703          	lw	a4,540(s1)
    80004786:	02f70b63          	beq	a4,a5,800047bc <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    8000478a:	1ff7f793          	andi	a5,a5,511
    8000478e:	97a6                	add	a5,a5,s1
    80004790:	0187c783          	lbu	a5,24(a5)
    80004794:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004798:	86de                	mv	a3,s7
    8000479a:	8662                	mv	a2,s8
    8000479c:	85ca                	mv	a1,s2
    8000479e:	058a3503          	ld	a0,88(s4)
    800047a2:	e87fc0ef          	jal	80001628 <copyout>
    800047a6:	03650f63          	beq	a0,s6,800047e4 <piperead+0xea>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800047aa:	2184a783          	lw	a5,536(s1)
    800047ae:	2785                	addiw	a5,a5,1
    800047b0:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800047b4:	2985                	addiw	s3,s3,1
    800047b6:	0905                	addi	s2,s2,1
    800047b8:	fd3a93e3          	bne	s5,s3,8000477e <piperead+0x84>
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    800047bc:	21c48513          	addi	a0,s1,540
    800047c0:	fb8fd0ef          	jal	80001f78 <wakeup>
  release(&pi->lock);
    800047c4:	8526                	mv	a0,s1
    800047c6:	ccefc0ef          	jal	80000c94 <release>
    800047ca:	7b02                	ld	s6,32(sp)
    800047cc:	6be2                	ld	s7,24(sp)
    800047ce:	6c42                	ld	s8,16(sp)
  return i;
}
    800047d0:	854e                	mv	a0,s3
    800047d2:	60e6                	ld	ra,88(sp)
    800047d4:	6446                	ld	s0,80(sp)
    800047d6:	64a6                	ld	s1,72(sp)
    800047d8:	6906                	ld	s2,64(sp)
    800047da:	79e2                	ld	s3,56(sp)
    800047dc:	7a42                	ld	s4,48(sp)
    800047de:	7aa2                	ld	s5,40(sp)
    800047e0:	6125                	addi	sp,sp,96
    800047e2:	8082                	ret
      if (i == 0)
    800047e4:	fc099ce3          	bnez	s3,800047bc <piperead+0xc2>
        i = -1;
    800047e8:	89aa                	mv	s3,a0
    800047ea:	bfc9                	j	800047bc <piperead+0xc2>

00000000800047ec <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    800047ec:	1141                	addi	sp,sp,-16
    800047ee:	e406                	sd	ra,8(sp)
    800047f0:	e022                	sd	s0,0(sp)
    800047f2:	0800                	addi	s0,sp,16
    800047f4:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    800047f6:	0035151b          	slliw	a0,a0,0x3
    800047fa:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    800047fc:	8b89                	andi	a5,a5,2
    800047fe:	c399                	beqz	a5,80004804 <flags2perm+0x18>
    perm |= PTE_W;
    80004800:	00456513          	ori	a0,a0,4
  return perm;
}
    80004804:	60a2                	ld	ra,8(sp)
    80004806:	6402                	ld	s0,0(sp)
    80004808:	0141                	addi	sp,sp,16
    8000480a:	8082                	ret

000000008000480c <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000480c:	de010113          	addi	sp,sp,-544
    80004810:	20113c23          	sd	ra,536(sp)
    80004814:	20813823          	sd	s0,528(sp)
    80004818:	20913423          	sd	s1,520(sp)
    8000481c:	21213023          	sd	s2,512(sp)
    80004820:	1400                	addi	s0,sp,544
    80004822:	892a                	mv	s2,a0
    80004824:	dea43823          	sd	a0,-528(s0)
    80004828:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000482c:	8d6fd0ef          	jal	80001902 <myproc>
    80004830:	84aa                	mv	s1,a0

  begin_op();
    80004832:	d6aff0ef          	jal	80003d9c <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004836:	854a                	mv	a0,s2
    80004838:	b86ff0ef          	jal	80003bbe <namei>
    8000483c:	cd21                	beqz	a0,80004894 <kexec+0x88>
    8000483e:	fbd2                	sd	s4,496(sp)
    80004840:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004842:	b4ffe0ef          	jal	80003390 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004846:	04000713          	li	a4,64
    8000484a:	4681                	li	a3,0
    8000484c:	e5040613          	addi	a2,s0,-432
    80004850:	4581                	li	a1,0
    80004852:	8552                	mv	a0,s4
    80004854:	ecffe0ef          	jal	80003722 <readi>
    80004858:	04000793          	li	a5,64
    8000485c:	00f51a63          	bne	a0,a5,80004870 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80004860:	e5042703          	lw	a4,-432(s0)
    80004864:	464c47b7          	lui	a5,0x464c4
    80004868:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000486c:	02f70863          	beq	a4,a5,8000489c <kexec+0x90>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004870:	8552                	mv	a0,s4
    80004872:	d2bfe0ef          	jal	8000359c <iunlockput>
    end_op();
    80004876:	d96ff0ef          	jal	80003e0c <end_op>
  }
  return -1;
    8000487a:	557d                	li	a0,-1
    8000487c:	7a5e                	ld	s4,496(sp)
}
    8000487e:	21813083          	ld	ra,536(sp)
    80004882:	21013403          	ld	s0,528(sp)
    80004886:	20813483          	ld	s1,520(sp)
    8000488a:	20013903          	ld	s2,512(sp)
    8000488e:	22010113          	addi	sp,sp,544
    80004892:	8082                	ret
    end_op();
    80004894:	d78ff0ef          	jal	80003e0c <end_op>
    return -1;
    80004898:	557d                	li	a0,-1
    8000489a:	b7d5                	j	8000487e <kexec+0x72>
    8000489c:	f3da                	sd	s6,480(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    8000489e:	8526                	mv	a0,s1
    800048a0:	96cfd0ef          	jal	80001a0c <proc_pagetable>
    800048a4:	8b2a                	mv	s6,a0
    800048a6:	26050f63          	beqz	a0,80004b24 <kexec+0x318>
    800048aa:	ffce                	sd	s3,504(sp)
    800048ac:	f7d6                	sd	s5,488(sp)
    800048ae:	efde                	sd	s7,472(sp)
    800048b0:	ebe2                	sd	s8,464(sp)
    800048b2:	e7e6                	sd	s9,456(sp)
    800048b4:	e3ea                	sd	s10,448(sp)
    800048b6:	ff6e                	sd	s11,440(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800048b8:	e8845783          	lhu	a5,-376(s0)
    800048bc:	0e078963          	beqz	a5,800049ae <kexec+0x1a2>
    800048c0:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800048c4:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800048c6:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048c8:	03800d93          	li	s11,56
    if (ph.vaddr % PGSIZE != 0)
    800048cc:	6c85                	lui	s9,0x1
    800048ce:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800048d2:	def43423          	sd	a5,-536(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800048d6:	6a85                	lui	s5,0x1
    800048d8:	a085                	j	80004938 <kexec+0x12c>
      panic("loadseg: address should exist");
    800048da:	00003517          	auipc	a0,0x3
    800048de:	cc650513          	addi	a0,a0,-826 # 800075a0 <etext+0x5a0>
    800048e2:	f37fb0ef          	jal	80000818 <panic>
    if (sz - i < PGSIZE)
    800048e6:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800048e8:	874a                	mv	a4,s2
    800048ea:	009b86bb          	addw	a3,s7,s1
    800048ee:	4581                	li	a1,0
    800048f0:	8552                	mv	a0,s4
    800048f2:	e31fe0ef          	jal	80003722 <readi>
    800048f6:	22a91b63          	bne	s2,a0,80004b2c <kexec+0x320>
  for (i = 0; i < sz; i += PGSIZE) {
    800048fa:	009a84bb          	addw	s1,s5,s1
    800048fe:	0334f263          	bgeu	s1,s3,80004922 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80004902:	02049593          	slli	a1,s1,0x20
    80004906:	9181                	srli	a1,a1,0x20
    80004908:	95e2                	add	a1,a1,s8
    8000490a:	855a                	mv	a0,s6
    8000490c:	eeefc0ef          	jal	80000ffa <walkaddr>
    80004910:	862a                	mv	a2,a0
    if (pa == 0)
    80004912:	d561                	beqz	a0,800048da <kexec+0xce>
    if (sz - i < PGSIZE)
    80004914:	409987bb          	subw	a5,s3,s1
    80004918:	893e                	mv	s2,a5
    8000491a:	fcfcf6e3          	bgeu	s9,a5,800048e6 <kexec+0xda>
    8000491e:	8956                	mv	s2,s5
    80004920:	b7d9                	j	800048e6 <kexec+0xda>
    sz = sz1;
    80004922:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004926:	2d05                	addiw	s10,s10,1
    80004928:	e0843783          	ld	a5,-504(s0)
    8000492c:	0387869b          	addiw	a3,a5,56
    80004930:	e8845783          	lhu	a5,-376(s0)
    80004934:	06fd5e63          	bge	s10,a5,800049b0 <kexec+0x1a4>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004938:	e0d43423          	sd	a3,-504(s0)
    8000493c:	876e                	mv	a4,s11
    8000493e:	e1840613          	addi	a2,s0,-488
    80004942:	4581                	li	a1,0
    80004944:	8552                	mv	a0,s4
    80004946:	dddfe0ef          	jal	80003722 <readi>
    8000494a:	1db51f63          	bne	a0,s11,80004b28 <kexec+0x31c>
    if (ph.type != ELF_PROG_LOAD)
    8000494e:	e1842783          	lw	a5,-488(s0)
    80004952:	4705                	li	a4,1
    80004954:	fce799e3          	bne	a5,a4,80004926 <kexec+0x11a>
    if (ph.memsz < ph.filesz)
    80004958:	e4043483          	ld	s1,-448(s0)
    8000495c:	e3843783          	ld	a5,-456(s0)
    80004960:	1ef4e463          	bltu	s1,a5,80004b48 <kexec+0x33c>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004964:	e2843783          	ld	a5,-472(s0)
    80004968:	94be                	add	s1,s1,a5
    8000496a:	1ef4e263          	bltu	s1,a5,80004b4e <kexec+0x342>
    if (ph.vaddr % PGSIZE != 0)
    8000496e:	de843703          	ld	a4,-536(s0)
    80004972:	8ff9                	and	a5,a5,a4
    80004974:	1e079063          	bnez	a5,80004b54 <kexec+0x348>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004978:	e1c42503          	lw	a0,-484(s0)
    8000497c:	e71ff0ef          	jal	800047ec <flags2perm>
    80004980:	86aa                	mv	a3,a0
    80004982:	8626                	mv	a2,s1
    80004984:	85ca                	mv	a1,s2
    80004986:	855a                	mv	a0,s6
    80004988:	949fc0ef          	jal	800012d0 <uvmalloc>
    8000498c:	dea43c23          	sd	a0,-520(s0)
    80004990:	1c050563          	beqz	a0,80004b5a <kexec+0x34e>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004994:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004998:	00098863          	beqz	s3,800049a8 <kexec+0x19c>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000499c:	e2843c03          	ld	s8,-472(s0)
    800049a0:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800049a4:	4481                	li	s1,0
    800049a6:	bfb1                	j	80004902 <kexec+0xf6>
    sz = sz1;
    800049a8:	df843903          	ld	s2,-520(s0)
    800049ac:	bfad                	j	80004926 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800049ae:	4901                	li	s2,0
  iunlockput(ip);
    800049b0:	8552                	mv	a0,s4
    800049b2:	bebfe0ef          	jal	8000359c <iunlockput>
  end_op();
    800049b6:	c56ff0ef          	jal	80003e0c <end_op>
  p = myproc();
    800049ba:	f49fc0ef          	jal	80001902 <myproc>
    800049be:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800049c0:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800049c4:	6985                	lui	s3,0x1
    800049c6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800049c8:	99ca                	add	s3,s3,s2
    800049ca:	77fd                	lui	a5,0xfffff
    800049cc:	00f9f9b3          	and	s3,s3,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    800049d0:	4691                	li	a3,4
    800049d2:	6609                	lui	a2,0x2
    800049d4:	964e                	add	a2,a2,s3
    800049d6:	85ce                	mv	a1,s3
    800049d8:	855a                	mv	a0,s6
    800049da:	8f7fc0ef          	jal	800012d0 <uvmalloc>
    800049de:	8a2a                	mv	s4,a0
    800049e0:	e105                	bnez	a0,80004a00 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    800049e2:	85ce                	mv	a1,s3
    800049e4:	855a                	mv	a0,s6
    800049e6:	8aafd0ef          	jal	80001a90 <proc_freepagetable>
  return -1;
    800049ea:	557d                	li	a0,-1
    800049ec:	79fe                	ld	s3,504(sp)
    800049ee:	7a5e                	ld	s4,496(sp)
    800049f0:	7abe                	ld	s5,488(sp)
    800049f2:	7b1e                	ld	s6,480(sp)
    800049f4:	6bfe                	ld	s7,472(sp)
    800049f6:	6c5e                	ld	s8,464(sp)
    800049f8:	6cbe                	ld	s9,456(sp)
    800049fa:	6d1e                	ld	s10,448(sp)
    800049fc:	7dfa                	ld	s11,440(sp)
    800049fe:	b541                	j	8000487e <kexec+0x72>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004a00:	75f9                	lui	a1,0xffffe
    80004a02:	95aa                	add	a1,a1,a0
    80004a04:	855a                	mv	a0,s6
    80004a06:	a9dfc0ef          	jal	800014a2 <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004a0a:	800a0b93          	addi	s7,s4,-2048
    80004a0e:	800b8b93          	addi	s7,s7,-2048
  for (argc = 0; argv[argc]; argc++) {
    80004a12:	e0043783          	ld	a5,-512(s0)
    80004a16:	6388                	ld	a0,0(a5)
  sp = sz;
    80004a18:	8952                	mv	s2,s4
  for (argc = 0; argv[argc]; argc++) {
    80004a1a:	4481                	li	s1,0
    ustack[argc] = sp;
    80004a1c:	e9040c93          	addi	s9,s0,-368
    if (argc >= MAXARG)
    80004a20:	02000c13          	li	s8,32
  for (argc = 0; argv[argc]; argc++) {
    80004a24:	cd21                	beqz	a0,80004a7c <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80004a26:	c30fc0ef          	jal	80000e56 <strlen>
    80004a2a:	0015079b          	addiw	a5,a0,1
    80004a2e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a32:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase)
    80004a36:	13796563          	bltu	s2,s7,80004b60 <kexec+0x354>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a3a:	e0043d83          	ld	s11,-512(s0)
    80004a3e:	000db983          	ld	s3,0(s11)
    80004a42:	854e                	mv	a0,s3
    80004a44:	c12fc0ef          	jal	80000e56 <strlen>
    80004a48:	0015069b          	addiw	a3,a0,1
    80004a4c:	864e                	mv	a2,s3
    80004a4e:	85ca                	mv	a1,s2
    80004a50:	855a                	mv	a0,s6
    80004a52:	bd7fc0ef          	jal	80001628 <copyout>
    80004a56:	10054763          	bltz	a0,80004b64 <kexec+0x358>
    ustack[argc] = sp;
    80004a5a:	00349793          	slli	a5,s1,0x3
    80004a5e:	97e6                	add	a5,a5,s9
    80004a60:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffde288>
  for (argc = 0; argv[argc]; argc++) {
    80004a64:	0485                	addi	s1,s1,1
    80004a66:	008d8793          	addi	a5,s11,8
    80004a6a:	e0f43023          	sd	a5,-512(s0)
    80004a6e:	008db503          	ld	a0,8(s11)
    80004a72:	c509                	beqz	a0,80004a7c <kexec+0x270>
    if (argc >= MAXARG)
    80004a74:	fb8499e3          	bne	s1,s8,80004a26 <kexec+0x21a>
  sz = sz1;
    80004a78:	89d2                	mv	s3,s4
    80004a7a:	b7a5                	j	800049e2 <kexec+0x1d6>
  ustack[argc] = 0;
    80004a7c:	00349793          	slli	a5,s1,0x3
    80004a80:	f9078793          	addi	a5,a5,-112
    80004a84:	97a2                	add	a5,a5,s0
    80004a86:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004a8a:	00349693          	slli	a3,s1,0x3
    80004a8e:	06a1                	addi	a3,a3,8
    80004a90:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004a94:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004a98:	89d2                	mv	s3,s4
  if (sp < stackbase)
    80004a9a:	f57964e3          	bltu	s2,s7,800049e2 <kexec+0x1d6>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    80004a9e:	e9040613          	addi	a2,s0,-368
    80004aa2:	85ca                	mv	a1,s2
    80004aa4:	855a                	mv	a0,s6
    80004aa6:	b83fc0ef          	jal	80001628 <copyout>
    80004aaa:	f2054ce3          	bltz	a0,800049e2 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80004aae:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80004ab2:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004ab6:	df043783          	ld	a5,-528(s0)
    80004aba:	0007c703          	lbu	a4,0(a5)
    80004abe:	cf11                	beqz	a4,80004ada <kexec+0x2ce>
    80004ac0:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004ac2:	02f00693          	li	a3,47
    80004ac6:	a029                	j	80004ad0 <kexec+0x2c4>
  for (last = s = path; *s; s++)
    80004ac8:	0785                	addi	a5,a5,1
    80004aca:	fff7c703          	lbu	a4,-1(a5)
    80004ace:	c711                	beqz	a4,80004ada <kexec+0x2ce>
    if (*s == '/')
    80004ad0:	fed71ce3          	bne	a4,a3,80004ac8 <kexec+0x2bc>
      last = s + 1;
    80004ad4:	def43823          	sd	a5,-528(s0)
    80004ad8:	bfc5                	j	80004ac8 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004ada:	4641                	li	a2,16
    80004adc:	df043583          	ld	a1,-528(s0)
    80004ae0:	160a8513          	addi	a0,s5,352
    80004ae4:	b3cfc0ef          	jal	80000e20 <safestrcpy>
  oldpagetable = p->pagetable;
    80004ae8:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004aec:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80004af0:	054ab823          	sd	s4,80(s5)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004af4:	060ab783          	ld	a5,96(s5)
    80004af8:	e6843703          	ld	a4,-408(s0)
    80004afc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004afe:	060ab783          	ld	a5,96(s5)
    80004b02:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004b06:	85ea                	mv	a1,s10
    80004b08:	f89fc0ef          	jal	80001a90 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004b0c:	0004851b          	sext.w	a0,s1
    80004b10:	79fe                	ld	s3,504(sp)
    80004b12:	7a5e                	ld	s4,496(sp)
    80004b14:	7abe                	ld	s5,488(sp)
    80004b16:	7b1e                	ld	s6,480(sp)
    80004b18:	6bfe                	ld	s7,472(sp)
    80004b1a:	6c5e                	ld	s8,464(sp)
    80004b1c:	6cbe                	ld	s9,456(sp)
    80004b1e:	6d1e                	ld	s10,448(sp)
    80004b20:	7dfa                	ld	s11,440(sp)
    80004b22:	bbb1                	j	8000487e <kexec+0x72>
    80004b24:	7b1e                	ld	s6,480(sp)
    80004b26:	b3a9                	j	80004870 <kexec+0x64>
    80004b28:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004b2c:	df843583          	ld	a1,-520(s0)
    80004b30:	855a                	mv	a0,s6
    80004b32:	f5ffc0ef          	jal	80001a90 <proc_freepagetable>
  if (ip) {
    80004b36:	79fe                	ld	s3,504(sp)
    80004b38:	7abe                	ld	s5,488(sp)
    80004b3a:	7b1e                	ld	s6,480(sp)
    80004b3c:	6bfe                	ld	s7,472(sp)
    80004b3e:	6c5e                	ld	s8,464(sp)
    80004b40:	6cbe                	ld	s9,456(sp)
    80004b42:	6d1e                	ld	s10,448(sp)
    80004b44:	7dfa                	ld	s11,440(sp)
    80004b46:	b32d                	j	80004870 <kexec+0x64>
    80004b48:	df243c23          	sd	s2,-520(s0)
    80004b4c:	b7c5                	j	80004b2c <kexec+0x320>
    80004b4e:	df243c23          	sd	s2,-520(s0)
    80004b52:	bfe9                	j	80004b2c <kexec+0x320>
    80004b54:	df243c23          	sd	s2,-520(s0)
    80004b58:	bfd1                	j	80004b2c <kexec+0x320>
    80004b5a:	df243c23          	sd	s2,-520(s0)
    80004b5e:	b7f9                	j	80004b2c <kexec+0x320>
  sz = sz1;
    80004b60:	89d2                	mv	s3,s4
    80004b62:	b541                	j	800049e2 <kexec+0x1d6>
    80004b64:	89d2                	mv	s3,s4
    80004b66:	bdb5                	j	800049e2 <kexec+0x1d6>

0000000080004b68 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004b68:	7179                	addi	sp,sp,-48
    80004b6a:	f406                	sd	ra,40(sp)
    80004b6c:	f022                	sd	s0,32(sp)
    80004b6e:	ec26                	sd	s1,24(sp)
    80004b70:	e84a                	sd	s2,16(sp)
    80004b72:	1800                	addi	s0,sp,48
    80004b74:	892e                	mv	s2,a1
    80004b76:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b78:	fdc40593          	addi	a1,s0,-36
    80004b7c:	cf9fd0ef          	jal	80002874 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004b80:	fdc42703          	lw	a4,-36(s0)
    80004b84:	47bd                	li	a5,15
    80004b86:	02e7ea63          	bltu	a5,a4,80004bba <argfd+0x52>
    80004b8a:	d79fc0ef          	jal	80001902 <myproc>
    80004b8e:	fdc42703          	lw	a4,-36(s0)
    80004b92:	00371793          	slli	a5,a4,0x3
    80004b96:	0d078793          	addi	a5,a5,208
    80004b9a:	953e                	add	a0,a0,a5
    80004b9c:	651c                	ld	a5,8(a0)
    80004b9e:	c385                	beqz	a5,80004bbe <argfd+0x56>
    return -1;
  if (pfd)
    80004ba0:	00090463          	beqz	s2,80004ba8 <argfd+0x40>
    *pfd = fd;
    80004ba4:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80004ba8:	4501                	li	a0,0
  if (pf)
    80004baa:	c091                	beqz	s1,80004bae <argfd+0x46>
    *pf = f;
    80004bac:	e09c                	sd	a5,0(s1)
}
    80004bae:	70a2                	ld	ra,40(sp)
    80004bb0:	7402                	ld	s0,32(sp)
    80004bb2:	64e2                	ld	s1,24(sp)
    80004bb4:	6942                	ld	s2,16(sp)
    80004bb6:	6145                	addi	sp,sp,48
    80004bb8:	8082                	ret
    return -1;
    80004bba:	557d                	li	a0,-1
    80004bbc:	bfcd                	j	80004bae <argfd+0x46>
    80004bbe:	557d                	li	a0,-1
    80004bc0:	b7fd                	j	80004bae <argfd+0x46>

0000000080004bc2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004bc2:	1101                	addi	sp,sp,-32
    80004bc4:	ec06                	sd	ra,24(sp)
    80004bc6:	e822                	sd	s0,16(sp)
    80004bc8:	e426                	sd	s1,8(sp)
    80004bca:	1000                	addi	s0,sp,32
    80004bcc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004bce:	d35fc0ef          	jal	80001902 <myproc>
    80004bd2:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004bd4:	0d850793          	addi	a5,a0,216
    80004bd8:	4501                	li	a0,0
    80004bda:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004bdc:	6398                	ld	a4,0(a5)
    80004bde:	cb19                	beqz	a4,80004bf4 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004be0:	2505                	addiw	a0,a0,1
    80004be2:	07a1                	addi	a5,a5,8
    80004be4:	fed51ce3          	bne	a0,a3,80004bdc <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004be8:	557d                	li	a0,-1
}
    80004bea:	60e2                	ld	ra,24(sp)
    80004bec:	6442                	ld	s0,16(sp)
    80004bee:	64a2                	ld	s1,8(sp)
    80004bf0:	6105                	addi	sp,sp,32
    80004bf2:	8082                	ret
      p->ofile[fd] = f;
    80004bf4:	00351793          	slli	a5,a0,0x3
    80004bf8:	0d078793          	addi	a5,a5,208
    80004bfc:	963e                	add	a2,a2,a5
    80004bfe:	e604                	sd	s1,8(a2)
      return fd;
    80004c00:	b7ed                	j	80004bea <fdalloc+0x28>

0000000080004c02 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004c02:	715d                	addi	sp,sp,-80
    80004c04:	e486                	sd	ra,72(sp)
    80004c06:	e0a2                	sd	s0,64(sp)
    80004c08:	fc26                	sd	s1,56(sp)
    80004c0a:	f84a                	sd	s2,48(sp)
    80004c0c:	f44e                	sd	s3,40(sp)
    80004c0e:	f052                	sd	s4,32(sp)
    80004c10:	ec56                	sd	s5,24(sp)
    80004c12:	e85a                	sd	s6,16(sp)
    80004c14:	0880                	addi	s0,sp,80
    80004c16:	892e                	mv	s2,a1
    80004c18:	8a2e                	mv	s4,a1
    80004c1a:	8ab2                	mv	s5,a2
    80004c1c:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004c1e:	fb040593          	addi	a1,s0,-80
    80004c22:	fb7fe0ef          	jal	80003bd8 <nameiparent>
    80004c26:	84aa                	mv	s1,a0
    80004c28:	10050763          	beqz	a0,80004d36 <create+0x134>
    return 0;

  ilock(dp);
    80004c2c:	f64fe0ef          	jal	80003390 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004c30:	4601                	li	a2,0
    80004c32:	fb040593          	addi	a1,s0,-80
    80004c36:	8526                	mv	a0,s1
    80004c38:	cf3fe0ef          	jal	8000392a <dirlookup>
    80004c3c:	89aa                	mv	s3,a0
    80004c3e:	c131                	beqz	a0,80004c82 <create+0x80>
    iunlockput(dp);
    80004c40:	8526                	mv	a0,s1
    80004c42:	95bfe0ef          	jal	8000359c <iunlockput>
    ilock(ip);
    80004c46:	854e                	mv	a0,s3
    80004c48:	f48fe0ef          	jal	80003390 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004c4c:	4789                	li	a5,2
    80004c4e:	02f91563          	bne	s2,a5,80004c78 <create+0x76>
    80004c52:	0449d783          	lhu	a5,68(s3)
    80004c56:	37f9                	addiw	a5,a5,-2
    80004c58:	17c2                	slli	a5,a5,0x30
    80004c5a:	93c1                	srli	a5,a5,0x30
    80004c5c:	4705                	li	a4,1
    80004c5e:	00f76d63          	bltu	a4,a5,80004c78 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004c62:	854e                	mv	a0,s3
    80004c64:	60a6                	ld	ra,72(sp)
    80004c66:	6406                	ld	s0,64(sp)
    80004c68:	74e2                	ld	s1,56(sp)
    80004c6a:	7942                	ld	s2,48(sp)
    80004c6c:	79a2                	ld	s3,40(sp)
    80004c6e:	7a02                	ld	s4,32(sp)
    80004c70:	6ae2                	ld	s5,24(sp)
    80004c72:	6b42                	ld	s6,16(sp)
    80004c74:	6161                	addi	sp,sp,80
    80004c76:	8082                	ret
    iunlockput(ip);
    80004c78:	854e                	mv	a0,s3
    80004c7a:	923fe0ef          	jal	8000359c <iunlockput>
    return 0;
    80004c7e:	4981                	li	s3,0
    80004c80:	b7cd                	j	80004c62 <create+0x60>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004c82:	85ca                	mv	a1,s2
    80004c84:	4088                	lw	a0,0(s1)
    80004c86:	d9afe0ef          	jal	80003220 <ialloc>
    80004c8a:	892a                	mv	s2,a0
    80004c8c:	cd15                	beqz	a0,80004cc8 <create+0xc6>
  ilock(ip);
    80004c8e:	f02fe0ef          	jal	80003390 <ilock>
  ip->major = major;
    80004c92:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004c96:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004c9a:	4785                	li	a5,1
    80004c9c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ca0:	854a                	mv	a0,s2
    80004ca2:	e3afe0ef          	jal	800032dc <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004ca6:	4705                	li	a4,1
    80004ca8:	02ea0463          	beq	s4,a4,80004cd0 <create+0xce>
  if (dirlink(dp, name, ip->inum) < 0)
    80004cac:	00492603          	lw	a2,4(s2)
    80004cb0:	fb040593          	addi	a1,s0,-80
    80004cb4:	8526                	mv	a0,s1
    80004cb6:	e5ffe0ef          	jal	80003b14 <dirlink>
    80004cba:	06054263          	bltz	a0,80004d1e <create+0x11c>
  iunlockput(dp);
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	8ddfe0ef          	jal	8000359c <iunlockput>
  return ip;
    80004cc4:	89ca                	mv	s3,s2
    80004cc6:	bf71                	j	80004c62 <create+0x60>
    iunlockput(dp);
    80004cc8:	8526                	mv	a0,s1
    80004cca:	8d3fe0ef          	jal	8000359c <iunlockput>
    return 0;
    80004cce:	bf51                	j	80004c62 <create+0x60>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004cd0:	00492603          	lw	a2,4(s2)
    80004cd4:	00003597          	auipc	a1,0x3
    80004cd8:	8ec58593          	addi	a1,a1,-1812 # 800075c0 <etext+0x5c0>
    80004cdc:	854a                	mv	a0,s2
    80004cde:	e37fe0ef          	jal	80003b14 <dirlink>
    80004ce2:	02054e63          	bltz	a0,80004d1e <create+0x11c>
    80004ce6:	40d0                	lw	a2,4(s1)
    80004ce8:	00003597          	auipc	a1,0x3
    80004cec:	8e058593          	addi	a1,a1,-1824 # 800075c8 <etext+0x5c8>
    80004cf0:	854a                	mv	a0,s2
    80004cf2:	e23fe0ef          	jal	80003b14 <dirlink>
    80004cf6:	02054463          	bltz	a0,80004d1e <create+0x11c>
  if (dirlink(dp, name, ip->inum) < 0)
    80004cfa:	00492603          	lw	a2,4(s2)
    80004cfe:	fb040593          	addi	a1,s0,-80
    80004d02:	8526                	mv	a0,s1
    80004d04:	e11fe0ef          	jal	80003b14 <dirlink>
    80004d08:	00054b63          	bltz	a0,80004d1e <create+0x11c>
    dp->nlink++; // for ".."
    80004d0c:	04a4d783          	lhu	a5,74(s1)
    80004d10:	2785                	addiw	a5,a5,1
    80004d12:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d16:	8526                	mv	a0,s1
    80004d18:	dc4fe0ef          	jal	800032dc <iupdate>
    80004d1c:	b74d                	j	80004cbe <create+0xbc>
  ip->nlink = 0;
    80004d1e:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004d22:	854a                	mv	a0,s2
    80004d24:	db8fe0ef          	jal	800032dc <iupdate>
  iunlockput(ip);
    80004d28:	854a                	mv	a0,s2
    80004d2a:	873fe0ef          	jal	8000359c <iunlockput>
  iunlockput(dp);
    80004d2e:	8526                	mv	a0,s1
    80004d30:	86dfe0ef          	jal	8000359c <iunlockput>
  return 0;
    80004d34:	b73d                	j	80004c62 <create+0x60>
    return 0;
    80004d36:	89aa                	mv	s3,a0
    80004d38:	b72d                	j	80004c62 <create+0x60>

0000000080004d3a <sys_dup>:
{
    80004d3a:	7179                	addi	sp,sp,-48
    80004d3c:	f406                	sd	ra,40(sp)
    80004d3e:	f022                	sd	s0,32(sp)
    80004d40:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004d42:	fd840613          	addi	a2,s0,-40
    80004d46:	4581                	li	a1,0
    80004d48:	4501                	li	a0,0
    80004d4a:	e1fff0ef          	jal	80004b68 <argfd>
    return -1;
    80004d4e:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80004d50:	02054363          	bltz	a0,80004d76 <sys_dup+0x3c>
    80004d54:	ec26                	sd	s1,24(sp)
    80004d56:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004d58:	fd843483          	ld	s1,-40(s0)
    80004d5c:	8526                	mv	a0,s1
    80004d5e:	e65ff0ef          	jal	80004bc2 <fdalloc>
    80004d62:	892a                	mv	s2,a0
    return -1;
    80004d64:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80004d66:	00054d63          	bltz	a0,80004d80 <sys_dup+0x46>
  filedup(f);
    80004d6a:	8526                	mv	a0,s1
    80004d6c:	c0eff0ef          	jal	8000417a <filedup>
  return fd;
    80004d70:	87ca                	mv	a5,s2
    80004d72:	64e2                	ld	s1,24(sp)
    80004d74:	6942                	ld	s2,16(sp)
}
    80004d76:	853e                	mv	a0,a5
    80004d78:	70a2                	ld	ra,40(sp)
    80004d7a:	7402                	ld	s0,32(sp)
    80004d7c:	6145                	addi	sp,sp,48
    80004d7e:	8082                	ret
    80004d80:	64e2                	ld	s1,24(sp)
    80004d82:	6942                	ld	s2,16(sp)
    80004d84:	bfcd                	j	80004d76 <sys_dup+0x3c>

0000000080004d86 <sys_read>:
{
    80004d86:	7179                	addi	sp,sp,-48
    80004d88:	f406                	sd	ra,40(sp)
    80004d8a:	f022                	sd	s0,32(sp)
    80004d8c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d8e:	fd840593          	addi	a1,s0,-40
    80004d92:	4505                	li	a0,1
    80004d94:	afdfd0ef          	jal	80002890 <argaddr>
  argint(2, &n);
    80004d98:	fe440593          	addi	a1,s0,-28
    80004d9c:	4509                	li	a0,2
    80004d9e:	ad7fd0ef          	jal	80002874 <argint>
  if (argfd(0, 0, &f) < 0)
    80004da2:	fe840613          	addi	a2,s0,-24
    80004da6:	4581                	li	a1,0
    80004da8:	4501                	li	a0,0
    80004daa:	dbfff0ef          	jal	80004b68 <argfd>
    80004dae:	87aa                	mv	a5,a0
    return -1;
    80004db0:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004db2:	0007ca63          	bltz	a5,80004dc6 <sys_read+0x40>
  return fileread(f, p, n);
    80004db6:	fe442603          	lw	a2,-28(s0)
    80004dba:	fd843583          	ld	a1,-40(s0)
    80004dbe:	fe843503          	ld	a0,-24(s0)
    80004dc2:	d22ff0ef          	jal	800042e4 <fileread>
}
    80004dc6:	70a2                	ld	ra,40(sp)
    80004dc8:	7402                	ld	s0,32(sp)
    80004dca:	6145                	addi	sp,sp,48
    80004dcc:	8082                	ret

0000000080004dce <sys_write>:
{
    80004dce:	7179                	addi	sp,sp,-48
    80004dd0:	f406                	sd	ra,40(sp)
    80004dd2:	f022                	sd	s0,32(sp)
    80004dd4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004dd6:	fd840593          	addi	a1,s0,-40
    80004dda:	4505                	li	a0,1
    80004ddc:	ab5fd0ef          	jal	80002890 <argaddr>
  argint(2, &n);
    80004de0:	fe440593          	addi	a1,s0,-28
    80004de4:	4509                	li	a0,2
    80004de6:	a8ffd0ef          	jal	80002874 <argint>
  if (argfd(0, 0, &f) < 0)
    80004dea:	fe840613          	addi	a2,s0,-24
    80004dee:	4581                	li	a1,0
    80004df0:	4501                	li	a0,0
    80004df2:	d77ff0ef          	jal	80004b68 <argfd>
    80004df6:	87aa                	mv	a5,a0
    return -1;
    80004df8:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004dfa:	0007ca63          	bltz	a5,80004e0e <sys_write+0x40>
  return filewrite(f, p, n);
    80004dfe:	fe442603          	lw	a2,-28(s0)
    80004e02:	fd843583          	ld	a1,-40(s0)
    80004e06:	fe843503          	ld	a0,-24(s0)
    80004e0a:	d9eff0ef          	jal	800043a8 <filewrite>
}
    80004e0e:	70a2                	ld	ra,40(sp)
    80004e10:	7402                	ld	s0,32(sp)
    80004e12:	6145                	addi	sp,sp,48
    80004e14:	8082                	ret

0000000080004e16 <sys_close>:
{
    80004e16:	1101                	addi	sp,sp,-32
    80004e18:	ec06                	sd	ra,24(sp)
    80004e1a:	e822                	sd	s0,16(sp)
    80004e1c:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004e1e:	fe040613          	addi	a2,s0,-32
    80004e22:	fec40593          	addi	a1,s0,-20
    80004e26:	4501                	li	a0,0
    80004e28:	d41ff0ef          	jal	80004b68 <argfd>
    return -1;
    80004e2c:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004e2e:	02054163          	bltz	a0,80004e50 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004e32:	ad1fc0ef          	jal	80001902 <myproc>
    80004e36:	fec42783          	lw	a5,-20(s0)
    80004e3a:	078e                	slli	a5,a5,0x3
    80004e3c:	0d078793          	addi	a5,a5,208
    80004e40:	953e                	add	a0,a0,a5
    80004e42:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004e46:	fe043503          	ld	a0,-32(s0)
    80004e4a:	b76ff0ef          	jal	800041c0 <fileclose>
  return 0;
    80004e4e:	4781                	li	a5,0
}
    80004e50:	853e                	mv	a0,a5
    80004e52:	60e2                	ld	ra,24(sp)
    80004e54:	6442                	ld	s0,16(sp)
    80004e56:	6105                	addi	sp,sp,32
    80004e58:	8082                	ret

0000000080004e5a <sys_fstat>:
{
    80004e5a:	1101                	addi	sp,sp,-32
    80004e5c:	ec06                	sd	ra,24(sp)
    80004e5e:	e822                	sd	s0,16(sp)
    80004e60:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004e62:	fe040593          	addi	a1,s0,-32
    80004e66:	4505                	li	a0,1
    80004e68:	a29fd0ef          	jal	80002890 <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004e6c:	fe840613          	addi	a2,s0,-24
    80004e70:	4581                	li	a1,0
    80004e72:	4501                	li	a0,0
    80004e74:	cf5ff0ef          	jal	80004b68 <argfd>
    80004e78:	87aa                	mv	a5,a0
    return -1;
    80004e7a:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004e7c:	0007c863          	bltz	a5,80004e8c <sys_fstat+0x32>
  return filestat(f, st);
    80004e80:	fe043583          	ld	a1,-32(s0)
    80004e84:	fe843503          	ld	a0,-24(s0)
    80004e88:	bfaff0ef          	jal	80004282 <filestat>
}
    80004e8c:	60e2                	ld	ra,24(sp)
    80004e8e:	6442                	ld	s0,16(sp)
    80004e90:	6105                	addi	sp,sp,32
    80004e92:	8082                	ret

0000000080004e94 <sys_link>:
{
    80004e94:	7169                	addi	sp,sp,-304
    80004e96:	f606                	sd	ra,296(sp)
    80004e98:	f222                	sd	s0,288(sp)
    80004e9a:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e9c:	08000613          	li	a2,128
    80004ea0:	ed040593          	addi	a1,s0,-304
    80004ea4:	4501                	li	a0,0
    80004ea6:	a07fd0ef          	jal	800028ac <argstr>
    return -1;
    80004eaa:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004eac:	0c054e63          	bltz	a0,80004f88 <sys_link+0xf4>
    80004eb0:	08000613          	li	a2,128
    80004eb4:	f5040593          	addi	a1,s0,-176
    80004eb8:	4505                	li	a0,1
    80004eba:	9f3fd0ef          	jal	800028ac <argstr>
    return -1;
    80004ebe:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ec0:	0c054463          	bltz	a0,80004f88 <sys_link+0xf4>
    80004ec4:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ec6:	ed7fe0ef          	jal	80003d9c <begin_op>
  if ((ip = namei(old)) == 0) {
    80004eca:	ed040513          	addi	a0,s0,-304
    80004ece:	cf1fe0ef          	jal	80003bbe <namei>
    80004ed2:	84aa                	mv	s1,a0
    80004ed4:	c53d                	beqz	a0,80004f42 <sys_link+0xae>
  ilock(ip);
    80004ed6:	cbafe0ef          	jal	80003390 <ilock>
  if (ip->type == T_DIR) {
    80004eda:	04449703          	lh	a4,68(s1)
    80004ede:	4785                	li	a5,1
    80004ee0:	06f70663          	beq	a4,a5,80004f4c <sys_link+0xb8>
    80004ee4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ee6:	04a4d783          	lhu	a5,74(s1)
    80004eea:	2785                	addiw	a5,a5,1
    80004eec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ef0:	8526                	mv	a0,s1
    80004ef2:	beafe0ef          	jal	800032dc <iupdate>
  iunlock(ip);
    80004ef6:	8526                	mv	a0,s1
    80004ef8:	d46fe0ef          	jal	8000343e <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004efc:	fd040593          	addi	a1,s0,-48
    80004f00:	f5040513          	addi	a0,s0,-176
    80004f04:	cd5fe0ef          	jal	80003bd8 <nameiparent>
    80004f08:	892a                	mv	s2,a0
    80004f0a:	cd21                	beqz	a0,80004f62 <sys_link+0xce>
  ilock(dp);
    80004f0c:	c84fe0ef          	jal	80003390 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004f10:	854a                	mv	a0,s2
    80004f12:	00092703          	lw	a4,0(s2)
    80004f16:	409c                	lw	a5,0(s1)
    80004f18:	04f71263          	bne	a4,a5,80004f5c <sys_link+0xc8>
    80004f1c:	40d0                	lw	a2,4(s1)
    80004f1e:	fd040593          	addi	a1,s0,-48
    80004f22:	bf3fe0ef          	jal	80003b14 <dirlink>
    80004f26:	02054b63          	bltz	a0,80004f5c <sys_link+0xc8>
  iunlockput(dp);
    80004f2a:	854a                	mv	a0,s2
    80004f2c:	e70fe0ef          	jal	8000359c <iunlockput>
  iput(ip);
    80004f30:	8526                	mv	a0,s1
    80004f32:	de0fe0ef          	jal	80003512 <iput>
  end_op();
    80004f36:	ed7fe0ef          	jal	80003e0c <end_op>
  return 0;
    80004f3a:	4781                	li	a5,0
    80004f3c:	64f2                	ld	s1,280(sp)
    80004f3e:	6952                	ld	s2,272(sp)
    80004f40:	a0a1                	j	80004f88 <sys_link+0xf4>
    end_op();
    80004f42:	ecbfe0ef          	jal	80003e0c <end_op>
    return -1;
    80004f46:	57fd                	li	a5,-1
    80004f48:	64f2                	ld	s1,280(sp)
    80004f4a:	a83d                	j	80004f88 <sys_link+0xf4>
    iunlockput(ip);
    80004f4c:	8526                	mv	a0,s1
    80004f4e:	e4efe0ef          	jal	8000359c <iunlockput>
    end_op();
    80004f52:	ebbfe0ef          	jal	80003e0c <end_op>
    return -1;
    80004f56:	57fd                	li	a5,-1
    80004f58:	64f2                	ld	s1,280(sp)
    80004f5a:	a03d                	j	80004f88 <sys_link+0xf4>
    iunlockput(dp);
    80004f5c:	854a                	mv	a0,s2
    80004f5e:	e3efe0ef          	jal	8000359c <iunlockput>
  ilock(ip);
    80004f62:	8526                	mv	a0,s1
    80004f64:	c2cfe0ef          	jal	80003390 <ilock>
  ip->nlink--;
    80004f68:	04a4d783          	lhu	a5,74(s1)
    80004f6c:	37fd                	addiw	a5,a5,-1
    80004f6e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f72:	8526                	mv	a0,s1
    80004f74:	b68fe0ef          	jal	800032dc <iupdate>
  iunlockput(ip);
    80004f78:	8526                	mv	a0,s1
    80004f7a:	e22fe0ef          	jal	8000359c <iunlockput>
  end_op();
    80004f7e:	e8ffe0ef          	jal	80003e0c <end_op>
  return -1;
    80004f82:	57fd                	li	a5,-1
    80004f84:	64f2                	ld	s1,280(sp)
    80004f86:	6952                	ld	s2,272(sp)
}
    80004f88:	853e                	mv	a0,a5
    80004f8a:	70b2                	ld	ra,296(sp)
    80004f8c:	7412                	ld	s0,288(sp)
    80004f8e:	6155                	addi	sp,sp,304
    80004f90:	8082                	ret

0000000080004f92 <sys_unlink>:
{
    80004f92:	7151                	addi	sp,sp,-240
    80004f94:	f586                	sd	ra,232(sp)
    80004f96:	f1a2                	sd	s0,224(sp)
    80004f98:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004f9a:	08000613          	li	a2,128
    80004f9e:	f3040593          	addi	a1,s0,-208
    80004fa2:	4501                	li	a0,0
    80004fa4:	909fd0ef          	jal	800028ac <argstr>
    80004fa8:	14054d63          	bltz	a0,80005102 <sys_unlink+0x170>
    80004fac:	eda6                	sd	s1,216(sp)
  begin_op();
    80004fae:	deffe0ef          	jal	80003d9c <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004fb2:	fb040593          	addi	a1,s0,-80
    80004fb6:	f3040513          	addi	a0,s0,-208
    80004fba:	c1ffe0ef          	jal	80003bd8 <nameiparent>
    80004fbe:	84aa                	mv	s1,a0
    80004fc0:	c955                	beqz	a0,80005074 <sys_unlink+0xe2>
  ilock(dp);
    80004fc2:	bcefe0ef          	jal	80003390 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004fc6:	00002597          	auipc	a1,0x2
    80004fca:	5fa58593          	addi	a1,a1,1530 # 800075c0 <etext+0x5c0>
    80004fce:	fb040513          	addi	a0,s0,-80
    80004fd2:	943fe0ef          	jal	80003914 <namecmp>
    80004fd6:	10050b63          	beqz	a0,800050ec <sys_unlink+0x15a>
    80004fda:	00002597          	auipc	a1,0x2
    80004fde:	5ee58593          	addi	a1,a1,1518 # 800075c8 <etext+0x5c8>
    80004fe2:	fb040513          	addi	a0,s0,-80
    80004fe6:	92ffe0ef          	jal	80003914 <namecmp>
    80004fea:	10050163          	beqz	a0,800050ec <sys_unlink+0x15a>
    80004fee:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004ff0:	f2c40613          	addi	a2,s0,-212
    80004ff4:	fb040593          	addi	a1,s0,-80
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	931fe0ef          	jal	8000392a <dirlookup>
    80004ffe:	892a                	mv	s2,a0
    80005000:	0e050563          	beqz	a0,800050ea <sys_unlink+0x158>
    80005004:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005006:	b8afe0ef          	jal	80003390 <ilock>
  if (ip->nlink < 1)
    8000500a:	04a91783          	lh	a5,74(s2)
    8000500e:	06f05863          	blez	a5,8000507e <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005012:	04491703          	lh	a4,68(s2)
    80005016:	4785                	li	a5,1
    80005018:	06f70963          	beq	a4,a5,8000508a <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    8000501c:	fc040993          	addi	s3,s0,-64
    80005020:	4641                	li	a2,16
    80005022:	4581                	li	a1,0
    80005024:	854e                	mv	a0,s3
    80005026:	ca7fb0ef          	jal	80000ccc <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000502a:	4741                	li	a4,16
    8000502c:	f2c42683          	lw	a3,-212(s0)
    80005030:	864e                	mv	a2,s3
    80005032:	4581                	li	a1,0
    80005034:	8526                	mv	a0,s1
    80005036:	fdefe0ef          	jal	80003814 <writei>
    8000503a:	47c1                	li	a5,16
    8000503c:	08f51863          	bne	a0,a5,800050cc <sys_unlink+0x13a>
  if (ip->type == T_DIR) {
    80005040:	04491703          	lh	a4,68(s2)
    80005044:	4785                	li	a5,1
    80005046:	08f70963          	beq	a4,a5,800050d8 <sys_unlink+0x146>
  iunlockput(dp);
    8000504a:	8526                	mv	a0,s1
    8000504c:	d50fe0ef          	jal	8000359c <iunlockput>
  ip->nlink--;
    80005050:	04a95783          	lhu	a5,74(s2)
    80005054:	37fd                	addiw	a5,a5,-1
    80005056:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000505a:	854a                	mv	a0,s2
    8000505c:	a80fe0ef          	jal	800032dc <iupdate>
  iunlockput(ip);
    80005060:	854a                	mv	a0,s2
    80005062:	d3afe0ef          	jal	8000359c <iunlockput>
  end_op();
    80005066:	da7fe0ef          	jal	80003e0c <end_op>
  return 0;
    8000506a:	4501                	li	a0,0
    8000506c:	64ee                	ld	s1,216(sp)
    8000506e:	694e                	ld	s2,208(sp)
    80005070:	69ae                	ld	s3,200(sp)
    80005072:	a061                	j	800050fa <sys_unlink+0x168>
    end_op();
    80005074:	d99fe0ef          	jal	80003e0c <end_op>
    return -1;
    80005078:	557d                	li	a0,-1
    8000507a:	64ee                	ld	s1,216(sp)
    8000507c:	a8bd                	j	800050fa <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000507e:	00002517          	auipc	a0,0x2
    80005082:	55250513          	addi	a0,a0,1362 # 800075d0 <etext+0x5d0>
    80005086:	f92fb0ef          	jal	80000818 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    8000508a:	04c92703          	lw	a4,76(s2)
    8000508e:	02000793          	li	a5,32
    80005092:	f8e7f5e3          	bgeu	a5,a4,8000501c <sys_unlink+0x8a>
    80005096:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005098:	4741                	li	a4,16
    8000509a:	86ce                	mv	a3,s3
    8000509c:	f1840613          	addi	a2,s0,-232
    800050a0:	4581                	li	a1,0
    800050a2:	854a                	mv	a0,s2
    800050a4:	e7efe0ef          	jal	80003722 <readi>
    800050a8:	47c1                	li	a5,16
    800050aa:	00f51b63          	bne	a0,a5,800050c0 <sys_unlink+0x12e>
    if (de.inum != 0)
    800050ae:	f1845783          	lhu	a5,-232(s0)
    800050b2:	ebb1                	bnez	a5,80005106 <sys_unlink+0x174>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800050b4:	29c1                	addiw	s3,s3,16
    800050b6:	04c92783          	lw	a5,76(s2)
    800050ba:	fcf9efe3          	bltu	s3,a5,80005098 <sys_unlink+0x106>
    800050be:	bfb9                	j	8000501c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800050c0:	00002517          	auipc	a0,0x2
    800050c4:	52850513          	addi	a0,a0,1320 # 800075e8 <etext+0x5e8>
    800050c8:	f50fb0ef          	jal	80000818 <panic>
    panic("unlink: writei");
    800050cc:	00002517          	auipc	a0,0x2
    800050d0:	53450513          	addi	a0,a0,1332 # 80007600 <etext+0x600>
    800050d4:	f44fb0ef          	jal	80000818 <panic>
    dp->nlink--;
    800050d8:	04a4d783          	lhu	a5,74(s1)
    800050dc:	37fd                	addiw	a5,a5,-1
    800050de:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800050e2:	8526                	mv	a0,s1
    800050e4:	9f8fe0ef          	jal	800032dc <iupdate>
    800050e8:	b78d                	j	8000504a <sys_unlink+0xb8>
    800050ea:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800050ec:	8526                	mv	a0,s1
    800050ee:	caefe0ef          	jal	8000359c <iunlockput>
  end_op();
    800050f2:	d1bfe0ef          	jal	80003e0c <end_op>
  return -1;
    800050f6:	557d                	li	a0,-1
    800050f8:	64ee                	ld	s1,216(sp)
}
    800050fa:	70ae                	ld	ra,232(sp)
    800050fc:	740e                	ld	s0,224(sp)
    800050fe:	616d                	addi	sp,sp,240
    80005100:	8082                	ret
    return -1;
    80005102:	557d                	li	a0,-1
    80005104:	bfdd                	j	800050fa <sys_unlink+0x168>
    iunlockput(ip);
    80005106:	854a                	mv	a0,s2
    80005108:	c94fe0ef          	jal	8000359c <iunlockput>
    goto bad;
    8000510c:	694e                	ld	s2,208(sp)
    8000510e:	69ae                	ld	s3,200(sp)
    80005110:	bff1                	j	800050ec <sys_unlink+0x15a>

0000000080005112 <sys_open>:

uint64
sys_open(void)
{
    80005112:	7131                	addi	sp,sp,-192
    80005114:	fd06                	sd	ra,184(sp)
    80005116:	f922                	sd	s0,176(sp)
    80005118:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000511a:	f4c40593          	addi	a1,s0,-180
    8000511e:	4505                	li	a0,1
    80005120:	f54fd0ef          	jal	80002874 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005124:	08000613          	li	a2,128
    80005128:	f5040593          	addi	a1,s0,-176
    8000512c:	4501                	li	a0,0
    8000512e:	f7efd0ef          	jal	800028ac <argstr>
    80005132:	87aa                	mv	a5,a0
    return -1;
    80005134:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005136:	0a07c363          	bltz	a5,800051dc <sys_open+0xca>
    8000513a:	f526                	sd	s1,168(sp)

  begin_op();
    8000513c:	c61fe0ef          	jal	80003d9c <begin_op>

  if (omode & O_CREATE) {
    80005140:	f4c42783          	lw	a5,-180(s0)
    80005144:	2007f793          	andi	a5,a5,512
    80005148:	c3dd                	beqz	a5,800051ee <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000514a:	4681                	li	a3,0
    8000514c:	4601                	li	a2,0
    8000514e:	4589                	li	a1,2
    80005150:	f5040513          	addi	a0,s0,-176
    80005154:	aafff0ef          	jal	80004c02 <create>
    80005158:	84aa                	mv	s1,a0
    if (ip == 0) {
    8000515a:	c549                	beqz	a0,800051e4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    8000515c:	04449703          	lh	a4,68(s1)
    80005160:	478d                	li	a5,3
    80005162:	00f71763          	bne	a4,a5,80005170 <sys_open+0x5e>
    80005166:	0464d703          	lhu	a4,70(s1)
    8000516a:	47a5                	li	a5,9
    8000516c:	0ae7ee63          	bltu	a5,a4,80005228 <sys_open+0x116>
    80005170:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005172:	fabfe0ef          	jal	8000411c <filealloc>
    80005176:	892a                	mv	s2,a0
    80005178:	c561                	beqz	a0,80005240 <sys_open+0x12e>
    8000517a:	ed4e                	sd	s3,152(sp)
    8000517c:	a47ff0ef          	jal	80004bc2 <fdalloc>
    80005180:	89aa                	mv	s3,a0
    80005182:	0a054b63          	bltz	a0,80005238 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005186:	04449703          	lh	a4,68(s1)
    8000518a:	478d                	li	a5,3
    8000518c:	0cf70363          	beq	a4,a5,80005252 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005190:	4789                	li	a5,2
    80005192:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005196:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000519a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000519e:	f4c42783          	lw	a5,-180(s0)
    800051a2:	0017f713          	andi	a4,a5,1
    800051a6:	00174713          	xori	a4,a4,1
    800051aa:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800051ae:	0037f713          	andi	a4,a5,3
    800051b2:	00e03733          	snez	a4,a4
    800051b6:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800051ba:	4007f793          	andi	a5,a5,1024
    800051be:	c791                	beqz	a5,800051ca <sys_open+0xb8>
    800051c0:	04449703          	lh	a4,68(s1)
    800051c4:	4789                	li	a5,2
    800051c6:	08f70d63          	beq	a4,a5,80005260 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800051ca:	8526                	mv	a0,s1
    800051cc:	a72fe0ef          	jal	8000343e <iunlock>
  end_op();
    800051d0:	c3dfe0ef          	jal	80003e0c <end_op>

  return fd;
    800051d4:	854e                	mv	a0,s3
    800051d6:	74aa                	ld	s1,168(sp)
    800051d8:	790a                	ld	s2,160(sp)
    800051da:	69ea                	ld	s3,152(sp)
}
    800051dc:	70ea                	ld	ra,184(sp)
    800051de:	744a                	ld	s0,176(sp)
    800051e0:	6129                	addi	sp,sp,192
    800051e2:	8082                	ret
      end_op();
    800051e4:	c29fe0ef          	jal	80003e0c <end_op>
      return -1;
    800051e8:	557d                	li	a0,-1
    800051ea:	74aa                	ld	s1,168(sp)
    800051ec:	bfc5                	j	800051dc <sys_open+0xca>
    if ((ip = namei(path)) == 0) {
    800051ee:	f5040513          	addi	a0,s0,-176
    800051f2:	9cdfe0ef          	jal	80003bbe <namei>
    800051f6:	84aa                	mv	s1,a0
    800051f8:	c11d                	beqz	a0,8000521e <sys_open+0x10c>
    ilock(ip);
    800051fa:	996fe0ef          	jal	80003390 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    800051fe:	04449703          	lh	a4,68(s1)
    80005202:	4785                	li	a5,1
    80005204:	f4f71ce3          	bne	a4,a5,8000515c <sys_open+0x4a>
    80005208:	f4c42783          	lw	a5,-180(s0)
    8000520c:	d3b5                	beqz	a5,80005170 <sys_open+0x5e>
      iunlockput(ip);
    8000520e:	8526                	mv	a0,s1
    80005210:	b8cfe0ef          	jal	8000359c <iunlockput>
      end_op();
    80005214:	bf9fe0ef          	jal	80003e0c <end_op>
      return -1;
    80005218:	557d                	li	a0,-1
    8000521a:	74aa                	ld	s1,168(sp)
    8000521c:	b7c1                	j	800051dc <sys_open+0xca>
      end_op();
    8000521e:	beffe0ef          	jal	80003e0c <end_op>
      return -1;
    80005222:	557d                	li	a0,-1
    80005224:	74aa                	ld	s1,168(sp)
    80005226:	bf5d                	j	800051dc <sys_open+0xca>
    iunlockput(ip);
    80005228:	8526                	mv	a0,s1
    8000522a:	b72fe0ef          	jal	8000359c <iunlockput>
    end_op();
    8000522e:	bdffe0ef          	jal	80003e0c <end_op>
    return -1;
    80005232:	557d                	li	a0,-1
    80005234:	74aa                	ld	s1,168(sp)
    80005236:	b75d                	j	800051dc <sys_open+0xca>
      fileclose(f);
    80005238:	854a                	mv	a0,s2
    8000523a:	f87fe0ef          	jal	800041c0 <fileclose>
    8000523e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005240:	8526                	mv	a0,s1
    80005242:	b5afe0ef          	jal	8000359c <iunlockput>
    end_op();
    80005246:	bc7fe0ef          	jal	80003e0c <end_op>
    return -1;
    8000524a:	557d                	li	a0,-1
    8000524c:	74aa                	ld	s1,168(sp)
    8000524e:	790a                	ld	s2,160(sp)
    80005250:	b771                	j	800051dc <sys_open+0xca>
    f->type = FD_DEVICE;
    80005252:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005256:	04649783          	lh	a5,70(s1)
    8000525a:	02f91223          	sh	a5,36(s2)
    8000525e:	bf35                	j	8000519a <sys_open+0x88>
    itrunc(ip);
    80005260:	8526                	mv	a0,s1
    80005262:	a1cfe0ef          	jal	8000347e <itrunc>
    80005266:	b795                	j	800051ca <sys_open+0xb8>

0000000080005268 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005268:	7175                	addi	sp,sp,-144
    8000526a:	e506                	sd	ra,136(sp)
    8000526c:	e122                	sd	s0,128(sp)
    8000526e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005270:	b2dfe0ef          	jal	80003d9c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005274:	08000613          	li	a2,128
    80005278:	f7040593          	addi	a1,s0,-144
    8000527c:	4501                	li	a0,0
    8000527e:	e2efd0ef          	jal	800028ac <argstr>
    80005282:	02054363          	bltz	a0,800052a8 <sys_mkdir+0x40>
    80005286:	4681                	li	a3,0
    80005288:	4601                	li	a2,0
    8000528a:	4585                	li	a1,1
    8000528c:	f7040513          	addi	a0,s0,-144
    80005290:	973ff0ef          	jal	80004c02 <create>
    80005294:	c911                	beqz	a0,800052a8 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005296:	b06fe0ef          	jal	8000359c <iunlockput>
  end_op();
    8000529a:	b73fe0ef          	jal	80003e0c <end_op>
  return 0;
    8000529e:	4501                	li	a0,0
}
    800052a0:	60aa                	ld	ra,136(sp)
    800052a2:	640a                	ld	s0,128(sp)
    800052a4:	6149                	addi	sp,sp,144
    800052a6:	8082                	ret
    end_op();
    800052a8:	b65fe0ef          	jal	80003e0c <end_op>
    return -1;
    800052ac:	557d                	li	a0,-1
    800052ae:	bfcd                	j	800052a0 <sys_mkdir+0x38>

00000000800052b0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800052b0:	7135                	addi	sp,sp,-160
    800052b2:	ed06                	sd	ra,152(sp)
    800052b4:	e922                	sd	s0,144(sp)
    800052b6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800052b8:	ae5fe0ef          	jal	80003d9c <begin_op>
  argint(1, &major);
    800052bc:	f6c40593          	addi	a1,s0,-148
    800052c0:	4505                	li	a0,1
    800052c2:	db2fd0ef          	jal	80002874 <argint>
  argint(2, &minor);
    800052c6:	f6840593          	addi	a1,s0,-152
    800052ca:	4509                	li	a0,2
    800052cc:	da8fd0ef          	jal	80002874 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800052d0:	08000613          	li	a2,128
    800052d4:	f7040593          	addi	a1,s0,-144
    800052d8:	4501                	li	a0,0
    800052da:	dd2fd0ef          	jal	800028ac <argstr>
    800052de:	02054563          	bltz	a0,80005308 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    800052e2:	f6841683          	lh	a3,-152(s0)
    800052e6:	f6c41603          	lh	a2,-148(s0)
    800052ea:	458d                	li	a1,3
    800052ec:	f7040513          	addi	a0,s0,-144
    800052f0:	913ff0ef          	jal	80004c02 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800052f4:	c911                	beqz	a0,80005308 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800052f6:	aa6fe0ef          	jal	8000359c <iunlockput>
  end_op();
    800052fa:	b13fe0ef          	jal	80003e0c <end_op>
  return 0;
    800052fe:	4501                	li	a0,0
}
    80005300:	60ea                	ld	ra,152(sp)
    80005302:	644a                	ld	s0,144(sp)
    80005304:	610d                	addi	sp,sp,160
    80005306:	8082                	ret
    end_op();
    80005308:	b05fe0ef          	jal	80003e0c <end_op>
    return -1;
    8000530c:	557d                	li	a0,-1
    8000530e:	bfcd                	j	80005300 <sys_mknod+0x50>

0000000080005310 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005310:	7135                	addi	sp,sp,-160
    80005312:	ed06                	sd	ra,152(sp)
    80005314:	e922                	sd	s0,144(sp)
    80005316:	e14a                	sd	s2,128(sp)
    80005318:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000531a:	de8fc0ef          	jal	80001902 <myproc>
    8000531e:	892a                	mv	s2,a0

  begin_op();
    80005320:	a7dfe0ef          	jal	80003d9c <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005324:	08000613          	li	a2,128
    80005328:	f6040593          	addi	a1,s0,-160
    8000532c:	4501                	li	a0,0
    8000532e:	d7efd0ef          	jal	800028ac <argstr>
    80005332:	04054363          	bltz	a0,80005378 <sys_chdir+0x68>
    80005336:	e526                	sd	s1,136(sp)
    80005338:	f6040513          	addi	a0,s0,-160
    8000533c:	883fe0ef          	jal	80003bbe <namei>
    80005340:	84aa                	mv	s1,a0
    80005342:	c915                	beqz	a0,80005376 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005344:	84cfe0ef          	jal	80003390 <ilock>
  if (ip->type != T_DIR) {
    80005348:	04449703          	lh	a4,68(s1)
    8000534c:	4785                	li	a5,1
    8000534e:	02f71963          	bne	a4,a5,80005380 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005352:	8526                	mv	a0,s1
    80005354:	8eafe0ef          	jal	8000343e <iunlock>
  iput(p->cwd);
    80005358:	15893503          	ld	a0,344(s2)
    8000535c:	9b6fe0ef          	jal	80003512 <iput>
  end_op();
    80005360:	aadfe0ef          	jal	80003e0c <end_op>
  p->cwd = ip;
    80005364:	14993c23          	sd	s1,344(s2)
  return 0;
    80005368:	4501                	li	a0,0
    8000536a:	64aa                	ld	s1,136(sp)
}
    8000536c:	60ea                	ld	ra,152(sp)
    8000536e:	644a                	ld	s0,144(sp)
    80005370:	690a                	ld	s2,128(sp)
    80005372:	610d                	addi	sp,sp,160
    80005374:	8082                	ret
    80005376:	64aa                	ld	s1,136(sp)
    end_op();
    80005378:	a95fe0ef          	jal	80003e0c <end_op>
    return -1;
    8000537c:	557d                	li	a0,-1
    8000537e:	b7fd                	j	8000536c <sys_chdir+0x5c>
    iunlockput(ip);
    80005380:	8526                	mv	a0,s1
    80005382:	a1afe0ef          	jal	8000359c <iunlockput>
    end_op();
    80005386:	a87fe0ef          	jal	80003e0c <end_op>
    return -1;
    8000538a:	557d                	li	a0,-1
    8000538c:	64aa                	ld	s1,136(sp)
    8000538e:	bff9                	j	8000536c <sys_chdir+0x5c>

0000000080005390 <sys_exec>:

uint64
sys_exec(void)
{
    80005390:	7105                	addi	sp,sp,-480
    80005392:	ef86                	sd	ra,472(sp)
    80005394:	eba2                	sd	s0,464(sp)
    80005396:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005398:	e2840593          	addi	a1,s0,-472
    8000539c:	4505                	li	a0,1
    8000539e:	cf2fd0ef          	jal	80002890 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    800053a2:	08000613          	li	a2,128
    800053a6:	f3040593          	addi	a1,s0,-208
    800053aa:	4501                	li	a0,0
    800053ac:	d00fd0ef          	jal	800028ac <argstr>
    800053b0:	87aa                	mv	a5,a0
    return -1;
    800053b2:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    800053b4:	0e07c063          	bltz	a5,80005494 <sys_exec+0x104>
    800053b8:	e7a6                	sd	s1,456(sp)
    800053ba:	e3ca                	sd	s2,448(sp)
    800053bc:	ff4e                	sd	s3,440(sp)
    800053be:	fb52                	sd	s4,432(sp)
    800053c0:	f756                	sd	s5,424(sp)
    800053c2:	f35a                	sd	s6,416(sp)
    800053c4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800053c6:	e3040a13          	addi	s4,s0,-464
    800053ca:	10000613          	li	a2,256
    800053ce:	4581                	li	a1,0
    800053d0:	8552                	mv	a0,s4
    800053d2:	8fbfb0ef          	jal	80000ccc <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800053d6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800053d8:	89d2                	mv	s3,s4
    800053da:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800053dc:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800053e0:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    800053e2:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800053e6:	00391513          	slli	a0,s2,0x3
    800053ea:	85d6                	mv	a1,s5
    800053ec:	e2843783          	ld	a5,-472(s0)
    800053f0:	953e                	add	a0,a0,a5
    800053f2:	bf8fd0ef          	jal	800027ea <fetchaddr>
    800053f6:	02054663          	bltz	a0,80005422 <sys_exec+0x92>
    if (uarg == 0) {
    800053fa:	e2043783          	ld	a5,-480(s0)
    800053fe:	c7a1                	beqz	a5,80005446 <sys_exec+0xb6>
    argv[i] = kalloc();
    80005400:	f20fb0ef          	jal	80000b20 <kalloc>
    80005404:	85aa                	mv	a1,a0
    80005406:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    8000540a:	cd01                	beqz	a0,80005422 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000540c:	865a                	mv	a2,s6
    8000540e:	e2043503          	ld	a0,-480(s0)
    80005412:	c22fd0ef          	jal	80002834 <fetchstr>
    80005416:	00054663          	bltz	a0,80005422 <sys_exec+0x92>
    if (i >= NELEM(argv)) {
    8000541a:	0905                	addi	s2,s2,1
    8000541c:	09a1                	addi	s3,s3,8
    8000541e:	fd7914e3          	bne	s2,s7,800053e6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005422:	100a0a13          	addi	s4,s4,256
    80005426:	6088                	ld	a0,0(s1)
    80005428:	cd31                	beqz	a0,80005484 <sys_exec+0xf4>
    kfree(argv[i]);
    8000542a:	e0efb0ef          	jal	80000a38 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000542e:	04a1                	addi	s1,s1,8
    80005430:	ff449be3          	bne	s1,s4,80005426 <sys_exec+0x96>
  return -1;
    80005434:	557d                	li	a0,-1
    80005436:	64be                	ld	s1,456(sp)
    80005438:	691e                	ld	s2,448(sp)
    8000543a:	79fa                	ld	s3,440(sp)
    8000543c:	7a5a                	ld	s4,432(sp)
    8000543e:	7aba                	ld	s5,424(sp)
    80005440:	7b1a                	ld	s6,416(sp)
    80005442:	6bfa                	ld	s7,408(sp)
    80005444:	a881                	j	80005494 <sys_exec+0x104>
      argv[i] = 0;
    80005446:	0009079b          	sext.w	a5,s2
    8000544a:	e3040593          	addi	a1,s0,-464
    8000544e:	078e                	slli	a5,a5,0x3
    80005450:	97ae                	add	a5,a5,a1
    80005452:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005456:	f3040513          	addi	a0,s0,-208
    8000545a:	bb2ff0ef          	jal	8000480c <kexec>
    8000545e:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005460:	100a0a13          	addi	s4,s4,256
    80005464:	6088                	ld	a0,0(s1)
    80005466:	c511                	beqz	a0,80005472 <sys_exec+0xe2>
    kfree(argv[i]);
    80005468:	dd0fb0ef          	jal	80000a38 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000546c:	04a1                	addi	s1,s1,8
    8000546e:	ff449be3          	bne	s1,s4,80005464 <sys_exec+0xd4>
  return ret;
    80005472:	854a                	mv	a0,s2
    80005474:	64be                	ld	s1,456(sp)
    80005476:	691e                	ld	s2,448(sp)
    80005478:	79fa                	ld	s3,440(sp)
    8000547a:	7a5a                	ld	s4,432(sp)
    8000547c:	7aba                	ld	s5,424(sp)
    8000547e:	7b1a                	ld	s6,416(sp)
    80005480:	6bfa                	ld	s7,408(sp)
    80005482:	a809                	j	80005494 <sys_exec+0x104>
  return -1;
    80005484:	557d                	li	a0,-1
    80005486:	64be                	ld	s1,456(sp)
    80005488:	691e                	ld	s2,448(sp)
    8000548a:	79fa                	ld	s3,440(sp)
    8000548c:	7a5a                	ld	s4,432(sp)
    8000548e:	7aba                	ld	s5,424(sp)
    80005490:	7b1a                	ld	s6,416(sp)
    80005492:	6bfa                	ld	s7,408(sp)
}
    80005494:	60fe                	ld	ra,472(sp)
    80005496:	645e                	ld	s0,464(sp)
    80005498:	613d                	addi	sp,sp,480
    8000549a:	8082                	ret

000000008000549c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000549c:	7139                	addi	sp,sp,-64
    8000549e:	fc06                	sd	ra,56(sp)
    800054a0:	f822                	sd	s0,48(sp)
    800054a2:	f426                	sd	s1,40(sp)
    800054a4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800054a6:	c5cfc0ef          	jal	80001902 <myproc>
    800054aa:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800054ac:	fd840593          	addi	a1,s0,-40
    800054b0:	4501                	li	a0,0
    800054b2:	bdefd0ef          	jal	80002890 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    800054b6:	fc840593          	addi	a1,s0,-56
    800054ba:	fd040513          	addi	a0,s0,-48
    800054be:	81eff0ef          	jal	800044dc <pipealloc>
    return -1;
    800054c2:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    800054c4:	0a054763          	bltz	a0,80005572 <sys_pipe+0xd6>
  fd0 = -1;
    800054c8:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800054cc:	fd043503          	ld	a0,-48(s0)
    800054d0:	ef2ff0ef          	jal	80004bc2 <fdalloc>
    800054d4:	fca42223          	sw	a0,-60(s0)
    800054d8:	08054463          	bltz	a0,80005560 <sys_pipe+0xc4>
    800054dc:	fc843503          	ld	a0,-56(s0)
    800054e0:	ee2ff0ef          	jal	80004bc2 <fdalloc>
    800054e4:	fca42023          	sw	a0,-64(s0)
    800054e8:	06054263          	bltz	a0,8000554c <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800054ec:	4691                	li	a3,4
    800054ee:	fc440613          	addi	a2,s0,-60
    800054f2:	fd843583          	ld	a1,-40(s0)
    800054f6:	6ca8                	ld	a0,88(s1)
    800054f8:	930fc0ef          	jal	80001628 <copyout>
    800054fc:	00054e63          	bltz	a0,80005518 <sys_pipe+0x7c>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80005500:	4691                	li	a3,4
    80005502:	fc040613          	addi	a2,s0,-64
    80005506:	fd843583          	ld	a1,-40(s0)
    8000550a:	95b6                	add	a1,a1,a3
    8000550c:	6ca8                	ld	a0,88(s1)
    8000550e:	91afc0ef          	jal	80001628 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005512:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005514:	04055f63          	bgez	a0,80005572 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80005518:	fc442783          	lw	a5,-60(s0)
    8000551c:	078e                	slli	a5,a5,0x3
    8000551e:	0d078793          	addi	a5,a5,208
    80005522:	97a6                	add	a5,a5,s1
    80005524:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005528:	fc042783          	lw	a5,-64(s0)
    8000552c:	078e                	slli	a5,a5,0x3
    8000552e:	0d078793          	addi	a5,a5,208
    80005532:	97a6                	add	a5,a5,s1
    80005534:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005538:	fd043503          	ld	a0,-48(s0)
    8000553c:	c85fe0ef          	jal	800041c0 <fileclose>
    fileclose(wf);
    80005540:	fc843503          	ld	a0,-56(s0)
    80005544:	c7dfe0ef          	jal	800041c0 <fileclose>
    return -1;
    80005548:	57fd                	li	a5,-1
    8000554a:	a025                	j	80005572 <sys_pipe+0xd6>
    if (fd0 >= 0)
    8000554c:	fc442783          	lw	a5,-60(s0)
    80005550:	0007c863          	bltz	a5,80005560 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80005554:	078e                	slli	a5,a5,0x3
    80005556:	0d078793          	addi	a5,a5,208
    8000555a:	97a6                	add	a5,a5,s1
    8000555c:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005560:	fd043503          	ld	a0,-48(s0)
    80005564:	c5dfe0ef          	jal	800041c0 <fileclose>
    fileclose(wf);
    80005568:	fc843503          	ld	a0,-56(s0)
    8000556c:	c55fe0ef          	jal	800041c0 <fileclose>
    return -1;
    80005570:	57fd                	li	a5,-1
}
    80005572:	853e                	mv	a0,a5
    80005574:	70e2                	ld	ra,56(sp)
    80005576:	7442                	ld	s0,48(sp)
    80005578:	74a2                	ld	s1,40(sp)
    8000557a:	6121                	addi	sp,sp,64
    8000557c:	8082                	ret
	...

0000000080005580 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005580:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005582:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005584:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005586:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005588:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000558a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000558c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000558e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005590:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005592:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005594:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005596:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005598:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000559a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000559c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000559e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800055a0:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800055a2:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800055a4:	954fd0ef          	jal	800026f8 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800055a8:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800055aa:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800055ac:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800055ae:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800055b0:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800055b2:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800055b4:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800055b6:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800055b8:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800055ba:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800055bc:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800055be:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800055c0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800055c2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800055c4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800055c6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800055c8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800055ca:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800055cc:	10200073          	sret
    800055d0:	0001                	nop
    800055d2:	00000013          	nop
    800055d6:	00000013          	nop
    800055da:	00000013          	nop

00000000800055de <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800055de:	1141                	addi	sp,sp,-16
    800055e0:	e406                	sd	ra,8(sp)
    800055e2:	e022                	sd	s0,0(sp)
    800055e4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    800055e6:	0c000737          	lui	a4,0xc000
    800055ea:	4785                	li	a5,1
    800055ec:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800055ee:	c35c                	sw	a5,4(a4)
}
    800055f0:	60a2                	ld	ra,8(sp)
    800055f2:	6402                	ld	s0,0(sp)
    800055f4:	0141                	addi	sp,sp,16
    800055f6:	8082                	ret

00000000800055f8 <plicinithart>:

void
plicinithart(void)
{
    800055f8:	1141                	addi	sp,sp,-16
    800055fa:	e406                	sd	ra,8(sp)
    800055fc:	e022                	sd	s0,0(sp)
    800055fe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005600:	acefc0ef          	jal	800018ce <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005604:	0085171b          	slliw	a4,a0,0x8
    80005608:	0c0027b7          	lui	a5,0xc002
    8000560c:	97ba                	add	a5,a5,a4
    8000560e:	40200713          	li	a4,1026
    80005612:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005616:	00d5151b          	slliw	a0,a0,0xd
    8000561a:	0c2017b7          	lui	a5,0xc201
    8000561e:	97aa                	add	a5,a5,a0
    80005620:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005624:	60a2                	ld	ra,8(sp)
    80005626:	6402                	ld	s0,0(sp)
    80005628:	0141                	addi	sp,sp,16
    8000562a:	8082                	ret

000000008000562c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000562c:	1141                	addi	sp,sp,-16
    8000562e:	e406                	sd	ra,8(sp)
    80005630:	e022                	sd	s0,0(sp)
    80005632:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005634:	a9afc0ef          	jal	800018ce <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005638:	00d5151b          	slliw	a0,a0,0xd
    8000563c:	0c2017b7          	lui	a5,0xc201
    80005640:	97aa                	add	a5,a5,a0
  return irq;
}
    80005642:	43c8                	lw	a0,4(a5)
    80005644:	60a2                	ld	ra,8(sp)
    80005646:	6402                	ld	s0,0(sp)
    80005648:	0141                	addi	sp,sp,16
    8000564a:	8082                	ret

000000008000564c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000564c:	1101                	addi	sp,sp,-32
    8000564e:	ec06                	sd	ra,24(sp)
    80005650:	e822                	sd	s0,16(sp)
    80005652:	e426                	sd	s1,8(sp)
    80005654:	1000                	addi	s0,sp,32
    80005656:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005658:	a76fc0ef          	jal	800018ce <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    8000565c:	00d5179b          	slliw	a5,a0,0xd
    80005660:	0c201737          	lui	a4,0xc201
    80005664:	97ba                	add	a5,a5,a4
    80005666:	c3c4                	sw	s1,4(a5)
}
    80005668:	60e2                	ld	ra,24(sp)
    8000566a:	6442                	ld	s0,16(sp)
    8000566c:	64a2                	ld	s1,8(sp)
    8000566e:	6105                	addi	sp,sp,32
    80005670:	8082                	ret

0000000080005672 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005672:	1141                	addi	sp,sp,-16
    80005674:	e406                	sd	ra,8(sp)
    80005676:	e022                	sd	s0,0(sp)
    80005678:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000567a:	479d                	li	a5,7
    8000567c:	04a7ca63          	blt	a5,a0,800056d0 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005680:	0001b797          	auipc	a5,0x1b
    80005684:	5b878793          	addi	a5,a5,1464 # 80020c38 <disk>
    80005688:	97aa                	add	a5,a5,a0
    8000568a:	0187c783          	lbu	a5,24(a5)
    8000568e:	e7b9                	bnez	a5,800056dc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005690:	00451693          	slli	a3,a0,0x4
    80005694:	0001b797          	auipc	a5,0x1b
    80005698:	5a478793          	addi	a5,a5,1444 # 80020c38 <disk>
    8000569c:	6398                	ld	a4,0(a5)
    8000569e:	9736                	add	a4,a4,a3
    800056a0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800056a4:	6398                	ld	a4,0(a5)
    800056a6:	9736                	add	a4,a4,a3
    800056a8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800056ac:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800056b0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800056b4:	97aa                	add	a5,a5,a0
    800056b6:	4705                	li	a4,1
    800056b8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800056bc:	0001b517          	auipc	a0,0x1b
    800056c0:	59450513          	addi	a0,a0,1428 # 80020c50 <disk+0x18>
    800056c4:	8b5fc0ef          	jal	80001f78 <wakeup>
}
    800056c8:	60a2                	ld	ra,8(sp)
    800056ca:	6402                	ld	s0,0(sp)
    800056cc:	0141                	addi	sp,sp,16
    800056ce:	8082                	ret
    panic("free_desc 1");
    800056d0:	00002517          	auipc	a0,0x2
    800056d4:	f4050513          	addi	a0,a0,-192 # 80007610 <etext+0x610>
    800056d8:	940fb0ef          	jal	80000818 <panic>
    panic("free_desc 2");
    800056dc:	00002517          	auipc	a0,0x2
    800056e0:	f4450513          	addi	a0,a0,-188 # 80007620 <etext+0x620>
    800056e4:	934fb0ef          	jal	80000818 <panic>

00000000800056e8 <virtio_disk_init>:
{
    800056e8:	1101                	addi	sp,sp,-32
    800056ea:	ec06                	sd	ra,24(sp)
    800056ec:	e822                	sd	s0,16(sp)
    800056ee:	e426                	sd	s1,8(sp)
    800056f0:	e04a                	sd	s2,0(sp)
    800056f2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800056f4:	00002597          	auipc	a1,0x2
    800056f8:	f3c58593          	addi	a1,a1,-196 # 80007630 <etext+0x630>
    800056fc:	0001b517          	auipc	a0,0x1b
    80005700:	66450513          	addi	a0,a0,1636 # 80020d60 <disk+0x128>
    80005704:	c76fb0ef          	jal	80000b7a <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005708:	100017b7          	lui	a5,0x10001
    8000570c:	4398                	lw	a4,0(a5)
    8000570e:	2701                	sext.w	a4,a4
    80005710:	747277b7          	lui	a5,0x74727
    80005714:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005718:	14f71863          	bne	a4,a5,80005868 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000571c:	100017b7          	lui	a5,0x10001
    80005720:	43dc                	lw	a5,4(a5)
    80005722:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005724:	4709                	li	a4,2
    80005726:	14e79163          	bne	a5,a4,80005868 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000572a:	100017b7          	lui	a5,0x10001
    8000572e:	479c                	lw	a5,8(a5)
    80005730:	2781                	sext.w	a5,a5
    80005732:	12e79b63          	bne	a5,a4,80005868 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005736:	100017b7          	lui	a5,0x10001
    8000573a:	47d8                	lw	a4,12(a5)
    8000573c:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000573e:	554d47b7          	lui	a5,0x554d4
    80005742:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005746:	12f71163          	bne	a4,a5,80005868 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000574a:	100017b7          	lui	a5,0x10001
    8000574e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005752:	4705                	li	a4,1
    80005754:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005756:	470d                	li	a4,3
    80005758:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000575a:	10001737          	lui	a4,0x10001
    8000575e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005760:	c7ffe6b7          	lui	a3,0xc7ffe
    80005764:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd9e7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005768:	8f75                	and	a4,a4,a3
    8000576a:	100016b7          	lui	a3,0x10001
    8000576e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005770:	472d                	li	a4,11
    80005772:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005774:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005778:	439c                	lw	a5,0(a5)
    8000577a:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000577e:	8ba1                	andi	a5,a5,8
    80005780:	0e078a63          	beqz	a5,80005874 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005784:	100017b7          	lui	a5,0x10001
    80005788:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000578c:	43fc                	lw	a5,68(a5)
    8000578e:	2781                	sext.w	a5,a5
    80005790:	0e079863          	bnez	a5,80005880 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005794:	100017b7          	lui	a5,0x10001
    80005798:	5bdc                	lw	a5,52(a5)
    8000579a:	2781                	sext.w	a5,a5
  if (max == 0)
    8000579c:	0e078863          	beqz	a5,8000588c <virtio_disk_init+0x1a4>
  if (max < NUM)
    800057a0:	471d                	li	a4,7
    800057a2:	0ef77b63          	bgeu	a4,a5,80005898 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800057a6:	b7afb0ef          	jal	80000b20 <kalloc>
    800057aa:	0001b497          	auipc	s1,0x1b
    800057ae:	48e48493          	addi	s1,s1,1166 # 80020c38 <disk>
    800057b2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800057b4:	b6cfb0ef          	jal	80000b20 <kalloc>
    800057b8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800057ba:	b66fb0ef          	jal	80000b20 <kalloc>
    800057be:	87aa                	mv	a5,a0
    800057c0:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    800057c2:	6088                	ld	a0,0(s1)
    800057c4:	0e050063          	beqz	a0,800058a4 <virtio_disk_init+0x1bc>
    800057c8:	0001b717          	auipc	a4,0x1b
    800057cc:	47873703          	ld	a4,1144(a4) # 80020c40 <disk+0x8>
    800057d0:	cb71                	beqz	a4,800058a4 <virtio_disk_init+0x1bc>
    800057d2:	cbe9                	beqz	a5,800058a4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800057d4:	6605                	lui	a2,0x1
    800057d6:	4581                	li	a1,0
    800057d8:	cf4fb0ef          	jal	80000ccc <memset>
  memset(disk.avail, 0, PGSIZE);
    800057dc:	0001b497          	auipc	s1,0x1b
    800057e0:	45c48493          	addi	s1,s1,1116 # 80020c38 <disk>
    800057e4:	6605                	lui	a2,0x1
    800057e6:	4581                	li	a1,0
    800057e8:	6488                	ld	a0,8(s1)
    800057ea:	ce2fb0ef          	jal	80000ccc <memset>
  memset(disk.used, 0, PGSIZE);
    800057ee:	6605                	lui	a2,0x1
    800057f0:	4581                	li	a1,0
    800057f2:	6888                	ld	a0,16(s1)
    800057f4:	cd8fb0ef          	jal	80000ccc <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800057f8:	100017b7          	lui	a5,0x10001
    800057fc:	4721                	li	a4,8
    800057fe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005800:	4098                	lw	a4,0(s1)
    80005802:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005806:	40d8                	lw	a4,4(s1)
    80005808:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000580c:	649c                	ld	a5,8(s1)
    8000580e:	0007869b          	sext.w	a3,a5
    80005812:	10001737          	lui	a4,0x10001
    80005816:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000581a:	9781                	srai	a5,a5,0x20
    8000581c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005820:	689c                	ld	a5,16(s1)
    80005822:	0007869b          	sext.w	a3,a5
    80005826:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000582a:	9781                	srai	a5,a5,0x20
    8000582c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005830:	4785                	li	a5,1
    80005832:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005834:	00f48c23          	sb	a5,24(s1)
    80005838:	00f48ca3          	sb	a5,25(s1)
    8000583c:	00f48d23          	sb	a5,26(s1)
    80005840:	00f48da3          	sb	a5,27(s1)
    80005844:	00f48e23          	sb	a5,28(s1)
    80005848:	00f48ea3          	sb	a5,29(s1)
    8000584c:	00f48f23          	sb	a5,30(s1)
    80005850:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005854:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005858:	07272823          	sw	s2,112(a4)
}
    8000585c:	60e2                	ld	ra,24(sp)
    8000585e:	6442                	ld	s0,16(sp)
    80005860:	64a2                	ld	s1,8(sp)
    80005862:	6902                	ld	s2,0(sp)
    80005864:	6105                	addi	sp,sp,32
    80005866:	8082                	ret
    panic("could not find virtio disk");
    80005868:	00002517          	auipc	a0,0x2
    8000586c:	dd850513          	addi	a0,a0,-552 # 80007640 <etext+0x640>
    80005870:	fa9fa0ef          	jal	80000818 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005874:	00002517          	auipc	a0,0x2
    80005878:	dec50513          	addi	a0,a0,-532 # 80007660 <etext+0x660>
    8000587c:	f9dfa0ef          	jal	80000818 <panic>
    panic("virtio disk should not be ready");
    80005880:	00002517          	auipc	a0,0x2
    80005884:	e0050513          	addi	a0,a0,-512 # 80007680 <etext+0x680>
    80005888:	f91fa0ef          	jal	80000818 <panic>
    panic("virtio disk has no queue 0");
    8000588c:	00002517          	auipc	a0,0x2
    80005890:	e1450513          	addi	a0,a0,-492 # 800076a0 <etext+0x6a0>
    80005894:	f85fa0ef          	jal	80000818 <panic>
    panic("virtio disk max queue too short");
    80005898:	00002517          	auipc	a0,0x2
    8000589c:	e2850513          	addi	a0,a0,-472 # 800076c0 <etext+0x6c0>
    800058a0:	f79fa0ef          	jal	80000818 <panic>
    panic("virtio disk kalloc");
    800058a4:	00002517          	auipc	a0,0x2
    800058a8:	e3c50513          	addi	a0,a0,-452 # 800076e0 <etext+0x6e0>
    800058ac:	f6dfa0ef          	jal	80000818 <panic>

00000000800058b0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800058b0:	711d                	addi	sp,sp,-96
    800058b2:	ec86                	sd	ra,88(sp)
    800058b4:	e8a2                	sd	s0,80(sp)
    800058b6:	e4a6                	sd	s1,72(sp)
    800058b8:	e0ca                	sd	s2,64(sp)
    800058ba:	fc4e                	sd	s3,56(sp)
    800058bc:	f852                	sd	s4,48(sp)
    800058be:	f456                	sd	s5,40(sp)
    800058c0:	f05a                	sd	s6,32(sp)
    800058c2:	ec5e                	sd	s7,24(sp)
    800058c4:	e862                	sd	s8,16(sp)
    800058c6:	1080                	addi	s0,sp,96
    800058c8:	89aa                	mv	s3,a0
    800058ca:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800058cc:	00c52b83          	lw	s7,12(a0)
    800058d0:	001b9b9b          	slliw	s7,s7,0x1
    800058d4:	1b82                	slli	s7,s7,0x20
    800058d6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800058da:	0001b517          	auipc	a0,0x1b
    800058de:	48650513          	addi	a0,a0,1158 # 80020d60 <disk+0x128>
    800058e2:	b22fb0ef          	jal	80000c04 <acquire>
  for (int i = 0; i < NUM; i++) {
    800058e6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800058e8:	0001ba97          	auipc	s5,0x1b
    800058ec:	350a8a93          	addi	s5,s5,848 # 80020c38 <disk>
  for (int i = 0; i < 3; i++) {
    800058f0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800058f2:	5c7d                	li	s8,-1
    800058f4:	a095                	j	80005958 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800058f6:	00fa8733          	add	a4,s5,a5
    800058fa:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800058fe:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005900:	0207c563          	bltz	a5,8000592a <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005904:	2905                	addiw	s2,s2,1
    80005906:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005908:	05490c63          	beq	s2,s4,80005960 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000590c:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    8000590e:	0001b717          	auipc	a4,0x1b
    80005912:	32a70713          	addi	a4,a4,810 # 80020c38 <disk>
    80005916:	4781                	li	a5,0
    if (disk.free[i]) {
    80005918:	01874683          	lbu	a3,24(a4)
    8000591c:	fee9                	bnez	a3,800058f6 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    8000591e:	2785                	addiw	a5,a5,1
    80005920:	0705                	addi	a4,a4,1
    80005922:	fe979be3          	bne	a5,s1,80005918 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005926:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    8000592a:	01205d63          	blez	s2,80005944 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000592e:	fa042503          	lw	a0,-96(s0)
    80005932:	d41ff0ef          	jal	80005672 <free_desc>
      for (int j = 0; j < i; j++)
    80005936:	4785                	li	a5,1
    80005938:	0127d663          	bge	a5,s2,80005944 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000593c:	fa442503          	lw	a0,-92(s0)
    80005940:	d33ff0ef          	jal	80005672 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005944:	0001b597          	auipc	a1,0x1b
    80005948:	41c58593          	addi	a1,a1,1052 # 80020d60 <disk+0x128>
    8000594c:	0001b517          	auipc	a0,0x1b
    80005950:	30450513          	addi	a0,a0,772 # 80020c50 <disk+0x18>
    80005954:	dd8fc0ef          	jal	80001f2c <sleep>
  for (int i = 0; i < 3; i++) {
    80005958:	fa040613          	addi	a2,s0,-96
    8000595c:	4901                	li	s2,0
    8000595e:	b77d                	j	8000590c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005960:	fa042503          	lw	a0,-96(s0)
    80005964:	00451693          	slli	a3,a0,0x4

  if (write)
    80005968:	0001b797          	auipc	a5,0x1b
    8000596c:	2d078793          	addi	a5,a5,720 # 80020c38 <disk>
    80005970:	00451713          	slli	a4,a0,0x4
    80005974:	0a070713          	addi	a4,a4,160
    80005978:	973e                	add	a4,a4,a5
    8000597a:	01603633          	snez	a2,s6
    8000597e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005980:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005984:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005988:	6398                	ld	a4,0(a5)
    8000598a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000598c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005990:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005992:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005994:	6390                	ld	a2,0(a5)
    80005996:	00d60833          	add	a6,a2,a3
    8000599a:	4741                	li	a4,16
    8000599c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800059a0:	4585                	li	a1,1
    800059a2:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    800059a6:	fa442703          	lw	a4,-92(s0)
    800059aa:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64)b->data;
    800059ae:	0712                	slli	a4,a4,0x4
    800059b0:	963a                	add	a2,a2,a4
    800059b2:	05898813          	addi	a6,s3,88
    800059b6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800059ba:	0007b883          	ld	a7,0(a5)
    800059be:	9746                	add	a4,a4,a7
    800059c0:	40000613          	li	a2,1024
    800059c4:	c710                	sw	a2,8(a4)
  if (write)
    800059c6:	001b3613          	seqz	a2,s6
    800059ca:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059ce:	8e4d                	or	a2,a2,a1
    800059d0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800059d4:	fa842603          	lw	a2,-88(s0)
    800059d8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800059dc:	00451813          	slli	a6,a0,0x4
    800059e0:	02080813          	addi	a6,a6,32
    800059e4:	983e                	add	a6,a6,a5
    800059e6:	577d                	li	a4,-1
    800059e8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800059ec:	0612                	slli	a2,a2,0x4
    800059ee:	98b2                	add	a7,a7,a2
    800059f0:	03068713          	addi	a4,a3,48
    800059f4:	973e                	add	a4,a4,a5
    800059f6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800059fa:	6398                	ld	a4,0(a5)
    800059fc:	9732                	add	a4,a4,a2
    800059fe:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005a00:	4689                	li	a3,2
    80005a02:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005a06:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005a0a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80005a0e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005a12:	6794                	ld	a3,8(a5)
    80005a14:	0026d703          	lhu	a4,2(a3)
    80005a18:	8b1d                	andi	a4,a4,7
    80005a1a:	0706                	slli	a4,a4,0x1
    80005a1c:	96ba                	add	a3,a3,a4
    80005a1e:	00a69223          	sh	a0,4(a3)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005a22:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a26:	6798                	ld	a4,8(a5)
    80005a28:	00275783          	lhu	a5,2(a4)
    80005a2c:	2785                	addiw	a5,a5,1
    80005a2e:	00f71123          	sh	a5,2(a4)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005a32:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a36:	100017b7          	lui	a5,0x10001
    80005a3a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005a3e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005a42:	0001b917          	auipc	s2,0x1b
    80005a46:	31e90913          	addi	s2,s2,798 # 80020d60 <disk+0x128>
  while (b->disk == 1) {
    80005a4a:	84ae                	mv	s1,a1
    80005a4c:	00b79a63          	bne	a5,a1,80005a60 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005a50:	85ca                	mv	a1,s2
    80005a52:	854e                	mv	a0,s3
    80005a54:	cd8fc0ef          	jal	80001f2c <sleep>
  while (b->disk == 1) {
    80005a58:	0049a783          	lw	a5,4(s3)
    80005a5c:	fe978ae3          	beq	a5,s1,80005a50 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005a60:	fa042903          	lw	s2,-96(s0)
    80005a64:	00491713          	slli	a4,s2,0x4
    80005a68:	02070713          	addi	a4,a4,32
    80005a6c:	0001b797          	auipc	a5,0x1b
    80005a70:	1cc78793          	addi	a5,a5,460 # 80020c38 <disk>
    80005a74:	97ba                	add	a5,a5,a4
    80005a76:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a7a:	0001b997          	auipc	s3,0x1b
    80005a7e:	1be98993          	addi	s3,s3,446 # 80020c38 <disk>
    80005a82:	00491713          	slli	a4,s2,0x4
    80005a86:	0009b783          	ld	a5,0(s3)
    80005a8a:	97ba                	add	a5,a5,a4
    80005a8c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a90:	854a                	mv	a0,s2
    80005a92:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a96:	bddff0ef          	jal	80005672 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005a9a:	8885                	andi	s1,s1,1
    80005a9c:	f0fd                	bnez	s1,80005a82 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a9e:	0001b517          	auipc	a0,0x1b
    80005aa2:	2c250513          	addi	a0,a0,706 # 80020d60 <disk+0x128>
    80005aa6:	9eefb0ef          	jal	80000c94 <release>
}
    80005aaa:	60e6                	ld	ra,88(sp)
    80005aac:	6446                	ld	s0,80(sp)
    80005aae:	64a6                	ld	s1,72(sp)
    80005ab0:	6906                	ld	s2,64(sp)
    80005ab2:	79e2                	ld	s3,56(sp)
    80005ab4:	7a42                	ld	s4,48(sp)
    80005ab6:	7aa2                	ld	s5,40(sp)
    80005ab8:	7b02                	ld	s6,32(sp)
    80005aba:	6be2                	ld	s7,24(sp)
    80005abc:	6c42                	ld	s8,16(sp)
    80005abe:	6125                	addi	sp,sp,96
    80005ac0:	8082                	ret

0000000080005ac2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ac2:	1101                	addi	sp,sp,-32
    80005ac4:	ec06                	sd	ra,24(sp)
    80005ac6:	e822                	sd	s0,16(sp)
    80005ac8:	e426                	sd	s1,8(sp)
    80005aca:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005acc:	0001b497          	auipc	s1,0x1b
    80005ad0:	16c48493          	addi	s1,s1,364 # 80020c38 <disk>
    80005ad4:	0001b517          	auipc	a0,0x1b
    80005ad8:	28c50513          	addi	a0,a0,652 # 80020d60 <disk+0x128>
    80005adc:	928fb0ef          	jal	80000c04 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ae0:	100017b7          	lui	a5,0x10001
    80005ae4:	53bc                	lw	a5,96(a5)
    80005ae6:	8b8d                	andi	a5,a5,3
    80005ae8:	10001737          	lui	a4,0x10001
    80005aec:	d37c                	sw	a5,100(a4)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005aee:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005af2:	689c                	ld	a5,16(s1)
    80005af4:	0204d703          	lhu	a4,32(s1)
    80005af8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005afc:	04f70863          	beq	a4,a5,80005b4c <virtio_disk_intr+0x8a>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005b00:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b04:	6898                	ld	a4,16(s1)
    80005b06:	0204d783          	lhu	a5,32(s1)
    80005b0a:	8b9d                	andi	a5,a5,7
    80005b0c:	078e                	slli	a5,a5,0x3
    80005b0e:	97ba                	add	a5,a5,a4
    80005b10:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005b12:	00479713          	slli	a4,a5,0x4
    80005b16:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80005b1a:	9726                	add	a4,a4,s1
    80005b1c:	01074703          	lbu	a4,16(a4)
    80005b20:	e329                	bnez	a4,80005b62 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b22:	0792                	slli	a5,a5,0x4
    80005b24:	02078793          	addi	a5,a5,32
    80005b28:	97a6                	add	a5,a5,s1
    80005b2a:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005b2c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b30:	c48fc0ef          	jal	80001f78 <wakeup>

    disk.used_idx += 1;
    80005b34:	0204d783          	lhu	a5,32(s1)
    80005b38:	2785                	addiw	a5,a5,1
    80005b3a:	17c2                	slli	a5,a5,0x30
    80005b3c:	93c1                	srli	a5,a5,0x30
    80005b3e:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005b42:	6898                	ld	a4,16(s1)
    80005b44:	00275703          	lhu	a4,2(a4)
    80005b48:	faf71ce3          	bne	a4,a5,80005b00 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005b4c:	0001b517          	auipc	a0,0x1b
    80005b50:	21450513          	addi	a0,a0,532 # 80020d60 <disk+0x128>
    80005b54:	940fb0ef          	jal	80000c94 <release>
}
    80005b58:	60e2                	ld	ra,24(sp)
    80005b5a:	6442                	ld	s0,16(sp)
    80005b5c:	64a2                	ld	s1,8(sp)
    80005b5e:	6105                	addi	sp,sp,32
    80005b60:	8082                	ret
      panic("virtio_disk_intr status");
    80005b62:	00002517          	auipc	a0,0x2
    80005b66:	b9650513          	addi	a0,a0,-1130 # 800076f8 <etext+0x6f8>
    80005b6a:	caffa0ef          	jal	80000818 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
