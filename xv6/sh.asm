
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 f7 0e 00 00       	call   f08 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 90 14 00 00 	mov    0x1490(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 64 14 00 00       	push   $0x1464
      2c:	e8 6b 03 00 00       	call   39c <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 bf 0e 00 00       	call   f08 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 e1 0e 00 00       	call   f40 <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 6b 14 00 00       	push   $0x146b
      71:	6a 02                	push   $0x2
      73:	e8 34 10 00 00       	call   10ac <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c6 01 00 00       	jmp    246 <runcmd+0x246>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 e8             	mov    %eax,-0x18(%ebp)
    close(rcmd->fd);
      86:	8b 45 e8             	mov    -0x18(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 9b 0e 00 00       	call   f30 <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 e8             	mov    -0x18(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 9a 0e 00 00       	call   f48 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 7b 14 00 00       	push   $0x147b
      c4:	6a 02                	push   $0x2
      c6:	e8 e1 0f 00 00       	call   10ac <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 35 0e 00 00       	call   f08 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5c 01 00 00       	jmp    246 <runcmd+0x246>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fork1() == 0)
      f0:	e8 c7 02 00 00       	call   3bc <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 00 0e 00 00       	call   f10 <wait>
    runcmd(lcmd->right);
     110:	8b 45 f0             	mov    -0x10(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 1f 01 00 00       	jmp    246 <runcmd+0x246>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 df 0d 00 00       	call   f18 <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 8b 14 00 00       	push   $0x148b
     148:	e8 4f 02 00 00       	call   39c <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 67 02 00 00       	call   3bc <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 cd 0d 00 00       	call   f30 <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 0e 0e 00 00       	call   f80 <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 af 0d 00 00       	call   f30 <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 a0 0d 00 00       	call   f30 <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 ec             	mov    -0x14(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 12 02 00 00       	call   3bc <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 78 0d 00 00       	call   f30 <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 b9 0d 00 00       	call   f80 <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 5a 0d 00 00       	call   f30 <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 4b 0d 00 00       	call   f30 <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 2a 0d 00 00       	call   f30 <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 1b 0d 00 00       	call   f30 <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 f3 0c 00 00       	call   f10 <wait>
    wait();
     21d:	e8 ee 0c 00 00       	call   f10 <wait>
    break;
     222:	eb 22                	jmp    246 <runcmd+0x246>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(fork1() == 0)
     22a:	e8 8d 01 00 00       	call   3bc <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 12                	jne    245 <runcmd+0x245>
      runcmd(bcmd->cmd);
     233:	8b 45 f4             	mov    -0xc(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	90                   	nop
  }
  exit();
     246:	e8 bd 0c 00 00       	call   f08 <exit>

0000024b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24b:	55                   	push   %ebp
     24c:	89 e5                	mov    %esp,%ebp
     24e:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     251:	83 ec 08             	sub    $0x8,%esp
     254:	68 a8 14 00 00       	push   $0x14a8
     259:	6a 02                	push   $0x2
     25b:	e8 4c 0e 00 00       	call   10ac <printf>
     260:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 ec 04             	sub    $0x4,%esp
     269:	50                   	push   %eax
     26a:	6a 00                	push   $0x0
     26c:	ff 75 08             	push   0x8(%ebp)
     26f:	e8 c9 0a 00 00       	call   d3d <memset>
     274:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     277:	83 ec 08             	sub    $0x8,%esp
     27a:	ff 75 0c             	push   0xc(%ebp)
     27d:	ff 75 08             	push   0x8(%ebp)
     280:	e8 05 0b 00 00       	call   d8a <gets>
     285:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     288:	8b 45 08             	mov    0x8(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	75 07                	jne    299 <getcmd+0x4e>
    return -1;
     292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     297:	eb 05                	jmp    29e <getcmd+0x53>
  return 0;
     299:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29e:	c9                   	leave  
     29f:	c3                   	ret    

000002a0 <main>:

int
main(void)
{
     2a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     2a4:	83 e4 f0             	and    $0xfffffff0,%esp
     2a7:	ff 71 fc             	push   -0x4(%ecx)
     2aa:	55                   	push   %ebp
     2ab:	89 e5                	mov    %esp,%ebp
     2ad:	51                   	push   %ecx
     2ae:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  // printf(1, "shell pid: %d\n", getpid());
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     2b1:	eb 16                	jmp    2c9 <main+0x29>
    if(fd >= 3){
     2b3:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     2b7:	7e 10                	jle    2c9 <main+0x29>
      close(fd);
     2b9:	83 ec 0c             	sub    $0xc,%esp
     2bc:	ff 75 f4             	push   -0xc(%ebp)
     2bf:	e8 6c 0c 00 00       	call   f30 <close>
     2c4:	83 c4 10             	add    $0x10,%esp
      break;
     2c7:	eb 1b                	jmp    2e4 <main+0x44>
  while((fd = open("console", O_RDWR)) >= 0){
     2c9:	83 ec 08             	sub    $0x8,%esp
     2cc:	6a 02                	push   $0x2
     2ce:	68 ab 14 00 00       	push   $0x14ab
     2d3:	e8 70 0c 00 00       	call   f48 <open>
     2d8:	83 c4 10             	add    $0x10,%esp
     2db:	89 45 f4             	mov    %eax,-0xc(%ebp)
     2de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2e2:	79 cf                	jns    2b3 <main+0x13>
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2e4:	e9 94 00 00 00       	jmp    37d <main+0xdd>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2e9:	0f b6 05 80 15 00 00 	movzbl 0x1580,%eax
     2f0:	3c 63                	cmp    $0x63,%al
     2f2:	75 5f                	jne    353 <main+0xb3>
     2f4:	0f b6 05 81 15 00 00 	movzbl 0x1581,%eax
     2fb:	3c 64                	cmp    $0x64,%al
     2fd:	75 54                	jne    353 <main+0xb3>
     2ff:	0f b6 05 82 15 00 00 	movzbl 0x1582,%eax
     306:	3c 20                	cmp    $0x20,%al
     308:	75 49                	jne    353 <main+0xb3>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     30a:	83 ec 0c             	sub    $0xc,%esp
     30d:	68 80 15 00 00       	push   $0x1580
     312:	e8 ff 09 00 00       	call   d16 <strlen>
     317:	83 c4 10             	add    $0x10,%esp
     31a:	83 e8 01             	sub    $0x1,%eax
     31d:	c6 80 80 15 00 00 00 	movb   $0x0,0x1580(%eax)
      if(chdir(buf+3) < 0)
     324:	b8 83 15 00 00       	mov    $0x1583,%eax
     329:	83 ec 0c             	sub    $0xc,%esp
     32c:	50                   	push   %eax
     32d:	e8 46 0c 00 00       	call   f78 <chdir>
     332:	83 c4 10             	add    $0x10,%esp
     335:	85 c0                	test   %eax,%eax
     337:	79 44                	jns    37d <main+0xdd>
        printf(2, "cannot cd %s\n", buf+3);
     339:	b8 83 15 00 00       	mov    $0x1583,%eax
     33e:	83 ec 04             	sub    $0x4,%esp
     341:	50                   	push   %eax
     342:	68 b3 14 00 00       	push   $0x14b3
     347:	6a 02                	push   $0x2
     349:	e8 5e 0d 00 00       	call   10ac <printf>
     34e:	83 c4 10             	add    $0x10,%esp
      continue;
     351:	eb 2a                	jmp    37d <main+0xdd>
    }
    if(fork1() == 0)
     353:	e8 64 00 00 00       	call   3bc <fork1>
     358:	85 c0                	test   %eax,%eax
     35a:	75 1c                	jne    378 <main+0xd8>
      runcmd(parsecmd(buf));
     35c:	83 ec 0c             	sub    $0xc,%esp
     35f:	68 80 15 00 00       	push   $0x1580
     364:	e8 aa 03 00 00       	call   713 <parsecmd>
     369:	83 c4 10             	add    $0x10,%esp
     36c:	83 ec 0c             	sub    $0xc,%esp
     36f:	50                   	push   %eax
     370:	e8 8b fc ff ff       	call   0 <runcmd>
     375:	83 c4 10             	add    $0x10,%esp
    wait();
     378:	e8 93 0b 00 00       	call   f10 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     37d:	83 ec 08             	sub    $0x8,%esp
     380:	6a 64                	push   $0x64
     382:	68 80 15 00 00       	push   $0x1580
     387:	e8 bf fe ff ff       	call   24b <getcmd>
     38c:	83 c4 10             	add    $0x10,%esp
     38f:	85 c0                	test   %eax,%eax
     391:	0f 89 52 ff ff ff    	jns    2e9 <main+0x49>
  }
  exit();
     397:	e8 6c 0b 00 00       	call   f08 <exit>

0000039c <panic>:
}

void
panic(char *s)
{
     39c:	55                   	push   %ebp
     39d:	89 e5                	mov    %esp,%ebp
     39f:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     3a2:	83 ec 04             	sub    $0x4,%esp
     3a5:	ff 75 08             	push   0x8(%ebp)
     3a8:	68 c1 14 00 00       	push   $0x14c1
     3ad:	6a 02                	push   $0x2
     3af:	e8 f8 0c 00 00       	call   10ac <printf>
     3b4:	83 c4 10             	add    $0x10,%esp
  exit();
     3b7:	e8 4c 0b 00 00       	call   f08 <exit>

000003bc <fork1>:
}

int
fork1(void)
{
     3bc:	55                   	push   %ebp
     3bd:	89 e5                	mov    %esp,%ebp
     3bf:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     3c2:	e8 39 0b 00 00       	call   f00 <fork>
     3c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     3ca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     3ce:	75 10                	jne    3e0 <fork1+0x24>
    panic("fork");
     3d0:	83 ec 0c             	sub    $0xc,%esp
     3d3:	68 c5 14 00 00       	push   $0x14c5
     3d8:	e8 bf ff ff ff       	call   39c <panic>
     3dd:	83 c4 10             	add    $0x10,%esp
  return pid;
     3e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3e3:	c9                   	leave  
     3e4:	c3                   	ret    

000003e5 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3e5:	55                   	push   %ebp
     3e6:	89 e5                	mov    %esp,%ebp
     3e8:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3eb:	83 ec 0c             	sub    $0xc,%esp
     3ee:	6a 54                	push   $0x54
     3f0:	e8 8b 0f 00 00       	call   1380 <malloc>
     3f5:	83 c4 10             	add    $0x10,%esp
     3f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3fb:	83 ec 04             	sub    $0x4,%esp
     3fe:	6a 54                	push   $0x54
     400:	6a 00                	push   $0x0
     402:	ff 75 f4             	push   -0xc(%ebp)
     405:	e8 33 09 00 00       	call   d3d <memset>
     40a:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     40d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     410:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     416:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     419:	c9                   	leave  
     41a:	c3                   	ret    

0000041b <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     41b:	55                   	push   %ebp
     41c:	89 e5                	mov    %esp,%ebp
     41e:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     421:	83 ec 0c             	sub    $0xc,%esp
     424:	6a 18                	push   $0x18
     426:	e8 55 0f 00 00       	call   1380 <malloc>
     42b:	83 c4 10             	add    $0x10,%esp
     42e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     431:	83 ec 04             	sub    $0x4,%esp
     434:	6a 18                	push   $0x18
     436:	6a 00                	push   $0x0
     438:	ff 75 f4             	push   -0xc(%ebp)
     43b:	e8 fd 08 00 00       	call   d3d <memset>
     440:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     443:	8b 45 f4             	mov    -0xc(%ebp),%eax
     446:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     44c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     44f:	8b 55 08             	mov    0x8(%ebp),%edx
     452:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     455:	8b 45 f4             	mov    -0xc(%ebp),%eax
     458:	8b 55 0c             	mov    0xc(%ebp),%edx
     45b:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     45e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     461:	8b 55 10             	mov    0x10(%ebp),%edx
     464:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     467:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46a:	8b 55 14             	mov    0x14(%ebp),%edx
     46d:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     470:	8b 45 f4             	mov    -0xc(%ebp),%eax
     473:	8b 55 18             	mov    0x18(%ebp),%edx
     476:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     479:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     47c:	c9                   	leave  
     47d:	c3                   	ret    

0000047e <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     47e:	55                   	push   %ebp
     47f:	89 e5                	mov    %esp,%ebp
     481:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     484:	83 ec 0c             	sub    $0xc,%esp
     487:	6a 0c                	push   $0xc
     489:	e8 f2 0e 00 00       	call   1380 <malloc>
     48e:	83 c4 10             	add    $0x10,%esp
     491:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     494:	83 ec 04             	sub    $0x4,%esp
     497:	6a 0c                	push   $0xc
     499:	6a 00                	push   $0x0
     49b:	ff 75 f4             	push   -0xc(%ebp)
     49e:	e8 9a 08 00 00       	call   d3d <memset>
     4a3:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a9:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b2:	8b 55 08             	mov    0x8(%ebp),%edx
     4b5:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4bb:	8b 55 0c             	mov    0xc(%ebp),%edx
     4be:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4c4:	c9                   	leave  
     4c5:	c3                   	ret    

000004c6 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     4c6:	55                   	push   %ebp
     4c7:	89 e5                	mov    %esp,%ebp
     4c9:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4cc:	83 ec 0c             	sub    $0xc,%esp
     4cf:	6a 0c                	push   $0xc
     4d1:	e8 aa 0e 00 00       	call   1380 <malloc>
     4d6:	83 c4 10             	add    $0x10,%esp
     4d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4dc:	83 ec 04             	sub    $0x4,%esp
     4df:	6a 0c                	push   $0xc
     4e1:	6a 00                	push   $0x0
     4e3:	ff 75 f4             	push   -0xc(%ebp)
     4e6:	e8 52 08 00 00       	call   d3d <memset>
     4eb:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     4ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f1:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fa:	8b 55 08             	mov    0x8(%ebp),%edx
     4fd:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     500:	8b 45 f4             	mov    -0xc(%ebp),%eax
     503:	8b 55 0c             	mov    0xc(%ebp),%edx
     506:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     509:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     50c:	c9                   	leave  
     50d:	c3                   	ret    

0000050e <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     50e:	55                   	push   %ebp
     50f:	89 e5                	mov    %esp,%ebp
     511:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     514:	83 ec 0c             	sub    $0xc,%esp
     517:	6a 08                	push   $0x8
     519:	e8 62 0e 00 00       	call   1380 <malloc>
     51e:	83 c4 10             	add    $0x10,%esp
     521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     524:	83 ec 04             	sub    $0x4,%esp
     527:	6a 08                	push   $0x8
     529:	6a 00                	push   $0x0
     52b:	ff 75 f4             	push   -0xc(%ebp)
     52e:	e8 0a 08 00 00       	call   d3d <memset>
     533:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     536:	8b 45 f4             	mov    -0xc(%ebp),%eax
     539:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     542:	8b 55 08             	mov    0x8(%ebp),%edx
     545:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     548:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     54b:	c9                   	leave  
     54c:	c3                   	ret    

0000054d <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     54d:	55                   	push   %ebp
     54e:	89 e5                	mov    %esp,%ebp
     550:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     553:	8b 45 08             	mov    0x8(%ebp),%eax
     556:	8b 00                	mov    (%eax),%eax
     558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     55b:	eb 04                	jmp    561 <gettoken+0x14>
    s++;
     55d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     561:	8b 45 f4             	mov    -0xc(%ebp),%eax
     564:	3b 45 0c             	cmp    0xc(%ebp),%eax
     567:	73 1e                	jae    587 <gettoken+0x3a>
     569:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56c:	0f b6 00             	movzbl (%eax),%eax
     56f:	0f be c0             	movsbl %al,%eax
     572:	83 ec 08             	sub    $0x8,%esp
     575:	50                   	push   %eax
     576:	68 5c 15 00 00       	push   $0x155c
     57b:	e8 d7 07 00 00       	call   d57 <strchr>
     580:	83 c4 10             	add    $0x10,%esp
     583:	85 c0                	test   %eax,%eax
     585:	75 d6                	jne    55d <gettoken+0x10>
  if(q)
     587:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     58b:	74 08                	je     595 <gettoken+0x48>
    *q = s;
     58d:	8b 45 10             	mov    0x10(%ebp),%eax
     590:	8b 55 f4             	mov    -0xc(%ebp),%edx
     593:	89 10                	mov    %edx,(%eax)
  ret = *s;
     595:	8b 45 f4             	mov    -0xc(%ebp),%eax
     598:	0f b6 00             	movzbl (%eax),%eax
     59b:	0f be c0             	movsbl %al,%eax
     59e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     5a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a4:	0f b6 00             	movzbl (%eax),%eax
     5a7:	0f be c0             	movsbl %al,%eax
     5aa:	83 f8 7c             	cmp    $0x7c,%eax
     5ad:	74 2c                	je     5db <gettoken+0x8e>
     5af:	83 f8 7c             	cmp    $0x7c,%eax
     5b2:	7f 48                	jg     5fc <gettoken+0xaf>
     5b4:	83 f8 3e             	cmp    $0x3e,%eax
     5b7:	74 28                	je     5e1 <gettoken+0x94>
     5b9:	83 f8 3e             	cmp    $0x3e,%eax
     5bc:	7f 3e                	jg     5fc <gettoken+0xaf>
     5be:	83 f8 3c             	cmp    $0x3c,%eax
     5c1:	7f 39                	jg     5fc <gettoken+0xaf>
     5c3:	83 f8 3b             	cmp    $0x3b,%eax
     5c6:	7d 13                	jge    5db <gettoken+0x8e>
     5c8:	83 f8 29             	cmp    $0x29,%eax
     5cb:	7f 2f                	jg     5fc <gettoken+0xaf>
     5cd:	83 f8 28             	cmp    $0x28,%eax
     5d0:	7d 09                	jge    5db <gettoken+0x8e>
     5d2:	85 c0                	test   %eax,%eax
     5d4:	74 79                	je     64f <gettoken+0x102>
     5d6:	83 f8 26             	cmp    $0x26,%eax
     5d9:	75 21                	jne    5fc <gettoken+0xaf>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     5df:	eb 75                	jmp    656 <gettoken+0x109>
  case '>':
    s++;
     5e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     5e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e8:	0f b6 00             	movzbl (%eax),%eax
     5eb:	3c 3e                	cmp    $0x3e,%al
     5ed:	75 63                	jne    652 <gettoken+0x105>
      ret = '+';
     5ef:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5f6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     5fa:	eb 56                	jmp    652 <gettoken+0x105>
  default:
    ret = 'a';
     5fc:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     603:	eb 04                	jmp    609 <gettoken+0xbc>
      s++;
     605:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     609:	8b 45 f4             	mov    -0xc(%ebp),%eax
     60c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     60f:	73 44                	jae    655 <gettoken+0x108>
     611:	8b 45 f4             	mov    -0xc(%ebp),%eax
     614:	0f b6 00             	movzbl (%eax),%eax
     617:	0f be c0             	movsbl %al,%eax
     61a:	83 ec 08             	sub    $0x8,%esp
     61d:	50                   	push   %eax
     61e:	68 5c 15 00 00       	push   $0x155c
     623:	e8 2f 07 00 00       	call   d57 <strchr>
     628:	83 c4 10             	add    $0x10,%esp
     62b:	85 c0                	test   %eax,%eax
     62d:	75 26                	jne    655 <gettoken+0x108>
     62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     632:	0f b6 00             	movzbl (%eax),%eax
     635:	0f be c0             	movsbl %al,%eax
     638:	83 ec 08             	sub    $0x8,%esp
     63b:	50                   	push   %eax
     63c:	68 64 15 00 00       	push   $0x1564
     641:	e8 11 07 00 00       	call   d57 <strchr>
     646:	83 c4 10             	add    $0x10,%esp
     649:	85 c0                	test   %eax,%eax
     64b:	74 b8                	je     605 <gettoken+0xb8>
    break;
     64d:	eb 06                	jmp    655 <gettoken+0x108>
    break;
     64f:	90                   	nop
     650:	eb 04                	jmp    656 <gettoken+0x109>
    break;
     652:	90                   	nop
     653:	eb 01                	jmp    656 <gettoken+0x109>
    break;
     655:	90                   	nop
  }
  if(eq)
     656:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     65a:	74 0e                	je     66a <gettoken+0x11d>
    *eq = s;
     65c:	8b 45 14             	mov    0x14(%ebp),%eax
     65f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     662:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     664:	eb 04                	jmp    66a <gettoken+0x11d>
    s++;
     666:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     66a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     66d:	3b 45 0c             	cmp    0xc(%ebp),%eax
     670:	73 1e                	jae    690 <gettoken+0x143>
     672:	8b 45 f4             	mov    -0xc(%ebp),%eax
     675:	0f b6 00             	movzbl (%eax),%eax
     678:	0f be c0             	movsbl %al,%eax
     67b:	83 ec 08             	sub    $0x8,%esp
     67e:	50                   	push   %eax
     67f:	68 5c 15 00 00       	push   $0x155c
     684:	e8 ce 06 00 00       	call   d57 <strchr>
     689:	83 c4 10             	add    $0x10,%esp
     68c:	85 c0                	test   %eax,%eax
     68e:	75 d6                	jne    666 <gettoken+0x119>
  *ps = s;
     690:	8b 45 08             	mov    0x8(%ebp),%eax
     693:	8b 55 f4             	mov    -0xc(%ebp),%edx
     696:	89 10                	mov    %edx,(%eax)
  return ret;
     698:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     69b:	c9                   	leave  
     69c:	c3                   	ret    

0000069d <peek>:

int
peek(char **ps, char *es, char *toks)
{
     69d:	55                   	push   %ebp
     69e:	89 e5                	mov    %esp,%ebp
     6a0:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     6a3:	8b 45 08             	mov    0x8(%ebp),%eax
     6a6:	8b 00                	mov    (%eax),%eax
     6a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6ab:	eb 04                	jmp    6b1 <peek+0x14>
    s++;
     6ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     6b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6b7:	73 1e                	jae    6d7 <peek+0x3a>
     6b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6bc:	0f b6 00             	movzbl (%eax),%eax
     6bf:	0f be c0             	movsbl %al,%eax
     6c2:	83 ec 08             	sub    $0x8,%esp
     6c5:	50                   	push   %eax
     6c6:	68 5c 15 00 00       	push   $0x155c
     6cb:	e8 87 06 00 00       	call   d57 <strchr>
     6d0:	83 c4 10             	add    $0x10,%esp
     6d3:	85 c0                	test   %eax,%eax
     6d5:	75 d6                	jne    6ad <peek+0x10>
  *ps = s;
     6d7:	8b 45 08             	mov    0x8(%ebp),%eax
     6da:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6dd:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e2:	0f b6 00             	movzbl (%eax),%eax
     6e5:	84 c0                	test   %al,%al
     6e7:	74 23                	je     70c <peek+0x6f>
     6e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ec:	0f b6 00             	movzbl (%eax),%eax
     6ef:	0f be c0             	movsbl %al,%eax
     6f2:	83 ec 08             	sub    $0x8,%esp
     6f5:	50                   	push   %eax
     6f6:	ff 75 10             	push   0x10(%ebp)
     6f9:	e8 59 06 00 00       	call   d57 <strchr>
     6fe:	83 c4 10             	add    $0x10,%esp
     701:	85 c0                	test   %eax,%eax
     703:	74 07                	je     70c <peek+0x6f>
     705:	b8 01 00 00 00       	mov    $0x1,%eax
     70a:	eb 05                	jmp    711 <peek+0x74>
     70c:	b8 00 00 00 00       	mov    $0x0,%eax
}
     711:	c9                   	leave  
     712:	c3                   	ret    

00000713 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     713:	55                   	push   %ebp
     714:	89 e5                	mov    %esp,%ebp
     716:	53                   	push   %ebx
     717:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     71a:	8b 5d 08             	mov    0x8(%ebp),%ebx
     71d:	8b 45 08             	mov    0x8(%ebp),%eax
     720:	83 ec 0c             	sub    $0xc,%esp
     723:	50                   	push   %eax
     724:	e8 ed 05 00 00       	call   d16 <strlen>
     729:	83 c4 10             	add    $0x10,%esp
     72c:	01 d8                	add    %ebx,%eax
     72e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     731:	83 ec 08             	sub    $0x8,%esp
     734:	ff 75 f4             	push   -0xc(%ebp)
     737:	8d 45 08             	lea    0x8(%ebp),%eax
     73a:	50                   	push   %eax
     73b:	e8 61 00 00 00       	call   7a1 <parseline>
     740:	83 c4 10             	add    $0x10,%esp
     743:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     746:	83 ec 04             	sub    $0x4,%esp
     749:	68 ca 14 00 00       	push   $0x14ca
     74e:	ff 75 f4             	push   -0xc(%ebp)
     751:	8d 45 08             	lea    0x8(%ebp),%eax
     754:	50                   	push   %eax
     755:	e8 43 ff ff ff       	call   69d <peek>
     75a:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     75d:	8b 45 08             	mov    0x8(%ebp),%eax
     760:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     763:	74 26                	je     78b <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     765:	8b 45 08             	mov    0x8(%ebp),%eax
     768:	83 ec 04             	sub    $0x4,%esp
     76b:	50                   	push   %eax
     76c:	68 cb 14 00 00       	push   $0x14cb
     771:	6a 02                	push   $0x2
     773:	e8 34 09 00 00       	call   10ac <printf>
     778:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     77b:	83 ec 0c             	sub    $0xc,%esp
     77e:	68 da 14 00 00       	push   $0x14da
     783:	e8 14 fc ff ff       	call   39c <panic>
     788:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     78b:	83 ec 0c             	sub    $0xc,%esp
     78e:	ff 75 f0             	push   -0x10(%ebp)
     791:	e8 ef 03 00 00       	call   b85 <nulterminate>
     796:	83 c4 10             	add    $0x10,%esp
  return cmd;
     799:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     79c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     79f:	c9                   	leave  
     7a0:	c3                   	ret    

000007a1 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     7a1:	55                   	push   %ebp
     7a2:	89 e5                	mov    %esp,%ebp
     7a4:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     7a7:	83 ec 08             	sub    $0x8,%esp
     7aa:	ff 75 0c             	push   0xc(%ebp)
     7ad:	ff 75 08             	push   0x8(%ebp)
     7b0:	e8 99 00 00 00       	call   84e <parsepipe>
     7b5:	83 c4 10             	add    $0x10,%esp
     7b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7bb:	eb 23                	jmp    7e0 <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     7bd:	6a 00                	push   $0x0
     7bf:	6a 00                	push   $0x0
     7c1:	ff 75 0c             	push   0xc(%ebp)
     7c4:	ff 75 08             	push   0x8(%ebp)
     7c7:	e8 81 fd ff ff       	call   54d <gettoken>
     7cc:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     7cf:	83 ec 0c             	sub    $0xc,%esp
     7d2:	ff 75 f4             	push   -0xc(%ebp)
     7d5:	e8 34 fd ff ff       	call   50e <backcmd>
     7da:	83 c4 10             	add    $0x10,%esp
     7dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     7e0:	83 ec 04             	sub    $0x4,%esp
     7e3:	68 e1 14 00 00       	push   $0x14e1
     7e8:	ff 75 0c             	push   0xc(%ebp)
     7eb:	ff 75 08             	push   0x8(%ebp)
     7ee:	e8 aa fe ff ff       	call   69d <peek>
     7f3:	83 c4 10             	add    $0x10,%esp
     7f6:	85 c0                	test   %eax,%eax
     7f8:	75 c3                	jne    7bd <parseline+0x1c>
  }
  if(peek(ps, es, ";")){
     7fa:	83 ec 04             	sub    $0x4,%esp
     7fd:	68 e3 14 00 00       	push   $0x14e3
     802:	ff 75 0c             	push   0xc(%ebp)
     805:	ff 75 08             	push   0x8(%ebp)
     808:	e8 90 fe ff ff       	call   69d <peek>
     80d:	83 c4 10             	add    $0x10,%esp
     810:	85 c0                	test   %eax,%eax
     812:	74 35                	je     849 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     814:	6a 00                	push   $0x0
     816:	6a 00                	push   $0x0
     818:	ff 75 0c             	push   0xc(%ebp)
     81b:	ff 75 08             	push   0x8(%ebp)
     81e:	e8 2a fd ff ff       	call   54d <gettoken>
     823:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     826:	83 ec 08             	sub    $0x8,%esp
     829:	ff 75 0c             	push   0xc(%ebp)
     82c:	ff 75 08             	push   0x8(%ebp)
     82f:	e8 6d ff ff ff       	call   7a1 <parseline>
     834:	83 c4 10             	add    $0x10,%esp
     837:	83 ec 08             	sub    $0x8,%esp
     83a:	50                   	push   %eax
     83b:	ff 75 f4             	push   -0xc(%ebp)
     83e:	e8 83 fc ff ff       	call   4c6 <listcmd>
     843:	83 c4 10             	add    $0x10,%esp
     846:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     849:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     84c:	c9                   	leave  
     84d:	c3                   	ret    

0000084e <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     84e:	55                   	push   %ebp
     84f:	89 e5                	mov    %esp,%ebp
     851:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     854:	83 ec 08             	sub    $0x8,%esp
     857:	ff 75 0c             	push   0xc(%ebp)
     85a:	ff 75 08             	push   0x8(%ebp)
     85d:	e8 f0 01 00 00       	call   a52 <parseexec>
     862:	83 c4 10             	add    $0x10,%esp
     865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     868:	83 ec 04             	sub    $0x4,%esp
     86b:	68 e5 14 00 00       	push   $0x14e5
     870:	ff 75 0c             	push   0xc(%ebp)
     873:	ff 75 08             	push   0x8(%ebp)
     876:	e8 22 fe ff ff       	call   69d <peek>
     87b:	83 c4 10             	add    $0x10,%esp
     87e:	85 c0                	test   %eax,%eax
     880:	74 35                	je     8b7 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     882:	6a 00                	push   $0x0
     884:	6a 00                	push   $0x0
     886:	ff 75 0c             	push   0xc(%ebp)
     889:	ff 75 08             	push   0x8(%ebp)
     88c:	e8 bc fc ff ff       	call   54d <gettoken>
     891:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     894:	83 ec 08             	sub    $0x8,%esp
     897:	ff 75 0c             	push   0xc(%ebp)
     89a:	ff 75 08             	push   0x8(%ebp)
     89d:	e8 ac ff ff ff       	call   84e <parsepipe>
     8a2:	83 c4 10             	add    $0x10,%esp
     8a5:	83 ec 08             	sub    $0x8,%esp
     8a8:	50                   	push   %eax
     8a9:	ff 75 f4             	push   -0xc(%ebp)
     8ac:	e8 cd fb ff ff       	call   47e <pipecmd>
     8b1:	83 c4 10             	add    $0x10,%esp
     8b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8ba:	c9                   	leave  
     8bb:	c3                   	ret    

000008bc <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8bc:	55                   	push   %ebp
     8bd:	89 e5                	mov    %esp,%ebp
     8bf:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8c2:	e9 ba 00 00 00       	jmp    981 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
     8c7:	6a 00                	push   $0x0
     8c9:	6a 00                	push   $0x0
     8cb:	ff 75 10             	push   0x10(%ebp)
     8ce:	ff 75 0c             	push   0xc(%ebp)
     8d1:	e8 77 fc ff ff       	call   54d <gettoken>
     8d6:	83 c4 10             	add    $0x10,%esp
     8d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8df:	50                   	push   %eax
     8e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8e3:	50                   	push   %eax
     8e4:	ff 75 10             	push   0x10(%ebp)
     8e7:	ff 75 0c             	push   0xc(%ebp)
     8ea:	e8 5e fc ff ff       	call   54d <gettoken>
     8ef:	83 c4 10             	add    $0x10,%esp
     8f2:	83 f8 61             	cmp    $0x61,%eax
     8f5:	74 10                	je     907 <parseredirs+0x4b>
      panic("missing file for redirection");
     8f7:	83 ec 0c             	sub    $0xc,%esp
     8fa:	68 e7 14 00 00       	push   $0x14e7
     8ff:	e8 98 fa ff ff       	call   39c <panic>
     904:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     907:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
     90b:	74 31                	je     93e <parseredirs+0x82>
     90d:	83 7d f4 3e          	cmpl   $0x3e,-0xc(%ebp)
     911:	7f 6e                	jg     981 <parseredirs+0xc5>
     913:	83 7d f4 2b          	cmpl   $0x2b,-0xc(%ebp)
     917:	74 47                	je     960 <parseredirs+0xa4>
     919:	83 7d f4 3c          	cmpl   $0x3c,-0xc(%ebp)
     91d:	75 62                	jne    981 <parseredirs+0xc5>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     91f:	8b 55 ec             	mov    -0x14(%ebp),%edx
     922:	8b 45 f0             	mov    -0x10(%ebp),%eax
     925:	83 ec 0c             	sub    $0xc,%esp
     928:	6a 00                	push   $0x0
     92a:	6a 00                	push   $0x0
     92c:	52                   	push   %edx
     92d:	50                   	push   %eax
     92e:	ff 75 08             	push   0x8(%ebp)
     931:	e8 e5 fa ff ff       	call   41b <redircmd>
     936:	83 c4 20             	add    $0x20,%esp
     939:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     93c:	eb 43                	jmp    981 <parseredirs+0xc5>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     93e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     941:	8b 45 f0             	mov    -0x10(%ebp),%eax
     944:	83 ec 0c             	sub    $0xc,%esp
     947:	6a 01                	push   $0x1
     949:	68 01 02 00 00       	push   $0x201
     94e:	52                   	push   %edx
     94f:	50                   	push   %eax
     950:	ff 75 08             	push   0x8(%ebp)
     953:	e8 c3 fa ff ff       	call   41b <redircmd>
     958:	83 c4 20             	add    $0x20,%esp
     95b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     95e:	eb 21                	jmp    981 <parseredirs+0xc5>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     960:	8b 55 ec             	mov    -0x14(%ebp),%edx
     963:	8b 45 f0             	mov    -0x10(%ebp),%eax
     966:	83 ec 0c             	sub    $0xc,%esp
     969:	6a 01                	push   $0x1
     96b:	68 01 02 00 00       	push   $0x201
     970:	52                   	push   %edx
     971:	50                   	push   %eax
     972:	ff 75 08             	push   0x8(%ebp)
     975:	e8 a1 fa ff ff       	call   41b <redircmd>
     97a:	83 c4 20             	add    $0x20,%esp
     97d:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     980:	90                   	nop
  while(peek(ps, es, "<>")){
     981:	83 ec 04             	sub    $0x4,%esp
     984:	68 04 15 00 00       	push   $0x1504
     989:	ff 75 10             	push   0x10(%ebp)
     98c:	ff 75 0c             	push   0xc(%ebp)
     98f:	e8 09 fd ff ff       	call   69d <peek>
     994:	83 c4 10             	add    $0x10,%esp
     997:	85 c0                	test   %eax,%eax
     999:	0f 85 28 ff ff ff    	jne    8c7 <parseredirs+0xb>
    }
  }
  return cmd;
     99f:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9a2:	c9                   	leave  
     9a3:	c3                   	ret    

000009a4 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9a4:	55                   	push   %ebp
     9a5:	89 e5                	mov    %esp,%ebp
     9a7:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     9aa:	83 ec 04             	sub    $0x4,%esp
     9ad:	68 07 15 00 00       	push   $0x1507
     9b2:	ff 75 0c             	push   0xc(%ebp)
     9b5:	ff 75 08             	push   0x8(%ebp)
     9b8:	e8 e0 fc ff ff       	call   69d <peek>
     9bd:	83 c4 10             	add    $0x10,%esp
     9c0:	85 c0                	test   %eax,%eax
     9c2:	75 10                	jne    9d4 <parseblock+0x30>
    panic("parseblock");
     9c4:	83 ec 0c             	sub    $0xc,%esp
     9c7:	68 09 15 00 00       	push   $0x1509
     9cc:	e8 cb f9 ff ff       	call   39c <panic>
     9d1:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     9d4:	6a 00                	push   $0x0
     9d6:	6a 00                	push   $0x0
     9d8:	ff 75 0c             	push   0xc(%ebp)
     9db:	ff 75 08             	push   0x8(%ebp)
     9de:	e8 6a fb ff ff       	call   54d <gettoken>
     9e3:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     9e6:	83 ec 08             	sub    $0x8,%esp
     9e9:	ff 75 0c             	push   0xc(%ebp)
     9ec:	ff 75 08             	push   0x8(%ebp)
     9ef:	e8 ad fd ff ff       	call   7a1 <parseline>
     9f4:	83 c4 10             	add    $0x10,%esp
     9f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     9fa:	83 ec 04             	sub    $0x4,%esp
     9fd:	68 14 15 00 00       	push   $0x1514
     a02:	ff 75 0c             	push   0xc(%ebp)
     a05:	ff 75 08             	push   0x8(%ebp)
     a08:	e8 90 fc ff ff       	call   69d <peek>
     a0d:	83 c4 10             	add    $0x10,%esp
     a10:	85 c0                	test   %eax,%eax
     a12:	75 10                	jne    a24 <parseblock+0x80>
    panic("syntax - missing )");
     a14:	83 ec 0c             	sub    $0xc,%esp
     a17:	68 16 15 00 00       	push   $0x1516
     a1c:	e8 7b f9 ff ff       	call   39c <panic>
     a21:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     a24:	6a 00                	push   $0x0
     a26:	6a 00                	push   $0x0
     a28:	ff 75 0c             	push   0xc(%ebp)
     a2b:	ff 75 08             	push   0x8(%ebp)
     a2e:	e8 1a fb ff ff       	call   54d <gettoken>
     a33:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     a36:	83 ec 04             	sub    $0x4,%esp
     a39:	ff 75 0c             	push   0xc(%ebp)
     a3c:	ff 75 08             	push   0x8(%ebp)
     a3f:	ff 75 f4             	push   -0xc(%ebp)
     a42:	e8 75 fe ff ff       	call   8bc <parseredirs>
     a47:	83 c4 10             	add    $0x10,%esp
     a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a50:	c9                   	leave  
     a51:	c3                   	ret    

00000a52 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     a52:	55                   	push   %ebp
     a53:	89 e5                	mov    %esp,%ebp
     a55:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     a58:	83 ec 04             	sub    $0x4,%esp
     a5b:	68 07 15 00 00       	push   $0x1507
     a60:	ff 75 0c             	push   0xc(%ebp)
     a63:	ff 75 08             	push   0x8(%ebp)
     a66:	e8 32 fc ff ff       	call   69d <peek>
     a6b:	83 c4 10             	add    $0x10,%esp
     a6e:	85 c0                	test   %eax,%eax
     a70:	74 16                	je     a88 <parseexec+0x36>
    return parseblock(ps, es);
     a72:	83 ec 08             	sub    $0x8,%esp
     a75:	ff 75 0c             	push   0xc(%ebp)
     a78:	ff 75 08             	push   0x8(%ebp)
     a7b:	e8 24 ff ff ff       	call   9a4 <parseblock>
     a80:	83 c4 10             	add    $0x10,%esp
     a83:	e9 fb 00 00 00       	jmp    b83 <parseexec+0x131>

  ret = execcmd();
     a88:	e8 58 f9 ff ff       	call   3e5 <execcmd>
     a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a93:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     a9d:	83 ec 04             	sub    $0x4,%esp
     aa0:	ff 75 0c             	push   0xc(%ebp)
     aa3:	ff 75 08             	push   0x8(%ebp)
     aa6:	ff 75 f0             	push   -0x10(%ebp)
     aa9:	e8 0e fe ff ff       	call   8bc <parseredirs>
     aae:	83 c4 10             	add    $0x10,%esp
     ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     ab4:	e9 87 00 00 00       	jmp    b40 <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     ab9:	8d 45 e0             	lea    -0x20(%ebp),%eax
     abc:	50                   	push   %eax
     abd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     ac0:	50                   	push   %eax
     ac1:	ff 75 0c             	push   0xc(%ebp)
     ac4:	ff 75 08             	push   0x8(%ebp)
     ac7:	e8 81 fa ff ff       	call   54d <gettoken>
     acc:	83 c4 10             	add    $0x10,%esp
     acf:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ad2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ad6:	0f 84 84 00 00 00    	je     b60 <parseexec+0x10e>
      break;
    if(tok != 'a')
     adc:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     ae0:	74 10                	je     af2 <parseexec+0xa0>
      panic("syntax");
     ae2:	83 ec 0c             	sub    $0xc,%esp
     ae5:	68 da 14 00 00       	push   $0x14da
     aea:	e8 ad f8 ff ff       	call   39c <panic>
     aef:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     af2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     afb:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     aff:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b02:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b08:	83 c1 08             	add    $0x8,%ecx
     b0b:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     b13:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     b17:	7e 10                	jle    b29 <parseexec+0xd7>
      panic("too many args");
     b19:	83 ec 0c             	sub    $0xc,%esp
     b1c:	68 29 15 00 00       	push   $0x1529
     b21:	e8 76 f8 ff ff       	call   39c <panic>
     b26:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     b29:	83 ec 04             	sub    $0x4,%esp
     b2c:	ff 75 0c             	push   0xc(%ebp)
     b2f:	ff 75 08             	push   0x8(%ebp)
     b32:	ff 75 f0             	push   -0x10(%ebp)
     b35:	e8 82 fd ff ff       	call   8bc <parseredirs>
     b3a:	83 c4 10             	add    $0x10,%esp
     b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b40:	83 ec 04             	sub    $0x4,%esp
     b43:	68 37 15 00 00       	push   $0x1537
     b48:	ff 75 0c             	push   0xc(%ebp)
     b4b:	ff 75 08             	push   0x8(%ebp)
     b4e:	e8 4a fb ff ff       	call   69d <peek>
     b53:	83 c4 10             	add    $0x10,%esp
     b56:	85 c0                	test   %eax,%eax
     b58:	0f 84 5b ff ff ff    	je     ab9 <parseexec+0x67>
     b5e:	eb 01                	jmp    b61 <parseexec+0x10f>
      break;
     b60:	90                   	nop
  }
  cmd->argv[argc] = 0;
     b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b67:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     b6e:	00 
  cmd->eargv[argc] = 0;
     b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b75:	83 c2 08             	add    $0x8,%edx
     b78:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     b7f:	00 
  return ret;
     b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b83:	c9                   	leave  
     b84:	c3                   	ret    

00000b85 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b85:	55                   	push   %ebp
     b86:	89 e5                	mov    %esp,%ebp
     b88:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b8f:	75 0a                	jne    b9b <nulterminate+0x16>
    return 0;
     b91:	b8 00 00 00 00       	mov    $0x0,%eax
     b96:	e9 e4 00 00 00       	jmp    c7f <nulterminate+0xfa>
  
  switch(cmd->type){
     b9b:	8b 45 08             	mov    0x8(%ebp),%eax
     b9e:	8b 00                	mov    (%eax),%eax
     ba0:	83 f8 05             	cmp    $0x5,%eax
     ba3:	0f 87 d3 00 00 00    	ja     c7c <nulterminate+0xf7>
     ba9:	8b 04 85 3c 15 00 00 	mov    0x153c(,%eax,4),%eax
     bb0:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     bb2:	8b 45 08             	mov    0x8(%ebp),%eax
     bb5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     bb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bbf:	eb 14                	jmp    bd5 <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bc7:	83 c2 08             	add    $0x8,%edx
     bca:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     bce:	c6 00 00             	movb   $0x0,(%eax)
    for(i=0; ecmd->argv[i]; i++)
     bd1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bdb:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     bdf:	85 c0                	test   %eax,%eax
     be1:	75 de                	jne    bc1 <nulterminate+0x3c>
    break;
     be3:	e9 94 00 00 00       	jmp    c7c <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     be8:	8b 45 08             	mov    0x8(%ebp),%eax
     beb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(rcmd->cmd);
     bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bf1:	8b 40 04             	mov    0x4(%eax),%eax
     bf4:	83 ec 0c             	sub    $0xc,%esp
     bf7:	50                   	push   %eax
     bf8:	e8 88 ff ff ff       	call   b85 <nulterminate>
     bfd:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c03:	8b 40 0c             	mov    0xc(%eax),%eax
     c06:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c09:	eb 71                	jmp    c7c <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c0b:	8b 45 08             	mov    0x8(%ebp),%eax
     c0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c14:	8b 40 04             	mov    0x4(%eax),%eax
     c17:	83 ec 0c             	sub    $0xc,%esp
     c1a:	50                   	push   %eax
     c1b:	e8 65 ff ff ff       	call   b85 <nulterminate>
     c20:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     c23:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c26:	8b 40 08             	mov    0x8(%eax),%eax
     c29:	83 ec 0c             	sub    $0xc,%esp
     c2c:	50                   	push   %eax
     c2d:	e8 53 ff ff ff       	call   b85 <nulterminate>
     c32:	83 c4 10             	add    $0x10,%esp
    break;
     c35:	eb 45                	jmp    c7c <nulterminate+0xf7>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     c37:	8b 45 08             	mov    0x8(%ebp),%eax
     c3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(lcmd->left);
     c3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c40:	8b 40 04             	mov    0x4(%eax),%eax
     c43:	83 ec 0c             	sub    $0xc,%esp
     c46:	50                   	push   %eax
     c47:	e8 39 ff ff ff       	call   b85 <nulterminate>
     c4c:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     c4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c52:	8b 40 08             	mov    0x8(%eax),%eax
     c55:	83 ec 0c             	sub    $0xc,%esp
     c58:	50                   	push   %eax
     c59:	e8 27 ff ff ff       	call   b85 <nulterminate>
     c5e:	83 c4 10             	add    $0x10,%esp
    break;
     c61:	eb 19                	jmp    c7c <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     c63:	8b 45 08             	mov    0x8(%ebp),%eax
     c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    nulterminate(bcmd->cmd);
     c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c6c:	8b 40 04             	mov    0x4(%eax),%eax
     c6f:	83 ec 0c             	sub    $0xc,%esp
     c72:	50                   	push   %eax
     c73:	e8 0d ff ff ff       	call   b85 <nulterminate>
     c78:	83 c4 10             	add    $0x10,%esp
    break;
     c7b:	90                   	nop
  }
  return cmd;
     c7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c7f:	c9                   	leave  
     c80:	c3                   	ret    

00000c81 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     c81:	55                   	push   %ebp
     c82:	89 e5                	mov    %esp,%ebp
     c84:	57                   	push   %edi
     c85:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     c86:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c89:	8b 55 10             	mov    0x10(%ebp),%edx
     c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
     c8f:	89 cb                	mov    %ecx,%ebx
     c91:	89 df                	mov    %ebx,%edi
     c93:	89 d1                	mov    %edx,%ecx
     c95:	fc                   	cld    
     c96:	f3 aa                	rep stos %al,%es:(%edi)
     c98:	89 ca                	mov    %ecx,%edx
     c9a:	89 fb                	mov    %edi,%ebx
     c9c:	89 5d 08             	mov    %ebx,0x8(%ebp)
     c9f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     ca2:	90                   	nop
     ca3:	5b                   	pop    %ebx
     ca4:	5f                   	pop    %edi
     ca5:	5d                   	pop    %ebp
     ca6:	c3                   	ret    

00000ca7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     ca7:	55                   	push   %ebp
     ca8:	89 e5                	mov    %esp,%ebp
     caa:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     cad:	8b 45 08             	mov    0x8(%ebp),%eax
     cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     cb3:	90                   	nop
     cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
     cb7:	8d 42 01             	lea    0x1(%edx),%eax
     cba:	89 45 0c             	mov    %eax,0xc(%ebp)
     cbd:	8b 45 08             	mov    0x8(%ebp),%eax
     cc0:	8d 48 01             	lea    0x1(%eax),%ecx
     cc3:	89 4d 08             	mov    %ecx,0x8(%ebp)
     cc6:	0f b6 12             	movzbl (%edx),%edx
     cc9:	88 10                	mov    %dl,(%eax)
     ccb:	0f b6 00             	movzbl (%eax),%eax
     cce:	84 c0                	test   %al,%al
     cd0:	75 e2                	jne    cb4 <strcpy+0xd>
    ;
  return os;
     cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cd5:	c9                   	leave  
     cd6:	c3                   	ret    

00000cd7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     cd7:	55                   	push   %ebp
     cd8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     cda:	eb 08                	jmp    ce4 <strcmp+0xd>
    p++, q++;
     cdc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     ce0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
     ce4:	8b 45 08             	mov    0x8(%ebp),%eax
     ce7:	0f b6 00             	movzbl (%eax),%eax
     cea:	84 c0                	test   %al,%al
     cec:	74 10                	je     cfe <strcmp+0x27>
     cee:	8b 45 08             	mov    0x8(%ebp),%eax
     cf1:	0f b6 10             	movzbl (%eax),%edx
     cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
     cf7:	0f b6 00             	movzbl (%eax),%eax
     cfa:	38 c2                	cmp    %al,%dl
     cfc:	74 de                	je     cdc <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
     cfe:	8b 45 08             	mov    0x8(%ebp),%eax
     d01:	0f b6 00             	movzbl (%eax),%eax
     d04:	0f b6 d0             	movzbl %al,%edx
     d07:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0a:	0f b6 00             	movzbl (%eax),%eax
     d0d:	0f b6 c8             	movzbl %al,%ecx
     d10:	89 d0                	mov    %edx,%eax
     d12:	29 c8                	sub    %ecx,%eax
}
     d14:	5d                   	pop    %ebp
     d15:	c3                   	ret    

00000d16 <strlen>:

uint
strlen(char *s)
{
     d16:	55                   	push   %ebp
     d17:	89 e5                	mov    %esp,%ebp
     d19:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     d1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     d23:	eb 04                	jmp    d29 <strlen+0x13>
     d25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d29:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d2c:	8b 45 08             	mov    0x8(%ebp),%eax
     d2f:	01 d0                	add    %edx,%eax
     d31:	0f b6 00             	movzbl (%eax),%eax
     d34:	84 c0                	test   %al,%al
     d36:	75 ed                	jne    d25 <strlen+0xf>
    ;
  return n;
     d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d3b:	c9                   	leave  
     d3c:	c3                   	ret    

00000d3d <memset>:

void*
memset(void *dst, int c, uint n)
{
     d3d:	55                   	push   %ebp
     d3e:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
     d40:	8b 45 10             	mov    0x10(%ebp),%eax
     d43:	50                   	push   %eax
     d44:	ff 75 0c             	push   0xc(%ebp)
     d47:	ff 75 08             	push   0x8(%ebp)
     d4a:	e8 32 ff ff ff       	call   c81 <stosb>
     d4f:	83 c4 0c             	add    $0xc,%esp
  return dst;
     d52:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d55:	c9                   	leave  
     d56:	c3                   	ret    

00000d57 <strchr>:

char*
strchr(const char *s, char c)
{
     d57:	55                   	push   %ebp
     d58:	89 e5                	mov    %esp,%ebp
     d5a:	83 ec 04             	sub    $0x4,%esp
     d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d60:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     d63:	eb 14                	jmp    d79 <strchr+0x22>
    if(*s == c)
     d65:	8b 45 08             	mov    0x8(%ebp),%eax
     d68:	0f b6 00             	movzbl (%eax),%eax
     d6b:	38 45 fc             	cmp    %al,-0x4(%ebp)
     d6e:	75 05                	jne    d75 <strchr+0x1e>
      return (char*)s;
     d70:	8b 45 08             	mov    0x8(%ebp),%eax
     d73:	eb 13                	jmp    d88 <strchr+0x31>
  for(; *s; s++)
     d75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     d79:	8b 45 08             	mov    0x8(%ebp),%eax
     d7c:	0f b6 00             	movzbl (%eax),%eax
     d7f:	84 c0                	test   %al,%al
     d81:	75 e2                	jne    d65 <strchr+0xe>
  return 0;
     d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d88:	c9                   	leave  
     d89:	c3                   	ret    

00000d8a <gets>:

char*
gets(char *buf, int max)
{
     d8a:	55                   	push   %ebp
     d8b:	89 e5                	mov    %esp,%ebp
     d8d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d97:	eb 42                	jmp    ddb <gets+0x51>
    cc = read(0, &c, 1);
     d99:	83 ec 04             	sub    $0x4,%esp
     d9c:	6a 01                	push   $0x1
     d9e:	8d 45 ef             	lea    -0x11(%ebp),%eax
     da1:	50                   	push   %eax
     da2:	6a 00                	push   $0x0
     da4:	e8 77 01 00 00       	call   f20 <read>
     da9:	83 c4 10             	add    $0x10,%esp
     dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     daf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     db3:	7e 33                	jle    de8 <gets+0x5e>
      break;
    buf[i++] = c;
     db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     db8:	8d 50 01             	lea    0x1(%eax),%edx
     dbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dbe:	89 c2                	mov    %eax,%edx
     dc0:	8b 45 08             	mov    0x8(%ebp),%eax
     dc3:	01 c2                	add    %eax,%edx
     dc5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dc9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     dcb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dcf:	3c 0a                	cmp    $0xa,%al
     dd1:	74 16                	je     de9 <gets+0x5f>
     dd3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     dd7:	3c 0d                	cmp    $0xd,%al
     dd9:	74 0e                	je     de9 <gets+0x5f>
  for(i=0; i+1 < max; ){
     ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dde:	83 c0 01             	add    $0x1,%eax
     de1:	39 45 0c             	cmp    %eax,0xc(%ebp)
     de4:	7f b3                	jg     d99 <gets+0xf>
     de6:	eb 01                	jmp    de9 <gets+0x5f>
      break;
     de8:	90                   	nop
      break;
  }
  buf[i] = '\0';
     de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     dec:	8b 45 08             	mov    0x8(%ebp),%eax
     def:	01 d0                	add    %edx,%eax
     df1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     df4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     df7:	c9                   	leave  
     df8:	c3                   	ret    

00000df9 <stat>:

int
stat(char *n, struct stat *st)
{
     df9:	55                   	push   %ebp
     dfa:	89 e5                	mov    %esp,%ebp
     dfc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dff:	83 ec 08             	sub    $0x8,%esp
     e02:	6a 00                	push   $0x0
     e04:	ff 75 08             	push   0x8(%ebp)
     e07:	e8 3c 01 00 00       	call   f48 <open>
     e0c:	83 c4 10             	add    $0x10,%esp
     e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e16:	79 07                	jns    e1f <stat+0x26>
    return -1;
     e18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e1d:	eb 25                	jmp    e44 <stat+0x4b>
  r = fstat(fd, st);
     e1f:	83 ec 08             	sub    $0x8,%esp
     e22:	ff 75 0c             	push   0xc(%ebp)
     e25:	ff 75 f4             	push   -0xc(%ebp)
     e28:	e8 33 01 00 00       	call   f60 <fstat>
     e2d:	83 c4 10             	add    $0x10,%esp
     e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     e33:	83 ec 0c             	sub    $0xc,%esp
     e36:	ff 75 f4             	push   -0xc(%ebp)
     e39:	e8 f2 00 00 00       	call   f30 <close>
     e3e:	83 c4 10             	add    $0x10,%esp
  return r;
     e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e44:	c9                   	leave  
     e45:	c3                   	ret    

00000e46 <atoi>:

int
atoi(const char *s)
{
     e46:	55                   	push   %ebp
     e47:	89 e5                	mov    %esp,%ebp
     e49:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     e4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e53:	eb 25                	jmp    e7a <atoi+0x34>
    n = n*10 + *s++ - '0';
     e55:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e58:	89 d0                	mov    %edx,%eax
     e5a:	c1 e0 02             	shl    $0x2,%eax
     e5d:	01 d0                	add    %edx,%eax
     e5f:	01 c0                	add    %eax,%eax
     e61:	89 c1                	mov    %eax,%ecx
     e63:	8b 45 08             	mov    0x8(%ebp),%eax
     e66:	8d 50 01             	lea    0x1(%eax),%edx
     e69:	89 55 08             	mov    %edx,0x8(%ebp)
     e6c:	0f b6 00             	movzbl (%eax),%eax
     e6f:	0f be c0             	movsbl %al,%eax
     e72:	01 c8                	add    %ecx,%eax
     e74:	83 e8 30             	sub    $0x30,%eax
     e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     e7a:	8b 45 08             	mov    0x8(%ebp),%eax
     e7d:	0f b6 00             	movzbl (%eax),%eax
     e80:	3c 2f                	cmp    $0x2f,%al
     e82:	7e 0a                	jle    e8e <atoi+0x48>
     e84:	8b 45 08             	mov    0x8(%ebp),%eax
     e87:	0f b6 00             	movzbl (%eax),%eax
     e8a:	3c 39                	cmp    $0x39,%al
     e8c:	7e c7                	jle    e55 <atoi+0xf>
  return n;
     e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e91:	c9                   	leave  
     e92:	c3                   	ret    

00000e93 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     e93:	55                   	push   %ebp
     e94:	89 e5                	mov    %esp,%ebp
     e96:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     e99:	8b 45 08             	mov    0x8(%ebp),%eax
     e9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     ea5:	eb 17                	jmp    ebe <memmove+0x2b>
    *dst++ = *src++;
     ea7:	8b 55 f8             	mov    -0x8(%ebp),%edx
     eaa:	8d 42 01             	lea    0x1(%edx),%eax
     ead:	89 45 f8             	mov    %eax,-0x8(%ebp)
     eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb3:	8d 48 01             	lea    0x1(%eax),%ecx
     eb6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
     eb9:	0f b6 12             	movzbl (%edx),%edx
     ebc:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
     ebe:	8b 45 10             	mov    0x10(%ebp),%eax
     ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
     ec4:	89 55 10             	mov    %edx,0x10(%ebp)
     ec7:	85 c0                	test   %eax,%eax
     ec9:	7f dc                	jg     ea7 <memmove+0x14>
  return vdst;
     ecb:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ece:	c9                   	leave  
     ecf:	c3                   	ret    

00000ed0 <restorer>:
     ed0:	83 c4 0c             	add    $0xc,%esp
     ed3:	5a                   	pop    %edx
     ed4:	59                   	pop    %ecx
     ed5:	58                   	pop    %eax
     ed6:	c3                   	ret    

00000ed7 <signal>:
            "pop %ecx\n\t"
            "pop %eax\n\t"
            "ret\n\t");

int signal(int signum, void(*handler)(int))
{
     ed7:	55                   	push   %ebp
     ed8:	89 e5                	mov    %esp,%ebp
     eda:	83 ec 08             	sub    $0x8,%esp
    signal_restorer(restorer);
     edd:	83 ec 0c             	sub    $0xc,%esp
     ee0:	68 d0 0e 00 00       	push   $0xed0
     ee5:	e8 ce 00 00 00       	call   fb8 <signal_restorer>
     eea:	83 c4 10             	add    $0x10,%esp
    return signal_register(signum, handler);
     eed:	83 ec 08             	sub    $0x8,%esp
     ef0:	ff 75 0c             	push   0xc(%ebp)
     ef3:	ff 75 08             	push   0x8(%ebp)
     ef6:	e8 b5 00 00 00       	call   fb0 <signal_register>
     efb:	83 c4 10             	add    $0x10,%esp
     efe:	c9                   	leave  
     eff:	c3                   	ret    

00000f00 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f00:	b8 01 00 00 00       	mov    $0x1,%eax
     f05:	cd 40                	int    $0x40
     f07:	c3                   	ret    

00000f08 <exit>:
SYSCALL(exit)
     f08:	b8 02 00 00 00       	mov    $0x2,%eax
     f0d:	cd 40                	int    $0x40
     f0f:	c3                   	ret    

00000f10 <wait>:
SYSCALL(wait)
     f10:	b8 03 00 00 00       	mov    $0x3,%eax
     f15:	cd 40                	int    $0x40
     f17:	c3                   	ret    

00000f18 <pipe>:
SYSCALL(pipe)
     f18:	b8 04 00 00 00       	mov    $0x4,%eax
     f1d:	cd 40                	int    $0x40
     f1f:	c3                   	ret    

00000f20 <read>:
SYSCALL(read)
     f20:	b8 05 00 00 00       	mov    $0x5,%eax
     f25:	cd 40                	int    $0x40
     f27:	c3                   	ret    

00000f28 <write>:
SYSCALL(write)
     f28:	b8 10 00 00 00       	mov    $0x10,%eax
     f2d:	cd 40                	int    $0x40
     f2f:	c3                   	ret    

00000f30 <close>:
SYSCALL(close)
     f30:	b8 15 00 00 00       	mov    $0x15,%eax
     f35:	cd 40                	int    $0x40
     f37:	c3                   	ret    

00000f38 <kill>:
SYSCALL(kill)
     f38:	b8 06 00 00 00       	mov    $0x6,%eax
     f3d:	cd 40                	int    $0x40
     f3f:	c3                   	ret    

00000f40 <exec>:
SYSCALL(exec)
     f40:	b8 07 00 00 00       	mov    $0x7,%eax
     f45:	cd 40                	int    $0x40
     f47:	c3                   	ret    

00000f48 <open>:
SYSCALL(open)
     f48:	b8 0f 00 00 00       	mov    $0xf,%eax
     f4d:	cd 40                	int    $0x40
     f4f:	c3                   	ret    

00000f50 <mknod>:
SYSCALL(mknod)
     f50:	b8 11 00 00 00       	mov    $0x11,%eax
     f55:	cd 40                	int    $0x40
     f57:	c3                   	ret    

00000f58 <unlink>:
SYSCALL(unlink)
     f58:	b8 12 00 00 00       	mov    $0x12,%eax
     f5d:	cd 40                	int    $0x40
     f5f:	c3                   	ret    

00000f60 <fstat>:
SYSCALL(fstat)
     f60:	b8 08 00 00 00       	mov    $0x8,%eax
     f65:	cd 40                	int    $0x40
     f67:	c3                   	ret    

00000f68 <link>:
SYSCALL(link)
     f68:	b8 13 00 00 00       	mov    $0x13,%eax
     f6d:	cd 40                	int    $0x40
     f6f:	c3                   	ret    

00000f70 <mkdir>:
SYSCALL(mkdir)
     f70:	b8 14 00 00 00       	mov    $0x14,%eax
     f75:	cd 40                	int    $0x40
     f77:	c3                   	ret    

00000f78 <chdir>:
SYSCALL(chdir)
     f78:	b8 09 00 00 00       	mov    $0x9,%eax
     f7d:	cd 40                	int    $0x40
     f7f:	c3                   	ret    

00000f80 <dup>:
SYSCALL(dup)
     f80:	b8 0a 00 00 00       	mov    $0xa,%eax
     f85:	cd 40                	int    $0x40
     f87:	c3                   	ret    

00000f88 <getpid>:
SYSCALL(getpid)
     f88:	b8 0b 00 00 00       	mov    $0xb,%eax
     f8d:	cd 40                	int    $0x40
     f8f:	c3                   	ret    

00000f90 <sbrk>:
SYSCALL(sbrk)
     f90:	b8 0c 00 00 00       	mov    $0xc,%eax
     f95:	cd 40                	int    $0x40
     f97:	c3                   	ret    

00000f98 <sleep>:
SYSCALL(sleep)
     f98:	b8 0d 00 00 00       	mov    $0xd,%eax
     f9d:	cd 40                	int    $0x40
     f9f:	c3                   	ret    

00000fa0 <uptime>:
SYSCALL(uptime)
     fa0:	b8 0e 00 00 00       	mov    $0xe,%eax
     fa5:	cd 40                	int    $0x40
     fa7:	c3                   	ret    

00000fa8 <halt>:
SYSCALL(halt)
     fa8:	b8 16 00 00 00       	mov    $0x16,%eax
     fad:	cd 40                	int    $0x40
     faf:	c3                   	ret    

00000fb0 <signal_register>:
SYSCALL(signal_register)
     fb0:	b8 17 00 00 00       	mov    $0x17,%eax
     fb5:	cd 40                	int    $0x40
     fb7:	c3                   	ret    

00000fb8 <signal_restorer>:
SYSCALL(signal_restorer)
     fb8:	b8 18 00 00 00       	mov    $0x18,%eax
     fbd:	cd 40                	int    $0x40
     fbf:	c3                   	ret    

00000fc0 <mprotect>:
SYSCALL(mprotect)
     fc0:	b8 19 00 00 00       	mov    $0x19,%eax
     fc5:	cd 40                	int    $0x40
     fc7:	c3                   	ret    

00000fc8 <cowfork>:
SYSCALL(cowfork)
     fc8:	b8 1a 00 00 00       	mov    $0x1a,%eax
     fcd:	cd 40                	int    $0x40
     fcf:	c3                   	ret    

00000fd0 <dsbrk>:
SYSCALL(dsbrk)
     fd0:	b8 1b 00 00 00       	mov    $0x1b,%eax
     fd5:	cd 40                	int    $0x40
     fd7:	c3                   	ret    

00000fd8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     fd8:	55                   	push   %ebp
     fd9:	89 e5                	mov    %esp,%ebp
     fdb:	83 ec 18             	sub    $0x18,%esp
     fde:	8b 45 0c             	mov    0xc(%ebp),%eax
     fe1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     fe4:	83 ec 04             	sub    $0x4,%esp
     fe7:	6a 01                	push   $0x1
     fe9:	8d 45 f4             	lea    -0xc(%ebp),%eax
     fec:	50                   	push   %eax
     fed:	ff 75 08             	push   0x8(%ebp)
     ff0:	e8 33 ff ff ff       	call   f28 <write>
     ff5:	83 c4 10             	add    $0x10,%esp
}
     ff8:	90                   	nop
     ff9:	c9                   	leave  
     ffa:	c3                   	ret    

00000ffb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ffb:	55                   	push   %ebp
     ffc:	89 e5                	mov    %esp,%ebp
     ffe:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1001:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1008:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    100c:	74 17                	je     1025 <printint+0x2a>
    100e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1012:	79 11                	jns    1025 <printint+0x2a>
    neg = 1;
    1014:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    101b:	8b 45 0c             	mov    0xc(%ebp),%eax
    101e:	f7 d8                	neg    %eax
    1020:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1023:	eb 06                	jmp    102b <printint+0x30>
  } else {
    x = xx;
    1025:	8b 45 0c             	mov    0xc(%ebp),%eax
    1028:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    102b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1032:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1035:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1038:	ba 00 00 00 00       	mov    $0x0,%edx
    103d:	f7 f1                	div    %ecx
    103f:	89 d1                	mov    %edx,%ecx
    1041:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1044:	8d 50 01             	lea    0x1(%eax),%edx
    1047:	89 55 f4             	mov    %edx,-0xc(%ebp)
    104a:	0f b6 91 6c 15 00 00 	movzbl 0x156c(%ecx),%edx
    1051:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
    1055:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1058:	8b 45 ec             	mov    -0x14(%ebp),%eax
    105b:	ba 00 00 00 00       	mov    $0x0,%edx
    1060:	f7 f1                	div    %ecx
    1062:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1065:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1069:	75 c7                	jne    1032 <printint+0x37>
  if(neg)
    106b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    106f:	74 2d                	je     109e <printint+0xa3>
    buf[i++] = '-';
    1071:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1074:	8d 50 01             	lea    0x1(%eax),%edx
    1077:	89 55 f4             	mov    %edx,-0xc(%ebp)
    107a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    107f:	eb 1d                	jmp    109e <printint+0xa3>
    putc(fd, buf[i]);
    1081:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1084:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1087:	01 d0                	add    %edx,%eax
    1089:	0f b6 00             	movzbl (%eax),%eax
    108c:	0f be c0             	movsbl %al,%eax
    108f:	83 ec 08             	sub    $0x8,%esp
    1092:	50                   	push   %eax
    1093:	ff 75 08             	push   0x8(%ebp)
    1096:	e8 3d ff ff ff       	call   fd8 <putc>
    109b:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
    109e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10a6:	79 d9                	jns    1081 <printint+0x86>
}
    10a8:	90                   	nop
    10a9:	90                   	nop
    10aa:	c9                   	leave  
    10ab:	c3                   	ret    

000010ac <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    10ac:	55                   	push   %ebp
    10ad:	89 e5                	mov    %esp,%ebp
    10af:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    10b2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    10b9:	8d 45 0c             	lea    0xc(%ebp),%eax
    10bc:	83 c0 04             	add    $0x4,%eax
    10bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    10c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    10c9:	e9 59 01 00 00       	jmp    1227 <printf+0x17b>
    c = fmt[i] & 0xff;
    10ce:	8b 55 0c             	mov    0xc(%ebp),%edx
    10d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10d4:	01 d0                	add    %edx,%eax
    10d6:	0f b6 00             	movzbl (%eax),%eax
    10d9:	0f be c0             	movsbl %al,%eax
    10dc:	25 ff 00 00 00       	and    $0xff,%eax
    10e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    10e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10e8:	75 2c                	jne    1116 <printf+0x6a>
      if(c == '%'){
    10ea:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    10ee:	75 0c                	jne    10fc <printf+0x50>
        state = '%';
    10f0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    10f7:	e9 27 01 00 00       	jmp    1223 <printf+0x177>
      } else {
        putc(fd, c);
    10fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10ff:	0f be c0             	movsbl %al,%eax
    1102:	83 ec 08             	sub    $0x8,%esp
    1105:	50                   	push   %eax
    1106:	ff 75 08             	push   0x8(%ebp)
    1109:	e8 ca fe ff ff       	call   fd8 <putc>
    110e:	83 c4 10             	add    $0x10,%esp
    1111:	e9 0d 01 00 00       	jmp    1223 <printf+0x177>
      }
    } else if(state == '%'){
    1116:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    111a:	0f 85 03 01 00 00    	jne    1223 <printf+0x177>
      if(c == 'd'){
    1120:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1124:	75 1e                	jne    1144 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1126:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1129:	8b 00                	mov    (%eax),%eax
    112b:	6a 01                	push   $0x1
    112d:	6a 0a                	push   $0xa
    112f:	50                   	push   %eax
    1130:	ff 75 08             	push   0x8(%ebp)
    1133:	e8 c3 fe ff ff       	call   ffb <printint>
    1138:	83 c4 10             	add    $0x10,%esp
        ap++;
    113b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    113f:	e9 d8 00 00 00       	jmp    121c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    1144:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1148:	74 06                	je     1150 <printf+0xa4>
    114a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    114e:	75 1e                	jne    116e <printf+0xc2>
        printint(fd, *ap, 16, 0);
    1150:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1153:	8b 00                	mov    (%eax),%eax
    1155:	6a 00                	push   $0x0
    1157:	6a 10                	push   $0x10
    1159:	50                   	push   %eax
    115a:	ff 75 08             	push   0x8(%ebp)
    115d:	e8 99 fe ff ff       	call   ffb <printint>
    1162:	83 c4 10             	add    $0x10,%esp
        ap++;
    1165:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1169:	e9 ae 00 00 00       	jmp    121c <printf+0x170>
      } else if(c == 's'){
    116e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1172:	75 43                	jne    11b7 <printf+0x10b>
        s = (char*)*ap;
    1174:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1177:	8b 00                	mov    (%eax),%eax
    1179:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    117c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1184:	75 25                	jne    11ab <printf+0xff>
          s = "(null)";
    1186:	c7 45 f4 54 15 00 00 	movl   $0x1554,-0xc(%ebp)
        while(*s != 0){
    118d:	eb 1c                	jmp    11ab <printf+0xff>
          putc(fd, *s);
    118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1192:	0f b6 00             	movzbl (%eax),%eax
    1195:	0f be c0             	movsbl %al,%eax
    1198:	83 ec 08             	sub    $0x8,%esp
    119b:	50                   	push   %eax
    119c:	ff 75 08             	push   0x8(%ebp)
    119f:	e8 34 fe ff ff       	call   fd8 <putc>
    11a4:	83 c4 10             	add    $0x10,%esp
          s++;
    11a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    11ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ae:	0f b6 00             	movzbl (%eax),%eax
    11b1:	84 c0                	test   %al,%al
    11b3:	75 da                	jne    118f <printf+0xe3>
    11b5:	eb 65                	jmp    121c <printf+0x170>
        }
      } else if(c == 'c'){
    11b7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    11bb:	75 1d                	jne    11da <printf+0x12e>
        putc(fd, *ap);
    11bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11c0:	8b 00                	mov    (%eax),%eax
    11c2:	0f be c0             	movsbl %al,%eax
    11c5:	83 ec 08             	sub    $0x8,%esp
    11c8:	50                   	push   %eax
    11c9:	ff 75 08             	push   0x8(%ebp)
    11cc:	e8 07 fe ff ff       	call   fd8 <putc>
    11d1:	83 c4 10             	add    $0x10,%esp
        ap++;
    11d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    11d8:	eb 42                	jmp    121c <printf+0x170>
      } else if(c == '%'){
    11da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    11de:	75 17                	jne    11f7 <printf+0x14b>
        putc(fd, c);
    11e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11e3:	0f be c0             	movsbl %al,%eax
    11e6:	83 ec 08             	sub    $0x8,%esp
    11e9:	50                   	push   %eax
    11ea:	ff 75 08             	push   0x8(%ebp)
    11ed:	e8 e6 fd ff ff       	call   fd8 <putc>
    11f2:	83 c4 10             	add    $0x10,%esp
    11f5:	eb 25                	jmp    121c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    11f7:	83 ec 08             	sub    $0x8,%esp
    11fa:	6a 25                	push   $0x25
    11fc:	ff 75 08             	push   0x8(%ebp)
    11ff:	e8 d4 fd ff ff       	call   fd8 <putc>
    1204:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    120a:	0f be c0             	movsbl %al,%eax
    120d:	83 ec 08             	sub    $0x8,%esp
    1210:	50                   	push   %eax
    1211:	ff 75 08             	push   0x8(%ebp)
    1214:	e8 bf fd ff ff       	call   fd8 <putc>
    1219:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    121c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    1223:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1227:	8b 55 0c             	mov    0xc(%ebp),%edx
    122a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    122d:	01 d0                	add    %edx,%eax
    122f:	0f b6 00             	movzbl (%eax),%eax
    1232:	84 c0                	test   %al,%al
    1234:	0f 85 94 fe ff ff    	jne    10ce <printf+0x22>
    }
  }
}
    123a:	90                   	nop
    123b:	90                   	nop
    123c:	c9                   	leave  
    123d:	c3                   	ret    

0000123e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    123e:	55                   	push   %ebp
    123f:	89 e5                	mov    %esp,%ebp
    1241:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1244:	8b 45 08             	mov    0x8(%ebp),%eax
    1247:	83 e8 08             	sub    $0x8,%eax
    124a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    124d:	a1 ec 15 00 00       	mov    0x15ec,%eax
    1252:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1255:	eb 24                	jmp    127b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1257:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125a:	8b 00                	mov    (%eax),%eax
    125c:	39 45 fc             	cmp    %eax,-0x4(%ebp)
    125f:	72 12                	jb     1273 <free+0x35>
    1261:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1264:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1267:	77 24                	ja     128d <free+0x4f>
    1269:	8b 45 fc             	mov    -0x4(%ebp),%eax
    126c:	8b 00                	mov    (%eax),%eax
    126e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    1271:	72 1a                	jb     128d <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1273:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1276:	8b 00                	mov    (%eax),%eax
    1278:	89 45 fc             	mov    %eax,-0x4(%ebp)
    127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    127e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1281:	76 d4                	jbe    1257 <free+0x19>
    1283:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1286:	8b 00                	mov    (%eax),%eax
    1288:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    128b:	73 ca                	jae    1257 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    128d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1290:	8b 40 04             	mov    0x4(%eax),%eax
    1293:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    129a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    129d:	01 c2                	add    %eax,%edx
    129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a2:	8b 00                	mov    (%eax),%eax
    12a4:	39 c2                	cmp    %eax,%edx
    12a6:	75 24                	jne    12cc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    12a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12ab:	8b 50 04             	mov    0x4(%eax),%edx
    12ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b1:	8b 00                	mov    (%eax),%eax
    12b3:	8b 40 04             	mov    0x4(%eax),%eax
    12b6:	01 c2                	add    %eax,%edx
    12b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12bb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    12be:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c1:	8b 00                	mov    (%eax),%eax
    12c3:	8b 10                	mov    (%eax),%edx
    12c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12c8:	89 10                	mov    %edx,(%eax)
    12ca:	eb 0a                	jmp    12d6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    12cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12cf:	8b 10                	mov    (%eax),%edx
    12d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12d4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    12d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12d9:	8b 40 04             	mov    0x4(%eax),%eax
    12dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    12e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12e6:	01 d0                	add    %edx,%eax
    12e8:	39 45 f8             	cmp    %eax,-0x8(%ebp)
    12eb:	75 20                	jne    130d <free+0xcf>
    p->s.size += bp->s.size;
    12ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12f0:	8b 50 04             	mov    0x4(%eax),%edx
    12f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12f6:	8b 40 04             	mov    0x4(%eax),%eax
    12f9:	01 c2                	add    %eax,%edx
    12fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12fe:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1301:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1304:	8b 10                	mov    (%eax),%edx
    1306:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1309:	89 10                	mov    %edx,(%eax)
    130b:	eb 08                	jmp    1315 <free+0xd7>
  } else
    p->s.ptr = bp;
    130d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1310:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1313:	89 10                	mov    %edx,(%eax)
  freep = p;
    1315:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1318:	a3 ec 15 00 00       	mov    %eax,0x15ec
}
    131d:	90                   	nop
    131e:	c9                   	leave  
    131f:	c3                   	ret    

00001320 <morecore>:

static Header*
morecore(uint nu)
{
    1320:	55                   	push   %ebp
    1321:	89 e5                	mov    %esp,%ebp
    1323:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1326:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    132d:	77 07                	ja     1336 <morecore+0x16>
    nu = 4096;
    132f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1336:	8b 45 08             	mov    0x8(%ebp),%eax
    1339:	c1 e0 03             	shl    $0x3,%eax
    133c:	83 ec 0c             	sub    $0xc,%esp
    133f:	50                   	push   %eax
    1340:	e8 4b fc ff ff       	call   f90 <sbrk>
    1345:	83 c4 10             	add    $0x10,%esp
    1348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    134b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    134f:	75 07                	jne    1358 <morecore+0x38>
    return 0;
    1351:	b8 00 00 00 00       	mov    $0x0,%eax
    1356:	eb 26                	jmp    137e <morecore+0x5e>
  hp = (Header*)p;
    1358:	8b 45 f4             	mov    -0xc(%ebp),%eax
    135b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    135e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1361:	8b 55 08             	mov    0x8(%ebp),%edx
    1364:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1367:	8b 45 f0             	mov    -0x10(%ebp),%eax
    136a:	83 c0 08             	add    $0x8,%eax
    136d:	83 ec 0c             	sub    $0xc,%esp
    1370:	50                   	push   %eax
    1371:	e8 c8 fe ff ff       	call   123e <free>
    1376:	83 c4 10             	add    $0x10,%esp
  return freep;
    1379:	a1 ec 15 00 00       	mov    0x15ec,%eax
}
    137e:	c9                   	leave  
    137f:	c3                   	ret    

00001380 <malloc>:

void*
malloc(uint nbytes)
{
    1380:	55                   	push   %ebp
    1381:	89 e5                	mov    %esp,%ebp
    1383:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1386:	8b 45 08             	mov    0x8(%ebp),%eax
    1389:	83 c0 07             	add    $0x7,%eax
    138c:	c1 e8 03             	shr    $0x3,%eax
    138f:	83 c0 01             	add    $0x1,%eax
    1392:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1395:	a1 ec 15 00 00       	mov    0x15ec,%eax
    139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    139d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13a1:	75 23                	jne    13c6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    13a3:	c7 45 f0 e4 15 00 00 	movl   $0x15e4,-0x10(%ebp)
    13aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13ad:	a3 ec 15 00 00       	mov    %eax,0x15ec
    13b2:	a1 ec 15 00 00       	mov    0x15ec,%eax
    13b7:	a3 e4 15 00 00       	mov    %eax,0x15e4
    base.s.size = 0;
    13bc:	c7 05 e8 15 00 00 00 	movl   $0x0,0x15e8
    13c3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13c9:	8b 00                	mov    (%eax),%eax
    13cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    13ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d1:	8b 40 04             	mov    0x4(%eax),%eax
    13d4:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    13d7:	77 4d                	ja     1426 <malloc+0xa6>
      if(p->s.size == nunits)
    13d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13dc:	8b 40 04             	mov    0x4(%eax),%eax
    13df:	39 45 ec             	cmp    %eax,-0x14(%ebp)
    13e2:	75 0c                	jne    13f0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    13e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13e7:	8b 10                	mov    (%eax),%edx
    13e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13ec:	89 10                	mov    %edx,(%eax)
    13ee:	eb 26                	jmp    1416 <malloc+0x96>
      else {
        p->s.size -= nunits;
    13f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f3:	8b 40 04             	mov    0x4(%eax),%eax
    13f6:	2b 45 ec             	sub    -0x14(%ebp),%eax
    13f9:	89 c2                	mov    %eax,%edx
    13fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13fe:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1401:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1404:	8b 40 04             	mov    0x4(%eax),%eax
    1407:	c1 e0 03             	shl    $0x3,%eax
    140a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    140d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1410:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1413:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1416:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1419:	a3 ec 15 00 00       	mov    %eax,0x15ec
      return (void*)(p + 1);
    141e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1421:	83 c0 08             	add    $0x8,%eax
    1424:	eb 3b                	jmp    1461 <malloc+0xe1>
    }
    if(p == freep)
    1426:	a1 ec 15 00 00       	mov    0x15ec,%eax
    142b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    142e:	75 1e                	jne    144e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1430:	83 ec 0c             	sub    $0xc,%esp
    1433:	ff 75 ec             	push   -0x14(%ebp)
    1436:	e8 e5 fe ff ff       	call   1320 <morecore>
    143b:	83 c4 10             	add    $0x10,%esp
    143e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1445:	75 07                	jne    144e <malloc+0xce>
        return 0;
    1447:	b8 00 00 00 00       	mov    $0x0,%eax
    144c:	eb 13                	jmp    1461 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    144e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1451:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1454:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1457:	8b 00                	mov    (%eax),%eax
    1459:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    145c:	e9 6d ff ff ff       	jmp    13ce <malloc+0x4e>
  }
}
    1461:	c9                   	leave  
    1462:	c3                   	ret    
