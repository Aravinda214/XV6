
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 54 11 80       	mov    $0x801154d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 32 10 80       	mov    $0x80103240,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 73 10 80       	push   $0x801073a0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 65 45 00 00       	call   801045c0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 73 10 80       	push   $0x801073a7
80100097:	50                   	push   %eax
80100098:	e8 f3 43 00 00       	call   80104490 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 a7 46 00 00       	call   80104790 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 c9 45 00 00       	call   80104730 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 43 00 00       	call   801044d0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 2f 23 00 00       	call   801024c0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 73 10 80       	push   $0x801073ae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ad 43 00 00       	call   80104570 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 e7 22 00 00       	jmp    801024c0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 73 10 80       	push   $0x801073bf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 43 00 00       	call   80104570 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 1c 43 00 00       	call   80104530 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 70 45 00 00       	call   80104790 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 bf 44 00 00       	jmp    80104730 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 73 10 80       	push   $0x801073c6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 a7 17 00 00       	call   80101a40 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 eb 44 00 00       	call   80104790 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 5e 3f 00 00       	call   80104230 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 38 00 00       	call   80103b60 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 35 44 00 00       	call   80104730 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 5c 16 00 00       	call   80101960 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 df 43 00 00       	call   80104730 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 06 16 00 00       	call   80101960 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 27 00 00       	call   80102ad0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 73 10 80       	push   $0x801073cd
801003a7:	e8 d4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 cb 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 f7 7c 10 80 	movl   $0x80107cf7,(%esp)
801003bc:	e8 bf 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 42 00 00       	call   801045e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 73 10 80       	push   $0x801073e1
801003dd:	e8 9e 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0e 00 00 00       	mov    $0xe,%eax
80100408:	89 e5                	mov    %esp,%ebp
8010040a:	57                   	push   %edi
8010040b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100410:	56                   	push   %esi
80100411:	89 fa                	mov    %edi,%edx
80100413:	53                   	push   %ebx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	be d5 03 00 00       	mov    $0x3d5,%esi
8010041d:	89 f2                	mov    %esi,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	c1 e0 08             	shl    $0x8,%eax
80100428:	89 c3                	mov    %eax,%ebx
8010042a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100430:	89 f2                	mov    %esi,%edx
80100432:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100433:	0f b6 c0             	movzbl %al,%eax
80100436:	09 d8                	or     %ebx,%eax
  if(c == '\n')
80100438:	83 f9 0a             	cmp    $0xa,%ecx
8010043b:	0f 84 97 00 00 00    	je     801004d8 <cgaputc+0xd8>
  else if(c == BACKSPACE){
80100441:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100447:	74 77                	je     801004c0 <cgaputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100449:	0f b6 c9             	movzbl %cl,%ecx
8010044c:	8d 58 01             	lea    0x1(%eax),%ebx
8010044f:	80 cd 07             	or     $0x7,%ch
80100452:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100459:	80 
  if(pos < 0 || pos > 25*80)
8010045a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100460:	0f 8f cc 00 00 00    	jg     80100532 <cgaputc+0x132>
  if((pos/80) >= 24){  // Scroll up.
80100466:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010046c:	0f 8f 7e 00 00 00    	jg     801004f0 <cgaputc+0xf0>
  outb(CRTPORT+1, pos>>8);
80100472:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100475:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100477:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
8010047e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100481:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100486:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048b:	89 da                	mov    %ebx,%edx
8010048d:	ee                   	out    %al,(%dx)
8010048e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100493:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100497:	89 ca                	mov    %ecx,%edx
80100499:	ee                   	out    %al,(%dx)
8010049a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049f:	89 da                	mov    %ebx,%edx
801004a1:	ee                   	out    %al,(%dx)
801004a2:	89 f8                	mov    %edi,%eax
801004a4:	89 ca                	mov    %ecx,%edx
801004a6:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a7:	b8 20 07 00 00       	mov    $0x720,%eax
801004ac:	66 89 06             	mov    %ax,(%esi)
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
801004b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004be:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004c3:	85 c0                	test   %eax,%eax
801004c5:	75 93                	jne    8010045a <cgaputc+0x5a>
801004c7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004cb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004d0:	31 ff                	xor    %edi,%edi
801004d2:	eb ad                	jmp    80100481 <cgaputc+0x81>
801004d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004d8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004dd:	f7 e2                	mul    %edx
801004df:	c1 ea 06             	shr    $0x6,%edx
801004e2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004e5:	c1 e0 04             	shl    $0x4,%eax
801004e8:	8d 58 50             	lea    0x50(%eax),%ebx
801004eb:	e9 6a ff ff ff       	jmp    8010045a <cgaputc+0x5a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004f3:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f6:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fd:	68 60 0e 00 00       	push   $0xe60
80100502:	68 a0 80 0b 80       	push   $0x800b80a0
80100507:	68 00 80 0b 80       	push   $0x800b8000
8010050c:	e8 df 43 00 00       	call   801048f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100511:	b8 80 07 00 00       	mov    $0x780,%eax
80100516:	83 c4 0c             	add    $0xc,%esp
80100519:	29 f8                	sub    %edi,%eax
8010051b:	01 c0                	add    %eax,%eax
8010051d:	50                   	push   %eax
8010051e:	6a 00                	push   $0x0
80100520:	56                   	push   %esi
80100521:	e8 2a 43 00 00       	call   80104850 <memset>
  outb(CRTPORT+1, pos);
80100526:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010052a:	83 c4 10             	add    $0x10,%esp
8010052d:	e9 4f ff ff ff       	jmp    80100481 <cgaputc+0x81>
    panic("pos under/overflow");
80100532:	83 ec 0c             	sub    $0xc,%esp
80100535:	68 e5 73 10 80       	push   $0x801073e5
8010053a:	e8 41 fe ff ff       	call   80100380 <panic>
8010053f:	90                   	nop

80100540 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100540:	55                   	push   %ebp
80100541:	89 e5                	mov    %esp,%ebp
80100543:	57                   	push   %edi
80100544:	56                   	push   %esi
80100545:	53                   	push   %ebx
80100546:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100549:	ff 75 08             	push   0x8(%ebp)
{
8010054c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010054f:	e8 ec 14 00 00       	call   80101a40 <iunlock>
  acquire(&cons.lock);
80100554:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010055b:	e8 30 42 00 00       	call   80104790 <acquire>
  for(i = 0; i < n; i++)
80100560:	83 c4 10             	add    $0x10,%esp
80100563:	85 f6                	test   %esi,%esi
80100565:	7e 3a                	jle    801005a1 <consolewrite+0x61>
80100567:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010056a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010056d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100573:	85 d2                	test   %edx,%edx
80100575:	74 09                	je     80100580 <consolewrite+0x40>
  asm volatile("cli");
80100577:	fa                   	cli    
    for(;;)
80100578:	eb fe                	jmp    80100578 <consolewrite+0x38>
8010057a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100580:	0f b6 03             	movzbl (%ebx),%eax
    uartputc(c);
80100583:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < n; i++)
80100586:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100589:	50                   	push   %eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010058d:	e8 2e 59 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
80100592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100595:	e8 66 fe ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
8010059a:	83 c4 10             	add    $0x10,%esp
8010059d:	39 df                	cmp    %ebx,%edi
8010059f:	75 cc                	jne    8010056d <consolewrite+0x2d>
  release(&cons.lock);
801005a1:	83 ec 0c             	sub    $0xc,%esp
801005a4:	68 20 ef 10 80       	push   $0x8010ef20
801005a9:	e8 82 41 00 00       	call   80104730 <release>
  ilock(ip);
801005ae:	58                   	pop    %eax
801005af:	ff 75 08             	push   0x8(%ebp)
801005b2:	e8 a9 13 00 00       	call   80101960 <ilock>

  return n;
}
801005b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ba:	89 f0                	mov    %esi,%eax
801005bc:	5b                   	pop    %ebx
801005bd:	5e                   	pop    %esi
801005be:	5f                   	pop    %edi
801005bf:	5d                   	pop    %ebp
801005c0:	c3                   	ret    
801005c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005cf:	90                   	nop

801005d0 <printint>:
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 2c             	sub    $0x2c,%esp
801005d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005df:	85 c9                	test   %ecx,%ecx
801005e1:	74 04                	je     801005e7 <printint+0x17>
801005e3:	85 c0                	test   %eax,%eax
801005e5:	78 7e                	js     80100665 <printint+0x95>
    x = xx;
801005e7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801005ee:	89 c1                	mov    %eax,%ecx
  i = 0;
801005f0:	31 db                	xor    %ebx,%ebx
801005f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
801005f8:	89 c8                	mov    %ecx,%eax
801005fa:	31 d2                	xor    %edx,%edx
801005fc:	89 de                	mov    %ebx,%esi
801005fe:	89 cf                	mov    %ecx,%edi
80100600:	f7 75 d4             	divl   -0x2c(%ebp)
80100603:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100606:	0f b6 92 10 74 10 80 	movzbl -0x7fef8bf0(%edx),%edx
  }while((x /= base) != 0);
8010060d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010060f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100613:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100616:	73 e0                	jae    801005f8 <printint+0x28>
  if(sign)
80100618:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010061b:	85 c9                	test   %ecx,%ecx
8010061d:	74 0c                	je     8010062b <printint+0x5b>
    buf[i++] = '-';
8010061f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100624:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100626:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010062b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010062f:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100634:	85 c0                	test   %eax,%eax
80100636:	74 08                	je     80100640 <printint+0x70>
80100638:	fa                   	cli    
    for(;;)
80100639:	eb fe                	jmp    80100639 <printint+0x69>
8010063b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop
    consputc(buf[i]);
80100640:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100643:	83 ec 0c             	sub    $0xc,%esp
80100646:	56                   	push   %esi
80100647:	e8 74 58 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
8010064c:	89 f0                	mov    %esi,%eax
8010064e:	e8 ad fd ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
80100653:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100656:	83 c4 10             	add    $0x10,%esp
80100659:	39 c3                	cmp    %eax,%ebx
8010065b:	74 0e                	je     8010066b <printint+0x9b>
    consputc(buf[i]);
8010065d:	0f b6 13             	movzbl (%ebx),%edx
80100660:	83 eb 01             	sub    $0x1,%ebx
80100663:	eb ca                	jmp    8010062f <printint+0x5f>
    x = -xx;
80100665:	f7 d8                	neg    %eax
80100667:	89 c1                	mov    %eax,%ecx
80100669:	eb 85                	jmp    801005f0 <printint+0x20>
}
8010066b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010066e:	5b                   	pop    %ebx
8010066f:	5e                   	pop    %esi
80100670:	5f                   	pop    %edi
80100671:	5d                   	pop    %ebp
80100672:	c3                   	ret    
80100673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100689:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
8010068e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100691:	85 c0                	test   %eax,%eax
80100693:	0f 85 37 01 00 00    	jne    801007d0 <cprintf+0x150>
  if (fmt == 0)
80100699:	8b 75 08             	mov    0x8(%ebp),%esi
8010069c:	85 f6                	test   %esi,%esi
8010069e:	0f 84 3f 02 00 00    	je     801008e3 <cprintf+0x263>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006a7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006aa:	31 db                	xor    %ebx,%ebx
801006ac:	85 c0                	test   %eax,%eax
801006ae:	74 56                	je     80100706 <cprintf+0x86>
    if(c != '%'){
801006b0:	83 f8 25             	cmp    $0x25,%eax
801006b3:	0f 85 d7 00 00 00    	jne    80100790 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801006b9:	83 c3 01             	add    $0x1,%ebx
801006bc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006c0:	85 d2                	test   %edx,%edx
801006c2:	74 42                	je     80100706 <cprintf+0x86>
    switch(c){
801006c4:	83 fa 70             	cmp    $0x70,%edx
801006c7:	0f 84 94 00 00 00    	je     80100761 <cprintf+0xe1>
801006cd:	7f 51                	jg     80100720 <cprintf+0xa0>
801006cf:	83 fa 25             	cmp    $0x25,%edx
801006d2:	0f 84 48 01 00 00    	je     80100820 <cprintf+0x1a0>
801006d8:	83 fa 64             	cmp    $0x64,%edx
801006db:	0f 85 04 01 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 10, 1);
801006e1:	8d 47 04             	lea    0x4(%edi),%eax
801006e4:	b9 01 00 00 00       	mov    $0x1,%ecx
801006e9:	ba 0a 00 00 00       	mov    $0xa,%edx
801006ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006f1:	8b 07                	mov    (%edi),%eax
801006f3:	e8 d8 fe ff ff       	call   801005d0 <printint>
801006f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fb:	83 c3 01             	add    $0x1,%ebx
801006fe:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100702:	85 c0                	test   %eax,%eax
80100704:	75 aa                	jne    801006b0 <cprintf+0x30>
  if(locking)
80100706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100709:	85 c0                	test   %eax,%eax
8010070b:	0f 85 b5 01 00 00    	jne    801008c6 <cprintf+0x246>
}
80100711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100714:	5b                   	pop    %ebx
80100715:	5e                   	pop    %esi
80100716:	5f                   	pop    %edi
80100717:	5d                   	pop    %ebp
80100718:	c3                   	ret    
80100719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	75 33                	jne    80100758 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100725:	8d 47 04             	lea    0x4(%edi),%eax
80100728:	8b 3f                	mov    (%edi),%edi
8010072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010072d:	85 ff                	test   %edi,%edi
8010072f:	0f 85 33 01 00 00    	jne    80100868 <cprintf+0x1e8>
        s = "(null)";
80100735:	bf f8 73 10 80       	mov    $0x801073f8,%edi
      for(; *s; s++)
8010073a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010073d:	b8 28 00 00 00       	mov    $0x28,%eax
80100742:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100744:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010074a:	85 d2                	test   %edx,%edx
8010074c:	0f 84 27 01 00 00    	je     80100879 <cprintf+0x1f9>
80100752:	fa                   	cli    
    for(;;)
80100753:	eb fe                	jmp    80100753 <cprintf+0xd3>
80100755:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100758:	83 fa 78             	cmp    $0x78,%edx
8010075b:	0f 85 84 00 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 16, 0);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	31 c9                	xor    %ecx,%ecx
80100766:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010076b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 58 fe ff ff       	call   801005d0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100778:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010077c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077f:	85 c0                	test   %eax,%eax
80100781:	0f 85 29 ff ff ff    	jne    801006b0 <cprintf+0x30>
80100787:	e9 7a ff ff ff       	jmp    80100706 <cprintf+0x86>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100790:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100796:	85 c9                	test   %ecx,%ecx
80100798:	74 06                	je     801007a0 <cprintf+0x120>
8010079a:	fa                   	cli    
    for(;;)
8010079b:	eb fe                	jmp    8010079b <cprintf+0x11b>
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801007a9:	50                   	push   %eax
801007aa:	e8 11 57 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	e8 49 fc ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801007bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007be:	85 c0                	test   %eax,%eax
801007c0:	0f 85 ea fe ff ff    	jne    801006b0 <cprintf+0x30>
801007c6:	e9 3b ff ff ff       	jmp    80100706 <cprintf+0x86>
801007cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007cf:	90                   	nop
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 b3 3f 00 00       	call   80104790 <acquire>
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	e9 b4 fe ff ff       	jmp    80100699 <cprintf+0x19>
  if(panicked){
801007e5:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
801007eb:	85 c9                	test   %ecx,%ecx
801007ed:	75 71                	jne    80100860 <cprintf+0x1e0>
    uartputc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007f5:	6a 25                	push   $0x25
801007f7:	e8 c4 56 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
801007fc:	b8 25 00 00 00       	mov    $0x25,%eax
80100801:	e8 fa fb ff ff       	call   80100400 <cgaputc>
  if(panicked){
80100806:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010080c:	83 c4 10             	add    $0x10,%esp
8010080f:	85 d2                	test   %edx,%edx
80100811:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100814:	0f 84 8e 00 00 00    	je     801008a8 <cprintf+0x228>
8010081a:	fa                   	cli    
    for(;;)
8010081b:	eb fe                	jmp    8010081b <cprintf+0x19b>
8010081d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100820:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100825:	85 c0                	test   %eax,%eax
80100827:	74 07                	je     80100830 <cprintf+0x1b0>
80100829:	fa                   	cli    
    for(;;)
8010082a:	eb fe                	jmp    8010082a <cprintf+0x1aa>
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100830:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100833:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100836:	6a 25                	push   $0x25
80100838:	e8 83 56 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
8010083d:	b8 25 00 00 00       	mov    $0x25,%eax
80100842:	e8 b9 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100847:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010084b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010084e:	85 c0                	test   %eax,%eax
80100850:	0f 85 5a fe ff ff    	jne    801006b0 <cprintf+0x30>
80100856:	e9 ab fe ff ff       	jmp    80100706 <cprintf+0x86>
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop
80100860:	fa                   	cli    
    for(;;)
80100861:	eb fe                	jmp    80100861 <cprintf+0x1e1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
      for(; *s; s++)
80100868:	0f b6 07             	movzbl (%edi),%eax
8010086b:	84 c0                	test   %al,%al
8010086d:	74 6c                	je     801008db <cprintf+0x25b>
8010086f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100872:	89 fb                	mov    %edi,%ebx
80100874:	e9 cb fe ff ff       	jmp    80100744 <cprintf+0xc4>
    uartputc(c);
80100879:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010087c:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
8010087f:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100882:	57                   	push   %edi
80100883:	e8 38 56 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
80100888:	89 f8                	mov    %edi,%eax
8010088a:	e8 71 fb ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
8010088f:	0f b6 03             	movzbl (%ebx),%eax
80100892:	83 c4 10             	add    $0x10,%esp
80100895:	84 c0                	test   %al,%al
80100897:	0f 85 a7 fe ff ff    	jne    80100744 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
8010089d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801008a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008a3:	e9 53 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    uartputc(c);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008ae:	52                   	push   %edx
801008af:	e8 0c 56 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
801008b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008b7:	89 d0                	mov    %edx,%eax
801008b9:	e8 42 fb ff ff       	call   80100400 <cgaputc>
}
801008be:	83 c4 10             	add    $0x10,%esp
801008c1:	e9 35 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    release(&cons.lock);
801008c6:	83 ec 0c             	sub    $0xc,%esp
801008c9:	68 20 ef 10 80       	push   $0x8010ef20
801008ce:	e8 5d 3e 00 00       	call   80104730 <release>
801008d3:	83 c4 10             	add    $0x10,%esp
}
801008d6:	e9 36 fe ff ff       	jmp    80100711 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008db:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008de:	e9 18 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    panic("null fmt");
801008e3:	83 ec 0c             	sub    $0xc,%esp
801008e6:	68 ff 73 10 80       	push   $0x801073ff
801008eb:	e8 90 fa ff ff       	call   80100380 <panic>

801008f0 <consoleintr>:
{
801008f0:	55                   	push   %ebp
801008f1:	89 e5                	mov    %esp,%ebp
801008f3:	57                   	push   %edi
801008f4:	56                   	push   %esi
801008f5:	53                   	push   %ebx
  char a[18]="\033[2J\033[1;1H";//On printing this it resets ubuntu terminal's cursor position to top-left
801008f6:	31 db                	xor    %ebx,%ebx
{
801008f8:	83 ec 48             	sub    $0x48,%esp
  char a[18]="\033[2J\033[1;1H";//On printing this it resets ubuntu terminal's cursor position to top-left
801008fb:	66 89 5d e6          	mov    %bx,-0x1a(%ebp)
{
801008ff:	8b 7d 08             	mov    0x8(%ebp),%edi
80100902:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
  acquire(&cons.lock);
80100905:	68 20 ef 10 80       	push   $0x8010ef20
  char a[18]="\033[2J\033[1;1H";//On printing this it resets ubuntu terminal's cursor position to top-left
8010090a:	c7 45 d6 1b 5b 32 4a 	movl   $0x4a325b1b,-0x2a(%ebp)
80100911:	c7 45 da 1b 5b 31 3b 	movl   $0x3b315b1b,-0x26(%ebp)
80100918:	c7 45 de 31 48 00 00 	movl   $0x4831,-0x22(%ebp)
8010091f:	c7 45 e2 00 00 00 00 	movl   $0x0,-0x1e(%ebp)
  acquire(&cons.lock);
80100926:	e8 65 3e 00 00       	call   80104790 <acquire>
  int c, doprocdump = 0;
8010092b:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  while((c = getc()) >= 0){
80100932:	83 c4 10             	add    $0x10,%esp
80100935:	ff d7                	call   *%edi
80100937:	85 c0                	test   %eax,%eax
80100939:	0f 88 be 00 00 00    	js     801009fd <consoleintr+0x10d>
    switch(c){
8010093f:	83 f8 10             	cmp    $0x10,%eax
80100942:	0f 84 10 02 00 00    	je     80100b58 <consoleintr+0x268>
80100948:	0f 8f d2 00 00 00    	jg     80100a20 <consoleintr+0x130>
8010094e:	83 f8 08             	cmp    $0x8,%eax
80100951:	0f 84 16 01 00 00    	je     80100a6d <consoleintr+0x17d>
80100957:	83 f8 0c             	cmp    $0xc,%eax
8010095a:	0f 85 40 01 00 00    	jne    80100aa0 <consoleintr+0x1b0>
80100960:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100963:	b8 1b 00 00 00       	mov    $0x1b,%eax
80100968:	eb 0c                	jmp    80100976 <consoleintr+0x86>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      d=a[i];
80100970:	0f be 06             	movsbl (%esi),%eax
80100973:	83 c6 01             	add    $0x1,%esi
      uartputc(d);	//writing to ubuntu terminal	
80100976:	83 ec 0c             	sub    $0xc,%esp
80100979:	50                   	push   %eax
8010097a:	e8 41 55 00 00       	call   80105ec0 <uartputc>
      while(i<14)
8010097f:	83 c4 10             	add    $0x10,%esp
80100982:	39 f3                	cmp    %esi,%ebx
80100984:	75 ea                	jne    80100970 <consoleintr+0x80>
80100986:	be 19 00 00 00       	mov    $0x19,%esi
8010098b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010098f:	90                   	nop
        cgaputc('\n');//writing to qemu 
80100990:	b8 0a 00 00 00       	mov    $0xa,%eax
80100995:	e8 66 fa ff ff       	call   80100400 <cgaputc>
      while(i<=24)
8010099a:	83 ee 01             	sub    $0x1,%esi
8010099d:	75 f1                	jne    80100990 <consoleintr+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010099f:	b8 0e 00 00 00       	mov    $0xe,%eax
801009a4:	ba d4 03 00 00       	mov    $0x3d4,%edx
801009a9:	ee                   	out    %al,(%dx)
801009aa:	31 c9                	xor    %ecx,%ecx
801009ac:	be d5 03 00 00       	mov    $0x3d5,%esi
801009b1:	89 c8                	mov    %ecx,%eax
801009b3:	89 f2                	mov    %esi,%edx
801009b5:	ee                   	out    %al,(%dx)
801009b6:	b8 0f 00 00 00       	mov    $0xf,%eax
801009bb:	ba d4 03 00 00       	mov    $0x3d4,%edx
801009c0:	ee                   	out    %al,(%dx)
801009c1:	89 c8                	mov    %ecx,%eax
801009c3:	89 f2                	mov    %esi,%edx
801009c5:	ee                   	out    %al,(%dx)
      cgaputc('$');
801009c6:	b8 24 00 00 00       	mov    $0x24,%eax
801009cb:	e8 30 fa ff ff       	call   80100400 <cgaputc>
      cgaputc(' ');
801009d0:	b8 20 00 00 00       	mov    $0x20,%eax
801009d5:	e8 26 fa ff ff       	call   80100400 <cgaputc>
      uartputc('$');
801009da:	83 ec 0c             	sub    $0xc,%esp
801009dd:	6a 24                	push   $0x24
801009df:	e8 dc 54 00 00       	call   80105ec0 <uartputc>
      uartputc(' ');	
801009e4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801009eb:	e8 d0 54 00 00       	call   80105ec0 <uartputc>
      break;
801009f0:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801009f3:	ff d7                	call   *%edi
801009f5:	85 c0                	test   %eax,%eax
801009f7:	0f 89 42 ff ff ff    	jns    8010093f <consoleintr+0x4f>
  release(&cons.lock);
801009fd:	83 ec 0c             	sub    $0xc,%esp
80100a00:	68 20 ef 10 80       	push   $0x8010ef20
80100a05:	e8 26 3d 00 00       	call   80104730 <release>
  if(doprocdump) {
80100a0a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80100a0d:	83 c4 10             	add    $0x10,%esp
80100a10:	85 c0                	test   %eax,%eax
80100a12:	0f 85 c8 01 00 00    	jne    80100be0 <consoleintr+0x2f0>
}
80100a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1b:	5b                   	pop    %ebx
80100a1c:	5e                   	pop    %esi
80100a1d:	5f                   	pop    %edi
80100a1e:	5d                   	pop    %ebp
80100a1f:	c3                   	ret    
    switch(c){
80100a20:	83 f8 15             	cmp    $0x15,%eax
80100a23:	75 43                	jne    80100a68 <consoleintr+0x178>
      while(input.e != input.w &&
80100a25:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a2a:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100a30:	0f 84 ff fe ff ff    	je     80100935 <consoleintr+0x45>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a36:	83 e8 01             	sub    $0x1,%eax
80100a39:	89 c2                	mov    %eax,%edx
80100a3b:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a3e:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100a45:	0f 84 ea fe ff ff    	je     80100935 <consoleintr+0x45>
  if(panicked){
80100a4b:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.e--;
80100a51:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a56:	85 c9                	test   %ecx,%ecx
80100a58:	0f 84 06 01 00 00    	je     80100b64 <consoleintr+0x274>
  asm volatile("cli");
80100a5e:	fa                   	cli    
    for(;;)
80100a5f:	eb fe                	jmp    80100a5f <consoleintr+0x16f>
80100a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100a68:	83 f8 7f             	cmp    $0x7f,%eax
80100a6b:	75 3b                	jne    80100aa8 <consoleintr+0x1b8>
      if(input.e != input.w){
80100a6d:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a72:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100a78:	0f 84 b7 fe ff ff    	je     80100935 <consoleintr+0x45>
  if(panicked){
80100a7e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100a84:	83 e8 01             	sub    $0x1,%eax
80100a87:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100a8c:	85 d2                	test   %edx,%edx
80100a8e:	0f 84 15 01 00 00    	je     80100ba9 <consoleintr+0x2b9>
80100a94:	fa                   	cli    
    for(;;)
80100a95:	eb fe                	jmp    80100a95 <consoleintr+0x1a5>
80100a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a9e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100aa0:	85 c0                	test   %eax,%eax
80100aa2:	0f 84 8d fe ff ff    	je     80100935 <consoleintr+0x45>
80100aa8:	8b 15 08 ef 10 80    	mov    0x8010ef08,%edx
80100aae:	89 d1                	mov    %edx,%ecx
80100ab0:	2b 0d 00 ef 10 80    	sub    0x8010ef00,%ecx
80100ab6:	83 f9 7f             	cmp    $0x7f,%ecx
80100ab9:	0f 87 76 fe ff ff    	ja     80100935 <consoleintr+0x45>
        input.buf[input.e++ % INPUT_BUF] = c;
80100abf:	89 d1                	mov    %edx,%ecx
80100ac1:	83 c2 01             	add    $0x1,%edx
  if(panicked){
80100ac4:	8b 35 58 ef 10 80    	mov    0x8010ef58,%esi
        input.buf[input.e++ % INPUT_BUF] = c;
80100aca:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100ad0:	83 e1 7f             	and    $0x7f,%ecx
        c = (c == '\r') ? '\n' : c;
80100ad3:	83 f8 0d             	cmp    $0xd,%eax
80100ad6:	0f 84 10 01 00 00    	je     80100bec <consoleintr+0x2fc>
        input.buf[input.e++ % INPUT_BUF] = c;
80100adc:	88 81 80 ee 10 80    	mov    %al,-0x7fef1180(%ecx)
  if(panicked){
80100ae2:	85 f6                	test   %esi,%esi
80100ae4:	0f 85 f3 00 00 00    	jne    80100bdd <consoleintr+0x2ed>
  if(c == BACKSPACE){
80100aea:	3d 00 01 00 00       	cmp    $0x100,%eax
80100aef:	0f 85 23 01 00 00    	jne    80100c18 <consoleintr+0x328>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100af5:	83 ec 0c             	sub    $0xc,%esp
80100af8:	6a 08                	push   $0x8
80100afa:	e8 c1 53 00 00       	call   80105ec0 <uartputc>
80100aff:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100b06:	e8 b5 53 00 00       	call   80105ec0 <uartputc>
80100b0b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100b12:	e8 a9 53 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
80100b17:	b8 00 01 00 00       	mov    $0x100,%eax
80100b1c:	e8 df f8 ff ff       	call   80100400 <cgaputc>
80100b21:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b24:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
80100b29:	83 e8 80             	sub    $0xffffff80,%eax
80100b2c:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
80100b32:	0f 85 fd fd ff ff    	jne    80100935 <consoleintr+0x45>
          wakeup(&input.r);
80100b38:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100b3b:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100b40:	68 00 ef 10 80       	push   $0x8010ef00
80100b45:	e8 a6 37 00 00       	call   801042f0 <wakeup>
80100b4a:	83 c4 10             	add    $0x10,%esp
80100b4d:	e9 e3 fd ff ff       	jmp    80100935 <consoleintr+0x45>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100b58:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
80100b5f:	e9 d1 fd ff ff       	jmp    80100935 <consoleintr+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100b64:	83 ec 0c             	sub    $0xc,%esp
80100b67:	6a 08                	push   $0x8
80100b69:	e8 52 53 00 00       	call   80105ec0 <uartputc>
80100b6e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100b75:	e8 46 53 00 00       	call   80105ec0 <uartputc>
80100b7a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100b81:	e8 3a 53 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
80100b86:	b8 00 01 00 00       	mov    $0x100,%eax
80100b8b:	e8 70 f8 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100b90:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100b95:	83 c4 10             	add    $0x10,%esp
80100b98:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100b9e:	0f 85 92 fe ff ff    	jne    80100a36 <consoleintr+0x146>
80100ba4:	e9 8c fd ff ff       	jmp    80100935 <consoleintr+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ba9:	83 ec 0c             	sub    $0xc,%esp
80100bac:	6a 08                	push   $0x8
80100bae:	e8 0d 53 00 00       	call   80105ec0 <uartputc>
80100bb3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100bba:	e8 01 53 00 00       	call   80105ec0 <uartputc>
80100bbf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100bc6:	e8 f5 52 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
80100bcb:	b8 00 01 00 00       	mov    $0x100,%eax
80100bd0:	e8 2b f8 ff ff       	call   80100400 <cgaputc>
}
80100bd5:	83 c4 10             	add    $0x10,%esp
80100bd8:	e9 58 fd ff ff       	jmp    80100935 <consoleintr+0x45>
80100bdd:	fa                   	cli    
    for(;;)
80100bde:	eb fe                	jmp    80100bde <consoleintr+0x2ee>
}
80100be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100be3:	5b                   	pop    %ebx
80100be4:	5e                   	pop    %esi
80100be5:	5f                   	pop    %edi
80100be6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100be7:	e9 e4 37 00 00       	jmp    801043d0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100bec:	c6 81 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%ecx)
  if(panicked){
80100bf3:	85 f6                	test   %esi,%esi
80100bf5:	75 e6                	jne    80100bdd <consoleintr+0x2ed>
    uartputc(c);
80100bf7:	83 ec 0c             	sub    $0xc,%esp
80100bfa:	6a 0a                	push   $0xa
80100bfc:	e8 bf 52 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
80100c01:	b8 0a 00 00 00       	mov    $0xa,%eax
80100c06:	e8 f5 f7 ff ff       	call   80100400 <cgaputc>
          input.w = input.e;
80100c0b:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100c10:	83 c4 10             	add    $0x10,%esp
80100c13:	e9 20 ff ff ff       	jmp    80100b38 <consoleintr+0x248>
    uartputc(c);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80100c1e:	50                   	push   %eax
80100c1f:	e8 9c 52 00 00       	call   80105ec0 <uartputc>
  cgaputc(c);
80100c24:	8b 45 c0             	mov    -0x40(%ebp),%eax
80100c27:	e8 d4 f7 ff ff       	call   80100400 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100c2c:	8b 45 c0             	mov    -0x40(%ebp),%eax
80100c2f:	83 c4 10             	add    $0x10,%esp
80100c32:	83 f8 0a             	cmp    $0xa,%eax
80100c35:	74 09                	je     80100c40 <consoleintr+0x350>
80100c37:	83 f8 04             	cmp    $0x4,%eax
80100c3a:	0f 85 e4 fe ff ff    	jne    80100b24 <consoleintr+0x234>
          input.w = input.e;
80100c40:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100c45:	e9 ee fe ff ff       	jmp    80100b38 <consoleintr+0x248>
80100c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100c50 <consoleinit>:

void
consoleinit(void)
{
80100c50:	55                   	push   %ebp
80100c51:	89 e5                	mov    %esp,%ebp
80100c53:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100c56:	68 08 74 10 80       	push   $0x80107408
80100c5b:	68 20 ef 10 80       	push   $0x8010ef20
80100c60:	e8 5b 39 00 00       	call   801045c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100c65:	58                   	pop    %eax
80100c66:	5a                   	pop    %edx
80100c67:	6a 00                	push   $0x0
80100c69:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100c6b:	c7 05 0c f9 10 80 40 	movl   $0x80100540,0x8010f90c
80100c72:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100c75:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100c7c:	02 10 80 
  cons.locking = 1;
80100c7f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100c86:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100c89:	e8 d2 19 00 00       	call   80102660 <ioapicenable>
}
80100c8e:	83 c4 10             	add    $0x10,%esp
80100c91:	c9                   	leave  
80100c92:	c3                   	ret    
80100c93:	66 90                	xchg   %ax,%ax
80100c95:	66 90                	xchg   %ax,%ax
80100c97:	66 90                	xchg   %ax,%ax
80100c99:	66 90                	xchg   %ax,%ax
80100c9b:	66 90                	xchg   %ax,%ax
80100c9d:	66 90                	xchg   %ax,%ax
80100c9f:	90                   	nop

80100ca0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ca0:	55                   	push   %ebp
80100ca1:	89 e5                	mov    %esp,%ebp
80100ca3:	57                   	push   %edi
80100ca4:	56                   	push   %esi
80100ca5:	53                   	push   %ebx
80100ca6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100cac:	e8 af 2e 00 00       	call   80103b60 <myproc>
80100cb1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100cb7:	e8 84 22 00 00       	call   80102f40 <begin_op>

  if((ip = namei(path)) == 0){
80100cbc:	83 ec 0c             	sub    $0xc,%esp
80100cbf:	ff 75 08             	push   0x8(%ebp)
80100cc2:	e8 b9 15 00 00       	call   80102280 <namei>
80100cc7:	83 c4 10             	add    $0x10,%esp
80100cca:	85 c0                	test   %eax,%eax
80100ccc:	0f 84 02 03 00 00    	je     80100fd4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100cd2:	83 ec 0c             	sub    $0xc,%esp
80100cd5:	89 c3                	mov    %eax,%ebx
80100cd7:	50                   	push   %eax
80100cd8:	e8 83 0c 00 00       	call   80101960 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100cdd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ce3:	6a 34                	push   $0x34
80100ce5:	6a 00                	push   $0x0
80100ce7:	50                   	push   %eax
80100ce8:	53                   	push   %ebx
80100ce9:	e8 82 0f 00 00       	call   80101c70 <readi>
80100cee:	83 c4 20             	add    $0x20,%esp
80100cf1:	83 f8 34             	cmp    $0x34,%eax
80100cf4:	74 22                	je     80100d18 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100cf6:	83 ec 0c             	sub    $0xc,%esp
80100cf9:	53                   	push   %ebx
80100cfa:	e8 f1 0e 00 00       	call   80101bf0 <iunlockput>
    end_op();
80100cff:	e8 ac 22 00 00       	call   80102fb0 <end_op>
80100d04:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d0f:	5b                   	pop    %ebx
80100d10:	5e                   	pop    %esi
80100d11:	5f                   	pop    %edi
80100d12:	5d                   	pop    %ebp
80100d13:	c3                   	ret    
80100d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100d18:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100d1f:	45 4c 46 
80100d22:	75 d2                	jne    80100cf6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100d24:	e8 27 63 00 00       	call   80107050 <setupkvm>
80100d29:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d2f:	85 c0                	test   %eax,%eax
80100d31:	74 c3                	je     80100cf6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d33:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100d3a:	00 
80100d3b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100d41:	0f 84 ac 02 00 00    	je     80100ff3 <exec+0x353>
  sz = 0;
80100d47:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100d4e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d51:	31 ff                	xor    %edi,%edi
80100d53:	e9 8e 00 00 00       	jmp    80100de6 <exec+0x146>
80100d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d5f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100d60:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100d67:	75 6c                	jne    80100dd5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100d69:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100d6f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100d75:	0f 82 87 00 00 00    	jb     80100e02 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100d7b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100d81:	72 7f                	jb     80100e02 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d83:	83 ec 04             	sub    $0x4,%esp
80100d86:	50                   	push   %eax
80100d87:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100d8d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d93:	e8 d8 60 00 00       	call   80106e70 <allocuvm>
80100d98:	83 c4 10             	add    $0x10,%esp
80100d9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100da1:	85 c0                	test   %eax,%eax
80100da3:	74 5d                	je     80100e02 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100da5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100dab:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100db0:	75 50                	jne    80100e02 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100db2:	83 ec 0c             	sub    $0xc,%esp
80100db5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100dbb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100dc1:	53                   	push   %ebx
80100dc2:	50                   	push   %eax
80100dc3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dc9:	e8 b2 5f 00 00       	call   80106d80 <loaduvm>
80100dce:	83 c4 20             	add    $0x20,%esp
80100dd1:	85 c0                	test   %eax,%eax
80100dd3:	78 2d                	js     80100e02 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100ddc:	83 c7 01             	add    $0x1,%edi
80100ddf:	83 c6 20             	add    $0x20,%esi
80100de2:	39 f8                	cmp    %edi,%eax
80100de4:	7e 3a                	jle    80100e20 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100de6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100dec:	6a 20                	push   $0x20
80100dee:	56                   	push   %esi
80100def:	50                   	push   %eax
80100df0:	53                   	push   %ebx
80100df1:	e8 7a 0e 00 00       	call   80101c70 <readi>
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	83 f8 20             	cmp    $0x20,%eax
80100dfc:	0f 84 5e ff ff ff    	je     80100d60 <exec+0xc0>
    freevm(pgdir);
80100e02:	83 ec 0c             	sub    $0xc,%esp
80100e05:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100e0b:	e8 c0 61 00 00       	call   80106fd0 <freevm>
  if(ip){
80100e10:	83 c4 10             	add    $0x10,%esp
80100e13:	e9 de fe ff ff       	jmp    80100cf6 <exec+0x56>
80100e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
  sz = PGROUNDUP(sz);
80100e20:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100e26:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100e2c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e32:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100e38:	83 ec 0c             	sub    $0xc,%esp
80100e3b:	53                   	push   %ebx
80100e3c:	e8 af 0d 00 00       	call   80101bf0 <iunlockput>
  end_op();
80100e41:	e8 6a 21 00 00       	call   80102fb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e46:	83 c4 0c             	add    $0xc,%esp
80100e49:	56                   	push   %esi
80100e4a:	57                   	push   %edi
80100e4b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e51:	57                   	push   %edi
80100e52:	e8 19 60 00 00       	call   80106e70 <allocuvm>
80100e57:	83 c4 10             	add    $0x10,%esp
80100e5a:	89 c6                	mov    %eax,%esi
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 84 94 00 00 00    	je     80100ef8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e64:	83 ec 08             	sub    $0x8,%esp
80100e67:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100e6d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e6f:	50                   	push   %eax
80100e70:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100e71:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e73:	e8 78 62 00 00       	call   801070f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e7b:	83 c4 10             	add    $0x10,%esp
80100e7e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100e84:	8b 00                	mov    (%eax),%eax
80100e86:	85 c0                	test   %eax,%eax
80100e88:	0f 84 8b 00 00 00    	je     80100f19 <exec+0x279>
80100e8e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100e94:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100e9a:	eb 23                	jmp    80100ebf <exec+0x21f>
80100e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ea3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100eaa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ead:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100eb3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100eb6:	85 c0                	test   %eax,%eax
80100eb8:	74 59                	je     80100f13 <exec+0x273>
    if(argc >= MAXARG)
80100eba:	83 ff 20             	cmp    $0x20,%edi
80100ebd:	74 39                	je     80100ef8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ebf:	83 ec 0c             	sub    $0xc,%esp
80100ec2:	50                   	push   %eax
80100ec3:	e8 88 3b 00 00       	call   80104a50 <strlen>
80100ec8:	f7 d0                	not    %eax
80100eca:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ecc:	58                   	pop    %eax
80100ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ed0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ed3:	ff 34 b8             	push   (%eax,%edi,4)
80100ed6:	e8 75 3b 00 00       	call   80104a50 <strlen>
80100edb:	83 c0 01             	add    $0x1,%eax
80100ede:	50                   	push   %eax
80100edf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ee2:	ff 34 b8             	push   (%eax,%edi,4)
80100ee5:	53                   	push   %ebx
80100ee6:	56                   	push   %esi
80100ee7:	e8 d4 63 00 00       	call   801072c0 <copyout>
80100eec:	83 c4 20             	add    $0x20,%esp
80100eef:	85 c0                	test   %eax,%eax
80100ef1:	79 ad                	jns    80100ea0 <exec+0x200>
80100ef3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ef7:	90                   	nop
    freevm(pgdir);
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100f01:	e8 ca 60 00 00       	call   80106fd0 <freevm>
80100f06:	83 c4 10             	add    $0x10,%esp
  return -1;
80100f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f0e:	e9 f9 fd ff ff       	jmp    80100d0c <exec+0x6c>
80100f13:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f19:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100f20:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100f22:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100f29:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f2d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100f2f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100f32:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100f38:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f3a:	50                   	push   %eax
80100f3b:	52                   	push   %edx
80100f3c:	53                   	push   %ebx
80100f3d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100f43:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100f4a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f4d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f53:	e8 68 63 00 00       	call   801072c0 <copyout>
80100f58:	83 c4 10             	add    $0x10,%esp
80100f5b:	85 c0                	test   %eax,%eax
80100f5d:	78 99                	js     80100ef8 <exec+0x258>
  for(last=s=path; *s; s++)
80100f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80100f62:	8b 55 08             	mov    0x8(%ebp),%edx
80100f65:	0f b6 00             	movzbl (%eax),%eax
80100f68:	84 c0                	test   %al,%al
80100f6a:	74 13                	je     80100f7f <exec+0x2df>
80100f6c:	89 d1                	mov    %edx,%ecx
80100f6e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100f70:	83 c1 01             	add    $0x1,%ecx
80100f73:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100f75:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100f78:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100f7b:	84 c0                	test   %al,%al
80100f7d:	75 f1                	jne    80100f70 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f7f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100f85:	83 ec 04             	sub    $0x4,%esp
80100f88:	6a 10                	push   $0x10
80100f8a:	89 f8                	mov    %edi,%eax
80100f8c:	52                   	push   %edx
80100f8d:	83 c0 6c             	add    $0x6c,%eax
80100f90:	50                   	push   %eax
80100f91:	e8 7a 3a 00 00       	call   80104a10 <safestrcpy>
  curproc->pgdir = pgdir;
80100f96:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100f9c:	89 f8                	mov    %edi,%eax
80100f9e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100fa1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100fa3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100fa6:	89 c1                	mov    %eax,%ecx
80100fa8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100fae:	8b 40 18             	mov    0x18(%eax),%eax
80100fb1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100fb4:	8b 41 18             	mov    0x18(%ecx),%eax
80100fb7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100fba:	89 0c 24             	mov    %ecx,(%esp)
80100fbd:	e8 2e 5c 00 00       	call   80106bf0 <switchuvm>
  freevm(oldpgdir);
80100fc2:	89 3c 24             	mov    %edi,(%esp)
80100fc5:	e8 06 60 00 00       	call   80106fd0 <freevm>
  return 0;
80100fca:	83 c4 10             	add    $0x10,%esp
80100fcd:	31 c0                	xor    %eax,%eax
80100fcf:	e9 38 fd ff ff       	jmp    80100d0c <exec+0x6c>
    end_op();
80100fd4:	e8 d7 1f 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 21 74 10 80       	push   $0x80107421
80100fe1:	e8 9a f6 ff ff       	call   80100680 <cprintf>
    return -1;
80100fe6:	83 c4 10             	add    $0x10,%esp
80100fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fee:	e9 19 fd ff ff       	jmp    80100d0c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ff3:	31 ff                	xor    %edi,%edi
80100ff5:	be 00 20 00 00       	mov    $0x2000,%esi
80100ffa:	e9 39 fe ff ff       	jmp    80100e38 <exec+0x198>
80100fff:	90                   	nop

80101000 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101006:	68 2d 74 10 80       	push   $0x8010742d
8010100b:	68 60 ef 10 80       	push   $0x8010ef60
80101010:	e8 ab 35 00 00       	call   801045c0 <initlock>
}
80101015:	83 c4 10             	add    $0x10,%esp
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101024:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80101029:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010102c:	68 60 ef 10 80       	push   $0x8010ef60
80101031:	e8 5a 37 00 00       	call   80104790 <acquire>
80101036:	83 c4 10             	add    $0x10,%esp
80101039:	eb 10                	jmp    8010104b <filealloc+0x2b>
8010103b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010103f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101040:	83 c3 18             	add    $0x18,%ebx
80101043:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80101049:	74 25                	je     80101070 <filealloc+0x50>
    if(f->ref == 0){
8010104b:	8b 43 04             	mov    0x4(%ebx),%eax
8010104e:	85 c0                	test   %eax,%eax
80101050:	75 ee                	jne    80101040 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101052:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101055:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010105c:	68 60 ef 10 80       	push   $0x8010ef60
80101061:	e8 ca 36 00 00       	call   80104730 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101066:	89 d8                	mov    %ebx,%eax
      return f;
80101068:	83 c4 10             	add    $0x10,%esp
}
8010106b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010106e:	c9                   	leave  
8010106f:	c3                   	ret    
  release(&ftable.lock);
80101070:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101073:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101075:	68 60 ef 10 80       	push   $0x8010ef60
8010107a:	e8 b1 36 00 00       	call   80104730 <release>
}
8010107f:	89 d8                	mov    %ebx,%eax
  return 0;
80101081:	83 c4 10             	add    $0x10,%esp
}
80101084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101087:	c9                   	leave  
80101088:	c3                   	ret    
80101089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101090 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	53                   	push   %ebx
80101094:	83 ec 10             	sub    $0x10,%esp
80101097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010109a:	68 60 ef 10 80       	push   $0x8010ef60
8010109f:	e8 ec 36 00 00       	call   80104790 <acquire>
  if(f->ref < 1)
801010a4:	8b 43 04             	mov    0x4(%ebx),%eax
801010a7:	83 c4 10             	add    $0x10,%esp
801010aa:	85 c0                	test   %eax,%eax
801010ac:	7e 1a                	jle    801010c8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801010ae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801010b1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801010b4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801010b7:	68 60 ef 10 80       	push   $0x8010ef60
801010bc:	e8 6f 36 00 00       	call   80104730 <release>
  return f;
}
801010c1:	89 d8                	mov    %ebx,%eax
801010c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010c6:	c9                   	leave  
801010c7:	c3                   	ret    
    panic("filedup");
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	68 34 74 10 80       	push   $0x80107434
801010d0:	e8 ab f2 ff ff       	call   80100380 <panic>
801010d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 28             	sub    $0x28,%esp
801010e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801010ec:	68 60 ef 10 80       	push   $0x8010ef60
801010f1:	e8 9a 36 00 00       	call   80104790 <acquire>
  if(f->ref < 1)
801010f6:	8b 53 04             	mov    0x4(%ebx),%edx
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	85 d2                	test   %edx,%edx
801010fe:	0f 8e a5 00 00 00    	jle    801011a9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101104:	83 ea 01             	sub    $0x1,%edx
80101107:	89 53 04             	mov    %edx,0x4(%ebx)
8010110a:	75 44                	jne    80101150 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010110c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101110:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101113:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101115:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010111b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010111e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101121:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101124:	68 60 ef 10 80       	push   $0x8010ef60
  ff = *f;
80101129:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010112c:	e8 ff 35 00 00       	call   80104730 <release>

  if(ff.type == FD_PIPE)
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	83 ff 01             	cmp    $0x1,%edi
80101137:	74 57                	je     80101190 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101139:	83 ff 02             	cmp    $0x2,%edi
8010113c:	74 2a                	je     80101168 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010113e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101141:	5b                   	pop    %ebx
80101142:	5e                   	pop    %esi
80101143:	5f                   	pop    %edi
80101144:	5d                   	pop    %ebp
80101145:	c3                   	ret    
80101146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101150:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80101157:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010115a:	5b                   	pop    %ebx
8010115b:	5e                   	pop    %esi
8010115c:	5f                   	pop    %edi
8010115d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010115e:	e9 cd 35 00 00       	jmp    80104730 <release>
80101163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101167:	90                   	nop
    begin_op();
80101168:	e8 d3 1d 00 00       	call   80102f40 <begin_op>
    iput(ff.ip);
8010116d:	83 ec 0c             	sub    $0xc,%esp
80101170:	ff 75 e0             	push   -0x20(%ebp)
80101173:	e8 18 09 00 00       	call   80101a90 <iput>
    end_op();
80101178:	83 c4 10             	add    $0x10,%esp
}
8010117b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117e:	5b                   	pop    %ebx
8010117f:	5e                   	pop    %esi
80101180:	5f                   	pop    %edi
80101181:	5d                   	pop    %ebp
    end_op();
80101182:	e9 29 1e 00 00       	jmp    80102fb0 <end_op>
80101187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010118e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101190:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101194:	83 ec 08             	sub    $0x8,%esp
80101197:	53                   	push   %ebx
80101198:	56                   	push   %esi
80101199:	e8 72 25 00 00       	call   80103710 <pipeclose>
8010119e:	83 c4 10             	add    $0x10,%esp
}
801011a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a4:	5b                   	pop    %ebx
801011a5:	5e                   	pop    %esi
801011a6:	5f                   	pop    %edi
801011a7:	5d                   	pop    %ebp
801011a8:	c3                   	ret    
    panic("fileclose");
801011a9:	83 ec 0c             	sub    $0xc,%esp
801011ac:	68 3c 74 10 80       	push   $0x8010743c
801011b1:	e8 ca f1 ff ff       	call   80100380 <panic>
801011b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801011bd:	8d 76 00             	lea    0x0(%esi),%esi

801011c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	53                   	push   %ebx
801011c4:	83 ec 04             	sub    $0x4,%esp
801011c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801011ca:	83 3b 02             	cmpl   $0x2,(%ebx)
801011cd:	75 31                	jne    80101200 <filestat+0x40>
    ilock(f->ip);
801011cf:	83 ec 0c             	sub    $0xc,%esp
801011d2:	ff 73 10             	push   0x10(%ebx)
801011d5:	e8 86 07 00 00       	call   80101960 <ilock>
    stati(f->ip, st);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	ff 75 0c             	push   0xc(%ebp)
801011df:	ff 73 10             	push   0x10(%ebx)
801011e2:	e8 59 0a 00 00       	call   80101c40 <stati>
    iunlock(f->ip);
801011e7:	59                   	pop    %ecx
801011e8:	ff 73 10             	push   0x10(%ebx)
801011eb:	e8 50 08 00 00       	call   80101a40 <iunlock>
    return 0;
  }
  return -1;
}
801011f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	31 c0                	xor    %eax,%eax
}
801011f8:	c9                   	leave  
801011f9:	c3                   	ret    
801011fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101200:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101208:	c9                   	leave  
80101209:	c3                   	ret    
8010120a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101210 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	83 ec 0c             	sub    $0xc,%esp
80101219:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010121c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010121f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101222:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101226:	74 60                	je     80101288 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101228:	8b 03                	mov    (%ebx),%eax
8010122a:	83 f8 01             	cmp    $0x1,%eax
8010122d:	74 41                	je     80101270 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010122f:	83 f8 02             	cmp    $0x2,%eax
80101232:	75 5b                	jne    8010128f <fileread+0x7f>
    ilock(f->ip);
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	ff 73 10             	push   0x10(%ebx)
8010123a:	e8 21 07 00 00       	call   80101960 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010123f:	57                   	push   %edi
80101240:	ff 73 14             	push   0x14(%ebx)
80101243:	56                   	push   %esi
80101244:	ff 73 10             	push   0x10(%ebx)
80101247:	e8 24 0a 00 00       	call   80101c70 <readi>
8010124c:	83 c4 20             	add    $0x20,%esp
8010124f:	89 c6                	mov    %eax,%esi
80101251:	85 c0                	test   %eax,%eax
80101253:	7e 03                	jle    80101258 <fileread+0x48>
      f->off += r;
80101255:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101258:	83 ec 0c             	sub    $0xc,%esp
8010125b:	ff 73 10             	push   0x10(%ebx)
8010125e:	e8 dd 07 00 00       	call   80101a40 <iunlock>
    return r;
80101263:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101266:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101269:	89 f0                	mov    %esi,%eax
8010126b:	5b                   	pop    %ebx
8010126c:	5e                   	pop    %esi
8010126d:	5f                   	pop    %edi
8010126e:	5d                   	pop    %ebp
8010126f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101270:	8b 43 0c             	mov    0xc(%ebx),%eax
80101273:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101276:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101279:	5b                   	pop    %ebx
8010127a:	5e                   	pop    %esi
8010127b:	5f                   	pop    %edi
8010127c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010127d:	e9 2e 26 00 00       	jmp    801038b0 <piperead>
80101282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101288:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010128d:	eb d7                	jmp    80101266 <fileread+0x56>
  panic("fileread");
8010128f:	83 ec 0c             	sub    $0xc,%esp
80101292:	68 46 74 10 80       	push   $0x80107446
80101297:	e8 e4 f0 ff ff       	call   80100380 <panic>
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	83 ec 1c             	sub    $0x1c,%esp
801012a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801012ac:	8b 75 08             	mov    0x8(%ebp),%esi
801012af:	89 45 dc             	mov    %eax,-0x24(%ebp)
801012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801012b5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801012b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801012bc:	0f 84 bd 00 00 00    	je     8010137f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801012c2:	8b 06                	mov    (%esi),%eax
801012c4:	83 f8 01             	cmp    $0x1,%eax
801012c7:	0f 84 bf 00 00 00    	je     8010138c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801012cd:	83 f8 02             	cmp    $0x2,%eax
801012d0:	0f 85 c8 00 00 00    	jne    8010139e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801012d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801012db:	85 c0                	test   %eax,%eax
801012dd:	7f 30                	jg     8010130f <filewrite+0x6f>
801012df:	e9 94 00 00 00       	jmp    80101378 <filewrite+0xd8>
801012e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801012e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801012eb:	83 ec 0c             	sub    $0xc,%esp
801012ee:	ff 76 10             	push   0x10(%esi)
        f->off += r;
801012f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801012f4:	e8 47 07 00 00       	call   80101a40 <iunlock>
      end_op();
801012f9:	e8 b2 1c 00 00       	call   80102fb0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801012fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101301:	83 c4 10             	add    $0x10,%esp
80101304:	39 c3                	cmp    %eax,%ebx
80101306:	75 60                	jne    80101368 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
80101308:	01 df                	add    %ebx,%edi
    while(i < n){
8010130a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010130d:	7e 69                	jle    80101378 <filewrite+0xd8>
      int n1 = n - i;
8010130f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101312:	b8 00 06 00 00       	mov    $0x600,%eax
80101317:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101319:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010131f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101322:	e8 19 1c 00 00       	call   80102f40 <begin_op>
      ilock(f->ip);
80101327:	83 ec 0c             	sub    $0xc,%esp
8010132a:	ff 76 10             	push   0x10(%esi)
8010132d:	e8 2e 06 00 00       	call   80101960 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101332:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101335:	53                   	push   %ebx
80101336:	ff 76 14             	push   0x14(%esi)
80101339:	01 f8                	add    %edi,%eax
8010133b:	50                   	push   %eax
8010133c:	ff 76 10             	push   0x10(%esi)
8010133f:	e8 2c 0a 00 00       	call   80101d70 <writei>
80101344:	83 c4 20             	add    $0x20,%esp
80101347:	85 c0                	test   %eax,%eax
80101349:	7f 9d                	jg     801012e8 <filewrite+0x48>
      iunlock(f->ip);
8010134b:	83 ec 0c             	sub    $0xc,%esp
8010134e:	ff 76 10             	push   0x10(%esi)
80101351:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101354:	e8 e7 06 00 00       	call   80101a40 <iunlock>
      end_op();
80101359:	e8 52 1c 00 00       	call   80102fb0 <end_op>
      if(r < 0)
8010135e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101361:	83 c4 10             	add    $0x10,%esp
80101364:	85 c0                	test   %eax,%eax
80101366:	75 17                	jne    8010137f <filewrite+0xdf>
        panic("short filewrite");
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	68 4f 74 10 80       	push   $0x8010744f
80101370:	e8 0b f0 ff ff       	call   80100380 <panic>
80101375:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101378:	89 f8                	mov    %edi,%eax
8010137a:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010137d:	74 05                	je     80101384 <filewrite+0xe4>
8010137f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101384:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101387:	5b                   	pop    %ebx
80101388:	5e                   	pop    %esi
80101389:	5f                   	pop    %edi
8010138a:	5d                   	pop    %ebp
8010138b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010138c:	8b 46 0c             	mov    0xc(%esi),%eax
8010138f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101395:	5b                   	pop    %ebx
80101396:	5e                   	pop    %esi
80101397:	5f                   	pop    %edi
80101398:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101399:	e9 12 24 00 00       	jmp    801037b0 <pipewrite>
  panic("filewrite");
8010139e:	83 ec 0c             	sub    $0xc,%esp
801013a1:	68 55 74 10 80       	push   $0x80107455
801013a6:	e8 d5 ef ff ff       	call   80100380 <panic>
801013ab:	66 90                	xchg   %ax,%ax
801013ad:	66 90                	xchg   %ax,%ax
801013af:	90                   	nop

801013b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013b0:	55                   	push   %ebp
801013b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801013b3:	89 d0                	mov    %edx,%eax
801013b5:	c1 e8 0c             	shr    $0xc,%eax
801013b8:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
801013be:	89 e5                	mov    %esp,%ebp
801013c0:	56                   	push   %esi
801013c1:	53                   	push   %ebx
801013c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801013c4:	83 ec 08             	sub    $0x8,%esp
801013c7:	50                   	push   %eax
801013c8:	51                   	push   %ecx
801013c9:	e8 02 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013d0:	c1 fb 03             	sar    $0x3,%ebx
801013d3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801013d6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801013d8:	83 e1 07             	and    $0x7,%ecx
801013db:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801013e0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801013e6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801013e8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801013ed:	85 c1                	test   %eax,%ecx
801013ef:	74 23                	je     80101414 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013f1:	f7 d0                	not    %eax
  log_write(bp);
801013f3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801013f6:	21 c8                	and    %ecx,%eax
801013f8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801013fc:	56                   	push   %esi
801013fd:	e8 1e 1d 00 00       	call   80103120 <log_write>
  brelse(bp);
80101402:	89 34 24             	mov    %esi,(%esp)
80101405:	e8 e6 ed ff ff       	call   801001f0 <brelse>
}
8010140a:	83 c4 10             	add    $0x10,%esp
8010140d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101410:	5b                   	pop    %ebx
80101411:	5e                   	pop    %esi
80101412:	5d                   	pop    %ebp
80101413:	c3                   	ret    
    panic("freeing free block");
80101414:	83 ec 0c             	sub    $0xc,%esp
80101417:	68 5f 74 10 80       	push   $0x8010745f
8010141c:	e8 5f ef ff ff       	call   80100380 <panic>
80101421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010142f:	90                   	nop

80101430 <balloc>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	53                   	push   %ebx
80101436:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101439:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010143f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101442:	85 c9                	test   %ecx,%ecx
80101444:	0f 84 87 00 00 00    	je     801014d1 <balloc+0xa1>
8010144a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101451:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101454:	83 ec 08             	sub    $0x8,%esp
80101457:	89 f0                	mov    %esi,%eax
80101459:	c1 f8 0c             	sar    $0xc,%eax
8010145c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80101462:	50                   	push   %eax
80101463:	ff 75 d8             	push   -0x28(%ebp)
80101466:	e8 65 ec ff ff       	call   801000d0 <bread>
8010146b:	83 c4 10             	add    $0x10,%esp
8010146e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101471:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101476:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101479:	31 c0                	xor    %eax,%eax
8010147b:	eb 2f                	jmp    801014ac <balloc+0x7c>
8010147d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101480:	89 c1                	mov    %eax,%ecx
80101482:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101487:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010148a:	83 e1 07             	and    $0x7,%ecx
8010148d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010148f:	89 c1                	mov    %eax,%ecx
80101491:	c1 f9 03             	sar    $0x3,%ecx
80101494:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101499:	89 fa                	mov    %edi,%edx
8010149b:	85 df                	test   %ebx,%edi
8010149d:	74 41                	je     801014e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010149f:	83 c0 01             	add    $0x1,%eax
801014a2:	83 c6 01             	add    $0x1,%esi
801014a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801014aa:	74 05                	je     801014b1 <balloc+0x81>
801014ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801014af:	77 cf                	ja     80101480 <balloc+0x50>
    brelse(bp);
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	ff 75 e4             	push   -0x1c(%ebp)
801014b7:	e8 34 ed ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801014c3:	83 c4 10             	add    $0x10,%esp
801014c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014c9:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
801014cf:	77 80                	ja     80101451 <balloc+0x21>
  panic("balloc: out of blocks");
801014d1:	83 ec 0c             	sub    $0xc,%esp
801014d4:	68 72 74 10 80       	push   $0x80107472
801014d9:	e8 a2 ee ff ff       	call   80100380 <panic>
801014de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801014e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801014e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801014e6:	09 da                	or     %ebx,%edx
801014e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801014ec:	57                   	push   %edi
801014ed:	e8 2e 1c 00 00       	call   80103120 <log_write>
        brelse(bp);
801014f2:	89 3c 24             	mov    %edi,(%esp)
801014f5:	e8 f6 ec ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801014fa:	58                   	pop    %eax
801014fb:	5a                   	pop    %edx
801014fc:	56                   	push   %esi
801014fd:	ff 75 d8             	push   -0x28(%ebp)
80101500:	e8 cb eb ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101505:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101508:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010150a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010150d:	68 00 02 00 00       	push   $0x200
80101512:	6a 00                	push   $0x0
80101514:	50                   	push   %eax
80101515:	e8 36 33 00 00       	call   80104850 <memset>
  log_write(bp);
8010151a:	89 1c 24             	mov    %ebx,(%esp)
8010151d:	e8 fe 1b 00 00       	call   80103120 <log_write>
  brelse(bp);
80101522:	89 1c 24             	mov    %ebx,(%esp)
80101525:	e8 c6 ec ff ff       	call   801001f0 <brelse>
}
8010152a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152d:	89 f0                	mov    %esi,%eax
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5f                   	pop    %edi
80101532:	5d                   	pop    %ebp
80101533:	c3                   	ret    
80101534:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	89 c7                	mov    %eax,%edi
80101546:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101547:	31 f6                	xor    %esi,%esi
{
80101549:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010154a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010154f:	83 ec 28             	sub    $0x28,%esp
80101552:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101555:	68 60 f9 10 80       	push   $0x8010f960
8010155a:	e8 31 32 00 00       	call   80104790 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010155f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101562:	83 c4 10             	add    $0x10,%esp
80101565:	eb 1b                	jmp    80101582 <iget+0x42>
80101567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010156e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101570:	39 3b                	cmp    %edi,(%ebx)
80101572:	74 6c                	je     801015e0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101574:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010157a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101580:	73 26                	jae    801015a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101582:	8b 43 08             	mov    0x8(%ebx),%eax
80101585:	85 c0                	test   %eax,%eax
80101587:	7f e7                	jg     80101570 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101589:	85 f6                	test   %esi,%esi
8010158b:	75 e7                	jne    80101574 <iget+0x34>
8010158d:	89 d9                	mov    %ebx,%ecx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010158f:	81 c3 90 00 00 00    	add    $0x90,%ebx
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101595:	85 c0                	test   %eax,%eax
80101597:	75 6e                	jne    80101607 <iget+0xc7>
80101599:	89 ce                	mov    %ecx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010159b:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801015a1:	72 df                	jb     80101582 <iget+0x42>
801015a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801015a8:	85 f6                	test   %esi,%esi
801015aa:	74 73                	je     8010161f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801015ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801015af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801015b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801015b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801015bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801015c2:	68 60 f9 10 80       	push   $0x8010f960
801015c7:	e8 64 31 00 00       	call   80104730 <release>

  return ip;
801015cc:	83 c4 10             	add    $0x10,%esp
}
801015cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015d2:	89 f0                	mov    %esi,%eax
801015d4:	5b                   	pop    %ebx
801015d5:	5e                   	pop    %esi
801015d6:	5f                   	pop    %edi
801015d7:	5d                   	pop    %ebp
801015d8:	c3                   	ret    
801015d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801015e3:	75 8f                	jne    80101574 <iget+0x34>
      release(&icache.lock);
801015e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801015e8:	83 c0 01             	add    $0x1,%eax
      return ip;
801015eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801015ed:	68 60 f9 10 80       	push   $0x8010f960
      ip->ref++;
801015f2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801015f5:	e8 36 31 00 00       	call   80104730 <release>
      return ip;
801015fa:	83 c4 10             	add    $0x10,%esp
}
801015fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101600:	89 f0                	mov    %esi,%eax
80101602:	5b                   	pop    %ebx
80101603:	5e                   	pop    %esi
80101604:	5f                   	pop    %edi
80101605:	5d                   	pop    %ebp
80101606:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101607:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010160d:	73 10                	jae    8010161f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010160f:	8b 43 08             	mov    0x8(%ebx),%eax
80101612:	85 c0                	test   %eax,%eax
80101614:	0f 8f 56 ff ff ff    	jg     80101570 <iget+0x30>
8010161a:	e9 6e ff ff ff       	jmp    8010158d <iget+0x4d>
    panic("iget: no inodes");
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	68 88 74 10 80       	push   $0x80107488
80101627:	e8 54 ed ff ff       	call   80100380 <panic>
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	89 c6                	mov    %eax,%esi
80101637:	53                   	push   %ebx
80101638:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010163b:	83 fa 0b             	cmp    $0xb,%edx
8010163e:	0f 86 8c 00 00 00    	jbe    801016d0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101644:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101647:	83 fb 7f             	cmp    $0x7f,%ebx
8010164a:	0f 87 a2 00 00 00    	ja     801016f2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101650:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
      ip->addrs[bn] = addr = balloc(ip->dev);
80101656:	8b 16                	mov    (%esi),%edx
    if((addr = ip->addrs[NDIRECT]) == 0)
80101658:	85 c0                	test   %eax,%eax
8010165a:	74 5c                	je     801016b8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010165c:	83 ec 08             	sub    $0x8,%esp
8010165f:	50                   	push   %eax
80101660:	52                   	push   %edx
80101661:	e8 6a ea ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101666:	83 c4 10             	add    $0x10,%esp
80101669:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010166d:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010166f:	8b 3b                	mov    (%ebx),%edi
80101671:	85 ff                	test   %edi,%edi
80101673:	74 1b                	je     80101690 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101675:	83 ec 0c             	sub    $0xc,%esp
80101678:	52                   	push   %edx
80101679:	e8 72 eb ff ff       	call   801001f0 <brelse>
8010167e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101681:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101684:	89 f8                	mov    %edi,%eax
80101686:	5b                   	pop    %ebx
80101687:	5e                   	pop    %esi
80101688:	5f                   	pop    %edi
80101689:	5d                   	pop    %ebp
8010168a:	c3                   	ret    
8010168b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010168f:	90                   	nop
80101690:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101693:	8b 06                	mov    (%esi),%eax
80101695:	e8 96 fd ff ff       	call   80101430 <balloc>
      log_write(bp);
8010169a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010169d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801016a0:	89 03                	mov    %eax,(%ebx)
801016a2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801016a4:	52                   	push   %edx
801016a5:	e8 76 1a 00 00       	call   80103120 <log_write>
801016aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016ad:	83 c4 10             	add    $0x10,%esp
801016b0:	eb c3                	jmp    80101675 <bmap+0x45>
801016b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801016b8:	89 d0                	mov    %edx,%eax
801016ba:	e8 71 fd ff ff       	call   80101430 <balloc>
    bp = bread(ip->dev, addr);
801016bf:	8b 16                	mov    (%esi),%edx
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801016c1:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801016c7:	eb 93                	jmp    8010165c <bmap+0x2c>
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801016d0:	8d 5a 14             	lea    0x14(%edx),%ebx
801016d3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801016d7:	85 ff                	test   %edi,%edi
801016d9:	75 a6                	jne    80101681 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801016db:	8b 00                	mov    (%eax),%eax
801016dd:	e8 4e fd ff ff       	call   80101430 <balloc>
801016e2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801016e6:	89 c7                	mov    %eax,%edi
}
801016e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016eb:	5b                   	pop    %ebx
801016ec:	89 f8                	mov    %edi,%eax
801016ee:	5e                   	pop    %esi
801016ef:	5f                   	pop    %edi
801016f0:	5d                   	pop    %ebp
801016f1:	c3                   	ret    
  panic("bmap: out of range");
801016f2:	83 ec 0c             	sub    $0xc,%esp
801016f5:	68 98 74 10 80       	push   $0x80107498
801016fa:	e8 81 ec ff ff       	call   80100380 <panic>
801016ff:	90                   	nop

80101700 <readsb>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101708:	83 ec 08             	sub    $0x8,%esp
8010170b:	6a 01                	push   $0x1
8010170d:	ff 75 08             	push   0x8(%ebp)
80101710:	e8 bb e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101715:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101718:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010171a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010171d:	6a 1c                	push   $0x1c
8010171f:	50                   	push   %eax
80101720:	56                   	push   %esi
80101721:	e8 ca 31 00 00       	call   801048f0 <memmove>
  brelse(bp);
80101726:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101729:	83 c4 10             	add    $0x10,%esp
}
8010172c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172f:	5b                   	pop    %ebx
80101730:	5e                   	pop    %esi
80101731:	5d                   	pop    %ebp
  brelse(bp);
80101732:	e9 b9 ea ff ff       	jmp    801001f0 <brelse>
80101737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173e:	66 90                	xchg   %ax,%ax

80101740 <iinit>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	53                   	push   %ebx
80101744:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101749:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010174c:	68 ab 74 10 80       	push   $0x801074ab
80101751:	68 60 f9 10 80       	push   $0x8010f960
80101756:	e8 65 2e 00 00       	call   801045c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010175b:	83 c4 10             	add    $0x10,%esp
8010175e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101760:	83 ec 08             	sub    $0x8,%esp
80101763:	68 b2 74 10 80       	push   $0x801074b2
80101768:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101769:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010176f:	e8 1c 2d 00 00       	call   80104490 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101774:	83 c4 10             	add    $0x10,%esp
80101777:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010177d:	75 e1                	jne    80101760 <iinit+0x20>
  bp = bread(dev, 1);
8010177f:	83 ec 08             	sub    $0x8,%esp
80101782:	6a 01                	push   $0x1
80101784:	ff 75 08             	push   0x8(%ebp)
80101787:	e8 44 e9 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010178c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010178f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101791:	8d 40 5c             	lea    0x5c(%eax),%eax
80101794:	6a 1c                	push   $0x1c
80101796:	50                   	push   %eax
80101797:	68 b4 15 11 80       	push   $0x801115b4
8010179c:	e8 4f 31 00 00       	call   801048f0 <memmove>
  brelse(bp);
801017a1:	89 1c 24             	mov    %ebx,(%esp)
801017a4:	e8 47 ea ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017a9:	ff 35 cc 15 11 80    	push   0x801115cc
801017af:	ff 35 c8 15 11 80    	push   0x801115c8
801017b5:	ff 35 c4 15 11 80    	push   0x801115c4
801017bb:	ff 35 c0 15 11 80    	push   0x801115c0
801017c1:	ff 35 bc 15 11 80    	push   0x801115bc
801017c7:	ff 35 b8 15 11 80    	push   0x801115b8
801017cd:	ff 35 b4 15 11 80    	push   0x801115b4
801017d3:	68 18 75 10 80       	push   $0x80107518
801017d8:	e8 a3 ee ff ff       	call   80100680 <cprintf>
}
801017dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e0:	83 c4 30             	add    $0x30,%esp
801017e3:	c9                   	leave  
801017e4:	c3                   	ret    
801017e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017f0 <ialloc>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 1c             	sub    $0x1c,%esp
801017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801017fc:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101803:	8b 75 08             	mov    0x8(%ebp),%esi
80101806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101809:	0f 86 91 00 00 00    	jbe    801018a0 <ialloc+0xb0>
8010180f:	bf 01 00 00 00       	mov    $0x1,%edi
80101814:	eb 21                	jmp    80101837 <ialloc+0x47>
80101816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010181d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101820:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101823:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101826:	53                   	push   %ebx
80101827:	e8 c4 e9 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010182c:	83 c4 10             	add    $0x10,%esp
8010182f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101835:	73 69                	jae    801018a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101837:	89 f8                	mov    %edi,%eax
80101839:	83 ec 08             	sub    $0x8,%esp
8010183c:	c1 e8 03             	shr    $0x3,%eax
8010183f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101845:	50                   	push   %eax
80101846:	56                   	push   %esi
80101847:	e8 84 e8 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010184c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010184f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101851:	89 f8                	mov    %edi,%eax
80101853:	83 e0 07             	and    $0x7,%eax
80101856:	c1 e0 06             	shl    $0x6,%eax
80101859:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010185d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101861:	75 bd                	jne    80101820 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101863:	83 ec 04             	sub    $0x4,%esp
80101866:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101869:	6a 40                	push   $0x40
8010186b:	6a 00                	push   $0x0
8010186d:	51                   	push   %ecx
8010186e:	e8 dd 2f 00 00       	call   80104850 <memset>
      dip->type = type;
80101873:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101877:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010187a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010187d:	89 1c 24             	mov    %ebx,(%esp)
80101880:	e8 9b 18 00 00       	call   80103120 <log_write>
      brelse(bp);
80101885:	89 1c 24             	mov    %ebx,(%esp)
80101888:	e8 63 e9 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010188d:	83 c4 10             	add    $0x10,%esp
}
80101890:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101893:	89 fa                	mov    %edi,%edx
}
80101895:	5b                   	pop    %ebx
      return iget(dev, inum);
80101896:	89 f0                	mov    %esi,%eax
}
80101898:	5e                   	pop    %esi
80101899:	5f                   	pop    %edi
8010189a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010189b:	e9 a0 fc ff ff       	jmp    80101540 <iget>
  panic("ialloc: no inodes");
801018a0:	83 ec 0c             	sub    $0xc,%esp
801018a3:	68 b8 74 10 80       	push   $0x801074b8
801018a8:	e8 d3 ea ff ff       	call   80100380 <panic>
801018ad:	8d 76 00             	lea    0x0(%esi),%esi

801018b0 <iupdate>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018bb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018be:	83 ec 08             	sub    $0x8,%esp
801018c1:	c1 e8 03             	shr    $0x3,%eax
801018c4:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801018ca:	50                   	push   %eax
801018cb:	ff 73 a4             	push   -0x5c(%ebx)
801018ce:	e8 fd e7 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801018d3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018d7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018da:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801018dc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801018df:	83 e0 07             	and    $0x7,%eax
801018e2:	c1 e0 06             	shl    $0x6,%eax
801018e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018e9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018f0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801018f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801018f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801018ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101903:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101907:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010190a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010190d:	6a 34                	push   $0x34
8010190f:	53                   	push   %ebx
80101910:	50                   	push   %eax
80101911:	e8 da 2f 00 00       	call   801048f0 <memmove>
  log_write(bp);
80101916:	89 34 24             	mov    %esi,(%esp)
80101919:	e8 02 18 00 00       	call   80103120 <log_write>
  brelse(bp);
8010191e:	89 75 08             	mov    %esi,0x8(%ebp)
80101921:	83 c4 10             	add    $0x10,%esp
}
80101924:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101927:	5b                   	pop    %ebx
80101928:	5e                   	pop    %esi
80101929:	5d                   	pop    %ebp
  brelse(bp);
8010192a:	e9 c1 e8 ff ff       	jmp    801001f0 <brelse>
8010192f:	90                   	nop

80101930 <idup>:
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 10             	sub    $0x10,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010193a:	68 60 f9 10 80       	push   $0x8010f960
8010193f:	e8 4c 2e 00 00       	call   80104790 <acquire>
  ip->ref++;
80101944:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101948:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010194f:	e8 dc 2d 00 00       	call   80104730 <release>
}
80101954:	89 d8                	mov    %ebx,%eax
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
8010195a:	c3                   	ret    
8010195b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010195f:	90                   	nop

80101960 <ilock>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	56                   	push   %esi
80101964:	53                   	push   %ebx
80101965:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101968:	85 db                	test   %ebx,%ebx
8010196a:	0f 84 b7 00 00 00    	je     80101a27 <ilock+0xc7>
80101970:	8b 53 08             	mov    0x8(%ebx),%edx
80101973:	85 d2                	test   %edx,%edx
80101975:	0f 8e ac 00 00 00    	jle    80101a27 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010197b:	83 ec 0c             	sub    $0xc,%esp
8010197e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101981:	50                   	push   %eax
80101982:	e8 49 2b 00 00       	call   801044d0 <acquiresleep>
  if(ip->valid == 0){
80101987:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	85 c0                	test   %eax,%eax
8010198f:	74 0f                	je     801019a0 <ilock+0x40>
}
80101991:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101994:	5b                   	pop    %ebx
80101995:	5e                   	pop    %esi
80101996:	5d                   	pop    %ebp
80101997:	c3                   	ret    
80101998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010199f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019a0:	8b 43 04             	mov    0x4(%ebx),%eax
801019a3:	83 ec 08             	sub    $0x8,%esp
801019a6:	c1 e8 03             	shr    $0x3,%eax
801019a9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801019af:	50                   	push   %eax
801019b0:	ff 33                	push   (%ebx)
801019b2:	e8 19 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019bc:	8b 43 04             	mov    0x4(%ebx),%eax
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801019c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801019cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801019d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801019d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801019db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801019df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801019e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801019eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801019ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019f1:	6a 34                	push   $0x34
801019f3:	50                   	push   %eax
801019f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019f7:	50                   	push   %eax
801019f8:	e8 f3 2e 00 00       	call   801048f0 <memmove>
    brelse(bp);
801019fd:	89 34 24             	mov    %esi,(%esp)
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101a05:	83 c4 10             	add    $0x10,%esp
80101a08:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101a0d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101a14:	0f 85 77 ff ff ff    	jne    80101991 <ilock+0x31>
      panic("ilock: no type");
80101a1a:	83 ec 0c             	sub    $0xc,%esp
80101a1d:	68 d0 74 10 80       	push   $0x801074d0
80101a22:	e8 59 e9 ff ff       	call   80100380 <panic>
    panic("ilock");
80101a27:	83 ec 0c             	sub    $0xc,%esp
80101a2a:	68 ca 74 10 80       	push   $0x801074ca
80101a2f:	e8 4c e9 ff ff       	call   80100380 <panic>
80101a34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a3f:	90                   	nop

80101a40 <iunlock>:
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	56                   	push   %esi
80101a44:	53                   	push   %ebx
80101a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a48:	85 db                	test   %ebx,%ebx
80101a4a:	74 28                	je     80101a74 <iunlock+0x34>
80101a4c:	83 ec 0c             	sub    $0xc,%esp
80101a4f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a52:	56                   	push   %esi
80101a53:	e8 18 2b 00 00       	call   80104570 <holdingsleep>
80101a58:	83 c4 10             	add    $0x10,%esp
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	74 15                	je     80101a74 <iunlock+0x34>
80101a5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a62:	85 c0                	test   %eax,%eax
80101a64:	7e 0e                	jle    80101a74 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a66:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a6c:	5b                   	pop    %ebx
80101a6d:	5e                   	pop    %esi
80101a6e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a6f:	e9 bc 2a 00 00       	jmp    80104530 <releasesleep>
    panic("iunlock");
80101a74:	83 ec 0c             	sub    $0xc,%esp
80101a77:	68 df 74 10 80       	push   $0x801074df
80101a7c:	e8 ff e8 ff ff       	call   80100380 <panic>
80101a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <iput>:
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 28             	sub    $0x28,%esp
80101a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a9c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a9f:	57                   	push   %edi
80101aa0:	e8 2b 2a 00 00       	call   801044d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101aa5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101aa8:	83 c4 10             	add    $0x10,%esp
80101aab:	85 d2                	test   %edx,%edx
80101aad:	74 07                	je     80101ab6 <iput+0x26>
80101aaf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101ab4:	74 32                	je     80101ae8 <iput+0x58>
  releasesleep(&ip->lock);
80101ab6:	83 ec 0c             	sub    $0xc,%esp
80101ab9:	57                   	push   %edi
80101aba:	e8 71 2a 00 00       	call   80104530 <releasesleep>
  acquire(&icache.lock);
80101abf:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101ac6:	e8 c5 2c 00 00       	call   80104790 <acquire>
  ip->ref--;
80101acb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adc:	5b                   	pop    %ebx
80101add:	5e                   	pop    %esi
80101ade:	5f                   	pop    %edi
80101adf:	5d                   	pop    %ebp
  release(&icache.lock);
80101ae0:	e9 4b 2c 00 00       	jmp    80104730 <release>
80101ae5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ae8:	83 ec 0c             	sub    $0xc,%esp
80101aeb:	68 60 f9 10 80       	push   $0x8010f960
80101af0:	e8 9b 2c 00 00       	call   80104790 <acquire>
    int r = ip->ref;
80101af5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101af8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101aff:	e8 2c 2c 00 00       	call   80104730 <release>
    if(r == 1){
80101b04:	83 c4 10             	add    $0x10,%esp
80101b07:	83 fe 01             	cmp    $0x1,%esi
80101b0a:	75 aa                	jne    80101ab6 <iput+0x26>
80101b0c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b12:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b15:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b18:	89 cf                	mov    %ecx,%edi
80101b1a:	eb 0b                	jmp    80101b27 <iput+0x97>
80101b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101b20:	83 c6 04             	add    $0x4,%esi
80101b23:	39 fe                	cmp    %edi,%esi
80101b25:	74 19                	je     80101b40 <iput+0xb0>
    if(ip->addrs[i]){
80101b27:	8b 16                	mov    (%esi),%edx
80101b29:	85 d2                	test   %edx,%edx
80101b2b:	74 f3                	je     80101b20 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101b2d:	8b 03                	mov    (%ebx),%eax
80101b2f:	e8 7c f8 ff ff       	call   801013b0 <bfree>
      ip->addrs[i] = 0;
80101b34:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b3a:	eb e4                	jmp    80101b20 <iput+0x90>
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b40:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b46:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b49:	85 c0                	test   %eax,%eax
80101b4b:	75 2d                	jne    80101b7a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b4d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b50:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b57:	53                   	push   %ebx
80101b58:	e8 53 fd ff ff       	call   801018b0 <iupdate>
      ip->type = 0;
80101b5d:	31 c0                	xor    %eax,%eax
80101b5f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b63:	89 1c 24             	mov    %ebx,(%esp)
80101b66:	e8 45 fd ff ff       	call   801018b0 <iupdate>
      ip->valid = 0;
80101b6b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b72:	83 c4 10             	add    $0x10,%esp
80101b75:	e9 3c ff ff ff       	jmp    80101ab6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b7a:	83 ec 08             	sub    $0x8,%esp
80101b7d:	50                   	push   %eax
80101b7e:	ff 33                	push   (%ebx)
80101b80:	e8 4b e5 ff ff       	call   801000d0 <bread>
80101b85:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b88:	83 c4 10             	add    $0x10,%esp
80101b8b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101b94:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b97:	89 cf                	mov    %ecx,%edi
80101b99:	eb 0c                	jmp    80101ba7 <iput+0x117>
80101b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop
80101ba0:	83 c6 04             	add    $0x4,%esi
80101ba3:	39 f7                	cmp    %esi,%edi
80101ba5:	74 0f                	je     80101bb6 <iput+0x126>
      if(a[j])
80101ba7:	8b 16                	mov    (%esi),%edx
80101ba9:	85 d2                	test   %edx,%edx
80101bab:	74 f3                	je     80101ba0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101bad:	8b 03                	mov    (%ebx),%eax
80101baf:	e8 fc f7 ff ff       	call   801013b0 <bfree>
80101bb4:	eb ea                	jmp    80101ba0 <iput+0x110>
    brelse(bp);
80101bb6:	83 ec 0c             	sub    $0xc,%esp
80101bb9:	ff 75 e4             	push   -0x1c(%ebp)
80101bbc:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bbf:	e8 2c e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101bc4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101bca:	8b 03                	mov    (%ebx),%eax
80101bcc:	e8 df f7 ff ff       	call   801013b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101bd1:	83 c4 10             	add    $0x10,%esp
80101bd4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101bdb:	00 00 00 
80101bde:	e9 6a ff ff ff       	jmp    80101b4d <iput+0xbd>
80101be3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101bf0 <iunlockput>:
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	56                   	push   %esi
80101bf4:	53                   	push   %ebx
80101bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101bf8:	85 db                	test   %ebx,%ebx
80101bfa:	74 34                	je     80101c30 <iunlockput+0x40>
80101bfc:	83 ec 0c             	sub    $0xc,%esp
80101bff:	8d 73 0c             	lea    0xc(%ebx),%esi
80101c02:	56                   	push   %esi
80101c03:	e8 68 29 00 00       	call   80104570 <holdingsleep>
80101c08:	83 c4 10             	add    $0x10,%esp
80101c0b:	85 c0                	test   %eax,%eax
80101c0d:	74 21                	je     80101c30 <iunlockput+0x40>
80101c0f:	8b 43 08             	mov    0x8(%ebx),%eax
80101c12:	85 c0                	test   %eax,%eax
80101c14:	7e 1a                	jle    80101c30 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101c16:	83 ec 0c             	sub    $0xc,%esp
80101c19:	56                   	push   %esi
80101c1a:	e8 11 29 00 00       	call   80104530 <releasesleep>
  iput(ip);
80101c1f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c22:	83 c4 10             	add    $0x10,%esp
}
80101c25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c28:	5b                   	pop    %ebx
80101c29:	5e                   	pop    %esi
80101c2a:	5d                   	pop    %ebp
  iput(ip);
80101c2b:	e9 60 fe ff ff       	jmp    80101a90 <iput>
    panic("iunlock");
80101c30:	83 ec 0c             	sub    $0xc,%esp
80101c33:	68 df 74 10 80       	push   $0x801074df
80101c38:	e8 43 e7 ff ff       	call   80100380 <panic>
80101c3d:	8d 76 00             	lea    0x0(%esi),%esi

80101c40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	8b 55 08             	mov    0x8(%ebp),%edx
80101c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c49:	8b 0a                	mov    (%edx),%ecx
80101c4b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c4e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c51:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c54:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c58:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c5b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c5f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c63:	8b 52 58             	mov    0x58(%edx),%edx
80101c66:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c69:	5d                   	pop    %ebp
80101c6a:	c3                   	ret    
80101c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c6f:	90                   	nop

80101c70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	83 ec 1c             	sub    $0x1c,%esp
80101c79:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7f:	8b 75 10             	mov    0x10(%ebp),%esi
80101c82:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c85:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c88:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c90:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c93:	0f 84 a7 00 00 00    	je     80101d40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c9c:	8b 40 58             	mov    0x58(%eax),%eax
80101c9f:	39 c6                	cmp    %eax,%esi
80101ca1:	0f 87 ba 00 00 00    	ja     80101d61 <readi+0xf1>
80101ca7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101caa:	31 c9                	xor    %ecx,%ecx
80101cac:	89 da                	mov    %ebx,%edx
80101cae:	01 f2                	add    %esi,%edx
80101cb0:	0f 92 c1             	setb   %cl
80101cb3:	89 cf                	mov    %ecx,%edi
80101cb5:	0f 82 a6 00 00 00    	jb     80101d61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101cbb:	89 c1                	mov    %eax,%ecx
80101cbd:	29 f1                	sub    %esi,%ecx
80101cbf:	39 d0                	cmp    %edx,%eax
80101cc1:	0f 43 cb             	cmovae %ebx,%ecx
80101cc4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cc7:	85 c9                	test   %ecx,%ecx
80101cc9:	74 67                	je     80101d32 <readi+0xc2>
80101ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ccf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cd0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101cd3:	89 f2                	mov    %esi,%edx
80101cd5:	c1 ea 09             	shr    $0x9,%edx
80101cd8:	89 d8                	mov    %ebx,%eax
80101cda:	e8 51 f9 ff ff       	call   80101630 <bmap>
80101cdf:	83 ec 08             	sub    $0x8,%esp
80101ce2:	50                   	push   %eax
80101ce3:	ff 33                	push   (%ebx)
80101ce5:	e8 e6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ced:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cf2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cf5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101cf7:	89 f0                	mov    %esi,%eax
80101cf9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cfe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d09:	39 d9                	cmp    %ebx,%ecx
80101d0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d0f:	01 df                	add    %ebx,%edi
80101d11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101d13:	50                   	push   %eax
80101d14:	ff 75 e0             	push   -0x20(%ebp)
80101d17:	e8 d4 2b 00 00       	call   801048f0 <memmove>
    brelse(bp);
80101d1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d1f:	89 14 24             	mov    %edx,(%esp)
80101d22:	e8 c9 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d30:	77 9e                	ja     80101cd0 <readi+0x60>
  }
  return n;
80101d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d38:	5b                   	pop    %ebx
80101d39:	5e                   	pop    %esi
80101d3a:	5f                   	pop    %edi
80101d3b:	5d                   	pop    %ebp
80101d3c:	c3                   	ret    
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d44:	66 83 f8 09          	cmp    $0x9,%ax
80101d48:	77 17                	ja     80101d61 <readi+0xf1>
80101d4a:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101d51:	85 c0                	test   %eax,%eax
80101d53:	74 0c                	je     80101d61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d5b:	5b                   	pop    %ebx
80101d5c:	5e                   	pop    %esi
80101d5d:	5f                   	pop    %edi
80101d5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d5f:	ff e0                	jmp    *%eax
      return -1;
80101d61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d66:	eb cd                	jmp    80101d35 <readi+0xc5>
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	83 ec 1c             	sub    $0x1c,%esp
80101d79:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d7f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d90:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d93:	0f 84 b7 00 00 00    	je     80101e50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d9c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d9f:	0f 87 e7 00 00 00    	ja     80101e8c <writei+0x11c>
80101da5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101da8:	31 d2                	xor    %edx,%edx
80101daa:	89 f8                	mov    %edi,%eax
80101dac:	01 f0                	add    %esi,%eax
80101dae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101db1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101db6:	0f 87 d0 00 00 00    	ja     80101e8c <writei+0x11c>
80101dbc:	85 d2                	test   %edx,%edx
80101dbe:	0f 85 c8 00 00 00    	jne    80101e8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101dc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101dcb:	85 ff                	test   %edi,%edi
80101dcd:	74 72                	je     80101e41 <writei+0xd1>
80101dcf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101dd3:	89 f2                	mov    %esi,%edx
80101dd5:	c1 ea 09             	shr    $0x9,%edx
80101dd8:	89 f8                	mov    %edi,%eax
80101dda:	e8 51 f8 ff ff       	call   80101630 <bmap>
80101ddf:	83 ec 08             	sub    $0x8,%esp
80101de2:	50                   	push   %eax
80101de3:	ff 37                	push   (%edi)
80101de5:	e8 e6 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101dea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101def:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101df2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101df5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101df7:	89 f0                	mov    %esi,%eax
80101df9:	83 c4 0c             	add    $0xc,%esp
80101dfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e07:	39 d9                	cmp    %ebx,%ecx
80101e09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101e0f:	ff 75 dc             	push   -0x24(%ebp)
80101e12:	50                   	push   %eax
80101e13:	e8 d8 2a 00 00       	call   801048f0 <memmove>
    log_write(bp);
80101e18:	89 3c 24             	mov    %edi,(%esp)
80101e1b:	e8 00 13 00 00       	call   80103120 <log_write>
    brelse(bp);
80101e20:	89 3c 24             	mov    %edi,(%esp)
80101e23:	e8 c8 e3 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e2b:	83 c4 10             	add    $0x10,%esp
80101e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e37:	77 97                	ja     80101dd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e3f:	77 37                	ja     80101e78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e54:	66 83 f8 09          	cmp    $0x9,%ax
80101e58:	77 32                	ja     80101e8c <writei+0x11c>
80101e5a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101e61:	85 c0                	test   %eax,%eax
80101e63:	74 27                	je     80101e8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101e65:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6b:	5b                   	pop    %ebx
80101e6c:	5e                   	pop    %esi
80101e6d:	5f                   	pop    %edi
80101e6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e6f:	ff e0                	jmp    *%eax
80101e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e81:	50                   	push   %eax
80101e82:	e8 29 fa ff ff       	call   801018b0 <iupdate>
80101e87:	83 c4 10             	add    $0x10,%esp
80101e8a:	eb b5                	jmp    80101e41 <writei+0xd1>
      return -1;
80101e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e91:	eb b1                	jmp    80101e44 <writei+0xd4>
80101e93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ea0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ea6:	6a 0e                	push   $0xe
80101ea8:	ff 75 0c             	push   0xc(%ebp)
80101eab:	ff 75 08             	push   0x8(%ebp)
80101eae:	e8 ad 2a 00 00       	call   80104960 <strncmp>
}
80101eb3:	c9                   	leave  
80101eb4:	c3                   	ret    
80101eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ec0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	83 ec 1c             	sub    $0x1c,%esp
80101ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ecc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ed1:	0f 85 85 00 00 00    	jne    80101f5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ed7:	8b 53 58             	mov    0x58(%ebx),%edx
80101eda:	31 ff                	xor    %edi,%edi
80101edc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101edf:	85 d2                	test   %edx,%edx
80101ee1:	74 3e                	je     80101f21 <dirlookup+0x61>
80101ee3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ee7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee8:	6a 10                	push   $0x10
80101eea:	57                   	push   %edi
80101eeb:	56                   	push   %esi
80101eec:	53                   	push   %ebx
80101eed:	e8 7e fd ff ff       	call   80101c70 <readi>
80101ef2:	83 c4 10             	add    $0x10,%esp
80101ef5:	83 f8 10             	cmp    $0x10,%eax
80101ef8:	75 55                	jne    80101f4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101efa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eff:	74 18                	je     80101f19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f01:	83 ec 04             	sub    $0x4,%esp
80101f04:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f07:	6a 0e                	push   $0xe
80101f09:	50                   	push   %eax
80101f0a:	ff 75 0c             	push   0xc(%ebp)
80101f0d:	e8 4e 2a 00 00       	call   80104960 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101f12:	83 c4 10             	add    $0x10,%esp
80101f15:	85 c0                	test   %eax,%eax
80101f17:	74 17                	je     80101f30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f19:	83 c7 10             	add    $0x10,%edi
80101f1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f1f:	72 c7                	jb     80101ee8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f24:	31 c0                	xor    %eax,%eax
}
80101f26:	5b                   	pop    %ebx
80101f27:	5e                   	pop    %esi
80101f28:	5f                   	pop    %edi
80101f29:	5d                   	pop    %ebp
80101f2a:	c3                   	ret    
80101f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      if(poff)
80101f30:	8b 45 10             	mov    0x10(%ebp),%eax
80101f33:	85 c0                	test   %eax,%eax
80101f35:	74 05                	je     80101f3c <dirlookup+0x7c>
        *poff = off;
80101f37:	8b 45 10             	mov    0x10(%ebp),%eax
80101f3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f40:	8b 03                	mov    (%ebx),%eax
80101f42:	e8 f9 f5 ff ff       	call   80101540 <iget>
}
80101f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4a:	5b                   	pop    %ebx
80101f4b:	5e                   	pop    %esi
80101f4c:	5f                   	pop    %edi
80101f4d:	5d                   	pop    %ebp
80101f4e:	c3                   	ret    
      panic("dirlookup read");
80101f4f:	83 ec 0c             	sub    $0xc,%esp
80101f52:	68 f9 74 10 80       	push   $0x801074f9
80101f57:	e8 24 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101f5c:	83 ec 0c             	sub    $0xc,%esp
80101f5f:	68 e7 74 10 80       	push   $0x801074e7
80101f64:	e8 17 e4 ff ff       	call   80100380 <panic>
80101f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	57                   	push   %edi
80101f74:	56                   	push   %esi
80101f75:	53                   	push   %ebx
80101f76:	89 c3                	mov    %eax,%ebx
80101f78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f7e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101f84:	0f 84 64 01 00 00    	je     801020ee <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f8a:	e8 d1 1b 00 00       	call   80103b60 <myproc>
  acquire(&icache.lock);
80101f8f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f92:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f95:	68 60 f9 10 80       	push   $0x8010f960
80101f9a:	e8 f1 27 00 00       	call   80104790 <acquire>
  ip->ref++;
80101f9f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101fa3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101faa:	e8 81 27 00 00       	call   80104730 <release>
80101faf:	83 c4 10             	add    $0x10,%esp
80101fb2:	eb 07                	jmp    80101fbb <namex+0x4b>
80101fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101fb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fbb:	0f b6 03             	movzbl (%ebx),%eax
80101fbe:	3c 2f                	cmp    $0x2f,%al
80101fc0:	74 f6                	je     80101fb8 <namex+0x48>
  if(*path == 0)
80101fc2:	84 c0                	test   %al,%al
80101fc4:	0f 84 06 01 00 00    	je     801020d0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101fca:	0f b6 03             	movzbl (%ebx),%eax
80101fcd:	84 c0                	test   %al,%al
80101fcf:	0f 84 10 01 00 00    	je     801020e5 <namex+0x175>
80101fd5:	89 df                	mov    %ebx,%edi
80101fd7:	3c 2f                	cmp    $0x2f,%al
80101fd9:	0f 84 06 01 00 00    	je     801020e5 <namex+0x175>
80101fdf:	90                   	nop
80101fe0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101fe4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101fe7:	3c 2f                	cmp    $0x2f,%al
80101fe9:	74 04                	je     80101fef <namex+0x7f>
80101feb:	84 c0                	test   %al,%al
80101fed:	75 f1                	jne    80101fe0 <namex+0x70>
  len = path - s;
80101fef:	89 f8                	mov    %edi,%eax
80101ff1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101ff3:	83 f8 0d             	cmp    $0xd,%eax
80101ff6:	0f 8e ac 00 00 00    	jle    801020a8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101ffc:	83 ec 04             	sub    $0x4,%esp
80101fff:	6a 0e                	push   $0xe
80102001:	53                   	push   %ebx
    path++;
80102002:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80102004:	ff 75 e4             	push   -0x1c(%ebp)
80102007:	e8 e4 28 00 00       	call   801048f0 <memmove>
8010200c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010200f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80102012:	75 0c                	jne    80102020 <namex+0xb0>
80102014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102018:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010201b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
8010201e:	74 f8                	je     80102018 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	56                   	push   %esi
80102024:	e8 37 f9 ff ff       	call   80101960 <ilock>
    if(ip->type != T_DIR){
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102031:	0f 85 cd 00 00 00    	jne    80102104 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102037:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010203a:	85 c0                	test   %eax,%eax
8010203c:	74 09                	je     80102047 <namex+0xd7>
8010203e:	80 3b 00             	cmpb   $0x0,(%ebx)
80102041:	0f 84 22 01 00 00    	je     80102169 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102047:	83 ec 04             	sub    $0x4,%esp
8010204a:	6a 00                	push   $0x0
8010204c:	ff 75 e4             	push   -0x1c(%ebp)
8010204f:	56                   	push   %esi
80102050:	e8 6b fe ff ff       	call   80101ec0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102055:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	89 c7                	mov    %eax,%edi
8010205d:	85 c0                	test   %eax,%eax
8010205f:	0f 84 e1 00 00 00    	je     80102146 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010206b:	52                   	push   %edx
8010206c:	e8 ff 24 00 00       	call   80104570 <holdingsleep>
80102071:	83 c4 10             	add    $0x10,%esp
80102074:	85 c0                	test   %eax,%eax
80102076:	0f 84 30 01 00 00    	je     801021ac <namex+0x23c>
8010207c:	8b 56 08             	mov    0x8(%esi),%edx
8010207f:	85 d2                	test   %edx,%edx
80102081:	0f 8e 25 01 00 00    	jle    801021ac <namex+0x23c>
  releasesleep(&ip->lock);
80102087:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010208a:	83 ec 0c             	sub    $0xc,%esp
8010208d:	52                   	push   %edx
8010208e:	e8 9d 24 00 00       	call   80104530 <releasesleep>
  iput(ip);
80102093:	89 34 24             	mov    %esi,(%esp)
80102096:	89 fe                	mov    %edi,%esi
80102098:	e8 f3 f9 ff ff       	call   80101a90 <iput>
8010209d:	83 c4 10             	add    $0x10,%esp
801020a0:	e9 16 ff ff ff       	jmp    80101fbb <namex+0x4b>
801020a5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
801020a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801020ab:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
801020ae:	83 ec 04             	sub    $0x4,%esp
801020b1:	89 55 e0             	mov    %edx,-0x20(%ebp)
801020b4:	50                   	push   %eax
801020b5:	53                   	push   %ebx
    name[len] = 0;
801020b6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
801020b8:	ff 75 e4             	push   -0x1c(%ebp)
801020bb:	e8 30 28 00 00       	call   801048f0 <memmove>
    name[len] = 0;
801020c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020c3:	83 c4 10             	add    $0x10,%esp
801020c6:	c6 02 00             	movb   $0x0,(%edx)
801020c9:	e9 41 ff ff ff       	jmp    8010200f <namex+0x9f>
801020ce:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801020d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801020d3:	85 c0                	test   %eax,%eax
801020d5:	0f 85 be 00 00 00    	jne    80102199 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
801020db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020de:	89 f0                	mov    %esi,%eax
801020e0:	5b                   	pop    %ebx
801020e1:	5e                   	pop    %esi
801020e2:	5f                   	pop    %edi
801020e3:	5d                   	pop    %ebp
801020e4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801020e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801020e8:	89 df                	mov    %ebx,%edi
801020ea:	31 c0                	xor    %eax,%eax
801020ec:	eb c0                	jmp    801020ae <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801020ee:	ba 01 00 00 00       	mov    $0x1,%edx
801020f3:	b8 01 00 00 00       	mov    $0x1,%eax
801020f8:	e8 43 f4 ff ff       	call   80101540 <iget>
801020fd:	89 c6                	mov    %eax,%esi
801020ff:	e9 b7 fe ff ff       	jmp    80101fbb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102104:	83 ec 0c             	sub    $0xc,%esp
80102107:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010210a:	53                   	push   %ebx
8010210b:	e8 60 24 00 00       	call   80104570 <holdingsleep>
80102110:	83 c4 10             	add    $0x10,%esp
80102113:	85 c0                	test   %eax,%eax
80102115:	0f 84 91 00 00 00    	je     801021ac <namex+0x23c>
8010211b:	8b 46 08             	mov    0x8(%esi),%eax
8010211e:	85 c0                	test   %eax,%eax
80102120:	0f 8e 86 00 00 00    	jle    801021ac <namex+0x23c>
  releasesleep(&ip->lock);
80102126:	83 ec 0c             	sub    $0xc,%esp
80102129:	53                   	push   %ebx
8010212a:	e8 01 24 00 00       	call   80104530 <releasesleep>
  iput(ip);
8010212f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102132:	31 f6                	xor    %esi,%esi
  iput(ip);
80102134:	e8 57 f9 ff ff       	call   80101a90 <iput>
      return 0;
80102139:	83 c4 10             	add    $0x10,%esp
}
8010213c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213f:	89 f0                	mov    %esi,%eax
80102141:	5b                   	pop    %ebx
80102142:	5e                   	pop    %esi
80102143:	5f                   	pop    %edi
80102144:	5d                   	pop    %ebp
80102145:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102146:	83 ec 0c             	sub    $0xc,%esp
80102149:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010214c:	52                   	push   %edx
8010214d:	e8 1e 24 00 00       	call   80104570 <holdingsleep>
80102152:	83 c4 10             	add    $0x10,%esp
80102155:	85 c0                	test   %eax,%eax
80102157:	74 53                	je     801021ac <namex+0x23c>
80102159:	8b 4e 08             	mov    0x8(%esi),%ecx
8010215c:	85 c9                	test   %ecx,%ecx
8010215e:	7e 4c                	jle    801021ac <namex+0x23c>
  releasesleep(&ip->lock);
80102160:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102163:	83 ec 0c             	sub    $0xc,%esp
80102166:	52                   	push   %edx
80102167:	eb c1                	jmp    8010212a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102169:	83 ec 0c             	sub    $0xc,%esp
8010216c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010216f:	53                   	push   %ebx
80102170:	e8 fb 23 00 00       	call   80104570 <holdingsleep>
80102175:	83 c4 10             	add    $0x10,%esp
80102178:	85 c0                	test   %eax,%eax
8010217a:	74 30                	je     801021ac <namex+0x23c>
8010217c:	8b 7e 08             	mov    0x8(%esi),%edi
8010217f:	85 ff                	test   %edi,%edi
80102181:	7e 29                	jle    801021ac <namex+0x23c>
  releasesleep(&ip->lock);
80102183:	83 ec 0c             	sub    $0xc,%esp
80102186:	53                   	push   %ebx
80102187:	e8 a4 23 00 00       	call   80104530 <releasesleep>
}
8010218c:	83 c4 10             	add    $0x10,%esp
}
8010218f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102192:	89 f0                	mov    %esi,%eax
80102194:	5b                   	pop    %ebx
80102195:	5e                   	pop    %esi
80102196:	5f                   	pop    %edi
80102197:	5d                   	pop    %ebp
80102198:	c3                   	ret    
    iput(ip);
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	56                   	push   %esi
    return 0;
8010219d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010219f:	e8 ec f8 ff ff       	call   80101a90 <iput>
    return 0;
801021a4:	83 c4 10             	add    $0x10,%esp
801021a7:	e9 2f ff ff ff       	jmp    801020db <namex+0x16b>
    panic("iunlock");
801021ac:	83 ec 0c             	sub    $0xc,%esp
801021af:	68 df 74 10 80       	push   $0x801074df
801021b4:	e8 c7 e1 ff ff       	call   80100380 <panic>
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <dirlink>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	57                   	push   %edi
801021c4:	56                   	push   %esi
801021c5:	53                   	push   %ebx
801021c6:	83 ec 20             	sub    $0x20,%esp
801021c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021cc:	6a 00                	push   $0x0
801021ce:	ff 75 0c             	push   0xc(%ebp)
801021d1:	53                   	push   %ebx
801021d2:	e8 e9 fc ff ff       	call   80101ec0 <dirlookup>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	75 67                	jne    80102245 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021de:	8b 7b 58             	mov    0x58(%ebx),%edi
801021e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021e4:	85 ff                	test   %edi,%edi
801021e6:	74 29                	je     80102211 <dirlink+0x51>
801021e8:	31 ff                	xor    %edi,%edi
801021ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021ed:	eb 09                	jmp    801021f8 <dirlink+0x38>
801021ef:	90                   	nop
801021f0:	83 c7 10             	add    $0x10,%edi
801021f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021f6:	73 19                	jae    80102211 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f8:	6a 10                	push   $0x10
801021fa:	57                   	push   %edi
801021fb:	56                   	push   %esi
801021fc:	53                   	push   %ebx
801021fd:	e8 6e fa ff ff       	call   80101c70 <readi>
80102202:	83 c4 10             	add    $0x10,%esp
80102205:	83 f8 10             	cmp    $0x10,%eax
80102208:	75 4e                	jne    80102258 <dirlink+0x98>
    if(de.inum == 0)
8010220a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010220f:	75 df                	jne    801021f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102211:	83 ec 04             	sub    $0x4,%esp
80102214:	8d 45 da             	lea    -0x26(%ebp),%eax
80102217:	6a 0e                	push   $0xe
80102219:	ff 75 0c             	push   0xc(%ebp)
8010221c:	50                   	push   %eax
8010221d:	e8 8e 27 00 00       	call   801049b0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102222:	6a 10                	push   $0x10
  de.inum = inum;
80102224:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102227:	57                   	push   %edi
80102228:	56                   	push   %esi
80102229:	53                   	push   %ebx
  de.inum = inum;
8010222a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010222e:	e8 3d fb ff ff       	call   80101d70 <writei>
80102233:	83 c4 20             	add    $0x20,%esp
80102236:	83 f8 10             	cmp    $0x10,%eax
80102239:	75 2a                	jne    80102265 <dirlink+0xa5>
  return 0;
8010223b:	31 c0                	xor    %eax,%eax
}
8010223d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102240:	5b                   	pop    %ebx
80102241:	5e                   	pop    %esi
80102242:	5f                   	pop    %edi
80102243:	5d                   	pop    %ebp
80102244:	c3                   	ret    
    iput(ip);
80102245:	83 ec 0c             	sub    $0xc,%esp
80102248:	50                   	push   %eax
80102249:	e8 42 f8 ff ff       	call   80101a90 <iput>
    return -1;
8010224e:	83 c4 10             	add    $0x10,%esp
80102251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102256:	eb e5                	jmp    8010223d <dirlink+0x7d>
      panic("dirlink read");
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	68 08 75 10 80       	push   $0x80107508
80102260:	e8 1b e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102265:	83 ec 0c             	sub    $0xc,%esp
80102268:	68 de 7a 10 80       	push   $0x80107ade
8010226d:	e8 0e e1 ff ff       	call   80100380 <panic>
80102272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102280 <namei>:

struct inode*
namei(char *path)
{
80102280:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102281:	31 d2                	xor    %edx,%edx
{
80102283:	89 e5                	mov    %esp,%ebp
80102285:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102288:	8b 45 08             	mov    0x8(%ebp),%eax
8010228b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010228e:	e8 dd fc ff ff       	call   80101f70 <namex>
}
80102293:	c9                   	leave  
80102294:	c3                   	ret    
80102295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022a0:	55                   	push   %ebp
  return namex(path, 1, name);
801022a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022af:	e9 bc fc ff ff       	jmp    80101f70 <namex>
801022b4:	66 90                	xchg   %ax,%ax
801022b6:	66 90                	xchg   %ax,%ax
801022b8:	66 90                	xchg   %ax,%ax
801022ba:	66 90                	xchg   %ax,%ax
801022bc:	66 90                	xchg   %ax,%ax
801022be:	66 90                	xchg   %ax,%ax

801022c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022c9:	85 c0                	test   %eax,%eax
801022cb:	0f 84 b4 00 00 00    	je     80102385 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022d1:	8b 70 08             	mov    0x8(%eax),%esi
801022d4:	89 c3                	mov    %eax,%ebx
801022d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801022dc:	0f 87 96 00 00 00    	ja     80102378 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ee:	66 90                	xchg   %ax,%ax
801022f0:	89 ca                	mov    %ecx,%edx
801022f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f3:	83 e0 c0             	and    $0xffffffc0,%eax
801022f6:	3c 40                	cmp    $0x40,%al
801022f8:	75 f6                	jne    801022f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022fa:	31 ff                	xor    %edi,%edi
801022fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102301:	89 f8                	mov    %edi,%eax
80102303:	ee                   	out    %al,(%dx)
80102304:	b8 01 00 00 00       	mov    $0x1,%eax
80102309:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010230e:	ee                   	out    %al,(%dx)
8010230f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102314:	89 f0                	mov    %esi,%eax
80102316:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102317:	89 f0                	mov    %esi,%eax
80102319:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010231e:	c1 f8 08             	sar    $0x8,%eax
80102321:	ee                   	out    %al,(%dx)
80102322:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102327:	89 f8                	mov    %edi,%eax
80102329:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010232a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010232e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102333:	c1 e0 04             	shl    $0x4,%eax
80102336:	83 e0 10             	and    $0x10,%eax
80102339:	83 c8 e0             	or     $0xffffffe0,%eax
8010233c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010233d:	f6 03 04             	testb  $0x4,(%ebx)
80102340:	75 16                	jne    80102358 <idestart+0x98>
80102342:	b8 20 00 00 00       	mov    $0x20,%eax
80102347:	89 ca                	mov    %ecx,%edx
80102349:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010234a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010234d:	5b                   	pop    %ebx
8010234e:	5e                   	pop    %esi
8010234f:	5f                   	pop    %edi
80102350:	5d                   	pop    %ebp
80102351:	c3                   	ret    
80102352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102358:	b8 30 00 00 00       	mov    $0x30,%eax
8010235d:	89 ca                	mov    %ecx,%edx
8010235f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102360:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102365:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102368:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010236d:	fc                   	cld    
8010236e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102373:	5b                   	pop    %ebx
80102374:	5e                   	pop    %esi
80102375:	5f                   	pop    %edi
80102376:	5d                   	pop    %ebp
80102377:	c3                   	ret    
    panic("incorrect blockno");
80102378:	83 ec 0c             	sub    $0xc,%esp
8010237b:	68 74 75 10 80       	push   $0x80107574
80102380:	e8 fb df ff ff       	call   80100380 <panic>
    panic("idestart");
80102385:	83 ec 0c             	sub    $0xc,%esp
80102388:	68 6b 75 10 80       	push   $0x8010756b
8010238d:	e8 ee df ff ff       	call   80100380 <panic>
80102392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801023a0 <ideinit>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023a6:	68 86 75 10 80       	push   $0x80107586
801023ab:	68 00 16 11 80       	push   $0x80111600
801023b0:	e8 0b 22 00 00       	call   801045c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023b5:	58                   	pop    %eax
801023b6:	a1 84 17 11 80       	mov    0x80111784,%eax
801023bb:	5a                   	pop    %edx
801023bc:	83 e8 01             	sub    $0x1,%eax
801023bf:	50                   	push   %eax
801023c0:	6a 0e                	push   $0xe
801023c2:	e8 99 02 00 00       	call   80102660 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023cf:	90                   	nop
801023d0:	ec                   	in     (%dx),%al
801023d1:	83 e0 c0             	and    $0xffffffc0,%eax
801023d4:	3c 40                	cmp    $0x40,%al
801023d6:	75 f8                	jne    801023d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023e2:	ee                   	out    %al,(%dx)
801023e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ed:	eb 06                	jmp    801023f5 <ideinit+0x55>
801023ef:	90                   	nop
  for(i=0; i<1000; i++){
801023f0:	83 e9 01             	sub    $0x1,%ecx
801023f3:	74 0f                	je     80102404 <ideinit+0x64>
801023f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023f6:	84 c0                	test   %al,%al
801023f8:	74 f6                	je     801023f0 <ideinit+0x50>
      havedisk1 = 1;
801023fa:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102401:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102404:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102409:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010240e:	ee                   	out    %al,(%dx)
}
8010240f:	c9                   	leave  
80102410:	c3                   	ret    
80102411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010241f:	90                   	nop

80102420 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	57                   	push   %edi
80102424:	56                   	push   %esi
80102425:	53                   	push   %ebx
80102426:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102429:	68 00 16 11 80       	push   $0x80111600
8010242e:	e8 5d 23 00 00       	call   80104790 <acquire>

  if((b = idequeue) == 0){
80102433:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	85 db                	test   %ebx,%ebx
8010243e:	74 63                	je     801024a3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102440:	8b 43 58             	mov    0x58(%ebx),%eax
80102443:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102448:	8b 33                	mov    (%ebx),%esi
8010244a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102450:	75 2f                	jne    80102481 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102452:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010245e:	66 90                	xchg   %ax,%ax
80102460:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102461:	89 c1                	mov    %eax,%ecx
80102463:	83 e1 c0             	and    $0xffffffc0,%ecx
80102466:	80 f9 40             	cmp    $0x40,%cl
80102469:	75 f5                	jne    80102460 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010246b:	a8 21                	test   $0x21,%al
8010246d:	75 12                	jne    80102481 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010246f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102472:	b9 80 00 00 00       	mov    $0x80,%ecx
80102477:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010247c:	fc                   	cld    
8010247d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010247f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102481:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102484:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102487:	83 ce 02             	or     $0x2,%esi
8010248a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010248c:	53                   	push   %ebx
8010248d:	e8 5e 1e 00 00       	call   801042f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102492:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102497:	83 c4 10             	add    $0x10,%esp
8010249a:	85 c0                	test   %eax,%eax
8010249c:	74 05                	je     801024a3 <ideintr+0x83>
    idestart(idequeue);
8010249e:	e8 1d fe ff ff       	call   801022c0 <idestart>
    release(&idelock);
801024a3:	83 ec 0c             	sub    $0xc,%esp
801024a6:	68 00 16 11 80       	push   $0x80111600
801024ab:	e8 80 22 00 00       	call   80104730 <release>

  release(&idelock);
}
801024b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b3:	5b                   	pop    %ebx
801024b4:	5e                   	pop    %esi
801024b5:	5f                   	pop    %edi
801024b6:	5d                   	pop    %ebp
801024b7:	c3                   	ret    
801024b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024bf:	90                   	nop

801024c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 10             	sub    $0x10,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801024cd:	50                   	push   %eax
801024ce:	e8 9d 20 00 00       	call   80104570 <holdingsleep>
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	85 c0                	test   %eax,%eax
801024d8:	0f 84 c3 00 00 00    	je     801025a1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 e0 06             	and    $0x6,%eax
801024e3:	83 f8 02             	cmp    $0x2,%eax
801024e6:	0f 84 a8 00 00 00    	je     80102594 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024ec:	8b 53 04             	mov    0x4(%ebx),%edx
801024ef:	85 d2                	test   %edx,%edx
801024f1:	74 0d                	je     80102500 <iderw+0x40>
801024f3:	a1 e0 15 11 80       	mov    0x801115e0,%eax
801024f8:	85 c0                	test   %eax,%eax
801024fa:	0f 84 87 00 00 00    	je     80102587 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 00 16 11 80       	push   $0x80111600
80102508:	e8 83 22 00 00       	call   80104790 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102512:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102519:	83 c4 10             	add    $0x10,%esp
8010251c:	85 c0                	test   %eax,%eax
8010251e:	74 60                	je     80102580 <iderw+0xc0>
80102520:	89 c2                	mov    %eax,%edx
80102522:	8b 40 58             	mov    0x58(%eax),%eax
80102525:	85 c0                	test   %eax,%eax
80102527:	75 f7                	jne    80102520 <iderw+0x60>
80102529:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010252c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010252e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102534:	74 3a                	je     80102570 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102536:	8b 03                	mov    (%ebx),%eax
80102538:	83 e0 06             	and    $0x6,%eax
8010253b:	83 f8 02             	cmp    $0x2,%eax
8010253e:	74 1b                	je     8010255b <iderw+0x9b>
    sleep(b, &idelock);
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	68 00 16 11 80       	push   $0x80111600
80102548:	53                   	push   %ebx
80102549:	e8 e2 1c 00 00       	call   80104230 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010254e:	8b 03                	mov    (%ebx),%eax
80102550:	83 c4 10             	add    $0x10,%esp
80102553:	83 e0 06             	and    $0x6,%eax
80102556:	83 f8 02             	cmp    $0x2,%eax
80102559:	75 e5                	jne    80102540 <iderw+0x80>
  }


  release(&idelock);
8010255b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102562:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102565:	c9                   	leave  
  release(&idelock);
80102566:	e9 c5 21 00 00       	jmp    80104730 <release>
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop
    idestart(b);
80102570:	89 d8                	mov    %ebx,%eax
80102572:	e8 49 fd ff ff       	call   801022c0 <idestart>
80102577:	eb bd                	jmp    80102536 <iderw+0x76>
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102580:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102585:	eb a5                	jmp    8010252c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	68 b5 75 10 80       	push   $0x801075b5
8010258f:	e8 ec dd ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102594:	83 ec 0c             	sub    $0xc,%esp
80102597:	68 a0 75 10 80       	push   $0x801075a0
8010259c:	e8 df dd ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801025a1:	83 ec 0c             	sub    $0xc,%esp
801025a4:	68 8a 75 10 80       	push   $0x8010758a
801025a9:	e8 d2 dd ff ff       	call   80100380 <panic>
801025ae:	66 90                	xchg   %ax,%ax

801025b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025b0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025b1:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801025b8:	00 c0 fe 
{
801025bb:	89 e5                	mov    %esp,%ebp
801025bd:	56                   	push   %esi
801025be:	53                   	push   %ebx
  ioapic->reg = reg;
801025bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025c6:	00 00 00 
  return ioapic->data;
801025c9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801025cf:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801025d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801025d8:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025de:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025e5:	c1 ee 10             	shr    $0x10,%esi
801025e8:	89 f0                	mov    %esi,%eax
801025ea:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801025ed:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801025f0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801025f3:	39 c2                	cmp    %eax,%edx
801025f5:	74 16                	je     8010260d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801025f7:	83 ec 0c             	sub    $0xc,%esp
801025fa:	68 d4 75 10 80       	push   $0x801075d4
801025ff:	e8 7c e0 ff ff       	call   80100680 <cprintf>
  ioapic->reg = reg;
80102604:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
8010260a:	83 c4 10             	add    $0x10,%esp
8010260d:	83 c6 21             	add    $0x21,%esi
{
80102610:	ba 10 00 00 00       	mov    $0x10,%edx
80102615:	b8 20 00 00 00       	mov    $0x20,%eax
8010261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102620:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102622:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102624:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  for(i = 0; i <= maxintr; i++){
8010262a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010262d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102633:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102636:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102639:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010263c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010263e:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80102644:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010264b:	39 f0                	cmp    %esi,%eax
8010264d:	75 d1                	jne    80102620 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010264f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102652:	5b                   	pop    %ebx
80102653:	5e                   	pop    %esi
80102654:	5d                   	pop    %ebp
80102655:	c3                   	ret    
80102656:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010265d:	8d 76 00             	lea    0x0(%esi),%esi

80102660 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102660:	55                   	push   %ebp
  ioapic->reg = reg;
80102661:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102667:	89 e5                	mov    %esp,%ebp
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010266c:	8d 50 20             	lea    0x20(%eax),%edx
8010266f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102673:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102675:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010267b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010267e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102681:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102684:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102686:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010268e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	66 90                	xchg   %ax,%ax
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	53                   	push   %ebx
801026a4:	83 ec 04             	sub    $0x4,%esp
801026a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026b0:	75 76                	jne    80102728 <kfree+0x88>
801026b2:	81 fb d0 54 11 80    	cmp    $0x801154d0,%ebx
801026b8:	72 6e                	jb     80102728 <kfree+0x88>
801026ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026c5:	77 61                	ja     80102728 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026c7:	83 ec 04             	sub    $0x4,%esp
801026ca:	68 00 10 00 00       	push   $0x1000
801026cf:	6a 01                	push   $0x1
801026d1:	53                   	push   %ebx
801026d2:	e8 79 21 00 00       	call   80104850 <memset>

  if(kmem.use_lock)
801026d7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	85 d2                	test   %edx,%edx
801026e2:	75 1c                	jne    80102700 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026e4:	a1 78 16 11 80       	mov    0x80111678,%eax
801026e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026eb:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
801026f0:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
801026f6:	85 c0                	test   %eax,%eax
801026f8:	75 1e                	jne    80102718 <kfree+0x78>
    release(&kmem.lock);
}
801026fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026fd:	c9                   	leave  
801026fe:	c3                   	ret    
801026ff:	90                   	nop
    acquire(&kmem.lock);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 40 16 11 80       	push   $0x80111640
80102708:	e8 83 20 00 00       	call   80104790 <acquire>
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	eb d2                	jmp    801026e4 <kfree+0x44>
80102712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102718:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010271f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102722:	c9                   	leave  
    release(&kmem.lock);
80102723:	e9 08 20 00 00       	jmp    80104730 <release>
    panic("kfree");
80102728:	83 ec 0c             	sub    $0xc,%esp
8010272b:	68 06 76 10 80       	push   $0x80107606
80102730:	e8 4b dc ff ff       	call   80100380 <panic>
80102735:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102740 <freerange>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102744:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102747:	8b 75 0c             	mov    0xc(%ebp),%esi
8010274a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010274b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102751:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275d:	39 de                	cmp    %ebx,%esi
8010275f:	72 23                	jb     80102784 <freerange+0x44>
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102768:	83 ec 0c             	sub    $0xc,%esp
8010276b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 23 ff ff ff       	call   801026a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 f3                	cmp    %esi,%ebx
80102782:	76 e4                	jbe    80102768 <freerange+0x28>
}
80102784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102787:	5b                   	pop    %ebx
80102788:	5e                   	pop    %esi
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop

80102790 <kinit2>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102794:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102797:	8b 75 0c             	mov    0xc(%ebp),%esi
8010279a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010279b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ad:	39 de                	cmp    %ebx,%esi
801027af:	72 23                	jb     801027d4 <kinit2+0x44>
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027c7:	50                   	push   %eax
801027c8:	e8 d3 fe ff ff       	call   801026a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	39 de                	cmp    %ebx,%esi
801027d2:	73 e4                	jae    801027b8 <kinit2+0x28>
  kmem.use_lock = 1;
801027d4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801027db:	00 00 00 
}
801027de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e1:	5b                   	pop    %ebx
801027e2:	5e                   	pop    %esi
801027e3:	5d                   	pop    %ebp
801027e4:	c3                   	ret    
801027e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <kinit1>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx
801027f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027f8:	83 ec 08             	sub    $0x8,%esp
801027fb:	68 0c 76 10 80       	push   $0x8010760c
80102800:	68 40 16 11 80       	push   $0x80111640
80102805:	e8 b6 1d 00 00       	call   801045c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010280a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010280d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102810:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102817:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010281a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102820:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102826:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010282c:	39 de                	cmp    %ebx,%esi
8010282e:	72 1c                	jb     8010284c <kinit1+0x5c>
    kfree(p);
80102830:	83 ec 0c             	sub    $0xc,%esp
80102833:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102839:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010283f:	50                   	push   %eax
80102840:	e8 5b fe ff ff       	call   801026a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102845:	83 c4 10             	add    $0x10,%esp
80102848:	39 de                	cmp    %ebx,%esi
8010284a:	73 e4                	jae    80102830 <kinit1+0x40>
}
8010284c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010284f:	5b                   	pop    %ebx
80102850:	5e                   	pop    %esi
80102851:	5d                   	pop    %ebp
80102852:	c3                   	ret    
80102853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102860 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102860:	a1 74 16 11 80       	mov    0x80111674,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	75 1f                	jne    80102888 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102869:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(r)
8010286e:	85 c0                	test   %eax,%eax
80102870:	74 0e                	je     80102880 <kalloc+0x20>
    kmem.freelist = r->next;
80102872:	8b 10                	mov    (%eax),%edx
80102874:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
8010287a:	c3                   	ret    
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102880:	c3                   	ret    
80102881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102888:	55                   	push   %ebp
80102889:	89 e5                	mov    %esp,%ebp
8010288b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010288e:	68 40 16 11 80       	push   $0x80111640
80102893:	e8 f8 1e 00 00       	call   80104790 <acquire>
  r = kmem.freelist;
80102898:	a1 78 16 11 80       	mov    0x80111678,%eax
  if(kmem.use_lock)
8010289d:	8b 15 74 16 11 80    	mov    0x80111674,%edx
  if(r)
801028a3:	83 c4 10             	add    $0x10,%esp
801028a6:	85 c0                	test   %eax,%eax
801028a8:	74 08                	je     801028b2 <kalloc+0x52>
    kmem.freelist = r->next;
801028aa:	8b 08                	mov    (%eax),%ecx
801028ac:	89 0d 78 16 11 80    	mov    %ecx,0x80111678
  if(kmem.use_lock)
801028b2:	85 d2                	test   %edx,%edx
801028b4:	74 16                	je     801028cc <kalloc+0x6c>
    release(&kmem.lock);
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bc:	68 40 16 11 80       	push   $0x80111640
801028c1:	e8 6a 1e 00 00       	call   80104730 <release>
  return (char*)r;
801028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028c9:	83 c4 10             	add    $0x10,%esp
}
801028cc:	c9                   	leave  
801028cd:	c3                   	ret    
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	ba 64 00 00 00       	mov    $0x64,%edx
801028d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028d6:	a8 01                	test   $0x1,%al
801028d8:	0f 84 ca 00 00 00    	je     801029a8 <kbdgetc+0xd8>
{
801028de:	55                   	push   %ebp
801028df:	ba 60 00 00 00       	mov    $0x60,%edx
801028e4:	89 e5                	mov    %esp,%ebp
801028e6:	53                   	push   %ebx
801028e7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801028e8:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
801028ee:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801028f1:	3c e0                	cmp    $0xe0,%al
801028f3:	74 5b                	je     80102950 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801028f5:	89 da                	mov    %ebx,%edx
801028f7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801028fa:	84 c0                	test   %al,%al
801028fc:	78 62                	js     80102960 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028fe:	85 d2                	test   %edx,%edx
80102900:	74 09                	je     8010290b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102902:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102905:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102908:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010290b:	0f b6 91 40 77 10 80 	movzbl -0x7fef88c0(%ecx),%edx
  shift ^= togglecode[data];
80102912:	0f b6 81 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%eax
  shift |= shiftcode[data];
80102919:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010291b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010291d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010291f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102925:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102928:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010292b:	8b 04 85 20 76 10 80 	mov    -0x7fef89e0(,%eax,4),%eax
80102932:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102936:	74 0b                	je     80102943 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102938:	8d 50 9f             	lea    -0x61(%eax),%edx
8010293b:	83 fa 19             	cmp    $0x19,%edx
8010293e:	77 50                	ja     80102990 <kbdgetc+0xc0>
      c += 'A' - 'a';
80102940:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102943:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102946:	c9                   	leave  
80102947:	c3                   	ret    
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop
    shift |= E0ESC;
80102950:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102953:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102955:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010295b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010295e:	c9                   	leave  
8010295f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102960:	83 e0 7f             	and    $0x7f,%eax
80102963:	85 d2                	test   %edx,%edx
80102965:	0f 44 c8             	cmove  %eax,%ecx
    return 0;
80102968:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010296a:	0f b6 91 40 77 10 80 	movzbl -0x7fef88c0(%ecx),%edx
80102971:	83 ca 40             	or     $0x40,%edx
80102974:	0f b6 d2             	movzbl %dl,%edx
80102977:	f7 d2                	not    %edx
80102979:	21 da                	and    %ebx,%edx
}
8010297b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010297e:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
}
80102984:	c9                   	leave  
80102985:	c3                   	ret    
80102986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298d:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102990:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102993:	8d 50 20             	lea    0x20(%eax),%edx
}
80102996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102999:	c9                   	leave  
      c += 'a' - 'A';
8010299a:	83 f9 1a             	cmp    $0x1a,%ecx
8010299d:	0f 42 c2             	cmovb  %edx,%eax
}
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801029a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029ad:	c3                   	ret    
801029ae:	66 90                	xchg   %ax,%ax

801029b0 <kbdintr>:

void
kbdintr(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029b6:	68 d0 28 10 80       	push   $0x801028d0
801029bb:	e8 30 df ff ff       	call   801008f0 <consoleintr>
}
801029c0:	83 c4 10             	add    $0x10,%esp
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    
801029c5:	66 90                	xchg   %ax,%ax
801029c7:	66 90                	xchg   %ax,%ax
801029c9:	66 90                	xchg   %ax,%ax
801029cb:	66 90                	xchg   %ax,%ax
801029cd:	66 90                	xchg   %ax,%ax
801029cf:	90                   	nop

801029d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029d0:	a1 80 16 11 80       	mov    0x80111680,%eax
801029d5:	85 c0                	test   %eax,%eax
801029d7:	0f 84 cb 00 00 00    	je     80102aa8 <lapicinit+0xd8>
  lapic[index] = value;
801029dd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029e4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ea:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029f1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801029fe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a01:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a04:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a0b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a18:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a25:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a28:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a2b:	8b 50 30             	mov    0x30(%eax),%edx
80102a2e:	c1 ea 10             	shr    $0x10,%edx
80102a31:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102a37:	75 77                	jne    80102ab0 <lapicinit+0xe0>
  lapic[index] = value;
80102a39:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a46:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a60:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a81:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx
80102a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a96:	80 e6 10             	and    $0x10,%dh
80102a99:	75 f5                	jne    80102a90 <lapicinit+0xc0>
  lapic[index] = value;
80102a9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102aa2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102aa8:	c3                   	ret    
80102aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102ab0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ab7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aba:	8b 50 20             	mov    0x20(%eax),%edx
}
80102abd:	e9 77 ff ff ff       	jmp    80102a39 <lapicinit+0x69>
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102ad0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ad0:	a1 80 16 11 80       	mov    0x80111680,%eax
80102ad5:	85 c0                	test   %eax,%eax
80102ad7:	74 07                	je     80102ae0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102ad9:	8b 40 20             	mov    0x20(%eax),%eax
80102adc:	c1 e8 18             	shr    $0x18,%eax
80102adf:	c3                   	ret    
    return 0;
80102ae0:	31 c0                	xor    %eax,%eax
}
80102ae2:	c3                   	ret    
80102ae3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102af0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102af0:	a1 80 16 11 80       	mov    0x80111680,%eax
80102af5:	85 c0                	test   %eax,%eax
80102af7:	74 0d                	je     80102b06 <lapiceoi+0x16>
  lapic[index] = value;
80102af9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b06:	c3                   	ret    
80102b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b0e:	66 90                	xchg   %ax,%ax

80102b10 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102b10:	c3                   	ret    
80102b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1f:	90                   	nop

80102b20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	53                   	push   %ebx
80102b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b34:	ee                   	out    %al,(%dx)
80102b35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b40:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b4d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102b50:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102b52:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b5e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102b63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bad:	c9                   	leave  
80102bae:	c3                   	ret    
80102baf:	90                   	nop

80102bb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102bb0:	55                   	push   %ebp
80102bb1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bb6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bbb:	89 e5                	mov    %esp,%ebp
80102bbd:	57                   	push   %edi
80102bbe:	56                   	push   %esi
80102bbf:	53                   	push   %ebx
80102bc0:	83 ec 4c             	sub    $0x4c,%esp
80102bc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102bca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bd2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
80102bd8:	31 c0                	xor    %eax,%eax
80102bda:	89 da                	mov    %ebx,%edx
80102bdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102be2:	89 ca                	mov    %ecx,%edx
80102be4:	ec                   	in     (%dx),%al
80102be5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be8:	89 da                	mov    %ebx,%edx
80102bea:	b8 02 00 00 00       	mov    $0x2,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 da                	mov    %ebx,%edx
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
80102c0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 da                	mov    %ebx,%edx
80102c14:	b8 08 00 00 00       	mov    $0x8,%eax
80102c19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1a:	89 ca                	mov    %ecx,%edx
80102c1c:	ec                   	in     (%dx),%al
80102c1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1f:	89 da                	mov    %ebx,%edx
80102c21:	b8 09 00 00 00       	mov    $0x9,%eax
80102c26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	89 ca                	mov    %ecx,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2c:	89 da                	mov    %ebx,%edx
80102c2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c34:	89 ca                	mov    %ecx,%edx
80102c36:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c37:	84 c0                	test   %al,%al
80102c39:	78 9d                	js     80102bd8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c3f:	89 fa                	mov    %edi,%edx
80102c41:	0f b6 fa             	movzbl %dl,%edi
80102c44:	89 f2                	mov    %esi,%edx
80102c46:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c49:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c4d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c50:	89 da                	mov    %ebx,%edx
80102c52:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102c55:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c58:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c5c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c69:	31 c0                	xor    %eax,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c77:	b8 02 00 00 00       	mov    $0x2,%eax
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
80102c80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c83:	89 da                	mov    %ebx,%edx
80102c85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c88:	b8 04 00 00 00       	mov    $0x4,%eax
80102c8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8e:	89 ca                	mov    %ecx,%edx
80102c90:	ec                   	in     (%dx),%al
80102c91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c94:	89 da                	mov    %ebx,%edx
80102c96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c99:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9f:	89 ca                	mov    %ecx,%edx
80102ca1:	ec                   	in     (%dx),%al
80102ca2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	89 da                	mov    %ebx,%edx
80102ca7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102caa:	b8 08 00 00 00       	mov    $0x8,%eax
80102caf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
80102cb3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 da                	mov    %ebx,%edx
80102cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cbb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc1:	89 ca                	mov    %ecx,%edx
80102cc3:	ec                   	in     (%dx),%al
80102cc4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ccd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cd0:	6a 18                	push   $0x18
80102cd2:	50                   	push   %eax
80102cd3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cd6:	50                   	push   %eax
80102cd7:	e8 c4 1b 00 00       	call   801048a0 <memcmp>
80102cdc:	83 c4 10             	add    $0x10,%esp
80102cdf:	85 c0                	test   %eax,%eax
80102ce1:	0f 85 f1 fe ff ff    	jne    80102bd8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ce7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ceb:	75 78                	jne    80102d65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ced:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cf0:	89 c2                	mov    %eax,%edx
80102cf2:	83 e0 0f             	and    $0xf,%eax
80102cf5:	c1 ea 04             	shr    $0x4,%edx
80102cf8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d04:	89 c2                	mov    %eax,%edx
80102d06:	83 e0 0f             	and    $0xf,%eax
80102d09:	c1 ea 04             	shr    $0x4,%edx
80102d0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d18:	89 c2                	mov    %eax,%edx
80102d1a:	83 e0 0f             	and    $0xf,%eax
80102d1d:	c1 ea 04             	shr    $0x4,%edx
80102d20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d2c:	89 c2                	mov    %eax,%edx
80102d2e:	83 e0 0f             	and    $0xf,%eax
80102d31:	c1 ea 04             	shr    $0x4,%edx
80102d34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d40:	89 c2                	mov    %eax,%edx
80102d42:	83 e0 0f             	and    $0xf,%eax
80102d45:	c1 ea 04             	shr    $0x4,%edx
80102d48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	83 e0 0f             	and    $0xf,%eax
80102d59:	c1 ea 04             	shr    $0x4,%edx
80102d5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d65:	8b 75 08             	mov    0x8(%ebp),%esi
80102d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d6b:	89 06                	mov    %eax,(%esi)
80102d6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d70:	89 46 04             	mov    %eax,0x4(%esi)
80102d73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d76:	89 46 08             	mov    %eax,0x8(%esi)
80102d79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d82:	89 46 10             	mov    %eax,0x10(%esi)
80102d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d95:	5b                   	pop    %ebx
80102d96:	5e                   	pop    %esi
80102d97:	5f                   	pop    %edi
80102d98:	5d                   	pop    %ebp
80102d99:	c3                   	ret    
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102da6:	85 c9                	test   %ecx,%ecx
80102da8:	0f 8e 8a 00 00 00    	jle    80102e38 <install_trans+0x98>
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102db2:	31 ff                	xor    %edi,%edi
{
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dc0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 f8                	add    %edi,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 e4 16 11 80    	push   0x801116e4
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102de4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102df5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 e7 1a 00 00       	call   801048f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e09:	89 1c 24             	mov    %ebx,(%esp)
80102e0c:	e8 9f d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102e11:	89 34 24             	mov    %esi,(%esp)
80102e14:	e8 d7 d3 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102e19:	89 1c 24             	mov    %ebx,(%esp)
80102e1c:	e8 cf d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102e2a:	7f 94                	jg     80102dc0 <install_trans+0x20>
  }
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e38:	c3                   	ret    
80102e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e47:	ff 35 d4 16 11 80    	push   0x801116d4
80102e4d:	ff 35 e4 16 11 80    	push   0x801116e4
80102e53:	e8 78 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e58:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102e5e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e61:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102e63:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e66:	85 c9                	test   %ecx,%ecx
80102e68:	7e 18                	jle    80102e82 <write_head+0x42>
80102e6a:	31 c0                	xor    %eax,%eax
80102e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102e70:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
80102e77:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102e7b:	83 c0 01             	add    $0x1,%eax
80102e7e:	39 c1                	cmp    %eax,%ecx
80102e80:	75 ee                	jne    80102e70 <write_head+0x30>
  }
  bwrite(buf);
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	53                   	push   %ebx
80102e86:	e8 25 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e8b:	89 1c 24             	mov    %ebx,(%esp)
80102e8e:	e8 5d d3 ff ff       	call   801001f0 <brelse>
}
80102e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e96:	83 c4 10             	add    $0x10,%esp
80102e99:	c9                   	leave  
80102e9a:	c3                   	ret    
80102e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e9f:	90                   	nop

80102ea0 <initlog>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 2c             	sub    $0x2c,%esp
80102ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eaa:	68 40 78 10 80       	push   $0x80107840
80102eaf:	68 a0 16 11 80       	push   $0x801116a0
80102eb4:	e8 07 17 00 00       	call   801045c0 <initlock>
  readsb(dev, &sb);
80102eb9:	58                   	pop    %eax
80102eba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 3b e8 ff ff       	call   80101700 <readsb>
  log.start = sb.logstart;
80102ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ec8:	59                   	pop    %ecx
  log.dev = dev;
80102ec9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102ecf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ed2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102ed7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 eb d1 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ee5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ee8:	8b 58 5c             	mov    0x5c(%eax),%ebx
  struct buf *buf = bread(log.dev, log.start);
80102eeb:	89 c1                	mov    %eax,%ecx
  log.lh.n = lh->n;
80102eed:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	85 db                	test   %ebx,%ebx
80102ef5:	7e 1b                	jle    80102f12 <initlog+0x72>
80102ef7:	31 c0                	xor    %eax,%eax
80102ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102f00:	8b 54 81 60          	mov    0x60(%ecx,%eax,4),%edx
80102f04:	89 14 85 ec 16 11 80 	mov    %edx,-0x7feee914(,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102f0b:	83 c0 01             	add    $0x1,%eax
80102f0e:	39 c3                	cmp    %eax,%ebx
80102f10:	75 ee                	jne    80102f00 <initlog+0x60>
  brelse(buf);
80102f12:	83 ec 0c             	sub    $0xc,%esp
80102f15:	51                   	push   %ecx
80102f16:	e8 d5 d2 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f1b:	e8 80 fe ff ff       	call   80102da0 <install_trans>
  log.lh.n = 0;
80102f20:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102f27:	00 00 00 
  write_head(); // clear the log
80102f2a:	e8 11 ff ff ff       	call   80102e40 <write_head>
}
80102f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f32:	83 c4 10             	add    $0x10,%esp
80102f35:	c9                   	leave  
80102f36:	c3                   	ret    
80102f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3e:	66 90                	xchg   %ax,%ax

80102f40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f46:	68 a0 16 11 80       	push   $0x801116a0
80102f4b:	e8 40 18 00 00       	call   80104790 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 a0 16 11 80       	push   $0x801116a0
80102f60:	68 a0 16 11 80       	push   $0x801116a0
80102f65:	e8 c6 12 00 00       	call   80104230 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f6d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f81:	83 c0 01             	add    $0x1,%eax
80102f84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f8a:	83 fa 1e             	cmp    $0x1e,%edx
80102f8d:	7f c9                	jg     80102f58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f92:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102f97:	68 a0 16 11 80       	push   $0x801116a0
80102f9c:	e8 8f 17 00 00       	call   80104730 <release>
      break;
    }
  }
}
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	c9                   	leave  
80102fa5:	c3                   	ret    
80102fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fad:	8d 76 00             	lea    0x0(%esi),%esi

80102fb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fb9:	68 a0 16 11 80       	push   $0x801116a0
80102fbe:	e8 cd 17 00 00       	call   80104790 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102fc8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102fce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102fd4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102fda:	85 f6                	test   %esi,%esi
80102fdc:	0f 85 22 01 00 00    	jne    80103104 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102fe2:	85 db                	test   %ebx,%ebx
80102fe4:	0f 85 f6 00 00 00    	jne    801030e0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102fea:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102ff1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ff4:	83 ec 0c             	sub    $0xc,%esp
80102ff7:	68 a0 16 11 80       	push   $0x801116a0
80102ffc:	e8 2f 17 00 00       	call   80104730 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103001:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80103007:	83 c4 10             	add    $0x10,%esp
8010300a:	85 c9                	test   %ecx,%ecx
8010300c:	7f 42                	jg     80103050 <end_op+0xa0>
    acquire(&log.lock);
8010300e:	83 ec 0c             	sub    $0xc,%esp
80103011:	68 a0 16 11 80       	push   $0x801116a0
80103016:	e8 75 17 00 00       	call   80104790 <acquire>
    wakeup(&log);
8010301b:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
    log.committing = 0;
80103022:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80103029:	00 00 00 
    wakeup(&log);
8010302c:	e8 bf 12 00 00       	call   801042f0 <wakeup>
    release(&log.lock);
80103031:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80103038:	e8 f3 16 00 00       	call   80104730 <release>
8010303d:	83 c4 10             	add    $0x10,%esp
}
80103040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103043:	5b                   	pop    %ebx
80103044:	5e                   	pop    %esi
80103045:	5f                   	pop    %edi
80103046:	5d                   	pop    %ebp
80103047:	c3                   	ret    
80103048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103050:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80103055:	83 ec 08             	sub    $0x8,%esp
80103058:	01 d8                	add    %ebx,%eax
8010305a:	83 c0 01             	add    $0x1,%eax
8010305d:	50                   	push   %eax
8010305e:	ff 35 e4 16 11 80    	push   0x801116e4
80103064:	e8 67 d0 ff ff       	call   801000d0 <bread>
80103069:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010306b:	58                   	pop    %eax
8010306c:	5a                   	pop    %edx
8010306d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80103074:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010307a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010307d:	e8 4e d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103082:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103085:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103087:	8d 40 5c             	lea    0x5c(%eax),%eax
8010308a:	68 00 02 00 00       	push   $0x200
8010308f:	50                   	push   %eax
80103090:	8d 46 5c             	lea    0x5c(%esi),%eax
80103093:	50                   	push   %eax
80103094:	e8 57 18 00 00       	call   801048f0 <memmove>
    bwrite(to);  // write the log
80103099:	89 34 24             	mov    %esi,(%esp)
8010309c:	e8 0f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
801030a1:	89 3c 24             	mov    %edi,(%esp)
801030a4:	e8 47 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 3f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b1:	83 c4 10             	add    $0x10,%esp
801030b4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
801030ba:	7c 94                	jl     80103050 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030bc:	e8 7f fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
801030c1:	e8 da fc ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
801030c6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
801030cd:	00 00 00 
    write_head();    // Erase the transaction from the log
801030d0:	e8 6b fd ff ff       	call   80102e40 <write_head>
801030d5:	e9 34 ff ff ff       	jmp    8010300e <end_op+0x5e>
801030da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801030e0:	83 ec 0c             	sub    $0xc,%esp
801030e3:	68 a0 16 11 80       	push   $0x801116a0
801030e8:	e8 03 12 00 00       	call   801042f0 <wakeup>
  release(&log.lock);
801030ed:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
801030f4:	e8 37 16 00 00       	call   80104730 <release>
801030f9:	83 c4 10             	add    $0x10,%esp
}
801030fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ff:	5b                   	pop    %ebx
80103100:	5e                   	pop    %esi
80103101:	5f                   	pop    %edi
80103102:	5d                   	pop    %ebp
80103103:	c3                   	ret    
    panic("log.committing");
80103104:	83 ec 0c             	sub    $0xc,%esp
80103107:	68 44 78 10 80       	push   $0x80107844
8010310c:	e8 6f d2 ff ff       	call   80100380 <panic>
80103111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010311f:	90                   	nop

80103120 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	53                   	push   %ebx
80103124:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103127:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010312d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103130:	83 fa 1d             	cmp    $0x1d,%edx
80103133:	0f 8f 85 00 00 00    	jg     801031be <log_write+0x9e>
80103139:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010313e:	83 e8 01             	sub    $0x1,%eax
80103141:	39 c2                	cmp    %eax,%edx
80103143:	7d 79                	jge    801031be <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103145:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010314a:	85 c0                	test   %eax,%eax
8010314c:	7e 7d                	jle    801031cb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010314e:	83 ec 0c             	sub    $0xc,%esp
80103151:	68 a0 16 11 80       	push   $0x801116a0
80103156:	e8 35 16 00 00       	call   80104790 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010315b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80103161:	83 c4 10             	add    $0x10,%esp
80103164:	85 d2                	test   %edx,%edx
80103166:	7e 4a                	jle    801031b2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103168:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010316b:	31 c0                	xor    %eax,%eax
8010316d:	eb 08                	jmp    80103177 <log_write+0x57>
8010316f:	90                   	nop
80103170:	83 c0 01             	add    $0x1,%eax
80103173:	39 c2                	cmp    %eax,%edx
80103175:	74 29                	je     801031a0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103177:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010317e:	75 f0                	jne    80103170 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103180:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103187:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010318a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010318d:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103194:	c9                   	leave  
  release(&log.lock);
80103195:	e9 96 15 00 00       	jmp    80104730 <release>
8010319a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031a0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
801031a7:	83 c2 01             	add    $0x1,%edx
801031aa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801031b0:	eb d5                	jmp    80103187 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801031b2:	8b 43 08             	mov    0x8(%ebx),%eax
801031b5:	a3 ec 16 11 80       	mov    %eax,0x801116ec
  if (i == log.lh.n)
801031ba:	75 cb                	jne    80103187 <log_write+0x67>
801031bc:	eb e9                	jmp    801031a7 <log_write+0x87>
    panic("too big a transaction");
801031be:	83 ec 0c             	sub    $0xc,%esp
801031c1:	68 53 78 10 80       	push   $0x80107853
801031c6:	e8 b5 d1 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801031cb:	83 ec 0c             	sub    $0xc,%esp
801031ce:	68 69 78 10 80       	push   $0x80107869
801031d3:	e8 a8 d1 ff ff       	call   80100380 <panic>
801031d8:	66 90                	xchg   %ax,%ax
801031da:	66 90                	xchg   %ax,%ax
801031dc:	66 90                	xchg   %ax,%ax
801031de:	66 90                	xchg   %ax,%ax

801031e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	53                   	push   %ebx
801031e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031e7:	e8 54 09 00 00       	call   80103b40 <cpuid>
801031ec:	89 c3                	mov    %eax,%ebx
801031ee:	e8 4d 09 00 00       	call   80103b40 <cpuid>
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	53                   	push   %ebx
801031f7:	50                   	push   %eax
801031f8:	68 84 78 10 80       	push   $0x80107884
801031fd:	e8 7e d4 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
80103202:	e8 c9 28 00 00       	call   80105ad0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103207:	e8 c4 08 00 00       	call   80103ad0 <mycpu>
8010320c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010320e:	b8 01 00 00 00       	mov    $0x1,%eax
80103213:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010321a:	e8 01 0c 00 00       	call   80103e20 <scheduler>
8010321f:	90                   	nop

80103220 <mpenter>:
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103226:	e8 b5 39 00 00       	call   80106be0 <switchkvm>
  seginit();
8010322b:	e8 20 39 00 00       	call   80106b50 <seginit>
  lapicinit();
80103230:	e8 9b f7 ff ff       	call   801029d0 <lapicinit>
  mpmain();
80103235:	e8 a6 ff ff ff       	call   801031e0 <mpmain>
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <main>:
{
80103240:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103244:	83 e4 f0             	and    $0xfffffff0,%esp
80103247:	ff 71 fc             	push   -0x4(%ecx)
8010324a:	55                   	push   %ebp
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	53                   	push   %ebx
8010324e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010324f:	83 ec 08             	sub    $0x8,%esp
80103252:	68 00 00 40 80       	push   $0x80400000
80103257:	68 d0 54 11 80       	push   $0x801154d0
8010325c:	e8 8f f5 ff ff       	call   801027f0 <kinit1>
  kvmalloc();      // kernel page table
80103261:	e8 6a 3e 00 00       	call   801070d0 <kvmalloc>
  mpinit();        // detect other processors
80103266:	e8 85 01 00 00       	call   801033f0 <mpinit>
  lapicinit();     // interrupt controller
8010326b:	e8 60 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
80103270:	e8 db 38 00 00       	call   80106b50 <seginit>
  picinit();       // disable pic
80103275:	e8 76 03 00 00       	call   801035f0 <picinit>
  ioapicinit();    // another interrupt controller
8010327a:	e8 31 f3 ff ff       	call   801025b0 <ioapicinit>
  consoleinit();   // console hardware
8010327f:	e8 cc d9 ff ff       	call   80100c50 <consoleinit>
  uartinit();      // serial port
80103284:	e8 37 2b 00 00       	call   80105dc0 <uartinit>
  pinit();         // process table
80103289:	e8 22 08 00 00       	call   80103ab0 <pinit>
  tvinit();        // trap vectors
8010328e:	e8 bd 27 00 00       	call   80105a50 <tvinit>
  binit();         // buffer cache
80103293:	e8 a8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103298:	e8 63 dd ff ff       	call   80101000 <fileinit>
  ideinit();       // disk 
8010329d:	e8 fe f0 ff ff       	call   801023a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032a2:	83 c4 0c             	add    $0xc,%esp
801032a5:	68 8a 00 00 00       	push   $0x8a
801032aa:	68 8c a4 10 80       	push   $0x8010a48c
801032af:	68 00 70 00 80       	push   $0x80007000
801032b4:	e8 37 16 00 00       	call   801048f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801032c3:	00 00 00 
801032c6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801032cb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801032d0:	76 7e                	jbe    80103350 <main+0x110>
801032d2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801032d7:	eb 20                	jmp    801032f9 <main+0xb9>
801032d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032e0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801032e7:	00 00 00 
801032ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032f0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801032f5:	39 c3                	cmp    %eax,%ebx
801032f7:	73 57                	jae    80103350 <main+0x110>
    if(c == mycpu())  // We've started already.
801032f9:	e8 d2 07 00 00       	call   80103ad0 <mycpu>
801032fe:	39 c3                	cmp    %eax,%ebx
80103300:	74 de                	je     801032e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103302:	e8 59 f5 ff ff       	call   80102860 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103307:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010330a:	c7 05 f8 6f 00 80 20 	movl   $0x80103220,0x80006ff8
80103311:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103314:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010331b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010331e:	05 00 10 00 00       	add    $0x1000,%eax
80103323:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103328:	0f b6 03             	movzbl (%ebx),%eax
8010332b:	68 00 70 00 00       	push   $0x7000
80103330:	50                   	push   %eax
80103331:	e8 ea f7 ff ff       	call   80102b20 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103336:	83 c4 10             	add    $0x10,%esp
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103340:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103346:	85 c0                	test   %eax,%eax
80103348:	74 f6                	je     80103340 <main+0x100>
8010334a:	eb 94                	jmp    801032e0 <main+0xa0>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103350:	83 ec 08             	sub    $0x8,%esp
80103353:	68 00 00 00 8e       	push   $0x8e000000
80103358:	68 00 00 40 80       	push   $0x80400000
8010335d:	e8 2e f4 ff ff       	call   80102790 <kinit2>
  userinit();      // first user process
80103362:	e8 29 08 00 00       	call   80103b90 <userinit>
  mpmain();        // finish this processor's setup
80103367:	e8 74 fe ff ff       	call   801031e0 <mpmain>
8010336c:	66 90                	xchg   %ax,%ax
8010336e:	66 90                	xchg   %ax,%ax

80103370 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103375:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010337b:	53                   	push   %ebx
  e = addr+len;
8010337c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010337f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103382:	39 de                	cmp    %ebx,%esi
80103384:	72 10                	jb     80103396 <mpsearch1+0x26>
80103386:	eb 50                	jmp    801033d8 <mpsearch1+0x68>
80103388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338f:	90                   	nop
80103390:	89 fe                	mov    %edi,%esi
80103392:	39 fb                	cmp    %edi,%ebx
80103394:	76 42                	jbe    801033d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103396:	83 ec 04             	sub    $0x4,%esp
80103399:	8d 7e 10             	lea    0x10(%esi),%edi
8010339c:	6a 04                	push   $0x4
8010339e:	68 98 78 10 80       	push   $0x80107898
801033a3:	56                   	push   %esi
801033a4:	e8 f7 14 00 00       	call   801048a0 <memcmp>
801033a9:	83 c4 10             	add    $0x10,%esp
801033ac:	89 c2                	mov    %eax,%edx
801033ae:	85 c0                	test   %eax,%eax
801033b0:	75 de                	jne    80103390 <mpsearch1+0x20>
801033b2:	89 f0                	mov    %esi,%eax
801033b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801033b8:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801033bb:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033be:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033c0:	39 f8                	cmp    %edi,%eax
801033c2:	75 f4                	jne    801033b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033c4:	84 d2                	test   %dl,%dl
801033c6:	75 c8                	jne    80103390 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033cb:	89 f0                	mov    %esi,%eax
801033cd:	5b                   	pop    %ebx
801033ce:	5e                   	pop    %esi
801033cf:	5f                   	pop    %edi
801033d0:	5d                   	pop    %ebp
801033d1:	c3                   	ret    
801033d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033db:	31 f6                	xor    %esi,%esi
}
801033dd:	5b                   	pop    %ebx
801033de:	89 f0                	mov    %esi,%eax
801033e0:	5e                   	pop    %esi
801033e1:	5f                   	pop    %edi
801033e2:	5d                   	pop    %ebp
801033e3:	c3                   	ret    
801033e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033ef:	90                   	nop

801033f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103400:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103407:	c1 e0 08             	shl    $0x8,%eax
8010340a:	09 d0                	or     %edx,%eax
8010340c:	c1 e0 04             	shl    $0x4,%eax
8010340f:	75 1b                	jne    8010342c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103411:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103418:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010341f:	c1 e0 08             	shl    $0x8,%eax
80103422:	09 d0                	or     %edx,%eax
80103424:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103427:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010342c:	ba 00 04 00 00       	mov    $0x400,%edx
80103431:	e8 3a ff ff ff       	call   80103370 <mpsearch1>
80103436:	89 c3                	mov    %eax,%ebx
80103438:	85 c0                	test   %eax,%eax
8010343a:	0f 84 40 01 00 00    	je     80103580 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103440:	8b 73 04             	mov    0x4(%ebx),%esi
80103443:	85 f6                	test   %esi,%esi
80103445:	0f 84 25 01 00 00    	je     80103570 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010344b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010344e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103454:	6a 04                	push   $0x4
80103456:	68 9d 78 10 80       	push   $0x8010789d
8010345b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010345c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010345f:	e8 3c 14 00 00       	call   801048a0 <memcmp>
80103464:	83 c4 10             	add    $0x10,%esp
80103467:	85 c0                	test   %eax,%eax
80103469:	0f 85 01 01 00 00    	jne    80103570 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010346f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103476:	3c 01                	cmp    $0x1,%al
80103478:	74 08                	je     80103482 <mpinit+0x92>
8010347a:	3c 04                	cmp    $0x4,%al
8010347c:	0f 85 ee 00 00 00    	jne    80103570 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103482:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103489:	66 85 d2             	test   %dx,%dx
8010348c:	74 22                	je     801034b0 <mpinit+0xc0>
8010348e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103491:	89 f0                	mov    %esi,%eax
  sum = 0;
80103493:	31 d2                	xor    %edx,%edx
80103495:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103498:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010349f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034a2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034a4:	39 f8                	cmp    %edi,%eax
801034a6:	75 f0                	jne    80103498 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801034a8:	84 d2                	test   %dl,%dl
801034aa:	0f 85 c0 00 00 00    	jne    80103570 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034b0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801034b6:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034bb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801034c2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801034c8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034cd:	03 55 e4             	add    -0x1c(%ebp),%edx
801034d0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801034d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034d7:	90                   	nop
801034d8:	39 d0                	cmp    %edx,%eax
801034da:	73 15                	jae    801034f1 <mpinit+0x101>
    switch(*p){
801034dc:	0f b6 08             	movzbl (%eax),%ecx
801034df:	80 f9 02             	cmp    $0x2,%cl
801034e2:	74 4c                	je     80103530 <mpinit+0x140>
801034e4:	77 3a                	ja     80103520 <mpinit+0x130>
801034e6:	84 c9                	test   %cl,%cl
801034e8:	74 56                	je     80103540 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034ea:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ed:	39 d0                	cmp    %edx,%eax
801034ef:	72 eb                	jb     801034dc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034f4:	85 f6                	test   %esi,%esi
801034f6:	0f 84 d9 00 00 00    	je     801035d5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034fc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103500:	74 15                	je     80103517 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103502:	b8 70 00 00 00       	mov    $0x70,%eax
80103507:	ba 22 00 00 00       	mov    $0x22,%edx
8010350c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010350d:	ba 23 00 00 00       	mov    $0x23,%edx
80103512:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103513:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103516:	ee                   	out    %al,(%dx)
  }
}
80103517:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010351a:	5b                   	pop    %ebx
8010351b:	5e                   	pop    %esi
8010351c:	5f                   	pop    %edi
8010351d:	5d                   	pop    %ebp
8010351e:	c3                   	ret    
8010351f:	90                   	nop
    switch(*p){
80103520:	83 e9 03             	sub    $0x3,%ecx
80103523:	80 f9 01             	cmp    $0x1,%cl
80103526:	76 c2                	jbe    801034ea <mpinit+0xfa>
80103528:	31 f6                	xor    %esi,%esi
8010352a:	eb ac                	jmp    801034d8 <mpinit+0xe8>
8010352c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103530:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103534:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103537:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010353d:	eb 99                	jmp    801034d8 <mpinit+0xe8>
8010353f:	90                   	nop
      if(ncpu < NCPU) {
80103540:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103546:	83 f9 07             	cmp    $0x7,%ecx
80103549:	7f 19                	jg     80103564 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010354b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103551:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103555:	83 c1 01             	add    $0x1,%ecx
80103558:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010355e:	88 9f a0 17 11 80    	mov    %bl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
80103564:	83 c0 14             	add    $0x14,%eax
      continue;
80103567:	e9 6c ff ff ff       	jmp    801034d8 <mpinit+0xe8>
8010356c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	68 a2 78 10 80       	push   $0x801078a2
80103578:	e8 03 ce ff ff       	call   80100380 <panic>
8010357d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103580:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103585:	eb 13                	jmp    8010359a <mpinit+0x1aa>
80103587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010358e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103590:	89 f3                	mov    %esi,%ebx
80103592:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103598:	74 d6                	je     80103570 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010359a:	83 ec 04             	sub    $0x4,%esp
8010359d:	8d 73 10             	lea    0x10(%ebx),%esi
801035a0:	6a 04                	push   $0x4
801035a2:	68 98 78 10 80       	push   $0x80107898
801035a7:	53                   	push   %ebx
801035a8:	e8 f3 12 00 00       	call   801048a0 <memcmp>
801035ad:	83 c4 10             	add    $0x10,%esp
801035b0:	89 c2                	mov    %eax,%edx
801035b2:	85 c0                	test   %eax,%eax
801035b4:	75 da                	jne    80103590 <mpinit+0x1a0>
801035b6:	89 d8                	mov    %ebx,%eax
801035b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035bf:	90                   	nop
    sum += addr[i];
801035c0:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801035c3:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801035c6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801035c8:	39 f0                	cmp    %esi,%eax
801035ca:	75 f4                	jne    801035c0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801035cc:	84 d2                	test   %dl,%dl
801035ce:	75 c0                	jne    80103590 <mpinit+0x1a0>
801035d0:	e9 6b fe ff ff       	jmp    80103440 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801035d5:	83 ec 0c             	sub    $0xc,%esp
801035d8:	68 bc 78 10 80       	push   $0x801078bc
801035dd:	e8 9e cd ff ff       	call   80100380 <panic>
801035e2:	66 90                	xchg   %ax,%ax
801035e4:	66 90                	xchg   %ax,%ax
801035e6:	66 90                	xchg   %ax,%ax
801035e8:	66 90                	xchg   %ax,%ax
801035ea:	66 90                	xchg   %ax,%ax
801035ec:	66 90                	xchg   %ax,%ax
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <picinit>:
801035f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035f5:	ba 21 00 00 00       	mov    $0x21,%edx
801035fa:	ee                   	out    %al,(%dx)
801035fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103600:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103601:	c3                   	ret    
80103602:	66 90                	xchg   %ax,%ax
80103604:	66 90                	xchg   %ax,%ax
80103606:	66 90                	xchg   %ax,%ax
80103608:	66 90                	xchg   %ax,%ax
8010360a:	66 90                	xchg   %ax,%ax
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 0c             	sub    $0xc,%esp
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010361c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010361f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103625:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010362b:	e8 f0 d9 ff ff       	call   80101020 <filealloc>
80103630:	89 03                	mov    %eax,(%ebx)
80103632:	85 c0                	test   %eax,%eax
80103634:	0f 84 a8 00 00 00    	je     801036e2 <pipealloc+0xd2>
8010363a:	e8 e1 d9 ff ff       	call   80101020 <filealloc>
8010363f:	89 06                	mov    %eax,(%esi)
80103641:	85 c0                	test   %eax,%eax
80103643:	0f 84 87 00 00 00    	je     801036d0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103649:	e8 12 f2 ff ff       	call   80102860 <kalloc>
8010364e:	89 c7                	mov    %eax,%edi
80103650:	85 c0                	test   %eax,%eax
80103652:	0f 84 b0 00 00 00    	je     80103708 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103658:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010365f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103662:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103665:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010366c:	00 00 00 
  p->nwrite = 0;
8010366f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103676:	00 00 00 
  p->nread = 0;
80103679:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103680:	00 00 00 
  initlock(&p->lock, "pipe");
80103683:	68 db 78 10 80       	push   $0x801078db
80103688:	50                   	push   %eax
80103689:	e8 32 0f 00 00       	call   801045c0 <initlock>
  (*f0)->type = FD_PIPE;
8010368e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103690:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103693:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103699:	8b 03                	mov    (%ebx),%eax
8010369b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010369f:	8b 03                	mov    (%ebx),%eax
801036a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036a5:	8b 03                	mov    (%ebx),%eax
801036a7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036aa:	8b 06                	mov    (%esi),%eax
801036ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036b2:	8b 06                	mov    (%esi),%eax
801036b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036b8:	8b 06                	mov    (%esi),%eax
801036ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036be:	8b 06                	mov    (%esi),%eax
801036c0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801036c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036c6:	31 c0                	xor    %eax,%eax
}
801036c8:	5b                   	pop    %ebx
801036c9:	5e                   	pop    %esi
801036ca:	5f                   	pop    %edi
801036cb:	5d                   	pop    %ebp
801036cc:	c3                   	ret    
801036cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801036d0:	8b 03                	mov    (%ebx),%eax
801036d2:	85 c0                	test   %eax,%eax
801036d4:	74 1e                	je     801036f4 <pipealloc+0xe4>
    fileclose(*f0);
801036d6:	83 ec 0c             	sub    $0xc,%esp
801036d9:	50                   	push   %eax
801036da:	e8 01 da ff ff       	call   801010e0 <fileclose>
801036df:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036e2:	8b 06                	mov    (%esi),%eax
801036e4:	85 c0                	test   %eax,%eax
801036e6:	74 0c                	je     801036f4 <pipealloc+0xe4>
    fileclose(*f1);
801036e8:	83 ec 0c             	sub    $0xc,%esp
801036eb:	50                   	push   %eax
801036ec:	e8 ef d9 ff ff       	call   801010e0 <fileclose>
801036f1:	83 c4 10             	add    $0x10,%esp
}
801036f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036fc:	5b                   	pop    %ebx
801036fd:	5e                   	pop    %esi
801036fe:	5f                   	pop    %edi
801036ff:	5d                   	pop    %ebp
80103700:	c3                   	ret    
80103701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103708:	8b 03                	mov    (%ebx),%eax
8010370a:	85 c0                	test   %eax,%eax
8010370c:	75 c8                	jne    801036d6 <pipealloc+0xc6>
8010370e:	eb d2                	jmp    801036e2 <pipealloc+0xd2>

80103710 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103718:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010371b:	83 ec 0c             	sub    $0xc,%esp
8010371e:	53                   	push   %ebx
8010371f:	e8 6c 10 00 00       	call   80104790 <acquire>
  if(writable){
80103724:	83 c4 10             	add    $0x10,%esp
80103727:	85 f6                	test   %esi,%esi
80103729:	74 65                	je     80103790 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103734:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010373b:	00 00 00 
    wakeup(&p->nread);
8010373e:	50                   	push   %eax
8010373f:	e8 ac 0b 00 00       	call   801042f0 <wakeup>
80103744:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103747:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010374d:	85 d2                	test   %edx,%edx
8010374f:	75 0a                	jne    8010375b <pipeclose+0x4b>
80103751:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103757:	85 c0                	test   %eax,%eax
80103759:	74 15                	je     80103770 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010375b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010375e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103761:	5b                   	pop    %ebx
80103762:	5e                   	pop    %esi
80103763:	5d                   	pop    %ebp
    release(&p->lock);
80103764:	e9 c7 0f 00 00       	jmp    80104730 <release>
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	53                   	push   %ebx
80103774:	e8 b7 0f 00 00       	call   80104730 <release>
    kfree((char*)p);
80103779:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010377c:	83 c4 10             	add    $0x10,%esp
}
8010377f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103782:	5b                   	pop    %ebx
80103783:	5e                   	pop    %esi
80103784:	5d                   	pop    %ebp
    kfree((char*)p);
80103785:	e9 16 ef ff ff       	jmp    801026a0 <kfree>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103799:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037a0:	00 00 00 
    wakeup(&p->nwrite);
801037a3:	50                   	push   %eax
801037a4:	e8 47 0b 00 00       	call   801042f0 <wakeup>
801037a9:	83 c4 10             	add    $0x10,%esp
801037ac:	eb 99                	jmp    80103747 <pipeclose+0x37>
801037ae:	66 90                	xchg   %ax,%ax

801037b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	57                   	push   %edi
801037b4:	56                   	push   %esi
801037b5:	53                   	push   %ebx
801037b6:	83 ec 28             	sub    $0x28,%esp
801037b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037bc:	53                   	push   %ebx
801037bd:	e8 ce 0f 00 00       	call   80104790 <acquire>
  for(i = 0; i < n; i++){
801037c2:	8b 45 10             	mov    0x10(%ebp),%eax
801037c5:	83 c4 10             	add    $0x10,%esp
801037c8:	85 c0                	test   %eax,%eax
801037ca:	0f 8e c0 00 00 00    	jle    80103890 <pipewrite+0xe0>
801037d0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037d3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037d9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801037e2:	03 45 10             	add    0x10(%ebp),%eax
801037e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037e8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037ee:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037f4:	89 ca                	mov    %ecx,%edx
801037f6:	05 00 02 00 00       	add    $0x200,%eax
801037fb:	39 c1                	cmp    %eax,%ecx
801037fd:	74 3f                	je     8010383e <pipewrite+0x8e>
801037ff:	eb 67                	jmp    80103868 <pipewrite+0xb8>
80103801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103808:	e8 53 03 00 00       	call   80103b60 <myproc>
8010380d:	8b 48 24             	mov    0x24(%eax),%ecx
80103810:	85 c9                	test   %ecx,%ecx
80103812:	75 34                	jne    80103848 <pipewrite+0x98>
      wakeup(&p->nread);
80103814:	83 ec 0c             	sub    $0xc,%esp
80103817:	57                   	push   %edi
80103818:	e8 d3 0a 00 00       	call   801042f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010381d:	58                   	pop    %eax
8010381e:	5a                   	pop    %edx
8010381f:	53                   	push   %ebx
80103820:	56                   	push   %esi
80103821:	e8 0a 0a 00 00       	call   80104230 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103826:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010382c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103832:	83 c4 10             	add    $0x10,%esp
80103835:	05 00 02 00 00       	add    $0x200,%eax
8010383a:	39 c2                	cmp    %eax,%edx
8010383c:	75 2a                	jne    80103868 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010383e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103844:	85 c0                	test   %eax,%eax
80103846:	75 c0                	jne    80103808 <pipewrite+0x58>
        release(&p->lock);
80103848:	83 ec 0c             	sub    $0xc,%esp
8010384b:	53                   	push   %ebx
8010384c:	e8 df 0e 00 00       	call   80104730 <release>
        return -1;
80103851:	83 c4 10             	add    $0x10,%esp
80103854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010385c:	5b                   	pop    %ebx
8010385d:	5e                   	pop    %esi
8010385e:	5f                   	pop    %edi
8010385f:	5d                   	pop    %ebp
80103860:	c3                   	ret    
80103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103868:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010386b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010386e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103874:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010387a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010387d:	83 c6 01             	add    $0x1,%esi
80103880:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103883:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103887:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010388a:	0f 85 58 ff ff ff    	jne    801037e8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103899:	50                   	push   %eax
8010389a:	e8 51 0a 00 00       	call   801042f0 <wakeup>
  release(&p->lock);
8010389f:	89 1c 24             	mov    %ebx,(%esp)
801038a2:	e8 89 0e 00 00       	call   80104730 <release>
  return n;
801038a7:	8b 45 10             	mov    0x10(%ebp),%eax
801038aa:	83 c4 10             	add    $0x10,%esp
801038ad:	eb aa                	jmp    80103859 <pipewrite+0xa9>
801038af:	90                   	nop

801038b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	57                   	push   %edi
801038b4:	56                   	push   %esi
801038b5:	53                   	push   %ebx
801038b6:	83 ec 18             	sub    $0x18,%esp
801038b9:	8b 75 08             	mov    0x8(%ebp),%esi
801038bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038bf:	56                   	push   %esi
801038c0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038c6:	e8 c5 0e 00 00       	call   80104790 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038cb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801038d1:	83 c4 10             	add    $0x10,%esp
801038d4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801038da:	74 2f                	je     8010390b <piperead+0x5b>
801038dc:	eb 37                	jmp    80103915 <piperead+0x65>
801038de:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801038e0:	e8 7b 02 00 00       	call   80103b60 <myproc>
801038e5:	8b 48 24             	mov    0x24(%eax),%ecx
801038e8:	85 c9                	test   %ecx,%ecx
801038ea:	0f 85 80 00 00 00    	jne    80103970 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038f0:	83 ec 08             	sub    $0x8,%esp
801038f3:	56                   	push   %esi
801038f4:	53                   	push   %ebx
801038f5:	e8 36 09 00 00       	call   80104230 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038fa:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103900:	83 c4 10             	add    $0x10,%esp
80103903:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103909:	75 0a                	jne    80103915 <piperead+0x65>
8010390b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103911:	85 c0                	test   %eax,%eax
80103913:	75 cb                	jne    801038e0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103915:	8b 55 10             	mov    0x10(%ebp),%edx
80103918:	31 db                	xor    %ebx,%ebx
8010391a:	85 d2                	test   %edx,%edx
8010391c:	7f 20                	jg     8010393e <piperead+0x8e>
8010391e:	eb 2c                	jmp    8010394c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103920:	8d 48 01             	lea    0x1(%eax),%ecx
80103923:	25 ff 01 00 00       	and    $0x1ff,%eax
80103928:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010392e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103933:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103936:	83 c3 01             	add    $0x1,%ebx
80103939:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010393c:	74 0e                	je     8010394c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010393e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103944:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010394a:	75 d4                	jne    80103920 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010394c:	83 ec 0c             	sub    $0xc,%esp
8010394f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103955:	50                   	push   %eax
80103956:	e8 95 09 00 00       	call   801042f0 <wakeup>
  release(&p->lock);
8010395b:	89 34 24             	mov    %esi,(%esp)
8010395e:	e8 cd 0d 00 00       	call   80104730 <release>
  return i;
80103963:	83 c4 10             	add    $0x10,%esp
}
80103966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103969:	89 d8                	mov    %ebx,%eax
8010396b:	5b                   	pop    %ebx
8010396c:	5e                   	pop    %esi
8010396d:	5f                   	pop    %edi
8010396e:	5d                   	pop    %ebp
8010396f:	c3                   	ret    
      release(&p->lock);
80103970:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103973:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103978:	56                   	push   %esi
80103979:	e8 b2 0d 00 00       	call   80104730 <release>
      return -1;
8010397e:	83 c4 10             	add    $0x10,%esp
}
80103981:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103984:	89 d8                	mov    %ebx,%eax
80103986:	5b                   	pop    %ebx
80103987:	5e                   	pop    %esi
80103988:	5f                   	pop    %edi
80103989:	5d                   	pop    %ebp
8010398a:	c3                   	ret    
8010398b:	66 90                	xchg   %ax,%ax
8010398d:	66 90                	xchg   %ax,%ax
8010398f:	90                   	nop

80103990 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103994:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
80103999:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010399c:	68 20 1d 11 80       	push   $0x80111d20
801039a1:	e8 ea 0d 00 00       	call   80104790 <acquire>
801039a6:	83 c4 10             	add    $0x10,%esp
801039a9:	eb 10                	jmp    801039bb <allocproc+0x2b>
801039ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039b0:	83 c3 7c             	add    $0x7c,%ebx
801039b3:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801039b9:	74 75                	je     80103a30 <allocproc+0xa0>
    if(p->state == UNUSED)
801039bb:	8b 43 0c             	mov    0xc(%ebx),%eax
801039be:	85 c0                	test   %eax,%eax
801039c0:	75 ee                	jne    801039b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039c2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801039c7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039ca:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039d1:	89 43 10             	mov    %eax,0x10(%ebx)
801039d4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801039d7:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
801039dc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801039e2:	e8 49 0d 00 00       	call   80104730 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039e7:	e8 74 ee ff ff       	call   80102860 <kalloc>
801039ec:	83 c4 10             	add    $0x10,%esp
801039ef:	89 43 08             	mov    %eax,0x8(%ebx)
801039f2:	85 c0                	test   %eax,%eax
801039f4:	74 53                	je     80103a49 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039f6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039fc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a04:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a07:	c7 40 14 42 5a 10 80 	movl   $0x80105a42,0x14(%eax)
  p->context = (struct context*)sp;
80103a0e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a11:	6a 14                	push   $0x14
80103a13:	6a 00                	push   $0x0
80103a15:	50                   	push   %eax
80103a16:	e8 35 0e 00 00       	call   80104850 <memset>
  p->context->eip = (uint)forkret;
80103a1b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a1e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a21:	c7 40 10 60 3a 10 80 	movl   $0x80103a60,0x10(%eax)
}
80103a28:	89 d8                	mov    %ebx,%eax
80103a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a2d:	c9                   	leave  
80103a2e:	c3                   	ret    
80103a2f:	90                   	nop
  release(&ptable.lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a33:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a35:	68 20 1d 11 80       	push   $0x80111d20
80103a3a:	e8 f1 0c 00 00       	call   80104730 <release>
}
80103a3f:	89 d8                	mov    %ebx,%eax
  return 0;
80103a41:	83 c4 10             	add    $0x10,%esp
}
80103a44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a47:	c9                   	leave  
80103a48:	c3                   	ret    
    p->state = UNUSED;
80103a49:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a50:	31 db                	xor    %ebx,%ebx
}
80103a52:	89 d8                	mov    %ebx,%eax
80103a54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a57:	c9                   	leave  
80103a58:	c3                   	ret    
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a60 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a66:	68 20 1d 11 80       	push   $0x80111d20
80103a6b:	e8 c0 0c 00 00       	call   80104730 <release>

  if (first) {
80103a70:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a75:	83 c4 10             	add    $0x10,%esp
80103a78:	85 c0                	test   %eax,%eax
80103a7a:	75 04                	jne    80103a80 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a7c:	c9                   	leave  
80103a7d:	c3                   	ret    
80103a7e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a80:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a87:	00 00 00 
    iinit(ROOTDEV);
80103a8a:	83 ec 0c             	sub    $0xc,%esp
80103a8d:	6a 01                	push   $0x1
80103a8f:	e8 ac dc ff ff       	call   80101740 <iinit>
    initlog(ROOTDEV);
80103a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a9b:	e8 00 f4 ff ff       	call   80102ea0 <initlog>
}
80103aa0:	83 c4 10             	add    $0x10,%esp
80103aa3:	c9                   	leave  
80103aa4:	c3                   	ret    
80103aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ab0 <pinit>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ab6:	68 e0 78 10 80       	push   $0x801078e0
80103abb:	68 20 1d 11 80       	push   $0x80111d20
80103ac0:	e8 fb 0a 00 00       	call   801045c0 <initlock>
}
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	c9                   	leave  
80103ac9:	c3                   	ret    
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ad0 <mycpu>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ad5:	9c                   	pushf  
80103ad6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ad7:	f6 c4 02             	test   $0x2,%ah
80103ada:	75 4e                	jne    80103b2a <mycpu+0x5a>
  apicid = lapicid();
80103adc:	e8 ef ef ff ff       	call   80102ad0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ae1:	8b 35 84 17 11 80    	mov    0x80111784,%esi
  apicid = lapicid();
80103ae7:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103ae9:	85 f6                	test   %esi,%esi
80103aeb:	7e 30                	jle    80103b1d <mycpu+0x4d>
80103aed:	31 c0                	xor    %eax,%eax
80103aef:	eb 0e                	jmp    80103aff <mycpu+0x2f>
80103af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103af8:	83 c0 01             	add    $0x1,%eax
80103afb:	39 f0                	cmp    %esi,%eax
80103afd:	74 1e                	je     80103b1d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103aff:	69 d0 b0 00 00 00    	imul   $0xb0,%eax,%edx
80103b05:	0f b6 8a a0 17 11 80 	movzbl -0x7feee860(%edx),%ecx
80103b0c:	39 d9                	cmp    %ebx,%ecx
80103b0e:	75 e8                	jne    80103af8 <mycpu+0x28>
}
80103b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b13:	8d 82 a0 17 11 80    	lea    -0x7feee860(%edx),%eax
}
80103b19:	5b                   	pop    %ebx
80103b1a:	5e                   	pop    %esi
80103b1b:	5d                   	pop    %ebp
80103b1c:	c3                   	ret    
  panic("unknown apicid\n");
80103b1d:	83 ec 0c             	sub    $0xc,%esp
80103b20:	68 e7 78 10 80       	push   $0x801078e7
80103b25:	e8 56 c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b2a:	83 ec 0c             	sub    $0xc,%esp
80103b2d:	68 c4 79 10 80       	push   $0x801079c4
80103b32:	e8 49 c8 ff ff       	call   80100380 <panic>
80103b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b3e:	66 90                	xchg   %ax,%ax

80103b40 <cpuid>:
cpuid() {
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b46:	e8 85 ff ff ff       	call   80103ad0 <mycpu>
}
80103b4b:	c9                   	leave  
  return mycpu()-cpus;
80103b4c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103b51:	c1 f8 04             	sar    $0x4,%eax
80103b54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b5a:	c3                   	ret    
80103b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <myproc>:
myproc(void) {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b67:	e8 d4 0a 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103b6c:	e8 5f ff ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103b71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b77:	e8 14 0b 00 00       	call   80104690 <popcli>
}
80103b7c:	89 d8                	mov    %ebx,%eax
80103b7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b81:	c9                   	leave  
80103b82:	c3                   	ret    
80103b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b90 <userinit>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b97:	e8 f4 fd ff ff       	call   80103990 <allocproc>
80103b9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b9e:	a3 54 3c 11 80       	mov    %eax,0x80113c54
  if((p->pgdir = setupkvm()) == 0)
80103ba3:	e8 a8 34 00 00       	call   80107050 <setupkvm>
80103ba8:	89 43 04             	mov    %eax,0x4(%ebx)
80103bab:	85 c0                	test   %eax,%eax
80103bad:	0f 84 bd 00 00 00    	je     80103c70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bb3:	83 ec 04             	sub    $0x4,%esp
80103bb6:	68 2c 00 00 00       	push   $0x2c
80103bbb:	68 60 a4 10 80       	push   $0x8010a460
80103bc0:	50                   	push   %eax
80103bc1:	e8 3a 31 00 00       	call   80106d00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bcf:	6a 4c                	push   $0x4c
80103bd1:	6a 00                	push   $0x0
80103bd3:	ff 73 18             	push   0x18(%ebx)
80103bd6:	e8 75 0c 00 00       	call   80104850 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bdb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103be3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103be6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103beb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bef:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c01:	8b 43 18             	mov    0x18(%ebx),%eax
80103c04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c16:	8b 43 18             	mov    0x18(%ebx),%eax
80103c19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c20:	8b 43 18             	mov    0x18(%ebx),%eax
80103c23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c2d:	6a 10                	push   $0x10
80103c2f:	68 10 79 10 80       	push   $0x80107910
80103c34:	50                   	push   %eax
80103c35:	e8 d6 0d 00 00       	call   80104a10 <safestrcpy>
  p->cwd = namei("/");
80103c3a:	c7 04 24 19 79 10 80 	movl   $0x80107919,(%esp)
80103c41:	e8 3a e6 ff ff       	call   80102280 <namei>
80103c46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c49:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c50:	e8 3b 0b 00 00       	call   80104790 <acquire>
  p->state = RUNNABLE;
80103c55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c5c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103c63:	e8 c8 0a 00 00       	call   80104730 <release>
}
80103c68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c6b:	83 c4 10             	add    $0x10,%esp
80103c6e:	c9                   	leave  
80103c6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	68 f7 78 10 80       	push   $0x801078f7
80103c78:	e8 03 c7 ff ff       	call   80100380 <panic>
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi

80103c80 <growproc>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	56                   	push   %esi
80103c84:	53                   	push   %ebx
80103c85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c88:	e8 b3 09 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103c8d:	e8 3e fe ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103c92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c98:	e8 f3 09 00 00       	call   80104690 <popcli>
  sz = curproc->sz;
80103c9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c9f:	85 f6                	test   %esi,%esi
80103ca1:	7f 1d                	jg     80103cc0 <growproc+0x40>
  } else if(n < 0){
80103ca3:	75 3b                	jne    80103ce0 <growproc+0x60>
  switchuvm(curproc);
80103ca5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ca8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103caa:	53                   	push   %ebx
80103cab:	e8 40 2f 00 00       	call   80106bf0 <switchuvm>
  return 0;
80103cb0:	83 c4 10             	add    $0x10,%esp
80103cb3:	31 c0                	xor    %eax,%eax
}
80103cb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb8:	5b                   	pop    %ebx
80103cb9:	5e                   	pop    %esi
80103cba:	5d                   	pop    %ebp
80103cbb:	c3                   	ret    
80103cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cc0:	83 ec 04             	sub    $0x4,%esp
80103cc3:	01 c6                	add    %eax,%esi
80103cc5:	56                   	push   %esi
80103cc6:	50                   	push   %eax
80103cc7:	ff 73 04             	push   0x4(%ebx)
80103cca:	e8 a1 31 00 00       	call   80106e70 <allocuvm>
80103ccf:	83 c4 10             	add    $0x10,%esp
80103cd2:	85 c0                	test   %eax,%eax
80103cd4:	75 cf                	jne    80103ca5 <growproc+0x25>
      return -1;
80103cd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cdb:	eb d8                	jmp    80103cb5 <growproc+0x35>
80103cdd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ce0:	83 ec 04             	sub    $0x4,%esp
80103ce3:	01 c6                	add    %eax,%esi
80103ce5:	56                   	push   %esi
80103ce6:	50                   	push   %eax
80103ce7:	ff 73 04             	push   0x4(%ebx)
80103cea:	e8 b1 32 00 00       	call   80106fa0 <deallocuvm>
80103cef:	83 c4 10             	add    $0x10,%esp
80103cf2:	85 c0                	test   %eax,%eax
80103cf4:	75 af                	jne    80103ca5 <growproc+0x25>
80103cf6:	eb de                	jmp    80103cd6 <growproc+0x56>
80103cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cff:	90                   	nop

80103d00 <fork>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d09:	e8 32 09 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103d0e:	e8 bd fd ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103d13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d19:	e8 72 09 00 00       	call   80104690 <popcli>
  if((np = allocproc()) == 0){
80103d1e:	e8 6d fc ff ff       	call   80103990 <allocproc>
80103d23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d26:	85 c0                	test   %eax,%eax
80103d28:	0f 84 b7 00 00 00    	je     80103de5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d2e:	83 ec 08             	sub    $0x8,%esp
80103d31:	ff 33                	push   (%ebx)
80103d33:	89 c7                	mov    %eax,%edi
80103d35:	ff 73 04             	push   0x4(%ebx)
80103d38:	e8 03 34 00 00       	call   80107140 <copyuvm>
80103d3d:	83 c4 10             	add    $0x10,%esp
80103d40:	89 47 04             	mov    %eax,0x4(%edi)
80103d43:	85 c0                	test   %eax,%eax
80103d45:	0f 84 a1 00 00 00    	je     80103dec <fork+0xec>
  np->sz = curproc->sz;
80103d4b:	8b 03                	mov    (%ebx),%eax
80103d4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d50:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d52:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d55:	89 c8                	mov    %ecx,%eax
80103d57:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d5a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d5f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d62:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d64:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d66:	8b 40 18             	mov    0x18(%eax),%eax
80103d69:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d70:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d74:	85 c0                	test   %eax,%eax
80103d76:	74 13                	je     80103d8b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d78:	83 ec 0c             	sub    $0xc,%esp
80103d7b:	50                   	push   %eax
80103d7c:	e8 0f d3 ff ff       	call   80101090 <filedup>
80103d81:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d84:	83 c4 10             	add    $0x10,%esp
80103d87:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d8b:	83 c6 01             	add    $0x1,%esi
80103d8e:	83 fe 10             	cmp    $0x10,%esi
80103d91:	75 dd                	jne    80103d70 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d93:	83 ec 0c             	sub    $0xc,%esp
80103d96:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d99:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d9c:	e8 8f db ff ff       	call   80101930 <idup>
80103da1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103da4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103da7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103daa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103dad:	6a 10                	push   $0x10
80103daf:	53                   	push   %ebx
80103db0:	50                   	push   %eax
80103db1:	e8 5a 0c 00 00       	call   80104a10 <safestrcpy>
  pid = np->pid;
80103db6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103db9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103dc0:	e8 cb 09 00 00       	call   80104790 <acquire>
  np->state = RUNNABLE;
80103dc5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103dcc:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103dd3:	e8 58 09 00 00       	call   80104730 <release>
  return pid;
80103dd8:	83 c4 10             	add    $0x10,%esp
}
80103ddb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dde:	89 d8                	mov    %ebx,%eax
80103de0:	5b                   	pop    %ebx
80103de1:	5e                   	pop    %esi
80103de2:	5f                   	pop    %edi
80103de3:	5d                   	pop    %ebp
80103de4:	c3                   	ret    
    return -1;
80103de5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dea:	eb ef                	jmp    80103ddb <fork+0xdb>
    kfree(np->kstack);
80103dec:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103def:	83 ec 0c             	sub    $0xc,%esp
80103df2:	ff 73 08             	push   0x8(%ebx)
80103df5:	e8 a6 e8 ff ff       	call   801026a0 <kfree>
    np->kstack = 0;
80103dfa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103e01:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103e04:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e10:	eb c9                	jmp    80103ddb <fork+0xdb>
80103e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e20 <scheduler>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	53                   	push   %ebx
80103e26:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e29:	e8 a2 fc ff ff       	call   80103ad0 <mycpu>
  c->proc = 0;
80103e2e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e35:	00 00 00 
  struct cpu *c = mycpu();
80103e38:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e3a:	8d 78 04             	lea    0x4(%eax),%edi
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e40:	fb                   	sti    
    acquire(&ptable.lock);
80103e41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e44:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103e49:	68 20 1d 11 80       	push   $0x80111d20
80103e4e:	e8 3d 09 00 00       	call   80104790 <acquire>
80103e53:	83 c4 10             	add    $0x10,%esp
80103e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103e60:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e64:	75 33                	jne    80103e99 <scheduler+0x79>
      switchuvm(p);
80103e66:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e69:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e6f:	53                   	push   %ebx
80103e70:	e8 7b 2d 00 00       	call   80106bf0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e75:	58                   	pop    %eax
80103e76:	5a                   	pop    %edx
80103e77:	ff 73 1c             	push   0x1c(%ebx)
80103e7a:	57                   	push   %edi
      p->state = RUNNING;
80103e7b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e82:	e8 e4 0b 00 00       	call   80104a6b <swtch>
      switchkvm();
80103e87:	e8 54 2d 00 00       	call   80106be0 <switchkvm>
      c->proc = 0;
80103e8c:	83 c4 10             	add    $0x10,%esp
80103e8f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e96:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e99:	83 c3 7c             	add    $0x7c,%ebx
80103e9c:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
80103ea2:	75 bc                	jne    80103e60 <scheduler+0x40>
    release(&ptable.lock);
80103ea4:	83 ec 0c             	sub    $0xc,%esp
80103ea7:	68 20 1d 11 80       	push   $0x80111d20
80103eac:	e8 7f 08 00 00       	call   80104730 <release>
    sti();
80103eb1:	83 c4 10             	add    $0x10,%esp
80103eb4:	eb 8a                	jmp    80103e40 <scheduler+0x20>
80103eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi

80103ec0 <sched>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  pushcli();
80103ec5:	e8 76 07 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103eca:	e8 01 fc ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80103ecf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ed5:	e8 b6 07 00 00       	call   80104690 <popcli>
  if(!holding(&ptable.lock))
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 20 1d 11 80       	push   $0x80111d20
80103ee2:	e8 09 08 00 00       	call   801046f0 <holding>
80103ee7:	83 c4 10             	add    $0x10,%esp
80103eea:	85 c0                	test   %eax,%eax
80103eec:	74 4f                	je     80103f3d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103eee:	e8 dd fb ff ff       	call   80103ad0 <mycpu>
80103ef3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103efa:	75 68                	jne    80103f64 <sched+0xa4>
  if(p->state == RUNNING)
80103efc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f00:	74 55                	je     80103f57 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f02:	9c                   	pushf  
80103f03:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f04:	f6 c4 02             	test   $0x2,%ah
80103f07:	75 41                	jne    80103f4a <sched+0x8a>
  intena = mycpu()->intena;
80103f09:	e8 c2 fb ff ff       	call   80103ad0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f0e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f17:	e8 b4 fb ff ff       	call   80103ad0 <mycpu>
80103f1c:	83 ec 08             	sub    $0x8,%esp
80103f1f:	ff 70 04             	push   0x4(%eax)
80103f22:	53                   	push   %ebx
80103f23:	e8 43 0b 00 00       	call   80104a6b <swtch>
  mycpu()->intena = intena;
80103f28:	e8 a3 fb ff ff       	call   80103ad0 <mycpu>
}
80103f2d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f39:	5b                   	pop    %ebx
80103f3a:	5e                   	pop    %esi
80103f3b:	5d                   	pop    %ebp
80103f3c:	c3                   	ret    
    panic("sched ptable.lock");
80103f3d:	83 ec 0c             	sub    $0xc,%esp
80103f40:	68 1b 79 10 80       	push   $0x8010791b
80103f45:	e8 36 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 47 79 10 80       	push   $0x80107947
80103f52:	e8 29 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103f57:	83 ec 0c             	sub    $0xc,%esp
80103f5a:	68 39 79 10 80       	push   $0x80107939
80103f5f:	e8 1c c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 2d 79 10 80       	push   $0x8010792d
80103f6c:	e8 0f c4 ff ff       	call   80100380 <panic>
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f7f:	90                   	nop

80103f80 <exit>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	57                   	push   %edi
80103f84:	56                   	push   %esi
80103f85:	53                   	push   %ebx
80103f86:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103f89:	e8 d2 fb ff ff       	call   80103b60 <myproc>
  if(curproc == initproc)
80103f8e:	39 05 54 3c 11 80    	cmp    %eax,0x80113c54
80103f94:	0f 84 fd 00 00 00    	je     80104097 <exit+0x117>
80103f9a:	89 c3                	mov    %eax,%ebx
80103f9c:	8d 70 28             	lea    0x28(%eax),%esi
80103f9f:	8d 78 68             	lea    0x68(%eax),%edi
80103fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103fa8:	8b 06                	mov    (%esi),%eax
80103faa:	85 c0                	test   %eax,%eax
80103fac:	74 12                	je     80103fc0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103fae:	83 ec 0c             	sub    $0xc,%esp
80103fb1:	50                   	push   %eax
80103fb2:	e8 29 d1 ff ff       	call   801010e0 <fileclose>
      curproc->ofile[fd] = 0;
80103fb7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103fbd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fc0:	83 c6 04             	add    $0x4,%esi
80103fc3:	39 f7                	cmp    %esi,%edi
80103fc5:	75 e1                	jne    80103fa8 <exit+0x28>
  begin_op();
80103fc7:	e8 74 ef ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
80103fcc:	83 ec 0c             	sub    $0xc,%esp
80103fcf:	ff 73 68             	push   0x68(%ebx)
80103fd2:	e8 b9 da ff ff       	call   80101a90 <iput>
  end_op();
80103fd7:	e8 d4 ef ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
80103fdc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103fe3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fea:	e8 a1 07 00 00       	call   80104790 <acquire>
  wakeup1(curproc->parent);
80103fef:	8b 53 14             	mov    0x14(%ebx),%edx
80103ff2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff5:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103ffa:	eb 0e                	jmp    8010400a <exit+0x8a>
80103ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104000:	83 c0 7c             	add    $0x7c,%eax
80104003:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104008:	74 1c                	je     80104026 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
8010400a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010400e:	75 f0                	jne    80104000 <exit+0x80>
80104010:	3b 50 20             	cmp    0x20(%eax),%edx
80104013:	75 eb                	jne    80104000 <exit+0x80>
      p->state = RUNNABLE;
80104015:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010401c:	83 c0 7c             	add    $0x7c,%eax
8010401f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104024:	75 e4                	jne    8010400a <exit+0x8a>
      p->parent = initproc;
80104026:	8b 0d 54 3c 11 80    	mov    0x80113c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80104031:	eb 10                	jmp    80104043 <exit+0xc3>
80104033:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104037:	90                   	nop
80104038:	83 c2 7c             	add    $0x7c,%edx
8010403b:	81 fa 54 3c 11 80    	cmp    $0x80113c54,%edx
80104041:	74 3b                	je     8010407e <exit+0xfe>
    if(p->parent == curproc){
80104043:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104046:	75 f0                	jne    80104038 <exit+0xb8>
      if(p->state == ZOMBIE)
80104048:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010404c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010404f:	75 e7                	jne    80104038 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104051:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104056:	eb 12                	jmp    8010406a <exit+0xea>
80104058:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405f:	90                   	nop
80104060:	83 c0 7c             	add    $0x7c,%eax
80104063:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104068:	74 ce                	je     80104038 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010406a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010406e:	75 f0                	jne    80104060 <exit+0xe0>
80104070:	3b 48 20             	cmp    0x20(%eax),%ecx
80104073:	75 eb                	jne    80104060 <exit+0xe0>
      p->state = RUNNABLE;
80104075:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010407c:	eb e2                	jmp    80104060 <exit+0xe0>
  curproc->state = ZOMBIE;
8010407e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104085:	e8 36 fe ff ff       	call   80103ec0 <sched>
  panic("zombie exit");
8010408a:	83 ec 0c             	sub    $0xc,%esp
8010408d:	68 68 79 10 80       	push   $0x80107968
80104092:	e8 e9 c2 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104097:	83 ec 0c             	sub    $0xc,%esp
8010409a:	68 5b 79 10 80       	push   $0x8010795b
8010409f:	e8 dc c2 ff ff       	call   80100380 <panic>
801040a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop

801040b0 <wait>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
  pushcli();
801040b5:	e8 86 05 00 00       	call   80104640 <pushcli>
  c = mycpu();
801040ba:	e8 11 fa ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
801040bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040c5:	e8 c6 05 00 00       	call   80104690 <popcli>
  acquire(&ptable.lock);
801040ca:	83 ec 0c             	sub    $0xc,%esp
801040cd:	68 20 1d 11 80       	push   $0x80111d20
801040d2:	e8 b9 06 00 00       	call   80104790 <acquire>
801040d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040dc:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801040e1:	eb 10                	jmp    801040f3 <wait+0x43>
801040e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e7:	90                   	nop
801040e8:	83 c3 7c             	add    $0x7c,%ebx
801040eb:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
801040f1:	74 1b                	je     8010410e <wait+0x5e>
      if(p->parent != curproc)
801040f3:	39 73 14             	cmp    %esi,0x14(%ebx)
801040f6:	75 f0                	jne    801040e8 <wait+0x38>
      if(p->state == ZOMBIE){
801040f8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040fc:	74 62                	je     80104160 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fe:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104101:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104106:	81 fb 54 3c 11 80    	cmp    $0x80113c54,%ebx
8010410c:	75 e5                	jne    801040f3 <wait+0x43>
    if(!havekids || curproc->killed){
8010410e:	85 c0                	test   %eax,%eax
80104110:	0f 84 a0 00 00 00    	je     801041b6 <wait+0x106>
80104116:	8b 46 24             	mov    0x24(%esi),%eax
80104119:	85 c0                	test   %eax,%eax
8010411b:	0f 85 95 00 00 00    	jne    801041b6 <wait+0x106>
  pushcli();
80104121:	e8 1a 05 00 00       	call   80104640 <pushcli>
  c = mycpu();
80104126:	e8 a5 f9 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
8010412b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104131:	e8 5a 05 00 00       	call   80104690 <popcli>
  if(p == 0)
80104136:	85 db                	test   %ebx,%ebx
80104138:	0f 84 8f 00 00 00    	je     801041cd <wait+0x11d>
  p->chan = chan;
8010413e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104141:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104148:	e8 73 fd ff ff       	call   80103ec0 <sched>
  p->chan = 0;
8010414d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104154:	eb 84                	jmp    801040da <wait+0x2a>
80104156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104160:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104163:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104166:	ff 73 08             	push   0x8(%ebx)
80104169:	e8 32 e5 ff ff       	call   801026a0 <kfree>
        p->kstack = 0;
8010416e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104175:	5a                   	pop    %edx
80104176:	ff 73 04             	push   0x4(%ebx)
80104179:	e8 52 2e 00 00       	call   80106fd0 <freevm>
        p->pid = 0;
8010417e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104185:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010418c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104190:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104197:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010419e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041a5:	e8 86 05 00 00       	call   80104730 <release>
        return pid;
801041aa:	83 c4 10             	add    $0x10,%esp
}
801041ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041b0:	89 f0                	mov    %esi,%eax
801041b2:	5b                   	pop    %ebx
801041b3:	5e                   	pop    %esi
801041b4:	5d                   	pop    %ebp
801041b5:	c3                   	ret    
      release(&ptable.lock);
801041b6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041be:	68 20 1d 11 80       	push   $0x80111d20
801041c3:	e8 68 05 00 00       	call   80104730 <release>
      return -1;
801041c8:	83 c4 10             	add    $0x10,%esp
801041cb:	eb e0                	jmp    801041ad <wait+0xfd>
    panic("sleep");
801041cd:	83 ec 0c             	sub    $0xc,%esp
801041d0:	68 74 79 10 80       	push   $0x80107974
801041d5:	e8 a6 c1 ff ff       	call   80100380 <panic>
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <yield>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801041e7:	68 20 1d 11 80       	push   $0x80111d20
801041ec:	e8 9f 05 00 00       	call   80104790 <acquire>
  pushcli();
801041f1:	e8 4a 04 00 00       	call   80104640 <pushcli>
  c = mycpu();
801041f6:	e8 d5 f8 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
801041fb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104201:	e8 8a 04 00 00       	call   80104690 <popcli>
  myproc()->state = RUNNABLE;
80104206:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010420d:	e8 ae fc ff ff       	call   80103ec0 <sched>
  release(&ptable.lock);
80104212:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104219:	e8 12 05 00 00       	call   80104730 <release>
}
8010421e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104221:	83 c4 10             	add    $0x10,%esp
80104224:	c9                   	leave  
80104225:	c3                   	ret    
80104226:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422d:	8d 76 00             	lea    0x0(%esi),%esi

80104230 <sleep>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	53                   	push   %ebx
80104236:	83 ec 0c             	sub    $0xc,%esp
80104239:	8b 7d 08             	mov    0x8(%ebp),%edi
8010423c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010423f:	e8 fc 03 00 00       	call   80104640 <pushcli>
  c = mycpu();
80104244:	e8 87 f8 ff ff       	call   80103ad0 <mycpu>
  p = c->proc;
80104249:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010424f:	e8 3c 04 00 00       	call   80104690 <popcli>
  if(p == 0)
80104254:	85 db                	test   %ebx,%ebx
80104256:	0f 84 87 00 00 00    	je     801042e3 <sleep+0xb3>
  if(lk == 0)
8010425c:	85 f6                	test   %esi,%esi
8010425e:	74 76                	je     801042d6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104260:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104266:	74 50                	je     801042b8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 20 1d 11 80       	push   $0x80111d20
80104270:	e8 1b 05 00 00       	call   80104790 <acquire>
    release(lk);
80104275:	89 34 24             	mov    %esi,(%esp)
80104278:	e8 b3 04 00 00       	call   80104730 <release>
  p->chan = chan;
8010427d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104280:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104287:	e8 34 fc ff ff       	call   80103ec0 <sched>
  p->chan = 0;
8010428c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104293:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010429a:	e8 91 04 00 00       	call   80104730 <release>
    acquire(lk);
8010429f:	89 75 08             	mov    %esi,0x8(%ebp)
801042a2:	83 c4 10             	add    $0x10,%esp
}
801042a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042a8:	5b                   	pop    %ebx
801042a9:	5e                   	pop    %esi
801042aa:	5f                   	pop    %edi
801042ab:	5d                   	pop    %ebp
    acquire(lk);
801042ac:	e9 df 04 00 00       	jmp    80104790 <acquire>
801042b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801042b8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042bb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042c2:	e8 f9 fb ff ff       	call   80103ec0 <sched>
  p->chan = 0;
801042c7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d1:	5b                   	pop    %ebx
801042d2:	5e                   	pop    %esi
801042d3:	5f                   	pop    %edi
801042d4:	5d                   	pop    %ebp
801042d5:	c3                   	ret    
    panic("sleep without lk");
801042d6:	83 ec 0c             	sub    $0xc,%esp
801042d9:	68 7a 79 10 80       	push   $0x8010797a
801042de:	e8 9d c0 ff ff       	call   80100380 <panic>
    panic("sleep");
801042e3:	83 ec 0c             	sub    $0xc,%esp
801042e6:	68 74 79 10 80       	push   $0x80107974
801042eb:	e8 90 c0 ff ff       	call   80100380 <panic>

801042f0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 10             	sub    $0x10,%esp
801042f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042fa:	68 20 1d 11 80       	push   $0x80111d20
801042ff:	e8 8c 04 00 00       	call   80104790 <acquire>
80104304:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104307:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010430c:	eb 0c                	jmp    8010431a <wakeup+0x2a>
8010430e:	66 90                	xchg   %ax,%ax
80104310:	83 c0 7c             	add    $0x7c,%eax
80104313:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104318:	74 1c                	je     80104336 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010431a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010431e:	75 f0                	jne    80104310 <wakeup+0x20>
80104320:	3b 58 20             	cmp    0x20(%eax),%ebx
80104323:	75 eb                	jne    80104310 <wakeup+0x20>
      p->state = RUNNABLE;
80104325:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010432c:	83 c0 7c             	add    $0x7c,%eax
8010432f:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104334:	75 e4                	jne    8010431a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104336:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010433d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104340:	c9                   	leave  
  release(&ptable.lock);
80104341:	e9 ea 03 00 00       	jmp    80104730 <release>
80104346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434d:	8d 76 00             	lea    0x0(%esi),%esi

80104350 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010435a:	68 20 1d 11 80       	push   $0x80111d20
8010435f:	e8 2c 04 00 00       	call   80104790 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104367:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010436c:	eb 0c                	jmp    8010437a <kill+0x2a>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	83 c0 7c             	add    $0x7c,%eax
80104373:	3d 54 3c 11 80       	cmp    $0x80113c54,%eax
80104378:	74 36                	je     801043b0 <kill+0x60>
    if(p->pid == pid){
8010437a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010437d:	75 f1                	jne    80104370 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010437f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104383:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010438a:	75 07                	jne    80104393 <kill+0x43>
        p->state = RUNNABLE;
8010438c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104393:	83 ec 0c             	sub    $0xc,%esp
80104396:	68 20 1d 11 80       	push   $0x80111d20
8010439b:	e8 90 03 00 00       	call   80104730 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043a3:	83 c4 10             	add    $0x10,%esp
801043a6:	31 c0                	xor    %eax,%eax
}
801043a8:	c9                   	leave  
801043a9:	c3                   	ret    
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043b0:	83 ec 0c             	sub    $0xc,%esp
801043b3:	68 20 1d 11 80       	push   $0x80111d20
801043b8:	e8 73 03 00 00       	call   80104730 <release>
}
801043bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043c0:	83 c4 10             	add    $0x10,%esp
801043c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043c8:	c9                   	leave  
801043c9:	c3                   	ret    
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	56                   	push   %esi
801043d5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043d8:	53                   	push   %ebx
801043d9:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
801043de:	83 ec 3c             	sub    $0x3c,%esp
801043e1:	eb 24                	jmp    80104407 <procdump+0x37>
801043e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	68 f7 7c 10 80       	push   $0x80107cf7
801043f0:	e8 8b c2 ff ff       	call   80100680 <cprintf>
801043f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f8:	83 c3 7c             	add    $0x7c,%ebx
801043fb:	81 fb c0 3c 11 80    	cmp    $0x80113cc0,%ebx
80104401:	0f 84 81 00 00 00    	je     80104488 <procdump+0xb8>
    if(p->state == UNUSED)
80104407:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010440a:	85 c0                	test   %eax,%eax
8010440c:	74 ea                	je     801043f8 <procdump+0x28>
      state = "???";
8010440e:	ba 8b 79 10 80       	mov    $0x8010798b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104413:	83 f8 05             	cmp    $0x5,%eax
80104416:	77 11                	ja     80104429 <procdump+0x59>
80104418:	8b 14 85 ec 79 10 80 	mov    -0x7fef8614(,%eax,4),%edx
      state = "???";
8010441f:	b8 8b 79 10 80       	mov    $0x8010798b,%eax
80104424:	85 d2                	test   %edx,%edx
80104426:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104429:	53                   	push   %ebx
8010442a:	52                   	push   %edx
8010442b:	ff 73 a4             	push   -0x5c(%ebx)
8010442e:	68 8f 79 10 80       	push   $0x8010798f
80104433:	e8 48 c2 ff ff       	call   80100680 <cprintf>
    if(p->state == SLEEPING){
80104438:	83 c4 10             	add    $0x10,%esp
8010443b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010443f:	75 a7                	jne    801043e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104441:	83 ec 08             	sub    $0x8,%esp
80104444:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104447:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010444a:	50                   	push   %eax
8010444b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010444e:	8b 40 0c             	mov    0xc(%eax),%eax
80104451:	83 c0 08             	add    $0x8,%eax
80104454:	50                   	push   %eax
80104455:	e8 86 01 00 00       	call   801045e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010445a:	83 c4 10             	add    $0x10,%esp
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
80104460:	8b 17                	mov    (%edi),%edx
80104462:	85 d2                	test   %edx,%edx
80104464:	74 82                	je     801043e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104466:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104469:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010446c:	52                   	push   %edx
8010446d:	68 e1 73 10 80       	push   $0x801073e1
80104472:	e8 09 c2 ff ff       	call   80100680 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104477:	83 c4 10             	add    $0x10,%esp
8010447a:	39 fe                	cmp    %edi,%esi
8010447c:	75 e2                	jne    80104460 <procdump+0x90>
8010447e:	e9 65 ff ff ff       	jmp    801043e8 <procdump+0x18>
80104483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104487:	90                   	nop
  }
}
80104488:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010448b:	5b                   	pop    %ebx
8010448c:	5e                   	pop    %esi
8010448d:	5f                   	pop    %edi
8010448e:	5d                   	pop    %ebp
8010448f:	c3                   	ret    

80104490 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 0c             	sub    $0xc,%esp
80104497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010449a:	68 04 7a 10 80       	push   $0x80107a04
8010449f:	8d 43 04             	lea    0x4(%ebx),%eax
801044a2:	50                   	push   %eax
801044a3:	e8 18 01 00 00       	call   801045c0 <initlock>
  lk->name = name;
801044a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801044ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c1:	c9                   	leave  
801044c2:	c3                   	ret    
801044c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
801044d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044d8:	8d 73 04             	lea    0x4(%ebx),%esi
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	56                   	push   %esi
801044df:	e8 ac 02 00 00       	call   80104790 <acquire>
  while (lk->locked) {
801044e4:	8b 13                	mov    (%ebx),%edx
801044e6:	83 c4 10             	add    $0x10,%esp
801044e9:	85 d2                	test   %edx,%edx
801044eb:	74 16                	je     80104503 <acquiresleep+0x33>
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044f0:	83 ec 08             	sub    $0x8,%esp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	e8 36 fd ff ff       	call   80104230 <sleep>
  while (lk->locked) {
801044fa:	8b 03                	mov    (%ebx),%eax
801044fc:	83 c4 10             	add    $0x10,%esp
801044ff:	85 c0                	test   %eax,%eax
80104501:	75 ed                	jne    801044f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104503:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104509:	e8 52 f6 ff ff       	call   80103b60 <myproc>
8010450e:	8b 40 10             	mov    0x10(%eax),%eax
80104511:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104514:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104517:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010451a:	5b                   	pop    %ebx
8010451b:	5e                   	pop    %esi
8010451c:	5d                   	pop    %ebp
  release(&lk->lk);
8010451d:	e9 0e 02 00 00       	jmp    80104730 <release>
80104522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104538:	8d 73 04             	lea    0x4(%ebx),%esi
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	56                   	push   %esi
8010453f:	e8 4c 02 00 00       	call   80104790 <acquire>
  lk->locked = 0;
80104544:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010454a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104551:	89 1c 24             	mov    %ebx,(%esp)
80104554:	e8 97 fd ff ff       	call   801042f0 <wakeup>
  release(&lk->lk);
80104559:	89 75 08             	mov    %esi,0x8(%ebp)
8010455c:	83 c4 10             	add    $0x10,%esp
}
8010455f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104562:	5b                   	pop    %ebx
80104563:	5e                   	pop    %esi
80104564:	5d                   	pop    %ebp
  release(&lk->lk);
80104565:	e9 c6 01 00 00       	jmp    80104730 <release>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104570 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	57                   	push   %edi
80104574:	31 ff                	xor    %edi,%edi
80104576:	56                   	push   %esi
80104577:	53                   	push   %ebx
80104578:	83 ec 18             	sub    $0x18,%esp
8010457b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010457e:	8d 73 04             	lea    0x4(%ebx),%esi
80104581:	56                   	push   %esi
80104582:	e8 09 02 00 00       	call   80104790 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104587:	8b 03                	mov    (%ebx),%eax
80104589:	83 c4 10             	add    $0x10,%esp
8010458c:	85 c0                	test   %eax,%eax
8010458e:	75 18                	jne    801045a8 <holdingsleep+0x38>
  release(&lk->lk);
80104590:	83 ec 0c             	sub    $0xc,%esp
80104593:	56                   	push   %esi
80104594:	e8 97 01 00 00       	call   80104730 <release>
  return r;
}
80104599:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010459c:	89 f8                	mov    %edi,%eax
8010459e:	5b                   	pop    %ebx
8010459f:	5e                   	pop    %esi
801045a0:	5f                   	pop    %edi
801045a1:	5d                   	pop    %ebp
801045a2:	c3                   	ret    
801045a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045a7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801045a8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045ab:	e8 b0 f5 ff ff       	call   80103b60 <myproc>
801045b0:	39 58 10             	cmp    %ebx,0x10(%eax)
801045b3:	0f 94 c0             	sete   %al
801045b6:	0f b6 c0             	movzbl %al,%eax
801045b9:	89 c7                	mov    %eax,%edi
801045bb:	eb d3                	jmp    80104590 <holdingsleep+0x20>
801045bd:	66 90                	xchg   %ax,%ax
801045bf:	90                   	nop

801045c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045d9:	5d                   	pop    %ebp
801045da:	c3                   	ret    
801045db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045df:	90                   	nop

801045e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045e1:	31 d2                	xor    %edx,%edx
{
801045e3:	89 e5                	mov    %esp,%ebp
801045e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045ec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801045ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045fc:	77 1a                	ja     80104618 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045fe:	8b 58 04             	mov    0x4(%eax),%ebx
80104601:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104604:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104607:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104609:	83 fa 0a             	cmp    $0xa,%edx
8010460c:	75 e2                	jne    801045f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010460e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104611:	c9                   	leave  
80104612:	c3                   	ret    
80104613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104617:	90                   	nop
  for(; i < 10; i++)
80104618:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010461b:	8d 51 28             	lea    0x28(%ecx),%edx
8010461e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104626:	83 c0 04             	add    $0x4,%eax
80104629:	39 d0                	cmp    %edx,%eax
8010462b:	75 f3                	jne    80104620 <getcallerpcs+0x40>
}
8010462d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104630:	c9                   	leave  
80104631:	c3                   	ret    
80104632:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104640 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	53                   	push   %ebx
80104644:	83 ec 04             	sub    $0x4,%esp
80104647:	9c                   	pushf  
80104648:	5b                   	pop    %ebx
  asm volatile("cli");
80104649:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010464a:	e8 81 f4 ff ff       	call   80103ad0 <mycpu>
8010464f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104655:	85 c0                	test   %eax,%eax
80104657:	74 17                	je     80104670 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104659:	e8 72 f4 ff ff       	call   80103ad0 <mycpu>
8010465e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104668:	c9                   	leave  
80104669:	c3                   	ret    
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104670:	e8 5b f4 ff ff       	call   80103ad0 <mycpu>
80104675:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010467b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104681:	eb d6                	jmp    80104659 <pushcli+0x19>
80104683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104690 <popcli>:

void
popcli(void)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104696:	9c                   	pushf  
80104697:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104698:	f6 c4 02             	test   $0x2,%ah
8010469b:	75 35                	jne    801046d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010469d:	e8 2e f4 ff ff       	call   80103ad0 <mycpu>
801046a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046a9:	78 34                	js     801046df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046ab:	e8 20 f4 ff ff       	call   80103ad0 <mycpu>
801046b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046b6:	85 d2                	test   %edx,%edx
801046b8:	74 06                	je     801046c0 <popcli+0x30>
    sti();
}
801046ba:	c9                   	leave  
801046bb:	c3                   	ret    
801046bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046c0:	e8 0b f4 ff ff       	call   80103ad0 <mycpu>
801046c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046cb:	85 c0                	test   %eax,%eax
801046cd:	74 eb                	je     801046ba <popcli+0x2a>
  asm volatile("sti");
801046cf:	fb                   	sti    
}
801046d0:	c9                   	leave  
801046d1:	c3                   	ret    
    panic("popcli - interruptible");
801046d2:	83 ec 0c             	sub    $0xc,%esp
801046d5:	68 0f 7a 10 80       	push   $0x80107a0f
801046da:	e8 a1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046df:	83 ec 0c             	sub    $0xc,%esp
801046e2:	68 26 7a 10 80       	push   $0x80107a26
801046e7:	e8 94 bc ff ff       	call   80100380 <panic>
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <holding>:
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	56                   	push   %esi
801046f4:	53                   	push   %ebx
801046f5:	8b 75 08             	mov    0x8(%ebp),%esi
801046f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046fa:	e8 41 ff ff ff       	call   80104640 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046ff:	8b 06                	mov    (%esi),%eax
80104701:	85 c0                	test   %eax,%eax
80104703:	75 0b                	jne    80104710 <holding+0x20>
  popcli();
80104705:	e8 86 ff ff ff       	call   80104690 <popcli>
}
8010470a:	89 d8                	mov    %ebx,%eax
8010470c:	5b                   	pop    %ebx
8010470d:	5e                   	pop    %esi
8010470e:	5d                   	pop    %ebp
8010470f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104710:	8b 5e 08             	mov    0x8(%esi),%ebx
80104713:	e8 b8 f3 ff ff       	call   80103ad0 <mycpu>
80104718:	39 c3                	cmp    %eax,%ebx
8010471a:	0f 94 c3             	sete   %bl
  popcli();
8010471d:	e8 6e ff ff ff       	call   80104690 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104722:	0f b6 db             	movzbl %bl,%ebx
}
80104725:	89 d8                	mov    %ebx,%eax
80104727:	5b                   	pop    %ebx
80104728:	5e                   	pop    %esi
80104729:	5d                   	pop    %ebp
8010472a:	c3                   	ret    
8010472b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010472f:	90                   	nop

80104730 <release>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104738:	e8 03 ff ff ff       	call   80104640 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010473d:	8b 03                	mov    (%ebx),%eax
8010473f:	85 c0                	test   %eax,%eax
80104741:	75 15                	jne    80104758 <release+0x28>
  popcli();
80104743:	e8 48 ff ff ff       	call   80104690 <popcli>
    panic("release");
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	68 2d 7a 10 80       	push   $0x80107a2d
80104750:	e8 2b bc ff ff       	call   80100380 <panic>
80104755:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104758:	8b 73 08             	mov    0x8(%ebx),%esi
8010475b:	e8 70 f3 ff ff       	call   80103ad0 <mycpu>
80104760:	39 c6                	cmp    %eax,%esi
80104762:	75 df                	jne    80104743 <release+0x13>
  popcli();
80104764:	e8 27 ff ff ff       	call   80104690 <popcli>
  lk->pcs[0] = 0;
80104769:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104770:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104777:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010477a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104780:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104783:	5b                   	pop    %ebx
80104784:	5e                   	pop    %esi
80104785:	5d                   	pop    %ebp
  popcli();
80104786:	e9 05 ff ff ff       	jmp    80104690 <popcli>
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <acquire>:
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104797:	e8 a4 fe ff ff       	call   80104640 <pushcli>
  if(holding(lk))
8010479c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010479f:	e8 9c fe ff ff       	call   80104640 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047a4:	8b 03                	mov    (%ebx),%eax
801047a6:	85 c0                	test   %eax,%eax
801047a8:	75 7e                	jne    80104828 <acquire+0x98>
  popcli();
801047aa:	e8 e1 fe ff ff       	call   80104690 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047af:	b9 01 00 00 00       	mov    $0x1,%ecx
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801047b8:	8b 55 08             	mov    0x8(%ebp),%edx
801047bb:	89 c8                	mov    %ecx,%eax
801047bd:	f0 87 02             	lock xchg %eax,(%edx)
801047c0:	85 c0                	test   %eax,%eax
801047c2:	75 f4                	jne    801047b8 <acquire+0x28>
  __sync_synchronize();
801047c4:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801047c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047ca:	e8 01 f3 ff ff       	call   80103ad0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801047d2:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801047d4:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801047d7:	31 c0                	xor    %eax,%eax
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047ec:	77 1a                	ja     80104808 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801047ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801047f1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801047f5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801047f8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801047fa:	83 f8 0a             	cmp    $0xa,%eax
801047fd:	75 e1                	jne    801047e0 <acquire+0x50>
}
801047ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104802:	c9                   	leave  
80104803:	c3                   	ret    
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104808:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010480c:	8d 51 34             	lea    0x34(%ecx),%edx
8010480f:	90                   	nop
    pcs[i] = 0;
80104810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104816:	83 c0 04             	add    $0x4,%eax
80104819:	39 c2                	cmp    %eax,%edx
8010481b:	75 f3                	jne    80104810 <acquire+0x80>
}
8010481d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104820:	c9                   	leave  
80104821:	c3                   	ret    
80104822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104828:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010482b:	e8 a0 f2 ff ff       	call   80103ad0 <mycpu>
80104830:	39 c3                	cmp    %eax,%ebx
80104832:	0f 85 72 ff ff ff    	jne    801047aa <acquire+0x1a>
  popcli();
80104838:	e8 53 fe ff ff       	call   80104690 <popcli>
    panic("acquire");
8010483d:	83 ec 0c             	sub    $0xc,%esp
80104840:	68 35 7a 10 80       	push   $0x80107a35
80104845:	e8 36 bb ff ff       	call   80100380 <panic>
8010484a:	66 90                	xchg   %ax,%ax
8010484c:	66 90                	xchg   %ax,%ax
8010484e:	66 90                	xchg   %ax,%ax

80104850 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	8b 55 08             	mov    0x8(%ebp),%edx
80104857:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010485a:	53                   	push   %ebx
8010485b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010485e:	89 d7                	mov    %edx,%edi
80104860:	09 cf                	or     %ecx,%edi
80104862:	83 e7 03             	and    $0x3,%edi
80104865:	75 29                	jne    80104890 <memset+0x40>
    c &= 0xFF;
80104867:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010486a:	c1 e0 18             	shl    $0x18,%eax
8010486d:	89 fb                	mov    %edi,%ebx
8010486f:	c1 e9 02             	shr    $0x2,%ecx
80104872:	c1 e3 10             	shl    $0x10,%ebx
80104875:	09 d8                	or     %ebx,%eax
80104877:	09 f8                	or     %edi,%eax
80104879:	c1 e7 08             	shl    $0x8,%edi
8010487c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010487e:	89 d7                	mov    %edx,%edi
80104880:	fc                   	cld    
80104881:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104883:	5b                   	pop    %ebx
80104884:	89 d0                	mov    %edx,%eax
80104886:	5f                   	pop    %edi
80104887:	5d                   	pop    %ebp
80104888:	c3                   	ret    
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104890:	89 d7                	mov    %edx,%edi
80104892:	fc                   	cld    
80104893:	f3 aa                	rep stos %al,%es:(%edi)
80104895:	5b                   	pop    %ebx
80104896:	89 d0                	mov    %edx,%eax
80104898:	5f                   	pop    %edi
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    
8010489b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop

801048a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	8b 75 10             	mov    0x10(%ebp),%esi
801048a7:	8b 55 08             	mov    0x8(%ebp),%edx
801048aa:	53                   	push   %ebx
801048ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ae:	85 f6                	test   %esi,%esi
801048b0:	74 2e                	je     801048e0 <memcmp+0x40>
801048b2:	01 c6                	add    %eax,%esi
801048b4:	eb 14                	jmp    801048ca <memcmp+0x2a>
801048b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048c6:	39 f0                	cmp    %esi,%eax
801048c8:	74 16                	je     801048e0 <memcmp+0x40>
    if(*s1 != *s2)
801048ca:	0f b6 0a             	movzbl (%edx),%ecx
801048cd:	0f b6 18             	movzbl (%eax),%ebx
801048d0:	38 d9                	cmp    %bl,%cl
801048d2:	74 ec                	je     801048c0 <memcmp+0x20>
      return *s1 - *s2;
801048d4:	0f b6 c1             	movzbl %cl,%eax
801048d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	5b                   	pop    %ebx
  return 0;
801048e1:	31 c0                	xor    %eax,%eax
}
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	8b 55 08             	mov    0x8(%ebp),%edx
801048f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048fa:	56                   	push   %esi
801048fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048fe:	39 d6                	cmp    %edx,%esi
80104900:	73 26                	jae    80104928 <memmove+0x38>
80104902:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104905:	39 fa                	cmp    %edi,%edx
80104907:	73 1f                	jae    80104928 <memmove+0x38>
80104909:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010490c:	85 c9                	test   %ecx,%ecx
8010490e:	74 0c                	je     8010491c <memmove+0x2c>
      *--d = *--s;
80104910:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104914:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104917:	83 e8 01             	sub    $0x1,%eax
8010491a:	73 f4                	jae    80104910 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010491c:	5e                   	pop    %esi
8010491d:	89 d0                	mov    %edx,%eax
8010491f:	5f                   	pop    %edi
80104920:	5d                   	pop    %ebp
80104921:	c3                   	ret    
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104928:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010492b:	89 d7                	mov    %edx,%edi
8010492d:	85 c9                	test   %ecx,%ecx
8010492f:	74 eb                	je     8010491c <memmove+0x2c>
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104938:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104939:	39 f0                	cmp    %esi,%eax
8010493b:	75 fb                	jne    80104938 <memmove+0x48>
}
8010493d:	5e                   	pop    %esi
8010493e:	89 d0                	mov    %edx,%eax
80104940:	5f                   	pop    %edi
80104941:	5d                   	pop    %ebp
80104942:	c3                   	ret    
80104943:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104950:	eb 9e                	jmp    801048f0 <memmove>
80104952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104960 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	8b 75 10             	mov    0x10(%ebp),%esi
80104967:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010496a:	53                   	push   %ebx
8010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
8010496e:	85 f6                	test   %esi,%esi
80104970:	74 36                	je     801049a8 <strncmp+0x48>
80104972:	01 c6                	add    %eax,%esi
80104974:	eb 18                	jmp    8010498e <strncmp+0x2e>
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
80104980:	38 da                	cmp    %bl,%dl
80104982:	75 14                	jne    80104998 <strncmp+0x38>
    n--, p++, q++;
80104984:	83 c0 01             	add    $0x1,%eax
80104987:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010498a:	39 f0                	cmp    %esi,%eax
8010498c:	74 1a                	je     801049a8 <strncmp+0x48>
8010498e:	0f b6 11             	movzbl (%ecx),%edx
80104991:	0f b6 18             	movzbl (%eax),%ebx
80104994:	84 d2                	test   %dl,%dl
80104996:	75 e8                	jne    80104980 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104998:	0f b6 c2             	movzbl %dl,%eax
8010499b:	29 d8                	sub    %ebx,%eax
}
8010499d:	5b                   	pop    %ebx
8010499e:	5e                   	pop    %esi
8010499f:	5d                   	pop    %ebp
801049a0:	c3                   	ret    
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	5b                   	pop    %ebx
    return 0;
801049a9:	31 c0                	xor    %eax,%eax
}
801049ab:	5e                   	pop    %esi
801049ac:	5d                   	pop    %ebp
801049ad:	c3                   	ret    
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	57                   	push   %edi
801049b4:	56                   	push   %esi
801049b5:	8b 75 08             	mov    0x8(%ebp),%esi
801049b8:	53                   	push   %ebx
801049b9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049bc:	89 f2                	mov    %esi,%edx
801049be:	eb 17                	jmp    801049d7 <strncpy+0x27>
801049c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049c7:	83 c2 01             	add    $0x1,%edx
801049ca:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801049ce:	89 f9                	mov    %edi,%ecx
801049d0:	88 4a ff             	mov    %cl,-0x1(%edx)
801049d3:	84 c9                	test   %cl,%cl
801049d5:	74 09                	je     801049e0 <strncpy+0x30>
801049d7:	89 c3                	mov    %eax,%ebx
801049d9:	83 e8 01             	sub    $0x1,%eax
801049dc:	85 db                	test   %ebx,%ebx
801049de:	7f e0                	jg     801049c0 <strncpy+0x10>
    ;
  while(n-- > 0)
801049e0:	89 d1                	mov    %edx,%ecx
801049e2:	85 c0                	test   %eax,%eax
801049e4:	7e 1d                	jle    80104a03 <strncpy+0x53>
801049e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
801049f0:	83 c1 01             	add    $0x1,%ecx
801049f3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801049f7:	89 c8                	mov    %ecx,%eax
801049f9:	f7 d0                	not    %eax
801049fb:	01 d0                	add    %edx,%eax
801049fd:	01 d8                	add    %ebx,%eax
801049ff:	85 c0                	test   %eax,%eax
80104a01:	7f ed                	jg     801049f0 <strncpy+0x40>
  return os;
}
80104a03:	5b                   	pop    %ebx
80104a04:	89 f0                	mov    %esi,%eax
80104a06:	5e                   	pop    %esi
80104a07:	5f                   	pop    %edi
80104a08:	5d                   	pop    %ebp
80104a09:	c3                   	ret    
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	8b 55 10             	mov    0x10(%ebp),%edx
80104a17:	8b 75 08             	mov    0x8(%ebp),%esi
80104a1a:	53                   	push   %ebx
80104a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a1e:	85 d2                	test   %edx,%edx
80104a20:	7e 25                	jle    80104a47 <safestrcpy+0x37>
80104a22:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a26:	89 f2                	mov    %esi,%edx
80104a28:	eb 16                	jmp    80104a40 <safestrcpy+0x30>
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a30:	0f b6 08             	movzbl (%eax),%ecx
80104a33:	83 c0 01             	add    $0x1,%eax
80104a36:	83 c2 01             	add    $0x1,%edx
80104a39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a3c:	84 c9                	test   %cl,%cl
80104a3e:	74 04                	je     80104a44 <safestrcpy+0x34>
80104a40:	39 d8                	cmp    %ebx,%eax
80104a42:	75 ec                	jne    80104a30 <safestrcpy+0x20>
    ;
  *s = 0;
80104a44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a47:	89 f0                	mov    %esi,%eax
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret    
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi

80104a50 <strlen>:

int
strlen(const char *s)
{
80104a50:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a51:	31 c0                	xor    %eax,%eax
{
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a58:	80 3a 00             	cmpb   $0x0,(%edx)
80104a5b:	74 0c                	je     80104a69 <strlen+0x19>
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
80104a60:	83 c0 01             	add    $0x1,%eax
80104a63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a67:	75 f7                	jne    80104a60 <strlen+0x10>
    ;
  return n;
}
80104a69:	5d                   	pop    %ebp
80104a6a:	c3                   	ret    

80104a6b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a6b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a6f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a73:	55                   	push   %ebp
  pushl %ebx
80104a74:	53                   	push   %ebx
  pushl %esi
80104a75:	56                   	push   %esi
  pushl %edi
80104a76:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a77:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a79:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a7b:	5f                   	pop    %edi
  popl %esi
80104a7c:	5e                   	pop    %esi
  popl %ebx
80104a7d:	5b                   	pop    %ebx
  popl %ebp
80104a7e:	5d                   	pop    %ebp
  ret
80104a7f:	c3                   	ret    

80104a80 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
80104a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a8a:	e8 d1 f0 ff ff       	call   80103b60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a8f:	8b 00                	mov    (%eax),%eax
80104a91:	39 d8                	cmp    %ebx,%eax
80104a93:	76 1b                	jbe    80104ab0 <fetchint+0x30>
80104a95:	8d 53 04             	lea    0x4(%ebx),%edx
80104a98:	39 d0                	cmp    %edx,%eax
80104a9a:	72 14                	jb     80104ab0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a9f:	8b 13                	mov    (%ebx),%edx
80104aa1:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa3:	31 c0                	xor    %eax,%eax
}
80104aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa8:	c9                   	leave  
80104aa9:	c3                   	ret    
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ab5:	eb ee                	jmp    80104aa5 <fetchint+0x25>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aca:	e8 91 f0 ff ff       	call   80103b60 <myproc>

  if(addr >= curproc->sz)
80104acf:	39 18                	cmp    %ebx,(%eax)
80104ad1:	76 2d                	jbe    80104b00 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ad6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104ad8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104ada:	39 d3                	cmp    %edx,%ebx
80104adc:	73 22                	jae    80104b00 <fetchstr+0x40>
80104ade:	89 d8                	mov    %ebx,%eax
80104ae0:	eb 0d                	jmp    80104aef <fetchstr+0x2f>
80104ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ae8:	83 c0 01             	add    $0x1,%eax
80104aeb:	39 c2                	cmp    %eax,%edx
80104aed:	76 11                	jbe    80104b00 <fetchstr+0x40>
    if(*s == 0)
80104aef:	80 38 00             	cmpb   $0x0,(%eax)
80104af2:	75 f4                	jne    80104ae8 <fetchstr+0x28>
      return s - *pp;
80104af4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104af6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af9:	c9                   	leave  
80104afa:	c3                   	ret    
80104afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop
80104b00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b08:	c9                   	leave  
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	e8 46 f0 ff ff       	call   80103b60 <myproc>
80104b1a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b1d:	8b 40 18             	mov    0x18(%eax),%eax
80104b20:	8b 40 44             	mov    0x44(%eax),%eax
80104b23:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b26:	e8 35 f0 ff ff       	call   80103b60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b2b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b2e:	8b 00                	mov    (%eax),%eax
80104b30:	39 c6                	cmp    %eax,%esi
80104b32:	73 1c                	jae    80104b50 <argint+0x40>
80104b34:	8d 53 08             	lea    0x8(%ebx),%edx
80104b37:	39 d0                	cmp    %edx,%eax
80104b39:	72 15                	jb     80104b50 <argint+0x40>
  *ip = *(int*)(addr);
80104b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b3e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b41:	89 10                	mov    %edx,(%eax)
  return 0;
80104b43:	31 c0                	xor    %eax,%eax
}
80104b45:	5b                   	pop    %ebx
80104b46:	5e                   	pop    %esi
80104b47:	5d                   	pop    %ebp
80104b48:	c3                   	ret    
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b55:	eb ee                	jmp    80104b45 <argint+0x35>
80104b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	56                   	push   %esi
80104b65:	53                   	push   %ebx
80104b66:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b69:	e8 f2 ef ff ff       	call   80103b60 <myproc>
80104b6e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b70:	e8 eb ef ff ff       	call   80103b60 <myproc>
80104b75:	8b 55 08             	mov    0x8(%ebp),%edx
80104b78:	8b 40 18             	mov    0x18(%eax),%eax
80104b7b:	8b 40 44             	mov    0x44(%eax),%eax
80104b7e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b81:	e8 da ef ff ff       	call   80103b60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b86:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b89:	8b 00                	mov    (%eax),%eax
80104b8b:	39 c7                	cmp    %eax,%edi
80104b8d:	73 31                	jae    80104bc0 <argptr+0x60>
80104b8f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b92:	39 c8                	cmp    %ecx,%eax
80104b94:	72 2a                	jb     80104bc0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b96:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b99:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b9c:	85 d2                	test   %edx,%edx
80104b9e:	78 20                	js     80104bc0 <argptr+0x60>
80104ba0:	8b 16                	mov    (%esi),%edx
80104ba2:	39 c2                	cmp    %eax,%edx
80104ba4:	76 1a                	jbe    80104bc0 <argptr+0x60>
80104ba6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ba9:	01 c3                	add    %eax,%ebx
80104bab:	39 da                	cmp    %ebx,%edx
80104bad:	72 11                	jb     80104bc0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104baf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bb2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bb4:	31 c0                	xor    %eax,%eax
}
80104bb6:	83 c4 0c             	add    $0xc,%esp
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5f                   	pop    %edi
80104bbc:	5d                   	pop    %ebp
80104bbd:	c3                   	ret    
80104bbe:	66 90                	xchg   %ax,%ax
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ef                	jmp    80104bb6 <argptr+0x56>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	e8 86 ef ff ff       	call   80103b60 <myproc>
80104bda:	8b 55 08             	mov    0x8(%ebp),%edx
80104bdd:	8b 40 18             	mov    0x18(%eax),%eax
80104be0:	8b 40 44             	mov    0x44(%eax),%eax
80104be3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be6:	e8 75 ef ff ff       	call   80103b60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104beb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bee:	8b 00                	mov    (%eax),%eax
80104bf0:	39 c6                	cmp    %eax,%esi
80104bf2:	73 44                	jae    80104c38 <argstr+0x68>
80104bf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bf7:	39 d0                	cmp    %edx,%eax
80104bf9:	72 3d                	jb     80104c38 <argstr+0x68>
  *ip = *(int*)(addr);
80104bfb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bfe:	e8 5d ef ff ff       	call   80103b60 <myproc>
  if(addr >= curproc->sz)
80104c03:	3b 18                	cmp    (%eax),%ebx
80104c05:	73 31                	jae    80104c38 <argstr+0x68>
  *pp = (char*)addr;
80104c07:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c0a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c0c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c0e:	39 d3                	cmp    %edx,%ebx
80104c10:	73 26                	jae    80104c38 <argstr+0x68>
80104c12:	89 d8                	mov    %ebx,%eax
80104c14:	eb 11                	jmp    80104c27 <argstr+0x57>
80104c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
80104c20:	83 c0 01             	add    $0x1,%eax
80104c23:	39 c2                	cmp    %eax,%edx
80104c25:	76 11                	jbe    80104c38 <argstr+0x68>
    if(*s == 0)
80104c27:	80 38 00             	cmpb   $0x0,(%eax)
80104c2a:	75 f4                	jne    80104c20 <argstr+0x50>
      return s - *pp;
80104c2c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c2e:	5b                   	pop    %ebx
80104c2f:	5e                   	pop    %esi
80104c30:	5d                   	pop    %ebp
80104c31:	c3                   	ret    
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c38:	5b                   	pop    %ebx
    return -1;
80104c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c3e:	5e                   	pop    %esi
80104c3f:	5d                   	pop    %ebp
80104c40:	c3                   	ret    
80104c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4f:	90                   	nop

80104c50 <syscall>:
// [SYS_close]   "close",
// };

void
syscall(void)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c57:	e8 04 ef ff ff       	call   80103b60 <myproc>
80104c5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c5e:	8b 40 18             	mov    0x18(%eax),%eax
80104c61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c67:	83 fa 14             	cmp    $0x14,%edx
80104c6a:	77 24                	ja     80104c90 <syscall+0x40>
80104c6c:	8b 14 85 60 7a 10 80 	mov    -0x7fef85a0(,%eax,4),%edx
80104c73:	85 d2                	test   %edx,%edx
80104c75:	74 19                	je     80104c90 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c77:	ff d2                	call   *%edx
80104c79:	89 c2                	mov    %eax,%edx
80104c7b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c7e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c84:	c9                   	leave  
80104c85:	c3                   	ret    
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c90:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c91:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c94:	50                   	push   %eax
80104c95:	ff 73 10             	push   0x10(%ebx)
80104c98:	68 3d 7a 10 80       	push   $0x80107a3d
80104c9d:	e8 de b9 ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
80104ca2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ca5:	83 c4 10             	add    $0x10,%esp
80104ca8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb2:	c9                   	leave  
80104cb3:	c3                   	ret    
80104cb4:	66 90                	xchg   %ax,%ax
80104cb6:	66 90                	xchg   %ax,%ax
80104cb8:	66 90                	xchg   %ax,%ax
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cc5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104cc8:	53                   	push   %ebx
80104cc9:	83 ec 34             	sub    $0x34,%esp
80104ccc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ccf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cd2:	57                   	push   %edi
80104cd3:	50                   	push   %eax
{
80104cd4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cd7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cda:	e8 c1 d5 ff ff       	call   801022a0 <nameiparent>
80104cdf:	83 c4 10             	add    $0x10,%esp
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	0f 84 46 01 00 00    	je     80104e30 <create+0x170>
    return 0;
  ilock(dp);
80104cea:	83 ec 0c             	sub    $0xc,%esp
80104ced:	89 c3                	mov    %eax,%ebx
80104cef:	50                   	push   %eax
80104cf0:	e8 6b cc ff ff       	call   80101960 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cf5:	83 c4 0c             	add    $0xc,%esp
80104cf8:	6a 00                	push   $0x0
80104cfa:	57                   	push   %edi
80104cfb:	53                   	push   %ebx
80104cfc:	e8 bf d1 ff ff       	call   80101ec0 <dirlookup>
80104d01:	83 c4 10             	add    $0x10,%esp
80104d04:	89 c6                	mov    %eax,%esi
80104d06:	85 c0                	test   %eax,%eax
80104d08:	74 56                	je     80104d60 <create+0xa0>
    iunlockput(dp);
80104d0a:	83 ec 0c             	sub    $0xc,%esp
80104d0d:	53                   	push   %ebx
80104d0e:	e8 dd ce ff ff       	call   80101bf0 <iunlockput>
    ilock(ip);
80104d13:	89 34 24             	mov    %esi,(%esp)
80104d16:	e8 45 cc ff ff       	call   80101960 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d1b:	83 c4 10             	add    $0x10,%esp
80104d1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d23:	75 1b                	jne    80104d40 <create+0x80>
80104d25:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d2a:	75 14                	jne    80104d40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d2f:	89 f0                	mov    %esi,%eax
80104d31:	5b                   	pop    %ebx
80104d32:	5e                   	pop    %esi
80104d33:	5f                   	pop    %edi
80104d34:	5d                   	pop    %ebp
80104d35:	c3                   	ret    
80104d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d40:	83 ec 0c             	sub    $0xc,%esp
80104d43:	56                   	push   %esi
    return 0;
80104d44:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d46:	e8 a5 ce ff ff       	call   80101bf0 <iunlockput>
    return 0;
80104d4b:	83 c4 10             	add    $0x10,%esp
}
80104d4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d51:	89 f0                	mov    %esi,%eax
80104d53:	5b                   	pop    %ebx
80104d54:	5e                   	pop    %esi
80104d55:	5f                   	pop    %edi
80104d56:	5d                   	pop    %ebp
80104d57:	c3                   	ret    
80104d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d64:	83 ec 08             	sub    $0x8,%esp
80104d67:	50                   	push   %eax
80104d68:	ff 33                	push   (%ebx)
80104d6a:	e8 81 ca ff ff       	call   801017f0 <ialloc>
80104d6f:	83 c4 10             	add    $0x10,%esp
80104d72:	89 c6                	mov    %eax,%esi
80104d74:	85 c0                	test   %eax,%eax
80104d76:	0f 84 cd 00 00 00    	je     80104e49 <create+0x189>
  ilock(ip);
80104d7c:	83 ec 0c             	sub    $0xc,%esp
80104d7f:	50                   	push   %eax
80104d80:	e8 db cb ff ff       	call   80101960 <ilock>
  ip->major = major;
80104d85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d95:	b8 01 00 00 00       	mov    $0x1,%eax
80104d9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d9e:	89 34 24             	mov    %esi,(%esp)
80104da1:	e8 0a cb ff ff       	call   801018b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104da6:	83 c4 10             	add    $0x10,%esp
80104da9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dae:	74 30                	je     80104de0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104db0:	83 ec 04             	sub    $0x4,%esp
80104db3:	ff 76 04             	push   0x4(%esi)
80104db6:	57                   	push   %edi
80104db7:	53                   	push   %ebx
80104db8:	e8 03 d4 ff ff       	call   801021c0 <dirlink>
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 78                	js     80104e3c <create+0x17c>
  iunlockput(dp);
80104dc4:	83 ec 0c             	sub    $0xc,%esp
80104dc7:	53                   	push   %ebx
80104dc8:	e8 23 ce ff ff       	call   80101bf0 <iunlockput>
  return ip;
80104dcd:	83 c4 10             	add    $0x10,%esp
}
80104dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dd3:	89 f0                	mov    %esi,%eax
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5f                   	pop    %edi
80104dd8:	5d                   	pop    %ebp
80104dd9:	c3                   	ret    
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104de0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104de3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104de8:	53                   	push   %ebx
80104de9:	e8 c2 ca ff ff       	call   801018b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dee:	83 c4 0c             	add    $0xc,%esp
80104df1:	ff 76 04             	push   0x4(%esi)
80104df4:	68 d4 7a 10 80       	push   $0x80107ad4
80104df9:	56                   	push   %esi
80104dfa:	e8 c1 d3 ff ff       	call   801021c0 <dirlink>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	85 c0                	test   %eax,%eax
80104e04:	78 18                	js     80104e1e <create+0x15e>
80104e06:	83 ec 04             	sub    $0x4,%esp
80104e09:	ff 73 04             	push   0x4(%ebx)
80104e0c:	68 d3 7a 10 80       	push   $0x80107ad3
80104e11:	56                   	push   %esi
80104e12:	e8 a9 d3 ff ff       	call   801021c0 <dirlink>
80104e17:	83 c4 10             	add    $0x10,%esp
80104e1a:	85 c0                	test   %eax,%eax
80104e1c:	79 92                	jns    80104db0 <create+0xf0>
      panic("create dots");
80104e1e:	83 ec 0c             	sub    $0xc,%esp
80104e21:	68 c7 7a 10 80       	push   $0x80107ac7
80104e26:	e8 55 b5 ff ff       	call   80100380 <panic>
80104e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
}
80104e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e33:	31 f6                	xor    %esi,%esi
}
80104e35:	5b                   	pop    %ebx
80104e36:	89 f0                	mov    %esi,%eax
80104e38:	5e                   	pop    %esi
80104e39:	5f                   	pop    %edi
80104e3a:	5d                   	pop    %ebp
80104e3b:	c3                   	ret    
    panic("create: dirlink");
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	68 d6 7a 10 80       	push   $0x80107ad6
80104e44:	e8 37 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e49:	83 ec 0c             	sub    $0xc,%esp
80104e4c:	68 b8 7a 10 80       	push   $0x80107ab8
80104e51:	e8 2a b5 ff ff       	call   80100380 <panic>
80104e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi

80104e60 <sys_dup>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6b:	50                   	push   %eax
80104e6c:	6a 00                	push   $0x0
80104e6e:	e8 9d fc ff ff       	call   80104b10 <argint>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 36                	js     80104eb0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e7e:	77 30                	ja     80104eb0 <sys_dup+0x50>
80104e80:	e8 db ec ff ff       	call   80103b60 <myproc>
80104e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e8c:	85 f6                	test   %esi,%esi
80104e8e:	74 20                	je     80104eb0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e90:	e8 cb ec ff ff       	call   80103b60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e95:	31 db                	xor    %ebx,%ebx
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104ea0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ea4:	85 d2                	test   %edx,%edx
80104ea6:	74 18                	je     80104ec0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ea8:	83 c3 01             	add    $0x1,%ebx
80104eab:	83 fb 10             	cmp    $0x10,%ebx
80104eae:	75 f0                	jne    80104ea0 <sys_dup+0x40>
}
80104eb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104eb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104eb8:	89 d8                	mov    %ebx,%eax
80104eba:	5b                   	pop    %ebx
80104ebb:	5e                   	pop    %esi
80104ebc:	5d                   	pop    %ebp
80104ebd:	c3                   	ret    
80104ebe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ec3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ec7:	56                   	push   %esi
80104ec8:	e8 c3 c1 ff ff       	call   80101090 <filedup>
  return fd;
80104ecd:	83 c4 10             	add    $0x10,%esp
}
80104ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed3:	89 d8                	mov    %ebx,%eax
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <sys_read>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ee5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eeb:	53                   	push   %ebx
80104eec:	6a 00                	push   $0x0
80104eee:	e8 1d fc ff ff       	call   80104b10 <argint>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 5e                	js     80104f58 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104efe:	77 58                	ja     80104f58 <sys_read+0x78>
80104f00:	e8 5b ec ff ff       	call   80103b60 <myproc>
80104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f0c:	85 f6                	test   %esi,%esi
80104f0e:	74 48                	je     80104f58 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f10:	83 ec 08             	sub    $0x8,%esp
80104f13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f16:	50                   	push   %eax
80104f17:	6a 02                	push   $0x2
80104f19:	e8 f2 fb ff ff       	call   80104b10 <argint>
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	85 c0                	test   %eax,%eax
80104f23:	78 33                	js     80104f58 <sys_read+0x78>
80104f25:	83 ec 04             	sub    $0x4,%esp
80104f28:	ff 75 f0             	push   -0x10(%ebp)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 01                	push   $0x1
80104f2e:	e8 2d fc ff ff       	call   80104b60 <argptr>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 1e                	js     80104f58 <sys_read+0x78>
  return fileread(f, p, n);
80104f3a:	83 ec 04             	sub    $0x4,%esp
80104f3d:	ff 75 f0             	push   -0x10(%ebp)
80104f40:	ff 75 f4             	push   -0xc(%ebp)
80104f43:	56                   	push   %esi
80104f44:	e8 c7 c2 ff ff       	call   80101210 <fileread>
80104f49:	83 c4 10             	add    $0x10,%esp
}
80104f4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f4f:	5b                   	pop    %ebx
80104f50:	5e                   	pop    %esi
80104f51:	5d                   	pop    %ebp
80104f52:	c3                   	ret    
80104f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f57:	90                   	nop
    return -1;
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f5d:	eb ed                	jmp    80104f4c <sys_read+0x6c>
80104f5f:	90                   	nop

80104f60 <sys_write>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 00                	push   $0x0
80104f6e:	e8 9d fb ff ff       	call   80104b10 <argint>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 5e                	js     80104fd8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f7e:	77 58                	ja     80104fd8 <sys_write+0x78>
80104f80:	e8 db eb ff ff       	call   80103b60 <myproc>
80104f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f8c:	85 f6                	test   %esi,%esi
80104f8e:	74 48                	je     80104fd8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f90:	83 ec 08             	sub    $0x8,%esp
80104f93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f96:	50                   	push   %eax
80104f97:	6a 02                	push   $0x2
80104f99:	e8 72 fb ff ff       	call   80104b10 <argint>
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	78 33                	js     80104fd8 <sys_write+0x78>
80104fa5:	83 ec 04             	sub    $0x4,%esp
80104fa8:	ff 75 f0             	push   -0x10(%ebp)
80104fab:	53                   	push   %ebx
80104fac:	6a 01                	push   $0x1
80104fae:	e8 ad fb ff ff       	call   80104b60 <argptr>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 1e                	js     80104fd8 <sys_write+0x78>
  return filewrite(f, p, n);
80104fba:	83 ec 04             	sub    $0x4,%esp
80104fbd:	ff 75 f0             	push   -0x10(%ebp)
80104fc0:	ff 75 f4             	push   -0xc(%ebp)
80104fc3:	56                   	push   %esi
80104fc4:	e8 d7 c2 ff ff       	call   801012a0 <filewrite>
80104fc9:	83 c4 10             	add    $0x10,%esp
}
80104fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fcf:	5b                   	pop    %ebx
80104fd0:	5e                   	pop    %esi
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret    
80104fd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fd7:	90                   	nop
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ed                	jmp    80104fcc <sys_write+0x6c>
80104fdf:	90                   	nop

80104fe0 <sys_close>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	50                   	push   %eax
80104fec:	6a 00                	push   $0x0
80104fee:	e8 1d fb ff ff       	call   80104b10 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 3e                	js     80105038 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 38                	ja     80105038 <sys_close+0x58>
80105000:	e8 5b eb ff ff       	call   80103b60 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8d 5a 08             	lea    0x8(%edx),%ebx
8010500b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010500f:	85 f6                	test   %esi,%esi
80105011:	74 25                	je     80105038 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105013:	e8 48 eb ff ff       	call   80103b60 <myproc>
  fileclose(f);
80105018:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010501b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105022:	00 
  fileclose(f);
80105023:	56                   	push   %esi
80105024:	e8 b7 c0 ff ff       	call   801010e0 <fileclose>
  return 0;
80105029:	83 c4 10             	add    $0x10,%esp
8010502c:	31 c0                	xor    %eax,%eax
}
8010502e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105031:	5b                   	pop    %ebx
80105032:	5e                   	pop    %esi
80105033:	5d                   	pop    %ebp
80105034:	c3                   	ret    
80105035:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503d:	eb ef                	jmp    8010502e <sys_close+0x4e>
8010503f:	90                   	nop

80105040 <sys_fstat>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105045:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105048:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504b:	53                   	push   %ebx
8010504c:	6a 00                	push   $0x0
8010504e:	e8 bd fa ff ff       	call   80104b10 <argint>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	78 46                	js     801050a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010505e:	77 40                	ja     801050a0 <sys_fstat+0x60>
80105060:	e8 fb ea ff ff       	call   80103b60 <myproc>
80105065:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105068:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010506c:	85 f6                	test   %esi,%esi
8010506e:	74 30                	je     801050a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105070:	83 ec 04             	sub    $0x4,%esp
80105073:	6a 14                	push   $0x14
80105075:	53                   	push   %ebx
80105076:	6a 01                	push   $0x1
80105078:	e8 e3 fa ff ff       	call   80104b60 <argptr>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	78 1c                	js     801050a0 <sys_fstat+0x60>
  return filestat(f, st);
80105084:	83 ec 08             	sub    $0x8,%esp
80105087:	ff 75 f4             	push   -0xc(%ebp)
8010508a:	56                   	push   %esi
8010508b:	e8 30 c1 ff ff       	call   801011c0 <filestat>
80105090:	83 c4 10             	add    $0x10,%esp
}
80105093:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105096:	5b                   	pop    %ebx
80105097:	5e                   	pop    %esi
80105098:	5d                   	pop    %ebp
80105099:	c3                   	ret    
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb ec                	jmp    80105093 <sys_fstat+0x53>
801050a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <sys_link>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050b8:	53                   	push   %ebx
801050b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050bc:	50                   	push   %eax
801050bd:	6a 00                	push   $0x0
801050bf:	e8 0c fb ff ff       	call   80104bd0 <argstr>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	0f 88 fb 00 00 00    	js     801051ca <sys_link+0x11a>
801050cf:	83 ec 08             	sub    $0x8,%esp
801050d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050d5:	50                   	push   %eax
801050d6:	6a 01                	push   $0x1
801050d8:	e8 f3 fa ff ff       	call   80104bd0 <argstr>
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	85 c0                	test   %eax,%eax
801050e2:	0f 88 e2 00 00 00    	js     801051ca <sys_link+0x11a>
  begin_op();
801050e8:	e8 53 de ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
801050ed:	83 ec 0c             	sub    $0xc,%esp
801050f0:	ff 75 d4             	push   -0x2c(%ebp)
801050f3:	e8 88 d1 ff ff       	call   80102280 <namei>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	89 c3                	mov    %eax,%ebx
801050fd:	85 c0                	test   %eax,%eax
801050ff:	0f 84 e4 00 00 00    	je     801051e9 <sys_link+0x139>
  ilock(ip);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	50                   	push   %eax
80105109:	e8 52 c8 ff ff       	call   80101960 <ilock>
  if(ip->type == T_DIR){
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105116:	0f 84 b5 00 00 00    	je     801051d1 <sys_link+0x121>
  iupdate(ip);
8010511c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010511f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105124:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105127:	53                   	push   %ebx
80105128:	e8 83 c7 ff ff       	call   801018b0 <iupdate>
  iunlock(ip);
8010512d:	89 1c 24             	mov    %ebx,(%esp)
80105130:	e8 0b c9 ff ff       	call   80101a40 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105135:	58                   	pop    %eax
80105136:	5a                   	pop    %edx
80105137:	57                   	push   %edi
80105138:	ff 75 d0             	push   -0x30(%ebp)
8010513b:	e8 60 d1 ff ff       	call   801022a0 <nameiparent>
80105140:	83 c4 10             	add    $0x10,%esp
80105143:	89 c6                	mov    %eax,%esi
80105145:	85 c0                	test   %eax,%eax
80105147:	74 5b                	je     801051a4 <sys_link+0xf4>
  ilock(dp);
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	50                   	push   %eax
8010514d:	e8 0e c8 ff ff       	call   80101960 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105152:	8b 03                	mov    (%ebx),%eax
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	39 06                	cmp    %eax,(%esi)
80105159:	75 3d                	jne    80105198 <sys_link+0xe8>
8010515b:	83 ec 04             	sub    $0x4,%esp
8010515e:	ff 73 04             	push   0x4(%ebx)
80105161:	57                   	push   %edi
80105162:	56                   	push   %esi
80105163:	e8 58 d0 ff ff       	call   801021c0 <dirlink>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	85 c0                	test   %eax,%eax
8010516d:	78 29                	js     80105198 <sys_link+0xe8>
  iunlockput(dp);
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	56                   	push   %esi
80105173:	e8 78 ca ff ff       	call   80101bf0 <iunlockput>
  iput(ip);
80105178:	89 1c 24             	mov    %ebx,(%esp)
8010517b:	e8 10 c9 ff ff       	call   80101a90 <iput>
  end_op();
80105180:	e8 2b de ff ff       	call   80102fb0 <end_op>
  return 0;
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	31 c0                	xor    %eax,%eax
}
8010518a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010518d:	5b                   	pop    %ebx
8010518e:	5e                   	pop    %esi
8010518f:	5f                   	pop    %edi
80105190:	5d                   	pop    %ebp
80105191:	c3                   	ret    
80105192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105198:	83 ec 0c             	sub    $0xc,%esp
8010519b:	56                   	push   %esi
8010519c:	e8 4f ca ff ff       	call   80101bf0 <iunlockput>
    goto bad;
801051a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	53                   	push   %ebx
801051a8:	e8 b3 c7 ff ff       	call   80101960 <ilock>
  ip->nlink--;
801051ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051b2:	89 1c 24             	mov    %ebx,(%esp)
801051b5:	e8 f6 c6 ff ff       	call   801018b0 <iupdate>
  iunlockput(ip);
801051ba:	89 1c 24             	mov    %ebx,(%esp)
801051bd:	e8 2e ca ff ff       	call   80101bf0 <iunlockput>
  end_op();
801051c2:	e8 e9 dd ff ff       	call   80102fb0 <end_op>
  return -1;
801051c7:	83 c4 10             	add    $0x10,%esp
801051ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051cf:	eb b9                	jmp    8010518a <sys_link+0xda>
    iunlockput(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
801051d4:	53                   	push   %ebx
801051d5:	e8 16 ca ff ff       	call   80101bf0 <iunlockput>
    end_op();
801051da:	e8 d1 dd ff ff       	call   80102fb0 <end_op>
    return -1;
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e7:	eb a1                	jmp    8010518a <sys_link+0xda>
    end_op();
801051e9:	e8 c2 dd ff ff       	call   80102fb0 <end_op>
    return -1;
801051ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f3:	eb 95                	jmp    8010518a <sys_link+0xda>
801051f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105200 <sys_unlink>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	57                   	push   %edi
80105204:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105205:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105208:	53                   	push   %ebx
80105209:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010520c:	50                   	push   %eax
8010520d:	6a 00                	push   $0x0
8010520f:	e8 bc f9 ff ff       	call   80104bd0 <argstr>
80105214:	83 c4 10             	add    $0x10,%esp
80105217:	85 c0                	test   %eax,%eax
80105219:	0f 88 7a 01 00 00    	js     80105399 <sys_unlink+0x199>
  begin_op();
8010521f:	e8 1c dd ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105224:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	53                   	push   %ebx
8010522b:	ff 75 c0             	push   -0x40(%ebp)
8010522e:	e8 6d d0 ff ff       	call   801022a0 <nameiparent>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105239:	85 c0                	test   %eax,%eax
8010523b:	0f 84 62 01 00 00    	je     801053a3 <sys_unlink+0x1a3>
  ilock(dp);
80105241:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	57                   	push   %edi
80105248:	e8 13 c7 ff ff       	call   80101960 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010524d:	58                   	pop    %eax
8010524e:	5a                   	pop    %edx
8010524f:	68 d4 7a 10 80       	push   $0x80107ad4
80105254:	53                   	push   %ebx
80105255:	e8 46 cc ff ff       	call   80101ea0 <namecmp>
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	85 c0                	test   %eax,%eax
8010525f:	0f 84 fb 00 00 00    	je     80105360 <sys_unlink+0x160>
80105265:	83 ec 08             	sub    $0x8,%esp
80105268:	68 d3 7a 10 80       	push   $0x80107ad3
8010526d:	53                   	push   %ebx
8010526e:	e8 2d cc ff ff       	call   80101ea0 <namecmp>
80105273:	83 c4 10             	add    $0x10,%esp
80105276:	85 c0                	test   %eax,%eax
80105278:	0f 84 e2 00 00 00    	je     80105360 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010527e:	83 ec 04             	sub    $0x4,%esp
80105281:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105284:	50                   	push   %eax
80105285:	53                   	push   %ebx
80105286:	57                   	push   %edi
80105287:	e8 34 cc ff ff       	call   80101ec0 <dirlookup>
8010528c:	83 c4 10             	add    $0x10,%esp
8010528f:	89 c3                	mov    %eax,%ebx
80105291:	85 c0                	test   %eax,%eax
80105293:	0f 84 c7 00 00 00    	je     80105360 <sys_unlink+0x160>
  ilock(ip);
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	50                   	push   %eax
8010529d:	e8 be c6 ff ff       	call   80101960 <ilock>
  if(ip->nlink < 1)
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052aa:	0f 8e 1c 01 00 00    	jle    801053cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052b8:	74 66                	je     80105320 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052ba:	83 ec 04             	sub    $0x4,%esp
801052bd:	6a 10                	push   $0x10
801052bf:	6a 00                	push   $0x0
801052c1:	57                   	push   %edi
801052c2:	e8 89 f5 ff ff       	call   80104850 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c7:	6a 10                	push   $0x10
801052c9:	ff 75 c4             	push   -0x3c(%ebp)
801052cc:	57                   	push   %edi
801052cd:	ff 75 b4             	push   -0x4c(%ebp)
801052d0:	e8 9b ca ff ff       	call   80101d70 <writei>
801052d5:	83 c4 20             	add    $0x20,%esp
801052d8:	83 f8 10             	cmp    $0x10,%eax
801052db:	0f 85 de 00 00 00    	jne    801053bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801052e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052e6:	0f 84 94 00 00 00    	je     80105380 <sys_unlink+0x180>
  iunlockput(dp);
801052ec:	83 ec 0c             	sub    $0xc,%esp
801052ef:	ff 75 b4             	push   -0x4c(%ebp)
801052f2:	e8 f9 c8 ff ff       	call   80101bf0 <iunlockput>
  ip->nlink--;
801052f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052fc:	89 1c 24             	mov    %ebx,(%esp)
801052ff:	e8 ac c5 ff ff       	call   801018b0 <iupdate>
  iunlockput(ip);
80105304:	89 1c 24             	mov    %ebx,(%esp)
80105307:	e8 e4 c8 ff ff       	call   80101bf0 <iunlockput>
  end_op();
8010530c:	e8 9f dc ff ff       	call   80102fb0 <end_op>
  return 0;
80105311:	83 c4 10             	add    $0x10,%esp
80105314:	31 c0                	xor    %eax,%eax
}
80105316:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105319:	5b                   	pop    %ebx
8010531a:	5e                   	pop    %esi
8010531b:	5f                   	pop    %edi
8010531c:	5d                   	pop    %ebp
8010531d:	c3                   	ret    
8010531e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105320:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105324:	76 94                	jbe    801052ba <sys_unlink+0xba>
80105326:	be 20 00 00 00       	mov    $0x20,%esi
8010532b:	eb 0b                	jmp    80105338 <sys_unlink+0x138>
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
80105330:	83 c6 10             	add    $0x10,%esi
80105333:	3b 73 58             	cmp    0x58(%ebx),%esi
80105336:	73 82                	jae    801052ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105338:	6a 10                	push   $0x10
8010533a:	56                   	push   %esi
8010533b:	57                   	push   %edi
8010533c:	53                   	push   %ebx
8010533d:	e8 2e c9 ff ff       	call   80101c70 <readi>
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	83 f8 10             	cmp    $0x10,%eax
80105348:	75 68                	jne    801053b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010534a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010534f:	74 df                	je     80105330 <sys_unlink+0x130>
    iunlockput(ip);
80105351:	83 ec 0c             	sub    $0xc,%esp
80105354:	53                   	push   %ebx
80105355:	e8 96 c8 ff ff       	call   80101bf0 <iunlockput>
    goto bad;
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	ff 75 b4             	push   -0x4c(%ebp)
80105366:	e8 85 c8 ff ff       	call   80101bf0 <iunlockput>
  end_op();
8010536b:	e8 40 dc ff ff       	call   80102fb0 <end_op>
  return -1;
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105378:	eb 9c                	jmp    80105316 <sys_unlink+0x116>
8010537a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105380:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105383:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105386:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010538b:	50                   	push   %eax
8010538c:	e8 1f c5 ff ff       	call   801018b0 <iupdate>
80105391:	83 c4 10             	add    $0x10,%esp
80105394:	e9 53 ff ff ff       	jmp    801052ec <sys_unlink+0xec>
    return -1;
80105399:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539e:	e9 73 ff ff ff       	jmp    80105316 <sys_unlink+0x116>
    end_op();
801053a3:	e8 08 dc ff ff       	call   80102fb0 <end_op>
    return -1;
801053a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ad:	e9 64 ff ff ff       	jmp    80105316 <sys_unlink+0x116>
      panic("isdirempty: readi");
801053b2:	83 ec 0c             	sub    $0xc,%esp
801053b5:	68 f8 7a 10 80       	push   $0x80107af8
801053ba:	e8 c1 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801053bf:	83 ec 0c             	sub    $0xc,%esp
801053c2:	68 0a 7b 10 80       	push   $0x80107b0a
801053c7:	e8 b4 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	68 e6 7a 10 80       	push   $0x80107ae6
801053d4:	e8 a7 af ff ff       	call   80100380 <panic>
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_open>:

int
sys_open(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	57                   	push   %edi
801053e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053e8:	53                   	push   %ebx
801053e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053ec:	50                   	push   %eax
801053ed:	6a 00                	push   $0x0
801053ef:	e8 dc f7 ff ff       	call   80104bd0 <argstr>
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	85 c0                	test   %eax,%eax
801053f9:	0f 88 8e 00 00 00    	js     8010548d <sys_open+0xad>
801053ff:	83 ec 08             	sub    $0x8,%esp
80105402:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105405:	50                   	push   %eax
80105406:	6a 01                	push   $0x1
80105408:	e8 03 f7 ff ff       	call   80104b10 <argint>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	78 79                	js     8010548d <sys_open+0xad>
    return -1;

  begin_op();
80105414:	e8 27 db ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
80105419:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010541d:	75 79                	jne    80105498 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	ff 75 e0             	push   -0x20(%ebp)
80105425:	e8 56 ce ff ff       	call   80102280 <namei>
8010542a:	83 c4 10             	add    $0x10,%esp
8010542d:	89 c6                	mov    %eax,%esi
8010542f:	85 c0                	test   %eax,%eax
80105431:	0f 84 7e 00 00 00    	je     801054b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105437:	83 ec 0c             	sub    $0xc,%esp
8010543a:	50                   	push   %eax
8010543b:	e8 20 c5 ff ff       	call   80101960 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105440:	83 c4 10             	add    $0x10,%esp
80105443:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105448:	0f 84 c2 00 00 00    	je     80105510 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010544e:	e8 cd bb ff ff       	call   80101020 <filealloc>
80105453:	89 c7                	mov    %eax,%edi
80105455:	85 c0                	test   %eax,%eax
80105457:	74 23                	je     8010547c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105459:	e8 02 e7 ff ff       	call   80103b60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010545e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105460:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105464:	85 d2                	test   %edx,%edx
80105466:	74 60                	je     801054c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105468:	83 c3 01             	add    $0x1,%ebx
8010546b:	83 fb 10             	cmp    $0x10,%ebx
8010546e:	75 f0                	jne    80105460 <sys_open+0x80>
    if(f)
      fileclose(f);
80105470:	83 ec 0c             	sub    $0xc,%esp
80105473:	57                   	push   %edi
80105474:	e8 67 bc ff ff       	call   801010e0 <fileclose>
80105479:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010547c:	83 ec 0c             	sub    $0xc,%esp
8010547f:	56                   	push   %esi
80105480:	e8 6b c7 ff ff       	call   80101bf0 <iunlockput>
    end_op();
80105485:	e8 26 db ff ff       	call   80102fb0 <end_op>
    return -1;
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105492:	eb 6d                	jmp    80105501 <sys_open+0x121>
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010549e:	31 c9                	xor    %ecx,%ecx
801054a0:	ba 02 00 00 00       	mov    $0x2,%edx
801054a5:	6a 00                	push   $0x0
801054a7:	e8 14 f8 ff ff       	call   80104cc0 <create>
    if(ip == 0){
801054ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801054af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054b1:	85 c0                	test   %eax,%eax
801054b3:	75 99                	jne    8010544e <sys_open+0x6e>
      end_op();
801054b5:	e8 f6 da ff ff       	call   80102fb0 <end_op>
      return -1;
801054ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054bf:	eb 40                	jmp    80105501 <sys_open+0x121>
801054c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054cf:	56                   	push   %esi
801054d0:	e8 6b c5 ff ff       	call   80101a40 <iunlock>
  end_op();
801054d5:	e8 d6 da ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
801054da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054f2:	f7 d0                	not    %eax
801054f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105504:	89 d8                	mov    %ebx,%eax
80105506:	5b                   	pop    %ebx
80105507:	5e                   	pop    %esi
80105508:	5f                   	pop    %edi
80105509:	5d                   	pop    %ebp
8010550a:	c3                   	ret    
8010550b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105510:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105513:	85 c9                	test   %ecx,%ecx
80105515:	0f 84 33 ff ff ff    	je     8010544e <sys_open+0x6e>
8010551b:	e9 5c ff ff ff       	jmp    8010547c <sys_open+0x9c>

80105520 <sys_mkdir>:

int
sys_mkdir(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105526:	e8 15 da ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010552b:	83 ec 08             	sub    $0x8,%esp
8010552e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105531:	50                   	push   %eax
80105532:	6a 00                	push   $0x0
80105534:	e8 97 f6 ff ff       	call   80104bd0 <argstr>
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	85 c0                	test   %eax,%eax
8010553e:	78 30                	js     80105570 <sys_mkdir+0x50>
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105546:	31 c9                	xor    %ecx,%ecx
80105548:	ba 01 00 00 00       	mov    $0x1,%edx
8010554d:	6a 00                	push   $0x0
8010554f:	e8 6c f7 ff ff       	call   80104cc0 <create>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	74 15                	je     80105570 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010555b:	83 ec 0c             	sub    $0xc,%esp
8010555e:	50                   	push   %eax
8010555f:	e8 8c c6 ff ff       	call   80101bf0 <iunlockput>
  end_op();
80105564:	e8 47 da ff ff       	call   80102fb0 <end_op>
  return 0;
80105569:	83 c4 10             	add    $0x10,%esp
8010556c:	31 c0                	xor    %eax,%eax
}
8010556e:	c9                   	leave  
8010556f:	c3                   	ret    
    end_op();
80105570:	e8 3b da ff ff       	call   80102fb0 <end_op>
    return -1;
80105575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010557a:	c9                   	leave  
8010557b:	c3                   	ret    
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_mknod>:

int
sys_mknod(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105586:	e8 b5 d9 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105591:	50                   	push   %eax
80105592:	6a 00                	push   $0x0
80105594:	e8 37 f6 ff ff       	call   80104bd0 <argstr>
80105599:	83 c4 10             	add    $0x10,%esp
8010559c:	85 c0                	test   %eax,%eax
8010559e:	78 60                	js     80105600 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055a0:	83 ec 08             	sub    $0x8,%esp
801055a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055a6:	50                   	push   %eax
801055a7:	6a 01                	push   $0x1
801055a9:	e8 62 f5 ff ff       	call   80104b10 <argint>
  if((argstr(0, &path)) < 0 ||
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	85 c0                	test   %eax,%eax
801055b3:	78 4b                	js     80105600 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055b5:	83 ec 08             	sub    $0x8,%esp
801055b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055bb:	50                   	push   %eax
801055bc:	6a 02                	push   $0x2
801055be:	e8 4d f5 ff ff       	call   80104b10 <argint>
     argint(1, &major) < 0 ||
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	85 c0                	test   %eax,%eax
801055c8:	78 36                	js     80105600 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055ce:	83 ec 0c             	sub    $0xc,%esp
801055d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055d5:	ba 03 00 00 00       	mov    $0x3,%edx
801055da:	50                   	push   %eax
801055db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055de:	e8 dd f6 ff ff       	call   80104cc0 <create>
     argint(2, &minor) < 0 ||
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	74 16                	je     80105600 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ea:	83 ec 0c             	sub    $0xc,%esp
801055ed:	50                   	push   %eax
801055ee:	e8 fd c5 ff ff       	call   80101bf0 <iunlockput>
  end_op();
801055f3:	e8 b8 d9 ff ff       	call   80102fb0 <end_op>
  return 0;
801055f8:	83 c4 10             	add    $0x10,%esp
801055fb:	31 c0                	xor    %eax,%eax
}
801055fd:	c9                   	leave  
801055fe:	c3                   	ret    
801055ff:	90                   	nop
    end_op();
80105600:	e8 ab d9 ff ff       	call   80102fb0 <end_op>
    return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_chdir>:

int
sys_chdir(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	56                   	push   %esi
80105614:	53                   	push   %ebx
80105615:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105618:	e8 43 e5 ff ff       	call   80103b60 <myproc>
8010561d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010561f:	e8 1c d9 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105624:	83 ec 08             	sub    $0x8,%esp
80105627:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562a:	50                   	push   %eax
8010562b:	6a 00                	push   $0x0
8010562d:	e8 9e f5 ff ff       	call   80104bd0 <argstr>
80105632:	83 c4 10             	add    $0x10,%esp
80105635:	85 c0                	test   %eax,%eax
80105637:	78 77                	js     801056b0 <sys_chdir+0xa0>
80105639:	83 ec 0c             	sub    $0xc,%esp
8010563c:	ff 75 f4             	push   -0xc(%ebp)
8010563f:	e8 3c cc ff ff       	call   80102280 <namei>
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	89 c3                	mov    %eax,%ebx
80105649:	85 c0                	test   %eax,%eax
8010564b:	74 63                	je     801056b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	50                   	push   %eax
80105651:	e8 0a c3 ff ff       	call   80101960 <ilock>
  if(ip->type != T_DIR){
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010565e:	75 30                	jne    80105690 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	53                   	push   %ebx
80105664:	e8 d7 c3 ff ff       	call   80101a40 <iunlock>
  iput(curproc->cwd);
80105669:	58                   	pop    %eax
8010566a:	ff 76 68             	push   0x68(%esi)
8010566d:	e8 1e c4 ff ff       	call   80101a90 <iput>
  end_op();
80105672:	e8 39 d9 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105677:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010567a:	83 c4 10             	add    $0x10,%esp
8010567d:	31 c0                	xor    %eax,%eax
}
8010567f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105682:	5b                   	pop    %ebx
80105683:	5e                   	pop    %esi
80105684:	5d                   	pop    %ebp
80105685:	c3                   	ret    
80105686:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	53                   	push   %ebx
80105694:	e8 57 c5 ff ff       	call   80101bf0 <iunlockput>
    end_op();
80105699:	e8 12 d9 ff ff       	call   80102fb0 <end_op>
    return -1;
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a6:	eb d7                	jmp    8010567f <sys_chdir+0x6f>
801056a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056af:	90                   	nop
    end_op();
801056b0:	e8 fb d8 ff ff       	call   80102fb0 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ba:	eb c3                	jmp    8010567f <sys_chdir+0x6f>
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_exec>:

int
sys_exec(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056cb:	53                   	push   %ebx
801056cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056d2:	50                   	push   %eax
801056d3:	6a 00                	push   $0x0
801056d5:	e8 f6 f4 ff ff       	call   80104bd0 <argstr>
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	85 c0                	test   %eax,%eax
801056df:	0f 88 87 00 00 00    	js     8010576c <sys_exec+0xac>
801056e5:	83 ec 08             	sub    $0x8,%esp
801056e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056ee:	50                   	push   %eax
801056ef:	6a 01                	push   $0x1
801056f1:	e8 1a f4 ff ff       	call   80104b10 <argint>
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	85 c0                	test   %eax,%eax
801056fb:	78 6f                	js     8010576c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056fd:	83 ec 04             	sub    $0x4,%esp
80105700:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105706:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105708:	68 80 00 00 00       	push   $0x80
8010570d:	6a 00                	push   $0x0
8010570f:	56                   	push   %esi
80105710:	e8 3b f1 ff ff       	call   80104850 <memset>
80105715:	83 c4 10             	add    $0x10,%esp
80105718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105720:	83 ec 08             	sub    $0x8,%esp
80105723:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105729:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105730:	50                   	push   %eax
80105731:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105737:	01 f8                	add    %edi,%eax
80105739:	50                   	push   %eax
8010573a:	e8 41 f3 ff ff       	call   80104a80 <fetchint>
8010573f:	83 c4 10             	add    $0x10,%esp
80105742:	85 c0                	test   %eax,%eax
80105744:	78 26                	js     8010576c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105746:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010574c:	85 c0                	test   %eax,%eax
8010574e:	74 30                	je     80105780 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105750:	83 ec 08             	sub    $0x8,%esp
80105753:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105756:	52                   	push   %edx
80105757:	50                   	push   %eax
80105758:	e8 63 f3 ff ff       	call   80104ac0 <fetchstr>
8010575d:	83 c4 10             	add    $0x10,%esp
80105760:	85 c0                	test   %eax,%eax
80105762:	78 08                	js     8010576c <sys_exec+0xac>
  for(i=0;; i++){
80105764:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105767:	83 fb 20             	cmp    $0x20,%ebx
8010576a:	75 b4                	jne    80105720 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010576c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010576f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105774:	5b                   	pop    %ebx
80105775:	5e                   	pop    %esi
80105776:	5f                   	pop    %edi
80105777:	5d                   	pop    %ebp
80105778:	c3                   	ret    
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105780:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105787:	00 00 00 00 
  return exec(path, argv);
8010578b:	83 ec 08             	sub    $0x8,%esp
8010578e:	56                   	push   %esi
8010578f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105795:	e8 06 b5 ff ff       	call   80100ca0 <exec>
8010579a:	83 c4 10             	add    $0x10,%esp
}
8010579d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a0:	5b                   	pop    %ebx
801057a1:	5e                   	pop    %esi
801057a2:	5f                   	pop    %edi
801057a3:	5d                   	pop    %ebp
801057a4:	c3                   	ret    
801057a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057b0 <sys_pipe>:

int
sys_pipe(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	57                   	push   %edi
801057b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057b8:	53                   	push   %ebx
801057b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057bc:	6a 08                	push   $0x8
801057be:	50                   	push   %eax
801057bf:	6a 00                	push   $0x0
801057c1:	e8 9a f3 ff ff       	call   80104b60 <argptr>
801057c6:	83 c4 10             	add    $0x10,%esp
801057c9:	85 c0                	test   %eax,%eax
801057cb:	78 4a                	js     80105817 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057cd:	83 ec 08             	sub    $0x8,%esp
801057d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057d3:	50                   	push   %eax
801057d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057d7:	50                   	push   %eax
801057d8:	e8 33 de ff ff       	call   80103610 <pipealloc>
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	85 c0                	test   %eax,%eax
801057e2:	78 33                	js     80105817 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057e7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057e9:	e8 72 e3 ff ff       	call   80103b60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801057f0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057f4:	85 f6                	test   %esi,%esi
801057f6:	74 28                	je     80105820 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801057f8:	83 c3 01             	add    $0x1,%ebx
801057fb:	83 fb 10             	cmp    $0x10,%ebx
801057fe:	75 f0                	jne    801057f0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	ff 75 e0             	push   -0x20(%ebp)
80105806:	e8 d5 b8 ff ff       	call   801010e0 <fileclose>
    fileclose(wf);
8010580b:	58                   	pop    %eax
8010580c:	ff 75 e4             	push   -0x1c(%ebp)
8010580f:	e8 cc b8 ff ff       	call   801010e0 <fileclose>
    return -1;
80105814:	83 c4 10             	add    $0x10,%esp
80105817:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581c:	eb 53                	jmp    80105871 <sys_pipe+0xc1>
8010581e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105820:	8d 73 08             	lea    0x8(%ebx),%esi
80105823:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105827:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010582a:	e8 31 e3 ff ff       	call   80103b60 <myproc>
8010582f:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80105831:	31 c0                	xor    %eax,%eax
80105833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105837:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105838:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
8010583c:	85 c9                	test   %ecx,%ecx
8010583e:	74 20                	je     80105860 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105840:	83 c0 01             	add    $0x1,%eax
80105843:	83 f8 10             	cmp    $0x10,%eax
80105846:	75 f0                	jne    80105838 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105848:	e8 13 e3 ff ff       	call   80103b60 <myproc>
8010584d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105854:	00 
80105855:	eb a9                	jmp    80105800 <sys_pipe+0x50>
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105860:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
80105864:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105867:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105869:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010586c:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
8010586f:	31 c0                	xor    %eax,%eax
}
80105871:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105874:	5b                   	pop    %ebx
80105875:	5e                   	pop    %esi
80105876:	5f                   	pop    %edi
80105877:	5d                   	pop    %ebp
80105878:	c3                   	ret    
80105879:	66 90                	xchg   %ax,%ax
8010587b:	66 90                	xchg   %ax,%ax
8010587d:	66 90                	xchg   %ax,%ax
8010587f:	90                   	nop

80105880 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105880:	e9 7b e4 ff ff       	jmp    80103d00 <fork>
80105885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_exit>:
}

int
sys_exit(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 08             	sub    $0x8,%esp
  exit();
80105896:	e8 e5 e6 ff ff       	call   80103f80 <exit>
  return 0;  // not reached
}
8010589b:	31 c0                	xor    %eax,%eax
8010589d:	c9                   	leave  
8010589e:	c3                   	ret    
8010589f:	90                   	nop

801058a0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801058a0:	e9 0b e8 ff ff       	jmp    801040b0 <wait>
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_kill>:
}

int
sys_kill(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b9:	50                   	push   %eax
801058ba:	6a 00                	push   $0x0
801058bc:	e8 4f f2 ff ff       	call   80104b10 <argint>
801058c1:	83 c4 10             	add    $0x10,%esp
801058c4:	85 c0                	test   %eax,%eax
801058c6:	78 18                	js     801058e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	ff 75 f4             	push   -0xc(%ebp)
801058ce:	e8 7d ea ff ff       	call   80104350 <kill>
801058d3:	83 c4 10             	add    $0x10,%esp
}
801058d6:	c9                   	leave  
801058d7:	c3                   	ret    
801058d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058df:	90                   	nop
801058e0:	c9                   	leave  
    return -1;
801058e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e6:	c3                   	ret    
801058e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ee:	66 90                	xchg   %ax,%ax

801058f0 <sys_getpid>:

int
sys_getpid(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058f6:	e8 65 e2 ff ff       	call   80103b60 <myproc>
801058fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058fe:	c9                   	leave  
801058ff:	c3                   	ret    

80105900 <sys_sbrk>:

int
sys_sbrk(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105904:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105907:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010590a:	50                   	push   %eax
8010590b:	6a 00                	push   $0x0
8010590d:	e8 fe f1 ff ff       	call   80104b10 <argint>
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	85 c0                	test   %eax,%eax
80105917:	78 27                	js     80105940 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105919:	e8 42 e2 ff ff       	call   80103b60 <myproc>
  if(growproc(n) < 0)
8010591e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105921:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105923:	ff 75 f4             	push   -0xc(%ebp)
80105926:	e8 55 e3 ff ff       	call   80103c80 <growproc>
8010592b:	83 c4 10             	add    $0x10,%esp
8010592e:	85 c0                	test   %eax,%eax
80105930:	78 0e                	js     80105940 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105932:	89 d8                	mov    %ebx,%eax
80105934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105937:	c9                   	leave  
80105938:	c3                   	ret    
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105940:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105945:	eb eb                	jmp    80105932 <sys_sbrk+0x32>
80105947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_sleep>:

int
sys_sleep(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105957:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 ae f1 ff ff       	call   80104b10 <argint>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	0f 88 8a 00 00 00    	js     801059f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	68 80 3c 11 80       	push   $0x80113c80
80105975:	e8 16 ee ff ff       	call   80104790 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010597a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010597d:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  while(ticks - ticks0 < n){
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 d2                	test   %edx,%edx
80105988:	75 27                	jne    801059b1 <sys_sleep+0x61>
8010598a:	eb 54                	jmp    801059e0 <sys_sleep+0x90>
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105990:	83 ec 08             	sub    $0x8,%esp
80105993:	68 80 3c 11 80       	push   $0x80113c80
80105998:	68 60 3c 11 80       	push   $0x80113c60
8010599d:	e8 8e e8 ff ff       	call   80104230 <sleep>
  while(ticks - ticks0 < n){
801059a2:	a1 60 3c 11 80       	mov    0x80113c60,%eax
801059a7:	83 c4 10             	add    $0x10,%esp
801059aa:	29 d8                	sub    %ebx,%eax
801059ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801059af:	73 2f                	jae    801059e0 <sys_sleep+0x90>
    if(myproc()->killed){
801059b1:	e8 aa e1 ff ff       	call   80103b60 <myproc>
801059b6:	8b 40 24             	mov    0x24(%eax),%eax
801059b9:	85 c0                	test   %eax,%eax
801059bb:	74 d3                	je     80105990 <sys_sleep+0x40>
      release(&tickslock);
801059bd:	83 ec 0c             	sub    $0xc,%esp
801059c0:	68 80 3c 11 80       	push   $0x80113c80
801059c5:	e8 66 ed ff ff       	call   80104730 <release>
  }
  release(&tickslock);
  return 0;
}
801059ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d5:	c9                   	leave  
801059d6:	c3                   	ret    
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	68 80 3c 11 80       	push   $0x80113c80
801059e8:	e8 43 ed ff ff       	call   80104730 <release>
  return 0;
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	31 c0                	xor    %eax,%eax
}
801059f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    
    return -1;
801059f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fc:	eb f4                	jmp    801059f2 <sys_sleep+0xa2>
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
80105a04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105a07:	68 80 3c 11 80       	push   $0x80113c80
80105a0c:	e8 7f ed ff ff       	call   80104790 <acquire>
  xticks = ticks;
80105a11:	8b 1d 60 3c 11 80    	mov    0x80113c60,%ebx
  release(&tickslock);
80105a17:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105a1e:	e8 0d ed ff ff       	call   80104730 <release>
  return xticks;
}
80105a23:	89 d8                	mov    %ebx,%eax
80105a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a28:	c9                   	leave  
80105a29:	c3                   	ret    

80105a2a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a2a:	1e                   	push   %ds
  pushl %es
80105a2b:	06                   	push   %es
  pushl %fs
80105a2c:	0f a0                	push   %fs
  pushl %gs
80105a2e:	0f a8                	push   %gs
  pushal
80105a30:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a31:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a35:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a37:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a39:	54                   	push   %esp
  call trap
80105a3a:	e8 c1 00 00 00       	call   80105b00 <trap>
  addl $4, %esp
80105a3f:	83 c4 04             	add    $0x4,%esp

80105a42 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a42:	61                   	popa   
  popl %gs
80105a43:	0f a9                	pop    %gs
  popl %fs
80105a45:	0f a1                	pop    %fs
  popl %es
80105a47:	07                   	pop    %es
  popl %ds
80105a48:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a49:	83 c4 08             	add    $0x8,%esp
  iret
80105a4c:	cf                   	iret   
80105a4d:	66 90                	xchg   %ax,%ax
80105a4f:	90                   	nop

80105a50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a51:	31 c0                	xor    %eax,%eax
{
80105a53:	89 e5                	mov    %esp,%ebp
80105a55:	83 ec 08             	sub    $0x8,%esp
80105a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a60:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a67:	c7 04 c5 c2 3c 11 80 	movl   $0x8e000008,-0x7feec33e(,%eax,8)
80105a6e:	08 00 00 8e 
80105a72:	66 89 14 c5 c0 3c 11 	mov    %dx,-0x7feec340(,%eax,8)
80105a79:	80 
80105a7a:	c1 ea 10             	shr    $0x10,%edx
80105a7d:	66 89 14 c5 c6 3c 11 	mov    %dx,-0x7feec33a(,%eax,8)
80105a84:	80 
  for(i = 0; i < 256; i++)
80105a85:	83 c0 01             	add    $0x1,%eax
80105a88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a8d:	75 d1                	jne    80105a60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a92:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105a97:	c7 05 c2 3e 11 80 08 	movl   $0xef000008,0x80113ec2
80105a9e:	00 00 ef 
  initlock(&tickslock, "time");
80105aa1:	68 19 7b 10 80       	push   $0x80107b19
80105aa6:	68 80 3c 11 80       	push   $0x80113c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105aab:	66 a3 c0 3e 11 80    	mov    %ax,0x80113ec0
80105ab1:	c1 e8 10             	shr    $0x10,%eax
80105ab4:	66 a3 c6 3e 11 80    	mov    %ax,0x80113ec6
  initlock(&tickslock, "time");
80105aba:	e8 01 eb ff ff       	call   801045c0 <initlock>
}
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	c9                   	leave  
80105ac3:	c3                   	ret    
80105ac4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105acf:	90                   	nop

80105ad0 <idtinit>:

void
idtinit(void)
{
80105ad0:	55                   	push   %ebp
  pd[0] = size-1;
80105ad1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ad6:	89 e5                	mov    %esp,%ebp
80105ad8:	83 ec 10             	sub    $0x10,%esp
80105adb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105adf:	b8 c0 3c 11 80       	mov    $0x80113cc0,%eax
80105ae4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ae8:	c1 e8 10             	shr    $0x10,%eax
80105aeb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105aef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105af2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
80105b06:	83 ec 1c             	sub    $0x1c,%esp
80105b09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b0c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b0f:	83 f8 40             	cmp    $0x40,%eax
80105b12:	0f 84 68 01 00 00    	je     80105c80 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b18:	83 e8 20             	sub    $0x20,%eax
80105b1b:	83 f8 1f             	cmp    $0x1f,%eax
80105b1e:	0f 87 8c 00 00 00    	ja     80105bb0 <trap+0xb0>
80105b24:	ff 24 85 c0 7b 10 80 	jmp    *-0x7fef8440(,%eax,4)
80105b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b2f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b30:	e8 eb c8 ff ff       	call   80102420 <ideintr>
    lapiceoi();
80105b35:	e8 b6 cf ff ff       	call   80102af0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b3a:	e8 21 e0 ff ff       	call   80103b60 <myproc>
80105b3f:	85 c0                	test   %eax,%eax
80105b41:	74 1d                	je     80105b60 <trap+0x60>
80105b43:	e8 18 e0 ff ff       	call   80103b60 <myproc>
80105b48:	8b 50 24             	mov    0x24(%eax),%edx
80105b4b:	85 d2                	test   %edx,%edx
80105b4d:	74 11                	je     80105b60 <trap+0x60>
80105b4f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b53:	83 e0 03             	and    $0x3,%eax
80105b56:	66 83 f8 03          	cmp    $0x3,%ax
80105b5a:	0f 84 e8 01 00 00    	je     80105d48 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b60:	e8 fb df ff ff       	call   80103b60 <myproc>
80105b65:	85 c0                	test   %eax,%eax
80105b67:	74 0f                	je     80105b78 <trap+0x78>
80105b69:	e8 f2 df ff ff       	call   80103b60 <myproc>
80105b6e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b72:	0f 84 b8 00 00 00    	je     80105c30 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b78:	e8 e3 df ff ff       	call   80103b60 <myproc>
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	74 1d                	je     80105b9e <trap+0x9e>
80105b81:	e8 da df ff ff       	call   80103b60 <myproc>
80105b86:	8b 40 24             	mov    0x24(%eax),%eax
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	74 11                	je     80105b9e <trap+0x9e>
80105b8d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b91:	83 e0 03             	and    $0x3,%eax
80105b94:	66 83 f8 03          	cmp    $0x3,%ax
80105b98:	0f 84 0f 01 00 00    	je     80105cad <trap+0x1ad>
    exit();
}
80105b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba1:	5b                   	pop    %ebx
80105ba2:	5e                   	pop    %esi
80105ba3:	5f                   	pop    %edi
80105ba4:	5d                   	pop    %ebp
80105ba5:	c3                   	ret    
80105ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bad:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bb0:	e8 ab df ff ff       	call   80103b60 <myproc>
80105bb5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bb8:	85 c0                	test   %eax,%eax
80105bba:	0f 84 a2 01 00 00    	je     80105d62 <trap+0x262>
80105bc0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105bc4:	0f 84 98 01 00 00    	je     80105d62 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105bca:	0f 20 d1             	mov    %cr2,%ecx
80105bcd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bd0:	e8 6b df ff ff       	call   80103b40 <cpuid>
80105bd5:	8b 73 30             	mov    0x30(%ebx),%esi
80105bd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105bdb:	8b 43 34             	mov    0x34(%ebx),%eax
80105bde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105be1:	e8 7a df ff ff       	call   80103b60 <myproc>
80105be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105be9:	e8 72 df ff ff       	call   80103b60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105bf1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105bf4:	51                   	push   %ecx
80105bf5:	57                   	push   %edi
80105bf6:	52                   	push   %edx
80105bf7:	ff 75 e4             	push   -0x1c(%ebp)
80105bfa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105bfb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105bfe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c01:	56                   	push   %esi
80105c02:	ff 70 10             	push   0x10(%eax)
80105c05:	68 7c 7b 10 80       	push   $0x80107b7c
80105c0a:	e8 71 aa ff ff       	call   80100680 <cprintf>
    myproc()->killed = 1;
80105c0f:	83 c4 20             	add    $0x20,%esp
80105c12:	e8 49 df ff ff       	call   80103b60 <myproc>
80105c17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c1e:	e8 3d df ff ff       	call   80103b60 <myproc>
80105c23:	85 c0                	test   %eax,%eax
80105c25:	0f 85 18 ff ff ff    	jne    80105b43 <trap+0x43>
80105c2b:	e9 30 ff ff ff       	jmp    80105b60 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105c30:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c34:	0f 85 3e ff ff ff    	jne    80105b78 <trap+0x78>
    yield();
80105c3a:	e8 a1 e5 ff ff       	call   801041e0 <yield>
80105c3f:	e9 34 ff ff ff       	jmp    80105b78 <trap+0x78>
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c48:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c4f:	e8 ec de ff ff       	call   80103b40 <cpuid>
80105c54:	57                   	push   %edi
80105c55:	56                   	push   %esi
80105c56:	50                   	push   %eax
80105c57:	68 24 7b 10 80       	push   $0x80107b24
80105c5c:	e8 1f aa ff ff       	call   80100680 <cprintf>
    lapiceoi();
80105c61:	e8 8a ce ff ff       	call   80102af0 <lapiceoi>
    break;
80105c66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c69:	e8 f2 de ff ff       	call   80103b60 <myproc>
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	0f 85 cd fe ff ff    	jne    80105b43 <trap+0x43>
80105c76:	e9 e5 fe ff ff       	jmp    80105b60 <trap+0x60>
80105c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
    if(myproc()->killed)
80105c80:	e8 db de ff ff       	call   80103b60 <myproc>
80105c85:	8b 70 24             	mov    0x24(%eax),%esi
80105c88:	85 f6                	test   %esi,%esi
80105c8a:	0f 85 c8 00 00 00    	jne    80105d58 <trap+0x258>
    myproc()->tf = tf;
80105c90:	e8 cb de ff ff       	call   80103b60 <myproc>
80105c95:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c98:	e8 b3 ef ff ff       	call   80104c50 <syscall>
    if(myproc()->killed)
80105c9d:	e8 be de ff ff       	call   80103b60 <myproc>
80105ca2:	8b 48 24             	mov    0x24(%eax),%ecx
80105ca5:	85 c9                	test   %ecx,%ecx
80105ca7:	0f 84 f1 fe ff ff    	je     80105b9e <trap+0x9e>
}
80105cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cb0:	5b                   	pop    %ebx
80105cb1:	5e                   	pop    %esi
80105cb2:	5f                   	pop    %edi
80105cb3:	5d                   	pop    %ebp
      exit();
80105cb4:	e9 c7 e2 ff ff       	jmp    80103f80 <exit>
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105cc0:	e8 5b 02 00 00       	call   80105f20 <uartintr>
    lapiceoi();
80105cc5:	e8 26 ce ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cca:	e8 91 de ff ff       	call   80103b60 <myproc>
80105ccf:	85 c0                	test   %eax,%eax
80105cd1:	0f 85 6c fe ff ff    	jne    80105b43 <trap+0x43>
80105cd7:	e9 84 fe ff ff       	jmp    80105b60 <trap+0x60>
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ce0:	e8 cb cc ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80105ce5:	e8 06 ce ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cea:	e8 71 de ff ff       	call   80103b60 <myproc>
80105cef:	85 c0                	test   %eax,%eax
80105cf1:	0f 85 4c fe ff ff    	jne    80105b43 <trap+0x43>
80105cf7:	e9 64 fe ff ff       	jmp    80105b60 <trap+0x60>
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105d00:	e8 3b de ff ff       	call   80103b40 <cpuid>
80105d05:	85 c0                	test   %eax,%eax
80105d07:	0f 85 28 fe ff ff    	jne    80105b35 <trap+0x35>
      acquire(&tickslock);
80105d0d:	83 ec 0c             	sub    $0xc,%esp
80105d10:	68 80 3c 11 80       	push   $0x80113c80
80105d15:	e8 76 ea ff ff       	call   80104790 <acquire>
      wakeup(&ticks);
80105d1a:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
      ticks++;
80105d21:	83 05 60 3c 11 80 01 	addl   $0x1,0x80113c60
      wakeup(&ticks);
80105d28:	e8 c3 e5 ff ff       	call   801042f0 <wakeup>
      release(&tickslock);
80105d2d:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105d34:	e8 f7 e9 ff ff       	call   80104730 <release>
80105d39:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d3c:	e9 f4 fd ff ff       	jmp    80105b35 <trap+0x35>
80105d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105d48:	e8 33 e2 ff ff       	call   80103f80 <exit>
80105d4d:	e9 0e fe ff ff       	jmp    80105b60 <trap+0x60>
80105d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d58:	e8 23 e2 ff ff       	call   80103f80 <exit>
80105d5d:	e9 2e ff ff ff       	jmp    80105c90 <trap+0x190>
80105d62:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d65:	e8 d6 dd ff ff       	call   80103b40 <cpuid>
80105d6a:	83 ec 0c             	sub    $0xc,%esp
80105d6d:	56                   	push   %esi
80105d6e:	57                   	push   %edi
80105d6f:	50                   	push   %eax
80105d70:	ff 73 30             	push   0x30(%ebx)
80105d73:	68 48 7b 10 80       	push   $0x80107b48
80105d78:	e8 03 a9 ff ff       	call   80100680 <cprintf>
      panic("trap");
80105d7d:	83 c4 14             	add    $0x14,%esp
80105d80:	68 1e 7b 10 80       	push   $0x80107b1e
80105d85:	e8 f6 a5 ff ff       	call   80100380 <panic>
80105d8a:	66 90                	xchg   %ax,%ax
80105d8c:	66 90                	xchg   %ax,%ax
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d90:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105d95:	85 c0                	test   %eax,%eax
80105d97:	74 17                	je     80105db0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d99:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d9e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d9f:	a8 01                	test   $0x1,%al
80105da1:	74 0d                	je     80105db0 <uartgetc+0x20>
80105da3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105da8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105da9:	0f b6 c0             	movzbl %al,%eax
80105dac:	c3                   	ret    
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105db5:	c3                   	ret    
80105db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi

80105dc0 <uartinit>:
{
80105dc0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dc1:	31 c9                	xor    %ecx,%ecx
80105dc3:	89 c8                	mov    %ecx,%eax
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	57                   	push   %edi
80105dc8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105dcd:	56                   	push   %esi
80105dce:	89 fa                	mov    %edi,%edx
80105dd0:	53                   	push   %ebx
80105dd1:	83 ec 1c             	sub    $0x1c,%esp
80105dd4:	ee                   	out    %al,(%dx)
80105dd5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105dda:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ddf:	89 f2                	mov    %esi,%edx
80105de1:	ee                   	out    %al,(%dx)
80105de2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105de7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dec:	ee                   	out    %al,(%dx)
80105ded:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105df2:	89 c8                	mov    %ecx,%eax
80105df4:	89 da                	mov    %ebx,%edx
80105df6:	ee                   	out    %al,(%dx)
80105df7:	b8 03 00 00 00       	mov    $0x3,%eax
80105dfc:	89 f2                	mov    %esi,%edx
80105dfe:	ee                   	out    %al,(%dx)
80105dff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e04:	89 c8                	mov    %ecx,%eax
80105e06:	ee                   	out    %al,(%dx)
80105e07:	b8 01 00 00 00       	mov    $0x1,%eax
80105e0c:	89 da                	mov    %ebx,%edx
80105e0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e0f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e14:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e15:	3c ff                	cmp    $0xff,%al
80105e17:	0f 84 93 00 00 00    	je     80105eb0 <uartinit+0xf0>
  uart = 1;
80105e1d:	c7 05 c0 44 11 80 01 	movl   $0x1,0x801144c0
80105e24:	00 00 00 
80105e27:	89 fa                	mov    %edi,%edx
80105e29:	ec                   	in     (%dx),%al
80105e2a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e2f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e30:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e33:	bf 40 7c 10 80       	mov    $0x80107c40,%edi
80105e38:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105e3d:	6a 00                	push   $0x0
80105e3f:	6a 04                	push   $0x4
80105e41:	e8 1a c8 ff ff       	call   80102660 <ioapicenable>
80105e46:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
80105e4a:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e4d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
80105e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80105e58:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105e5d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e62:	85 c0                	test   %eax,%eax
80105e64:	75 1c                	jne    80105e82 <uartinit+0xc2>
80105e66:	eb 2b                	jmp    80105e93 <uartinit+0xd3>
80105e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6f:	90                   	nop
    microdelay(10);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	6a 0a                	push   $0xa
80105e75:	e8 96 cc ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e7a:	83 c4 10             	add    $0x10,%esp
80105e7d:	83 eb 01             	sub    $0x1,%ebx
80105e80:	74 07                	je     80105e89 <uartinit+0xc9>
80105e82:	89 f2                	mov    %esi,%edx
80105e84:	ec                   	in     (%dx),%al
80105e85:	a8 20                	test   $0x20,%al
80105e87:	74 e7                	je     80105e70 <uartinit+0xb0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e89:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
80105e8d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e92:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105e93:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105e97:	83 c7 01             	add    $0x1,%edi
80105e9a:	84 c0                	test   %al,%al
80105e9c:	74 12                	je     80105eb0 <uartinit+0xf0>
80105e9e:	88 45 e6             	mov    %al,-0x1a(%ebp)
80105ea1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105ea5:	88 45 e7             	mov    %al,-0x19(%ebp)
80105ea8:	eb ae                	jmp    80105e58 <uartinit+0x98>
80105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80105eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eb3:	5b                   	pop    %ebx
80105eb4:	5e                   	pop    %esi
80105eb5:	5f                   	pop    %edi
80105eb6:	5d                   	pop    %ebp
80105eb7:	c3                   	ret    
80105eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop

80105ec0 <uartputc>:
  if(!uart)
80105ec0:	a1 c0 44 11 80       	mov    0x801144c0,%eax
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	74 47                	je     80105f10 <uartputc+0x50>
{
80105ec9:	55                   	push   %ebp
80105eca:	89 e5                	mov    %esp,%ebp
80105ecc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ecd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ed2:	53                   	push   %ebx
80105ed3:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ed8:	eb 18                	jmp    80105ef2 <uartputc+0x32>
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105ee0:	83 ec 0c             	sub    $0xc,%esp
80105ee3:	6a 0a                	push   $0xa
80105ee5:	e8 26 cc ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eea:	83 c4 10             	add    $0x10,%esp
80105eed:	83 eb 01             	sub    $0x1,%ebx
80105ef0:	74 07                	je     80105ef9 <uartputc+0x39>
80105ef2:	89 f2                	mov    %esi,%edx
80105ef4:	ec                   	in     (%dx),%al
80105ef5:	a8 20                	test   $0x20,%al
80105ef7:	74 e7                	je     80105ee0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80105efc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f01:	ee                   	out    %al,(%dx)
}
80105f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f05:	5b                   	pop    %ebx
80105f06:	5e                   	pop    %esi
80105f07:	5d                   	pop    %ebp
80105f08:	c3                   	ret    
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f10:	c3                   	ret    
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f1f:	90                   	nop

80105f20 <uartintr>:

void
uartintr(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f26:	68 90 5d 10 80       	push   $0x80105d90
80105f2b:	e8 c0 a9 ff ff       	call   801008f0 <consoleintr>
}
80105f30:	83 c4 10             	add    $0x10,%esp
80105f33:	c9                   	leave  
80105f34:	c3                   	ret    

80105f35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $0
80105f37:	6a 00                	push   $0x0
  jmp alltraps
80105f39:	e9 ec fa ff ff       	jmp    80105a2a <alltraps>

80105f3e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $1
80105f40:	6a 01                	push   $0x1
  jmp alltraps
80105f42:	e9 e3 fa ff ff       	jmp    80105a2a <alltraps>

80105f47 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $2
80105f49:	6a 02                	push   $0x2
  jmp alltraps
80105f4b:	e9 da fa ff ff       	jmp    80105a2a <alltraps>

80105f50 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $3
80105f52:	6a 03                	push   $0x3
  jmp alltraps
80105f54:	e9 d1 fa ff ff       	jmp    80105a2a <alltraps>

80105f59 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $4
80105f5b:	6a 04                	push   $0x4
  jmp alltraps
80105f5d:	e9 c8 fa ff ff       	jmp    80105a2a <alltraps>

80105f62 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $5
80105f64:	6a 05                	push   $0x5
  jmp alltraps
80105f66:	e9 bf fa ff ff       	jmp    80105a2a <alltraps>

80105f6b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $6
80105f6d:	6a 06                	push   $0x6
  jmp alltraps
80105f6f:	e9 b6 fa ff ff       	jmp    80105a2a <alltraps>

80105f74 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $7
80105f76:	6a 07                	push   $0x7
  jmp alltraps
80105f78:	e9 ad fa ff ff       	jmp    80105a2a <alltraps>

80105f7d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f7d:	6a 08                	push   $0x8
  jmp alltraps
80105f7f:	e9 a6 fa ff ff       	jmp    80105a2a <alltraps>

80105f84 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $9
80105f86:	6a 09                	push   $0x9
  jmp alltraps
80105f88:	e9 9d fa ff ff       	jmp    80105a2a <alltraps>

80105f8d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f8d:	6a 0a                	push   $0xa
  jmp alltraps
80105f8f:	e9 96 fa ff ff       	jmp    80105a2a <alltraps>

80105f94 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f94:	6a 0b                	push   $0xb
  jmp alltraps
80105f96:	e9 8f fa ff ff       	jmp    80105a2a <alltraps>

80105f9b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f9b:	6a 0c                	push   $0xc
  jmp alltraps
80105f9d:	e9 88 fa ff ff       	jmp    80105a2a <alltraps>

80105fa2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105fa2:	6a 0d                	push   $0xd
  jmp alltraps
80105fa4:	e9 81 fa ff ff       	jmp    80105a2a <alltraps>

80105fa9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105fa9:	6a 0e                	push   $0xe
  jmp alltraps
80105fab:	e9 7a fa ff ff       	jmp    80105a2a <alltraps>

80105fb0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $15
80105fb2:	6a 0f                	push   $0xf
  jmp alltraps
80105fb4:	e9 71 fa ff ff       	jmp    80105a2a <alltraps>

80105fb9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $16
80105fbb:	6a 10                	push   $0x10
  jmp alltraps
80105fbd:	e9 68 fa ff ff       	jmp    80105a2a <alltraps>

80105fc2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105fc2:	6a 11                	push   $0x11
  jmp alltraps
80105fc4:	e9 61 fa ff ff       	jmp    80105a2a <alltraps>

80105fc9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $18
80105fcb:	6a 12                	push   $0x12
  jmp alltraps
80105fcd:	e9 58 fa ff ff       	jmp    80105a2a <alltraps>

80105fd2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $19
80105fd4:	6a 13                	push   $0x13
  jmp alltraps
80105fd6:	e9 4f fa ff ff       	jmp    80105a2a <alltraps>

80105fdb <vector20>:
.globl vector20
vector20:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $20
80105fdd:	6a 14                	push   $0x14
  jmp alltraps
80105fdf:	e9 46 fa ff ff       	jmp    80105a2a <alltraps>

80105fe4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $21
80105fe6:	6a 15                	push   $0x15
  jmp alltraps
80105fe8:	e9 3d fa ff ff       	jmp    80105a2a <alltraps>

80105fed <vector22>:
.globl vector22
vector22:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $22
80105fef:	6a 16                	push   $0x16
  jmp alltraps
80105ff1:	e9 34 fa ff ff       	jmp    80105a2a <alltraps>

80105ff6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $23
80105ff8:	6a 17                	push   $0x17
  jmp alltraps
80105ffa:	e9 2b fa ff ff       	jmp    80105a2a <alltraps>

80105fff <vector24>:
.globl vector24
vector24:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $24
80106001:	6a 18                	push   $0x18
  jmp alltraps
80106003:	e9 22 fa ff ff       	jmp    80105a2a <alltraps>

80106008 <vector25>:
.globl vector25
vector25:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $25
8010600a:	6a 19                	push   $0x19
  jmp alltraps
8010600c:	e9 19 fa ff ff       	jmp    80105a2a <alltraps>

80106011 <vector26>:
.globl vector26
vector26:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $26
80106013:	6a 1a                	push   $0x1a
  jmp alltraps
80106015:	e9 10 fa ff ff       	jmp    80105a2a <alltraps>

8010601a <vector27>:
.globl vector27
vector27:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $27
8010601c:	6a 1b                	push   $0x1b
  jmp alltraps
8010601e:	e9 07 fa ff ff       	jmp    80105a2a <alltraps>

80106023 <vector28>:
.globl vector28
vector28:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $28
80106025:	6a 1c                	push   $0x1c
  jmp alltraps
80106027:	e9 fe f9 ff ff       	jmp    80105a2a <alltraps>

8010602c <vector29>:
.globl vector29
vector29:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $29
8010602e:	6a 1d                	push   $0x1d
  jmp alltraps
80106030:	e9 f5 f9 ff ff       	jmp    80105a2a <alltraps>

80106035 <vector30>:
.globl vector30
vector30:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $30
80106037:	6a 1e                	push   $0x1e
  jmp alltraps
80106039:	e9 ec f9 ff ff       	jmp    80105a2a <alltraps>

8010603e <vector31>:
.globl vector31
vector31:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $31
80106040:	6a 1f                	push   $0x1f
  jmp alltraps
80106042:	e9 e3 f9 ff ff       	jmp    80105a2a <alltraps>

80106047 <vector32>:
.globl vector32
vector32:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $32
80106049:	6a 20                	push   $0x20
  jmp alltraps
8010604b:	e9 da f9 ff ff       	jmp    80105a2a <alltraps>

80106050 <vector33>:
.globl vector33
vector33:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $33
80106052:	6a 21                	push   $0x21
  jmp alltraps
80106054:	e9 d1 f9 ff ff       	jmp    80105a2a <alltraps>

80106059 <vector34>:
.globl vector34
vector34:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $34
8010605b:	6a 22                	push   $0x22
  jmp alltraps
8010605d:	e9 c8 f9 ff ff       	jmp    80105a2a <alltraps>

80106062 <vector35>:
.globl vector35
vector35:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $35
80106064:	6a 23                	push   $0x23
  jmp alltraps
80106066:	e9 bf f9 ff ff       	jmp    80105a2a <alltraps>

8010606b <vector36>:
.globl vector36
vector36:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $36
8010606d:	6a 24                	push   $0x24
  jmp alltraps
8010606f:	e9 b6 f9 ff ff       	jmp    80105a2a <alltraps>

80106074 <vector37>:
.globl vector37
vector37:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $37
80106076:	6a 25                	push   $0x25
  jmp alltraps
80106078:	e9 ad f9 ff ff       	jmp    80105a2a <alltraps>

8010607d <vector38>:
.globl vector38
vector38:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $38
8010607f:	6a 26                	push   $0x26
  jmp alltraps
80106081:	e9 a4 f9 ff ff       	jmp    80105a2a <alltraps>

80106086 <vector39>:
.globl vector39
vector39:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $39
80106088:	6a 27                	push   $0x27
  jmp alltraps
8010608a:	e9 9b f9 ff ff       	jmp    80105a2a <alltraps>

8010608f <vector40>:
.globl vector40
vector40:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $40
80106091:	6a 28                	push   $0x28
  jmp alltraps
80106093:	e9 92 f9 ff ff       	jmp    80105a2a <alltraps>

80106098 <vector41>:
.globl vector41
vector41:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $41
8010609a:	6a 29                	push   $0x29
  jmp alltraps
8010609c:	e9 89 f9 ff ff       	jmp    80105a2a <alltraps>

801060a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $42
801060a3:	6a 2a                	push   $0x2a
  jmp alltraps
801060a5:	e9 80 f9 ff ff       	jmp    80105a2a <alltraps>

801060aa <vector43>:
.globl vector43
vector43:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $43
801060ac:	6a 2b                	push   $0x2b
  jmp alltraps
801060ae:	e9 77 f9 ff ff       	jmp    80105a2a <alltraps>

801060b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $44
801060b5:	6a 2c                	push   $0x2c
  jmp alltraps
801060b7:	e9 6e f9 ff ff       	jmp    80105a2a <alltraps>

801060bc <vector45>:
.globl vector45
vector45:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $45
801060be:	6a 2d                	push   $0x2d
  jmp alltraps
801060c0:	e9 65 f9 ff ff       	jmp    80105a2a <alltraps>

801060c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $46
801060c7:	6a 2e                	push   $0x2e
  jmp alltraps
801060c9:	e9 5c f9 ff ff       	jmp    80105a2a <alltraps>

801060ce <vector47>:
.globl vector47
vector47:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $47
801060d0:	6a 2f                	push   $0x2f
  jmp alltraps
801060d2:	e9 53 f9 ff ff       	jmp    80105a2a <alltraps>

801060d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $48
801060d9:	6a 30                	push   $0x30
  jmp alltraps
801060db:	e9 4a f9 ff ff       	jmp    80105a2a <alltraps>

801060e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $49
801060e2:	6a 31                	push   $0x31
  jmp alltraps
801060e4:	e9 41 f9 ff ff       	jmp    80105a2a <alltraps>

801060e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $50
801060eb:	6a 32                	push   $0x32
  jmp alltraps
801060ed:	e9 38 f9 ff ff       	jmp    80105a2a <alltraps>

801060f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $51
801060f4:	6a 33                	push   $0x33
  jmp alltraps
801060f6:	e9 2f f9 ff ff       	jmp    80105a2a <alltraps>

801060fb <vector52>:
.globl vector52
vector52:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $52
801060fd:	6a 34                	push   $0x34
  jmp alltraps
801060ff:	e9 26 f9 ff ff       	jmp    80105a2a <alltraps>

80106104 <vector53>:
.globl vector53
vector53:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $53
80106106:	6a 35                	push   $0x35
  jmp alltraps
80106108:	e9 1d f9 ff ff       	jmp    80105a2a <alltraps>

8010610d <vector54>:
.globl vector54
vector54:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $54
8010610f:	6a 36                	push   $0x36
  jmp alltraps
80106111:	e9 14 f9 ff ff       	jmp    80105a2a <alltraps>

80106116 <vector55>:
.globl vector55
vector55:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $55
80106118:	6a 37                	push   $0x37
  jmp alltraps
8010611a:	e9 0b f9 ff ff       	jmp    80105a2a <alltraps>

8010611f <vector56>:
.globl vector56
vector56:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $56
80106121:	6a 38                	push   $0x38
  jmp alltraps
80106123:	e9 02 f9 ff ff       	jmp    80105a2a <alltraps>

80106128 <vector57>:
.globl vector57
vector57:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $57
8010612a:	6a 39                	push   $0x39
  jmp alltraps
8010612c:	e9 f9 f8 ff ff       	jmp    80105a2a <alltraps>

80106131 <vector58>:
.globl vector58
vector58:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $58
80106133:	6a 3a                	push   $0x3a
  jmp alltraps
80106135:	e9 f0 f8 ff ff       	jmp    80105a2a <alltraps>

8010613a <vector59>:
.globl vector59
vector59:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $59
8010613c:	6a 3b                	push   $0x3b
  jmp alltraps
8010613e:	e9 e7 f8 ff ff       	jmp    80105a2a <alltraps>

80106143 <vector60>:
.globl vector60
vector60:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $60
80106145:	6a 3c                	push   $0x3c
  jmp alltraps
80106147:	e9 de f8 ff ff       	jmp    80105a2a <alltraps>

8010614c <vector61>:
.globl vector61
vector61:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $61
8010614e:	6a 3d                	push   $0x3d
  jmp alltraps
80106150:	e9 d5 f8 ff ff       	jmp    80105a2a <alltraps>

80106155 <vector62>:
.globl vector62
vector62:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $62
80106157:	6a 3e                	push   $0x3e
  jmp alltraps
80106159:	e9 cc f8 ff ff       	jmp    80105a2a <alltraps>

8010615e <vector63>:
.globl vector63
vector63:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $63
80106160:	6a 3f                	push   $0x3f
  jmp alltraps
80106162:	e9 c3 f8 ff ff       	jmp    80105a2a <alltraps>

80106167 <vector64>:
.globl vector64
vector64:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $64
80106169:	6a 40                	push   $0x40
  jmp alltraps
8010616b:	e9 ba f8 ff ff       	jmp    80105a2a <alltraps>

80106170 <vector65>:
.globl vector65
vector65:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $65
80106172:	6a 41                	push   $0x41
  jmp alltraps
80106174:	e9 b1 f8 ff ff       	jmp    80105a2a <alltraps>

80106179 <vector66>:
.globl vector66
vector66:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $66
8010617b:	6a 42                	push   $0x42
  jmp alltraps
8010617d:	e9 a8 f8 ff ff       	jmp    80105a2a <alltraps>

80106182 <vector67>:
.globl vector67
vector67:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $67
80106184:	6a 43                	push   $0x43
  jmp alltraps
80106186:	e9 9f f8 ff ff       	jmp    80105a2a <alltraps>

8010618b <vector68>:
.globl vector68
vector68:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $68
8010618d:	6a 44                	push   $0x44
  jmp alltraps
8010618f:	e9 96 f8 ff ff       	jmp    80105a2a <alltraps>

80106194 <vector69>:
.globl vector69
vector69:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $69
80106196:	6a 45                	push   $0x45
  jmp alltraps
80106198:	e9 8d f8 ff ff       	jmp    80105a2a <alltraps>

8010619d <vector70>:
.globl vector70
vector70:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $70
8010619f:	6a 46                	push   $0x46
  jmp alltraps
801061a1:	e9 84 f8 ff ff       	jmp    80105a2a <alltraps>

801061a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $71
801061a8:	6a 47                	push   $0x47
  jmp alltraps
801061aa:	e9 7b f8 ff ff       	jmp    80105a2a <alltraps>

801061af <vector72>:
.globl vector72
vector72:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $72
801061b1:	6a 48                	push   $0x48
  jmp alltraps
801061b3:	e9 72 f8 ff ff       	jmp    80105a2a <alltraps>

801061b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $73
801061ba:	6a 49                	push   $0x49
  jmp alltraps
801061bc:	e9 69 f8 ff ff       	jmp    80105a2a <alltraps>

801061c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $74
801061c3:	6a 4a                	push   $0x4a
  jmp alltraps
801061c5:	e9 60 f8 ff ff       	jmp    80105a2a <alltraps>

801061ca <vector75>:
.globl vector75
vector75:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $75
801061cc:	6a 4b                	push   $0x4b
  jmp alltraps
801061ce:	e9 57 f8 ff ff       	jmp    80105a2a <alltraps>

801061d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $76
801061d5:	6a 4c                	push   $0x4c
  jmp alltraps
801061d7:	e9 4e f8 ff ff       	jmp    80105a2a <alltraps>

801061dc <vector77>:
.globl vector77
vector77:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $77
801061de:	6a 4d                	push   $0x4d
  jmp alltraps
801061e0:	e9 45 f8 ff ff       	jmp    80105a2a <alltraps>

801061e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $78
801061e7:	6a 4e                	push   $0x4e
  jmp alltraps
801061e9:	e9 3c f8 ff ff       	jmp    80105a2a <alltraps>

801061ee <vector79>:
.globl vector79
vector79:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $79
801061f0:	6a 4f                	push   $0x4f
  jmp alltraps
801061f2:	e9 33 f8 ff ff       	jmp    80105a2a <alltraps>

801061f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $80
801061f9:	6a 50                	push   $0x50
  jmp alltraps
801061fb:	e9 2a f8 ff ff       	jmp    80105a2a <alltraps>

80106200 <vector81>:
.globl vector81
vector81:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $81
80106202:	6a 51                	push   $0x51
  jmp alltraps
80106204:	e9 21 f8 ff ff       	jmp    80105a2a <alltraps>

80106209 <vector82>:
.globl vector82
vector82:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $82
8010620b:	6a 52                	push   $0x52
  jmp alltraps
8010620d:	e9 18 f8 ff ff       	jmp    80105a2a <alltraps>

80106212 <vector83>:
.globl vector83
vector83:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $83
80106214:	6a 53                	push   $0x53
  jmp alltraps
80106216:	e9 0f f8 ff ff       	jmp    80105a2a <alltraps>

8010621b <vector84>:
.globl vector84
vector84:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $84
8010621d:	6a 54                	push   $0x54
  jmp alltraps
8010621f:	e9 06 f8 ff ff       	jmp    80105a2a <alltraps>

80106224 <vector85>:
.globl vector85
vector85:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $85
80106226:	6a 55                	push   $0x55
  jmp alltraps
80106228:	e9 fd f7 ff ff       	jmp    80105a2a <alltraps>

8010622d <vector86>:
.globl vector86
vector86:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $86
8010622f:	6a 56                	push   $0x56
  jmp alltraps
80106231:	e9 f4 f7 ff ff       	jmp    80105a2a <alltraps>

80106236 <vector87>:
.globl vector87
vector87:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $87
80106238:	6a 57                	push   $0x57
  jmp alltraps
8010623a:	e9 eb f7 ff ff       	jmp    80105a2a <alltraps>

8010623f <vector88>:
.globl vector88
vector88:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $88
80106241:	6a 58                	push   $0x58
  jmp alltraps
80106243:	e9 e2 f7 ff ff       	jmp    80105a2a <alltraps>

80106248 <vector89>:
.globl vector89
vector89:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $89
8010624a:	6a 59                	push   $0x59
  jmp alltraps
8010624c:	e9 d9 f7 ff ff       	jmp    80105a2a <alltraps>

80106251 <vector90>:
.globl vector90
vector90:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $90
80106253:	6a 5a                	push   $0x5a
  jmp alltraps
80106255:	e9 d0 f7 ff ff       	jmp    80105a2a <alltraps>

8010625a <vector91>:
.globl vector91
vector91:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $91
8010625c:	6a 5b                	push   $0x5b
  jmp alltraps
8010625e:	e9 c7 f7 ff ff       	jmp    80105a2a <alltraps>

80106263 <vector92>:
.globl vector92
vector92:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $92
80106265:	6a 5c                	push   $0x5c
  jmp alltraps
80106267:	e9 be f7 ff ff       	jmp    80105a2a <alltraps>

8010626c <vector93>:
.globl vector93
vector93:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $93
8010626e:	6a 5d                	push   $0x5d
  jmp alltraps
80106270:	e9 b5 f7 ff ff       	jmp    80105a2a <alltraps>

80106275 <vector94>:
.globl vector94
vector94:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $94
80106277:	6a 5e                	push   $0x5e
  jmp alltraps
80106279:	e9 ac f7 ff ff       	jmp    80105a2a <alltraps>

8010627e <vector95>:
.globl vector95
vector95:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $95
80106280:	6a 5f                	push   $0x5f
  jmp alltraps
80106282:	e9 a3 f7 ff ff       	jmp    80105a2a <alltraps>

80106287 <vector96>:
.globl vector96
vector96:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $96
80106289:	6a 60                	push   $0x60
  jmp alltraps
8010628b:	e9 9a f7 ff ff       	jmp    80105a2a <alltraps>

80106290 <vector97>:
.globl vector97
vector97:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $97
80106292:	6a 61                	push   $0x61
  jmp alltraps
80106294:	e9 91 f7 ff ff       	jmp    80105a2a <alltraps>

80106299 <vector98>:
.globl vector98
vector98:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $98
8010629b:	6a 62                	push   $0x62
  jmp alltraps
8010629d:	e9 88 f7 ff ff       	jmp    80105a2a <alltraps>

801062a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $99
801062a4:	6a 63                	push   $0x63
  jmp alltraps
801062a6:	e9 7f f7 ff ff       	jmp    80105a2a <alltraps>

801062ab <vector100>:
.globl vector100
vector100:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $100
801062ad:	6a 64                	push   $0x64
  jmp alltraps
801062af:	e9 76 f7 ff ff       	jmp    80105a2a <alltraps>

801062b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $101
801062b6:	6a 65                	push   $0x65
  jmp alltraps
801062b8:	e9 6d f7 ff ff       	jmp    80105a2a <alltraps>

801062bd <vector102>:
.globl vector102
vector102:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $102
801062bf:	6a 66                	push   $0x66
  jmp alltraps
801062c1:	e9 64 f7 ff ff       	jmp    80105a2a <alltraps>

801062c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $103
801062c8:	6a 67                	push   $0x67
  jmp alltraps
801062ca:	e9 5b f7 ff ff       	jmp    80105a2a <alltraps>

801062cf <vector104>:
.globl vector104
vector104:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $104
801062d1:	6a 68                	push   $0x68
  jmp alltraps
801062d3:	e9 52 f7 ff ff       	jmp    80105a2a <alltraps>

801062d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $105
801062da:	6a 69                	push   $0x69
  jmp alltraps
801062dc:	e9 49 f7 ff ff       	jmp    80105a2a <alltraps>

801062e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $106
801062e3:	6a 6a                	push   $0x6a
  jmp alltraps
801062e5:	e9 40 f7 ff ff       	jmp    80105a2a <alltraps>

801062ea <vector107>:
.globl vector107
vector107:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $107
801062ec:	6a 6b                	push   $0x6b
  jmp alltraps
801062ee:	e9 37 f7 ff ff       	jmp    80105a2a <alltraps>

801062f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $108
801062f5:	6a 6c                	push   $0x6c
  jmp alltraps
801062f7:	e9 2e f7 ff ff       	jmp    80105a2a <alltraps>

801062fc <vector109>:
.globl vector109
vector109:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $109
801062fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106300:	e9 25 f7 ff ff       	jmp    80105a2a <alltraps>

80106305 <vector110>:
.globl vector110
vector110:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $110
80106307:	6a 6e                	push   $0x6e
  jmp alltraps
80106309:	e9 1c f7 ff ff       	jmp    80105a2a <alltraps>

8010630e <vector111>:
.globl vector111
vector111:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $111
80106310:	6a 6f                	push   $0x6f
  jmp alltraps
80106312:	e9 13 f7 ff ff       	jmp    80105a2a <alltraps>

80106317 <vector112>:
.globl vector112
vector112:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $112
80106319:	6a 70                	push   $0x70
  jmp alltraps
8010631b:	e9 0a f7 ff ff       	jmp    80105a2a <alltraps>

80106320 <vector113>:
.globl vector113
vector113:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $113
80106322:	6a 71                	push   $0x71
  jmp alltraps
80106324:	e9 01 f7 ff ff       	jmp    80105a2a <alltraps>

80106329 <vector114>:
.globl vector114
vector114:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $114
8010632b:	6a 72                	push   $0x72
  jmp alltraps
8010632d:	e9 f8 f6 ff ff       	jmp    80105a2a <alltraps>

80106332 <vector115>:
.globl vector115
vector115:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $115
80106334:	6a 73                	push   $0x73
  jmp alltraps
80106336:	e9 ef f6 ff ff       	jmp    80105a2a <alltraps>

8010633b <vector116>:
.globl vector116
vector116:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $116
8010633d:	6a 74                	push   $0x74
  jmp alltraps
8010633f:	e9 e6 f6 ff ff       	jmp    80105a2a <alltraps>

80106344 <vector117>:
.globl vector117
vector117:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $117
80106346:	6a 75                	push   $0x75
  jmp alltraps
80106348:	e9 dd f6 ff ff       	jmp    80105a2a <alltraps>

8010634d <vector118>:
.globl vector118
vector118:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $118
8010634f:	6a 76                	push   $0x76
  jmp alltraps
80106351:	e9 d4 f6 ff ff       	jmp    80105a2a <alltraps>

80106356 <vector119>:
.globl vector119
vector119:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $119
80106358:	6a 77                	push   $0x77
  jmp alltraps
8010635a:	e9 cb f6 ff ff       	jmp    80105a2a <alltraps>

8010635f <vector120>:
.globl vector120
vector120:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $120
80106361:	6a 78                	push   $0x78
  jmp alltraps
80106363:	e9 c2 f6 ff ff       	jmp    80105a2a <alltraps>

80106368 <vector121>:
.globl vector121
vector121:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $121
8010636a:	6a 79                	push   $0x79
  jmp alltraps
8010636c:	e9 b9 f6 ff ff       	jmp    80105a2a <alltraps>

80106371 <vector122>:
.globl vector122
vector122:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $122
80106373:	6a 7a                	push   $0x7a
  jmp alltraps
80106375:	e9 b0 f6 ff ff       	jmp    80105a2a <alltraps>

8010637a <vector123>:
.globl vector123
vector123:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $123
8010637c:	6a 7b                	push   $0x7b
  jmp alltraps
8010637e:	e9 a7 f6 ff ff       	jmp    80105a2a <alltraps>

80106383 <vector124>:
.globl vector124
vector124:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $124
80106385:	6a 7c                	push   $0x7c
  jmp alltraps
80106387:	e9 9e f6 ff ff       	jmp    80105a2a <alltraps>

8010638c <vector125>:
.globl vector125
vector125:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $125
8010638e:	6a 7d                	push   $0x7d
  jmp alltraps
80106390:	e9 95 f6 ff ff       	jmp    80105a2a <alltraps>

80106395 <vector126>:
.globl vector126
vector126:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $126
80106397:	6a 7e                	push   $0x7e
  jmp alltraps
80106399:	e9 8c f6 ff ff       	jmp    80105a2a <alltraps>

8010639e <vector127>:
.globl vector127
vector127:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $127
801063a0:	6a 7f                	push   $0x7f
  jmp alltraps
801063a2:	e9 83 f6 ff ff       	jmp    80105a2a <alltraps>

801063a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $128
801063a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063ae:	e9 77 f6 ff ff       	jmp    80105a2a <alltraps>

801063b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $129
801063b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063ba:	e9 6b f6 ff ff       	jmp    80105a2a <alltraps>

801063bf <vector130>:
.globl vector130
vector130:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $130
801063c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063c6:	e9 5f f6 ff ff       	jmp    80105a2a <alltraps>

801063cb <vector131>:
.globl vector131
vector131:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $131
801063cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063d2:	e9 53 f6 ff ff       	jmp    80105a2a <alltraps>

801063d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $132
801063d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063de:	e9 47 f6 ff ff       	jmp    80105a2a <alltraps>

801063e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $133
801063e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063ea:	e9 3b f6 ff ff       	jmp    80105a2a <alltraps>

801063ef <vector134>:
.globl vector134
vector134:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $134
801063f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063f6:	e9 2f f6 ff ff       	jmp    80105a2a <alltraps>

801063fb <vector135>:
.globl vector135
vector135:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $135
801063fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106402:	e9 23 f6 ff ff       	jmp    80105a2a <alltraps>

80106407 <vector136>:
.globl vector136
vector136:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $136
80106409:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010640e:	e9 17 f6 ff ff       	jmp    80105a2a <alltraps>

80106413 <vector137>:
.globl vector137
vector137:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $137
80106415:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010641a:	e9 0b f6 ff ff       	jmp    80105a2a <alltraps>

8010641f <vector138>:
.globl vector138
vector138:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $138
80106421:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106426:	e9 ff f5 ff ff       	jmp    80105a2a <alltraps>

8010642b <vector139>:
.globl vector139
vector139:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $139
8010642d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106432:	e9 f3 f5 ff ff       	jmp    80105a2a <alltraps>

80106437 <vector140>:
.globl vector140
vector140:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $140
80106439:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010643e:	e9 e7 f5 ff ff       	jmp    80105a2a <alltraps>

80106443 <vector141>:
.globl vector141
vector141:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $141
80106445:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010644a:	e9 db f5 ff ff       	jmp    80105a2a <alltraps>

8010644f <vector142>:
.globl vector142
vector142:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $142
80106451:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106456:	e9 cf f5 ff ff       	jmp    80105a2a <alltraps>

8010645b <vector143>:
.globl vector143
vector143:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $143
8010645d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106462:	e9 c3 f5 ff ff       	jmp    80105a2a <alltraps>

80106467 <vector144>:
.globl vector144
vector144:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $144
80106469:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010646e:	e9 b7 f5 ff ff       	jmp    80105a2a <alltraps>

80106473 <vector145>:
.globl vector145
vector145:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $145
80106475:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010647a:	e9 ab f5 ff ff       	jmp    80105a2a <alltraps>

8010647f <vector146>:
.globl vector146
vector146:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $146
80106481:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106486:	e9 9f f5 ff ff       	jmp    80105a2a <alltraps>

8010648b <vector147>:
.globl vector147
vector147:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $147
8010648d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106492:	e9 93 f5 ff ff       	jmp    80105a2a <alltraps>

80106497 <vector148>:
.globl vector148
vector148:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $148
80106499:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010649e:	e9 87 f5 ff ff       	jmp    80105a2a <alltraps>

801064a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $149
801064a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064aa:	e9 7b f5 ff ff       	jmp    80105a2a <alltraps>

801064af <vector150>:
.globl vector150
vector150:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $150
801064b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064b6:	e9 6f f5 ff ff       	jmp    80105a2a <alltraps>

801064bb <vector151>:
.globl vector151
vector151:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $151
801064bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064c2:	e9 63 f5 ff ff       	jmp    80105a2a <alltraps>

801064c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $152
801064c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064ce:	e9 57 f5 ff ff       	jmp    80105a2a <alltraps>

801064d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $153
801064d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064da:	e9 4b f5 ff ff       	jmp    80105a2a <alltraps>

801064df <vector154>:
.globl vector154
vector154:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $154
801064e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064e6:	e9 3f f5 ff ff       	jmp    80105a2a <alltraps>

801064eb <vector155>:
.globl vector155
vector155:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $155
801064ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064f2:	e9 33 f5 ff ff       	jmp    80105a2a <alltraps>

801064f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $156
801064f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064fe:	e9 27 f5 ff ff       	jmp    80105a2a <alltraps>

80106503 <vector157>:
.globl vector157
vector157:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $157
80106505:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010650a:	e9 1b f5 ff ff       	jmp    80105a2a <alltraps>

8010650f <vector158>:
.globl vector158
vector158:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $158
80106511:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106516:	e9 0f f5 ff ff       	jmp    80105a2a <alltraps>

8010651b <vector159>:
.globl vector159
vector159:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $159
8010651d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106522:	e9 03 f5 ff ff       	jmp    80105a2a <alltraps>

80106527 <vector160>:
.globl vector160
vector160:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $160
80106529:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010652e:	e9 f7 f4 ff ff       	jmp    80105a2a <alltraps>

80106533 <vector161>:
.globl vector161
vector161:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $161
80106535:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010653a:	e9 eb f4 ff ff       	jmp    80105a2a <alltraps>

8010653f <vector162>:
.globl vector162
vector162:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $162
80106541:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106546:	e9 df f4 ff ff       	jmp    80105a2a <alltraps>

8010654b <vector163>:
.globl vector163
vector163:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $163
8010654d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106552:	e9 d3 f4 ff ff       	jmp    80105a2a <alltraps>

80106557 <vector164>:
.globl vector164
vector164:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $164
80106559:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010655e:	e9 c7 f4 ff ff       	jmp    80105a2a <alltraps>

80106563 <vector165>:
.globl vector165
vector165:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $165
80106565:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010656a:	e9 bb f4 ff ff       	jmp    80105a2a <alltraps>

8010656f <vector166>:
.globl vector166
vector166:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $166
80106571:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106576:	e9 af f4 ff ff       	jmp    80105a2a <alltraps>

8010657b <vector167>:
.globl vector167
vector167:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $167
8010657d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106582:	e9 a3 f4 ff ff       	jmp    80105a2a <alltraps>

80106587 <vector168>:
.globl vector168
vector168:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $168
80106589:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010658e:	e9 97 f4 ff ff       	jmp    80105a2a <alltraps>

80106593 <vector169>:
.globl vector169
vector169:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $169
80106595:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010659a:	e9 8b f4 ff ff       	jmp    80105a2a <alltraps>

8010659f <vector170>:
.globl vector170
vector170:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $170
801065a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065a6:	e9 7f f4 ff ff       	jmp    80105a2a <alltraps>

801065ab <vector171>:
.globl vector171
vector171:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $171
801065ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065b2:	e9 73 f4 ff ff       	jmp    80105a2a <alltraps>

801065b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $172
801065b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065be:	e9 67 f4 ff ff       	jmp    80105a2a <alltraps>

801065c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $173
801065c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065ca:	e9 5b f4 ff ff       	jmp    80105a2a <alltraps>

801065cf <vector174>:
.globl vector174
vector174:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $174
801065d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065d6:	e9 4f f4 ff ff       	jmp    80105a2a <alltraps>

801065db <vector175>:
.globl vector175
vector175:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $175
801065dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065e2:	e9 43 f4 ff ff       	jmp    80105a2a <alltraps>

801065e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $176
801065e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065ee:	e9 37 f4 ff ff       	jmp    80105a2a <alltraps>

801065f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $177
801065f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065fa:	e9 2b f4 ff ff       	jmp    80105a2a <alltraps>

801065ff <vector178>:
.globl vector178
vector178:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $178
80106601:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106606:	e9 1f f4 ff ff       	jmp    80105a2a <alltraps>

8010660b <vector179>:
.globl vector179
vector179:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $179
8010660d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106612:	e9 13 f4 ff ff       	jmp    80105a2a <alltraps>

80106617 <vector180>:
.globl vector180
vector180:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $180
80106619:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010661e:	e9 07 f4 ff ff       	jmp    80105a2a <alltraps>

80106623 <vector181>:
.globl vector181
vector181:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $181
80106625:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010662a:	e9 fb f3 ff ff       	jmp    80105a2a <alltraps>

8010662f <vector182>:
.globl vector182
vector182:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $182
80106631:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106636:	e9 ef f3 ff ff       	jmp    80105a2a <alltraps>

8010663b <vector183>:
.globl vector183
vector183:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $183
8010663d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106642:	e9 e3 f3 ff ff       	jmp    80105a2a <alltraps>

80106647 <vector184>:
.globl vector184
vector184:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $184
80106649:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010664e:	e9 d7 f3 ff ff       	jmp    80105a2a <alltraps>

80106653 <vector185>:
.globl vector185
vector185:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $185
80106655:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010665a:	e9 cb f3 ff ff       	jmp    80105a2a <alltraps>

8010665f <vector186>:
.globl vector186
vector186:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $186
80106661:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106666:	e9 bf f3 ff ff       	jmp    80105a2a <alltraps>

8010666b <vector187>:
.globl vector187
vector187:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $187
8010666d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106672:	e9 b3 f3 ff ff       	jmp    80105a2a <alltraps>

80106677 <vector188>:
.globl vector188
vector188:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $188
80106679:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010667e:	e9 a7 f3 ff ff       	jmp    80105a2a <alltraps>

80106683 <vector189>:
.globl vector189
vector189:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $189
80106685:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010668a:	e9 9b f3 ff ff       	jmp    80105a2a <alltraps>

8010668f <vector190>:
.globl vector190
vector190:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $190
80106691:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106696:	e9 8f f3 ff ff       	jmp    80105a2a <alltraps>

8010669b <vector191>:
.globl vector191
vector191:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $191
8010669d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066a2:	e9 83 f3 ff ff       	jmp    80105a2a <alltraps>

801066a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $192
801066a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066ae:	e9 77 f3 ff ff       	jmp    80105a2a <alltraps>

801066b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $193
801066b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066ba:	e9 6b f3 ff ff       	jmp    80105a2a <alltraps>

801066bf <vector194>:
.globl vector194
vector194:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $194
801066c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066c6:	e9 5f f3 ff ff       	jmp    80105a2a <alltraps>

801066cb <vector195>:
.globl vector195
vector195:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $195
801066cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066d2:	e9 53 f3 ff ff       	jmp    80105a2a <alltraps>

801066d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $196
801066d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066de:	e9 47 f3 ff ff       	jmp    80105a2a <alltraps>

801066e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $197
801066e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066ea:	e9 3b f3 ff ff       	jmp    80105a2a <alltraps>

801066ef <vector198>:
.globl vector198
vector198:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $198
801066f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066f6:	e9 2f f3 ff ff       	jmp    80105a2a <alltraps>

801066fb <vector199>:
.globl vector199
vector199:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $199
801066fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106702:	e9 23 f3 ff ff       	jmp    80105a2a <alltraps>

80106707 <vector200>:
.globl vector200
vector200:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $200
80106709:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010670e:	e9 17 f3 ff ff       	jmp    80105a2a <alltraps>

80106713 <vector201>:
.globl vector201
vector201:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $201
80106715:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010671a:	e9 0b f3 ff ff       	jmp    80105a2a <alltraps>

8010671f <vector202>:
.globl vector202
vector202:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $202
80106721:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106726:	e9 ff f2 ff ff       	jmp    80105a2a <alltraps>

8010672b <vector203>:
.globl vector203
vector203:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $203
8010672d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106732:	e9 f3 f2 ff ff       	jmp    80105a2a <alltraps>

80106737 <vector204>:
.globl vector204
vector204:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $204
80106739:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010673e:	e9 e7 f2 ff ff       	jmp    80105a2a <alltraps>

80106743 <vector205>:
.globl vector205
vector205:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $205
80106745:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010674a:	e9 db f2 ff ff       	jmp    80105a2a <alltraps>

8010674f <vector206>:
.globl vector206
vector206:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $206
80106751:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106756:	e9 cf f2 ff ff       	jmp    80105a2a <alltraps>

8010675b <vector207>:
.globl vector207
vector207:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $207
8010675d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106762:	e9 c3 f2 ff ff       	jmp    80105a2a <alltraps>

80106767 <vector208>:
.globl vector208
vector208:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $208
80106769:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010676e:	e9 b7 f2 ff ff       	jmp    80105a2a <alltraps>

80106773 <vector209>:
.globl vector209
vector209:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $209
80106775:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010677a:	e9 ab f2 ff ff       	jmp    80105a2a <alltraps>

8010677f <vector210>:
.globl vector210
vector210:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $210
80106781:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106786:	e9 9f f2 ff ff       	jmp    80105a2a <alltraps>

8010678b <vector211>:
.globl vector211
vector211:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $211
8010678d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106792:	e9 93 f2 ff ff       	jmp    80105a2a <alltraps>

80106797 <vector212>:
.globl vector212
vector212:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $212
80106799:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010679e:	e9 87 f2 ff ff       	jmp    80105a2a <alltraps>

801067a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $213
801067a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067aa:	e9 7b f2 ff ff       	jmp    80105a2a <alltraps>

801067af <vector214>:
.globl vector214
vector214:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $214
801067b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067b6:	e9 6f f2 ff ff       	jmp    80105a2a <alltraps>

801067bb <vector215>:
.globl vector215
vector215:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $215
801067bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067c2:	e9 63 f2 ff ff       	jmp    80105a2a <alltraps>

801067c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $216
801067c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067ce:	e9 57 f2 ff ff       	jmp    80105a2a <alltraps>

801067d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $217
801067d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067da:	e9 4b f2 ff ff       	jmp    80105a2a <alltraps>

801067df <vector218>:
.globl vector218
vector218:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $218
801067e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067e6:	e9 3f f2 ff ff       	jmp    80105a2a <alltraps>

801067eb <vector219>:
.globl vector219
vector219:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $219
801067ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067f2:	e9 33 f2 ff ff       	jmp    80105a2a <alltraps>

801067f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $220
801067f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067fe:	e9 27 f2 ff ff       	jmp    80105a2a <alltraps>

80106803 <vector221>:
.globl vector221
vector221:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $221
80106805:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010680a:	e9 1b f2 ff ff       	jmp    80105a2a <alltraps>

8010680f <vector222>:
.globl vector222
vector222:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $222
80106811:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106816:	e9 0f f2 ff ff       	jmp    80105a2a <alltraps>

8010681b <vector223>:
.globl vector223
vector223:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $223
8010681d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106822:	e9 03 f2 ff ff       	jmp    80105a2a <alltraps>

80106827 <vector224>:
.globl vector224
vector224:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $224
80106829:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010682e:	e9 f7 f1 ff ff       	jmp    80105a2a <alltraps>

80106833 <vector225>:
.globl vector225
vector225:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $225
80106835:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010683a:	e9 eb f1 ff ff       	jmp    80105a2a <alltraps>

8010683f <vector226>:
.globl vector226
vector226:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $226
80106841:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106846:	e9 df f1 ff ff       	jmp    80105a2a <alltraps>

8010684b <vector227>:
.globl vector227
vector227:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $227
8010684d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106852:	e9 d3 f1 ff ff       	jmp    80105a2a <alltraps>

80106857 <vector228>:
.globl vector228
vector228:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $228
80106859:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010685e:	e9 c7 f1 ff ff       	jmp    80105a2a <alltraps>

80106863 <vector229>:
.globl vector229
vector229:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $229
80106865:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010686a:	e9 bb f1 ff ff       	jmp    80105a2a <alltraps>

8010686f <vector230>:
.globl vector230
vector230:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $230
80106871:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106876:	e9 af f1 ff ff       	jmp    80105a2a <alltraps>

8010687b <vector231>:
.globl vector231
vector231:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $231
8010687d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106882:	e9 a3 f1 ff ff       	jmp    80105a2a <alltraps>

80106887 <vector232>:
.globl vector232
vector232:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $232
80106889:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010688e:	e9 97 f1 ff ff       	jmp    80105a2a <alltraps>

80106893 <vector233>:
.globl vector233
vector233:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $233
80106895:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010689a:	e9 8b f1 ff ff       	jmp    80105a2a <alltraps>

8010689f <vector234>:
.globl vector234
vector234:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $234
801068a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068a6:	e9 7f f1 ff ff       	jmp    80105a2a <alltraps>

801068ab <vector235>:
.globl vector235
vector235:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $235
801068ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068b2:	e9 73 f1 ff ff       	jmp    80105a2a <alltraps>

801068b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $236
801068b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068be:	e9 67 f1 ff ff       	jmp    80105a2a <alltraps>

801068c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $237
801068c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068ca:	e9 5b f1 ff ff       	jmp    80105a2a <alltraps>

801068cf <vector238>:
.globl vector238
vector238:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $238
801068d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068d6:	e9 4f f1 ff ff       	jmp    80105a2a <alltraps>

801068db <vector239>:
.globl vector239
vector239:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $239
801068dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068e2:	e9 43 f1 ff ff       	jmp    80105a2a <alltraps>

801068e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $240
801068e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068ee:	e9 37 f1 ff ff       	jmp    80105a2a <alltraps>

801068f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $241
801068f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068fa:	e9 2b f1 ff ff       	jmp    80105a2a <alltraps>

801068ff <vector242>:
.globl vector242
vector242:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $242
80106901:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106906:	e9 1f f1 ff ff       	jmp    80105a2a <alltraps>

8010690b <vector243>:
.globl vector243
vector243:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $243
8010690d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106912:	e9 13 f1 ff ff       	jmp    80105a2a <alltraps>

80106917 <vector244>:
.globl vector244
vector244:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $244
80106919:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010691e:	e9 07 f1 ff ff       	jmp    80105a2a <alltraps>

80106923 <vector245>:
.globl vector245
vector245:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $245
80106925:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010692a:	e9 fb f0 ff ff       	jmp    80105a2a <alltraps>

8010692f <vector246>:
.globl vector246
vector246:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $246
80106931:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106936:	e9 ef f0 ff ff       	jmp    80105a2a <alltraps>

8010693b <vector247>:
.globl vector247
vector247:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $247
8010693d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106942:	e9 e3 f0 ff ff       	jmp    80105a2a <alltraps>

80106947 <vector248>:
.globl vector248
vector248:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $248
80106949:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010694e:	e9 d7 f0 ff ff       	jmp    80105a2a <alltraps>

80106953 <vector249>:
.globl vector249
vector249:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $249
80106955:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010695a:	e9 cb f0 ff ff       	jmp    80105a2a <alltraps>

8010695f <vector250>:
.globl vector250
vector250:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $250
80106961:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106966:	e9 bf f0 ff ff       	jmp    80105a2a <alltraps>

8010696b <vector251>:
.globl vector251
vector251:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $251
8010696d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106972:	e9 b3 f0 ff ff       	jmp    80105a2a <alltraps>

80106977 <vector252>:
.globl vector252
vector252:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $252
80106979:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010697e:	e9 a7 f0 ff ff       	jmp    80105a2a <alltraps>

80106983 <vector253>:
.globl vector253
vector253:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $253
80106985:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010698a:	e9 9b f0 ff ff       	jmp    80105a2a <alltraps>

8010698f <vector254>:
.globl vector254
vector254:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $254
80106991:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106996:	e9 8f f0 ff ff       	jmp    80105a2a <alltraps>

8010699b <vector255>:
.globl vector255
vector255:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $255
8010699d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069a2:	e9 83 f0 ff ff       	jmp    80105a2a <alltraps>
801069a7:	66 90                	xchg   %ax,%ax
801069a9:	66 90                	xchg   %ax,%ax
801069ab:	66 90                	xchg   %ax,%ax
801069ad:	66 90                	xchg   %ax,%ax
801069af:	90                   	nop

801069b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069b6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069bc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069c2:	83 ec 1c             	sub    $0x1c,%esp
801069c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069c8:	39 d3                	cmp    %edx,%ebx
801069ca:	73 45                	jae    80106a11 <deallocuvm.part.0+0x61>
801069cc:	89 c7                	mov    %eax,%edi
801069ce:	eb 0a                	jmp    801069da <deallocuvm.part.0+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069d0:	8d 59 01             	lea    0x1(%ecx),%ebx
801069d3:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069d6:	39 da                	cmp    %ebx,%edx
801069d8:	76 37                	jbe    80106a11 <deallocuvm.part.0+0x61>
  pde = &pgdir[PDX(va)];
801069da:	89 d9                	mov    %ebx,%ecx
801069dc:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801069df:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
801069e2:	a8 01                	test   $0x1,%al
801069e4:	74 ea                	je     801069d0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801069e6:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801069ed:	c1 ee 0a             	shr    $0xa,%esi
801069f0:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801069f6:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if(!pte)
801069fd:	85 f6                	test   %esi,%esi
801069ff:	74 cf                	je     801069d0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106a01:	8b 06                	mov    (%esi),%eax
80106a03:	a8 01                	test   $0x1,%al
80106a05:	75 19                	jne    80106a20 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106a07:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a0d:	39 da                	cmp    %ebx,%edx
80106a0f:	77 c9                	ja     801069da <deallocuvm.part.0+0x2a>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a11:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a17:	5b                   	pop    %ebx
80106a18:	5e                   	pop    %esi
80106a19:	5f                   	pop    %edi
80106a1a:	5d                   	pop    %ebp
80106a1b:	c3                   	ret    
80106a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106a20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a25:	74 25                	je     80106a4c <deallocuvm.part.0+0x9c>
      kfree(v);
80106a27:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a2a:	05 00 00 00 80       	add    $0x80000000,%eax
80106a2f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a38:	50                   	push   %eax
80106a39:	e8 62 bc ff ff       	call   801026a0 <kfree>
      *pte = 0;
80106a3e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106a44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a47:	83 c4 10             	add    $0x10,%esp
80106a4a:	eb 8a                	jmp    801069d6 <deallocuvm.part.0+0x26>
        panic("kfree");
80106a4c:	83 ec 0c             	sub    $0xc,%esp
80106a4f:	68 06 76 10 80       	push   $0x80107606
80106a54:	e8 27 99 ff ff       	call   80100380 <panic>
80106a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a60 <mappages>:
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a66:	89 d3                	mov    %edx,%ebx
80106a68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a6e:	83 ec 1c             	sub    $0x1c,%esp
80106a71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a80:	8b 45 08             	mov    0x8(%ebp),%eax
80106a83:	29 d8                	sub    %ebx,%eax
80106a85:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a88:	eb 3d                	jmp    80106ac7 <mappages+0x67>
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106a90:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a97:	c1 ea 0a             	shr    $0xa,%edx
80106a9a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106aa0:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106aa7:	85 d2                	test   %edx,%edx
80106aa9:	74 75                	je     80106b20 <mappages+0xc0>
    if(*pte & PTE_P)
80106aab:	f6 02 01             	testb  $0x1,(%edx)
80106aae:	0f 85 86 00 00 00    	jne    80106b3a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ab4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ab7:	83 ce 01             	or     $0x1,%esi
80106aba:	89 32                	mov    %esi,(%edx)
    if(a == last)
80106abc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106abf:	74 6f                	je     80106b30 <mappages+0xd0>
    a += PGSIZE;
80106ac1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106aca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106acd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106ad0:	89 d8                	mov    %ebx,%eax
80106ad2:	c1 e8 16             	shr    $0x16,%eax
80106ad5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106ad8:	8b 07                	mov    (%edi),%eax
80106ada:	a8 01                	test   $0x1,%al
80106adc:	75 b2                	jne    80106a90 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ade:	e8 7d bd ff ff       	call   80102860 <kalloc>
80106ae3:	85 c0                	test   %eax,%eax
80106ae5:	74 39                	je     80106b20 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ae7:	83 ec 04             	sub    $0x4,%esp
80106aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106aed:	68 00 10 00 00       	push   $0x1000
80106af2:	6a 00                	push   $0x0
80106af4:	50                   	push   %eax
80106af5:	e8 56 dd ff ff       	call   80104850 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106afa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106afd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b00:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b06:	83 c8 07             	or     $0x7,%eax
80106b09:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b0b:	89 d8                	mov    %ebx,%eax
80106b0d:	c1 e8 0a             	shr    $0xa,%eax
80106b10:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b15:	01 c2                	add    %eax,%edx
80106b17:	eb 92                	jmp    80106aab <mappages+0x4b>
80106b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b28:	5b                   	pop    %ebx
80106b29:	5e                   	pop    %esi
80106b2a:	5f                   	pop    %edi
80106b2b:	5d                   	pop    %ebp
80106b2c:	c3                   	ret    
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret    
      panic("remap");
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	68 48 7c 10 80       	push   $0x80107c48
80106b42:	e8 39 98 ff ff       	call   80100380 <panic>
80106b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b4e:	66 90                	xchg   %ax,%ax

80106b50 <seginit>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b56:	e8 e5 cf ff ff       	call   80103b40 <cpuid>
  pd[0] = size-1;
80106b5b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b60:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b66:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b6a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106b71:	ff 00 00 
80106b74:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106b7b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b7e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106b85:	ff 00 00 
80106b88:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106b8f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b92:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106b99:	ff 00 00 
80106b9c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106ba3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ba6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106bad:	ff 00 00 
80106bb0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106bb7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106bba:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106bbf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bc3:	c1 e8 10             	shr    $0x10,%eax
80106bc6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bca:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bcd:	0f 01 10             	lgdtl  (%eax)
}
80106bd0:	c9                   	leave  
80106bd1:	c3                   	ret    
80106bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106be0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106be0:	a1 c4 44 11 80       	mov    0x801144c4,%eax
80106be5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bea:	0f 22 d8             	mov    %eax,%cr3
}
80106bed:	c3                   	ret    
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <switchuvm>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106bfc:	85 f6                	test   %esi,%esi
80106bfe:	0f 84 cb 00 00 00    	je     80106ccf <switchuvm+0xdf>
  if(p->kstack == 0)
80106c04:	8b 46 08             	mov    0x8(%esi),%eax
80106c07:	85 c0                	test   %eax,%eax
80106c09:	0f 84 da 00 00 00    	je     80106ce9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c0f:	8b 46 04             	mov    0x4(%esi),%eax
80106c12:	85 c0                	test   %eax,%eax
80106c14:	0f 84 c2 00 00 00    	je     80106cdc <switchuvm+0xec>
  pushcli();
80106c1a:	e8 21 da ff ff       	call   80104640 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c1f:	e8 ac ce ff ff       	call   80103ad0 <mycpu>
80106c24:	89 c3                	mov    %eax,%ebx
80106c26:	e8 a5 ce ff ff       	call   80103ad0 <mycpu>
80106c2b:	89 c7                	mov    %eax,%edi
80106c2d:	e8 9e ce ff ff       	call   80103ad0 <mycpu>
80106c32:	83 c7 08             	add    $0x8,%edi
80106c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c38:	e8 93 ce ff ff       	call   80103ad0 <mycpu>
80106c3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c40:	ba 67 00 00 00       	mov    $0x67,%edx
80106c45:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c4c:	83 c0 08             	add    $0x8,%eax
80106c4f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c56:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c5b:	83 c1 08             	add    $0x8,%ecx
80106c5e:	c1 e8 18             	shr    $0x18,%eax
80106c61:	c1 e9 10             	shr    $0x10,%ecx
80106c64:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c6a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c75:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c81:	e8 4a ce ff ff       	call   80103ad0 <mycpu>
80106c86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c8d:	e8 3e ce ff ff       	call   80103ad0 <mycpu>
80106c92:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c96:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c99:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c9f:	e8 2c ce ff ff       	call   80103ad0 <mycpu>
80106ca4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ca7:	e8 24 ce ff ff       	call   80103ad0 <mycpu>
80106cac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106cb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106cb5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cb8:	8b 46 04             	mov    0x4(%esi),%eax
80106cbb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cc0:	0f 22 d8             	mov    %eax,%cr3
}
80106cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cc6:	5b                   	pop    %ebx
80106cc7:	5e                   	pop    %esi
80106cc8:	5f                   	pop    %edi
80106cc9:	5d                   	pop    %ebp
  popcli();
80106cca:	e9 c1 d9 ff ff       	jmp    80104690 <popcli>
    panic("switchuvm: no process");
80106ccf:	83 ec 0c             	sub    $0xc,%esp
80106cd2:	68 4e 7c 10 80       	push   $0x80107c4e
80106cd7:	e8 a4 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106cdc:	83 ec 0c             	sub    $0xc,%esp
80106cdf:	68 79 7c 10 80       	push   $0x80107c79
80106ce4:	e8 97 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106ce9:	83 ec 0c             	sub    $0xc,%esp
80106cec:	68 64 7c 10 80       	push   $0x80107c64
80106cf1:	e8 8a 96 ff ff       	call   80100380 <panic>
80106cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cfd:	8d 76 00             	lea    0x0(%esi),%esi

80106d00 <inituvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d0c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d0f:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d15:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d1b:	77 4b                	ja     80106d68 <inituvm+0x68>
  mem = kalloc();
80106d1d:	e8 3e bb ff ff       	call   80102860 <kalloc>
  memset(mem, 0, PGSIZE);
80106d22:	83 ec 04             	sub    $0x4,%esp
80106d25:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d2a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d2c:	6a 00                	push   $0x0
80106d2e:	50                   	push   %eax
80106d2f:	e8 1c db ff ff       	call   80104850 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d34:	58                   	pop    %eax
80106d35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d3b:	5a                   	pop    %edx
80106d3c:	6a 06                	push   $0x6
80106d3e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d43:	31 d2                	xor    %edx,%edx
80106d45:	50                   	push   %eax
80106d46:	89 f8                	mov    %edi,%eax
80106d48:	e8 13 fd ff ff       	call   80106a60 <mappages>
  memmove(mem, init, sz);
80106d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d50:	89 75 10             	mov    %esi,0x10(%ebp)
80106d53:	83 c4 10             	add    $0x10,%esp
80106d56:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106d59:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d5f:	5b                   	pop    %ebx
80106d60:	5e                   	pop    %esi
80106d61:	5f                   	pop    %edi
80106d62:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d63:	e9 88 db ff ff       	jmp    801048f0 <memmove>
    panic("inituvm: more than a page");
80106d68:	83 ec 0c             	sub    $0xc,%esp
80106d6b:	68 8d 7c 10 80       	push   $0x80107c8d
80106d70:	e8 0b 96 ff ff       	call   80100380 <panic>
80106d75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d80 <loaduvm>:
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 1c             	sub    $0x1c,%esp
80106d89:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d8c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106d8f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106d94:	0f 85 bb 00 00 00    	jne    80106e55 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80106d9a:	01 f0                	add    %esi,%eax
80106d9c:	89 f3                	mov    %esi,%ebx
80106d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106da1:	8b 45 14             	mov    0x14(%ebp),%eax
80106da4:	01 f0                	add    %esi,%eax
80106da6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106da9:	85 f6                	test   %esi,%esi
80106dab:	0f 84 87 00 00 00    	je     80106e38 <loaduvm+0xb8>
80106db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80106db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80106dbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106dbe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80106dc0:	89 c2                	mov    %eax,%edx
80106dc2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106dc5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80106dc8:	f6 c2 01             	test   $0x1,%dl
80106dcb:	75 13                	jne    80106de0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80106dcd:	83 ec 0c             	sub    $0xc,%esp
80106dd0:	68 a7 7c 10 80       	push   $0x80107ca7
80106dd5:	e8 a6 95 ff ff       	call   80100380 <panic>
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106de0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106de3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106de9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106dee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106df5:	85 c0                	test   %eax,%eax
80106df7:	74 d4                	je     80106dcd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80106df9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dfb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106dfe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e08:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106e0e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e11:	29 d9                	sub    %ebx,%ecx
80106e13:	05 00 00 00 80       	add    $0x80000000,%eax
80106e18:	57                   	push   %edi
80106e19:	51                   	push   %ecx
80106e1a:	50                   	push   %eax
80106e1b:	ff 75 10             	push   0x10(%ebp)
80106e1e:	e8 4d ae ff ff       	call   80101c70 <readi>
80106e23:	83 c4 10             	add    $0x10,%esp
80106e26:	39 f8                	cmp    %edi,%eax
80106e28:	75 1e                	jne    80106e48 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e2a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e30:	89 f0                	mov    %esi,%eax
80106e32:	29 d8                	sub    %ebx,%eax
80106e34:	39 c6                	cmp    %eax,%esi
80106e36:	77 80                	ja     80106db8 <loaduvm+0x38>
}
80106e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e3b:	31 c0                	xor    %eax,%eax
}
80106e3d:	5b                   	pop    %ebx
80106e3e:	5e                   	pop    %esi
80106e3f:	5f                   	pop    %edi
80106e40:	5d                   	pop    %ebp
80106e41:	c3                   	ret    
80106e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e50:	5b                   	pop    %ebx
80106e51:	5e                   	pop    %esi
80106e52:	5f                   	pop    %edi
80106e53:	5d                   	pop    %ebp
80106e54:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80106e55:	83 ec 0c             	sub    $0xc,%esp
80106e58:	68 48 7d 10 80       	push   $0x80107d48
80106e5d:	e8 1e 95 ff ff       	call   80100380 <panic>
80106e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e70 <allocuvm>:
{
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	57                   	push   %edi
80106e74:	56                   	push   %esi
80106e75:	53                   	push   %ebx
80106e76:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106e79:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106e7c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106e7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e82:	85 c0                	test   %eax,%eax
80106e84:	0f 88 b6 00 00 00    	js     80106f40 <allocuvm+0xd0>
  if(newsz < oldsz)
80106e8a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106e90:	0f 82 9a 00 00 00    	jb     80106f30 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106e96:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106e9c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106ea2:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ea5:	77 44                	ja     80106eeb <allocuvm+0x7b>
80106ea7:	e9 87 00 00 00       	jmp    80106f33 <allocuvm+0xc3>
80106eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106eb0:	83 ec 04             	sub    $0x4,%esp
80106eb3:	68 00 10 00 00       	push   $0x1000
80106eb8:	6a 00                	push   $0x0
80106eba:	50                   	push   %eax
80106ebb:	e8 90 d9 ff ff       	call   80104850 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ec0:	58                   	pop    %eax
80106ec1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ec7:	5a                   	pop    %edx
80106ec8:	6a 06                	push   $0x6
80106eca:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ecf:	89 f2                	mov    %esi,%edx
80106ed1:	50                   	push   %eax
80106ed2:	89 f8                	mov    %edi,%eax
80106ed4:	e8 87 fb ff ff       	call   80106a60 <mappages>
80106ed9:	83 c4 10             	add    $0x10,%esp
80106edc:	85 c0                	test   %eax,%eax
80106ede:	78 78                	js     80106f58 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106ee0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ee6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ee9:	76 48                	jbe    80106f33 <allocuvm+0xc3>
    mem = kalloc();
80106eeb:	e8 70 b9 ff ff       	call   80102860 <kalloc>
80106ef0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106ef2:	85 c0                	test   %eax,%eax
80106ef4:	75 ba                	jne    80106eb0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106ef6:	83 ec 0c             	sub    $0xc,%esp
80106ef9:	68 c5 7c 10 80       	push   $0x80107cc5
80106efe:	e8 7d 97 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80106f03:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f06:	83 c4 10             	add    $0x10,%esp
80106f09:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f0c:	74 32                	je     80106f40 <allocuvm+0xd0>
80106f0e:	8b 55 10             	mov    0x10(%ebp),%edx
80106f11:	89 c1                	mov    %eax,%ecx
80106f13:	89 f8                	mov    %edi,%eax
80106f15:	e8 96 fa ff ff       	call   801069b0 <deallocuvm.part.0>
      return 0;
80106f1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f27:	5b                   	pop    %ebx
80106f28:	5e                   	pop    %esi
80106f29:	5f                   	pop    %edi
80106f2a:	5d                   	pop    %ebp
80106f2b:	c3                   	ret    
80106f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106f30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106f33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f39:	5b                   	pop    %ebx
80106f3a:	5e                   	pop    %esi
80106f3b:	5f                   	pop    %edi
80106f3c:	5d                   	pop    %ebp
80106f3d:	c3                   	ret    
80106f3e:	66 90                	xchg   %ax,%ax
    return 0;
80106f40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f4d:	5b                   	pop    %ebx
80106f4e:	5e                   	pop    %esi
80106f4f:	5f                   	pop    %edi
80106f50:	5d                   	pop    %ebp
80106f51:	c3                   	ret    
80106f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f58:	83 ec 0c             	sub    $0xc,%esp
80106f5b:	68 dd 7c 10 80       	push   $0x80107cdd
80106f60:	e8 1b 97 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80106f65:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f68:	83 c4 10             	add    $0x10,%esp
80106f6b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f6e:	74 0c                	je     80106f7c <allocuvm+0x10c>
80106f70:	8b 55 10             	mov    0x10(%ebp),%edx
80106f73:	89 c1                	mov    %eax,%ecx
80106f75:	89 f8                	mov    %edi,%eax
80106f77:	e8 34 fa ff ff       	call   801069b0 <deallocuvm.part.0>
      kfree(mem);
80106f7c:	83 ec 0c             	sub    $0xc,%esp
80106f7f:	53                   	push   %ebx
80106f80:	e8 1b b7 ff ff       	call   801026a0 <kfree>
      return 0;
80106f85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106f8c:	83 c4 10             	add    $0x10,%esp
}
80106f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f95:	5b                   	pop    %ebx
80106f96:	5e                   	pop    %esi
80106f97:	5f                   	pop    %edi
80106f98:	5d                   	pop    %ebp
80106f99:	c3                   	ret    
80106f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fa0 <deallocuvm>:
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106fac:	39 d1                	cmp    %edx,%ecx
80106fae:	73 10                	jae    80106fc0 <deallocuvm+0x20>
}
80106fb0:	5d                   	pop    %ebp
80106fb1:	e9 fa f9 ff ff       	jmp    801069b0 <deallocuvm.part.0>
80106fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
80106fc0:	89 d0                	mov    %edx,%eax
80106fc2:	5d                   	pop    %ebp
80106fc3:	c3                   	ret    
80106fc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fcf:	90                   	nop

80106fd0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 0c             	sub    $0xc,%esp
80106fd9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106fdc:	85 f6                	test   %esi,%esi
80106fde:	74 59                	je     80107039 <freevm+0x69>
  if(newsz >= oldsz)
80106fe0:	31 c9                	xor    %ecx,%ecx
80106fe2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106fe7:	89 f0                	mov    %esi,%eax
80106fe9:	89 f3                	mov    %esi,%ebx
80106feb:	e8 c0 f9 ff ff       	call   801069b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ff0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ff6:	eb 0f                	jmp    80107007 <freevm+0x37>
80106ff8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fff:	90                   	nop
80107000:	83 c3 04             	add    $0x4,%ebx
80107003:	39 df                	cmp    %ebx,%edi
80107005:	74 23                	je     8010702a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107007:	8b 03                	mov    (%ebx),%eax
80107009:	a8 01                	test   $0x1,%al
8010700b:	74 f3                	je     80107000 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010700d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107012:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107015:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107018:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010701d:	50                   	push   %eax
8010701e:	e8 7d b6 ff ff       	call   801026a0 <kfree>
80107023:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107026:	39 df                	cmp    %ebx,%edi
80107028:	75 dd                	jne    80107007 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010702a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010702d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107030:	5b                   	pop    %ebx
80107031:	5e                   	pop    %esi
80107032:	5f                   	pop    %edi
80107033:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107034:	e9 67 b6 ff ff       	jmp    801026a0 <kfree>
    panic("freevm: no pgdir");
80107039:	83 ec 0c             	sub    $0xc,%esp
8010703c:	68 f9 7c 10 80       	push   $0x80107cf9
80107041:	e8 3a 93 ff ff       	call   80100380 <panic>
80107046:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010704d:	8d 76 00             	lea    0x0(%esi),%esi

80107050 <setupkvm>:
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	56                   	push   %esi
80107054:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107055:	e8 06 b8 ff ff       	call   80102860 <kalloc>
8010705a:	89 c6                	mov    %eax,%esi
8010705c:	85 c0                	test   %eax,%eax
8010705e:	74 42                	je     801070a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107060:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107063:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107068:	68 00 10 00 00       	push   $0x1000
8010706d:	6a 00                	push   $0x0
8010706f:	50                   	push   %eax
80107070:	e8 db d7 ff ff       	call   80104850 <memset>
80107075:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107078:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010707b:	83 ec 08             	sub    $0x8,%esp
8010707e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107081:	ff 73 0c             	push   0xc(%ebx)
80107084:	8b 13                	mov    (%ebx),%edx
80107086:	50                   	push   %eax
80107087:	29 c1                	sub    %eax,%ecx
80107089:	89 f0                	mov    %esi,%eax
8010708b:	e8 d0 f9 ff ff       	call   80106a60 <mappages>
80107090:	83 c4 10             	add    $0x10,%esp
80107093:	85 c0                	test   %eax,%eax
80107095:	78 19                	js     801070b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107097:	83 c3 10             	add    $0x10,%ebx
8010709a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801070a0:	75 d6                	jne    80107078 <setupkvm+0x28>
}
801070a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070a5:	89 f0                	mov    %esi,%eax
801070a7:	5b                   	pop    %ebx
801070a8:	5e                   	pop    %esi
801070a9:	5d                   	pop    %ebp
801070aa:	c3                   	ret    
801070ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070af:	90                   	nop
      freevm(pgdir);
801070b0:	83 ec 0c             	sub    $0xc,%esp
801070b3:	56                   	push   %esi
      return 0;
801070b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801070b6:	e8 15 ff ff ff       	call   80106fd0 <freevm>
      return 0;
801070bb:	83 c4 10             	add    $0x10,%esp
}
801070be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070c1:	89 f0                	mov    %esi,%eax
801070c3:	5b                   	pop    %ebx
801070c4:	5e                   	pop    %esi
801070c5:	5d                   	pop    %ebp
801070c6:	c3                   	ret    
801070c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ce:	66 90                	xchg   %ax,%ax

801070d0 <kvmalloc>:
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801070d6:	e8 75 ff ff ff       	call   80107050 <setupkvm>
801070db:	a3 c4 44 11 80       	mov    %eax,0x801144c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070e0:	05 00 00 00 80       	add    $0x80000000,%eax
801070e5:	0f 22 d8             	mov    %eax,%cr3
}
801070e8:	c9                   	leave  
801070e9:	c3                   	ret    
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	83 ec 08             	sub    $0x8,%esp
801070f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070f9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801070fc:	89 c1                	mov    %eax,%ecx
801070fe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107101:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107104:	f6 c2 01             	test   $0x1,%dl
80107107:	75 17                	jne    80107120 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107109:	83 ec 0c             	sub    $0xc,%esp
8010710c:	68 0a 7d 10 80       	push   $0x80107d0a
80107111:	e8 6a 92 ff ff       	call   80100380 <panic>
80107116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010711d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107120:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107123:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107129:	25 fc 0f 00 00       	and    $0xffc,%eax
8010712e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107135:	85 c0                	test   %eax,%eax
80107137:	74 d0                	je     80107109 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107139:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010713c:	c9                   	leave  
8010713d:	c3                   	ret    
8010713e:	66 90                	xchg   %ax,%ax

80107140 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107149:	e8 02 ff ff ff       	call   80107050 <setupkvm>
8010714e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107151:	85 c0                	test   %eax,%eax
80107153:	0f 84 bd 00 00 00    	je     80107216 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107159:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010715c:	85 c9                	test   %ecx,%ecx
8010715e:	0f 84 b2 00 00 00    	je     80107216 <copyuvm+0xd6>
80107164:	31 f6                	xor    %esi,%esi
80107166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010716d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107173:	89 f0                	mov    %esi,%eax
80107175:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107178:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010717b:	a8 01                	test   $0x1,%al
8010717d:	75 11                	jne    80107190 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010717f:	83 ec 0c             	sub    $0xc,%esp
80107182:	68 14 7d 10 80       	push   $0x80107d14
80107187:	e8 f4 91 ff ff       	call   80100380 <panic>
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107190:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107197:	c1 ea 0a             	shr    $0xa,%edx
8010719a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071a7:	85 c0                	test   %eax,%eax
801071a9:	74 d4                	je     8010717f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801071ab:	8b 00                	mov    (%eax),%eax
801071ad:	a8 01                	test   $0x1,%al
801071af:	0f 84 9f 00 00 00    	je     80107254 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801071b5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801071b7:	25 ff 0f 00 00       	and    $0xfff,%eax
801071bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801071bf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801071c5:	e8 96 b6 ff ff       	call   80102860 <kalloc>
801071ca:	89 c3                	mov    %eax,%ebx
801071cc:	85 c0                	test   %eax,%eax
801071ce:	74 64                	je     80107234 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071d0:	83 ec 04             	sub    $0x4,%esp
801071d3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801071d9:	68 00 10 00 00       	push   $0x1000
801071de:	57                   	push   %edi
801071df:	50                   	push   %eax
801071e0:	e8 0b d7 ff ff       	call   801048f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801071e5:	58                   	pop    %eax
801071e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071ec:	5a                   	pop    %edx
801071ed:	ff 75 e4             	push   -0x1c(%ebp)
801071f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071f5:	89 f2                	mov    %esi,%edx
801071f7:	50                   	push   %eax
801071f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071fb:	e8 60 f8 ff ff       	call   80106a60 <mappages>
80107200:	83 c4 10             	add    $0x10,%esp
80107203:	85 c0                	test   %eax,%eax
80107205:	78 21                	js     80107228 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107207:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010720d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107210:	0f 87 5a ff ff ff    	ja     80107170 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107216:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107219:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010721c:	5b                   	pop    %ebx
8010721d:	5e                   	pop    %esi
8010721e:	5f                   	pop    %edi
8010721f:	5d                   	pop    %ebp
80107220:	c3                   	ret    
80107221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107228:	83 ec 0c             	sub    $0xc,%esp
8010722b:	53                   	push   %ebx
8010722c:	e8 6f b4 ff ff       	call   801026a0 <kfree>
      goto bad;
80107231:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107234:	83 ec 0c             	sub    $0xc,%esp
80107237:	ff 75 e0             	push   -0x20(%ebp)
8010723a:	e8 91 fd ff ff       	call   80106fd0 <freevm>
  return 0;
8010723f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107246:	83 c4 10             	add    $0x10,%esp
}
80107249:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010724c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010724f:	5b                   	pop    %ebx
80107250:	5e                   	pop    %esi
80107251:	5f                   	pop    %edi
80107252:	5d                   	pop    %ebp
80107253:	c3                   	ret    
      panic("copyuvm: page not present");
80107254:	83 ec 0c             	sub    $0xc,%esp
80107257:	68 2e 7d 10 80       	push   $0x80107d2e
8010725c:	e8 1f 91 ff ff       	call   80100380 <panic>
80107261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107268:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010726f:	90                   	nop

80107270 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107276:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107279:	89 c1                	mov    %eax,%ecx
8010727b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010727e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107281:	f6 c2 01             	test   $0x1,%dl
80107284:	0f 84 00 01 00 00    	je     8010738a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010728a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010728d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107293:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107294:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107299:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801072a0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072a7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072aa:	05 00 00 00 80       	add    $0x80000000,%eax
801072af:	83 fa 05             	cmp    $0x5,%edx
801072b2:	ba 00 00 00 00       	mov    $0x0,%edx
801072b7:	0f 45 c2             	cmovne %edx,%eax
}
801072ba:	c3                   	ret    
801072bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072bf:	90                   	nop

801072c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	53                   	push   %ebx
801072c6:	83 ec 0c             	sub    $0xc,%esp
801072c9:	8b 75 14             	mov    0x14(%ebp),%esi
801072cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801072cf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072d2:	85 f6                	test   %esi,%esi
801072d4:	75 51                	jne    80107327 <copyout+0x67>
801072d6:	e9 a5 00 00 00       	jmp    80107380 <copyout+0xc0>
801072db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072df:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801072e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801072e6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801072ec:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801072f2:	74 75                	je     80107369 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801072f4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801072f6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801072f9:	29 c3                	sub    %eax,%ebx
801072fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107301:	39 f3                	cmp    %esi,%ebx
80107303:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107306:	29 f8                	sub    %edi,%eax
80107308:	83 ec 04             	sub    $0x4,%esp
8010730b:	01 c8                	add    %ecx,%eax
8010730d:	53                   	push   %ebx
8010730e:	52                   	push   %edx
8010730f:	50                   	push   %eax
80107310:	e8 db d5 ff ff       	call   801048f0 <memmove>
    len -= n;
    buf += n;
80107315:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107318:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010731e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107321:	01 da                	add    %ebx,%edx
  while(len > 0){
80107323:	29 de                	sub    %ebx,%esi
80107325:	74 59                	je     80107380 <copyout+0xc0>
  if(*pde & PTE_P){
80107327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010732a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010732c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010732e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107331:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107337:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010733a:	f6 c1 01             	test   $0x1,%cl
8010733d:	0f 84 4e 00 00 00    	je     80107391 <copyout.cold>
  return &pgtab[PTX(va)];
80107343:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107345:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010734b:	c1 eb 0c             	shr    $0xc,%ebx
8010734e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107354:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010735b:	89 d9                	mov    %ebx,%ecx
8010735d:	83 e1 05             	and    $0x5,%ecx
80107360:	83 f9 05             	cmp    $0x5,%ecx
80107363:	0f 84 77 ff ff ff    	je     801072e0 <copyout+0x20>
  }
  return 0;
}
80107369:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010736c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107371:	5b                   	pop    %ebx
80107372:	5e                   	pop    %esi
80107373:	5f                   	pop    %edi
80107374:	5d                   	pop    %ebp
80107375:	c3                   	ret    
80107376:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737d:	8d 76 00             	lea    0x0(%esi),%esi
80107380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107383:	31 c0                	xor    %eax,%eax
}
80107385:	5b                   	pop    %ebx
80107386:	5e                   	pop    %esi
80107387:	5f                   	pop    %edi
80107388:	5d                   	pop    %ebp
80107389:	c3                   	ret    

8010738a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010738a:	a1 00 00 00 00       	mov    0x0,%eax
8010738f:	0f 0b                	ud2    

80107391 <copyout.cold>:
80107391:	a1 00 00 00 00       	mov    0x0,%eax
80107396:	0f 0b                	ud2    
