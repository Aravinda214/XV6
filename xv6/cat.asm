
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	push   -0xc(%ebp)
   e:	68 40 09 00 00       	push   $0x940
  13:	6a 01                	push   $0x1
  15:	e8 9c 03 00 00       	call   3b6 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 40 09 00 00       	push   $0x940
  2a:	ff 75 08             	push   0x8(%ebp)
  2d:	e8 7c 03 00 00       	call   3ae <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 f1 08 00 00       	push   $0x8f1
  4c:	6a 01                	push   $0x1
  4e:	e8 e7 04 00 00       	call   53a <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 3b 03 00 00       	call   396 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	push   -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 0d 03 00 00       	call   396 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 28 03 00 00       	call   3d6 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 02 09 00 00       	push   $0x902
  d4:	6a 01                	push   $0x1
  d6:	e8 5f 04 00 00       	call   53a <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 b3 02 00 00       	call   396 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	push   -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	push   -0x10(%ebp)
  f7:	e8 c2 02 00 00       	call   3be <close>
  fc:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
  }
  exit();
 10a:	e8 87 02 00 00       	call   396 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 55 0c             	mov    0xc(%ebp),%edx
 145:	8d 42 01             	lea    0x1(%edx),%eax
 148:	89 45 0c             	mov    %eax,0xc(%ebp)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	8d 48 01             	lea    0x1(%eax),%ecx
 151:	89 4d 08             	mov    %ecx,0x8(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c8             	movzbl %al,%ecx
 19e:	89 d0                	mov    %edx,%eax
 1a0:	29 c8                	sub    %ecx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	push   0xc(%ebp)
 1d5:	ff 75 08             	push   0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 77 01 00 00       	call   3ae <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 272:	7f b3                	jg     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
      break;
 276:	90                   	nop
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	push   0x8(%ebp)
 295:	e8 3c 01 00 00       	call   3d6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	push   0xc(%ebp)
 2b3:	ff 75 f4             	push   -0xc(%ebp)
 2b6:	e8 33 01 00 00       	call   3ee <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	push   -0xc(%ebp)
 2c7:	e8 f2 00 00 00       	call   3be <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 55 f8             	mov    -0x8(%ebp),%edx
 338:	8d 42 01             	lea    0x1(%edx),%eax
 33b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 33e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 341:	8d 48 01             	lea    0x1(%eax),%ecx
 344:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <restorer>:
 35e:	83 c4 0c             	add    $0xc,%esp
 361:	5a                   	pop    %edx
 362:	59                   	pop    %ecx
 363:	58                   	pop    %eax
 364:	c3                   	ret    

00000365 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
 368:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 36b:	83 ec 0c             	sub    $0xc,%esp
 36e:	68 5e 03 00 00       	push   $0x35e
 373:	e8 ce 00 00 00       	call   446 <signal_restorer>
 378:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 37b:	83 ec 08             	sub    $0x8,%esp
 37e:	ff 75 0c             	push   0xc(%ebp)
 381:	ff 75 08             	push   0x8(%ebp)
 384:	e8 b5 00 00 00       	call   43e <signal_register>
 389:	83 c4 10             	add    $0x10,%esp
 38c:	c9                   	leave  
 38d:	c3                   	ret    

0000038e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 38e:	b8 01 00 00 00       	mov    $0x1,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <exit>:
SYSCALL(exit)
 396:	b8 02 00 00 00       	mov    $0x2,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <wait>:
SYSCALL(wait)
 39e:	b8 03 00 00 00       	mov    $0x3,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <pipe>:
SYSCALL(pipe)
 3a6:	b8 04 00 00 00       	mov    $0x4,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <read>:
SYSCALL(read)
 3ae:	b8 05 00 00 00       	mov    $0x5,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <write>:
SYSCALL(write)
 3b6:	b8 10 00 00 00       	mov    $0x10,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <close>:
SYSCALL(close)
 3be:	b8 15 00 00 00       	mov    $0x15,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <kill>:
SYSCALL(kill)
 3c6:	b8 06 00 00 00       	mov    $0x6,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <exec>:
SYSCALL(exec)
 3ce:	b8 07 00 00 00       	mov    $0x7,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <open>:
SYSCALL(open)
 3d6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <mknod>:
SYSCALL(mknod)
 3de:	b8 11 00 00 00       	mov    $0x11,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <unlink>:
SYSCALL(unlink)
 3e6:	b8 12 00 00 00       	mov    $0x12,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <fstat>:
SYSCALL(fstat)
 3ee:	b8 08 00 00 00       	mov    $0x8,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <link>:
SYSCALL(link)
 3f6:	b8 13 00 00 00       	mov    $0x13,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <mkdir>:
SYSCALL(mkdir)
 3fe:	b8 14 00 00 00       	mov    $0x14,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <chdir>:
SYSCALL(chdir)
 406:	b8 09 00 00 00       	mov    $0x9,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <dup>:
SYSCALL(dup)
 40e:	b8 0a 00 00 00       	mov    $0xa,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getpid>:
SYSCALL(getpid)
 416:	b8 0b 00 00 00       	mov    $0xb,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <sbrk>:
SYSCALL(sbrk)
 41e:	b8 0c 00 00 00       	mov    $0xc,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <sleep>:
SYSCALL(sleep)
 426:	b8 0d 00 00 00       	mov    $0xd,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <uptime>:
SYSCALL(uptime)
 42e:	b8 0e 00 00 00       	mov    $0xe,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <halt>:
SYSCALL(halt)
 436:	b8 16 00 00 00       	mov    $0x16,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <signal_register>:
SYSCALL(signal_register)
 43e:	b8 17 00 00 00       	mov    $0x17,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <signal_restorer>:
SYSCALL(signal_restorer)
 446:	b8 18 00 00 00       	mov    $0x18,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <mprotect>:
SYSCALL(mprotect)
 44e:	b8 19 00 00 00       	mov    $0x19,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <cowfork>:
SYSCALL(cowfork)
 456:	b8 1a 00 00 00       	mov    $0x1a,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <dsbrk>:
SYSCALL(dsbrk)
 45e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 466:	55                   	push   %ebp
 467:	89 e5                	mov    %esp,%ebp
 469:	83 ec 18             	sub    $0x18,%esp
 46c:	8b 45 0c             	mov    0xc(%ebp),%eax
 46f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 472:	83 ec 04             	sub    $0x4,%esp
 475:	6a 01                	push   $0x1
 477:	8d 45 f4             	lea    -0xc(%ebp),%eax
 47a:	50                   	push   %eax
 47b:	ff 75 08             	push   0x8(%ebp)
 47e:	e8 33 ff ff ff       	call   3b6 <write>
 483:	83 c4 10             	add    $0x10,%esp
}
 486:	90                   	nop
 487:	c9                   	leave  
 488:	c3                   	ret    

00000489 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 489:	55                   	push   %ebp
 48a:	89 e5                	mov    %esp,%ebp
 48c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 496:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49a:	74 17                	je     4b3 <printint+0x2a>
 49c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a0:	79 11                	jns    4b3 <printint+0x2a>
    neg = 1;
 4a2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ac:	f7 d8                	neg    %eax
 4ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b1:	eb 06                	jmp    4b9 <printint+0x30>
  } else {
    x = xx;
 4b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c6:	ba 00 00 00 00       	mov    $0x0,%edx
 4cb:	f7 f1                	div    %ecx
 4cd:	89 d1                	mov    %edx,%ecx
 4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d2:	8d 50 01             	lea    0x1(%eax),%edx
 4d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d8:	0f b6 91 20 09 00 00 	movzbl 0x920(%ecx),%edx
 4df:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ee:	f7 f1                	div    %ecx
 4f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f7:	75 c7                	jne    4c0 <printint+0x37>
  if(neg)
 4f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fd:	74 2d                	je     52c <printint+0xa3>
    buf[i++] = '-';
 4ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 502:	8d 50 01             	lea    0x1(%eax),%edx
 505:	89 55 f4             	mov    %edx,-0xc(%ebp)
 508:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50d:	eb 1d                	jmp    52c <printint+0xa3>
    putc(fd, buf[i]);
 50f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 515:	01 d0                	add    %edx,%eax
 517:	0f b6 00             	movzbl (%eax),%eax
 51a:	0f be c0             	movsbl %al,%eax
 51d:	83 ec 08             	sub    $0x8,%esp
 520:	50                   	push   %eax
 521:	ff 75 08             	push   0x8(%ebp)
 524:	e8 3d ff ff ff       	call   466 <putc>
 529:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 52c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 534:	79 d9                	jns    50f <printint+0x86>
}
 536:	90                   	nop
 537:	90                   	nop
 538:	c9                   	leave  
 539:	c3                   	ret    

0000053a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53a:	55                   	push   %ebp
 53b:	89 e5                	mov    %esp,%ebp
 53d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 540:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 547:	8d 45 0c             	lea    0xc(%ebp),%eax
 54a:	83 c0 04             	add    $0x4,%eax
 54d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 550:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 557:	e9 59 01 00 00       	jmp    6b5 <printf+0x17b>
    c = fmt[i] & 0xff;
 55c:	8b 55 0c             	mov    0xc(%ebp),%edx
 55f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 562:	01 d0                	add    %edx,%eax
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	25 ff 00 00 00       	and    $0xff,%eax
 56f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 572:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 576:	75 2c                	jne    5a4 <printf+0x6a>
      if(c == '%'){
 578:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57c:	75 0c                	jne    58a <printf+0x50>
        state = '%';
 57e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 585:	e9 27 01 00 00       	jmp    6b1 <printf+0x177>
      } else {
        putc(fd, c);
 58a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	push   0x8(%ebp)
 597:	e8 ca fe ff ff       	call   466 <putc>
 59c:	83 c4 10             	add    $0x10,%esp
 59f:	e9 0d 01 00 00       	jmp    6b1 <printf+0x177>
      }
    } else if(state == '%'){
 5a4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a8:	0f 85 03 01 00 00    	jne    6b1 <printf+0x177>
      if(c == 'd'){
 5ae:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b2:	75 1e                	jne    5d2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b7:	8b 00                	mov    (%eax),%eax
 5b9:	6a 01                	push   $0x1
 5bb:	6a 0a                	push   $0xa
 5bd:	50                   	push   %eax
 5be:	ff 75 08             	push   0x8(%ebp)
 5c1:	e8 c3 fe ff ff       	call   489 <printint>
 5c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cd:	e9 d8 00 00 00       	jmp    6aa <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d6:	74 06                	je     5de <printf+0xa4>
 5d8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5dc:	75 1e                	jne    5fc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	6a 00                	push   $0x0
 5e5:	6a 10                	push   $0x10
 5e7:	50                   	push   %eax
 5e8:	ff 75 08             	push   0x8(%ebp)
 5eb:	e8 99 fe ff ff       	call   489 <printint>
 5f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f7:	e9 ae 00 00 00       	jmp    6aa <printf+0x170>
      } else if(c == 's'){
 5fc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 600:	75 43                	jne    645 <printf+0x10b>
        s = (char*)*ap;
 602:	8b 45 e8             	mov    -0x18(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 60a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 612:	75 25                	jne    639 <printf+0xff>
          s = "(null)";
 614:	c7 45 f4 17 09 00 00 	movl   $0x917,-0xc(%ebp)
        while(*s != 0){
 61b:	eb 1c                	jmp    639 <printf+0xff>
          putc(fd, *s);
 61d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 620:	0f b6 00             	movzbl (%eax),%eax
 623:	0f be c0             	movsbl %al,%eax
 626:	83 ec 08             	sub    $0x8,%esp
 629:	50                   	push   %eax
 62a:	ff 75 08             	push   0x8(%ebp)
 62d:	e8 34 fe ff ff       	call   466 <putc>
 632:	83 c4 10             	add    $0x10,%esp
          s++;
 635:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	0f b6 00             	movzbl (%eax),%eax
 63f:	84 c0                	test   %al,%al
 641:	75 da                	jne    61d <printf+0xe3>
 643:	eb 65                	jmp    6aa <printf+0x170>
        }
      } else if(c == 'c'){
 645:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 649:	75 1d                	jne    668 <printf+0x12e>
        putc(fd, *ap);
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	0f be c0             	movsbl %al,%eax
 653:	83 ec 08             	sub    $0x8,%esp
 656:	50                   	push   %eax
 657:	ff 75 08             	push   0x8(%ebp)
 65a:	e8 07 fe ff ff       	call   466 <putc>
 65f:	83 c4 10             	add    $0x10,%esp
        ap++;
 662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 666:	eb 42                	jmp    6aa <printf+0x170>
      } else if(c == '%'){
 668:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66c:	75 17                	jne    685 <printf+0x14b>
        putc(fd, c);
 66e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 671:	0f be c0             	movsbl %al,%eax
 674:	83 ec 08             	sub    $0x8,%esp
 677:	50                   	push   %eax
 678:	ff 75 08             	push   0x8(%ebp)
 67b:	e8 e6 fd ff ff       	call   466 <putc>
 680:	83 c4 10             	add    $0x10,%esp
 683:	eb 25                	jmp    6aa <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 685:	83 ec 08             	sub    $0x8,%esp
 688:	6a 25                	push   $0x25
 68a:	ff 75 08             	push   0x8(%ebp)
 68d:	e8 d4 fd ff ff       	call   466 <putc>
 692:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 698:	0f be c0             	movsbl %al,%eax
 69b:	83 ec 08             	sub    $0x8,%esp
 69e:	50                   	push   %eax
 69f:	ff 75 08             	push   0x8(%ebp)
 6a2:	e8 bf fd ff ff       	call   466 <putc>
 6a7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bb:	01 d0                	add    %edx,%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	84 c0                	test   %al,%al
 6c2:	0f 85 94 fe ff ff    	jne    55c <printf+0x22>
    }
  }
}
 6c8:	90                   	nop
 6c9:	90                   	nop
 6ca:	c9                   	leave  
 6cb:	c3                   	ret    

000006cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	83 e8 08             	sub    $0x8,%eax
 6d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6db:	a1 48 0b 00 00       	mov    0xb48,%eax
 6e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e3:	eb 24                	jmp    709 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6ed:	72 12                	jb     701 <free+0x35>
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f5:	77 24                	ja     71b <free+0x4f>
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6ff:	72 1a                	jb     71b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	89 45 fc             	mov    %eax,-0x4(%ebp)
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	76 d4                	jbe    6e5 <free+0x19>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 719:	73 ca                	jae    6e5 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	01 c2                	add    %eax,%edx
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	39 c2                	cmp    %eax,%edx
 734:	75 24                	jne    75a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	8b 50 04             	mov    0x4(%eax),%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	01 c2                	add    %eax,%edx
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	8b 10                	mov    (%eax),%edx
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	89 10                	mov    %edx,(%eax)
 758:	eb 0a                	jmp    764 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 10                	mov    (%eax),%edx
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 40 04             	mov    0x4(%eax),%eax
 76a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	01 d0                	add    %edx,%eax
 776:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 779:	75 20                	jne    79b <free+0xcf>
    p->s.size += bp->s.size;
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 50 04             	mov    0x4(%eax),%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	01 c2                	add    %eax,%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 08                	jmp    7a3 <free+0xd7>
  } else
    p->s.ptr = bp;
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7a1:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	a3 48 0b 00 00       	mov    %eax,0xb48
}
 7ab:	90                   	nop
 7ac:	c9                   	leave  
 7ad:	c3                   	ret    

000007ae <morecore>:

static Header*
morecore(uint nu)
{
 7ae:	55                   	push   %ebp
 7af:	89 e5                	mov    %esp,%ebp
 7b1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7bb:	77 07                	ja     7c4 <morecore+0x16>
    nu = 4096;
 7bd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	c1 e0 03             	shl    $0x3,%eax
 7ca:	83 ec 0c             	sub    $0xc,%esp
 7cd:	50                   	push   %eax
 7ce:	e8 4b fc ff ff       	call   41e <sbrk>
 7d3:	83 c4 10             	add    $0x10,%esp
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7dd:	75 07                	jne    7e6 <morecore+0x38>
    return 0;
 7df:	b8 00 00 00 00       	mov    $0x0,%eax
 7e4:	eb 26                	jmp    80c <morecore+0x5e>
  hp = (Header*)p;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	8b 55 08             	mov    0x8(%ebp),%edx
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	83 c0 08             	add    $0x8,%eax
 7fb:	83 ec 0c             	sub    $0xc,%esp
 7fe:	50                   	push   %eax
 7ff:	e8 c8 fe ff ff       	call   6cc <free>
 804:	83 c4 10             	add    $0x10,%esp
  return freep;
 807:	a1 48 0b 00 00       	mov    0xb48,%eax
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    

0000080e <malloc>:

void*
malloc(uint nbytes)
{
 80e:	55                   	push   %ebp
 80f:	89 e5                	mov    %esp,%ebp
 811:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	83 c0 07             	add    $0x7,%eax
 81a:	c1 e8 03             	shr    $0x3,%eax
 81d:	83 c0 01             	add    $0x1,%eax
 820:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 823:	a1 48 0b 00 00       	mov    0xb48,%eax
 828:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82f:	75 23                	jne    854 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 831:	c7 45 f0 40 0b 00 00 	movl   $0xb40,-0x10(%ebp)
 838:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83b:	a3 48 0b 00 00       	mov    %eax,0xb48
 840:	a1 48 0b 00 00       	mov    0xb48,%eax
 845:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 84a:	c7 05 44 0b 00 00 00 	movl   $0x0,0xb44
 851:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 40 04             	mov    0x4(%eax),%eax
 862:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 865:	77 4d                	ja     8b4 <malloc+0xa6>
      if(p->s.size == nunits)
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 40 04             	mov    0x4(%eax),%eax
 86d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 870:	75 0c                	jne    87e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 10                	mov    (%eax),%edx
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	89 10                	mov    %edx,(%eax)
 87c:	eb 26                	jmp    8a4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	2b 45 ec             	sub    -0x14(%ebp),%eax
 887:	89 c2                	mov    %eax,%edx
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 40 04             	mov    0x4(%eax),%eax
 895:	c1 e0 03             	shl    $0x3,%eax
 898:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a7:	a3 48 0b 00 00       	mov    %eax,0xb48
      return (void*)(p + 1);
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	83 c0 08             	add    $0x8,%eax
 8b2:	eb 3b                	jmp    8ef <malloc+0xe1>
    }
    if(p == freep)
 8b4:	a1 48 0b 00 00       	mov    0xb48,%eax
 8b9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8bc:	75 1e                	jne    8dc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8be:	83 ec 0c             	sub    $0xc,%esp
 8c1:	ff 75 ec             	push   -0x14(%ebp)
 8c4:	e8 e5 fe ff ff       	call   7ae <morecore>
 8c9:	83 c4 10             	add    $0x10,%esp
 8cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d3:	75 07                	jne    8dc <malloc+0xce>
        return 0;
 8d5:	b8 00 00 00 00       	mov    $0x0,%eax
 8da:	eb 13                	jmp    8ef <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	8b 00                	mov    (%eax),%eax
 8e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ea:	e9 6d ff ff ff       	jmp    85c <malloc+0x4e>
  }
}
 8ef:	c9                   	leave  
 8f0:	c3                   	ret    
