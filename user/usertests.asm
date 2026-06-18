
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	bd078793          	addi	a5,a5,-1072 # 7be0 <malloc+0x26ae>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	01a050ef          	jal	5064 <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00005517          	auipc	a0,0x5
      70:	5c450513          	addi	a0,a0,1476 # 5630 <malloc+0xfe>
      74:	406050ef          	jal	547a <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	7ab040ef          	jal	5024 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	00009797          	auipc	a5,0x9
      82:	52a78793          	addi	a5,a5,1322 # 95a8 <uninit>
      86:	0000c697          	auipc	a3,0xc
      8a:	c3268693          	addi	a3,a3,-974 # bcb8 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00005517          	auipc	a0,0x5
      aa:	5aa50513          	addi	a0,a0,1450 # 5650 <malloc+0x11e>
      ae:	3cc050ef          	jal	547a <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	771040ef          	jal	5024 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00005517          	auipc	a0,0x5
      ca:	5a250513          	addi	a0,a0,1442 # 5668 <malloc+0x136>
      ce:	797040ef          	jal	5064 <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	777040ef          	jal	504c <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	5ac50513          	addi	a0,a0,1452 # 5688 <malloc+0x156>
      e4:	781040ef          	jal	5064 <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00005517          	auipc	a0,0x5
      fc:	57850513          	addi	a0,a0,1400 # 5670 <malloc+0x13e>
     100:	37a050ef          	jal	547a <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	71f040ef          	jal	5024 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	58c50513          	addi	a0,a0,1420 # 5698 <malloc+0x166>
     114:	366050ef          	jal	547a <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	70b040ef          	jal	5024 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00005517          	auipc	a0,0x5
     132:	59250513          	addi	a0,a0,1426 # 56c0 <malloc+0x18e>
     136:	73f040ef          	jal	5074 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	58250513          	addi	a0,a0,1410 # 56c0 <malloc+0x18e>
     146:	71f040ef          	jal	5064 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	58258593          	addi	a1,a1,1410 # 56d0 <malloc+0x19e>
     156:	6ef040ef          	jal	5044 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	56250513          	addi	a0,a0,1378 # 56c0 <malloc+0x18e>
     166:	6ff040ef          	jal	5064 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	56a58593          	addi	a1,a1,1386 # 56d8 <malloc+0x1a6>
     176:	8526                	mv	a0,s1
     178:	6cd040ef          	jal	5044 <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	53e50513          	addi	a0,a0,1342 # 56c0 <malloc+0x18e>
     18a:	6eb040ef          	jal	5074 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	6bd040ef          	jal	504c <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	6b7040ef          	jal	504c <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00005517          	auipc	a0,0x5
     1b0:	53450513          	addi	a0,a0,1332 # 56e0 <malloc+0x1ae>
     1b4:	2c6050ef          	jal	547a <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	66b040ef          	jal	5024 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	673040ef          	jal	5064 <open>
    close(fd);
     1f6:	657040ef          	jal	504c <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	653040ef          	jal	5074 <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00005517          	auipc	a0,0x5
     260:	4ac50513          	addi	a0,a0,1196 # 5708 <malloc+0x1d6>
     264:	611040ef          	jal	5074 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00005a17          	auipc	s4,0x5
     274:	498a0a13          	addi	s4,s4,1176 # 5708 <malloc+0x1d6>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000c997          	auipc	s3,0xc
     27e:	a3e98993          	addi	s3,s3,-1474 # bcb8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <rmdot+0x51>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	5d9040ef          	jal	5064 <open>
     290:	892a                	mv	s2,a0
    if (fd < 0) {
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	5a7040ef          	jal	5044 <write>
      if (cc != sz) {
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for (i = 0; i < 2; i++) {
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	59f040ef          	jal	504c <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	5c1040ef          	jal	5074 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00005517          	auipc	a0,0x5
     2e0:	43c50513          	addi	a0,a0,1084 # 5718 <malloc+0x1e6>
     2e4:	196050ef          	jal	547a <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	53b040ef          	jal	5024 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00005517          	auipc	a0,0x5
     2f8:	44450513          	addi	a0,a0,1092 # 5738 <malloc+0x206>
     2fc:	17e050ef          	jal	547a <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	523040ef          	jal	5024 <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31a:	00005517          	auipc	a0,0x5
     31e:	43650513          	addi	a0,a0,1078 # 5750 <malloc+0x21e>
     322:	553040ef          	jal	5074 <unlink>
     326:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00005997          	auipc	s3,0x5
     332:	42298993          	addi	s3,s3,1058 # 5750 <malloc+0x21e>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	523040ef          	jal	5064 <open>
     346:	84aa                	mv	s1,a0
    if (fd < 0) {
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	4f5040ef          	jal	5044 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	4f7040ef          	jal	504c <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	519040ef          	jal	5074 <unlink>
  for (int i = 0; i < assumed_free; i++) {
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00005517          	auipc	a0,0x5
     36e:	3e650513          	addi	a0,a0,998 # 5750 <malloc+0x21e>
     372:	4f3040ef          	jal	5064 <open>
     376:	84aa                	mv	s1,a0
  if (fd < 0) {
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37c:	4605                	li	a2,1
     37e:	00005597          	auipc	a1,0x5
     382:	35a58593          	addi	a1,a1,858 # 56d8 <malloc+0x1a6>
     386:	4bf040ef          	jal	5044 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00005517          	auipc	a0,0x5
     394:	3e050513          	addi	a0,a0,992 # 5770 <malloc+0x23e>
     398:	0e2050ef          	jal	547a <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	487040ef          	jal	5024 <exit>
      printf("open junk failed\n");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	3b650513          	addi	a0,a0,950 # 5758 <malloc+0x226>
     3aa:	0d0050ef          	jal	547a <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	475040ef          	jal	5024 <exit>
    printf("open junk failed\n");
     3b4:	00005517          	auipc	a0,0x5
     3b8:	3a450513          	addi	a0,a0,932 # 5758 <malloc+0x226>
     3bc:	0be050ef          	jal	547a <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	463040ef          	jal	5024 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	485040ef          	jal	504c <close>
  unlink("junk");
     3cc:	00005517          	auipc	a0,0x5
     3d0:	38450513          	addi	a0,a0,900 # 5750 <malloc+0x21e>
     3d4:	4a1040ef          	jal	5074 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	44b040ef          	jal	5024 <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	441040ef          	jal	5074 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	429040ef          	jal	5064 <open>
    if (fd < 0) {
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	409040ef          	jal	504c <close>
  for (int i = 0; i < nzz; i++) {
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
     44e:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++) {
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	3e7040ef          	jal	5074 <unlink>
  for (int i = 0; i < nzz; i++) {
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00007797          	auipc	a5,0x7
     4c8:	71c78793          	addi	a5,a5,1820 # 7be0 <malloc+0x26ae>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00005a97          	auipc	s5,0x5
     4fa:	28aa8a93          	addi	s5,s5,650 # 5780 <malloc+0x24e>
    int n = write(fd, (void *)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     500:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	357040ef          	jal	5064 <open>
     512:	84aa                	mv	s1,a0
    if (fd < 0) {
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	329040ef          	jal	5044 <write>
    if (n >= 0) {
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	327040ef          	jal	504c <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	349040ef          	jal	5074 <unlink>
    n = write(1, (char *)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	30f040ef          	jal	5044 <write>
    if (n > 0) {
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if (pipe(fds) < 0) {
     53e:	855e                	mv	a0,s7
     540:	2f5040ef          	jal	5034 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	2f5040ef          	jal	5044 <write>
    if (n > 0) {
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	2f1040ef          	jal	504c <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	2e9040ef          	jal	504c <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00005517          	auipc	a0,0x5
     58c:	20050513          	addi	a0,a0,512 # 5788 <malloc+0x256>
     590:	6eb040ef          	jal	547a <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	28f040ef          	jal	5024 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00005517          	auipc	a0,0x5
     5a2:	20250513          	addi	a0,a0,514 # 57a0 <malloc+0x26e>
     5a6:	6d5040ef          	jal	547a <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	279040ef          	jal	5024 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00005517          	auipc	a0,0x5
     5b8:	21c50513          	addi	a0,a0,540 # 57d0 <malloc+0x29e>
     5bc:	6bf040ef          	jal	547a <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	263040ef          	jal	5024 <exit>
      printf("pipe() failed\n");
     5c6:	00005517          	auipc	a0,0x5
     5ca:	23a50513          	addi	a0,a0,570 # 5800 <malloc+0x2ce>
     5ce:	6ad040ef          	jal	547a <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	251040ef          	jal	5024 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00005517          	auipc	a0,0x5
     5e0:	23450513          	addi	a0,a0,564 # 5810 <malloc+0x2de>
     5e4:	697040ef          	jal	547a <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	23b040ef          	jal	5024 <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     608:	00007797          	auipc	a5,0x7
     60c:	5d878793          	addi	a5,a5,1496 # 7be0 <malloc+0x26ae>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00005b17          	auipc	s6,0x5
     640:	204b0b13          	addi	s6,s6,516 # 5840 <malloc+0x30e>
    int n = read(fd, (void *)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	08cb8b93          	addi	s7,s7,140 # 56d8 <malloc+0x1a6>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	209040ef          	jal	5064 <open>
     660:	84aa                	mv	s1,a0
    if (fd < 0) {
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	1d3040ef          	jal	503c <read>
    if (n > 0) {
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	1d9040ef          	jal	504c <close>
    if (pipe(fds) < 0) {
     678:	8562                	mv	a0,s8
     67a:	1bb040ef          	jal	5034 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	1bb040ef          	jal	5044 <write>
    if (n != 1) {
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	1a3040ef          	jal	503c <read>
    if (n > 0) {
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	1a7040ef          	jal	504c <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	19f040ef          	jal	504c <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00005517          	auipc	a0,0x5
     6d6:	17650513          	addi	a0,a0,374 # 5848 <malloc+0x316>
     6da:	5a1040ef          	jal	547a <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	145040ef          	jal	5024 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00005517          	auipc	a0,0x5
     6ec:	17850513          	addi	a0,a0,376 # 5860 <malloc+0x32e>
     6f0:	58b040ef          	jal	547a <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	12f040ef          	jal	5024 <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	10650513          	addi	a0,a0,262 # 5800 <malloc+0x2ce>
     702:	579040ef          	jal	547a <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	11d040ef          	jal	5024 <exit>
      printf("pipe write failed\n");
     70c:	00005517          	auipc	a0,0x5
     710:	18450513          	addi	a0,a0,388 # 5890 <malloc+0x35e>
     714:	567040ef          	jal	547a <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	10b040ef          	jal	5024 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00005517          	auipc	a0,0x5
     726:	18650513          	addi	a0,a0,390 # 58a8 <malloc+0x376>
     72a:	551040ef          	jal	547a <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	0f5040ef          	jal	5024 <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	f7850513          	addi	a0,a0,-136 # 56c0 <malloc+0x18e>
     750:	125040ef          	jal	5074 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	f6850513          	addi	a0,a0,-152 # 56c0 <malloc+0x18e>
     760:	105040ef          	jal	5064 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	f6858593          	addi	a1,a1,-152 # 56d0 <malloc+0x19e>
     770:	0d5040ef          	jal	5044 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	0d7040ef          	jal	504c <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	f4450513          	addi	a0,a0,-188 # 56c0 <malloc+0x18e>
     784:	0e1040ef          	jal	5064 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	0ab040ef          	jal	503c <read>
  if (n != 4) {
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	f2050513          	addi	a0,a0,-224 # 56c0 <malloc+0x18e>
     7a8:	0bd040ef          	jal	5064 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	f1050513          	addi	a0,a0,-240 # 56c0 <malloc+0x18e>
     7b8:	0ad040ef          	jal	5064 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	077040ef          	jal	503c <read>
     7ca:	8aaa                	mv	s5,a0
  if (n != 0) {
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	065040ef          	jal	503c <read>
     7dc:	8aaa                	mv	s5,a0
  if (n != 0) {
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	15658593          	addi	a1,a1,342 # 5938 <malloc+0x406>
     7ea:	854e                	mv	a0,s3
     7ec:	059040ef          	jal	5044 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	043040ef          	jal	503c <read>
  if (n != 6) {
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	02f040ef          	jal	503c <read>
  if (n != 2) {
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	ea850513          	addi	a0,a0,-344 # 56c0 <malloc+0x18e>
     820:	055040ef          	jal	5074 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	027040ef          	jal	504c <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	021040ef          	jal	504c <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	01b040ef          	jal	504c <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	08c50513          	addi	a0,a0,140 # 58d8 <malloc+0x3a6>
     854:	427040ef          	jal	547a <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	7ca040ef          	jal	5024 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	09850513          	addi	a0,a0,152 # 58f8 <malloc+0x3c6>
     868:	413040ef          	jal	547a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	09850513          	addi	a0,a0,152 # 5908 <malloc+0x3d6>
     878:	403040ef          	jal	547a <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	7a6040ef          	jal	5024 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	0a450513          	addi	a0,a0,164 # 5928 <malloc+0x3f6>
     88c:	3ef040ef          	jal	547a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	07450513          	addi	a0,a0,116 # 5908 <malloc+0x3d6>
     89c:	3df040ef          	jal	547a <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	782040ef          	jal	5024 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	09650513          	addi	a0,a0,150 # 5940 <malloc+0x40e>
     8b2:	3c9040ef          	jal	547a <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	76c040ef          	jal	5024 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	0a050513          	addi	a0,a0,160 # 5960 <malloc+0x42e>
     8c8:	3b3040ef          	jal	547a <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	756040ef          	jal	5024 <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	09250513          	addi	a0,a0,146 # 5980 <malloc+0x44e>
     8f6:	76e040ef          	jal	5064 <open>
  if (fd < 0) {
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	0a4a0a13          	addi	s4,s4,164 # 59a8 <malloc+0x476>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90c:	00005b17          	auipc	s6,0x5
     910:	0d4b0b13          	addi	s6,s6,212 # 59e0 <malloc+0x4ae>
  for (i = 0; i < N; i++) {
     914:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	726040ef          	jal	5044 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	718040ef          	jal	5044 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	710040ef          	jal	504c <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	03e50513          	addi	a0,a0,62 # 5980 <malloc+0x44e>
     94a:	71a040ef          	jal	5064 <open>
     94e:	84aa                	mv	s1,a0
  if (fd < 0) {
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     954:	7d000613          	li	a2,2000
     958:	0000b597          	auipc	a1,0xb
     95c:	36058593          	addi	a1,a1,864 # bcb8 <buf>
     960:	6dc040ef          	jal	503c <read>
  if (i != N * SZ * 2) {
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	6de040ef          	jal	504c <close>
  if (unlink("small") < 0) {
     972:	00005517          	auipc	a0,0x5
     976:	00e50513          	addi	a0,a0,14 # 5980 <malloc+0x44e>
     97a:	6fa040ef          	jal	5074 <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	fee50513          	addi	a0,a0,-18 # 5988 <malloc+0x456>
     9a2:	2d9040ef          	jal	547a <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	67c040ef          	jal	5024 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	00850513          	addi	a0,a0,8 # 59b8 <malloc+0x486>
     9b8:	2c3040ef          	jal	547a <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	666040ef          	jal	5024 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	02a50513          	addi	a0,a0,42 # 59f0 <malloc+0x4be>
     9ce:	2ad040ef          	jal	547a <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	650040ef          	jal	5024 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	03e50513          	addi	a0,a0,62 # 5a18 <malloc+0x4e6>
     9e2:	299040ef          	jal	547a <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	63c040ef          	jal	5024 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	04a50513          	addi	a0,a0,74 # 5a38 <malloc+0x506>
     9f6:	285040ef          	jal	547a <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	628040ef          	jal	5024 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	04e50513          	addi	a0,a0,78 # 5a50 <malloc+0x51e>
     a0a:	271040ef          	jal	547a <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	614040ef          	jal	5024 <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	04250513          	addi	a0,a0,66 # 5a70 <malloc+0x53e>
     a36:	62e040ef          	jal	5064 <open>
  if (fd < 0) {
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a42:	0000b997          	auipc	s3,0xb
     a46:	27698993          	addi	s3,s3,630 # bcb8 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4a:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a4e:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	5e8040ef          	jal	5044 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	5e0040ef          	jal	504c <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	ffe50513          	addi	a0,a0,-2 # 5a70 <malloc+0x53e>
     a7a:	5ea040ef          	jal	5064 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000b917          	auipc	s2,0xb
     a8a:	23290913          	addi	s2,s2,562 # bcb8 <buf>
  if (fd < 0) {
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	5a4040ef          	jal	503c <read>
    if (i == 0) {
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if (i != BSIZE) {
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	fc850513          	addi	a0,a0,-56 # 5a78 <malloc+0x546>
     ab8:	1c3040ef          	jal	547a <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	566040ef          	jal	5024 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	fd250513          	addi	a0,a0,-46 # 5a98 <malloc+0x566>
     ace:	1ad040ef          	jal	547a <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	550040ef          	jal	5024 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	fe650513          	addi	a0,a0,-26 # 5ac0 <malloc+0x58e>
     ae2:	199040ef          	jal	547a <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	53c040ef          	jal	5024 <exit>
      if (n != MAXFILE) {
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	556040ef          	jal	504c <close>
  if (unlink("big") < 0) {
     afa:	00005517          	auipc	a0,0x5
     afe:	f7650513          	addi	a0,a0,-138 # 5a70 <malloc+0x53e>
     b02:	572040ef          	jal	5074 <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	fbe50513          	addi	a0,a0,-66 # 5ae0 <malloc+0x5ae>
     b2a:	151040ef          	jal	547a <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	4f4040ef          	jal	5024 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	fd050513          	addi	a0,a0,-48 # 5b08 <malloc+0x5d6>
     b40:	13b040ef          	jal	547a <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	4de040ef          	jal	5024 <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	fd250513          	addi	a0,a0,-46 # 5b20 <malloc+0x5ee>
     b56:	125040ef          	jal	547a <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	4c8040ef          	jal	5024 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	fe650513          	addi	a0,a0,-26 # 5b48 <malloc+0x616>
     b6a:	111040ef          	jal	547a <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	4b4040ef          	jal	5024 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	fd850513          	addi	a0,a0,-40 # 5b60 <malloc+0x62e>
     b90:	4d4040ef          	jal	5064 <open>
  if (fd < 0) {
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	ff458593          	addi	a1,a1,-12 # 5b90 <malloc+0x65e>
     ba4:	4a0040ef          	jal	5044 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	4a2040ef          	jal	504c <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	fb050513          	addi	a0,a0,-80 # 5b60 <malloc+0x62e>
     bb8:	4ac040ef          	jal	5064 <open>
     bbc:	84aa                	mv	s1,a0
  if (fd < 0) {
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc2:	00005517          	auipc	a0,0x5
     bc6:	f9e50513          	addi	a0,a0,-98 # 5b60 <malloc+0x62e>
     bca:	4aa040ef          	jal	5074 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	f8c50513          	addi	a0,a0,-116 # 5b60 <malloc+0x62e>
     bdc:	488040ef          	jal	5064 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	ff458593          	addi	a1,a1,-12 # 5bd8 <malloc+0x6a6>
     bec:	458040ef          	jal	5044 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	45a040ef          	jal	504c <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf6:	660d                	lui	a2,0x3
     bf8:	0000b597          	auipc	a1,0xb
     bfc:	0c058593          	addi	a1,a1,192 # bcb8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	43a040ef          	jal	503c <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0c:	0000b717          	auipc	a4,0xb
     c10:	0ac74703          	lbu	a4,172(a4) # bcb8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1c:	4629                	li	a2,10
     c1e:	0000b597          	auipc	a1,0xb
     c22:	09a58593          	addi	a1,a1,154 # bcb8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	41c040ef          	jal	5044 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	418040ef          	jal	504c <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	f2850513          	addi	a0,a0,-216 # 5b60 <malloc+0x62e>
     c40:	434040ef          	jal	5074 <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	f1c50513          	addi	a0,a0,-228 # 5b70 <malloc+0x63e>
     c5c:	01f040ef          	jal	547a <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	3c2040ef          	jal	5024 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	f3050513          	addi	a0,a0,-208 # 5b98 <malloc+0x666>
     c70:	00b040ef          	jal	547a <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	3ae040ef          	jal	5024 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	f3c50513          	addi	a0,a0,-196 # 5bb8 <malloc+0x686>
     c84:	7f6040ef          	jal	547a <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	39a040ef          	jal	5024 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	f5050513          	addi	a0,a0,-176 # 5be0 <malloc+0x6ae>
     c98:	7e2040ef          	jal	547a <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	386040ef          	jal	5024 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	f5c50513          	addi	a0,a0,-164 # 5c00 <malloc+0x6ce>
     cac:	7ce040ef          	jal	547a <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	372040ef          	jal	5024 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	f6850513          	addi	a0,a0,-152 # 5c20 <malloc+0x6ee>
     cc0:	7ba040ef          	jal	547a <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	35e040ef          	jal	5024 <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	f6850513          	addi	a0,a0,-152 # 5c40 <malloc+0x70e>
     ce0:	394040ef          	jal	5074 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	f6450513          	addi	a0,a0,-156 # 5c48 <malloc+0x716>
     cec:	388040ef          	jal	5074 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	f4c50513          	addi	a0,a0,-180 # 5c40 <malloc+0x70e>
     cfc:	368040ef          	jal	5064 <open>
  if (fd < 0) {
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	e8858593          	addi	a1,a1,-376 # 5b90 <malloc+0x65e>
     d10:	334040ef          	jal	5044 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	330040ef          	jal	504c <close>
  if (link("lf1", "lf2") < 0) {
     d20:	00005597          	auipc	a1,0x5
     d24:	f2858593          	addi	a1,a1,-216 # 5c48 <malloc+0x716>
     d28:	00005517          	auipc	a0,0x5
     d2c:	f1850513          	addi	a0,a0,-232 # 5c40 <malloc+0x70e>
     d30:	354040ef          	jal	5084 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	f0850513          	addi	a0,a0,-248 # 5c40 <malloc+0x70e>
     d40:	334040ef          	jal	5074 <unlink>
  if (open("lf1", 0) >= 0) {
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	efa50513          	addi	a0,a0,-262 # 5c40 <malloc+0x70e>
     d4e:	316040ef          	jal	5064 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	ef050513          	addi	a0,a0,-272 # 5c48 <malloc+0x716>
     d60:	304040ef          	jal	5064 <open>
     d64:	84aa                	mv	s1,a0
  if (fd < 0) {
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6a:	660d                	lui	a2,0x3
     d6c:	0000b597          	auipc	a1,0xb
     d70:	f4c58593          	addi	a1,a1,-180 # bcb8 <buf>
     d74:	2c8040ef          	jal	503c <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	2cc040ef          	jal	504c <close>
  if (link("lf2", "lf2") >= 0) {
     d84:	00005597          	auipc	a1,0x5
     d88:	ec458593          	addi	a1,a1,-316 # 5c48 <malloc+0x716>
     d8c:	852e                	mv	a0,a1
     d8e:	2f6040ef          	jal	5084 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	eb250513          	addi	a0,a0,-334 # 5c48 <malloc+0x716>
     d9e:	2d6040ef          	jal	5074 <unlink>
  if (link("lf2", "lf1") >= 0) {
     da2:	00005597          	auipc	a1,0x5
     da6:	e9e58593          	addi	a1,a1,-354 # 5c40 <malloc+0x70e>
     daa:	00005517          	auipc	a0,0x5
     dae:	e9e50513          	addi	a0,a0,-354 # 5c48 <malloc+0x716>
     db2:	2d2040ef          	jal	5084 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dba:	00005597          	auipc	a1,0x5
     dbe:	e8658593          	addi	a1,a1,-378 # 5c40 <malloc+0x70e>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	f8e50513          	addi	a0,a0,-114 # 5d50 <malloc+0x81e>
     dca:	2ba040ef          	jal	5084 <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	e7050513          	addi	a0,a0,-400 # 5c50 <malloc+0x71e>
     de8:	692040ef          	jal	547a <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	236040ef          	jal	5024 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	e7450513          	addi	a0,a0,-396 # 5c68 <malloc+0x736>
     dfc:	67e040ef          	jal	547a <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	222040ef          	jal	5024 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	e7850513          	addi	a0,a0,-392 # 5c80 <malloc+0x74e>
     e10:	66a040ef          	jal	547a <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	20e040ef          	jal	5024 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	e8450513          	addi	a0,a0,-380 # 5ca0 <malloc+0x76e>
     e24:	656040ef          	jal	547a <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	1fa040ef          	jal	5024 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	ea050513          	addi	a0,a0,-352 # 5cd0 <malloc+0x79e>
     e38:	642040ef          	jal	547a <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	1e6040ef          	jal	5024 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	ea450513          	addi	a0,a0,-348 # 5ce8 <malloc+0x7b6>
     e4c:	62e040ef          	jal	547a <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	1d2040ef          	jal	5024 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	ea850513          	addi	a0,a0,-344 # 5d00 <malloc+0x7ce>
     e60:	61a040ef          	jal	547a <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	1be040ef          	jal	5024 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	ebc50513          	addi	a0,a0,-324 # 5d28 <malloc+0x7f6>
     e74:	606040ef          	jal	547a <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	1aa040ef          	jal	5024 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	ed850513          	addi	a0,a0,-296 # 5d58 <malloc+0x826>
     e88:	5f2040ef          	jal	547a <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	196040ef          	jal	5024 <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ea8:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eaa:	00005997          	auipc	s3,0x5
     eae:	ece98993          	addi	s3,s3,-306 # 5d78 <malloc+0x846>
     eb2:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	1c6040ef          	jal	5084 <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	ea650513          	addi	a0,a0,-346 # 5d88 <malloc+0x856>
     eea:	590040ef          	jal	547a <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	134040ef          	jal	5024 <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	e9c50513          	addi	a0,a0,-356 # 5da8 <malloc+0x876>
     f14:	160040ef          	jal	5074 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	e8c50513          	addi	a0,a0,-372 # 5da8 <malloc+0x876>
     f24:	140040ef          	jal	5064 <open>
  if (fd < 0) {
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	120040ef          	jal	504c <close>
  for (i = 0; i < N; i++) {
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	e6e98993          	addi	s3,s3,-402 # 5da8 <malloc+0x876>
  for (i = 0; i < N; i++) {
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	10c040ef          	jal	5084 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	e2250513          	addi	a0,a0,-478 # 5da8 <malloc+0x876>
     f8e:	0e6040ef          	jal	5074 <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if (unlink(name) != 0) {
     f96:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fcc:	854a                	mv	a0,s2
     fce:	0a6040ef          	jal	5074 <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	dbe50513          	addi	a0,a0,-578 # 5db0 <malloc+0x87e>
     ffa:	480040ef          	jal	547a <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	024040ef          	jal	5024 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	dc450513          	addi	a0,a0,-572 # 5dd0 <malloc+0x89e>
    1014:	466040ef          	jal	547a <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	00a040ef          	jal	5024 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	dd850513          	addi	a0,a0,-552 # 5df8 <malloc+0x8c6>
    1028:	452040ef          	jal	547a <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	7f7030ef          	jal	5024 <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00007497          	auipc	s1,0x7
    1044:	fc048493          	addi	s1,s1,-64 # 8000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	00e040ef          	jal	505c <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	7e1030ef          	jal	5034 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	7cb030ef          	jal	5024 <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <buf+0x698>
    argv[0] = (char *)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00004997          	auipc	s3,0x4
    1082:	5ea98993          	addi	s3,s3,1514 # 5668 <malloc+0x136>
    argv[0] = (char *)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	7cb030ef          	jal	505c <exec>
  for (int i = 0; i < 50000; i++) {
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	789030ef          	jal	5024 <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	7af030ef          	jal	5074 <unlink>
  if (ret != -1) {
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	78d030ef          	jal	5064 <open>
  if (fd != -1) {
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	79d030ef          	jal	5084 <link>
  if (ret != -1) {
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f2:	00006797          	auipc	a5,0x6
    10f6:	dee78793          	addi	a5,a5,-530 # 6ee0 <malloc+0x19ae>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	753030ef          	jal	505c <exec>
  if (ret != -1) {
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	709030ef          	jal	501c <fork>
  if (pid < 0) {
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if (pid == 0) {
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00007797          	auipc	a5,0x7
    1124:	48078793          	addi	a5,a5,1152 # 85a0 <big.0>
    1128:	00008697          	auipc	a3,0x8
    112c:	47868693          	addi	a3,a3,1144 # 95a0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	00008797          	auipc	a5,0x8
    1142:	46078123          	sb	zero,1122(a5) # 95a0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1146:	00007797          	auipc	a5,0x7
    114a:	a9a78793          	addi	a5,a5,-1382 # 7be0 <malloc+0x26ae>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00004517          	auipc	a0,0x4
    116e:	4fe50513          	addi	a0,a0,1278 # 5668 <malloc+0x136>
    1172:	6eb030ef          	jal	505c <exec>
    if (ret != -1) {
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	d2250513          	addi	a0,a0,-734 # 5ea0 <malloc+0x96e>
    1186:	2f4040ef          	jal	547a <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	699030ef          	jal	5024 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	c8250513          	addi	a0,a0,-894 # 5e18 <malloc+0x8e6>
    119e:	2dc040ef          	jal	547a <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	681030ef          	jal	5024 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	c8a50513          	addi	a0,a0,-886 # 5e38 <malloc+0x906>
    11b6:	2c4040ef          	jal	547a <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	669030ef          	jal	5024 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	c9050513          	addi	a0,a0,-880 # 5e58 <malloc+0x926>
    11d0:	2aa040ef          	jal	547a <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	64f030ef          	jal	5024 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	ca050513          	addi	a0,a0,-864 # 5e80 <malloc+0x94e>
    11e8:	292040ef          	jal	547a <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	637030ef          	jal	5024 <exit>
    printf("fork failed\n");
    11f2:	00006517          	auipc	a0,0x6
    11f6:	2de50513          	addi	a0,a0,734 # 74d0 <malloc+0x1f9e>
    11fa:	280040ef          	jal	547a <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	625030ef          	jal	5024 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	61d030ef          	jal	5024 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	619030ef          	jal	502c <wait>
  if (st != 747) {
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	c9c50513          	addi	a0,a0,-868 # 5ec8 <malloc+0x996>
    1234:	246040ef          	jal	547a <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	5eb030ef          	jal	5024 <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00004517          	auipc	a0,0x4
    1252:	47250513          	addi	a0,a0,1138 # 56c0 <malloc+0x18e>
    1256:	60f030ef          	jal	5064 <open>
    125a:	5f3030ef          	jal	504c <close>
  pid = fork();
    125e:	5bf030ef          	jal	501c <fork>
  if (pid < 0) {
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if (pid == 0) {
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00004997          	auipc	s3,0x4
    1282:	44298993          	addi	s3,s3,1090 # 56c0 <malloc+0x18e>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	ca0b0b13          	addi	s6,s6,-864 # 5f28 <malloc+0x9f6>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	5c9030ef          	jal	5064 <open>
    12a0:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	59b030ef          	jal	5044 <write>
      if (n != 10) {
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	599030ef          	jal	504c <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	5a9030ef          	jal	5064 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	577030ef          	jal	503c <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	581030ef          	jal	504c <close>
    for (int i = 0; i < 100; i++) {
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	54d030ef          	jal	5024 <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	c0a50513          	addi	a0,a0,-1014 # 5ef8 <malloc+0x9c6>
    12f6:	184040ef          	jal	547a <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	529030ef          	jal	5024 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	c0e50513          	addi	a0,a0,-1010 # 5f10 <malloc+0x9de>
    130a:	170040ef          	jal	547a <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	515030ef          	jal	5024 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	c2050513          	addi	a0,a0,-992 # 5f38 <malloc+0xa06>
    1320:	15a040ef          	jal	547a <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	4ff030ef          	jal	5024 <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00004a17          	auipc	s4,0x4
    1342:	382a0a13          	addi	s4,s4,898 # 56c0 <malloc+0x18e>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	c10b0b13          	addi	s6,s6,-1008 # 5f58 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	511030ef          	jal	5064 <open>
    1358:	84aa                	mv	s1,a0
    if (fd < 0) {
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	4e3030ef          	jal	5044 <write>
    if (n != 3) {
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	4e1030ef          	jal	504c <close>
  for (int i = 0; i < 150; i++) {
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	4af030ef          	jal	502c <wait>
  unlink("truncfile");
    1382:	00004517          	auipc	a0,0x4
    1386:	33e50513          	addi	a0,a0,830 # 56c0 <malloc+0x18e>
    138a:	4eb030ef          	jal	5074 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	493030ef          	jal	5024 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	b7450513          	addi	a0,a0,-1164 # 5f10 <malloc+0x9de>
    13a4:	0d6040ef          	jal	547a <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	47b030ef          	jal	5024 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	baa50513          	addi	a0,a0,-1110 # 5f60 <malloc+0xa2e>
    13be:	0bc040ef          	jal	547a <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	461030ef          	jal	5024 <exit>

00000000000013c8 <pipe1>:
{
    13c8:	711d                	addi	sp,sp,-96
    13ca:	ec86                	sd	ra,88(sp)
    13cc:	e8a2                	sd	s0,80(sp)
    13ce:	e862                	sd	s8,16(sp)
    13d0:	1080                	addi	s0,sp,96
    13d2:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    13d4:	fa840513          	addi	a0,s0,-88
    13d8:	45d030ef          	jal	5034 <pipe>
    13dc:	e925                	bnez	a0,144c <pipe1+0x84>
    13de:	e4a6                	sd	s1,72(sp)
    13e0:	fc4e                	sd	s3,56(sp)
    13e2:	84aa                	mv	s1,a0
  pid = fork();
    13e4:	439030ef          	jal	501c <fork>
    13e8:	89aa                	mv	s3,a0
  if (pid == 0) {
    13ea:	c151                	beqz	a0,146e <pipe1+0xa6>
  } else if (pid > 0) {
    13ec:	16a05063          	blez	a0,154c <pipe1+0x184>
    13f0:	e0ca                	sd	s2,64(sp)
    13f2:	f852                	sd	s4,48(sp)
    close(fds[1]);
    13f4:	fac42503          	lw	a0,-84(s0)
    13f8:	455030ef          	jal	504c <close>
    total = 0;
    13fc:	89a6                	mv	s3,s1
    cc = 1;
    13fe:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1400:	0000ba17          	auipc	s4,0xb
    1404:	8b8a0a13          	addi	s4,s4,-1864 # bcb8 <buf>
    1408:	864a                	mv	a2,s2
    140a:	85d2                	mv	a1,s4
    140c:	fa842503          	lw	a0,-88(s0)
    1410:	42d030ef          	jal	503c <read>
    1414:	85aa                	mv	a1,a0
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x140>
    141a:	0000b797          	auipc	a5,0xb
    141e:	89e78793          	addi	a5,a5,-1890 # bcb8 <buf>
    1422:	00b4863b          	addw	a2,s1,a1
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	0007c683          	lbu	a3,0(a5)
    142a:	0ff4f713          	zext.b	a4,s1
    142e:	0ae69d63          	bne	a3,a4,14e8 <pipe1+0x120>
    1432:	2485                	addiw	s1,s1,1
      for (i = 0; i < n; i++) {
    1434:	0785                	addi	a5,a5,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5e>
      total += n;
    143a:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    143e:	0019191b          	slliw	s2,s2,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd27f2e3          	bgeu	a5,s2,1408 <pipe1+0x40>
        cc = sizeof(buf);
    1448:	893e                	mv	s2,a5
    144a:	bf7d                	j	1408 <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	e0ca                	sd	s2,64(sp)
    1450:	fc4e                	sd	s3,56(sp)
    1452:	f852                	sd	s4,48(sp)
    1454:	f456                	sd	s5,40(sp)
    1456:	f05a                	sd	s6,32(sp)
    1458:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85e2                	mv	a1,s8
    145c:	00005517          	auipc	a0,0x5
    1460:	b2450513          	addi	a0,a0,-1244 # 5f80 <malloc+0xa4e>
    1464:	016040ef          	jal	547a <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	3bb030ef          	jal	5024 <exit>
    146e:	e0ca                	sd	s2,64(sp)
    1470:	f852                	sd	s4,48(sp)
    1472:	f456                	sd	s5,40(sp)
    1474:	f05a                	sd	s6,32(sp)
    1476:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	3d1030ef          	jal	504c <close>
    for (n = 0; n < N; n++) {
    1480:	0000bb17          	auipc	s6,0xb
    1484:	838b0b13          	addi	s6,s6,-1992 # bcb8 <buf>
    1488:	416004bb          	negw	s1,s6
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a13          	li	s4,1033
    1498:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    149a:	6a85                	lui	s5,0x1
    149c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0x65>
{
    14a0:	87da                	mv	a5,s6
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x476>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff279be3          	bne	a5,s2,14a2 <pipe1+0xda>
      if (write(fds[1], buf, SZ) != SZ) {
    14b0:	8652                	mv	a2,s4
    14b2:	85de                	mv	a1,s7
    14b4:	fac42503          	lw	a0,-84(s0)
    14b8:	38d030ef          	jal	5044 <write>
    14bc:	01451c63          	bne	a0,s4,14d4 <pipe1+0x10c>
    14c0:	4099899b          	addiw	s3,s3,1033
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd599be3          	bne	s3,s5,14a0 <pipe1+0xd8>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	355030ef          	jal	5024 <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85e2                	mv	a1,s8
    14d6:	00005517          	auipc	a0,0x5
    14da:	ac250513          	addi	a0,a0,-1342 # 5f98 <malloc+0xa66>
    14de:	79d030ef          	jal	547a <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	341030ef          	jal	5024 <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85e2                	mv	a1,s8
    14ea:	00005517          	auipc	a0,0x5
    14ee:	ac650513          	addi	a0,a0,-1338 # 5fb0 <malloc+0xa7e>
    14f2:	789030ef          	jal	547a <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	6906                	ld	s2,64(sp)
    14fa:	79e2                	ld	s3,56(sp)
    14fc:	7a42                	ld	s4,48(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6c42                	ld	s8,16(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x65>
    150e:	02f98063          	beq	s3,a5,152e <pipe1+0x166>
    1512:	f456                	sd	s5,40(sp)
    1514:	f05a                	sd	s6,32(sp)
    1516:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	864e                	mv	a2,s3
    151a:	85e2                	mv	a1,s8
    151c:	00005517          	auipc	a0,0x5
    1520:	aac50513          	addi	a0,a0,-1364 # 5fc8 <malloc+0xa96>
    1524:	757030ef          	jal	547a <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	2fb030ef          	jal	5024 <exit>
    152e:	f456                	sd	s5,40(sp)
    1530:	f05a                	sd	s6,32(sp)
    1532:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	315030ef          	jal	504c <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	2ed030ef          	jal	502c <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	2dd030ef          	jal	5024 <exit>
    154c:	e0ca                	sd	s2,64(sp)
    154e:	f852                	sd	s4,48(sp)
    1550:	f456                	sd	s5,40(sp)
    1552:	f05a                	sd	s6,32(sp)
    1554:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1556:	85e2                	mv	a1,s8
    1558:	00005517          	auipc	a0,0x5
    155c:	a9050513          	addi	a0,a0,-1392 # 5fe8 <malloc+0xab6>
    1560:	71b030ef          	jal	547a <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	2bf030ef          	jal	5024 <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	295030ef          	jal	501c <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	297030ef          	jal	502c <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	93850513          	addi	a0,a0,-1736 # 5ef8 <malloc+0x9c6>
    15c8:	6b3030ef          	jal	547a <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	257030ef          	jal	5024 <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	a2c50513          	addi	a0,a0,-1492 # 6000 <malloc+0xace>
    15dc:	69f030ef          	jal	547a <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	243030ef          	jal	5024 <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	a3050513          	addi	a0,a0,-1488 # 6018 <malloc+0xae6>
    15f0:	68b030ef          	jal	547a <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	22f030ef          	jal	5024 <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	229030ef          	jal	5024 <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	20b030ef          	jal	501c <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	201030ef          	jal	501c <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	205030ef          	jal	502c <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	1ff030ef          	jal	502c <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	8b450513          	addi	a0,a0,-1868 # 5ef8 <malloc+0x9c6>
    164c:	62f030ef          	jal	547a <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	1d3030ef          	jal	5024 <exit>
      exit(0);
    1656:	1cf030ef          	jal	5024 <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	89c50513          	addi	a0,a0,-1892 # 5ef8 <malloc+0x9c6>
    1664:	617030ef          	jal	547a <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	1bb030ef          	jal	5024 <exit>
        exit(0);
    166e:	1b7030ef          	jal	5024 <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	19f030ef          	jal	501c <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	195030ef          	jal	501c <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	197030ef          	jal	502c <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	189030ef          	jal	502c <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	97e50513          	addi	a0,a0,-1666 # 6038 <malloc+0xb06>
    16c2:	5b9030ef          	jal	547a <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	15d030ef          	jal	5024 <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	14d030ef          	jal	501c <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	151030ef          	jal	502c <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	13f030ef          	jal	5024 <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	139030ef          	jal	5024 <exit>
          exit(0);
    16f0:	135030ef          	jal	5024 <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	95250513          	addi	a0,a0,-1710 # 6048 <malloc+0xb16>
    16fe:	57d030ef          	jal	547a <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	121030ef          	jal	5024 <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	107030ef          	jal	501c <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	10b030ef          	jal	502c <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	0f9030ef          	jal	5024 <exit>
      printf("fork failed\n");
    1730:	00006517          	auipc	a0,0x6
    1734:	da050513          	addi	a0,a0,-608 # 74d0 <malloc+0x1f9e>
    1738:	543030ef          	jal	547a <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	0e7030ef          	jal	5024 <exit>
      fork();
    1742:	0db030ef          	jal	501c <fork>
      fork();
    1746:	0d7030ef          	jal	501c <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	0d9030ef          	jal	5024 <exit>

0000000000001750 <createdelete>:
{
    1750:	7135                	addi	sp,sp,-160
    1752:	ed06                	sd	ra,152(sp)
    1754:	e922                	sd	s0,144(sp)
    1756:	e526                	sd	s1,136(sp)
    1758:	e14a                	sd	s2,128(sp)
    175a:	fcce                	sd	s3,120(sp)
    175c:	f8d2                	sd	s4,112(sp)
    175e:	f4d6                	sd	s5,104(sp)
    1760:	f0da                	sd	s6,96(sp)
    1762:	ecde                	sd	s7,88(sp)
    1764:	e8e2                	sd	s8,80(sp)
    1766:	e4e6                	sd	s9,72(sp)
    1768:	e0ea                	sd	s10,64(sp)
    176a:	fc6e                	sd	s11,56(sp)
    176c:	1100                	addi	s0,sp,160
    176e:	8daa                	mv	s11,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1770:	4901                	li	s2,0
    1772:	4991                	li	s3,4
    pid = fork();
    1774:	0a9030ef          	jal	501c <fork>
    1778:	84aa                	mv	s1,a0
    if (pid < 0) {
    177a:	04054063          	bltz	a0,17ba <createdelete+0x6a>
    if (pid == 0) {
    177e:	c921                	beqz	a0,17ce <createdelete+0x7e>
  for (pi = 0; pi < NCHILD; pi++) {
    1780:	2905                	addiw	s2,s2,1
    1782:	ff3919e3          	bne	s2,s3,1774 <createdelete+0x24>
    1786:	4491                	li	s1,4
    wait(&xstatus);
    1788:	f6c40913          	addi	s2,s0,-148
    178c:	854a                	mv	a0,s2
    178e:	09f030ef          	jal	502c <wait>
    if (xstatus != 0)
    1792:	f6c42a83          	lw	s5,-148(s0)
    1796:	0c0a9263          	bnez	s5,185a <createdelete+0x10a>
  for (pi = 0; pi < NCHILD; pi++) {
    179a:	34fd                	addiw	s1,s1,-1
    179c:	f8e5                	bnez	s1,178c <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    179e:	f6040923          	sb	zero,-142(s0)
    17a2:	03000913          	li	s2,48
    17a6:	5a7d                	li	s4,-1
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17a8:	4d25                	li	s10,9
    17aa:	07000c93          	li	s9,112
      fd = open(name, 0);
    17ae:	f7040c13          	addi	s8,s0,-144
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17b2:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    17b4:	07400b13          	li	s6,116
    17b8:	aa39                	j	18d6 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    17ba:	85ee                	mv	a1,s11
    17bc:	00004517          	auipc	a0,0x4
    17c0:	73c50513          	addi	a0,a0,1852 # 5ef8 <malloc+0x9c6>
    17c4:	4b7030ef          	jal	547a <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	05b030ef          	jal	5024 <exit>
      name[0] = 'p' + pi;
    17ce:	0709091b          	addiw	s2,s2,112
    17d2:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    17d6:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17da:	f7040913          	addi	s2,s0,-144
    17de:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17e2:	4a51                	li	s4,20
    17e4:	a815                	j	1818 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    17e6:	85ee                	mv	a1,s11
    17e8:	00005517          	auipc	a0,0x5
    17ec:	88050513          	addi	a0,a0,-1920 # 6068 <malloc+0xb36>
    17f0:	48b030ef          	jal	547a <printf>
          exit(1);
    17f4:	4505                	li	a0,1
    17f6:	02f030ef          	jal	5024 <exit>
          name[1] = '0' + (i / 2);
    17fa:	01f4d79b          	srliw	a5,s1,0x1f
    17fe:	9fa5                	addw	a5,a5,s1
    1800:	4017d79b          	sraiw	a5,a5,0x1
    1804:	0307879b          	addiw	a5,a5,48
    1808:	f6f408a3          	sb	a5,-143(s0)
          if (unlink(name) < 0) {
    180c:	854a                	mv	a0,s2
    180e:	067030ef          	jal	5074 <unlink>
    1812:	02054a63          	bltz	a0,1846 <createdelete+0xf6>
      for (i = 0; i < N; i++) {
    1816:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1818:	0304879b          	addiw	a5,s1,48
    181c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1820:	85ce                	mv	a1,s3
    1822:	854a                	mv	a0,s2
    1824:	041030ef          	jal	5064 <open>
        if (fd < 0) {
    1828:	fa054fe3          	bltz	a0,17e6 <createdelete+0x96>
        close(fd);
    182c:	021030ef          	jal	504c <close>
        if (i > 0 && (i % 2) == 0) {
    1830:	fe9053e3          	blez	s1,1816 <createdelete+0xc6>
    1834:	0014f793          	andi	a5,s1,1
    1838:	d3e9                	beqz	a5,17fa <createdelete+0xaa>
      for (i = 0; i < N; i++) {
    183a:	2485                	addiw	s1,s1,1
    183c:	fd449ee3          	bne	s1,s4,1818 <createdelete+0xc8>
      exit(0);
    1840:	4501                	li	a0,0
    1842:	7e2030ef          	jal	5024 <exit>
            printf("%s: unlink failed\n", s);
    1846:	85ee                	mv	a1,s11
    1848:	00005517          	auipc	a0,0x5
    184c:	83850513          	addi	a0,a0,-1992 # 6080 <malloc+0xb4e>
    1850:	42b030ef          	jal	547a <printf>
            exit(1);
    1854:	4505                	li	a0,1
    1856:	7ce030ef          	jal	5024 <exit>
      exit(1);
    185a:	4505                	li	a0,1
    185c:	7c8030ef          	jal	5024 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1860:	054bf263          	bgeu	s7,s4,18a4 <createdelete+0x154>
      if (fd >= 0)
    1864:	04055e63          	bgez	a0,18c0 <createdelete+0x170>
    for (pi = 0; pi < NCHILD; pi++) {
    1868:	2485                	addiw	s1,s1,1
    186a:	0ff4f493          	zext.b	s1,s1
    186e:	05648c63          	beq	s1,s6,18c6 <createdelete+0x176>
      name[0] = 'p' + pi;
    1872:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1876:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    187a:	4581                	li	a1,0
    187c:	8562                	mv	a0,s8
    187e:	7e6030ef          	jal	5064 <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1882:	01f5579b          	srliw	a5,a0,0x1f
    1886:	dfe9                	beqz	a5,1860 <createdelete+0x110>
    1888:	fc098ce3          	beqz	s3,1860 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    188c:	f7040613          	addi	a2,s0,-144
    1890:	85ee                	mv	a1,s11
    1892:	00005517          	auipc	a0,0x5
    1896:	80650513          	addi	a0,a0,-2042 # 6098 <malloc+0xb66>
    189a:	3e1030ef          	jal	547a <printf>
        exit(1);
    189e:	4505                	li	a0,1
    18a0:	784030ef          	jal	5024 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18a4:	fc0542e3          	bltz	a0,1868 <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    18a8:	f7040613          	addi	a2,s0,-144
    18ac:	85ee                	mv	a1,s11
    18ae:	00005517          	auipc	a0,0x5
    18b2:	81250513          	addi	a0,a0,-2030 # 60c0 <malloc+0xb8e>
    18b6:	3c5030ef          	jal	547a <printf>
        exit(1);
    18ba:	4505                	li	a0,1
    18bc:	768030ef          	jal	5024 <exit>
        close(fd);
    18c0:	78c030ef          	jal	504c <close>
    18c4:	b755                	j	1868 <createdelete+0x118>
  for (i = 0; i < N; i++) {
    18c6:	2a85                	addiw	s5,s5,1
    18c8:	2a05                	addiw	s4,s4,1
    18ca:	2905                	addiw	s2,s2,1
    18cc:	0ff97913          	zext.b	s2,s2
    18d0:	47d1                	li	a5,20
    18d2:	00fa8a63          	beq	s5,a5,18e6 <createdelete+0x196>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18d6:	001ab993          	seqz	s3,s5
    18da:	015d27b3          	slt	a5,s10,s5
    18de:	00f9e9b3          	or	s3,s3,a5
    18e2:	84e6                	mv	s1,s9
    18e4:	b779                	j	1872 <createdelete+0x122>
    18e6:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18ea:	07000b13          	li	s6,112
      unlink(name);
    18ee:	f7040a13          	addi	s4,s0,-144
    for (pi = 0; pi < NCHILD; pi++) {
    18f2:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18f6:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18fa:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18fc:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1900:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1904:	8552                	mv	a0,s4
    1906:	76e030ef          	jal	5074 <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    190a:	2485                	addiw	s1,s1,1
    190c:	0ff4f493          	zext.b	s1,s1
    1910:	ff3496e3          	bne	s1,s3,18fc <createdelete+0x1ac>
  for (i = 0; i < N; i++) {
    1914:	2905                	addiw	s2,s2,1
    1916:	0ff97913          	zext.b	s2,s2
    191a:	ff5910e3          	bne	s2,s5,18fa <createdelete+0x1aa>
}
    191e:	60ea                	ld	ra,152(sp)
    1920:	644a                	ld	s0,144(sp)
    1922:	64aa                	ld	s1,136(sp)
    1924:	690a                	ld	s2,128(sp)
    1926:	79e6                	ld	s3,120(sp)
    1928:	7a46                	ld	s4,112(sp)
    192a:	7aa6                	ld	s5,104(sp)
    192c:	7b06                	ld	s6,96(sp)
    192e:	6be6                	ld	s7,88(sp)
    1930:	6c46                	ld	s8,80(sp)
    1932:	6ca6                	ld	s9,72(sp)
    1934:	6d06                	ld	s10,64(sp)
    1936:	7de2                	ld	s11,56(sp)
    1938:	610d                	addi	sp,sp,160
    193a:	8082                	ret

000000000000193c <linkunlink>:
{
    193c:	711d                	addi	sp,sp,-96
    193e:	ec86                	sd	ra,88(sp)
    1940:	e8a2                	sd	s0,80(sp)
    1942:	e4a6                	sd	s1,72(sp)
    1944:	e0ca                	sd	s2,64(sp)
    1946:	fc4e                	sd	s3,56(sp)
    1948:	f852                	sd	s4,48(sp)
    194a:	f456                	sd	s5,40(sp)
    194c:	f05a                	sd	s6,32(sp)
    194e:	ec5e                	sd	s7,24(sp)
    1950:	e862                	sd	s8,16(sp)
    1952:	e466                	sd	s9,8(sp)
    1954:	e06a                	sd	s10,0(sp)
    1956:	1080                	addi	s0,sp,96
    1958:	84aa                	mv	s1,a0
  unlink("x");
    195a:	00004517          	auipc	a0,0x4
    195e:	d7e50513          	addi	a0,a0,-642 # 56d8 <malloc+0x1a6>
    1962:	712030ef          	jal	5074 <unlink>
  pid = fork();
    1966:	6b6030ef          	jal	501c <fork>
  if (pid < 0) {
    196a:	04054363          	bltz	a0,19b0 <linkunlink+0x74>
    196e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1970:	06100913          	li	s2,97
    1974:	c111                	beqz	a0,1978 <linkunlink+0x3c>
    1976:	4905                	li	s2,1
    1978:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    197c:	41c65ab7          	lui	s5,0x41c65
    1980:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c561b5>
    1984:	6a0d                	lui	s4,0x3
    1986:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4af>
    if ((x % 3) == 0) {
    198a:	000ab9b7          	lui	s3,0xab
    198e:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9bdf3>
    1992:	09b2                	slli	s3,s3,0xc
    1994:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    1998:	4b85                	li	s7,1
      unlink("x");
    199a:	00004b17          	auipc	s6,0x4
    199e:	d3eb0b13          	addi	s6,s6,-706 # 56d8 <malloc+0x1a6>
      link("cat", "x");
    19a2:	00004c97          	auipc	s9,0x4
    19a6:	746c8c93          	addi	s9,s9,1862 # 60e8 <malloc+0xbb6>
      close(open("x", O_RDWR | O_CREATE));
    19aa:	20200c13          	li	s8,514
    19ae:	a03d                	j	19dc <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    19b0:	85a6                	mv	a1,s1
    19b2:	00004517          	auipc	a0,0x4
    19b6:	54650513          	addi	a0,a0,1350 # 5ef8 <malloc+0x9c6>
    19ba:	2c1030ef          	jal	547a <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	664030ef          	jal	5024 <exit>
      close(open("x", O_RDWR | O_CREATE));
    19c4:	85e2                	mv	a1,s8
    19c6:	855a                	mv	a0,s6
    19c8:	69c030ef          	jal	5064 <open>
    19cc:	680030ef          	jal	504c <close>
    19d0:	a021                	j	19d8 <linkunlink+0x9c>
      unlink("x");
    19d2:	855a                	mv	a0,s6
    19d4:	6a0030ef          	jal	5074 <unlink>
  for (i = 0; i < 100; i++) {
    19d8:	34fd                	addiw	s1,s1,-1
    19da:	c885                	beqz	s1,1a0a <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    19dc:	035907bb          	mulw	a5,s2,s5
    19e0:	00fa07bb          	addw	a5,s4,a5
    19e4:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19e6:	02079713          	slli	a4,a5,0x20
    19ea:	9301                	srli	a4,a4,0x20
    19ec:	03370733          	mul	a4,a4,s3
    19f0:	9305                	srli	a4,a4,0x21
    19f2:	0017169b          	slliw	a3,a4,0x1
    19f6:	9f35                	addw	a4,a4,a3
    19f8:	9f99                	subw	a5,a5,a4
    19fa:	d7e9                	beqz	a5,19c4 <linkunlink+0x88>
    } else if ((x % 3) == 1) {
    19fc:	fd779be3          	bne	a5,s7,19d2 <linkunlink+0x96>
      link("cat", "x");
    1a00:	85da                	mv	a1,s6
    1a02:	8566                	mv	a0,s9
    1a04:	680030ef          	jal	5084 <link>
    1a08:	bfc1                	j	19d8 <linkunlink+0x9c>
  if (pid)
    1a0a:	020d0363          	beqz	s10,1a30 <linkunlink+0xf4>
    wait(0);
    1a0e:	4501                	li	a0,0
    1a10:	61c030ef          	jal	502c <wait>
}
    1a14:	60e6                	ld	ra,88(sp)
    1a16:	6446                	ld	s0,80(sp)
    1a18:	64a6                	ld	s1,72(sp)
    1a1a:	6906                	ld	s2,64(sp)
    1a1c:	79e2                	ld	s3,56(sp)
    1a1e:	7a42                	ld	s4,48(sp)
    1a20:	7aa2                	ld	s5,40(sp)
    1a22:	7b02                	ld	s6,32(sp)
    1a24:	6be2                	ld	s7,24(sp)
    1a26:	6c42                	ld	s8,16(sp)
    1a28:	6ca2                	ld	s9,8(sp)
    1a2a:	6d02                	ld	s10,0(sp)
    1a2c:	6125                	addi	sp,sp,96
    1a2e:	8082                	ret
    exit(0);
    1a30:	4501                	li	a0,0
    1a32:	5f2030ef          	jal	5024 <exit>

0000000000001a36 <forktest>:
{
    1a36:	7179                	addi	sp,sp,-48
    1a38:	f406                	sd	ra,40(sp)
    1a3a:	f022                	sd	s0,32(sp)
    1a3c:	ec26                	sd	s1,24(sp)
    1a3e:	e84a                	sd	s2,16(sp)
    1a40:	e44e                	sd	s3,8(sp)
    1a42:	1800                	addi	s0,sp,48
    1a44:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a46:	4481                	li	s1,0
    1a48:	3e800913          	li	s2,1000
    pid = fork();
    1a4c:	5d0030ef          	jal	501c <fork>
    if (pid < 0)
    1a50:	06054063          	bltz	a0,1ab0 <forktest+0x7a>
    if (pid == 0)
    1a54:	cd11                	beqz	a0,1a70 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a56:	2485                	addiw	s1,s1,1
    1a58:	ff249ae3          	bne	s1,s2,1a4c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a5c:	85ce                	mv	a1,s3
    1a5e:	00004517          	auipc	a0,0x4
    1a62:	6da50513          	addi	a0,a0,1754 # 6138 <malloc+0xc06>
    1a66:	215030ef          	jal	547a <printf>
    exit(1);
    1a6a:	4505                	li	a0,1
    1a6c:	5b8030ef          	jal	5024 <exit>
      exit(0);
    1a70:	5b4030ef          	jal	5024 <exit>
    printf("%s: no fork at all!\n", s);
    1a74:	85ce                	mv	a1,s3
    1a76:	00004517          	auipc	a0,0x4
    1a7a:	67a50513          	addi	a0,a0,1658 # 60f0 <malloc+0xbbe>
    1a7e:	1fd030ef          	jal	547a <printf>
    exit(1);
    1a82:	4505                	li	a0,1
    1a84:	5a0030ef          	jal	5024 <exit>
      printf("%s: wait stopped early\n", s);
    1a88:	85ce                	mv	a1,s3
    1a8a:	00004517          	auipc	a0,0x4
    1a8e:	67e50513          	addi	a0,a0,1662 # 6108 <malloc+0xbd6>
    1a92:	1e9030ef          	jal	547a <printf>
      exit(1);
    1a96:	4505                	li	a0,1
    1a98:	58c030ef          	jal	5024 <exit>
    printf("%s: wait got too many\n", s);
    1a9c:	85ce                	mv	a1,s3
    1a9e:	00004517          	auipc	a0,0x4
    1aa2:	68250513          	addi	a0,a0,1666 # 6120 <malloc+0xbee>
    1aa6:	1d5030ef          	jal	547a <printf>
    exit(1);
    1aaa:	4505                	li	a0,1
    1aac:	578030ef          	jal	5024 <exit>
  if (n == 0) {
    1ab0:	d0f1                	beqz	s1,1a74 <forktest+0x3e>
  for (; n > 0; n--) {
    1ab2:	00905963          	blez	s1,1ac4 <forktest+0x8e>
    if (wait(0) < 0) {
    1ab6:	4501                	li	a0,0
    1ab8:	574030ef          	jal	502c <wait>
    1abc:	fc0546e3          	bltz	a0,1a88 <forktest+0x52>
  for (; n > 0; n--) {
    1ac0:	34fd                	addiw	s1,s1,-1
    1ac2:	f8f5                	bnez	s1,1ab6 <forktest+0x80>
  if (wait(0) != -1) {
    1ac4:	4501                	li	a0,0
    1ac6:	566030ef          	jal	502c <wait>
    1aca:	57fd                	li	a5,-1
    1acc:	fcf518e3          	bne	a0,a5,1a9c <forktest+0x66>
}
    1ad0:	70a2                	ld	ra,40(sp)
    1ad2:	7402                	ld	s0,32(sp)
    1ad4:	64e2                	ld	s1,24(sp)
    1ad6:	6942                	ld	s2,16(sp)
    1ad8:	69a2                	ld	s3,8(sp)
    1ada:	6145                	addi	sp,sp,48
    1adc:	8082                	ret

0000000000001ade <kernmem>:
{
    1ade:	715d                	addi	sp,sp,-80
    1ae0:	e486                	sd	ra,72(sp)
    1ae2:	e0a2                	sd	s0,64(sp)
    1ae4:	fc26                	sd	s1,56(sp)
    1ae6:	f84a                	sd	s2,48(sp)
    1ae8:	f44e                	sd	s3,40(sp)
    1aea:	f052                	sd	s4,32(sp)
    1aec:	ec56                	sd	s5,24(sp)
    1aee:	e85a                	sd	s6,16(sp)
    1af0:	0880                	addi	s0,sp,80
    1af2:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1af4:	4485                	li	s1,1
    1af6:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1af8:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1afc:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1afe:	69b1                	lui	s3,0xc
    1b00:	35098993          	addi	s3,s3,848 # c350 <buf+0x698>
    1b04:	1003d937          	lui	s2,0x1003d
    1b08:	090e                	slli	s2,s2,0x3
    1b0a:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e7c8>
    pid = fork();
    1b0e:	50e030ef          	jal	501c <fork>
    if (pid < 0) {
    1b12:	02054763          	bltz	a0,1b40 <kernmem+0x62>
    if (pid == 0) {
    1b16:	cd1d                	beqz	a0,1b54 <kernmem+0x76>
    wait(&xstatus);
    1b18:	8556                	mv	a0,s5
    1b1a:	512030ef          	jal	502c <wait>
    if (xstatus != -1) // did kernel kill child?
    1b1e:	fbc42783          	lw	a5,-68(s0)
    1b22:	05479663          	bne	a5,s4,1b6e <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b26:	94ce                	add	s1,s1,s3
    1b28:	ff2493e3          	bne	s1,s2,1b0e <kernmem+0x30>
}
    1b2c:	60a6                	ld	ra,72(sp)
    1b2e:	6406                	ld	s0,64(sp)
    1b30:	74e2                	ld	s1,56(sp)
    1b32:	7942                	ld	s2,48(sp)
    1b34:	79a2                	ld	s3,40(sp)
    1b36:	7a02                	ld	s4,32(sp)
    1b38:	6ae2                	ld	s5,24(sp)
    1b3a:	6b42                	ld	s6,16(sp)
    1b3c:	6161                	addi	sp,sp,80
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85da                	mv	a1,s6
    1b42:	00004517          	auipc	a0,0x4
    1b46:	3b650513          	addi	a0,a0,950 # 5ef8 <malloc+0x9c6>
    1b4a:	131030ef          	jal	547a <printf>
      exit(1);
    1b4e:	4505                	li	a0,1
    1b50:	4d4030ef          	jal	5024 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b54:	0004c683          	lbu	a3,0(s1)
    1b58:	8626                	mv	a2,s1
    1b5a:	85da                	mv	a1,s6
    1b5c:	00004517          	auipc	a0,0x4
    1b60:	60450513          	addi	a0,a0,1540 # 6160 <malloc+0xc2e>
    1b64:	117030ef          	jal	547a <printf>
      exit(1);
    1b68:	4505                	li	a0,1
    1b6a:	4ba030ef          	jal	5024 <exit>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	4b4030ef          	jal	5024 <exit>

0000000000001b74 <MAXVAplus>:
{
    1b74:	7139                	addi	sp,sp,-64
    1b76:	fc06                	sd	ra,56(sp)
    1b78:	f822                	sd	s0,48(sp)
    1b7a:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b7c:	4785                	li	a5,1
    1b7e:	179a                	slli	a5,a5,0x26
    1b80:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b84:	fc843783          	ld	a5,-56(s0)
    1b88:	cf9d                	beqz	a5,1bc6 <MAXVAplus+0x52>
    1b8a:	f426                	sd	s1,40(sp)
    1b8c:	f04a                	sd	s2,32(sp)
    1b8e:	ec4e                	sd	s3,24(sp)
    1b90:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b92:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b96:	54fd                	li	s1,-1
    pid = fork();
    1b98:	484030ef          	jal	501c <fork>
    if (pid < 0) {
    1b9c:	02054963          	bltz	a0,1bce <MAXVAplus+0x5a>
    if (pid == 0) {
    1ba0:	c129                	beqz	a0,1be2 <MAXVAplus+0x6e>
    wait(&xstatus);
    1ba2:	854a                	mv	a0,s2
    1ba4:	488030ef          	jal	502c <wait>
    if (xstatus != -1) // did kernel kill child?
    1ba8:	fc442783          	lw	a5,-60(s0)
    1bac:	04979d63          	bne	a5,s1,1c06 <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1bb0:	fc843783          	ld	a5,-56(s0)
    1bb4:	0786                	slli	a5,a5,0x1
    1bb6:	fcf43423          	sd	a5,-56(s0)
    1bba:	fc843783          	ld	a5,-56(s0)
    1bbe:	ffe9                	bnez	a5,1b98 <MAXVAplus+0x24>
    1bc0:	74a2                	ld	s1,40(sp)
    1bc2:	7902                	ld	s2,32(sp)
    1bc4:	69e2                	ld	s3,24(sp)
}
    1bc6:	70e2                	ld	ra,56(sp)
    1bc8:	7442                	ld	s0,48(sp)
    1bca:	6121                	addi	sp,sp,64
    1bcc:	8082                	ret
      printf("%s: fork failed\n", s);
    1bce:	85ce                	mv	a1,s3
    1bd0:	00004517          	auipc	a0,0x4
    1bd4:	32850513          	addi	a0,a0,808 # 5ef8 <malloc+0x9c6>
    1bd8:	0a3030ef          	jal	547a <printf>
      exit(1);
    1bdc:	4505                	li	a0,1
    1bde:	446030ef          	jal	5024 <exit>
      *(char *)a = 99;
    1be2:	fc843783          	ld	a5,-56(s0)
    1be6:	06300713          	li	a4,99
    1bea:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bee:	fc843603          	ld	a2,-56(s0)
    1bf2:	85ce                	mv	a1,s3
    1bf4:	00004517          	auipc	a0,0x4
    1bf8:	58c50513          	addi	a0,a0,1420 # 6180 <malloc+0xc4e>
    1bfc:	07f030ef          	jal	547a <printf>
      exit(1);
    1c00:	4505                	li	a0,1
    1c02:	422030ef          	jal	5024 <exit>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	41c030ef          	jal	5024 <exit>

0000000000001c0c <stacktest>:
{
    1c0c:	7179                	addi	sp,sp,-48
    1c0e:	f406                	sd	ra,40(sp)
    1c10:	f022                	sd	s0,32(sp)
    1c12:	ec26                	sd	s1,24(sp)
    1c14:	1800                	addi	s0,sp,48
    1c16:	84aa                	mv	s1,a0
  pid = fork();
    1c18:	404030ef          	jal	501c <fork>
  if (pid == 0) {
    1c1c:	cd11                	beqz	a0,1c38 <stacktest+0x2c>
  } else if (pid < 0) {
    1c1e:	02054c63          	bltz	a0,1c56 <stacktest+0x4a>
  wait(&xstatus);
    1c22:	fdc40513          	addi	a0,s0,-36
    1c26:	406030ef          	jal	502c <wait>
  if (xstatus == -1) // kernel killed child?
    1c2a:	fdc42503          	lw	a0,-36(s0)
    1c2e:	57fd                	li	a5,-1
    1c30:	02f50d63          	beq	a0,a5,1c6a <stacktest+0x5e>
    exit(xstatus);
    1c34:	3f0030ef          	jal	5024 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c38:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c3a:	80078793          	addi	a5,a5,-2048
    1c3e:	8007c603          	lbu	a2,-2048(a5)
    1c42:	85a6                	mv	a1,s1
    1c44:	00004517          	auipc	a0,0x4
    1c48:	55450513          	addi	a0,a0,1364 # 6198 <malloc+0xc66>
    1c4c:	02f030ef          	jal	547a <printf>
    exit(1);
    1c50:	4505                	li	a0,1
    1c52:	3d2030ef          	jal	5024 <exit>
    printf("%s: fork failed\n", s);
    1c56:	85a6                	mv	a1,s1
    1c58:	00004517          	auipc	a0,0x4
    1c5c:	2a050513          	addi	a0,a0,672 # 5ef8 <malloc+0x9c6>
    1c60:	01b030ef          	jal	547a <printf>
    exit(1);
    1c64:	4505                	li	a0,1
    1c66:	3be030ef          	jal	5024 <exit>
    exit(0);
    1c6a:	4501                	li	a0,0
    1c6c:	3b8030ef          	jal	5024 <exit>

0000000000001c70 <nowrite>:
{
    1c70:	7159                	addi	sp,sp,-112
    1c72:	f486                	sd	ra,104(sp)
    1c74:	f0a2                	sd	s0,96(sp)
    1c76:	eca6                	sd	s1,88(sp)
    1c78:	e8ca                	sd	s2,80(sp)
    1c7a:	e4ce                	sd	s3,72(sp)
    1c7c:	e0d2                	sd	s4,64(sp)
    1c7e:	1880                	addi	s0,sp,112
    1c80:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c82:	00006797          	auipc	a5,0x6
    1c86:	f5e78793          	addi	a5,a5,-162 # 7be0 <malloc+0x26ae>
    1c8a:	7788                	ld	a0,40(a5)
    1c8c:	7b8c                	ld	a1,48(a5)
    1c8e:	7f90                	ld	a2,56(a5)
    1c90:	63b4                	ld	a3,64(a5)
    1c92:	67b8                	ld	a4,72(a5)
    1c94:	f8a43c23          	sd	a0,-104(s0)
    1c98:	fab43023          	sd	a1,-96(s0)
    1c9c:	fac43423          	sd	a2,-88(s0)
    1ca0:	fad43823          	sd	a3,-80(s0)
    1ca4:	fae43c23          	sd	a4,-72(s0)
    1ca8:	6bbc                	ld	a5,80(a5)
    1caa:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cae:	4481                	li	s1,0
    wait(&xstatus);
    1cb0:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cb4:	4999                	li	s3,6
    pid = fork();
    1cb6:	366030ef          	jal	501c <fork>
    if (pid == 0) {
    1cba:	cd19                	beqz	a0,1cd8 <nowrite+0x68>
    } else if (pid < 0) {
    1cbc:	04054163          	bltz	a0,1cfe <nowrite+0x8e>
    wait(&xstatus);
    1cc0:	854a                	mv	a0,s2
    1cc2:	36a030ef          	jal	502c <wait>
    if (xstatus == 0) {
    1cc6:	fcc42783          	lw	a5,-52(s0)
    1cca:	c7a1                	beqz	a5,1d12 <nowrite+0xa2>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1ccc:	2485                	addiw	s1,s1,1
    1cce:	ff3494e3          	bne	s1,s3,1cb6 <nowrite+0x46>
  exit(0);
    1cd2:	4501                	li	a0,0
    1cd4:	350030ef          	jal	5024 <exit>
      volatile int *addr = (int *)addrs[ai];
    1cd8:	048e                	slli	s1,s1,0x3
    1cda:	fd048793          	addi	a5,s1,-48
    1cde:	008784b3          	add	s1,a5,s0
    1ce2:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1ce6:	47a9                	li	a5,10
    1ce8:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cea:	85d2                	mv	a1,s4
    1cec:	00004517          	auipc	a0,0x4
    1cf0:	4d450513          	addi	a0,a0,1236 # 61c0 <malloc+0xc8e>
    1cf4:	786030ef          	jal	547a <printf>
      exit(0);
    1cf8:	4501                	li	a0,0
    1cfa:	32a030ef          	jal	5024 <exit>
      printf("%s: fork failed\n", s);
    1cfe:	85d2                	mv	a1,s4
    1d00:	00004517          	auipc	a0,0x4
    1d04:	1f850513          	addi	a0,a0,504 # 5ef8 <malloc+0x9c6>
    1d08:	772030ef          	jal	547a <printf>
      exit(1);
    1d0c:	4505                	li	a0,1
    1d0e:	316030ef          	jal	5024 <exit>
      exit(1);
    1d12:	4505                	li	a0,1
    1d14:	310030ef          	jal	5024 <exit>

0000000000001d18 <manywrites>:
{
    1d18:	7159                	addi	sp,sp,-112
    1d1a:	f486                	sd	ra,104(sp)
    1d1c:	f0a2                	sd	s0,96(sp)
    1d1e:	eca6                	sd	s1,88(sp)
    1d20:	e8ca                	sd	s2,80(sp)
    1d22:	e4ce                	sd	s3,72(sp)
    1d24:	ec66                	sd	s9,24(sp)
    1d26:	1880                	addi	s0,sp,112
    1d28:	8caa                	mv	s9,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d2a:	4901                	li	s2,0
    1d2c:	4991                	li	s3,4
    int pid = fork();
    1d2e:	2ee030ef          	jal	501c <fork>
    1d32:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d34:	02054c63          	bltz	a0,1d6c <manywrites+0x54>
    if (pid == 0) {
    1d38:	c929                	beqz	a0,1d8a <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    1d3a:	2905                	addiw	s2,s2,1
    1d3c:	ff3919e3          	bne	s2,s3,1d2e <manywrites+0x16>
    1d40:	4491                	li	s1,4
    wait(&st);
    1d42:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d46:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d4a:	854a                	mv	a0,s2
    1d4c:	2e0030ef          	jal	502c <wait>
    if (st != 0)
    1d50:	f9842503          	lw	a0,-104(s0)
    1d54:	0e051763          	bnez	a0,1e42 <manywrites+0x12a>
  for (int ci = 0; ci < nchildren; ci++) {
    1d58:	34fd                	addiw	s1,s1,-1
    1d5a:	f4f5                	bnez	s1,1d46 <manywrites+0x2e>
    1d5c:	e0d2                	sd	s4,64(sp)
    1d5e:	fc56                	sd	s5,56(sp)
    1d60:	f85a                	sd	s6,48(sp)
    1d62:	f45e                	sd	s7,40(sp)
    1d64:	f062                	sd	s8,32(sp)
    1d66:	e86a                	sd	s10,16(sp)
  exit(0);
    1d68:	2bc030ef          	jal	5024 <exit>
    1d6c:	e0d2                	sd	s4,64(sp)
    1d6e:	fc56                	sd	s5,56(sp)
    1d70:	f85a                	sd	s6,48(sp)
    1d72:	f45e                	sd	s7,40(sp)
    1d74:	f062                	sd	s8,32(sp)
    1d76:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d78:	00005517          	auipc	a0,0x5
    1d7c:	75850513          	addi	a0,a0,1880 # 74d0 <malloc+0x1f9e>
    1d80:	6fa030ef          	jal	547a <printf>
      exit(1);
    1d84:	4505                	li	a0,1
    1d86:	29e030ef          	jal	5024 <exit>
    1d8a:	e0d2                	sd	s4,64(sp)
    1d8c:	fc56                	sd	s5,56(sp)
    1d8e:	f85a                	sd	s6,48(sp)
    1d90:	f45e                	sd	s7,40(sp)
    1d92:	f062                	sd	s8,32(sp)
    1d94:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d96:	06200793          	li	a5,98
    1d9a:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1d9e:	0619079b          	addiw	a5,s2,97
    1da2:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1da6:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1daa:	f9840513          	addi	a0,s0,-104
    1dae:	2c6030ef          	jal	5074 <unlink>
    1db2:	47f9                	li	a5,30
    1db4:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1db6:	f9840b93          	addi	s7,s0,-104
    1dba:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1dbe:	6a8d                	lui	s5,0x3
    1dc0:	0000ac17          	auipc	s8,0xa
    1dc4:	ef8c0c13          	addi	s8,s8,-264 # bcb8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1dc8:	8a26                	mv	s4,s1
    1dca:	02094563          	bltz	s2,1df4 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1dce:	85da                	mv	a1,s6
    1dd0:	855e                	mv	a0,s7
    1dd2:	292030ef          	jal	5064 <open>
    1dd6:	89aa                	mv	s3,a0
          if (fd < 0) {
    1dd8:	02054d63          	bltz	a0,1e12 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1ddc:	8656                	mv	a2,s5
    1dde:	85e2                	mv	a1,s8
    1de0:	264030ef          	jal	5044 <write>
          if (cc != sz) {
    1de4:	05551363          	bne	a0,s5,1e2a <manywrites+0x112>
          close(fd);
    1de8:	854e                	mv	a0,s3
    1dea:	262030ef          	jal	504c <close>
        for (int i = 0; i < ci + 1; i++) {
    1dee:	2a05                	addiw	s4,s4,1
    1df0:	fd495fe3          	bge	s2,s4,1dce <manywrites+0xb6>
        unlink(name);
    1df4:	f9840513          	addi	a0,s0,-104
    1df8:	27c030ef          	jal	5074 <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1dfc:	fffd079b          	addiw	a5,s10,-1
    1e00:	8d3e                	mv	s10,a5
    1e02:	f3f9                	bnez	a5,1dc8 <manywrites+0xb0>
      unlink(name);
    1e04:	f9840513          	addi	a0,s0,-104
    1e08:	26c030ef          	jal	5074 <unlink>
      exit(0);
    1e0c:	4501                	li	a0,0
    1e0e:	216030ef          	jal	5024 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e12:	f9840613          	addi	a2,s0,-104
    1e16:	85e6                	mv	a1,s9
    1e18:	00004517          	auipc	a0,0x4
    1e1c:	3c850513          	addi	a0,a0,968 # 61e0 <malloc+0xcae>
    1e20:	65a030ef          	jal	547a <printf>
            exit(1);
    1e24:	4505                	li	a0,1
    1e26:	1fe030ef          	jal	5024 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e2a:	86aa                	mv	a3,a0
    1e2c:	660d                	lui	a2,0x3
    1e2e:	85e6                	mv	a1,s9
    1e30:	00004517          	auipc	a0,0x4
    1e34:	90850513          	addi	a0,a0,-1784 # 5738 <malloc+0x206>
    1e38:	642030ef          	jal	547a <printf>
            exit(1);
    1e3c:	4505                	li	a0,1
    1e3e:	1e6030ef          	jal	5024 <exit>
    1e42:	e0d2                	sd	s4,64(sp)
    1e44:	fc56                	sd	s5,56(sp)
    1e46:	f85a                	sd	s6,48(sp)
    1e48:	f45e                	sd	s7,40(sp)
    1e4a:	f062                	sd	s8,32(sp)
    1e4c:	e86a                	sd	s10,16(sp)
      exit(st);
    1e4e:	1d6030ef          	jal	5024 <exit>

0000000000001e52 <copyinstr3>:
{
    1e52:	7179                	addi	sp,sp,-48
    1e54:	f406                	sd	ra,40(sp)
    1e56:	f022                	sd	s0,32(sp)
    1e58:	ec26                	sd	s1,24(sp)
    1e5a:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e5c:	6509                	lui	a0,0x2
    1e5e:	192030ef          	jal	4ff0 <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e62:	4501                	li	a0,0
    1e64:	18c030ef          	jal	4ff0 <sbrk>
  if ((top % PGSIZE) != 0) {
    1e68:	03451793          	slli	a5,a0,0x34
    1e6c:	e7bd                	bnez	a5,1eda <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e6e:	4501                	li	a0,0
    1e70:	180030ef          	jal	4ff0 <sbrk>
  if (top % PGSIZE) {
    1e74:	03451793          	slli	a5,a0,0x34
    1e78:	ebad                	bnez	a5,1eea <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1e7a:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xa9>
  *b = 'x';
    1e7e:	07800793          	li	a5,120
    1e82:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e86:	8526                	mv	a0,s1
    1e88:	1ec030ef          	jal	5074 <unlink>
  if (ret != -1) {
    1e8c:	57fd                	li	a5,-1
    1e8e:	06f51763          	bne	a0,a5,1efc <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e92:	20100593          	li	a1,513
    1e96:	8526                	mv	a0,s1
    1e98:	1cc030ef          	jal	5064 <open>
  if (fd != -1) {
    1e9c:	57fd                	li	a5,-1
    1e9e:	06f51a63          	bne	a0,a5,1f12 <copyinstr3+0xc0>
  ret = link(b, b);
    1ea2:	85a6                	mv	a1,s1
    1ea4:	8526                	mv	a0,s1
    1ea6:	1de030ef          	jal	5084 <link>
  if (ret != -1) {
    1eaa:	57fd                	li	a5,-1
    1eac:	06f51e63          	bne	a0,a5,1f28 <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1eb0:	00005797          	auipc	a5,0x5
    1eb4:	03078793          	addi	a5,a5,48 # 6ee0 <malloc+0x19ae>
    1eb8:	fcf43823          	sd	a5,-48(s0)
    1ebc:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1ec0:	fd040593          	addi	a1,s0,-48
    1ec4:	8526                	mv	a0,s1
    1ec6:	196030ef          	jal	505c <exec>
  if (ret != -1) {
    1eca:	57fd                	li	a5,-1
    1ecc:	06f51a63          	bne	a0,a5,1f40 <copyinstr3+0xee>
}
    1ed0:	70a2                	ld	ra,40(sp)
    1ed2:	7402                	ld	s0,32(sp)
    1ed4:	64e2                	ld	s1,24(sp)
    1ed6:	6145                	addi	sp,sp,48
    1ed8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1eda:	0347d513          	srli	a0,a5,0x34
    1ede:	6785                	lui	a5,0x1
    1ee0:	40a7853b          	subw	a0,a5,a0
    1ee4:	10c030ef          	jal	4ff0 <sbrk>
    1ee8:	b759                	j	1e6e <copyinstr3+0x1c>
    printf("oops\n");
    1eea:	00004517          	auipc	a0,0x4
    1eee:	30e50513          	addi	a0,a0,782 # 61f8 <malloc+0xcc6>
    1ef2:	588030ef          	jal	547a <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	12c030ef          	jal	5024 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1efc:	862a                	mv	a2,a0
    1efe:	85a6                	mv	a1,s1
    1f00:	00004517          	auipc	a0,0x4
    1f04:	f1850513          	addi	a0,a0,-232 # 5e18 <malloc+0x8e6>
    1f08:	572030ef          	jal	547a <printf>
    exit(1);
    1f0c:	4505                	li	a0,1
    1f0e:	116030ef          	jal	5024 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f12:	862a                	mv	a2,a0
    1f14:	85a6                	mv	a1,s1
    1f16:	00004517          	auipc	a0,0x4
    1f1a:	f2250513          	addi	a0,a0,-222 # 5e38 <malloc+0x906>
    1f1e:	55c030ef          	jal	547a <printf>
    exit(1);
    1f22:	4505                	li	a0,1
    1f24:	100030ef          	jal	5024 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f28:	86aa                	mv	a3,a0
    1f2a:	8626                	mv	a2,s1
    1f2c:	85a6                	mv	a1,s1
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	f2a50513          	addi	a0,a0,-214 # 5e58 <malloc+0x926>
    1f36:	544030ef          	jal	547a <printf>
    exit(1);
    1f3a:	4505                	li	a0,1
    1f3c:	0e8030ef          	jal	5024 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f40:	863e                	mv	a2,a5
    1f42:	85a6                	mv	a1,s1
    1f44:	00004517          	auipc	a0,0x4
    1f48:	f3c50513          	addi	a0,a0,-196 # 5e80 <malloc+0x94e>
    1f4c:	52e030ef          	jal	547a <printf>
    exit(1);
    1f50:	4505                	li	a0,1
    1f52:	0d2030ef          	jal	5024 <exit>

0000000000001f56 <rwsbrk>:
{
    1f56:	1101                	addi	sp,sp,-32
    1f58:	ec06                	sd	ra,24(sp)
    1f5a:	e822                	sd	s0,16(sp)
    1f5c:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f5e:	6509                	lui	a0,0x2
    1f60:	090030ef          	jal	4ff0 <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f64:	57fd                	li	a5,-1
    1f66:	04f50a63          	beq	a0,a5,1fba <rwsbrk+0x64>
    1f6a:	e426                	sd	s1,8(sp)
    1f6c:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f6e:	7579                	lui	a0,0xffffe
    1f70:	080030ef          	jal	4ff0 <sbrk>
    1f74:	57fd                	li	a5,-1
    1f76:	04f50d63          	beq	a0,a5,1fd0 <rwsbrk+0x7a>
    1f7a:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f7c:	20100593          	li	a1,513
    1f80:	00004517          	auipc	a0,0x4
    1f84:	2b850513          	addi	a0,a0,696 # 6238 <malloc+0xd06>
    1f88:	0dc030ef          	jal	5064 <open>
    1f8c:	892a                	mv	s2,a0
  if (fd < 0) {
    1f8e:	04054b63          	bltz	a0,1fe4 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f92:	6785                	lui	a5,0x1
    1f94:	94be                	add	s1,s1,a5
    1f96:	40000613          	li	a2,1024
    1f9a:	85a6                	mv	a1,s1
    1f9c:	0a8030ef          	jal	5044 <write>
    1fa0:	862a                	mv	a2,a0
  if (n >= 0) {
    1fa2:	04054a63          	bltz	a0,1ff6 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1fa6:	85a6                	mv	a1,s1
    1fa8:	00004517          	auipc	a0,0x4
    1fac:	2b050513          	addi	a0,a0,688 # 6258 <malloc+0xd26>
    1fb0:	4ca030ef          	jal	547a <printf>
    exit(1);
    1fb4:	4505                	li	a0,1
    1fb6:	06e030ef          	jal	5024 <exit>
    1fba:	e426                	sd	s1,8(sp)
    1fbc:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1fbe:	00004517          	auipc	a0,0x4
    1fc2:	24250513          	addi	a0,a0,578 # 6200 <malloc+0xcce>
    1fc6:	4b4030ef          	jal	547a <printf>
    exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	058030ef          	jal	5024 <exit>
    1fd0:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fd2:	00004517          	auipc	a0,0x4
    1fd6:	24650513          	addi	a0,a0,582 # 6218 <malloc+0xce6>
    1fda:	4a0030ef          	jal	547a <printf>
    exit(1);
    1fde:	4505                	li	a0,1
    1fe0:	044030ef          	jal	5024 <exit>
    printf("open(rwsbrk) failed\n");
    1fe4:	00004517          	auipc	a0,0x4
    1fe8:	25c50513          	addi	a0,a0,604 # 6240 <malloc+0xd0e>
    1fec:	48e030ef          	jal	547a <printf>
    exit(1);
    1ff0:	4505                	li	a0,1
    1ff2:	032030ef          	jal	5024 <exit>
  close(fd);
    1ff6:	854a                	mv	a0,s2
    1ff8:	054030ef          	jal	504c <close>
  unlink("rwsbrk");
    1ffc:	00004517          	auipc	a0,0x4
    2000:	23c50513          	addi	a0,a0,572 # 6238 <malloc+0xd06>
    2004:	070030ef          	jal	5074 <unlink>
  fd = open("README", O_RDONLY);
    2008:	4581                	li	a1,0
    200a:	00004517          	auipc	a0,0x4
    200e:	83650513          	addi	a0,a0,-1994 # 5840 <malloc+0x30e>
    2012:	052030ef          	jal	5064 <open>
    2016:	892a                	mv	s2,a0
  if (fd < 0) {
    2018:	02054363          	bltz	a0,203e <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    201c:	4629                	li	a2,10
    201e:	85a6                	mv	a1,s1
    2020:	01c030ef          	jal	503c <read>
    2024:	862a                	mv	a2,a0
  if (n >= 0) {
    2026:	02054563          	bltz	a0,2050 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    202a:	85a6                	mv	a1,s1
    202c:	00004517          	auipc	a0,0x4
    2030:	25c50513          	addi	a0,a0,604 # 6288 <malloc+0xd56>
    2034:	446030ef          	jal	547a <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	7eb020ef          	jal	5024 <exit>
    printf("open(README) failed\n");
    203e:	00004517          	auipc	a0,0x4
    2042:	80a50513          	addi	a0,a0,-2038 # 5848 <malloc+0x316>
    2046:	434030ef          	jal	547a <printf>
    exit(1);
    204a:	4505                	li	a0,1
    204c:	7d9020ef          	jal	5024 <exit>
  close(fd);
    2050:	854a                	mv	a0,s2
    2052:	7fb020ef          	jal	504c <close>
  exit(0);
    2056:	4501                	li	a0,0
    2058:	7cd020ef          	jal	5024 <exit>

000000000000205c <sbrkbasic>:
{
    205c:	715d                	addi	sp,sp,-80
    205e:	e486                	sd	ra,72(sp)
    2060:	e0a2                	sd	s0,64(sp)
    2062:	ec56                	sd	s5,24(sp)
    2064:	0880                	addi	s0,sp,80
    2066:	8aaa                	mv	s5,a0
  pid = fork();
    2068:	7b5020ef          	jal	501c <fork>
  if (pid < 0) {
    206c:	02054c63          	bltz	a0,20a4 <sbrkbasic+0x48>
  if (pid == 0) {
    2070:	ed31                	bnez	a0,20cc <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    2072:	40000537          	lui	a0,0x40000
    2076:	77b020ef          	jal	4ff0 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    207a:	57fd                	li	a5,-1
    207c:	04f50163          	beq	a0,a5,20be <sbrkbasic+0x62>
    2080:	fc26                	sd	s1,56(sp)
    2082:	f84a                	sd	s2,48(sp)
    2084:	f44e                	sd	s3,40(sp)
    2086:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2088:	400007b7          	lui	a5,0x40000
    208c:	97aa                	add	a5,a5,a0
      *b = 99;
    208e:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2092:	6705                	lui	a4,0x1
      *b = 99;
    2094:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1348>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2098:	953a                	add	a0,a0,a4
    209a:	fef51de3          	bne	a0,a5,2094 <sbrkbasic+0x38>
    exit(1);
    209e:	4505                	li	a0,1
    20a0:	785020ef          	jal	5024 <exit>
    20a4:	fc26                	sd	s1,56(sp)
    20a6:	f84a                	sd	s2,48(sp)
    20a8:	f44e                	sd	s3,40(sp)
    20aa:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    20ac:	00004517          	auipc	a0,0x4
    20b0:	20450513          	addi	a0,a0,516 # 62b0 <malloc+0xd7e>
    20b4:	3c6030ef          	jal	547a <printf>
    exit(1);
    20b8:	4505                	li	a0,1
    20ba:	76b020ef          	jal	5024 <exit>
    20be:	fc26                	sd	s1,56(sp)
    20c0:	f84a                	sd	s2,48(sp)
    20c2:	f44e                	sd	s3,40(sp)
    20c4:	f052                	sd	s4,32(sp)
      exit(0);
    20c6:	4501                	li	a0,0
    20c8:	75d020ef          	jal	5024 <exit>
  wait(&xstatus);
    20cc:	fbc40513          	addi	a0,s0,-68
    20d0:	75d020ef          	jal	502c <wait>
  if (xstatus == 1) {
    20d4:	fbc42703          	lw	a4,-68(s0)
    20d8:	4785                	li	a5,1
    20da:	02f70063          	beq	a4,a5,20fa <sbrkbasic+0x9e>
    20de:	fc26                	sd	s1,56(sp)
    20e0:	f84a                	sd	s2,48(sp)
    20e2:	f44e                	sd	s3,40(sp)
    20e4:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20e6:	4501                	li	a0,0
    20e8:	709020ef          	jal	4ff0 <sbrk>
    20ec:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20ee:	4901                	li	s2,0
    b = sbrk(1);
    20f0:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20f2:	6a05                	lui	s4,0x1
    20f4:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    20f8:	a005                	j	2118 <sbrkbasic+0xbc>
    20fa:	fc26                	sd	s1,56(sp)
    20fc:	f84a                	sd	s2,48(sp)
    20fe:	f44e                	sd	s3,40(sp)
    2100:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2102:	85d6                	mv	a1,s5
    2104:	00004517          	auipc	a0,0x4
    2108:	1cc50513          	addi	a0,a0,460 # 62d0 <malloc+0xd9e>
    210c:	36e030ef          	jal	547a <printf>
    exit(1);
    2110:	4505                	li	a0,1
    2112:	713020ef          	jal	5024 <exit>
    2116:	84be                	mv	s1,a5
    b = sbrk(1);
    2118:	854e                	mv	a0,s3
    211a:	6d7020ef          	jal	4ff0 <sbrk>
    if (b != a) {
    211e:	04951163          	bne	a0,s1,2160 <sbrkbasic+0x104>
    *b = 1;
    2122:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2126:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    212a:	2905                	addiw	s2,s2,1
    212c:	ff4915e3          	bne	s2,s4,2116 <sbrkbasic+0xba>
  pid = fork();
    2130:	6ed020ef          	jal	501c <fork>
    2134:	892a                	mv	s2,a0
  if (pid < 0) {
    2136:	04054263          	bltz	a0,217a <sbrkbasic+0x11e>
  c = sbrk(1);
    213a:	4505                	li	a0,1
    213c:	6b5020ef          	jal	4ff0 <sbrk>
  c = sbrk(1);
    2140:	4505                	li	a0,1
    2142:	6af020ef          	jal	4ff0 <sbrk>
  if (c != a + 1) {
    2146:	0489                	addi	s1,s1,2
    2148:	04950363          	beq	a0,s1,218e <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    214c:	85d6                	mv	a1,s5
    214e:	00004517          	auipc	a0,0x4
    2152:	1e250513          	addi	a0,a0,482 # 6330 <malloc+0xdfe>
    2156:	324030ef          	jal	547a <printf>
    exit(1);
    215a:	4505                	li	a0,1
    215c:	6c9020ef          	jal	5024 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2160:	872a                	mv	a4,a0
    2162:	86a6                	mv	a3,s1
    2164:	864a                	mv	a2,s2
    2166:	85d6                	mv	a1,s5
    2168:	00004517          	auipc	a0,0x4
    216c:	18850513          	addi	a0,a0,392 # 62f0 <malloc+0xdbe>
    2170:	30a030ef          	jal	547a <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	6af020ef          	jal	5024 <exit>
    printf("%s: sbrk test fork failed\n", s);
    217a:	85d6                	mv	a1,s5
    217c:	00004517          	auipc	a0,0x4
    2180:	19450513          	addi	a0,a0,404 # 6310 <malloc+0xdde>
    2184:	2f6030ef          	jal	547a <printf>
    exit(1);
    2188:	4505                	li	a0,1
    218a:	69b020ef          	jal	5024 <exit>
  if (pid == 0)
    218e:	00091563          	bnez	s2,2198 <sbrkbasic+0x13c>
    exit(0);
    2192:	4501                	li	a0,0
    2194:	691020ef          	jal	5024 <exit>
  wait(&xstatus);
    2198:	fbc40513          	addi	a0,s0,-68
    219c:	691020ef          	jal	502c <wait>
  exit(xstatus);
    21a0:	fbc42503          	lw	a0,-68(s0)
    21a4:	681020ef          	jal	5024 <exit>

00000000000021a8 <sbrkmuch>:
{
    21a8:	7179                	addi	sp,sp,-48
    21aa:	f406                	sd	ra,40(sp)
    21ac:	f022                	sd	s0,32(sp)
    21ae:	ec26                	sd	s1,24(sp)
    21b0:	e84a                	sd	s2,16(sp)
    21b2:	e44e                	sd	s3,8(sp)
    21b4:	e052                	sd	s4,0(sp)
    21b6:	1800                	addi	s0,sp,48
    21b8:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21ba:	4501                	li	a0,0
    21bc:	635020ef          	jal	4ff0 <sbrk>
    21c0:	892a                	mv	s2,a0
  a = sbrk(0);
    21c2:	4501                	li	a0,0
    21c4:	62d020ef          	jal	4ff0 <sbrk>
    21c8:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21ca:	06400537          	lui	a0,0x6400
    21ce:	9d05                	subw	a0,a0,s1
    21d0:	621020ef          	jal	4ff0 <sbrk>
  if (p != a) {
    21d4:	08a49963          	bne	s1,a0,2266 <sbrkmuch+0xbe>
  *lastaddr = 99;
    21d8:	064007b7          	lui	a5,0x6400
    21dc:	06300713          	li	a4,99
    21e0:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1347>
  a = sbrk(0);
    21e4:	4501                	li	a0,0
    21e6:	60b020ef          	jal	4ff0 <sbrk>
    21ea:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21ec:	757d                	lui	a0,0xfffff
    21ee:	603020ef          	jal	4ff0 <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21f2:	57fd                	li	a5,-1
    21f4:	08f50363          	beq	a0,a5,227a <sbrkmuch+0xd2>
  c = sbrk(0);
    21f8:	4501                	li	a0,0
    21fa:	5f7020ef          	jal	4ff0 <sbrk>
  if (c != a - PGSIZE) {
    21fe:	80048793          	addi	a5,s1,-2048
    2202:	80078793          	addi	a5,a5,-2048
    2206:	08f51463          	bne	a0,a5,228e <sbrkmuch+0xe6>
  a = sbrk(0);
    220a:	4501                	li	a0,0
    220c:	5e5020ef          	jal	4ff0 <sbrk>
    2210:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2212:	6505                	lui	a0,0x1
    2214:	5dd020ef          	jal	4ff0 <sbrk>
    2218:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    221a:	08a49663          	bne	s1,a0,22a6 <sbrkmuch+0xfe>
    221e:	4501                	li	a0,0
    2220:	5d1020ef          	jal	4ff0 <sbrk>
    2224:	6785                	lui	a5,0x1
    2226:	97a6                	add	a5,a5,s1
    2228:	06f51f63          	bne	a0,a5,22a6 <sbrkmuch+0xfe>
  if (*lastaddr == 99) {
    222c:	064007b7          	lui	a5,0x6400
    2230:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1347>
    2234:	06300793          	li	a5,99
    2238:	08f70363          	beq	a4,a5,22be <sbrkmuch+0x116>
  a = sbrk(0);
    223c:	4501                	li	a0,0
    223e:	5b3020ef          	jal	4ff0 <sbrk>
    2242:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2244:	4501                	li	a0,0
    2246:	5ab020ef          	jal	4ff0 <sbrk>
    224a:	40a9053b          	subw	a0,s2,a0
    224e:	5a3020ef          	jal	4ff0 <sbrk>
  if (c != a) {
    2252:	08a49063          	bne	s1,a0,22d2 <sbrkmuch+0x12a>
}
    2256:	70a2                	ld	ra,40(sp)
    2258:	7402                	ld	s0,32(sp)
    225a:	64e2                	ld	s1,24(sp)
    225c:	6942                	ld	s2,16(sp)
    225e:	69a2                	ld	s3,8(sp)
    2260:	6a02                	ld	s4,0(sp)
    2262:	6145                	addi	sp,sp,48
    2264:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2266:	85ce                	mv	a1,s3
    2268:	00004517          	auipc	a0,0x4
    226c:	0e850513          	addi	a0,a0,232 # 6350 <malloc+0xe1e>
    2270:	20a030ef          	jal	547a <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	5af020ef          	jal	5024 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    227a:	85ce                	mv	a1,s3
    227c:	00004517          	auipc	a0,0x4
    2280:	11c50513          	addi	a0,a0,284 # 6398 <malloc+0xe66>
    2284:	1f6030ef          	jal	547a <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	59b020ef          	jal	5024 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    228e:	86aa                	mv	a3,a0
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00004517          	auipc	a0,0x4
    2298:	12450513          	addi	a0,a0,292 # 63b8 <malloc+0xe86>
    229c:	1de030ef          	jal	547a <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	583020ef          	jal	5024 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22a6:	86d2                	mv	a3,s4
    22a8:	8626                	mv	a2,s1
    22aa:	85ce                	mv	a1,s3
    22ac:	00004517          	auipc	a0,0x4
    22b0:	14c50513          	addi	a0,a0,332 # 63f8 <malloc+0xec6>
    22b4:	1c6030ef          	jal	547a <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	56b020ef          	jal	5024 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22be:	85ce                	mv	a1,s3
    22c0:	00004517          	auipc	a0,0x4
    22c4:	16850513          	addi	a0,a0,360 # 6428 <malloc+0xef6>
    22c8:	1b2030ef          	jal	547a <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	557020ef          	jal	5024 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22d2:	86aa                	mv	a3,a0
    22d4:	8626                	mv	a2,s1
    22d6:	85ce                	mv	a1,s3
    22d8:	00004517          	auipc	a0,0x4
    22dc:	18850513          	addi	a0,a0,392 # 6460 <malloc+0xf2e>
    22e0:	19a030ef          	jal	547a <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	53f020ef          	jal	5024 <exit>

00000000000022ea <sbrkarg>:
{
    22ea:	7179                	addi	sp,sp,-48
    22ec:	f406                	sd	ra,40(sp)
    22ee:	f022                	sd	s0,32(sp)
    22f0:	ec26                	sd	s1,24(sp)
    22f2:	e84a                	sd	s2,16(sp)
    22f4:	e44e                	sd	s3,8(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22fa:	6505                	lui	a0,0x1
    22fc:	4f5020ef          	jal	4ff0 <sbrk>
    2300:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2302:	20100593          	li	a1,513
    2306:	00004517          	auipc	a0,0x4
    230a:	18250513          	addi	a0,a0,386 # 6488 <malloc+0xf56>
    230e:	557020ef          	jal	5064 <open>
    2312:	84aa                	mv	s1,a0
  unlink("sbrk");
    2314:	00004517          	auipc	a0,0x4
    2318:	17450513          	addi	a0,a0,372 # 6488 <malloc+0xf56>
    231c:	559020ef          	jal	5074 <unlink>
  if (fd < 0) {
    2320:	0204c963          	bltz	s1,2352 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2324:	6605                	lui	a2,0x1
    2326:	85ca                	mv	a1,s2
    2328:	8526                	mv	a0,s1
    232a:	51b020ef          	jal	5044 <write>
    232e:	02054c63          	bltz	a0,2366 <sbrkarg+0x7c>
  close(fd);
    2332:	8526                	mv	a0,s1
    2334:	519020ef          	jal	504c <close>
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	4b7020ef          	jal	4ff0 <sbrk>
  if (pipe((int *)a) != 0) {
    233e:	4f7020ef          	jal	5034 <pipe>
    2342:	ed05                	bnez	a0,237a <sbrkarg+0x90>
}
    2344:	70a2                	ld	ra,40(sp)
    2346:	7402                	ld	s0,32(sp)
    2348:	64e2                	ld	s1,24(sp)
    234a:	6942                	ld	s2,16(sp)
    234c:	69a2                	ld	s3,8(sp)
    234e:	6145                	addi	sp,sp,48
    2350:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2352:	85ce                	mv	a1,s3
    2354:	00004517          	auipc	a0,0x4
    2358:	13c50513          	addi	a0,a0,316 # 6490 <malloc+0xf5e>
    235c:	11e030ef          	jal	547a <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	4c3020ef          	jal	5024 <exit>
    printf("%s: write sbrk failed\n", s);
    2366:	85ce                	mv	a1,s3
    2368:	00004517          	auipc	a0,0x4
    236c:	14050513          	addi	a0,a0,320 # 64a8 <malloc+0xf76>
    2370:	10a030ef          	jal	547a <printf>
    exit(1);
    2374:	4505                	li	a0,1
    2376:	4af020ef          	jal	5024 <exit>
    printf("%s: pipe() failed\n", s);
    237a:	85ce                	mv	a1,s3
    237c:	00004517          	auipc	a0,0x4
    2380:	c0450513          	addi	a0,a0,-1020 # 5f80 <malloc+0xa4e>
    2384:	0f6030ef          	jal	547a <printf>
    exit(1);
    2388:	4505                	li	a0,1
    238a:	49b020ef          	jal	5024 <exit>

000000000000238e <argptest>:
{
    238e:	1101                	addi	sp,sp,-32
    2390:	ec06                	sd	ra,24(sp)
    2392:	e822                	sd	s0,16(sp)
    2394:	e426                	sd	s1,8(sp)
    2396:	e04a                	sd	s2,0(sp)
    2398:	1000                	addi	s0,sp,32
    239a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    239c:	4581                	li	a1,0
    239e:	00004517          	auipc	a0,0x4
    23a2:	12250513          	addi	a0,a0,290 # 64c0 <malloc+0xf8e>
    23a6:	4bf020ef          	jal	5064 <open>
  if (fd < 0) {
    23aa:	02054563          	bltz	a0,23d4 <argptest+0x46>
    23ae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23b0:	4501                	li	a0,0
    23b2:	43f020ef          	jal	4ff0 <sbrk>
    23b6:	567d                	li	a2,-1
    23b8:	00c505b3          	add	a1,a0,a2
    23bc:	8526                	mv	a0,s1
    23be:	47f020ef          	jal	503c <read>
  close(fd);
    23c2:	8526                	mv	a0,s1
    23c4:	489020ef          	jal	504c <close>
}
    23c8:	60e2                	ld	ra,24(sp)
    23ca:	6442                	ld	s0,16(sp)
    23cc:	64a2                	ld	s1,8(sp)
    23ce:	6902                	ld	s2,0(sp)
    23d0:	6105                	addi	sp,sp,32
    23d2:	8082                	ret
    printf("%s: open failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00004517          	auipc	a0,0x4
    23da:	b3a50513          	addi	a0,a0,-1222 # 5f10 <malloc+0x9de>
    23de:	09c030ef          	jal	547a <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	441020ef          	jal	5024 <exit>

00000000000023e8 <sbrkbugs>:
{
    23e8:	1141                	addi	sp,sp,-16
    23ea:	e406                	sd	ra,8(sp)
    23ec:	e022                	sd	s0,0(sp)
    23ee:	0800                	addi	s0,sp,16
  int pid = fork();
    23f0:	42d020ef          	jal	501c <fork>
  if (pid < 0) {
    23f4:	00054c63          	bltz	a0,240c <sbrkbugs+0x24>
  if (pid == 0) {
    23f8:	e11d                	bnez	a0,241e <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23fa:	3f7020ef          	jal	4ff0 <sbrk>
    sbrk(-sz);
    23fe:	40a0053b          	negw	a0,a0
    2402:	3ef020ef          	jal	4ff0 <sbrk>
    exit(0);
    2406:	4501                	li	a0,0
    2408:	41d020ef          	jal	5024 <exit>
    printf("fork failed\n");
    240c:	00005517          	auipc	a0,0x5
    2410:	0c450513          	addi	a0,a0,196 # 74d0 <malloc+0x1f9e>
    2414:	066030ef          	jal	547a <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	40b020ef          	jal	5024 <exit>
  wait(0);
    241e:	4501                	li	a0,0
    2420:	40d020ef          	jal	502c <wait>
  pid = fork();
    2424:	3f9020ef          	jal	501c <fork>
  if (pid < 0) {
    2428:	00054f63          	bltz	a0,2446 <sbrkbugs+0x5e>
  if (pid == 0) {
    242c:	e515                	bnez	a0,2458 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    242e:	3c3020ef          	jal	4ff0 <sbrk>
    sbrk(-(sz - 3500));
    2432:	6785                	lui	a5,0x1
    2434:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    2438:	40a7853b          	subw	a0,a5,a0
    243c:	3b5020ef          	jal	4ff0 <sbrk>
    exit(0);
    2440:	4501                	li	a0,0
    2442:	3e3020ef          	jal	5024 <exit>
    printf("fork failed\n");
    2446:	00005517          	auipc	a0,0x5
    244a:	08a50513          	addi	a0,a0,138 # 74d0 <malloc+0x1f9e>
    244e:	02c030ef          	jal	547a <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	3d1020ef          	jal	5024 <exit>
  wait(0);
    2458:	4501                	li	a0,0
    245a:	3d3020ef          	jal	502c <wait>
  pid = fork();
    245e:	3bf020ef          	jal	501c <fork>
  if (pid < 0) {
    2462:	02054263          	bltz	a0,2486 <sbrkbugs+0x9e>
  if (pid == 0) {
    2466:	e90d                	bnez	a0,2498 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2468:	389020ef          	jal	4ff0 <sbrk>
    246c:	67ad                	lui	a5,0xb
    246e:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1258>
    2472:	40a7853b          	subw	a0,a5,a0
    2476:	37b020ef          	jal	4ff0 <sbrk>
    sbrk(-10);
    247a:	5559                	li	a0,-10
    247c:	375020ef          	jal	4ff0 <sbrk>
    exit(0);
    2480:	4501                	li	a0,0
    2482:	3a3020ef          	jal	5024 <exit>
    printf("fork failed\n");
    2486:	00005517          	auipc	a0,0x5
    248a:	04a50513          	addi	a0,a0,74 # 74d0 <malloc+0x1f9e>
    248e:	7ed020ef          	jal	547a <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	391020ef          	jal	5024 <exit>
  wait(0);
    2498:	4501                	li	a0,0
    249a:	393020ef          	jal	502c <wait>
  exit(0);
    249e:	4501                	li	a0,0
    24a0:	385020ef          	jal	5024 <exit>

00000000000024a4 <sbrklast>:
{
    24a4:	7179                	addi	sp,sp,-48
    24a6:	f406                	sd	ra,40(sp)
    24a8:	f022                	sd	s0,32(sp)
    24aa:	ec26                	sd	s1,24(sp)
    24ac:	e84a                	sd	s2,16(sp)
    24ae:	e44e                	sd	s3,8(sp)
    24b0:	e052                	sd	s4,0(sp)
    24b2:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    24b4:	4501                	li	a0,0
    24b6:	33b020ef          	jal	4ff0 <sbrk>
  if ((top % PGSIZE) != 0)
    24ba:	03451793          	slli	a5,a0,0x34
    24be:	ebad                	bnez	a5,2530 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	32f020ef          	jal	4ff0 <sbrk>
  sbrk(10);
    24c6:	4529                	li	a0,10
    24c8:	329020ef          	jal	4ff0 <sbrk>
  sbrk(-20);
    24cc:	5531                	li	a0,-20
    24ce:	323020ef          	jal	4ff0 <sbrk>
  top = (uint64)sbrk(0);
    24d2:	4501                	li	a0,0
    24d4:	31d020ef          	jal	4ff0 <sbrk>
    24d8:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24da:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    24de:	07800993          	li	s3,120
    24e2:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    24e6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24ea:	20200593          	li	a1,514
    24ee:	854a                	mv	a0,s2
    24f0:	375020ef          	jal	5064 <open>
    24f4:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    24f6:	4605                	li	a2,1
    24f8:	85ca                	mv	a1,s2
    24fa:	34b020ef          	jal	5044 <write>
  close(fd);
    24fe:	8552                	mv	a0,s4
    2500:	34d020ef          	jal	504c <close>
  fd = open(p, O_RDWR);
    2504:	4589                	li	a1,2
    2506:	854a                	mv	a0,s2
    2508:	35d020ef          	jal	5064 <open>
  p[0] = '\0';
    250c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2510:	4605                	li	a2,1
    2512:	85ca                	mv	a1,s2
    2514:	329020ef          	jal	503c <read>
  if (p[0] != 'x')
    2518:	fc04c783          	lbu	a5,-64(s1)
    251c:	03379263          	bne	a5,s3,2540 <sbrklast+0x9c>
}
    2520:	70a2                	ld	ra,40(sp)
    2522:	7402                	ld	s0,32(sp)
    2524:	64e2                	ld	s1,24(sp)
    2526:	6942                	ld	s2,16(sp)
    2528:	69a2                	ld	s3,8(sp)
    252a:	6a02                	ld	s4,0(sp)
    252c:	6145                	addi	sp,sp,48
    252e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2530:	0347d513          	srli	a0,a5,0x34
    2534:	6785                	lui	a5,0x1
    2536:	40a7853b          	subw	a0,a5,a0
    253a:	2b7020ef          	jal	4ff0 <sbrk>
    253e:	b749                	j	24c0 <sbrklast+0x1c>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	2e3020ef          	jal	5024 <exit>

0000000000002546 <sbrk8000>:
{
    2546:	1141                	addi	sp,sp,-16
    2548:	e406                	sd	ra,8(sp)
    254a:	e022                	sd	s0,0(sp)
    254c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    254e:	80000537          	lui	a0,0x80000
    2552:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff134c>
    2554:	29d020ef          	jal	4ff0 <sbrk>
  volatile char *top = sbrk(0);
    2558:	4501                	li	a0,0
    255a:	297020ef          	jal	4ff0 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    255e:	fff54783          	lbu	a5,-1(a0)
    2562:	0785                	addi	a5,a5,1 # 1001 <bigdir+0x10d>
    2564:	0ff7f793          	zext.b	a5,a5
    2568:	fef50fa3          	sb	a5,-1(a0)
}
    256c:	60a2                	ld	ra,8(sp)
    256e:	6402                	ld	s0,0(sp)
    2570:	0141                	addi	sp,sp,16
    2572:	8082                	ret

0000000000002574 <execout>:
{
    2574:	711d                	addi	sp,sp,-96
    2576:	ec86                	sd	ra,88(sp)
    2578:	e8a2                	sd	s0,80(sp)
    257a:	e4a6                	sd	s1,72(sp)
    257c:	e0ca                	sd	s2,64(sp)
    257e:	fc4e                	sd	s3,56(sp)
    2580:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    2582:	4901                	li	s2,0
    2584:	49bd                	li	s3,15
    int pid = fork();
    2586:	297020ef          	jal	501c <fork>
    258a:	84aa                	mv	s1,a0
    if (pid < 0) {
    258c:	00054e63          	bltz	a0,25a8 <execout+0x34>
    } else if (pid == 0) {
    2590:	c51d                	beqz	a0,25be <execout+0x4a>
      wait((int *)0);
    2592:	4501                	li	a0,0
    2594:	299020ef          	jal	502c <wait>
  for (int avail = 0; avail < 15; avail++) {
    2598:	2905                	addiw	s2,s2,1
    259a:	ff3916e3          	bne	s2,s3,2586 <execout+0x12>
    259e:	f852                	sd	s4,48(sp)
    25a0:	f456                	sd	s5,40(sp)
  exit(0);
    25a2:	4501                	li	a0,0
    25a4:	281020ef          	jal	5024 <exit>
    25a8:	f852                	sd	s4,48(sp)
    25aa:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    25ac:	00005517          	auipc	a0,0x5
    25b0:	f2450513          	addi	a0,a0,-220 # 74d0 <malloc+0x1f9e>
    25b4:	6c7020ef          	jal	547a <printf>
      exit(1);
    25b8:	4505                	li	a0,1
    25ba:	26b020ef          	jal	5024 <exit>
    25be:	f852                	sd	s4,48(sp)
    25c0:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25c2:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25c4:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25c6:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25c8:	854e                	mv	a0,s3
    25ca:	227020ef          	jal	4ff0 <sbrk>
        if (a == SBRK_ERROR)
    25ce:	01450663          	beq	a0,s4,25da <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25d2:	954e                	add	a0,a0,s3
    25d4:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25d8:	bfc5                	j	25c8 <execout+0x54>
        sbrk(-PGSIZE);
    25da:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25dc:	01205863          	blez	s2,25ec <execout+0x78>
        sbrk(-PGSIZE);
    25e0:	854e                	mv	a0,s3
    25e2:	20f020ef          	jal	4ff0 <sbrk>
      for (int i = 0; i < avail; i++)
    25e6:	2485                	addiw	s1,s1,1
    25e8:	ff249ce3          	bne	s1,s2,25e0 <execout+0x6c>
      close(1);
    25ec:	4505                	li	a0,1
    25ee:	25f020ef          	jal	504c <close>
      char *args[] = {"echo", "x", 0};
    25f2:	00003797          	auipc	a5,0x3
    25f6:	07678793          	addi	a5,a5,118 # 5668 <malloc+0x136>
    25fa:	faf43423          	sd	a5,-88(s0)
    25fe:	00003797          	auipc	a5,0x3
    2602:	0da78793          	addi	a5,a5,218 # 56d8 <malloc+0x1a6>
    2606:	faf43823          	sd	a5,-80(s0)
    260a:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    260e:	fa840593          	addi	a1,s0,-88
    2612:	00003517          	auipc	a0,0x3
    2616:	05650513          	addi	a0,a0,86 # 5668 <malloc+0x136>
    261a:	243020ef          	jal	505c <exec>
      exit(0);
    261e:	4501                	li	a0,0
    2620:	205020ef          	jal	5024 <exit>

0000000000002624 <fourteen>:
{
    2624:	1101                	addi	sp,sp,-32
    2626:	ec06                	sd	ra,24(sp)
    2628:	e822                	sd	s0,16(sp)
    262a:	e426                	sd	s1,8(sp)
    262c:	1000                	addi	s0,sp,32
    262e:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    2630:	00004517          	auipc	a0,0x4
    2634:	06850513          	addi	a0,a0,104 # 6698 <malloc+0x1166>
    2638:	255020ef          	jal	508c <mkdir>
    263c:	e555                	bnez	a0,26e8 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    263e:	00004517          	auipc	a0,0x4
    2642:	eb250513          	addi	a0,a0,-334 # 64f0 <malloc+0xfbe>
    2646:	247020ef          	jal	508c <mkdir>
    264a:	e94d                	bnez	a0,26fc <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    264c:	20000593          	li	a1,512
    2650:	00004517          	auipc	a0,0x4
    2654:	ef850513          	addi	a0,a0,-264 # 6548 <malloc+0x1016>
    2658:	20d020ef          	jal	5064 <open>
  if (fd < 0) {
    265c:	0a054a63          	bltz	a0,2710 <fourteen+0xec>
  close(fd);
    2660:	1ed020ef          	jal	504c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2664:	4581                	li	a1,0
    2666:	00004517          	auipc	a0,0x4
    266a:	f5a50513          	addi	a0,a0,-166 # 65c0 <malloc+0x108e>
    266e:	1f7020ef          	jal	5064 <open>
  if (fd < 0) {
    2672:	0a054963          	bltz	a0,2724 <fourteen+0x100>
  close(fd);
    2676:	1d7020ef          	jal	504c <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    267a:	00004517          	auipc	a0,0x4
    267e:	fb650513          	addi	a0,a0,-74 # 6630 <malloc+0x10fe>
    2682:	20b020ef          	jal	508c <mkdir>
    2686:	c94d                	beqz	a0,2738 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2688:	00004517          	auipc	a0,0x4
    268c:	00050513          	mv	a0,a0
    2690:	1fd020ef          	jal	508c <mkdir>
    2694:	cd45                	beqz	a0,274c <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2696:	00004517          	auipc	a0,0x4
    269a:	ff250513          	addi	a0,a0,-14 # 6688 <malloc+0x1156>
    269e:	1d7020ef          	jal	5074 <unlink>
  unlink("12345678901234/12345678901234");
    26a2:	00004517          	auipc	a0,0x4
    26a6:	f8e50513          	addi	a0,a0,-114 # 6630 <malloc+0x10fe>
    26aa:	1cb020ef          	jal	5074 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26ae:	00004517          	auipc	a0,0x4
    26b2:	f1250513          	addi	a0,a0,-238 # 65c0 <malloc+0x108e>
    26b6:	1bf020ef          	jal	5074 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26ba:	00004517          	auipc	a0,0x4
    26be:	e8e50513          	addi	a0,a0,-370 # 6548 <malloc+0x1016>
    26c2:	1b3020ef          	jal	5074 <unlink>
  unlink("12345678901234/123456789012345");
    26c6:	00004517          	auipc	a0,0x4
    26ca:	e2a50513          	addi	a0,a0,-470 # 64f0 <malloc+0xfbe>
    26ce:	1a7020ef          	jal	5074 <unlink>
  unlink("12345678901234");
    26d2:	00004517          	auipc	a0,0x4
    26d6:	fc650513          	addi	a0,a0,-58 # 6698 <malloc+0x1166>
    26da:	19b020ef          	jal	5074 <unlink>
}
    26de:	60e2                	ld	ra,24(sp)
    26e0:	6442                	ld	s0,16(sp)
    26e2:	64a2                	ld	s1,8(sp)
    26e4:	6105                	addi	sp,sp,32
    26e6:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26e8:	85a6                	mv	a1,s1
    26ea:	00004517          	auipc	a0,0x4
    26ee:	dde50513          	addi	a0,a0,-546 # 64c8 <malloc+0xf96>
    26f2:	589020ef          	jal	547a <printf>
    exit(1);
    26f6:	4505                	li	a0,1
    26f8:	12d020ef          	jal	5024 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26fc:	85a6                	mv	a1,s1
    26fe:	00004517          	auipc	a0,0x4
    2702:	e1250513          	addi	a0,a0,-494 # 6510 <malloc+0xfde>
    2706:	575020ef          	jal	547a <printf>
    exit(1);
    270a:	4505                	li	a0,1
    270c:	119020ef          	jal	5024 <exit>
    printf(
    2710:	85a6                	mv	a1,s1
    2712:	00004517          	auipc	a0,0x4
    2716:	e6650513          	addi	a0,a0,-410 # 6578 <malloc+0x1046>
    271a:	561020ef          	jal	547a <printf>
    exit(1);
    271e:	4505                	li	a0,1
    2720:	105020ef          	jal	5024 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2724:	85a6                	mv	a1,s1
    2726:	00004517          	auipc	a0,0x4
    272a:	eca50513          	addi	a0,a0,-310 # 65f0 <malloc+0x10be>
    272e:	54d020ef          	jal	547a <printf>
    exit(1);
    2732:	4505                	li	a0,1
    2734:	0f1020ef          	jal	5024 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2738:	85a6                	mv	a1,s1
    273a:	00004517          	auipc	a0,0x4
    273e:	f1650513          	addi	a0,a0,-234 # 6650 <malloc+0x111e>
    2742:	539020ef          	jal	547a <printf>
    exit(1);
    2746:	4505                	li	a0,1
    2748:	0dd020ef          	jal	5024 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    274c:	85a6                	mv	a1,s1
    274e:	00004517          	auipc	a0,0x4
    2752:	f5a50513          	addi	a0,a0,-166 # 66a8 <malloc+0x1176>
    2756:	525020ef          	jal	547a <printf>
    exit(1);
    275a:	4505                	li	a0,1
    275c:	0c9020ef          	jal	5024 <exit>

0000000000002760 <diskfull>:
{
    2760:	b6010113          	addi	sp,sp,-1184
    2764:	48113c23          	sd	ra,1176(sp)
    2768:	48813823          	sd	s0,1168(sp)
    276c:	48913423          	sd	s1,1160(sp)
    2770:	49213023          	sd	s2,1152(sp)
    2774:	47313c23          	sd	s3,1144(sp)
    2778:	47413823          	sd	s4,1136(sp)
    277c:	47513423          	sd	s5,1128(sp)
    2780:	47613023          	sd	s6,1120(sp)
    2784:	45713c23          	sd	s7,1112(sp)
    2788:	45813823          	sd	s8,1104(sp)
    278c:	45913423          	sd	s9,1096(sp)
    2790:	45a13023          	sd	s10,1088(sp)
    2794:	43b13c23          	sd	s11,1080(sp)
    2798:	4a010413          	addi	s0,sp,1184
    279c:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    27a0:	00004517          	auipc	a0,0x4
    27a4:	f4050513          	addi	a0,a0,-192 # 66e0 <malloc+0x11ae>
    27a8:	0cd020ef          	jal	5074 <unlink>
    27ac:	03000a93          	li	s5,48
    name[0] = 'b';
    27b0:	06200d13          	li	s10,98
    name[1] = 'i';
    27b4:	06900c93          	li	s9,105
    name[2] = 'g';
    27b8:	06700c13          	li	s8,103
    unlink(name);
    27bc:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27c0:	60200b93          	li	s7,1538
    27c4:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27c8:	b9040a13          	addi	s4,s0,-1136
    27cc:	aa8d                	j	293e <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27ce:	b7040613          	addi	a2,s0,-1168
    27d2:	b6843583          	ld	a1,-1176(s0)
    27d6:	00004517          	auipc	a0,0x4
    27da:	f1a50513          	addi	a0,a0,-230 # 66f0 <malloc+0x11be>
    27de:	49d020ef          	jal	547a <printf>
      break;
    27e2:	a039                	j	27f0 <diskfull+0x90>
        close(fd);
    27e4:	854e                	mv	a0,s3
    27e6:	067020ef          	jal	504c <close>
    close(fd);
    27ea:	854e                	mv	a0,s3
    27ec:	061020ef          	jal	504c <close>
  for (int i = 0; i < nzz; i++) {
    27f0:	4481                	li	s1,0
    name[0] = 'z';
    27f2:	07a00993          	li	s3,122
    unlink(name);
    27f6:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27fe:	08000a93          	li	s5,128
    name[0] = 'z';
    2802:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2806:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    280a:	41f4d71b          	sraiw	a4,s1,0x1f
    280e:	01b7571b          	srliw	a4,a4,0x1b
    2812:	009707bb          	addw	a5,a4,s1
    2816:	4057d69b          	sraiw	a3,a5,0x5
    281a:	0306869b          	addiw	a3,a3,48
    281e:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2822:	8bfd                	andi	a5,a5,31
    2824:	9f99                	subw	a5,a5,a4
    2826:	0307879b          	addiw	a5,a5,48
    282a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    282e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2832:	854a                	mv	a0,s2
    2834:	041020ef          	jal	5074 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2838:	85d2                	mv	a1,s4
    283a:	854a                	mv	a0,s2
    283c:	029020ef          	jal	5064 <open>
    if (fd < 0)
    2840:	00054763          	bltz	a0,284e <diskfull+0xee>
    close(fd);
    2844:	009020ef          	jal	504c <close>
  for (int i = 0; i < nzz; i++) {
    2848:	2485                	addiw	s1,s1,1
    284a:	fb549ce3          	bne	s1,s5,2802 <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    284e:	00004517          	auipc	a0,0x4
    2852:	e9250513          	addi	a0,a0,-366 # 66e0 <malloc+0x11ae>
    2856:	037020ef          	jal	508c <mkdir>
    285a:	12050363          	beqz	a0,2980 <diskfull+0x220>
  unlink("diskfulldir");
    285e:	00004517          	auipc	a0,0x4
    2862:	e8250513          	addi	a0,a0,-382 # 66e0 <malloc+0x11ae>
    2866:	00f020ef          	jal	5074 <unlink>
  for (int i = 0; i < nzz; i++) {
    286a:	4481                	li	s1,0
    name[0] = 'z';
    286c:	07a00913          	li	s2,122
    unlink(name);
    2870:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2874:	08000993          	li	s3,128
    name[0] = 'z';
    2878:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    287c:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    2880:	41f4d71b          	sraiw	a4,s1,0x1f
    2884:	01b7571b          	srliw	a4,a4,0x1b
    2888:	009707bb          	addw	a5,a4,s1
    288c:	4057d69b          	sraiw	a3,a5,0x5
    2890:	0306869b          	addiw	a3,a3,48
    2894:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2898:	8bfd                	andi	a5,a5,31
    289a:	9f99                	subw	a5,a5,a4
    289c:	0307879b          	addiw	a5,a5,48
    28a0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28a4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28a8:	8552                	mv	a0,s4
    28aa:	7ca020ef          	jal	5074 <unlink>
  for (int i = 0; i < nzz; i++) {
    28ae:	2485                	addiw	s1,s1,1
    28b0:	fd3494e3          	bne	s1,s3,2878 <diskfull+0x118>
    28b4:	03000493          	li	s1,48
    name[0] = 'b';
    28b8:	06200b13          	li	s6,98
    name[1] = 'i';
    28bc:	06900a93          	li	s5,105
    name[2] = 'g';
    28c0:	06700a13          	li	s4,103
    unlink(name);
    28c4:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28c8:	07f00913          	li	s2,127
    name[0] = 'b';
    28cc:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28d0:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28d4:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28d8:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28dc:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28e0:	854e                	mv	a0,s3
    28e2:	792020ef          	jal	5074 <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28e6:	2485                	addiw	s1,s1,1
    28e8:	0ff4f493          	zext.b	s1,s1
    28ec:	ff2490e3          	bne	s1,s2,28cc <diskfull+0x16c>
}
    28f0:	49813083          	ld	ra,1176(sp)
    28f4:	49013403          	ld	s0,1168(sp)
    28f8:	48813483          	ld	s1,1160(sp)
    28fc:	48013903          	ld	s2,1152(sp)
    2900:	47813983          	ld	s3,1144(sp)
    2904:	47013a03          	ld	s4,1136(sp)
    2908:	46813a83          	ld	s5,1128(sp)
    290c:	46013b03          	ld	s6,1120(sp)
    2910:	45813b83          	ld	s7,1112(sp)
    2914:	45013c03          	ld	s8,1104(sp)
    2918:	44813c83          	ld	s9,1096(sp)
    291c:	44013d03          	ld	s10,1088(sp)
    2920:	43813d83          	ld	s11,1080(sp)
    2924:	4a010113          	addi	sp,sp,1184
    2928:	8082                	ret
    close(fd);
    292a:	854e                	mv	a0,s3
    292c:	720020ef          	jal	504c <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    2930:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x477>
    2932:	0ffafa93          	zext.b	s5,s5
    2936:	07f00793          	li	a5,127
    293a:	eafa8be3          	beq	s5,a5,27f0 <diskfull+0x90>
    name[0] = 'b';
    293e:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2942:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2946:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    294a:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    294e:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2952:	855a                	mv	a0,s6
    2954:	720020ef          	jal	5074 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2958:	85de                	mv	a1,s7
    295a:	855a                	mv	a0,s6
    295c:	708020ef          	jal	5064 <open>
    2960:	89aa                	mv	s3,a0
    if (fd < 0) {
    2962:	e60546e3          	bltz	a0,27ce <diskfull+0x6e>
    2966:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    2968:	40000913          	li	s2,1024
    296c:	864a                	mv	a2,s2
    296e:	85d2                	mv	a1,s4
    2970:	854e                	mv	a0,s3
    2972:	6d2020ef          	jal	5044 <write>
    2976:	e72517e3          	bne	a0,s2,27e4 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    297a:	34fd                	addiw	s1,s1,-1
    297c:	f8e5                	bnez	s1,296c <diskfull+0x20c>
    297e:	b775                	j	292a <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2980:	b6843583          	ld	a1,-1176(s0)
    2984:	00004517          	auipc	a0,0x4
    2988:	d8c50513          	addi	a0,a0,-628 # 6710 <malloc+0x11de>
    298c:	2ef020ef          	jal	547a <printf>
    2990:	b5f9                	j	285e <diskfull+0xfe>

0000000000002992 <iputtest>:
{
    2992:	1101                	addi	sp,sp,-32
    2994:	ec06                	sd	ra,24(sp)
    2996:	e822                	sd	s0,16(sp)
    2998:	e426                	sd	s1,8(sp)
    299a:	1000                	addi	s0,sp,32
    299c:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    299e:	00004517          	auipc	a0,0x4
    29a2:	da250513          	addi	a0,a0,-606 # 6740 <malloc+0x120e>
    29a6:	6e6020ef          	jal	508c <mkdir>
    29aa:	02054f63          	bltz	a0,29e8 <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    29ae:	00004517          	auipc	a0,0x4
    29b2:	d9250513          	addi	a0,a0,-622 # 6740 <malloc+0x120e>
    29b6:	6de020ef          	jal	5094 <chdir>
    29ba:	04054163          	bltz	a0,29fc <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29be:	00004517          	auipc	a0,0x4
    29c2:	dc250513          	addi	a0,a0,-574 # 6780 <malloc+0x124e>
    29c6:	6ae020ef          	jal	5074 <unlink>
    29ca:	04054363          	bltz	a0,2a10 <iputtest+0x7e>
  if (chdir("/") < 0) {
    29ce:	00004517          	auipc	a0,0x4
    29d2:	de250513          	addi	a0,a0,-542 # 67b0 <malloc+0x127e>
    29d6:	6be020ef          	jal	5094 <chdir>
    29da:	04054563          	bltz	a0,2a24 <iputtest+0x92>
}
    29de:	60e2                	ld	ra,24(sp)
    29e0:	6442                	ld	s0,16(sp)
    29e2:	64a2                	ld	s1,8(sp)
    29e4:	6105                	addi	sp,sp,32
    29e6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e8:	85a6                	mv	a1,s1
    29ea:	00004517          	auipc	a0,0x4
    29ee:	d5e50513          	addi	a0,a0,-674 # 6748 <malloc+0x1216>
    29f2:	289020ef          	jal	547a <printf>
    exit(1);
    29f6:	4505                	li	a0,1
    29f8:	62c020ef          	jal	5024 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29fc:	85a6                	mv	a1,s1
    29fe:	00004517          	auipc	a0,0x4
    2a02:	d6250513          	addi	a0,a0,-670 # 6760 <malloc+0x122e>
    2a06:	275020ef          	jal	547a <printf>
    exit(1);
    2a0a:	4505                	li	a0,1
    2a0c:	618020ef          	jal	5024 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a10:	85a6                	mv	a1,s1
    2a12:	00004517          	auipc	a0,0x4
    2a16:	d7e50513          	addi	a0,a0,-642 # 6790 <malloc+0x125e>
    2a1a:	261020ef          	jal	547a <printf>
    exit(1);
    2a1e:	4505                	li	a0,1
    2a20:	604020ef          	jal	5024 <exit>
    printf("%s: chdir / failed\n", s);
    2a24:	85a6                	mv	a1,s1
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	d9250513          	addi	a0,a0,-622 # 67b8 <malloc+0x1286>
    2a2e:	24d020ef          	jal	547a <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	5f0020ef          	jal	5024 <exit>

0000000000002a38 <exitiputtest>:
{
    2a38:	7179                	addi	sp,sp,-48
    2a3a:	f406                	sd	ra,40(sp)
    2a3c:	f022                	sd	s0,32(sp)
    2a3e:	ec26                	sd	s1,24(sp)
    2a40:	1800                	addi	s0,sp,48
    2a42:	84aa                	mv	s1,a0
  pid = fork();
    2a44:	5d8020ef          	jal	501c <fork>
  if (pid < 0) {
    2a48:	02054e63          	bltz	a0,2a84 <exitiputtest+0x4c>
  if (pid == 0) {
    2a4c:	e541                	bnez	a0,2ad4 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a4e:	00004517          	auipc	a0,0x4
    2a52:	cf250513          	addi	a0,a0,-782 # 6740 <malloc+0x120e>
    2a56:	636020ef          	jal	508c <mkdir>
    2a5a:	02054f63          	bltz	a0,2a98 <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	ce250513          	addi	a0,a0,-798 # 6740 <malloc+0x120e>
    2a66:	62e020ef          	jal	5094 <chdir>
    2a6a:	04054163          	bltz	a0,2aac <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a6e:	00004517          	auipc	a0,0x4
    2a72:	d1250513          	addi	a0,a0,-750 # 6780 <malloc+0x124e>
    2a76:	5fe020ef          	jal	5074 <unlink>
    2a7a:	04054363          	bltz	a0,2ac0 <exitiputtest+0x88>
    exit(0);
    2a7e:	4501                	li	a0,0
    2a80:	5a4020ef          	jal	5024 <exit>
    printf("%s: fork failed\n", s);
    2a84:	85a6                	mv	a1,s1
    2a86:	00003517          	auipc	a0,0x3
    2a8a:	47250513          	addi	a0,a0,1138 # 5ef8 <malloc+0x9c6>
    2a8e:	1ed020ef          	jal	547a <printf>
    exit(1);
    2a92:	4505                	li	a0,1
    2a94:	590020ef          	jal	5024 <exit>
      printf("%s: mkdir failed\n", s);
    2a98:	85a6                	mv	a1,s1
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	cae50513          	addi	a0,a0,-850 # 6748 <malloc+0x1216>
    2aa2:	1d9020ef          	jal	547a <printf>
      exit(1);
    2aa6:	4505                	li	a0,1
    2aa8:	57c020ef          	jal	5024 <exit>
      printf("%s: child chdir failed\n", s);
    2aac:	85a6                	mv	a1,s1
    2aae:	00004517          	auipc	a0,0x4
    2ab2:	d2250513          	addi	a0,a0,-734 # 67d0 <malloc+0x129e>
    2ab6:	1c5020ef          	jal	547a <printf>
      exit(1);
    2aba:	4505                	li	a0,1
    2abc:	568020ef          	jal	5024 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ac0:	85a6                	mv	a1,s1
    2ac2:	00004517          	auipc	a0,0x4
    2ac6:	cce50513          	addi	a0,a0,-818 # 6790 <malloc+0x125e>
    2aca:	1b1020ef          	jal	547a <printf>
      exit(1);
    2ace:	4505                	li	a0,1
    2ad0:	554020ef          	jal	5024 <exit>
  wait(&xstatus);
    2ad4:	fdc40513          	addi	a0,s0,-36
    2ad8:	554020ef          	jal	502c <wait>
  exit(xstatus);
    2adc:	fdc42503          	lw	a0,-36(s0)
    2ae0:	544020ef          	jal	5024 <exit>

0000000000002ae4 <dirtest>:
{
    2ae4:	1101                	addi	sp,sp,-32
    2ae6:	ec06                	sd	ra,24(sp)
    2ae8:	e822                	sd	s0,16(sp)
    2aea:	e426                	sd	s1,8(sp)
    2aec:	1000                	addi	s0,sp,32
    2aee:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2af0:	00004517          	auipc	a0,0x4
    2af4:	cf850513          	addi	a0,a0,-776 # 67e8 <malloc+0x12b6>
    2af8:	594020ef          	jal	508c <mkdir>
    2afc:	02054f63          	bltz	a0,2b3a <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2b00:	00004517          	auipc	a0,0x4
    2b04:	ce850513          	addi	a0,a0,-792 # 67e8 <malloc+0x12b6>
    2b08:	58c020ef          	jal	5094 <chdir>
    2b0c:	04054163          	bltz	a0,2b4e <dirtest+0x6a>
  if (chdir("..") < 0) {
    2b10:	00004517          	auipc	a0,0x4
    2b14:	cf850513          	addi	a0,a0,-776 # 6808 <malloc+0x12d6>
    2b18:	57c020ef          	jal	5094 <chdir>
    2b1c:	04054363          	bltz	a0,2b62 <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b20:	00004517          	auipc	a0,0x4
    2b24:	cc850513          	addi	a0,a0,-824 # 67e8 <malloc+0x12b6>
    2b28:	54c020ef          	jal	5074 <unlink>
    2b2c:	04054563          	bltz	a0,2b76 <dirtest+0x92>
}
    2b30:	60e2                	ld	ra,24(sp)
    2b32:	6442                	ld	s0,16(sp)
    2b34:	64a2                	ld	s1,8(sp)
    2b36:	6105                	addi	sp,sp,32
    2b38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b3a:	85a6                	mv	a1,s1
    2b3c:	00004517          	auipc	a0,0x4
    2b40:	c0c50513          	addi	a0,a0,-1012 # 6748 <malloc+0x1216>
    2b44:	137020ef          	jal	547a <printf>
    exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	4da020ef          	jal	5024 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4e:	85a6                	mv	a1,s1
    2b50:	00004517          	auipc	a0,0x4
    2b54:	ca050513          	addi	a0,a0,-864 # 67f0 <malloc+0x12be>
    2b58:	123020ef          	jal	547a <printf>
    exit(1);
    2b5c:	4505                	li	a0,1
    2b5e:	4c6020ef          	jal	5024 <exit>
    printf("%s: chdir .. failed\n", s);
    2b62:	85a6                	mv	a1,s1
    2b64:	00004517          	auipc	a0,0x4
    2b68:	cac50513          	addi	a0,a0,-852 # 6810 <malloc+0x12de>
    2b6c:	10f020ef          	jal	547a <printf>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	4b2020ef          	jal	5024 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b76:	85a6                	mv	a1,s1
    2b78:	00004517          	auipc	a0,0x4
    2b7c:	cb050513          	addi	a0,a0,-848 # 6828 <malloc+0x12f6>
    2b80:	0fb020ef          	jal	547a <printf>
    exit(1);
    2b84:	4505                	li	a0,1
    2b86:	49e020ef          	jal	5024 <exit>

0000000000002b8a <subdir>:
{
    2b8a:	1101                	addi	sp,sp,-32
    2b8c:	ec06                	sd	ra,24(sp)
    2b8e:	e822                	sd	s0,16(sp)
    2b90:	e426                	sd	s1,8(sp)
    2b92:	e04a                	sd	s2,0(sp)
    2b94:	1000                	addi	s0,sp,32
    2b96:	892a                	mv	s2,a0
  unlink("ff");
    2b98:	00004517          	auipc	a0,0x4
    2b9c:	dd850513          	addi	a0,a0,-552 # 6970 <malloc+0x143e>
    2ba0:	4d4020ef          	jal	5074 <unlink>
  if (mkdir("dd") != 0) {
    2ba4:	00004517          	auipc	a0,0x4
    2ba8:	c9c50513          	addi	a0,a0,-868 # 6840 <malloc+0x130e>
    2bac:	4e0020ef          	jal	508c <mkdir>
    2bb0:	2e051263          	bnez	a0,2e94 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb4:	20200593          	li	a1,514
    2bb8:	00004517          	auipc	a0,0x4
    2bbc:	ca850513          	addi	a0,a0,-856 # 6860 <malloc+0x132e>
    2bc0:	4a4020ef          	jal	5064 <open>
    2bc4:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bc6:	2e054163          	bltz	a0,2ea8 <subdir+0x31e>
  write(fd, "ff", 2);
    2bca:	4609                	li	a2,2
    2bcc:	00004597          	auipc	a1,0x4
    2bd0:	da458593          	addi	a1,a1,-604 # 6970 <malloc+0x143e>
    2bd4:	470020ef          	jal	5044 <write>
  close(fd);
    2bd8:	8526                	mv	a0,s1
    2bda:	472020ef          	jal	504c <close>
  if (unlink("dd") >= 0) {
    2bde:	00004517          	auipc	a0,0x4
    2be2:	c6250513          	addi	a0,a0,-926 # 6840 <malloc+0x130e>
    2be6:	48e020ef          	jal	5074 <unlink>
    2bea:	2c055963          	bgez	a0,2ebc <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	cca50513          	addi	a0,a0,-822 # 68b8 <malloc+0x1386>
    2bf6:	496020ef          	jal	508c <mkdir>
    2bfa:	2c051b63          	bnez	a0,2ed0 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfe:	20200593          	li	a1,514
    2c02:	00004517          	auipc	a0,0x4
    2c06:	cde50513          	addi	a0,a0,-802 # 68e0 <malloc+0x13ae>
    2c0a:	45a020ef          	jal	5064 <open>
    2c0e:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c10:	2c054a63          	bltz	a0,2ee4 <subdir+0x35a>
  write(fd, "FF", 2);
    2c14:	4609                	li	a2,2
    2c16:	00004597          	auipc	a1,0x4
    2c1a:	cfa58593          	addi	a1,a1,-774 # 6910 <malloc+0x13de>
    2c1e:	426020ef          	jal	5044 <write>
  close(fd);
    2c22:	8526                	mv	a0,s1
    2c24:	428020ef          	jal	504c <close>
  fd = open("dd/dd/../ff", 0);
    2c28:	4581                	li	a1,0
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	cee50513          	addi	a0,a0,-786 # 6918 <malloc+0x13e6>
    2c32:	432020ef          	jal	5064 <open>
    2c36:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c38:	2c054063          	bltz	a0,2ef8 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c3c:	660d                	lui	a2,0x3
    2c3e:	00009597          	auipc	a1,0x9
    2c42:	07a58593          	addi	a1,a1,122 # bcb8 <buf>
    2c46:	3f6020ef          	jal	503c <read>
  if (cc != 2 || buf[0] != 'f') {
    2c4a:	4789                	li	a5,2
    2c4c:	2cf51063          	bne	a0,a5,2f0c <subdir+0x382>
    2c50:	00009717          	auipc	a4,0x9
    2c54:	06874703          	lbu	a4,104(a4) # bcb8 <buf>
    2c58:	06600793          	li	a5,102
    2c5c:	2af71863          	bne	a4,a5,2f0c <subdir+0x382>
  close(fd);
    2c60:	8526                	mv	a0,s1
    2c62:	3ea020ef          	jal	504c <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c66:	00004597          	auipc	a1,0x4
    2c6a:	d0258593          	addi	a1,a1,-766 # 6968 <malloc+0x1436>
    2c6e:	00004517          	auipc	a0,0x4
    2c72:	c7250513          	addi	a0,a0,-910 # 68e0 <malloc+0x13ae>
    2c76:	40e020ef          	jal	5084 <link>
    2c7a:	2a051363          	bnez	a0,2f20 <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c7e:	00004517          	auipc	a0,0x4
    2c82:	c6250513          	addi	a0,a0,-926 # 68e0 <malloc+0x13ae>
    2c86:	3ee020ef          	jal	5074 <unlink>
    2c8a:	2a051563          	bnez	a0,2f34 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c8e:	4581                	li	a1,0
    2c90:	00004517          	auipc	a0,0x4
    2c94:	c5050513          	addi	a0,a0,-944 # 68e0 <malloc+0x13ae>
    2c98:	3cc020ef          	jal	5064 <open>
    2c9c:	2a055663          	bgez	a0,2f48 <subdir+0x3be>
  if (chdir("dd") != 0) {
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	ba050513          	addi	a0,a0,-1120 # 6840 <malloc+0x130e>
    2ca8:	3ec020ef          	jal	5094 <chdir>
    2cac:	2a051863          	bnez	a0,2f5c <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	d5050513          	addi	a0,a0,-688 # 6a00 <malloc+0x14ce>
    2cb8:	3dc020ef          	jal	5094 <chdir>
    2cbc:	2a051a63          	bnez	a0,2f70 <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	d7050513          	addi	a0,a0,-656 # 6a30 <malloc+0x14fe>
    2cc8:	3cc020ef          	jal	5094 <chdir>
    2ccc:	2a051c63          	bnez	a0,2f84 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2cd0:	00004517          	auipc	a0,0x4
    2cd4:	d9850513          	addi	a0,a0,-616 # 6a68 <malloc+0x1536>
    2cd8:	3bc020ef          	jal	5094 <chdir>
    2cdc:	2a051e63          	bnez	a0,2f98 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2ce0:	4581                	li	a1,0
    2ce2:	00004517          	auipc	a0,0x4
    2ce6:	c8650513          	addi	a0,a0,-890 # 6968 <malloc+0x1436>
    2cea:	37a020ef          	jal	5064 <open>
    2cee:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cf0:	2a054e63          	bltz	a0,2fac <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cf4:	660d                	lui	a2,0x3
    2cf6:	00009597          	auipc	a1,0x9
    2cfa:	fc258593          	addi	a1,a1,-62 # bcb8 <buf>
    2cfe:	33e020ef          	jal	503c <read>
    2d02:	4789                	li	a5,2
    2d04:	2af51e63          	bne	a0,a5,2fc0 <subdir+0x436>
  close(fd);
    2d08:	8526                	mv	a0,s1
    2d0a:	342020ef          	jal	504c <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d0e:	4581                	li	a1,0
    2d10:	00004517          	auipc	a0,0x4
    2d14:	bd050513          	addi	a0,a0,-1072 # 68e0 <malloc+0x13ae>
    2d18:	34c020ef          	jal	5064 <open>
    2d1c:	2a055c63          	bgez	a0,2fd4 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d20:	20200593          	li	a1,514
    2d24:	00004517          	auipc	a0,0x4
    2d28:	dd450513          	addi	a0,a0,-556 # 6af8 <malloc+0x15c6>
    2d2c:	338020ef          	jal	5064 <open>
    2d30:	2a055c63          	bgez	a0,2fe8 <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d34:	20200593          	li	a1,514
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	df050513          	addi	a0,a0,-528 # 6b28 <malloc+0x15f6>
    2d40:	324020ef          	jal	5064 <open>
    2d44:	2a055c63          	bgez	a0,2ffc <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d48:	20000593          	li	a1,512
    2d4c:	00004517          	auipc	a0,0x4
    2d50:	af450513          	addi	a0,a0,-1292 # 6840 <malloc+0x130e>
    2d54:	310020ef          	jal	5064 <open>
    2d58:	2a055c63          	bgez	a0,3010 <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d5c:	4589                	li	a1,2
    2d5e:	00004517          	auipc	a0,0x4
    2d62:	ae250513          	addi	a0,a0,-1310 # 6840 <malloc+0x130e>
    2d66:	2fe020ef          	jal	5064 <open>
    2d6a:	2a055d63          	bgez	a0,3024 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d6e:	4585                	li	a1,1
    2d70:	00004517          	auipc	a0,0x4
    2d74:	ad050513          	addi	a0,a0,-1328 # 6840 <malloc+0x130e>
    2d78:	2ec020ef          	jal	5064 <open>
    2d7c:	2a055e63          	bgez	a0,3038 <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d80:	00004597          	auipc	a1,0x4
    2d84:	e3858593          	addi	a1,a1,-456 # 6bb8 <malloc+0x1686>
    2d88:	00004517          	auipc	a0,0x4
    2d8c:	d7050513          	addi	a0,a0,-656 # 6af8 <malloc+0x15c6>
    2d90:	2f4020ef          	jal	5084 <link>
    2d94:	2a050c63          	beqz	a0,304c <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d98:	00004597          	auipc	a1,0x4
    2d9c:	e2058593          	addi	a1,a1,-480 # 6bb8 <malloc+0x1686>
    2da0:	00004517          	auipc	a0,0x4
    2da4:	d8850513          	addi	a0,a0,-632 # 6b28 <malloc+0x15f6>
    2da8:	2dc020ef          	jal	5084 <link>
    2dac:	2a050a63          	beqz	a0,3060 <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2db0:	00004597          	auipc	a1,0x4
    2db4:	bb858593          	addi	a1,a1,-1096 # 6968 <malloc+0x1436>
    2db8:	00004517          	auipc	a0,0x4
    2dbc:	aa850513          	addi	a0,a0,-1368 # 6860 <malloc+0x132e>
    2dc0:	2c4020ef          	jal	5084 <link>
    2dc4:	2a050863          	beqz	a0,3074 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2dc8:	00004517          	auipc	a0,0x4
    2dcc:	d3050513          	addi	a0,a0,-720 # 6af8 <malloc+0x15c6>
    2dd0:	2bc020ef          	jal	508c <mkdir>
    2dd4:	2a050a63          	beqz	a0,3088 <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dd8:	00004517          	auipc	a0,0x4
    2ddc:	d5050513          	addi	a0,a0,-688 # 6b28 <malloc+0x15f6>
    2de0:	2ac020ef          	jal	508c <mkdir>
    2de4:	2a050c63          	beqz	a0,309c <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2de8:	00004517          	auipc	a0,0x4
    2dec:	b8050513          	addi	a0,a0,-1152 # 6968 <malloc+0x1436>
    2df0:	29c020ef          	jal	508c <mkdir>
    2df4:	2a050e63          	beqz	a0,30b0 <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2df8:	00004517          	auipc	a0,0x4
    2dfc:	d3050513          	addi	a0,a0,-720 # 6b28 <malloc+0x15f6>
    2e00:	274020ef          	jal	5074 <unlink>
    2e04:	2c050063          	beqz	a0,30c4 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2e08:	00004517          	auipc	a0,0x4
    2e0c:	cf050513          	addi	a0,a0,-784 # 6af8 <malloc+0x15c6>
    2e10:	264020ef          	jal	5074 <unlink>
    2e14:	2c050263          	beqz	a0,30d8 <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	a4850513          	addi	a0,a0,-1464 # 6860 <malloc+0x132e>
    2e20:	274020ef          	jal	5094 <chdir>
    2e24:	2c050463          	beqz	a0,30ec <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e28:	00004517          	auipc	a0,0x4
    2e2c:	ee050513          	addi	a0,a0,-288 # 6d08 <malloc+0x17d6>
    2e30:	264020ef          	jal	5094 <chdir>
    2e34:	2c050663          	beqz	a0,3100 <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e38:	00004517          	auipc	a0,0x4
    2e3c:	b3050513          	addi	a0,a0,-1232 # 6968 <malloc+0x1436>
    2e40:	234020ef          	jal	5074 <unlink>
    2e44:	2c051863          	bnez	a0,3114 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	a1850513          	addi	a0,a0,-1512 # 6860 <malloc+0x132e>
    2e50:	224020ef          	jal	5074 <unlink>
    2e54:	2c051a63          	bnez	a0,3128 <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	9e850513          	addi	a0,a0,-1560 # 6840 <malloc+0x130e>
    2e60:	214020ef          	jal	5074 <unlink>
    2e64:	2c050c63          	beqz	a0,313c <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e68:	00004517          	auipc	a0,0x4
    2e6c:	f1050513          	addi	a0,a0,-240 # 6d78 <malloc+0x1846>
    2e70:	204020ef          	jal	5074 <unlink>
    2e74:	2c054e63          	bltz	a0,3150 <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	9c850513          	addi	a0,a0,-1592 # 6840 <malloc+0x130e>
    2e80:	1f4020ef          	jal	5074 <unlink>
    2e84:	2e054063          	bltz	a0,3164 <subdir+0x5da>
}
    2e88:	60e2                	ld	ra,24(sp)
    2e8a:	6442                	ld	s0,16(sp)
    2e8c:	64a2                	ld	s1,8(sp)
    2e8e:	6902                	ld	s2,0(sp)
    2e90:	6105                	addi	sp,sp,32
    2e92:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e94:	85ca                	mv	a1,s2
    2e96:	00004517          	auipc	a0,0x4
    2e9a:	9b250513          	addi	a0,a0,-1614 # 6848 <malloc+0x1316>
    2e9e:	5dc020ef          	jal	547a <printf>
    exit(1);
    2ea2:	4505                	li	a0,1
    2ea4:	180020ef          	jal	5024 <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea8:	85ca                	mv	a1,s2
    2eaa:	00004517          	auipc	a0,0x4
    2eae:	9be50513          	addi	a0,a0,-1602 # 6868 <malloc+0x1336>
    2eb2:	5c8020ef          	jal	547a <printf>
    exit(1);
    2eb6:	4505                	li	a0,1
    2eb8:	16c020ef          	jal	5024 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ebc:	85ca                	mv	a1,s2
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	9ca50513          	addi	a0,a0,-1590 # 6888 <malloc+0x1356>
    2ec6:	5b4020ef          	jal	547a <printf>
    exit(1);
    2eca:	4505                	li	a0,1
    2ecc:	158020ef          	jal	5024 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ed0:	85ca                	mv	a1,s2
    2ed2:	00004517          	auipc	a0,0x4
    2ed6:	9ee50513          	addi	a0,a0,-1554 # 68c0 <malloc+0x138e>
    2eda:	5a0020ef          	jal	547a <printf>
    exit(1);
    2ede:	4505                	li	a0,1
    2ee0:	144020ef          	jal	5024 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee4:	85ca                	mv	a1,s2
    2ee6:	00004517          	auipc	a0,0x4
    2eea:	a0a50513          	addi	a0,a0,-1526 # 68f0 <malloc+0x13be>
    2eee:	58c020ef          	jal	547a <printf>
    exit(1);
    2ef2:	4505                	li	a0,1
    2ef4:	130020ef          	jal	5024 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef8:	85ca                	mv	a1,s2
    2efa:	00004517          	auipc	a0,0x4
    2efe:	a2e50513          	addi	a0,a0,-1490 # 6928 <malloc+0x13f6>
    2f02:	578020ef          	jal	547a <printf>
    exit(1);
    2f06:	4505                	li	a0,1
    2f08:	11c020ef          	jal	5024 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f0c:	85ca                	mv	a1,s2
    2f0e:	00004517          	auipc	a0,0x4
    2f12:	a3a50513          	addi	a0,a0,-1478 # 6948 <malloc+0x1416>
    2f16:	564020ef          	jal	547a <printf>
    exit(1);
    2f1a:	4505                	li	a0,1
    2f1c:	108020ef          	jal	5024 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f20:	85ca                	mv	a1,s2
    2f22:	00004517          	auipc	a0,0x4
    2f26:	a5650513          	addi	a0,a0,-1450 # 6978 <malloc+0x1446>
    2f2a:	550020ef          	jal	547a <printf>
    exit(1);
    2f2e:	4505                	li	a0,1
    2f30:	0f4020ef          	jal	5024 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f34:	85ca                	mv	a1,s2
    2f36:	00004517          	auipc	a0,0x4
    2f3a:	a6a50513          	addi	a0,a0,-1430 # 69a0 <malloc+0x146e>
    2f3e:	53c020ef          	jal	547a <printf>
    exit(1);
    2f42:	4505                	li	a0,1
    2f44:	0e0020ef          	jal	5024 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f48:	85ca                	mv	a1,s2
    2f4a:	00004517          	auipc	a0,0x4
    2f4e:	a7650513          	addi	a0,a0,-1418 # 69c0 <malloc+0x148e>
    2f52:	528020ef          	jal	547a <printf>
    exit(1);
    2f56:	4505                	li	a0,1
    2f58:	0cc020ef          	jal	5024 <exit>
    printf("%s: chdir dd failed\n", s);
    2f5c:	85ca                	mv	a1,s2
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	a8a50513          	addi	a0,a0,-1398 # 69e8 <malloc+0x14b6>
    2f66:	514020ef          	jal	547a <printf>
    exit(1);
    2f6a:	4505                	li	a0,1
    2f6c:	0b8020ef          	jal	5024 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f70:	85ca                	mv	a1,s2
    2f72:	00004517          	auipc	a0,0x4
    2f76:	a9e50513          	addi	a0,a0,-1378 # 6a10 <malloc+0x14de>
    2f7a:	500020ef          	jal	547a <printf>
    exit(1);
    2f7e:	4505                	li	a0,1
    2f80:	0a4020ef          	jal	5024 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f84:	85ca                	mv	a1,s2
    2f86:	00004517          	auipc	a0,0x4
    2f8a:	aba50513          	addi	a0,a0,-1350 # 6a40 <malloc+0x150e>
    2f8e:	4ec020ef          	jal	547a <printf>
    exit(1);
    2f92:	4505                	li	a0,1
    2f94:	090020ef          	jal	5024 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f98:	85ca                	mv	a1,s2
    2f9a:	00004517          	auipc	a0,0x4
    2f9e:	ad650513          	addi	a0,a0,-1322 # 6a70 <malloc+0x153e>
    2fa2:	4d8020ef          	jal	547a <printf>
    exit(1);
    2fa6:	4505                	li	a0,1
    2fa8:	07c020ef          	jal	5024 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fac:	85ca                	mv	a1,s2
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	ada50513          	addi	a0,a0,-1318 # 6a88 <malloc+0x1556>
    2fb6:	4c4020ef          	jal	547a <printf>
    exit(1);
    2fba:	4505                	li	a0,1
    2fbc:	068020ef          	jal	5024 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fc0:	85ca                	mv	a1,s2
    2fc2:	00004517          	auipc	a0,0x4
    2fc6:	ae650513          	addi	a0,a0,-1306 # 6aa8 <malloc+0x1576>
    2fca:	4b0020ef          	jal	547a <printf>
    exit(1);
    2fce:	4505                	li	a0,1
    2fd0:	054020ef          	jal	5024 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd4:	85ca                	mv	a1,s2
    2fd6:	00004517          	auipc	a0,0x4
    2fda:	af250513          	addi	a0,a0,-1294 # 6ac8 <malloc+0x1596>
    2fde:	49c020ef          	jal	547a <printf>
    exit(1);
    2fe2:	4505                	li	a0,1
    2fe4:	040020ef          	jal	5024 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe8:	85ca                	mv	a1,s2
    2fea:	00004517          	auipc	a0,0x4
    2fee:	b1e50513          	addi	a0,a0,-1250 # 6b08 <malloc+0x15d6>
    2ff2:	488020ef          	jal	547a <printf>
    exit(1);
    2ff6:	4505                	li	a0,1
    2ff8:	02c020ef          	jal	5024 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ffc:	85ca                	mv	a1,s2
    2ffe:	00004517          	auipc	a0,0x4
    3002:	b3a50513          	addi	a0,a0,-1222 # 6b38 <malloc+0x1606>
    3006:	474020ef          	jal	547a <printf>
    exit(1);
    300a:	4505                	li	a0,1
    300c:	018020ef          	jal	5024 <exit>
    printf("%s: create dd succeeded!\n", s);
    3010:	85ca                	mv	a1,s2
    3012:	00004517          	auipc	a0,0x4
    3016:	b4650513          	addi	a0,a0,-1210 # 6b58 <malloc+0x1626>
    301a:	460020ef          	jal	547a <printf>
    exit(1);
    301e:	4505                	li	a0,1
    3020:	004020ef          	jal	5024 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3024:	85ca                	mv	a1,s2
    3026:	00004517          	auipc	a0,0x4
    302a:	b5250513          	addi	a0,a0,-1198 # 6b78 <malloc+0x1646>
    302e:	44c020ef          	jal	547a <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	7f1010ef          	jal	5024 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3038:	85ca                	mv	a1,s2
    303a:	00004517          	auipc	a0,0x4
    303e:	b5e50513          	addi	a0,a0,-1186 # 6b98 <malloc+0x1666>
    3042:	438020ef          	jal	547a <printf>
    exit(1);
    3046:	4505                	li	a0,1
    3048:	7dd010ef          	jal	5024 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    304c:	85ca                	mv	a1,s2
    304e:	00004517          	auipc	a0,0x4
    3052:	b7a50513          	addi	a0,a0,-1158 # 6bc8 <malloc+0x1696>
    3056:	424020ef          	jal	547a <printf>
    exit(1);
    305a:	4505                	li	a0,1
    305c:	7c9010ef          	jal	5024 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3060:	85ca                	mv	a1,s2
    3062:	00004517          	auipc	a0,0x4
    3066:	b8e50513          	addi	a0,a0,-1138 # 6bf0 <malloc+0x16be>
    306a:	410020ef          	jal	547a <printf>
    exit(1);
    306e:	4505                	li	a0,1
    3070:	7b5010ef          	jal	5024 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3074:	85ca                	mv	a1,s2
    3076:	00004517          	auipc	a0,0x4
    307a:	ba250513          	addi	a0,a0,-1118 # 6c18 <malloc+0x16e6>
    307e:	3fc020ef          	jal	547a <printf>
    exit(1);
    3082:	4505                	li	a0,1
    3084:	7a1010ef          	jal	5024 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3088:	85ca                	mv	a1,s2
    308a:	00004517          	auipc	a0,0x4
    308e:	bb650513          	addi	a0,a0,-1098 # 6c40 <malloc+0x170e>
    3092:	3e8020ef          	jal	547a <printf>
    exit(1);
    3096:	4505                	li	a0,1
    3098:	78d010ef          	jal	5024 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    309c:	85ca                	mv	a1,s2
    309e:	00004517          	auipc	a0,0x4
    30a2:	bc250513          	addi	a0,a0,-1086 # 6c60 <malloc+0x172e>
    30a6:	3d4020ef          	jal	547a <printf>
    exit(1);
    30aa:	4505                	li	a0,1
    30ac:	779010ef          	jal	5024 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30b0:	85ca                	mv	a1,s2
    30b2:	00004517          	auipc	a0,0x4
    30b6:	bce50513          	addi	a0,a0,-1074 # 6c80 <malloc+0x174e>
    30ba:	3c0020ef          	jal	547a <printf>
    exit(1);
    30be:	4505                	li	a0,1
    30c0:	765010ef          	jal	5024 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c4:	85ca                	mv	a1,s2
    30c6:	00004517          	auipc	a0,0x4
    30ca:	be250513          	addi	a0,a0,-1054 # 6ca8 <malloc+0x1776>
    30ce:	3ac020ef          	jal	547a <printf>
    exit(1);
    30d2:	4505                	li	a0,1
    30d4:	751010ef          	jal	5024 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d8:	85ca                	mv	a1,s2
    30da:	00004517          	auipc	a0,0x4
    30de:	bee50513          	addi	a0,a0,-1042 # 6cc8 <malloc+0x1796>
    30e2:	398020ef          	jal	547a <printf>
    exit(1);
    30e6:	4505                	li	a0,1
    30e8:	73d010ef          	jal	5024 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30ec:	85ca                	mv	a1,s2
    30ee:	00004517          	auipc	a0,0x4
    30f2:	bfa50513          	addi	a0,a0,-1030 # 6ce8 <malloc+0x17b6>
    30f6:	384020ef          	jal	547a <printf>
    exit(1);
    30fa:	4505                	li	a0,1
    30fc:	729010ef          	jal	5024 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3100:	85ca                	mv	a1,s2
    3102:	00004517          	auipc	a0,0x4
    3106:	c0e50513          	addi	a0,a0,-1010 # 6d10 <malloc+0x17de>
    310a:	370020ef          	jal	547a <printf>
    exit(1);
    310e:	4505                	li	a0,1
    3110:	715010ef          	jal	5024 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3114:	85ca                	mv	a1,s2
    3116:	00004517          	auipc	a0,0x4
    311a:	88a50513          	addi	a0,a0,-1910 # 69a0 <malloc+0x146e>
    311e:	35c020ef          	jal	547a <printf>
    exit(1);
    3122:	4505                	li	a0,1
    3124:	701010ef          	jal	5024 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3128:	85ca                	mv	a1,s2
    312a:	00004517          	auipc	a0,0x4
    312e:	c0650513          	addi	a0,a0,-1018 # 6d30 <malloc+0x17fe>
    3132:	348020ef          	jal	547a <printf>
    exit(1);
    3136:	4505                	li	a0,1
    3138:	6ed010ef          	jal	5024 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    313c:	85ca                	mv	a1,s2
    313e:	00004517          	auipc	a0,0x4
    3142:	c1250513          	addi	a0,a0,-1006 # 6d50 <malloc+0x181e>
    3146:	334020ef          	jal	547a <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	6d9010ef          	jal	5024 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3150:	85ca                	mv	a1,s2
    3152:	00004517          	auipc	a0,0x4
    3156:	c2e50513          	addi	a0,a0,-978 # 6d80 <malloc+0x184e>
    315a:	320020ef          	jal	547a <printf>
    exit(1);
    315e:	4505                	li	a0,1
    3160:	6c5010ef          	jal	5024 <exit>
    printf("%s: unlink dd failed\n", s);
    3164:	85ca                	mv	a1,s2
    3166:	00004517          	auipc	a0,0x4
    316a:	c3a50513          	addi	a0,a0,-966 # 6da0 <malloc+0x186e>
    316e:	30c020ef          	jal	547a <printf>
    exit(1);
    3172:	4505                	li	a0,1
    3174:	6b1010ef          	jal	5024 <exit>

0000000000003178 <rmdot>:
{
    3178:	1101                	addi	sp,sp,-32
    317a:	ec06                	sd	ra,24(sp)
    317c:	e822                	sd	s0,16(sp)
    317e:	e426                	sd	s1,8(sp)
    3180:	1000                	addi	s0,sp,32
    3182:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3184:	00004517          	auipc	a0,0x4
    3188:	c3450513          	addi	a0,a0,-972 # 6db8 <malloc+0x1886>
    318c:	701010ef          	jal	508c <mkdir>
    3190:	e53d                	bnez	a0,31fe <rmdot+0x86>
  if (chdir("dots") != 0) {
    3192:	00004517          	auipc	a0,0x4
    3196:	c2650513          	addi	a0,a0,-986 # 6db8 <malloc+0x1886>
    319a:	6fb010ef          	jal	5094 <chdir>
    319e:	e935                	bnez	a0,3212 <rmdot+0x9a>
  if (unlink(".") == 0) {
    31a0:	00003517          	auipc	a0,0x3
    31a4:	bb050513          	addi	a0,a0,-1104 # 5d50 <malloc+0x81e>
    31a8:	6cd010ef          	jal	5074 <unlink>
    31ac:	cd2d                	beqz	a0,3226 <rmdot+0xae>
  if (unlink("..") == 0) {
    31ae:	00003517          	auipc	a0,0x3
    31b2:	65a50513          	addi	a0,a0,1626 # 6808 <malloc+0x12d6>
    31b6:	6bf010ef          	jal	5074 <unlink>
    31ba:	c141                	beqz	a0,323a <rmdot+0xc2>
  if (chdir("/") != 0) {
    31bc:	00003517          	auipc	a0,0x3
    31c0:	5f450513          	addi	a0,a0,1524 # 67b0 <malloc+0x127e>
    31c4:	6d1010ef          	jal	5094 <chdir>
    31c8:	e159                	bnez	a0,324e <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31ca:	00004517          	auipc	a0,0x4
    31ce:	c5650513          	addi	a0,a0,-938 # 6e20 <malloc+0x18ee>
    31d2:	6a3010ef          	jal	5074 <unlink>
    31d6:	c551                	beqz	a0,3262 <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31d8:	00004517          	auipc	a0,0x4
    31dc:	c7050513          	addi	a0,a0,-912 # 6e48 <malloc+0x1916>
    31e0:	695010ef          	jal	5074 <unlink>
    31e4:	c949                	beqz	a0,3276 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31e6:	00004517          	auipc	a0,0x4
    31ea:	bd250513          	addi	a0,a0,-1070 # 6db8 <malloc+0x1886>
    31ee:	687010ef          	jal	5074 <unlink>
    31f2:	ed41                	bnez	a0,328a <rmdot+0x112>
}
    31f4:	60e2                	ld	ra,24(sp)
    31f6:	6442                	ld	s0,16(sp)
    31f8:	64a2                	ld	s1,8(sp)
    31fa:	6105                	addi	sp,sp,32
    31fc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fe:	85a6                	mv	a1,s1
    3200:	00004517          	auipc	a0,0x4
    3204:	bc050513          	addi	a0,a0,-1088 # 6dc0 <malloc+0x188e>
    3208:	272020ef          	jal	547a <printf>
    exit(1);
    320c:	4505                	li	a0,1
    320e:	617010ef          	jal	5024 <exit>
    printf("%s: chdir dots failed\n", s);
    3212:	85a6                	mv	a1,s1
    3214:	00004517          	auipc	a0,0x4
    3218:	bc450513          	addi	a0,a0,-1084 # 6dd8 <malloc+0x18a6>
    321c:	25e020ef          	jal	547a <printf>
    exit(1);
    3220:	4505                	li	a0,1
    3222:	603010ef          	jal	5024 <exit>
    printf("%s: rm . worked!\n", s);
    3226:	85a6                	mv	a1,s1
    3228:	00004517          	auipc	a0,0x4
    322c:	bc850513          	addi	a0,a0,-1080 # 6df0 <malloc+0x18be>
    3230:	24a020ef          	jal	547a <printf>
    exit(1);
    3234:	4505                	li	a0,1
    3236:	5ef010ef          	jal	5024 <exit>
    printf("%s: rm .. worked!\n", s);
    323a:	85a6                	mv	a1,s1
    323c:	00004517          	auipc	a0,0x4
    3240:	bcc50513          	addi	a0,a0,-1076 # 6e08 <malloc+0x18d6>
    3244:	236020ef          	jal	547a <printf>
    exit(1);
    3248:	4505                	li	a0,1
    324a:	5db010ef          	jal	5024 <exit>
    printf("%s: chdir / failed\n", s);
    324e:	85a6                	mv	a1,s1
    3250:	00003517          	auipc	a0,0x3
    3254:	56850513          	addi	a0,a0,1384 # 67b8 <malloc+0x1286>
    3258:	222020ef          	jal	547a <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	5c7010ef          	jal	5024 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3262:	85a6                	mv	a1,s1
    3264:	00004517          	auipc	a0,0x4
    3268:	bc450513          	addi	a0,a0,-1084 # 6e28 <malloc+0x18f6>
    326c:	20e020ef          	jal	547a <printf>
    exit(1);
    3270:	4505                	li	a0,1
    3272:	5b3010ef          	jal	5024 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3276:	85a6                	mv	a1,s1
    3278:	00004517          	auipc	a0,0x4
    327c:	bd850513          	addi	a0,a0,-1064 # 6e50 <malloc+0x191e>
    3280:	1fa020ef          	jal	547a <printf>
    exit(1);
    3284:	4505                	li	a0,1
    3286:	59f010ef          	jal	5024 <exit>
    printf("%s: unlink dots failed!\n", s);
    328a:	85a6                	mv	a1,s1
    328c:	00004517          	auipc	a0,0x4
    3290:	be450513          	addi	a0,a0,-1052 # 6e70 <malloc+0x193e>
    3294:	1e6020ef          	jal	547a <printf>
    exit(1);
    3298:	4505                	li	a0,1
    329a:	58b010ef          	jal	5024 <exit>

000000000000329e <dirfile>:
{
    329e:	1101                	addi	sp,sp,-32
    32a0:	ec06                	sd	ra,24(sp)
    32a2:	e822                	sd	s0,16(sp)
    32a4:	e426                	sd	s1,8(sp)
    32a6:	e04a                	sd	s2,0(sp)
    32a8:	1000                	addi	s0,sp,32
    32aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32ac:	20000593          	li	a1,512
    32b0:	00004517          	auipc	a0,0x4
    32b4:	be050513          	addi	a0,a0,-1056 # 6e90 <malloc+0x195e>
    32b8:	5ad010ef          	jal	5064 <open>
  if (fd < 0) {
    32bc:	0c054563          	bltz	a0,3386 <dirfile+0xe8>
  close(fd);
    32c0:	58d010ef          	jal	504c <close>
  if (chdir("dirfile") == 0) {
    32c4:	00004517          	auipc	a0,0x4
    32c8:	bcc50513          	addi	a0,a0,-1076 # 6e90 <malloc+0x195e>
    32cc:	5c9010ef          	jal	5094 <chdir>
    32d0:	c569                	beqz	a0,339a <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32d2:	4581                	li	a1,0
    32d4:	00004517          	auipc	a0,0x4
    32d8:	c0450513          	addi	a0,a0,-1020 # 6ed8 <malloc+0x19a6>
    32dc:	589010ef          	jal	5064 <open>
  if (fd >= 0) {
    32e0:	0c055763          	bgez	a0,33ae <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e4:	20000593          	li	a1,512
    32e8:	00004517          	auipc	a0,0x4
    32ec:	bf050513          	addi	a0,a0,-1040 # 6ed8 <malloc+0x19a6>
    32f0:	575010ef          	jal	5064 <open>
  if (fd >= 0) {
    32f4:	0c055763          	bgez	a0,33c2 <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32f8:	00004517          	auipc	a0,0x4
    32fc:	be050513          	addi	a0,a0,-1056 # 6ed8 <malloc+0x19a6>
    3300:	58d010ef          	jal	508c <mkdir>
    3304:	0c050963          	beqz	a0,33d6 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    3308:	00004517          	auipc	a0,0x4
    330c:	bd050513          	addi	a0,a0,-1072 # 6ed8 <malloc+0x19a6>
    3310:	565010ef          	jal	5074 <unlink>
    3314:	0c050b63          	beqz	a0,33ea <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    3318:	00004597          	auipc	a1,0x4
    331c:	bc058593          	addi	a1,a1,-1088 # 6ed8 <malloc+0x19a6>
    3320:	00002517          	auipc	a0,0x2
    3324:	52050513          	addi	a0,a0,1312 # 5840 <malloc+0x30e>
    3328:	55d010ef          	jal	5084 <link>
    332c:	0c050963          	beqz	a0,33fe <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    3330:	00004517          	auipc	a0,0x4
    3334:	b6050513          	addi	a0,a0,-1184 # 6e90 <malloc+0x195e>
    3338:	53d010ef          	jal	5074 <unlink>
    333c:	0c051b63          	bnez	a0,3412 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3340:	4589                	li	a1,2
    3342:	00003517          	auipc	a0,0x3
    3346:	a0e50513          	addi	a0,a0,-1522 # 5d50 <malloc+0x81e>
    334a:	51b010ef          	jal	5064 <open>
  if (fd >= 0) {
    334e:	0c055c63          	bgez	a0,3426 <dirfile+0x188>
  fd = open(".", 0);
    3352:	4581                	li	a1,0
    3354:	00003517          	auipc	a0,0x3
    3358:	9fc50513          	addi	a0,a0,-1540 # 5d50 <malloc+0x81e>
    335c:	509010ef          	jal	5064 <open>
    3360:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    3362:	4605                	li	a2,1
    3364:	00002597          	auipc	a1,0x2
    3368:	37458593          	addi	a1,a1,884 # 56d8 <malloc+0x1a6>
    336c:	4d9010ef          	jal	5044 <write>
    3370:	0ca04563          	bgtz	a0,343a <dirfile+0x19c>
  close(fd);
    3374:	8526                	mv	a0,s1
    3376:	4d7010ef          	jal	504c <close>
}
    337a:	60e2                	ld	ra,24(sp)
    337c:	6442                	ld	s0,16(sp)
    337e:	64a2                	ld	s1,8(sp)
    3380:	6902                	ld	s2,0(sp)
    3382:	6105                	addi	sp,sp,32
    3384:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3386:	85ca                	mv	a1,s2
    3388:	00004517          	auipc	a0,0x4
    338c:	b1050513          	addi	a0,a0,-1264 # 6e98 <malloc+0x1966>
    3390:	0ea020ef          	jal	547a <printf>
    exit(1);
    3394:	4505                	li	a0,1
    3396:	48f010ef          	jal	5024 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00004517          	auipc	a0,0x4
    33a0:	b1c50513          	addi	a0,a0,-1252 # 6eb8 <malloc+0x1986>
    33a4:	0d6020ef          	jal	547a <printf>
    exit(1);
    33a8:	4505                	li	a0,1
    33aa:	47b010ef          	jal	5024 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33ae:	85ca                	mv	a1,s2
    33b0:	00004517          	auipc	a0,0x4
    33b4:	b3850513          	addi	a0,a0,-1224 # 6ee8 <malloc+0x19b6>
    33b8:	0c2020ef          	jal	547a <printf>
    exit(1);
    33bc:	4505                	li	a0,1
    33be:	467010ef          	jal	5024 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33c2:	85ca                	mv	a1,s2
    33c4:	00004517          	auipc	a0,0x4
    33c8:	b2450513          	addi	a0,a0,-1244 # 6ee8 <malloc+0x19b6>
    33cc:	0ae020ef          	jal	547a <printf>
    exit(1);
    33d0:	4505                	li	a0,1
    33d2:	453010ef          	jal	5024 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d6:	85ca                	mv	a1,s2
    33d8:	00004517          	auipc	a0,0x4
    33dc:	b3850513          	addi	a0,a0,-1224 # 6f10 <malloc+0x19de>
    33e0:	09a020ef          	jal	547a <printf>
    exit(1);
    33e4:	4505                	li	a0,1
    33e6:	43f010ef          	jal	5024 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33ea:	85ca                	mv	a1,s2
    33ec:	00004517          	auipc	a0,0x4
    33f0:	b4c50513          	addi	a0,a0,-1204 # 6f38 <malloc+0x1a06>
    33f4:	086020ef          	jal	547a <printf>
    exit(1);
    33f8:	4505                	li	a0,1
    33fa:	42b010ef          	jal	5024 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fe:	85ca                	mv	a1,s2
    3400:	00004517          	auipc	a0,0x4
    3404:	b6050513          	addi	a0,a0,-1184 # 6f60 <malloc+0x1a2e>
    3408:	072020ef          	jal	547a <printf>
    exit(1);
    340c:	4505                	li	a0,1
    340e:	417010ef          	jal	5024 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3412:	85ca                	mv	a1,s2
    3414:	00004517          	auipc	a0,0x4
    3418:	b7450513          	addi	a0,a0,-1164 # 6f88 <malloc+0x1a56>
    341c:	05e020ef          	jal	547a <printf>
    exit(1);
    3420:	4505                	li	a0,1
    3422:	403010ef          	jal	5024 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3426:	85ca                	mv	a1,s2
    3428:	00004517          	auipc	a0,0x4
    342c:	b8050513          	addi	a0,a0,-1152 # 6fa8 <malloc+0x1a76>
    3430:	04a020ef          	jal	547a <printf>
    exit(1);
    3434:	4505                	li	a0,1
    3436:	3ef010ef          	jal	5024 <exit>
    printf("%s: write . succeeded!\n", s);
    343a:	85ca                	mv	a1,s2
    343c:	00004517          	auipc	a0,0x4
    3440:	b9450513          	addi	a0,a0,-1132 # 6fd0 <malloc+0x1a9e>
    3444:	036020ef          	jal	547a <printf>
    exit(1);
    3448:	4505                	li	a0,1
    344a:	3db010ef          	jal	5024 <exit>

000000000000344e <iref>:
{
    344e:	715d                	addi	sp,sp,-80
    3450:	e486                	sd	ra,72(sp)
    3452:	e0a2                	sd	s0,64(sp)
    3454:	fc26                	sd	s1,56(sp)
    3456:	f84a                	sd	s2,48(sp)
    3458:	f44e                	sd	s3,40(sp)
    345a:	f052                	sd	s4,32(sp)
    345c:	ec56                	sd	s5,24(sp)
    345e:	e85a                	sd	s6,16(sp)
    3460:	e45e                	sd	s7,8(sp)
    3462:	0880                	addi	s0,sp,80
    3464:	8baa                	mv	s7,a0
    3466:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    346a:	00004a97          	auipc	s5,0x4
    346e:	b7ea8a93          	addi	s5,s5,-1154 # 6fe8 <malloc+0x1ab6>
    mkdir("");
    3472:	00003497          	auipc	s1,0x3
    3476:	67e48493          	addi	s1,s1,1662 # 6af0 <malloc+0x15be>
    link("README", "");
    347a:	00002b17          	auipc	s6,0x2
    347e:	3c6b0b13          	addi	s6,s6,966 # 5840 <malloc+0x30e>
    fd = open("", O_CREATE);
    3482:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3486:	00004997          	auipc	s3,0x4
    348a:	a5a98993          	addi	s3,s3,-1446 # 6ee0 <malloc+0x19ae>
    348e:	a835                	j	34ca <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3490:	85de                	mv	a1,s7
    3492:	00004517          	auipc	a0,0x4
    3496:	b5e50513          	addi	a0,a0,-1186 # 6ff0 <malloc+0x1abe>
    349a:	7e1010ef          	jal	547a <printf>
      exit(1);
    349e:	4505                	li	a0,1
    34a0:	385010ef          	jal	5024 <exit>
      printf("%s: chdir irefd failed\n", s);
    34a4:	85de                	mv	a1,s7
    34a6:	00004517          	auipc	a0,0x4
    34aa:	b6250513          	addi	a0,a0,-1182 # 7008 <malloc+0x1ad6>
    34ae:	7cd010ef          	jal	547a <printf>
      exit(1);
    34b2:	4505                	li	a0,1
    34b4:	371010ef          	jal	5024 <exit>
      close(fd);
    34b8:	395010ef          	jal	504c <close>
    34bc:	a825                	j	34f4 <iref+0xa6>
    unlink("xx");
    34be:	854e                	mv	a0,s3
    34c0:	3b5010ef          	jal	5074 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34c4:	397d                	addiw	s2,s2,-1
    34c6:	04090063          	beqz	s2,3506 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34ca:	8556                	mv	a0,s5
    34cc:	3c1010ef          	jal	508c <mkdir>
    34d0:	f161                	bnez	a0,3490 <iref+0x42>
    if (chdir("irefd") != 0) {
    34d2:	8556                	mv	a0,s5
    34d4:	3c1010ef          	jal	5094 <chdir>
    34d8:	f571                	bnez	a0,34a4 <iref+0x56>
    mkdir("");
    34da:	8526                	mv	a0,s1
    34dc:	3b1010ef          	jal	508c <mkdir>
    link("README", "");
    34e0:	85a6                	mv	a1,s1
    34e2:	855a                	mv	a0,s6
    34e4:	3a1010ef          	jal	5084 <link>
    fd = open("", O_CREATE);
    34e8:	85d2                	mv	a1,s4
    34ea:	8526                	mv	a0,s1
    34ec:	379010ef          	jal	5064 <open>
    if (fd >= 0)
    34f0:	fc0554e3          	bgez	a0,34b8 <iref+0x6a>
    fd = open("xx", O_CREATE);
    34f4:	85d2                	mv	a1,s4
    34f6:	854e                	mv	a0,s3
    34f8:	36d010ef          	jal	5064 <open>
    if (fd >= 0)
    34fc:	fc0541e3          	bltz	a0,34be <iref+0x70>
      close(fd);
    3500:	34d010ef          	jal	504c <close>
    3504:	bf6d                	j	34be <iref+0x70>
    3506:	03300493          	li	s1,51
    chdir("..");
    350a:	00003997          	auipc	s3,0x3
    350e:	2fe98993          	addi	s3,s3,766 # 6808 <malloc+0x12d6>
    unlink("irefd");
    3512:	00004917          	auipc	s2,0x4
    3516:	ad690913          	addi	s2,s2,-1322 # 6fe8 <malloc+0x1ab6>
    chdir("..");
    351a:	854e                	mv	a0,s3
    351c:	379010ef          	jal	5094 <chdir>
    unlink("irefd");
    3520:	854a                	mv	a0,s2
    3522:	353010ef          	jal	5074 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3526:	34fd                	addiw	s1,s1,-1
    3528:	f8ed                	bnez	s1,351a <iref+0xcc>
  chdir("/");
    352a:	00003517          	auipc	a0,0x3
    352e:	28650513          	addi	a0,a0,646 # 67b0 <malloc+0x127e>
    3532:	363010ef          	jal	5094 <chdir>
}
    3536:	60a6                	ld	ra,72(sp)
    3538:	6406                	ld	s0,64(sp)
    353a:	74e2                	ld	s1,56(sp)
    353c:	7942                	ld	s2,48(sp)
    353e:	79a2                	ld	s3,40(sp)
    3540:	7a02                	ld	s4,32(sp)
    3542:	6ae2                	ld	s5,24(sp)
    3544:	6b42                	ld	s6,16(sp)
    3546:	6ba2                	ld	s7,8(sp)
    3548:	6161                	addi	sp,sp,80
    354a:	8082                	ret

000000000000354c <openiputtest>:
{
    354c:	7179                	addi	sp,sp,-48
    354e:	f406                	sd	ra,40(sp)
    3550:	f022                	sd	s0,32(sp)
    3552:	ec26                	sd	s1,24(sp)
    3554:	1800                	addi	s0,sp,48
    3556:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3558:	00004517          	auipc	a0,0x4
    355c:	ac850513          	addi	a0,a0,-1336 # 7020 <malloc+0x1aee>
    3560:	32d010ef          	jal	508c <mkdir>
    3564:	02054a63          	bltz	a0,3598 <openiputtest+0x4c>
  pid = fork();
    3568:	2b5010ef          	jal	501c <fork>
  if (pid < 0) {
    356c:	04054063          	bltz	a0,35ac <openiputtest+0x60>
  if (pid == 0) {
    3570:	e939                	bnez	a0,35c6 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3572:	4589                	li	a1,2
    3574:	00004517          	auipc	a0,0x4
    3578:	aac50513          	addi	a0,a0,-1364 # 7020 <malloc+0x1aee>
    357c:	2e9010ef          	jal	5064 <open>
    if (fd >= 0) {
    3580:	04054063          	bltz	a0,35c0 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3584:	85a6                	mv	a1,s1
    3586:	00004517          	auipc	a0,0x4
    358a:	aba50513          	addi	a0,a0,-1350 # 7040 <malloc+0x1b0e>
    358e:	6ed010ef          	jal	547a <printf>
      exit(1);
    3592:	4505                	li	a0,1
    3594:	291010ef          	jal	5024 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3598:	85a6                	mv	a1,s1
    359a:	00004517          	auipc	a0,0x4
    359e:	a8e50513          	addi	a0,a0,-1394 # 7028 <malloc+0x1af6>
    35a2:	6d9010ef          	jal	547a <printf>
    exit(1);
    35a6:	4505                	li	a0,1
    35a8:	27d010ef          	jal	5024 <exit>
    printf("%s: fork failed\n", s);
    35ac:	85a6                	mv	a1,s1
    35ae:	00003517          	auipc	a0,0x3
    35b2:	94a50513          	addi	a0,a0,-1718 # 5ef8 <malloc+0x9c6>
    35b6:	6c5010ef          	jal	547a <printf>
    exit(1);
    35ba:	4505                	li	a0,1
    35bc:	269010ef          	jal	5024 <exit>
    exit(0);
    35c0:	4501                	li	a0,0
    35c2:	263010ef          	jal	5024 <exit>
  pause(1);
    35c6:	4505                	li	a0,1
    35c8:	2ed010ef          	jal	50b4 <pause>
  if (unlink("oidir") != 0) {
    35cc:	00004517          	auipc	a0,0x4
    35d0:	a5450513          	addi	a0,a0,-1452 # 7020 <malloc+0x1aee>
    35d4:	2a1010ef          	jal	5074 <unlink>
    35d8:	c919                	beqz	a0,35ee <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35da:	85a6                	mv	a1,s1
    35dc:	00003517          	auipc	a0,0x3
    35e0:	aa450513          	addi	a0,a0,-1372 # 6080 <malloc+0xb4e>
    35e4:	697010ef          	jal	547a <printf>
    exit(1);
    35e8:	4505                	li	a0,1
    35ea:	23b010ef          	jal	5024 <exit>
  wait(&xstatus);
    35ee:	fdc40513          	addi	a0,s0,-36
    35f2:	23b010ef          	jal	502c <wait>
  exit(xstatus);
    35f6:	fdc42503          	lw	a0,-36(s0)
    35fa:	22b010ef          	jal	5024 <exit>

00000000000035fe <forkforkfork>:
{
    35fe:	1101                	addi	sp,sp,-32
    3600:	ec06                	sd	ra,24(sp)
    3602:	e822                	sd	s0,16(sp)
    3604:	e426                	sd	s1,8(sp)
    3606:	1000                	addi	s0,sp,32
    3608:	84aa                	mv	s1,a0
  unlink("stopforking");
    360a:	00004517          	auipc	a0,0x4
    360e:	a5e50513          	addi	a0,a0,-1442 # 7068 <malloc+0x1b36>
    3612:	263010ef          	jal	5074 <unlink>
  int pid = fork();
    3616:	207010ef          	jal	501c <fork>
  if (pid < 0) {
    361a:	02054b63          	bltz	a0,3650 <forkforkfork+0x52>
  if (pid == 0) {
    361e:	c139                	beqz	a0,3664 <forkforkfork+0x66>
  pause(20); // two seconds
    3620:	4551                	li	a0,20
    3622:	293010ef          	jal	50b4 <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3626:	20200593          	li	a1,514
    362a:	00004517          	auipc	a0,0x4
    362e:	a3e50513          	addi	a0,a0,-1474 # 7068 <malloc+0x1b36>
    3632:	233010ef          	jal	5064 <open>
    3636:	217010ef          	jal	504c <close>
  wait(0);
    363a:	4501                	li	a0,0
    363c:	1f1010ef          	jal	502c <wait>
  pause(10); // one second
    3640:	4529                	li	a0,10
    3642:	273010ef          	jal	50b4 <pause>
}
    3646:	60e2                	ld	ra,24(sp)
    3648:	6442                	ld	s0,16(sp)
    364a:	64a2                	ld	s1,8(sp)
    364c:	6105                	addi	sp,sp,32
    364e:	8082                	ret
    printf("%s: fork failed", s);
    3650:	85a6                	mv	a1,s1
    3652:	00003517          	auipc	a0,0x3
    3656:	9e650513          	addi	a0,a0,-1562 # 6038 <malloc+0xb06>
    365a:	621010ef          	jal	547a <printf>
    exit(1);
    365e:	4505                	li	a0,1
    3660:	1c5010ef          	jal	5024 <exit>
      int fd = open("stopforking", 0);
    3664:	4581                	li	a1,0
    3666:	00004517          	auipc	a0,0x4
    366a:	a0250513          	addi	a0,a0,-1534 # 7068 <malloc+0x1b36>
    366e:	1f7010ef          	jal	5064 <open>
      if (fd >= 0) {
    3672:	02055163          	bgez	a0,3694 <forkforkfork+0x96>
      if (fork() < 0) {
    3676:	1a7010ef          	jal	501c <fork>
    367a:	fe0555e3          	bgez	a0,3664 <forkforkfork+0x66>
        close(open("stopforking", O_CREATE | O_RDWR));
    367e:	20200593          	li	a1,514
    3682:	00004517          	auipc	a0,0x4
    3686:	9e650513          	addi	a0,a0,-1562 # 7068 <malloc+0x1b36>
    368a:	1db010ef          	jal	5064 <open>
    368e:	1bf010ef          	jal	504c <close>
    3692:	bfc9                	j	3664 <forkforkfork+0x66>
        exit(0);
    3694:	4501                	li	a0,0
    3696:	18f010ef          	jal	5024 <exit>

000000000000369a <exectest>:
{
    369a:	711d                	addi	sp,sp,-96
    369c:	ec86                	sd	ra,88(sp)
    369e:	e8a2                	sd	s0,80(sp)
    36a0:	e0ca                	sd	s2,64(sp)
    36a2:	1080                	addi	s0,sp,96
    36a4:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    36a6:	00002797          	auipc	a5,0x2
    36aa:	fc278793          	addi	a5,a5,-62 # 5668 <malloc+0x136>
    36ae:	faf43823          	sd	a5,-80(s0)
    36b2:	00004797          	auipc	a5,0x4
    36b6:	9c678793          	addi	a5,a5,-1594 # 7078 <malloc+0x1b46>
    36ba:	faf43c23          	sd	a5,-72(s0)
    36be:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    36c2:	00004517          	auipc	a0,0x4
    36c6:	9be50513          	addi	a0,a0,-1602 # 7080 <malloc+0x1b4e>
    36ca:	1ab010ef          	jal	5074 <unlink>
  pid = fork();
    36ce:	14f010ef          	jal	501c <fork>
  if (pid < 0) {
    36d2:	04054763          	bltz	a0,3720 <exectest+0x86>
    36d6:	e4a6                	sd	s1,72(sp)
    36d8:	fc4e                	sd	s3,56(sp)
    36da:	84aa                	mv	s1,a0
  if (pid == 0) {
    36dc:	ed49                	bnez	a0,3776 <exectest+0xdc>
    int errfd = dup(1);
    36de:	4505                	li	a0,1
    36e0:	1bd010ef          	jal	509c <dup>
    36e4:	89aa                	mv	s3,a0
    if (errfd < 0) {
    36e6:	04054963          	bltz	a0,3738 <exectest+0x9e>
    close(1);
    36ea:	4505                	li	a0,1
    36ec:	161010ef          	jal	504c <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    36f0:	20100593          	li	a1,513
    36f4:	00004517          	auipc	a0,0x4
    36f8:	98c50513          	addi	a0,a0,-1652 # 7080 <malloc+0x1b4e>
    36fc:	169010ef          	jal	5064 <open>
    if (fd < 0) {
    3700:	04054663          	bltz	a0,374c <exectest+0xb2>
    if (fd != 1) {
    3704:	4785                	li	a5,1
    3706:	04f50e63          	beq	a0,a5,3762 <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    370a:	864a                	mv	a2,s2
    370c:	00004597          	auipc	a1,0x4
    3710:	98c58593          	addi	a1,a1,-1652 # 7098 <malloc+0x1b66>
    3714:	854e                	mv	a0,s3
    3716:	53b010ef          	jal	5450 <fprintf>
      exit(1);
    371a:	4505                	li	a0,1
    371c:	109010ef          	jal	5024 <exit>
    3720:	e4a6                	sd	s1,72(sp)
    3722:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3724:	85ca                	mv	a1,s2
    3726:	00002517          	auipc	a0,0x2
    372a:	7d250513          	addi	a0,a0,2002 # 5ef8 <malloc+0x9c6>
    372e:	54d010ef          	jal	547a <printf>
    exit(1);
    3732:	4505                	li	a0,1
    3734:	0f1010ef          	jal	5024 <exit>
      printf("%s: dup failed\n", s);
    3738:	85ca                	mv	a1,s2
    373a:	00004517          	auipc	a0,0x4
    373e:	94e50513          	addi	a0,a0,-1714 # 7088 <malloc+0x1b56>
    3742:	539010ef          	jal	547a <printf>
      exit(1);
    3746:	4505                	li	a0,1
    3748:	0dd010ef          	jal	5024 <exit>
      fprintf(errfd, "%s: create failed\n", s);
    374c:	864a                	mv	a2,s2
    374e:	00003597          	auipc	a1,0x3
    3752:	91a58593          	addi	a1,a1,-1766 # 6068 <malloc+0xb36>
    3756:	854e                	mv	a0,s3
    3758:	4f9010ef          	jal	5450 <fprintf>
      exit(1);
    375c:	4505                	li	a0,1
    375e:	0c7010ef          	jal	5024 <exit>
    if (exec("echo", echoargv) < 0) {
    3762:	fb040593          	addi	a1,s0,-80
    3766:	00002517          	auipc	a0,0x2
    376a:	f0250513          	addi	a0,a0,-254 # 5668 <malloc+0x136>
    376e:	0ef010ef          	jal	505c <exec>
    3772:	02054563          	bltz	a0,379c <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3776:	fcc40513          	addi	a0,s0,-52
    377a:	0b3010ef          	jal	502c <wait>
    377e:	02951a63          	bne	a0,s1,37b2 <exectest+0x118>
  if (xstatus != 0) {
    3782:	fcc42603          	lw	a2,-52(s0)
    3786:	ce15                	beqz	a2,37c2 <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3788:	85ca                	mv	a1,s2
    378a:	00004517          	auipc	a0,0x4
    378e:	94e50513          	addi	a0,a0,-1714 # 70d8 <malloc+0x1ba6>
    3792:	4e9010ef          	jal	547a <printf>
    exit(1);
    3796:	4505                	li	a0,1
    3798:	08d010ef          	jal	5024 <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    379c:	864a                	mv	a2,s2
    379e:	00004597          	auipc	a1,0x4
    37a2:	90a58593          	addi	a1,a1,-1782 # 70a8 <malloc+0x1b76>
    37a6:	854e                	mv	a0,s3
    37a8:	4a9010ef          	jal	5450 <fprintf>
      exit(1);
    37ac:	4505                	li	a0,1
    37ae:	077010ef          	jal	5024 <exit>
    printf("%s: wait failed!\n", s);
    37b2:	85ca                	mv	a1,s2
    37b4:	00004517          	auipc	a0,0x4
    37b8:	90c50513          	addi	a0,a0,-1780 # 70c0 <malloc+0x1b8e>
    37bc:	4bf010ef          	jal	547a <printf>
    37c0:	b7c9                	j	3782 <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    37c2:	4581                	li	a1,0
    37c4:	00004517          	auipc	a0,0x4
    37c8:	8bc50513          	addi	a0,a0,-1860 # 7080 <malloc+0x1b4e>
    37cc:	099010ef          	jal	5064 <open>
  if (fd < 0) {
    37d0:	02054463          	bltz	a0,37f8 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    37d4:	4609                	li	a2,2
    37d6:	fa840593          	addi	a1,s0,-88
    37da:	063010ef          	jal	503c <read>
    37de:	4789                	li	a5,2
    37e0:	02f50663          	beq	a0,a5,380c <exectest+0x172>
    printf("%s: read failed\n", s);
    37e4:	85ca                	mv	a1,s2
    37e6:	00002517          	auipc	a0,0x2
    37ea:	25250513          	addi	a0,a0,594 # 5a38 <malloc+0x506>
    37ee:	48d010ef          	jal	547a <printf>
    exit(1);
    37f2:	4505                	li	a0,1
    37f4:	031010ef          	jal	5024 <exit>
    printf("%s: open failed\n", s);
    37f8:	85ca                	mv	a1,s2
    37fa:	00002517          	auipc	a0,0x2
    37fe:	71650513          	addi	a0,a0,1814 # 5f10 <malloc+0x9de>
    3802:	479010ef          	jal	547a <printf>
    exit(1);
    3806:	4505                	li	a0,1
    3808:	01d010ef          	jal	5024 <exit>
  unlink("echo-ok");
    380c:	00004517          	auipc	a0,0x4
    3810:	87450513          	addi	a0,a0,-1932 # 7080 <malloc+0x1b4e>
    3814:	061010ef          	jal	5074 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    3818:	fa844703          	lbu	a4,-88(s0)
    381c:	04f00793          	li	a5,79
    3820:	00f71863          	bne	a4,a5,3830 <exectest+0x196>
    3824:	fa944703          	lbu	a4,-87(s0)
    3828:	04b00793          	li	a5,75
    382c:	00f70c63          	beq	a4,a5,3844 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    3830:	85ca                	mv	a1,s2
    3832:	00004517          	auipc	a0,0x4
    3836:	8c650513          	addi	a0,a0,-1850 # 70f8 <malloc+0x1bc6>
    383a:	441010ef          	jal	547a <printf>
    exit(1);
    383e:	4505                	li	a0,1
    3840:	7e4010ef          	jal	5024 <exit>
    exit(0);
    3844:	4501                	li	a0,0
    3846:	7de010ef          	jal	5024 <exit>

000000000000384a <killstatus>:
{
    384a:	715d                	addi	sp,sp,-80
    384c:	e486                	sd	ra,72(sp)
    384e:	e0a2                	sd	s0,64(sp)
    3850:	fc26                	sd	s1,56(sp)
    3852:	f84a                	sd	s2,48(sp)
    3854:	f44e                	sd	s3,40(sp)
    3856:	f052                	sd	s4,32(sp)
    3858:	ec56                	sd	s5,24(sp)
    385a:	e85a                	sd	s6,16(sp)
    385c:	0880                	addi	s0,sp,80
    385e:	8b2a                	mv	s6,a0
    3860:	06400913          	li	s2,100
    pause(1);
    3864:	4a85                	li	s5,1
    wait(&xst);
    3866:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    386a:	59fd                	li	s3,-1
    int pid1 = fork();
    386c:	7b0010ef          	jal	501c <fork>
    3870:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    3872:	02054663          	bltz	a0,389e <killstatus+0x54>
    if (pid1 == 0) {
    3876:	cd15                	beqz	a0,38b2 <killstatus+0x68>
    pause(1);
    3878:	8556                	mv	a0,s5
    387a:	03b010ef          	jal	50b4 <pause>
    kill(pid1);
    387e:	8526                	mv	a0,s1
    3880:	7d4010ef          	jal	5054 <kill>
    wait(&xst);
    3884:	8552                	mv	a0,s4
    3886:	7a6010ef          	jal	502c <wait>
    if (xst != -1) {
    388a:	fbc42783          	lw	a5,-68(s0)
    388e:	03379563          	bne	a5,s3,38b8 <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    3892:	397d                	addiw	s2,s2,-1
    3894:	fc091ce3          	bnez	s2,386c <killstatus+0x22>
  exit(0);
    3898:	4501                	li	a0,0
    389a:	78a010ef          	jal	5024 <exit>
      printf("%s: fork failed\n", s);
    389e:	85da                	mv	a1,s6
    38a0:	00002517          	auipc	a0,0x2
    38a4:	65850513          	addi	a0,a0,1624 # 5ef8 <malloc+0x9c6>
    38a8:	3d3010ef          	jal	547a <printf>
      exit(1);
    38ac:	4505                	li	a0,1
    38ae:	776010ef          	jal	5024 <exit>
        getpid();
    38b2:	7f2010ef          	jal	50a4 <getpid>
      while (1) {
    38b6:	bff5                	j	38b2 <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    38b8:	85da                	mv	a1,s6
    38ba:	00004517          	auipc	a0,0x4
    38be:	85650513          	addi	a0,a0,-1962 # 7110 <malloc+0x1bde>
    38c2:	3b9010ef          	jal	547a <printf>
      exit(1);
    38c6:	4505                	li	a0,1
    38c8:	75c010ef          	jal	5024 <exit>

00000000000038cc <preempt>:
{
    38cc:	7139                	addi	sp,sp,-64
    38ce:	fc06                	sd	ra,56(sp)
    38d0:	f822                	sd	s0,48(sp)
    38d2:	f426                	sd	s1,40(sp)
    38d4:	f04a                	sd	s2,32(sp)
    38d6:	ec4e                	sd	s3,24(sp)
    38d8:	e852                	sd	s4,16(sp)
    38da:	0080                	addi	s0,sp,64
    38dc:	892a                	mv	s2,a0
  pid1 = fork();
    38de:	73e010ef          	jal	501c <fork>
  if (pid1 < 0) {
    38e2:	00054563          	bltz	a0,38ec <preempt+0x20>
    38e6:	84aa                	mv	s1,a0
  if (pid1 == 0)
    38e8:	ed01                	bnez	a0,3900 <preempt+0x34>
    for (;;)
    38ea:	a001                	j	38ea <preempt+0x1e>
    printf("%s: fork failed", s);
    38ec:	85ca                	mv	a1,s2
    38ee:	00002517          	auipc	a0,0x2
    38f2:	74a50513          	addi	a0,a0,1866 # 6038 <malloc+0xb06>
    38f6:	385010ef          	jal	547a <printf>
    exit(1);
    38fa:	4505                	li	a0,1
    38fc:	728010ef          	jal	5024 <exit>
  pid2 = fork();
    3900:	71c010ef          	jal	501c <fork>
    3904:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3906:	00054463          	bltz	a0,390e <preempt+0x42>
  if (pid2 == 0)
    390a:	ed01                	bnez	a0,3922 <preempt+0x56>
    for (;;)
    390c:	a001                	j	390c <preempt+0x40>
    printf("%s: fork failed\n", s);
    390e:	85ca                	mv	a1,s2
    3910:	00002517          	auipc	a0,0x2
    3914:	5e850513          	addi	a0,a0,1512 # 5ef8 <malloc+0x9c6>
    3918:	363010ef          	jal	547a <printf>
    exit(1);
    391c:	4505                	li	a0,1
    391e:	706010ef          	jal	5024 <exit>
  pipe(pfds);
    3922:	fc840513          	addi	a0,s0,-56
    3926:	70e010ef          	jal	5034 <pipe>
  pid3 = fork();
    392a:	6f2010ef          	jal	501c <fork>
    392e:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3930:	02054863          	bltz	a0,3960 <preempt+0x94>
  if (pid3 == 0) {
    3934:	e921                	bnez	a0,3984 <preempt+0xb8>
    close(pfds[0]);
    3936:	fc842503          	lw	a0,-56(s0)
    393a:	712010ef          	jal	504c <close>
    if (write(pfds[1], "x", 1) != 1)
    393e:	4605                	li	a2,1
    3940:	00002597          	auipc	a1,0x2
    3944:	d9858593          	addi	a1,a1,-616 # 56d8 <malloc+0x1a6>
    3948:	fcc42503          	lw	a0,-52(s0)
    394c:	6f8010ef          	jal	5044 <write>
    3950:	4785                	li	a5,1
    3952:	02f51163          	bne	a0,a5,3974 <preempt+0xa8>
    close(pfds[1]);
    3956:	fcc42503          	lw	a0,-52(s0)
    395a:	6f2010ef          	jal	504c <close>
    for (;;)
    395e:	a001                	j	395e <preempt+0x92>
    printf("%s: fork failed\n", s);
    3960:	85ca                	mv	a1,s2
    3962:	00002517          	auipc	a0,0x2
    3966:	59650513          	addi	a0,a0,1430 # 5ef8 <malloc+0x9c6>
    396a:	311010ef          	jal	547a <printf>
    exit(1);
    396e:	4505                	li	a0,1
    3970:	6b4010ef          	jal	5024 <exit>
      printf("%s: preempt write error", s);
    3974:	85ca                	mv	a1,s2
    3976:	00003517          	auipc	a0,0x3
    397a:	7ba50513          	addi	a0,a0,1978 # 7130 <malloc+0x1bfe>
    397e:	2fd010ef          	jal	547a <printf>
    3982:	bfd1                	j	3956 <preempt+0x8a>
  close(pfds[1]);
    3984:	fcc42503          	lw	a0,-52(s0)
    3988:	6c4010ef          	jal	504c <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    398c:	660d                	lui	a2,0x3
    398e:	00008597          	auipc	a1,0x8
    3992:	32a58593          	addi	a1,a1,810 # bcb8 <buf>
    3996:	fc842503          	lw	a0,-56(s0)
    399a:	6a2010ef          	jal	503c <read>
    399e:	4785                	li	a5,1
    39a0:	02f50163          	beq	a0,a5,39c2 <preempt+0xf6>
    printf("%s: preempt read error", s);
    39a4:	85ca                	mv	a1,s2
    39a6:	00003517          	auipc	a0,0x3
    39aa:	7a250513          	addi	a0,a0,1954 # 7148 <malloc+0x1c16>
    39ae:	2cd010ef          	jal	547a <printf>
}
    39b2:	70e2                	ld	ra,56(sp)
    39b4:	7442                	ld	s0,48(sp)
    39b6:	74a2                	ld	s1,40(sp)
    39b8:	7902                	ld	s2,32(sp)
    39ba:	69e2                	ld	s3,24(sp)
    39bc:	6a42                	ld	s4,16(sp)
    39be:	6121                	addi	sp,sp,64
    39c0:	8082                	ret
  close(pfds[0]);
    39c2:	fc842503          	lw	a0,-56(s0)
    39c6:	686010ef          	jal	504c <close>
  printf("kill... ");
    39ca:	00003517          	auipc	a0,0x3
    39ce:	79650513          	addi	a0,a0,1942 # 7160 <malloc+0x1c2e>
    39d2:	2a9010ef          	jal	547a <printf>
  kill(pid1);
    39d6:	8526                	mv	a0,s1
    39d8:	67c010ef          	jal	5054 <kill>
  kill(pid2);
    39dc:	854e                	mv	a0,s3
    39de:	676010ef          	jal	5054 <kill>
  kill(pid3);
    39e2:	8552                	mv	a0,s4
    39e4:	670010ef          	jal	5054 <kill>
  printf("wait... ");
    39e8:	00003517          	auipc	a0,0x3
    39ec:	78850513          	addi	a0,a0,1928 # 7170 <malloc+0x1c3e>
    39f0:	28b010ef          	jal	547a <printf>
  wait(0);
    39f4:	4501                	li	a0,0
    39f6:	636010ef          	jal	502c <wait>
  wait(0);
    39fa:	4501                	li	a0,0
    39fc:	630010ef          	jal	502c <wait>
  wait(0);
    3a00:	4501                	li	a0,0
    3a02:	62a010ef          	jal	502c <wait>
    3a06:	b775                	j	39b2 <preempt+0xe6>

0000000000003a08 <reparent>:
{
    3a08:	7179                	addi	sp,sp,-48
    3a0a:	f406                	sd	ra,40(sp)
    3a0c:	f022                	sd	s0,32(sp)
    3a0e:	ec26                	sd	s1,24(sp)
    3a10:	e84a                	sd	s2,16(sp)
    3a12:	e44e                	sd	s3,8(sp)
    3a14:	e052                	sd	s4,0(sp)
    3a16:	1800                	addi	s0,sp,48
    3a18:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3a1a:	68a010ef          	jal	50a4 <getpid>
    3a1e:	8a2a                	mv	s4,a0
    3a20:	0c800913          	li	s2,200
    int pid = fork();
    3a24:	5f8010ef          	jal	501c <fork>
    3a28:	84aa                	mv	s1,a0
    if (pid < 0) {
    3a2a:	00054e63          	bltz	a0,3a46 <reparent+0x3e>
    if (pid) {
    3a2e:	c121                	beqz	a0,3a6e <reparent+0x66>
      if (wait(0) != pid) {
    3a30:	4501                	li	a0,0
    3a32:	5fa010ef          	jal	502c <wait>
    3a36:	02951263          	bne	a0,s1,3a5a <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3a3a:	397d                	addiw	s2,s2,-1
    3a3c:	fe0914e3          	bnez	s2,3a24 <reparent+0x1c>
  exit(0);
    3a40:	4501                	li	a0,0
    3a42:	5e2010ef          	jal	5024 <exit>
      printf("%s: fork failed\n", s);
    3a46:	85ce                	mv	a1,s3
    3a48:	00002517          	auipc	a0,0x2
    3a4c:	4b050513          	addi	a0,a0,1200 # 5ef8 <malloc+0x9c6>
    3a50:	22b010ef          	jal	547a <printf>
      exit(1);
    3a54:	4505                	li	a0,1
    3a56:	5ce010ef          	jal	5024 <exit>
        printf("%s: wait wrong pid\n", s);
    3a5a:	85ce                	mv	a1,s3
    3a5c:	00002517          	auipc	a0,0x2
    3a60:	5a450513          	addi	a0,a0,1444 # 6000 <malloc+0xace>
    3a64:	217010ef          	jal	547a <printf>
        exit(1);
    3a68:	4505                	li	a0,1
    3a6a:	5ba010ef          	jal	5024 <exit>
      int pid2 = fork();
    3a6e:	5ae010ef          	jal	501c <fork>
      if (pid2 < 0) {
    3a72:	00054563          	bltz	a0,3a7c <reparent+0x74>
      exit(0);
    3a76:	4501                	li	a0,0
    3a78:	5ac010ef          	jal	5024 <exit>
        kill(master_pid);
    3a7c:	8552                	mv	a0,s4
    3a7e:	5d6010ef          	jal	5054 <kill>
        exit(1);
    3a82:	4505                	li	a0,1
    3a84:	5a0010ef          	jal	5024 <exit>

0000000000003a88 <sbrkfail>:
{
    3a88:	7175                	addi	sp,sp,-144
    3a8a:	e506                	sd	ra,136(sp)
    3a8c:	e122                	sd	s0,128(sp)
    3a8e:	fca6                	sd	s1,120(sp)
    3a90:	f8ca                	sd	s2,112(sp)
    3a92:	f4ce                	sd	s3,104(sp)
    3a94:	f0d2                	sd	s4,96(sp)
    3a96:	ecd6                	sd	s5,88(sp)
    3a98:	e8da                	sd	s6,80(sp)
    3a9a:	e4de                	sd	s7,72(sp)
    3a9c:	e0e2                	sd	s8,64(sp)
    3a9e:	0900                	addi	s0,sp,144
    3aa0:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    3aa2:	fa040513          	addi	a0,s0,-96
    3aa6:	58e010ef          	jal	5034 <pipe>
    3aaa:	ed01                	bnez	a0,3ac2 <sbrkfail+0x3a>
    3aac:	8baa                	mv	s7,a0
    3aae:	f7040493          	addi	s1,s0,-144
    3ab2:	f9840993          	addi	s3,s0,-104
    3ab6:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3ab8:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3aba:	f9f40b13          	addi	s6,s0,-97
    3abe:	4a85                	li	s5,1
    3ac0:	a095                	j	3b24 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3ac2:	85e2                	mv	a1,s8
    3ac4:	00002517          	auipc	a0,0x2
    3ac8:	4bc50513          	addi	a0,a0,1212 # 5f80 <malloc+0xa4e>
    3acc:	1af010ef          	jal	547a <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	552010ef          	jal	5024 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3ad6:	51a010ef          	jal	4ff0 <sbrk>
    3ada:	064007b7          	lui	a5,0x6400
    3ade:	40a7853b          	subw	a0,a5,a0
    3ae2:	50e010ef          	jal	4ff0 <sbrk>
    3ae6:	57fd                	li	a5,-1
    3ae8:	02f50163          	beq	a0,a5,3b0a <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3aec:	4605                	li	a2,1
    3aee:	00004597          	auipc	a1,0x4
    3af2:	e0a58593          	addi	a1,a1,-502 # 78f8 <malloc+0x23c6>
    3af6:	fa442503          	lw	a0,-92(s0)
    3afa:	54a010ef          	jal	5044 <write>
        pause(1000);
    3afe:	3e800493          	li	s1,1000
    3b02:	8526                	mv	a0,s1
    3b04:	5b0010ef          	jal	50b4 <pause>
      for (;;)
    3b08:	bfed                	j	3b02 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3b0a:	4605                	li	a2,1
    3b0c:	00003597          	auipc	a1,0x3
    3b10:	67458593          	addi	a1,a1,1652 # 7180 <malloc+0x1c4e>
    3b14:	fa442503          	lw	a0,-92(s0)
    3b18:	52c010ef          	jal	5044 <write>
    3b1c:	b7cd                	j	3afe <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3b1e:	0911                	addi	s2,s2,4
    3b20:	03390a63          	beq	s2,s3,3b54 <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3b24:	4f8010ef          	jal	501c <fork>
    3b28:	00a92023          	sw	a0,0(s2)
    3b2c:	d54d                	beqz	a0,3ad6 <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3b2e:	ff4508e3          	beq	a0,s4,3b1e <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3b32:	8656                	mv	a2,s5
    3b34:	85da                	mv	a1,s6
    3b36:	fa042503          	lw	a0,-96(s0)
    3b3a:	502010ef          	jal	503c <read>
      if (scratch == '0')
    3b3e:	f9f44783          	lbu	a5,-97(s0)
    3b42:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63f1318>
    3b46:	0017b793          	seqz	a5,a5
    3b4a:	00fbe7b3          	or	a5,s7,a5
    3b4e:	00078b9b          	sext.w	s7,a5
    3b52:	b7f1                	j	3b1e <sbrkfail+0x96>
  if (!failed) {
    3b54:	000b8863          	beqz	s7,3b64 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3b58:	6505                	lui	a0,0x1
    3b5a:	496010ef          	jal	4ff0 <sbrk>
    3b5e:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3b60:	597d                	li	s2,-1
    3b62:	a821                	j	3b7a <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3b64:	85e2                	mv	a1,s8
    3b66:	00003517          	auipc	a0,0x3
    3b6a:	62250513          	addi	a0,a0,1570 # 7188 <malloc+0x1c56>
    3b6e:	10d010ef          	jal	547a <printf>
    3b72:	b7dd                	j	3b58 <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3b74:	0491                	addi	s1,s1,4
    3b76:	01348b63          	beq	s1,s3,3b8c <sbrkfail+0x104>
    if (pids[i] == -1)
    3b7a:	4088                	lw	a0,0(s1)
    3b7c:	ff250ce3          	beq	a0,s2,3b74 <sbrkfail+0xec>
    kill(pids[i]);
    3b80:	4d4010ef          	jal	5054 <kill>
    wait(0);
    3b84:	4501                	li	a0,0
    3b86:	4a6010ef          	jal	502c <wait>
    3b8a:	b7ed                	j	3b74 <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3b8c:	57fd                	li	a5,-1
    3b8e:	02fa0a63          	beq	s4,a5,3bc2 <sbrkfail+0x13a>
  pid = fork();
    3b92:	48a010ef          	jal	501c <fork>
  if (pid < 0) {
    3b96:	04054063          	bltz	a0,3bd6 <sbrkfail+0x14e>
  if (pid == 0) {
    3b9a:	e939                	bnez	a0,3bf0 <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3b9c:	3e800537          	lui	a0,0x3e800
    3ba0:	450010ef          	jal	4ff0 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3ba4:	57fd                	li	a5,-1
    3ba6:	04f50263          	beq	a0,a5,3bea <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3baa:	3e800637          	lui	a2,0x3e800
    3bae:	85e2                	mv	a1,s8
    3bb0:	00003517          	auipc	a0,0x3
    3bb4:	62850513          	addi	a0,a0,1576 # 71d8 <malloc+0x1ca6>
    3bb8:	0c3010ef          	jal	547a <printf>
    exit(1);
    3bbc:	4505                	li	a0,1
    3bbe:	466010ef          	jal	5024 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3bc2:	85e2                	mv	a1,s8
    3bc4:	00003517          	auipc	a0,0x3
    3bc8:	5f450513          	addi	a0,a0,1524 # 71b8 <malloc+0x1c86>
    3bcc:	0af010ef          	jal	547a <printf>
    exit(1);
    3bd0:	4505                	li	a0,1
    3bd2:	452010ef          	jal	5024 <exit>
    printf("%s: fork failed\n", s);
    3bd6:	85e2                	mv	a1,s8
    3bd8:	00002517          	auipc	a0,0x2
    3bdc:	32050513          	addi	a0,a0,800 # 5ef8 <malloc+0x9c6>
    3be0:	09b010ef          	jal	547a <printf>
    exit(1);
    3be4:	4505                	li	a0,1
    3be6:	43e010ef          	jal	5024 <exit>
      exit(0);
    3bea:	4501                	li	a0,0
    3bec:	438010ef          	jal	5024 <exit>
  wait(&xstatus);
    3bf0:	fac40513          	addi	a0,s0,-84
    3bf4:	438010ef          	jal	502c <wait>
  if (xstatus != 0)
    3bf8:	fac42783          	lw	a5,-84(s0)
    3bfc:	ef89                	bnez	a5,3c16 <sbrkfail+0x18e>
}
    3bfe:	60aa                	ld	ra,136(sp)
    3c00:	640a                	ld	s0,128(sp)
    3c02:	74e6                	ld	s1,120(sp)
    3c04:	7946                	ld	s2,112(sp)
    3c06:	79a6                	ld	s3,104(sp)
    3c08:	7a06                	ld	s4,96(sp)
    3c0a:	6ae6                	ld	s5,88(sp)
    3c0c:	6b46                	ld	s6,80(sp)
    3c0e:	6ba6                	ld	s7,72(sp)
    3c10:	6c06                	ld	s8,64(sp)
    3c12:	6149                	addi	sp,sp,144
    3c14:	8082                	ret
    exit(1);
    3c16:	4505                	li	a0,1
    3c18:	40c010ef          	jal	5024 <exit>

0000000000003c1c <mem>:
{
    3c1c:	7139                	addi	sp,sp,-64
    3c1e:	fc06                	sd	ra,56(sp)
    3c20:	f822                	sd	s0,48(sp)
    3c22:	f426                	sd	s1,40(sp)
    3c24:	f04a                	sd	s2,32(sp)
    3c26:	ec4e                	sd	s3,24(sp)
    3c28:	0080                	addi	s0,sp,64
    3c2a:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3c2c:	3f0010ef          	jal	501c <fork>
    m1 = 0;
    3c30:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3c32:	6909                	lui	s2,0x2
    3c34:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xed>
  if ((pid = fork()) == 0) {
    3c38:	cd11                	beqz	a0,3c54 <mem+0x38>
    wait(&xstatus);
    3c3a:	fcc40513          	addi	a0,s0,-52
    3c3e:	3ee010ef          	jal	502c <wait>
    if (xstatus == -1) {
    3c42:	fcc42503          	lw	a0,-52(s0)
    3c46:	57fd                	li	a5,-1
    3c48:	04f50363          	beq	a0,a5,3c8e <mem+0x72>
    exit(xstatus);
    3c4c:	3d8010ef          	jal	5024 <exit>
      *(char **)m2 = m1;
    3c50:	e104                	sd	s1,0(a0)
      m1 = m2;
    3c52:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3c54:	854a                	mv	a0,s2
    3c56:	0dd010ef          	jal	5532 <malloc>
    3c5a:	f97d                	bnez	a0,3c50 <mem+0x34>
    while (m1) {
    3c5c:	c491                	beqz	s1,3c68 <mem+0x4c>
      m2 = *(char **)m1;
    3c5e:	8526                	mv	a0,s1
    3c60:	6084                	ld	s1,0(s1)
      free(m1);
    3c62:	04b010ef          	jal	54ac <free>
    while (m1) {
    3c66:	fce5                	bnez	s1,3c5e <mem+0x42>
    m1 = malloc(1024 * 20);
    3c68:	6515                	lui	a0,0x5
    3c6a:	0c9010ef          	jal	5532 <malloc>
    if (m1 == 0) {
    3c6e:	c511                	beqz	a0,3c7a <mem+0x5e>
    free(m1);
    3c70:	03d010ef          	jal	54ac <free>
    exit(0);
    3c74:	4501                	li	a0,0
    3c76:	3ae010ef          	jal	5024 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c7a:	85ce                	mv	a1,s3
    3c7c:	00003517          	auipc	a0,0x3
    3c80:	58c50513          	addi	a0,a0,1420 # 7208 <malloc+0x1cd6>
    3c84:	7f6010ef          	jal	547a <printf>
      exit(1);
    3c88:	4505                	li	a0,1
    3c8a:	39a010ef          	jal	5024 <exit>
      exit(0);
    3c8e:	4501                	li	a0,0
    3c90:	394010ef          	jal	5024 <exit>

0000000000003c94 <sharedfd>:
{
    3c94:	7159                	addi	sp,sp,-112
    3c96:	f486                	sd	ra,104(sp)
    3c98:	f0a2                	sd	s0,96(sp)
    3c9a:	eca6                	sd	s1,88(sp)
    3c9c:	f85a                	sd	s6,48(sp)
    3c9e:	1880                	addi	s0,sp,112
    3ca0:	84aa                	mv	s1,a0
    3ca2:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3ca4:	00003517          	auipc	a0,0x3
    3ca8:	58450513          	addi	a0,a0,1412 # 7228 <malloc+0x1cf6>
    3cac:	3c8010ef          	jal	5074 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3cb0:	20200593          	li	a1,514
    3cb4:	00003517          	auipc	a0,0x3
    3cb8:	57450513          	addi	a0,a0,1396 # 7228 <malloc+0x1cf6>
    3cbc:	3a8010ef          	jal	5064 <open>
  if (fd < 0) {
    3cc0:	04054863          	bltz	a0,3d10 <sharedfd+0x7c>
    3cc4:	e8ca                	sd	s2,80(sp)
    3cc6:	e4ce                	sd	s3,72(sp)
    3cc8:	e0d2                	sd	s4,64(sp)
    3cca:	fc56                	sd	s5,56(sp)
    3ccc:	89aa                	mv	s3,a0
  pid = fork();
    3cce:	34e010ef          	jal	501c <fork>
    3cd2:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3cd4:	07000593          	li	a1,112
    3cd8:	e119                	bnez	a0,3cde <sharedfd+0x4a>
    3cda:	06300593          	li	a1,99
    3cde:	4629                	li	a2,10
    3ce0:	fa040513          	addi	a0,s0,-96
    3ce4:	116010ef          	jal	4dfa <memset>
    3ce8:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3cec:	fa040a13          	addi	s4,s0,-96
    3cf0:	4929                	li	s2,10
    3cf2:	864a                	mv	a2,s2
    3cf4:	85d2                	mv	a1,s4
    3cf6:	854e                	mv	a0,s3
    3cf8:	34c010ef          	jal	5044 <write>
    3cfc:	03251963          	bne	a0,s2,3d2e <sharedfd+0x9a>
  for (i = 0; i < N; i++) {
    3d00:	34fd                	addiw	s1,s1,-1
    3d02:	f8e5                	bnez	s1,3cf2 <sharedfd+0x5e>
  if (pid == 0) {
    3d04:	040a9063          	bnez	s5,3d44 <sharedfd+0xb0>
    3d08:	f45e                	sd	s7,40(sp)
    exit(0);
    3d0a:	4501                	li	a0,0
    3d0c:	318010ef          	jal	5024 <exit>
    3d10:	e8ca                	sd	s2,80(sp)
    3d12:	e4ce                	sd	s3,72(sp)
    3d14:	e0d2                	sd	s4,64(sp)
    3d16:	fc56                	sd	s5,56(sp)
    3d18:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3d1a:	85a6                	mv	a1,s1
    3d1c:	00003517          	auipc	a0,0x3
    3d20:	51c50513          	addi	a0,a0,1308 # 7238 <malloc+0x1d06>
    3d24:	756010ef          	jal	547a <printf>
    exit(1);
    3d28:	4505                	li	a0,1
    3d2a:	2fa010ef          	jal	5024 <exit>
    3d2e:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3d30:	85da                	mv	a1,s6
    3d32:	00003517          	auipc	a0,0x3
    3d36:	52e50513          	addi	a0,a0,1326 # 7260 <malloc+0x1d2e>
    3d3a:	740010ef          	jal	547a <printf>
      exit(1);
    3d3e:	4505                	li	a0,1
    3d40:	2e4010ef          	jal	5024 <exit>
    wait(&xstatus);
    3d44:	f9c40513          	addi	a0,s0,-100
    3d48:	2e4010ef          	jal	502c <wait>
    if (xstatus != 0)
    3d4c:	f9c42a03          	lw	s4,-100(s0)
    3d50:	000a0663          	beqz	s4,3d5c <sharedfd+0xc8>
    3d54:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3d56:	8552                	mv	a0,s4
    3d58:	2cc010ef          	jal	5024 <exit>
    3d5c:	f45e                	sd	s7,40(sp)
  close(fd);
    3d5e:	854e                	mv	a0,s3
    3d60:	2ec010ef          	jal	504c <close>
  fd = open("sharedfd", 0);
    3d64:	4581                	li	a1,0
    3d66:	00003517          	auipc	a0,0x3
    3d6a:	4c250513          	addi	a0,a0,1218 # 7228 <malloc+0x1cf6>
    3d6e:	2f6010ef          	jal	5064 <open>
    3d72:	8baa                	mv	s7,a0
  nc = np = 0;
    3d74:	89d2                	mv	s3,s4
  if (fd < 0) {
    3d76:	02054363          	bltz	a0,3d9c <sharedfd+0x108>
    3d7a:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    3d7e:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3d82:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3d86:	4629                	li	a2,10
    3d88:	fa040593          	addi	a1,s0,-96
    3d8c:	855e                	mv	a0,s7
    3d8e:	2ae010ef          	jal	503c <read>
    3d92:	02a05b63          	blez	a0,3dc8 <sharedfd+0x134>
    3d96:	fa040793          	addi	a5,s0,-96
    3d9a:	a839                	j	3db8 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3d9c:	85da                	mv	a1,s6
    3d9e:	00003517          	auipc	a0,0x3
    3da2:	4e250513          	addi	a0,a0,1250 # 7280 <malloc+0x1d4e>
    3da6:	6d4010ef          	jal	547a <printf>
    exit(1);
    3daa:	4505                	li	a0,1
    3dac:	278010ef          	jal	5024 <exit>
        nc++;
    3db0:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    3db2:	0785                	addi	a5,a5,1
    3db4:	fd2789e3          	beq	a5,s2,3d86 <sharedfd+0xf2>
      if (buf[i] == 'c')
    3db8:	0007c703          	lbu	a4,0(a5)
    3dbc:	fe970ae3          	beq	a4,s1,3db0 <sharedfd+0x11c>
      if (buf[i] == 'p')
    3dc0:	ff5719e3          	bne	a4,s5,3db2 <sharedfd+0x11e>
        np++;
    3dc4:	2985                	addiw	s3,s3,1
    3dc6:	b7f5                	j	3db2 <sharedfd+0x11e>
  close(fd);
    3dc8:	855e                	mv	a0,s7
    3dca:	282010ef          	jal	504c <close>
  unlink("sharedfd");
    3dce:	00003517          	auipc	a0,0x3
    3dd2:	45a50513          	addi	a0,a0,1114 # 7228 <malloc+0x1cf6>
    3dd6:	29e010ef          	jal	5074 <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3dda:	6789                	lui	a5,0x2
    3ddc:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xec>
    3de0:	00fa1763          	bne	s4,a5,3dee <sharedfd+0x15a>
    3de4:	01499563          	bne	s3,s4,3dee <sharedfd+0x15a>
    exit(0);
    3de8:	4501                	li	a0,0
    3dea:	23a010ef          	jal	5024 <exit>
    printf("%s: nc/np test fails\n", s);
    3dee:	85da                	mv	a1,s6
    3df0:	00003517          	auipc	a0,0x3
    3df4:	4b850513          	addi	a0,a0,1208 # 72a8 <malloc+0x1d76>
    3df8:	682010ef          	jal	547a <printf>
    exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	226010ef          	jal	5024 <exit>

0000000000003e02 <fourfiles>:
{
    3e02:	7135                	addi	sp,sp,-160
    3e04:	ed06                	sd	ra,152(sp)
    3e06:	e922                	sd	s0,144(sp)
    3e08:	e526                	sd	s1,136(sp)
    3e0a:	e14a                	sd	s2,128(sp)
    3e0c:	fcce                	sd	s3,120(sp)
    3e0e:	f8d2                	sd	s4,112(sp)
    3e10:	f4d6                	sd	s5,104(sp)
    3e12:	f0da                	sd	s6,96(sp)
    3e14:	ecde                	sd	s7,88(sp)
    3e16:	e8e2                	sd	s8,80(sp)
    3e18:	e4e6                	sd	s9,72(sp)
    3e1a:	e0ea                	sd	s10,64(sp)
    3e1c:	fc6e                	sd	s11,56(sp)
    3e1e:	1100                	addi	s0,sp,160
    3e20:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3e22:	00003797          	auipc	a5,0x3
    3e26:	49e78793          	addi	a5,a5,1182 # 72c0 <malloc+0x1d8e>
    3e2a:	f6f43823          	sd	a5,-144(s0)
    3e2e:	00003797          	auipc	a5,0x3
    3e32:	49a78793          	addi	a5,a5,1178 # 72c8 <malloc+0x1d96>
    3e36:	f6f43c23          	sd	a5,-136(s0)
    3e3a:	00003797          	auipc	a5,0x3
    3e3e:	49678793          	addi	a5,a5,1174 # 72d0 <malloc+0x1d9e>
    3e42:	f8f43023          	sd	a5,-128(s0)
    3e46:	00003797          	auipc	a5,0x3
    3e4a:	49278793          	addi	a5,a5,1170 # 72d8 <malloc+0x1da6>
    3e4e:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3e52:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3e56:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3e58:	4481                	li	s1,0
    3e5a:	4a11                	li	s4,4
    fname = names[pi];
    3e5c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e60:	854e                	mv	a0,s3
    3e62:	212010ef          	jal	5074 <unlink>
    pid = fork();
    3e66:	1b6010ef          	jal	501c <fork>
    if (pid < 0) {
    3e6a:	04054063          	bltz	a0,3eaa <fourfiles+0xa8>
    if (pid == 0) {
    3e6e:	c921                	beqz	a0,3ebe <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    3e70:	2485                	addiw	s1,s1,1
    3e72:	0921                	addi	s2,s2,8
    3e74:	ff4494e3          	bne	s1,s4,3e5c <fourfiles+0x5a>
    3e78:	4491                	li	s1,4
    wait(&xstatus);
    3e7a:	f6c40913          	addi	s2,s0,-148
    3e7e:	854a                	mv	a0,s2
    3e80:	1ac010ef          	jal	502c <wait>
    if (xstatus != 0)
    3e84:	f6c42b03          	lw	s6,-148(s0)
    3e88:	0a0b1463          	bnez	s6,3f30 <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    3e8c:	34fd                	addiw	s1,s1,-1
    3e8e:	f8e5                	bnez	s1,3e7e <fourfiles+0x7c>
    3e90:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3e94:	6a8d                	lui	s5,0x3
    3e96:	00008a17          	auipc	s4,0x8
    3e9a:	e22a0a13          	addi	s4,s4,-478 # bcb8 <buf>
    if (total != N * SZ) {
    3e9e:	6d05                	lui	s10,0x1
    3ea0:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    3ea4:	03400d93          	li	s11,52
    3ea8:	a86d                	j	3f62 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3eaa:	85e6                	mv	a1,s9
    3eac:	00002517          	auipc	a0,0x2
    3eb0:	04c50513          	addi	a0,a0,76 # 5ef8 <malloc+0x9c6>
    3eb4:	5c6010ef          	jal	547a <printf>
      exit(1);
    3eb8:	4505                	li	a0,1
    3eba:	16a010ef          	jal	5024 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3ebe:	20200593          	li	a1,514
    3ec2:	854e                	mv	a0,s3
    3ec4:	1a0010ef          	jal	5064 <open>
    3ec8:	892a                	mv	s2,a0
      if (fd < 0) {
    3eca:	04054063          	bltz	a0,3f0a <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    3ece:	1f400613          	li	a2,500
    3ed2:	0304859b          	addiw	a1,s1,48
    3ed6:	00008517          	auipc	a0,0x8
    3eda:	de250513          	addi	a0,a0,-542 # bcb8 <buf>
    3ede:	71d000ef          	jal	4dfa <memset>
    3ee2:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    3ee4:	1f400993          	li	s3,500
    3ee8:	00008a17          	auipc	s4,0x8
    3eec:	dd0a0a13          	addi	s4,s4,-560 # bcb8 <buf>
    3ef0:	864e                	mv	a2,s3
    3ef2:	85d2                	mv	a1,s4
    3ef4:	854a                	mv	a0,s2
    3ef6:	14e010ef          	jal	5044 <write>
    3efa:	85aa                	mv	a1,a0
    3efc:	03351163          	bne	a0,s3,3f1e <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    3f00:	34fd                	addiw	s1,s1,-1
    3f02:	f4fd                	bnez	s1,3ef0 <fourfiles+0xee>
      exit(0);
    3f04:	4501                	li	a0,0
    3f06:	11e010ef          	jal	5024 <exit>
        printf("%s: create failed\n", s);
    3f0a:	85e6                	mv	a1,s9
    3f0c:	00002517          	auipc	a0,0x2
    3f10:	15c50513          	addi	a0,a0,348 # 6068 <malloc+0xb36>
    3f14:	566010ef          	jal	547a <printf>
        exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	10a010ef          	jal	5024 <exit>
          printf("write failed %d\n", n);
    3f1e:	00003517          	auipc	a0,0x3
    3f22:	3c250513          	addi	a0,a0,962 # 72e0 <malloc+0x1dae>
    3f26:	554010ef          	jal	547a <printf>
          exit(1);
    3f2a:	4505                	li	a0,1
    3f2c:	0f8010ef          	jal	5024 <exit>
      exit(xstatus);
    3f30:	855a                	mv	a0,s6
    3f32:	0f2010ef          	jal	5024 <exit>
          printf("%s: wrong char\n", s);
    3f36:	85e6                	mv	a1,s9
    3f38:	00003517          	auipc	a0,0x3
    3f3c:	3c050513          	addi	a0,a0,960 # 72f8 <malloc+0x1dc6>
    3f40:	53a010ef          	jal	547a <printf>
          exit(1);
    3f44:	4505                	li	a0,1
    3f46:	0de010ef          	jal	5024 <exit>
    close(fd);
    3f4a:	854e                	mv	a0,s3
    3f4c:	100010ef          	jal	504c <close>
    if (total != N * SZ) {
    3f50:	05a91863          	bne	s2,s10,3fa0 <fourfiles+0x19e>
    unlink(fname);
    3f54:	8562                	mv	a0,s8
    3f56:	11e010ef          	jal	5074 <unlink>
  for (i = 0; i < NCHILD; i++) {
    3f5a:	0ba1                	addi	s7,s7,8
    3f5c:	2485                	addiw	s1,s1,1
    3f5e:	05b48b63          	beq	s1,s11,3fb4 <fourfiles+0x1b2>
    fname = names[i];
    3f62:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f66:	4581                	li	a1,0
    3f68:	8562                	mv	a0,s8
    3f6a:	0fa010ef          	jal	5064 <open>
    3f6e:	89aa                	mv	s3,a0
    total = 0;
    3f70:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3f72:	8656                	mv	a2,s5
    3f74:	85d2                	mv	a1,s4
    3f76:	854e                	mv	a0,s3
    3f78:	0c4010ef          	jal	503c <read>
    3f7c:	fca057e3          	blez	a0,3f4a <fourfiles+0x148>
    3f80:	00008797          	auipc	a5,0x8
    3f84:	d3878793          	addi	a5,a5,-712 # bcb8 <buf>
    3f88:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    3f8c:	0007c703          	lbu	a4,0(a5)
    3f90:	fa9713e3          	bne	a4,s1,3f36 <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    3f94:	0785                	addi	a5,a5,1
    3f96:	fed79be3          	bne	a5,a3,3f8c <fourfiles+0x18a>
      total += n;
    3f9a:	00a9093b          	addw	s2,s2,a0
    3f9e:	bfd1                	j	3f72 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3fa0:	85ca                	mv	a1,s2
    3fa2:	00003517          	auipc	a0,0x3
    3fa6:	36650513          	addi	a0,a0,870 # 7308 <malloc+0x1dd6>
    3faa:	4d0010ef          	jal	547a <printf>
      exit(1);
    3fae:	4505                	li	a0,1
    3fb0:	074010ef          	jal	5024 <exit>
}
    3fb4:	60ea                	ld	ra,152(sp)
    3fb6:	644a                	ld	s0,144(sp)
    3fb8:	64aa                	ld	s1,136(sp)
    3fba:	690a                	ld	s2,128(sp)
    3fbc:	79e6                	ld	s3,120(sp)
    3fbe:	7a46                	ld	s4,112(sp)
    3fc0:	7aa6                	ld	s5,104(sp)
    3fc2:	7b06                	ld	s6,96(sp)
    3fc4:	6be6                	ld	s7,88(sp)
    3fc6:	6c46                	ld	s8,80(sp)
    3fc8:	6ca6                	ld	s9,72(sp)
    3fca:	6d06                	ld	s10,64(sp)
    3fcc:	7de2                	ld	s11,56(sp)
    3fce:	610d                	addi	sp,sp,160
    3fd0:	8082                	ret

0000000000003fd2 <concreate>:
{
    3fd2:	7171                	addi	sp,sp,-176
    3fd4:	f506                	sd	ra,168(sp)
    3fd6:	f122                	sd	s0,160(sp)
    3fd8:	ed26                	sd	s1,152(sp)
    3fda:	e94a                	sd	s2,144(sp)
    3fdc:	e54e                	sd	s3,136(sp)
    3fde:	e152                	sd	s4,128(sp)
    3fe0:	fcd6                	sd	s5,120(sp)
    3fe2:	f8da                	sd	s6,112(sp)
    3fe4:	f4de                	sd	s7,104(sp)
    3fe6:	f0e2                	sd	s8,96(sp)
    3fe8:	ece6                	sd	s9,88(sp)
    3fea:	e8ea                	sd	s10,80(sp)
    3fec:	1900                	addi	s0,sp,176
    3fee:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3ff0:	04300793          	li	a5,67
    3ff4:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3ff8:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    3ffc:	4901                	li	s2,0
    unlink(file);
    3ffe:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    4002:	55555b37          	lui	s6,0x55555
    4006:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554689e>
    400a:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    400c:	20200c13          	li	s8,514
      link("C0", file);
    4010:	00003c97          	auipc	s9,0x3
    4014:	310c8c93          	addi	s9,s9,784 # 7320 <malloc+0x1dee>
      wait(&xstatus);
    4018:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    401c:	02800a13          	li	s4,40
    4020:	ac25                	j	4258 <concreate+0x286>
      link("C0", file);
    4022:	85ce                	mv	a1,s3
    4024:	8566                	mv	a0,s9
    4026:	05e010ef          	jal	5084 <link>
    if (pid == 0) {
    402a:	ac29                	j	4244 <concreate+0x272>
    } else if (pid == 0 && (i % 5) == 1) {
    402c:	666667b7          	lui	a5,0x66666
    4030:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666579af>
    4034:	02f907b3          	mul	a5,s2,a5
    4038:	9785                	srai	a5,a5,0x21
    403a:	41f9571b          	sraiw	a4,s2,0x1f
    403e:	9f99                	subw	a5,a5,a4
    4040:	0027971b          	slliw	a4,a5,0x2
    4044:	9fb9                	addw	a5,a5,a4
    4046:	40f9093b          	subw	s2,s2,a5
    404a:	4785                	li	a5,1
    404c:	02f90563          	beq	s2,a5,4076 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    4050:	20200593          	li	a1,514
    4054:	f9840513          	addi	a0,s0,-104
    4058:	00c010ef          	jal	5064 <open>
      if (fd < 0) {
    405c:	1c055f63          	bgez	a0,423a <concreate+0x268>
        printf("concreate create %s failed\n", file);
    4060:	f9840593          	addi	a1,s0,-104
    4064:	00003517          	auipc	a0,0x3
    4068:	2c450513          	addi	a0,a0,708 # 7328 <malloc+0x1df6>
    406c:	40e010ef          	jal	547a <printf>
        exit(1);
    4070:	4505                	li	a0,1
    4072:	7b3000ef          	jal	5024 <exit>
      link("C0", file);
    4076:	f9840593          	addi	a1,s0,-104
    407a:	00003517          	auipc	a0,0x3
    407e:	2a650513          	addi	a0,a0,678 # 7320 <malloc+0x1dee>
    4082:	002010ef          	jal	5084 <link>
      exit(0);
    4086:	4501                	li	a0,0
    4088:	79d000ef          	jal	5024 <exit>
        exit(1);
    408c:	4505                	li	a0,1
    408e:	797000ef          	jal	5024 <exit>
  memset(fa, 0, sizeof(fa));
    4092:	02800613          	li	a2,40
    4096:	4581                	li	a1,0
    4098:	f7040513          	addi	a0,s0,-144
    409c:	55f000ef          	jal	4dfa <memset>
  fd = open(".", 0);
    40a0:	4581                	li	a1,0
    40a2:	00002517          	auipc	a0,0x2
    40a6:	cae50513          	addi	a0,a0,-850 # 5d50 <malloc+0x81e>
    40aa:	7bb000ef          	jal	5064 <open>
    40ae:	892a                	mv	s2,a0
  n = 0;
    40b0:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    40b2:	f6040a13          	addi	s4,s0,-160
    40b6:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    40b8:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    40bc:	02700b93          	li	s7,39
      fa[i] = 1;
    40c0:	4c05                	li	s8,1
  while (read(fd, &de, sizeof(de)) > 0) {
    40c2:	864e                	mv	a2,s3
    40c4:	85d2                	mv	a1,s4
    40c6:	854a                	mv	a0,s2
    40c8:	775000ef          	jal	503c <read>
    40cc:	06a05763          	blez	a0,413a <concreate+0x168>
    if (de.inum == 0)
    40d0:	f6045783          	lhu	a5,-160(s0)
    40d4:	d7fd                	beqz	a5,40c2 <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    40d6:	f6244783          	lbu	a5,-158(s0)
    40da:	ff5794e3          	bne	a5,s5,40c2 <concreate+0xf0>
    40de:	f6444783          	lbu	a5,-156(s0)
    40e2:	f3e5                	bnez	a5,40c2 <concreate+0xf0>
      i = de.name[1] - '0';
    40e4:	f6344783          	lbu	a5,-157(s0)
    40e8:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    40ec:	00fbef63          	bltu	s7,a5,410a <concreate+0x138>
      if (fa[i]) {
    40f0:	fa078713          	addi	a4,a5,-96
    40f4:	9722                	add	a4,a4,s0
    40f6:	fd074703          	lbu	a4,-48(a4)
    40fa:	e705                	bnez	a4,4122 <concreate+0x150>
      fa[i] = 1;
    40fc:	fa078793          	addi	a5,a5,-96
    4100:	97a2                	add	a5,a5,s0
    4102:	fd878823          	sb	s8,-48(a5)
      n++;
    4106:	2b05                	addiw	s6,s6,1
    4108:	bf6d                	j	40c2 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    410a:	f6240613          	addi	a2,s0,-158
    410e:	85ea                	mv	a1,s10
    4110:	00003517          	auipc	a0,0x3
    4114:	23850513          	addi	a0,a0,568 # 7348 <malloc+0x1e16>
    4118:	362010ef          	jal	547a <printf>
        exit(1);
    411c:	4505                	li	a0,1
    411e:	707000ef          	jal	5024 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4122:	f6240613          	addi	a2,s0,-158
    4126:	85ea                	mv	a1,s10
    4128:	00003517          	auipc	a0,0x3
    412c:	24050513          	addi	a0,a0,576 # 7368 <malloc+0x1e36>
    4130:	34a010ef          	jal	547a <printf>
        exit(1);
    4134:	4505                	li	a0,1
    4136:	6ef000ef          	jal	5024 <exit>
  close(fd);
    413a:	854a                	mv	a0,s2
    413c:	711000ef          	jal	504c <close>
  if (n != N) {
    4140:	02800793          	li	a5,40
    4144:	00fb1a63          	bne	s6,a5,4158 <concreate+0x186>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4148:	55555a37          	lui	s4,0x55555
    414c:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554689e>
      close(open(file, 0));
    4150:	f9840993          	addi	s3,s0,-104
  for (i = 0; i < N; i++) {
    4154:	8ada                	mv	s5,s6
    4156:	a049                	j	41d8 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    4158:	85ea                	mv	a1,s10
    415a:	00003517          	auipc	a0,0x3
    415e:	23650513          	addi	a0,a0,566 # 7390 <malloc+0x1e5e>
    4162:	318010ef          	jal	547a <printf>
    exit(1);
    4166:	4505                	li	a0,1
    4168:	6bd000ef          	jal	5024 <exit>
      printf("%s: fork failed\n", s);
    416c:	85ea                	mv	a1,s10
    416e:	00002517          	auipc	a0,0x2
    4172:	d8a50513          	addi	a0,a0,-630 # 5ef8 <malloc+0x9c6>
    4176:	304010ef          	jal	547a <printf>
      exit(1);
    417a:	4505                	li	a0,1
    417c:	6a9000ef          	jal	5024 <exit>
      close(open(file, 0));
    4180:	4581                	li	a1,0
    4182:	854e                	mv	a0,s3
    4184:	6e1000ef          	jal	5064 <open>
    4188:	6c5000ef          	jal	504c <close>
      close(open(file, 0));
    418c:	4581                	li	a1,0
    418e:	854e                	mv	a0,s3
    4190:	6d5000ef          	jal	5064 <open>
    4194:	6b9000ef          	jal	504c <close>
      close(open(file, 0));
    4198:	4581                	li	a1,0
    419a:	854e                	mv	a0,s3
    419c:	6c9000ef          	jal	5064 <open>
    41a0:	6ad000ef          	jal	504c <close>
      close(open(file, 0));
    41a4:	4581                	li	a1,0
    41a6:	854e                	mv	a0,s3
    41a8:	6bd000ef          	jal	5064 <open>
    41ac:	6a1000ef          	jal	504c <close>
      close(open(file, 0));
    41b0:	4581                	li	a1,0
    41b2:	854e                	mv	a0,s3
    41b4:	6b1000ef          	jal	5064 <open>
    41b8:	695000ef          	jal	504c <close>
      close(open(file, 0));
    41bc:	4581                	li	a1,0
    41be:	854e                	mv	a0,s3
    41c0:	6a5000ef          	jal	5064 <open>
    41c4:	689000ef          	jal	504c <close>
    if (pid == 0)
    41c8:	06090663          	beqz	s2,4234 <concreate+0x262>
      wait(0);
    41cc:	4501                	li	a0,0
    41ce:	65f000ef          	jal	502c <wait>
  for (i = 0; i < N; i++) {
    41d2:	2485                	addiw	s1,s1,1
    41d4:	0d548163          	beq	s1,s5,4296 <concreate+0x2c4>
    file[1] = '0' + i;
    41d8:	0304879b          	addiw	a5,s1,48
    41dc:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    41e0:	63d000ef          	jal	501c <fork>
    41e4:	892a                	mv	s2,a0
    if (pid < 0) {
    41e6:	f80543e3          	bltz	a0,416c <concreate+0x19a>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    41ea:	03448733          	mul	a4,s1,s4
    41ee:	9301                	srli	a4,a4,0x20
    41f0:	41f4d79b          	sraiw	a5,s1,0x1f
    41f4:	9f1d                	subw	a4,a4,a5
    41f6:	0017179b          	slliw	a5,a4,0x1
    41fa:	9fb9                	addw	a5,a5,a4
    41fc:	40f487bb          	subw	a5,s1,a5
    4200:	00a7e733          	or	a4,a5,a0
    4204:	2701                	sext.w	a4,a4
    4206:	df2d                	beqz	a4,4180 <concreate+0x1ae>
    4208:	c119                	beqz	a0,420e <concreate+0x23c>
    420a:	17fd                	addi	a5,a5,-1
    420c:	dbb5                	beqz	a5,4180 <concreate+0x1ae>
      unlink(file);
    420e:	854e                	mv	a0,s3
    4210:	665000ef          	jal	5074 <unlink>
      unlink(file);
    4214:	854e                	mv	a0,s3
    4216:	65f000ef          	jal	5074 <unlink>
      unlink(file);
    421a:	854e                	mv	a0,s3
    421c:	659000ef          	jal	5074 <unlink>
      unlink(file);
    4220:	854e                	mv	a0,s3
    4222:	653000ef          	jal	5074 <unlink>
      unlink(file);
    4226:	854e                	mv	a0,s3
    4228:	64d000ef          	jal	5074 <unlink>
      unlink(file);
    422c:	854e                	mv	a0,s3
    422e:	647000ef          	jal	5074 <unlink>
    4232:	bf59                	j	41c8 <concreate+0x1f6>
      exit(0);
    4234:	4501                	li	a0,0
    4236:	5ef000ef          	jal	5024 <exit>
      close(fd);
    423a:	613000ef          	jal	504c <close>
    if (pid == 0) {
    423e:	b5a1                	j	4086 <concreate+0xb4>
      close(fd);
    4240:	60d000ef          	jal	504c <close>
      wait(&xstatus);
    4244:	8556                	mv	a0,s5
    4246:	5e7000ef          	jal	502c <wait>
      if (xstatus != 0)
    424a:	f5c42483          	lw	s1,-164(s0)
    424e:	e2049fe3          	bnez	s1,408c <concreate+0xba>
  for (i = 0; i < N; i++) {
    4252:	2905                	addiw	s2,s2,1
    4254:	e3490fe3          	beq	s2,s4,4092 <concreate+0xc0>
    file[1] = '0' + i;
    4258:	0309079b          	addiw	a5,s2,48
    425c:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4260:	854e                	mv	a0,s3
    4262:	613000ef          	jal	5074 <unlink>
    pid = fork();
    4266:	5b7000ef          	jal	501c <fork>
    if (pid && (i % 3) == 1) {
    426a:	dc0501e3          	beqz	a0,402c <concreate+0x5a>
    426e:	036907b3          	mul	a5,s2,s6
    4272:	9381                	srli	a5,a5,0x20
    4274:	41f9571b          	sraiw	a4,s2,0x1f
    4278:	9f99                	subw	a5,a5,a4
    427a:	0017971b          	slliw	a4,a5,0x1
    427e:	9fb9                	addw	a5,a5,a4
    4280:	40f907bb          	subw	a5,s2,a5
    4284:	d9778fe3          	beq	a5,s7,4022 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    4288:	85e2                	mv	a1,s8
    428a:	854e                	mv	a0,s3
    428c:	5d9000ef          	jal	5064 <open>
      if (fd < 0) {
    4290:	fa0558e3          	bgez	a0,4240 <concreate+0x26e>
    4294:	b3f1                	j	4060 <concreate+0x8e>
}
    4296:	70aa                	ld	ra,168(sp)
    4298:	740a                	ld	s0,160(sp)
    429a:	64ea                	ld	s1,152(sp)
    429c:	694a                	ld	s2,144(sp)
    429e:	69aa                	ld	s3,136(sp)
    42a0:	6a0a                	ld	s4,128(sp)
    42a2:	7ae6                	ld	s5,120(sp)
    42a4:	7b46                	ld	s6,112(sp)
    42a6:	7ba6                	ld	s7,104(sp)
    42a8:	7c06                	ld	s8,96(sp)
    42aa:	6ce6                	ld	s9,88(sp)
    42ac:	6d46                	ld	s10,80(sp)
    42ae:	614d                	addi	sp,sp,176
    42b0:	8082                	ret

00000000000042b2 <bigfile>:
{
    42b2:	7139                	addi	sp,sp,-64
    42b4:	fc06                	sd	ra,56(sp)
    42b6:	f822                	sd	s0,48(sp)
    42b8:	f426                	sd	s1,40(sp)
    42ba:	f04a                	sd	s2,32(sp)
    42bc:	ec4e                	sd	s3,24(sp)
    42be:	e852                	sd	s4,16(sp)
    42c0:	e456                	sd	s5,8(sp)
    42c2:	e05a                	sd	s6,0(sp)
    42c4:	0080                	addi	s0,sp,64
    42c6:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    42c8:	00003517          	auipc	a0,0x3
    42cc:	10050513          	addi	a0,a0,256 # 73c8 <malloc+0x1e96>
    42d0:	5a5000ef          	jal	5074 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    42d4:	20200593          	li	a1,514
    42d8:	00003517          	auipc	a0,0x3
    42dc:	0f050513          	addi	a0,a0,240 # 73c8 <malloc+0x1e96>
    42e0:	585000ef          	jal	5064 <open>
  if (fd < 0) {
    42e4:	08054a63          	bltz	a0,4378 <bigfile+0xc6>
    42e8:	8a2a                	mv	s4,a0
    42ea:	4481                	li	s1,0
    memset(buf, i, SZ);
    42ec:	25800913          	li	s2,600
    42f0:	00008997          	auipc	s3,0x8
    42f4:	9c898993          	addi	s3,s3,-1592 # bcb8 <buf>
  for (i = 0; i < N; i++) {
    42f8:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42fa:	864a                	mv	a2,s2
    42fc:	85a6                	mv	a1,s1
    42fe:	854e                	mv	a0,s3
    4300:	2fb000ef          	jal	4dfa <memset>
    if (write(fd, buf, SZ) != SZ) {
    4304:	864a                	mv	a2,s2
    4306:	85ce                	mv	a1,s3
    4308:	8552                	mv	a0,s4
    430a:	53b000ef          	jal	5044 <write>
    430e:	07251f63          	bne	a0,s2,438c <bigfile+0xda>
  for (i = 0; i < N; i++) {
    4312:	2485                	addiw	s1,s1,1
    4314:	ff5493e3          	bne	s1,s5,42fa <bigfile+0x48>
  close(fd);
    4318:	8552                	mv	a0,s4
    431a:	533000ef          	jal	504c <close>
  fd = open("bigfile.dat", 0);
    431e:	4581                	li	a1,0
    4320:	00003517          	auipc	a0,0x3
    4324:	0a850513          	addi	a0,a0,168 # 73c8 <malloc+0x1e96>
    4328:	53d000ef          	jal	5064 <open>
    432c:	8aaa                	mv	s5,a0
  total = 0;
    432e:	4a01                	li	s4,0
  for (i = 0;; i++) {
    4330:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    4332:	12c00993          	li	s3,300
    4336:	00008917          	auipc	s2,0x8
    433a:	98290913          	addi	s2,s2,-1662 # bcb8 <buf>
  if (fd < 0) {
    433e:	06054163          	bltz	a0,43a0 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    4342:	864e                	mv	a2,s3
    4344:	85ca                	mv	a1,s2
    4346:	8556                	mv	a0,s5
    4348:	4f5000ef          	jal	503c <read>
    if (cc < 0) {
    434c:	06054463          	bltz	a0,43b4 <bigfile+0x102>
    if (cc == 0)
    4350:	c145                	beqz	a0,43f0 <bigfile+0x13e>
    if (cc != SZ / 2) {
    4352:	07351b63          	bne	a0,s3,43c8 <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    4356:	01f4d79b          	srliw	a5,s1,0x1f
    435a:	9fa5                	addw	a5,a5,s1
    435c:	4017d79b          	sraiw	a5,a5,0x1
    4360:	00094703          	lbu	a4,0(s2)
    4364:	06f71c63          	bne	a4,a5,43dc <bigfile+0x12a>
    4368:	12b94703          	lbu	a4,299(s2)
    436c:	06f71863          	bne	a4,a5,43dc <bigfile+0x12a>
    total += cc;
    4370:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    4374:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    4376:	b7f1                	j	4342 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    4378:	85da                	mv	a1,s6
    437a:	00003517          	auipc	a0,0x3
    437e:	05e50513          	addi	a0,a0,94 # 73d8 <malloc+0x1ea6>
    4382:	0f8010ef          	jal	547a <printf>
    exit(1);
    4386:	4505                	li	a0,1
    4388:	49d000ef          	jal	5024 <exit>
      printf("%s: write bigfile failed\n", s);
    438c:	85da                	mv	a1,s6
    438e:	00003517          	auipc	a0,0x3
    4392:	06a50513          	addi	a0,a0,106 # 73f8 <malloc+0x1ec6>
    4396:	0e4010ef          	jal	547a <printf>
      exit(1);
    439a:	4505                	li	a0,1
    439c:	489000ef          	jal	5024 <exit>
    printf("%s: cannot open bigfile\n", s);
    43a0:	85da                	mv	a1,s6
    43a2:	00003517          	auipc	a0,0x3
    43a6:	07650513          	addi	a0,a0,118 # 7418 <malloc+0x1ee6>
    43aa:	0d0010ef          	jal	547a <printf>
    exit(1);
    43ae:	4505                	li	a0,1
    43b0:	475000ef          	jal	5024 <exit>
      printf("%s: read bigfile failed\n", s);
    43b4:	85da                	mv	a1,s6
    43b6:	00003517          	auipc	a0,0x3
    43ba:	08250513          	addi	a0,a0,130 # 7438 <malloc+0x1f06>
    43be:	0bc010ef          	jal	547a <printf>
      exit(1);
    43c2:	4505                	li	a0,1
    43c4:	461000ef          	jal	5024 <exit>
      printf("%s: short read bigfile\n", s);
    43c8:	85da                	mv	a1,s6
    43ca:	00003517          	auipc	a0,0x3
    43ce:	08e50513          	addi	a0,a0,142 # 7458 <malloc+0x1f26>
    43d2:	0a8010ef          	jal	547a <printf>
      exit(1);
    43d6:	4505                	li	a0,1
    43d8:	44d000ef          	jal	5024 <exit>
      printf("%s: read bigfile wrong data\n", s);
    43dc:	85da                	mv	a1,s6
    43de:	00003517          	auipc	a0,0x3
    43e2:	09250513          	addi	a0,a0,146 # 7470 <malloc+0x1f3e>
    43e6:	094010ef          	jal	547a <printf>
      exit(1);
    43ea:	4505                	li	a0,1
    43ec:	439000ef          	jal	5024 <exit>
  close(fd);
    43f0:	8556                	mv	a0,s5
    43f2:	45b000ef          	jal	504c <close>
  if (total != N * SZ) {
    43f6:	678d                	lui	a5,0x3
    43f8:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x356>
    43fc:	02fa1263          	bne	s4,a5,4420 <bigfile+0x16e>
  unlink("bigfile.dat");
    4400:	00003517          	auipc	a0,0x3
    4404:	fc850513          	addi	a0,a0,-56 # 73c8 <malloc+0x1e96>
    4408:	46d000ef          	jal	5074 <unlink>
}
    440c:	70e2                	ld	ra,56(sp)
    440e:	7442                	ld	s0,48(sp)
    4410:	74a2                	ld	s1,40(sp)
    4412:	7902                	ld	s2,32(sp)
    4414:	69e2                	ld	s3,24(sp)
    4416:	6a42                	ld	s4,16(sp)
    4418:	6aa2                	ld	s5,8(sp)
    441a:	6b02                	ld	s6,0(sp)
    441c:	6121                	addi	sp,sp,64
    441e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4420:	85da                	mv	a1,s6
    4422:	00003517          	auipc	a0,0x3
    4426:	06e50513          	addi	a0,a0,110 # 7490 <malloc+0x1f5e>
    442a:	050010ef          	jal	547a <printf>
    exit(1);
    442e:	4505                	li	a0,1
    4430:	3f5000ef          	jal	5024 <exit>

0000000000004434 <bigargtest>:
{
    4434:	7121                	addi	sp,sp,-448
    4436:	ff06                	sd	ra,440(sp)
    4438:	fb22                	sd	s0,432(sp)
    443a:	f726                	sd	s1,424(sp)
    443c:	0380                	addi	s0,sp,448
    443e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4440:	00003517          	auipc	a0,0x3
    4444:	07050513          	addi	a0,a0,112 # 74b0 <malloc+0x1f7e>
    4448:	42d000ef          	jal	5074 <unlink>
  pid = fork();
    444c:	3d1000ef          	jal	501c <fork>
  if (pid == 0) {
    4450:	c915                	beqz	a0,4484 <bigargtest+0x50>
  } else if (pid < 0) {
    4452:	08054c63          	bltz	a0,44ea <bigargtest+0xb6>
  wait(&xstatus);
    4456:	fdc40513          	addi	a0,s0,-36
    445a:	3d3000ef          	jal	502c <wait>
  if (xstatus != 0)
    445e:	fdc42503          	lw	a0,-36(s0)
    4462:	ed51                	bnez	a0,44fe <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    4464:	4581                	li	a1,0
    4466:	00003517          	auipc	a0,0x3
    446a:	04a50513          	addi	a0,a0,74 # 74b0 <malloc+0x1f7e>
    446e:	3f7000ef          	jal	5064 <open>
  if (fd < 0) {
    4472:	08054863          	bltz	a0,4502 <bigargtest+0xce>
  close(fd);
    4476:	3d7000ef          	jal	504c <close>
}
    447a:	70fa                	ld	ra,440(sp)
    447c:	745a                	ld	s0,432(sp)
    447e:	74ba                	ld	s1,424(sp)
    4480:	6139                	addi	sp,sp,448
    4482:	8082                	ret
    memset(big, ' ', sizeof(big));
    4484:	19000613          	li	a2,400
    4488:	02000593          	li	a1,32
    448c:	e4840513          	addi	a0,s0,-440
    4490:	16b000ef          	jal	4dfa <memset>
    big[sizeof(big) - 1] = '\0';
    4494:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    4498:	00004797          	auipc	a5,0x4
    449c:	00878793          	addi	a5,a5,8 # 84a0 <args.1>
    44a0:	00004697          	auipc	a3,0x4
    44a4:	0f868693          	addi	a3,a3,248 # 8598 <args.1+0xf8>
      args[i] = big;
    44a8:	e4840713          	addi	a4,s0,-440
    44ac:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    44ae:	07a1                	addi	a5,a5,8
    44b0:	fed79ee3          	bne	a5,a3,44ac <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    44b4:	00004797          	auipc	a5,0x4
    44b8:	0e07b223          	sd	zero,228(a5) # 8598 <args.1+0xf8>
    exec("echo", args);
    44bc:	00004597          	auipc	a1,0x4
    44c0:	fe458593          	addi	a1,a1,-28 # 84a0 <args.1>
    44c4:	00001517          	auipc	a0,0x1
    44c8:	1a450513          	addi	a0,a0,420 # 5668 <malloc+0x136>
    44cc:	391000ef          	jal	505c <exec>
    fd = open("bigarg-ok", O_CREATE);
    44d0:	20000593          	li	a1,512
    44d4:	00003517          	auipc	a0,0x3
    44d8:	fdc50513          	addi	a0,a0,-36 # 74b0 <malloc+0x1f7e>
    44dc:	389000ef          	jal	5064 <open>
    close(fd);
    44e0:	36d000ef          	jal	504c <close>
    exit(0);
    44e4:	4501                	li	a0,0
    44e6:	33f000ef          	jal	5024 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44ea:	85a6                	mv	a1,s1
    44ec:	00003517          	auipc	a0,0x3
    44f0:	fd450513          	addi	a0,a0,-44 # 74c0 <malloc+0x1f8e>
    44f4:	787000ef          	jal	547a <printf>
    exit(1);
    44f8:	4505                	li	a0,1
    44fa:	32b000ef          	jal	5024 <exit>
    exit(xstatus);
    44fe:	327000ef          	jal	5024 <exit>
    printf("%s: bigarg test failed!\n", s);
    4502:	85a6                	mv	a1,s1
    4504:	00003517          	auipc	a0,0x3
    4508:	fdc50513          	addi	a0,a0,-36 # 74e0 <malloc+0x1fae>
    450c:	76f000ef          	jal	547a <printf>
    exit(1);
    4510:	4505                	li	a0,1
    4512:	313000ef          	jal	5024 <exit>

0000000000004516 <lazy_alloc>:
{
    4516:	1141                	addi	sp,sp,-16
    4518:	e406                	sd	ra,8(sp)
    451a:	e022                	sd	s0,0(sp)
    451c:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    451e:	40000537          	lui	a0,0x40000
    4522:	2e5000ef          	jal	5006 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4526:	57fd                	li	a5,-1
    4528:	02f50a63          	beq	a0,a5,455c <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    452c:	6605                	lui	a2,0x1
    452e:	962a                	add	a2,a2,a0
    4530:	400017b7          	lui	a5,0x40001
    4534:	00f50733          	add	a4,a0,a5
    4538:	87b2                	mv	a5,a2
    453a:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    453e:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4540:	97b6                	add	a5,a5,a3
    4542:	fee79ee3          	bne	a5,a4,453e <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4546:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    454a:	621c                	ld	a5,0(a2)
    454c:	02c79163          	bne	a5,a2,456e <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4550:	9636                	add	a2,a2,a3
    4552:	fee61ce3          	bne	a2,a4,454a <lazy_alloc+0x34>
  exit(0);
    4556:	4501                	li	a0,0
    4558:	2cd000ef          	jal	5024 <exit>
    printf("sbrklazy() failed\n");
    455c:	00003517          	auipc	a0,0x3
    4560:	fa450513          	addi	a0,a0,-92 # 7500 <malloc+0x1fce>
    4564:	717000ef          	jal	547a <printf>
    exit(1);
    4568:	4505                	li	a0,1
    456a:	2bb000ef          	jal	5024 <exit>
      printf("failed to read value from memory\n");
    456e:	00003517          	auipc	a0,0x3
    4572:	faa50513          	addi	a0,a0,-86 # 7518 <malloc+0x1fe6>
    4576:	705000ef          	jal	547a <printf>
      exit(1);
    457a:	4505                	li	a0,1
    457c:	2a9000ef          	jal	5024 <exit>

0000000000004580 <lazy_unmap>:
{
    4580:	7139                	addi	sp,sp,-64
    4582:	fc06                	sd	ra,56(sp)
    4584:	f822                	sd	s0,48(sp)
    4586:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    4588:	40000537          	lui	a0,0x40000
    458c:	27b000ef          	jal	5006 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4590:	57fd                	li	a5,-1
    4592:	04f50863          	beq	a0,a5,45e2 <lazy_unmap+0x62>
    4596:	f426                	sd	s1,40(sp)
    4598:	f04a                	sd	s2,32(sp)
    459a:	ec4e                	sd	s3,24(sp)
    459c:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    459e:	6905                	lui	s2,0x1
    45a0:	992a                	add	s2,s2,a0
    45a2:	400017b7          	lui	a5,0x40001
    45a6:	00f504b3          	add	s1,a0,a5
    45aa:	87ca                	mv	a5,s2
    45ac:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    45b0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    45b2:	97ba                	add	a5,a5,a4
    45b4:	fe979ee3          	bne	a5,s1,45b0 <lazy_unmap+0x30>
      wait(&status);
    45b8:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    45bc:	01000a37          	lui	s4,0x1000
    pid = fork();
    45c0:	25d000ef          	jal	501c <fork>
    if (pid < 0) {
    45c4:	02054c63          	bltz	a0,45fc <lazy_unmap+0x7c>
    } else if (pid == 0) {
    45c8:	c139                	beqz	a0,460e <lazy_unmap+0x8e>
      wait(&status);
    45ca:	854e                	mv	a0,s3
    45cc:	261000ef          	jal	502c <wait>
      if (status == 0) {
    45d0:	fcc42783          	lw	a5,-52(s0)
    45d4:	c7b1                	beqz	a5,4620 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    45d6:	9952                	add	s2,s2,s4
    45d8:	fe9914e3          	bne	s2,s1,45c0 <lazy_unmap+0x40>
  exit(0);
    45dc:	4501                	li	a0,0
    45de:	247000ef          	jal	5024 <exit>
    45e2:	f426                	sd	s1,40(sp)
    45e4:	f04a                	sd	s2,32(sp)
    45e6:	ec4e                	sd	s3,24(sp)
    45e8:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    45ea:	00003517          	auipc	a0,0x3
    45ee:	f1650513          	addi	a0,a0,-234 # 7500 <malloc+0x1fce>
    45f2:	689000ef          	jal	547a <printf>
    exit(1);
    45f6:	4505                	li	a0,1
    45f8:	22d000ef          	jal	5024 <exit>
      printf("error forking\n");
    45fc:	00003517          	auipc	a0,0x3
    4600:	f4450513          	addi	a0,a0,-188 # 7540 <malloc+0x200e>
    4604:	677000ef          	jal	547a <printf>
      exit(1);
    4608:	4505                	li	a0,1
    460a:	21b000ef          	jal	5024 <exit>
      sbrklazy(-1L * REGION_SZ);
    460e:	c0000537          	lui	a0,0xc0000
    4612:	1f5000ef          	jal	5006 <sbrklazy>
      *(char **)i = i;
    4616:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    461a:	4501                	li	a0,0
    461c:	209000ef          	jal	5024 <exit>
        printf("memory not unmapped\n");
    4620:	00003517          	auipc	a0,0x3
    4624:	f3050513          	addi	a0,a0,-208 # 7550 <malloc+0x201e>
    4628:	653000ef          	jal	547a <printf>
        exit(1);
    462c:	4505                	li	a0,1
    462e:	1f7000ef          	jal	5024 <exit>

0000000000004632 <lazy_copy>:
{
    4632:	7119                	addi	sp,sp,-128
    4634:	fc86                	sd	ra,120(sp)
    4636:	f8a2                	sd	s0,112(sp)
    4638:	f4a6                	sd	s1,104(sp)
    463a:	f0ca                	sd	s2,96(sp)
    463c:	ecce                	sd	s3,88(sp)
    463e:	e8d2                	sd	s4,80(sp)
    4640:	e4d6                	sd	s5,72(sp)
    4642:	e0da                	sd	s6,64(sp)
    4644:	fc5e                	sd	s7,56(sp)
    4646:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    4648:	4501                	li	a0,0
    464a:	1a7000ef          	jal	4ff0 <sbrk>
    464e:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    4650:	6511                	lui	a0,0x4
    4652:	1b5000ef          	jal	5006 <sbrklazy>
    open(p + 8192, 0);
    4656:	4581                	li	a1,0
    4658:	6509                	lui	a0,0x2
    465a:	9526                	add	a0,a0,s1
    465c:	209000ef          	jal	5064 <open>
    void *xx = sbrk(0);
    4660:	4501                	li	a0,0
    4662:	18f000ef          	jal	4ff0 <sbrk>
    4666:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    4668:	fff54513          	not	a0,a0
    466c:	2501                	sext.w	a0,a0
    466e:	183000ef          	jal	4ff0 <sbrk>
    if (ret != xx) {
    4672:	00a48c63          	beq	s1,a0,468a <lazy_copy+0x58>
    4676:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4678:	00003517          	auipc	a0,0x3
    467c:	ef050513          	addi	a0,a0,-272 # 7568 <malloc+0x2036>
    4680:	5fb000ef          	jal	547a <printf>
      exit(1);
    4684:	4505                	li	a0,1
    4686:	19f000ef          	jal	5024 <exit>
  unsigned long bad[] = {
    468a:	00003797          	auipc	a5,0x3
    468e:	55678793          	addi	a5,a5,1366 # 7be0 <malloc+0x26ae>
    4692:	7fa8                	ld	a0,120(a5)
    4694:	63cc                	ld	a1,128(a5)
    4696:	67d0                	ld	a2,136(a5)
    4698:	6bd4                	ld	a3,144(a5)
    469a:	6fd8                	ld	a4,152(a5)
    469c:	f8a43023          	sd	a0,-128(s0)
    46a0:	f8b43423          	sd	a1,-120(s0)
    46a4:	f8c43823          	sd	a2,-112(s0)
    46a8:	f8d43c23          	sd	a3,-104(s0)
    46ac:	fae43023          	sd	a4,-96(s0)
    46b0:	73dc                	ld	a5,160(a5)
    46b2:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    46b6:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    46ba:	00001a97          	auipc	s5,0x1
    46be:	186a8a93          	addi	s5,s5,390 # 5840 <malloc+0x30e>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    46c2:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    46c6:	60200b93          	li	s7,1538
    46ca:	00001b17          	auipc	s6,0x1
    46ce:	086b0b13          	addi	s6,s6,134 # 5750 <malloc+0x21e>
    int fd = open("README", 0);
    46d2:	4581                	li	a1,0
    46d4:	8556                	mv	a0,s5
    46d6:	18f000ef          	jal	5064 <open>
    46da:	84aa                	mv	s1,a0
    if (fd < 0) {
    46dc:	04054563          	bltz	a0,4726 <lazy_copy+0xf4>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    46e0:	00093983          	ld	s3,0(s2)
    46e4:	8652                	mv	a2,s4
    46e6:	85ce                	mv	a1,s3
    46e8:	155000ef          	jal	503c <read>
    46ec:	04055663          	bgez	a0,4738 <lazy_copy+0x106>
    close(fd);
    46f0:	8526                	mv	a0,s1
    46f2:	15b000ef          	jal	504c <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    46f6:	85de                	mv	a1,s7
    46f8:	855a                	mv	a0,s6
    46fa:	16b000ef          	jal	5064 <open>
    46fe:	84aa                	mv	s1,a0
    if (fd < 0) {
    4700:	04054563          	bltz	a0,474a <lazy_copy+0x118>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4704:	8652                	mv	a2,s4
    4706:	85ce                	mv	a1,s3
    4708:	13d000ef          	jal	5044 <write>
    470c:	04055863          	bgez	a0,475c <lazy_copy+0x12a>
    close(fd);
    4710:	8526                	mv	a0,s1
    4712:	13b000ef          	jal	504c <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4716:	0921                	addi	s2,s2,8
    4718:	fb040793          	addi	a5,s0,-80
    471c:	faf91be3          	bne	s2,a5,46d2 <lazy_copy+0xa0>
  exit(0);
    4720:	4501                	li	a0,0
    4722:	103000ef          	jal	5024 <exit>
      printf("cannot open README\n");
    4726:	00003517          	auipc	a0,0x3
    472a:	e7250513          	addi	a0,a0,-398 # 7598 <malloc+0x2066>
    472e:	54d000ef          	jal	547a <printf>
      exit(1);
    4732:	4505                	li	a0,1
    4734:	0f1000ef          	jal	5024 <exit>
      printf("read succeeded\n");
    4738:	00003517          	auipc	a0,0x3
    473c:	e7850513          	addi	a0,a0,-392 # 75b0 <malloc+0x207e>
    4740:	53b000ef          	jal	547a <printf>
      exit(1);
    4744:	4505                	li	a0,1
    4746:	0df000ef          	jal	5024 <exit>
      printf("cannot open junk\n");
    474a:	00003517          	auipc	a0,0x3
    474e:	e7650513          	addi	a0,a0,-394 # 75c0 <malloc+0x208e>
    4752:	529000ef          	jal	547a <printf>
      exit(1);
    4756:	4505                	li	a0,1
    4758:	0cd000ef          	jal	5024 <exit>
      printf("write succeeded\n");
    475c:	00003517          	auipc	a0,0x3
    4760:	e7c50513          	addi	a0,a0,-388 # 75d8 <malloc+0x20a6>
    4764:	517000ef          	jal	547a <printf>
      exit(1);
    4768:	4505                	li	a0,1
    476a:	0bb000ef          	jal	5024 <exit>

000000000000476e <lazy_sbrk>:
{
    476e:	7179                	addi	sp,sp,-48
    4770:	f406                	sd	ra,40(sp)
    4772:	f022                	sd	s0,32(sp)
    4774:	ec26                	sd	s1,24(sp)
    4776:	e84a                	sd	s2,16(sp)
    4778:	e44e                	sd	s3,8(sp)
    477a:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    477c:	4501                	li	a0,0
    477e:	073000ef          	jal	4ff0 <sbrk>
    4782:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4784:	0ff00793          	li	a5,255
    4788:	07fa                	slli	a5,a5,0x1e
    478a:	00f57e63          	bgeu	a0,a5,47a6 <lazy_sbrk+0x38>
    p = sbrklazy(1 << 30);
    478e:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA - (1 << 30)) {
    4792:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4794:	854e                	mv	a0,s3
    4796:	071000ef          	jal	5006 <sbrklazy>
    p = sbrklazy(0);
    479a:	4501                	li	a0,0
    479c:	06b000ef          	jal	5006 <sbrklazy>
    47a0:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    47a2:	ff2569e3          	bltu	a0,s2,4794 <lazy_sbrk+0x26>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    47a6:	7975                	lui	s2,0xffffd
    47a8:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    47ac:	854a                	mv	a0,s2
    47ae:	059000ef          	jal	5006 <sbrklazy>
    47b2:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    47b4:	00950d63          	beq	a0,s1,47ce <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    47b8:	86a6                	mv	a3,s1
    47ba:	85ca                	mv	a1,s2
    47bc:	00003517          	auipc	a0,0x3
    47c0:	e3450513          	addi	a0,a0,-460 # 75f0 <malloc+0x20be>
    47c4:	4b7000ef          	jal	547a <printf>
    exit(1);
    47c8:	4505                	li	a0,1
    47ca:	05b000ef          	jal	5024 <exit>
  p = sbrk(PGSIZE);
    47ce:	6505                	lui	a0,0x1
    47d0:	021000ef          	jal	4ff0 <sbrk>
    47d4:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    47d6:	040007b7          	lui	a5,0x4000
    47da:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    47dc:	07b2                	slli	a5,a5,0xc
    47de:	00f50c63          	beq	a0,a5,47f6 <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    47e2:	6585                	lui	a1,0x1
    47e4:	00003517          	auipc	a0,0x3
    47e8:	e3c50513          	addi	a0,a0,-452 # 7620 <malloc+0x20ee>
    47ec:	48f000ef          	jal	547a <printf>
    exit(1);
    47f0:	4505                	li	a0,1
    47f2:	033000ef          	jal	5024 <exit>
  p[0] = 1;
    47f6:	040007b7          	lui	a5,0x4000
    47fa:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    47fc:	07b2                	slli	a5,a5,0xc
    47fe:	4705                	li	a4,1
    4800:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4804:	0017c783          	lbu	a5,1(a5)
    4808:	cb91                	beqz	a5,481c <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    480a:	00003517          	auipc	a0,0x3
    480e:	e4e50513          	addi	a0,a0,-434 # 7658 <malloc+0x2126>
    4812:	469000ef          	jal	547a <printf>
    exit(1);
    4816:	4505                	li	a0,1
    4818:	00d000ef          	jal	5024 <exit>
  p = sbrk(1);
    481c:	4505                	li	a0,1
    481e:	7d2000ef          	jal	4ff0 <sbrk>
    4822:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4824:	57fd                	li	a5,-1
    4826:	00f50b63          	beq	a0,a5,483c <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    482a:	00003517          	auipc	a0,0x3
    482e:	e5650513          	addi	a0,a0,-426 # 7680 <malloc+0x214e>
    4832:	449000ef          	jal	547a <printf>
    exit(1);
    4836:	4505                	li	a0,1
    4838:	7ec000ef          	jal	5024 <exit>
  p = sbrklazy(1);
    483c:	4505                	li	a0,1
    483e:	7c8000ef          	jal	5006 <sbrklazy>
    4842:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4844:	57fd                	li	a5,-1
    4846:	00f50b63          	beq	a0,a5,485c <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    484a:	00003517          	auipc	a0,0x3
    484e:	e5e50513          	addi	a0,a0,-418 # 76a8 <malloc+0x2176>
    4852:	429000ef          	jal	547a <printf>
    exit(1);
    4856:	4505                	li	a0,1
    4858:	7cc000ef          	jal	5024 <exit>
  exit(0);
    485c:	4501                	li	a0,0
    485e:	7c6000ef          	jal	5024 <exit>

0000000000004862 <fsfull>:
{
    4862:	7171                	addi	sp,sp,-176
    4864:	f506                	sd	ra,168(sp)
    4866:	f122                	sd	s0,160(sp)
    4868:	ed26                	sd	s1,152(sp)
    486a:	e94a                	sd	s2,144(sp)
    486c:	e54e                	sd	s3,136(sp)
    486e:	e152                	sd	s4,128(sp)
    4870:	fcd6                	sd	s5,120(sp)
    4872:	f8da                	sd	s6,112(sp)
    4874:	f4de                	sd	s7,104(sp)
    4876:	f0e2                	sd	s8,96(sp)
    4878:	ece6                	sd	s9,88(sp)
    487a:	e8ea                	sd	s10,80(sp)
    487c:	e4ee                	sd	s11,72(sp)
    487e:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4880:	00003517          	auipc	a0,0x3
    4884:	e5850513          	addi	a0,a0,-424 # 76d8 <malloc+0x21a6>
    4888:	3f3000ef          	jal	547a <printf>
  for (nfiles = 0;; nfiles++) {
    488c:	4481                	li	s1,0
    name[0] = 'f';
    488e:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4892:	10625cb7          	lui	s9,0x10625
    4896:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061611b>
    name[2] = '0' + (nfiles % 1000) / 100;
    489a:	51eb8ab7          	lui	s5,0x51eb8
    489e:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea9867>
    name[3] = '0' + (nfiles % 100) / 10;
    48a2:	66666a37          	lui	s4,0x66666
    48a6:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666579af>
    printf("writing %s\n", name);
    48aa:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    48ae:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    48b2:	039487b3          	mul	a5,s1,s9
    48b6:	9799                	srai	a5,a5,0x26
    48b8:	41f4d69b          	sraiw	a3,s1,0x1f
    48bc:	9f95                	subw	a5,a5,a3
    48be:	0307871b          	addiw	a4,a5,48
    48c2:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    48c6:	3e800713          	li	a4,1000
    48ca:	02f707bb          	mulw	a5,a4,a5
    48ce:	40f487bb          	subw	a5,s1,a5
    48d2:	03578733          	mul	a4,a5,s5
    48d6:	9715                	srai	a4,a4,0x25
    48d8:	41f7d79b          	sraiw	a5,a5,0x1f
    48dc:	40f707bb          	subw	a5,a4,a5
    48e0:	0307879b          	addiw	a5,a5,48
    48e4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    48e8:	035487b3          	mul	a5,s1,s5
    48ec:	9795                	srai	a5,a5,0x25
    48ee:	9f95                	subw	a5,a5,a3
    48f0:	06400713          	li	a4,100
    48f4:	02f707bb          	mulw	a5,a4,a5
    48f8:	40f487bb          	subw	a5,s1,a5
    48fc:	03478733          	mul	a4,a5,s4
    4900:	9709                	srai	a4,a4,0x22
    4902:	41f7d79b          	sraiw	a5,a5,0x1f
    4906:	40f707bb          	subw	a5,a4,a5
    490a:	0307879b          	addiw	a5,a5,48
    490e:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4912:	03448733          	mul	a4,s1,s4
    4916:	9709                	srai	a4,a4,0x22
    4918:	9f15                	subw	a4,a4,a3
    491a:	0027179b          	slliw	a5,a4,0x2
    491e:	9fb9                	addw	a5,a5,a4
    4920:	0017979b          	slliw	a5,a5,0x1
    4924:	40f487bb          	subw	a5,s1,a5
    4928:	0307879b          	addiw	a5,a5,48
    492c:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4930:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4934:	85ea                	mv	a1,s10
    4936:	00003517          	auipc	a0,0x3
    493a:	db250513          	addi	a0,a0,-590 # 76e8 <malloc+0x21b6>
    493e:	33d000ef          	jal	547a <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4942:	20200593          	li	a1,514
    4946:	856a                	mv	a0,s10
    4948:	71c000ef          	jal	5064 <open>
    494c:	892a                	mv	s2,a0
    if (fd < 0) {
    494e:	0e055b63          	bgez	a0,4a44 <fsfull+0x1e2>
      printf("open %s failed\n", name);
    4952:	f5040593          	addi	a1,s0,-176
    4956:	00003517          	auipc	a0,0x3
    495a:	da250513          	addi	a0,a0,-606 # 76f8 <malloc+0x21c6>
    495e:	31d000ef          	jal	547a <printf>
  while (nfiles >= 0) {
    4962:	0a04cc63          	bltz	s1,4a1a <fsfull+0x1b8>
    name[0] = 'f';
    4966:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    496a:	10625a37          	lui	s4,0x10625
    496e:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061611b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4972:	3e800b93          	li	s7,1000
    4976:	51eb89b7          	lui	s3,0x51eb8
    497a:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea9867>
    name[3] = '0' + (nfiles % 100) / 10;
    497e:	06400b13          	li	s6,100
    4982:	66666937          	lui	s2,0x66666
    4986:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666579af>
    unlink(name);
    498a:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    498e:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4992:	034487b3          	mul	a5,s1,s4
    4996:	9799                	srai	a5,a5,0x26
    4998:	41f4d69b          	sraiw	a3,s1,0x1f
    499c:	9f95                	subw	a5,a5,a3
    499e:	0307871b          	addiw	a4,a5,48
    49a2:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    49a6:	02fb87bb          	mulw	a5,s7,a5
    49aa:	40f487bb          	subw	a5,s1,a5
    49ae:	03378733          	mul	a4,a5,s3
    49b2:	9715                	srai	a4,a4,0x25
    49b4:	41f7d79b          	sraiw	a5,a5,0x1f
    49b8:	40f707bb          	subw	a5,a4,a5
    49bc:	0307879b          	addiw	a5,a5,48
    49c0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    49c4:	033487b3          	mul	a5,s1,s3
    49c8:	9795                	srai	a5,a5,0x25
    49ca:	9f95                	subw	a5,a5,a3
    49cc:	02fb07bb          	mulw	a5,s6,a5
    49d0:	40f487bb          	subw	a5,s1,a5
    49d4:	03278733          	mul	a4,a5,s2
    49d8:	9709                	srai	a4,a4,0x22
    49da:	41f7d79b          	sraiw	a5,a5,0x1f
    49de:	40f707bb          	subw	a5,a4,a5
    49e2:	0307879b          	addiw	a5,a5,48
    49e6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    49ea:	03248733          	mul	a4,s1,s2
    49ee:	9709                	srai	a4,a4,0x22
    49f0:	9f15                	subw	a4,a4,a3
    49f2:	0027179b          	slliw	a5,a4,0x2
    49f6:	9fb9                	addw	a5,a5,a4
    49f8:	0017979b          	slliw	a5,a5,0x1
    49fc:	40f487bb          	subw	a5,s1,a5
    4a00:	0307879b          	addiw	a5,a5,48
    4a04:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4a08:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4a0c:	8556                	mv	a0,s5
    4a0e:	666000ef          	jal	5074 <unlink>
    nfiles--;
    4a12:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4a14:	57fd                	li	a5,-1
    4a16:	f6f49ce3          	bne	s1,a5,498e <fsfull+0x12c>
  printf("fsfull test finished\n");
    4a1a:	00003517          	auipc	a0,0x3
    4a1e:	cfe50513          	addi	a0,a0,-770 # 7718 <malloc+0x21e6>
    4a22:	259000ef          	jal	547a <printf>
}
    4a26:	70aa                	ld	ra,168(sp)
    4a28:	740a                	ld	s0,160(sp)
    4a2a:	64ea                	ld	s1,152(sp)
    4a2c:	694a                	ld	s2,144(sp)
    4a2e:	69aa                	ld	s3,136(sp)
    4a30:	6a0a                	ld	s4,128(sp)
    4a32:	7ae6                	ld	s5,120(sp)
    4a34:	7b46                	ld	s6,112(sp)
    4a36:	7ba6                	ld	s7,104(sp)
    4a38:	7c06                	ld	s8,96(sp)
    4a3a:	6ce6                	ld	s9,88(sp)
    4a3c:	6d46                	ld	s10,80(sp)
    4a3e:	6da6                	ld	s11,72(sp)
    4a40:	614d                	addi	sp,sp,176
    4a42:	8082                	ret
    int total = 0;
    4a44:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4a46:	40000c13          	li	s8,1024
    4a4a:	00007b97          	auipc	s7,0x7
    4a4e:	26eb8b93          	addi	s7,s7,622 # bcb8 <buf>
      if (cc < BSIZE)
    4a52:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    4a56:	8662                	mv	a2,s8
    4a58:	85de                	mv	a1,s7
    4a5a:	854a                	mv	a0,s2
    4a5c:	5e8000ef          	jal	5044 <write>
      if (cc < BSIZE)
    4a60:	00ab5563          	bge	s6,a0,4a6a <fsfull+0x208>
      total += cc;
    4a64:	00a989bb          	addw	s3,s3,a0
    while (1) {
    4a68:	b7fd                	j	4a56 <fsfull+0x1f4>
    printf("wrote %d bytes\n", total);
    4a6a:	85ce                	mv	a1,s3
    4a6c:	00003517          	auipc	a0,0x3
    4a70:	c9c50513          	addi	a0,a0,-868 # 7708 <malloc+0x21d6>
    4a74:	207000ef          	jal	547a <printf>
    close(fd);
    4a78:	854a                	mv	a0,s2
    4a7a:	5d2000ef          	jal	504c <close>
    if (total == 0)
    4a7e:	ee0982e3          	beqz	s3,4962 <fsfull+0x100>
  for (nfiles = 0;; nfiles++) {
    4a82:	2485                	addiw	s1,s1,1
    4a84:	b52d                	j	48ae <fsfull+0x4c>

0000000000004a86 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    4a86:	7179                	addi	sp,sp,-48
    4a88:	f406                	sd	ra,40(sp)
    4a8a:	f022                	sd	s0,32(sp)
    4a8c:	ec26                	sd	s1,24(sp)
    4a8e:	e84a                	sd	s2,16(sp)
    4a90:	1800                	addi	s0,sp,48
    4a92:	84aa                	mv	s1,a0
    4a94:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4a96:	00003517          	auipc	a0,0x3
    4a9a:	c9a50513          	addi	a0,a0,-870 # 7730 <malloc+0x21fe>
    4a9e:	1dd000ef          	jal	547a <printf>
  if ((pid = fork()) < 0) {
    4aa2:	57a000ef          	jal	501c <fork>
    4aa6:	02054a63          	bltz	a0,4ada <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    4aaa:	c129                	beqz	a0,4aec <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4aac:	fdc40513          	addi	a0,s0,-36
    4ab0:	57c000ef          	jal	502c <wait>
    if (xstatus != 0)
    4ab4:	fdc42783          	lw	a5,-36(s0)
    4ab8:	cf9d                	beqz	a5,4af6 <run+0x70>
      printf("FAILED\n");
    4aba:	00003517          	auipc	a0,0x3
    4abe:	c9e50513          	addi	a0,a0,-866 # 7758 <malloc+0x2226>
    4ac2:	1b9000ef          	jal	547a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4ac6:	fdc42503          	lw	a0,-36(s0)
  }
}
    4aca:	00153513          	seqz	a0,a0
    4ace:	70a2                	ld	ra,40(sp)
    4ad0:	7402                	ld	s0,32(sp)
    4ad2:	64e2                	ld	s1,24(sp)
    4ad4:	6942                	ld	s2,16(sp)
    4ad6:	6145                	addi	sp,sp,48
    4ad8:	8082                	ret
    printf("runtest: fork error\n");
    4ada:	00003517          	auipc	a0,0x3
    4ade:	c6650513          	addi	a0,a0,-922 # 7740 <malloc+0x220e>
    4ae2:	199000ef          	jal	547a <printf>
    exit(1);
    4ae6:	4505                	li	a0,1
    4ae8:	53c000ef          	jal	5024 <exit>
    f(s);
    4aec:	854a                	mv	a0,s2
    4aee:	9482                	jalr	s1
    exit(0);
    4af0:	4501                	li	a0,0
    4af2:	532000ef          	jal	5024 <exit>
      printf("OK\n");
    4af6:	00003517          	auipc	a0,0x3
    4afa:	c6a50513          	addi	a0,a0,-918 # 7760 <malloc+0x222e>
    4afe:	17d000ef          	jal	547a <printf>
    4b02:	b7d1                	j	4ac6 <run+0x40>

0000000000004b04 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    4b04:	7179                	addi	sp,sp,-48
    4b06:	f406                	sd	ra,40(sp)
    4b08:	f022                	sd	s0,32(sp)
    4b0a:	ec26                	sd	s1,24(sp)
    4b0c:	e44e                	sd	s3,8(sp)
    4b0e:	1800                	addi	s0,sp,48
    4b10:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4b12:	6508                	ld	a0,8(a0)
    4b14:	cd29                	beqz	a0,4b6e <runtests+0x6a>
    4b16:	e84a                	sd	s2,16(sp)
    4b18:	e052                	sd	s4,0(sp)
    4b1a:	892e                	mv	s2,a1
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    4b1c:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    4b1e:	00c03a33          	snez	s4,a2
  int ntests = 0;
    4b22:	4981                	li	s3,0
    4b24:	a029                	j	4b2e <runtests+0x2a>
      ntests++;
    4b26:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    4b28:	04c1                	addi	s1,s1,16
    4b2a:	6488                	ld	a0,8(s1)
    4b2c:	c905                	beqz	a0,4b5c <runtests+0x58>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    4b2e:	00090663          	beqz	s2,4b3a <runtests+0x36>
    4b32:	85ca                	mv	a1,s2
    4b34:	26a000ef          	jal	4d9e <strcmp>
    4b38:	f965                	bnez	a0,4b28 <runtests+0x24>
      if (!run(t->f, t->s)) {
    4b3a:	648c                	ld	a1,8(s1)
    4b3c:	6088                	ld	a0,0(s1)
    4b3e:	f49ff0ef          	jal	4a86 <run>
        if (continuous != 2) {
    4b42:	f175                	bnez	a0,4b26 <runtests+0x22>
    4b44:	fe0a01e3          	beqz	s4,4b26 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4b48:	00003517          	auipc	a0,0x3
    4b4c:	c2050513          	addi	a0,a0,-992 # 7768 <malloc+0x2236>
    4b50:	12b000ef          	jal	547a <printf>
          return -1;
    4b54:	59fd                	li	s3,-1
    4b56:	6942                	ld	s2,16(sp)
    4b58:	6a02                	ld	s4,0(sp)
    4b5a:	a019                	j	4b60 <runtests+0x5c>
    4b5c:	6942                	ld	s2,16(sp)
    4b5e:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    4b60:	854e                	mv	a0,s3
    4b62:	70a2                	ld	ra,40(sp)
    4b64:	7402                	ld	s0,32(sp)
    4b66:	64e2                	ld	s1,24(sp)
    4b68:	69a2                	ld	s3,8(sp)
    4b6a:	6145                	addi	sp,sp,48
    4b6c:	8082                	ret
  return ntests;
    4b6e:	4981                	li	s3,0
    4b70:	bfc5                	j	4b60 <runtests+0x5c>

0000000000004b72 <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4b72:	7179                	addi	sp,sp,-48
    4b74:	f406                	sd	ra,40(sp)
    4b76:	f022                	sd	s0,32(sp)
    4b78:	ec26                	sd	s1,24(sp)
    4b7a:	e84a                	sd	s2,16(sp)
    4b7c:	e44e                	sd	s3,8(sp)
    4b7e:	e052                	sd	s4,0(sp)
    4b80:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4b82:	4501                	li	a0,0
    4b84:	46c000ef          	jal	4ff0 <sbrk>
    4b88:	8a2a                	mv	s4,a0
  int n = 0;
    4b8a:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    4b8c:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    4b8e:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    4b90:	854e                	mv	a0,s3
    4b92:	45e000ef          	jal	4ff0 <sbrk>
    if (a == SBRK_ERROR) {
    4b96:	01250463          	beq	a0,s2,4b9e <countfree+0x2c>
      break;
    }
    n += 1;
    4b9a:	2485                	addiw	s1,s1,1
  while (1) {
    4b9c:	bfd5                	j	4b90 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    4b9e:	4501                	li	a0,0
    4ba0:	450000ef          	jal	4ff0 <sbrk>
    4ba4:	40aa053b          	subw	a0,s4,a0
    4ba8:	448000ef          	jal	4ff0 <sbrk>
  return n;
}
    4bac:	8526                	mv	a0,s1
    4bae:	70a2                	ld	ra,40(sp)
    4bb0:	7402                	ld	s0,32(sp)
    4bb2:	64e2                	ld	s1,24(sp)
    4bb4:	6942                	ld	s2,16(sp)
    4bb6:	69a2                	ld	s3,8(sp)
    4bb8:	6a02                	ld	s4,0(sp)
    4bba:	6145                	addi	sp,sp,48
    4bbc:	8082                	ret

0000000000004bbe <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    4bbe:	7159                	addi	sp,sp,-112
    4bc0:	f486                	sd	ra,104(sp)
    4bc2:	f0a2                	sd	s0,96(sp)
    4bc4:	eca6                	sd	s1,88(sp)
    4bc6:	e8ca                	sd	s2,80(sp)
    4bc8:	e4ce                	sd	s3,72(sp)
    4bca:	e0d2                	sd	s4,64(sp)
    4bcc:	fc56                	sd	s5,56(sp)
    4bce:	f85a                	sd	s6,48(sp)
    4bd0:	f45e                	sd	s7,40(sp)
    4bd2:	f062                	sd	s8,32(sp)
    4bd4:	ec66                	sd	s9,24(sp)
    4bd6:	e86a                	sd	s10,16(sp)
    4bd8:	e46e                	sd	s11,8(sp)
    4bda:	1880                	addi	s0,sp,112
    4bdc:	8aaa                	mv	s5,a0
    4bde:	89ae                	mv	s3,a1
    4be0:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4be2:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    4be6:	00003c17          	auipc	s8,0x3
    4bea:	b9ac0c13          	addi	s8,s8,-1126 # 7780 <malloc+0x224e>
    n = runtests(quicktests, justone, continuous);
    4bee:	00003b97          	auipc	s7,0x3
    4bf2:	422b8b93          	addi	s7,s7,1058 # 8010 <quicktests>
      if (continuous != 2) {
    4bf6:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    4bf8:	00004c97          	auipc	s9,0x4
    4bfc:	828c8c93          	addi	s9,s9,-2008 # 8420 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4c00:	00003d97          	auipc	s11,0x3
    4c04:	bb8d8d93          	addi	s11,s11,-1096 # 77b8 <malloc+0x2286>
    4c08:	a82d                	j	4c42 <drivetests+0x84>
      if (continuous != 2) {
    4c0a:	0b699363          	bne	s3,s6,4cb0 <drivetests+0xf2>
    int ntests = 0;
    4c0e:	4481                	li	s1,0
    4c10:	a0b9                	j	4c5e <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    4c12:	00003517          	auipc	a0,0x3
    4c16:	b8650513          	addi	a0,a0,-1146 # 7798 <malloc+0x2266>
    4c1a:	061000ef          	jal	547a <printf>
    4c1e:	a0a1                	j	4c66 <drivetests+0xa8>
        if (continuous != 2) {
    4c20:	05698b63          	beq	s3,s6,4c76 <drivetests+0xb8>
          return 1;
    4c24:	4505                	li	a0,1
    4c26:	a0b5                	j	4c92 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4c28:	864a                	mv	a2,s2
    4c2a:	85aa                	mv	a1,a0
    4c2c:	856e                	mv	a0,s11
    4c2e:	04d000ef          	jal	547a <printf>
      if (continuous != 2) {
    4c32:	09699163          	bne	s3,s6,4cb4 <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    4c36:	e491                	bnez	s1,4c42 <drivetests+0x84>
    4c38:	000d0563          	beqz	s10,4c42 <drivetests+0x84>
    4c3c:	a0a1                	j	4c84 <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    4c3e:	06098d63          	beqz	s3,4cb8 <drivetests+0xfa>
    printf("usertests starting\n");
    4c42:	8562                	mv	a0,s8
    4c44:	037000ef          	jal	547a <printf>
    int free0 = countfree();
    4c48:	f2bff0ef          	jal	4b72 <countfree>
    4c4c:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4c4e:	864e                	mv	a2,s3
    4c50:	85d2                	mv	a1,s4
    4c52:	855e                	mv	a0,s7
    4c54:	eb1ff0ef          	jal	4b04 <runtests>
    4c58:	84aa                	mv	s1,a0
    if (n < 0) {
    4c5a:	fa0548e3          	bltz	a0,4c0a <drivetests+0x4c>
    if (!quick) {
    4c5e:	000a9c63          	bnez	s5,4c76 <drivetests+0xb8>
      if (justone == 0)
    4c62:	fa0a08e3          	beqz	s4,4c12 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    4c66:	864e                	mv	a2,s3
    4c68:	85d2                	mv	a1,s4
    4c6a:	8566                	mv	a0,s9
    4c6c:	e99ff0ef          	jal	4b04 <runtests>
      if (n < 0) {
    4c70:	fa0548e3          	bltz	a0,4c20 <drivetests+0x62>
        ntests += n;
    4c74:	9ca9                	addw	s1,s1,a0
    if ((free1 = countfree()) < free0) {
    4c76:	efdff0ef          	jal	4b72 <countfree>
    4c7a:	fb2547e3          	blt	a0,s2,4c28 <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    4c7e:	f0e1                	bnez	s1,4c3e <drivetests+0x80>
    4c80:	fa0d0fe3          	beqz	s10,4c3e <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    4c84:	00003517          	auipc	a0,0x3
    4c88:	b6450513          	addi	a0,a0,-1180 # 77e8 <malloc+0x22b6>
    4c8c:	7ee000ef          	jal	547a <printf>
      return 1;
    4c90:	4505                	li	a0,1
  return 0;
}
    4c92:	70a6                	ld	ra,104(sp)
    4c94:	7406                	ld	s0,96(sp)
    4c96:	64e6                	ld	s1,88(sp)
    4c98:	6946                	ld	s2,80(sp)
    4c9a:	69a6                	ld	s3,72(sp)
    4c9c:	6a06                	ld	s4,64(sp)
    4c9e:	7ae2                	ld	s5,56(sp)
    4ca0:	7b42                	ld	s6,48(sp)
    4ca2:	7ba2                	ld	s7,40(sp)
    4ca4:	7c02                	ld	s8,32(sp)
    4ca6:	6ce2                	ld	s9,24(sp)
    4ca8:	6d42                	ld	s10,16(sp)
    4caa:	6da2                	ld	s11,8(sp)
    4cac:	6165                	addi	sp,sp,112
    4cae:	8082                	ret
        return 1;
    4cb0:	4505                	li	a0,1
    4cb2:	b7c5                	j	4c92 <drivetests+0xd4>
        return 1;
    4cb4:	4505                	li	a0,1
    4cb6:	bff1                	j	4c92 <drivetests+0xd4>
  return 0;
    4cb8:	854e                	mv	a0,s3
    4cba:	bfe1                	j	4c92 <drivetests+0xd4>

0000000000004cbc <main>:

int
main(int argc, char *argv[])
{
    4cbc:	1101                	addi	sp,sp,-32
    4cbe:	ec06                	sd	ra,24(sp)
    4cc0:	e822                	sd	s0,16(sp)
    4cc2:	e426                	sd	s1,8(sp)
    4cc4:	e04a                	sd	s2,0(sp)
    4cc6:	1000                	addi	s0,sp,32
    4cc8:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    4cca:	4789                	li	a5,2
    4ccc:	00f50e63          	beq	a0,a5,4ce8 <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    4cd0:	4785                	li	a5,1
    4cd2:	06a7c663          	blt	a5,a0,4d3e <main+0x82>
  char *justone = 0;
    4cd6:	4601                	li	a2,0
  int quick = 0;
    4cd8:	4501                	li	a0,0
  int continuous = 0;
    4cda:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4cdc:	ee3ff0ef          	jal	4bbe <drivetests>
    4ce0:	cd35                	beqz	a0,4d5c <main+0xa0>
    exit(1);
    4ce2:	4505                	li	a0,1
    4ce4:	340000ef          	jal	5024 <exit>
    4ce8:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    4cea:	00003597          	auipc	a1,0x3
    4cee:	b1658593          	addi	a1,a1,-1258 # 7800 <malloc+0x22ce>
    4cf2:	00893503          	ld	a0,8(s2)
    4cf6:	0a8000ef          	jal	4d9e <strcmp>
    4cfa:	85aa                	mv	a1,a0
    4cfc:	e501                	bnez	a0,4d04 <main+0x48>
  char *justone = 0;
    4cfe:	4601                	li	a2,0
    quick = 1;
    4d00:	4505                	li	a0,1
    4d02:	bfe9                	j	4cdc <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    4d04:	00003597          	auipc	a1,0x3
    4d08:	b0458593          	addi	a1,a1,-1276 # 7808 <malloc+0x22d6>
    4d0c:	00893503          	ld	a0,8(s2)
    4d10:	08e000ef          	jal	4d9e <strcmp>
    4d14:	cd15                	beqz	a0,4d50 <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    4d16:	00003597          	auipc	a1,0x3
    4d1a:	b4258593          	addi	a1,a1,-1214 # 7858 <malloc+0x2326>
    4d1e:	00893503          	ld	a0,8(s2)
    4d22:	07c000ef          	jal	4d9e <strcmp>
    4d26:	c905                	beqz	a0,4d56 <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    4d28:	00893603          	ld	a2,8(s2)
    4d2c:	00064703          	lbu	a4,0(a2)
    4d30:	02d00793          	li	a5,45
    4d34:	00f70563          	beq	a4,a5,4d3e <main+0x82>
  int quick = 0;
    4d38:	4501                	li	a0,0
  int continuous = 0;
    4d3a:	4581                	li	a1,0
    4d3c:	b745                	j	4cdc <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4d3e:	00003517          	auipc	a0,0x3
    4d42:	ad250513          	addi	a0,a0,-1326 # 7810 <malloc+0x22de>
    4d46:	734000ef          	jal	547a <printf>
    exit(1);
    4d4a:	4505                	li	a0,1
    4d4c:	2d8000ef          	jal	5024 <exit>
  char *justone = 0;
    4d50:	4601                	li	a2,0
    continuous = 1;
    4d52:	4585                	li	a1,1
    4d54:	b761                	j	4cdc <main+0x20>
    continuous = 2;
    4d56:	85a6                	mv	a1,s1
  char *justone = 0;
    4d58:	4601                	li	a2,0
    4d5a:	b749                	j	4cdc <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4d5c:	00003517          	auipc	a0,0x3
    4d60:	ae450513          	addi	a0,a0,-1308 # 7840 <malloc+0x230e>
    4d64:	716000ef          	jal	547a <printf>
  exit(0);
    4d68:	4501                	li	a0,0
    4d6a:	2ba000ef          	jal	5024 <exit>

0000000000004d6e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4d6e:	1141                	addi	sp,sp,-16
    4d70:	e406                	sd	ra,8(sp)
    4d72:	e022                	sd	s0,0(sp)
    4d74:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4d76:	f47ff0ef          	jal	4cbc <main>
  exit(r);
    4d7a:	2aa000ef          	jal	5024 <exit>

0000000000004d7e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    4d7e:	1141                	addi	sp,sp,-16
    4d80:	e406                	sd	ra,8(sp)
    4d82:	e022                	sd	s0,0(sp)
    4d84:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    4d86:	87aa                	mv	a5,a0
    4d88:	0585                	addi	a1,a1,1
    4d8a:	0785                	addi	a5,a5,1
    4d8c:	fff5c703          	lbu	a4,-1(a1)
    4d90:	fee78fa3          	sb	a4,-1(a5)
    4d94:	fb75                	bnez	a4,4d88 <strcpy+0xa>
    ;
  return os;
}
    4d96:	60a2                	ld	ra,8(sp)
    4d98:	6402                	ld	s0,0(sp)
    4d9a:	0141                	addi	sp,sp,16
    4d9c:	8082                	ret

0000000000004d9e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4d9e:	1141                	addi	sp,sp,-16
    4da0:	e406                	sd	ra,8(sp)
    4da2:	e022                	sd	s0,0(sp)
    4da4:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    4da6:	00054783          	lbu	a5,0(a0)
    4daa:	cb91                	beqz	a5,4dbe <strcmp+0x20>
    4dac:	0005c703          	lbu	a4,0(a1)
    4db0:	00f71763          	bne	a4,a5,4dbe <strcmp+0x20>
    p++, q++;
    4db4:	0505                	addi	a0,a0,1
    4db6:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    4db8:	00054783          	lbu	a5,0(a0)
    4dbc:	fbe5                	bnez	a5,4dac <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4dbe:	0005c503          	lbu	a0,0(a1)
}
    4dc2:	40a7853b          	subw	a0,a5,a0
    4dc6:	60a2                	ld	ra,8(sp)
    4dc8:	6402                	ld	s0,0(sp)
    4dca:	0141                	addi	sp,sp,16
    4dcc:	8082                	ret

0000000000004dce <strlen>:

uint
strlen(const char *s)
{
    4dce:	1141                	addi	sp,sp,-16
    4dd0:	e406                	sd	ra,8(sp)
    4dd2:	e022                	sd	s0,0(sp)
    4dd4:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    4dd6:	00054783          	lbu	a5,0(a0)
    4dda:	cf91                	beqz	a5,4df6 <strlen+0x28>
    4ddc:	00150793          	addi	a5,a0,1
    4de0:	86be                	mv	a3,a5
    4de2:	0785                	addi	a5,a5,1
    4de4:	fff7c703          	lbu	a4,-1(a5)
    4de8:	ff65                	bnez	a4,4de0 <strlen+0x12>
    4dea:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4dee:	60a2                	ld	ra,8(sp)
    4df0:	6402                	ld	s0,0(sp)
    4df2:	0141                	addi	sp,sp,16
    4df4:	8082                	ret
  for (n = 0; s[n]; n++)
    4df6:	4501                	li	a0,0
    4df8:	bfdd                	j	4dee <strlen+0x20>

0000000000004dfa <memset>:

void *
memset(void *dst, int c, uint n)
{
    4dfa:	1141                	addi	sp,sp,-16
    4dfc:	e406                	sd	ra,8(sp)
    4dfe:	e022                	sd	s0,0(sp)
    4e00:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    4e02:	ca19                	beqz	a2,4e18 <memset+0x1e>
    4e04:	87aa                	mv	a5,a0
    4e06:	1602                	slli	a2,a2,0x20
    4e08:	9201                	srli	a2,a2,0x20
    4e0a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4e0e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    4e12:	0785                	addi	a5,a5,1
    4e14:	fee79de3          	bne	a5,a4,4e0e <memset+0x14>
  }
  return dst;
}
    4e18:	60a2                	ld	ra,8(sp)
    4e1a:	6402                	ld	s0,0(sp)
    4e1c:	0141                	addi	sp,sp,16
    4e1e:	8082                	ret

0000000000004e20 <strchr>:

char *
strchr(const char *s, char c)
{
    4e20:	1141                	addi	sp,sp,-16
    4e22:	e406                	sd	ra,8(sp)
    4e24:	e022                	sd	s0,0(sp)
    4e26:	0800                	addi	s0,sp,16
  for (; *s; s++)
    4e28:	00054783          	lbu	a5,0(a0)
    4e2c:	cf81                	beqz	a5,4e44 <strchr+0x24>
    if (*s == c)
    4e2e:	00f58763          	beq	a1,a5,4e3c <strchr+0x1c>
  for (; *s; s++)
    4e32:	0505                	addi	a0,a0,1
    4e34:	00054783          	lbu	a5,0(a0)
    4e38:	fbfd                	bnez	a5,4e2e <strchr+0xe>
      return (char *)s;
  return 0;
    4e3a:	4501                	li	a0,0
}
    4e3c:	60a2                	ld	ra,8(sp)
    4e3e:	6402                	ld	s0,0(sp)
    4e40:	0141                	addi	sp,sp,16
    4e42:	8082                	ret
  return 0;
    4e44:	4501                	li	a0,0
    4e46:	bfdd                	j	4e3c <strchr+0x1c>

0000000000004e48 <gets>:

char *
gets(char *buf, int max)
{
    4e48:	711d                	addi	sp,sp,-96
    4e4a:	ec86                	sd	ra,88(sp)
    4e4c:	e8a2                	sd	s0,80(sp)
    4e4e:	e4a6                	sd	s1,72(sp)
    4e50:	e0ca                	sd	s2,64(sp)
    4e52:	fc4e                	sd	s3,56(sp)
    4e54:	f852                	sd	s4,48(sp)
    4e56:	f456                	sd	s5,40(sp)
    4e58:	f05a                	sd	s6,32(sp)
    4e5a:	ec5e                	sd	s7,24(sp)
    4e5c:	e862                	sd	s8,16(sp)
    4e5e:	1080                	addi	s0,sp,96
    4e60:	8baa                	mv	s7,a0
    4e62:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    4e64:	892a                	mv	s2,a0
    4e66:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4e68:	faf40b13          	addi	s6,s0,-81
    4e6c:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
    4e6e:	8c26                	mv	s8,s1
    4e70:	0014899b          	addiw	s3,s1,1
    4e74:	84ce                	mv	s1,s3
    4e76:	0349d463          	bge	s3,s4,4e9e <gets+0x56>
    cc = read(0, &c, 1);
    4e7a:	8656                	mv	a2,s5
    4e7c:	85da                	mv	a1,s6
    4e7e:	4501                	li	a0,0
    4e80:	1bc000ef          	jal	503c <read>
    if (cc < 1)
    4e84:	00a05d63          	blez	a0,4e9e <gets+0x56>
      break;
    buf[i++] = c;
    4e88:	faf44783          	lbu	a5,-81(s0)
    4e8c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    4e90:	0905                	addi	s2,s2,1
    4e92:	ff678713          	addi	a4,a5,-10
    4e96:	c319                	beqz	a4,4e9c <gets+0x54>
    4e98:	17cd                	addi	a5,a5,-13
    4e9a:	fbf1                	bnez	a5,4e6e <gets+0x26>
    buf[i++] = c;
    4e9c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4e9e:	9c5e                	add	s8,s8,s7
    4ea0:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4ea4:	855e                	mv	a0,s7
    4ea6:	60e6                	ld	ra,88(sp)
    4ea8:	6446                	ld	s0,80(sp)
    4eaa:	64a6                	ld	s1,72(sp)
    4eac:	6906                	ld	s2,64(sp)
    4eae:	79e2                	ld	s3,56(sp)
    4eb0:	7a42                	ld	s4,48(sp)
    4eb2:	7aa2                	ld	s5,40(sp)
    4eb4:	7b02                	ld	s6,32(sp)
    4eb6:	6be2                	ld	s7,24(sp)
    4eb8:	6c42                	ld	s8,16(sp)
    4eba:	6125                	addi	sp,sp,96
    4ebc:	8082                	ret

0000000000004ebe <stat>:

int
stat(const char *n, struct stat *st)
{
    4ebe:	1101                	addi	sp,sp,-32
    4ec0:	ec06                	sd	ra,24(sp)
    4ec2:	e822                	sd	s0,16(sp)
    4ec4:	e04a                	sd	s2,0(sp)
    4ec6:	1000                	addi	s0,sp,32
    4ec8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4eca:	4581                	li	a1,0
    4ecc:	198000ef          	jal	5064 <open>
  if (fd < 0)
    4ed0:	02054263          	bltz	a0,4ef4 <stat+0x36>
    4ed4:	e426                	sd	s1,8(sp)
    4ed6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4ed8:	85ca                	mv	a1,s2
    4eda:	1a2000ef          	jal	507c <fstat>
    4ede:	892a                	mv	s2,a0
  close(fd);
    4ee0:	8526                	mv	a0,s1
    4ee2:	16a000ef          	jal	504c <close>
  return r;
    4ee6:	64a2                	ld	s1,8(sp)
}
    4ee8:	854a                	mv	a0,s2
    4eea:	60e2                	ld	ra,24(sp)
    4eec:	6442                	ld	s0,16(sp)
    4eee:	6902                	ld	s2,0(sp)
    4ef0:	6105                	addi	sp,sp,32
    4ef2:	8082                	ret
    return -1;
    4ef4:	57fd                	li	a5,-1
    4ef6:	893e                	mv	s2,a5
    4ef8:	bfc5                	j	4ee8 <stat+0x2a>

0000000000004efa <atoi>:

int
atoi(const char *s)
{
    4efa:	1141                	addi	sp,sp,-16
    4efc:	e406                	sd	ra,8(sp)
    4efe:	e022                	sd	s0,0(sp)
    4f00:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    4f02:	00054683          	lbu	a3,0(a0)
    4f06:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x31318>
    4f0a:	0ff7f793          	zext.b	a5,a5
    4f0e:	4625                	li	a2,9
    4f10:	02f66963          	bltu	a2,a5,4f42 <atoi+0x48>
    4f14:	872a                	mv	a4,a0
  n = 0;
    4f16:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    4f18:	0705                	addi	a4,a4,1 # 1000001 <base+0xff1349>
    4f1a:	0025179b          	slliw	a5,a0,0x2
    4f1e:	9fa9                	addw	a5,a5,a0
    4f20:	0017979b          	slliw	a5,a5,0x1
    4f24:	9fb5                	addw	a5,a5,a3
    4f26:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    4f2a:	00074683          	lbu	a3,0(a4)
    4f2e:	fd06879b          	addiw	a5,a3,-48
    4f32:	0ff7f793          	zext.b	a5,a5
    4f36:	fef671e3          	bgeu	a2,a5,4f18 <atoi+0x1e>
  return n;
}
    4f3a:	60a2                	ld	ra,8(sp)
    4f3c:	6402                	ld	s0,0(sp)
    4f3e:	0141                	addi	sp,sp,16
    4f40:	8082                	ret
  n = 0;
    4f42:	4501                	li	a0,0
    4f44:	bfdd                	j	4f3a <atoi+0x40>

0000000000004f46 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    4f46:	1141                	addi	sp,sp,-16
    4f48:	e406                	sd	ra,8(sp)
    4f4a:	e022                	sd	s0,0(sp)
    4f4c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4f4e:	02b57563          	bgeu	a0,a1,4f78 <memmove+0x32>
    while (n-- > 0)
    4f52:	00c05f63          	blez	a2,4f70 <memmove+0x2a>
    4f56:	1602                	slli	a2,a2,0x20
    4f58:	9201                	srli	a2,a2,0x20
    4f5a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4f5e:	872a                	mv	a4,a0
      *dst++ = *src++;
    4f60:	0585                	addi	a1,a1,1
    4f62:	0705                	addi	a4,a4,1
    4f64:	fff5c683          	lbu	a3,-1(a1)
    4f68:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    4f6c:	fee79ae3          	bne	a5,a4,4f60 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4f70:	60a2                	ld	ra,8(sp)
    4f72:	6402                	ld	s0,0(sp)
    4f74:	0141                	addi	sp,sp,16
    4f76:	8082                	ret
    while (n-- > 0)
    4f78:	fec05ce3          	blez	a2,4f70 <memmove+0x2a>
    dst += n;
    4f7c:	00c50733          	add	a4,a0,a2
    src += n;
    4f80:	95b2                	add	a1,a1,a2
    4f82:	fff6079b          	addiw	a5,a2,-1
    4f86:	1782                	slli	a5,a5,0x20
    4f88:	9381                	srli	a5,a5,0x20
    4f8a:	fff7c793          	not	a5,a5
    4f8e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4f90:	15fd                	addi	a1,a1,-1
    4f92:	177d                	addi	a4,a4,-1
    4f94:	0005c683          	lbu	a3,0(a1)
    4f98:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    4f9c:	fef71ae3          	bne	a4,a5,4f90 <memmove+0x4a>
    4fa0:	bfc1                	j	4f70 <memmove+0x2a>

0000000000004fa2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4fa2:	1141                	addi	sp,sp,-16
    4fa4:	e406                	sd	ra,8(sp)
    4fa6:	e022                	sd	s0,0(sp)
    4fa8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4faa:	c61d                	beqz	a2,4fd8 <memcmp+0x36>
    4fac:	1602                	slli	a2,a2,0x20
    4fae:	9201                	srli	a2,a2,0x20
    4fb0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    4fb4:	00054783          	lbu	a5,0(a0)
    4fb8:	0005c703          	lbu	a4,0(a1)
    4fbc:	00e79863          	bne	a5,a4,4fcc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    4fc0:	0505                	addi	a0,a0,1
    p2++;
    4fc2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4fc4:	fed518e3          	bne	a0,a3,4fb4 <memcmp+0x12>
  }
  return 0;
    4fc8:	4501                	li	a0,0
    4fca:	a019                	j	4fd0 <memcmp+0x2e>
      return *p1 - *p2;
    4fcc:	40e7853b          	subw	a0,a5,a4
}
    4fd0:	60a2                	ld	ra,8(sp)
    4fd2:	6402                	ld	s0,0(sp)
    4fd4:	0141                	addi	sp,sp,16
    4fd6:	8082                	ret
  return 0;
    4fd8:	4501                	li	a0,0
    4fda:	bfdd                	j	4fd0 <memcmp+0x2e>

0000000000004fdc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4fdc:	1141                	addi	sp,sp,-16
    4fde:	e406                	sd	ra,8(sp)
    4fe0:	e022                	sd	s0,0(sp)
    4fe2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4fe4:	f63ff0ef          	jal	4f46 <memmove>
}
    4fe8:	60a2                	ld	ra,8(sp)
    4fea:	6402                	ld	s0,0(sp)
    4fec:	0141                	addi	sp,sp,16
    4fee:	8082                	ret

0000000000004ff0 <sbrk>:

char *
sbrk(int n)
{
    4ff0:	1141                	addi	sp,sp,-16
    4ff2:	e406                	sd	ra,8(sp)
    4ff4:	e022                	sd	s0,0(sp)
    4ff6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4ff8:	4585                	li	a1,1
    4ffa:	0b2000ef          	jal	50ac <sys_sbrk>
}
    4ffe:	60a2                	ld	ra,8(sp)
    5000:	6402                	ld	s0,0(sp)
    5002:	0141                	addi	sp,sp,16
    5004:	8082                	ret

0000000000005006 <sbrklazy>:

char *
sbrklazy(int n)
{
    5006:	1141                	addi	sp,sp,-16
    5008:	e406                	sd	ra,8(sp)
    500a:	e022                	sd	s0,0(sp)
    500c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    500e:	4589                	li	a1,2
    5010:	09c000ef          	jal	50ac <sys_sbrk>
}
    5014:	60a2                	ld	ra,8(sp)
    5016:	6402                	ld	s0,0(sp)
    5018:	0141                	addi	sp,sp,16
    501a:	8082                	ret

000000000000501c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    501c:	4885                	li	a7,1
 ecall
    501e:	00000073          	ecall
 ret
    5022:	8082                	ret

0000000000005024 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5024:	4889                	li	a7,2
 ecall
    5026:	00000073          	ecall
 ret
    502a:	8082                	ret

000000000000502c <wait>:
.global wait
wait:
 li a7, SYS_wait
    502c:	488d                	li	a7,3
 ecall
    502e:	00000073          	ecall
 ret
    5032:	8082                	ret

0000000000005034 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5034:	4891                	li	a7,4
 ecall
    5036:	00000073          	ecall
 ret
    503a:	8082                	ret

000000000000503c <read>:
.global read
read:
 li a7, SYS_read
    503c:	4895                	li	a7,5
 ecall
    503e:	00000073          	ecall
 ret
    5042:	8082                	ret

0000000000005044 <write>:
.global write
write:
 li a7, SYS_write
    5044:	48c1                	li	a7,16
 ecall
    5046:	00000073          	ecall
 ret
    504a:	8082                	ret

000000000000504c <close>:
.global close
close:
 li a7, SYS_close
    504c:	48d5                	li	a7,21
 ecall
    504e:	00000073          	ecall
 ret
    5052:	8082                	ret

0000000000005054 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5054:	4899                	li	a7,6
 ecall
    5056:	00000073          	ecall
 ret
    505a:	8082                	ret

000000000000505c <exec>:
.global exec
exec:
 li a7, SYS_exec
    505c:	489d                	li	a7,7
 ecall
    505e:	00000073          	ecall
 ret
    5062:	8082                	ret

0000000000005064 <open>:
.global open
open:
 li a7, SYS_open
    5064:	48bd                	li	a7,15
 ecall
    5066:	00000073          	ecall
 ret
    506a:	8082                	ret

000000000000506c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    506c:	48c5                	li	a7,17
 ecall
    506e:	00000073          	ecall
 ret
    5072:	8082                	ret

0000000000005074 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5074:	48c9                	li	a7,18
 ecall
    5076:	00000073          	ecall
 ret
    507a:	8082                	ret

000000000000507c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    507c:	48a1                	li	a7,8
 ecall
    507e:	00000073          	ecall
 ret
    5082:	8082                	ret

0000000000005084 <link>:
.global link
link:
 li a7, SYS_link
    5084:	48cd                	li	a7,19
 ecall
    5086:	00000073          	ecall
 ret
    508a:	8082                	ret

000000000000508c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    508c:	48d1                	li	a7,20
 ecall
    508e:	00000073          	ecall
 ret
    5092:	8082                	ret

0000000000005094 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5094:	48a5                	li	a7,9
 ecall
    5096:	00000073          	ecall
 ret
    509a:	8082                	ret

000000000000509c <dup>:
.global dup
dup:
 li a7, SYS_dup
    509c:	48a9                	li	a7,10
 ecall
    509e:	00000073          	ecall
 ret
    50a2:	8082                	ret

00000000000050a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    50a4:	48ad                	li	a7,11
 ecall
    50a6:	00000073          	ecall
 ret
    50aa:	8082                	ret

00000000000050ac <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    50ac:	48b1                	li	a7,12
 ecall
    50ae:	00000073          	ecall
 ret
    50b2:	8082                	ret

00000000000050b4 <pause>:
.global pause
pause:
 li a7, SYS_pause
    50b4:	48b5                	li	a7,13
 ecall
    50b6:	00000073          	ecall
 ret
    50ba:	8082                	ret

00000000000050bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    50bc:	48b9                	li	a7,14
 ecall
    50be:	00000073          	ecall
 ret
    50c2:	8082                	ret

00000000000050c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    50c4:	48d9                	li	a7,22
 ecall
    50c6:	00000073          	ecall
 ret
    50ca:	8082                	ret

00000000000050cc <getprocinfo>:
.global getprocinfo
getprocinfo:
 li a7, SYS_getprocinfo
    50cc:	48dd                	li	a7,23
 ecall
    50ce:	00000073          	ecall
 ret
    50d2:	8082                	ret

00000000000050d4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    50d4:	1101                	addi	sp,sp,-32
    50d6:	ec06                	sd	ra,24(sp)
    50d8:	e822                	sd	s0,16(sp)
    50da:	1000                	addi	s0,sp,32
    50dc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    50e0:	4605                	li	a2,1
    50e2:	fef40593          	addi	a1,s0,-17
    50e6:	f5fff0ef          	jal	5044 <write>
}
    50ea:	60e2                	ld	ra,24(sp)
    50ec:	6442                	ld	s0,16(sp)
    50ee:	6105                	addi	sp,sp,32
    50f0:	8082                	ret

00000000000050f2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    50f2:	715d                	addi	sp,sp,-80
    50f4:	e486                	sd	ra,72(sp)
    50f6:	e0a2                	sd	s0,64(sp)
    50f8:	f84a                	sd	s2,48(sp)
    50fa:	f44e                	sd	s3,40(sp)
    50fc:	0880                	addi	s0,sp,80
    50fe:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    5100:	c6d1                	beqz	a3,518c <printint+0x9a>
    5102:	0805d563          	bgez	a1,518c <printint+0x9a>
    neg = 1;
    x = -xx;
    5106:	40b005b3          	neg	a1,a1
    neg = 1;
    510a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    510c:	fb840993          	addi	s3,s0,-72
  neg = 0;
    5110:	86ce                	mv	a3,s3
  i = 0;
    5112:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    5114:	00003817          	auipc	a6,0x3
    5118:	b7480813          	addi	a6,a6,-1164 # 7c88 <digits>
    511c:	88ba                	mv	a7,a4
    511e:	0017051b          	addiw	a0,a4,1
    5122:	872a                	mv	a4,a0
    5124:	02c5f7b3          	remu	a5,a1,a2
    5128:	97c2                	add	a5,a5,a6
    512a:	0007c783          	lbu	a5,0(a5)
    512e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5132:	87ae                	mv	a5,a1
    5134:	02c5d5b3          	divu	a1,a1,a2
    5138:	0685                	addi	a3,a3,1
    513a:	fec7f1e3          	bgeu	a5,a2,511c <printint+0x2a>
  if (neg)
    513e:	00030c63          	beqz	t1,5156 <printint+0x64>
    buf[i++] = '-';
    5142:	fd050793          	addi	a5,a0,-48
    5146:	00878533          	add	a0,a5,s0
    514a:	02d00793          	li	a5,45
    514e:	fef50423          	sb	a5,-24(a0)
    5152:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    5156:	02e05563          	blez	a4,5180 <printint+0x8e>
    515a:	fc26                	sd	s1,56(sp)
    515c:	377d                	addiw	a4,a4,-1
    515e:	00e984b3          	add	s1,s3,a4
    5162:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    5164:	99ba                	add	s3,s3,a4
    5166:	1702                	slli	a4,a4,0x20
    5168:	9301                	srli	a4,a4,0x20
    516a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    516e:	0004c583          	lbu	a1,0(s1)
    5172:	854a                	mv	a0,s2
    5174:	f61ff0ef          	jal	50d4 <putc>
  while (--i >= 0)
    5178:	14fd                	addi	s1,s1,-1
    517a:	ff349ae3          	bne	s1,s3,516e <printint+0x7c>
    517e:	74e2                	ld	s1,56(sp)
}
    5180:	60a6                	ld	ra,72(sp)
    5182:	6406                	ld	s0,64(sp)
    5184:	7942                	ld	s2,48(sp)
    5186:	79a2                	ld	s3,40(sp)
    5188:	6161                	addi	sp,sp,80
    518a:	8082                	ret
  neg = 0;
    518c:	4301                	li	t1,0
    518e:	bfbd                	j	510c <printint+0x1a>

0000000000005190 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5190:	711d                	addi	sp,sp,-96
    5192:	ec86                	sd	ra,88(sp)
    5194:	e8a2                	sd	s0,80(sp)
    5196:	e4a6                	sd	s1,72(sp)
    5198:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    519a:	0005c483          	lbu	s1,0(a1)
    519e:	22048363          	beqz	s1,53c4 <vprintf+0x234>
    51a2:	e0ca                	sd	s2,64(sp)
    51a4:	fc4e                	sd	s3,56(sp)
    51a6:	f852                	sd	s4,48(sp)
    51a8:	f456                	sd	s5,40(sp)
    51aa:	f05a                	sd	s6,32(sp)
    51ac:	ec5e                	sd	s7,24(sp)
    51ae:	e862                	sd	s8,16(sp)
    51b0:	8b2a                	mv	s6,a0
    51b2:	8a2e                	mv	s4,a1
    51b4:	8bb2                	mv	s7,a2
  state = 0;
    51b6:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    51b8:	4901                	li	s2,0
    51ba:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    51bc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    51c0:	06400c13          	li	s8,100
    51c4:	a00d                	j	51e6 <vprintf+0x56>
        putc(fd, c0);
    51c6:	85a6                	mv	a1,s1
    51c8:	855a                	mv	a0,s6
    51ca:	f0bff0ef          	jal	50d4 <putc>
    51ce:	a019                	j	51d4 <vprintf+0x44>
    } else if (state == '%') {
    51d0:	03598363          	beq	s3,s5,51f6 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
    51d4:	0019079b          	addiw	a5,s2,1
    51d8:	893e                	mv	s2,a5
    51da:	873e                	mv	a4,a5
    51dc:	97d2                	add	a5,a5,s4
    51de:	0007c483          	lbu	s1,0(a5)
    51e2:	1c048a63          	beqz	s1,53b6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    51e6:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    51ea:	fe0993e3          	bnez	s3,51d0 <vprintf+0x40>
      if (c0 == '%') {
    51ee:	fd579ce3          	bne	a5,s5,51c6 <vprintf+0x36>
        state = '%';
    51f2:	89be                	mv	s3,a5
    51f4:	b7c5                	j	51d4 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
    51f6:	00ea06b3          	add	a3,s4,a4
    51fa:	0016c603          	lbu	a2,1(a3)
      if (c1)
    51fe:	1c060863          	beqz	a2,53ce <vprintf+0x23e>
      if (c0 == 'd') {
    5202:	03878763          	beq	a5,s8,5230 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    5206:	f9478693          	addi	a3,a5,-108
    520a:	0016b693          	seqz	a3,a3
    520e:	f9c60593          	addi	a1,a2,-100
    5212:	e99d                	bnez	a1,5248 <vprintf+0xb8>
    5214:	ca95                	beqz	a3,5248 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5216:	008b8493          	addi	s1,s7,8
    521a:	4685                	li	a3,1
    521c:	4629                	li	a2,10
    521e:	000bb583          	ld	a1,0(s7)
    5222:	855a                	mv	a0,s6
    5224:	ecfff0ef          	jal	50f2 <printint>
        i += 1;
    5228:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    522a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    522c:	4981                	li	s3,0
    522e:	b75d                	j	51d4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    5230:	008b8493          	addi	s1,s7,8
    5234:	4685                	li	a3,1
    5236:	4629                	li	a2,10
    5238:	000ba583          	lw	a1,0(s7)
    523c:	855a                	mv	a0,s6
    523e:	eb5ff0ef          	jal	50f2 <printint>
    5242:	8ba6                	mv	s7,s1
      state = 0;
    5244:	4981                	li	s3,0
    5246:	b779                	j	51d4 <vprintf+0x44>
        c2 = fmt[i + 2] & 0xff;
    5248:	9752                	add	a4,a4,s4
    524a:	00274583          	lbu	a1,2(a4)
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    524e:	f9460713          	addi	a4,a2,-108
    5252:	00173713          	seqz	a4,a4
    5256:	8f75                	and	a4,a4,a3
    5258:	f9c58513          	addi	a0,a1,-100
    525c:	18051363          	bnez	a0,53e2 <vprintf+0x252>
    5260:	18070163          	beqz	a4,53e2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5264:	008b8493          	addi	s1,s7,8
    5268:	4685                	li	a3,1
    526a:	4629                	li	a2,10
    526c:	000bb583          	ld	a1,0(s7)
    5270:	855a                	mv	a0,s6
    5272:	e81ff0ef          	jal	50f2 <printint>
        i += 2;
    5276:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5278:	8ba6                	mv	s7,s1
      state = 0;
    527a:	4981                	li	s3,0
        i += 2;
    527c:	bfa1                	j	51d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    527e:	008b8493          	addi	s1,s7,8
    5282:	4681                	li	a3,0
    5284:	4629                	li	a2,10
    5286:	000be583          	lwu	a1,0(s7)
    528a:	855a                	mv	a0,s6
    528c:	e67ff0ef          	jal	50f2 <printint>
    5290:	8ba6                	mv	s7,s1
      state = 0;
    5292:	4981                	li	s3,0
    5294:	b781                	j	51d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5296:	008b8493          	addi	s1,s7,8
    529a:	4681                	li	a3,0
    529c:	4629                	li	a2,10
    529e:	000bb583          	ld	a1,0(s7)
    52a2:	855a                	mv	a0,s6
    52a4:	e4fff0ef          	jal	50f2 <printint>
        i += 1;
    52a8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    52aa:	8ba6                	mv	s7,s1
      state = 0;
    52ac:	4981                	li	s3,0
    52ae:	b71d                	j	51d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    52b0:	008b8493          	addi	s1,s7,8
    52b4:	4681                	li	a3,0
    52b6:	4629                	li	a2,10
    52b8:	000bb583          	ld	a1,0(s7)
    52bc:	855a                	mv	a0,s6
    52be:	e35ff0ef          	jal	50f2 <printint>
        i += 2;
    52c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    52c4:	8ba6                	mv	s7,s1
      state = 0;
    52c6:	4981                	li	s3,0
        i += 2;
    52c8:	b731                	j	51d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    52ca:	008b8493          	addi	s1,s7,8
    52ce:	4681                	li	a3,0
    52d0:	4641                	li	a2,16
    52d2:	000be583          	lwu	a1,0(s7)
    52d6:	855a                	mv	a0,s6
    52d8:	e1bff0ef          	jal	50f2 <printint>
    52dc:	8ba6                	mv	s7,s1
      state = 0;
    52de:	4981                	li	s3,0
    52e0:	bdd5                	j	51d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    52e2:	008b8493          	addi	s1,s7,8
    52e6:	4681                	li	a3,0
    52e8:	4641                	li	a2,16
    52ea:	000bb583          	ld	a1,0(s7)
    52ee:	855a                	mv	a0,s6
    52f0:	e03ff0ef          	jal	50f2 <printint>
        i += 1;
    52f4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    52f6:	8ba6                	mv	s7,s1
      state = 0;
    52f8:	4981                	li	s3,0
    52fa:	bde9                	j	51d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    52fc:	008b8493          	addi	s1,s7,8
    5300:	4681                	li	a3,0
    5302:	4641                	li	a2,16
    5304:	000bb583          	ld	a1,0(s7)
    5308:	855a                	mv	a0,s6
    530a:	de9ff0ef          	jal	50f2 <printint>
        i += 2;
    530e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5310:	8ba6                	mv	s7,s1
      state = 0;
    5312:	4981                	li	s3,0
        i += 2;
    5314:	b5c1                	j	51d4 <vprintf+0x44>
    5316:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    5318:	008b8793          	addi	a5,s7,8
    531c:	8cbe                	mv	s9,a5
    531e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5322:	03000593          	li	a1,48
    5326:	855a                	mv	a0,s6
    5328:	dadff0ef          	jal	50d4 <putc>
  putc(fd, 'x');
    532c:	07800593          	li	a1,120
    5330:	855a                	mv	a0,s6
    5332:	da3ff0ef          	jal	50d4 <putc>
    5336:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5338:	00003b97          	auipc	s7,0x3
    533c:	950b8b93          	addi	s7,s7,-1712 # 7c88 <digits>
    5340:	03c9d793          	srli	a5,s3,0x3c
    5344:	97de                	add	a5,a5,s7
    5346:	0007c583          	lbu	a1,0(a5)
    534a:	855a                	mv	a0,s6
    534c:	d89ff0ef          	jal	50d4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5350:	0992                	slli	s3,s3,0x4
    5352:	34fd                	addiw	s1,s1,-1
    5354:	f4f5                	bnez	s1,5340 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    5356:	8be6                	mv	s7,s9
      state = 0;
    5358:	4981                	li	s3,0
    535a:	6ca2                	ld	s9,8(sp)
    535c:	bda5                	j	51d4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    535e:	008b8493          	addi	s1,s7,8
    5362:	000bc583          	lbu	a1,0(s7)
    5366:	855a                	mv	a0,s6
    5368:	d6dff0ef          	jal	50d4 <putc>
    536c:	8ba6                	mv	s7,s1
      state = 0;
    536e:	4981                	li	s3,0
    5370:	b595                	j	51d4 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5372:	008b8993          	addi	s3,s7,8
    5376:	000bb483          	ld	s1,0(s7)
    537a:	cc91                	beqz	s1,5396 <vprintf+0x206>
        for (; *s; s++)
    537c:	0004c583          	lbu	a1,0(s1)
    5380:	c985                	beqz	a1,53b0 <vprintf+0x220>
          putc(fd, *s);
    5382:	855a                	mv	a0,s6
    5384:	d51ff0ef          	jal	50d4 <putc>
        for (; *s; s++)
    5388:	0485                	addi	s1,s1,1
    538a:	0004c583          	lbu	a1,0(s1)
    538e:	f9f5                	bnez	a1,5382 <vprintf+0x1f2>
        if ((s = va_arg(ap, char *)) == 0)
    5390:	8bce                	mv	s7,s3
      state = 0;
    5392:	4981                	li	s3,0
    5394:	b581                	j	51d4 <vprintf+0x44>
          s = "(null)";
    5396:	00003497          	auipc	s1,0x3
    539a:	84248493          	addi	s1,s1,-1982 # 7bd8 <malloc+0x26a6>
        for (; *s; s++)
    539e:	02800593          	li	a1,40
    53a2:	b7c5                	j	5382 <vprintf+0x1f2>
        putc(fd, '%');
    53a4:	85be                	mv	a1,a5
    53a6:	855a                	mv	a0,s6
    53a8:	d2dff0ef          	jal	50d4 <putc>
      state = 0;
    53ac:	4981                	li	s3,0
    53ae:	b51d                	j	51d4 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    53b0:	8bce                	mv	s7,s3
      state = 0;
    53b2:	4981                	li	s3,0
    53b4:	b505                	j	51d4 <vprintf+0x44>
    53b6:	6906                	ld	s2,64(sp)
    53b8:	79e2                	ld	s3,56(sp)
    53ba:	7a42                	ld	s4,48(sp)
    53bc:	7aa2                	ld	s5,40(sp)
    53be:	7b02                	ld	s6,32(sp)
    53c0:	6be2                	ld	s7,24(sp)
    53c2:	6c42                	ld	s8,16(sp)
    }
  }
}
    53c4:	60e6                	ld	ra,88(sp)
    53c6:	6446                	ld	s0,80(sp)
    53c8:	64a6                	ld	s1,72(sp)
    53ca:	6125                	addi	sp,sp,96
    53cc:	8082                	ret
      if (c0 == 'd') {
    53ce:	06400713          	li	a4,100
    53d2:	e4e78fe3          	beq	a5,a4,5230 <vprintf+0xa0>
      } else if (c0 == 'l' && c1 == 'd') {
    53d6:	f9478693          	addi	a3,a5,-108
    53da:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    53de:	85b2                	mv	a1,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    53e0:	4701                	li	a4,0
      } else if (c0 == 'u') {
    53e2:	07500513          	li	a0,117
    53e6:	e8a78ce3          	beq	a5,a0,527e <vprintf+0xee>
      } else if (c0 == 'l' && c1 == 'u') {
    53ea:	f8b60513          	addi	a0,a2,-117
    53ee:	e119                	bnez	a0,53f4 <vprintf+0x264>
    53f0:	ea0693e3          	bnez	a3,5296 <vprintf+0x106>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    53f4:	f8b58513          	addi	a0,a1,-117
    53f8:	e119                	bnez	a0,53fe <vprintf+0x26e>
    53fa:	ea071be3          	bnez	a4,52b0 <vprintf+0x120>
      } else if (c0 == 'x') {
    53fe:	07800513          	li	a0,120
    5402:	eca784e3          	beq	a5,a0,52ca <vprintf+0x13a>
      } else if (c0 == 'l' && c1 == 'x') {
    5406:	f8860613          	addi	a2,a2,-120
    540a:	e219                	bnez	a2,5410 <vprintf+0x280>
    540c:	ec069be3          	bnez	a3,52e2 <vprintf+0x152>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5410:	f8858593          	addi	a1,a1,-120
    5414:	e199                	bnez	a1,541a <vprintf+0x28a>
    5416:	ee0713e3          	bnez	a4,52fc <vprintf+0x16c>
      } else if (c0 == 'p') {
    541a:	07000713          	li	a4,112
    541e:	eee78ce3          	beq	a5,a4,5316 <vprintf+0x186>
      } else if (c0 == 'c') {
    5422:	06300713          	li	a4,99
    5426:	f2e78ce3          	beq	a5,a4,535e <vprintf+0x1ce>
      } else if (c0 == 's') {
    542a:	07300713          	li	a4,115
    542e:	f4e782e3          	beq	a5,a4,5372 <vprintf+0x1e2>
      } else if (c0 == '%') {
    5432:	02500713          	li	a4,37
    5436:	f6e787e3          	beq	a5,a4,53a4 <vprintf+0x214>
        putc(fd, '%');
    543a:	02500593          	li	a1,37
    543e:	855a                	mv	a0,s6
    5440:	c95ff0ef          	jal	50d4 <putc>
        putc(fd, c0);
    5444:	85a6                	mv	a1,s1
    5446:	855a                	mv	a0,s6
    5448:	c8dff0ef          	jal	50d4 <putc>
      state = 0;
    544c:	4981                	li	s3,0
    544e:	b359                	j	51d4 <vprintf+0x44>

0000000000005450 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5450:	715d                	addi	sp,sp,-80
    5452:	ec06                	sd	ra,24(sp)
    5454:	e822                	sd	s0,16(sp)
    5456:	1000                	addi	s0,sp,32
    5458:	e010                	sd	a2,0(s0)
    545a:	e414                	sd	a3,8(s0)
    545c:	e818                	sd	a4,16(s0)
    545e:	ec1c                	sd	a5,24(s0)
    5460:	03043023          	sd	a6,32(s0)
    5464:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5468:	8622                	mv	a2,s0
    546a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    546e:	d23ff0ef          	jal	5190 <vprintf>
}
    5472:	60e2                	ld	ra,24(sp)
    5474:	6442                	ld	s0,16(sp)
    5476:	6161                	addi	sp,sp,80
    5478:	8082                	ret

000000000000547a <printf>:

void
printf(const char *fmt, ...)
{
    547a:	711d                	addi	sp,sp,-96
    547c:	ec06                	sd	ra,24(sp)
    547e:	e822                	sd	s0,16(sp)
    5480:	1000                	addi	s0,sp,32
    5482:	e40c                	sd	a1,8(s0)
    5484:	e810                	sd	a2,16(s0)
    5486:	ec14                	sd	a3,24(s0)
    5488:	f018                	sd	a4,32(s0)
    548a:	f41c                	sd	a5,40(s0)
    548c:	03043823          	sd	a6,48(s0)
    5490:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5494:	00840613          	addi	a2,s0,8
    5498:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    549c:	85aa                	mv	a1,a0
    549e:	4505                	li	a0,1
    54a0:	cf1ff0ef          	jal	5190 <vprintf>
}
    54a4:	60e2                	ld	ra,24(sp)
    54a6:	6442                	ld	s0,16(sp)
    54a8:	6125                	addi	sp,sp,96
    54aa:	8082                	ret

00000000000054ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    54ac:	1141                	addi	sp,sp,-16
    54ae:	e406                	sd	ra,8(sp)
    54b0:	e022                	sd	s0,0(sp)
    54b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    54b4:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    54b8:	00003797          	auipc	a5,0x3
    54bc:	fd87b783          	ld	a5,-40(a5) # 8490 <freep>
    54c0:	a039                	j	54ce <free+0x22>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    54c2:	6398                	ld	a4,0(a5)
    54c4:	00e7e463          	bltu	a5,a4,54cc <free+0x20>
    54c8:	00e6ea63          	bltu	a3,a4,54dc <free+0x30>
{
    54cc:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    54ce:	fed7fae3          	bgeu	a5,a3,54c2 <free+0x16>
    54d2:	6398                	ld	a4,0(a5)
    54d4:	00e6e463          	bltu	a3,a4,54dc <free+0x30>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    54d8:	fee7eae3          	bltu	a5,a4,54cc <free+0x20>
      break;
  if (bp + bp->s.size == p->s.ptr) {
    54dc:	ff852583          	lw	a1,-8(a0)
    54e0:	6390                	ld	a2,0(a5)
    54e2:	02059813          	slli	a6,a1,0x20
    54e6:	01c85713          	srli	a4,a6,0x1c
    54ea:	9736                	add	a4,a4,a3
    54ec:	02e60563          	beq	a2,a4,5516 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    54f0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    54f4:	4790                	lw	a2,8(a5)
    54f6:	02061593          	slli	a1,a2,0x20
    54fa:	01c5d713          	srli	a4,a1,0x1c
    54fe:	973e                	add	a4,a4,a5
    5500:	02e68263          	beq	a3,a4,5524 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    5504:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5506:	00003717          	auipc	a4,0x3
    550a:	f8f73523          	sd	a5,-118(a4) # 8490 <freep>
}
    550e:	60a2                	ld	ra,8(sp)
    5510:	6402                	ld	s0,0(sp)
    5512:	0141                	addi	sp,sp,16
    5514:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5516:	4618                	lw	a4,8(a2)
    5518:	9f2d                	addw	a4,a4,a1
    551a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    551e:	6398                	ld	a4,0(a5)
    5520:	6310                	ld	a2,0(a4)
    5522:	b7f9                	j	54f0 <free+0x44>
    p->s.size += bp->s.size;
    5524:	ff852703          	lw	a4,-8(a0)
    5528:	9f31                	addw	a4,a4,a2
    552a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    552c:	ff053683          	ld	a3,-16(a0)
    5530:	bfd1                	j	5504 <free+0x58>

0000000000005532 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5532:	7139                	addi	sp,sp,-64
    5534:	fc06                	sd	ra,56(sp)
    5536:	f822                	sd	s0,48(sp)
    5538:	f04a                	sd	s2,32(sp)
    553a:	ec4e                	sd	s3,24(sp)
    553c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    553e:	02051993          	slli	s3,a0,0x20
    5542:	0209d993          	srli	s3,s3,0x20
    5546:	09bd                	addi	s3,s3,15
    5548:	0049d993          	srli	s3,s3,0x4
    554c:	2985                	addiw	s3,s3,1
    554e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    5550:	00003517          	auipc	a0,0x3
    5554:	f4053503          	ld	a0,-192(a0) # 8490 <freep>
    5558:	c905                	beqz	a0,5588 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    555a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    555c:	4798                	lw	a4,8(a5)
    555e:	09377663          	bgeu	a4,s3,55ea <malloc+0xb8>
    5562:	f426                	sd	s1,40(sp)
    5564:	e852                	sd	s4,16(sp)
    5566:	e456                	sd	s5,8(sp)
    5568:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    556a:	8a4e                	mv	s4,s3
    556c:	6705                	lui	a4,0x1
    556e:	00e9f363          	bgeu	s3,a4,5574 <malloc+0x42>
    5572:	6a05                	lui	s4,0x1
    5574:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5578:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    557c:	00003497          	auipc	s1,0x3
    5580:	f1448493          	addi	s1,s1,-236 # 8490 <freep>
  if (p == SBRK_ERROR)
    5584:	5afd                	li	s5,-1
    5586:	a83d                	j	55c4 <malloc+0x92>
    5588:	f426                	sd	s1,40(sp)
    558a:	e852                	sd	s4,16(sp)
    558c:	e456                	sd	s5,8(sp)
    558e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5590:	00009797          	auipc	a5,0x9
    5594:	72878793          	addi	a5,a5,1832 # ecb8 <base>
    5598:	00003717          	auipc	a4,0x3
    559c:	eef73c23          	sd	a5,-264(a4) # 8490 <freep>
    55a0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    55a2:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    55a6:	b7d1                	j	556a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    55a8:	6398                	ld	a4,0(a5)
    55aa:	e118                	sd	a4,0(a0)
    55ac:	a899                	j	5602 <malloc+0xd0>
  hp->s.size = nu;
    55ae:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    55b2:	0541                	addi	a0,a0,16
    55b4:	ef9ff0ef          	jal	54ac <free>
  return freep;
    55b8:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    55ba:	c125                	beqz	a0,561a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    55bc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    55be:	4798                	lw	a4,8(a5)
    55c0:	03277163          	bgeu	a4,s2,55e2 <malloc+0xb0>
    if (p == freep)
    55c4:	6098                	ld	a4,0(s1)
    55c6:	853e                	mv	a0,a5
    55c8:	fef71ae3          	bne	a4,a5,55bc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    55cc:	8552                	mv	a0,s4
    55ce:	a23ff0ef          	jal	4ff0 <sbrk>
  if (p == SBRK_ERROR)
    55d2:	fd551ee3          	bne	a0,s5,55ae <malloc+0x7c>
        return 0;
    55d6:	4501                	li	a0,0
    55d8:	74a2                	ld	s1,40(sp)
    55da:	6a42                	ld	s4,16(sp)
    55dc:	6aa2                	ld	s5,8(sp)
    55de:	6b02                	ld	s6,0(sp)
    55e0:	a03d                	j	560e <malloc+0xdc>
    55e2:	74a2                	ld	s1,40(sp)
    55e4:	6a42                	ld	s4,16(sp)
    55e6:	6aa2                	ld	s5,8(sp)
    55e8:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    55ea:	fae90fe3          	beq	s2,a4,55a8 <malloc+0x76>
        p->s.size -= nunits;
    55ee:	4137073b          	subw	a4,a4,s3
    55f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    55f4:	02071693          	slli	a3,a4,0x20
    55f8:	01c6d713          	srli	a4,a3,0x1c
    55fc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    55fe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5602:	00003717          	auipc	a4,0x3
    5606:	e8a73723          	sd	a0,-370(a4) # 8490 <freep>
      return (void *)(p + 1);
    560a:	01078513          	addi	a0,a5,16
  }
}
    560e:	70e2                	ld	ra,56(sp)
    5610:	7442                	ld	s0,48(sp)
    5612:	7902                	ld	s2,32(sp)
    5614:	69e2                	ld	s3,24(sp)
    5616:	6121                	addi	sp,sp,64
    5618:	8082                	ret
    561a:	74a2                	ld	s1,40(sp)
    561c:	6a42                	ld	s4,16(sp)
    561e:	6aa2                	ld	s5,8(sp)
    5620:	6b02                	ld	s6,0(sp)
    5622:	b7f5                	j	560e <malloc+0xdc>
