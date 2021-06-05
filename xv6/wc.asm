
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 00 0a 00 00       	add    $0xa00,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 00 0a 00 00       	add    $0xa00,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 9f 09 00 00       	push   $0x99f
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 00 0a 00 00       	push   $0xa00
  98:	ff 75 08             	push   0x8(%ebp)
  9b:	e8 bc 03 00 00       	call   45c <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 a5 09 00 00       	push   $0x9a5
  be:	6a 01                	push   $0x1
  c0:	e8 23 05 00 00       	call   5e8 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 77 03 00 00       	call   444 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	push   0xc(%ebp)
  d3:	ff 75 e8             	push   -0x18(%ebp)
  d6:	ff 75 ec             	push   -0x14(%ebp)
  d9:	ff 75 f0             	push   -0x10(%ebp)
  dc:	68 b5 09 00 00       	push   $0x9b5
  e1:	6a 01                	push   $0x1
  e3:	e8 00 05 00 00       	call   5e8 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	push   -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 c2 09 00 00       	push   $0x9c2
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 26 03 00 00       	call   444 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 3e 03 00 00       	call   484 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 c3 09 00 00       	push   $0x9c3
 16c:	6a 01                	push   $0x1
 16e:	e8 75 04 00 00       	call   5e8 <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 c9 02 00 00       	call   444 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	push   -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	push   -0x10(%ebp)
 1a1:	e8 c6 02 00 00       	call   46c <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
  }
  exit();
 1b8:	e8 87 02 00 00       	call   444 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f3:	8d 42 01             	lea    0x1(%edx),%eax
 1f6:	89 45 0c             	mov    %eax,0xc(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	8d 48 01             	lea    0x1(%eax),%ecx
 1ff:	89 4d 08             	mov    %ecx,0x8(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c8             	movzbl %al,%ecx
 24c:	89 d0                	mov    %edx,%eax
 24e:	29 c8                	sub    %ecx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	push   0xc(%ebp)
 283:	ff 75 08             	push   0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	38 45 fc             	cmp    %al,-0x4(%ebp)
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 77 01 00 00       	call   45c <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	39 45 0c             	cmp    %eax,0xc(%ebp)
 320:	7f b3                	jg     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
      break;
 324:	90                   	nop
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	push   0x8(%ebp)
 343:	e8 3c 01 00 00       	call   484 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	push   0xc(%ebp)
 361:	ff 75 f4             	push   -0xc(%ebp)
 364:	e8 33 01 00 00       	call   49c <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	push   -0xc(%ebp)
 375:	e8 f2 00 00 00       	call   46c <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38f:	eb 25                	jmp    3b6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	89 d0                	mov    %edx,%eax
 396:	c1 e0 02             	shl    $0x2,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	01 c0                	add    %eax,%eax
 39d:	89 c1                	mov    %eax,%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoi+0x48>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 39                	cmp    $0x39,%al
 3c8:	7e c7                	jle    391 <atoi+0xf>
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e1:	eb 17                	jmp    3fa <memmove+0x2b>
    *dst++ = *src++;
 3e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3e6:	8d 42 01             	lea    0x1(%edx),%eax
 3e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 3ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ef:	8d 48 01             	lea    0x1(%eax),%ecx
 3f2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 3f5:	0f b6 12             	movzbl (%edx),%edx
 3f8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 3fa:	8b 45 10             	mov    0x10(%ebp),%eax
 3fd:	8d 50 ff             	lea    -0x1(%eax),%edx
 400:	89 55 10             	mov    %edx,0x10(%ebp)
 403:	85 c0                	test   %eax,%eax
 405:	7f dc                	jg     3e3 <memmove+0x14>
  return vdst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <restorer>:
 40c:	83 c4 0c             	add    $0xc,%esp
 40f:	5a                   	pop    %edx
 410:	59                   	pop    %ecx
 411:	58                   	pop    %eax
 412:	c3                   	ret    

00000413 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 419:	83 ec 0c             	sub    $0xc,%esp
 41c:	68 0c 04 00 00       	push   $0x40c
 421:	e8 ce 00 00 00       	call   4f4 <signal_restorer>
 426:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 429:	83 ec 08             	sub    $0x8,%esp
 42c:	ff 75 0c             	push   0xc(%ebp)
 42f:	ff 75 08             	push   0x8(%ebp)
 432:	e8 b5 00 00 00       	call   4ec <signal_register>
 437:	83 c4 10             	add    $0x10,%esp
 43a:	c9                   	leave  
 43b:	c3                   	ret    

0000043c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 43c:	b8 01 00 00 00       	mov    $0x1,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <exit>:
SYSCALL(exit)
 444:	b8 02 00 00 00       	mov    $0x2,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <wait>:
SYSCALL(wait)
 44c:	b8 03 00 00 00       	mov    $0x3,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <pipe>:
SYSCALL(pipe)
 454:	b8 04 00 00 00       	mov    $0x4,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <read>:
SYSCALL(read)
 45c:	b8 05 00 00 00       	mov    $0x5,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <write>:
SYSCALL(write)
 464:	b8 10 00 00 00       	mov    $0x10,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <close>:
SYSCALL(close)
 46c:	b8 15 00 00 00       	mov    $0x15,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <kill>:
SYSCALL(kill)
 474:	b8 06 00 00 00       	mov    $0x6,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <exec>:
SYSCALL(exec)
 47c:	b8 07 00 00 00       	mov    $0x7,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <open>:
SYSCALL(open)
 484:	b8 0f 00 00 00       	mov    $0xf,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <mknod>:
SYSCALL(mknod)
 48c:	b8 11 00 00 00       	mov    $0x11,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <unlink>:
SYSCALL(unlink)
 494:	b8 12 00 00 00       	mov    $0x12,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <fstat>:
SYSCALL(fstat)
 49c:	b8 08 00 00 00       	mov    $0x8,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <link>:
SYSCALL(link)
 4a4:	b8 13 00 00 00       	mov    $0x13,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <mkdir>:
SYSCALL(mkdir)
 4ac:	b8 14 00 00 00       	mov    $0x14,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <chdir>:
SYSCALL(chdir)
 4b4:	b8 09 00 00 00       	mov    $0x9,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <dup>:
SYSCALL(dup)
 4bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <getpid>:
SYSCALL(getpid)
 4c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <sbrk>:
SYSCALL(sbrk)
 4cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <sleep>:
SYSCALL(sleep)
 4d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <uptime>:
SYSCALL(uptime)
 4dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <halt>:
SYSCALL(halt)
 4e4:	b8 16 00 00 00       	mov    $0x16,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <signal_register>:
SYSCALL(signal_register)
 4ec:	b8 17 00 00 00       	mov    $0x17,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <signal_restorer>:
SYSCALL(signal_restorer)
 4f4:	b8 18 00 00 00       	mov    $0x18,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <mprotect>:
SYSCALL(mprotect)
 4fc:	b8 19 00 00 00       	mov    $0x19,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <cowfork>:
SYSCALL(cowfork)
 504:	b8 1a 00 00 00       	mov    $0x1a,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <dsbrk>:
SYSCALL(dsbrk)
 50c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 514:	55                   	push   %ebp
 515:	89 e5                	mov    %esp,%ebp
 517:	83 ec 18             	sub    $0x18,%esp
 51a:	8b 45 0c             	mov    0xc(%ebp),%eax
 51d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 520:	83 ec 04             	sub    $0x4,%esp
 523:	6a 01                	push   $0x1
 525:	8d 45 f4             	lea    -0xc(%ebp),%eax
 528:	50                   	push   %eax
 529:	ff 75 08             	push   0x8(%ebp)
 52c:	e8 33 ff ff ff       	call   464 <write>
 531:	83 c4 10             	add    $0x10,%esp
}
 534:	90                   	nop
 535:	c9                   	leave  
 536:	c3                   	ret    

00000537 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 537:	55                   	push   %ebp
 538:	89 e5                	mov    %esp,%ebp
 53a:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 53d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 544:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 548:	74 17                	je     561 <printint+0x2a>
 54a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 54e:	79 11                	jns    561 <printint+0x2a>
    neg = 1;
 550:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 557:	8b 45 0c             	mov    0xc(%ebp),%eax
 55a:	f7 d8                	neg    %eax
 55c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55f:	eb 06                	jmp    567 <printint+0x30>
  } else {
    x = xx;
 561:	8b 45 0c             	mov    0xc(%ebp),%eax
 564:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 567:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 56e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 571:	8b 45 ec             	mov    -0x14(%ebp),%eax
 574:	ba 00 00 00 00       	mov    $0x0,%edx
 579:	f7 f1                	div    %ecx
 57b:	89 d1                	mov    %edx,%ecx
 57d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 580:	8d 50 01             	lea    0x1(%eax),%edx
 583:	89 55 f4             	mov    %edx,-0xc(%ebp)
 586:	0f b6 91 e0 09 00 00 	movzbl 0x9e0(%ecx),%edx
 58d:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 591:	8b 4d 10             	mov    0x10(%ebp),%ecx
 594:	8b 45 ec             	mov    -0x14(%ebp),%eax
 597:	ba 00 00 00 00       	mov    $0x0,%edx
 59c:	f7 f1                	div    %ecx
 59e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a5:	75 c7                	jne    56e <printint+0x37>
  if(neg)
 5a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ab:	74 2d                	je     5da <printint+0xa3>
    buf[i++] = '-';
 5ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b0:	8d 50 01             	lea    0x1(%eax),%edx
 5b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5bb:	eb 1d                	jmp    5da <printint+0xa3>
    putc(fd, buf[i]);
 5bd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c3:	01 d0                	add    %edx,%eax
 5c5:	0f b6 00             	movzbl (%eax),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	83 ec 08             	sub    $0x8,%esp
 5ce:	50                   	push   %eax
 5cf:	ff 75 08             	push   0x8(%ebp)
 5d2:	e8 3d ff ff ff       	call   514 <putc>
 5d7:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 5da:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e2:	79 d9                	jns    5bd <printint+0x86>
}
 5e4:	90                   	nop
 5e5:	90                   	nop
 5e6:	c9                   	leave  
 5e7:	c3                   	ret    

000005e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f8:	83 c0 04             	add    $0x4,%eax
 5fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 605:	e9 59 01 00 00       	jmp    763 <printf+0x17b>
    c = fmt[i] & 0xff;
 60a:	8b 55 0c             	mov    0xc(%ebp),%edx
 60d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 610:	01 d0                	add    %edx,%eax
 612:	0f b6 00             	movzbl (%eax),%eax
 615:	0f be c0             	movsbl %al,%eax
 618:	25 ff 00 00 00       	and    $0xff,%eax
 61d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 624:	75 2c                	jne    652 <printf+0x6a>
      if(c == '%'){
 626:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62a:	75 0c                	jne    638 <printf+0x50>
        state = '%';
 62c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 633:	e9 27 01 00 00       	jmp    75f <printf+0x177>
      } else {
        putc(fd, c);
 638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	83 ec 08             	sub    $0x8,%esp
 641:	50                   	push   %eax
 642:	ff 75 08             	push   0x8(%ebp)
 645:	e8 ca fe ff ff       	call   514 <putc>
 64a:	83 c4 10             	add    $0x10,%esp
 64d:	e9 0d 01 00 00       	jmp    75f <printf+0x177>
      }
    } else if(state == '%'){
 652:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 656:	0f 85 03 01 00 00    	jne    75f <printf+0x177>
      if(c == 'd'){
 65c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 660:	75 1e                	jne    680 <printf+0x98>
        printint(fd, *ap, 10, 1);
 662:	8b 45 e8             	mov    -0x18(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	6a 01                	push   $0x1
 669:	6a 0a                	push   $0xa
 66b:	50                   	push   %eax
 66c:	ff 75 08             	push   0x8(%ebp)
 66f:	e8 c3 fe ff ff       	call   537 <printint>
 674:	83 c4 10             	add    $0x10,%esp
        ap++;
 677:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67b:	e9 d8 00 00 00       	jmp    758 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 680:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 684:	74 06                	je     68c <printf+0xa4>
 686:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 68a:	75 1e                	jne    6aa <printf+0xc2>
        printint(fd, *ap, 16, 0);
 68c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	6a 00                	push   $0x0
 693:	6a 10                	push   $0x10
 695:	50                   	push   %eax
 696:	ff 75 08             	push   0x8(%ebp)
 699:	e8 99 fe ff ff       	call   537 <printint>
 69e:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a5:	e9 ae 00 00 00       	jmp    758 <printf+0x170>
      } else if(c == 's'){
 6aa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ae:	75 43                	jne    6f3 <printf+0x10b>
        s = (char*)*ap;
 6b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c0:	75 25                	jne    6e7 <printf+0xff>
          s = "(null)";
 6c2:	c7 45 f4 d7 09 00 00 	movl   $0x9d7,-0xc(%ebp)
        while(*s != 0){
 6c9:	eb 1c                	jmp    6e7 <printf+0xff>
          putc(fd, *s);
 6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ce:	0f b6 00             	movzbl (%eax),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	83 ec 08             	sub    $0x8,%esp
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	push   0x8(%ebp)
 6db:	e8 34 fe ff ff       	call   514 <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
          s++;
 6e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	84 c0                	test   %al,%al
 6ef:	75 da                	jne    6cb <printf+0xe3>
 6f1:	eb 65                	jmp    758 <printf+0x170>
        }
      } else if(c == 'c'){
 6f3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f7:	75 1d                	jne    716 <printf+0x12e>
        putc(fd, *ap);
 6f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	0f be c0             	movsbl %al,%eax
 701:	83 ec 08             	sub    $0x8,%esp
 704:	50                   	push   %eax
 705:	ff 75 08             	push   0x8(%ebp)
 708:	e8 07 fe ff ff       	call   514 <putc>
 70d:	83 c4 10             	add    $0x10,%esp
        ap++;
 710:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 714:	eb 42                	jmp    758 <printf+0x170>
      } else if(c == '%'){
 716:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71a:	75 17                	jne    733 <printf+0x14b>
        putc(fd, c);
 71c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	push   0x8(%ebp)
 729:	e8 e6 fd ff ff       	call   514 <putc>
 72e:	83 c4 10             	add    $0x10,%esp
 731:	eb 25                	jmp    758 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 733:	83 ec 08             	sub    $0x8,%esp
 736:	6a 25                	push   $0x25
 738:	ff 75 08             	push   0x8(%ebp)
 73b:	e8 d4 fd ff ff       	call   514 <putc>
 740:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 746:	0f be c0             	movsbl %al,%eax
 749:	83 ec 08             	sub    $0x8,%esp
 74c:	50                   	push   %eax
 74d:	ff 75 08             	push   0x8(%ebp)
 750:	e8 bf fd ff ff       	call   514 <putc>
 755:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 758:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 75f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 763:	8b 55 0c             	mov    0xc(%ebp),%edx
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	01 d0                	add    %edx,%eax
 76b:	0f b6 00             	movzbl (%eax),%eax
 76e:	84 c0                	test   %al,%al
 770:	0f 85 94 fe ff ff    	jne    60a <printf+0x22>
    }
  }
}
 776:	90                   	nop
 777:	90                   	nop
 778:	c9                   	leave  
 779:	c3                   	ret    

0000077a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77a:	55                   	push   %ebp
 77b:	89 e5                	mov    %esp,%ebp
 77d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 780:	8b 45 08             	mov    0x8(%ebp),%eax
 783:	83 e8 08             	sub    $0x8,%eax
 786:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 789:	a1 08 0c 00 00       	mov    0xc08,%eax
 78e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 791:	eb 24                	jmp    7b7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 79b:	72 12                	jb     7af <free+0x35>
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a3:	77 24                	ja     7c9 <free+0x4f>
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7ad:	72 1a                	jb     7c9 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	8b 00                	mov    (%eax),%eax
 7b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bd:	76 d4                	jbe    793 <free+0x19>
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	8b 00                	mov    (%eax),%eax
 7c4:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 7c7:	73 ca                	jae    793 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	01 c2                	add    %eax,%edx
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	8b 00                	mov    (%eax),%eax
 7e0:	39 c2                	cmp    %eax,%edx
 7e2:	75 24                	jne    808 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e7:	8b 50 04             	mov    0x4(%eax),%edx
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	8b 00                	mov    (%eax),%eax
 7ef:	8b 40 04             	mov    0x4(%eax),%eax
 7f2:	01 c2                	add    %eax,%edx
 7f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 00                	mov    (%eax),%eax
 7ff:	8b 10                	mov    (%eax),%edx
 801:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804:	89 10                	mov    %edx,(%eax)
 806:	eb 0a                	jmp    812 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80b:	8b 10                	mov    (%eax),%edx
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 812:	8b 45 fc             	mov    -0x4(%ebp),%eax
 815:	8b 40 04             	mov    0x4(%eax),%eax
 818:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	01 d0                	add    %edx,%eax
 824:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 827:	75 20                	jne    849 <free+0xcf>
    p->s.size += bp->s.size;
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 50 04             	mov    0x4(%eax),%edx
 82f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	01 c2                	add    %eax,%edx
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 83d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 840:	8b 10                	mov    (%eax),%edx
 842:	8b 45 fc             	mov    -0x4(%ebp),%eax
 845:	89 10                	mov    %edx,(%eax)
 847:	eb 08                	jmp    851 <free+0xd7>
  } else
    p->s.ptr = bp;
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84f:	89 10                	mov    %edx,(%eax)
  freep = p;
 851:	8b 45 fc             	mov    -0x4(%ebp),%eax
 854:	a3 08 0c 00 00       	mov    %eax,0xc08
}
 859:	90                   	nop
 85a:	c9                   	leave  
 85b:	c3                   	ret    

0000085c <morecore>:

static Header*
morecore(uint nu)
{
 85c:	55                   	push   %ebp
 85d:	89 e5                	mov    %esp,%ebp
 85f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 862:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 869:	77 07                	ja     872 <morecore+0x16>
    nu = 4096;
 86b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 872:	8b 45 08             	mov    0x8(%ebp),%eax
 875:	c1 e0 03             	shl    $0x3,%eax
 878:	83 ec 0c             	sub    $0xc,%esp
 87b:	50                   	push   %eax
 87c:	e8 4b fc ff ff       	call   4cc <sbrk>
 881:	83 c4 10             	add    $0x10,%esp
 884:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 887:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 88b:	75 07                	jne    894 <morecore+0x38>
    return 0;
 88d:	b8 00 00 00 00       	mov    $0x0,%eax
 892:	eb 26                	jmp    8ba <morecore+0x5e>
  hp = (Header*)p;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	8b 55 08             	mov    0x8(%ebp),%edx
 8a0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a6:	83 c0 08             	add    $0x8,%eax
 8a9:	83 ec 0c             	sub    $0xc,%esp
 8ac:	50                   	push   %eax
 8ad:	e8 c8 fe ff ff       	call   77a <free>
 8b2:	83 c4 10             	add    $0x10,%esp
  return freep;
 8b5:	a1 08 0c 00 00       	mov    0xc08,%eax
}
 8ba:	c9                   	leave  
 8bb:	c3                   	ret    

000008bc <malloc>:

void*
malloc(uint nbytes)
{
 8bc:	55                   	push   %ebp
 8bd:	89 e5                	mov    %esp,%ebp
 8bf:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c2:	8b 45 08             	mov    0x8(%ebp),%eax
 8c5:	83 c0 07             	add    $0x7,%eax
 8c8:	c1 e8 03             	shr    $0x3,%eax
 8cb:	83 c0 01             	add    $0x1,%eax
 8ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d1:	a1 08 0c 00 00       	mov    0xc08,%eax
 8d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8dd:	75 23                	jne    902 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8df:	c7 45 f0 00 0c 00 00 	movl   $0xc00,-0x10(%ebp)
 8e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e9:	a3 08 0c 00 00       	mov    %eax,0xc08
 8ee:	a1 08 0c 00 00       	mov    0xc08,%eax
 8f3:	a3 00 0c 00 00       	mov    %eax,0xc00
    base.s.size = 0;
 8f8:	c7 05 04 0c 00 00 00 	movl   $0x0,0xc04
 8ff:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 902:	8b 45 f0             	mov    -0x10(%ebp),%eax
 905:	8b 00                	mov    (%eax),%eax
 907:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 40 04             	mov    0x4(%eax),%eax
 910:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 913:	77 4d                	ja     962 <malloc+0xa6>
      if(p->s.size == nunits)
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	8b 40 04             	mov    0x4(%eax),%eax
 91b:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 91e:	75 0c                	jne    92c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 10                	mov    (%eax),%edx
 925:	8b 45 f0             	mov    -0x10(%ebp),%eax
 928:	89 10                	mov    %edx,(%eax)
 92a:	eb 26                	jmp    952 <malloc+0x96>
      else {
        p->s.size -= nunits;
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	8b 40 04             	mov    0x4(%eax),%eax
 932:	2b 45 ec             	sub    -0x14(%ebp),%eax
 935:	89 c2                	mov    %eax,%edx
 937:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	8b 40 04             	mov    0x4(%eax),%eax
 943:	c1 e0 03             	shl    $0x3,%eax
 946:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 94f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 952:	8b 45 f0             	mov    -0x10(%ebp),%eax
 955:	a3 08 0c 00 00       	mov    %eax,0xc08
      return (void*)(p + 1);
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	83 c0 08             	add    $0x8,%eax
 960:	eb 3b                	jmp    99d <malloc+0xe1>
    }
    if(p == freep)
 962:	a1 08 0c 00 00       	mov    0xc08,%eax
 967:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 96a:	75 1e                	jne    98a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 96c:	83 ec 0c             	sub    $0xc,%esp
 96f:	ff 75 ec             	push   -0x14(%ebp)
 972:	e8 e5 fe ff ff       	call   85c <morecore>
 977:	83 c4 10             	add    $0x10,%esp
 97a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 97d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 981:	75 07                	jne    98a <malloc+0xce>
        return 0;
 983:	b8 00 00 00 00       	mov    $0x0,%eax
 988:	eb 13                	jmp    99d <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	8b 00                	mov    (%eax),%eax
 995:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 998:	e9 6d ff ff ff       	jmp    90a <malloc+0x4e>
  }
}
 99d:	c9                   	leave  
 99e:	c3                   	ret    
