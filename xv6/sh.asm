
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

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
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      11:	eb 0e                	jmp    21 <main+0x21>
      13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      17:	90                   	nop
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f 91 00 00 00    	jg     b2 <main+0xb2>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 e9 13 00 00       	push   $0x13e9
      2b:	e8 93 0e 00 00       	call   ec3 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	eb 2e                	jmp    67 <main+0x67>
      39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      40:	80 3d 62 14 00 00 20 	cmpb   $0x20,0x1462
      47:	0f 84 88 00 00 00    	je     d5 <main+0xd5>
      4d:	8d 76 00             	lea    0x0(%esi),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      50:	e8 26 0e 00 00       	call   e7b <fork>
  if(pid == -1)
      55:	83 f8 ff             	cmp    $0xffffffff,%eax
      58:	0f 84 c1 00 00 00    	je     11f <main+0x11f>
    if(fork1() == 0)
      5e:	85 c0                	test   %eax,%eax
      60:	74 5e                	je     c0 <main+0xc0>
    wait();
      62:	e8 24 0e 00 00       	call   e8b <wait>
  printf(2, "$ ");
      67:	83 ec 08             	sub    $0x8,%esp
      6a:	68 48 13 00 00       	push   $0x1348
      6f:	6a 02                	push   $0x2
      71:	e8 6a 0f 00 00       	call   fe0 <printf>
  memset(buf, 0, nbuf);
      76:	83 c4 0c             	add    $0xc,%esp
      79:	6a 64                	push   $0x64
      7b:	6a 00                	push   $0x0
      7d:	68 60 14 00 00       	push   $0x1460
      82:	e8 59 0c 00 00       	call   ce0 <memset>
  gets(buf, nbuf);
      87:	58                   	pop    %eax
      88:	5a                   	pop    %edx
      89:	6a 64                	push   $0x64
      8b:	68 60 14 00 00       	push   $0x1460
      90:	e8 ab 0c 00 00       	call   d40 <gets>
  if(buf[0] == 0) // EOF
      95:	0f b6 05 60 14 00 00 	movzbl 0x1460,%eax
      9c:	83 c4 10             	add    $0x10,%esp
      9f:	84 c0                	test   %al,%al
      a1:	74 77                	je     11a <main+0x11a>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      a3:	3c 63                	cmp    $0x63,%al
      a5:	75 a9                	jne    50 <main+0x50>
      a7:	80 3d 61 14 00 00 64 	cmpb   $0x64,0x1461
      ae:	75 a0                	jne    50 <main+0x50>
      b0:	eb 8e                	jmp    40 <main+0x40>
      close(fd);
      b2:	83 ec 0c             	sub    $0xc,%esp
      b5:	50                   	push   %eax
      b6:	e8 f0 0d 00 00       	call   eab <close>
      break;
      bb:	83 c4 10             	add    $0x10,%esp
      be:	eb a7                	jmp    67 <main+0x67>
      runcmd(parsecmd(buf));
      c0:	83 ec 0c             	sub    $0xc,%esp
      c3:	68 60 14 00 00       	push   $0x1460
      c8:	e8 f3 0a 00 00       	call   bc0 <parsecmd>
      cd:	89 04 24             	mov    %eax,(%esp)
      d0:	e8 eb 00 00 00       	call   1c0 <runcmd>
      buf[strlen(buf)-1] = 0;  // chop \n
      d5:	83 ec 0c             	sub    $0xc,%esp
      d8:	68 60 14 00 00       	push   $0x1460
      dd:	e8 ce 0b 00 00       	call   cb0 <strlen>
      if(chdir(buf+3) < 0)
      e2:	c7 04 24 63 14 00 00 	movl   $0x1463,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      e9:	c6 80 5f 14 00 00 00 	movb   $0x0,0x145f(%eax)
      if(chdir(buf+3) < 0)
      f0:	e8 fe 0d 00 00       	call   ef3 <chdir>
      f5:	83 c4 10             	add    $0x10,%esp
      f8:	85 c0                	test   %eax,%eax
      fa:	0f 89 67 ff ff ff    	jns    67 <main+0x67>
        printf(2, "cannot cd %s\n", buf+3);
     100:	51                   	push   %ecx
     101:	68 63 14 00 00       	push   $0x1463
     106:	68 f1 13 00 00       	push   $0x13f1
     10b:	6a 02                	push   $0x2
     10d:	e8 ce 0e 00 00       	call   fe0 <printf>
     112:	83 c4 10             	add    $0x10,%esp
     115:	e9 4d ff ff ff       	jmp    67 <main+0x67>
  exit();
     11a:	e8 64 0d 00 00       	call   e83 <exit>
    panic("fork");
     11f:	83 ec 0c             	sub    $0xc,%esp
     122:	68 4b 13 00 00       	push   $0x134b
     127:	e8 54 00 00 00       	call   180 <panic>
     12c:	66 90                	xchg   %ax,%ax
     12e:	66 90                	xchg   %ax,%ax

00000130 <getcmd>:
{
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	56                   	push   %esi
     134:	53                   	push   %ebx
     135:	8b 75 0c             	mov    0xc(%ebp),%esi
     138:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     13b:	83 ec 08             	sub    $0x8,%esp
     13e:	68 48 13 00 00       	push   $0x1348
     143:	6a 02                	push   $0x2
     145:	e8 96 0e 00 00       	call   fe0 <printf>
  memset(buf, 0, nbuf);
     14a:	83 c4 0c             	add    $0xc,%esp
     14d:	56                   	push   %esi
     14e:	6a 00                	push   $0x0
     150:	53                   	push   %ebx
     151:	e8 8a 0b 00 00       	call   ce0 <memset>
  gets(buf, nbuf);
     156:	58                   	pop    %eax
     157:	5a                   	pop    %edx
     158:	56                   	push   %esi
     159:	53                   	push   %ebx
     15a:	e8 e1 0b 00 00       	call   d40 <gets>
  if(buf[0] == 0) // EOF
     15f:	83 c4 10             	add    $0x10,%esp
     162:	31 c0                	xor    %eax,%eax
     164:	80 3b 00             	cmpb   $0x0,(%ebx)
     167:	0f 94 c0             	sete   %al
}
     16a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     16d:	5b                   	pop    %ebx
  if(buf[0] == 0) // EOF
     16e:	f7 d8                	neg    %eax
}
     170:	5e                   	pop    %esi
     171:	5d                   	pop    %ebp
     172:	c3                   	ret    
     173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000180 <panic>:
{
     180:	55                   	push   %ebp
     181:	89 e5                	mov    %esp,%ebp
     183:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     186:	ff 75 08             	push   0x8(%ebp)
     189:	68 e5 13 00 00       	push   $0x13e5
     18e:	6a 02                	push   $0x2
     190:	e8 4b 0e 00 00       	call   fe0 <printf>
  exit();
     195:	e8 e9 0c 00 00       	call   e83 <exit>
     19a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001a0 <fork1>:
{
     1a0:	55                   	push   %ebp
     1a1:	89 e5                	mov    %esp,%ebp
     1a3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     1a6:	e8 d0 0c 00 00       	call   e7b <fork>
  if(pid == -1)
     1ab:	83 f8 ff             	cmp    $0xffffffff,%eax
     1ae:	74 02                	je     1b2 <fork1+0x12>
  return pid;
}
     1b0:	c9                   	leave  
     1b1:	c3                   	ret    
    panic("fork");
     1b2:	83 ec 0c             	sub    $0xc,%esp
     1b5:	68 4b 13 00 00       	push   $0x134b
     1ba:	e8 c1 ff ff ff       	call   180 <panic>
     1bf:	90                   	nop

000001c0 <runcmd>:
{
     1c0:	55                   	push   %ebp
     1c1:	89 e5                	mov    %esp,%ebp
     1c3:	53                   	push   %ebx
     1c4:	83 ec 14             	sub    $0x14,%esp
     1c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     1ca:	85 db                	test   %ebx,%ebx
     1cc:	74 42                	je     210 <runcmd+0x50>
  switch(cmd->type){
     1ce:	83 3b 05             	cmpl   $0x5,(%ebx)
     1d1:	0f 87 e3 00 00 00    	ja     2ba <runcmd+0xfa>
     1d7:	8b 03                	mov    (%ebx),%eax
     1d9:	ff 24 85 00 14 00 00 	jmp    *0x1400(,%eax,4)
    if(ecmd->argv[0] == 0)
     1e0:	8b 43 04             	mov    0x4(%ebx),%eax
     1e3:	85 c0                	test   %eax,%eax
     1e5:	74 29                	je     210 <runcmd+0x50>
    exec(ecmd->argv[0], ecmd->argv);
     1e7:	8d 53 04             	lea    0x4(%ebx),%edx
     1ea:	51                   	push   %ecx
     1eb:	51                   	push   %ecx
     1ec:	52                   	push   %edx
     1ed:	50                   	push   %eax
     1ee:	e8 c8 0c 00 00       	call   ebb <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     1f3:	83 c4 0c             	add    $0xc,%esp
     1f6:	ff 73 04             	push   0x4(%ebx)
     1f9:	68 57 13 00 00       	push   $0x1357
     1fe:	6a 02                	push   $0x2
     200:	e8 db 0d 00 00       	call   fe0 <printf>
    break;
     205:	83 c4 10             	add    $0x10,%esp
     208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     20f:	90                   	nop
    exit();
     210:	e8 6e 0c 00 00       	call   e83 <exit>
    if(fork1() == 0)
     215:	e8 86 ff ff ff       	call   1a0 <fork1>
     21a:	85 c0                	test   %eax,%eax
     21c:	75 f2                	jne    210 <runcmd+0x50>
     21e:	e9 8c 00 00 00       	jmp    2af <runcmd+0xef>
    if(pipe(p) < 0)
     223:	83 ec 0c             	sub    $0xc,%esp
     226:	8d 45 f0             	lea    -0x10(%ebp),%eax
     229:	50                   	push   %eax
     22a:	e8 64 0c 00 00       	call   e93 <pipe>
     22f:	83 c4 10             	add    $0x10,%esp
     232:	85 c0                	test   %eax,%eax
     234:	0f 88 a2 00 00 00    	js     2dc <runcmd+0x11c>
    if(fork1() == 0){
     23a:	e8 61 ff ff ff       	call   1a0 <fork1>
     23f:	85 c0                	test   %eax,%eax
     241:	0f 84 a2 00 00 00    	je     2e9 <runcmd+0x129>
    if(fork1() == 0){
     247:	e8 54 ff ff ff       	call   1a0 <fork1>
     24c:	85 c0                	test   %eax,%eax
     24e:	0f 84 c3 00 00 00    	je     317 <runcmd+0x157>
    close(p[0]);
     254:	83 ec 0c             	sub    $0xc,%esp
     257:	ff 75 f0             	push   -0x10(%ebp)
     25a:	e8 4c 0c 00 00       	call   eab <close>
    close(p[1]);
     25f:	58                   	pop    %eax
     260:	ff 75 f4             	push   -0xc(%ebp)
     263:	e8 43 0c 00 00       	call   eab <close>
    wait();
     268:	e8 1e 0c 00 00       	call   e8b <wait>
    wait();
     26d:	e8 19 0c 00 00       	call   e8b <wait>
    break;
     272:	83 c4 10             	add    $0x10,%esp
     275:	eb 99                	jmp    210 <runcmd+0x50>
    if(fork1() == 0)
     277:	e8 24 ff ff ff       	call   1a0 <fork1>
     27c:	85 c0                	test   %eax,%eax
     27e:	74 2f                	je     2af <runcmd+0xef>
    wait();
     280:	e8 06 0c 00 00       	call   e8b <wait>
    runcmd(lcmd->right);
     285:	83 ec 0c             	sub    $0xc,%esp
     288:	ff 73 08             	push   0x8(%ebx)
     28b:	e8 30 ff ff ff       	call   1c0 <runcmd>
    close(rcmd->fd);
     290:	83 ec 0c             	sub    $0xc,%esp
     293:	ff 73 14             	push   0x14(%ebx)
     296:	e8 10 0c 00 00       	call   eab <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     29b:	58                   	pop    %eax
     29c:	5a                   	pop    %edx
     29d:	ff 73 10             	push   0x10(%ebx)
     2a0:	ff 73 08             	push   0x8(%ebx)
     2a3:	e8 1b 0c 00 00       	call   ec3 <open>
     2a8:	83 c4 10             	add    $0x10,%esp
     2ab:	85 c0                	test   %eax,%eax
     2ad:	78 18                	js     2c7 <runcmd+0x107>
      runcmd(bcmd->cmd);
     2af:	83 ec 0c             	sub    $0xc,%esp
     2b2:	ff 73 04             	push   0x4(%ebx)
     2b5:	e8 06 ff ff ff       	call   1c0 <runcmd>
    panic("runcmd");
     2ba:	83 ec 0c             	sub    $0xc,%esp
     2bd:	68 50 13 00 00       	push   $0x1350
     2c2:	e8 b9 fe ff ff       	call   180 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     2c7:	51                   	push   %ecx
     2c8:	ff 73 08             	push   0x8(%ebx)
     2cb:	68 67 13 00 00       	push   $0x1367
     2d0:	6a 02                	push   $0x2
     2d2:	e8 09 0d 00 00       	call   fe0 <printf>
      exit();
     2d7:	e8 a7 0b 00 00       	call   e83 <exit>
      panic("pipe");
     2dc:	83 ec 0c             	sub    $0xc,%esp
     2df:	68 77 13 00 00       	push   $0x1377
     2e4:	e8 97 fe ff ff       	call   180 <panic>
      close(1);
     2e9:	83 ec 0c             	sub    $0xc,%esp
     2ec:	6a 01                	push   $0x1
     2ee:	e8 b8 0b 00 00       	call   eab <close>
      dup(p[1]);
     2f3:	58                   	pop    %eax
     2f4:	ff 75 f4             	push   -0xc(%ebp)
     2f7:	e8 ff 0b 00 00       	call   efb <dup>
      close(p[0]);
     2fc:	58                   	pop    %eax
     2fd:	ff 75 f0             	push   -0x10(%ebp)
     300:	e8 a6 0b 00 00       	call   eab <close>
      close(p[1]);
     305:	58                   	pop    %eax
     306:	ff 75 f4             	push   -0xc(%ebp)
     309:	e8 9d 0b 00 00       	call   eab <close>
      runcmd(pcmd->left);
     30e:	5a                   	pop    %edx
     30f:	ff 73 04             	push   0x4(%ebx)
     312:	e8 a9 fe ff ff       	call   1c0 <runcmd>
      close(0);
     317:	83 ec 0c             	sub    $0xc,%esp
     31a:	6a 00                	push   $0x0
     31c:	e8 8a 0b 00 00       	call   eab <close>
      dup(p[0]);
     321:	5a                   	pop    %edx
     322:	ff 75 f0             	push   -0x10(%ebp)
     325:	e8 d1 0b 00 00       	call   efb <dup>
      close(p[0]);
     32a:	59                   	pop    %ecx
     32b:	ff 75 f0             	push   -0x10(%ebp)
     32e:	e8 78 0b 00 00       	call   eab <close>
      close(p[1]);
     333:	58                   	pop    %eax
     334:	ff 75 f4             	push   -0xc(%ebp)
     337:	e8 6f 0b 00 00       	call   eab <close>
      runcmd(pcmd->right);
     33c:	58                   	pop    %eax
     33d:	ff 73 08             	push   0x8(%ebx)
     340:	e8 7b fe ff ff       	call   1c0 <runcmd>
     345:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000350 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     350:	55                   	push   %ebp
     351:	89 e5                	mov    %esp,%ebp
     353:	53                   	push   %ebx
     354:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     357:	6a 54                	push   $0x54
     359:	e8 e2 0e 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     35e:	83 c4 0c             	add    $0xc,%esp
     361:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     363:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     365:	6a 00                	push   $0x0
     367:	50                   	push   %eax
     368:	e8 73 09 00 00       	call   ce0 <memset>
  cmd->type = EXEC;
     36d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     373:	89 d8                	mov    %ebx,%eax
     375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     378:	c9                   	leave  
     379:	c3                   	ret    
     37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000380 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	53                   	push   %ebx
     384:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     387:	6a 18                	push   $0x18
     389:	e8 b2 0e 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     38e:	83 c4 0c             	add    $0xc,%esp
     391:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     393:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     395:	6a 00                	push   $0x0
     397:	50                   	push   %eax
     398:	e8 43 09 00 00       	call   ce0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     39d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     3a0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     3a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ac:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     3af:	8b 45 10             	mov    0x10(%ebp),%eax
     3b2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     3b5:	8b 45 14             	mov    0x14(%ebp),%eax
     3b8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     3bb:	8b 45 18             	mov    0x18(%ebp),%eax
     3be:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     3c1:	89 d8                	mov    %ebx,%eax
     3c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3c6:	c9                   	leave  
     3c7:	c3                   	ret    
     3c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     3cf:	90                   	nop

000003d0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	53                   	push   %ebx
     3d4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3d7:	6a 0c                	push   $0xc
     3d9:	e8 62 0e 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3de:	83 c4 0c             	add    $0xc,%esp
     3e1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     3e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3e5:	6a 00                	push   $0x0
     3e7:	50                   	push   %eax
     3e8:	e8 f3 08 00 00       	call   ce0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     3ed:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     3f0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     3f6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3fc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     3ff:	89 d8                	mov    %ebx,%eax
     401:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     404:	c9                   	leave  
     405:	c3                   	ret    
     406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     40d:	8d 76 00             	lea    0x0(%esi),%esi

00000410 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     410:	55                   	push   %ebp
     411:	89 e5                	mov    %esp,%ebp
     413:	53                   	push   %ebx
     414:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     417:	6a 0c                	push   $0xc
     419:	e8 22 0e 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     41e:	83 c4 0c             	add    $0xc,%esp
     421:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     423:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     425:	6a 00                	push   $0x0
     427:	50                   	push   %eax
     428:	e8 b3 08 00 00       	call   ce0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     42d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     430:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     436:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     439:	8b 45 0c             	mov    0xc(%ebp),%eax
     43c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     43f:	89 d8                	mov    %ebx,%eax
     441:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     444:	c9                   	leave  
     445:	c3                   	ret    
     446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     44d:	8d 76 00             	lea    0x0(%esi),%esi

00000450 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     450:	55                   	push   %ebp
     451:	89 e5                	mov    %esp,%ebp
     453:	53                   	push   %ebx
     454:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     457:	6a 08                	push   $0x8
     459:	e8 e2 0d 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     45e:	83 c4 0c             	add    $0xc,%esp
     461:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     463:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     465:	6a 00                	push   $0x0
     467:	50                   	push   %eax
     468:	e8 73 08 00 00       	call   ce0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     46d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     470:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     476:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     479:	89 d8                	mov    %ebx,%eax
     47b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     47e:	c9                   	leave  
     47f:	c3                   	ret    

00000480 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	57                   	push   %edi
     484:	56                   	push   %esi
     485:	53                   	push   %ebx
     486:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     489:	8b 45 08             	mov    0x8(%ebp),%eax
{
     48c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     48f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     492:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     494:	39 df                	cmp    %ebx,%edi
     496:	72 0f                	jb     4a7 <gettoken+0x27>
     498:	eb 25                	jmp    4bf <gettoken+0x3f>
     49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     4a0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     4a3:	39 fb                	cmp    %edi,%ebx
     4a5:	74 18                	je     4bf <gettoken+0x3f>
     4a7:	0f be 07             	movsbl (%edi),%eax
     4aa:	83 ec 08             	sub    $0x8,%esp
     4ad:	50                   	push   %eax
     4ae:	68 54 14 00 00       	push   $0x1454
     4b3:	e8 48 08 00 00       	call   d00 <strchr>
     4b8:	83 c4 10             	add    $0x10,%esp
     4bb:	85 c0                	test   %eax,%eax
     4bd:	75 e1                	jne    4a0 <gettoken+0x20>
  if(q)
     4bf:	85 f6                	test   %esi,%esi
     4c1:	74 02                	je     4c5 <gettoken+0x45>
    *q = s;
     4c3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     4c5:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     4c8:	3c 3c                	cmp    $0x3c,%al
     4ca:	0f 8f d0 00 00 00    	jg     5a0 <gettoken+0x120>
     4d0:	3c 3a                	cmp    $0x3a,%al
     4d2:	0f 8f b4 00 00 00    	jg     58c <gettoken+0x10c>
     4d8:	84 c0                	test   %al,%al
     4da:	75 44                	jne    520 <gettoken+0xa0>
     4dc:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     4de:	8b 55 14             	mov    0x14(%ebp),%edx
     4e1:	85 d2                	test   %edx,%edx
     4e3:	74 05                	je     4ea <gettoken+0x6a>
    *eq = s;
     4e5:	8b 45 14             	mov    0x14(%ebp),%eax
     4e8:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     4ea:	39 df                	cmp    %ebx,%edi
     4ec:	72 09                	jb     4f7 <gettoken+0x77>
     4ee:	eb 1f                	jmp    50f <gettoken+0x8f>
    s++;
     4f0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     4f3:	39 fb                	cmp    %edi,%ebx
     4f5:	74 18                	je     50f <gettoken+0x8f>
     4f7:	0f be 07             	movsbl (%edi),%eax
     4fa:	83 ec 08             	sub    $0x8,%esp
     4fd:	50                   	push   %eax
     4fe:	68 54 14 00 00       	push   $0x1454
     503:	e8 f8 07 00 00       	call   d00 <strchr>
     508:	83 c4 10             	add    $0x10,%esp
     50b:	85 c0                	test   %eax,%eax
     50d:	75 e1                	jne    4f0 <gettoken+0x70>
  *ps = s;
     50f:	8b 45 08             	mov    0x8(%ebp),%eax
     512:	89 38                	mov    %edi,(%eax)
  return ret;
}
     514:	8d 65 f4             	lea    -0xc(%ebp),%esp
     517:	89 f0                	mov    %esi,%eax
     519:	5b                   	pop    %ebx
     51a:	5e                   	pop    %esi
     51b:	5f                   	pop    %edi
     51c:	5d                   	pop    %ebp
     51d:	c3                   	ret    
     51e:	66 90                	xchg   %ax,%ax
  switch(*s){
     520:	79 5e                	jns    580 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     522:	39 fb                	cmp    %edi,%ebx
     524:	77 34                	ja     55a <gettoken+0xda>
  if(eq)
     526:	8b 45 14             	mov    0x14(%ebp),%eax
     529:	be 61 00 00 00       	mov    $0x61,%esi
     52e:	85 c0                	test   %eax,%eax
     530:	75 b3                	jne    4e5 <gettoken+0x65>
     532:	eb db                	jmp    50f <gettoken+0x8f>
     534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     538:	0f be 07             	movsbl (%edi),%eax
     53b:	83 ec 08             	sub    $0x8,%esp
     53e:	50                   	push   %eax
     53f:	68 4c 14 00 00       	push   $0x144c
     544:	e8 b7 07 00 00       	call   d00 <strchr>
     549:	83 c4 10             	add    $0x10,%esp
     54c:	85 c0                	test   %eax,%eax
     54e:	75 22                	jne    572 <gettoken+0xf2>
      s++;
     550:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     553:	39 fb                	cmp    %edi,%ebx
     555:	74 cf                	je     526 <gettoken+0xa6>
     557:	0f b6 07             	movzbl (%edi),%eax
     55a:	83 ec 08             	sub    $0x8,%esp
     55d:	0f be f0             	movsbl %al,%esi
     560:	56                   	push   %esi
     561:	68 54 14 00 00       	push   $0x1454
     566:	e8 95 07 00 00       	call   d00 <strchr>
     56b:	83 c4 10             	add    $0x10,%esp
     56e:	85 c0                	test   %eax,%eax
     570:	74 c6                	je     538 <gettoken+0xb8>
    ret = 'a';
     572:	be 61 00 00 00       	mov    $0x61,%esi
     577:	e9 62 ff ff ff       	jmp    4de <gettoken+0x5e>
     57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     580:	3c 26                	cmp    $0x26,%al
     582:	74 08                	je     58c <gettoken+0x10c>
     584:	8d 48 d8             	lea    -0x28(%eax),%ecx
     587:	80 f9 01             	cmp    $0x1,%cl
     58a:	77 96                	ja     522 <gettoken+0xa2>
  ret = *s;
     58c:	0f be f0             	movsbl %al,%esi
    s++;
     58f:	83 c7 01             	add    $0x1,%edi
    break;
     592:	e9 47 ff ff ff       	jmp    4de <gettoken+0x5e>
     597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     59e:	66 90                	xchg   %ax,%ax
  switch(*s){
     5a0:	3c 3e                	cmp    $0x3e,%al
     5a2:	75 1c                	jne    5c0 <gettoken+0x140>
    if(*s == '>'){
     5a4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     5a8:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     5ab:	74 1c                	je     5c9 <gettoken+0x149>
    s++;
     5ad:	89 c7                	mov    %eax,%edi
     5af:	be 3e 00 00 00       	mov    $0x3e,%esi
     5b4:	e9 25 ff ff ff       	jmp    4de <gettoken+0x5e>
     5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     5c0:	3c 7c                	cmp    $0x7c,%al
     5c2:	74 c8                	je     58c <gettoken+0x10c>
     5c4:	e9 59 ff ff ff       	jmp    522 <gettoken+0xa2>
      s++;
     5c9:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     5cc:	be 2b 00 00 00       	mov    $0x2b,%esi
     5d1:	e9 08 ff ff ff       	jmp    4de <gettoken+0x5e>
     5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     5dd:	8d 76 00             	lea    0x0(%esi),%esi

000005e0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     5e0:	55                   	push   %ebp
     5e1:	89 e5                	mov    %esp,%ebp
     5e3:	57                   	push   %edi
     5e4:	56                   	push   %esi
     5e5:	53                   	push   %ebx
     5e6:	83 ec 0c             	sub    $0xc,%esp
     5e9:	8b 7d 08             	mov    0x8(%ebp),%edi
     5ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     5ef:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     5f1:	39 f3                	cmp    %esi,%ebx
     5f3:	72 12                	jb     607 <peek+0x27>
     5f5:	eb 28                	jmp    61f <peek+0x3f>
     5f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     5fe:	66 90                	xchg   %ax,%ax
    s++;
     600:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     603:	39 de                	cmp    %ebx,%esi
     605:	74 18                	je     61f <peek+0x3f>
     607:	0f be 03             	movsbl (%ebx),%eax
     60a:	83 ec 08             	sub    $0x8,%esp
     60d:	50                   	push   %eax
     60e:	68 54 14 00 00       	push   $0x1454
     613:	e8 e8 06 00 00       	call   d00 <strchr>
     618:	83 c4 10             	add    $0x10,%esp
     61b:	85 c0                	test   %eax,%eax
     61d:	75 e1                	jne    600 <peek+0x20>
  *ps = s;
     61f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     621:	0f be 03             	movsbl (%ebx),%eax
     624:	31 d2                	xor    %edx,%edx
     626:	84 c0                	test   %al,%al
     628:	75 0e                	jne    638 <peek+0x58>
}
     62a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     62d:	89 d0                	mov    %edx,%eax
     62f:	5b                   	pop    %ebx
     630:	5e                   	pop    %esi
     631:	5f                   	pop    %edi
     632:	5d                   	pop    %ebp
     633:	c3                   	ret    
     634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     638:	83 ec 08             	sub    $0x8,%esp
     63b:	50                   	push   %eax
     63c:	ff 75 10             	push   0x10(%ebp)
     63f:	e8 bc 06 00 00       	call   d00 <strchr>
     644:	83 c4 10             	add    $0x10,%esp
     647:	31 d2                	xor    %edx,%edx
     649:	85 c0                	test   %eax,%eax
     64b:	0f 95 c2             	setne  %dl
}
     64e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     651:	5b                   	pop    %ebx
     652:	89 d0                	mov    %edx,%eax
     654:	5e                   	pop    %esi
     655:	5f                   	pop    %edi
     656:	5d                   	pop    %ebp
     657:	c3                   	ret    
     658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     65f:	90                   	nop

00000660 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     660:	55                   	push   %ebp
     661:	89 e5                	mov    %esp,%ebp
     663:	57                   	push   %edi
     664:	56                   	push   %esi
     665:	53                   	push   %ebx
     666:	83 ec 2c             	sub    $0x2c,%esp
     669:	8b 75 0c             	mov    0xc(%ebp),%esi
     66c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     66f:	90                   	nop
     670:	83 ec 04             	sub    $0x4,%esp
     673:	68 99 13 00 00       	push   $0x1399
     678:	53                   	push   %ebx
     679:	56                   	push   %esi
     67a:	e8 61 ff ff ff       	call   5e0 <peek>
     67f:	83 c4 10             	add    $0x10,%esp
     682:	85 c0                	test   %eax,%eax
     684:	0f 84 f6 00 00 00    	je     780 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     68a:	6a 00                	push   $0x0
     68c:	6a 00                	push   $0x0
     68e:	53                   	push   %ebx
     68f:	56                   	push   %esi
     690:	e8 eb fd ff ff       	call   480 <gettoken>
     695:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     697:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     69a:	50                   	push   %eax
     69b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     69e:	50                   	push   %eax
     69f:	53                   	push   %ebx
     6a0:	56                   	push   %esi
     6a1:	e8 da fd ff ff       	call   480 <gettoken>
     6a6:	83 c4 20             	add    $0x20,%esp
     6a9:	83 f8 61             	cmp    $0x61,%eax
     6ac:	0f 85 d9 00 00 00    	jne    78b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     6b2:	83 ff 3c             	cmp    $0x3c,%edi
     6b5:	74 69                	je     720 <parseredirs+0xc0>
     6b7:	83 ff 3e             	cmp    $0x3e,%edi
     6ba:	74 05                	je     6c1 <parseredirs+0x61>
     6bc:	83 ff 2b             	cmp    $0x2b,%edi
     6bf:	75 af                	jne    670 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     6c1:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     6c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     6ca:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6cc:	89 55 d0             	mov    %edx,-0x30(%ebp)
     6cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     6d2:	e8 69 0b 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     6d7:	83 c4 0c             	add    $0xc,%esp
     6da:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     6dc:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     6de:	6a 00                	push   $0x0
     6e0:	50                   	push   %eax
     6e1:	e8 fa 05 00 00       	call   ce0 <memset>
  cmd->type = REDIR;
     6e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     6ec:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     6ef:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     6f2:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     6f5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     6f8:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     6fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     6fe:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     705:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     708:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     70f:	89 7d 08             	mov    %edi,0x8(%ebp)
     712:	e9 59 ff ff ff       	jmp    670 <parseredirs+0x10>
     717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     71e:	66 90                	xchg   %ax,%ax
  cmd = malloc(sizeof(*cmd));
     720:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     723:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     726:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     729:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     72b:	89 55 d0             	mov    %edx,-0x30(%ebp)
     72e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     731:	e8 0a 0b 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     736:	83 c4 0c             	add    $0xc,%esp
     739:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     73b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     73d:	6a 00                	push   $0x0
     73f:	50                   	push   %eax
     740:	e8 9b 05 00 00       	call   ce0 <memset>
  cmd->cmd = subcmd;
     745:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     748:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     74b:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     74e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     751:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     757:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     75a:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     75d:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     760:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     763:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     76a:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     771:	e9 fa fe ff ff       	jmp    670 <parseredirs+0x10>
     776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     77d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  return cmd;
}
     780:	8b 45 08             	mov    0x8(%ebp),%eax
     783:	8d 65 f4             	lea    -0xc(%ebp),%esp
     786:	5b                   	pop    %ebx
     787:	5e                   	pop    %esi
     788:	5f                   	pop    %edi
     789:	5d                   	pop    %ebp
     78a:	c3                   	ret    
      panic("missing file for redirection");
     78b:	83 ec 0c             	sub    $0xc,%esp
     78e:	68 7c 13 00 00       	push   $0x137c
     793:	e8 e8 f9 ff ff       	call   180 <panic>
     798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     79f:	90                   	nop

000007a0 <parseexec.part.0>:
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
     7a0:	55                   	push   %ebp
     7a1:	89 e5                	mov    %esp,%ebp
     7a3:	57                   	push   %edi
     7a4:	89 d7                	mov    %edx,%edi
     7a6:	56                   	push   %esi
     7a7:	89 c6                	mov    %eax,%esi
     7a9:	53                   	push   %ebx
     7aa:	83 ec 38             	sub    $0x38,%esp
  cmd = malloc(sizeof(*cmd));
     7ad:	6a 54                	push   $0x54
     7af:	e8 8c 0a 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7b4:	83 c4 0c             	add    $0xc,%esp
     7b7:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     7b9:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7bb:	6a 00                	push   $0x0
     7bd:	50                   	push   %eax
  cmd = malloc(sizeof(*cmd));
     7be:	89 45 d0             	mov    %eax,-0x30(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7c1:	e8 1a 05 00 00       	call   ce0 <memset>

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7c6:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     7c9:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  ret = parseredirs(ret, ps, es);
     7cf:	57                   	push   %edi
     7d0:	56                   	push   %esi
     7d1:	53                   	push   %ebx
  argc = 0;
     7d2:	31 db                	xor    %ebx,%ebx
  ret = parseredirs(ret, ps, es);
     7d4:	e8 87 fe ff ff       	call   660 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     7d9:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     7dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7df:	eb 1a                	jmp    7fb <parseexec.part.0+0x5b>
     7e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     7e8:	83 ec 04             	sub    $0x4,%esp
     7eb:	57                   	push   %edi
     7ec:	56                   	push   %esi
     7ed:	ff 75 d4             	push   -0x2c(%ebp)
     7f0:	e8 6b fe ff ff       	call   660 <parseredirs>
     7f5:	83 c4 10             	add    $0x10,%esp
     7f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7fb:	83 ec 04             	sub    $0x4,%esp
     7fe:	68 b1 13 00 00       	push   $0x13b1
     803:	57                   	push   %edi
     804:	56                   	push   %esi
     805:	e8 d6 fd ff ff       	call   5e0 <peek>
     80a:	83 c4 10             	add    $0x10,%esp
     80d:	85 c0                	test   %eax,%eax
     80f:	75 47                	jne    858 <parseexec.part.0+0xb8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     811:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     814:	50                   	push   %eax
     815:	8d 45 e0             	lea    -0x20(%ebp),%eax
     818:	50                   	push   %eax
     819:	57                   	push   %edi
     81a:	56                   	push   %esi
     81b:	e8 60 fc ff ff       	call   480 <gettoken>
     820:	83 c4 10             	add    $0x10,%esp
     823:	85 c0                	test   %eax,%eax
     825:	74 31                	je     858 <parseexec.part.0+0xb8>
    if(tok != 'a')
     827:	83 f8 61             	cmp    $0x61,%eax
     82a:	75 4a                	jne    876 <parseexec.part.0+0xd6>
    cmd->argv[argc] = q;
     82c:	8b 45 e0             	mov    -0x20(%ebp),%eax
     82f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
     832:	89 44 99 04          	mov    %eax,0x4(%ecx,%ebx,4)
    cmd->eargv[argc] = eq;
     836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     839:	89 44 99 2c          	mov    %eax,0x2c(%ecx,%ebx,4)
    argc++;
     83d:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     840:	83 fb 0a             	cmp    $0xa,%ebx
     843:	75 a3                	jne    7e8 <parseexec.part.0+0x48>
      panic("too many args");
     845:	83 ec 0c             	sub    $0xc,%esp
     848:	68 a3 13 00 00       	push   $0x13a3
     84d:	e8 2e f9 ff ff       	call   180 <panic>
     852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  cmd->argv[argc] = 0;
     858:	8b 45 d0             	mov    -0x30(%ebp),%eax
     85b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     862:	00 
  cmd->eargv[argc] = 0;
     863:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     86a:	00 
  return ret;
}
     86b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     86e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     871:	5b                   	pop    %ebx
     872:	5e                   	pop    %esi
     873:	5f                   	pop    %edi
     874:	5d                   	pop    %ebp
     875:	c3                   	ret    
      panic("syntax");
     876:	83 ec 0c             	sub    $0xc,%esp
     879:	68 9c 13 00 00       	push   $0x139c
     87e:	e8 fd f8 ff ff       	call   180 <panic>
     883:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000890 <parseblock>:
{
     890:	55                   	push   %ebp
     891:	89 e5                	mov    %esp,%ebp
     893:	57                   	push   %edi
     894:	56                   	push   %esi
     895:	53                   	push   %ebx
     896:	83 ec 10             	sub    $0x10,%esp
     899:	8b 5d 08             	mov    0x8(%ebp),%ebx
     89c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     89f:	68 b6 13 00 00       	push   $0x13b6
     8a4:	56                   	push   %esi
     8a5:	53                   	push   %ebx
     8a6:	e8 35 fd ff ff       	call   5e0 <peek>
     8ab:	83 c4 10             	add    $0x10,%esp
     8ae:	85 c0                	test   %eax,%eax
     8b0:	74 4a                	je     8fc <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     8b2:	6a 00                	push   $0x0
     8b4:	6a 00                	push   $0x0
     8b6:	56                   	push   %esi
     8b7:	53                   	push   %ebx
     8b8:	e8 c3 fb ff ff       	call   480 <gettoken>
  cmd = parseline(ps, es);
     8bd:	58                   	pop    %eax
     8be:	5a                   	pop    %edx
     8bf:	56                   	push   %esi
     8c0:	53                   	push   %ebx
     8c1:	e8 1a 01 00 00       	call   9e0 <parseline>
  if(!peek(ps, es, ")"))
     8c6:	83 c4 0c             	add    $0xc,%esp
     8c9:	68 d4 13 00 00       	push   $0x13d4
  cmd = parseline(ps, es);
     8ce:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     8d0:	56                   	push   %esi
     8d1:	53                   	push   %ebx
     8d2:	e8 09 fd ff ff       	call   5e0 <peek>
     8d7:	83 c4 10             	add    $0x10,%esp
     8da:	85 c0                	test   %eax,%eax
     8dc:	74 2b                	je     909 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     8de:	6a 00                	push   $0x0
     8e0:	6a 00                	push   $0x0
     8e2:	56                   	push   %esi
     8e3:	53                   	push   %ebx
     8e4:	e8 97 fb ff ff       	call   480 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     8e9:	83 c4 0c             	add    $0xc,%esp
     8ec:	56                   	push   %esi
     8ed:	53                   	push   %ebx
     8ee:	57                   	push   %edi
     8ef:	e8 6c fd ff ff       	call   660 <parseredirs>
}
     8f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8f7:	5b                   	pop    %ebx
     8f8:	5e                   	pop    %esi
     8f9:	5f                   	pop    %edi
     8fa:	5d                   	pop    %ebp
     8fb:	c3                   	ret    
    panic("parseblock");
     8fc:	83 ec 0c             	sub    $0xc,%esp
     8ff:	68 b8 13 00 00       	push   $0x13b8
     904:	e8 77 f8 ff ff       	call   180 <panic>
    panic("syntax - missing )");
     909:	83 ec 0c             	sub    $0xc,%esp
     90c:	68 c3 13 00 00       	push   $0x13c3
     911:	e8 6a f8 ff ff       	call   180 <panic>
     916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     91d:	8d 76 00             	lea    0x0(%esi),%esi

00000920 <parsepipe>:
{
     920:	55                   	push   %ebp
     921:	89 e5                	mov    %esp,%ebp
     923:	57                   	push   %edi
     924:	56                   	push   %esi
     925:	53                   	push   %ebx
     926:	83 ec 10             	sub    $0x10,%esp
     929:	8b 75 08             	mov    0x8(%ebp),%esi
     92c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(peek(ps, es, "("))
     92f:	68 b6 13 00 00       	push   $0x13b6
     934:	57                   	push   %edi
     935:	56                   	push   %esi
     936:	e8 a5 fc ff ff       	call   5e0 <peek>
     93b:	83 c4 10             	add    $0x10,%esp
     93e:	85 c0                	test   %eax,%eax
     940:	75 2e                	jne    970 <parsepipe+0x50>
     942:	89 fa                	mov    %edi,%edx
     944:	89 f0                	mov    %esi,%eax
     946:	e8 55 fe ff ff       	call   7a0 <parseexec.part.0>
     94b:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     94d:	83 ec 04             	sub    $0x4,%esp
     950:	68 d6 13 00 00       	push   $0x13d6
     955:	57                   	push   %edi
     956:	56                   	push   %esi
     957:	e8 84 fc ff ff       	call   5e0 <peek>
     95c:	83 c4 10             	add    $0x10,%esp
     95f:	85 c0                	test   %eax,%eax
     961:	75 25                	jne    988 <parsepipe+0x68>
}
     963:	8d 65 f4             	lea    -0xc(%ebp),%esp
     966:	89 d8                	mov    %ebx,%eax
     968:	5b                   	pop    %ebx
     969:	5e                   	pop    %esi
     96a:	5f                   	pop    %edi
     96b:	5d                   	pop    %ebp
     96c:	c3                   	ret    
     96d:	8d 76 00             	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     970:	83 ec 08             	sub    $0x8,%esp
     973:	57                   	push   %edi
     974:	56                   	push   %esi
     975:	e8 16 ff ff ff       	call   890 <parseblock>
     97a:	83 c4 10             	add    $0x10,%esp
     97d:	89 c3                	mov    %eax,%ebx
     97f:	eb cc                	jmp    94d <parsepipe+0x2d>
     981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     988:	6a 00                	push   $0x0
     98a:	6a 00                	push   $0x0
     98c:	57                   	push   %edi
     98d:	56                   	push   %esi
     98e:	e8 ed fa ff ff       	call   480 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     993:	58                   	pop    %eax
     994:	5a                   	pop    %edx
     995:	57                   	push   %edi
     996:	56                   	push   %esi
     997:	e8 84 ff ff ff       	call   920 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     99c:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     9a3:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     9a5:	e8 96 08 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     9aa:	83 c4 0c             	add    $0xc,%esp
     9ad:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     9af:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     9b1:	6a 00                	push   $0x0
     9b3:	50                   	push   %eax
     9b4:	e8 27 03 00 00       	call   ce0 <memset>
  cmd->left = left;
     9b9:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     9bc:	83 c4 10             	add    $0x10,%esp
     9bf:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     9c1:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     9c7:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     9c9:	89 7e 08             	mov    %edi,0x8(%esi)
}
     9cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9cf:	5b                   	pop    %ebx
     9d0:	5e                   	pop    %esi
     9d1:	5f                   	pop    %edi
     9d2:	5d                   	pop    %ebp
     9d3:	c3                   	ret    
     9d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     9df:	90                   	nop

000009e0 <parseline>:
{
     9e0:	55                   	push   %ebp
     9e1:	89 e5                	mov    %esp,%ebp
     9e3:	57                   	push   %edi
     9e4:	56                   	push   %esi
     9e5:	53                   	push   %ebx
     9e6:	83 ec 24             	sub    $0x24,%esp
     9e9:	8b 75 08             	mov    0x8(%ebp),%esi
     9ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     9ef:	57                   	push   %edi
     9f0:	56                   	push   %esi
     9f1:	e8 2a ff ff ff       	call   920 <parsepipe>
  while(peek(ps, es, "&")){
     9f6:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     9f9:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     9fb:	eb 3b                	jmp    a38 <parseline+0x58>
     9fd:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     a00:	6a 00                	push   $0x0
     a02:	6a 00                	push   $0x0
     a04:	57                   	push   %edi
     a05:	56                   	push   %esi
     a06:	e8 75 fa ff ff       	call   480 <gettoken>
  cmd = malloc(sizeof(*cmd));
     a0b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     a12:	e8 29 08 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a17:	83 c4 0c             	add    $0xc,%esp
     a1a:	6a 08                	push   $0x8
     a1c:	6a 00                	push   $0x0
     a1e:	50                   	push   %eax
     a1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     a22:	e8 b9 02 00 00       	call   ce0 <memset>
  cmd->type = BACK;
     a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     a2a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     a2d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     a33:	89 5a 04             	mov    %ebx,0x4(%edx)
     a36:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     a38:	83 ec 04             	sub    $0x4,%esp
     a3b:	68 d8 13 00 00       	push   $0x13d8
     a40:	57                   	push   %edi
     a41:	56                   	push   %esi
     a42:	e8 99 fb ff ff       	call   5e0 <peek>
     a47:	83 c4 10             	add    $0x10,%esp
     a4a:	85 c0                	test   %eax,%eax
     a4c:	75 b2                	jne    a00 <parseline+0x20>
  if(peek(ps, es, ";")){
     a4e:	83 ec 04             	sub    $0x4,%esp
     a51:	68 b4 13 00 00       	push   $0x13b4
     a56:	57                   	push   %edi
     a57:	56                   	push   %esi
     a58:	e8 83 fb ff ff       	call   5e0 <peek>
     a5d:	83 c4 10             	add    $0x10,%esp
     a60:	85 c0                	test   %eax,%eax
     a62:	75 0c                	jne    a70 <parseline+0x90>
}
     a64:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a67:	89 d8                	mov    %ebx,%eax
     a69:	5b                   	pop    %ebx
     a6a:	5e                   	pop    %esi
     a6b:	5f                   	pop    %edi
     a6c:	5d                   	pop    %ebp
     a6d:	c3                   	ret    
     a6e:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     a70:	6a 00                	push   $0x0
     a72:	6a 00                	push   $0x0
     a74:	57                   	push   %edi
     a75:	56                   	push   %esi
     a76:	e8 05 fa ff ff       	call   480 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     a7b:	58                   	pop    %eax
     a7c:	5a                   	pop    %edx
     a7d:	57                   	push   %edi
     a7e:	56                   	push   %esi
     a7f:	e8 5c ff ff ff       	call   9e0 <parseline>
  cmd = malloc(sizeof(*cmd));
     a84:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     a8b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     a8d:	e8 ae 07 00 00       	call   1240 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     a92:	83 c4 0c             	add    $0xc,%esp
     a95:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     a97:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     a99:	6a 00                	push   $0x0
     a9b:	50                   	push   %eax
     a9c:	e8 3f 02 00 00       	call   ce0 <memset>
  cmd->left = left;
     aa1:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     aa4:	83 c4 10             	add    $0x10,%esp
     aa7:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     aa9:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     aaf:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     ab1:	89 7e 08             	mov    %edi,0x8(%esi)
}
     ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ab7:	5b                   	pop    %ebx
     ab8:	5e                   	pop    %esi
     ab9:	5f                   	pop    %edi
     aba:	5d                   	pop    %ebp
     abb:	c3                   	ret    
     abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000ac0 <parseexec>:
{
     ac0:	55                   	push   %ebp
     ac1:	89 e5                	mov    %esp,%ebp
     ac3:	56                   	push   %esi
     ac4:	53                   	push   %ebx
     ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
     ac8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(peek(ps, es, "("))
     acb:	83 ec 04             	sub    $0x4,%esp
     ace:	68 b6 13 00 00       	push   $0x13b6
     ad3:	56                   	push   %esi
     ad4:	53                   	push   %ebx
     ad5:	e8 06 fb ff ff       	call   5e0 <peek>
     ada:	83 c4 10             	add    $0x10,%esp
     add:	85 c0                	test   %eax,%eax
     adf:	75 0f                	jne    af0 <parseexec+0x30>
}
     ae1:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ae4:	89 f2                	mov    %esi,%edx
     ae6:	89 d8                	mov    %ebx,%eax
     ae8:	5b                   	pop    %ebx
     ae9:	5e                   	pop    %esi
     aea:	5d                   	pop    %ebp
     aeb:	e9 b0 fc ff ff       	jmp    7a0 <parseexec.part.0>
    return parseblock(ps, es);
     af0:	89 75 0c             	mov    %esi,0xc(%ebp)
     af3:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     af6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     af9:	5b                   	pop    %ebx
     afa:	5e                   	pop    %esi
     afb:	5d                   	pop    %ebp
    return parseblock(ps, es);
     afc:	e9 8f fd ff ff       	jmp    890 <parseblock>
     b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b0f:	90                   	nop

00000b10 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     b10:	55                   	push   %ebp
     b11:	89 e5                	mov    %esp,%ebp
     b13:	53                   	push   %ebx
     b14:	83 ec 04             	sub    $0x4,%esp
     b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     b1a:	85 db                	test   %ebx,%ebx
     b1c:	0f 84 8e 00 00 00    	je     bb0 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     b22:	83 3b 05             	cmpl   $0x5,(%ebx)
     b25:	77 61                	ja     b88 <nulterminate+0x78>
     b27:	8b 03                	mov    (%ebx),%eax
     b29:	ff 24 85 18 14 00 00 	jmp    *0x1418(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     b30:	83 ec 0c             	sub    $0xc,%esp
     b33:	ff 73 04             	push   0x4(%ebx)
     b36:	e8 d5 ff ff ff       	call   b10 <nulterminate>
    nulterminate(lcmd->right);
     b3b:	58                   	pop    %eax
     b3c:	ff 73 08             	push   0x8(%ebx)
     b3f:	e8 cc ff ff ff       	call   b10 <nulterminate>
    break;
     b44:	83 c4 10             	add    $0x10,%esp
     b47:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     b49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b4c:	c9                   	leave  
     b4d:	c3                   	ret    
     b4e:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     b50:	83 ec 0c             	sub    $0xc,%esp
     b53:	ff 73 04             	push   0x4(%ebx)
     b56:	e8 b5 ff ff ff       	call   b10 <nulterminate>
    break;
     b5b:	89 d8                	mov    %ebx,%eax
     b5d:	83 c4 10             	add    $0x10,%esp
}
     b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b63:	c9                   	leave  
     b64:	c3                   	ret    
     b65:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     b68:	8b 4b 04             	mov    0x4(%ebx),%ecx
     b6b:	8d 43 08             	lea    0x8(%ebx),%eax
     b6e:	85 c9                	test   %ecx,%ecx
     b70:	74 16                	je     b88 <nulterminate+0x78>
     b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     b78:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     b7b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     b7e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     b81:	8b 50 fc             	mov    -0x4(%eax),%edx
     b84:	85 d2                	test   %edx,%edx
     b86:	75 f0                	jne    b78 <nulterminate+0x68>
  switch(cmd->type){
     b88:	89 d8                	mov    %ebx,%eax
}
     b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b8d:	c9                   	leave  
     b8e:	c3                   	ret    
     b8f:	90                   	nop
    nulterminate(rcmd->cmd);
     b90:	83 ec 0c             	sub    $0xc,%esp
     b93:	ff 73 04             	push   0x4(%ebx)
     b96:	e8 75 ff ff ff       	call   b10 <nulterminate>
    *rcmd->efile = 0;
     b9b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     b9e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     ba1:	c6 00 00             	movb   $0x0,(%eax)
    break;
     ba4:	89 d8                	mov    %ebx,%eax
}
     ba6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ba9:	c9                   	leave  
     baa:	c3                   	ret    
     bab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     baf:	90                   	nop
    return 0;
     bb0:	31 c0                	xor    %eax,%eax
     bb2:	eb 95                	jmp    b49 <nulterminate+0x39>
     bb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     bbf:	90                   	nop

00000bc0 <parsecmd>:
{
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	57                   	push   %edi
     bc4:	56                   	push   %esi
  cmd = parseline(&s, es);
     bc5:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     bc8:	53                   	push   %ebx
     bc9:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     bcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
     bcf:	53                   	push   %ebx
     bd0:	e8 db 00 00 00       	call   cb0 <strlen>
  cmd = parseline(&s, es);
     bd5:	59                   	pop    %ecx
     bd6:	5e                   	pop    %esi
  es = s + strlen(s);
     bd7:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     bd9:	53                   	push   %ebx
     bda:	57                   	push   %edi
     bdb:	e8 00 fe ff ff       	call   9e0 <parseline>
  peek(&s, es, "");
     be0:	83 c4 0c             	add    $0xc,%esp
     be3:	68 66 13 00 00       	push   $0x1366
  cmd = parseline(&s, es);
     be8:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     bea:	53                   	push   %ebx
     beb:	57                   	push   %edi
     bec:	e8 ef f9 ff ff       	call   5e0 <peek>
  if(s != es){
     bf1:	8b 45 08             	mov    0x8(%ebp),%eax
     bf4:	83 c4 10             	add    $0x10,%esp
     bf7:	39 d8                	cmp    %ebx,%eax
     bf9:	75 13                	jne    c0e <parsecmd+0x4e>
  nulterminate(cmd);
     bfb:	83 ec 0c             	sub    $0xc,%esp
     bfe:	56                   	push   %esi
     bff:	e8 0c ff ff ff       	call   b10 <nulterminate>
}
     c04:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c07:	89 f0                	mov    %esi,%eax
     c09:	5b                   	pop    %ebx
     c0a:	5e                   	pop    %esi
     c0b:	5f                   	pop    %edi
     c0c:	5d                   	pop    %ebp
     c0d:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     c0e:	52                   	push   %edx
     c0f:	50                   	push   %eax
     c10:	68 da 13 00 00       	push   $0x13da
     c15:	6a 02                	push   $0x2
     c17:	e8 c4 03 00 00       	call   fe0 <printf>
    panic("syntax");
     c1c:	c7 04 24 9c 13 00 00 	movl   $0x139c,(%esp)
     c23:	e8 58 f5 ff ff       	call   180 <panic>
     c28:	66 90                	xchg   %ax,%ax
     c2a:	66 90                	xchg   %ax,%ax
     c2c:	66 90                	xchg   %ax,%ax
     c2e:	66 90                	xchg   %ax,%ax

00000c30 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     c30:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c31:	31 c0                	xor    %eax,%eax
{
     c33:	89 e5                	mov    %esp,%ebp
     c35:	53                   	push   %ebx
     c36:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     c40:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     c44:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     c47:	83 c0 01             	add    $0x1,%eax
     c4a:	84 d2                	test   %dl,%dl
     c4c:	75 f2                	jne    c40 <strcpy+0x10>
    ;
  return os;
}
     c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c51:	89 c8                	mov    %ecx,%eax
     c53:	c9                   	leave  
     c54:	c3                   	ret    
     c55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c60 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c60:	55                   	push   %ebp
     c61:	89 e5                	mov    %esp,%ebp
     c63:	53                   	push   %ebx
     c64:	8b 4d 08             	mov    0x8(%ebp),%ecx
     c67:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     c6a:	0f b6 01             	movzbl (%ecx),%eax
     c6d:	0f b6 1a             	movzbl (%edx),%ebx
     c70:	84 c0                	test   %al,%al
     c72:	75 1d                	jne    c91 <strcmp+0x31>
     c74:	eb 2a                	jmp    ca0 <strcmp+0x40>
     c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c7d:	8d 76 00             	lea    0x0(%esi),%esi
     c80:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     c84:	83 c1 01             	add    $0x1,%ecx
     c87:	83 c2 01             	add    $0x1,%edx
  return (uchar)*p - (uchar)*q;
     c8a:	0f b6 1a             	movzbl (%edx),%ebx
  while(*p && *p == *q)
     c8d:	84 c0                	test   %al,%al
     c8f:	74 0f                	je     ca0 <strcmp+0x40>
     c91:	38 d8                	cmp    %bl,%al
     c93:	74 eb                	je     c80 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     c95:	29 d8                	sub    %ebx,%eax
}
     c97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c9a:	c9                   	leave  
     c9b:	c3                   	ret    
     c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ca0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     ca2:	29 d8                	sub    %ebx,%eax
}
     ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ca7:	c9                   	leave  
     ca8:	c3                   	ret    
     ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000cb0 <strlen>:

uint
strlen(const char *s)
{
     cb0:	55                   	push   %ebp
     cb1:	89 e5                	mov    %esp,%ebp
     cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     cb6:	80 3a 00             	cmpb   $0x0,(%edx)
     cb9:	74 15                	je     cd0 <strlen+0x20>
     cbb:	31 c0                	xor    %eax,%eax
     cbd:	8d 76 00             	lea    0x0(%esi),%esi
     cc0:	83 c0 01             	add    $0x1,%eax
     cc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     cc7:	89 c1                	mov    %eax,%ecx
     cc9:	75 f5                	jne    cc0 <strlen+0x10>
    ;
  return n;
}
     ccb:	89 c8                	mov    %ecx,%eax
     ccd:	5d                   	pop    %ebp
     cce:	c3                   	ret    
     ccf:	90                   	nop
  for(n = 0; s[n]; n++)
     cd0:	31 c9                	xor    %ecx,%ecx
}
     cd2:	5d                   	pop    %ebp
     cd3:	89 c8                	mov    %ecx,%eax
     cd5:	c3                   	ret    
     cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     cdd:	8d 76 00             	lea    0x0(%esi),%esi

00000ce0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ce0:	55                   	push   %ebp
     ce1:	89 e5                	mov    %esp,%ebp
     ce3:	57                   	push   %edi
     ce4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     ce7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     cea:	8b 45 0c             	mov    0xc(%ebp),%eax
     ced:	89 d7                	mov    %edx,%edi
     cef:	fc                   	cld    
     cf0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     cf2:	8b 7d fc             	mov    -0x4(%ebp),%edi
     cf5:	89 d0                	mov    %edx,%eax
     cf7:	c9                   	leave  
     cf8:	c3                   	ret    
     cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d00 <strchr>:

char*
strchr(const char *s, char c)
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	8b 45 08             	mov    0x8(%ebp),%eax
     d06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     d0a:	0f b6 10             	movzbl (%eax),%edx
     d0d:	84 d2                	test   %dl,%dl
     d0f:	75 12                	jne    d23 <strchr+0x23>
     d11:	eb 1d                	jmp    d30 <strchr+0x30>
     d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d17:	90                   	nop
     d18:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     d1c:	83 c0 01             	add    $0x1,%eax
     d1f:	84 d2                	test   %dl,%dl
     d21:	74 0d                	je     d30 <strchr+0x30>
    if(*s == c)
     d23:	38 d1                	cmp    %dl,%cl
     d25:	75 f1                	jne    d18 <strchr+0x18>
      return (char*)s;
  return 0;
}
     d27:	5d                   	pop    %ebp
     d28:	c3                   	ret    
     d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     d30:	31 c0                	xor    %eax,%eax
}
     d32:	5d                   	pop    %ebp
     d33:	c3                   	ret    
     d34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d3f:	90                   	nop

00000d40 <gets>:

char*
gets(char *buf, int max)
{
     d40:	55                   	push   %ebp
     d41:	89 e5                	mov    %esp,%ebp
     d43:	57                   	push   %edi
     d44:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d45:	31 f6                	xor    %esi,%esi
{
     d47:	53                   	push   %ebx
     d48:	89 f3                	mov    %esi,%ebx
     d4a:	83 ec 1c             	sub    $0x1c,%esp
     d4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     d50:	eb 2f                	jmp    d81 <gets+0x41>
     d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     d58:	83 ec 04             	sub    $0x4,%esp
     d5b:	8d 45 e7             	lea    -0x19(%ebp),%eax
     d5e:	6a 01                	push   $0x1
     d60:	50                   	push   %eax
     d61:	6a 00                	push   $0x0
     d63:	e8 33 01 00 00       	call   e9b <read>
    if(cc < 1)
     d68:	83 c4 10             	add    $0x10,%esp
     d6b:	85 c0                	test   %eax,%eax
     d6d:	7e 1c                	jle    d8b <gets+0x4b>
      break;
    buf[i++] = c;
     d6f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    if(c == '\n' || c == '\r')
     d73:	83 c7 01             	add    $0x1,%edi
    buf[i++] = c;
     d76:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     d79:	3c 0a                	cmp    $0xa,%al
     d7b:	74 23                	je     da0 <gets+0x60>
     d7d:	3c 0d                	cmp    $0xd,%al
     d7f:	74 1f                	je     da0 <gets+0x60>
  for(i=0; i+1 < max; ){
     d81:	83 c3 01             	add    $0x1,%ebx
    buf[i++] = c;
     d84:	89 fe                	mov    %edi,%esi
  for(i=0; i+1 < max; ){
     d86:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     d89:	7c cd                	jl     d58 <gets+0x18>
     d8b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     d90:	c6 03 00             	movb   $0x0,(%ebx)
}
     d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d96:	5b                   	pop    %ebx
     d97:	5e                   	pop    %esi
     d98:	5f                   	pop    %edi
     d99:	5d                   	pop    %ebp
     d9a:	c3                   	ret    
     d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d9f:	90                   	nop
  buf[i] = '\0';
     da0:	8b 75 08             	mov    0x8(%ebp),%esi
}
     da3:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     da6:	01 de                	add    %ebx,%esi
     da8:	89 f3                	mov    %esi,%ebx
     daa:	c6 03 00             	movb   $0x0,(%ebx)
}
     dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
     db0:	5b                   	pop    %ebx
     db1:	5e                   	pop    %esi
     db2:	5f                   	pop    %edi
     db3:	5d                   	pop    %ebp
     db4:	c3                   	ret    
     db5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000dc0 <stat>:

int
stat(const char *n, struct stat *st)
{
     dc0:	55                   	push   %ebp
     dc1:	89 e5                	mov    %esp,%ebp
     dc3:	56                   	push   %esi
     dc4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dc5:	83 ec 08             	sub    $0x8,%esp
     dc8:	6a 00                	push   $0x0
     dca:	ff 75 08             	push   0x8(%ebp)
     dcd:	e8 f1 00 00 00       	call   ec3 <open>
  if(fd < 0)
     dd2:	83 c4 10             	add    $0x10,%esp
     dd5:	85 c0                	test   %eax,%eax
     dd7:	78 27                	js     e00 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     dd9:	83 ec 08             	sub    $0x8,%esp
     ddc:	ff 75 0c             	push   0xc(%ebp)
     ddf:	89 c3                	mov    %eax,%ebx
     de1:	50                   	push   %eax
     de2:	e8 f4 00 00 00       	call   edb <fstat>
  close(fd);
     de7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     dea:	89 c6                	mov    %eax,%esi
  close(fd);
     dec:	e8 ba 00 00 00       	call   eab <close>
  return r;
     df1:	83 c4 10             	add    $0x10,%esp
}
     df4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     df7:	89 f0                	mov    %esi,%eax
     df9:	5b                   	pop    %ebx
     dfa:	5e                   	pop    %esi
     dfb:	5d                   	pop    %ebp
     dfc:	c3                   	ret    
     dfd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     e00:	be ff ff ff ff       	mov    $0xffffffff,%esi
     e05:	eb ed                	jmp    df4 <stat+0x34>
     e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e0e:	66 90                	xchg   %ax,%ax

00000e10 <atoi>:

int
atoi(const char *s)
{
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
     e13:	53                   	push   %ebx
     e14:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e17:	0f be 02             	movsbl (%edx),%eax
     e1a:	8d 48 d0             	lea    -0x30(%eax),%ecx
     e1d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     e20:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     e25:	77 1e                	ja     e45 <atoi+0x35>
     e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e2e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
     e30:	83 c2 01             	add    $0x1,%edx
     e33:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     e36:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     e3a:	0f be 02             	movsbl (%edx),%eax
     e3d:	8d 58 d0             	lea    -0x30(%eax),%ebx
     e40:	80 fb 09             	cmp    $0x9,%bl
     e43:	76 eb                	jbe    e30 <atoi+0x20>
  return n;
}
     e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e48:	89 c8                	mov    %ecx,%eax
     e4a:	c9                   	leave  
     e4b:	c3                   	ret    
     e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e50 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e50:	55                   	push   %ebp
     e51:	89 e5                	mov    %esp,%ebp
     e53:	57                   	push   %edi
     e54:	8b 45 10             	mov    0x10(%ebp),%eax
     e57:	8b 55 08             	mov    0x8(%ebp),%edx
     e5a:	56                   	push   %esi
     e5b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     e5e:	85 c0                	test   %eax,%eax
     e60:	7e 13                	jle    e75 <memmove+0x25>
     e62:	01 d0                	add    %edx,%eax
  dst = vdst;
     e64:	89 d7                	mov    %edx,%edi
     e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e6d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
     e70:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     e71:	39 f8                	cmp    %edi,%eax
     e73:	75 fb                	jne    e70 <memmove+0x20>
  return vdst;
}
     e75:	5e                   	pop    %esi
     e76:	89 d0                	mov    %edx,%eax
     e78:	5f                   	pop    %edi
     e79:	5d                   	pop    %ebp
     e7a:	c3                   	ret    

00000e7b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e7b:	b8 01 00 00 00       	mov    $0x1,%eax
     e80:	cd 40                	int    $0x40
     e82:	c3                   	ret    

00000e83 <exit>:
SYSCALL(exit)
     e83:	b8 02 00 00 00       	mov    $0x2,%eax
     e88:	cd 40                	int    $0x40
     e8a:	c3                   	ret    

00000e8b <wait>:
SYSCALL(wait)
     e8b:	b8 03 00 00 00       	mov    $0x3,%eax
     e90:	cd 40                	int    $0x40
     e92:	c3                   	ret    

00000e93 <pipe>:
SYSCALL(pipe)
     e93:	b8 04 00 00 00       	mov    $0x4,%eax
     e98:	cd 40                	int    $0x40
     e9a:	c3                   	ret    

00000e9b <read>:
SYSCALL(read)
     e9b:	b8 05 00 00 00       	mov    $0x5,%eax
     ea0:	cd 40                	int    $0x40
     ea2:	c3                   	ret    

00000ea3 <write>:
SYSCALL(write)
     ea3:	b8 10 00 00 00       	mov    $0x10,%eax
     ea8:	cd 40                	int    $0x40
     eaa:	c3                   	ret    

00000eab <close>:
SYSCALL(close)
     eab:	b8 15 00 00 00       	mov    $0x15,%eax
     eb0:	cd 40                	int    $0x40
     eb2:	c3                   	ret    

00000eb3 <kill>:
SYSCALL(kill)
     eb3:	b8 06 00 00 00       	mov    $0x6,%eax
     eb8:	cd 40                	int    $0x40
     eba:	c3                   	ret    

00000ebb <exec>:
SYSCALL(exec)
     ebb:	b8 07 00 00 00       	mov    $0x7,%eax
     ec0:	cd 40                	int    $0x40
     ec2:	c3                   	ret    

00000ec3 <open>:
SYSCALL(open)
     ec3:	b8 0f 00 00 00       	mov    $0xf,%eax
     ec8:	cd 40                	int    $0x40
     eca:	c3                   	ret    

00000ecb <mknod>:
SYSCALL(mknod)
     ecb:	b8 11 00 00 00       	mov    $0x11,%eax
     ed0:	cd 40                	int    $0x40
     ed2:	c3                   	ret    

00000ed3 <unlink>:
SYSCALL(unlink)
     ed3:	b8 12 00 00 00       	mov    $0x12,%eax
     ed8:	cd 40                	int    $0x40
     eda:	c3                   	ret    

00000edb <fstat>:
SYSCALL(fstat)
     edb:	b8 08 00 00 00       	mov    $0x8,%eax
     ee0:	cd 40                	int    $0x40
     ee2:	c3                   	ret    

00000ee3 <link>:
SYSCALL(link)
     ee3:	b8 13 00 00 00       	mov    $0x13,%eax
     ee8:	cd 40                	int    $0x40
     eea:	c3                   	ret    

00000eeb <mkdir>:
SYSCALL(mkdir)
     eeb:	b8 14 00 00 00       	mov    $0x14,%eax
     ef0:	cd 40                	int    $0x40
     ef2:	c3                   	ret    

00000ef3 <chdir>:
SYSCALL(chdir)
     ef3:	b8 09 00 00 00       	mov    $0x9,%eax
     ef8:	cd 40                	int    $0x40
     efa:	c3                   	ret    

00000efb <dup>:
SYSCALL(dup)
     efb:	b8 0a 00 00 00       	mov    $0xa,%eax
     f00:	cd 40                	int    $0x40
     f02:	c3                   	ret    

00000f03 <getpid>:
SYSCALL(getpid)
     f03:	b8 0b 00 00 00       	mov    $0xb,%eax
     f08:	cd 40                	int    $0x40
     f0a:	c3                   	ret    

00000f0b <sbrk>:
SYSCALL(sbrk)
     f0b:	b8 0c 00 00 00       	mov    $0xc,%eax
     f10:	cd 40                	int    $0x40
     f12:	c3                   	ret    

00000f13 <sleep>:
SYSCALL(sleep)
     f13:	b8 0d 00 00 00       	mov    $0xd,%eax
     f18:	cd 40                	int    $0x40
     f1a:	c3                   	ret    

00000f1b <uptime>:
SYSCALL(uptime)
     f1b:	b8 0e 00 00 00       	mov    $0xe,%eax
     f20:	cd 40                	int    $0x40
     f22:	c3                   	ret    
     f23:	66 90                	xchg   %ax,%ax
     f25:	66 90                	xchg   %ax,%ax
     f27:	66 90                	xchg   %ax,%ax
     f29:	66 90                	xchg   %ax,%ax
     f2b:	66 90                	xchg   %ax,%ax
     f2d:	66 90                	xchg   %ax,%ax
     f2f:	90                   	nop

00000f30 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     f30:	55                   	push   %ebp
     f31:	89 e5                	mov    %esp,%ebp
     f33:	57                   	push   %edi
     f34:	56                   	push   %esi
     f35:	53                   	push   %ebx
     f36:	83 ec 3c             	sub    $0x3c,%esp
     f39:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     f3c:	89 d1                	mov    %edx,%ecx
{
     f3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     f41:	85 d2                	test   %edx,%edx
     f43:	0f 89 7f 00 00 00    	jns    fc8 <printint+0x98>
     f49:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     f4d:	74 79                	je     fc8 <printint+0x98>
    neg = 1;
     f4f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     f56:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     f58:	31 db                	xor    %ebx,%ebx
     f5a:	8d 75 d7             	lea    -0x29(%ebp),%esi
     f5d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     f60:	89 c8                	mov    %ecx,%eax
     f62:	31 d2                	xor    %edx,%edx
     f64:	89 cf                	mov    %ecx,%edi
     f66:	f7 75 c4             	divl   -0x3c(%ebp)
     f69:	0f b6 92 38 14 00 00 	movzbl 0x1438(%edx),%edx
     f70:	89 45 c0             	mov    %eax,-0x40(%ebp)
     f73:	89 d8                	mov    %ebx,%eax
     f75:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     f78:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     f7b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     f7e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     f81:	76 dd                	jbe    f60 <printint+0x30>
  if(neg)
     f83:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     f86:	85 c9                	test   %ecx,%ecx
     f88:	74 0c                	je     f96 <printint+0x66>
    buf[i++] = '-';
     f8a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     f8f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     f91:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     f96:	8b 7d b8             	mov    -0x48(%ebp),%edi
     f99:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     f9d:	eb 07                	jmp    fa6 <printint+0x76>
     f9f:	90                   	nop
    putc(fd, buf[i]);
     fa0:	0f b6 13             	movzbl (%ebx),%edx
     fa3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     fa6:	83 ec 04             	sub    $0x4,%esp
     fa9:	88 55 d7             	mov    %dl,-0x29(%ebp)
     fac:	6a 01                	push   $0x1
     fae:	56                   	push   %esi
     faf:	57                   	push   %edi
     fb0:	e8 ee fe ff ff       	call   ea3 <write>
  while(--i >= 0)
     fb5:	83 c4 10             	add    $0x10,%esp
     fb8:	39 de                	cmp    %ebx,%esi
     fba:	75 e4                	jne    fa0 <printint+0x70>
}
     fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fbf:	5b                   	pop    %ebx
     fc0:	5e                   	pop    %esi
     fc1:	5f                   	pop    %edi
     fc2:	5d                   	pop    %ebp
     fc3:	c3                   	ret    
     fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     fc8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     fcf:	eb 87                	jmp    f58 <printint+0x28>
     fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fdf:	90                   	nop

00000fe0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     fe0:	55                   	push   %ebp
     fe1:	89 e5                	mov    %esp,%ebp
     fe3:	57                   	push   %edi
     fe4:	56                   	push   %esi
     fe5:	53                   	push   %ebx
     fe6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     fe9:	8b 75 0c             	mov    0xc(%ebp),%esi
     fec:	0f b6 1e             	movzbl (%esi),%ebx
     fef:	84 db                	test   %bl,%bl
     ff1:	0f 84 b8 00 00 00    	je     10af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
     ff7:	8d 45 10             	lea    0x10(%ebp),%eax
     ffa:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     ffd:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1000:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1002:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1005:	eb 37                	jmp    103e <printf+0x5e>
    1007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    100e:	66 90                	xchg   %ax,%ax
    1010:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1013:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1018:	83 f8 25             	cmp    $0x25,%eax
    101b:	74 17                	je     1034 <printf+0x54>
  write(fd, &c, 1);
    101d:	83 ec 04             	sub    $0x4,%esp
    1020:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1023:	6a 01                	push   $0x1
    1025:	57                   	push   %edi
    1026:	ff 75 08             	push   0x8(%ebp)
    1029:	e8 75 fe ff ff       	call   ea3 <write>
    102e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1031:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1034:	0f b6 1e             	movzbl (%esi),%ebx
    1037:	83 c6 01             	add    $0x1,%esi
    103a:	84 db                	test   %bl,%bl
    103c:	74 71                	je     10af <printf+0xcf>
    c = fmt[i] & 0xff;
    103e:	0f be cb             	movsbl %bl,%ecx
    1041:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1044:	85 d2                	test   %edx,%edx
    1046:	74 c8                	je     1010 <printf+0x30>
      }
    } else if(state == '%'){
    1048:	83 fa 25             	cmp    $0x25,%edx
    104b:	75 e7                	jne    1034 <printf+0x54>
      if(c == 'd'){
    104d:	83 f8 64             	cmp    $0x64,%eax
    1050:	0f 84 9a 00 00 00    	je     10f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1056:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    105c:	83 f9 70             	cmp    $0x70,%ecx
    105f:	74 5f                	je     10c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1061:	83 f8 73             	cmp    $0x73,%eax
    1064:	0f 84 d6 00 00 00    	je     1140 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    106a:	83 f8 63             	cmp    $0x63,%eax
    106d:	0f 84 8d 00 00 00    	je     1100 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1073:	83 f8 25             	cmp    $0x25,%eax
    1076:	0f 84 b4 00 00 00    	je     1130 <printf+0x150>
  write(fd, &c, 1);
    107c:	83 ec 04             	sub    $0x4,%esp
    107f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1083:	6a 01                	push   $0x1
    1085:	57                   	push   %edi
    1086:	ff 75 08             	push   0x8(%ebp)
    1089:	e8 15 fe ff ff       	call   ea3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    108e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1091:	83 c4 0c             	add    $0xc,%esp
    1094:	6a 01                	push   $0x1
  for(i = 0; fmt[i]; i++){
    1096:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1099:	57                   	push   %edi
    109a:	ff 75 08             	push   0x8(%ebp)
    109d:	e8 01 fe ff ff       	call   ea3 <write>
  for(i = 0; fmt[i]; i++){
    10a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    10a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    10a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    10ab:	84 db                	test   %bl,%bl
    10ad:	75 8f                	jne    103e <printf+0x5e>
    }
  }
}
    10af:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10b2:	5b                   	pop    %ebx
    10b3:	5e                   	pop    %esi
    10b4:	5f                   	pop    %edi
    10b5:	5d                   	pop    %ebp
    10b6:	c3                   	ret    
    10b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    10c0:	83 ec 0c             	sub    $0xc,%esp
    10c3:	b9 10 00 00 00       	mov    $0x10,%ecx
    10c8:	6a 00                	push   $0x0
    10ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	8b 13                	mov    (%ebx),%edx
    10d2:	e8 59 fe ff ff       	call   f30 <printint>
        ap++;
    10d7:	89 d8                	mov    %ebx,%eax
    10d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    10dc:	31 d2                	xor    %edx,%edx
        ap++;
    10de:	83 c0 04             	add    $0x4,%eax
    10e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    10e4:	e9 4b ff ff ff       	jmp    1034 <printf+0x54>
    10e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    10f0:	83 ec 0c             	sub    $0xc,%esp
    10f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    10f8:	6a 01                	push   $0x1
    10fa:	eb ce                	jmp    10ca <printf+0xea>
    10fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1100:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1103:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1106:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1108:	6a 01                	push   $0x1
        ap++;
    110a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    110d:	57                   	push   %edi
    110e:	ff 75 08             	push   0x8(%ebp)
        putc(fd, *ap);
    1111:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1114:	e8 8a fd ff ff       	call   ea3 <write>
        ap++;
    1119:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    111c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    111f:	31 d2                	xor    %edx,%edx
    1121:	e9 0e ff ff ff       	jmp    1034 <printf+0x54>
    1126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    112d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1130:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1133:	83 ec 04             	sub    $0x4,%esp
    1136:	e9 59 ff ff ff       	jmp    1094 <printf+0xb4>
    113b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    113f:	90                   	nop
        s = (char*)*ap;
    1140:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1143:	8b 18                	mov    (%eax),%ebx
        ap++;
    1145:	83 c0 04             	add    $0x4,%eax
    1148:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    114b:	85 db                	test   %ebx,%ebx
    114d:	74 17                	je     1166 <printf+0x186>
        while(*s != 0){
    114f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1152:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1154:	84 c0                	test   %al,%al
    1156:	0f 84 d8 fe ff ff    	je     1034 <printf+0x54>
    115c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    115f:	89 de                	mov    %ebx,%esi
    1161:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1164:	eb 1a                	jmp    1180 <printf+0x1a0>
          s = "(null)";
    1166:	bb 30 14 00 00       	mov    $0x1430,%ebx
        while(*s != 0){
    116b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    116e:	b8 28 00 00 00       	mov    $0x28,%eax
    1173:	89 de                	mov    %ebx,%esi
    1175:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    117f:	90                   	nop
  write(fd, &c, 1);
    1180:	83 ec 04             	sub    $0x4,%esp
          s++;
    1183:	83 c6 01             	add    $0x1,%esi
    1186:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1189:	6a 01                	push   $0x1
    118b:	57                   	push   %edi
    118c:	53                   	push   %ebx
    118d:	e8 11 fd ff ff       	call   ea3 <write>
        while(*s != 0){
    1192:	0f b6 06             	movzbl (%esi),%eax
    1195:	83 c4 10             	add    $0x10,%esp
    1198:	84 c0                	test   %al,%al
    119a:	75 e4                	jne    1180 <printf+0x1a0>
      state = 0;
    119c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
    119f:	31 d2                	xor    %edx,%edx
    11a1:	e9 8e fe ff ff       	jmp    1034 <printf+0x54>
    11a6:	66 90                	xchg   %ax,%ax
    11a8:	66 90                	xchg   %ax,%ax
    11aa:	66 90                	xchg   %ax,%ax
    11ac:	66 90                	xchg   %ax,%ax
    11ae:	66 90                	xchg   %ax,%ax

000011b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11b1:	a1 c4 14 00 00       	mov    0x14c4,%eax
{
    11b6:	89 e5                	mov    %esp,%ebp
    11b8:	57                   	push   %edi
    11b9:	56                   	push   %esi
    11ba:	53                   	push   %ebx
    11bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    11be:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11c8:	89 c2                	mov    %eax,%edx
    11ca:	8b 00                	mov    (%eax),%eax
    11cc:	39 ca                	cmp    %ecx,%edx
    11ce:	73 30                	jae    1200 <free+0x50>
    11d0:	39 c1                	cmp    %eax,%ecx
    11d2:	72 04                	jb     11d8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11d4:	39 c2                	cmp    %eax,%edx
    11d6:	72 f0                	jb     11c8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    11d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    11db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    11de:	39 f8                	cmp    %edi,%eax
    11e0:	74 30                	je     1212 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    11e2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    11e5:	8b 42 04             	mov    0x4(%edx),%eax
    11e8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    11eb:	39 f1                	cmp    %esi,%ecx
    11ed:	74 3a                	je     1229 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    11ef:	89 0a                	mov    %ecx,(%edx)
  freep = p;
}
    11f1:	5b                   	pop    %ebx
  freep = p;
    11f2:	89 15 c4 14 00 00    	mov    %edx,0x14c4
}
    11f8:	5e                   	pop    %esi
    11f9:	5f                   	pop    %edi
    11fa:	5d                   	pop    %ebp
    11fb:	c3                   	ret    
    11fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1200:	39 c2                	cmp    %eax,%edx
    1202:	72 c4                	jb     11c8 <free+0x18>
    1204:	39 c1                	cmp    %eax,%ecx
    1206:	73 c0                	jae    11c8 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    1208:	8b 73 fc             	mov    -0x4(%ebx),%esi
    120b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    120e:	39 f8                	cmp    %edi,%eax
    1210:	75 d0                	jne    11e2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    1212:	03 70 04             	add    0x4(%eax),%esi
    1215:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1218:	8b 02                	mov    (%edx),%eax
    121a:	8b 00                	mov    (%eax),%eax
    121c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    121f:	8b 42 04             	mov    0x4(%edx),%eax
    1222:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    1225:	39 f1                	cmp    %esi,%ecx
    1227:	75 c6                	jne    11ef <free+0x3f>
    p->s.size += bp->s.size;
    1229:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    122c:	89 15 c4 14 00 00    	mov    %edx,0x14c4
    p->s.size += bp->s.size;
    1232:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    1235:	8b 43 f8             	mov    -0x8(%ebx),%eax
    1238:	89 02                	mov    %eax,(%edx)
}
    123a:	5b                   	pop    %ebx
    123b:	5e                   	pop    %esi
    123c:	5f                   	pop    %edi
    123d:	5d                   	pop    %ebp
    123e:	c3                   	ret    
    123f:	90                   	nop

00001240 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	57                   	push   %edi
    1244:	56                   	push   %esi
    1245:	53                   	push   %ebx
    1246:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1249:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    124c:	8b 3d c4 14 00 00    	mov    0x14c4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1252:	8d 70 07             	lea    0x7(%eax),%esi
    1255:	c1 ee 03             	shr    $0x3,%esi
    1258:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    125b:	85 ff                	test   %edi,%edi
    125d:	0f 84 ad 00 00 00    	je     1310 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1263:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    1265:	8b 48 04             	mov    0x4(%eax),%ecx
    1268:	39 f1                	cmp    %esi,%ecx
    126a:	73 71                	jae    12dd <malloc+0x9d>
    126c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1272:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1277:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    127a:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1281:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1284:	eb 1b                	jmp    12a1 <malloc+0x61>
    1286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    128d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1290:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1292:	8b 4a 04             	mov    0x4(%edx),%ecx
    1295:	39 f1                	cmp    %esi,%ecx
    1297:	73 4f                	jae    12e8 <malloc+0xa8>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1299:	8b 3d c4 14 00 00    	mov    0x14c4,%edi
    129f:	89 d0                	mov    %edx,%eax
    12a1:	39 c7                	cmp    %eax,%edi
    12a3:	75 eb                	jne    1290 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    12a5:	83 ec 0c             	sub    $0xc,%esp
    12a8:	ff 75 e4             	push   -0x1c(%ebp)
    12ab:	e8 5b fc ff ff       	call   f0b <sbrk>
  if(p == (char*)-1)
    12b0:	83 c4 10             	add    $0x10,%esp
    12b3:	83 f8 ff             	cmp    $0xffffffff,%eax
    12b6:	74 1b                	je     12d3 <malloc+0x93>
  hp->s.size = nu;
    12b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    12bb:	83 ec 0c             	sub    $0xc,%esp
    12be:	83 c0 08             	add    $0x8,%eax
    12c1:	50                   	push   %eax
    12c2:	e8 e9 fe ff ff       	call   11b0 <free>
  return freep;
    12c7:	a1 c4 14 00 00       	mov    0x14c4,%eax
      if((p = morecore(nunits)) == 0)
    12cc:	83 c4 10             	add    $0x10,%esp
    12cf:	85 c0                	test   %eax,%eax
    12d1:	75 bd                	jne    1290 <malloc+0x50>
        return 0;
  }
}
    12d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    12d6:	31 c0                	xor    %eax,%eax
}
    12d8:	5b                   	pop    %ebx
    12d9:	5e                   	pop    %esi
    12da:	5f                   	pop    %edi
    12db:	5d                   	pop    %ebp
    12dc:	c3                   	ret    
    if(p->s.size >= nunits){
    12dd:	89 c2                	mov    %eax,%edx
    12df:	89 f8                	mov    %edi,%eax
    12e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    12e8:	39 ce                	cmp    %ecx,%esi
    12ea:	74 54                	je     1340 <malloc+0x100>
        p->s.size -= nunits;
    12ec:	29 f1                	sub    %esi,%ecx
    12ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    12f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    12f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    12f7:	a3 c4 14 00 00       	mov    %eax,0x14c4
}
    12fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    12ff:	8d 42 08             	lea    0x8(%edx),%eax
}
    1302:	5b                   	pop    %ebx
    1303:	5e                   	pop    %esi
    1304:	5f                   	pop    %edi
    1305:	5d                   	pop    %ebp
    1306:	c3                   	ret    
    1307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    130e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1310:	c7 05 c4 14 00 00 c8 	movl   $0x14c8,0x14c4
    1317:	14 00 00 
    base.s.size = 0;
    131a:	bf c8 14 00 00       	mov    $0x14c8,%edi
    base.s.ptr = freep = prevp = &base;
    131f:	c7 05 c8 14 00 00 c8 	movl   $0x14c8,0x14c8
    1326:	14 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1329:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    132b:	c7 05 cc 14 00 00 00 	movl   $0x0,0x14cc
    1332:	00 00 00 
    if(p->s.size >= nunits){
    1335:	e9 32 ff ff ff       	jmp    126c <malloc+0x2c>
    133a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1340:	8b 0a                	mov    (%edx),%ecx
    1342:	89 08                	mov    %ecx,(%eax)
    1344:	eb b1                	jmp    12f7 <malloc+0xb7>
