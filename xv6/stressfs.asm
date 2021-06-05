
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 34 09 00 00       	push   $0x934
  30:	6a 01                	push   $0x1
  32:	e8 46 05 00 00       	call   57d <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 70 03 00 00       	call   3d1 <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	push   -0xc(%ebp)
  78:	68 47 09 00 00       	push   $0x947
  7d:	6a 01                	push   $0x1
  7f:	e8 f9 04 00 00       	call   57d <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 73 03 00 00       	call   419 <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	push   -0x10(%ebp)
  c7:	e8 2d 03 00 00       	call   3f9 <write>
  cc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	push   -0x10(%ebp)
  df:	e8 1d 03 00 00       	call   401 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 51 09 00 00       	push   $0x951
  ef:	6a 01                	push   $0x1
  f1:	e8 87 04 00 00       	call   57d <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 12 03 00 00       	call   419 <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	push   -0x10(%ebp)
 128:	e8 c4 02 00 00       	call   3f1 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	push   -0x10(%ebp)
 140:	e8 bc 02 00 00       	call   401 <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 94 02 00 00       	call   3e1 <wait>
  
  exit();
 14d:	e8 87 02 00 00       	call   3d9 <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 55 0c             	mov    0xc(%ebp),%edx
 188:	8d 42 01             	lea    0x1(%edx),%eax
 18b:	89 45 0c             	mov    %eax,0xc(%ebp)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	8d 48 01             	lea    0x1(%eax),%ecx
 194:	89 4d 08             	mov    %ecx,0x8(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c8             	movzbl %al,%ecx
 1e1:	89 d0                	mov    %edx,%eax
 1e3:	29 c8                	sub    %ecx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	push   0xc(%ebp)
 218:	ff 75 08             	push   0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 77 01 00 00       	call   3f1 <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 2b5:	7f b3                	jg     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
      break;
 2b9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	push   0x8(%ebp)
 2d8:	e8 3c 01 00 00       	call   419 <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	push   0xc(%ebp)
 2f6:	ff 75 f4             	push   -0xc(%ebp)
 2f9:	e8 33 01 00 00       	call   431 <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	push   -0xc(%ebp)
 30a:	e8 f2 00 00 00       	call   401 <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 324:	eb 25                	jmp    34b <atoi+0x34>
    n = n*10 + *s++ - '0';
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	89 d0                	mov    %edx,%eax
 32b:	c1 e0 02             	shl    $0x2,%eax
 32e:	01 d0                	add    %edx,%eax
 330:	01 c0                	add    %eax,%eax
 332:	89 c1                	mov    %eax,%ecx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8d 50 01             	lea    0x1(%eax),%edx
 33a:	89 55 08             	mov    %edx,0x8(%ebp)
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	0f be c0             	movsbl %al,%eax
 343:	01 c8                	add    %ecx,%eax
 345:	83 e8 30             	sub    $0x30,%eax
 348:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 2f                	cmp    $0x2f,%al
 353:	7e 0a                	jle    35f <atoi+0x48>
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	0f b6 00             	movzbl (%eax),%eax
 35b:	3c 39                	cmp    $0x39,%al
 35d:	7e c7                	jle    326 <atoi+0xf>
  return n;
 35f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 376:	eb 17                	jmp    38f <memmove+0x2b>
    *dst++ = *src++;
 378:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37b:	8d 42 01             	lea    0x1(%edx),%eax
 37e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 381:	8b 45 fc             	mov    -0x4(%ebp),%eax
 384:	8d 48 01             	lea    0x1(%eax),%ecx
 387:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 38a:	0f b6 12             	movzbl (%edx),%edx
 38d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 38f:	8b 45 10             	mov    0x10(%ebp),%eax
 392:	8d 50 ff             	lea    -0x1(%eax),%edx
 395:	89 55 10             	mov    %edx,0x10(%ebp)
 398:	85 c0                	test   %eax,%eax
 39a:	7f dc                	jg     378 <memmove+0x14>
  return vdst;
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <restorer>:
 3a1:	83 c4 0c             	add    $0xc,%esp
 3a4:	5a                   	pop    %edx
 3a5:	59                   	pop    %ecx
 3a6:	58                   	pop    %eax
 3a7:	c3                   	ret    

000003a8 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 3ae:	83 ec 0c             	sub    $0xc,%esp
 3b1:	68 a1 03 00 00       	push   $0x3a1
 3b6:	e8 ce 00 00 00       	call   489 <signal_restorer>
 3bb:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 3be:	83 ec 08             	sub    $0x8,%esp
 3c1:	ff 75 0c             	push   0xc(%ebp)
 3c4:	ff 75 08             	push   0x8(%ebp)
 3c7:	e8 b5 00 00 00       	call   481 <signal_register>
 3cc:	83 c4 10             	add    $0x10,%esp
 3cf:	c9                   	leave  
 3d0:	c3                   	ret    

000003d1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d1:	b8 01 00 00 00       	mov    $0x1,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <exit>:
SYSCALL(exit)
 3d9:	b8 02 00 00 00       	mov    $0x2,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <wait>:
SYSCALL(wait)
 3e1:	b8 03 00 00 00       	mov    $0x3,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <pipe>:
SYSCALL(pipe)
 3e9:	b8 04 00 00 00       	mov    $0x4,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <read>:
SYSCALL(read)
 3f1:	b8 05 00 00 00       	mov    $0x5,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <write>:
SYSCALL(write)
 3f9:	b8 10 00 00 00       	mov    $0x10,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <close>:
SYSCALL(close)
 401:	b8 15 00 00 00       	mov    $0x15,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <kill>:
SYSCALL(kill)
 409:	b8 06 00 00 00       	mov    $0x6,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <exec>:
SYSCALL(exec)
 411:	b8 07 00 00 00       	mov    $0x7,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <open>:
SYSCALL(open)
 419:	b8 0f 00 00 00       	mov    $0xf,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <mknod>:
SYSCALL(mknod)
 421:	b8 11 00 00 00       	mov    $0x11,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <unlink>:
SYSCALL(unlink)
 429:	b8 12 00 00 00       	mov    $0x12,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <fstat>:
SYSCALL(fstat)
 431:	b8 08 00 00 00       	mov    $0x8,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <link>:
SYSCALL(link)
 439:	b8 13 00 00 00       	mov    $0x13,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <mkdir>:
SYSCALL(mkdir)
 441:	b8 14 00 00 00       	mov    $0x14,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <chdir>:
SYSCALL(chdir)
 449:	b8 09 00 00 00       	mov    $0x9,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <dup>:
SYSCALL(dup)
 451:	b8 0a 00 00 00       	mov    $0xa,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <getpid>:
SYSCALL(getpid)
 459:	b8 0b 00 00 00       	mov    $0xb,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <sbrk>:
SYSCALL(sbrk)
 461:	b8 0c 00 00 00       	mov    $0xc,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <sleep>:
SYSCALL(sleep)
 469:	b8 0d 00 00 00       	mov    $0xd,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <uptime>:
SYSCALL(uptime)
 471:	b8 0e 00 00 00       	mov    $0xe,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <halt>:
SYSCALL(halt)
 479:	b8 16 00 00 00       	mov    $0x16,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <signal_register>:
SYSCALL(signal_register)
 481:	b8 17 00 00 00       	mov    $0x17,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <signal_restorer>:
SYSCALL(signal_restorer)
 489:	b8 18 00 00 00       	mov    $0x18,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <mprotect>:
SYSCALL(mprotect)
 491:	b8 19 00 00 00       	mov    $0x19,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <cowfork>:
SYSCALL(cowfork)
 499:	b8 1a 00 00 00       	mov    $0x1a,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <dsbrk>:
SYSCALL(dsbrk)
 4a1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a9:	55                   	push   %ebp
 4aa:	89 e5                	mov    %esp,%ebp
 4ac:	83 ec 18             	sub    $0x18,%esp
 4af:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b5:	83 ec 04             	sub    $0x4,%esp
 4b8:	6a 01                	push   $0x1
 4ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4bd:	50                   	push   %eax
 4be:	ff 75 08             	push   0x8(%ebp)
 4c1:	e8 33 ff ff ff       	call   3f9 <write>
 4c6:	83 c4 10             	add    $0x10,%esp
}
 4c9:	90                   	nop
 4ca:	c9                   	leave  
 4cb:	c3                   	ret    

000004cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4dd:	74 17                	je     4f6 <printint+0x2a>
 4df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e3:	79 11                	jns    4f6 <printint+0x2a>
    neg = 1;
 4e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ef:	f7 d8                	neg    %eax
 4f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f4:	eb 06                	jmp    4fc <printint+0x30>
  } else {
    x = xx;
 4f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 503:	8b 4d 10             	mov    0x10(%ebp),%ecx
 506:	8b 45 ec             	mov    -0x14(%ebp),%eax
 509:	ba 00 00 00 00       	mov    $0x0,%edx
 50e:	f7 f1                	div    %ecx
 510:	89 d1                	mov    %edx,%ecx
 512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 515:	8d 50 01             	lea    0x1(%eax),%edx
 518:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51b:	0f b6 91 60 09 00 00 	movzbl 0x960(%ecx),%edx
 522:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 526:	8b 4d 10             	mov    0x10(%ebp),%ecx
 529:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52c:	ba 00 00 00 00       	mov    $0x0,%edx
 531:	f7 f1                	div    %ecx
 533:	89 45 ec             	mov    %eax,-0x14(%ebp)
 536:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53a:	75 c7                	jne    503 <printint+0x37>
  if(neg)
 53c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 540:	74 2d                	je     56f <printint+0xa3>
    buf[i++] = '-';
 542:	8b 45 f4             	mov    -0xc(%ebp),%eax
 545:	8d 50 01             	lea    0x1(%eax),%edx
 548:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 550:	eb 1d                	jmp    56f <printint+0xa3>
    putc(fd, buf[i]);
 552:	8d 55 dc             	lea    -0x24(%ebp),%edx
 555:	8b 45 f4             	mov    -0xc(%ebp),%eax
 558:	01 d0                	add    %edx,%eax
 55a:	0f b6 00             	movzbl (%eax),%eax
 55d:	0f be c0             	movsbl %al,%eax
 560:	83 ec 08             	sub    $0x8,%esp
 563:	50                   	push   %eax
 564:	ff 75 08             	push   0x8(%ebp)
 567:	e8 3d ff ff ff       	call   4a9 <putc>
 56c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 56f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 573:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 577:	79 d9                	jns    552 <printint+0x86>
}
 579:	90                   	nop
 57a:	90                   	nop
 57b:	c9                   	leave  
 57c:	c3                   	ret    

0000057d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 57d:	55                   	push   %ebp
 57e:	89 e5                	mov    %esp,%ebp
 580:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 583:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58a:	8d 45 0c             	lea    0xc(%ebp),%eax
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 593:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59a:	e9 59 01 00 00       	jmp    6f8 <printf+0x17b>
    c = fmt[i] & 0xff;
 59f:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a5:	01 d0                	add    %edx,%eax
 5a7:	0f b6 00             	movzbl (%eax),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	25 ff 00 00 00       	and    $0xff,%eax
 5b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b9:	75 2c                	jne    5e7 <printf+0x6a>
      if(c == '%'){
 5bb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bf:	75 0c                	jne    5cd <printf+0x50>
        state = '%';
 5c1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c8:	e9 27 01 00 00       	jmp    6f4 <printf+0x177>
      } else {
        putc(fd, c);
 5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	83 ec 08             	sub    $0x8,%esp
 5d6:	50                   	push   %eax
 5d7:	ff 75 08             	push   0x8(%ebp)
 5da:	e8 ca fe ff ff       	call   4a9 <putc>
 5df:	83 c4 10             	add    $0x10,%esp
 5e2:	e9 0d 01 00 00       	jmp    6f4 <printf+0x177>
      }
    } else if(state == '%'){
 5e7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5eb:	0f 85 03 01 00 00    	jne    6f4 <printf+0x177>
      if(c == 'd'){
 5f1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f5:	75 1e                	jne    615 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	6a 01                	push   $0x1
 5fe:	6a 0a                	push   $0xa
 600:	50                   	push   %eax
 601:	ff 75 08             	push   0x8(%ebp)
 604:	e8 c3 fe ff ff       	call   4cc <printint>
 609:	83 c4 10             	add    $0x10,%esp
        ap++;
 60c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 610:	e9 d8 00 00 00       	jmp    6ed <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 615:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 619:	74 06                	je     621 <printf+0xa4>
 61b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 61f:	75 1e                	jne    63f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 621:	8b 45 e8             	mov    -0x18(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	6a 00                	push   $0x0
 628:	6a 10                	push   $0x10
 62a:	50                   	push   %eax
 62b:	ff 75 08             	push   0x8(%ebp)
 62e:	e8 99 fe ff ff       	call   4cc <printint>
 633:	83 c4 10             	add    $0x10,%esp
        ap++;
 636:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63a:	e9 ae 00 00 00       	jmp    6ed <printf+0x170>
      } else if(c == 's'){
 63f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 643:	75 43                	jne    688 <printf+0x10b>
        s = (char*)*ap;
 645:	8b 45 e8             	mov    -0x18(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 64d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 651:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 655:	75 25                	jne    67c <printf+0xff>
          s = "(null)";
 657:	c7 45 f4 57 09 00 00 	movl   $0x957,-0xc(%ebp)
        while(*s != 0){
 65e:	eb 1c                	jmp    67c <printf+0xff>
          putc(fd, *s);
 660:	8b 45 f4             	mov    -0xc(%ebp),%eax
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	83 ec 08             	sub    $0x8,%esp
 66c:	50                   	push   %eax
 66d:	ff 75 08             	push   0x8(%ebp)
 670:	e8 34 fe ff ff       	call   4a9 <putc>
 675:	83 c4 10             	add    $0x10,%esp
          s++;
 678:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 67c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67f:	0f b6 00             	movzbl (%eax),%eax
 682:	84 c0                	test   %al,%al
 684:	75 da                	jne    660 <printf+0xe3>
 686:	eb 65                	jmp    6ed <printf+0x170>
        }
      } else if(c == 'c'){
 688:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 68c:	75 1d                	jne    6ab <printf+0x12e>
        putc(fd, *ap);
 68e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	0f be c0             	movsbl %al,%eax
 696:	83 ec 08             	sub    $0x8,%esp
 699:	50                   	push   %eax
 69a:	ff 75 08             	push   0x8(%ebp)
 69d:	e8 07 fe ff ff       	call   4a9 <putc>
 6a2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a9:	eb 42                	jmp    6ed <printf+0x170>
      } else if(c == '%'){
 6ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6af:	75 17                	jne    6c8 <printf+0x14b>
        putc(fd, c);
 6b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b4:	0f be c0             	movsbl %al,%eax
 6b7:	83 ec 08             	sub    $0x8,%esp
 6ba:	50                   	push   %eax
 6bb:	ff 75 08             	push   0x8(%ebp)
 6be:	e8 e6 fd ff ff       	call   4a9 <putc>
 6c3:	83 c4 10             	add    $0x10,%esp
 6c6:	eb 25                	jmp    6ed <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c8:	83 ec 08             	sub    $0x8,%esp
 6cb:	6a 25                	push   $0x25
 6cd:	ff 75 08             	push   0x8(%ebp)
 6d0:	e8 d4 fd ff ff       	call   4a9 <putc>
 6d5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6db:	0f be c0             	movsbl %al,%eax
 6de:	83 ec 08             	sub    $0x8,%esp
 6e1:	50                   	push   %eax
 6e2:	ff 75 08             	push   0x8(%ebp)
 6e5:	e8 bf fd ff ff       	call   4a9 <putc>
 6ea:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6f4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fe:	01 d0                	add    %edx,%eax
 700:	0f b6 00             	movzbl (%eax),%eax
 703:	84 c0                	test   %al,%al
 705:	0f 85 94 fe ff ff    	jne    59f <printf+0x22>
    }
  }
}
 70b:	90                   	nop
 70c:	90                   	nop
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	83 e8 08             	sub    $0x8,%eax
 71b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	a1 7c 09 00 00       	mov    0x97c,%eax
 723:	89 45 fc             	mov    %eax,-0x4(%ebp)
 726:	eb 24                	jmp    74c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 730:	72 12                	jb     744 <free+0x35>
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 738:	77 24                	ja     75e <free+0x4f>
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 742:	72 1a                	jb     75e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 752:	76 d4                	jbe    728 <free+0x19>
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 75c:	73 ca                	jae    728 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 40 04             	mov    0x4(%eax),%eax
 764:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	01 c2                	add    %eax,%edx
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	39 c2                	cmp    %eax,%edx
 777:	75 24                	jne    79d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	8b 50 04             	mov    0x4(%eax),%edx
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 00                	mov    (%eax),%eax
 794:	8b 10                	mov    (%eax),%edx
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	89 10                	mov    %edx,(%eax)
 79b:	eb 0a                	jmp    7a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 10                	mov    (%eax),%edx
 7a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	01 d0                	add    %edx,%eax
 7b9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7bc:	75 20                	jne    7de <free+0xcf>
    p->s.size += bp->s.size;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 50 04             	mov    0x4(%eax),%edx
 7c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	01 c2                	add    %eax,%edx
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	89 10                	mov    %edx,(%eax)
 7dc:	eb 08                	jmp    7e6 <free+0xd7>
  } else
    p->s.ptr = bp;
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	a3 7c 09 00 00       	mov    %eax,0x97c
}
 7ee:	90                   	nop
 7ef:	c9                   	leave  
 7f0:	c3                   	ret    

000007f1 <morecore>:

static Header*
morecore(uint nu)
{
 7f1:	55                   	push   %ebp
 7f2:	89 e5                	mov    %esp,%ebp
 7f4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7fe:	77 07                	ja     807 <morecore+0x16>
    nu = 4096;
 800:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	c1 e0 03             	shl    $0x3,%eax
 80d:	83 ec 0c             	sub    $0xc,%esp
 810:	50                   	push   %eax
 811:	e8 4b fc ff ff       	call   461 <sbrk>
 816:	83 c4 10             	add    $0x10,%esp
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 81c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 820:	75 07                	jne    829 <morecore+0x38>
    return 0;
 822:	b8 00 00 00 00       	mov    $0x0,%eax
 827:	eb 26                	jmp    84f <morecore+0x5e>
  hp = (Header*)p;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 82f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 832:	8b 55 08             	mov    0x8(%ebp),%edx
 835:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	83 c0 08             	add    $0x8,%eax
 83e:	83 ec 0c             	sub    $0xc,%esp
 841:	50                   	push   %eax
 842:	e8 c8 fe ff ff       	call   70f <free>
 847:	83 c4 10             	add    $0x10,%esp
  return freep;
 84a:	a1 7c 09 00 00       	mov    0x97c,%eax
}
 84f:	c9                   	leave  
 850:	c3                   	ret    

00000851 <malloc>:

void*
malloc(uint nbytes)
{
 851:	55                   	push   %ebp
 852:	89 e5                	mov    %esp,%ebp
 854:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 857:	8b 45 08             	mov    0x8(%ebp),%eax
 85a:	83 c0 07             	add    $0x7,%eax
 85d:	c1 e8 03             	shr    $0x3,%eax
 860:	83 c0 01             	add    $0x1,%eax
 863:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 866:	a1 7c 09 00 00       	mov    0x97c,%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 872:	75 23                	jne    897 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 874:	c7 45 f0 74 09 00 00 	movl   $0x974,-0x10(%ebp)
 87b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87e:	a3 7c 09 00 00       	mov    %eax,0x97c
 883:	a1 7c 09 00 00       	mov    0x97c,%eax
 888:	a3 74 09 00 00       	mov    %eax,0x974
    base.s.size = 0;
 88d:	c7 05 78 09 00 00 00 	movl   $0x0,0x978
 894:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 897:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	8b 40 04             	mov    0x4(%eax),%eax
 8a5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8a8:	77 4d                	ja     8f7 <malloc+0xa6>
      if(p->s.size == nunits)
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 40 04             	mov    0x4(%eax),%eax
 8b0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8b3:	75 0c                	jne    8c1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 10                	mov    (%eax),%edx
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	89 10                	mov    %edx,(%eax)
 8bf:	eb 26                	jmp    8e7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c4:	8b 40 04             	mov    0x4(%eax),%eax
 8c7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ca:	89 c2                	mov    %eax,%edx
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	8b 40 04             	mov    0x4(%eax),%eax
 8d8:	c1 e0 03             	shl    $0x3,%eax
 8db:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8e4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ea:	a3 7c 09 00 00       	mov    %eax,0x97c
      return (void*)(p + 1);
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	83 c0 08             	add    $0x8,%eax
 8f5:	eb 3b                	jmp    932 <malloc+0xe1>
    }
    if(p == freep)
 8f7:	a1 7c 09 00 00       	mov    0x97c,%eax
 8fc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ff:	75 1e                	jne    91f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 901:	83 ec 0c             	sub    $0xc,%esp
 904:	ff 75 ec             	push   -0x14(%ebp)
 907:	e8 e5 fe ff ff       	call   7f1 <morecore>
 90c:	83 c4 10             	add    $0x10,%esp
 90f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 916:	75 07                	jne    91f <malloc+0xce>
        return 0;
 918:	b8 00 00 00 00       	mov    $0x0,%eax
 91d:	eb 13                	jmp    932 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	89 45 f0             	mov    %eax,-0x10(%ebp)
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 92d:	e9 6d ff ff ff       	jmp    89f <malloc+0x4e>
  }
}
 932:	c9                   	leave  
 933:	c3                   	ret    
