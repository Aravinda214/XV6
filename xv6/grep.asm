
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 a3 00 00 00       	jmp    b5 <grep+0xb5>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 44                	jmp    65 <grep+0x65>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 f0             	push   -0x10(%ebp)
  2d:	ff 75 08             	push   0x8(%ebp)
  30:	e8 91 01 00 00       	call   1c6 <match>
  35:	83 c4 10             	add    $0x10,%esp
  38:	85 c0                	test   %eax,%eax
  3a:	74 20                	je     5c <grep+0x5c>
        *q = '\n';
  3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  3f:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  45:	83 c0 01             	add    $0x1,%eax
  48:	2b 45 f0             	sub    -0x10(%ebp),%eax
  4b:	83 ec 04             	sub    $0x4,%esp
  4e:	50                   	push   %eax
  4f:	ff 75 f0             	push   -0x10(%ebp)
  52:	6a 01                	push   $0x1
  54:	e8 70 05 00 00       	call   5c9 <write>
  59:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  5f:	83 c0 01             	add    $0x1,%eax
  62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  65:	83 ec 08             	sub    $0x8,%esp
  68:	6a 0a                	push   $0xa
  6a:	ff 75 f0             	push   -0x10(%ebp)
  6d:	e8 86 03 00 00       	call   3f8 <strchr>
  72:	83 c4 10             	add    $0x10,%esp
  75:	89 45 e8             	mov    %eax,-0x18(%ebp)
  78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  7c:	75 a3                	jne    21 <grep+0x21>
    }
    if(p == buf)
  7e:	81 7d f0 60 0b 00 00 	cmpl   $0xb60,-0x10(%ebp)
  85:	75 07                	jne    8e <grep+0x8e>
      m = 0;
  87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  92:	7e 21                	jle    b5 <grep+0xb5>
      m -= p - buf;
  94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  97:	2d 60 0b 00 00       	sub    $0xb60,%eax
  9c:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	ff 75 f4             	push   -0xc(%ebp)
  a5:	ff 75 f0             	push   -0x10(%ebp)
  a8:	68 60 0b 00 00       	push   $0xb60
  ad:	e8 82 04 00 00       	call   534 <memmove>
  b2:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  b8:	b8 00 04 00 00       	mov    $0x400,%eax
  bd:	29 d0                	sub    %edx,%eax
  bf:	89 c2                	mov    %eax,%edx
  c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c4:	05 60 0b 00 00       	add    $0xb60,%eax
  c9:	83 ec 04             	sub    $0x4,%esp
  cc:	52                   	push   %edx
  cd:	50                   	push   %eax
  ce:	ff 75 0c             	push   0xc(%ebp)
  d1:	e8 eb 04 00 00       	call   5c1 <read>
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  e0:	0f 8f 2c ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
  e6:	90                   	nop
  e7:	90                   	nop
  e8:	c9                   	leave  
  e9:	c3                   	ret    

000000ea <main>:

int
main(int argc, char *argv[])
{
  ea:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  ee:	83 e4 f0             	and    $0xfffffff0,%esp
  f1:	ff 71 fc             	push   -0x4(%ecx)
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	53                   	push   %ebx
  f8:	51                   	push   %ecx
  f9:	83 ec 10             	sub    $0x10,%esp
  fc:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
  fe:	83 3b 01             	cmpl   $0x1,(%ebx)
 101:	7f 17                	jg     11a <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 103:	83 ec 08             	sub    $0x8,%esp
 106:	68 04 0b 00 00       	push   $0xb04
 10b:	6a 02                	push   $0x2
 10d:	e8 3b 06 00 00       	call   74d <printf>
 112:	83 c4 10             	add    $0x10,%esp
    exit();
 115:	e8 8f 04 00 00       	call   5a9 <exit>
  }
  pattern = argv[1];
 11a:	8b 43 04             	mov    0x4(%ebx),%eax
 11d:	8b 40 04             	mov    0x4(%eax),%eax
 120:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 123:	83 3b 02             	cmpl   $0x2,(%ebx)
 126:	7f 15                	jg     13d <main+0x53>
    grep(pattern, 0);
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	6a 00                	push   $0x0
 12d:	ff 75 f0             	push   -0x10(%ebp)
 130:	e8 cb fe ff ff       	call   0 <grep>
 135:	83 c4 10             	add    $0x10,%esp
    exit();
 138:	e8 6c 04 00 00       	call   5a9 <exit>
  }

  for(i = 2; i < argc; i++){
 13d:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 144:	eb 74                	jmp    1ba <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 146:	8b 45 f4             	mov    -0xc(%ebp),%eax
 149:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 150:	8b 43 04             	mov    0x4(%ebx),%eax
 153:	01 d0                	add    %edx,%eax
 155:	8b 00                	mov    (%eax),%eax
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	6a 00                	push   $0x0
 15c:	50                   	push   %eax
 15d:	e8 87 04 00 00       	call   5e9 <open>
 162:	83 c4 10             	add    $0x10,%esp
 165:	89 45 ec             	mov    %eax,-0x14(%ebp)
 168:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 16c:	79 29                	jns    197 <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 16e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 178:	8b 43 04             	mov    0x4(%ebx),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	8b 00                	mov    (%eax),%eax
 17f:	83 ec 04             	sub    $0x4,%esp
 182:	50                   	push   %eax
 183:	68 24 0b 00 00       	push   $0xb24
 188:	6a 01                	push   $0x1
 18a:	e8 be 05 00 00       	call   74d <printf>
 18f:	83 c4 10             	add    $0x10,%esp
      exit();
 192:	e8 12 04 00 00       	call   5a9 <exit>
    }
    grep(pattern, fd);
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	ff 75 ec             	push   -0x14(%ebp)
 19d:	ff 75 f0             	push   -0x10(%ebp)
 1a0:	e8 5b fe ff ff       	call   0 <grep>
 1a5:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1a8:	83 ec 0c             	sub    $0xc,%esp
 1ab:	ff 75 ec             	push   -0x14(%ebp)
 1ae:	e8 1e 04 00 00       	call   5d1 <close>
 1b3:	83 c4 10             	add    $0x10,%esp
  for(i = 2; i < argc; i++){
 1b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1bd:	3b 03                	cmp    (%ebx),%eax
 1bf:	7c 85                	jl     146 <main+0x5c>
  }
  exit();
 1c1:	e8 e3 03 00 00       	call   5a9 <exit>

000001c6 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	0f b6 00             	movzbl (%eax),%eax
 1d2:	3c 5e                	cmp    $0x5e,%al
 1d4:	75 17                	jne    1ed <match+0x27>
    return matchhere(re+1, text);
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	83 c0 01             	add    $0x1,%eax
 1dc:	83 ec 08             	sub    $0x8,%esp
 1df:	ff 75 0c             	push   0xc(%ebp)
 1e2:	50                   	push   %eax
 1e3:	e8 38 00 00 00       	call   220 <matchhere>
 1e8:	83 c4 10             	add    $0x10,%esp
 1eb:	eb 31                	jmp    21e <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 1ed:	83 ec 08             	sub    $0x8,%esp
 1f0:	ff 75 0c             	push   0xc(%ebp)
 1f3:	ff 75 08             	push   0x8(%ebp)
 1f6:	e8 25 00 00 00       	call   220 <matchhere>
 1fb:	83 c4 10             	add    $0x10,%esp
 1fe:	85 c0                	test   %eax,%eax
 200:	74 07                	je     209 <match+0x43>
      return 1;
 202:	b8 01 00 00 00       	mov    $0x1,%eax
 207:	eb 15                	jmp    21e <match+0x58>
  }while(*text++ != '\0');
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	8d 50 01             	lea    0x1(%eax),%edx
 20f:	89 55 0c             	mov    %edx,0xc(%ebp)
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	84 c0                	test   %al,%al
 217:	75 d4                	jne    1ed <match+0x27>
  return 0;
 219:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	0f b6 00             	movzbl (%eax),%eax
 22c:	84 c0                	test   %al,%al
 22e:	75 0a                	jne    23a <matchhere+0x1a>
    return 1;
 230:	b8 01 00 00 00       	mov    $0x1,%eax
 235:	e9 99 00 00 00       	jmp    2d3 <matchhere+0xb3>
  if(re[1] == '*')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	83 c0 01             	add    $0x1,%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	3c 2a                	cmp    $0x2a,%al
 245:	75 21                	jne    268 <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 02             	lea    0x2(%eax),%edx
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	83 ec 04             	sub    $0x4,%esp
 259:	ff 75 0c             	push   0xc(%ebp)
 25c:	52                   	push   %edx
 25d:	50                   	push   %eax
 25e:	e8 72 00 00 00       	call   2d5 <matchstar>
 263:	83 c4 10             	add    $0x10,%esp
 266:	eb 6b                	jmp    2d3 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 24                	cmp    $0x24,%al
 270:	75 1d                	jne    28f <matchhere+0x6f>
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	83 c0 01             	add    $0x1,%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	84 c0                	test   %al,%al
 27d:	75 10                	jne    28f <matchhere+0x6f>
    return *text == '\0';
 27f:	8b 45 0c             	mov    0xc(%ebp),%eax
 282:	0f b6 00             	movzbl (%eax),%eax
 285:	84 c0                	test   %al,%al
 287:	0f 94 c0             	sete   %al
 28a:	0f b6 c0             	movzbl %al,%eax
 28d:	eb 44                	jmp    2d3 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	0f b6 00             	movzbl (%eax),%eax
 295:	84 c0                	test   %al,%al
 297:	74 35                	je     2ce <matchhere+0xae>
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	3c 2e                	cmp    $0x2e,%al
 2a1:	74 10                	je     2b3 <matchhere+0x93>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 10             	movzbl (%eax),%edx
 2a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	38 c2                	cmp    %al,%dl
 2b1:	75 1b                	jne    2ce <matchhere+0xae>
    return matchhere(re+1, text+1);
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	8d 50 01             	lea    0x1(%eax),%edx
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	83 c0 01             	add    $0x1,%eax
 2bf:	83 ec 08             	sub    $0x8,%esp
 2c2:	52                   	push   %edx
 2c3:	50                   	push   %eax
 2c4:	e8 57 ff ff ff       	call   220 <matchhere>
 2c9:	83 c4 10             	add    $0x10,%esp
 2cc:	eb 05                	jmp    2d3 <matchhere+0xb3>
  return 0;
 2ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2db:	83 ec 08             	sub    $0x8,%esp
 2de:	ff 75 10             	push   0x10(%ebp)
 2e1:	ff 75 0c             	push   0xc(%ebp)
 2e4:	e8 37 ff ff ff       	call   220 <matchhere>
 2e9:	83 c4 10             	add    $0x10,%esp
 2ec:	85 c0                	test   %eax,%eax
 2ee:	74 07                	je     2f7 <matchstar+0x22>
      return 1;
 2f0:	b8 01 00 00 00       	mov    $0x1,%eax
 2f5:	eb 29                	jmp    320 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 2f7:	8b 45 10             	mov    0x10(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	84 c0                	test   %al,%al
 2ff:	74 1a                	je     31b <matchstar+0x46>
 301:	8b 45 10             	mov    0x10(%ebp),%eax
 304:	8d 50 01             	lea    0x1(%eax),%edx
 307:	89 55 10             	mov    %edx,0x10(%ebp)
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	0f be c0             	movsbl %al,%eax
 310:	39 45 08             	cmp    %eax,0x8(%ebp)
 313:	74 c6                	je     2db <matchstar+0x6>
 315:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 319:	74 c0                	je     2db <matchstar+0x6>
  return 0;
 31b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	57                   	push   %edi
 326:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 327:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32a:	8b 55 10             	mov    0x10(%ebp),%edx
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 cb                	mov    %ecx,%ebx
 332:	89 df                	mov    %ebx,%edi
 334:	89 d1                	mov    %edx,%ecx
 336:	fc                   	cld    
 337:	f3 aa                	rep stos %al,%es:(%edi)
 339:	89 ca                	mov    %ecx,%edx
 33b:	89 fb                	mov    %edi,%ebx
 33d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 340:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 343:	90                   	nop
 344:	5b                   	pop    %ebx
 345:	5f                   	pop    %edi
 346:	5d                   	pop    %ebp
 347:	c3                   	ret    

00000348 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 354:	90                   	nop
 355:	8b 55 0c             	mov    0xc(%ebp),%edx
 358:	8d 42 01             	lea    0x1(%edx),%eax
 35b:	89 45 0c             	mov    %eax,0xc(%ebp)
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	8d 48 01             	lea    0x1(%eax),%ecx
 364:	89 4d 08             	mov    %ecx,0x8(%ebp)
 367:	0f b6 12             	movzbl (%edx),%edx
 36a:	88 10                	mov    %dl,(%eax)
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	84 c0                	test   %al,%al
 371:	75 e2                	jne    355 <strcpy+0xd>
    ;
  return os;
 373:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 376:	c9                   	leave  
 377:	c3                   	ret    

00000378 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 37b:	eb 08                	jmp    385 <strcmp+0xd>
    p++, q++;
 37d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 381:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	84 c0                	test   %al,%al
 38d:	74 10                	je     39f <strcmp+0x27>
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	0f b6 10             	movzbl (%eax),%edx
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	38 c2                	cmp    %al,%dl
 39d:	74 de                	je     37d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	0f b6 d0             	movzbl %al,%edx
 3a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	0f b6 c8             	movzbl %al,%ecx
 3b1:	89 d0                	mov    %edx,%eax
 3b3:	29 c8                	sub    %ecx,%eax
}
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    

000003b7 <strlen>:

uint
strlen(char *s)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3c4:	eb 04                	jmp    3ca <strlen+0x13>
 3c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	01 d0                	add    %edx,%eax
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	84 c0                	test   %al,%al
 3d7:	75 ed                	jne    3c6 <strlen+0xf>
    ;
  return n;
 3d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <memset>:

void*
memset(void *dst, int c, uint n)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3e1:	8b 45 10             	mov    0x10(%ebp),%eax
 3e4:	50                   	push   %eax
 3e5:	ff 75 0c             	push   0xc(%ebp)
 3e8:	ff 75 08             	push   0x8(%ebp)
 3eb:	e8 32 ff ff ff       	call   322 <stosb>
 3f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f6:	c9                   	leave  
 3f7:	c3                   	ret    

000003f8 <strchr>:

char*
strchr(const char *s, char c)
{
 3f8:	55                   	push   %ebp
 3f9:	89 e5                	mov    %esp,%ebp
 3fb:	83 ec 04             	sub    $0x4,%esp
 3fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 401:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 404:	eb 14                	jmp    41a <strchr+0x22>
    if(*s == c)
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 40f:	75 05                	jne    416 <strchr+0x1e>
      return (char*)s;
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	eb 13                	jmp    429 <strchr+0x31>
  for(; *s; s++)
 416:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	84 c0                	test   %al,%al
 422:	75 e2                	jne    406 <strchr+0xe>
  return 0;
 424:	b8 00 00 00 00       	mov    $0x0,%eax
}
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <gets>:

char*
gets(char *buf, int max)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
 42e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 431:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 438:	eb 42                	jmp    47c <gets+0x51>
    cc = read(0, &c, 1);
 43a:	83 ec 04             	sub    $0x4,%esp
 43d:	6a 01                	push   $0x1
 43f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 442:	50                   	push   %eax
 443:	6a 00                	push   $0x0
 445:	e8 77 01 00 00       	call   5c1 <read>
 44a:	83 c4 10             	add    $0x10,%esp
 44d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 450:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 454:	7e 33                	jle    489 <gets+0x5e>
      break;
    buf[i++] = c;
 456:	8b 45 f4             	mov    -0xc(%ebp),%eax
 459:	8d 50 01             	lea    0x1(%eax),%edx
 45c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45f:	89 c2                	mov    %eax,%edx
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	01 c2                	add    %eax,%edx
 466:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 46a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 46c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 470:	3c 0a                	cmp    $0xa,%al
 472:	74 16                	je     48a <gets+0x5f>
 474:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 478:	3c 0d                	cmp    $0xd,%al
 47a:	74 0e                	je     48a <gets+0x5f>
  for(i=0; i+1 < max; ){
 47c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47f:	83 c0 01             	add    $0x1,%eax
 482:	39 45 0c             	cmp    %eax,0xc(%ebp)
 485:	7f b3                	jg     43a <gets+0xf>
 487:	eb 01                	jmp    48a <gets+0x5f>
      break;
 489:	90                   	nop
      break;
  }
  buf[i] = '\0';
 48a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	01 d0                	add    %edx,%eax
 492:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 495:	8b 45 08             	mov    0x8(%ebp),%eax
}
 498:	c9                   	leave  
 499:	c3                   	ret    

0000049a <stat>:

int
stat(char *n, struct stat *st)
{
 49a:	55                   	push   %ebp
 49b:	89 e5                	mov    %esp,%ebp
 49d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a0:	83 ec 08             	sub    $0x8,%esp
 4a3:	6a 00                	push   $0x0
 4a5:	ff 75 08             	push   0x8(%ebp)
 4a8:	e8 3c 01 00 00       	call   5e9 <open>
 4ad:	83 c4 10             	add    $0x10,%esp
 4b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4b7:	79 07                	jns    4c0 <stat+0x26>
    return -1;
 4b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4be:	eb 25                	jmp    4e5 <stat+0x4b>
  r = fstat(fd, st);
 4c0:	83 ec 08             	sub    $0x8,%esp
 4c3:	ff 75 0c             	push   0xc(%ebp)
 4c6:	ff 75 f4             	push   -0xc(%ebp)
 4c9:	e8 33 01 00 00       	call   601 <fstat>
 4ce:	83 c4 10             	add    $0x10,%esp
 4d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4d4:	83 ec 0c             	sub    $0xc,%esp
 4d7:	ff 75 f4             	push   -0xc(%ebp)
 4da:	e8 f2 00 00 00       	call   5d1 <close>
 4df:	83 c4 10             	add    $0x10,%esp
  return r;
 4e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4e5:	c9                   	leave  
 4e6:	c3                   	ret    

000004e7 <atoi>:

int
atoi(const char *s)
{
 4e7:	55                   	push   %ebp
 4e8:	89 e5                	mov    %esp,%ebp
 4ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4f4:	eb 25                	jmp    51b <atoi+0x34>
    n = n*10 + *s++ - '0';
 4f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f9:	89 d0                	mov    %edx,%eax
 4fb:	c1 e0 02             	shl    $0x2,%eax
 4fe:	01 d0                	add    %edx,%eax
 500:	01 c0                	add    %eax,%eax
 502:	89 c1                	mov    %eax,%ecx
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	8d 50 01             	lea    0x1(%eax),%edx
 50a:	89 55 08             	mov    %edx,0x8(%ebp)
 50d:	0f b6 00             	movzbl (%eax),%eax
 510:	0f be c0             	movsbl %al,%eax
 513:	01 c8                	add    %ecx,%eax
 515:	83 e8 30             	sub    $0x30,%eax
 518:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	0f b6 00             	movzbl (%eax),%eax
 521:	3c 2f                	cmp    $0x2f,%al
 523:	7e 0a                	jle    52f <atoi+0x48>
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	0f b6 00             	movzbl (%eax),%eax
 52b:	3c 39                	cmp    $0x39,%al
 52d:	7e c7                	jle    4f6 <atoi+0xf>
  return n;
 52f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 540:	8b 45 0c             	mov    0xc(%ebp),%eax
 543:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 546:	eb 17                	jmp    55f <memmove+0x2b>
    *dst++ = *src++;
 548:	8b 55 f8             	mov    -0x8(%ebp),%edx
 54b:	8d 42 01             	lea    0x1(%edx),%eax
 54e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
 554:	8d 48 01             	lea    0x1(%eax),%ecx
 557:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 55a:	0f b6 12             	movzbl (%edx),%edx
 55d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 55f:	8b 45 10             	mov    0x10(%ebp),%eax
 562:	8d 50 ff             	lea    -0x1(%eax),%edx
 565:	89 55 10             	mov    %edx,0x10(%ebp)
 568:	85 c0                	test   %eax,%eax
 56a:	7f dc                	jg     548 <memmove+0x14>
  return vdst;
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 56f:	c9                   	leave  
 570:	c3                   	ret    

00000571 <restorer>:
 571:	83 c4 0c             	add    $0xc,%esp
 574:	5a                   	pop    %edx
 575:	59                   	pop    %ecx
 576:	58                   	pop    %eax
 577:	c3                   	ret    

00000578 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 57e:	83 ec 0c             	sub    $0xc,%esp
 581:	68 71 05 00 00       	push   $0x571
 586:	e8 ce 00 00 00       	call   659 <signal_restorer>
 58b:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 58e:	83 ec 08             	sub    $0x8,%esp
 591:	ff 75 0c             	push   0xc(%ebp)
 594:	ff 75 08             	push   0x8(%ebp)
 597:	e8 b5 00 00 00       	call   651 <signal_register>
 59c:	83 c4 10             	add    $0x10,%esp
 59f:	c9                   	leave  
 5a0:	c3                   	ret    

000005a1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5a1:	b8 01 00 00 00       	mov    $0x1,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <exit>:
SYSCALL(exit)
 5a9:	b8 02 00 00 00       	mov    $0x2,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <wait>:
SYSCALL(wait)
 5b1:	b8 03 00 00 00       	mov    $0x3,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <pipe>:
SYSCALL(pipe)
 5b9:	b8 04 00 00 00       	mov    $0x4,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <read>:
SYSCALL(read)
 5c1:	b8 05 00 00 00       	mov    $0x5,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <write>:
SYSCALL(write)
 5c9:	b8 10 00 00 00       	mov    $0x10,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <close>:
SYSCALL(close)
 5d1:	b8 15 00 00 00       	mov    $0x15,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <kill>:
SYSCALL(kill)
 5d9:	b8 06 00 00 00       	mov    $0x6,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <exec>:
SYSCALL(exec)
 5e1:	b8 07 00 00 00       	mov    $0x7,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <open>:
SYSCALL(open)
 5e9:	b8 0f 00 00 00       	mov    $0xf,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <mknod>:
SYSCALL(mknod)
 5f1:	b8 11 00 00 00       	mov    $0x11,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <unlink>:
SYSCALL(unlink)
 5f9:	b8 12 00 00 00       	mov    $0x12,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <fstat>:
SYSCALL(fstat)
 601:	b8 08 00 00 00       	mov    $0x8,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <link>:
SYSCALL(link)
 609:	b8 13 00 00 00       	mov    $0x13,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <mkdir>:
SYSCALL(mkdir)
 611:	b8 14 00 00 00       	mov    $0x14,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <chdir>:
SYSCALL(chdir)
 619:	b8 09 00 00 00       	mov    $0x9,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <dup>:
SYSCALL(dup)
 621:	b8 0a 00 00 00       	mov    $0xa,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <getpid>:
SYSCALL(getpid)
 629:	b8 0b 00 00 00       	mov    $0xb,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <sbrk>:
SYSCALL(sbrk)
 631:	b8 0c 00 00 00       	mov    $0xc,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <sleep>:
SYSCALL(sleep)
 639:	b8 0d 00 00 00       	mov    $0xd,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <uptime>:
SYSCALL(uptime)
 641:	b8 0e 00 00 00       	mov    $0xe,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <halt>:
SYSCALL(halt)
 649:	b8 16 00 00 00       	mov    $0x16,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <signal_register>:
SYSCALL(signal_register)
 651:	b8 17 00 00 00       	mov    $0x17,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <signal_restorer>:
SYSCALL(signal_restorer)
 659:	b8 18 00 00 00       	mov    $0x18,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <mprotect>:
SYSCALL(mprotect)
 661:	b8 19 00 00 00       	mov    $0x19,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <cowfork>:
SYSCALL(cowfork)
 669:	b8 1a 00 00 00       	mov    $0x1a,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <dsbrk>:
SYSCALL(dsbrk)
 671:	b8 1b 00 00 00       	mov    $0x1b,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 679:	55                   	push   %ebp
 67a:	89 e5                	mov    %esp,%ebp
 67c:	83 ec 18             	sub    $0x18,%esp
 67f:	8b 45 0c             	mov    0xc(%ebp),%eax
 682:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 685:	83 ec 04             	sub    $0x4,%esp
 688:	6a 01                	push   $0x1
 68a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 68d:	50                   	push   %eax
 68e:	ff 75 08             	push   0x8(%ebp)
 691:	e8 33 ff ff ff       	call   5c9 <write>
 696:	83 c4 10             	add    $0x10,%esp
}
 699:	90                   	nop
 69a:	c9                   	leave  
 69b:	c3                   	ret    

0000069c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6a9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6ad:	74 17                	je     6c6 <printint+0x2a>
 6af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6b3:	79 11                	jns    6c6 <printint+0x2a>
    neg = 1;
 6b5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bf:	f7 d8                	neg    %eax
 6c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c4:	eb 06                	jmp    6cc <printint+0x30>
  } else {
    x = xx;
 6c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6d9:	ba 00 00 00 00       	mov    $0x0,%edx
 6de:	f7 f1                	div    %ecx
 6e0:	89 d1                	mov    %edx,%ecx
 6e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e5:	8d 50 01             	lea    0x1(%eax),%edx
 6e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6eb:	0f b6 91 44 0b 00 00 	movzbl 0xb44(%ecx),%edx
 6f2:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6fc:	ba 00 00 00 00       	mov    $0x0,%edx
 701:	f7 f1                	div    %ecx
 703:	89 45 ec             	mov    %eax,-0x14(%ebp)
 706:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 70a:	75 c7                	jne    6d3 <printint+0x37>
  if(neg)
 70c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 710:	74 2d                	je     73f <printint+0xa3>
    buf[i++] = '-';
 712:	8b 45 f4             	mov    -0xc(%ebp),%eax
 715:	8d 50 01             	lea    0x1(%eax),%edx
 718:	89 55 f4             	mov    %edx,-0xc(%ebp)
 71b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 720:	eb 1d                	jmp    73f <printint+0xa3>
    putc(fd, buf[i]);
 722:	8d 55 dc             	lea    -0x24(%ebp),%edx
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	01 d0                	add    %edx,%eax
 72a:	0f b6 00             	movzbl (%eax),%eax
 72d:	0f be c0             	movsbl %al,%eax
 730:	83 ec 08             	sub    $0x8,%esp
 733:	50                   	push   %eax
 734:	ff 75 08             	push   0x8(%ebp)
 737:	e8 3d ff ff ff       	call   679 <putc>
 73c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 73f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 747:	79 d9                	jns    722 <printint+0x86>
}
 749:	90                   	nop
 74a:	90                   	nop
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 753:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 75a:	8d 45 0c             	lea    0xc(%ebp),%eax
 75d:	83 c0 04             	add    $0x4,%eax
 760:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 76a:	e9 59 01 00 00       	jmp    8c8 <printf+0x17b>
    c = fmt[i] & 0xff;
 76f:	8b 55 0c             	mov    0xc(%ebp),%edx
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	01 d0                	add    %edx,%eax
 777:	0f b6 00             	movzbl (%eax),%eax
 77a:	0f be c0             	movsbl %al,%eax
 77d:	25 ff 00 00 00       	and    $0xff,%eax
 782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 785:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 789:	75 2c                	jne    7b7 <printf+0x6a>
      if(c == '%'){
 78b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 78f:	75 0c                	jne    79d <printf+0x50>
        state = '%';
 791:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 798:	e9 27 01 00 00       	jmp    8c4 <printf+0x177>
      } else {
        putc(fd, c);
 79d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a0:	0f be c0             	movsbl %al,%eax
 7a3:	83 ec 08             	sub    $0x8,%esp
 7a6:	50                   	push   %eax
 7a7:	ff 75 08             	push   0x8(%ebp)
 7aa:	e8 ca fe ff ff       	call   679 <putc>
 7af:	83 c4 10             	add    $0x10,%esp
 7b2:	e9 0d 01 00 00       	jmp    8c4 <printf+0x177>
      }
    } else if(state == '%'){
 7b7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7bb:	0f 85 03 01 00 00    	jne    8c4 <printf+0x177>
      if(c == 'd'){
 7c1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7c5:	75 1e                	jne    7e5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	6a 01                	push   $0x1
 7ce:	6a 0a                	push   $0xa
 7d0:	50                   	push   %eax
 7d1:	ff 75 08             	push   0x8(%ebp)
 7d4:	e8 c3 fe ff ff       	call   69c <printint>
 7d9:	83 c4 10             	add    $0x10,%esp
        ap++;
 7dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e0:	e9 d8 00 00 00       	jmp    8bd <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7e5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7e9:	74 06                	je     7f1 <printf+0xa4>
 7eb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ef:	75 1e                	jne    80f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	6a 00                	push   $0x0
 7f8:	6a 10                	push   $0x10
 7fa:	50                   	push   %eax
 7fb:	ff 75 08             	push   0x8(%ebp)
 7fe:	e8 99 fe ff ff       	call   69c <printint>
 803:	83 c4 10             	add    $0x10,%esp
        ap++;
 806:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80a:	e9 ae 00 00 00       	jmp    8bd <printf+0x170>
      } else if(c == 's'){
 80f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 813:	75 43                	jne    858 <printf+0x10b>
        s = (char*)*ap;
 815:	8b 45 e8             	mov    -0x18(%ebp),%eax
 818:	8b 00                	mov    (%eax),%eax
 81a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 81d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 825:	75 25                	jne    84c <printf+0xff>
          s = "(null)";
 827:	c7 45 f4 3a 0b 00 00 	movl   $0xb3a,-0xc(%ebp)
        while(*s != 0){
 82e:	eb 1c                	jmp    84c <printf+0xff>
          putc(fd, *s);
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	0f b6 00             	movzbl (%eax),%eax
 836:	0f be c0             	movsbl %al,%eax
 839:	83 ec 08             	sub    $0x8,%esp
 83c:	50                   	push   %eax
 83d:	ff 75 08             	push   0x8(%ebp)
 840:	e8 34 fe ff ff       	call   679 <putc>
 845:	83 c4 10             	add    $0x10,%esp
          s++;
 848:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	0f b6 00             	movzbl (%eax),%eax
 852:	84 c0                	test   %al,%al
 854:	75 da                	jne    830 <printf+0xe3>
 856:	eb 65                	jmp    8bd <printf+0x170>
        }
      } else if(c == 'c'){
 858:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 85c:	75 1d                	jne    87b <printf+0x12e>
        putc(fd, *ap);
 85e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 861:	8b 00                	mov    (%eax),%eax
 863:	0f be c0             	movsbl %al,%eax
 866:	83 ec 08             	sub    $0x8,%esp
 869:	50                   	push   %eax
 86a:	ff 75 08             	push   0x8(%ebp)
 86d:	e8 07 fe ff ff       	call   679 <putc>
 872:	83 c4 10             	add    $0x10,%esp
        ap++;
 875:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 879:	eb 42                	jmp    8bd <printf+0x170>
      } else if(c == '%'){
 87b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 87f:	75 17                	jne    898 <printf+0x14b>
        putc(fd, c);
 881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 884:	0f be c0             	movsbl %al,%eax
 887:	83 ec 08             	sub    $0x8,%esp
 88a:	50                   	push   %eax
 88b:	ff 75 08             	push   0x8(%ebp)
 88e:	e8 e6 fd ff ff       	call   679 <putc>
 893:	83 c4 10             	add    $0x10,%esp
 896:	eb 25                	jmp    8bd <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 898:	83 ec 08             	sub    $0x8,%esp
 89b:	6a 25                	push   $0x25
 89d:	ff 75 08             	push   0x8(%ebp)
 8a0:	e8 d4 fd ff ff       	call   679 <putc>
 8a5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8ab:	0f be c0             	movsbl %al,%eax
 8ae:	83 ec 08             	sub    $0x8,%esp
 8b1:	50                   	push   %eax
 8b2:	ff 75 08             	push   0x8(%ebp)
 8b5:	e8 bf fd ff ff       	call   679 <putc>
 8ba:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8c4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 8cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ce:	01 d0                	add    %edx,%eax
 8d0:	0f b6 00             	movzbl (%eax),%eax
 8d3:	84 c0                	test   %al,%al
 8d5:	0f 85 94 fe ff ff    	jne    76f <printf+0x22>
    }
  }
}
 8db:	90                   	nop
 8dc:	90                   	nop
 8dd:	c9                   	leave  
 8de:	c3                   	ret    

000008df <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8df:	55                   	push   %ebp
 8e0:	89 e5                	mov    %esp,%ebp
 8e2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e5:	8b 45 08             	mov    0x8(%ebp),%eax
 8e8:	83 e8 08             	sub    $0x8,%eax
 8eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	a1 68 0f 00 00       	mov    0xf68,%eax
 8f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f6:	eb 24                	jmp    91c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 900:	72 12                	jb     914 <free+0x35>
 902:	8b 45 f8             	mov    -0x8(%ebp),%eax
 905:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 908:	77 24                	ja     92e <free+0x4f>
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 912:	72 1a                	jb     92e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	8b 00                	mov    (%eax),%eax
 919:	89 45 fc             	mov    %eax,-0x4(%ebp)
 91c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 922:	76 d4                	jbe    8f8 <free+0x19>
 924:	8b 45 fc             	mov    -0x4(%ebp),%eax
 927:	8b 00                	mov    (%eax),%eax
 929:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 92c:	73 ca                	jae    8f8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 92e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 931:	8b 40 04             	mov    0x4(%eax),%eax
 934:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 93b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93e:	01 c2                	add    %eax,%edx
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	39 c2                	cmp    %eax,%edx
 947:	75 24                	jne    96d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 949:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94c:	8b 50 04             	mov    0x4(%eax),%edx
 94f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 952:	8b 00                	mov    (%eax),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	01 c2                	add    %eax,%edx
 959:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 00                	mov    (%eax),%eax
 964:	8b 10                	mov    (%eax),%edx
 966:	8b 45 f8             	mov    -0x8(%ebp),%eax
 969:	89 10                	mov    %edx,(%eax)
 96b:	eb 0a                	jmp    977 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	8b 10                	mov    (%eax),%edx
 972:	8b 45 f8             	mov    -0x8(%ebp),%eax
 975:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 977:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97a:	8b 40 04             	mov    0x4(%eax),%eax
 97d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	01 d0                	add    %edx,%eax
 989:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 98c:	75 20                	jne    9ae <free+0xcf>
    p->s.size += bp->s.size;
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 50 04             	mov    0x4(%eax),%edx
 994:	8b 45 f8             	mov    -0x8(%ebp),%eax
 997:	8b 40 04             	mov    0x4(%eax),%eax
 99a:	01 c2                	add    %eax,%edx
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a5:	8b 10                	mov    (%eax),%edx
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	89 10                	mov    %edx,(%eax)
 9ac:	eb 08                	jmp    9b6 <free+0xd7>
  } else
    p->s.ptr = bp;
 9ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9b4:	89 10                	mov    %edx,(%eax)
  freep = p;
 9b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b9:	a3 68 0f 00 00       	mov    %eax,0xf68
}
 9be:	90                   	nop
 9bf:	c9                   	leave  
 9c0:	c3                   	ret    

000009c1 <morecore>:

static Header*
morecore(uint nu)
{
 9c1:	55                   	push   %ebp
 9c2:	89 e5                	mov    %esp,%ebp
 9c4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9c7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ce:	77 07                	ja     9d7 <morecore+0x16>
    nu = 4096;
 9d0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9d7:	8b 45 08             	mov    0x8(%ebp),%eax
 9da:	c1 e0 03             	shl    $0x3,%eax
 9dd:	83 ec 0c             	sub    $0xc,%esp
 9e0:	50                   	push   %eax
 9e1:	e8 4b fc ff ff       	call   631 <sbrk>
 9e6:	83 c4 10             	add    $0x10,%esp
 9e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9f0:	75 07                	jne    9f9 <morecore+0x38>
    return 0;
 9f2:	b8 00 00 00 00       	mov    $0x0,%eax
 9f7:	eb 26                	jmp    a1f <morecore+0x5e>
  hp = (Header*)p;
 9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a02:	8b 55 08             	mov    0x8(%ebp),%edx
 a05:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0b:	83 c0 08             	add    $0x8,%eax
 a0e:	83 ec 0c             	sub    $0xc,%esp
 a11:	50                   	push   %eax
 a12:	e8 c8 fe ff ff       	call   8df <free>
 a17:	83 c4 10             	add    $0x10,%esp
  return freep;
 a1a:	a1 68 0f 00 00       	mov    0xf68,%eax
}
 a1f:	c9                   	leave  
 a20:	c3                   	ret    

00000a21 <malloc>:

void*
malloc(uint nbytes)
{
 a21:	55                   	push   %ebp
 a22:	89 e5                	mov    %esp,%ebp
 a24:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a27:	8b 45 08             	mov    0x8(%ebp),%eax
 a2a:	83 c0 07             	add    $0x7,%eax
 a2d:	c1 e8 03             	shr    $0x3,%eax
 a30:	83 c0 01             	add    $0x1,%eax
 a33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a36:	a1 68 0f 00 00       	mov    0xf68,%eax
 a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a42:	75 23                	jne    a67 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a44:	c7 45 f0 60 0f 00 00 	movl   $0xf60,-0x10(%ebp)
 a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4e:	a3 68 0f 00 00       	mov    %eax,0xf68
 a53:	a1 68 0f 00 00       	mov    0xf68,%eax
 a58:	a3 60 0f 00 00       	mov    %eax,0xf60
    base.s.size = 0;
 a5d:	c7 05 64 0f 00 00 00 	movl   $0x0,0xf64
 a64:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6a:	8b 00                	mov    (%eax),%eax
 a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a72:	8b 40 04             	mov    0x4(%eax),%eax
 a75:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a78:	77 4d                	ja     ac7 <malloc+0xa6>
      if(p->s.size == nunits)
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	8b 40 04             	mov    0x4(%eax),%eax
 a80:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a83:	75 0c                	jne    a91 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	8b 10                	mov    (%eax),%edx
 a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8d:	89 10                	mov    %edx,(%eax)
 a8f:	eb 26                	jmp    ab7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a94:	8b 40 04             	mov    0x4(%eax),%eax
 a97:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a9a:	89 c2                	mov    %eax,%edx
 a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa5:	8b 40 04             	mov    0x4(%eax),%eax
 aa8:	c1 e0 03             	shl    $0x3,%eax
 aab:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ab4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aba:	a3 68 0f 00 00       	mov    %eax,0xf68
      return (void*)(p + 1);
 abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac2:	83 c0 08             	add    $0x8,%eax
 ac5:	eb 3b                	jmp    b02 <malloc+0xe1>
    }
    if(p == freep)
 ac7:	a1 68 0f 00 00       	mov    0xf68,%eax
 acc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 acf:	75 1e                	jne    aef <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ad1:	83 ec 0c             	sub    $0xc,%esp
 ad4:	ff 75 ec             	push   -0x14(%ebp)
 ad7:	e8 e5 fe ff ff       	call   9c1 <morecore>
 adc:	83 c4 10             	add    $0x10,%esp
 adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ae6:	75 07                	jne    aef <malloc+0xce>
        return 0;
 ae8:	b8 00 00 00 00       	mov    $0x0,%eax
 aed:	eb 13                	jmp    b02 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	8b 00                	mov    (%eax),%eax
 afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 afd:	e9 6d ff ff ff       	jmp    a6f <malloc+0x4e>
  }
}
 b02:	c9                   	leave  
 b03:	c3                   	ret    
