
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <login>:
#define REG_USERS 2
char *argv[] = {"login", 0};
char *regusers[] = {"suriya","aravinda"};
char *regpass[] = {"19BCE1050","19BCE1190"};

int login(char *u, char *p) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int i;
  int loggedIn = 0;
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0 ; i < REG_USERS ; i++) {
   d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  14:	eb 47                	jmp    5d <login+0x5d>
    //printf(1, "%s %s %s %s %d %d\n", u, regusers[i], p, regpass[i], !strcmp(u, regusers[i]), !strcmp(p, regpass[i]));
    if(!strcmp(u, regusers[i]) && !strcmp(p, regpass[i])) {
  16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  19:	8b 04 85 b8 0c 00 00 	mov    0xcb8(,%eax,4),%eax
  20:	83 ec 08             	sub    $0x8,%esp
  23:	50                   	push   %eax
  24:	ff 75 08             	push   0x8(%ebp)
  27:	e8 84 03 00 00       	call   3b0 <strcmp>
  2c:	83 c4 10             	add    $0x10,%esp
  2f:	85 c0                	test   %eax,%eax
  31:	75 26                	jne    59 <login+0x59>
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8b 04 85 c0 0c 00 00 	mov    0xcc0(,%eax,4),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	50                   	push   %eax
  41:	ff 75 0c             	push   0xc(%ebp)
  44:	e8 67 03 00 00       	call   3b0 <strcmp>
  49:	83 c4 10             	add    $0x10,%esp
  4c:	85 c0                	test   %eax,%eax
  4e:	75 09                	jne    59 <login+0x59>
      loggedIn = 1;
  50:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
  57:	eb 0a                	jmp    63 <login+0x63>
  for(i = 0 ; i < REG_USERS ; i++) {
  59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  5d:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  61:	7e b3                	jle    16 <login+0x16>
    }
  }

  return loggedIn;
  63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(void)
{
  68:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  6c:	83 e4 f0             	and    $0xfffffff0,%esp
  6f:	ff 71 fc             	push   -0x4(%ecx)
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	53                   	push   %ebx
  76:	51                   	push   %ecx
  77:	83 ec 60             	sub    $0x60,%esp
  int pid, wpid,loggedIn;

  if(open("console", O_RDWR) < 0){
  7a:	83 ec 08             	sub    $0x8,%esp
  7d:	6a 02                	push   $0x2
  7f:	68 66 0b 00 00       	push   $0xb66
  84:	e8 98 05 00 00       	call   621 <open>
  89:	83 c4 10             	add    $0x10,%esp
  8c:	85 c0                	test   %eax,%eax
  8e:	79 26                	jns    b6 <main+0x4e>
    mknod("console", 1, 1);
  90:	83 ec 04             	sub    $0x4,%esp
  93:	6a 01                	push   $0x1
  95:	6a 01                	push   $0x1
  97:	68 66 0b 00 00       	push   $0xb66
  9c:	e8 88 05 00 00       	call   629 <mknod>
  a1:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	6a 02                	push   $0x2
  a9:	68 66 0b 00 00       	push   $0xb66
  ae:	e8 6e 05 00 00       	call   621 <open>
  b3:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  b6:	83 ec 0c             	sub    $0xc,%esp
  b9:	6a 00                	push   $0x0
  bb:	e8 99 05 00 00       	call   659 <dup>
  c0:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  c3:	83 ec 0c             	sub    $0xc,%esp
  c6:	6a 00                	push   $0x0
  c8:	e8 8c 05 00 00       	call   659 <dup>
  cd:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "Starting XV6 os by\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 6e 0b 00 00       	push   $0xb6e
  d8:	6a 01                	push   $0x1
  da:	e8 a6 06 00 00       	call   785 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    printf(1, "Suriyakrishnan S - 19BCE1050\n");
  e2:	83 ec 08             	sub    $0x8,%esp
  e5:	68 82 0b 00 00       	push   $0xb82
  ea:	6a 01                	push   $0x1
  ec:	e8 94 06 00 00       	call   785 <printf>
  f1:	83 c4 10             	add    $0x10,%esp
    printf(1, "Aravinda B - 19BCE1190\n");
  f4:	83 ec 08             	sub    $0x8,%esp
  f7:	68 a0 0b 00 00       	push   $0xba0
  fc:	6a 01                	push   $0x1
  fe:	e8 82 06 00 00       	call   785 <printf>
 103:	83 c4 10             	add    $0x10,%esp
    printf(1, "init: starting login\n");
 106:	83 ec 08             	sub    $0x8,%esp
 109:	68 b8 0b 00 00       	push   $0xbb8
 10e:	6a 01                	push   $0x1
 110:	e8 70 06 00 00       	call   785 <printf>
 115:	83 c4 10             	add    $0x10,%esp
    pid = fork();
 118:	e8 bc 04 00 00       	call   5d9 <fork>
 11d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
 120:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 124:	79 17                	jns    13d <main+0xd5>
      printf(1, "init: fork failed\n");
 126:	83 ec 08             	sub    $0x8,%esp
 129:	68 ce 0b 00 00       	push   $0xbce
 12e:	6a 01                	push   $0x1
 130:	e8 50 06 00 00       	call   785 <printf>
 135:	83 c4 10             	add    $0x10,%esp
      exit();
 138:	e8 a4 04 00 00       	call   5e1 <exit>
    }
    if(pid == 0){
 13d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 141:	0f 85 f4 01 00 00    	jne    33b <main+0x2d3>
      // exec(argv[0], argv);
      // printf(1, "init: exec login failed\n");
      // exit();
      int count=0;
 147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      while (count < MAX_Attempt)
 14e:	e9 b8 01 00 00       	jmp    30b <main+0x2a3>
      {
        printf(1, "Username: ");
 153:	83 ec 08             	sub    $0x8,%esp
 156:	68 e1 0b 00 00       	push   $0xbe1
 15b:	6a 01                	push   $0x1
 15d:	e8 23 06 00 00       	call   785 <printf>
 162:	83 c4 10             	add    $0x10,%esp
        char *user = (char *)malloc(BUFFLEN);
 165:	83 ec 0c             	sub    $0xc,%esp
 168:	6a 40                	push   $0x40
 16a:	e8 ea 08 00 00       	call   a59 <malloc>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	89 45 e0             	mov    %eax,-0x20(%ebp)
        user = gets(user , 64);
 175:	8b 45 e0             	mov    -0x20(%ebp),%eax
 178:	83 ec 08             	sub    $0x8,%esp
 17b:	6a 40                	push   $0x40
 17d:	50                   	push   %eax
 17e:	e8 e0 02 00 00       	call   463 <gets>
 183:	83 c4 10             	add    $0x10,%esp
 186:	89 45 e0             	mov    %eax,-0x20(%ebp)
        //remove enter key
        switch(user[strlen(user) - 1]) {
 189:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 18c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 18f:	83 ec 0c             	sub    $0xc,%esp
 192:	50                   	push   %eax
 193:	e8 57 02 00 00       	call   3ef <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 e8 01             	sub    $0x1,%eax
 19e:	01 d8                	add    %ebx,%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	0f be c0             	movsbl %al,%eax
 1a6:	83 f8 0a             	cmp    $0xa,%eax
 1a9:	74 05                	je     1b0 <main+0x148>
 1ab:	83 f8 0d             	cmp    $0xd,%eax
 1ae:	75 1a                	jne    1ca <main+0x162>
          case '\n': case '\r':
          user[strlen(user) - 1] = 0;
 1b0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 1b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1b6:	83 ec 0c             	sub    $0xc,%esp
 1b9:	50                   	push   %eax
 1ba:	e8 30 02 00 00       	call   3ef <strlen>
 1bf:	83 c4 10             	add    $0x10,%esp
 1c2:	83 e8 01             	sub    $0x1,%eax
 1c5:	01 d8                	add    %ebx,%eax
 1c7:	c6 00 00             	movb   $0x0,(%eax)
        }
        
        printf(1, "Password :  ");
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	68 ec 0b 00 00       	push   $0xbec
 1d2:	6a 01                	push   $0x1
 1d4:	e8 ac 05 00 00       	call   785 <printf>
 1d9:	83 c4 10             	add    $0x10,%esp
        char *pass = (char *)malloc(BUFFLEN);
 1dc:	83 ec 0c             	sub    $0xc,%esp
 1df:	6a 40                	push   $0x40
 1e1:	e8 73 08 00 00       	call   a59 <malloc>
 1e6:	83 c4 10             	add    $0x10,%esp
 1e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        pass = gets(pass , 20);
 1ec:	83 ec 08             	sub    $0x8,%esp
 1ef:	6a 14                	push   $0x14
 1f1:	ff 75 e8             	push   -0x18(%ebp)
 1f4:	e8 6a 02 00 00       	call   463 <gets>
 1f9:	83 c4 10             	add    $0x10,%esp
 1fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //remove enter key
        switch(pass[strlen(pass) - 1]) {
 1ff:	83 ec 0c             	sub    $0xc,%esp
 202:	ff 75 e8             	push   -0x18(%ebp)
 205:	e8 e5 01 00 00       	call   3ef <strlen>
 20a:	83 c4 10             	add    $0x10,%esp
 20d:	8d 50 ff             	lea    -0x1(%eax),%edx
 210:	8b 45 e8             	mov    -0x18(%ebp),%eax
 213:	01 d0                	add    %edx,%eax
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	0f be c0             	movsbl %al,%eax
 21b:	83 f8 0a             	cmp    $0xa,%eax
 21e:	74 05                	je     225 <main+0x1bd>
 220:	83 f8 0d             	cmp    $0xd,%eax
 223:	75 19                	jne    23e <main+0x1d6>
          case '\n': case '\r':
          pass[strlen(pass) - 1] = 0;
 225:	83 ec 0c             	sub    $0xc,%esp
 228:	ff 75 e8             	push   -0x18(%ebp)
 22b:	e8 bf 01 00 00       	call   3ef <strlen>
 230:	83 c4 10             	add    $0x10,%esp
 233:	8d 50 ff             	lea    -0x1(%eax),%edx
 236:	8b 45 e8             	mov    -0x18(%ebp),%eax
 239:	01 d0                	add    %edx,%eax
 23b:	c6 00 00             	movb   $0x0,(%eax)
        }

        loggedIn = login(user, pass);
 23e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 241:	83 ec 08             	sub    $0x8,%esp
 244:	ff 75 e8             	push   -0x18(%ebp)
 247:	50                   	push   %eax
 248:	e8 b3 fd ff ff       	call   0 <login>
 24d:	83 c4 10             	add    $0x10,%esp
 250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(loggedIn) {
 253:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 257:	0f 84 98 00 00 00    	je     2f5 <main+0x28d>
          char home_dir[64];
          strcpy(home_dir, "/home/");      
 25d:	83 ec 08             	sub    $0x8,%esp
 260:	68 f9 0b 00 00       	push   $0xbf9
 265:	8d 45 a0             	lea    -0x60(%ebp),%eax
 268:	50                   	push   %eax
 269:	e8 12 01 00 00       	call   380 <strcpy>
 26e:	83 c4 10             	add    $0x10,%esp
          mkdir(home_dir);      
 271:	83 ec 0c             	sub    $0xc,%esp
 274:	8d 45 a0             	lea    -0x60(%ebp),%eax
 277:	50                   	push   %eax
 278:	e8 cc 03 00 00       	call   649 <mkdir>
 27d:	83 c4 10             	add    $0x10,%esp
          strcpy(home_dir + strlen(home_dir), "suriya");
 280:	83 ec 0c             	sub    $0xc,%esp
 283:	8d 45 a0             	lea    -0x60(%ebp),%eax
 286:	50                   	push   %eax
 287:	e8 63 01 00 00       	call   3ef <strlen>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	8d 55 a0             	lea    -0x60(%ebp),%edx
 292:	01 d0                	add    %edx,%eax
 294:	83 ec 08             	sub    $0x8,%esp
 297:	68 42 0b 00 00       	push   $0xb42
 29c:	50                   	push   %eax
 29d:	e8 de 00 00 00       	call   380 <strcpy>
 2a2:	83 c4 10             	add    $0x10,%esp
          mkdir(home_dir);
 2a5:	83 ec 0c             	sub    $0xc,%esp
 2a8:	8d 45 a0             	lea    -0x60(%ebp),%eax
 2ab:	50                   	push   %eax
 2ac:	e8 98 03 00 00       	call   649 <mkdir>
 2b1:	83 c4 10             	add    $0x10,%esp
          //opens shell for the user
          printf(1, "Welcome back %s!\n", user);          
 2b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
 2b7:	83 ec 04             	sub    $0x4,%esp
 2ba:	50                   	push   %eax
 2bb:	68 00 0c 00 00       	push   $0xc00
 2c0:	6a 01                	push   $0x1
 2c2:	e8 be 04 00 00       	call   785 <printf>
 2c7:	83 c4 10             	add    $0x10,%esp
          exec("sh", &user);
 2ca:	83 ec 08             	sub    $0x8,%esp
 2cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
 2d0:	50                   	push   %eax
 2d1:	68 12 0c 00 00       	push   $0xc12
 2d6:	e8 3e 03 00 00       	call   619 <exec>
 2db:	83 c4 10             	add    $0x10,%esp
          printf(1, "init: exec login failed\n");
 2de:	83 ec 08             	sub    $0x8,%esp
 2e1:	68 15 0c 00 00       	push   $0xc15
 2e6:	6a 01                	push   $0x1
 2e8:	e8 98 04 00 00       	call   785 <printf>
 2ed:	83 c4 10             	add    $0x10,%esp
          exit();
 2f0:	e8 ec 02 00 00       	call   5e1 <exit>
        }
        else {
          printf(1, "User and password do not match, or user does not exist! Try again!\n");
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	68 30 0c 00 00       	push   $0xc30
 2fd:	6a 01                	push   $0x1
 2ff:	e8 81 04 00 00       	call   785 <printf>
 304:	83 c4 10             	add    $0x10,%esp
          count++;
 307:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      while (count < MAX_Attempt)
 30b:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
 30f:	0f 8e 3e fe ff ff    	jle    153 <main+0xeb>
        }
      }

      printf(1, "Failed 3 attempts! Please reboot machine!\n");
 315:	83 ec 08             	sub    $0x8,%esp
 318:	68 74 0c 00 00       	push   $0xc74
 31d:	6a 01                	push   $0x1
 31f:	e8 61 04 00 00       	call   785 <printf>
 324:	83 c4 10             	add    $0x10,%esp
      while(1); //stall
 327:	eb fe                	jmp    327 <main+0x2bf>
      exit();
      
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
 329:	83 ec 08             	sub    $0x8,%esp
 32c:	68 9f 0c 00 00       	push   $0xc9f
 331:	6a 01                	push   $0x1
 333:	e8 4d 04 00 00       	call   785 <printf>
 338:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
 33b:	e8 a9 02 00 00       	call   5e9 <wait>
 340:	89 45 ec             	mov    %eax,-0x14(%ebp)
 343:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 347:	0f 88 83 fd ff ff    	js     d0 <main+0x68>
 34d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 350:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 353:	75 d4                	jne    329 <main+0x2c1>
    printf(1, "Starting XV6 os by\n");
 355:	e9 76 fd ff ff       	jmp    d0 <main+0x68>

0000035a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	57                   	push   %edi
 35e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 35f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 362:	8b 55 10             	mov    0x10(%ebp),%edx
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 cb                	mov    %ecx,%ebx
 36a:	89 df                	mov    %ebx,%edi
 36c:	89 d1                	mov    %edx,%ecx
 36e:	fc                   	cld    
 36f:	f3 aa                	rep stos %al,%es:(%edi)
 371:	89 ca                	mov    %ecx,%edx
 373:	89 fb                	mov    %edi,%ebx
 375:	89 5d 08             	mov    %ebx,0x8(%ebp)
 378:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37b:	90                   	nop
 37c:	5b                   	pop    %ebx
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38c:	90                   	nop
 38d:	8b 55 0c             	mov    0xc(%ebp),%edx
 390:	8d 42 01             	lea    0x1(%edx),%eax
 393:	89 45 0c             	mov    %eax,0xc(%ebp)
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	8d 48 01             	lea    0x1(%eax),%ecx
 39c:	89 4d 08             	mov    %ecx,0x8(%ebp)
 39f:	0f b6 12             	movzbl (%edx),%edx
 3a2:	88 10                	mov    %dl,(%eax)
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	84 c0                	test   %al,%al
 3a9:	75 e2                	jne    38d <strcpy+0xd>
    ;
  return os;
 3ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ae:	c9                   	leave  
 3af:	c3                   	ret    

000003b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b3:	eb 08                	jmp    3bd <strcmp+0xd>
    p++, q++;
 3b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	84 c0                	test   %al,%al
 3c5:	74 10                	je     3d7 <strcmp+0x27>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 10             	movzbl (%eax),%edx
 3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d0:	0f b6 00             	movzbl (%eax),%eax
 3d3:	38 c2                	cmp    %al,%dl
 3d5:	74 de                	je     3b5 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	0f b6 d0             	movzbl %al,%edx
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	0f b6 c8             	movzbl %al,%ecx
 3e9:	89 d0                	mov    %edx,%eax
 3eb:	29 c8                	sub    %ecx,%eax
}
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret    

000003ef <strlen>:

uint
strlen(char *s)
{
 3ef:	55                   	push   %ebp
 3f0:	89 e5                	mov    %esp,%ebp
 3f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3fc:	eb 04                	jmp    402 <strlen+0x13>
 3fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 402:	8b 55 fc             	mov    -0x4(%ebp),%edx
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	01 d0                	add    %edx,%eax
 40a:	0f b6 00             	movzbl (%eax),%eax
 40d:	84 c0                	test   %al,%al
 40f:	75 ed                	jne    3fe <strlen+0xf>
    ;
  return n;
 411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <memset>:

void*
memset(void *dst, int c, uint n)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 419:	8b 45 10             	mov    0x10(%ebp),%eax
 41c:	50                   	push   %eax
 41d:	ff 75 0c             	push   0xc(%ebp)
 420:	ff 75 08             	push   0x8(%ebp)
 423:	e8 32 ff ff ff       	call   35a <stosb>
 428:	83 c4 0c             	add    $0xc,%esp
  return dst;
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42e:	c9                   	leave  
 42f:	c3                   	ret    

00000430 <strchr>:

char*
strchr(const char *s, char c)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	83 ec 04             	sub    $0x4,%esp
 436:	8b 45 0c             	mov    0xc(%ebp),%eax
 439:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 43c:	eb 14                	jmp    452 <strchr+0x22>
    if(*s == c)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	38 45 fc             	cmp    %al,-0x4(%ebp)
 447:	75 05                	jne    44e <strchr+0x1e>
      return (char*)s;
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	eb 13                	jmp    461 <strchr+0x31>
  for(; *s; s++)
 44e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	0f b6 00             	movzbl (%eax),%eax
 458:	84 c0                	test   %al,%al
 45a:	75 e2                	jne    43e <strchr+0xe>
  return 0;
 45c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 461:	c9                   	leave  
 462:	c3                   	ret    

00000463 <gets>:

char*
gets(char *buf, int max)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 469:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 470:	eb 42                	jmp    4b4 <gets+0x51>
    cc = read(0, &c, 1);
 472:	83 ec 04             	sub    $0x4,%esp
 475:	6a 01                	push   $0x1
 477:	8d 45 ef             	lea    -0x11(%ebp),%eax
 47a:	50                   	push   %eax
 47b:	6a 00                	push   $0x0
 47d:	e8 77 01 00 00       	call   5f9 <read>
 482:	83 c4 10             	add    $0x10,%esp
 485:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48c:	7e 33                	jle    4c1 <gets+0x5e>
      break;
    buf[i++] = c;
 48e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 491:	8d 50 01             	lea    0x1(%eax),%edx
 494:	89 55 f4             	mov    %edx,-0xc(%ebp)
 497:	89 c2                	mov    %eax,%edx
 499:	8b 45 08             	mov    0x8(%ebp),%eax
 49c:	01 c2                	add    %eax,%edx
 49e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4a8:	3c 0a                	cmp    $0xa,%al
 4aa:	74 16                	je     4c2 <gets+0x5f>
 4ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b0:	3c 0d                	cmp    $0xd,%al
 4b2:	74 0e                	je     4c2 <gets+0x5f>
  for(i=0; i+1 < max; ){
 4b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b7:	83 c0 01             	add    $0x1,%eax
 4ba:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4bd:	7f b3                	jg     472 <gets+0xf>
 4bf:	eb 01                	jmp    4c2 <gets+0x5f>
      break;
 4c1:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
 4c8:	01 d0                	add    %edx,%eax
 4ca:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d0:	c9                   	leave  
 4d1:	c3                   	ret    

000004d2 <stat>:

int
stat(char *n, struct stat *st)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d8:	83 ec 08             	sub    $0x8,%esp
 4db:	6a 00                	push   $0x0
 4dd:	ff 75 08             	push   0x8(%ebp)
 4e0:	e8 3c 01 00 00       	call   621 <open>
 4e5:	83 c4 10             	add    $0x10,%esp
 4e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ef:	79 07                	jns    4f8 <stat+0x26>
    return -1;
 4f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f6:	eb 25                	jmp    51d <stat+0x4b>
  r = fstat(fd, st);
 4f8:	83 ec 08             	sub    $0x8,%esp
 4fb:	ff 75 0c             	push   0xc(%ebp)
 4fe:	ff 75 f4             	push   -0xc(%ebp)
 501:	e8 33 01 00 00       	call   639 <fstat>
 506:	83 c4 10             	add    $0x10,%esp
 509:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 50c:	83 ec 0c             	sub    $0xc,%esp
 50f:	ff 75 f4             	push   -0xc(%ebp)
 512:	e8 f2 00 00 00       	call   609 <close>
 517:	83 c4 10             	add    $0x10,%esp
  return r;
 51a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <atoi>:

int
atoi(const char *s)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 525:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 52c:	eb 25                	jmp    553 <atoi+0x34>
    n = n*10 + *s++ - '0';
 52e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 531:	89 d0                	mov    %edx,%eax
 533:	c1 e0 02             	shl    $0x2,%eax
 536:	01 d0                	add    %edx,%eax
 538:	01 c0                	add    %eax,%eax
 53a:	89 c1                	mov    %eax,%ecx
 53c:	8b 45 08             	mov    0x8(%ebp),%eax
 53f:	8d 50 01             	lea    0x1(%eax),%edx
 542:	89 55 08             	mov    %edx,0x8(%ebp)
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	01 c8                	add    %ecx,%eax
 54d:	83 e8 30             	sub    $0x30,%eax
 550:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	0f b6 00             	movzbl (%eax),%eax
 559:	3c 2f                	cmp    $0x2f,%al
 55b:	7e 0a                	jle    567 <atoi+0x48>
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	0f b6 00             	movzbl (%eax),%eax
 563:	3c 39                	cmp    $0x39,%al
 565:	7e c7                	jle    52e <atoi+0xf>
  return n;
 567:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 56a:	c9                   	leave  
 56b:	c3                   	ret    

0000056c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 578:	8b 45 0c             	mov    0xc(%ebp),%eax
 57b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 57e:	eb 17                	jmp    597 <memmove+0x2b>
    *dst++ = *src++;
 580:	8b 55 f8             	mov    -0x8(%ebp),%edx
 583:	8d 42 01             	lea    0x1(%edx),%eax
 586:	89 45 f8             	mov    %eax,-0x8(%ebp)
 589:	8b 45 fc             	mov    -0x4(%ebp),%eax
 58c:	8d 48 01             	lea    0x1(%eax),%ecx
 58f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 592:	0f b6 12             	movzbl (%edx),%edx
 595:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 597:	8b 45 10             	mov    0x10(%ebp),%eax
 59a:	8d 50 ff             	lea    -0x1(%eax),%edx
 59d:	89 55 10             	mov    %edx,0x10(%ebp)
 5a0:	85 c0                	test   %eax,%eax
 5a2:	7f dc                	jg     580 <memmove+0x14>
  return vdst;
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5a7:	c9                   	leave  
 5a8:	c3                   	ret    

000005a9 <restorer>:
 5a9:	83 c4 0c             	add    $0xc,%esp
 5ac:	5a                   	pop    %edx
 5ad:	59                   	pop    %ecx
 5ae:	58                   	pop    %eax
 5af:	c3                   	ret    

000005b0 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
 5b6:	83 ec 0c             	sub    $0xc,%esp
 5b9:	68 a9 05 00 00       	push   $0x5a9
 5be:	e8 ce 00 00 00       	call   691 <signal_restorer>
 5c3:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
 5c6:	83 ec 08             	sub    $0x8,%esp
 5c9:	ff 75 0c             	push   0xc(%ebp)
 5cc:	ff 75 08             	push   0x8(%ebp)
 5cf:	e8 b5 00 00 00       	call   689 <signal_register>
 5d4:	83 c4 10             	add    $0x10,%esp
 5d7:	c9                   	leave  
 5d8:	c3                   	ret    

000005d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5d9:	b8 01 00 00 00       	mov    $0x1,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <exit>:
SYSCALL(exit)
 5e1:	b8 02 00 00 00       	mov    $0x2,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <wait>:
SYSCALL(wait)
 5e9:	b8 03 00 00 00       	mov    $0x3,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <pipe>:
SYSCALL(pipe)
 5f1:	b8 04 00 00 00       	mov    $0x4,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <read>:
SYSCALL(read)
 5f9:	b8 05 00 00 00       	mov    $0x5,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <write>:
SYSCALL(write)
 601:	b8 10 00 00 00       	mov    $0x10,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <close>:
SYSCALL(close)
 609:	b8 15 00 00 00       	mov    $0x15,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <kill>:
SYSCALL(kill)
 611:	b8 06 00 00 00       	mov    $0x6,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <exec>:
SYSCALL(exec)
 619:	b8 07 00 00 00       	mov    $0x7,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <open>:
SYSCALL(open)
 621:	b8 0f 00 00 00       	mov    $0xf,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <mknod>:
SYSCALL(mknod)
 629:	b8 11 00 00 00       	mov    $0x11,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <unlink>:
SYSCALL(unlink)
 631:	b8 12 00 00 00       	mov    $0x12,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <fstat>:
SYSCALL(fstat)
 639:	b8 08 00 00 00       	mov    $0x8,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <link>:
SYSCALL(link)
 641:	b8 13 00 00 00       	mov    $0x13,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <mkdir>:
SYSCALL(mkdir)
 649:	b8 14 00 00 00       	mov    $0x14,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <chdir>:
SYSCALL(chdir)
 651:	b8 09 00 00 00       	mov    $0x9,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <dup>:
SYSCALL(dup)
 659:	b8 0a 00 00 00       	mov    $0xa,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <getpid>:
SYSCALL(getpid)
 661:	b8 0b 00 00 00       	mov    $0xb,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <sbrk>:
SYSCALL(sbrk)
 669:	b8 0c 00 00 00       	mov    $0xc,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <sleep>:
SYSCALL(sleep)
 671:	b8 0d 00 00 00       	mov    $0xd,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <uptime>:
SYSCALL(uptime)
 679:	b8 0e 00 00 00       	mov    $0xe,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <halt>:
SYSCALL(halt)
 681:	b8 16 00 00 00       	mov    $0x16,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <signal_register>:
SYSCALL(signal_register)
 689:	b8 17 00 00 00       	mov    $0x17,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <signal_restorer>:
SYSCALL(signal_restorer)
 691:	b8 18 00 00 00       	mov    $0x18,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <mprotect>:
SYSCALL(mprotect)
 699:	b8 19 00 00 00       	mov    $0x19,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <cowfork>:
SYSCALL(cowfork)
 6a1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <dsbrk>:
SYSCALL(dsbrk)
 6a9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b1:	55                   	push   %ebp
 6b2:	89 e5                	mov    %esp,%ebp
 6b4:	83 ec 18             	sub    $0x18,%esp
 6b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ba:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6bd:	83 ec 04             	sub    $0x4,%esp
 6c0:	6a 01                	push   $0x1
 6c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6c5:	50                   	push   %eax
 6c6:	ff 75 08             	push   0x8(%ebp)
 6c9:	e8 33 ff ff ff       	call   601 <write>
 6ce:	83 c4 10             	add    $0x10,%esp
}
 6d1:	90                   	nop
 6d2:	c9                   	leave  
 6d3:	c3                   	ret    

000006d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d4:	55                   	push   %ebp
 6d5:	89 e5                	mov    %esp,%ebp
 6d7:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6e5:	74 17                	je     6fe <printint+0x2a>
 6e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6eb:	79 11                	jns    6fe <printint+0x2a>
    neg = 1;
 6ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f7:	f7 d8                	neg    %eax
 6f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6fc:	eb 06                	jmp    704 <printint+0x30>
  } else {
    x = xx;
 6fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 701:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 704:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 70b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 70e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 711:	ba 00 00 00 00       	mov    $0x0,%edx
 716:	f7 f1                	div    %ecx
 718:	89 d1                	mov    %edx,%ecx
 71a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71d:	8d 50 01             	lea    0x1(%eax),%edx
 720:	89 55 f4             	mov    %edx,-0xc(%ebp)
 723:	0f b6 91 c8 0c 00 00 	movzbl 0xcc8(%ecx),%edx
 72a:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 72e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 731:	8b 45 ec             	mov    -0x14(%ebp),%eax
 734:	ba 00 00 00 00       	mov    $0x0,%edx
 739:	f7 f1                	div    %ecx
 73b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 73e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 742:	75 c7                	jne    70b <printint+0x37>
  if(neg)
 744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 748:	74 2d                	je     777 <printint+0xa3>
    buf[i++] = '-';
 74a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74d:	8d 50 01             	lea    0x1(%eax),%edx
 750:	89 55 f4             	mov    %edx,-0xc(%ebp)
 753:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 758:	eb 1d                	jmp    777 <printint+0xa3>
    putc(fd, buf[i]);
 75a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	01 d0                	add    %edx,%eax
 762:	0f b6 00             	movzbl (%eax),%eax
 765:	0f be c0             	movsbl %al,%eax
 768:	83 ec 08             	sub    $0x8,%esp
 76b:	50                   	push   %eax
 76c:	ff 75 08             	push   0x8(%ebp)
 76f:	e8 3d ff ff ff       	call   6b1 <putc>
 774:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 777:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 77b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77f:	79 d9                	jns    75a <printint+0x86>
}
 781:	90                   	nop
 782:	90                   	nop
 783:	c9                   	leave  
 784:	c3                   	ret    

00000785 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 785:	55                   	push   %ebp
 786:	89 e5                	mov    %esp,%ebp
 788:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 78b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 792:	8d 45 0c             	lea    0xc(%ebp),%eax
 795:	83 c0 04             	add    $0x4,%eax
 798:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 79b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a2:	e9 59 01 00 00       	jmp    900 <printf+0x17b>
    c = fmt[i] & 0xff;
 7a7:	8b 55 0c             	mov    0xc(%ebp),%edx
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	01 d0                	add    %edx,%eax
 7af:	0f b6 00             	movzbl (%eax),%eax
 7b2:	0f be c0             	movsbl %al,%eax
 7b5:	25 ff 00 00 00       	and    $0xff,%eax
 7ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c1:	75 2c                	jne    7ef <printf+0x6a>
      if(c == '%'){
 7c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c7:	75 0c                	jne    7d5 <printf+0x50>
        state = '%';
 7c9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d0:	e9 27 01 00 00       	jmp    8fc <printf+0x177>
      } else {
        putc(fd, c);
 7d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d8:	0f be c0             	movsbl %al,%eax
 7db:	83 ec 08             	sub    $0x8,%esp
 7de:	50                   	push   %eax
 7df:	ff 75 08             	push   0x8(%ebp)
 7e2:	e8 ca fe ff ff       	call   6b1 <putc>
 7e7:	83 c4 10             	add    $0x10,%esp
 7ea:	e9 0d 01 00 00       	jmp    8fc <printf+0x177>
      }
    } else if(state == '%'){
 7ef:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7f3:	0f 85 03 01 00 00    	jne    8fc <printf+0x177>
      if(c == 'd'){
 7f9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7fd:	75 1e                	jne    81d <printf+0x98>
        printint(fd, *ap, 10, 1);
 7ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	6a 01                	push   $0x1
 806:	6a 0a                	push   $0xa
 808:	50                   	push   %eax
 809:	ff 75 08             	push   0x8(%ebp)
 80c:	e8 c3 fe ff ff       	call   6d4 <printint>
 811:	83 c4 10             	add    $0x10,%esp
        ap++;
 814:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 818:	e9 d8 00 00 00       	jmp    8f5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 81d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 821:	74 06                	je     829 <printf+0xa4>
 823:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 827:	75 1e                	jne    847 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 829:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	6a 00                	push   $0x0
 830:	6a 10                	push   $0x10
 832:	50                   	push   %eax
 833:	ff 75 08             	push   0x8(%ebp)
 836:	e8 99 fe ff ff       	call   6d4 <printint>
 83b:	83 c4 10             	add    $0x10,%esp
        ap++;
 83e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 842:	e9 ae 00 00 00       	jmp    8f5 <printf+0x170>
      } else if(c == 's'){
 847:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 84b:	75 43                	jne    890 <printf+0x10b>
        s = (char*)*ap;
 84d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 855:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85d:	75 25                	jne    884 <printf+0xff>
          s = "(null)";
 85f:	c7 45 f4 a8 0c 00 00 	movl   $0xca8,-0xc(%ebp)
        while(*s != 0){
 866:	eb 1c                	jmp    884 <printf+0xff>
          putc(fd, *s);
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	0f b6 00             	movzbl (%eax),%eax
 86e:	0f be c0             	movsbl %al,%eax
 871:	83 ec 08             	sub    $0x8,%esp
 874:	50                   	push   %eax
 875:	ff 75 08             	push   0x8(%ebp)
 878:	e8 34 fe ff ff       	call   6b1 <putc>
 87d:	83 c4 10             	add    $0x10,%esp
          s++;
 880:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	0f b6 00             	movzbl (%eax),%eax
 88a:	84 c0                	test   %al,%al
 88c:	75 da                	jne    868 <printf+0xe3>
 88e:	eb 65                	jmp    8f5 <printf+0x170>
        }
      } else if(c == 'c'){
 890:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 894:	75 1d                	jne    8b3 <printf+0x12e>
        putc(fd, *ap);
 896:	8b 45 e8             	mov    -0x18(%ebp),%eax
 899:	8b 00                	mov    (%eax),%eax
 89b:	0f be c0             	movsbl %al,%eax
 89e:	83 ec 08             	sub    $0x8,%esp
 8a1:	50                   	push   %eax
 8a2:	ff 75 08             	push   0x8(%ebp)
 8a5:	e8 07 fe ff ff       	call   6b1 <putc>
 8aa:	83 c4 10             	add    $0x10,%esp
        ap++;
 8ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b1:	eb 42                	jmp    8f5 <printf+0x170>
      } else if(c == '%'){
 8b3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8b7:	75 17                	jne    8d0 <printf+0x14b>
        putc(fd, c);
 8b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8bc:	0f be c0             	movsbl %al,%eax
 8bf:	83 ec 08             	sub    $0x8,%esp
 8c2:	50                   	push   %eax
 8c3:	ff 75 08             	push   0x8(%ebp)
 8c6:	e8 e6 fd ff ff       	call   6b1 <putc>
 8cb:	83 c4 10             	add    $0x10,%esp
 8ce:	eb 25                	jmp    8f5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d0:	83 ec 08             	sub    $0x8,%esp
 8d3:	6a 25                	push   $0x25
 8d5:	ff 75 08             	push   0x8(%ebp)
 8d8:	e8 d4 fd ff ff       	call   6b1 <putc>
 8dd:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e3:	0f be c0             	movsbl %al,%eax
 8e6:	83 ec 08             	sub    $0x8,%esp
 8e9:	50                   	push   %eax
 8ea:	ff 75 08             	push   0x8(%ebp)
 8ed:	e8 bf fd ff ff       	call   6b1 <putc>
 8f2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8fc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 900:	8b 55 0c             	mov    0xc(%ebp),%edx
 903:	8b 45 f0             	mov    -0x10(%ebp),%eax
 906:	01 d0                	add    %edx,%eax
 908:	0f b6 00             	movzbl (%eax),%eax
 90b:	84 c0                	test   %al,%al
 90d:	0f 85 94 fe ff ff    	jne    7a7 <printf+0x22>
    }
  }
}
 913:	90                   	nop
 914:	90                   	nop
 915:	c9                   	leave  
 916:	c3                   	ret    

00000917 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 917:	55                   	push   %ebp
 918:	89 e5                	mov    %esp,%ebp
 91a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91d:	8b 45 08             	mov    0x8(%ebp),%eax
 920:	83 e8 08             	sub    $0x8,%eax
 923:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 926:	a1 e4 0c 00 00       	mov    0xce4,%eax
 92b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 92e:	eb 24                	jmp    954 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	8b 45 fc             	mov    -0x4(%ebp),%eax
 933:	8b 00                	mov    (%eax),%eax
 935:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 938:	72 12                	jb     94c <free+0x35>
 93a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 940:	77 24                	ja     966 <free+0x4f>
 942:	8b 45 fc             	mov    -0x4(%ebp),%eax
 945:	8b 00                	mov    (%eax),%eax
 947:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 94a:	72 1a                	jb     966 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94f:	8b 00                	mov    (%eax),%eax
 951:	89 45 fc             	mov    %eax,-0x4(%ebp)
 954:	8b 45 f8             	mov    -0x8(%ebp),%eax
 957:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95a:	76 d4                	jbe    930 <free+0x19>
 95c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95f:	8b 00                	mov    (%eax),%eax
 961:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 964:	73 ca                	jae    930 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 966:	8b 45 f8             	mov    -0x8(%ebp),%eax
 969:	8b 40 04             	mov    0x4(%eax),%eax
 96c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 973:	8b 45 f8             	mov    -0x8(%ebp),%eax
 976:	01 c2                	add    %eax,%edx
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	8b 00                	mov    (%eax),%eax
 97d:	39 c2                	cmp    %eax,%edx
 97f:	75 24                	jne    9a5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 981:	8b 45 f8             	mov    -0x8(%ebp),%eax
 984:	8b 50 04             	mov    0x4(%eax),%edx
 987:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98a:	8b 00                	mov    (%eax),%eax
 98c:	8b 40 04             	mov    0x4(%eax),%eax
 98f:	01 c2                	add    %eax,%edx
 991:	8b 45 f8             	mov    -0x8(%ebp),%eax
 994:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 997:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99a:	8b 00                	mov    (%eax),%eax
 99c:	8b 10                	mov    (%eax),%edx
 99e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a1:	89 10                	mov    %edx,(%eax)
 9a3:	eb 0a                	jmp    9af <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a8:	8b 10                	mov    (%eax),%edx
 9aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ad:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b2:	8b 40 04             	mov    0x4(%eax),%eax
 9b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bf:	01 d0                	add    %edx,%eax
 9c1:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 9c4:	75 20                	jne    9e6 <free+0xcf>
    p->s.size += bp->s.size;
 9c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c9:	8b 50 04             	mov    0x4(%eax),%edx
 9cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9cf:	8b 40 04             	mov    0x4(%eax),%eax
 9d2:	01 c2                	add    %eax,%edx
 9d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9dd:	8b 10                	mov    (%eax),%edx
 9df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e2:	89 10                	mov    %edx,(%eax)
 9e4:	eb 08                	jmp    9ee <free+0xd7>
  } else
    p->s.ptr = bp;
 9e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9ec:	89 10                	mov    %edx,(%eax)
  freep = p;
 9ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f1:	a3 e4 0c 00 00       	mov    %eax,0xce4
}
 9f6:	90                   	nop
 9f7:	c9                   	leave  
 9f8:	c3                   	ret    

000009f9 <morecore>:

static Header*
morecore(uint nu)
{
 9f9:	55                   	push   %ebp
 9fa:	89 e5                	mov    %esp,%ebp
 9fc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9ff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a06:	77 07                	ja     a0f <morecore+0x16>
    nu = 4096;
 a08:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a0f:	8b 45 08             	mov    0x8(%ebp),%eax
 a12:	c1 e0 03             	shl    $0x3,%eax
 a15:	83 ec 0c             	sub    $0xc,%esp
 a18:	50                   	push   %eax
 a19:	e8 4b fc ff ff       	call   669 <sbrk>
 a1e:	83 c4 10             	add    $0x10,%esp
 a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a24:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a28:	75 07                	jne    a31 <morecore+0x38>
    return 0;
 a2a:	b8 00 00 00 00       	mov    $0x0,%eax
 a2f:	eb 26                	jmp    a57 <morecore+0x5e>
  hp = (Header*)p;
 a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	8b 55 08             	mov    0x8(%ebp),%edx
 a3d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a43:	83 c0 08             	add    $0x8,%eax
 a46:	83 ec 0c             	sub    $0xc,%esp
 a49:	50                   	push   %eax
 a4a:	e8 c8 fe ff ff       	call   917 <free>
 a4f:	83 c4 10             	add    $0x10,%esp
  return freep;
 a52:	a1 e4 0c 00 00       	mov    0xce4,%eax
}
 a57:	c9                   	leave  
 a58:	c3                   	ret    

00000a59 <malloc>:

void*
malloc(uint nbytes)
{
 a59:	55                   	push   %ebp
 a5a:	89 e5                	mov    %esp,%ebp
 a5c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	83 c0 07             	add    $0x7,%eax
 a65:	c1 e8 03             	shr    $0x3,%eax
 a68:	83 c0 01             	add    $0x1,%eax
 a6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a6e:	a1 e4 0c 00 00       	mov    0xce4,%eax
 a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a7a:	75 23                	jne    a9f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a7c:	c7 45 f0 dc 0c 00 00 	movl   $0xcdc,-0x10(%ebp)
 a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a86:	a3 e4 0c 00 00       	mov    %eax,0xce4
 a8b:	a1 e4 0c 00 00       	mov    0xce4,%eax
 a90:	a3 dc 0c 00 00       	mov    %eax,0xcdc
    base.s.size = 0;
 a95:	c7 05 e0 0c 00 00 00 	movl   $0x0,0xce0
 a9c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa2:	8b 00                	mov    (%eax),%eax
 aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaa:	8b 40 04             	mov    0x4(%eax),%eax
 aad:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ab0:	77 4d                	ja     aff <malloc+0xa6>
      if(p->s.size == nunits)
 ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab5:	8b 40 04             	mov    0x4(%eax),%eax
 ab8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 abb:	75 0c                	jne    ac9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac0:	8b 10                	mov    (%eax),%edx
 ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac5:	89 10                	mov    %edx,(%eax)
 ac7:	eb 26                	jmp    aef <malloc+0x96>
      else {
        p->s.size -= nunits;
 ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acc:	8b 40 04             	mov    0x4(%eax),%eax
 acf:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ad2:	89 c2                	mov    %eax,%edx
 ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
 add:	8b 40 04             	mov    0x4(%eax),%eax
 ae0:	c1 e0 03             	shl    $0x3,%eax
 ae3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aec:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af2:	a3 e4 0c 00 00       	mov    %eax,0xce4
      return (void*)(p + 1);
 af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afa:	83 c0 08             	add    $0x8,%eax
 afd:	eb 3b                	jmp    b3a <malloc+0xe1>
    }
    if(p == freep)
 aff:	a1 e4 0c 00 00       	mov    0xce4,%eax
 b04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b07:	75 1e                	jne    b27 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b09:	83 ec 0c             	sub    $0xc,%esp
 b0c:	ff 75 ec             	push   -0x14(%ebp)
 b0f:	e8 e5 fe ff ff       	call   9f9 <morecore>
 b14:	83 c4 10             	add    $0x10,%esp
 b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b1e:	75 07                	jne    b27 <malloc+0xce>
        return 0;
 b20:	b8 00 00 00 00       	mov    $0x0,%eax
 b25:	eb 13                	jmp    b3a <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b30:	8b 00                	mov    (%eax),%eax
 b32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b35:	e9 6d ff ff ff       	jmp    aa7 <malloc+0x4e>
  }
}
 b3a:	c9                   	leave  
 b3b:	c3                   	ret    
