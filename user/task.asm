
user/_task:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main() {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("Task starting (Quick task)...\n");
   8:	00001517          	auipc	a0,0x1
   c:	8d850513          	addi	a0,a0,-1832 # 8e0 <malloc+0xf6>
  10:	722000ef          	jal	732 <printf>
    printf("Task finished!\n");
  14:	00001517          	auipc	a0,0x1
  18:	8ec50513          	addi	a0,a0,-1812 # 900 <malloc+0x116>
  1c:	716000ef          	jal	732 <printf>
    exit(0);
  20:	4501                	li	a0,0
  22:	2ba000ef          	jal	2dc <exit>

0000000000000026 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  2e:	fd3ff0ef          	jal	0 <main>
  exit(r);
  32:	2aa000ef          	jal	2dc <exit>

0000000000000036 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  36:	1141                	addi	sp,sp,-16
  38:	e406                	sd	ra,8(sp)
  3a:	e022                	sd	s0,0(sp)
  3c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  3e:	87aa                	mv	a5,a0
  40:	0585                	addi	a1,a1,1
  42:	0785                	addi	a5,a5,1
  44:	fff5c703          	lbu	a4,-1(a1)
  48:	fee78fa3          	sb	a4,-1(a5)
  4c:	fb75                	bnez	a4,40 <strcpy+0xa>
    ;
  return os;
}
  4e:	60a2                	ld	ra,8(sp)
  50:	6402                	ld	s0,0(sp)
  52:	0141                	addi	sp,sp,16
  54:	8082                	ret

0000000000000056 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  56:	1141                	addi	sp,sp,-16
  58:	e406                	sd	ra,8(sp)
  5a:	e022                	sd	s0,0(sp)
  5c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	cb91                	beqz	a5,76 <strcmp+0x20>
  64:	0005c703          	lbu	a4,0(a1)
  68:	00f71763          	bne	a4,a5,76 <strcmp+0x20>
    p++, q++;
  6c:	0505                	addi	a0,a0,1
  6e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  70:	00054783          	lbu	a5,0(a0)
  74:	fbe5                	bnez	a5,64 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  76:	0005c503          	lbu	a0,0(a1)
}
  7a:	40a7853b          	subw	a0,a5,a0
  7e:	60a2                	ld	ra,8(sp)
  80:	6402                	ld	s0,0(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret

0000000000000086 <strlen>:

uint
strlen(const char *s)
{
  86:	1141                	addi	sp,sp,-16
  88:	e406                	sd	ra,8(sp)
  8a:	e022                	sd	s0,0(sp)
  8c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cf91                	beqz	a5,ae <strlen+0x28>
  94:	00150793          	addi	a5,a0,1
  98:	86be                	mv	a3,a5
  9a:	0785                	addi	a5,a5,1
  9c:	fff7c703          	lbu	a4,-1(a5)
  a0:	ff65                	bnez	a4,98 <strlen+0x12>
  a2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret
  for (n = 0; s[n]; n++)
  ae:	4501                	li	a0,0
  b0:	bfdd                	j	a6 <strlen+0x20>

00000000000000b2 <memset>:

void *
memset(void *dst, int c, uint n)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e406                	sd	ra,8(sp)
  b6:	e022                	sd	s0,0(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  ba:	ca19                	beqz	a2,d0 <memset+0x1e>
  bc:	87aa                	mv	a5,a0
  be:	1602                	slli	a2,a2,0x20
  c0:	9201                	srli	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  ca:	0785                	addi	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x14>
  }
  return dst;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char *
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  for (; *s; s++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf81                	beqz	a5,fc <strchr+0x24>
    if (*s == c)
  e6:	00f58763          	beq	a1,a5,f4 <strchr+0x1c>
  for (; *s; s++)
  ea:	0505                	addi	a0,a0,1
  ec:	00054783          	lbu	a5,0(a0)
  f0:	fbfd                	bnez	a5,e6 <strchr+0xe>
      return (char *)s;
  return 0;
  f2:	4501                	li	a0,0
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  return 0;
  fc:	4501                	li	a0,0
  fe:	bfdd                	j	f4 <strchr+0x1c>

0000000000000100 <gets>:

char *
gets(char *buf, int max)
{
 100:	711d                	addi	sp,sp,-96
 102:	ec86                	sd	ra,88(sp)
 104:	e8a2                	sd	s0,80(sp)
 106:	e4a6                	sd	s1,72(sp)
 108:	e0ca                	sd	s2,64(sp)
 10a:	fc4e                	sd	s3,56(sp)
 10c:	f852                	sd	s4,48(sp)
 10e:	f456                	sd	s5,40(sp)
 110:	f05a                	sd	s6,32(sp)
 112:	ec5e                	sd	s7,24(sp)
 114:	e862                	sd	s8,16(sp)
 116:	1080                	addi	s0,sp,96
 118:	8baa                	mv	s7,a0
 11a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 11c:	892a                	mv	s2,a0
 11e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 120:	faf40b13          	addi	s6,s0,-81
 124:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 126:	8c26                	mv	s8,s1
 128:	0014899b          	addiw	s3,s1,1
 12c:	84ce                	mv	s1,s3
 12e:	0349d463          	bge	s3,s4,156 <gets+0x56>
    cc = read(0, &c, 1);
 132:	8656                	mv	a2,s5
 134:	85da                	mv	a1,s6
 136:	4501                	li	a0,0
 138:	1bc000ef          	jal	2f4 <read>
    if (cc < 1)
 13c:	00a05d63          	blez	a0,156 <gets+0x56>
      break;
    buf[i++] = c;
 140:	faf44783          	lbu	a5,-81(s0)
 144:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 148:	0905                	addi	s2,s2,1
 14a:	ff678713          	addi	a4,a5,-10
 14e:	c319                	beqz	a4,154 <gets+0x54>
 150:	17cd                	addi	a5,a5,-13
 152:	fbf1                	bnez	a5,126 <gets+0x26>
    buf[i++] = c;
 154:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 156:	9c5e                	add	s8,s8,s7
 158:	000c0023          	sb	zero,0(s8)
  return buf;
}
 15c:	855e                	mv	a0,s7
 15e:	60e6                	ld	ra,88(sp)
 160:	6446                	ld	s0,80(sp)
 162:	64a6                	ld	s1,72(sp)
 164:	6906                	ld	s2,64(sp)
 166:	79e2                	ld	s3,56(sp)
 168:	7a42                	ld	s4,48(sp)
 16a:	7aa2                	ld	s5,40(sp)
 16c:	7b02                	ld	s6,32(sp)
 16e:	6be2                	ld	s7,24(sp)
 170:	6c42                	ld	s8,16(sp)
 172:	6125                	addi	sp,sp,96
 174:	8082                	ret

0000000000000176 <stat>:

int
stat(const char *n, struct stat *st)
{
 176:	1101                	addi	sp,sp,-32
 178:	ec06                	sd	ra,24(sp)
 17a:	e822                	sd	s0,16(sp)
 17c:	e04a                	sd	s2,0(sp)
 17e:	1000                	addi	s0,sp,32
 180:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 182:	4581                	li	a1,0
 184:	198000ef          	jal	31c <open>
  if (fd < 0)
 188:	02054263          	bltz	a0,1ac <stat+0x36>
 18c:	e426                	sd	s1,8(sp)
 18e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 190:	85ca                	mv	a1,s2
 192:	1a2000ef          	jal	334 <fstat>
 196:	892a                	mv	s2,a0
  close(fd);
 198:	8526                	mv	a0,s1
 19a:	16a000ef          	jal	304 <close>
  return r;
 19e:	64a2                	ld	s1,8(sp)
}
 1a0:	854a                	mv	a0,s2
 1a2:	60e2                	ld	ra,24(sp)
 1a4:	6442                	ld	s0,16(sp)
 1a6:	6902                	ld	s2,0(sp)
 1a8:	6105                	addi	sp,sp,32
 1aa:	8082                	ret
    return -1;
 1ac:	57fd                	li	a5,-1
 1ae:	893e                	mv	s2,a5
 1b0:	bfc5                	j	1a0 <stat+0x2a>

00000000000001b2 <atoi>:

int
atoi(const char *s)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e406                	sd	ra,8(sp)
 1b6:	e022                	sd	s0,0(sp)
 1b8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1ba:	00054683          	lbu	a3,0(a0)
 1be:	fd06879b          	addiw	a5,a3,-48
 1c2:	0ff7f793          	zext.b	a5,a5
 1c6:	4625                	li	a2,9
 1c8:	02f66963          	bltu	a2,a5,1fa <atoi+0x48>
 1cc:	872a                	mv	a4,a0
  n = 0;
 1ce:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1d0:	0705                	addi	a4,a4,1
 1d2:	0025179b          	slliw	a5,a0,0x2
 1d6:	9fa9                	addw	a5,a5,a0
 1d8:	0017979b          	slliw	a5,a5,0x1
 1dc:	9fb5                	addw	a5,a5,a3
 1de:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1e2:	00074683          	lbu	a3,0(a4)
 1e6:	fd06879b          	addiw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	fef671e3          	bgeu	a2,a5,1d0 <atoi+0x1e>
  return n;
}
 1f2:	60a2                	ld	ra,8(sp)
 1f4:	6402                	ld	s0,0(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret
  n = 0;
 1fa:	4501                	li	a0,0
 1fc:	bfdd                	j	1f2 <atoi+0x40>

00000000000001fe <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e406                	sd	ra,8(sp)
 202:	e022                	sd	s0,0(sp)
 204:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 206:	02b57563          	bgeu	a0,a1,230 <memmove+0x32>
    while (n-- > 0)
 20a:	00c05f63          	blez	a2,228 <memmove+0x2a>
 20e:	1602                	slli	a2,a2,0x20
 210:	9201                	srli	a2,a2,0x20
 212:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 216:	872a                	mv	a4,a0
      *dst++ = *src++;
 218:	0585                	addi	a1,a1,1
 21a:	0705                	addi	a4,a4,1
 21c:	fff5c683          	lbu	a3,-1(a1)
 220:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 224:	fee79ae3          	bne	a5,a4,218 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 228:	60a2                	ld	ra,8(sp)
 22a:	6402                	ld	s0,0(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
    while (n-- > 0)
 230:	fec05ce3          	blez	a2,228 <memmove+0x2a>
    dst += n;
 234:	00c50733          	add	a4,a0,a2
    src += n;
 238:	95b2                	add	a1,a1,a2
 23a:	fff6079b          	addiw	a5,a2,-1
 23e:	1782                	slli	a5,a5,0x20
 240:	9381                	srli	a5,a5,0x20
 242:	fff7c793          	not	a5,a5
 246:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 248:	15fd                	addi	a1,a1,-1
 24a:	177d                	addi	a4,a4,-1
 24c:	0005c683          	lbu	a3,0(a1)
 250:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 254:	fef71ae3          	bne	a4,a5,248 <memmove+0x4a>
 258:	bfc1                	j	228 <memmove+0x2a>

000000000000025a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 262:	c61d                	beqz	a2,290 <memcmp+0x36>
 264:	1602                	slli	a2,a2,0x20
 266:	9201                	srli	a2,a2,0x20
 268:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 26c:	00054783          	lbu	a5,0(a0)
 270:	0005c703          	lbu	a4,0(a1)
 274:	00e79863          	bne	a5,a4,284 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 278:	0505                	addi	a0,a0,1
    p2++;
 27a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27c:	fed518e3          	bne	a0,a3,26c <memcmp+0x12>
  }
  return 0;
 280:	4501                	li	a0,0
 282:	a019                	j	288 <memcmp+0x2e>
      return *p1 - *p2;
 284:	40e7853b          	subw	a0,a5,a4
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  return 0;
 290:	4501                	li	a0,0
 292:	bfdd                	j	288 <memcmp+0x2e>

0000000000000294 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 29c:	f63ff0ef          	jal	1fe <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <sbrk>:

char *
sbrk(int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2b0:	4585                	li	a1,1
 2b2:	0b2000ef          	jal	364 <sys_sbrk>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <sbrklazy>:

char *
sbrklazy(int n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2c6:	4589                	li	a1,2
 2c8:	09c000ef          	jal	364 <sys_sbrk>
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d4:	4885                	li	a7,1
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2dc:	4889                	li	a7,2
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e4:	488d                	li	a7,3
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ec:	4891                	li	a7,4
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <read>:
.global read
read:
 li a7, SYS_read
 2f4:	4895                	li	a7,5
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <write>:
.global write
write:
 li a7, SYS_write
 2fc:	48c1                	li	a7,16
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <close>:
.global close
close:
 li a7, SYS_close
 304:	48d5                	li	a7,21
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <kill>:
.global kill
kill:
 li a7, SYS_kill
 30c:	4899                	li	a7,6
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exec>:
.global exec
exec:
 li a7, SYS_exec
 314:	489d                	li	a7,7
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <open>:
.global open
open:
 li a7, SYS_open
 31c:	48bd                	li	a7,15
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 324:	48c5                	li	a7,17
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32c:	48c9                	li	a7,18
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 334:	48a1                	li	a7,8
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <link>:
.global link
link:
 li a7, SYS_link
 33c:	48cd                	li	a7,19
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 344:	48d1                	li	a7,20
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 34c:	48a5                	li	a7,9
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <dup>:
.global dup
dup:
 li a7, SYS_dup
 354:	48a9                	li	a7,10
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 35c:	48ad                	li	a7,11
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 364:	48b1                	li	a7,12
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <pause>:
.global pause
pause:
 li a7, SYS_pause
 36c:	48b5                	li	a7,13
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 374:	48b9                	li	a7,14
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 37c:	48d9                	li	a7,22
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getprocinfo>:
.global getprocinfo
getprocinfo:
 li a7, SYS_getprocinfo
 384:	48dd                	li	a7,23
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	1000                	addi	s0,sp,32
 394:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 398:	4605                	li	a2,1
 39a:	fef40593          	addi	a1,s0,-17
 39e:	f5fff0ef          	jal	2fc <write>
}
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	6105                	addi	sp,sp,32
 3a8:	8082                	ret

00000000000003aa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3aa:	715d                	addi	sp,sp,-80
 3ac:	e486                	sd	ra,72(sp)
 3ae:	e0a2                	sd	s0,64(sp)
 3b0:	f84a                	sd	s2,48(sp)
 3b2:	f44e                	sd	s3,40(sp)
 3b4:	0880                	addi	s0,sp,80
 3b6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3b8:	c6d1                	beqz	a3,444 <printint+0x9a>
 3ba:	0805d563          	bgez	a1,444 <printint+0x9a>
    neg = 1;
    x = -xx;
 3be:	40b005b3          	neg	a1,a1
    neg = 1;
 3c2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3c4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3c8:	86ce                	mv	a3,s3
  i = 0;
 3ca:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3cc:	00000817          	auipc	a6,0x0
 3d0:	54c80813          	addi	a6,a6,1356 # 918 <digits>
 3d4:	88ba                	mv	a7,a4
 3d6:	0017051b          	addiw	a0,a4,1
 3da:	872a                	mv	a4,a0
 3dc:	02c5f7b3          	remu	a5,a1,a2
 3e0:	97c2                	add	a5,a5,a6
 3e2:	0007c783          	lbu	a5,0(a5)
 3e6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3ea:	87ae                	mv	a5,a1
 3ec:	02c5d5b3          	divu	a1,a1,a2
 3f0:	0685                	addi	a3,a3,1
 3f2:	fec7f1e3          	bgeu	a5,a2,3d4 <printint+0x2a>
  if (neg)
 3f6:	00030c63          	beqz	t1,40e <printint+0x64>
    buf[i++] = '-';
 3fa:	fd050793          	addi	a5,a0,-48
 3fe:	00878533          	add	a0,a5,s0
 402:	02d00793          	li	a5,45
 406:	fef50423          	sb	a5,-24(a0)
 40a:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 40e:	02e05563          	blez	a4,438 <printint+0x8e>
 412:	fc26                	sd	s1,56(sp)
 414:	377d                	addiw	a4,a4,-1
 416:	00e984b3          	add	s1,s3,a4
 41a:	19fd                	addi	s3,s3,-1
 41c:	99ba                	add	s3,s3,a4
 41e:	1702                	slli	a4,a4,0x20
 420:	9301                	srli	a4,a4,0x20
 422:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 426:	0004c583          	lbu	a1,0(s1)
 42a:	854a                	mv	a0,s2
 42c:	f61ff0ef          	jal	38c <putc>
  while (--i >= 0)
 430:	14fd                	addi	s1,s1,-1
 432:	ff349ae3          	bne	s1,s3,426 <printint+0x7c>
 436:	74e2                	ld	s1,56(sp)
}
 438:	60a6                	ld	ra,72(sp)
 43a:	6406                	ld	s0,64(sp)
 43c:	7942                	ld	s2,48(sp)
 43e:	79a2                	ld	s3,40(sp)
 440:	6161                	addi	sp,sp,80
 442:	8082                	ret
  neg = 0;
 444:	4301                	li	t1,0
 446:	bfbd                	j	3c4 <printint+0x1a>

0000000000000448 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 448:	711d                	addi	sp,sp,-96
 44a:	ec86                	sd	ra,88(sp)
 44c:	e8a2                	sd	s0,80(sp)
 44e:	e4a6                	sd	s1,72(sp)
 450:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 452:	0005c483          	lbu	s1,0(a1)
 456:	22048363          	beqz	s1,67c <vprintf+0x234>
 45a:	e0ca                	sd	s2,64(sp)
 45c:	fc4e                	sd	s3,56(sp)
 45e:	f852                	sd	s4,48(sp)
 460:	f456                	sd	s5,40(sp)
 462:	f05a                	sd	s6,32(sp)
 464:	ec5e                	sd	s7,24(sp)
 466:	e862                	sd	s8,16(sp)
 468:	8b2a                	mv	s6,a0
 46a:	8a2e                	mv	s4,a1
 46c:	8bb2                	mv	s7,a2
  state = 0;
 46e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 470:	4901                	li	s2,0
 472:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 474:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 478:	06400c13          	li	s8,100
 47c:	a00d                	j	49e <vprintf+0x56>
        putc(fd, c0);
 47e:	85a6                	mv	a1,s1
 480:	855a                	mv	a0,s6
 482:	f0bff0ef          	jal	38c <putc>
 486:	a019                	j	48c <vprintf+0x44>
    } else if (state == '%') {
 488:	03598363          	beq	s3,s5,4ae <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 48c:	0019079b          	addiw	a5,s2,1
 490:	893e                	mv	s2,a5
 492:	873e                	mv	a4,a5
 494:	97d2                	add	a5,a5,s4
 496:	0007c483          	lbu	s1,0(a5)
 49a:	1c048a63          	beqz	s1,66e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 49e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4a2:	fe0993e3          	bnez	s3,488 <vprintf+0x40>
      if (c0 == '%') {
 4a6:	fd579ce3          	bne	a5,s5,47e <vprintf+0x36>
        state = '%';
 4aa:	89be                	mv	s3,a5
 4ac:	b7c5                	j	48c <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4ae:	00ea06b3          	add	a3,s4,a4
 4b2:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4b6:	1c060863          	beqz	a2,686 <vprintf+0x23e>
      if (c0 == 'd') {
 4ba:	03878763          	beq	a5,s8,4e8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4be:	f9478693          	addi	a3,a5,-108
 4c2:	0016b693          	seqz	a3,a3
 4c6:	f9c60593          	addi	a1,a2,-100
 4ca:	e99d                	bnez	a1,500 <vprintf+0xb8>
 4cc:	ca95                	beqz	a3,500 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ce:	008b8493          	addi	s1,s7,8
 4d2:	4685                	li	a3,1
 4d4:	4629                	li	a2,10
 4d6:	000bb583          	ld	a1,0(s7)
 4da:	855a                	mv	a0,s6
 4dc:	ecfff0ef          	jal	3aa <printint>
        i += 1;
 4e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4e2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b75d                	j	48c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4e8:	008b8493          	addi	s1,s7,8
 4ec:	4685                	li	a3,1
 4ee:	4629                	li	a2,10
 4f0:	000ba583          	lw	a1,0(s7)
 4f4:	855a                	mv	a0,s6
 4f6:	eb5ff0ef          	jal	3aa <printint>
 4fa:	8ba6                	mv	s7,s1
      state = 0;
 4fc:	4981                	li	s3,0
 4fe:	b779                	j	48c <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 500:	9752                	add	a4,a4,s4
 502:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 506:	f9460713          	addi	a4,a2,-108
 50a:	00173713          	seqz	a4,a4
 50e:	8f75                	and	a4,a4,a3
 510:	f9c58513          	addi	a0,a1,-100
 514:	18051363          	bnez	a0,69a <vprintf+0x252>
 518:	18070163          	beqz	a4,69a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 51c:	008b8493          	addi	s1,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000bb583          	ld	a1,0(s7)
 528:	855a                	mv	a0,s6
 52a:	e81ff0ef          	jal	3aa <printint>
        i += 2;
 52e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 530:	8ba6                	mv	s7,s1
      state = 0;
 532:	4981                	li	s3,0
        i += 2;
 534:	bfa1                	j	48c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 536:	008b8493          	addi	s1,s7,8
 53a:	4681                	li	a3,0
 53c:	4629                	li	a2,10
 53e:	000be583          	lwu	a1,0(s7)
 542:	855a                	mv	a0,s6
 544:	e67ff0ef          	jal	3aa <printint>
 548:	8ba6                	mv	s7,s1
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b781                	j	48c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 54e:	008b8493          	addi	s1,s7,8
 552:	4681                	li	a3,0
 554:	4629                	li	a2,10
 556:	000bb583          	ld	a1,0(s7)
 55a:	855a                	mv	a0,s6
 55c:	e4fff0ef          	jal	3aa <printint>
        i += 1;
 560:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 562:	8ba6                	mv	s7,s1
      state = 0;
 564:	4981                	li	s3,0
 566:	b71d                	j	48c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 568:	008b8493          	addi	s1,s7,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000bb583          	ld	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	e35ff0ef          	jal	3aa <printint>
        i += 2;
 57a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	8ba6                	mv	s7,s1
      state = 0;
 57e:	4981                	li	s3,0
        i += 2;
 580:	b731                	j	48c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 582:	008b8493          	addi	s1,s7,8
 586:	4681                	li	a3,0
 588:	4641                	li	a2,16
 58a:	000be583          	lwu	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e1bff0ef          	jal	3aa <printint>
 594:	8ba6                	mv	s7,s1
      state = 0;
 596:	4981                	li	s3,0
 598:	bdd5                	j	48c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 59a:	008b8493          	addi	s1,s7,8
 59e:	4681                	li	a3,0
 5a0:	4641                	li	a2,16
 5a2:	000bb583          	ld	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	e03ff0ef          	jal	3aa <printint>
        i += 1;
 5ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bde9                	j	48c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4641                	li	a2,16
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	de9ff0ef          	jal	3aa <printint>
        i += 2;
 5c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	b5c1                	j	48c <vprintf+0x44>
 5ce:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5d0:	008b8793          	addi	a5,s7,8
 5d4:	8cbe                	mv	s9,a5
 5d6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5da:	03000593          	li	a1,48
 5de:	855a                	mv	a0,s6
 5e0:	dadff0ef          	jal	38c <putc>
  putc(fd, 'x');
 5e4:	07800593          	li	a1,120
 5e8:	855a                	mv	a0,s6
 5ea:	da3ff0ef          	jal	38c <putc>
 5ee:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f0:	00000b97          	auipc	s7,0x0
 5f4:	328b8b93          	addi	s7,s7,808 # 918 <digits>
 5f8:	03c9d793          	srli	a5,s3,0x3c
 5fc:	97de                	add	a5,a5,s7
 5fe:	0007c583          	lbu	a1,0(a5)
 602:	855a                	mv	a0,s6
 604:	d89ff0ef          	jal	38c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 608:	0992                	slli	s3,s3,0x4
 60a:	34fd                	addiw	s1,s1,-1
 60c:	f4f5                	bnez	s1,5f8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 60e:	8be6                	mv	s7,s9
      state = 0;
 610:	4981                	li	s3,0
 612:	6ca2                	ld	s9,8(sp)
 614:	bda5                	j	48c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 616:	008b8493          	addi	s1,s7,8
 61a:	000bc583          	lbu	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	d6dff0ef          	jal	38c <putc>
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
 628:	b595                	j	48c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 62a:	008b8993          	addi	s3,s7,8
 62e:	000bb483          	ld	s1,0(s7)
 632:	cc91                	beqz	s1,64e <vprintf+0x206>
        for (; *s; s++)
 634:	0004c583          	lbu	a1,0(s1)
 638:	c985                	beqz	a1,668 <vprintf+0x220>
          putc(fd, *s);
 63a:	855a                	mv	a0,s6
 63c:	d51ff0ef          	jal	38c <putc>
        for (; *s; s++)
 640:	0485                	addi	s1,s1,1
 642:	0004c583          	lbu	a1,0(s1)
 646:	f9f5                	bnez	a1,63a <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 648:	8bce                	mv	s7,s3
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b581                	j	48c <vprintf+0x44>
          s = "(null)";
 64e:	00000497          	auipc	s1,0x0
 652:	2c248493          	addi	s1,s1,706 # 910 <malloc+0x126>
        for (; *s; s++)
 656:	02800593          	li	a1,40
 65a:	b7c5                	j	63a <vprintf+0x1f2>
        putc(fd, '%');
 65c:	85be                	mv	a1,a5
 65e:	855a                	mv	a0,s6
 660:	d2dff0ef          	jal	38c <putc>
      state = 0;
 664:	4981                	li	s3,0
 666:	b51d                	j	48c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 668:	8bce                	mv	s7,s3
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b505                	j	48c <vprintf+0x44>
 66e:	6906                	ld	s2,64(sp)
 670:	79e2                	ld	s3,56(sp)
 672:	7a42                	ld	s4,48(sp)
 674:	7aa2                	ld	s5,40(sp)
 676:	7b02                	ld	s6,32(sp)
 678:	6be2                	ld	s7,24(sp)
 67a:	6c42                	ld	s8,16(sp)
    }
  }
}
 67c:	60e6                	ld	ra,88(sp)
 67e:	6446                	ld	s0,80(sp)
 680:	64a6                	ld	s1,72(sp)
 682:	6125                	addi	sp,sp,96
 684:	8082                	ret
      if (c0 == 'd') {
 686:	06400713          	li	a4,100
 68a:	e4e78fe3          	beq	a5,a4,4e8 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 68e:	f9478693          	addi	a3,a5,-108
 692:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 696:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 698:	4701                	li	a4,0
      } else if (c0 == 'u') {
 69a:	07500513          	li	a0,117
 69e:	e8a78ce3          	beq	a5,a0,536 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 6a2:	f8b60513          	addi	a0,a2,-117
 6a6:	e119                	bnez	a0,6ac <vprintf+0x264>
 6a8:	ea0693e3          	bnez	a3,54e <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6ac:	f8b58513          	addi	a0,a1,-117
 6b0:	e119                	bnez	a0,6b6 <vprintf+0x26e>
 6b2:	ea071be3          	bnez	a4,568 <vprintf+0x120>
      } else if (c0 == 'x') {
 6b6:	07800513          	li	a0,120
 6ba:	eca784e3          	beq	a5,a0,582 <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 6be:	f8860613          	addi	a2,a2,-120
 6c2:	e219                	bnez	a2,6c8 <vprintf+0x280>
 6c4:	ec069be3          	bnez	a3,59a <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6c8:	f8858593          	addi	a1,a1,-120
 6cc:	e199                	bnez	a1,6d2 <vprintf+0x28a>
 6ce:	ee0713e3          	bnez	a4,5b4 <vprintf+0x16c>
      } else if (c0 == 'p') {
 6d2:	07000713          	li	a4,112
 6d6:	eee78ce3          	beq	a5,a4,5ce <vprintf+0x186>
      } else if (c0 == 'c') {
 6da:	06300713          	li	a4,99
 6de:	f2e78ce3          	beq	a5,a4,616 <vprintf+0x1ce>
      } else if (c0 == 's') {
 6e2:	07300713          	li	a4,115
 6e6:	f4e782e3          	beq	a5,a4,62a <vprintf+0x1e2>
      } else if (c0 == '%') {
 6ea:	02500713          	li	a4,37
 6ee:	f6e787e3          	beq	a5,a4,65c <vprintf+0x214>
        putc(fd, '%');
 6f2:	02500593          	li	a1,37
 6f6:	855a                	mv	a0,s6
 6f8:	c95ff0ef          	jal	38c <putc>
        putc(fd, c0);
 6fc:	85a6                	mv	a1,s1
 6fe:	855a                	mv	a0,s6
 700:	c8dff0ef          	jal	38c <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	b359                	j	48c <vprintf+0x44>

0000000000000708 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 708:	715d                	addi	sp,sp,-80
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e010                	sd	a2,0(s0)
 712:	e414                	sd	a3,8(s0)
 714:	e818                	sd	a4,16(s0)
 716:	ec1c                	sd	a5,24(s0)
 718:	03043023          	sd	a6,32(s0)
 71c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 720:	8622                	mv	a2,s0
 722:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 726:	d23ff0ef          	jal	448 <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6161                	addi	sp,sp,80
 730:	8082                	ret

0000000000000732 <printf>:

void
printf(const char *fmt, ...)
{
 732:	711d                	addi	sp,sp,-96
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e40c                	sd	a1,8(s0)
 73c:	e810                	sd	a2,16(s0)
 73e:	ec14                	sd	a3,24(s0)
 740:	f018                	sd	a4,32(s0)
 742:	f41c                	sd	a5,40(s0)
 744:	03043823          	sd	a6,48(s0)
 748:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	00840613          	addi	a2,s0,8
 750:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 754:	85aa                	mv	a1,a0
 756:	4505                	li	a0,1
 758:	cf1ff0ef          	jal	448 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6125                	addi	sp,sp,96
 762:	8082                	ret

0000000000000764 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 764:	1141                	addi	sp,sp,-16
 766:	e406                	sd	ra,8(sp)
 768:	e022                	sd	s0,0(sp)
 76a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 76c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 770:	00001797          	auipc	a5,0x1
 774:	8907b783          	ld	a5,-1904(a5) # 1000 <freep>
 778:	a039                	j	786 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77a:	6398                	ld	a4,0(a5)
 77c:	00e7e463          	bltu	a5,a4,784 <free+0x20>
 780:	00e6ea63          	bltu	a3,a4,794 <free+0x30>
{
 784:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	fed7fae3          	bgeu	a5,a3,77a <free+0x16>
 78a:	6398                	ld	a4,0(a5)
 78c:	00e6e463          	bltu	a3,a4,794 <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	fee7eae3          	bltu	a5,a4,784 <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 794:	ff852583          	lw	a1,-8(a0)
 798:	6390                	ld	a2,0(a5)
 79a:	02059813          	slli	a6,a1,0x20
 79e:	01c85713          	srli	a4,a6,0x1c
 7a2:	9736                	add	a4,a4,a3
 7a4:	02e60563          	beq	a2,a4,7ce <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7ac:	4790                	lw	a2,8(a5)
 7ae:	02061593          	slli	a1,a2,0x20
 7b2:	01c5d713          	srli	a4,a1,0x1c
 7b6:	973e                	add	a4,a4,a5
 7b8:	02e68263          	beq	a3,a4,7dc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7be:	00001717          	auipc	a4,0x1
 7c2:	84f73123          	sd	a5,-1982(a4) # 1000 <freep>
}
 7c6:	60a2                	ld	ra,8(sp)
 7c8:	6402                	ld	s0,0(sp)
 7ca:	0141                	addi	sp,sp,16
 7cc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ce:	4618                	lw	a4,8(a2)
 7d0:	9f2d                	addw	a4,a4,a1
 7d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	6398                	ld	a4,0(a5)
 7d8:	6310                	ld	a2,0(a4)
 7da:	b7f9                	j	7a8 <free+0x44>
    p->s.size += bp->s.size;
 7dc:	ff852703          	lw	a4,-8(a0)
 7e0:	9f31                	addw	a4,a4,a2
 7e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7e4:	ff053683          	ld	a3,-16(a0)
 7e8:	bfd1                	j	7bc <free+0x58>

00000000000007ea <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7ea:	7139                	addi	sp,sp,-64
 7ec:	fc06                	sd	ra,56(sp)
 7ee:	f822                	sd	s0,48(sp)
 7f0:	f04a                	sd	s2,32(sp)
 7f2:	ec4e                	sd	s3,24(sp)
 7f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7f6:	02051993          	slli	s3,a0,0x20
 7fa:	0209d993          	srli	s3,s3,0x20
 7fe:	09bd                	addi	s3,s3,15
 800:	0049d993          	srli	s3,s3,0x4
 804:	2985                	addiw	s3,s3,1
 806:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 808:	00000517          	auipc	a0,0x0
 80c:	7f853503          	ld	a0,2040(a0) # 1000 <freep>
 810:	c905                	beqz	a0,840 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 812:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 814:	4798                	lw	a4,8(a5)
 816:	09377663          	bgeu	a4,s3,8a2 <malloc+0xb8>
 81a:	f426                	sd	s1,40(sp)
 81c:	e852                	sd	s4,16(sp)
 81e:	e456                	sd	s5,8(sp)
 820:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 822:	8a4e                	mv	s4,s3
 824:	6705                	lui	a4,0x1
 826:	00e9f363          	bgeu	s3,a4,82c <malloc+0x42>
 82a:	6a05                	lui	s4,0x1
 82c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 830:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 834:	00000497          	auipc	s1,0x0
 838:	7cc48493          	addi	s1,s1,1996 # 1000 <freep>
  if (p == SBRK_ERROR)
 83c:	5afd                	li	s5,-1
 83e:	a83d                	j	87c <malloc+0x92>
 840:	f426                	sd	s1,40(sp)
 842:	e852                	sd	s4,16(sp)
 844:	e456                	sd	s5,8(sp)
 846:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 848:	00000797          	auipc	a5,0x0
 84c:	7c878793          	addi	a5,a5,1992 # 1010 <base>
 850:	00000717          	auipc	a4,0x0
 854:	7af73823          	sd	a5,1968(a4) # 1000 <freep>
 858:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 85e:	b7d1                	j	822 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 860:	6398                	ld	a4,0(a5)
 862:	e118                	sd	a4,0(a0)
 864:	a899                	j	8ba <malloc+0xd0>
  hp->s.size = nu;
 866:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 86a:	0541                	addi	a0,a0,16
 86c:	ef9ff0ef          	jal	764 <free>
  return freep;
 870:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 872:	c125                	beqz	a0,8d2 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 874:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 876:	4798                	lw	a4,8(a5)
 878:	03277163          	bgeu	a4,s2,89a <malloc+0xb0>
    if (p == freep)
 87c:	6098                	ld	a4,0(s1)
 87e:	853e                	mv	a0,a5
 880:	fef71ae3          	bne	a4,a5,874 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 884:	8552                	mv	a0,s4
 886:	a23ff0ef          	jal	2a8 <sbrk>
  if (p == SBRK_ERROR)
 88a:	fd551ee3          	bne	a0,s5,866 <malloc+0x7c>
        return 0;
 88e:	4501                	li	a0,0
 890:	74a2                	ld	s1,40(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
 898:	a03d                	j	8c6 <malloc+0xdc>
 89a:	74a2                	ld	s1,40(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8a2:	fae90fe3          	beq	s2,a4,860 <malloc+0x76>
        p->s.size -= nunits;
 8a6:	4137073b          	subw	a4,a4,s3
 8aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ac:	02071693          	slli	a3,a4,0x20
 8b0:	01c6d713          	srli	a4,a3,0x1c
 8b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ba:	00000717          	auipc	a4,0x0
 8be:	74a73323          	sd	a0,1862(a4) # 1000 <freep>
      return (void *)(p + 1);
 8c2:	01078513          	addi	a0,a5,16
  }
}
 8c6:	70e2                	ld	ra,56(sp)
 8c8:	7442                	ld	s0,48(sp)
 8ca:	7902                	ld	s2,32(sp)
 8cc:	69e2                	ld	s3,24(sp)
 8ce:	6121                	addi	sp,sp,64
 8d0:	8082                	ret
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
 8da:	b7f5                	j	8c6 <malloc+0xdc>
