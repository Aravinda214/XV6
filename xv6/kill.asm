
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 1){
  14:	83 3b 00             	cmpl   $0x0,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 54 08 00 00       	push   $0x854
  21:	6a 02                	push   $0x2
  23:	e8 75 04 00 00       	call   49d <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 c9 02 00 00       	call   2f9 <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 ca 02 00 00       	call   329 <kill>
  5f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
  exit();
  6d:	e8 87 02 00 00       	call   2f9 <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  a8:	8d 42 01             	lea    0x1(%edx),%eax
  ab:	89 45 0c             	mov    %eax,0xc(%ebp)
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 48 01             	lea    0x1(%eax),%ecx
  b4:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c8             	movzbl %al,%ecx
 101:	89 d0                	mov    %edx,%eax
 103:	29 c8                	sub    %ecx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	push   0xc(%ebp)
 138:	ff 75 08             	push   0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 77 01 00 00       	call   311 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d5:	7f b3                	jg     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
      break;
 1d9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	push   0x8(%ebp)
 1f8:	e8 3c 01 00 00       	call   339 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	push   0xc(%ebp)
 216:	ff 75 f4             	push   -0xc(%ebp)
 219:	e8 33 01 00 00       	call   351 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	push   -0xc(%ebp)
 22a:	e8 f2 00 00 00       	call   321 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29b:	8d 42 01             	lea    0x1(%edx),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a4:	8d 48 01             	lea    0x1(%eax),%ecx
 2a7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <restorer>:
 2c1:	83 c4 0c             	add    $0xc,%esp
 2c4:	5a                   	pop    %edx
 2c5:	59                   	pop    %ecx
 2c6:	58                   	pop    %eax
 2c7:	c3                   	ret    

000002c8 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 2c8:	55                   	push   %ebp
 2c9:	89 e5                	mov    %esp,%ebp
 2cb:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 2ce:	83 ec 0c             	sub    $0xc,%esp
 2d1:	68 c1 02 00 00       	push   $0x2c1
 2d6:	e8 ce 00 00 00       	call   3a9 <signal_restorer>
 2db:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 2de:	83 ec 08             	sub    $0x8,%esp
 2e1:	ff 75 0c             	push   0xc(%ebp)
 2e4:	ff 75 08             	push   0x8(%ebp)
 2e7:	e8 b5 00 00 00       	call   3a1 <signal_register>
 2ec:	83 c4 10             	add    $0x10,%esp
 2ef:	c9                   	leave  
 2f0:	c3                   	ret    

000002f1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f1:	b8 01 00 00 00       	mov    $0x1,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <exit>:
SYSCALL(exit)
 2f9:	b8 02 00 00 00       	mov    $0x2,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <wait>:
SYSCALL(wait)
 301:	b8 03 00 00 00       	mov    $0x3,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <pipe>:
SYSCALL(pipe)
 309:	b8 04 00 00 00       	mov    $0x4,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <read>:
SYSCALL(read)
 311:	b8 05 00 00 00       	mov    $0x5,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <write>:
SYSCALL(write)
 319:	b8 10 00 00 00       	mov    $0x10,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <close>:
SYSCALL(close)
 321:	b8 15 00 00 00       	mov    $0x15,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <kill>:
SYSCALL(kill)
 329:	b8 06 00 00 00       	mov    $0x6,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <exec>:
SYSCALL(exec)
 331:	b8 07 00 00 00       	mov    $0x7,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <open>:
SYSCALL(open)
 339:	b8 0f 00 00 00       	mov    $0xf,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <mknod>:
SYSCALL(mknod)
 341:	b8 11 00 00 00       	mov    $0x11,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <unlink>:
SYSCALL(unlink)
 349:	b8 12 00 00 00       	mov    $0x12,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <fstat>:
SYSCALL(fstat)
 351:	b8 08 00 00 00       	mov    $0x8,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <link>:
SYSCALL(link)
 359:	b8 13 00 00 00       	mov    $0x13,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <mkdir>:
SYSCALL(mkdir)
 361:	b8 14 00 00 00       	mov    $0x14,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <chdir>:
SYSCALL(chdir)
 369:	b8 09 00 00 00       	mov    $0x9,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <dup>:
SYSCALL(dup)
 371:	b8 0a 00 00 00       	mov    $0xa,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <getpid>:
SYSCALL(getpid)
 379:	b8 0b 00 00 00       	mov    $0xb,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <sbrk>:
SYSCALL(sbrk)
 381:	b8 0c 00 00 00       	mov    $0xc,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <sleep>:
SYSCALL(sleep)
 389:	b8 0d 00 00 00       	mov    $0xd,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <uptime>:
SYSCALL(uptime)
 391:	b8 0e 00 00 00       	mov    $0xe,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <halt>:
SYSCALL(halt)
 399:	b8 16 00 00 00       	mov    $0x16,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <signal_register>:
SYSCALL(signal_register)
 3a1:	b8 17 00 00 00       	mov    $0x17,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <signal_restorer>:
SYSCALL(signal_restorer)
 3a9:	b8 18 00 00 00       	mov    $0x18,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <mprotect>:
SYSCALL(mprotect)
 3b1:	b8 19 00 00 00       	mov    $0x19,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <cowfork>:
SYSCALL(cowfork)
 3b9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <dsbrk>:
SYSCALL(dsbrk)
 3c1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c9:	55                   	push   %ebp
 3ca:	89 e5                	mov    %esp,%ebp
 3cc:	83 ec 18             	sub    $0x18,%esp
 3cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3d5:	83 ec 04             	sub    $0x4,%esp
 3d8:	6a 01                	push   $0x1
 3da:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3dd:	50                   	push   %eax
 3de:	ff 75 08             	push   0x8(%ebp)
 3e1:	e8 33 ff ff ff       	call   319 <write>
 3e6:	83 c4 10             	add    $0x10,%esp
}
 3e9:	90                   	nop
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3fd:	74 17                	je     416 <printint+0x2a>
 3ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 403:	79 11                	jns    416 <printint+0x2a>
    neg = 1;
 405:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	f7 d8                	neg    %eax
 411:	89 45 ec             	mov    %eax,-0x14(%ebp)
 414:	eb 06                	jmp    41c <printint+0x30>
  } else {
    x = xx;
 416:	8b 45 0c             	mov    0xc(%ebp),%eax
 419:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 41c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 423:	8b 4d 10             	mov    0x10(%ebp),%ecx
 426:	8b 45 ec             	mov    -0x14(%ebp),%eax
 429:	ba 00 00 00 00       	mov    $0x0,%edx
 42e:	f7 f1                	div    %ecx
 430:	89 d1                	mov    %edx,%ecx
 432:	8b 45 f4             	mov    -0xc(%ebp),%eax
 435:	8d 50 01             	lea    0x1(%eax),%edx
 438:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43b:	0f b6 91 70 08 00 00 	movzbl 0x870(%ecx),%edx
 442:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 446:	8b 4d 10             	mov    0x10(%ebp),%ecx
 449:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44c:	ba 00 00 00 00       	mov    $0x0,%edx
 451:	f7 f1                	div    %ecx
 453:	89 45 ec             	mov    %eax,-0x14(%ebp)
 456:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45a:	75 c7                	jne    423 <printint+0x37>
  if(neg)
 45c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 460:	74 2d                	je     48f <printint+0xa3>
    buf[i++] = '-';
 462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 465:	8d 50 01             	lea    0x1(%eax),%edx
 468:	89 55 f4             	mov    %edx,-0xc(%ebp)
 46b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 470:	eb 1d                	jmp    48f <printint+0xa3>
    putc(fd, buf[i]);
 472:	8d 55 dc             	lea    -0x24(%ebp),%edx
 475:	8b 45 f4             	mov    -0xc(%ebp),%eax
 478:	01 d0                	add    %edx,%eax
 47a:	0f b6 00             	movzbl (%eax),%eax
 47d:	0f be c0             	movsbl %al,%eax
 480:	83 ec 08             	sub    $0x8,%esp
 483:	50                   	push   %eax
 484:	ff 75 08             	push   0x8(%ebp)
 487:	e8 3d ff ff ff       	call   3c9 <putc>
 48c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 48f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 497:	79 d9                	jns    472 <printint+0x86>
}
 499:	90                   	nop
 49a:	90                   	nop
 49b:	c9                   	leave  
 49c:	c3                   	ret    

0000049d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 49d:	55                   	push   %ebp
 49e:	89 e5                	mov    %esp,%ebp
 4a0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4aa:	8d 45 0c             	lea    0xc(%ebp),%eax
 4ad:	83 c0 04             	add    $0x4,%eax
 4b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ba:	e9 59 01 00 00       	jmp    618 <printf+0x17b>
    c = fmt[i] & 0xff;
 4bf:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c5:	01 d0                	add    %edx,%eax
 4c7:	0f b6 00             	movzbl (%eax),%eax
 4ca:	0f be c0             	movsbl %al,%eax
 4cd:	25 ff 00 00 00       	and    $0xff,%eax
 4d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d9:	75 2c                	jne    507 <printf+0x6a>
      if(c == '%'){
 4db:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4df:	75 0c                	jne    4ed <printf+0x50>
        state = '%';
 4e1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e8:	e9 27 01 00 00       	jmp    614 <printf+0x177>
      } else {
        putc(fd, c);
 4ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f0:	0f be c0             	movsbl %al,%eax
 4f3:	83 ec 08             	sub    $0x8,%esp
 4f6:	50                   	push   %eax
 4f7:	ff 75 08             	push   0x8(%ebp)
 4fa:	e8 ca fe ff ff       	call   3c9 <putc>
 4ff:	83 c4 10             	add    $0x10,%esp
 502:	e9 0d 01 00 00       	jmp    614 <printf+0x177>
      }
    } else if(state == '%'){
 507:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 50b:	0f 85 03 01 00 00    	jne    614 <printf+0x177>
      if(c == 'd'){
 511:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 515:	75 1e                	jne    535 <printf+0x98>
        printint(fd, *ap, 10, 1);
 517:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51a:	8b 00                	mov    (%eax),%eax
 51c:	6a 01                	push   $0x1
 51e:	6a 0a                	push   $0xa
 520:	50                   	push   %eax
 521:	ff 75 08             	push   0x8(%ebp)
 524:	e8 c3 fe ff ff       	call   3ec <printint>
 529:	83 c4 10             	add    $0x10,%esp
        ap++;
 52c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 530:	e9 d8 00 00 00       	jmp    60d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 535:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 539:	74 06                	je     541 <printf+0xa4>
 53b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 53f:	75 1e                	jne    55f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 541:	8b 45 e8             	mov    -0x18(%ebp),%eax
 544:	8b 00                	mov    (%eax),%eax
 546:	6a 00                	push   $0x0
 548:	6a 10                	push   $0x10
 54a:	50                   	push   %eax
 54b:	ff 75 08             	push   0x8(%ebp)
 54e:	e8 99 fe ff ff       	call   3ec <printint>
 553:	83 c4 10             	add    $0x10,%esp
        ap++;
 556:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55a:	e9 ae 00 00 00       	jmp    60d <printf+0x170>
      } else if(c == 's'){
 55f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 563:	75 43                	jne    5a8 <printf+0x10b>
        s = (char*)*ap;
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 56d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 575:	75 25                	jne    59c <printf+0xff>
          s = "(null)";
 577:	c7 45 f4 68 08 00 00 	movl   $0x868,-0xc(%ebp)
        while(*s != 0){
 57e:	eb 1c                	jmp    59c <printf+0xff>
          putc(fd, *s);
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	0f be c0             	movsbl %al,%eax
 589:	83 ec 08             	sub    $0x8,%esp
 58c:	50                   	push   %eax
 58d:	ff 75 08             	push   0x8(%ebp)
 590:	e8 34 fe ff ff       	call   3c9 <putc>
 595:	83 c4 10             	add    $0x10,%esp
          s++;
 598:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59f:	0f b6 00             	movzbl (%eax),%eax
 5a2:	84 c0                	test   %al,%al
 5a4:	75 da                	jne    580 <printf+0xe3>
 5a6:	eb 65                	jmp    60d <printf+0x170>
        }
      } else if(c == 'c'){
 5a8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ac:	75 1d                	jne    5cb <printf+0x12e>
        putc(fd, *ap);
 5ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	83 ec 08             	sub    $0x8,%esp
 5b9:	50                   	push   %eax
 5ba:	ff 75 08             	push   0x8(%ebp)
 5bd:	e8 07 fe ff ff       	call   3c9 <putc>
 5c2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c9:	eb 42                	jmp    60d <printf+0x170>
      } else if(c == '%'){
 5cb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5cf:	75 17                	jne    5e8 <printf+0x14b>
        putc(fd, c);
 5d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	83 ec 08             	sub    $0x8,%esp
 5da:	50                   	push   %eax
 5db:	ff 75 08             	push   0x8(%ebp)
 5de:	e8 e6 fd ff ff       	call   3c9 <putc>
 5e3:	83 c4 10             	add    $0x10,%esp
 5e6:	eb 25                	jmp    60d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e8:	83 ec 08             	sub    $0x8,%esp
 5eb:	6a 25                	push   $0x25
 5ed:	ff 75 08             	push   0x8(%ebp)
 5f0:	e8 d4 fd ff ff       	call   3c9 <putc>
 5f5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fb:	0f be c0             	movsbl %al,%eax
 5fe:	83 ec 08             	sub    $0x8,%esp
 601:	50                   	push   %eax
 602:	ff 75 08             	push   0x8(%ebp)
 605:	e8 bf fd ff ff       	call   3c9 <putc>
 60a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 60d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 614:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 618:	8b 55 0c             	mov    0xc(%ebp),%edx
 61b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61e:	01 d0                	add    %edx,%eax
 620:	0f b6 00             	movzbl (%eax),%eax
 623:	84 c0                	test   %al,%al
 625:	0f 85 94 fe ff ff    	jne    4bf <printf+0x22>
    }
  }
}
 62b:	90                   	nop
 62c:	90                   	nop
 62d:	c9                   	leave  
 62e:	c3                   	ret    

0000062f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	83 e8 08             	sub    $0x8,%eax
 63b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63e:	a1 8c 08 00 00       	mov    0x88c,%eax
 643:	89 45 fc             	mov    %eax,-0x4(%ebp)
 646:	eb 24                	jmp    66c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 650:	72 12                	jb     664 <free+0x35>
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 658:	77 24                	ja     67e <free+0x4f>
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 662:	72 1a                	jb     67e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 672:	76 d4                	jbe    648 <free+0x19>
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 67c:	73 ca                	jae    648 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	01 c2                	add    %eax,%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	39 c2                	cmp    %eax,%edx
 697:	75 24                	jne    6bd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 50 04             	mov    0x4(%eax),%edx
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	8b 40 04             	mov    0x4(%eax),%eax
 6a7:	01 c2                	add    %eax,%edx
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	8b 10                	mov    (%eax),%edx
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	89 10                	mov    %edx,(%eax)
 6bb:	eb 0a                	jmp    6c7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 10                	mov    (%eax),%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 40 04             	mov    0x4(%eax),%eax
 6cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	01 d0                	add    %edx,%eax
 6d9:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6dc:	75 20                	jne    6fe <free+0xcf>
    p->s.size += bp->s.size;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 50 04             	mov    0x4(%eax),%edx
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	8b 40 04             	mov    0x4(%eax),%eax
 6ea:	01 c2                	add    %eax,%edx
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 10                	mov    (%eax),%edx
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	89 10                	mov    %edx,(%eax)
 6fc:	eb 08                	jmp    706 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 55 f8             	mov    -0x8(%ebp),%edx
 704:	89 10                	mov    %edx,(%eax)
  freep = p;
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	a3 8c 08 00 00       	mov    %eax,0x88c
}
 70e:	90                   	nop
 70f:	c9                   	leave  
 710:	c3                   	ret    

00000711 <morecore>:

static Header*
morecore(uint nu)
{
 711:	55                   	push   %ebp
 712:	89 e5                	mov    %esp,%ebp
 714:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 717:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71e:	77 07                	ja     727 <morecore+0x16>
    nu = 4096;
 720:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	c1 e0 03             	shl    $0x3,%eax
 72d:	83 ec 0c             	sub    $0xc,%esp
 730:	50                   	push   %eax
 731:	e8 4b fc ff ff       	call   381 <sbrk>
 736:	83 c4 10             	add    $0x10,%esp
 739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 73c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 740:	75 07                	jne    749 <morecore+0x38>
    return 0;
 742:	b8 00 00 00 00       	mov    $0x0,%eax
 747:	eb 26                	jmp    76f <morecore+0x5e>
  hp = (Header*)p;
 749:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	8b 55 08             	mov    0x8(%ebp),%edx
 755:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 758:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75b:	83 c0 08             	add    $0x8,%eax
 75e:	83 ec 0c             	sub    $0xc,%esp
 761:	50                   	push   %eax
 762:	e8 c8 fe ff ff       	call   62f <free>
 767:	83 c4 10             	add    $0x10,%esp
  return freep;
 76a:	a1 8c 08 00 00       	mov    0x88c,%eax
}
 76f:	c9                   	leave  
 770:	c3                   	ret    

00000771 <malloc>:

void*
malloc(uint nbytes)
{
 771:	55                   	push   %ebp
 772:	89 e5                	mov    %esp,%ebp
 774:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	83 c0 07             	add    $0x7,%eax
 77d:	c1 e8 03             	shr    $0x3,%eax
 780:	83 c0 01             	add    $0x1,%eax
 783:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 786:	a1 8c 08 00 00       	mov    0x88c,%eax
 78b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 78e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 792:	75 23                	jne    7b7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 794:	c7 45 f0 84 08 00 00 	movl   $0x884,-0x10(%ebp)
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79e:	a3 8c 08 00 00       	mov    %eax,0x88c
 7a3:	a1 8c 08 00 00       	mov    0x88c,%eax
 7a8:	a3 84 08 00 00       	mov    %eax,0x884
    base.s.size = 0;
 7ad:	c7 05 88 08 00 00 00 	movl   $0x0,0x888
 7b4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8b 40 04             	mov    0x4(%eax),%eax
 7c5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7c8:	77 4d                	ja     817 <malloc+0xa6>
      if(p->s.size == nunits)
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7d3:	75 0c                	jne    7e1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 10                	mov    (%eax),%edx
 7da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dd:	89 10                	mov    %edx,(%eax)
 7df:	eb 26                	jmp    807 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 40 04             	mov    0x4(%eax),%eax
 7e7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ea:	89 c2                	mov    %eax,%edx
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 40 04             	mov    0x4(%eax),%eax
 7f8:	c1 e0 03             	shl    $0x3,%eax
 7fb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 807:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80a:	a3 8c 08 00 00       	mov    %eax,0x88c
      return (void*)(p + 1);
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	83 c0 08             	add    $0x8,%eax
 815:	eb 3b                	jmp    852 <malloc+0xe1>
    }
    if(p == freep)
 817:	a1 8c 08 00 00       	mov    0x88c,%eax
 81c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81f:	75 1e                	jne    83f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 821:	83 ec 0c             	sub    $0xc,%esp
 824:	ff 75 ec             	push   -0x14(%ebp)
 827:	e8 e5 fe ff ff       	call   711 <morecore>
 82c:	83 c4 10             	add    $0x10,%esp
 82f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 836:	75 07                	jne    83f <malloc+0xce>
        return 0;
 838:	b8 00 00 00 00       	mov    $0x0,%eax
 83d:	eb 13                	jmp    852 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	89 45 f0             	mov    %eax,-0x10(%ebp)
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 84d:	e9 6d ff ff ff       	jmp    7bf <malloc+0x4e>
  }
}
 852:	c9                   	leave  
 853:	c3                   	ret    
