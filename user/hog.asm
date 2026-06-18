
user/_hog:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
    volatile int dummy = 0;
   8:	fe042623          	sw	zero,-20(s0)
   c:	1dcd6737          	lui	a4,0x1dcd6
  10:	50070713          	addi	a4,a4,1280 # 1dcd6500 <base+0x1dcd54f0>
    
    // A loop big enough to take a few seconds, but not infinite
    for(long long i = 0; i < 500000000; i++) {
        dummy = dummy + 1; 
  14:	fec42783          	lw	a5,-20(s0)
  18:	2785                	addiw	a5,a5,1
  1a:	fef42623          	sw	a5,-20(s0)
    for(long long i = 0; i < 500000000; i++) {
  1e:	177d                	addi	a4,a4,-1
  20:	fb75                	bnez	a4,14 <main+0x14>
    }
    
    printf("Hog finally finished!\n");
  22:	00001517          	auipc	a0,0x1
  26:	8ce50513          	addi	a0,a0,-1842 # 8f0 <malloc+0xf8>
  2a:	716000ef          	jal	740 <printf>
    exit(0); 
  2e:	4501                	li	a0,0
  30:	2ba000ef          	jal	2ea <exit>

0000000000000034 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  34:	1141                	addi	sp,sp,-16
  36:	e406                	sd	ra,8(sp)
  38:	e022                	sd	s0,0(sp)
  3a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  3c:	fc5ff0ef          	jal	0 <main>
  exit(r);
  40:	2aa000ef          	jal	2ea <exit>

0000000000000044 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  4c:	87aa                	mv	a5,a0
  4e:	0585                	addi	a1,a1,1
  50:	0785                	addi	a5,a5,1
  52:	fff5c703          	lbu	a4,-1(a1)
  56:	fee78fa3          	sb	a4,-1(a5)
  5a:	fb75                	bnez	a4,4e <strcpy+0xa>
    ;
  return os;
}
  5c:	60a2                	ld	ra,8(sp)
  5e:	6402                	ld	s0,0(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  6c:	00054783          	lbu	a5,0(a0)
  70:	cb91                	beqz	a5,84 <strcmp+0x20>
  72:	0005c703          	lbu	a4,0(a1)
  76:	00f71763          	bne	a4,a5,84 <strcmp+0x20>
    p++, q++;
  7a:	0505                	addi	a0,a0,1
  7c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  7e:	00054783          	lbu	a5,0(a0)
  82:	fbe5                	bnez	a5,72 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  84:	0005c503          	lbu	a0,0(a1)
}
  88:	40a7853b          	subw	a0,a5,a0
  8c:	60a2                	ld	ra,8(sp)
  8e:	6402                	ld	s0,0(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strlen>:

uint
strlen(const char *s)
{
  94:	1141                	addi	sp,sp,-16
  96:	e406                	sd	ra,8(sp)
  98:	e022                	sd	s0,0(sp)
  9a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  9c:	00054783          	lbu	a5,0(a0)
  a0:	cf91                	beqz	a5,bc <strlen+0x28>
  a2:	00150793          	addi	a5,a0,1
  a6:	86be                	mv	a3,a5
  a8:	0785                	addi	a5,a5,1
  aa:	fff7c703          	lbu	a4,-1(a5)
  ae:	ff65                	bnez	a4,a6 <strlen+0x12>
  b0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret
  for (n = 0; s[n]; n++)
  bc:	4501                	li	a0,0
  be:	bfdd                	j	b4 <strlen+0x20>

00000000000000c0 <memset>:

void *
memset(void *dst, int c, uint n)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  c8:	ca19                	beqz	a2,de <memset+0x1e>
  ca:	87aa                	mv	a5,a0
  cc:	1602                	slli	a2,a2,0x20
  ce:	9201                	srli	a2,a2,0x20
  d0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  d8:	0785                	addi	a5,a5,1
  da:	fee79de3          	bne	a5,a4,d4 <memset+0x14>
  }
  return dst;
}
  de:	60a2                	ld	ra,8(sp)
  e0:	6402                	ld	s0,0(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strchr>:

char *
strchr(const char *s, char c)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  for (; *s; s++)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cf81                	beqz	a5,10a <strchr+0x24>
    if (*s == c)
  f4:	00f58763          	beq	a1,a5,102 <strchr+0x1c>
  for (; *s; s++)
  f8:	0505                	addi	a0,a0,1
  fa:	00054783          	lbu	a5,0(a0)
  fe:	fbfd                	bnez	a5,f4 <strchr+0xe>
      return (char *)s;
  return 0;
 100:	4501                	li	a0,0
}
 102:	60a2                	ld	ra,8(sp)
 104:	6402                	ld	s0,0(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  return 0;
 10a:	4501                	li	a0,0
 10c:	bfdd                	j	102 <strchr+0x1c>

000000000000010e <gets>:

char *
gets(char *buf, int max)
{
 10e:	711d                	addi	sp,sp,-96
 110:	ec86                	sd	ra,88(sp)
 112:	e8a2                	sd	s0,80(sp)
 114:	e4a6                	sd	s1,72(sp)
 116:	e0ca                	sd	s2,64(sp)
 118:	fc4e                	sd	s3,56(sp)
 11a:	f852                	sd	s4,48(sp)
 11c:	f456                	sd	s5,40(sp)
 11e:	f05a                	sd	s6,32(sp)
 120:	ec5e                	sd	s7,24(sp)
 122:	e862                	sd	s8,16(sp)
 124:	1080                	addi	s0,sp,96
 126:	8baa                	mv	s7,a0
 128:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 12a:	892a                	mv	s2,a0
 12c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 12e:	faf40b13          	addi	s6,s0,-81
 132:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 134:	8c26                	mv	s8,s1
 136:	0014899b          	addiw	s3,s1,1
 13a:	84ce                	mv	s1,s3
 13c:	0349d463          	bge	s3,s4,164 <gets+0x56>
    cc = read(0, &c, 1);
 140:	8656                	mv	a2,s5
 142:	85da                	mv	a1,s6
 144:	4501                	li	a0,0
 146:	1bc000ef          	jal	302 <read>
    if (cc < 1)
 14a:	00a05d63          	blez	a0,164 <gets+0x56>
      break;
    buf[i++] = c;
 14e:	faf44783          	lbu	a5,-81(s0)
 152:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 156:	0905                	addi	s2,s2,1
 158:	ff678713          	addi	a4,a5,-10
 15c:	c319                	beqz	a4,162 <gets+0x54>
 15e:	17cd                	addi	a5,a5,-13
 160:	fbf1                	bnez	a5,134 <gets+0x26>
    buf[i++] = c;
 162:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 164:	9c5e                	add	s8,s8,s7
 166:	000c0023          	sb	zero,0(s8)
  return buf;
}
 16a:	855e                	mv	a0,s7
 16c:	60e6                	ld	ra,88(sp)
 16e:	6446                	ld	s0,80(sp)
 170:	64a6                	ld	s1,72(sp)
 172:	6906                	ld	s2,64(sp)
 174:	79e2                	ld	s3,56(sp)
 176:	7a42                	ld	s4,48(sp)
 178:	7aa2                	ld	s5,40(sp)
 17a:	7b02                	ld	s6,32(sp)
 17c:	6be2                	ld	s7,24(sp)
 17e:	6c42                	ld	s8,16(sp)
 180:	6125                	addi	sp,sp,96
 182:	8082                	ret

0000000000000184 <stat>:

int
stat(const char *n, struct stat *st)
{
 184:	1101                	addi	sp,sp,-32
 186:	ec06                	sd	ra,24(sp)
 188:	e822                	sd	s0,16(sp)
 18a:	e04a                	sd	s2,0(sp)
 18c:	1000                	addi	s0,sp,32
 18e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 190:	4581                	li	a1,0
 192:	198000ef          	jal	32a <open>
  if (fd < 0)
 196:	02054263          	bltz	a0,1ba <stat+0x36>
 19a:	e426                	sd	s1,8(sp)
 19c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 19e:	85ca                	mv	a1,s2
 1a0:	1a2000ef          	jal	342 <fstat>
 1a4:	892a                	mv	s2,a0
  close(fd);
 1a6:	8526                	mv	a0,s1
 1a8:	16a000ef          	jal	312 <close>
  return r;
 1ac:	64a2                	ld	s1,8(sp)
}
 1ae:	854a                	mv	a0,s2
 1b0:	60e2                	ld	ra,24(sp)
 1b2:	6442                	ld	s0,16(sp)
 1b4:	6902                	ld	s2,0(sp)
 1b6:	6105                	addi	sp,sp,32
 1b8:	8082                	ret
    return -1;
 1ba:	57fd                	li	a5,-1
 1bc:	893e                	mv	s2,a5
 1be:	bfc5                	j	1ae <stat+0x2a>

00000000000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e406                	sd	ra,8(sp)
 1c4:	e022                	sd	s0,0(sp)
 1c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1c8:	00054683          	lbu	a3,0(a0)
 1cc:	fd06879b          	addiw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	4625                	li	a2,9
 1d6:	02f66963          	bltu	a2,a5,208 <atoi+0x48>
 1da:	872a                	mv	a4,a0
  n = 0;
 1dc:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1de:	0705                	addi	a4,a4,1
 1e0:	0025179b          	slliw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	slliw	a5,a5,0x1
 1ea:	9fb5                	addw	a5,a5,a3
 1ec:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1f0:	00074683          	lbu	a3,0(a4)
 1f4:	fd06879b          	addiw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	fef671e3          	bgeu	a2,a5,1de <atoi+0x1e>
  return n;
}
 200:	60a2                	ld	ra,8(sp)
 202:	6402                	ld	s0,0(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
  n = 0;
 208:	4501                	li	a0,0
 20a:	bfdd                	j	200 <atoi+0x40>

000000000000020c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 214:	02b57563          	bgeu	a0,a1,23e <memmove+0x32>
    while (n-- > 0)
 218:	00c05f63          	blez	a2,236 <memmove+0x2a>
 21c:	1602                	slli	a2,a2,0x20
 21e:	9201                	srli	a2,a2,0x20
 220:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 224:	872a                	mv	a4,a0
      *dst++ = *src++;
 226:	0585                	addi	a1,a1,1
 228:	0705                	addi	a4,a4,1
 22a:	fff5c683          	lbu	a3,-1(a1)
 22e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 232:	fee79ae3          	bne	a5,a4,226 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 236:	60a2                	ld	ra,8(sp)
 238:	6402                	ld	s0,0(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    while (n-- > 0)
 23e:	fec05ce3          	blez	a2,236 <memmove+0x2a>
    dst += n;
 242:	00c50733          	add	a4,a0,a2
    src += n;
 246:	95b2                	add	a1,a1,a2
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 262:	fef71ae3          	bne	a4,a5,256 <memmove+0x4a>
 266:	bfc1                	j	236 <memmove+0x2a>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 270:	c61d                	beqz	a2,29e <memcmp+0x36>
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 27a:	00054783          	lbu	a5,0(a0)
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00e79863          	bne	a5,a4,292 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 286:	0505                	addi	a0,a0,1
    p2++;
 288:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28a:	fed518e3          	bne	a0,a3,27a <memcmp+0x12>
  }
  return 0;
 28e:	4501                	li	a0,0
 290:	a019                	j	296 <memcmp+0x2e>
      return *p1 - *p2;
 292:	40e7853b          	subw	a0,a5,a4
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfdd                	j	296 <memcmp+0x2e>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	f63ff0ef          	jal	20c <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <sbrk>:

char *
sbrk(int n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2be:	4585                	li	a1,1
 2c0:	0b2000ef          	jal	372 <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <sbrklazy>:

char *
sbrklazy(int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d4:	4589                	li	a1,2
 2d6:	09c000ef          	jal	372 <sys_sbrk>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e2:	4885                	li	a7,1
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ea:	4889                	li	a7,2
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f2:	488d                	li	a7,3
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2fa:	4891                	li	a7,4
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <read>:
.global read
read:
 li a7, SYS_read
 302:	4895                	li	a7,5
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <write>:
.global write
write:
 li a7, SYS_write
 30a:	48c1                	li	a7,16
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <close>:
.global close
close:
 li a7, SYS_close
 312:	48d5                	li	a7,21
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <kill>:
.global kill
kill:
 li a7, SYS_kill
 31a:	4899                	li	a7,6
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exec>:
.global exec
exec:
 li a7, SYS_exec
 322:	489d                	li	a7,7
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <open>:
.global open
open:
 li a7, SYS_open
 32a:	48bd                	li	a7,15
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 332:	48c5                	li	a7,17
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 33a:	48c9                	li	a7,18
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 342:	48a1                	li	a7,8
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <link>:
.global link
link:
 li a7, SYS_link
 34a:	48cd                	li	a7,19
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 352:	48d1                	li	a7,20
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 35a:	48a5                	li	a7,9
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <dup>:
.global dup
dup:
 li a7, SYS_dup
 362:	48a9                	li	a7,10
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 36a:	48ad                	li	a7,11
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 372:	48b1                	li	a7,12
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <pause>:
.global pause
pause:
 li a7, SYS_pause
 37a:	48b5                	li	a7,13
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 382:	48b9                	li	a7,14
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 38a:	48d9                	li	a7,22
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <getprocinfo>:
.global getprocinfo
getprocinfo:
 li a7, SYS_getprocinfo
 392:	48dd                	li	a7,23
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39a:	1101                	addi	sp,sp,-32
 39c:	ec06                	sd	ra,24(sp)
 39e:	e822                	sd	s0,16(sp)
 3a0:	1000                	addi	s0,sp,32
 3a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	fef40593          	addi	a1,s0,-17
 3ac:	f5fff0ef          	jal	30a <write>
}
 3b0:	60e2                	ld	ra,24(sp)
 3b2:	6442                	ld	s0,16(sp)
 3b4:	6105                	addi	sp,sp,32
 3b6:	8082                	ret

00000000000003b8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3b8:	715d                	addi	sp,sp,-80
 3ba:	e486                	sd	ra,72(sp)
 3bc:	e0a2                	sd	s0,64(sp)
 3be:	f84a                	sd	s2,48(sp)
 3c0:	f44e                	sd	s3,40(sp)
 3c2:	0880                	addi	s0,sp,80
 3c4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3c6:	c6d1                	beqz	a3,452 <printint+0x9a>
 3c8:	0805d563          	bgez	a1,452 <printint+0x9a>
    neg = 1;
    x = -xx;
 3cc:	40b005b3          	neg	a1,a1
    neg = 1;
 3d0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3d2:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3d6:	86ce                	mv	a3,s3
  i = 0;
 3d8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3da:	00000817          	auipc	a6,0x0
 3de:	53680813          	addi	a6,a6,1334 # 910 <digits>
 3e2:	88ba                	mv	a7,a4
 3e4:	0017051b          	addiw	a0,a4,1
 3e8:	872a                	mv	a4,a0
 3ea:	02c5f7b3          	remu	a5,a1,a2
 3ee:	97c2                	add	a5,a5,a6
 3f0:	0007c783          	lbu	a5,0(a5)
 3f4:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3f8:	87ae                	mv	a5,a1
 3fa:	02c5d5b3          	divu	a1,a1,a2
 3fe:	0685                	addi	a3,a3,1
 400:	fec7f1e3          	bgeu	a5,a2,3e2 <printint+0x2a>
  if (neg)
 404:	00030c63          	beqz	t1,41c <printint+0x64>
    buf[i++] = '-';
 408:	fd050793          	addi	a5,a0,-48
 40c:	00878533          	add	a0,a5,s0
 410:	02d00793          	li	a5,45
 414:	fef50423          	sb	a5,-24(a0)
 418:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 41c:	02e05563          	blez	a4,446 <printint+0x8e>
 420:	fc26                	sd	s1,56(sp)
 422:	377d                	addiw	a4,a4,-1
 424:	00e984b3          	add	s1,s3,a4
 428:	19fd                	addi	s3,s3,-1
 42a:	99ba                	add	s3,s3,a4
 42c:	1702                	slli	a4,a4,0x20
 42e:	9301                	srli	a4,a4,0x20
 430:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 434:	0004c583          	lbu	a1,0(s1)
 438:	854a                	mv	a0,s2
 43a:	f61ff0ef          	jal	39a <putc>
  while (--i >= 0)
 43e:	14fd                	addi	s1,s1,-1
 440:	ff349ae3          	bne	s1,s3,434 <printint+0x7c>
 444:	74e2                	ld	s1,56(sp)
}
 446:	60a6                	ld	ra,72(sp)
 448:	6406                	ld	s0,64(sp)
 44a:	7942                	ld	s2,48(sp)
 44c:	79a2                	ld	s3,40(sp)
 44e:	6161                	addi	sp,sp,80
 450:	8082                	ret
  neg = 0;
 452:	4301                	li	t1,0
 454:	bfbd                	j	3d2 <printint+0x1a>

0000000000000456 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 456:	711d                	addi	sp,sp,-96
 458:	ec86                	sd	ra,88(sp)
 45a:	e8a2                	sd	s0,80(sp)
 45c:	e4a6                	sd	s1,72(sp)
 45e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 460:	0005c483          	lbu	s1,0(a1)
 464:	22048363          	beqz	s1,68a <vprintf+0x234>
 468:	e0ca                	sd	s2,64(sp)
 46a:	fc4e                	sd	s3,56(sp)
 46c:	f852                	sd	s4,48(sp)
 46e:	f456                	sd	s5,40(sp)
 470:	f05a                	sd	s6,32(sp)
 472:	ec5e                	sd	s7,24(sp)
 474:	e862                	sd	s8,16(sp)
 476:	8b2a                	mv	s6,a0
 478:	8a2e                	mv	s4,a1
 47a:	8bb2                	mv	s7,a2
  state = 0;
 47c:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 47e:	4901                	li	s2,0
 480:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 482:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 486:	06400c13          	li	s8,100
 48a:	a00d                	j	4ac <vprintf+0x56>
        putc(fd, c0);
 48c:	85a6                	mv	a1,s1
 48e:	855a                	mv	a0,s6
 490:	f0bff0ef          	jal	39a <putc>
 494:	a019                	j	49a <vprintf+0x44>
    } else if (state == '%') {
 496:	03598363          	beq	s3,s5,4bc <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 49a:	0019079b          	addiw	a5,s2,1
 49e:	893e                	mv	s2,a5
 4a0:	873e                	mv	a4,a5
 4a2:	97d2                	add	a5,a5,s4
 4a4:	0007c483          	lbu	s1,0(a5)
 4a8:	1c048a63          	beqz	s1,67c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4ac:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4b0:	fe0993e3          	bnez	s3,496 <vprintf+0x40>
      if (c0 == '%') {
 4b4:	fd579ce3          	bne	a5,s5,48c <vprintf+0x36>
        state = '%';
 4b8:	89be                	mv	s3,a5
 4ba:	b7c5                	j	49a <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4bc:	00ea06b3          	add	a3,s4,a4
 4c0:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4c4:	1c060863          	beqz	a2,694 <vprintf+0x23e>
      if (c0 == 'd') {
 4c8:	03878763          	beq	a5,s8,4f6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4cc:	f9478693          	addi	a3,a5,-108
 4d0:	0016b693          	seqz	a3,a3
 4d4:	f9c60593          	addi	a1,a2,-100
 4d8:	e99d                	bnez	a1,50e <vprintf+0xb8>
 4da:	ca95                	beqz	a3,50e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4dc:	008b8493          	addi	s1,s7,8
 4e0:	4685                	li	a3,1
 4e2:	4629                	li	a2,10
 4e4:	000bb583          	ld	a1,0(s7)
 4e8:	855a                	mv	a0,s6
 4ea:	ecfff0ef          	jal	3b8 <printint>
        i += 1;
 4ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4f2:	4981                	li	s3,0
 4f4:	b75d                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4f6:	008b8493          	addi	s1,s7,8
 4fa:	4685                	li	a3,1
 4fc:	4629                	li	a2,10
 4fe:	000ba583          	lw	a1,0(s7)
 502:	855a                	mv	a0,s6
 504:	eb5ff0ef          	jal	3b8 <printint>
 508:	8ba6                	mv	s7,s1
      state = 0;
 50a:	4981                	li	s3,0
 50c:	b779                	j	49a <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 50e:	9752                	add	a4,a4,s4
 510:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 514:	f9460713          	addi	a4,a2,-108
 518:	00173713          	seqz	a4,a4
 51c:	8f75                	and	a4,a4,a3
 51e:	f9c58513          	addi	a0,a1,-100
 522:	18051363          	bnez	a0,6a8 <vprintf+0x252>
 526:	18070163          	beqz	a4,6a8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 52a:	008b8493          	addi	s1,s7,8
 52e:	4685                	li	a3,1
 530:	4629                	li	a2,10
 532:	000bb583          	ld	a1,0(s7)
 536:	855a                	mv	a0,s6
 538:	e81ff0ef          	jal	3b8 <printint>
        i += 2;
 53c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	8ba6                	mv	s7,s1
      state = 0;
 540:	4981                	li	s3,0
        i += 2;
 542:	bfa1                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 544:	008b8493          	addi	s1,s7,8
 548:	4681                	li	a3,0
 54a:	4629                	li	a2,10
 54c:	000be583          	lwu	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e67ff0ef          	jal	3b8 <printint>
 556:	8ba6                	mv	s7,s1
      state = 0;
 558:	4981                	li	s3,0
 55a:	b781                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 55c:	008b8493          	addi	s1,s7,8
 560:	4681                	li	a3,0
 562:	4629                	li	a2,10
 564:	000bb583          	ld	a1,0(s7)
 568:	855a                	mv	a0,s6
 56a:	e4fff0ef          	jal	3b8 <printint>
        i += 1;
 56e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 570:	8ba6                	mv	s7,s1
      state = 0;
 572:	4981                	li	s3,0
 574:	b71d                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	008b8493          	addi	s1,s7,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000bb583          	ld	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	e35ff0ef          	jal	3b8 <printint>
        i += 2;
 588:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	8ba6                	mv	s7,s1
      state = 0;
 58c:	4981                	li	s3,0
        i += 2;
 58e:	b731                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 590:	008b8493          	addi	s1,s7,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000be583          	lwu	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e1bff0ef          	jal	3b8 <printint>
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	bdd5                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4641                	li	a2,16
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e03ff0ef          	jal	3b8 <printint>
        i += 1;
 5ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bde9                	j	49a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4641                	li	a2,16
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	de9ff0ef          	jal	3b8 <printint>
        i += 2;
 5d4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	b5c1                	j	49a <vprintf+0x44>
 5dc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5de:	008b8793          	addi	a5,s7,8
 5e2:	8cbe                	mv	s9,a5
 5e4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e8:	03000593          	li	a1,48
 5ec:	855a                	mv	a0,s6
 5ee:	dadff0ef          	jal	39a <putc>
  putc(fd, 'x');
 5f2:	07800593          	li	a1,120
 5f6:	855a                	mv	a0,s6
 5f8:	da3ff0ef          	jal	39a <putc>
 5fc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fe:	00000b97          	auipc	s7,0x0
 602:	312b8b93          	addi	s7,s7,786 # 910 <digits>
 606:	03c9d793          	srli	a5,s3,0x3c
 60a:	97de                	add	a5,a5,s7
 60c:	0007c583          	lbu	a1,0(a5)
 610:	855a                	mv	a0,s6
 612:	d89ff0ef          	jal	39a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 616:	0992                	slli	s3,s3,0x4
 618:	34fd                	addiw	s1,s1,-1
 61a:	f4f5                	bnez	s1,606 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 61c:	8be6                	mv	s7,s9
      state = 0;
 61e:	4981                	li	s3,0
 620:	6ca2                	ld	s9,8(sp)
 622:	bda5                	j	49a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 624:	008b8493          	addi	s1,s7,8
 628:	000bc583          	lbu	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	d6dff0ef          	jal	39a <putc>
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	b595                	j	49a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 638:	008b8993          	addi	s3,s7,8
 63c:	000bb483          	ld	s1,0(s7)
 640:	cc91                	beqz	s1,65c <vprintf+0x206>
        for (; *s; s++)
 642:	0004c583          	lbu	a1,0(s1)
 646:	c985                	beqz	a1,676 <vprintf+0x220>
          putc(fd, *s);
 648:	855a                	mv	a0,s6
 64a:	d51ff0ef          	jal	39a <putc>
        for (; *s; s++)
 64e:	0485                	addi	s1,s1,1
 650:	0004c583          	lbu	a1,0(s1)
 654:	f9f5                	bnez	a1,648 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 656:	8bce                	mv	s7,s3
      state = 0;
 658:	4981                	li	s3,0
 65a:	b581                	j	49a <vprintf+0x44>
          s = "(null)";
 65c:	00000497          	auipc	s1,0x0
 660:	2ac48493          	addi	s1,s1,684 # 908 <malloc+0x110>
        for (; *s; s++)
 664:	02800593          	li	a1,40
 668:	b7c5                	j	648 <vprintf+0x1f2>
        putc(fd, '%');
 66a:	85be                	mv	a1,a5
 66c:	855a                	mv	a0,s6
 66e:	d2dff0ef          	jal	39a <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	b51d                	j	49a <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 676:	8bce                	mv	s7,s3
      state = 0;
 678:	4981                	li	s3,0
 67a:	b505                	j	49a <vprintf+0x44>
 67c:	6906                	ld	s2,64(sp)
 67e:	79e2                	ld	s3,56(sp)
 680:	7a42                	ld	s4,48(sp)
 682:	7aa2                	ld	s5,40(sp)
 684:	7b02                	ld	s6,32(sp)
 686:	6be2                	ld	s7,24(sp)
 688:	6c42                	ld	s8,16(sp)
    }
  }
}
 68a:	60e6                	ld	ra,88(sp)
 68c:	6446                	ld	s0,80(sp)
 68e:	64a6                	ld	s1,72(sp)
 690:	6125                	addi	sp,sp,96
 692:	8082                	ret
      if (c0 == 'd') {
 694:	06400713          	li	a4,100
 698:	e4e78fe3          	beq	a5,a4,4f6 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 69c:	f9478693          	addi	a3,a5,-108
 6a0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6a4:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6a6:	4701                	li	a4,0
      } else if (c0 == 'u') {
 6a8:	07500513          	li	a0,117
 6ac:	e8a78ce3          	beq	a5,a0,544 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 6b0:	f8b60513          	addi	a0,a2,-117
 6b4:	e119                	bnez	a0,6ba <vprintf+0x264>
 6b6:	ea0693e3          	bnez	a3,55c <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6ba:	f8b58513          	addi	a0,a1,-117
 6be:	e119                	bnez	a0,6c4 <vprintf+0x26e>
 6c0:	ea071be3          	bnez	a4,576 <vprintf+0x120>
      } else if (c0 == 'x') {
 6c4:	07800513          	li	a0,120
 6c8:	eca784e3          	beq	a5,a0,590 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 6cc:	f8860613          	addi	a2,a2,-120
 6d0:	e219                	bnez	a2,6d6 <vprintf+0x280>
 6d2:	ec069be3          	bnez	a3,5a8 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6d6:	f8858593          	addi	a1,a1,-120
 6da:	e199                	bnez	a1,6e0 <vprintf+0x28a>
 6dc:	ee0713e3          	bnez	a4,5c2 <vprintf+0x16c>
      } else if (c0 == 'p') {
 6e0:	07000713          	li	a4,112
 6e4:	eee78ce3          	beq	a5,a4,5dc <vprintf+0x186>
      } else if (c0 == 'c') {
 6e8:	06300713          	li	a4,99
 6ec:	f2e78ce3          	beq	a5,a4,624 <vprintf+0x1ce>
      } else if (c0 == 's') {
 6f0:	07300713          	li	a4,115
 6f4:	f4e782e3          	beq	a5,a4,638 <vprintf+0x1e2>
      } else if (c0 == '%') {
 6f8:	02500713          	li	a4,37
 6fc:	f6e787e3          	beq	a5,a4,66a <vprintf+0x214>
        putc(fd, '%');
 700:	02500593          	li	a1,37
 704:	855a                	mv	a0,s6
 706:	c95ff0ef          	jal	39a <putc>
        putc(fd, c0);
 70a:	85a6                	mv	a1,s1
 70c:	855a                	mv	a0,s6
 70e:	c8dff0ef          	jal	39a <putc>
      state = 0;
 712:	4981                	li	s3,0
 714:	b359                	j	49a <vprintf+0x44>

0000000000000716 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 716:	715d                	addi	sp,sp,-80
 718:	ec06                	sd	ra,24(sp)
 71a:	e822                	sd	s0,16(sp)
 71c:	1000                	addi	s0,sp,32
 71e:	e010                	sd	a2,0(s0)
 720:	e414                	sd	a3,8(s0)
 722:	e818                	sd	a4,16(s0)
 724:	ec1c                	sd	a5,24(s0)
 726:	03043023          	sd	a6,32(s0)
 72a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72e:	8622                	mv	a2,s0
 730:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 734:	d23ff0ef          	jal	456 <vprintf>
}
 738:	60e2                	ld	ra,24(sp)
 73a:	6442                	ld	s0,16(sp)
 73c:	6161                	addi	sp,sp,80
 73e:	8082                	ret

0000000000000740 <printf>:

void
printf(const char *fmt, ...)
{
 740:	711d                	addi	sp,sp,-96
 742:	ec06                	sd	ra,24(sp)
 744:	e822                	sd	s0,16(sp)
 746:	1000                	addi	s0,sp,32
 748:	e40c                	sd	a1,8(s0)
 74a:	e810                	sd	a2,16(s0)
 74c:	ec14                	sd	a3,24(s0)
 74e:	f018                	sd	a4,32(s0)
 750:	f41c                	sd	a5,40(s0)
 752:	03043823          	sd	a6,48(s0)
 756:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75a:	00840613          	addi	a2,s0,8
 75e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 762:	85aa                	mv	a1,a0
 764:	4505                	li	a0,1
 766:	cf1ff0ef          	jal	456 <vprintf>
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6125                	addi	sp,sp,96
 770:	8082                	ret

0000000000000772 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 772:	1141                	addi	sp,sp,-16
 774:	e406                	sd	ra,8(sp)
 776:	e022                	sd	s0,0(sp)
 778:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 77a:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	00001797          	auipc	a5,0x1
 782:	8827b783          	ld	a5,-1918(a5) # 1000 <freep>
 786:	a039                	j	794 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	6398                	ld	a4,0(a5)
 78a:	00e7e463          	bltu	a5,a4,792 <free+0x20>
 78e:	00e6ea63          	bltu	a3,a4,7a2 <free+0x30>
{
 792:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	fed7fae3          	bgeu	a5,a3,788 <free+0x16>
 798:	6398                	ld	a4,0(a5)
 79a:	00e6e463          	bltu	a3,a4,7a2 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	fee7eae3          	bltu	a5,a4,792 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7a2:	ff852583          	lw	a1,-8(a0)
 7a6:	6390                	ld	a2,0(a5)
 7a8:	02059813          	slli	a6,a1,0x20
 7ac:	01c85713          	srli	a4,a6,0x1c
 7b0:	9736                	add	a4,a4,a3
 7b2:	02e60563          	beq	a2,a4,7dc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7ba:	4790                	lw	a2,8(a5)
 7bc:	02061593          	slli	a1,a2,0x20
 7c0:	01c5d713          	srli	a4,a1,0x1c
 7c4:	973e                	add	a4,a4,a5
 7c6:	02e68263          	beq	a3,a4,7ea <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82f73a23          	sd	a5,-1996(a4) # 1000 <freep>
}
 7d4:	60a2                	ld	ra,8(sp)
 7d6:	6402                	ld	s0,0(sp)
 7d8:	0141                	addi	sp,sp,16
 7da:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7dc:	4618                	lw	a4,8(a2)
 7de:	9f2d                	addw	a4,a4,a1
 7e0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	6398                	ld	a4,0(a5)
 7e6:	6310                	ld	a2,0(a4)
 7e8:	b7f9                	j	7b6 <free+0x44>
    p->s.size += bp->s.size;
 7ea:	ff852703          	lw	a4,-8(a0)
 7ee:	9f31                	addw	a4,a4,a2
 7f0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f2:	ff053683          	ld	a3,-16(a0)
 7f6:	bfd1                	j	7ca <free+0x58>

00000000000007f8 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7f8:	7139                	addi	sp,sp,-64
 7fa:	fc06                	sd	ra,56(sp)
 7fc:	f822                	sd	s0,48(sp)
 7fe:	f04a                	sd	s2,32(sp)
 800:	ec4e                	sd	s3,24(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 804:	02051993          	slli	s3,a0,0x20
 808:	0209d993          	srli	s3,s3,0x20
 80c:	09bd                	addi	s3,s3,15
 80e:	0049d993          	srli	s3,s3,0x4
 812:	2985                	addiw	s3,s3,1
 814:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 816:	00000517          	auipc	a0,0x0
 81a:	7ea53503          	ld	a0,2026(a0) # 1000 <freep>
 81e:	c905                	beqz	a0,84e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 820:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 822:	4798                	lw	a4,8(a5)
 824:	09377663          	bgeu	a4,s3,8b0 <malloc+0xb8>
 828:	f426                	sd	s1,40(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 830:	8a4e                	mv	s4,s3
 832:	6705                	lui	a4,0x1
 834:	00e9f363          	bgeu	s3,a4,83a <malloc+0x42>
 838:	6a05                	lui	s4,0x1
 83a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 842:	00000497          	auipc	s1,0x0
 846:	7be48493          	addi	s1,s1,1982 # 1000 <freep>
  if (p == SBRK_ERROR)
 84a:	5afd                	li	s5,-1
 84c:	a83d                	j	88a <malloc+0x92>
 84e:	f426                	sd	s1,40(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 856:	00000797          	auipc	a5,0x0
 85a:	7ba78793          	addi	a5,a5,1978 # 1010 <base>
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
 866:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 868:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 86c:	b7d1                	j	830 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	e118                	sd	a4,0(a0)
 872:	a899                	j	8c8 <malloc+0xd0>
  hp->s.size = nu;
 874:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 878:	0541                	addi	a0,a0,16
 87a:	ef9ff0ef          	jal	772 <free>
  return freep;
 87e:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 880:	c125                	beqz	a0,8e0 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 882:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 884:	4798                	lw	a4,8(a5)
 886:	03277163          	bgeu	a4,s2,8a8 <malloc+0xb0>
    if (p == freep)
 88a:	6098                	ld	a4,0(s1)
 88c:	853e                	mv	a0,a5
 88e:	fef71ae3          	bne	a4,a5,882 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 892:	8552                	mv	a0,s4
 894:	a23ff0ef          	jal	2b6 <sbrk>
  if (p == SBRK_ERROR)
 898:	fd551ee3          	bne	a0,s5,874 <malloc+0x7c>
        return 0;
 89c:	4501                	li	a0,0
 89e:	74a2                	ld	s1,40(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	a03d                	j	8d4 <malloc+0xdc>
 8a8:	74a2                	ld	s1,40(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8b0:	fae90fe3          	beq	s2,a4,86e <malloc+0x76>
        p->s.size -= nunits;
 8b4:	4137073b          	subw	a4,a4,s3
 8b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ba:	02071693          	slli	a3,a4,0x20
 8be:	01c6d713          	srli	a4,a3,0x1c
 8c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c8:	00000717          	auipc	a4,0x0
 8cc:	72a73c23          	sd	a0,1848(a4) # 1000 <freep>
      return (void *)(p + 1);
 8d0:	01078513          	addi	a0,a5,16
  }
}
 8d4:	70e2                	ld	ra,56(sp)
 8d6:	7442                	ld	s0,48(sp)
 8d8:	7902                	ld	s2,32(sp)
 8da:	69e2                	ld	s3,24(sp)
 8dc:	6121                	addi	sp,sp,64
 8de:	8082                	ret
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	b7f5                	j	8d4 <malloc+0xdc>
