
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 95 02 00 00       	call   2ab <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 1f 03 00 00       	call   343 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 87 02 00 00       	call   2b3 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  62:	8d 42 01             	lea    0x1(%edx),%eax
  65:	89 45 0c             	mov    %eax,0xc(%ebp)
  68:	8b 45 08             	mov    0x8(%ebp),%eax
  6b:	8d 48 01             	lea    0x1(%eax),%ecx
  6e:	89 4d 08             	mov    %ecx,0x8(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c8             	movzbl %al,%ecx
  bb:	89 d0                	mov    %edx,%eax
  bd:	29 c8                	sub    %ecx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	push   0xc(%ebp)
  f2:	ff 75 08             	push   0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	38 45 fc             	cmp    %al,-0x4(%ebp)
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 77 01 00 00       	call   2cb <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	39 45 0c             	cmp    %eax,0xc(%ebp)
 18f:	7f b3                	jg     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
      break;
 193:	90                   	nop
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	push   0x8(%ebp)
 1b2:	e8 3c 01 00 00       	call   2f3 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	push   0xc(%ebp)
 1d0:	ff 75 f4             	push   -0xc(%ebp)
 1d3:	e8 33 01 00 00       	call   30b <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	push   -0xc(%ebp)
 1e4:	e8 f2 00 00 00       	call   2db <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fe:	eb 25                	jmp    225 <atoi+0x34>
    n = n*10 + *s++ - '0';
 200:	8b 55 fc             	mov    -0x4(%ebp),%edx
 203:	89 d0                	mov    %edx,%eax
 205:	c1 e0 02             	shl    $0x2,%eax
 208:	01 d0                	add    %edx,%eax
 20a:	01 c0                	add    %eax,%eax
 20c:	89 c1                	mov    %eax,%ecx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8d 50 01             	lea    0x1(%eax),%edx
 214:	89 55 08             	mov    %edx,0x8(%ebp)
 217:	0f b6 00             	movzbl (%eax),%eax
 21a:	0f be c0             	movsbl %al,%eax
 21d:	01 c8                	add    %ecx,%eax
 21f:	83 e8 30             	sub    $0x30,%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 0a                	jle    239 <atoi+0x48>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	3c 39                	cmp    $0x39,%al
 237:	7e c7                	jle    200 <atoi+0xf>
  return n;
 239:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 250:	eb 17                	jmp    269 <memmove+0x2b>
    *dst++ = *src++;
 252:	8b 55 f8             	mov    -0x8(%ebp),%edx
 255:	8d 42 01             	lea    0x1(%edx),%eax
 258:	89 45 f8             	mov    %eax,-0x8(%ebp)
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25e:	8d 48 01             	lea    0x1(%eax),%ecx
 261:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 264:	0f b6 12             	movzbl (%edx),%edx
 267:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 269:	8b 45 10             	mov    0x10(%ebp),%eax
 26c:	8d 50 ff             	lea    -0x1(%eax),%edx
 26f:	89 55 10             	mov    %edx,0x10(%ebp)
 272:	85 c0                	test   %eax,%eax
 274:	7f dc                	jg     252 <memmove+0x14>
  return vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <restorer>:
 27b:	83 c4 0c             	add    $0xc,%esp
 27e:	5a                   	pop    %edx
 27f:	59                   	pop    %ecx
 280:	58                   	pop    %eax
 281:	c3                   	ret    

00000282 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 288:	83 ec 0c             	sub    $0xc,%esp
 28b:	68 7b 02 00 00       	push   $0x27b
 290:	e8 ce 00 00 00       	call   363 <signal_restorer>
 295:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 298:	83 ec 08             	sub    $0x8,%esp
 29b:	ff 75 0c             	push   0xc(%ebp)
 29e:	ff 75 08             	push   0x8(%ebp)
 2a1:	e8 b5 00 00 00       	call   35b <signal_register>
 2a6:	83 c4 10             	add    $0x10,%esp
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ab:	b8 01 00 00 00       	mov    $0x1,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <exit>:
SYSCALL(exit)
 2b3:	b8 02 00 00 00       	mov    $0x2,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <wait>:
SYSCALL(wait)
 2bb:	b8 03 00 00 00       	mov    $0x3,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <pipe>:
SYSCALL(pipe)
 2c3:	b8 04 00 00 00       	mov    $0x4,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <read>:
SYSCALL(read)
 2cb:	b8 05 00 00 00       	mov    $0x5,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <write>:
SYSCALL(write)
 2d3:	b8 10 00 00 00       	mov    $0x10,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <close>:
SYSCALL(close)
 2db:	b8 15 00 00 00       	mov    $0x15,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <kill>:
SYSCALL(kill)
 2e3:	b8 06 00 00 00       	mov    $0x6,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exec>:
SYSCALL(exec)
 2eb:	b8 07 00 00 00       	mov    $0x7,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <open>:
SYSCALL(open)
 2f3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mknod>:
SYSCALL(mknod)
 2fb:	b8 11 00 00 00       	mov    $0x11,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <unlink>:
SYSCALL(unlink)
 303:	b8 12 00 00 00       	mov    $0x12,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <fstat>:
SYSCALL(fstat)
 30b:	b8 08 00 00 00       	mov    $0x8,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <link>:
SYSCALL(link)
 313:	b8 13 00 00 00       	mov    $0x13,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mkdir>:
SYSCALL(mkdir)
 31b:	b8 14 00 00 00       	mov    $0x14,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <chdir>:
SYSCALL(chdir)
 323:	b8 09 00 00 00       	mov    $0x9,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <dup>:
SYSCALL(dup)
 32b:	b8 0a 00 00 00       	mov    $0xa,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <getpid>:
SYSCALL(getpid)
 333:	b8 0b 00 00 00       	mov    $0xb,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <sbrk>:
SYSCALL(sbrk)
 33b:	b8 0c 00 00 00       	mov    $0xc,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <sleep>:
SYSCALL(sleep)
 343:	b8 0d 00 00 00       	mov    $0xd,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <uptime>:
SYSCALL(uptime)
 34b:	b8 0e 00 00 00       	mov    $0xe,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <halt>:
SYSCALL(halt)
 353:	b8 16 00 00 00       	mov    $0x16,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <signal_register>:
SYSCALL(signal_register)
 35b:	b8 17 00 00 00       	mov    $0x17,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <signal_restorer>:
SYSCALL(signal_restorer)
 363:	b8 18 00 00 00       	mov    $0x18,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mprotect>:
SYSCALL(mprotect)
 36b:	b8 19 00 00 00       	mov    $0x19,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <cowfork>:
SYSCALL(cowfork)
 373:	b8 1a 00 00 00       	mov    $0x1a,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <dsbrk>:
SYSCALL(dsbrk)
 37b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 18             	sub    $0x18,%esp
 389:	8b 45 0c             	mov    0xc(%ebp),%eax
 38c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38f:	83 ec 04             	sub    $0x4,%esp
 392:	6a 01                	push   $0x1
 394:	8d 45 f4             	lea    -0xc(%ebp),%eax
 397:	50                   	push   %eax
 398:	ff 75 08             	push   0x8(%ebp)
 39b:	e8 33 ff ff ff       	call   2d3 <write>
 3a0:	83 c4 10             	add    $0x10,%esp
}
 3a3:	90                   	nop
 3a4:	c9                   	leave  
 3a5:	c3                   	ret    

000003a6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a6:	55                   	push   %ebp
 3a7:	89 e5                	mov    %esp,%ebp
 3a9:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b7:	74 17                	je     3d0 <printint+0x2a>
 3b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3bd:	79 11                	jns    3d0 <printint+0x2a>
    neg = 1;
 3bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	f7 d8                	neg    %eax
 3cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ce:	eb 06                	jmp    3d6 <printint+0x30>
  } else {
    x = xx;
 3d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e3:	ba 00 00 00 00       	mov    $0x0,%edx
 3e8:	f7 f1                	div    %ecx
 3ea:	89 d1                	mov    %edx,%ecx
 3ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ef:	8d 50 01             	lea    0x1(%eax),%edx
 3f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f5:	0f b6 91 18 08 00 00 	movzbl 0x818(%ecx),%edx
 3fc:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 400:	8b 4d 10             	mov    0x10(%ebp),%ecx
 403:	8b 45 ec             	mov    -0x14(%ebp),%eax
 406:	ba 00 00 00 00       	mov    $0x0,%edx
 40b:	f7 f1                	div    %ecx
 40d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 414:	75 c7                	jne    3dd <printint+0x37>
  if(neg)
 416:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41a:	74 2d                	je     449 <printint+0xa3>
    buf[i++] = '-';
 41c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41f:	8d 50 01             	lea    0x1(%eax),%edx
 422:	89 55 f4             	mov    %edx,-0xc(%ebp)
 425:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42a:	eb 1d                	jmp    449 <printint+0xa3>
    putc(fd, buf[i]);
 42c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 432:	01 d0                	add    %edx,%eax
 434:	0f b6 00             	movzbl (%eax),%eax
 437:	0f be c0             	movsbl %al,%eax
 43a:	83 ec 08             	sub    $0x8,%esp
 43d:	50                   	push   %eax
 43e:	ff 75 08             	push   0x8(%ebp)
 441:	e8 3d ff ff ff       	call   383 <putc>
 446:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 449:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 451:	79 d9                	jns    42c <printint+0x86>
}
 453:	90                   	nop
 454:	90                   	nop
 455:	c9                   	leave  
 456:	c3                   	ret    

00000457 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 464:	8d 45 0c             	lea    0xc(%ebp),%eax
 467:	83 c0 04             	add    $0x4,%eax
 46a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 474:	e9 59 01 00 00       	jmp    5d2 <printf+0x17b>
    c = fmt[i] & 0xff;
 479:	8b 55 0c             	mov    0xc(%ebp),%edx
 47c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47f:	01 d0                	add    %edx,%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	0f be c0             	movsbl %al,%eax
 487:	25 ff 00 00 00       	and    $0xff,%eax
 48c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 493:	75 2c                	jne    4c1 <printf+0x6a>
      if(c == '%'){
 495:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 499:	75 0c                	jne    4a7 <printf+0x50>
        state = '%';
 49b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a2:	e9 27 01 00 00       	jmp    5ce <printf+0x177>
      } else {
        putc(fd, c);
 4a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4aa:	0f be c0             	movsbl %al,%eax
 4ad:	83 ec 08             	sub    $0x8,%esp
 4b0:	50                   	push   %eax
 4b1:	ff 75 08             	push   0x8(%ebp)
 4b4:	e8 ca fe ff ff       	call   383 <putc>
 4b9:	83 c4 10             	add    $0x10,%esp
 4bc:	e9 0d 01 00 00       	jmp    5ce <printf+0x177>
      }
    } else if(state == '%'){
 4c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c5:	0f 85 03 01 00 00    	jne    5ce <printf+0x177>
      if(c == 'd'){
 4cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cf:	75 1e                	jne    4ef <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d4:	8b 00                	mov    (%eax),%eax
 4d6:	6a 01                	push   $0x1
 4d8:	6a 0a                	push   $0xa
 4da:	50                   	push   %eax
 4db:	ff 75 08             	push   0x8(%ebp)
 4de:	e8 c3 fe ff ff       	call   3a6 <printint>
 4e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ea:	e9 d8 00 00 00       	jmp    5c7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ef:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f3:	74 06                	je     4fb <printf+0xa4>
 4f5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f9:	75 1e                	jne    519 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	6a 00                	push   $0x0
 502:	6a 10                	push   $0x10
 504:	50                   	push   %eax
 505:	ff 75 08             	push   0x8(%ebp)
 508:	e8 99 fe ff ff       	call   3a6 <printint>
 50d:	83 c4 10             	add    $0x10,%esp
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 ae 00 00 00       	jmp    5c7 <printf+0x170>
      } else if(c == 's'){
 519:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51d:	75 43                	jne    562 <printf+0x10b>
        s = (char*)*ap;
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52f:	75 25                	jne    556 <printf+0xff>
          s = "(null)";
 531:	c7 45 f4 0e 08 00 00 	movl   $0x80e,-0xc(%ebp)
        while(*s != 0){
 538:	eb 1c                	jmp    556 <printf+0xff>
          putc(fd, *s);
 53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53d:	0f b6 00             	movzbl (%eax),%eax
 540:	0f be c0             	movsbl %al,%eax
 543:	83 ec 08             	sub    $0x8,%esp
 546:	50                   	push   %eax
 547:	ff 75 08             	push   0x8(%ebp)
 54a:	e8 34 fe ff ff       	call   383 <putc>
 54f:	83 c4 10             	add    $0x10,%esp
          s++;
 552:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	84 c0                	test   %al,%al
 55e:	75 da                	jne    53a <printf+0xe3>
 560:	eb 65                	jmp    5c7 <printf+0x170>
        }
      } else if(c == 'c'){
 562:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 566:	75 1d                	jne    585 <printf+0x12e>
        putc(fd, *ap);
 568:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56b:	8b 00                	mov    (%eax),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	83 ec 08             	sub    $0x8,%esp
 573:	50                   	push   %eax
 574:	ff 75 08             	push   0x8(%ebp)
 577:	e8 07 fe ff ff       	call   383 <putc>
 57c:	83 c4 10             	add    $0x10,%esp
        ap++;
 57f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 583:	eb 42                	jmp    5c7 <printf+0x170>
      } else if(c == '%'){
 585:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 589:	75 17                	jne    5a2 <printf+0x14b>
        putc(fd, c);
 58b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	83 ec 08             	sub    $0x8,%esp
 594:	50                   	push   %eax
 595:	ff 75 08             	push   0x8(%ebp)
 598:	e8 e6 fd ff ff       	call   383 <putc>
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	eb 25                	jmp    5c7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a2:	83 ec 08             	sub    $0x8,%esp
 5a5:	6a 25                	push   $0x25
 5a7:	ff 75 08             	push   0x8(%ebp)
 5aa:	e8 d4 fd ff ff       	call   383 <putc>
 5af:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	83 ec 08             	sub    $0x8,%esp
 5bb:	50                   	push   %eax
 5bc:	ff 75 08             	push   0x8(%ebp)
 5bf:	e8 bf fd ff ff       	call   383 <putc>
 5c4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d8:	01 d0                	add    %edx,%eax
 5da:	0f b6 00             	movzbl (%eax),%eax
 5dd:	84 c0                	test   %al,%al
 5df:	0f 85 94 fe ff ff    	jne    479 <printf+0x22>
    }
  }
}
 5e5:	90                   	nop
 5e6:	90                   	nop
 5e7:	c9                   	leave  
 5e8:	c3                   	ret    

000005e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	83 e8 08             	sub    $0x8,%eax
 5f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f8:	a1 34 08 00 00       	mov    0x834,%eax
 5fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 600:	eb 24                	jmp    626 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 60a:	72 12                	jb     61e <free+0x35>
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 612:	77 24                	ja     638 <free+0x4f>
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 61c:	72 1a                	jb     638 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	89 45 fc             	mov    %eax,-0x4(%ebp)
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62c:	76 d4                	jbe    602 <free+0x19>
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 636:	73 ca                	jae    602 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	8b 40 04             	mov    0x4(%eax),%eax
 63e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	01 c2                	add    %eax,%edx
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	39 c2                	cmp    %eax,%edx
 651:	75 24                	jne    677 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 50 04             	mov    0x4(%eax),%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	01 c2                	add    %eax,%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	8b 10                	mov    (%eax),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	89 10                	mov    %edx,(%eax)
 675:	eb 0a                	jmp    681 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	01 d0                	add    %edx,%eax
 693:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 696:	75 20                	jne    6b8 <free+0xcf>
    p->s.size += bp->s.size;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 50 04             	mov    0x4(%eax),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	89 10                	mov    %edx,(%eax)
 6b6:	eb 08                	jmp    6c0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6be:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	a3 34 08 00 00       	mov    %eax,0x834
}
 6c8:	90                   	nop
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    

000006cb <morecore>:

static Header*
morecore(uint nu)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d8:	77 07                	ja     6e1 <morecore+0x16>
    nu = 4096;
 6da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	c1 e0 03             	shl    $0x3,%eax
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	50                   	push   %eax
 6eb:	e8 4b fc ff ff       	call   33b <sbrk>
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fa:	75 07                	jne    703 <morecore+0x38>
    return 0;
 6fc:	b8 00 00 00 00       	mov    $0x0,%eax
 701:	eb 26                	jmp    729 <morecore+0x5e>
  hp = (Header*)p;
 703:	8b 45 f4             	mov    -0xc(%ebp),%eax
 706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	8b 55 08             	mov    0x8(%ebp),%edx
 70f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	83 c0 08             	add    $0x8,%eax
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	50                   	push   %eax
 71c:	e8 c8 fe ff ff       	call   5e9 <free>
 721:	83 c4 10             	add    $0x10,%esp
  return freep;
 724:	a1 34 08 00 00       	mov    0x834,%eax
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <malloc>:

void*
malloc(uint nbytes)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 c0 07             	add    $0x7,%eax
 737:	c1 e8 03             	shr    $0x3,%eax
 73a:	83 c0 01             	add    $0x1,%eax
 73d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 740:	a1 34 08 00 00       	mov    0x834,%eax
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
 748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74c:	75 23                	jne    771 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74e:	c7 45 f0 2c 08 00 00 	movl   $0x82c,-0x10(%ebp)
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	a3 34 08 00 00       	mov    %eax,0x834
 75d:	a1 34 08 00 00       	mov    0x834,%eax
 762:	a3 2c 08 00 00       	mov    %eax,0x82c
    base.s.size = 0;
 767:	c7 05 30 08 00 00 00 	movl   $0x0,0x830
 76e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 782:	77 4d                	ja     7d1 <malloc+0xa6>
      if(p->s.size == nunits)
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 78d:	75 0c                	jne    79b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 26                	jmp    7c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a4:	89 c2                	mov    %eax,%edx
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	a3 34 08 00 00       	mov    %eax,0x834
      return (void*)(p + 1);
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	eb 3b                	jmp    80c <malloc+0xe1>
    }
    if(p == freep)
 7d1:	a1 34 08 00 00       	mov    0x834,%eax
 7d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d9:	75 1e                	jne    7f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7db:	83 ec 0c             	sub    $0xc,%esp
 7de:	ff 75 ec             	push   -0x14(%ebp)
 7e1:	e8 e5 fe ff ff       	call   6cb <morecore>
 7e6:	83 c4 10             	add    $0x10,%esp
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 07                	jne    7f9 <malloc+0xce>
        return 0;
 7f2:	b8 00 00 00 00       	mov    $0x0,%eax
 7f7:	eb 13                	jmp    80c <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 807:	e9 6d ff ff ff       	jmp    779 <malloc+0x4e>
  }
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    
