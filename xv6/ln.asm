
_ln:     file format elf32-i386


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
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3 && argc != 4){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 1c                	je     32 <main+0x32>
  16:	83 3b 04             	cmpl   $0x4,(%ebx)
  19:	74 17                	je     32 <main+0x32>
    printf(2, "Usage: ln old new\n");
  1b:	83 ec 08             	sub    $0x8,%esp
  1e:	68 5b 08 00 00       	push   $0x85b
  23:	6a 02                	push   $0x2
  25:	e8 7a 04 00 00       	call   4a4 <printf>
  2a:	83 c4 10             	add    $0x10,%esp
    exit();
  2d:	e8 ce 02 00 00       	call   300 <exit>
  //   if(symlink(argv[2],argv[3]) < 0){
  //     printf(2,"symbolic link %s %s failed\n",argv[2],argv[3]);
  //     exit();
  //   }
  // }
  else if(link(argv[1], argv[2]) < 0)
  32:	8b 43 04             	mov    0x4(%ebx),%eax
  35:	83 c0 08             	add    $0x8,%eax
  38:	8b 10                	mov    (%eax),%edx
  3a:	8b 43 04             	mov    0x4(%ebx),%eax
  3d:	83 c0 04             	add    $0x4,%eax
  40:	8b 00                	mov    (%eax),%eax
  42:	83 ec 08             	sub    $0x8,%esp
  45:	52                   	push   %edx
  46:	50                   	push   %eax
  47:	e8 14 03 00 00       	call   360 <link>
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	85 c0                	test   %eax,%eax
  51:	79 21                	jns    74 <main+0x74>
    printf(2, "hard link %s %s: failed\n", argv[1], argv[2]);
  53:	8b 43 04             	mov    0x4(%ebx),%eax
  56:	83 c0 08             	add    $0x8,%eax
  59:	8b 10                	mov    (%eax),%edx
  5b:	8b 43 04             	mov    0x4(%ebx),%eax
  5e:	83 c0 04             	add    $0x4,%eax
  61:	8b 00                	mov    (%eax),%eax
  63:	52                   	push   %edx
  64:	50                   	push   %eax
  65:	68 6e 08 00 00       	push   $0x86e
  6a:	6a 02                	push   $0x2
  6c:	e8 33 04 00 00       	call   4a4 <printf>
  71:	83 c4 10             	add    $0x10,%esp
    
  exit();
  74:	e8 87 02 00 00       	call   300 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	90                   	nop
  9b:	5b                   	pop    %ebx
  9c:	5f                   	pop    %edi
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ab:	90                   	nop
  ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  af:	8d 42 01             	lea    0x1(%edx),%eax
  b2:	89 45 0c             	mov    %eax,0xc(%ebp)
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	8d 48 01             	lea    0x1(%eax),%ecx
  bb:	89 4d 08             	mov    %ecx,0x8(%ebp)
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	88 10                	mov    %dl,(%eax)
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	84 c0                	test   %al,%al
  c8:	75 e2                	jne    ac <strcpy+0xd>
    ;
  return os;
  ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cd:	c9                   	leave  
  ce:	c3                   	ret    

000000cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d2:	eb 08                	jmp    dc <strcmp+0xd>
    p++, q++;
  d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 00             	movzbl (%eax),%eax
  e2:	84 c0                	test   %al,%al
  e4:	74 10                	je     f6 <strcmp+0x27>
  e6:	8b 45 08             	mov    0x8(%ebp),%eax
  e9:	0f b6 10             	movzbl (%eax),%edx
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	38 c2                	cmp    %al,%dl
  f4:	74 de                	je     d4 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	0f b6 00             	movzbl (%eax),%eax
  fc:	0f b6 d0             	movzbl %al,%edx
  ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 102:	0f b6 00             	movzbl (%eax),%eax
 105:	0f b6 c8             	movzbl %al,%ecx
 108:	89 d0                	mov    %edx,%eax
 10a:	29 c8                	sub    %ecx,%eax
}
 10c:	5d                   	pop    %ebp
 10d:	c3                   	ret    

0000010e <strlen>:

uint
strlen(char *s)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
 111:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 114:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 11b:	eb 04                	jmp    121 <strlen+0x13>
 11d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 121:	8b 55 fc             	mov    -0x4(%ebp),%edx
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	01 d0                	add    %edx,%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	84 c0                	test   %al,%al
 12e:	75 ed                	jne    11d <strlen+0xf>
    ;
  return n;
 130:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <memset>:

void*
memset(void *dst, int c, uint n)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 138:	8b 45 10             	mov    0x10(%ebp),%eax
 13b:	50                   	push   %eax
 13c:	ff 75 0c             	push   0xc(%ebp)
 13f:	ff 75 08             	push   0x8(%ebp)
 142:	e8 32 ff ff ff       	call   79 <stosb>
 147:	83 c4 0c             	add    $0xc,%esp
  return dst;
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <strchr>:

char*
strchr(const char *s, char c)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 04             	sub    $0x4,%esp
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15b:	eb 14                	jmp    171 <strchr+0x22>
    if(*s == c)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	38 45 fc             	cmp    %al,-0x4(%ebp)
 166:	75 05                	jne    16d <strchr+0x1e>
      return (char*)s;
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	eb 13                	jmp    180 <strchr+0x31>
  for(; *s; s++)
 16d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	75 e2                	jne    15d <strchr+0xe>
  return 0;
 17b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 180:	c9                   	leave  
 181:	c3                   	ret    

00000182 <gets>:

char*
gets(char *buf, int max)
{
 182:	55                   	push   %ebp
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18f:	eb 42                	jmp    1d3 <gets+0x51>
    cc = read(0, &c, 1);
 191:	83 ec 04             	sub    $0x4,%esp
 194:	6a 01                	push   $0x1
 196:	8d 45 ef             	lea    -0x11(%ebp),%eax
 199:	50                   	push   %eax
 19a:	6a 00                	push   $0x0
 19c:	e8 77 01 00 00       	call   318 <read>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ab:	7e 33                	jle    1e0 <gets+0x5e>
      break;
    buf[i++] = c;
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	8d 50 01             	lea    0x1(%eax),%edx
 1b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b6:	89 c2                	mov    %eax,%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 c2                	add    %eax,%edx
 1bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	3c 0a                	cmp    $0xa,%al
 1c9:	74 16                	je     1e1 <gets+0x5f>
 1cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cf:	3c 0d                	cmp    $0xd,%al
 1d1:	74 0e                	je     1e1 <gets+0x5f>
  for(i=0; i+1 < max; ){
 1d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d6:	83 c0 01             	add    $0x1,%eax
 1d9:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1dc:	7f b3                	jg     191 <gets+0xf>
 1de:	eb 01                	jmp    1e1 <gets+0x5f>
      break;
 1e0:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	01 d0                	add    %edx,%eax
 1e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <stat>:

int
stat(char *n, struct stat *st)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f7:	83 ec 08             	sub    $0x8,%esp
 1fa:	6a 00                	push   $0x0
 1fc:	ff 75 08             	push   0x8(%ebp)
 1ff:	e8 3c 01 00 00       	call   340 <open>
 204:	83 c4 10             	add    $0x10,%esp
 207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20e:	79 07                	jns    217 <stat+0x26>
    return -1;
 210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 215:	eb 25                	jmp    23c <stat+0x4b>
  r = fstat(fd, st);
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	ff 75 0c             	push   0xc(%ebp)
 21d:	ff 75 f4             	push   -0xc(%ebp)
 220:	e8 33 01 00 00       	call   358 <fstat>
 225:	83 c4 10             	add    $0x10,%esp
 228:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22b:	83 ec 0c             	sub    $0xc,%esp
 22e:	ff 75 f4             	push   -0xc(%ebp)
 231:	e8 f2 00 00 00       	call   328 <close>
 236:	83 c4 10             	add    $0x10,%esp
  return r;
 239:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23c:	c9                   	leave  
 23d:	c3                   	ret    

0000023e <atoi>:

int
atoi(const char *s)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 244:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24b:	eb 25                	jmp    272 <atoi+0x34>
    n = n*10 + *s++ - '0';
 24d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 250:	89 d0                	mov    %edx,%eax
 252:	c1 e0 02             	shl    $0x2,%eax
 255:	01 d0                	add    %edx,%eax
 257:	01 c0                	add    %eax,%eax
 259:	89 c1                	mov    %eax,%ecx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 01             	lea    0x1(%eax),%edx
 261:	89 55 08             	mov    %edx,0x8(%ebp)
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	01 c8                	add    %ecx,%eax
 26c:	83 e8 30             	sub    $0x30,%eax
 26f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	3c 2f                	cmp    $0x2f,%al
 27a:	7e 0a                	jle    286 <atoi+0x48>
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 39                	cmp    $0x39,%al
 284:	7e c7                	jle    24d <atoi+0xf>
  return n;
 286:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 289:	c9                   	leave  
 28a:	c3                   	ret    

0000028b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 29d:	eb 17                	jmp    2b6 <memmove+0x2b>
    *dst++ = *src++;
 29f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a2:	8d 42 01             	lea    0x1(%edx),%eax
 2a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ab:	8d 48 01             	lea    0x1(%eax),%ecx
 2ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2b1:	0f b6 12             	movzbl (%edx),%edx
 2b4:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2b6:	8b 45 10             	mov    0x10(%ebp),%eax
 2b9:	8d 50 ff             	lea    -0x1(%eax),%edx
 2bc:	89 55 10             	mov    %edx,0x10(%ebp)
 2bf:	85 c0                	test   %eax,%eax
 2c1:	7f dc                	jg     29f <memmove+0x14>
  return vdst;
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c6:	c9                   	leave  
 2c7:	c3                   	ret    

000002c8 <restorer>:
 2c8:	83 c4 0c             	add    $0xc,%esp
 2cb:	5a                   	pop    %edx
 2cc:	59                   	pop    %ecx
 2cd:	58                   	pop    %eax
 2ce:	c3                   	ret    

000002cf <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp
 2d2:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 2d5:	83 ec 0c             	sub    $0xc,%esp
 2d8:	68 c8 02 00 00       	push   $0x2c8
 2dd:	e8 ce 00 00 00       	call   3b0 <signal_restorer>
 2e2:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 2e5:	83 ec 08             	sub    $0x8,%esp
 2e8:	ff 75 0c             	push   0xc(%ebp)
 2eb:	ff 75 08             	push   0x8(%ebp)
 2ee:	e8 b5 00 00 00       	call   3a8 <signal_register>
 2f3:	83 c4 10             	add    $0x10,%esp
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2f8:	b8 01 00 00 00       	mov    $0x1,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exit>:
SYSCALL(exit)
 300:	b8 02 00 00 00       	mov    $0x2,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <wait>:
SYSCALL(wait)
 308:	b8 03 00 00 00       	mov    $0x3,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <pipe>:
SYSCALL(pipe)
 310:	b8 04 00 00 00       	mov    $0x4,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <read>:
SYSCALL(read)
 318:	b8 05 00 00 00       	mov    $0x5,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <write>:
SYSCALL(write)
 320:	b8 10 00 00 00       	mov    $0x10,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <close>:
SYSCALL(close)
 328:	b8 15 00 00 00       	mov    $0x15,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <kill>:
SYSCALL(kill)
 330:	b8 06 00 00 00       	mov    $0x6,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <exec>:
SYSCALL(exec)
 338:	b8 07 00 00 00       	mov    $0x7,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <open>:
SYSCALL(open)
 340:	b8 0f 00 00 00       	mov    $0xf,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <mknod>:
SYSCALL(mknod)
 348:	b8 11 00 00 00       	mov    $0x11,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <unlink>:
SYSCALL(unlink)
 350:	b8 12 00 00 00       	mov    $0x12,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <fstat>:
SYSCALL(fstat)
 358:	b8 08 00 00 00       	mov    $0x8,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <link>:
SYSCALL(link)
 360:	b8 13 00 00 00       	mov    $0x13,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <mkdir>:
SYSCALL(mkdir)
 368:	b8 14 00 00 00       	mov    $0x14,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <chdir>:
SYSCALL(chdir)
 370:	b8 09 00 00 00       	mov    $0x9,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <dup>:
SYSCALL(dup)
 378:	b8 0a 00 00 00       	mov    $0xa,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <getpid>:
SYSCALL(getpid)
 380:	b8 0b 00 00 00       	mov    $0xb,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <sbrk>:
SYSCALL(sbrk)
 388:	b8 0c 00 00 00       	mov    $0xc,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <sleep>:
SYSCALL(sleep)
 390:	b8 0d 00 00 00       	mov    $0xd,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <uptime>:
SYSCALL(uptime)
 398:	b8 0e 00 00 00       	mov    $0xe,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <halt>:
SYSCALL(halt)
 3a0:	b8 16 00 00 00       	mov    $0x16,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <signal_register>:
SYSCALL(signal_register)
 3a8:	b8 17 00 00 00       	mov    $0x17,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <signal_restorer>:
SYSCALL(signal_restorer)
 3b0:	b8 18 00 00 00       	mov    $0x18,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <mprotect>:
SYSCALL(mprotect)
 3b8:	b8 19 00 00 00       	mov    $0x19,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <cowfork>:
SYSCALL(cowfork)
 3c0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <dsbrk>:
SYSCALL(dsbrk)
 3c8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	83 ec 18             	sub    $0x18,%esp
 3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3dc:	83 ec 04             	sub    $0x4,%esp
 3df:	6a 01                	push   $0x1
 3e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e4:	50                   	push   %eax
 3e5:	ff 75 08             	push   0x8(%ebp)
 3e8:	e8 33 ff ff ff       	call   320 <write>
 3ed:	83 c4 10             	add    $0x10,%esp
}
 3f0:	90                   	nop
 3f1:	c9                   	leave  
 3f2:	c3                   	ret    

000003f3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f3:	55                   	push   %ebp
 3f4:	89 e5                	mov    %esp,%ebp
 3f6:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 400:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 404:	74 17                	je     41d <printint+0x2a>
 406:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 40a:	79 11                	jns    41d <printint+0x2a>
    neg = 1;
 40c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	f7 d8                	neg    %eax
 418:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41b:	eb 06                	jmp    423 <printint+0x30>
  } else {
    x = xx;
 41d:	8b 45 0c             	mov    0xc(%ebp),%eax
 420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 423:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 42a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 42d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 430:	ba 00 00 00 00       	mov    $0x0,%edx
 435:	f7 f1                	div    %ecx
 437:	89 d1                	mov    %edx,%ecx
 439:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43c:	8d 50 01             	lea    0x1(%eax),%edx
 43f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 442:	0f b6 91 90 08 00 00 	movzbl 0x890(%ecx),%edx
 449:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 44d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 450:	8b 45 ec             	mov    -0x14(%ebp),%eax
 453:	ba 00 00 00 00       	mov    $0x0,%edx
 458:	f7 f1                	div    %ecx
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 461:	75 c7                	jne    42a <printint+0x37>
  if(neg)
 463:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 467:	74 2d                	je     496 <printint+0xa3>
    buf[i++] = '-';
 469:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46c:	8d 50 01             	lea    0x1(%eax),%edx
 46f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 472:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 477:	eb 1d                	jmp    496 <printint+0xa3>
    putc(fd, buf[i]);
 479:	8d 55 dc             	lea    -0x24(%ebp),%edx
 47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47f:	01 d0                	add    %edx,%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	0f be c0             	movsbl %al,%eax
 487:	83 ec 08             	sub    $0x8,%esp
 48a:	50                   	push   %eax
 48b:	ff 75 08             	push   0x8(%ebp)
 48e:	e8 3d ff ff ff       	call   3d0 <putc>
 493:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 496:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 49a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 49e:	79 d9                	jns    479 <printint+0x86>
}
 4a0:	90                   	nop
 4a1:	90                   	nop
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b1:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b4:	83 c0 04             	add    $0x4,%eax
 4b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c1:	e9 59 01 00 00       	jmp    61f <printf+0x17b>
    c = fmt[i] & 0xff;
 4c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 4c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	0f b6 00             	movzbl (%eax),%eax
 4d1:	0f be c0             	movsbl %al,%eax
 4d4:	25 ff 00 00 00       	and    $0xff,%eax
 4d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e0:	75 2c                	jne    50e <printf+0x6a>
      if(c == '%'){
 4e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e6:	75 0c                	jne    4f4 <printf+0x50>
        state = '%';
 4e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ef:	e9 27 01 00 00       	jmp    61b <printf+0x177>
      } else {
        putc(fd, c);
 4f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f7:	0f be c0             	movsbl %al,%eax
 4fa:	83 ec 08             	sub    $0x8,%esp
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	push   0x8(%ebp)
 501:	e8 ca fe ff ff       	call   3d0 <putc>
 506:	83 c4 10             	add    $0x10,%esp
 509:	e9 0d 01 00 00       	jmp    61b <printf+0x177>
      }
    } else if(state == '%'){
 50e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 512:	0f 85 03 01 00 00    	jne    61b <printf+0x177>
      if(c == 'd'){
 518:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51c:	75 1e                	jne    53c <printf+0x98>
        printint(fd, *ap, 10, 1);
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	6a 01                	push   $0x1
 525:	6a 0a                	push   $0xa
 527:	50                   	push   %eax
 528:	ff 75 08             	push   0x8(%ebp)
 52b:	e8 c3 fe ff ff       	call   3f3 <printint>
 530:	83 c4 10             	add    $0x10,%esp
        ap++;
 533:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 537:	e9 d8 00 00 00       	jmp    614 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 53c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 540:	74 06                	je     548 <printf+0xa4>
 542:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 546:	75 1e                	jne    566 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 548:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	6a 00                	push   $0x0
 54f:	6a 10                	push   $0x10
 551:	50                   	push   %eax
 552:	ff 75 08             	push   0x8(%ebp)
 555:	e8 99 fe ff ff       	call   3f3 <printint>
 55a:	83 c4 10             	add    $0x10,%esp
        ap++;
 55d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 561:	e9 ae 00 00 00       	jmp    614 <printf+0x170>
      } else if(c == 's'){
 566:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 56a:	75 43                	jne    5af <printf+0x10b>
        s = (char*)*ap;
 56c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56f:	8b 00                	mov    (%eax),%eax
 571:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 574:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57c:	75 25                	jne    5a3 <printf+0xff>
          s = "(null)";
 57e:	c7 45 f4 87 08 00 00 	movl   $0x887,-0xc(%ebp)
        while(*s != 0){
 585:	eb 1c                	jmp    5a3 <printf+0xff>
          putc(fd, *s);
 587:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	push   0x8(%ebp)
 597:	e8 34 fe ff ff       	call   3d0 <putc>
 59c:	83 c4 10             	add    $0x10,%esp
          s++;
 59f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a6:	0f b6 00             	movzbl (%eax),%eax
 5a9:	84 c0                	test   %al,%al
 5ab:	75 da                	jne    587 <printf+0xe3>
 5ad:	eb 65                	jmp    614 <printf+0x170>
        }
      } else if(c == 'c'){
 5af:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5b3:	75 1d                	jne    5d2 <printf+0x12e>
        putc(fd, *ap);
 5b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	83 ec 08             	sub    $0x8,%esp
 5c0:	50                   	push   %eax
 5c1:	ff 75 08             	push   0x8(%ebp)
 5c4:	e8 07 fe ff ff       	call   3d0 <putc>
 5c9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d0:	eb 42                	jmp    614 <printf+0x170>
      } else if(c == '%'){
 5d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d6:	75 17                	jne    5ef <printf+0x14b>
        putc(fd, c);
 5d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5db:	0f be c0             	movsbl %al,%eax
 5de:	83 ec 08             	sub    $0x8,%esp
 5e1:	50                   	push   %eax
 5e2:	ff 75 08             	push   0x8(%ebp)
 5e5:	e8 e6 fd ff ff       	call   3d0 <putc>
 5ea:	83 c4 10             	add    $0x10,%esp
 5ed:	eb 25                	jmp    614 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ef:	83 ec 08             	sub    $0x8,%esp
 5f2:	6a 25                	push   $0x25
 5f4:	ff 75 08             	push   0x8(%ebp)
 5f7:	e8 d4 fd ff ff       	call   3d0 <putc>
 5fc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 602:	0f be c0             	movsbl %al,%eax
 605:	83 ec 08             	sub    $0x8,%esp
 608:	50                   	push   %eax
 609:	ff 75 08             	push   0x8(%ebp)
 60c:	e8 bf fd ff ff       	call   3d0 <putc>
 611:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 614:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 61b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 61f:	8b 55 0c             	mov    0xc(%ebp),%edx
 622:	8b 45 f0             	mov    -0x10(%ebp),%eax
 625:	01 d0                	add    %edx,%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	84 c0                	test   %al,%al
 62c:	0f 85 94 fe ff ff    	jne    4c6 <printf+0x22>
    }
  }
}
 632:	90                   	nop
 633:	90                   	nop
 634:	c9                   	leave  
 635:	c3                   	ret    

00000636 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 636:	55                   	push   %ebp
 637:	89 e5                	mov    %esp,%ebp
 639:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	83 e8 08             	sub    $0x8,%eax
 642:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 645:	a1 ac 08 00 00       	mov    0x8ac,%eax
 64a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64d:	eb 24                	jmp    673 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 652:	8b 00                	mov    (%eax),%eax
 654:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 657:	72 12                	jb     66b <free+0x35>
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65f:	77 24                	ja     685 <free+0x4f>
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 669:	72 1a                	jb     685 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	89 45 fc             	mov    %eax,-0x4(%ebp)
 673:	8b 45 f8             	mov    -0x8(%ebp),%eax
 676:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 679:	76 d4                	jbe    64f <free+0x19>
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	8b 00                	mov    (%eax),%eax
 680:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 683:	73 ca                	jae    64f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	8b 40 04             	mov    0x4(%eax),%eax
 68b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 692:	8b 45 f8             	mov    -0x8(%ebp),%eax
 695:	01 c2                	add    %eax,%edx
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	39 c2                	cmp    %eax,%edx
 69e:	75 24                	jne    6c4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	8b 50 04             	mov    0x4(%eax),%edx
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	01 c2                	add    %eax,%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	8b 00                	mov    (%eax),%eax
 6bb:	8b 10                	mov    (%eax),%edx
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	89 10                	mov    %edx,(%eax)
 6c2:	eb 0a                	jmp    6ce <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 10                	mov    (%eax),%edx
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 40 04             	mov    0x4(%eax),%eax
 6d4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	01 d0                	add    %edx,%eax
 6e0:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6e3:	75 20                	jne    705 <free+0xcf>
    p->s.size += bp->s.size;
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 50 04             	mov    0x4(%eax),%edx
 6eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ee:	8b 40 04             	mov    0x4(%eax),%eax
 6f1:	01 c2                	add    %eax,%edx
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	8b 10                	mov    (%eax),%edx
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	89 10                	mov    %edx,(%eax)
 703:	eb 08                	jmp    70d <free+0xd7>
  } else
    p->s.ptr = bp;
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	8b 55 f8             	mov    -0x8(%ebp),%edx
 70b:	89 10                	mov    %edx,(%eax)
  freep = p;
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	a3 ac 08 00 00       	mov    %eax,0x8ac
}
 715:	90                   	nop
 716:	c9                   	leave  
 717:	c3                   	ret    

00000718 <morecore>:

static Header*
morecore(uint nu)
{
 718:	55                   	push   %ebp
 719:	89 e5                	mov    %esp,%ebp
 71b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 71e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 725:	77 07                	ja     72e <morecore+0x16>
    nu = 4096;
 727:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 72e:	8b 45 08             	mov    0x8(%ebp),%eax
 731:	c1 e0 03             	shl    $0x3,%eax
 734:	83 ec 0c             	sub    $0xc,%esp
 737:	50                   	push   %eax
 738:	e8 4b fc ff ff       	call   388 <sbrk>
 73d:	83 c4 10             	add    $0x10,%esp
 740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 743:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 747:	75 07                	jne    750 <morecore+0x38>
    return 0;
 749:	b8 00 00 00 00       	mov    $0x0,%eax
 74e:	eb 26                	jmp    776 <morecore+0x5e>
  hp = (Header*)p;
 750:	8b 45 f4             	mov    -0xc(%ebp),%eax
 753:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	8b 55 08             	mov    0x8(%ebp),%edx
 75c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 75f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 762:	83 c0 08             	add    $0x8,%eax
 765:	83 ec 0c             	sub    $0xc,%esp
 768:	50                   	push   %eax
 769:	e8 c8 fe ff ff       	call   636 <free>
 76e:	83 c4 10             	add    $0x10,%esp
  return freep;
 771:	a1 ac 08 00 00       	mov    0x8ac,%eax
}
 776:	c9                   	leave  
 777:	c3                   	ret    

00000778 <malloc>:

void*
malloc(uint nbytes)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	83 c0 07             	add    $0x7,%eax
 784:	c1 e8 03             	shr    $0x3,%eax
 787:	83 c0 01             	add    $0x1,%eax
 78a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78d:	a1 ac 08 00 00       	mov    0x8ac,%eax
 792:	89 45 f0             	mov    %eax,-0x10(%ebp)
 795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 799:	75 23                	jne    7be <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 79b:	c7 45 f0 a4 08 00 00 	movl   $0x8a4,-0x10(%ebp)
 7a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a5:	a3 ac 08 00 00       	mov    %eax,0x8ac
 7aa:	a1 ac 08 00 00       	mov    0x8ac,%eax
 7af:	a3 a4 08 00 00       	mov    %eax,0x8a4
    base.s.size = 0;
 7b4:	c7 05 a8 08 00 00 00 	movl   $0x0,0x8a8
 7bb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c9:	8b 40 04             	mov    0x4(%eax),%eax
 7cc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7cf:	77 4d                	ja     81e <malloc+0xa6>
      if(p->s.size == nunits)
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 7da:	75 0c                	jne    7e8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 10                	mov    (%eax),%edx
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	89 10                	mov    %edx,(%eax)
 7e6:	eb 26                	jmp    80e <malloc+0x96>
      else {
        p->s.size -= nunits;
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7f1:	89 c2                	mov    %eax,%edx
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 40 04             	mov    0x4(%eax),%eax
 7ff:	c1 e0 03             	shl    $0x3,%eax
 802:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	a3 ac 08 00 00       	mov    %eax,0x8ac
      return (void*)(p + 1);
 816:	8b 45 f4             	mov    -0xc(%ebp),%eax
 819:	83 c0 08             	add    $0x8,%eax
 81c:	eb 3b                	jmp    859 <malloc+0xe1>
    }
    if(p == freep)
 81e:	a1 ac 08 00 00       	mov    0x8ac,%eax
 823:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 826:	75 1e                	jne    846 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 828:	83 ec 0c             	sub    $0xc,%esp
 82b:	ff 75 ec             	push   -0x14(%ebp)
 82e:	e8 e5 fe ff ff       	call   718 <morecore>
 833:	83 c4 10             	add    $0x10,%esp
 836:	89 45 f4             	mov    %eax,-0xc(%ebp)
 839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83d:	75 07                	jne    846 <malloc+0xce>
        return 0;
 83f:	b8 00 00 00 00       	mov    $0x0,%eax
 844:	eb 13                	jmp    859 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 00                	mov    (%eax),%eax
 851:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 854:	e9 6d ff ff ff       	jmp    7c6 <malloc+0x4e>
  }
}
 859:	c9                   	leave  
 85a:	c3                   	ret    
