
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 72 08 00 00       	push   $0x872
  21:	6a 02                	push   $0x2
  23:	e8 93 04 00 00       	call   4bb <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 e7 02 00 00       	call   317 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 14 03 00 00       	call   367 <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 86 08 00 00       	push   $0x886
  74:	6a 02                	push   $0x2
  76:	e8 40 04 00 00       	call   4bb <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
    }
  }

  exit();
  8b:	e8 87 02 00 00       	call   317 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	90                   	nop
  b2:	5b                   	pop    %ebx
  b3:	5f                   	pop    %edi
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c2:	90                   	nop
  c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  c6:	8d 42 01             	lea    0x1(%edx),%eax
  c9:	89 45 0c             	mov    %eax,0xc(%ebp)
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8d 48 01             	lea    0x1(%eax),%ecx
  d2:	89 4d 08             	mov    %ecx,0x8(%ebp)
  d5:	0f b6 12             	movzbl (%edx),%edx
  d8:	88 10                	mov    %dl,(%eax)
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 e2                	jne    c3 <strcpy+0xd>
    ;
  return os;
  e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e4:	c9                   	leave  
  e5:	c3                   	ret    

000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e9:	eb 08                	jmp    f3 <strcmp+0xd>
    p++, q++;
  eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	74 10                	je     10d <strcmp+0x27>
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	38 c2                	cmp    %al,%dl
 10b:	74 de                	je     eb <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 d0             	movzbl %al,%edx
 116:	8b 45 0c             	mov    0xc(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	0f b6 c8             	movzbl %al,%ecx
 11f:	89 d0                	mov    %edx,%eax
 121:	29 c8                	sub    %ecx,%eax
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <strlen>:

uint
strlen(char *s)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 132:	eb 04                	jmp    138 <strlen+0x13>
 134:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 138:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	01 d0                	add    %edx,%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 ed                	jne    134 <strlen+0xf>
    ;
  return n;
 147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14a:	c9                   	leave  
 14b:	c3                   	ret    

0000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14f:	8b 45 10             	mov    0x10(%ebp),%eax
 152:	50                   	push   %eax
 153:	ff 75 0c             	push   0xc(%ebp)
 156:	ff 75 08             	push   0x8(%ebp)
 159:	e8 32 ff ff ff       	call   90 <stosb>
 15e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 45 fc             	cmp    %al,-0x4(%ebp)
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x51>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 77 01 00 00       	call   32f <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x5e>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x5f>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1f3:	7f b3                	jg     1a8 <gets+0xf>
 1f5:	eb 01                	jmp    1f8 <gets+0x5f>
      break;
 1f7:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	6a 00                	push   $0x0
 213:	ff 75 08             	push   0x8(%ebp)
 216:	e8 3c 01 00 00       	call   357 <open>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x26>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 25                	jmp    253 <stat+0x4b>
  r = fstat(fd, st);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	ff 75 0c             	push   0xc(%ebp)
 234:	ff 75 f4             	push   -0xc(%ebp)
 237:	e8 33 01 00 00       	call   36f <fstat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	ff 75 f4             	push   -0xc(%ebp)
 248:	e8 f2 00 00 00       	call   33f <close>
 24d:	83 c4 10             	add    $0x10,%esp
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 262:	eb 25                	jmp    289 <atoi+0x34>
    n = n*10 + *s++ - '0';
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	89 d0                	mov    %edx,%eax
 269:	c1 e0 02             	shl    $0x2,%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	01 c0                	add    %eax,%eax
 270:	89 c1                	mov    %eax,%ecx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8d 50 01             	lea    0x1(%eax),%edx
 278:	89 55 08             	mov    %edx,0x8(%ebp)
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	0f be c0             	movsbl %al,%eax
 281:	01 c8                	add    %ecx,%eax
 283:	83 e8 30             	sub    $0x30,%eax
 286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	3c 2f                	cmp    $0x2f,%al
 291:	7e 0a                	jle    29d <atoi+0x48>
 293:	8b 45 08             	mov    0x8(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	3c 39                	cmp    $0x39,%al
 29b:	7e c7                	jle    264 <atoi+0xf>
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b4:	eb 17                	jmp    2cd <memmove+0x2b>
    *dst++ = *src++;
 2b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b9:	8d 42 01             	lea    0x1(%edx),%eax
 2bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c2:	8d 48 01             	lea    0x1(%eax),%ecx
 2c5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2c8:	0f b6 12             	movzbl (%edx),%edx
 2cb:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2cd:	8b 45 10             	mov    0x10(%ebp),%eax
 2d0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d3:	89 55 10             	mov    %edx,0x10(%ebp)
 2d6:	85 c0                	test   %eax,%eax
 2d8:	7f dc                	jg     2b6 <memmove+0x14>
  return vdst;
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <restorer>:
 2df:	83 c4 0c             	add    $0xc,%esp
 2e2:	5a                   	pop    %edx
 2e3:	59                   	pop    %ecx
 2e4:	58                   	pop    %eax
 2e5:	c3                   	ret    

000002e6 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 2ec:	83 ec 0c             	sub    $0xc,%esp
 2ef:	68 df 02 00 00       	push   $0x2df
 2f4:	e8 ce 00 00 00       	call   3c7 <signal_restorer>
 2f9:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 2fc:	83 ec 08             	sub    $0x8,%esp
 2ff:	ff 75 0c             	push   0xc(%ebp)
 302:	ff 75 08             	push   0x8(%ebp)
 305:	e8 b5 00 00 00       	call   3bf <signal_register>
 30a:	83 c4 10             	add    $0x10,%esp
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 30f:	b8 01 00 00 00       	mov    $0x1,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <exit>:
SYSCALL(exit)
 317:	b8 02 00 00 00       	mov    $0x2,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <wait>:
SYSCALL(wait)
 31f:	b8 03 00 00 00       	mov    $0x3,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <pipe>:
SYSCALL(pipe)
 327:	b8 04 00 00 00       	mov    $0x4,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <read>:
SYSCALL(read)
 32f:	b8 05 00 00 00       	mov    $0x5,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <write>:
SYSCALL(write)
 337:	b8 10 00 00 00       	mov    $0x10,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <close>:
SYSCALL(close)
 33f:	b8 15 00 00 00       	mov    $0x15,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <kill>:
SYSCALL(kill)
 347:	b8 06 00 00 00       	mov    $0x6,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <exec>:
SYSCALL(exec)
 34f:	b8 07 00 00 00       	mov    $0x7,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <open>:
SYSCALL(open)
 357:	b8 0f 00 00 00       	mov    $0xf,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <mknod>:
SYSCALL(mknod)
 35f:	b8 11 00 00 00       	mov    $0x11,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <unlink>:
SYSCALL(unlink)
 367:	b8 12 00 00 00       	mov    $0x12,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <fstat>:
SYSCALL(fstat)
 36f:	b8 08 00 00 00       	mov    $0x8,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <link>:
SYSCALL(link)
 377:	b8 13 00 00 00       	mov    $0x13,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <mkdir>:
SYSCALL(mkdir)
 37f:	b8 14 00 00 00       	mov    $0x14,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <chdir>:
SYSCALL(chdir)
 387:	b8 09 00 00 00       	mov    $0x9,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <dup>:
SYSCALL(dup)
 38f:	b8 0a 00 00 00       	mov    $0xa,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <getpid>:
SYSCALL(getpid)
 397:	b8 0b 00 00 00       	mov    $0xb,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <sbrk>:
SYSCALL(sbrk)
 39f:	b8 0c 00 00 00       	mov    $0xc,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <sleep>:
SYSCALL(sleep)
 3a7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <uptime>:
SYSCALL(uptime)
 3af:	b8 0e 00 00 00       	mov    $0xe,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <halt>:
SYSCALL(halt)
 3b7:	b8 16 00 00 00       	mov    $0x16,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <signal_register>:
SYSCALL(signal_register)
 3bf:	b8 17 00 00 00       	mov    $0x17,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <signal_restorer>:
SYSCALL(signal_restorer)
 3c7:	b8 18 00 00 00       	mov    $0x18,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <mprotect>:
SYSCALL(mprotect)
 3cf:	b8 19 00 00 00       	mov    $0x19,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <cowfork>:
SYSCALL(cowfork)
 3d7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <dsbrk>:
SYSCALL(dsbrk)
 3df:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
 3ea:	83 ec 18             	sub    $0x18,%esp
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3f3:	83 ec 04             	sub    $0x4,%esp
 3f6:	6a 01                	push   $0x1
 3f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3fb:	50                   	push   %eax
 3fc:	ff 75 08             	push   0x8(%ebp)
 3ff:	e8 33 ff ff ff       	call   337 <write>
 404:	83 c4 10             	add    $0x10,%esp
}
 407:	90                   	nop
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 410:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 417:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 41b:	74 17                	je     434 <printint+0x2a>
 41d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 421:	79 11                	jns    434 <printint+0x2a>
    neg = 1;
 423:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 42a:	8b 45 0c             	mov    0xc(%ebp),%eax
 42d:	f7 d8                	neg    %eax
 42f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 432:	eb 06                	jmp    43a <printint+0x30>
  } else {
    x = xx;
 434:	8b 45 0c             	mov    0xc(%ebp),%eax
 437:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 43a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 441:	8b 4d 10             	mov    0x10(%ebp),%ecx
 444:	8b 45 ec             	mov    -0x14(%ebp),%eax
 447:	ba 00 00 00 00       	mov    $0x0,%edx
 44c:	f7 f1                	div    %ecx
 44e:	89 d1                	mov    %edx,%ecx
 450:	8b 45 f4             	mov    -0xc(%ebp),%eax
 453:	8d 50 01             	lea    0x1(%eax),%edx
 456:	89 55 f4             	mov    %edx,-0xc(%ebp)
 459:	0f b6 91 a8 08 00 00 	movzbl 0x8a8(%ecx),%edx
 460:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 464:	8b 4d 10             	mov    0x10(%ebp),%ecx
 467:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46a:	ba 00 00 00 00       	mov    $0x0,%edx
 46f:	f7 f1                	div    %ecx
 471:	89 45 ec             	mov    %eax,-0x14(%ebp)
 474:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 478:	75 c7                	jne    441 <printint+0x37>
  if(neg)
 47a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47e:	74 2d                	je     4ad <printint+0xa3>
    buf[i++] = '-';
 480:	8b 45 f4             	mov    -0xc(%ebp),%eax
 483:	8d 50 01             	lea    0x1(%eax),%edx
 486:	89 55 f4             	mov    %edx,-0xc(%ebp)
 489:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 48e:	eb 1d                	jmp    4ad <printint+0xa3>
    putc(fd, buf[i]);
 490:	8d 55 dc             	lea    -0x24(%ebp),%edx
 493:	8b 45 f4             	mov    -0xc(%ebp),%eax
 496:	01 d0                	add    %edx,%eax
 498:	0f b6 00             	movzbl (%eax),%eax
 49b:	0f be c0             	movsbl %al,%eax
 49e:	83 ec 08             	sub    $0x8,%esp
 4a1:	50                   	push   %eax
 4a2:	ff 75 08             	push   0x8(%ebp)
 4a5:	e8 3d ff ff ff       	call   3e7 <putc>
 4aa:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b5:	79 d9                	jns    490 <printint+0x86>
}
 4b7:	90                   	nop
 4b8:	90                   	nop
 4b9:	c9                   	leave  
 4ba:	c3                   	ret    

000004bb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4c8:	8d 45 0c             	lea    0xc(%ebp),%eax
 4cb:	83 c0 04             	add    $0x4,%eax
 4ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4d8:	e9 59 01 00 00       	jmp    636 <printf+0x17b>
    c = fmt[i] & 0xff;
 4dd:	8b 55 0c             	mov    0xc(%ebp),%edx
 4e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4e3:	01 d0                	add    %edx,%eax
 4e5:	0f b6 00             	movzbl (%eax),%eax
 4e8:	0f be c0             	movsbl %al,%eax
 4eb:	25 ff 00 00 00       	and    $0xff,%eax
 4f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f7:	75 2c                	jne    525 <printf+0x6a>
      if(c == '%'){
 4f9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4fd:	75 0c                	jne    50b <printf+0x50>
        state = '%';
 4ff:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 506:	e9 27 01 00 00       	jmp    632 <printf+0x177>
      } else {
        putc(fd, c);
 50b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 50e:	0f be c0             	movsbl %al,%eax
 511:	83 ec 08             	sub    $0x8,%esp
 514:	50                   	push   %eax
 515:	ff 75 08             	push   0x8(%ebp)
 518:	e8 ca fe ff ff       	call   3e7 <putc>
 51d:	83 c4 10             	add    $0x10,%esp
 520:	e9 0d 01 00 00       	jmp    632 <printf+0x177>
      }
    } else if(state == '%'){
 525:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 529:	0f 85 03 01 00 00    	jne    632 <printf+0x177>
      if(c == 'd'){
 52f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 533:	75 1e                	jne    553 <printf+0x98>
        printint(fd, *ap, 10, 1);
 535:	8b 45 e8             	mov    -0x18(%ebp),%eax
 538:	8b 00                	mov    (%eax),%eax
 53a:	6a 01                	push   $0x1
 53c:	6a 0a                	push   $0xa
 53e:	50                   	push   %eax
 53f:	ff 75 08             	push   0x8(%ebp)
 542:	e8 c3 fe ff ff       	call   40a <printint>
 547:	83 c4 10             	add    $0x10,%esp
        ap++;
 54a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54e:	e9 d8 00 00 00       	jmp    62b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 553:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 557:	74 06                	je     55f <printf+0xa4>
 559:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55d:	75 1e                	jne    57d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 55f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 562:	8b 00                	mov    (%eax),%eax
 564:	6a 00                	push   $0x0
 566:	6a 10                	push   $0x10
 568:	50                   	push   %eax
 569:	ff 75 08             	push   0x8(%ebp)
 56c:	e8 99 fe ff ff       	call   40a <printint>
 571:	83 c4 10             	add    $0x10,%esp
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 578:	e9 ae 00 00 00       	jmp    62b <printf+0x170>
      } else if(c == 's'){
 57d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 581:	75 43                	jne    5c6 <printf+0x10b>
        s = (char*)*ap;
 583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 586:	8b 00                	mov    (%eax),%eax
 588:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 58b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 58f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 593:	75 25                	jne    5ba <printf+0xff>
          s = "(null)";
 595:	c7 45 f4 9f 08 00 00 	movl   $0x89f,-0xc(%ebp)
        while(*s != 0){
 59c:	eb 1c                	jmp    5ba <printf+0xff>
          putc(fd, *s);
 59e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a1:	0f b6 00             	movzbl (%eax),%eax
 5a4:	0f be c0             	movsbl %al,%eax
 5a7:	83 ec 08             	sub    $0x8,%esp
 5aa:	50                   	push   %eax
 5ab:	ff 75 08             	push   0x8(%ebp)
 5ae:	e8 34 fe ff ff       	call   3e7 <putc>
 5b3:	83 c4 10             	add    $0x10,%esp
          s++;
 5b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	84 c0                	test   %al,%al
 5c2:	75 da                	jne    59e <printf+0xe3>
 5c4:	eb 65                	jmp    62b <printf+0x170>
        }
      } else if(c == 'c'){
 5c6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ca:	75 1d                	jne    5e9 <printf+0x12e>
        putc(fd, *ap);
 5cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cf:	8b 00                	mov    (%eax),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	50                   	push   %eax
 5d8:	ff 75 08             	push   0x8(%ebp)
 5db:	e8 07 fe ff ff       	call   3e7 <putc>
 5e0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e7:	eb 42                	jmp    62b <printf+0x170>
      } else if(c == '%'){
 5e9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ed:	75 17                	jne    606 <printf+0x14b>
        putc(fd, c);
 5ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	83 ec 08             	sub    $0x8,%esp
 5f8:	50                   	push   %eax
 5f9:	ff 75 08             	push   0x8(%ebp)
 5fc:	e8 e6 fd ff ff       	call   3e7 <putc>
 601:	83 c4 10             	add    $0x10,%esp
 604:	eb 25                	jmp    62b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 606:	83 ec 08             	sub    $0x8,%esp
 609:	6a 25                	push   $0x25
 60b:	ff 75 08             	push   0x8(%ebp)
 60e:	e8 d4 fd ff ff       	call   3e7 <putc>
 613:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	0f be c0             	movsbl %al,%eax
 61c:	83 ec 08             	sub    $0x8,%esp
 61f:	50                   	push   %eax
 620:	ff 75 08             	push   0x8(%ebp)
 623:	e8 bf fd ff ff       	call   3e7 <putc>
 628:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 62b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 632:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 636:	8b 55 0c             	mov    0xc(%ebp),%edx
 639:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63c:	01 d0                	add    %edx,%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	84 c0                	test   %al,%al
 643:	0f 85 94 fe ff ff    	jne    4dd <printf+0x22>
    }
  }
}
 649:	90                   	nop
 64a:	90                   	nop
 64b:	c9                   	leave  
 64c:	c3                   	ret    

0000064d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64d:	55                   	push   %ebp
 64e:	89 e5                	mov    %esp,%ebp
 650:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 653:	8b 45 08             	mov    0x8(%ebp),%eax
 656:	83 e8 08             	sub    $0x8,%eax
 659:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65c:	a1 c4 08 00 00       	mov    0x8c4,%eax
 661:	89 45 fc             	mov    %eax,-0x4(%ebp)
 664:	eb 24                	jmp    68a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 66e:	72 12                	jb     682 <free+0x35>
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 676:	77 24                	ja     69c <free+0x4f>
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 680:	72 1a                	jb     69c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	89 45 fc             	mov    %eax,-0x4(%ebp)
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 690:	76 d4                	jbe    666 <free+0x19>
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69a:	73 ca                	jae    666 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	01 c2                	add    %eax,%edx
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	39 c2                	cmp    %eax,%edx
 6b5:	75 24                	jne    6db <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	8b 50 04             	mov    0x4(%eax),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 40 04             	mov    0x4(%eax),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	89 10                	mov    %edx,(%eax)
 6d9:	eb 0a                	jmp    6e5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 40 04             	mov    0x4(%eax),%eax
 6eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	01 d0                	add    %edx,%eax
 6f7:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6fa:	75 20                	jne    71c <free+0xcf>
    p->s.size += bp->s.size;
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 50 04             	mov    0x4(%eax),%edx
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 40 04             	mov    0x4(%eax),%eax
 708:	01 c2                	add    %eax,%edx
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	8b 10                	mov    (%eax),%edx
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	89 10                	mov    %edx,(%eax)
 71a:	eb 08                	jmp    724 <free+0xd7>
  } else
    p->s.ptr = bp;
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 722:	89 10                	mov    %edx,(%eax)
  freep = p;
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	a3 c4 08 00 00       	mov    %eax,0x8c4
}
 72c:	90                   	nop
 72d:	c9                   	leave  
 72e:	c3                   	ret    

0000072f <morecore>:

static Header*
morecore(uint nu)
{
 72f:	55                   	push   %ebp
 730:	89 e5                	mov    %esp,%ebp
 732:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 735:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 73c:	77 07                	ja     745 <morecore+0x16>
    nu = 4096;
 73e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	c1 e0 03             	shl    $0x3,%eax
 74b:	83 ec 0c             	sub    $0xc,%esp
 74e:	50                   	push   %eax
 74f:	e8 4b fc ff ff       	call   39f <sbrk>
 754:	83 c4 10             	add    $0x10,%esp
 757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 75a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 75e:	75 07                	jne    767 <morecore+0x38>
    return 0;
 760:	b8 00 00 00 00       	mov    $0x0,%eax
 765:	eb 26                	jmp    78d <morecore+0x5e>
  hp = (Header*)p;
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	8b 55 08             	mov    0x8(%ebp),%edx
 773:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 776:	8b 45 f0             	mov    -0x10(%ebp),%eax
 779:	83 c0 08             	add    $0x8,%eax
 77c:	83 ec 0c             	sub    $0xc,%esp
 77f:	50                   	push   %eax
 780:	e8 c8 fe ff ff       	call   64d <free>
 785:	83 c4 10             	add    $0x10,%esp
  return freep;
 788:	a1 c4 08 00 00       	mov    0x8c4,%eax
}
 78d:	c9                   	leave  
 78e:	c3                   	ret    

0000078f <malloc>:

void*
malloc(uint nbytes)
{
 78f:	55                   	push   %ebp
 790:	89 e5                	mov    %esp,%ebp
 792:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 795:	8b 45 08             	mov    0x8(%ebp),%eax
 798:	83 c0 07             	add    $0x7,%eax
 79b:	c1 e8 03             	shr    $0x3,%eax
 79e:	83 c0 01             	add    $0x1,%eax
 7a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a4:	a1 c4 08 00 00       	mov    0x8c4,%eax
 7a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b0:	75 23                	jne    7d5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7b2:	c7 45 f0 bc 08 00 00 	movl   $0x8bc,-0x10(%ebp)
 7b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bc:	a3 c4 08 00 00       	mov    %eax,0x8c4
 7c1:	a1 c4 08 00 00       	mov    0x8c4,%eax
 7c6:	a3 bc 08 00 00       	mov    %eax,0x8bc
    base.s.size = 0;
 7cb:	c7 05 c0 08 00 00 00 	movl   $0x0,0x8c0
 7d2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	8b 40 04             	mov    0x4(%eax),%eax
 7e3:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7e6:	77 4d                	ja     835 <malloc+0xa6>
      if(p->s.size == nunits)
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7f1:	75 0c                	jne    7ff <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	89 10                	mov    %edx,(%eax)
 7fd:	eb 26                	jmp    825 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 40 04             	mov    0x4(%eax),%eax
 805:	2b 45 ec             	sub    -0x14(%ebp),%eax
 808:	89 c2                	mov    %eax,%edx
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	c1 e0 03             	shl    $0x3,%eax
 819:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 822:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 825:	8b 45 f0             	mov    -0x10(%ebp),%eax
 828:	a3 c4 08 00 00       	mov    %eax,0x8c4
      return (void*)(p + 1);
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	83 c0 08             	add    $0x8,%eax
 833:	eb 3b                	jmp    870 <malloc+0xe1>
    }
    if(p == freep)
 835:	a1 c4 08 00 00       	mov    0x8c4,%eax
 83a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 83d:	75 1e                	jne    85d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 83f:	83 ec 0c             	sub    $0xc,%esp
 842:	ff 75 ec             	push   -0x14(%ebp)
 845:	e8 e5 fe ff ff       	call   72f <morecore>
 84a:	83 c4 10             	add    $0x10,%esp
 84d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 854:	75 07                	jne    85d <malloc+0xce>
        return 0;
 856:	b8 00 00 00 00       	mov    $0x0,%eax
 85b:	eb 13                	jmp    870 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	89 45 f0             	mov    %eax,-0x10(%ebp)
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8b 00                	mov    (%eax),%eax
 868:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 86b:	e9 6d ff ff ff       	jmp    7dd <malloc+0x4e>
  }
}
 870:	c9                   	leave  
 871:	c3                   	ret    
