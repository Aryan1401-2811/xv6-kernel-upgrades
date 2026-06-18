
user/_monitor:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/uproc.h"

int main() {
   0:	8a010113          	addi	sp,sp,-1888
   4:	74113c23          	sd	ra,1880(sp)
   8:	74813823          	sd	s0,1872(sp)
   c:	74913423          	sd	s1,1864(sp)
  10:	75213023          	sd	s2,1856(sp)
  14:	73313c23          	sd	s3,1848(sp)
  18:	73413823          	sd	s4,1840(sp)
  1c:	73513423          	sd	s5,1832(sp)
  20:	73613023          	sd	s6,1824(sp)
  24:	71713c23          	sd	s7,1816(sp)
  28:	71813823          	sd	s8,1808(sp)
  2c:	71913423          	sd	s9,1800(sp)
  30:	76010413          	addi	s0,sp,1888
    struct uproc uproc_table[64]; // Array to hold process data

    while(1) {
        // Clear the screen using terminal escape codes
        printf("\033[2J\033[H"); 
  34:	00001c17          	auipc	s8,0x1
  38:	95cc0c13          	addi	s8,s8,-1700 # 990 <malloc+0xfc>
        printf("=== XV6 MLFQ TELEMETRY DASHBOARD ===\n");
  3c:	00001b97          	auipc	s7,0x1
  40:	95cb8b93          	addi	s7,s7,-1700 # 998 <malloc+0x104>
        printf("PID\tNAME\t\tPRIORITY\tTOTAL TICKS\n");
  44:	00001b17          	auipc	s6,0x1
  48:	984b0b13          	addi	s6,s6,-1660 # 9c8 <malloc+0x134>
        printf("-------------------------------------------------\n");
  4c:	00001a97          	auipc	s5,0x1
  50:	99ca8a93          	addi	s5,s5,-1636 # 9e8 <malloc+0x154>

        int count = getprocinfo(uproc_table);
  54:	8a040a13          	addi	s4,s0,-1888
            printf("Error fetching process info.\n");
            exit(1);
        }

        for(int i = 0; i < count; i++) {
            printf("%d\t%s\t\t%d\t\t%d\n", 
  58:	00001997          	auipc	s3,0x1
  5c:	9e898993          	addi	s3,s3,-1560 # a40 <malloc+0x1ac>
                   uproc_table[i].name, 
                   uproc_table[i].priority, 
                   uproc_table[i].total_ticks);
        }

        sleep(50); // Refresh roughly every half second
  60:	03200c93          	li	s9,50
  64:	a829                	j	7e <main+0x7e>
            printf("Error fetching process info.\n");
  66:	00001517          	auipc	a0,0x1
  6a:	9ba50513          	addi	a0,a0,-1606 # a20 <malloc+0x18c>
  6e:	76e000ef          	jal	7dc <printf>
            exit(1);
  72:	4505                	li	a0,1
  74:	312000ef          	jal	386 <exit>
        sleep(50); // Refresh roughly every half second
  78:	8566                	mv	a0,s9
  7a:	3ac000ef          	jal	426 <sleep>
        printf("\033[2J\033[H"); 
  7e:	8562                	mv	a0,s8
  80:	75c000ef          	jal	7dc <printf>
        printf("=== XV6 MLFQ TELEMETRY DASHBOARD ===\n");
  84:	855e                	mv	a0,s7
  86:	756000ef          	jal	7dc <printf>
        printf("PID\tNAME\t\tPRIORITY\tTOTAL TICKS\n");
  8a:	855a                	mv	a0,s6
  8c:	750000ef          	jal	7dc <printf>
        printf("-------------------------------------------------\n");
  90:	8556                	mv	a0,s5
  92:	74a000ef          	jal	7dc <printf>
        int count = getprocinfo(uproc_table);
  96:	8552                	mv	a0,s4
  98:	396000ef          	jal	42e <getprocinfo>
        if(count < 0) {
  9c:	fc0545e3          	bltz	a0,66 <main+0x66>
        for(int i = 0; i < count; i++) {
  a0:	fca05ce3          	blez	a0,78 <main+0x78>
  a4:	8ac40493          	addi	s1,s0,-1876
  a8:	00351913          	slli	s2,a0,0x3
  ac:	40a90933          	sub	s2,s2,a0
  b0:	090a                	slli	s2,s2,0x2
  b2:	9926                	add	s2,s2,s1
            printf("%d\t%s\t\t%d\t\t%d\n", 
  b4:	ffc4a703          	lw	a4,-4(s1)
  b8:	ff84a683          	lw	a3,-8(s1)
  bc:	8626                	mv	a2,s1
  be:	ff44a583          	lw	a1,-12(s1)
  c2:	854e                	mv	a0,s3
  c4:	718000ef          	jal	7dc <printf>
        for(int i = 0; i < count; i++) {
  c8:	04f1                	addi	s1,s1,28
  ca:	ff2495e3          	bne	s1,s2,b4 <main+0xb4>
  ce:	b76d                	j	78 <main+0x78>

00000000000000d0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  d8:	f29ff0ef          	jal	0 <main>
  exit(r);
  dc:	2aa000ef          	jal	386 <exit>

00000000000000e0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e406                	sd	ra,8(sp)
  e4:	e022                	sd	s0,0(sp)
  e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  e8:	87aa                	mv	a5,a0
  ea:	0585                	addi	a1,a1,1
  ec:	0785                	addi	a5,a5,1
  ee:	fff5c703          	lbu	a4,-1(a1)
  f2:	fee78fa3          	sb	a4,-1(a5)
  f6:	fb75                	bnez	a4,ea <strcpy+0xa>
    ;
  return os;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cb91                	beqz	a5,120 <strcmp+0x20>
 10e:	0005c703          	lbu	a4,0(a1)
 112:	00f71763          	bne	a4,a5,120 <strcmp+0x20>
    p++, q++;
 116:	0505                	addi	a0,a0,1
 118:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	fbe5                	bnez	a5,10e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 120:	0005c503          	lbu	a0,0(a1)
}
 124:	40a7853b          	subw	a0,a5,a0
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strlen>:

uint
strlen(const char *s)
{
 130:	1141                	addi	sp,sp,-16
 132:	e406                	sd	ra,8(sp)
 134:	e022                	sd	s0,0(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x28>
 13e:	00150793          	addi	a5,a0,1
 142:	86be                	mv	a3,a5
 144:	0785                	addi	a5,a5,1
 146:	fff7c703          	lbu	a4,-1(a5)
 14a:	ff65                	bnez	a4,142 <strlen+0x12>
 14c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for (n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfdd                	j	150 <strlen+0x20>

000000000000015c <memset>:

void *
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 164:	ca19                	beqz	a2,17a <memset+0x1e>
 166:	87aa                	mv	a5,a0
 168:	1602                	slli	a2,a2,0x20
 16a:	9201                	srli	a2,a2,0x20
 16c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 170:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 174:	0785                	addi	a5,a5,1
 176:	fee79de3          	bne	a5,a4,170 <memset+0x14>
  }
  return dst;
}
 17a:	60a2                	ld	ra,8(sp)
 17c:	6402                	ld	s0,0(sp)
 17e:	0141                	addi	sp,sp,16
 180:	8082                	ret

0000000000000182 <strchr>:

char *
strchr(const char *s, char c)
{
 182:	1141                	addi	sp,sp,-16
 184:	e406                	sd	ra,8(sp)
 186:	e022                	sd	s0,0(sp)
 188:	0800                	addi	s0,sp,16
  for (; *s; s++)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	cf81                	beqz	a5,1a6 <strchr+0x24>
    if (*s == c)
 190:	00f58763          	beq	a1,a5,19e <strchr+0x1c>
  for (; *s; s++)
 194:	0505                	addi	a0,a0,1
 196:	00054783          	lbu	a5,0(a0)
 19a:	fbfd                	bnez	a5,190 <strchr+0xe>
      return (char *)s;
  return 0;
 19c:	4501                	li	a0,0
}
 19e:	60a2                	ld	ra,8(sp)
 1a0:	6402                	ld	s0,0(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
  return 0;
 1a6:	4501                	li	a0,0
 1a8:	bfdd                	j	19e <strchr+0x1c>

00000000000001aa <gets>:

char *
gets(char *buf, int max)
{
 1aa:	711d                	addi	sp,sp,-96
 1ac:	ec86                	sd	ra,88(sp)
 1ae:	e8a2                	sd	s0,80(sp)
 1b0:	e4a6                	sd	s1,72(sp)
 1b2:	e0ca                	sd	s2,64(sp)
 1b4:	fc4e                	sd	s3,56(sp)
 1b6:	f852                	sd	s4,48(sp)
 1b8:	f456                	sd	s5,40(sp)
 1ba:	f05a                	sd	s6,32(sp)
 1bc:	ec5e                	sd	s7,24(sp)
 1be:	e862                	sd	s8,16(sp)
 1c0:	1080                	addi	s0,sp,96
 1c2:	8baa                	mv	s7,a0
 1c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1c6:	892a                	mv	s2,a0
 1c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ca:	faf40b13          	addi	s6,s0,-81
 1ce:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1d0:	8c26                	mv	s8,s1
 1d2:	0014899b          	addiw	s3,s1,1
 1d6:	84ce                	mv	s1,s3
 1d8:	0349d463          	bge	s3,s4,200 <gets+0x56>
    cc = read(0, &c, 1);
 1dc:	8656                	mv	a2,s5
 1de:	85da                	mv	a1,s6
 1e0:	4501                	li	a0,0
 1e2:	1bc000ef          	jal	39e <read>
    if (cc < 1)
 1e6:	00a05d63          	blez	a0,200 <gets+0x56>
      break;
    buf[i++] = c;
 1ea:	faf44783          	lbu	a5,-81(s0)
 1ee:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1f2:	0905                	addi	s2,s2,1
 1f4:	ff678713          	addi	a4,a5,-10
 1f8:	c319                	beqz	a4,1fe <gets+0x54>
 1fa:	17cd                	addi	a5,a5,-13
 1fc:	fbf1                	bnez	a5,1d0 <gets+0x26>
    buf[i++] = c;
 1fe:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 200:	9c5e                	add	s8,s8,s7
 202:	000c0023          	sb	zero,0(s8)
  return buf;
}
 206:	855e                	mv	a0,s7
 208:	60e6                	ld	ra,88(sp)
 20a:	6446                	ld	s0,80(sp)
 20c:	64a6                	ld	s1,72(sp)
 20e:	6906                	ld	s2,64(sp)
 210:	79e2                	ld	s3,56(sp)
 212:	7a42                	ld	s4,48(sp)
 214:	7aa2                	ld	s5,40(sp)
 216:	7b02                	ld	s6,32(sp)
 218:	6be2                	ld	s7,24(sp)
 21a:	6c42                	ld	s8,16(sp)
 21c:	6125                	addi	sp,sp,96
 21e:	8082                	ret

0000000000000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	1101                	addi	sp,sp,-32
 222:	ec06                	sd	ra,24(sp)
 224:	e822                	sd	s0,16(sp)
 226:	e04a                	sd	s2,0(sp)
 228:	1000                	addi	s0,sp,32
 22a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22c:	4581                	li	a1,0
 22e:	198000ef          	jal	3c6 <open>
  if (fd < 0)
 232:	02054263          	bltz	a0,256 <stat+0x36>
 236:	e426                	sd	s1,8(sp)
 238:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23a:	85ca                	mv	a1,s2
 23c:	1a2000ef          	jal	3de <fstat>
 240:	892a                	mv	s2,a0
  close(fd);
 242:	8526                	mv	a0,s1
 244:	16a000ef          	jal	3ae <close>
  return r;
 248:	64a2                	ld	s1,8(sp)
}
 24a:	854a                	mv	a0,s2
 24c:	60e2                	ld	ra,24(sp)
 24e:	6442                	ld	s0,16(sp)
 250:	6902                	ld	s2,0(sp)
 252:	6105                	addi	sp,sp,32
 254:	8082                	ret
    return -1;
 256:	57fd                	li	a5,-1
 258:	893e                	mv	s2,a5
 25a:	bfc5                	j	24a <stat+0x2a>

000000000000025c <atoi>:

int
atoi(const char *s)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 264:	00054683          	lbu	a3,0(a0)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	4625                	li	a2,9
 272:	02f66963          	bltu	a2,a5,2a4 <atoi+0x48>
 276:	872a                	mv	a4,a0
  n = 0;
 278:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 27a:	0705                	addi	a4,a4,1
 27c:	0025179b          	slliw	a5,a0,0x2
 280:	9fa9                	addw	a5,a5,a0
 282:	0017979b          	slliw	a5,a5,0x1
 286:	9fb5                	addw	a5,a5,a3
 288:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 28c:	00074683          	lbu	a3,0(a4)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	fef671e3          	bgeu	a2,a5,27a <atoi+0x1e>
  return n;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  n = 0;
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <atoi+0x40>

00000000000002a8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b0:	02b57563          	bgeu	a0,a1,2da <memmove+0x32>
    while (n-- > 0)
 2b4:	00c05f63          	blez	a2,2d2 <memmove+0x2a>
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c2:	0585                	addi	a1,a1,1
 2c4:	0705                	addi	a4,a4,1
 2c6:	fff5c683          	lbu	a3,-1(a1)
 2ca:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2ce:	fee79ae3          	bne	a5,a4,2c2 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
    while (n-- > 0)
 2da:	fec05ce3          	blez	a2,2d2 <memmove+0x2a>
    dst += n;
 2de:	00c50733          	add	a4,a0,a2
    src += n;
 2e2:	95b2                	add	a1,a1,a2
 2e4:	fff6079b          	addiw	a5,a2,-1
 2e8:	1782                	slli	a5,a5,0x20
 2ea:	9381                	srli	a5,a5,0x20
 2ec:	fff7c793          	not	a5,a5
 2f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f2:	15fd                	addi	a1,a1,-1
 2f4:	177d                	addi	a4,a4,-1
 2f6:	0005c683          	lbu	a3,0(a1)
 2fa:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2fe:	fef71ae3          	bne	a4,a5,2f2 <memmove+0x4a>
 302:	bfc1                	j	2d2 <memmove+0x2a>

0000000000000304 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30c:	c61d                	beqz	a2,33a <memcmp+0x36>
 30e:	1602                	slli	a2,a2,0x20
 310:	9201                	srli	a2,a2,0x20
 312:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 316:	00054783          	lbu	a5,0(a0)
 31a:	0005c703          	lbu	a4,0(a1)
 31e:	00e79863          	bne	a5,a4,32e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 322:	0505                	addi	a0,a0,1
    p2++;
 324:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 326:	fed518e3          	bne	a0,a3,316 <memcmp+0x12>
  }
  return 0;
 32a:	4501                	li	a0,0
 32c:	a019                	j	332 <memcmp+0x2e>
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
  return 0;
 33a:	4501                	li	a0,0
 33c:	bfdd                	j	332 <memcmp+0x2e>

000000000000033e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 346:	f63ff0ef          	jal	2a8 <memmove>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <sbrk>:

char *
sbrk(int n)
{
 352:	1141                	addi	sp,sp,-16
 354:	e406                	sd	ra,8(sp)
 356:	e022                	sd	s0,0(sp)
 358:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 35a:	4585                	li	a1,1
 35c:	0b2000ef          	jal	40e <sys_sbrk>
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <sbrklazy>:

char *
sbrklazy(int n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 370:	4589                	li	a1,2
 372:	09c000ef          	jal	40e <sys_sbrk>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37e:	4885                	li	a7,1
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <exit>:
.global exit
exit:
 li a7, SYS_exit
 386:	4889                	li	a7,2
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <wait>:
.global wait
wait:
 li a7, SYS_wait
 38e:	488d                	li	a7,3
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 396:	4891                	li	a7,4
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <read>:
.global read
read:
 li a7, SYS_read
 39e:	4895                	li	a7,5
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <write>:
.global write
write:
 li a7, SYS_write
 3a6:	48c1                	li	a7,16
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <close>:
.global close
close:
 li a7, SYS_close
 3ae:	48d5                	li	a7,21
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b6:	4899                	li	a7,6
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <exec>:
.global exec
exec:
 li a7, SYS_exec
 3be:	489d                	li	a7,7
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <open>:
.global open
open:
 li a7, SYS_open
 3c6:	48bd                	li	a7,15
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ce:	48c5                	li	a7,17
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d6:	48c9                	li	a7,18
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3de:	48a1                	li	a7,8
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <link>:
.global link
link:
 li a7, SYS_link
 3e6:	48cd                	li	a7,19
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ee:	48d1                	li	a7,20
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f6:	48a5                	li	a7,9
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <dup>:
.global dup
dup:
 li a7, SYS_dup
 3fe:	48a9                	li	a7,10
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 406:	48ad                	li	a7,11
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 40e:	48b1                	li	a7,12
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <pause>:
.global pause
pause:
 li a7, SYS_pause
 416:	48b5                	li	a7,13
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 41e:	48b9                	li	a7,14
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 426:	48d9                	li	a7,22
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <getprocinfo>:
.global getprocinfo
getprocinfo:
 li a7, SYS_getprocinfo
 42e:	48dd                	li	a7,23
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 436:	1101                	addi	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	1000                	addi	s0,sp,32
 43e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 442:	4605                	li	a2,1
 444:	fef40593          	addi	a1,s0,-17
 448:	f5fff0ef          	jal	3a6 <write>
}
 44c:	60e2                	ld	ra,24(sp)
 44e:	6442                	ld	s0,16(sp)
 450:	6105                	addi	sp,sp,32
 452:	8082                	ret

0000000000000454 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 454:	715d                	addi	sp,sp,-80
 456:	e486                	sd	ra,72(sp)
 458:	e0a2                	sd	s0,64(sp)
 45a:	f84a                	sd	s2,48(sp)
 45c:	f44e                	sd	s3,40(sp)
 45e:	0880                	addi	s0,sp,80
 460:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 462:	c6d1                	beqz	a3,4ee <printint+0x9a>
 464:	0805d563          	bgez	a1,4ee <printint+0x9a>
    neg = 1;
    x = -xx;
 468:	40b005b3          	neg	a1,a1
    neg = 1;
 46c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 46e:	fb840993          	addi	s3,s0,-72
  neg = 0;
 472:	86ce                	mv	a3,s3
  i = 0;
 474:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 476:	00000817          	auipc	a6,0x0
 47a:	5e280813          	addi	a6,a6,1506 # a58 <digits>
 47e:	88ba                	mv	a7,a4
 480:	0017051b          	addiw	a0,a4,1
 484:	872a                	mv	a4,a0
 486:	02c5f7b3          	remu	a5,a1,a2
 48a:	97c2                	add	a5,a5,a6
 48c:	0007c783          	lbu	a5,0(a5)
 490:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 494:	87ae                	mv	a5,a1
 496:	02c5d5b3          	divu	a1,a1,a2
 49a:	0685                	addi	a3,a3,1
 49c:	fec7f1e3          	bgeu	a5,a2,47e <printint+0x2a>
  if (neg)
 4a0:	00030c63          	beqz	t1,4b8 <printint+0x64>
    buf[i++] = '-';
 4a4:	fd050793          	addi	a5,a0,-48
 4a8:	00878533          	add	a0,a5,s0
 4ac:	02d00793          	li	a5,45
 4b0:	fef50423          	sb	a5,-24(a0)
 4b4:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4b8:	02e05563          	blez	a4,4e2 <printint+0x8e>
 4bc:	fc26                	sd	s1,56(sp)
 4be:	377d                	addiw	a4,a4,-1
 4c0:	00e984b3          	add	s1,s3,a4
 4c4:	19fd                	addi	s3,s3,-1
 4c6:	99ba                	add	s3,s3,a4
 4c8:	1702                	slli	a4,a4,0x20
 4ca:	9301                	srli	a4,a4,0x20
 4cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d0:	0004c583          	lbu	a1,0(s1)
 4d4:	854a                	mv	a0,s2
 4d6:	f61ff0ef          	jal	436 <putc>
  while (--i >= 0)
 4da:	14fd                	addi	s1,s1,-1
 4dc:	ff349ae3          	bne	s1,s3,4d0 <printint+0x7c>
 4e0:	74e2                	ld	s1,56(sp)
}
 4e2:	60a6                	ld	ra,72(sp)
 4e4:	6406                	ld	s0,64(sp)
 4e6:	7942                	ld	s2,48(sp)
 4e8:	79a2                	ld	s3,40(sp)
 4ea:	6161                	addi	sp,sp,80
 4ec:	8082                	ret
  neg = 0;
 4ee:	4301                	li	t1,0
 4f0:	bfbd                	j	46e <printint+0x1a>

00000000000004f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f2:	711d                	addi	sp,sp,-96
 4f4:	ec86                	sd	ra,88(sp)
 4f6:	e8a2                	sd	s0,80(sp)
 4f8:	e4a6                	sd	s1,72(sp)
 4fa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4fc:	0005c483          	lbu	s1,0(a1)
 500:	22048363          	beqz	s1,726 <vprintf+0x234>
 504:	e0ca                	sd	s2,64(sp)
 506:	fc4e                	sd	s3,56(sp)
 508:	f852                	sd	s4,48(sp)
 50a:	f456                	sd	s5,40(sp)
 50c:	f05a                	sd	s6,32(sp)
 50e:	ec5e                	sd	s7,24(sp)
 510:	e862                	sd	s8,16(sp)
 512:	8b2a                	mv	s6,a0
 514:	8a2e                	mv	s4,a1
 516:	8bb2                	mv	s7,a2
  state = 0;
 518:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 51a:	4901                	li	s2,0
 51c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 51e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 522:	06400c13          	li	s8,100
 526:	a00d                	j	548 <vprintf+0x56>
        putc(fd, c0);
 528:	85a6                	mv	a1,s1
 52a:	855a                	mv	a0,s6
 52c:	f0bff0ef          	jal	436 <putc>
 530:	a019                	j	536 <vprintf+0x44>
    } else if (state == '%') {
 532:	03598363          	beq	s3,s5,558 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 536:	0019079b          	addiw	a5,s2,1
 53a:	893e                	mv	s2,a5
 53c:	873e                	mv	a4,a5
 53e:	97d2                	add	a5,a5,s4
 540:	0007c483          	lbu	s1,0(a5)
 544:	1c048a63          	beqz	s1,718 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 548:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 54c:	fe0993e3          	bnez	s3,532 <vprintf+0x40>
      if (c0 == '%') {
 550:	fd579ce3          	bne	a5,s5,528 <vprintf+0x36>
        state = '%';
 554:	89be                	mv	s3,a5
 556:	b7c5                	j	536 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 558:	00ea06b3          	add	a3,s4,a4
 55c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 560:	1c060863          	beqz	a2,730 <vprintf+0x23e>
      if (c0 == 'd') {
 564:	03878763          	beq	a5,s8,592 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 568:	f9478693          	addi	a3,a5,-108
 56c:	0016b693          	seqz	a3,a3
 570:	f9c60593          	addi	a1,a2,-100
 574:	e99d                	bnez	a1,5aa <vprintf+0xb8>
 576:	ca95                	beqz	a3,5aa <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 578:	008b8493          	addi	s1,s7,8
 57c:	4685                	li	a3,1
 57e:	4629                	li	a2,10
 580:	000bb583          	ld	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	ecfff0ef          	jal	454 <printint>
        i += 1;
 58a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 58c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 58e:	4981                	li	s3,0
 590:	b75d                	j	536 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8493          	addi	s1,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	eb5ff0ef          	jal	454 <printint>
 5a4:	8ba6                	mv	s7,s1
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b779                	j	536 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
 5aa:	9752                	add	a4,a4,s4
 5ac:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5b0:	f9460713          	addi	a4,a2,-108
 5b4:	00173713          	seqz	a4,a4
 5b8:	8f75                	and	a4,a4,a3
 5ba:	f9c58513          	addi	a0,a1,-100
 5be:	18051363          	bnez	a0,744 <vprintf+0x252>
 5c2:	18070163          	beqz	a4,744 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e81ff0ef          	jal	454 <printint>
        i += 2;
 5d8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
        i += 2;
 5de:	bfa1                	j	536 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000be583          	lwu	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e67ff0ef          	jal	454 <printint>
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b781                	j	536 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e4fff0ef          	jal	454 <printint>
        i += 1;
 60a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
 610:	b71d                	j	536 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e35ff0ef          	jal	454 <printint>
        i += 2;
 624:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	b731                	j	536 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000be583          	lwu	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	e1bff0ef          	jal	454 <printint>
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	bdd5                	j	536 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	e03ff0ef          	jal	454 <printint>
        i += 1;
 656:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bde9                	j	536 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	de9ff0ef          	jal	454 <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	b5c1                	j	536 <vprintf+0x44>
 678:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 67a:	008b8793          	addi	a5,s7,8
 67e:	8cbe                	mv	s9,a5
 680:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 684:	03000593          	li	a1,48
 688:	855a                	mv	a0,s6
 68a:	dadff0ef          	jal	436 <putc>
  putc(fd, 'x');
 68e:	07800593          	li	a1,120
 692:	855a                	mv	a0,s6
 694:	da3ff0ef          	jal	436 <putc>
 698:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69a:	00000b97          	auipc	s7,0x0
 69e:	3beb8b93          	addi	s7,s7,958 # a58 <digits>
 6a2:	03c9d793          	srli	a5,s3,0x3c
 6a6:	97de                	add	a5,a5,s7
 6a8:	0007c583          	lbu	a1,0(a5)
 6ac:	855a                	mv	a0,s6
 6ae:	d89ff0ef          	jal	436 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b2:	0992                	slli	s3,s3,0x4
 6b4:	34fd                	addiw	s1,s1,-1
 6b6:	f4f5                	bnez	s1,6a2 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6b8:	8be6                	mv	s7,s9
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	6ca2                	ld	s9,8(sp)
 6be:	bda5                	j	536 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6c0:	008b8493          	addi	s1,s7,8
 6c4:	000bc583          	lbu	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	d6dff0ef          	jal	436 <putc>
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b595                	j	536 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6d4:	008b8993          	addi	s3,s7,8
 6d8:	000bb483          	ld	s1,0(s7)
 6dc:	cc91                	beqz	s1,6f8 <vprintf+0x206>
        for (; *s; s++)
 6de:	0004c583          	lbu	a1,0(s1)
 6e2:	c985                	beqz	a1,712 <vprintf+0x220>
          putc(fd, *s);
 6e4:	855a                	mv	a0,s6
 6e6:	d51ff0ef          	jal	436 <putc>
        for (; *s; s++)
 6ea:	0485                	addi	s1,s1,1
 6ec:	0004c583          	lbu	a1,0(s1)
 6f0:	f9f5                	bnez	a1,6e4 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
 6f2:	8bce                	mv	s7,s3
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b581                	j	536 <vprintf+0x44>
          s = "(null)";
 6f8:	00000497          	auipc	s1,0x0
 6fc:	35848493          	addi	s1,s1,856 # a50 <malloc+0x1bc>
        for (; *s; s++)
 700:	02800593          	li	a1,40
 704:	b7c5                	j	6e4 <vprintf+0x1f2>
        putc(fd, '%');
 706:	85be                	mv	a1,a5
 708:	855a                	mv	a0,s6
 70a:	d2dff0ef          	jal	436 <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	b51d                	j	536 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 712:	8bce                	mv	s7,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	b505                	j	536 <vprintf+0x44>
 718:	6906                	ld	s2,64(sp)
 71a:	79e2                	ld	s3,56(sp)
 71c:	7a42                	ld	s4,48(sp)
 71e:	7aa2                	ld	s5,40(sp)
 720:	7b02                	ld	s6,32(sp)
 722:	6be2                	ld	s7,24(sp)
 724:	6c42                	ld	s8,16(sp)
    }
  }
}
 726:	60e6                	ld	ra,88(sp)
 728:	6446                	ld	s0,80(sp)
 72a:	64a6                	ld	s1,72(sp)
 72c:	6125                	addi	sp,sp,96
 72e:	8082                	ret
      if (c0 == 'd') {
 730:	06400713          	li	a4,100
 734:	e4e78fe3          	beq	a5,a4,592 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
 738:	f9478693          	addi	a3,a5,-108
 73c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 740:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 742:	4701                	li	a4,0
      } else if (c0 == 'u') {
 744:	07500513          	li	a0,117
 748:	e8a78ce3          	beq	a5,a0,5e0 <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
 74c:	f8b60513          	addi	a0,a2,-117
 750:	e119                	bnez	a0,756 <vprintf+0x264>
 752:	ea0693e3          	bnez	a3,5f8 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 756:	f8b58513          	addi	a0,a1,-117
 75a:	e119                	bnez	a0,760 <vprintf+0x26e>
 75c:	ea071be3          	bnez	a4,612 <vprintf+0x120>
      } else if (c0 == 'x') {
 760:	07800513          	li	a0,120
 764:	eca784e3          	beq	a5,a0,62c <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
 768:	f8860613          	addi	a2,a2,-120
 76c:	e219                	bnez	a2,772 <vprintf+0x280>
 76e:	ec069be3          	bnez	a3,644 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 772:	f8858593          	addi	a1,a1,-120
 776:	e199                	bnez	a1,77c <vprintf+0x28a>
 778:	ee0713e3          	bnez	a4,65e <vprintf+0x16c>
      } else if (c0 == 'p') {
 77c:	07000713          	li	a4,112
 780:	eee78ce3          	beq	a5,a4,678 <vprintf+0x186>
      } else if (c0 == 'c') {
 784:	06300713          	li	a4,99
 788:	f2e78ce3          	beq	a5,a4,6c0 <vprintf+0x1ce>
      } else if (c0 == 's') {
 78c:	07300713          	li	a4,115
 790:	f4e782e3          	beq	a5,a4,6d4 <vprintf+0x1e2>
      } else if (c0 == '%') {
 794:	02500713          	li	a4,37
 798:	f6e787e3          	beq	a5,a4,706 <vprintf+0x214>
        putc(fd, '%');
 79c:	02500593          	li	a1,37
 7a0:	855a                	mv	a0,s6
 7a2:	c95ff0ef          	jal	436 <putc>
        putc(fd, c0);
 7a6:	85a6                	mv	a1,s1
 7a8:	855a                	mv	a0,s6
 7aa:	c8dff0ef          	jal	436 <putc>
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b359                	j	536 <vprintf+0x44>

00000000000007b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b2:	715d                	addi	sp,sp,-80
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	e010                	sd	a2,0(s0)
 7bc:	e414                	sd	a3,8(s0)
 7be:	e818                	sd	a4,16(s0)
 7c0:	ec1c                	sd	a5,24(s0)
 7c2:	03043023          	sd	a6,32(s0)
 7c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	8622                	mv	a2,s0
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	d23ff0ef          	jal	4f2 <vprintf>
}
 7d4:	60e2                	ld	ra,24(sp)
 7d6:	6442                	ld	s0,16(sp)
 7d8:	6161                	addi	sp,sp,80
 7da:	8082                	ret

00000000000007dc <printf>:

void
printf(const char *fmt, ...)
{
 7dc:	711d                	addi	sp,sp,-96
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e40c                	sd	a1,8(s0)
 7e6:	e810                	sd	a2,16(s0)
 7e8:	ec14                	sd	a3,24(s0)
 7ea:	f018                	sd	a4,32(s0)
 7ec:	f41c                	sd	a5,40(s0)
 7ee:	03043823          	sd	a6,48(s0)
 7f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f6:	00840613          	addi	a2,s0,8
 7fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7fe:	85aa                	mv	a1,a0
 800:	4505                	li	a0,1
 802:	cf1ff0ef          	jal	4f2 <vprintf>
}
 806:	60e2                	ld	ra,24(sp)
 808:	6442                	ld	s0,16(sp)
 80a:	6125                	addi	sp,sp,96
 80c:	8082                	ret

000000000000080e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80e:	1141                	addi	sp,sp,-16
 810:	e406                	sd	ra,8(sp)
 812:	e022                	sd	s0,0(sp)
 814:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 816:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	00000797          	auipc	a5,0x0
 81e:	7e67b783          	ld	a5,2022(a5) # 1000 <freep>
 822:	a039                	j	830 <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	6398                	ld	a4,0(a5)
 826:	00e7e463          	bltu	a5,a4,82e <free+0x20>
 82a:	00e6ea63          	bltu	a3,a4,83e <free+0x30>
{
 82e:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	fed7fae3          	bgeu	a5,a3,824 <free+0x16>
 834:	6398                	ld	a4,0(a5)
 836:	00e6e463          	bltu	a3,a4,83e <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83a:	fee7eae3          	bltu	a5,a4,82e <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
 83e:	ff852583          	lw	a1,-8(a0)
 842:	6390                	ld	a2,0(a5)
 844:	02059813          	slli	a6,a1,0x20
 848:	01c85713          	srli	a4,a6,0x1c
 84c:	9736                	add	a4,a4,a3
 84e:	02e60563          	beq	a2,a4,878 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 856:	4790                	lw	a2,8(a5)
 858:	02061593          	slli	a1,a2,0x20
 85c:	01c5d713          	srli	a4,a1,0x1c
 860:	973e                	add	a4,a4,a5
 862:	02e68263          	beq	a3,a4,886 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 866:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 868:	00000717          	auipc	a4,0x0
 86c:	78f73c23          	sd	a5,1944(a4) # 1000 <freep>
}
 870:	60a2                	ld	ra,8(sp)
 872:	6402                	ld	s0,0(sp)
 874:	0141                	addi	sp,sp,16
 876:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 878:	4618                	lw	a4,8(a2)
 87a:	9f2d                	addw	a4,a4,a1
 87c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	6310                	ld	a2,0(a4)
 884:	b7f9                	j	852 <free+0x44>
    p->s.size += bp->s.size;
 886:	ff852703          	lw	a4,-8(a0)
 88a:	9f31                	addw	a4,a4,a2
 88c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 88e:	ff053683          	ld	a3,-16(a0)
 892:	bfd1                	j	866 <free+0x58>

0000000000000894 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 894:	7139                	addi	sp,sp,-64
 896:	fc06                	sd	ra,56(sp)
 898:	f822                	sd	s0,48(sp)
 89a:	f04a                	sd	s2,32(sp)
 89c:	ec4e                	sd	s3,24(sp)
 89e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8a0:	02051993          	slli	s3,a0,0x20
 8a4:	0209d993          	srli	s3,s3,0x20
 8a8:	09bd                	addi	s3,s3,15
 8aa:	0049d993          	srli	s3,s3,0x4
 8ae:	2985                	addiw	s3,s3,1
 8b0:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8b2:	00000517          	auipc	a0,0x0
 8b6:	74e53503          	ld	a0,1870(a0) # 1000 <freep>
 8ba:	c905                	beqz	a0,8ea <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8bc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8be:	4798                	lw	a4,8(a5)
 8c0:	09377663          	bgeu	a4,s3,94c <malloc+0xb8>
 8c4:	f426                	sd	s1,40(sp)
 8c6:	e852                	sd	s4,16(sp)
 8c8:	e456                	sd	s5,8(sp)
 8ca:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8cc:	8a4e                	mv	s4,s3
 8ce:	6705                	lui	a4,0x1
 8d0:	00e9f363          	bgeu	s3,a4,8d6 <malloc+0x42>
 8d4:	6a05                	lui	s4,0x1
 8d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8de:	00000497          	auipc	s1,0x0
 8e2:	72248493          	addi	s1,s1,1826 # 1000 <freep>
  if (p == SBRK_ERROR)
 8e6:	5afd                	li	s5,-1
 8e8:	a83d                	j	926 <malloc+0x92>
 8ea:	f426                	sd	s1,40(sp)
 8ec:	e852                	sd	s4,16(sp)
 8ee:	e456                	sd	s5,8(sp)
 8f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f2:	00000797          	auipc	a5,0x0
 8f6:	71e78793          	addi	a5,a5,1822 # 1010 <base>
 8fa:	00000717          	auipc	a4,0x0
 8fe:	70f73323          	sd	a5,1798(a4) # 1000 <freep>
 902:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 904:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 908:	b7d1                	j	8cc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 90a:	6398                	ld	a4,0(a5)
 90c:	e118                	sd	a4,0(a0)
 90e:	a899                	j	964 <malloc+0xd0>
  hp->s.size = nu;
 910:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 914:	0541                	addi	a0,a0,16
 916:	ef9ff0ef          	jal	80e <free>
  return freep;
 91a:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 91c:	c125                	beqz	a0,97c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 91e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 920:	4798                	lw	a4,8(a5)
 922:	03277163          	bgeu	a4,s2,944 <malloc+0xb0>
    if (p == freep)
 926:	6098                	ld	a4,0(s1)
 928:	853e                	mv	a0,a5
 92a:	fef71ae3          	bne	a4,a5,91e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 92e:	8552                	mv	a0,s4
 930:	a23ff0ef          	jal	352 <sbrk>
  if (p == SBRK_ERROR)
 934:	fd551ee3          	bne	a0,s5,910 <malloc+0x7c>
        return 0;
 938:	4501                	li	a0,0
 93a:	74a2                	ld	s1,40(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	a03d                	j	970 <malloc+0xdc>
 944:	74a2                	ld	s1,40(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 94c:	fae90fe3          	beq	s2,a4,90a <malloc+0x76>
        p->s.size -= nunits;
 950:	4137073b          	subw	a4,a4,s3
 954:	c798                	sw	a4,8(a5)
        p += p->s.size;
 956:	02071693          	slli	a3,a4,0x20
 95a:	01c6d713          	srli	a4,a3,0x1c
 95e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 960:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 964:	00000717          	auipc	a4,0x0
 968:	68a73e23          	sd	a0,1692(a4) # 1000 <freep>
      return (void *)(p + 1);
 96c:	01078513          	addi	a0,a5,16
  }
}
 970:	70e2                	ld	ra,56(sp)
 972:	7442                	ld	s0,48(sp)
 974:	7902                	ld	s2,32(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6121                	addi	sp,sp,64
 97a:	8082                	ret
 97c:	74a2                	ld	s1,40(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	b7f5                	j	970 <malloc+0xdc>
