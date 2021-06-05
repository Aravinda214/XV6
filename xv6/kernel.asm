
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 80 33 15 80       	mov    $0x80153380,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 4d 38 10 80       	mov    $0x8010384d,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 74 92 10 80       	push   $0x80109274
80100042:	68 c0 c5 10 80       	push   $0x8010c5c0
80100047:	e8 a3 53 00 00       	call   801053ef <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 d0 04 11 80 c4 	movl   $0x801104c4,0x801104d0
80100056:	04 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 d4 04 11 80 c4 	movl   $0x801104c4,0x801104d4
80100060:	04 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 f4 c5 10 80 	movl   $0x8010c5f4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 d4 04 11 80    	mov    0x801104d4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c c4 04 11 80 	movl   $0x801104c4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 d4 04 11 80       	mov    0x801104d4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 d4 04 11 80       	mov    %eax,0x801104d4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 c4 04 11 80       	mov    $0x801104c4,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
  }
}
801000b0:	90                   	nop
801000b1:	90                   	nop
801000b2:	c9                   	leave  
801000b3:	c3                   	ret    

801000b4 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000ba:	83 ec 0c             	sub    $0xc,%esp
801000bd:	68 c0 c5 10 80       	push   $0x8010c5c0
801000c2:	e8 4a 53 00 00       	call   80105411 <acquire>
801000c7:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ca:	a1 d4 04 11 80       	mov    0x801104d4,%eax
801000cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d2:	eb 67                	jmp    8010013b <bget+0x87>
    if(b->dev == dev && b->sector == sector){
801000d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d7:	8b 40 04             	mov    0x4(%eax),%eax
801000da:	39 45 08             	cmp    %eax,0x8(%ebp)
801000dd:	75 53                	jne    80100132 <bget+0x7e>
801000df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e2:	8b 40 08             	mov    0x8(%eax),%eax
801000e5:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000e8:	75 48                	jne    80100132 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ed:	8b 00                	mov    (%eax),%eax
801000ef:	83 e0 01             	and    $0x1,%eax
801000f2:	85 c0                	test   %eax,%eax
801000f4:	75 27                	jne    8010011d <bget+0x69>
        b->flags |= B_BUSY;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 00                	mov    (%eax),%eax
801000fb:	83 c8 01             	or     $0x1,%eax
801000fe:	89 c2                	mov    %eax,%edx
80100100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100103:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 c0 c5 10 80       	push   $0x8010c5c0
8010010d:	e8 66 53 00 00       	call   80105478 <release>
80100112:	83 c4 10             	add    $0x10,%esp
        return b;
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	e9 98 00 00 00       	jmp    801001b5 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011d:	83 ec 08             	sub    $0x8,%esp
80100120:	68 c0 c5 10 80       	push   $0x8010c5c0
80100125:	ff 75 f4             	push   -0xc(%ebp)
80100128:	e8 3a 4c 00 00       	call   80104d67 <sleep>
8010012d:	83 c4 10             	add    $0x10,%esp
      goto loop;
80100130:	eb 98                	jmp    801000ca <bget+0x16>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	8b 40 10             	mov    0x10(%eax),%eax
80100138:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013b:	81 7d f4 c4 04 11 80 	cmpl   $0x801104c4,-0xc(%ebp)
80100142:	75 90                	jne    801000d4 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100144:	a1 d0 04 11 80       	mov    0x801104d0,%eax
80100149:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014c:	eb 51                	jmp    8010019f <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 01             	and    $0x1,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 3c                	jne    80100196 <bget+0xe2>
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 00                	mov    (%eax),%eax
8010015f:	83 e0 04             	and    $0x4,%eax
80100162:	85 c0                	test   %eax,%eax
80100164:	75 30                	jne    80100196 <bget+0xe2>
      b->dev = dev;
80100166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100169:	8b 55 08             	mov    0x8(%ebp),%edx
8010016c:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
8010016f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100172:	8b 55 0c             	mov    0xc(%ebp),%edx
80100175:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100181:	83 ec 0c             	sub    $0xc,%esp
80100184:	68 c0 c5 10 80       	push   $0x8010c5c0
80100189:	e8 ea 52 00 00       	call   80105478 <release>
8010018e:	83 c4 10             	add    $0x10,%esp
      return b;
80100191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100194:	eb 1f                	jmp    801001b5 <bget+0x101>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	8b 40 0c             	mov    0xc(%eax),%eax
8010019c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019f:	81 7d f4 c4 04 11 80 	cmpl   $0x801104c4,-0xc(%ebp)
801001a6:	75 a6                	jne    8010014e <bget+0x9a>
    }
  }
  panic("bget: no buffers");
801001a8:	83 ec 0c             	sub    $0xc,%esp
801001ab:	68 7b 92 10 80       	push   $0x8010927b
801001b0:	e8 c6 03 00 00       	call   8010057b <panic>
}
801001b5:	c9                   	leave  
801001b6:	c3                   	ret    

801001b7 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001b7:	55                   	push   %ebp
801001b8:	89 e5                	mov    %esp,%ebp
801001ba:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, sector);
801001bd:	83 ec 08             	sub    $0x8,%esp
801001c0:	ff 75 0c             	push   0xc(%ebp)
801001c3:	ff 75 08             	push   0x8(%ebp)
801001c6:	e8 e9 fe ff ff       	call   801000b4 <bget>
801001cb:	83 c4 10             	add    $0x10,%esp
801001ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d4:	8b 00                	mov    (%eax),%eax
801001d6:	83 e0 02             	and    $0x2,%eax
801001d9:	85 c0                	test   %eax,%eax
801001db:	75 0e                	jne    801001eb <bread+0x34>
    iderw(b);
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	ff 75 f4             	push   -0xc(%ebp)
801001e3:	e8 a2 26 00 00       	call   8010288a <iderw>
801001e8:	83 c4 10             	add    $0x10,%esp
  return b;
801001eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ee:	c9                   	leave  
801001ef:	c3                   	ret    

801001f0 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f6:	8b 45 08             	mov    0x8(%ebp),%eax
801001f9:	8b 00                	mov    (%eax),%eax
801001fb:	83 e0 01             	and    $0x1,%eax
801001fe:	85 c0                	test   %eax,%eax
80100200:	75 0d                	jne    8010020f <bwrite+0x1f>
    panic("bwrite");
80100202:	83 ec 0c             	sub    $0xc,%esp
80100205:	68 8c 92 10 80       	push   $0x8010928c
8010020a:	e8 6c 03 00 00       	call   8010057b <panic>
  b->flags |= B_DIRTY;
8010020f:	8b 45 08             	mov    0x8(%ebp),%eax
80100212:	8b 00                	mov    (%eax),%eax
80100214:	83 c8 04             	or     $0x4,%eax
80100217:	89 c2                	mov    %eax,%edx
80100219:	8b 45 08             	mov    0x8(%ebp),%eax
8010021c:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021e:	83 ec 0c             	sub    $0xc,%esp
80100221:	ff 75 08             	push   0x8(%ebp)
80100224:	e8 61 26 00 00       	call   8010288a <iderw>
80100229:	83 c4 10             	add    $0x10,%esp
}
8010022c:	90                   	nop
8010022d:	c9                   	leave  
8010022e:	c3                   	ret    

8010022f <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022f:	55                   	push   %ebp
80100230:	89 e5                	mov    %esp,%ebp
80100232:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100235:	8b 45 08             	mov    0x8(%ebp),%eax
80100238:	8b 00                	mov    (%eax),%eax
8010023a:	83 e0 01             	and    $0x1,%eax
8010023d:	85 c0                	test   %eax,%eax
8010023f:	75 0d                	jne    8010024e <brelse+0x1f>
    panic("brelse");
80100241:	83 ec 0c             	sub    $0xc,%esp
80100244:	68 93 92 10 80       	push   $0x80109293
80100249:	e8 2d 03 00 00       	call   8010057b <panic>

  acquire(&bcache.lock);
8010024e:	83 ec 0c             	sub    $0xc,%esp
80100251:	68 c0 c5 10 80       	push   $0x8010c5c0
80100256:	e8 b6 51 00 00       	call   80105411 <acquire>
8010025b:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025e:	8b 45 08             	mov    0x8(%ebp),%eax
80100261:	8b 40 10             	mov    0x10(%eax),%eax
80100264:	8b 55 08             	mov    0x8(%ebp),%edx
80100267:	8b 52 0c             	mov    0xc(%edx),%edx
8010026a:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	8b 40 0c             	mov    0xc(%eax),%eax
80100273:	8b 55 08             	mov    0x8(%ebp),%edx
80100276:	8b 52 10             	mov    0x10(%edx),%edx
80100279:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027c:	8b 15 d4 04 11 80    	mov    0x801104d4,%edx
80100282:	8b 45 08             	mov    0x8(%ebp),%eax
80100285:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	c7 40 0c c4 04 11 80 	movl   $0x801104c4,0xc(%eax)
  bcache.head.next->prev = b;
80100292:	a1 d4 04 11 80       	mov    0x801104d4,%eax
80100297:	8b 55 08             	mov    0x8(%ebp),%edx
8010029a:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029d:	8b 45 08             	mov    0x8(%ebp),%eax
801002a0:	a3 d4 04 11 80       	mov    %eax,0x801104d4

  b->flags &= ~B_BUSY;
801002a5:	8b 45 08             	mov    0x8(%ebp),%eax
801002a8:	8b 00                	mov    (%eax),%eax
801002aa:	83 e0 fe             	and    $0xfffffffe,%eax
801002ad:	89 c2                	mov    %eax,%edx
801002af:	8b 45 08             	mov    0x8(%ebp),%eax
801002b2:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b4:	83 ec 0c             	sub    $0xc,%esp
801002b7:	ff 75 08             	push   0x8(%ebp)
801002ba:	e8 97 4b 00 00       	call   80104e56 <wakeup>
801002bf:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c2:	83 ec 0c             	sub    $0xc,%esp
801002c5:	68 c0 c5 10 80       	push   $0x8010c5c0
801002ca:	e8 a9 51 00 00       	call   80105478 <release>
801002cf:	83 c4 10             	add    $0x10,%esp
}
801002d2:	90                   	nop
801002d3:	c9                   	leave  
801002d4:	c3                   	ret    

801002d5 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d5:	55                   	push   %ebp
801002d6:	89 e5                	mov    %esp,%ebp
801002d8:	83 ec 14             	sub    $0x14,%esp
801002db:	8b 45 08             	mov    0x8(%ebp),%eax
801002de:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e6:	89 c2                	mov    %eax,%edx
801002e8:	ec                   	in     (%dx),%al
801002e9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ec:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f0:	c9                   	leave  
801002f1:	c3                   	ret    

801002f2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f2:	55                   	push   %ebp
801002f3:	89 e5                	mov    %esp,%ebp
801002f5:	83 ec 08             	sub    $0x8,%esp
801002f8:	8b 45 08             	mov    0x8(%ebp),%eax
801002fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801002fe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100302:	89 d0                	mov    %edx,%eax
80100304:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100307:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030f:	ee                   	out    %al,(%dx)
}
80100310:	90                   	nop
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	90                   	nop
80100318:	5d                   	pop    %ebp
80100319:	c3                   	ret    

8010031a <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010031a:	55                   	push   %ebp
8010031b:	89 e5                	mov    %esp,%ebp
8010031d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100324:	74 1c                	je     80100342 <printint+0x28>
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	c1 e8 1f             	shr    $0x1f,%eax
8010032c:	0f b6 c0             	movzbl %al,%eax
8010032f:	89 45 10             	mov    %eax,0x10(%ebp)
80100332:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100336:	74 0a                	je     80100342 <printint+0x28>
    x = -xx;
80100338:	8b 45 08             	mov    0x8(%ebp),%eax
8010033b:	f7 d8                	neg    %eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100340:	eb 06                	jmp    80100348 <printint+0x2e>
  else
    x = xx;
80100342:	8b 45 08             	mov    0x8(%ebp),%eax
80100345:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100355:	ba 00 00 00 00       	mov    $0x0,%edx
8010035a:	f7 f1                	div    %ecx
8010035c:	89 d1                	mov    %edx,%ecx
8010035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100361:	8d 50 01             	lea    0x1(%eax),%edx
80100364:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100367:	0f b6 91 04 a0 10 80 	movzbl -0x7fef5ffc(%ecx),%edx
8010036e:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
80100372:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100375:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100378:	ba 00 00 00 00       	mov    $0x0,%edx
8010037d:	f7 f1                	div    %ecx
8010037f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100386:	75 c7                	jne    8010034f <printint+0x35>

  if(sign)
80100388:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038c:	74 2a                	je     801003b8 <printint+0x9e>
    buf[i++] = '-';
8010038e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100391:	8d 50 01             	lea    0x1(%eax),%edx
80100394:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100397:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039c:	eb 1a                	jmp    801003b8 <printint+0x9e>
    consputc(buf[i]);
8010039e:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a4:	01 d0                	add    %edx,%eax
801003a6:	0f b6 00             	movzbl (%eax),%eax
801003a9:	0f be c0             	movsbl %al,%eax
801003ac:	83 ec 0c             	sub    $0xc,%esp
801003af:	50                   	push   %eax
801003b0:	e8 e4 03 00 00       	call   80100799 <consputc>
801003b5:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003b8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003c0:	79 dc                	jns    8010039e <printint+0x84>
}
801003c2:	90                   	nop
801003c3:	90                   	nop
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 f4 07 11 80       	mov    0x801107f4,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 c0 07 11 80       	push   $0x801107c0
801003e2:	e8 2a 50 00 00       	call   80105411 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 9a 92 10 80       	push   $0x8010929a
801003f9:	e8 7d 01 00 00       	call   8010057b <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 2f 01 00 00       	jmp    8010053f <cprintf+0x179>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	push   -0x1c(%ebp)
8010041c:	e8 78 03 00 00       	call   80100799 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 12 01 00 00       	jmp    8010053b <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 14 01 00 00    	je     80100561 <cprintf+0x19b>
      break;
    switch(c){
8010044d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100451:	74 5e                	je     801004b1 <cprintf+0xeb>
80100453:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100457:	0f 8f c2 00 00 00    	jg     8010051f <cprintf+0x159>
8010045d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100461:	74 6b                	je     801004ce <cprintf+0x108>
80100463:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100467:	0f 8f b2 00 00 00    	jg     8010051f <cprintf+0x159>
8010046d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100471:	74 3e                	je     801004b1 <cprintf+0xeb>
80100473:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100477:	0f 8f a2 00 00 00    	jg     8010051f <cprintf+0x159>
8010047d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100481:	0f 84 89 00 00 00    	je     80100510 <cprintf+0x14a>
80100487:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
8010048b:	0f 85 8e 00 00 00    	jne    8010051f <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
80100491:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100494:	8d 50 04             	lea    0x4(%eax),%edx
80100497:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049a:	8b 00                	mov    (%eax),%eax
8010049c:	83 ec 04             	sub    $0x4,%esp
8010049f:	6a 01                	push   $0x1
801004a1:	6a 0a                	push   $0xa
801004a3:	50                   	push   %eax
801004a4:	e8 71 fe ff ff       	call   8010031a <printint>
801004a9:	83 c4 10             	add    $0x10,%esp
      break;
801004ac:	e9 8a 00 00 00       	jmp    8010053b <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b4:	8d 50 04             	lea    0x4(%eax),%edx
801004b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004ba:	8b 00                	mov    (%eax),%eax
801004bc:	83 ec 04             	sub    $0x4,%esp
801004bf:	6a 00                	push   $0x0
801004c1:	6a 10                	push   $0x10
801004c3:	50                   	push   %eax
801004c4:	e8 51 fe ff ff       	call   8010031a <printint>
801004c9:	83 c4 10             	add    $0x10,%esp
      break;
801004cc:	eb 6d                	jmp    8010053b <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
801004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d1:	8d 50 04             	lea    0x4(%eax),%edx
801004d4:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004d7:	8b 00                	mov    (%eax),%eax
801004d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004e0:	75 22                	jne    80100504 <cprintf+0x13e>
        s = "(null)";
801004e2:	c7 45 ec a3 92 10 80 	movl   $0x801092a3,-0x14(%ebp)
      for(; *s; s++)
801004e9:	eb 19                	jmp    80100504 <cprintf+0x13e>
        consputc(*s);
801004eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ee:	0f b6 00             	movzbl (%eax),%eax
801004f1:	0f be c0             	movsbl %al,%eax
801004f4:	83 ec 0c             	sub    $0xc,%esp
801004f7:	50                   	push   %eax
801004f8:	e8 9c 02 00 00       	call   80100799 <consputc>
801004fd:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100500:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100507:	0f b6 00             	movzbl (%eax),%eax
8010050a:	84 c0                	test   %al,%al
8010050c:	75 dd                	jne    801004eb <cprintf+0x125>
      break;
8010050e:	eb 2b                	jmp    8010053b <cprintf+0x175>
    case '%':
      consputc('%');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 25                	push   $0x25
80100515:	e8 7f 02 00 00       	call   80100799 <consputc>
8010051a:	83 c4 10             	add    $0x10,%esp
      break;
8010051d:	eb 1c                	jmp    8010053b <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010051f:	83 ec 0c             	sub    $0xc,%esp
80100522:	6a 25                	push   $0x25
80100524:	e8 70 02 00 00       	call   80100799 <consputc>
80100529:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	ff 75 e4             	push   -0x1c(%ebp)
80100532:	e8 62 02 00 00       	call   80100799 <consputc>
80100537:	83 c4 10             	add    $0x10,%esp
      break;
8010053a:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010053b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010053f:	8b 55 08             	mov    0x8(%ebp),%edx
80100542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100545:	01 d0                	add    %edx,%eax
80100547:	0f b6 00             	movzbl (%eax),%eax
8010054a:	0f be c0             	movsbl %al,%eax
8010054d:	25 ff 00 00 00       	and    $0xff,%eax
80100552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100555:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100559:	0f 85 b1 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010055f:	eb 01                	jmp    80100562 <cprintf+0x19c>
      break;
80100561:	90                   	nop
    }
  }

  if(locking)
80100562:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100566:	74 10                	je     80100578 <cprintf+0x1b2>
    release(&cons.lock);
80100568:	83 ec 0c             	sub    $0xc,%esp
8010056b:	68 c0 07 11 80       	push   $0x801107c0
80100570:	e8 03 4f 00 00       	call   80105478 <release>
80100575:	83 c4 10             	add    $0x10,%esp
}
80100578:	90                   	nop
80100579:	c9                   	leave  
8010057a:	c3                   	ret    

8010057b <panic>:

void
panic(char *s)
{
8010057b:	55                   	push   %ebp
8010057c:	89 e5                	mov    %esp,%ebp
8010057e:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100581:	e8 8d fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
80100586:	c7 05 f4 07 11 80 00 	movl   $0x0,0x801107f4
8010058d:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100590:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100596:	0f b6 00             	movzbl (%eax),%eax
80100599:	0f b6 c0             	movzbl %al,%eax
8010059c:	83 ec 08             	sub    $0x8,%esp
8010059f:	50                   	push   %eax
801005a0:	68 aa 92 10 80       	push   $0x801092aa
801005a5:	e8 1c fe ff ff       	call   801003c6 <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005ad:	8b 45 08             	mov    0x8(%ebp),%eax
801005b0:	83 ec 0c             	sub    $0xc,%esp
801005b3:	50                   	push   %eax
801005b4:	e8 0d fe ff ff       	call   801003c6 <cprintf>
801005b9:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005bc:	83 ec 0c             	sub    $0xc,%esp
801005bf:	68 b9 92 10 80       	push   $0x801092b9
801005c4:	e8 fd fd ff ff       	call   801003c6 <cprintf>
801005c9:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005cc:	83 ec 08             	sub    $0x8,%esp
801005cf:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005d2:	50                   	push   %eax
801005d3:	8d 45 08             	lea    0x8(%ebp),%eax
801005d6:	50                   	push   %eax
801005d7:	e8 ee 4e 00 00       	call   801054ca <getcallerpcs>
801005dc:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005e6:	eb 1c                	jmp    80100604 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005eb:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005ef:	83 ec 08             	sub    $0x8,%esp
801005f2:	50                   	push   %eax
801005f3:	68 bb 92 10 80       	push   $0x801092bb
801005f8:	e8 c9 fd ff ff       	call   801003c6 <cprintf>
801005fd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100600:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100604:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100608:	7e de                	jle    801005e8 <panic+0x6d>
  panicked = 1; // freeze other CPU
8010060a:	c7 05 a0 07 11 80 01 	movl   $0x1,0x801107a0
80100611:	00 00 00 
  for(;;)
80100614:	eb fe                	jmp    80100614 <panic+0x99>

80100616 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100616:	55                   	push   %ebp
80100617:	89 e5                	mov    %esp,%ebp
80100619:	53                   	push   %ebx
8010061a:	83 ec 14             	sub    $0x14,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010061d:	6a 0e                	push   $0xe
8010061f:	68 d4 03 00 00       	push   $0x3d4
80100624:	e8 c9 fc ff ff       	call   801002f2 <outb>
80100629:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010062c:	68 d5 03 00 00       	push   $0x3d5
80100631:	e8 9f fc ff ff       	call   801002d5 <inb>
80100636:	83 c4 04             	add    $0x4,%esp
80100639:	0f b6 c0             	movzbl %al,%eax
8010063c:	c1 e0 08             	shl    $0x8,%eax
8010063f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100642:	6a 0f                	push   $0xf
80100644:	68 d4 03 00 00       	push   $0x3d4
80100649:	e8 a4 fc ff ff       	call   801002f2 <outb>
8010064e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100651:	68 d5 03 00 00       	push   $0x3d5
80100656:	e8 7a fc ff ff       	call   801002d5 <inb>
8010065b:	83 c4 04             	add    $0x4,%esp
8010065e:	0f b6 c0             	movzbl %al,%eax
80100661:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100664:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100668:	75 34                	jne    8010069e <cgaputc+0x88>
    pos += 80 - pos%80;
8010066a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010066d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100672:	89 c8                	mov    %ecx,%eax
80100674:	f7 ea                	imul   %edx
80100676:	89 d0                	mov    %edx,%eax
80100678:	c1 f8 05             	sar    $0x5,%eax
8010067b:	89 cb                	mov    %ecx,%ebx
8010067d:	c1 fb 1f             	sar    $0x1f,%ebx
80100680:	29 d8                	sub    %ebx,%eax
80100682:	89 c2                	mov    %eax,%edx
80100684:	89 d0                	mov    %edx,%eax
80100686:	c1 e0 02             	shl    $0x2,%eax
80100689:	01 d0                	add    %edx,%eax
8010068b:	c1 e0 04             	shl    $0x4,%eax
8010068e:	29 c1                	sub    %eax,%ecx
80100690:	89 ca                	mov    %ecx,%edx
80100692:	b8 50 00 00 00       	mov    $0x50,%eax
80100697:	29 d0                	sub    %edx,%eax
80100699:	01 45 f4             	add    %eax,-0xc(%ebp)
8010069c:	eb 38                	jmp    801006d6 <cgaputc+0xc0>
  else if(c == BACKSPACE){
8010069e:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006a5:	75 0c                	jne    801006b3 <cgaputc+0x9d>
    if(pos > 0) --pos;
801006a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006ab:	7e 29                	jle    801006d6 <cgaputc+0xc0>
801006ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006b1:	eb 23                	jmp    801006d6 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006b3:	8b 45 08             	mov    0x8(%ebp),%eax
801006b6:	0f b6 c0             	movzbl %al,%eax
801006b9:	80 cc 07             	or     $0x7,%ah
801006bc:	89 c1                	mov    %eax,%ecx
801006be:	8b 1d 00 a0 10 80    	mov    0x8010a000,%ebx
801006c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006c7:	8d 50 01             	lea    0x1(%eax),%edx
801006ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006cd:	01 c0                	add    %eax,%eax
801006cf:	01 d8                	add    %ebx,%eax
801006d1:	89 ca                	mov    %ecx,%edx
801006d3:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006d6:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006dd:	7e 4d                	jle    8010072c <cgaputc+0x116>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006df:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006ea:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ef:	83 ec 04             	sub    $0x4,%esp
801006f2:	68 60 0e 00 00       	push   $0xe60
801006f7:	52                   	push   %edx
801006f8:	50                   	push   %eax
801006f9:	e8 35 50 00 00       	call   80105733 <memmove>
801006fe:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
80100701:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100705:	b8 80 07 00 00       	mov    $0x780,%eax
8010070a:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070d:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100710:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100719:	01 c0                	add    %eax,%eax
8010071b:	01 c8                	add    %ecx,%eax
8010071d:	83 ec 04             	sub    $0x4,%esp
80100720:	52                   	push   %edx
80100721:	6a 00                	push   $0x0
80100723:	50                   	push   %eax
80100724:	e8 4b 4f 00 00       	call   80105674 <memset>
80100729:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
8010072c:	83 ec 08             	sub    $0x8,%esp
8010072f:	6a 0e                	push   $0xe
80100731:	68 d4 03 00 00       	push   $0x3d4
80100736:	e8 b7 fb ff ff       	call   801002f2 <outb>
8010073b:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100741:	c1 f8 08             	sar    $0x8,%eax
80100744:	0f b6 c0             	movzbl %al,%eax
80100747:	83 ec 08             	sub    $0x8,%esp
8010074a:	50                   	push   %eax
8010074b:	68 d5 03 00 00       	push   $0x3d5
80100750:	e8 9d fb ff ff       	call   801002f2 <outb>
80100755:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100758:	83 ec 08             	sub    $0x8,%esp
8010075b:	6a 0f                	push   $0xf
8010075d:	68 d4 03 00 00       	push   $0x3d4
80100762:	e8 8b fb ff ff       	call   801002f2 <outb>
80100767:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
8010076a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076d:	0f b6 c0             	movzbl %al,%eax
80100770:	83 ec 08             	sub    $0x8,%esp
80100773:	50                   	push   %eax
80100774:	68 d5 03 00 00       	push   $0x3d5
80100779:	e8 74 fb ff ff       	call   801002f2 <outb>
8010077e:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100781:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
80100787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010078a:	01 c0                	add    %eax,%eax
8010078c:	01 d0                	add    %edx,%eax
8010078e:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100793:	90                   	nop
80100794:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100797:	c9                   	leave  
80100798:	c3                   	ret    

80100799 <consputc>:

void
consputc(int c)
{
80100799:	55                   	push   %ebp
8010079a:	89 e5                	mov    %esp,%ebp
8010079c:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
8010079f:	a1 a0 07 11 80       	mov    0x801107a0,%eax
801007a4:	85 c0                	test   %eax,%eax
801007a6:	74 07                	je     801007af <consputc+0x16>
    cli();
801007a8:	e8 66 fb ff ff       	call   80100313 <cli>
    for(;;)
801007ad:	eb fe                	jmp    801007ad <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007af:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007b6:	75 29                	jne    801007e1 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b8:	83 ec 0c             	sub    $0xc,%esp
801007bb:	6a 08                	push   $0x8
801007bd:	e8 a8 6b 00 00       	call   8010736a <uartputc>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	83 ec 0c             	sub    $0xc,%esp
801007c8:	6a 20                	push   $0x20
801007ca:	e8 9b 6b 00 00       	call   8010736a <uartputc>
801007cf:	83 c4 10             	add    $0x10,%esp
801007d2:	83 ec 0c             	sub    $0xc,%esp
801007d5:	6a 08                	push   $0x8
801007d7:	e8 8e 6b 00 00       	call   8010736a <uartputc>
801007dc:	83 c4 10             	add    $0x10,%esp
801007df:	eb 0e                	jmp    801007ef <consputc+0x56>
  } else
    uartputc(c);
801007e1:	83 ec 0c             	sub    $0xc,%esp
801007e4:	ff 75 08             	push   0x8(%ebp)
801007e7:	e8 7e 6b 00 00       	call   8010736a <uartputc>
801007ec:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	ff 75 08             	push   0x8(%ebp)
801007f5:	e8 1c fe ff ff       	call   80100616 <cgaputc>
801007fa:	83 c4 10             	add    $0x10,%esp
}
801007fd:	90                   	nop
801007fe:	c9                   	leave  
801007ff:	c3                   	ret    

80100800 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100800:	55                   	push   %ebp
80100801:	89 e5                	mov    %esp,%ebp
80100803:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
80100806:	83 ec 0c             	sub    $0xc,%esp
80100809:	68 e0 06 11 80       	push   $0x801106e0
8010080e:	e8 fe 4b 00 00       	call   80105411 <acquire>
80100813:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100816:	e9 4a 01 00 00       	jmp    80100965 <consoleintr+0x165>
    switch(c){
8010081b:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010081f:	74 7f                	je     801008a0 <consoleintr+0xa0>
80100821:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80100825:	0f 8f aa 00 00 00    	jg     801008d5 <consoleintr+0xd5>
8010082b:	83 7d f4 15          	cmpl   $0x15,-0xc(%ebp)
8010082f:	74 41                	je     80100872 <consoleintr+0x72>
80100831:	83 7d f4 15          	cmpl   $0x15,-0xc(%ebp)
80100835:	0f 8f 9a 00 00 00    	jg     801008d5 <consoleintr+0xd5>
8010083b:	83 7d f4 08          	cmpl   $0x8,-0xc(%ebp)
8010083f:	74 5f                	je     801008a0 <consoleintr+0xa0>
80100841:	83 7d f4 10          	cmpl   $0x10,-0xc(%ebp)
80100845:	0f 85 8a 00 00 00    	jne    801008d5 <consoleintr+0xd5>
    case C('P'):  // Process listing.
      procdump();
8010084b:	e8 c4 46 00 00       	call   80104f14 <procdump>
      break;
80100850:	e9 10 01 00 00       	jmp    80100965 <consoleintr+0x165>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100855:	a1 9c 07 11 80       	mov    0x8011079c,%eax
8010085a:	83 e8 01             	sub    $0x1,%eax
8010085d:	a3 9c 07 11 80       	mov    %eax,0x8011079c
        consputc(BACKSPACE);
80100862:	83 ec 0c             	sub    $0xc,%esp
80100865:	68 00 01 00 00       	push   $0x100
8010086a:	e8 2a ff ff ff       	call   80100799 <consputc>
8010086f:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
80100872:	8b 15 9c 07 11 80    	mov    0x8011079c,%edx
80100878:	a1 98 07 11 80       	mov    0x80110798,%eax
8010087d:	39 c2                	cmp    %eax,%edx
8010087f:	0f 84 e0 00 00 00    	je     80100965 <consoleintr+0x165>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100885:	a1 9c 07 11 80       	mov    0x8011079c,%eax
8010088a:	83 e8 01             	sub    $0x1,%eax
8010088d:	83 e0 7f             	and    $0x7f,%eax
80100890:	0f b6 80 14 07 11 80 	movzbl -0x7feef8ec(%eax),%eax
      while(input.e != input.w &&
80100897:	3c 0a                	cmp    $0xa,%al
80100899:	75 ba                	jne    80100855 <consoleintr+0x55>
      }
      break;
8010089b:	e9 c5 00 00 00       	jmp    80100965 <consoleintr+0x165>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008a0:	8b 15 9c 07 11 80    	mov    0x8011079c,%edx
801008a6:	a1 98 07 11 80       	mov    0x80110798,%eax
801008ab:	39 c2                	cmp    %eax,%edx
801008ad:	0f 84 b2 00 00 00    	je     80100965 <consoleintr+0x165>
        input.e--;
801008b3:	a1 9c 07 11 80       	mov    0x8011079c,%eax
801008b8:	83 e8 01             	sub    $0x1,%eax
801008bb:	a3 9c 07 11 80       	mov    %eax,0x8011079c
        consputc(BACKSPACE);
801008c0:	83 ec 0c             	sub    $0xc,%esp
801008c3:	68 00 01 00 00       	push   $0x100
801008c8:	e8 cc fe ff ff       	call   80100799 <consputc>
801008cd:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008d0:	e9 90 00 00 00       	jmp    80100965 <consoleintr+0x165>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008d9:	0f 84 85 00 00 00    	je     80100964 <consoleintr+0x164>
801008df:	a1 9c 07 11 80       	mov    0x8011079c,%eax
801008e4:	8b 15 94 07 11 80    	mov    0x80110794,%edx
801008ea:	29 d0                	sub    %edx,%eax
801008ec:	83 f8 7f             	cmp    $0x7f,%eax
801008ef:	77 73                	ja     80100964 <consoleintr+0x164>
        c = (c == '\r') ? '\n' : c;
801008f1:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008f5:	74 05                	je     801008fc <consoleintr+0xfc>
801008f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008fa:	eb 05                	jmp    80100901 <consoleintr+0x101>
801008fc:	b8 0a 00 00 00       	mov    $0xa,%eax
80100901:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100904:	a1 9c 07 11 80       	mov    0x8011079c,%eax
80100909:	8d 50 01             	lea    0x1(%eax),%edx
8010090c:	89 15 9c 07 11 80    	mov    %edx,0x8011079c
80100912:	83 e0 7f             	and    $0x7f,%eax
80100915:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100918:	88 90 14 07 11 80    	mov    %dl,-0x7feef8ec(%eax)
        consputc(c);
8010091e:	83 ec 0c             	sub    $0xc,%esp
80100921:	ff 75 f4             	push   -0xc(%ebp)
80100924:	e8 70 fe ff ff       	call   80100799 <consputc>
80100929:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010092c:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
80100930:	74 18                	je     8010094a <consoleintr+0x14a>
80100932:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80100936:	74 12                	je     8010094a <consoleintr+0x14a>
80100938:	a1 9c 07 11 80       	mov    0x8011079c,%eax
8010093d:	8b 15 94 07 11 80    	mov    0x80110794,%edx
80100943:	83 ea 80             	sub    $0xffffff80,%edx
80100946:	39 d0                	cmp    %edx,%eax
80100948:	75 1a                	jne    80100964 <consoleintr+0x164>
          input.w = input.e;
8010094a:	a1 9c 07 11 80       	mov    0x8011079c,%eax
8010094f:	a3 98 07 11 80       	mov    %eax,0x80110798
          wakeup(&input.r);
80100954:	83 ec 0c             	sub    $0xc,%esp
80100957:	68 94 07 11 80       	push   $0x80110794
8010095c:	e8 f5 44 00 00       	call   80104e56 <wakeup>
80100961:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
80100964:	90                   	nop
  while((c = getc()) >= 0){
80100965:	8b 45 08             	mov    0x8(%ebp),%eax
80100968:	ff d0                	call   *%eax
8010096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010096d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100971:	0f 89 a4 fe ff ff    	jns    8010081b <consoleintr+0x1b>
    }
  }
  release(&input.lock);
80100977:	83 ec 0c             	sub    $0xc,%esp
8010097a:	68 e0 06 11 80       	push   $0x801106e0
8010097f:	e8 f4 4a 00 00       	call   80105478 <release>
80100984:	83 c4 10             	add    $0x10,%esp
}
80100987:	90                   	nop
80100988:	c9                   	leave  
80100989:	c3                   	ret    

8010098a <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010098a:	55                   	push   %ebp
8010098b:	89 e5                	mov    %esp,%ebp
8010098d:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100990:	83 ec 0c             	sub    $0xc,%esp
80100993:	ff 75 08             	push   0x8(%ebp)
80100996:	e8 f1 10 00 00       	call   80101a8c <iunlock>
8010099b:	83 c4 10             	add    $0x10,%esp
  target = n;
8010099e:	8b 45 10             	mov    0x10(%ebp),%eax
801009a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
801009a4:	83 ec 0c             	sub    $0xc,%esp
801009a7:	68 e0 06 11 80       	push   $0x801106e0
801009ac:	e8 60 4a 00 00       	call   80105411 <acquire>
801009b1:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009b4:	e9 ac 00 00 00       	jmp    80100a65 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009bf:	8b 40 24             	mov    0x24(%eax),%eax
801009c2:	85 c0                	test   %eax,%eax
801009c4:	74 28                	je     801009ee <consoleread+0x64>
        release(&input.lock);
801009c6:	83 ec 0c             	sub    $0xc,%esp
801009c9:	68 e0 06 11 80       	push   $0x801106e0
801009ce:	e8 a5 4a 00 00       	call   80105478 <release>
801009d3:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009d6:	83 ec 0c             	sub    $0xc,%esp
801009d9:	ff 75 08             	push   0x8(%ebp)
801009dc:	e8 53 0f 00 00       	call   80101934 <ilock>
801009e1:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009e9:	e9 a9 00 00 00       	jmp    80100a97 <consoleread+0x10d>
      }
      sleep(&input.r, &input.lock);
801009ee:	83 ec 08             	sub    $0x8,%esp
801009f1:	68 e0 06 11 80       	push   $0x801106e0
801009f6:	68 94 07 11 80       	push   $0x80110794
801009fb:	e8 67 43 00 00       	call   80104d67 <sleep>
80100a00:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a03:	8b 15 94 07 11 80    	mov    0x80110794,%edx
80100a09:	a1 98 07 11 80       	mov    0x80110798,%eax
80100a0e:	39 c2                	cmp    %eax,%edx
80100a10:	74 a7                	je     801009b9 <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a12:	a1 94 07 11 80       	mov    0x80110794,%eax
80100a17:	8d 50 01             	lea    0x1(%eax),%edx
80100a1a:	89 15 94 07 11 80    	mov    %edx,0x80110794
80100a20:	83 e0 7f             	and    $0x7f,%eax
80100a23:	0f b6 80 14 07 11 80 	movzbl -0x7feef8ec(%eax),%eax
80100a2a:	0f be c0             	movsbl %al,%eax
80100a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a30:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a34:	75 17                	jne    80100a4d <consoleread+0xc3>
      if(n < target){
80100a36:	8b 45 10             	mov    0x10(%ebp),%eax
80100a39:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a3c:	76 2f                	jbe    80100a6d <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a3e:	a1 94 07 11 80       	mov    0x80110794,%eax
80100a43:	83 e8 01             	sub    $0x1,%eax
80100a46:	a3 94 07 11 80       	mov    %eax,0x80110794
      }
      break;
80100a4b:	eb 20                	jmp    80100a6d <consoleread+0xe3>
    }
    *dst++ = c;
80100a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a50:	8d 50 01             	lea    0x1(%eax),%edx
80100a53:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a56:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a59:	88 10                	mov    %dl,(%eax)
    --n;
80100a5b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a5f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a63:	74 0b                	je     80100a70 <consoleread+0xe6>
  while(n > 0){
80100a65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a69:	7f 98                	jg     80100a03 <consoleread+0x79>
80100a6b:	eb 04                	jmp    80100a71 <consoleread+0xe7>
      break;
80100a6d:	90                   	nop
80100a6e:	eb 01                	jmp    80100a71 <consoleread+0xe7>
      break;
80100a70:	90                   	nop
  }
  release(&input.lock);
80100a71:	83 ec 0c             	sub    $0xc,%esp
80100a74:	68 e0 06 11 80       	push   $0x801106e0
80100a79:	e8 fa 49 00 00       	call   80105478 <release>
80100a7e:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a81:	83 ec 0c             	sub    $0xc,%esp
80100a84:	ff 75 08             	push   0x8(%ebp)
80100a87:	e8 a8 0e 00 00       	call   80101934 <ilock>
80100a8c:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a8f:	8b 55 10             	mov    0x10(%ebp),%edx
80100a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a95:	29 d0                	sub    %edx,%eax
}
80100a97:	c9                   	leave  
80100a98:	c3                   	ret    

80100a99 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a99:	55                   	push   %ebp
80100a9a:	89 e5                	mov    %esp,%ebp
80100a9c:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a9f:	83 ec 0c             	sub    $0xc,%esp
80100aa2:	ff 75 08             	push   0x8(%ebp)
80100aa5:	e8 e2 0f 00 00       	call   80101a8c <iunlock>
80100aaa:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100aad:	83 ec 0c             	sub    $0xc,%esp
80100ab0:	68 c0 07 11 80       	push   $0x801107c0
80100ab5:	e8 57 49 00 00       	call   80105411 <acquire>
80100aba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100abd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100ac4:	eb 21                	jmp    80100ae7 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100acc:	01 d0                	add    %edx,%eax
80100ace:	0f b6 00             	movzbl (%eax),%eax
80100ad1:	0f be c0             	movsbl %al,%eax
80100ad4:	0f b6 c0             	movzbl %al,%eax
80100ad7:	83 ec 0c             	sub    $0xc,%esp
80100ada:	50                   	push   %eax
80100adb:	e8 b9 fc ff ff       	call   80100799 <consputc>
80100ae0:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ae3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100aea:	3b 45 10             	cmp    0x10(%ebp),%eax
80100aed:	7c d7                	jl     80100ac6 <consolewrite+0x2d>
  release(&cons.lock);
80100aef:	83 ec 0c             	sub    $0xc,%esp
80100af2:	68 c0 07 11 80       	push   $0x801107c0
80100af7:	e8 7c 49 00 00       	call   80105478 <release>
80100afc:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100aff:	83 ec 0c             	sub    $0xc,%esp
80100b02:	ff 75 08             	push   0x8(%ebp)
80100b05:	e8 2a 0e 00 00       	call   80101934 <ilock>
80100b0a:	83 c4 10             	add    $0x10,%esp

  return n;
80100b0d:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b10:	c9                   	leave  
80100b11:	c3                   	ret    

80100b12 <consoleinit>:

void
consoleinit(void)
{
80100b12:	55                   	push   %ebp
80100b13:	89 e5                	mov    %esp,%ebp
80100b15:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b18:	83 ec 08             	sub    $0x8,%esp
80100b1b:	68 bf 92 10 80       	push   $0x801092bf
80100b20:	68 c0 07 11 80       	push   $0x801107c0
80100b25:	e8 c5 48 00 00       	call   801053ef <initlock>
80100b2a:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100b2d:	83 ec 08             	sub    $0x8,%esp
80100b30:	68 c7 92 10 80       	push   $0x801092c7
80100b35:	68 e0 06 11 80       	push   $0x801106e0
80100b3a:	e8 b0 48 00 00       	call   801053ef <initlock>
80100b3f:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b42:	c7 05 0c 08 11 80 99 	movl   $0x80100a99,0x8011080c
80100b49:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b4c:	c7 05 08 08 11 80 8a 	movl   $0x8010098a,0x80110808
80100b53:	09 10 80 
  cons.locking = 1;
80100b56:	c7 05 f4 07 11 80 01 	movl   $0x1,0x801107f4
80100b5d:	00 00 00 

  picenable(IRQ_KBD);
80100b60:	83 ec 0c             	sub    $0xc,%esp
80100b63:	6a 01                	push   $0x1
80100b65:	e8 a6 33 00 00       	call   80103f10 <picenable>
80100b6a:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b6d:	83 ec 08             	sub    $0x8,%esp
80100b70:	6a 00                	push   $0x0
80100b72:	6a 01                	push   $0x1
80100b74:	e8 de 1e 00 00       	call   80102a57 <ioapicenable>
80100b79:	83 c4 10             	add    $0x10,%esp
}
80100b7c:	90                   	nop
80100b7d:	c9                   	leave  
80100b7e:	c3                   	ret    

80100b7f <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b7f:	55                   	push   %ebp
80100b80:	89 e5                	mov    %esp,%ebp
80100b82:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b88:	e8 9d 29 00 00       	call   8010352a <begin_op>
  if((ip = namei(path)) == 0){
80100b8d:	83 ec 0c             	sub    $0xc,%esp
80100b90:	ff 75 08             	push   0x8(%ebp)
80100b93:	e8 47 19 00 00       	call   801024df <namei>
80100b98:	83 c4 10             	add    $0x10,%esp
80100b9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b9e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ba2:	75 0f                	jne    80100bb3 <exec+0x34>
    end_op();
80100ba4:	e8 0d 2a 00 00       	call   801035b6 <end_op>
    return -1;
80100ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bae:	e9 ce 03 00 00       	jmp    80100f81 <exec+0x402>
  }
  ilock(ip);
80100bb3:	83 ec 0c             	sub    $0xc,%esp
80100bb6:	ff 75 d8             	push   -0x28(%ebp)
80100bb9:	e8 76 0d 00 00       	call   80101934 <ilock>
80100bbe:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bc1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100bc8:	6a 34                	push   $0x34
80100bca:	6a 00                	push   $0x0
80100bcc:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bd2:	50                   	push   %eax
80100bd3:	ff 75 d8             	push   -0x28(%ebp)
80100bd6:	e8 bc 12 00 00       	call   80101e97 <readi>
80100bdb:	83 c4 10             	add    $0x10,%esp
80100bde:	83 f8 33             	cmp    $0x33,%eax
80100be1:	0f 86 49 03 00 00    	jbe    80100f30 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100be7:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bed:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bf2:	0f 85 3b 03 00 00    	jne    80100f33 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100bf8:	e8 d3 78 00 00       	call   801084d0 <setupkvm>
80100bfd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c00:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c04:	0f 84 2c 03 00 00    	je     80100f36 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c11:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c18:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c21:	e9 ab 00 00 00       	jmp    80100cd1 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c29:	6a 20                	push   $0x20
80100c2b:	50                   	push   %eax
80100c2c:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c32:	50                   	push   %eax
80100c33:	ff 75 d8             	push   -0x28(%ebp)
80100c36:	e8 5c 12 00 00       	call   80101e97 <readi>
80100c3b:	83 c4 10             	add    $0x10,%esp
80100c3e:	83 f8 20             	cmp    $0x20,%eax
80100c41:	0f 85 f2 02 00 00    	jne    80100f39 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c47:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c4d:	83 f8 01             	cmp    $0x1,%eax
80100c50:	75 71                	jne    80100cc3 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c52:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c58:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c5e:	39 c2                	cmp    %eax,%edx
80100c60:	0f 82 d6 02 00 00    	jb     80100f3c <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c66:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c6c:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c72:	01 d0                	add    %edx,%eax
80100c74:	83 ec 04             	sub    $0x4,%esp
80100c77:	50                   	push   %eax
80100c78:	ff 75 e0             	push   -0x20(%ebp)
80100c7b:	ff 75 d4             	push   -0x2c(%ebp)
80100c7e:	e8 f5 7b 00 00       	call   80108878 <allocuvm>
80100c83:	83 c4 10             	add    $0x10,%esp
80100c86:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c89:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c8d:	0f 84 ac 02 00 00    	je     80100f3f <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c93:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c99:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c9f:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ca5:	83 ec 0c             	sub    $0xc,%esp
80100ca8:	52                   	push   %edx
80100ca9:	50                   	push   %eax
80100caa:	ff 75 d8             	push   -0x28(%ebp)
80100cad:	51                   	push   %ecx
80100cae:	ff 75 d4             	push   -0x2c(%ebp)
80100cb1:	e8 eb 7a 00 00       	call   801087a1 <loaduvm>
80100cb6:	83 c4 20             	add    $0x20,%esp
80100cb9:	85 c0                	test   %eax,%eax
80100cbb:	0f 88 81 02 00 00    	js     80100f42 <exec+0x3c3>
80100cc1:	eb 01                	jmp    80100cc4 <exec+0x145>
      continue;
80100cc3:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cc4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ccb:	83 c0 20             	add    $0x20,%eax
80100cce:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cd1:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cd8:	0f b7 c0             	movzwl %ax,%eax
80100cdb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100cde:	0f 8c 42 ff ff ff    	jl     80100c26 <exec+0xa7>
      goto bad;
  }
  iunlockput(ip);
80100ce4:	83 ec 0c             	sub    $0xc,%esp
80100ce7:	ff 75 d8             	push   -0x28(%ebp)
80100cea:	e8 ff 0e 00 00       	call   80101bee <iunlockput>
80100cef:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cf2:	e8 bf 28 00 00       	call   801035b6 <end_op>
  ip = 0;
80100cf7:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d01:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d11:	05 00 20 00 00       	add    $0x2000,%eax
80100d16:	83 ec 04             	sub    $0x4,%esp
80100d19:	50                   	push   %eax
80100d1a:	ff 75 e0             	push   -0x20(%ebp)
80100d1d:	ff 75 d4             	push   -0x2c(%ebp)
80100d20:	e8 53 7b 00 00       	call   80108878 <allocuvm>
80100d25:	83 c4 10             	add    $0x10,%esp
80100d28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d2b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d2f:	0f 84 10 02 00 00    	je     80100f45 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d38:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d3d:	83 ec 08             	sub    $0x8,%esp
80100d40:	50                   	push   %eax
80100d41:	ff 75 d4             	push   -0x2c(%ebp)
80100d44:	e8 53 7d 00 00       	call   80108a9c <clearpteu>
80100d49:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4f:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d59:	e9 96 00 00 00       	jmp    80100df4 <exec+0x275>
    if(argc >= MAXARG)
80100d5e:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d62:	0f 87 e0 01 00 00    	ja     80100f48 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d6b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d72:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d75:	01 d0                	add    %edx,%eax
80100d77:	8b 00                	mov    (%eax),%eax
80100d79:	83 ec 0c             	sub    $0xc,%esp
80100d7c:	50                   	push   %eax
80100d7d:	e8 3f 4b 00 00       	call   801058c1 <strlen>
80100d82:	83 c4 10             	add    $0x10,%esp
80100d85:	89 c2                	mov    %eax,%edx
80100d87:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d8a:	29 d0                	sub    %edx,%eax
80100d8c:	83 e8 01             	sub    $0x1,%eax
80100d8f:	83 e0 fc             	and    $0xfffffffc,%eax
80100d92:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da2:	01 d0                	add    %edx,%eax
80100da4:	8b 00                	mov    (%eax),%eax
80100da6:	83 ec 0c             	sub    $0xc,%esp
80100da9:	50                   	push   %eax
80100daa:	e8 12 4b 00 00       	call   801058c1 <strlen>
80100daf:	83 c4 10             	add    $0x10,%esp
80100db2:	83 c0 01             	add    $0x1,%eax
80100db5:	89 c2                	mov    %eax,%edx
80100db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc4:	01 c8                	add    %ecx,%eax
80100dc6:	8b 00                	mov    (%eax),%eax
80100dc8:	52                   	push   %edx
80100dc9:	50                   	push   %eax
80100dca:	ff 75 dc             	push   -0x24(%ebp)
80100dcd:	ff 75 d4             	push   -0x2c(%ebp)
80100dd0:	e8 7d 7e 00 00       	call   80108c52 <copyout>
80100dd5:	83 c4 10             	add    $0x10,%esp
80100dd8:	85 c0                	test   %eax,%eax
80100dda:	0f 88 6b 01 00 00    	js     80100f4b <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de3:	8d 50 03             	lea    0x3(%eax),%edx
80100de6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100de9:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100df0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e01:	01 d0                	add    %edx,%eax
80100e03:	8b 00                	mov    (%eax),%eax
80100e05:	85 c0                	test   %eax,%eax
80100e07:	0f 85 51 ff ff ff    	jne    80100d5e <exec+0x1df>
  }
  ustack[3+argc] = 0;
80100e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e10:	83 c0 03             	add    $0x3,%eax
80100e13:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e1a:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e1e:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e25:	ff ff ff 
  ustack[1] = argc;
80100e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2b:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e34:	83 c0 01             	add    $0x1,%eax
80100e37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e41:	29 d0                	sub    %edx,%eax
80100e43:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4c:	83 c0 04             	add    $0x4,%eax
80100e4f:	c1 e0 02             	shl    $0x2,%eax
80100e52:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e58:	83 c0 04             	add    $0x4,%eax
80100e5b:	c1 e0 02             	shl    $0x2,%eax
80100e5e:	50                   	push   %eax
80100e5f:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e65:	50                   	push   %eax
80100e66:	ff 75 dc             	push   -0x24(%ebp)
80100e69:	ff 75 d4             	push   -0x2c(%ebp)
80100e6c:	e8 e1 7d 00 00       	call   80108c52 <copyout>
80100e71:	83 c4 10             	add    $0x10,%esp
80100e74:	85 c0                	test   %eax,%eax
80100e76:	0f 88 d2 00 00 00    	js     80100f4e <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80100e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e88:	eb 17                	jmp    80100ea1 <exec+0x322>
    if(*s == '/')
80100e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e8d:	0f b6 00             	movzbl (%eax),%eax
80100e90:	3c 2f                	cmp    $0x2f,%al
80100e92:	75 09                	jne    80100e9d <exec+0x31e>
      last = s+1;
80100e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e97:	83 c0 01             	add    $0x1,%eax
80100e9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100e9d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea4:	0f b6 00             	movzbl (%eax),%eax
80100ea7:	84 c0                	test   %al,%al
80100ea9:	75 df                	jne    80100e8a <exec+0x30b>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100eab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb1:	83 c0 6c             	add    $0x6c,%eax
80100eb4:	83 ec 04             	sub    $0x4,%esp
80100eb7:	6a 10                	push   $0x10
80100eb9:	ff 75 f0             	push   -0x10(%ebp)
80100ebc:	50                   	push   %eax
80100ebd:	e8 b5 49 00 00       	call   80105877 <safestrcpy>
80100ec2:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ec5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ecb:	8b 40 04             	mov    0x4(%eax),%eax
80100ece:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ed1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eda:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee3:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ee6:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ee8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eee:	8b 40 18             	mov    0x18(%eax),%eax
80100ef1:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ef7:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100efa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f00:	8b 40 18             	mov    0x18(%eax),%eax
80100f03:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f06:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	50                   	push   %eax
80100f13:	e8 9f 76 00 00       	call   801085b7 <switchuvm>
80100f18:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f1b:	83 ec 0c             	sub    $0xc,%esp
80100f1e:	ff 75 d0             	push   -0x30(%ebp)
80100f21:	e8 d6 7a 00 00       	call   801089fc <freevm>
80100f26:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f29:	b8 00 00 00 00       	mov    $0x0,%eax
80100f2e:	eb 51                	jmp    80100f81 <exec+0x402>
    goto bad;
80100f30:	90                   	nop
80100f31:	eb 1c                	jmp    80100f4f <exec+0x3d0>
    goto bad;
80100f33:	90                   	nop
80100f34:	eb 19                	jmp    80100f4f <exec+0x3d0>
    goto bad;
80100f36:	90                   	nop
80100f37:	eb 16                	jmp    80100f4f <exec+0x3d0>
      goto bad;
80100f39:	90                   	nop
80100f3a:	eb 13                	jmp    80100f4f <exec+0x3d0>
      goto bad;
80100f3c:	90                   	nop
80100f3d:	eb 10                	jmp    80100f4f <exec+0x3d0>
      goto bad;
80100f3f:	90                   	nop
80100f40:	eb 0d                	jmp    80100f4f <exec+0x3d0>
      goto bad;
80100f42:	90                   	nop
80100f43:	eb 0a                	jmp    80100f4f <exec+0x3d0>
    goto bad;
80100f45:	90                   	nop
80100f46:	eb 07                	jmp    80100f4f <exec+0x3d0>
      goto bad;
80100f48:	90                   	nop
80100f49:	eb 04                	jmp    80100f4f <exec+0x3d0>
      goto bad;
80100f4b:	90                   	nop
80100f4c:	eb 01                	jmp    80100f4f <exec+0x3d0>
    goto bad;
80100f4e:	90                   	nop

 bad:
  if(pgdir)
80100f4f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f53:	74 0e                	je     80100f63 <exec+0x3e4>
    freevm(pgdir);
80100f55:	83 ec 0c             	sub    $0xc,%esp
80100f58:	ff 75 d4             	push   -0x2c(%ebp)
80100f5b:	e8 9c 7a 00 00       	call   801089fc <freevm>
80100f60:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f63:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f67:	74 13                	je     80100f7c <exec+0x3fd>
    iunlockput(ip);
80100f69:	83 ec 0c             	sub    $0xc,%esp
80100f6c:	ff 75 d8             	push   -0x28(%ebp)
80100f6f:	e8 7a 0c 00 00       	call   80101bee <iunlockput>
80100f74:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f77:	e8 3a 26 00 00       	call   801035b6 <end_op>
  }
  return -1;
80100f7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f81:	c9                   	leave  
80100f82:	c3                   	ret    

80100f83 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f83:	55                   	push   %ebp
80100f84:	89 e5                	mov    %esp,%ebp
80100f86:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f89:	83 ec 08             	sub    $0x8,%esp
80100f8c:	68 cd 92 10 80       	push   $0x801092cd
80100f91:	68 60 08 11 80       	push   $0x80110860
80100f96:	e8 54 44 00 00       	call   801053ef <initlock>
80100f9b:	83 c4 10             	add    $0x10,%esp
}
80100f9e:	90                   	nop
80100f9f:	c9                   	leave  
80100fa0:	c3                   	ret    

80100fa1 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fa1:	55                   	push   %ebp
80100fa2:	89 e5                	mov    %esp,%ebp
80100fa4:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fa7:	83 ec 0c             	sub    $0xc,%esp
80100faa:	68 60 08 11 80       	push   $0x80110860
80100faf:	e8 5d 44 00 00       	call   80105411 <acquire>
80100fb4:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fb7:	c7 45 f4 94 08 11 80 	movl   $0x80110894,-0xc(%ebp)
80100fbe:	eb 2d                	jmp    80100fed <filealloc+0x4c>
    if(f->ref == 0){
80100fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc3:	8b 40 04             	mov    0x4(%eax),%eax
80100fc6:	85 c0                	test   %eax,%eax
80100fc8:	75 1f                	jne    80100fe9 <filealloc+0x48>
      f->ref = 1;
80100fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fcd:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fd4:	83 ec 0c             	sub    $0xc,%esp
80100fd7:	68 60 08 11 80       	push   $0x80110860
80100fdc:	e8 97 44 00 00       	call   80105478 <release>
80100fe1:	83 c4 10             	add    $0x10,%esp
      return f;
80100fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe7:	eb 23                	jmp    8010100c <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fe9:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fed:	b8 f4 11 11 80       	mov    $0x801111f4,%eax
80100ff2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100ff5:	72 c9                	jb     80100fc0 <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80100ff7:	83 ec 0c             	sub    $0xc,%esp
80100ffa:	68 60 08 11 80       	push   $0x80110860
80100fff:	e8 74 44 00 00       	call   80105478 <release>
80101004:	83 c4 10             	add    $0x10,%esp
  return 0;
80101007:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010100c:	c9                   	leave  
8010100d:	c3                   	ret    

8010100e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010100e:	55                   	push   %ebp
8010100f:	89 e5                	mov    %esp,%ebp
80101011:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	68 60 08 11 80       	push   $0x80110860
8010101c:	e8 f0 43 00 00       	call   80105411 <acquire>
80101021:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101024:	8b 45 08             	mov    0x8(%ebp),%eax
80101027:	8b 40 04             	mov    0x4(%eax),%eax
8010102a:	85 c0                	test   %eax,%eax
8010102c:	7f 0d                	jg     8010103b <filedup+0x2d>
    panic("filedup");
8010102e:	83 ec 0c             	sub    $0xc,%esp
80101031:	68 d4 92 10 80       	push   $0x801092d4
80101036:	e8 40 f5 ff ff       	call   8010057b <panic>
  f->ref++;
8010103b:	8b 45 08             	mov    0x8(%ebp),%eax
8010103e:	8b 40 04             	mov    0x4(%eax),%eax
80101041:	8d 50 01             	lea    0x1(%eax),%edx
80101044:	8b 45 08             	mov    0x8(%ebp),%eax
80101047:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010104a:	83 ec 0c             	sub    $0xc,%esp
8010104d:	68 60 08 11 80       	push   $0x80110860
80101052:	e8 21 44 00 00       	call   80105478 <release>
80101057:	83 c4 10             	add    $0x10,%esp
  return f;
8010105a:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010105d:	c9                   	leave  
8010105e:	c3                   	ret    

8010105f <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010105f:	55                   	push   %ebp
80101060:	89 e5                	mov    %esp,%ebp
80101062:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101065:	83 ec 0c             	sub    $0xc,%esp
80101068:	68 60 08 11 80       	push   $0x80110860
8010106d:	e8 9f 43 00 00       	call   80105411 <acquire>
80101072:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101075:	8b 45 08             	mov    0x8(%ebp),%eax
80101078:	8b 40 04             	mov    0x4(%eax),%eax
8010107b:	85 c0                	test   %eax,%eax
8010107d:	7f 0d                	jg     8010108c <fileclose+0x2d>
    panic("fileclose");
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	68 dc 92 10 80       	push   $0x801092dc
80101087:	e8 ef f4 ff ff       	call   8010057b <panic>
  if(--f->ref > 0){
8010108c:	8b 45 08             	mov    0x8(%ebp),%eax
8010108f:	8b 40 04             	mov    0x4(%eax),%eax
80101092:	8d 50 ff             	lea    -0x1(%eax),%edx
80101095:	8b 45 08             	mov    0x8(%ebp),%eax
80101098:	89 50 04             	mov    %edx,0x4(%eax)
8010109b:	8b 45 08             	mov    0x8(%ebp),%eax
8010109e:	8b 40 04             	mov    0x4(%eax),%eax
801010a1:	85 c0                	test   %eax,%eax
801010a3:	7e 15                	jle    801010ba <fileclose+0x5b>
    release(&ftable.lock);
801010a5:	83 ec 0c             	sub    $0xc,%esp
801010a8:	68 60 08 11 80       	push   $0x80110860
801010ad:	e8 c6 43 00 00       	call   80105478 <release>
801010b2:	83 c4 10             	add    $0x10,%esp
801010b5:	e9 8b 00 00 00       	jmp    80101145 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010ba:	8b 45 08             	mov    0x8(%ebp),%eax
801010bd:	8b 10                	mov    (%eax),%edx
801010bf:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010c2:	8b 50 04             	mov    0x4(%eax),%edx
801010c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010c8:	8b 50 08             	mov    0x8(%eax),%edx
801010cb:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010ce:	8b 50 0c             	mov    0xc(%eax),%edx
801010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010d4:	8b 50 10             	mov    0x10(%eax),%edx
801010d7:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010da:	8b 40 14             	mov    0x14(%eax),%eax
801010dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010e0:	8b 45 08             	mov    0x8(%ebp),%eax
801010e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
801010ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	68 60 08 11 80       	push   $0x80110860
801010fb:	e8 78 43 00 00       	call   80105478 <release>
80101100:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101103:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101106:	83 f8 01             	cmp    $0x1,%eax
80101109:	75 19                	jne    80101124 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010110b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010110f:	0f be d0             	movsbl %al,%edx
80101112:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101115:	83 ec 08             	sub    $0x8,%esp
80101118:	52                   	push   %edx
80101119:	50                   	push   %eax
8010111a:	e8 59 30 00 00       	call   80104178 <pipeclose>
8010111f:	83 c4 10             	add    $0x10,%esp
80101122:	eb 21                	jmp    80101145 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101124:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101127:	83 f8 02             	cmp    $0x2,%eax
8010112a:	75 19                	jne    80101145 <fileclose+0xe6>
    begin_op();
8010112c:	e8 f9 23 00 00       	call   8010352a <begin_op>
    iput(ff.ip);
80101131:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101134:	83 ec 0c             	sub    $0xc,%esp
80101137:	50                   	push   %eax
80101138:	e8 c1 09 00 00       	call   80101afe <iput>
8010113d:	83 c4 10             	add    $0x10,%esp
    end_op();
80101140:	e8 71 24 00 00       	call   801035b6 <end_op>
  }
}
80101145:	c9                   	leave  
80101146:	c3                   	ret    

80101147 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101147:	55                   	push   %ebp
80101148:	89 e5                	mov    %esp,%ebp
8010114a:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010114d:	8b 45 08             	mov    0x8(%ebp),%eax
80101150:	8b 00                	mov    (%eax),%eax
80101152:	83 f8 02             	cmp    $0x2,%eax
80101155:	75 40                	jne    80101197 <filestat+0x50>
    ilock(f->ip);
80101157:	8b 45 08             	mov    0x8(%ebp),%eax
8010115a:	8b 40 10             	mov    0x10(%eax),%eax
8010115d:	83 ec 0c             	sub    $0xc,%esp
80101160:	50                   	push   %eax
80101161:	e8 ce 07 00 00       	call   80101934 <ilock>
80101166:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101169:	8b 45 08             	mov    0x8(%ebp),%eax
8010116c:	8b 40 10             	mov    0x10(%eax),%eax
8010116f:	83 ec 08             	sub    $0x8,%esp
80101172:	ff 75 0c             	push   0xc(%ebp)
80101175:	50                   	push   %eax
80101176:	e8 d6 0c 00 00       	call   80101e51 <stati>
8010117b:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010117e:	8b 45 08             	mov    0x8(%ebp),%eax
80101181:	8b 40 10             	mov    0x10(%eax),%eax
80101184:	83 ec 0c             	sub    $0xc,%esp
80101187:	50                   	push   %eax
80101188:	e8 ff 08 00 00       	call   80101a8c <iunlock>
8010118d:	83 c4 10             	add    $0x10,%esp
    return 0;
80101190:	b8 00 00 00 00       	mov    $0x0,%eax
80101195:	eb 05                	jmp    8010119c <filestat+0x55>
  }
  return -1;
80101197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010119c:	c9                   	leave  
8010119d:	c3                   	ret    

8010119e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010119e:	55                   	push   %ebp
8010119f:	89 e5                	mov    %esp,%ebp
801011a1:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011a4:	8b 45 08             	mov    0x8(%ebp),%eax
801011a7:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011ab:	84 c0                	test   %al,%al
801011ad:	75 0a                	jne    801011b9 <fileread+0x1b>
    return -1;
801011af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011b4:	e9 9b 00 00 00       	jmp    80101254 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011b9:	8b 45 08             	mov    0x8(%ebp),%eax
801011bc:	8b 00                	mov    (%eax),%eax
801011be:	83 f8 01             	cmp    $0x1,%eax
801011c1:	75 1a                	jne    801011dd <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011c3:	8b 45 08             	mov    0x8(%ebp),%eax
801011c6:	8b 40 0c             	mov    0xc(%eax),%eax
801011c9:	83 ec 04             	sub    $0x4,%esp
801011cc:	ff 75 10             	push   0x10(%ebp)
801011cf:	ff 75 0c             	push   0xc(%ebp)
801011d2:	50                   	push   %eax
801011d3:	e8 4e 31 00 00       	call   80104326 <piperead>
801011d8:	83 c4 10             	add    $0x10,%esp
801011db:	eb 77                	jmp    80101254 <fileread+0xb6>
  if(f->type == FD_INODE){
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	8b 00                	mov    (%eax),%eax
801011e2:	83 f8 02             	cmp    $0x2,%eax
801011e5:	75 60                	jne    80101247 <fileread+0xa9>
    ilock(f->ip);
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	8b 40 10             	mov    0x10(%eax),%eax
801011ed:	83 ec 0c             	sub    $0xc,%esp
801011f0:	50                   	push   %eax
801011f1:	e8 3e 07 00 00       	call   80101934 <ilock>
801011f6:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	8b 50 14             	mov    0x14(%eax),%edx
80101202:	8b 45 08             	mov    0x8(%ebp),%eax
80101205:	8b 40 10             	mov    0x10(%eax),%eax
80101208:	51                   	push   %ecx
80101209:	52                   	push   %edx
8010120a:	ff 75 0c             	push   0xc(%ebp)
8010120d:	50                   	push   %eax
8010120e:	e8 84 0c 00 00       	call   80101e97 <readi>
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010121d:	7e 11                	jle    80101230 <fileread+0x92>
      f->off += r;
8010121f:	8b 45 08             	mov    0x8(%ebp),%eax
80101222:	8b 50 14             	mov    0x14(%eax),%edx
80101225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101228:	01 c2                	add    %eax,%edx
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101230:	8b 45 08             	mov    0x8(%ebp),%eax
80101233:	8b 40 10             	mov    0x10(%eax),%eax
80101236:	83 ec 0c             	sub    $0xc,%esp
80101239:	50                   	push   %eax
8010123a:	e8 4d 08 00 00       	call   80101a8c <iunlock>
8010123f:	83 c4 10             	add    $0x10,%esp
    return r;
80101242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101245:	eb 0d                	jmp    80101254 <fileread+0xb6>
  }
  panic("fileread");
80101247:	83 ec 0c             	sub    $0xc,%esp
8010124a:	68 e6 92 10 80       	push   $0x801092e6
8010124f:	e8 27 f3 ff ff       	call   8010057b <panic>
}
80101254:	c9                   	leave  
80101255:	c3                   	ret    

80101256 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101256:	55                   	push   %ebp
80101257:	89 e5                	mov    %esp,%ebp
80101259:	53                   	push   %ebx
8010125a:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010125d:	8b 45 08             	mov    0x8(%ebp),%eax
80101260:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101264:	84 c0                	test   %al,%al
80101266:	75 0a                	jne    80101272 <filewrite+0x1c>
    return -1;
80101268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010126d:	e9 1b 01 00 00       	jmp    8010138d <filewrite+0x137>
  if(f->type == FD_PIPE)
80101272:	8b 45 08             	mov    0x8(%ebp),%eax
80101275:	8b 00                	mov    (%eax),%eax
80101277:	83 f8 01             	cmp    $0x1,%eax
8010127a:	75 1d                	jne    80101299 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	8b 40 0c             	mov    0xc(%eax),%eax
80101282:	83 ec 04             	sub    $0x4,%esp
80101285:	ff 75 10             	push   0x10(%ebp)
80101288:	ff 75 0c             	push   0xc(%ebp)
8010128b:	50                   	push   %eax
8010128c:	e8 92 2f 00 00       	call   80104223 <pipewrite>
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	e9 f4 00 00 00       	jmp    8010138d <filewrite+0x137>
  if(f->type == FD_INODE){
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 00                	mov    (%eax),%eax
8010129e:	83 f8 02             	cmp    $0x2,%eax
801012a1:	0f 85 d9 00 00 00    	jne    80101380 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012a7:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012b5:	e9 a3 00 00 00       	jmp    8010135d <filewrite+0x107>
      int n1 = n - i;
801012ba:	8b 45 10             	mov    0x10(%ebp),%eax
801012bd:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012c9:	7e 06                	jle    801012d1 <filewrite+0x7b>
        n1 = max;
801012cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012d1:	e8 54 22 00 00       	call   8010352a <begin_op>
      ilock(f->ip);
801012d6:	8b 45 08             	mov    0x8(%ebp),%eax
801012d9:	8b 40 10             	mov    0x10(%eax),%eax
801012dc:	83 ec 0c             	sub    $0xc,%esp
801012df:	50                   	push   %eax
801012e0:	e8 4f 06 00 00       	call   80101934 <ilock>
801012e5:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012e8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012eb:	8b 45 08             	mov    0x8(%ebp),%eax
801012ee:	8b 50 14             	mov    0x14(%eax),%edx
801012f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801012f7:	01 c3                	add    %eax,%ebx
801012f9:	8b 45 08             	mov    0x8(%ebp),%eax
801012fc:	8b 40 10             	mov    0x10(%eax),%eax
801012ff:	51                   	push   %ecx
80101300:	52                   	push   %edx
80101301:	53                   	push   %ebx
80101302:	50                   	push   %eax
80101303:	e8 e4 0c 00 00       	call   80101fec <writei>
80101308:	83 c4 10             	add    $0x10,%esp
8010130b:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010130e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101312:	7e 11                	jle    80101325 <filewrite+0xcf>
        f->off += r;
80101314:	8b 45 08             	mov    0x8(%ebp),%eax
80101317:	8b 50 14             	mov    0x14(%eax),%edx
8010131a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131d:	01 c2                	add    %eax,%edx
8010131f:	8b 45 08             	mov    0x8(%ebp),%eax
80101322:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101325:	8b 45 08             	mov    0x8(%ebp),%eax
80101328:	8b 40 10             	mov    0x10(%eax),%eax
8010132b:	83 ec 0c             	sub    $0xc,%esp
8010132e:	50                   	push   %eax
8010132f:	e8 58 07 00 00       	call   80101a8c <iunlock>
80101334:	83 c4 10             	add    $0x10,%esp
      end_op();
80101337:	e8 7a 22 00 00       	call   801035b6 <end_op>

      if(r < 0)
8010133c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101340:	78 29                	js     8010136b <filewrite+0x115>
        break;
      if(r != n1)
80101342:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101345:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101348:	74 0d                	je     80101357 <filewrite+0x101>
        panic("short filewrite");
8010134a:	83 ec 0c             	sub    $0xc,%esp
8010134d:	68 ef 92 10 80       	push   $0x801092ef
80101352:	e8 24 f2 ff ff       	call   8010057b <panic>
      i += r;
80101357:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010135a:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101360:	3b 45 10             	cmp    0x10(%ebp),%eax
80101363:	0f 8c 51 ff ff ff    	jl     801012ba <filewrite+0x64>
80101369:	eb 01                	jmp    8010136c <filewrite+0x116>
        break;
8010136b:	90                   	nop
    }
    return i == n ? n : -1;
8010136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136f:	3b 45 10             	cmp    0x10(%ebp),%eax
80101372:	75 05                	jne    80101379 <filewrite+0x123>
80101374:	8b 45 10             	mov    0x10(%ebp),%eax
80101377:	eb 14                	jmp    8010138d <filewrite+0x137>
80101379:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010137e:	eb 0d                	jmp    8010138d <filewrite+0x137>
  }
  panic("filewrite");
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	68 ff 92 10 80       	push   $0x801092ff
80101388:	e8 ee f1 ff ff       	call   8010057b <panic>
}
8010138d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101390:	c9                   	leave  
80101391:	c3                   	ret    

80101392 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101392:	55                   	push   %ebp
80101393:	89 e5                	mov    %esp,%ebp
80101395:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101398:	8b 45 08             	mov    0x8(%ebp),%eax
8010139b:	83 ec 08             	sub    $0x8,%esp
8010139e:	6a 01                	push   $0x1
801013a0:	50                   	push   %eax
801013a1:	e8 11 ee ff ff       	call   801001b7 <bread>
801013a6:	83 c4 10             	add    $0x10,%esp
801013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013af:	83 c0 18             	add    $0x18,%eax
801013b2:	83 ec 04             	sub    $0x4,%esp
801013b5:	6a 10                	push   $0x10
801013b7:	50                   	push   %eax
801013b8:	ff 75 0c             	push   0xc(%ebp)
801013bb:	e8 73 43 00 00       	call   80105733 <memmove>
801013c0:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013c3:	83 ec 0c             	sub    $0xc,%esp
801013c6:	ff 75 f4             	push   -0xc(%ebp)
801013c9:	e8 61 ee ff ff       	call   8010022f <brelse>
801013ce:	83 c4 10             	add    $0x10,%esp
}
801013d1:	90                   	nop
801013d2:	c9                   	leave  
801013d3:	c3                   	ret    

801013d4 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013d4:	55                   	push   %ebp
801013d5:	89 e5                	mov    %esp,%ebp
801013d7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013da:	8b 55 0c             	mov    0xc(%ebp),%edx
801013dd:	8b 45 08             	mov    0x8(%ebp),%eax
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	52                   	push   %edx
801013e4:	50                   	push   %eax
801013e5:	e8 cd ed ff ff       	call   801001b7 <bread>
801013ea:	83 c4 10             	add    $0x10,%esp
801013ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f3:	83 c0 18             	add    $0x18,%eax
801013f6:	83 ec 04             	sub    $0x4,%esp
801013f9:	68 00 02 00 00       	push   $0x200
801013fe:	6a 00                	push   $0x0
80101400:	50                   	push   %eax
80101401:	e8 6e 42 00 00       	call   80105674 <memset>
80101406:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101409:	83 ec 0c             	sub    $0xc,%esp
8010140c:	ff 75 f4             	push   -0xc(%ebp)
8010140f:	e8 4f 23 00 00       	call   80103763 <log_write>
80101414:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101417:	83 ec 0c             	sub    $0xc,%esp
8010141a:	ff 75 f4             	push   -0xc(%ebp)
8010141d:	e8 0d ee ff ff       	call   8010022f <brelse>
80101422:	83 c4 10             	add    $0x10,%esp
}
80101425:	90                   	nop
80101426:	c9                   	leave  
80101427:	c3                   	ret    

80101428 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101428:	55                   	push   %ebp
80101429:	89 e5                	mov    %esp,%ebp
8010142b:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010142e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101435:	8b 45 08             	mov    0x8(%ebp),%eax
80101438:	83 ec 08             	sub    $0x8,%esp
8010143b:	8d 55 d8             	lea    -0x28(%ebp),%edx
8010143e:	52                   	push   %edx
8010143f:	50                   	push   %eax
80101440:	e8 4d ff ff ff       	call   80101392 <readsb>
80101445:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101448:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010144f:	e9 15 01 00 00       	jmp    80101569 <balloc+0x141>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
80101454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101457:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010145d:	85 c0                	test   %eax,%eax
8010145f:	0f 48 c2             	cmovs  %edx,%eax
80101462:	c1 f8 0c             	sar    $0xc,%eax
80101465:	89 c2                	mov    %eax,%edx
80101467:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010146a:	c1 e8 03             	shr    $0x3,%eax
8010146d:	01 d0                	add    %edx,%eax
8010146f:	83 c0 03             	add    $0x3,%eax
80101472:	83 ec 08             	sub    $0x8,%esp
80101475:	50                   	push   %eax
80101476:	ff 75 08             	push   0x8(%ebp)
80101479:	e8 39 ed ff ff       	call   801001b7 <bread>
8010147e:	83 c4 10             	add    $0x10,%esp
80101481:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101484:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010148b:	e9 a6 00 00 00       	jmp    80101536 <balloc+0x10e>
      m = 1 << (bi % 8);
80101490:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101493:	99                   	cltd   
80101494:	c1 ea 1d             	shr    $0x1d,%edx
80101497:	01 d0                	add    %edx,%eax
80101499:	83 e0 07             	and    $0x7,%eax
8010149c:	29 d0                	sub    %edx,%eax
8010149e:	ba 01 00 00 00       	mov    $0x1,%edx
801014a3:	89 c1                	mov    %eax,%ecx
801014a5:	d3 e2                	shl    %cl,%edx
801014a7:	89 d0                	mov    %edx,%eax
801014a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014af:	8d 50 07             	lea    0x7(%eax),%edx
801014b2:	85 c0                	test   %eax,%eax
801014b4:	0f 48 c2             	cmovs  %edx,%eax
801014b7:	c1 f8 03             	sar    $0x3,%eax
801014ba:	89 c2                	mov    %eax,%edx
801014bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014bf:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014c4:	0f b6 c0             	movzbl %al,%eax
801014c7:	23 45 e8             	and    -0x18(%ebp),%eax
801014ca:	85 c0                	test   %eax,%eax
801014cc:	75 64                	jne    80101532 <balloc+0x10a>
        bp->data[bi/8] |= m;  // Mark block in use.
801014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d1:	8d 50 07             	lea    0x7(%eax),%edx
801014d4:	85 c0                	test   %eax,%eax
801014d6:	0f 48 c2             	cmovs  %edx,%eax
801014d9:	c1 f8 03             	sar    $0x3,%eax
801014dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014df:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014e4:	89 d1                	mov    %edx,%ecx
801014e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014e9:	09 ca                	or     %ecx,%edx
801014eb:	89 d1                	mov    %edx,%ecx
801014ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014f0:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014f4:	83 ec 0c             	sub    $0xc,%esp
801014f7:	ff 75 ec             	push   -0x14(%ebp)
801014fa:	e8 64 22 00 00       	call   80103763 <log_write>
801014ff:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101502:	83 ec 0c             	sub    $0xc,%esp
80101505:	ff 75 ec             	push   -0x14(%ebp)
80101508:	e8 22 ed ff ff       	call   8010022f <brelse>
8010150d:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101510:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101513:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101516:	01 c2                	add    %eax,%edx
80101518:	8b 45 08             	mov    0x8(%ebp),%eax
8010151b:	83 ec 08             	sub    $0x8,%esp
8010151e:	52                   	push   %edx
8010151f:	50                   	push   %eax
80101520:	e8 af fe ff ff       	call   801013d4 <bzero>
80101525:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101528:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152e:	01 d0                	add    %edx,%eax
80101530:	eb 52                	jmp    80101584 <balloc+0x15c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101532:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101536:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010153d:	7f 15                	jg     80101554 <balloc+0x12c>
8010153f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101542:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101545:	01 d0                	add    %edx,%eax
80101547:	89 c2                	mov    %eax,%edx
80101549:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010154c:	39 c2                	cmp    %eax,%edx
8010154e:	0f 82 3c ff ff ff    	jb     80101490 <balloc+0x68>
      }
    }
    brelse(bp);
80101554:	83 ec 0c             	sub    $0xc,%esp
80101557:	ff 75 ec             	push   -0x14(%ebp)
8010155a:	e8 d0 ec ff ff       	call   8010022f <brelse>
8010155f:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101562:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101569:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010156c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010156f:	39 c2                	cmp    %eax,%edx
80101571:	0f 87 dd fe ff ff    	ja     80101454 <balloc+0x2c>
  }
  panic("balloc: out of blocks");
80101577:	83 ec 0c             	sub    $0xc,%esp
8010157a:	68 09 93 10 80       	push   $0x80109309
8010157f:	e8 f7 ef ff ff       	call   8010057b <panic>
}
80101584:	c9                   	leave  
80101585:	c3                   	ret    

80101586 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101586:	55                   	push   %ebp
80101587:	89 e5                	mov    %esp,%ebp
80101589:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
8010158c:	83 ec 08             	sub    $0x8,%esp
8010158f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101592:	50                   	push   %eax
80101593:	ff 75 08             	push   0x8(%ebp)
80101596:	e8 f7 fd ff ff       	call   80101392 <readsb>
8010159b:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb.ninodes));
8010159e:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a1:	c1 e8 0c             	shr    $0xc,%eax
801015a4:	89 c2                	mov    %eax,%edx
801015a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801015a9:	c1 e8 03             	shr    $0x3,%eax
801015ac:	01 d0                	add    %edx,%eax
801015ae:	8d 50 03             	lea    0x3(%eax),%edx
801015b1:	8b 45 08             	mov    0x8(%ebp),%eax
801015b4:	83 ec 08             	sub    $0x8,%esp
801015b7:	52                   	push   %edx
801015b8:	50                   	push   %eax
801015b9:	e8 f9 eb ff ff       	call   801001b7 <bread>
801015be:	83 c4 10             	add    $0x10,%esp
801015c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c7:	25 ff 0f 00 00       	and    $0xfff,%eax
801015cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d2:	99                   	cltd   
801015d3:	c1 ea 1d             	shr    $0x1d,%edx
801015d6:	01 d0                	add    %edx,%eax
801015d8:	83 e0 07             	and    $0x7,%eax
801015db:	29 d0                	sub    %edx,%eax
801015dd:	ba 01 00 00 00       	mov    $0x1,%edx
801015e2:	89 c1                	mov    %eax,%ecx
801015e4:	d3 e2                	shl    %cl,%edx
801015e6:	89 d0                	mov    %edx,%eax
801015e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ee:	8d 50 07             	lea    0x7(%eax),%edx
801015f1:	85 c0                	test   %eax,%eax
801015f3:	0f 48 c2             	cmovs  %edx,%eax
801015f6:	c1 f8 03             	sar    $0x3,%eax
801015f9:	89 c2                	mov    %eax,%edx
801015fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fe:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101603:	0f b6 c0             	movzbl %al,%eax
80101606:	23 45 ec             	and    -0x14(%ebp),%eax
80101609:	85 c0                	test   %eax,%eax
8010160b:	75 0d                	jne    8010161a <bfree+0x94>
    panic("freeing free block");
8010160d:	83 ec 0c             	sub    $0xc,%esp
80101610:	68 1f 93 10 80       	push   $0x8010931f
80101615:	e8 61 ef ff ff       	call   8010057b <panic>
  bp->data[bi/8] &= ~m;
8010161a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010161d:	8d 50 07             	lea    0x7(%eax),%edx
80101620:	85 c0                	test   %eax,%eax
80101622:	0f 48 c2             	cmovs  %edx,%eax
80101625:	c1 f8 03             	sar    $0x3,%eax
80101628:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010162b:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101630:	89 d1                	mov    %edx,%ecx
80101632:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101635:	f7 d2                	not    %edx
80101637:	21 ca                	and    %ecx,%edx
80101639:	89 d1                	mov    %edx,%ecx
8010163b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010163e:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101642:	83 ec 0c             	sub    $0xc,%esp
80101645:	ff 75 f4             	push   -0xc(%ebp)
80101648:	e8 16 21 00 00       	call   80103763 <log_write>
8010164d:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	ff 75 f4             	push   -0xc(%ebp)
80101656:	e8 d4 eb ff ff       	call   8010022f <brelse>
8010165b:	83 c4 10             	add    $0x10,%esp
}
8010165e:	90                   	nop
8010165f:	c9                   	leave  
80101660:	c3                   	ret    

80101661 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101661:	55                   	push   %ebp
80101662:	89 e5                	mov    %esp,%ebp
80101664:	83 ec 08             	sub    $0x8,%esp
  initlock(&icache.lock, "icache");
80101667:	83 ec 08             	sub    $0x8,%esp
8010166a:	68 32 93 10 80       	push   $0x80109332
8010166f:	68 00 12 11 80       	push   $0x80111200
80101674:	e8 76 3d 00 00       	call   801053ef <initlock>
80101679:	83 c4 10             	add    $0x10,%esp
}
8010167c:	90                   	nop
8010167d:	c9                   	leave  
8010167e:	c3                   	ret    

8010167f <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010167f:	55                   	push   %ebp
80101680:	89 e5                	mov    %esp,%ebp
80101682:	83 ec 38             	sub    $0x38,%esp
80101685:	8b 45 0c             	mov    0xc(%ebp),%eax
80101688:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
8010168c:	8b 45 08             	mov    0x8(%ebp),%eax
8010168f:	83 ec 08             	sub    $0x8,%esp
80101692:	8d 55 dc             	lea    -0x24(%ebp),%edx
80101695:	52                   	push   %edx
80101696:	50                   	push   %eax
80101697:	e8 f6 fc ff ff       	call   80101392 <readsb>
8010169c:	83 c4 10             	add    $0x10,%esp

  for(inum = 1; inum < sb.ninodes; inum++){
8010169f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016a6:	e9 98 00 00 00       	jmp    80101743 <ialloc+0xc4>
    bp = bread(dev, IBLOCK(inum));
801016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016ae:	c1 e8 03             	shr    $0x3,%eax
801016b1:	83 c0 02             	add    $0x2,%eax
801016b4:	83 ec 08             	sub    $0x8,%esp
801016b7:	50                   	push   %eax
801016b8:	ff 75 08             	push   0x8(%ebp)
801016bb:	e8 f7 ea ff ff       	call   801001b7 <bread>
801016c0:	83 c4 10             	add    $0x10,%esp
801016c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c9:	8d 50 18             	lea    0x18(%eax),%edx
801016cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	01 d0                	add    %edx,%eax
801016d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016dd:	0f b7 00             	movzwl (%eax),%eax
801016e0:	66 85 c0             	test   %ax,%ax
801016e3:	75 4c                	jne    80101731 <ialloc+0xb2>
      memset(dip, 0, sizeof(*dip));
801016e5:	83 ec 04             	sub    $0x4,%esp
801016e8:	6a 40                	push   $0x40
801016ea:	6a 00                	push   $0x0
801016ec:	ff 75 ec             	push   -0x14(%ebp)
801016ef:	e8 80 3f 00 00       	call   80105674 <memset>
801016f4:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016fa:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
801016fe:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101701:	83 ec 0c             	sub    $0xc,%esp
80101704:	ff 75 f0             	push   -0x10(%ebp)
80101707:	e8 57 20 00 00       	call   80103763 <log_write>
8010170c:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
8010170f:	83 ec 0c             	sub    $0xc,%esp
80101712:	ff 75 f0             	push   -0x10(%ebp)
80101715:	e8 15 eb ff ff       	call   8010022f <brelse>
8010171a:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101720:	83 ec 08             	sub    $0x8,%esp
80101723:	50                   	push   %eax
80101724:	ff 75 08             	push   0x8(%ebp)
80101727:	e8 ef 00 00 00       	call   8010181b <iget>
8010172c:	83 c4 10             	add    $0x10,%esp
8010172f:	eb 2d                	jmp    8010175e <ialloc+0xdf>
    }
    brelse(bp);
80101731:	83 ec 0c             	sub    $0xc,%esp
80101734:	ff 75 f0             	push   -0x10(%ebp)
80101737:	e8 f3 ea ff ff       	call   8010022f <brelse>
8010173c:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
8010173f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101743:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101749:	39 c2                	cmp    %eax,%edx
8010174b:	0f 87 5a ff ff ff    	ja     801016ab <ialloc+0x2c>
  }
  panic("ialloc: no inodes");
80101751:	83 ec 0c             	sub    $0xc,%esp
80101754:	68 39 93 10 80       	push   $0x80109339
80101759:	e8 1d ee ff ff       	call   8010057b <panic>
}
8010175e:	c9                   	leave  
8010175f:	c3                   	ret    

80101760 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101766:	8b 45 08             	mov    0x8(%ebp),%eax
80101769:	8b 40 04             	mov    0x4(%eax),%eax
8010176c:	c1 e8 03             	shr    $0x3,%eax
8010176f:	8d 50 02             	lea    0x2(%eax),%edx
80101772:	8b 45 08             	mov    0x8(%ebp),%eax
80101775:	8b 00                	mov    (%eax),%eax
80101777:	83 ec 08             	sub    $0x8,%esp
8010177a:	52                   	push   %edx
8010177b:	50                   	push   %eax
8010177c:	e8 36 ea ff ff       	call   801001b7 <bread>
80101781:	83 c4 10             	add    $0x10,%esp
80101784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178a:	8d 50 18             	lea    0x18(%eax),%edx
8010178d:	8b 45 08             	mov    0x8(%ebp),%eax
80101790:	8b 40 04             	mov    0x4(%eax),%eax
80101793:	83 e0 07             	and    $0x7,%eax
80101796:	c1 e0 06             	shl    $0x6,%eax
80101799:	01 d0                	add    %edx,%eax
8010179b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801017a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a8:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017ab:	8b 45 08             	mov    0x8(%ebp),%eax
801017ae:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b5:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017b9:	8b 45 08             	mov    0x8(%ebp),%eax
801017bc:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c3:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017c7:	8b 45 08             	mov    0x8(%ebp),%eax
801017ca:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d1:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017d5:	8b 45 08             	mov    0x8(%ebp),%eax
801017d8:	8b 50 18             	mov    0x18(%eax),%edx
801017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017de:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017e1:	8b 45 08             	mov    0x8(%ebp),%eax
801017e4:	8d 50 1c             	lea    0x1c(%eax),%edx
801017e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ea:	83 c0 0c             	add    $0xc,%eax
801017ed:	83 ec 04             	sub    $0x4,%esp
801017f0:	6a 34                	push   $0x34
801017f2:	52                   	push   %edx
801017f3:	50                   	push   %eax
801017f4:	e8 3a 3f 00 00       	call   80105733 <memmove>
801017f9:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017fc:	83 ec 0c             	sub    $0xc,%esp
801017ff:	ff 75 f4             	push   -0xc(%ebp)
80101802:	e8 5c 1f 00 00       	call   80103763 <log_write>
80101807:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010180a:	83 ec 0c             	sub    $0xc,%esp
8010180d:	ff 75 f4             	push   -0xc(%ebp)
80101810:	e8 1a ea ff ff       	call   8010022f <brelse>
80101815:	83 c4 10             	add    $0x10,%esp
}
80101818:	90                   	nop
80101819:	c9                   	leave  
8010181a:	c3                   	ret    

8010181b <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010181b:	55                   	push   %ebp
8010181c:	89 e5                	mov    %esp,%ebp
8010181e:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101821:	83 ec 0c             	sub    $0xc,%esp
80101824:	68 00 12 11 80       	push   $0x80111200
80101829:	e8 e3 3b 00 00       	call   80105411 <acquire>
8010182e:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101831:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101838:	c7 45 f4 34 12 11 80 	movl   $0x80111234,-0xc(%ebp)
8010183f:	eb 5d                	jmp    8010189e <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101844:	8b 40 08             	mov    0x8(%eax),%eax
80101847:	85 c0                	test   %eax,%eax
80101849:	7e 39                	jle    80101884 <iget+0x69>
8010184b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184e:	8b 00                	mov    (%eax),%eax
80101850:	39 45 08             	cmp    %eax,0x8(%ebp)
80101853:	75 2f                	jne    80101884 <iget+0x69>
80101855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101858:	8b 40 04             	mov    0x4(%eax),%eax
8010185b:	39 45 0c             	cmp    %eax,0xc(%ebp)
8010185e:	75 24                	jne    80101884 <iget+0x69>
      ip->ref++;
80101860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101863:	8b 40 08             	mov    0x8(%eax),%eax
80101866:	8d 50 01             	lea    0x1(%eax),%edx
80101869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010186c:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010186f:	83 ec 0c             	sub    $0xc,%esp
80101872:	68 00 12 11 80       	push   $0x80111200
80101877:	e8 fc 3b 00 00       	call   80105478 <release>
8010187c:	83 c4 10             	add    $0x10,%esp
      return ip;
8010187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101882:	eb 74                	jmp    801018f8 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101884:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101888:	75 10                	jne    8010189a <iget+0x7f>
8010188a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188d:	8b 40 08             	mov    0x8(%eax),%eax
80101890:	85 c0                	test   %eax,%eax
80101892:	75 06                	jne    8010189a <iget+0x7f>
      empty = ip;
80101894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101897:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010189a:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010189e:	81 7d f4 d4 21 11 80 	cmpl   $0x801121d4,-0xc(%ebp)
801018a5:	72 9a                	jb     80101841 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018ab:	75 0d                	jne    801018ba <iget+0x9f>
    panic("iget: no inodes");
801018ad:	83 ec 0c             	sub    $0xc,%esp
801018b0:	68 4b 93 10 80       	push   $0x8010934b
801018b5:	e8 c1 ec ff ff       	call   8010057b <panic>

  ip = empty;
801018ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c3:	8b 55 08             	mov    0x8(%ebp),%edx
801018c6:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801018ce:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d4:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018e5:	83 ec 0c             	sub    $0xc,%esp
801018e8:	68 00 12 11 80       	push   $0x80111200
801018ed:	e8 86 3b 00 00       	call   80105478 <release>
801018f2:	83 c4 10             	add    $0x10,%esp

  return ip;
801018f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018f8:	c9                   	leave  
801018f9:	c3                   	ret    

801018fa <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018fa:	55                   	push   %ebp
801018fb:	89 e5                	mov    %esp,%ebp
801018fd:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 00 12 11 80       	push   $0x80111200
80101908:	e8 04 3b 00 00       	call   80105411 <acquire>
8010190d:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101910:	8b 45 08             	mov    0x8(%ebp),%eax
80101913:	8b 40 08             	mov    0x8(%eax),%eax
80101916:	8d 50 01             	lea    0x1(%eax),%edx
80101919:	8b 45 08             	mov    0x8(%ebp),%eax
8010191c:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010191f:	83 ec 0c             	sub    $0xc,%esp
80101922:	68 00 12 11 80       	push   $0x80111200
80101927:	e8 4c 3b 00 00       	call   80105478 <release>
8010192c:	83 c4 10             	add    $0x10,%esp
  return ip;
8010192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101932:	c9                   	leave  
80101933:	c3                   	ret    

80101934 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101934:	55                   	push   %ebp
80101935:	89 e5                	mov    %esp,%ebp
80101937:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010193a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010193e:	74 0a                	je     8010194a <ilock+0x16>
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	8b 40 08             	mov    0x8(%eax),%eax
80101946:	85 c0                	test   %eax,%eax
80101948:	7f 0d                	jg     80101957 <ilock+0x23>
    panic("ilock");
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	68 5b 93 10 80       	push   $0x8010935b
80101952:	e8 24 ec ff ff       	call   8010057b <panic>

  acquire(&icache.lock);
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 00 12 11 80       	push   $0x80111200
8010195f:	e8 ad 3a 00 00       	call   80105411 <acquire>
80101964:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101967:	eb 13                	jmp    8010197c <ilock+0x48>
    sleep(ip, &icache.lock);
80101969:	83 ec 08             	sub    $0x8,%esp
8010196c:	68 00 12 11 80       	push   $0x80111200
80101971:	ff 75 08             	push   0x8(%ebp)
80101974:	e8 ee 33 00 00       	call   80104d67 <sleep>
80101979:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010197c:	8b 45 08             	mov    0x8(%ebp),%eax
8010197f:	8b 40 0c             	mov    0xc(%eax),%eax
80101982:	83 e0 01             	and    $0x1,%eax
80101985:	85 c0                	test   %eax,%eax
80101987:	75 e0                	jne    80101969 <ilock+0x35>
  ip->flags |= I_BUSY;
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	8b 40 0c             	mov    0xc(%eax),%eax
8010198f:	83 c8 01             	or     $0x1,%eax
80101992:	89 c2                	mov    %eax,%edx
80101994:	8b 45 08             	mov    0x8(%ebp),%eax
80101997:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
8010199a:	83 ec 0c             	sub    $0xc,%esp
8010199d:	68 00 12 11 80       	push   $0x80111200
801019a2:	e8 d1 3a 00 00       	call   80105478 <release>
801019a7:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019aa:	8b 45 08             	mov    0x8(%ebp),%eax
801019ad:	8b 40 0c             	mov    0xc(%eax),%eax
801019b0:	83 e0 02             	and    $0x2,%eax
801019b3:	85 c0                	test   %eax,%eax
801019b5:	0f 85 ce 00 00 00    	jne    80101a89 <ilock+0x155>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801019bb:	8b 45 08             	mov    0x8(%ebp),%eax
801019be:	8b 40 04             	mov    0x4(%eax),%eax
801019c1:	c1 e8 03             	shr    $0x3,%eax
801019c4:	8d 50 02             	lea    0x2(%eax),%edx
801019c7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ca:	8b 00                	mov    (%eax),%eax
801019cc:	83 ec 08             	sub    $0x8,%esp
801019cf:	52                   	push   %edx
801019d0:	50                   	push   %eax
801019d1:	e8 e1 e7 ff ff       	call   801001b7 <bread>
801019d6:	83 c4 10             	add    $0x10,%esp
801019d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019df:	8d 50 18             	lea    0x18(%eax),%edx
801019e2:	8b 45 08             	mov    0x8(%ebp),%eax
801019e5:	8b 40 04             	mov    0x4(%eax),%eax
801019e8:	83 e0 07             	and    $0x7,%eax
801019eb:	c1 e0 06             	shl    $0x6,%eax
801019ee:	01 d0                	add    %edx,%eax
801019f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f6:	0f b7 10             	movzwl (%eax),%edx
801019f9:	8b 45 08             	mov    0x8(%ebp),%eax
801019fc:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a03:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a11:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a23:	8b 45 08             	mov    0x8(%ebp),%eax
80101a26:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a2d:	8b 50 08             	mov    0x8(%eax),%edx
80101a30:	8b 45 08             	mov    0x8(%ebp),%eax
80101a33:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a39:	8d 50 0c             	lea    0xc(%eax),%edx
80101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3f:	83 c0 1c             	add    $0x1c,%eax
80101a42:	83 ec 04             	sub    $0x4,%esp
80101a45:	6a 34                	push   $0x34
80101a47:	52                   	push   %edx
80101a48:	50                   	push   %eax
80101a49:	e8 e5 3c 00 00       	call   80105733 <memmove>
80101a4e:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a51:	83 ec 0c             	sub    $0xc,%esp
80101a54:	ff 75 f4             	push   -0xc(%ebp)
80101a57:	e8 d3 e7 ff ff       	call   8010022f <brelse>
80101a5c:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a62:	8b 40 0c             	mov    0xc(%eax),%eax
80101a65:	83 c8 02             	or     $0x2,%eax
80101a68:	89 c2                	mov    %eax,%edx
80101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6d:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a77:	66 85 c0             	test   %ax,%ax
80101a7a:	75 0d                	jne    80101a89 <ilock+0x155>
      panic("ilock: no type");
80101a7c:	83 ec 0c             	sub    $0xc,%esp
80101a7f:	68 61 93 10 80       	push   $0x80109361
80101a84:	e8 f2 ea ff ff       	call   8010057b <panic>
  }
}
80101a89:	90                   	nop
80101a8a:	c9                   	leave  
80101a8b:	c3                   	ret    

80101a8c <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a8c:	55                   	push   %ebp
80101a8d:	89 e5                	mov    %esp,%ebp
80101a8f:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a96:	74 17                	je     80101aaf <iunlock+0x23>
80101a98:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9b:	8b 40 0c             	mov    0xc(%eax),%eax
80101a9e:	83 e0 01             	and    $0x1,%eax
80101aa1:	85 c0                	test   %eax,%eax
80101aa3:	74 0a                	je     80101aaf <iunlock+0x23>
80101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa8:	8b 40 08             	mov    0x8(%eax),%eax
80101aab:	85 c0                	test   %eax,%eax
80101aad:	7f 0d                	jg     80101abc <iunlock+0x30>
    panic("iunlock");
80101aaf:	83 ec 0c             	sub    $0xc,%esp
80101ab2:	68 70 93 10 80       	push   $0x80109370
80101ab7:	e8 bf ea ff ff       	call   8010057b <panic>

  acquire(&icache.lock);
80101abc:	83 ec 0c             	sub    $0xc,%esp
80101abf:	68 00 12 11 80       	push   $0x80111200
80101ac4:	e8 48 39 00 00       	call   80105411 <acquire>
80101ac9:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad2:	83 e0 fe             	and    $0xfffffffe,%eax
80101ad5:	89 c2                	mov    %eax,%edx
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101add:	83 ec 0c             	sub    $0xc,%esp
80101ae0:	ff 75 08             	push   0x8(%ebp)
80101ae3:	e8 6e 33 00 00       	call   80104e56 <wakeup>
80101ae8:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101aeb:	83 ec 0c             	sub    $0xc,%esp
80101aee:	68 00 12 11 80       	push   $0x80111200
80101af3:	e8 80 39 00 00       	call   80105478 <release>
80101af8:	83 c4 10             	add    $0x10,%esp
}
80101afb:	90                   	nop
80101afc:	c9                   	leave  
80101afd:	c3                   	ret    

80101afe <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101afe:	55                   	push   %ebp
80101aff:	89 e5                	mov    %esp,%ebp
80101b01:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b04:	83 ec 0c             	sub    $0xc,%esp
80101b07:	68 00 12 11 80       	push   $0x80111200
80101b0c:	e8 00 39 00 00       	call   80105411 <acquire>
80101b11:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b14:	8b 45 08             	mov    0x8(%ebp),%eax
80101b17:	8b 40 08             	mov    0x8(%eax),%eax
80101b1a:	83 f8 01             	cmp    $0x1,%eax
80101b1d:	0f 85 a9 00 00 00    	jne    80101bcc <iput+0xce>
80101b23:	8b 45 08             	mov    0x8(%ebp),%eax
80101b26:	8b 40 0c             	mov    0xc(%eax),%eax
80101b29:	83 e0 02             	and    $0x2,%eax
80101b2c:	85 c0                	test   %eax,%eax
80101b2e:	0f 84 98 00 00 00    	je     80101bcc <iput+0xce>
80101b34:	8b 45 08             	mov    0x8(%ebp),%eax
80101b37:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b3b:	66 85 c0             	test   %ax,%ax
80101b3e:	0f 85 88 00 00 00    	jne    80101bcc <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	8b 40 0c             	mov    0xc(%eax),%eax
80101b4a:	83 e0 01             	and    $0x1,%eax
80101b4d:	85 c0                	test   %eax,%eax
80101b4f:	74 0d                	je     80101b5e <iput+0x60>
      panic("iput busy");
80101b51:	83 ec 0c             	sub    $0xc,%esp
80101b54:	68 78 93 10 80       	push   $0x80109378
80101b59:	e8 1d ea ff ff       	call   8010057b <panic>
    ip->flags |= I_BUSY;
80101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b61:	8b 40 0c             	mov    0xc(%eax),%eax
80101b64:	83 c8 01             	or     $0x1,%eax
80101b67:	89 c2                	mov    %eax,%edx
80101b69:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6c:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b6f:	83 ec 0c             	sub    $0xc,%esp
80101b72:	68 00 12 11 80       	push   $0x80111200
80101b77:	e8 fc 38 00 00       	call   80105478 <release>
80101b7c:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b7f:	83 ec 0c             	sub    $0xc,%esp
80101b82:	ff 75 08             	push   0x8(%ebp)
80101b85:	e8 a3 01 00 00       	call   80101d2d <itrunc>
80101b8a:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b90:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b96:	83 ec 0c             	sub    $0xc,%esp
80101b99:	ff 75 08             	push   0x8(%ebp)
80101b9c:	e8 bf fb ff ff       	call   80101760 <iupdate>
80101ba1:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101ba4:	83 ec 0c             	sub    $0xc,%esp
80101ba7:	68 00 12 11 80       	push   $0x80111200
80101bac:	e8 60 38 00 00       	call   80105411 <acquire>
80101bb1:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bbe:	83 ec 0c             	sub    $0xc,%esp
80101bc1:	ff 75 08             	push   0x8(%ebp)
80101bc4:	e8 8d 32 00 00       	call   80104e56 <wakeup>
80101bc9:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bcc:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcf:	8b 40 08             	mov    0x8(%eax),%eax
80101bd2:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bdb:	83 ec 0c             	sub    $0xc,%esp
80101bde:	68 00 12 11 80       	push   $0x80111200
80101be3:	e8 90 38 00 00       	call   80105478 <release>
80101be8:	83 c4 10             	add    $0x10,%esp
}
80101beb:	90                   	nop
80101bec:	c9                   	leave  
80101bed:	c3                   	ret    

80101bee <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101bee:	55                   	push   %ebp
80101bef:	89 e5                	mov    %esp,%ebp
80101bf1:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101bf4:	83 ec 0c             	sub    $0xc,%esp
80101bf7:	ff 75 08             	push   0x8(%ebp)
80101bfa:	e8 8d fe ff ff       	call   80101a8c <iunlock>
80101bff:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c02:	83 ec 0c             	sub    $0xc,%esp
80101c05:	ff 75 08             	push   0x8(%ebp)
80101c08:	e8 f1 fe ff ff       	call   80101afe <iput>
80101c0d:	83 c4 10             	add    $0x10,%esp
}
80101c10:	90                   	nop
80101c11:	c9                   	leave  
80101c12:	c3                   	ret    

80101c13 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c13:	55                   	push   %ebp
80101c14:	89 e5                	mov    %esp,%ebp
80101c16:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c19:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c1d:	77 42                	ja     80101c61 <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c22:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c25:	83 c2 04             	add    $0x4,%edx
80101c28:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c33:	75 24                	jne    80101c59 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c35:	8b 45 08             	mov    0x8(%ebp),%eax
80101c38:	8b 00                	mov    (%eax),%eax
80101c3a:	83 ec 0c             	sub    $0xc,%esp
80101c3d:	50                   	push   %eax
80101c3e:	e8 e5 f7 ff ff       	call   80101428 <balloc>
80101c43:	83 c4 10             	add    $0x10,%esp
80101c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c49:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c4f:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c55:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c5c:	e9 ca 00 00 00       	jmp    80101d2b <bmap+0x118>
  }
  bn -= NDIRECT;
80101c61:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c65:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c69:	0f 87 af 00 00 00    	ja     80101d1e <bmap+0x10b>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c72:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c7c:	75 1d                	jne    80101c9b <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c81:	8b 00                	mov    (%eax),%eax
80101c83:	83 ec 0c             	sub    $0xc,%esp
80101c86:	50                   	push   %eax
80101c87:	e8 9c f7 ff ff       	call   80101428 <balloc>
80101c8c:	83 c4 10             	add    $0x10,%esp
80101c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c92:	8b 45 08             	mov    0x8(%ebp),%eax
80101c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c98:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c9e:	8b 00                	mov    (%eax),%eax
80101ca0:	83 ec 08             	sub    $0x8,%esp
80101ca3:	ff 75 f4             	push   -0xc(%ebp)
80101ca6:	50                   	push   %eax
80101ca7:	e8 0b e5 ff ff       	call   801001b7 <bread>
80101cac:	83 c4 10             	add    $0x10,%esp
80101caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb5:	83 c0 18             	add    $0x18,%eax
80101cb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cbe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cc8:	01 d0                	add    %edx,%eax
80101cca:	8b 00                	mov    (%eax),%eax
80101ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cd3:	75 36                	jne    80101d0b <bmap+0xf8>
      a[bn] = addr = balloc(ip->dev);
80101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd8:	8b 00                	mov    (%eax),%eax
80101cda:	83 ec 0c             	sub    $0xc,%esp
80101cdd:	50                   	push   %eax
80101cde:	e8 45 f7 ff ff       	call   80101428 <balloc>
80101ce3:	83 c4 10             	add    $0x10,%esp
80101ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf6:	01 c2                	add    %eax,%edx
80101cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cfb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101cfd:	83 ec 0c             	sub    $0xc,%esp
80101d00:	ff 75 f0             	push   -0x10(%ebp)
80101d03:	e8 5b 1a 00 00       	call   80103763 <log_write>
80101d08:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d0b:	83 ec 0c             	sub    $0xc,%esp
80101d0e:	ff 75 f0             	push   -0x10(%ebp)
80101d11:	e8 19 e5 ff ff       	call   8010022f <brelse>
80101d16:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d1c:	eb 0d                	jmp    80101d2b <bmap+0x118>
  }

  panic("bmap: out of range");
80101d1e:	83 ec 0c             	sub    $0xc,%esp
80101d21:	68 82 93 10 80       	push   $0x80109382
80101d26:	e8 50 e8 ff ff       	call   8010057b <panic>
}
80101d2b:	c9                   	leave  
80101d2c:	c3                   	ret    

80101d2d <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d2d:	55                   	push   %ebp
80101d2e:	89 e5                	mov    %esp,%ebp
80101d30:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d3a:	eb 45                	jmp    80101d81 <itrunc+0x54>
    if(ip->addrs[i]){
80101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d42:	83 c2 04             	add    $0x4,%edx
80101d45:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d49:	85 c0                	test   %eax,%eax
80101d4b:	74 30                	je     80101d7d <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d50:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d53:	83 c2 04             	add    $0x4,%edx
80101d56:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d5a:	8b 55 08             	mov    0x8(%ebp),%edx
80101d5d:	8b 12                	mov    (%edx),%edx
80101d5f:	83 ec 08             	sub    $0x8,%esp
80101d62:	50                   	push   %eax
80101d63:	52                   	push   %edx
80101d64:	e8 1d f8 ff ff       	call   80101586 <bfree>
80101d69:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d72:	83 c2 04             	add    $0x4,%edx
80101d75:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d7c:	00 
  for(i = 0; i < NDIRECT; i++){
80101d7d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d81:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d85:	7e b5                	jle    80101d3c <itrunc+0xf>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d87:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d8d:	85 c0                	test   %eax,%eax
80101d8f:	0f 84 a1 00 00 00    	je     80101e36 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d95:	8b 45 08             	mov    0x8(%ebp),%eax
80101d98:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9e:	8b 00                	mov    (%eax),%eax
80101da0:	83 ec 08             	sub    $0x8,%esp
80101da3:	52                   	push   %edx
80101da4:	50                   	push   %eax
80101da5:	e8 0d e4 ff ff       	call   801001b7 <bread>
80101daa:	83 c4 10             	add    $0x10,%esp
80101dad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101db0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101db3:	83 c0 18             	add    $0x18,%eax
80101db6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101db9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101dc0:	eb 3c                	jmp    80101dfe <itrunc+0xd1>
      if(a[j])
80101dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dc5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dcf:	01 d0                	add    %edx,%eax
80101dd1:	8b 00                	mov    (%eax),%eax
80101dd3:	85 c0                	test   %eax,%eax
80101dd5:	74 23                	je     80101dfa <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101de1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101de4:	01 d0                	add    %edx,%eax
80101de6:	8b 00                	mov    (%eax),%eax
80101de8:	8b 55 08             	mov    0x8(%ebp),%edx
80101deb:	8b 12                	mov    (%edx),%edx
80101ded:	83 ec 08             	sub    $0x8,%esp
80101df0:	50                   	push   %eax
80101df1:	52                   	push   %edx
80101df2:	e8 8f f7 ff ff       	call   80101586 <bfree>
80101df7:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101dfa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e01:	83 f8 7f             	cmp    $0x7f,%eax
80101e04:	76 bc                	jbe    80101dc2 <itrunc+0x95>
    }
    brelse(bp);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	ff 75 ec             	push   -0x14(%ebp)
80101e0c:	e8 1e e4 ff ff       	call   8010022f <brelse>
80101e11:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e1a:	8b 55 08             	mov    0x8(%ebp),%edx
80101e1d:	8b 12                	mov    (%edx),%edx
80101e1f:	83 ec 08             	sub    $0x8,%esp
80101e22:	50                   	push   %eax
80101e23:	52                   	push   %edx
80101e24:	e8 5d f7 ff ff       	call   80101586 <bfree>
80101e29:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2f:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e36:	8b 45 08             	mov    0x8(%ebp),%eax
80101e39:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	ff 75 08             	push   0x8(%ebp)
80101e46:	e8 15 f9 ff ff       	call   80101760 <iupdate>
80101e4b:	83 c4 10             	add    $0x10,%esp
}
80101e4e:	90                   	nop
80101e4f:	c9                   	leave  
80101e50:	c3                   	ret    

80101e51 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e51:	55                   	push   %ebp
80101e52:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e54:	8b 45 08             	mov    0x8(%ebp),%eax
80101e57:	8b 00                	mov    (%eax),%eax
80101e59:	89 c2                	mov    %eax,%edx
80101e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5e:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e61:	8b 45 08             	mov    0x8(%ebp),%eax
80101e64:	8b 50 04             	mov    0x4(%eax),%edx
80101e67:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e6a:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e70:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e74:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e77:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7d:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e81:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e84:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e88:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8b:	8b 50 18             	mov    0x18(%eax),%edx
80101e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e91:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e94:	90                   	nop
80101e95:	5d                   	pop    %ebp
80101e96:	c3                   	ret    

80101e97 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e97:	55                   	push   %ebp
80101e98:	89 e5                	mov    %esp,%ebp
80101e9a:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ea4:	66 83 f8 03          	cmp    $0x3,%ax
80101ea8:	75 5c                	jne    80101f06 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101eaa:	8b 45 08             	mov    0x8(%ebp),%eax
80101ead:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eb1:	66 85 c0             	test   %ax,%ax
80101eb4:	78 20                	js     80101ed6 <readi+0x3f>
80101eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ebd:	66 83 f8 09          	cmp    $0x9,%ax
80101ec1:	7f 13                	jg     80101ed6 <readi+0x3f>
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eca:	98                   	cwtl   
80101ecb:	8b 04 c5 00 08 11 80 	mov    -0x7feef800(,%eax,8),%eax
80101ed2:	85 c0                	test   %eax,%eax
80101ed4:	75 0a                	jne    80101ee0 <readi+0x49>
      return -1;
80101ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101edb:	e9 0a 01 00 00       	jmp    80101fea <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ee7:	98                   	cwtl   
80101ee8:	8b 04 c5 00 08 11 80 	mov    -0x7feef800(,%eax,8),%eax
80101eef:	8b 55 14             	mov    0x14(%ebp),%edx
80101ef2:	83 ec 04             	sub    $0x4,%esp
80101ef5:	52                   	push   %edx
80101ef6:	ff 75 0c             	push   0xc(%ebp)
80101ef9:	ff 75 08             	push   0x8(%ebp)
80101efc:	ff d0                	call   *%eax
80101efe:	83 c4 10             	add    $0x10,%esp
80101f01:	e9 e4 00 00 00       	jmp    80101fea <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f06:	8b 45 08             	mov    0x8(%ebp),%eax
80101f09:	8b 40 18             	mov    0x18(%eax),%eax
80101f0c:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f0f:	77 0d                	ja     80101f1e <readi+0x87>
80101f11:	8b 55 10             	mov    0x10(%ebp),%edx
80101f14:	8b 45 14             	mov    0x14(%ebp),%eax
80101f17:	01 d0                	add    %edx,%eax
80101f19:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f1c:	76 0a                	jbe    80101f28 <readi+0x91>
    return -1;
80101f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f23:	e9 c2 00 00 00       	jmp    80101fea <readi+0x153>
  if(off + n > ip->size)
80101f28:	8b 55 10             	mov    0x10(%ebp),%edx
80101f2b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f2e:	01 c2                	add    %eax,%edx
80101f30:	8b 45 08             	mov    0x8(%ebp),%eax
80101f33:	8b 40 18             	mov    0x18(%eax),%eax
80101f36:	39 c2                	cmp    %eax,%edx
80101f38:	76 0c                	jbe    80101f46 <readi+0xaf>
    n = ip->size - off;
80101f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3d:	8b 40 18             	mov    0x18(%eax),%eax
80101f40:	2b 45 10             	sub    0x10(%ebp),%eax
80101f43:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f4d:	e9 89 00 00 00       	jmp    80101fdb <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f52:	8b 45 10             	mov    0x10(%ebp),%eax
80101f55:	c1 e8 09             	shr    $0x9,%eax
80101f58:	83 ec 08             	sub    $0x8,%esp
80101f5b:	50                   	push   %eax
80101f5c:	ff 75 08             	push   0x8(%ebp)
80101f5f:	e8 af fc ff ff       	call   80101c13 <bmap>
80101f64:	83 c4 10             	add    $0x10,%esp
80101f67:	8b 55 08             	mov    0x8(%ebp),%edx
80101f6a:	8b 12                	mov    (%edx),%edx
80101f6c:	83 ec 08             	sub    $0x8,%esp
80101f6f:	50                   	push   %eax
80101f70:	52                   	push   %edx
80101f71:	e8 41 e2 ff ff       	call   801001b7 <bread>
80101f76:	83 c4 10             	add    $0x10,%esp
80101f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f7c:	8b 45 10             	mov    0x10(%ebp),%eax
80101f7f:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f84:	ba 00 02 00 00       	mov    $0x200,%edx
80101f89:	29 c2                	sub    %eax,%edx
80101f8b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f8e:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f91:	39 c2                	cmp    %eax,%edx
80101f93:	0f 46 c2             	cmovbe %edx,%eax
80101f96:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f9c:	8d 50 18             	lea    0x18(%eax),%edx
80101f9f:	8b 45 10             	mov    0x10(%ebp),%eax
80101fa2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fa7:	01 d0                	add    %edx,%eax
80101fa9:	83 ec 04             	sub    $0x4,%esp
80101fac:	ff 75 ec             	push   -0x14(%ebp)
80101faf:	50                   	push   %eax
80101fb0:	ff 75 0c             	push   0xc(%ebp)
80101fb3:	e8 7b 37 00 00       	call   80105733 <memmove>
80101fb8:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fbb:	83 ec 0c             	sub    $0xc,%esp
80101fbe:	ff 75 f0             	push   -0x10(%ebp)
80101fc1:	e8 69 e2 ff ff       	call   8010022f <brelse>
80101fc6:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fcc:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd2:	01 45 10             	add    %eax,0x10(%ebp)
80101fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd8:	01 45 0c             	add    %eax,0xc(%ebp)
80101fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fde:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fe1:	0f 82 6b ff ff ff    	jb     80101f52 <readi+0xbb>
  }
  return n;
80101fe7:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fea:	c9                   	leave  
80101feb:	c3                   	ret    

80101fec <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101fec:	55                   	push   %ebp
80101fed:	89 e5                	mov    %esp,%ebp
80101fef:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ff9:	66 83 f8 03          	cmp    $0x3,%ax
80101ffd:	75 5c                	jne    8010205b <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101fff:	8b 45 08             	mov    0x8(%ebp),%eax
80102002:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102006:	66 85 c0             	test   %ax,%ax
80102009:	78 20                	js     8010202b <writei+0x3f>
8010200b:	8b 45 08             	mov    0x8(%ebp),%eax
8010200e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102012:	66 83 f8 09          	cmp    $0x9,%ax
80102016:	7f 13                	jg     8010202b <writei+0x3f>
80102018:	8b 45 08             	mov    0x8(%ebp),%eax
8010201b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010201f:	98                   	cwtl   
80102020:	8b 04 c5 04 08 11 80 	mov    -0x7feef7fc(,%eax,8),%eax
80102027:	85 c0                	test   %eax,%eax
80102029:	75 0a                	jne    80102035 <writei+0x49>
      return -1;
8010202b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102030:	e9 3b 01 00 00       	jmp    80102170 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
80102035:	8b 45 08             	mov    0x8(%ebp),%eax
80102038:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010203c:	98                   	cwtl   
8010203d:	8b 04 c5 04 08 11 80 	mov    -0x7feef7fc(,%eax,8),%eax
80102044:	8b 55 14             	mov    0x14(%ebp),%edx
80102047:	83 ec 04             	sub    $0x4,%esp
8010204a:	52                   	push   %edx
8010204b:	ff 75 0c             	push   0xc(%ebp)
8010204e:	ff 75 08             	push   0x8(%ebp)
80102051:	ff d0                	call   *%eax
80102053:	83 c4 10             	add    $0x10,%esp
80102056:	e9 15 01 00 00       	jmp    80102170 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
8010205b:	8b 45 08             	mov    0x8(%ebp),%eax
8010205e:	8b 40 18             	mov    0x18(%eax),%eax
80102061:	39 45 10             	cmp    %eax,0x10(%ebp)
80102064:	77 0d                	ja     80102073 <writei+0x87>
80102066:	8b 55 10             	mov    0x10(%ebp),%edx
80102069:	8b 45 14             	mov    0x14(%ebp),%eax
8010206c:	01 d0                	add    %edx,%eax
8010206e:	39 45 10             	cmp    %eax,0x10(%ebp)
80102071:	76 0a                	jbe    8010207d <writei+0x91>
    return -1;
80102073:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102078:	e9 f3 00 00 00       	jmp    80102170 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
8010207d:	8b 55 10             	mov    0x10(%ebp),%edx
80102080:	8b 45 14             	mov    0x14(%ebp),%eax
80102083:	01 d0                	add    %edx,%eax
80102085:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010208a:	76 0a                	jbe    80102096 <writei+0xaa>
    return -1;
8010208c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102091:	e9 da 00 00 00       	jmp    80102170 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010209d:	e9 97 00 00 00       	jmp    80102139 <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
801020a5:	c1 e8 09             	shr    $0x9,%eax
801020a8:	83 ec 08             	sub    $0x8,%esp
801020ab:	50                   	push   %eax
801020ac:	ff 75 08             	push   0x8(%ebp)
801020af:	e8 5f fb ff ff       	call   80101c13 <bmap>
801020b4:	83 c4 10             	add    $0x10,%esp
801020b7:	8b 55 08             	mov    0x8(%ebp),%edx
801020ba:	8b 12                	mov    (%edx),%edx
801020bc:	83 ec 08             	sub    $0x8,%esp
801020bf:	50                   	push   %eax
801020c0:	52                   	push   %edx
801020c1:	e8 f1 e0 ff ff       	call   801001b7 <bread>
801020c6:	83 c4 10             	add    $0x10,%esp
801020c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020cc:	8b 45 10             	mov    0x10(%ebp),%eax
801020cf:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d4:	ba 00 02 00 00       	mov    $0x200,%edx
801020d9:	29 c2                	sub    %eax,%edx
801020db:	8b 45 14             	mov    0x14(%ebp),%eax
801020de:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020e1:	39 c2                	cmp    %eax,%edx
801020e3:	0f 46 c2             	cmovbe %edx,%eax
801020e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020ec:	8d 50 18             	lea    0x18(%eax),%edx
801020ef:	8b 45 10             	mov    0x10(%ebp),%eax
801020f2:	25 ff 01 00 00       	and    $0x1ff,%eax
801020f7:	01 d0                	add    %edx,%eax
801020f9:	83 ec 04             	sub    $0x4,%esp
801020fc:	ff 75 ec             	push   -0x14(%ebp)
801020ff:	ff 75 0c             	push   0xc(%ebp)
80102102:	50                   	push   %eax
80102103:	e8 2b 36 00 00       	call   80105733 <memmove>
80102108:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010210b:	83 ec 0c             	sub    $0xc,%esp
8010210e:	ff 75 f0             	push   -0x10(%ebp)
80102111:	e8 4d 16 00 00       	call   80103763 <log_write>
80102116:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102119:	83 ec 0c             	sub    $0xc,%esp
8010211c:	ff 75 f0             	push   -0x10(%ebp)
8010211f:	e8 0b e1 ff ff       	call   8010022f <brelse>
80102124:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102127:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010212a:	01 45 f4             	add    %eax,-0xc(%ebp)
8010212d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102130:	01 45 10             	add    %eax,0x10(%ebp)
80102133:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102136:	01 45 0c             	add    %eax,0xc(%ebp)
80102139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010213c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010213f:	0f 82 5d ff ff ff    	jb     801020a2 <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
80102145:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102149:	74 22                	je     8010216d <writei+0x181>
8010214b:	8b 45 08             	mov    0x8(%ebp),%eax
8010214e:	8b 40 18             	mov    0x18(%eax),%eax
80102151:	39 45 10             	cmp    %eax,0x10(%ebp)
80102154:	76 17                	jbe    8010216d <writei+0x181>
    ip->size = off;
80102156:	8b 45 08             	mov    0x8(%ebp),%eax
80102159:	8b 55 10             	mov    0x10(%ebp),%edx
8010215c:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010215f:	83 ec 0c             	sub    $0xc,%esp
80102162:	ff 75 08             	push   0x8(%ebp)
80102165:	e8 f6 f5 ff ff       	call   80101760 <iupdate>
8010216a:	83 c4 10             	add    $0x10,%esp
  }
  return n;
8010216d:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102170:	c9                   	leave  
80102171:	c3                   	ret    

80102172 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102172:	55                   	push   %ebp
80102173:	89 e5                	mov    %esp,%ebp
80102175:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
80102178:	83 ec 04             	sub    $0x4,%esp
8010217b:	6a 0e                	push   $0xe
8010217d:	ff 75 0c             	push   0xc(%ebp)
80102180:	ff 75 08             	push   0x8(%ebp)
80102183:	e8 41 36 00 00       	call   801057c9 <strncmp>
80102188:	83 c4 10             	add    $0x10,%esp
}
8010218b:	c9                   	leave  
8010218c:	c3                   	ret    

8010218d <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010218d:	55                   	push   %ebp
8010218e:	89 e5                	mov    %esp,%ebp
80102190:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102193:	8b 45 08             	mov    0x8(%ebp),%eax
80102196:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010219a:	66 83 f8 01          	cmp    $0x1,%ax
8010219e:	74 0d                	je     801021ad <dirlookup+0x20>
    panic("dirlookup not DIR");
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	68 95 93 10 80       	push   $0x80109395
801021a8:	e8 ce e3 ff ff       	call   8010057b <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021b4:	eb 7b                	jmp    80102231 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021b6:	6a 10                	push   $0x10
801021b8:	ff 75 f4             	push   -0xc(%ebp)
801021bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021be:	50                   	push   %eax
801021bf:	ff 75 08             	push   0x8(%ebp)
801021c2:	e8 d0 fc ff ff       	call   80101e97 <readi>
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	83 f8 10             	cmp    $0x10,%eax
801021cd:	74 0d                	je     801021dc <dirlookup+0x4f>
      panic("dirlink read");
801021cf:	83 ec 0c             	sub    $0xc,%esp
801021d2:	68 a7 93 10 80       	push   $0x801093a7
801021d7:	e8 9f e3 ff ff       	call   8010057b <panic>
    if(de.inum == 0)
801021dc:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021e0:	66 85 c0             	test   %ax,%ax
801021e3:	74 47                	je     8010222c <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801021e5:	83 ec 08             	sub    $0x8,%esp
801021e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021eb:	83 c0 02             	add    $0x2,%eax
801021ee:	50                   	push   %eax
801021ef:	ff 75 0c             	push   0xc(%ebp)
801021f2:	e8 7b ff ff ff       	call   80102172 <namecmp>
801021f7:	83 c4 10             	add    $0x10,%esp
801021fa:	85 c0                	test   %eax,%eax
801021fc:	75 2f                	jne    8010222d <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801021fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102202:	74 08                	je     8010220c <dirlookup+0x7f>
        *poff = off;
80102204:	8b 45 10             	mov    0x10(%ebp),%eax
80102207:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010220a:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010220c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102210:	0f b7 c0             	movzwl %ax,%eax
80102213:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102216:	8b 45 08             	mov    0x8(%ebp),%eax
80102219:	8b 00                	mov    (%eax),%eax
8010221b:	83 ec 08             	sub    $0x8,%esp
8010221e:	ff 75 f0             	push   -0x10(%ebp)
80102221:	50                   	push   %eax
80102222:	e8 f4 f5 ff ff       	call   8010181b <iget>
80102227:	83 c4 10             	add    $0x10,%esp
8010222a:	eb 19                	jmp    80102245 <dirlookup+0xb8>
      continue;
8010222c:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010222d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102231:	8b 45 08             	mov    0x8(%ebp),%eax
80102234:	8b 40 18             	mov    0x18(%eax),%eax
80102237:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010223a:	0f 82 76 ff ff ff    	jb     801021b6 <dirlookup+0x29>
    }
  }

  return 0;
80102240:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102245:	c9                   	leave  
80102246:	c3                   	ret    

80102247 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102247:	55                   	push   %ebp
80102248:	89 e5                	mov    %esp,%ebp
8010224a:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010224d:	83 ec 04             	sub    $0x4,%esp
80102250:	6a 00                	push   $0x0
80102252:	ff 75 0c             	push   0xc(%ebp)
80102255:	ff 75 08             	push   0x8(%ebp)
80102258:	e8 30 ff ff ff       	call   8010218d <dirlookup>
8010225d:	83 c4 10             	add    $0x10,%esp
80102260:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102263:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102267:	74 18                	je     80102281 <dirlink+0x3a>
    iput(ip);
80102269:	83 ec 0c             	sub    $0xc,%esp
8010226c:	ff 75 f0             	push   -0x10(%ebp)
8010226f:	e8 8a f8 ff ff       	call   80101afe <iput>
80102274:	83 c4 10             	add    $0x10,%esp
    return -1;
80102277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010227c:	e9 9c 00 00 00       	jmp    8010231d <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102281:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102288:	eb 39                	jmp    801022c3 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010228d:	6a 10                	push   $0x10
8010228f:	50                   	push   %eax
80102290:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102293:	50                   	push   %eax
80102294:	ff 75 08             	push   0x8(%ebp)
80102297:	e8 fb fb ff ff       	call   80101e97 <readi>
8010229c:	83 c4 10             	add    $0x10,%esp
8010229f:	83 f8 10             	cmp    $0x10,%eax
801022a2:	74 0d                	je     801022b1 <dirlink+0x6a>
      panic("dirlink read");
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 a7 93 10 80       	push   $0x801093a7
801022ac:	e8 ca e2 ff ff       	call   8010057b <panic>
    if(de.inum == 0)
801022b1:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022b5:	66 85 c0             	test   %ax,%ax
801022b8:	74 18                	je     801022d2 <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
801022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022bd:	83 c0 10             	add    $0x10,%eax
801022c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
801022c6:	8b 50 18             	mov    0x18(%eax),%edx
801022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022cc:	39 c2                	cmp    %eax,%edx
801022ce:	77 ba                	ja     8010228a <dirlink+0x43>
801022d0:	eb 01                	jmp    801022d3 <dirlink+0x8c>
      break;
801022d2:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801022d3:	83 ec 04             	sub    $0x4,%esp
801022d6:	6a 0e                	push   $0xe
801022d8:	ff 75 0c             	push   0xc(%ebp)
801022db:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022de:	83 c0 02             	add    $0x2,%eax
801022e1:	50                   	push   %eax
801022e2:	e8 38 35 00 00       	call   8010581f <strncpy>
801022e7:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022ea:	8b 45 10             	mov    0x10(%ebp),%eax
801022ed:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f4:	6a 10                	push   $0x10
801022f6:	50                   	push   %eax
801022f7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022fa:	50                   	push   %eax
801022fb:	ff 75 08             	push   0x8(%ebp)
801022fe:	e8 e9 fc ff ff       	call   80101fec <writei>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	83 f8 10             	cmp    $0x10,%eax
80102309:	74 0d                	je     80102318 <dirlink+0xd1>
    panic("dirlink");
8010230b:	83 ec 0c             	sub    $0xc,%esp
8010230e:	68 b4 93 10 80       	push   $0x801093b4
80102313:	e8 63 e2 ff ff       	call   8010057b <panic>
  
  return 0;
80102318:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010231d:	c9                   	leave  
8010231e:	c3                   	ret    

8010231f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010231f:	55                   	push   %ebp
80102320:	89 e5                	mov    %esp,%ebp
80102322:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102325:	eb 04                	jmp    8010232b <skipelem+0xc>
    path++;
80102327:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
8010232b:	8b 45 08             	mov    0x8(%ebp),%eax
8010232e:	0f b6 00             	movzbl (%eax),%eax
80102331:	3c 2f                	cmp    $0x2f,%al
80102333:	74 f2                	je     80102327 <skipelem+0x8>
  if(*path == 0)
80102335:	8b 45 08             	mov    0x8(%ebp),%eax
80102338:	0f b6 00             	movzbl (%eax),%eax
8010233b:	84 c0                	test   %al,%al
8010233d:	75 07                	jne    80102346 <skipelem+0x27>
    return 0;
8010233f:	b8 00 00 00 00       	mov    $0x0,%eax
80102344:	eb 77                	jmp    801023bd <skipelem+0x9e>
  s = path;
80102346:	8b 45 08             	mov    0x8(%ebp),%eax
80102349:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010234c:	eb 04                	jmp    80102352 <skipelem+0x33>
    path++;
8010234e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102352:	8b 45 08             	mov    0x8(%ebp),%eax
80102355:	0f b6 00             	movzbl (%eax),%eax
80102358:	3c 2f                	cmp    $0x2f,%al
8010235a:	74 0a                	je     80102366 <skipelem+0x47>
8010235c:	8b 45 08             	mov    0x8(%ebp),%eax
8010235f:	0f b6 00             	movzbl (%eax),%eax
80102362:	84 c0                	test   %al,%al
80102364:	75 e8                	jne    8010234e <skipelem+0x2f>
  len = path - s;
80102366:	8b 45 08             	mov    0x8(%ebp),%eax
80102369:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010236c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010236f:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102373:	7e 15                	jle    8010238a <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
80102375:	83 ec 04             	sub    $0x4,%esp
80102378:	6a 0e                	push   $0xe
8010237a:	ff 75 f4             	push   -0xc(%ebp)
8010237d:	ff 75 0c             	push   0xc(%ebp)
80102380:	e8 ae 33 00 00       	call   80105733 <memmove>
80102385:	83 c4 10             	add    $0x10,%esp
80102388:	eb 26                	jmp    801023b0 <skipelem+0x91>
  else {
    memmove(name, s, len);
8010238a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010238d:	83 ec 04             	sub    $0x4,%esp
80102390:	50                   	push   %eax
80102391:	ff 75 f4             	push   -0xc(%ebp)
80102394:	ff 75 0c             	push   0xc(%ebp)
80102397:	e8 97 33 00 00       	call   80105733 <memmove>
8010239c:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010239f:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801023a5:	01 d0                	add    %edx,%eax
801023a7:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023aa:	eb 04                	jmp    801023b0 <skipelem+0x91>
    path++;
801023ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801023b0:	8b 45 08             	mov    0x8(%ebp),%eax
801023b3:	0f b6 00             	movzbl (%eax),%eax
801023b6:	3c 2f                	cmp    $0x2f,%al
801023b8:	74 f2                	je     801023ac <skipelem+0x8d>
  return path;
801023ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023bd:	c9                   	leave  
801023be:	c3                   	ret    

801023bf <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023bf:	55                   	push   %ebp
801023c0:	89 e5                	mov    %esp,%ebp
801023c2:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
801023c8:	0f b6 00             	movzbl (%eax),%eax
801023cb:	3c 2f                	cmp    $0x2f,%al
801023cd:	75 17                	jne    801023e6 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801023cf:	83 ec 08             	sub    $0x8,%esp
801023d2:	6a 01                	push   $0x1
801023d4:	6a 01                	push   $0x1
801023d6:	e8 40 f4 ff ff       	call   8010181b <iget>
801023db:	83 c4 10             	add    $0x10,%esp
801023de:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023e1:	e9 bb 00 00 00       	jmp    801024a1 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801023e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023ec:	8b 40 68             	mov    0x68(%eax),%eax
801023ef:	83 ec 0c             	sub    $0xc,%esp
801023f2:	50                   	push   %eax
801023f3:	e8 02 f5 ff ff       	call   801018fa <idup>
801023f8:	83 c4 10             	add    $0x10,%esp
801023fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801023fe:	e9 9e 00 00 00       	jmp    801024a1 <namex+0xe2>
    ilock(ip);
80102403:	83 ec 0c             	sub    $0xc,%esp
80102406:	ff 75 f4             	push   -0xc(%ebp)
80102409:	e8 26 f5 ff ff       	call   80101934 <ilock>
8010240e:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102411:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102414:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102418:	66 83 f8 01          	cmp    $0x1,%ax
8010241c:	74 18                	je     80102436 <namex+0x77>
      iunlockput(ip);
8010241e:	83 ec 0c             	sub    $0xc,%esp
80102421:	ff 75 f4             	push   -0xc(%ebp)
80102424:	e8 c5 f7 ff ff       	call   80101bee <iunlockput>
80102429:	83 c4 10             	add    $0x10,%esp
      return 0;
8010242c:	b8 00 00 00 00       	mov    $0x0,%eax
80102431:	e9 a7 00 00 00       	jmp    801024dd <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102436:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010243a:	74 20                	je     8010245c <namex+0x9d>
8010243c:	8b 45 08             	mov    0x8(%ebp),%eax
8010243f:	0f b6 00             	movzbl (%eax),%eax
80102442:	84 c0                	test   %al,%al
80102444:	75 16                	jne    8010245c <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102446:	83 ec 0c             	sub    $0xc,%esp
80102449:	ff 75 f4             	push   -0xc(%ebp)
8010244c:	e8 3b f6 ff ff       	call   80101a8c <iunlock>
80102451:	83 c4 10             	add    $0x10,%esp
      return ip;
80102454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102457:	e9 81 00 00 00       	jmp    801024dd <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010245c:	83 ec 04             	sub    $0x4,%esp
8010245f:	6a 00                	push   $0x0
80102461:	ff 75 10             	push   0x10(%ebp)
80102464:	ff 75 f4             	push   -0xc(%ebp)
80102467:	e8 21 fd ff ff       	call   8010218d <dirlookup>
8010246c:	83 c4 10             	add    $0x10,%esp
8010246f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102472:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102476:	75 15                	jne    8010248d <namex+0xce>
      iunlockput(ip);
80102478:	83 ec 0c             	sub    $0xc,%esp
8010247b:	ff 75 f4             	push   -0xc(%ebp)
8010247e:	e8 6b f7 ff ff       	call   80101bee <iunlockput>
80102483:	83 c4 10             	add    $0x10,%esp
      return 0;
80102486:	b8 00 00 00 00       	mov    $0x0,%eax
8010248b:	eb 50                	jmp    801024dd <namex+0x11e>
    }
    iunlockput(ip);
8010248d:	83 ec 0c             	sub    $0xc,%esp
80102490:	ff 75 f4             	push   -0xc(%ebp)
80102493:	e8 56 f7 ff ff       	call   80101bee <iunlockput>
80102498:	83 c4 10             	add    $0x10,%esp
    ip = next;
8010249b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010249e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024a1:	83 ec 08             	sub    $0x8,%esp
801024a4:	ff 75 10             	push   0x10(%ebp)
801024a7:	ff 75 08             	push   0x8(%ebp)
801024aa:	e8 70 fe ff ff       	call   8010231f <skipelem>
801024af:	83 c4 10             	add    $0x10,%esp
801024b2:	89 45 08             	mov    %eax,0x8(%ebp)
801024b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024b9:	0f 85 44 ff ff ff    	jne    80102403 <namex+0x44>
  }
  if(nameiparent){
801024bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024c3:	74 15                	je     801024da <namex+0x11b>
    iput(ip);
801024c5:	83 ec 0c             	sub    $0xc,%esp
801024c8:	ff 75 f4             	push   -0xc(%ebp)
801024cb:	e8 2e f6 ff ff       	call   80101afe <iput>
801024d0:	83 c4 10             	add    $0x10,%esp
    return 0;
801024d3:	b8 00 00 00 00       	mov    $0x0,%eax
801024d8:	eb 03                	jmp    801024dd <namex+0x11e>
  }
  return ip;
801024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024dd:	c9                   	leave  
801024de:	c3                   	ret    

801024df <namei>:

struct inode*
namei(char *path)
{
801024df:	55                   	push   %ebp
801024e0:	89 e5                	mov    %esp,%ebp
801024e2:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024e5:	83 ec 04             	sub    $0x4,%esp
801024e8:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024eb:	50                   	push   %eax
801024ec:	6a 00                	push   $0x0
801024ee:	ff 75 08             	push   0x8(%ebp)
801024f1:	e8 c9 fe ff ff       	call   801023bf <namex>
801024f6:	83 c4 10             	add    $0x10,%esp
}
801024f9:	c9                   	leave  
801024fa:	c3                   	ret    

801024fb <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024fb:	55                   	push   %ebp
801024fc:	89 e5                	mov    %esp,%ebp
801024fe:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102501:	83 ec 04             	sub    $0x4,%esp
80102504:	ff 75 0c             	push   0xc(%ebp)
80102507:	6a 01                	push   $0x1
80102509:	ff 75 08             	push   0x8(%ebp)
8010250c:	e8 ae fe ff ff       	call   801023bf <namex>
80102511:	83 c4 10             	add    $0x10,%esp
}
80102514:	c9                   	leave  
80102515:	c3                   	ret    

80102516 <inb>:
{
80102516:	55                   	push   %ebp
80102517:	89 e5                	mov    %esp,%ebp
80102519:	83 ec 14             	sub    $0x14,%esp
8010251c:	8b 45 08             	mov    0x8(%ebp),%eax
8010251f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102523:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102527:	89 c2                	mov    %eax,%edx
80102529:	ec                   	in     (%dx),%al
8010252a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010252d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102531:	c9                   	leave  
80102532:	c3                   	ret    

80102533 <insl>:
{
80102533:	55                   	push   %ebp
80102534:	89 e5                	mov    %esp,%ebp
80102536:	57                   	push   %edi
80102537:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102538:	8b 55 08             	mov    0x8(%ebp),%edx
8010253b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010253e:	8b 45 10             	mov    0x10(%ebp),%eax
80102541:	89 cb                	mov    %ecx,%ebx
80102543:	89 df                	mov    %ebx,%edi
80102545:	89 c1                	mov    %eax,%ecx
80102547:	fc                   	cld    
80102548:	f3 6d                	rep insl (%dx),%es:(%edi)
8010254a:	89 c8                	mov    %ecx,%eax
8010254c:	89 fb                	mov    %edi,%ebx
8010254e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102551:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102554:	90                   	nop
80102555:	5b                   	pop    %ebx
80102556:	5f                   	pop    %edi
80102557:	5d                   	pop    %ebp
80102558:	c3                   	ret    

80102559 <outb>:
{
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	83 ec 08             	sub    $0x8,%esp
8010255f:	8b 45 08             	mov    0x8(%ebp),%eax
80102562:	8b 55 0c             	mov    0xc(%ebp),%edx
80102565:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102569:	89 d0                	mov    %edx,%eax
8010256b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010256e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102572:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102576:	ee                   	out    %al,(%dx)
}
80102577:	90                   	nop
80102578:	c9                   	leave  
80102579:	c3                   	ret    

8010257a <outsl>:
{
8010257a:	55                   	push   %ebp
8010257b:	89 e5                	mov    %esp,%ebp
8010257d:	56                   	push   %esi
8010257e:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
8010257f:	8b 55 08             	mov    0x8(%ebp),%edx
80102582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102585:	8b 45 10             	mov    0x10(%ebp),%eax
80102588:	89 cb                	mov    %ecx,%ebx
8010258a:	89 de                	mov    %ebx,%esi
8010258c:	89 c1                	mov    %eax,%ecx
8010258e:	fc                   	cld    
8010258f:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102591:	89 c8                	mov    %ecx,%eax
80102593:	89 f3                	mov    %esi,%ebx
80102595:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102598:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010259b:	90                   	nop
8010259c:	5b                   	pop    %ebx
8010259d:	5e                   	pop    %esi
8010259e:	5d                   	pop    %ebp
8010259f:	c3                   	ret    

801025a0 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801025a6:	90                   	nop
801025a7:	68 f7 01 00 00       	push   $0x1f7
801025ac:	e8 65 ff ff ff       	call   80102516 <inb>
801025b1:	83 c4 04             	add    $0x4,%esp
801025b4:	0f b6 c0             	movzbl %al,%eax
801025b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801025ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025bd:	25 c0 00 00 00       	and    $0xc0,%eax
801025c2:	83 f8 40             	cmp    $0x40,%eax
801025c5:	75 e0                	jne    801025a7 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801025c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025cb:	74 11                	je     801025de <idewait+0x3e>
801025cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801025d0:	83 e0 21             	and    $0x21,%eax
801025d3:	85 c0                	test   %eax,%eax
801025d5:	74 07                	je     801025de <idewait+0x3e>
    return -1;
801025d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dc:	eb 05                	jmp    801025e3 <idewait+0x43>
  return 0;
801025de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025e3:	c9                   	leave  
801025e4:	c3                   	ret    

801025e5 <ideinit>:

void
ideinit(void)
{
801025e5:	55                   	push   %ebp
801025e6:	89 e5                	mov    %esp,%ebp
801025e8:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
801025eb:	83 ec 08             	sub    $0x8,%esp
801025ee:	68 bc 93 10 80       	push   $0x801093bc
801025f3:	68 e0 21 11 80       	push   $0x801121e0
801025f8:	e8 f2 2d 00 00       	call   801053ef <initlock>
801025fd:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	6a 0e                	push   $0xe
80102605:	e8 06 19 00 00       	call   80103f10 <picenable>
8010260a:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010260d:	a1 44 29 11 80       	mov    0x80112944,%eax
80102612:	83 e8 01             	sub    $0x1,%eax
80102615:	83 ec 08             	sub    $0x8,%esp
80102618:	50                   	push   %eax
80102619:	6a 0e                	push   $0xe
8010261b:	e8 37 04 00 00       	call   80102a57 <ioapicenable>
80102620:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102623:	83 ec 0c             	sub    $0xc,%esp
80102626:	6a 00                	push   $0x0
80102628:	e8 73 ff ff ff       	call   801025a0 <idewait>
8010262d:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102630:	83 ec 08             	sub    $0x8,%esp
80102633:	68 f0 00 00 00       	push   $0xf0
80102638:	68 f6 01 00 00       	push   $0x1f6
8010263d:	e8 17 ff ff ff       	call   80102559 <outb>
80102642:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010264c:	eb 24                	jmp    80102672 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010264e:	83 ec 0c             	sub    $0xc,%esp
80102651:	68 f7 01 00 00       	push   $0x1f7
80102656:	e8 bb fe ff ff       	call   80102516 <inb>
8010265b:	83 c4 10             	add    $0x10,%esp
8010265e:	84 c0                	test   %al,%al
80102660:	74 0c                	je     8010266e <ideinit+0x89>
      havedisk1 = 1;
80102662:	c7 05 18 22 11 80 01 	movl   $0x1,0x80112218
80102669:	00 00 00 
      break;
8010266c:	eb 0d                	jmp    8010267b <ideinit+0x96>
  for(i=0; i<1000; i++){
8010266e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102672:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102679:	7e d3                	jle    8010264e <ideinit+0x69>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010267b:	83 ec 08             	sub    $0x8,%esp
8010267e:	68 e0 00 00 00       	push   $0xe0
80102683:	68 f6 01 00 00       	push   $0x1f6
80102688:	e8 cc fe ff ff       	call   80102559 <outb>
8010268d:	83 c4 10             	add    $0x10,%esp
}
80102690:	90                   	nop
80102691:	c9                   	leave  
80102692:	c3                   	ret    

80102693 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102693:	55                   	push   %ebp
80102694:	89 e5                	mov    %esp,%ebp
80102696:	83 ec 08             	sub    $0x8,%esp
  if(b == 0)
80102699:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010269d:	75 0d                	jne    801026ac <idestart+0x19>
    panic("idestart");
8010269f:	83 ec 0c             	sub    $0xc,%esp
801026a2:	68 c0 93 10 80       	push   $0x801093c0
801026a7:	e8 cf de ff ff       	call   8010057b <panic>

  idewait(0);
801026ac:	83 ec 0c             	sub    $0xc,%esp
801026af:	6a 00                	push   $0x0
801026b1:	e8 ea fe ff ff       	call   801025a0 <idewait>
801026b6:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801026b9:	83 ec 08             	sub    $0x8,%esp
801026bc:	6a 00                	push   $0x0
801026be:	68 f6 03 00 00       	push   $0x3f6
801026c3:	e8 91 fe ff ff       	call   80102559 <outb>
801026c8:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, 1);  // number of sectors
801026cb:	83 ec 08             	sub    $0x8,%esp
801026ce:	6a 01                	push   $0x1
801026d0:	68 f2 01 00 00       	push   $0x1f2
801026d5:	e8 7f fe ff ff       	call   80102559 <outb>
801026da:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, b->sector & 0xff);
801026dd:	8b 45 08             	mov    0x8(%ebp),%eax
801026e0:	8b 40 08             	mov    0x8(%eax),%eax
801026e3:	0f b6 c0             	movzbl %al,%eax
801026e6:	83 ec 08             	sub    $0x8,%esp
801026e9:	50                   	push   %eax
801026ea:	68 f3 01 00 00       	push   $0x1f3
801026ef:	e8 65 fe ff ff       	call   80102559 <outb>
801026f4:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (b->sector >> 8) & 0xff);
801026f7:	8b 45 08             	mov    0x8(%ebp),%eax
801026fa:	8b 40 08             	mov    0x8(%eax),%eax
801026fd:	c1 e8 08             	shr    $0x8,%eax
80102700:	0f b6 c0             	movzbl %al,%eax
80102703:	83 ec 08             	sub    $0x8,%esp
80102706:	50                   	push   %eax
80102707:	68 f4 01 00 00       	push   $0x1f4
8010270c:	e8 48 fe ff ff       	call   80102559 <outb>
80102711:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102714:	8b 45 08             	mov    0x8(%ebp),%eax
80102717:	8b 40 08             	mov    0x8(%eax),%eax
8010271a:	c1 e8 10             	shr    $0x10,%eax
8010271d:	0f b6 c0             	movzbl %al,%eax
80102720:	83 ec 08             	sub    $0x8,%esp
80102723:	50                   	push   %eax
80102724:	68 f5 01 00 00       	push   $0x1f5
80102729:	e8 2b fe ff ff       	call   80102559 <outb>
8010272e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102731:	8b 45 08             	mov    0x8(%ebp),%eax
80102734:	8b 40 04             	mov    0x4(%eax),%eax
80102737:	c1 e0 04             	shl    $0x4,%eax
8010273a:	83 e0 10             	and    $0x10,%eax
8010273d:	89 c2                	mov    %eax,%edx
8010273f:	8b 45 08             	mov    0x8(%ebp),%eax
80102742:	8b 40 08             	mov    0x8(%eax),%eax
80102745:	c1 e8 18             	shr    $0x18,%eax
80102748:	83 e0 0f             	and    $0xf,%eax
8010274b:	09 d0                	or     %edx,%eax
8010274d:	83 c8 e0             	or     $0xffffffe0,%eax
80102750:	0f b6 c0             	movzbl %al,%eax
80102753:	83 ec 08             	sub    $0x8,%esp
80102756:	50                   	push   %eax
80102757:	68 f6 01 00 00       	push   $0x1f6
8010275c:	e8 f8 fd ff ff       	call   80102559 <outb>
80102761:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102764:	8b 45 08             	mov    0x8(%ebp),%eax
80102767:	8b 00                	mov    (%eax),%eax
80102769:	83 e0 04             	and    $0x4,%eax
8010276c:	85 c0                	test   %eax,%eax
8010276e:	74 30                	je     801027a0 <idestart+0x10d>
    outb(0x1f7, IDE_CMD_WRITE);
80102770:	83 ec 08             	sub    $0x8,%esp
80102773:	6a 30                	push   $0x30
80102775:	68 f7 01 00 00       	push   $0x1f7
8010277a:	e8 da fd ff ff       	call   80102559 <outb>
8010277f:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, 512/4);
80102782:	8b 45 08             	mov    0x8(%ebp),%eax
80102785:	83 c0 18             	add    $0x18,%eax
80102788:	83 ec 04             	sub    $0x4,%esp
8010278b:	68 80 00 00 00       	push   $0x80
80102790:	50                   	push   %eax
80102791:	68 f0 01 00 00       	push   $0x1f0
80102796:	e8 df fd ff ff       	call   8010257a <outsl>
8010279b:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
8010279e:	eb 12                	jmp    801027b2 <idestart+0x11f>
    outb(0x1f7, IDE_CMD_READ);
801027a0:	83 ec 08             	sub    $0x8,%esp
801027a3:	6a 20                	push   $0x20
801027a5:	68 f7 01 00 00       	push   $0x1f7
801027aa:	e8 aa fd ff ff       	call   80102559 <outb>
801027af:	83 c4 10             	add    $0x10,%esp
}
801027b2:	90                   	nop
801027b3:	c9                   	leave  
801027b4:	c3                   	ret    

801027b5 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
801027b8:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	68 e0 21 11 80       	push   $0x801121e0
801027c3:	e8 49 2c 00 00       	call   80105411 <acquire>
801027c8:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801027cb:	a1 14 22 11 80       	mov    0x80112214,%eax
801027d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027d7:	75 15                	jne    801027ee <ideintr+0x39>
    release(&idelock);
801027d9:	83 ec 0c             	sub    $0xc,%esp
801027dc:	68 e0 21 11 80       	push   $0x801121e0
801027e1:	e8 92 2c 00 00       	call   80105478 <release>
801027e6:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
801027e9:	e9 9a 00 00 00       	jmp    80102888 <ideintr+0xd3>
  }
  idequeue = b->qnext;
801027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f1:	8b 40 14             	mov    0x14(%eax),%eax
801027f4:	a3 14 22 11 80       	mov    %eax,0x80112214

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fc:	8b 00                	mov    (%eax),%eax
801027fe:	83 e0 04             	and    $0x4,%eax
80102801:	85 c0                	test   %eax,%eax
80102803:	75 2d                	jne    80102832 <ideintr+0x7d>
80102805:	83 ec 0c             	sub    $0xc,%esp
80102808:	6a 01                	push   $0x1
8010280a:	e8 91 fd ff ff       	call   801025a0 <idewait>
8010280f:	83 c4 10             	add    $0x10,%esp
80102812:	85 c0                	test   %eax,%eax
80102814:	78 1c                	js     80102832 <ideintr+0x7d>
    insl(0x1f0, b->data, 512/4);
80102816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102819:	83 c0 18             	add    $0x18,%eax
8010281c:	83 ec 04             	sub    $0x4,%esp
8010281f:	68 80 00 00 00       	push   $0x80
80102824:	50                   	push   %eax
80102825:	68 f0 01 00 00       	push   $0x1f0
8010282a:	e8 04 fd ff ff       	call   80102533 <insl>
8010282f:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102832:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102835:	8b 00                	mov    (%eax),%eax
80102837:	83 c8 02             	or     $0x2,%eax
8010283a:	89 c2                	mov    %eax,%edx
8010283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010283f:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102844:	8b 00                	mov    (%eax),%eax
80102846:	83 e0 fb             	and    $0xfffffffb,%eax
80102849:	89 c2                	mov    %eax,%edx
8010284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284e:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102850:	83 ec 0c             	sub    $0xc,%esp
80102853:	ff 75 f4             	push   -0xc(%ebp)
80102856:	e8 fb 25 00 00       	call   80104e56 <wakeup>
8010285b:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010285e:	a1 14 22 11 80       	mov    0x80112214,%eax
80102863:	85 c0                	test   %eax,%eax
80102865:	74 11                	je     80102878 <ideintr+0xc3>
    idestart(idequeue);
80102867:	a1 14 22 11 80       	mov    0x80112214,%eax
8010286c:	83 ec 0c             	sub    $0xc,%esp
8010286f:	50                   	push   %eax
80102870:	e8 1e fe ff ff       	call   80102693 <idestart>
80102875:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102878:	83 ec 0c             	sub    $0xc,%esp
8010287b:	68 e0 21 11 80       	push   $0x801121e0
80102880:	e8 f3 2b 00 00       	call   80105478 <release>
80102885:	83 c4 10             	add    $0x10,%esp
}
80102888:	c9                   	leave  
80102889:	c3                   	ret    

8010288a <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010288a:	55                   	push   %ebp
8010288b:	89 e5                	mov    %esp,%ebp
8010288d:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102890:	8b 45 08             	mov    0x8(%ebp),%eax
80102893:	8b 00                	mov    (%eax),%eax
80102895:	83 e0 01             	and    $0x1,%eax
80102898:	85 c0                	test   %eax,%eax
8010289a:	75 0d                	jne    801028a9 <iderw+0x1f>
    panic("iderw: buf not busy");
8010289c:	83 ec 0c             	sub    $0xc,%esp
8010289f:	68 c9 93 10 80       	push   $0x801093c9
801028a4:	e8 d2 dc ff ff       	call   8010057b <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028a9:	8b 45 08             	mov    0x8(%ebp),%eax
801028ac:	8b 00                	mov    (%eax),%eax
801028ae:	83 e0 06             	and    $0x6,%eax
801028b1:	83 f8 02             	cmp    $0x2,%eax
801028b4:	75 0d                	jne    801028c3 <iderw+0x39>
    panic("iderw: nothing to do");
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	68 dd 93 10 80       	push   $0x801093dd
801028be:	e8 b8 dc ff ff       	call   8010057b <panic>
  if(b->dev != 0 && !havedisk1)
801028c3:	8b 45 08             	mov    0x8(%ebp),%eax
801028c6:	8b 40 04             	mov    0x4(%eax),%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 16                	je     801028e3 <iderw+0x59>
801028cd:	a1 18 22 11 80       	mov    0x80112218,%eax
801028d2:	85 c0                	test   %eax,%eax
801028d4:	75 0d                	jne    801028e3 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	68 f2 93 10 80       	push   $0x801093f2
801028de:	e8 98 dc ff ff       	call   8010057b <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028e3:	83 ec 0c             	sub    $0xc,%esp
801028e6:	68 e0 21 11 80       	push   $0x801121e0
801028eb:	e8 21 2b 00 00       	call   80105411 <acquire>
801028f0:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
801028f3:	8b 45 08             	mov    0x8(%ebp),%eax
801028f6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028fd:	c7 45 f4 14 22 11 80 	movl   $0x80112214,-0xc(%ebp)
80102904:	eb 0b                	jmp    80102911 <iderw+0x87>
80102906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102909:	8b 00                	mov    (%eax),%eax
8010290b:	83 c0 14             	add    $0x14,%eax
8010290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102914:	8b 00                	mov    (%eax),%eax
80102916:	85 c0                	test   %eax,%eax
80102918:	75 ec                	jne    80102906 <iderw+0x7c>
    ;
  *pp = b;
8010291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291d:	8b 55 08             	mov    0x8(%ebp),%edx
80102920:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102922:	a1 14 22 11 80       	mov    0x80112214,%eax
80102927:	39 45 08             	cmp    %eax,0x8(%ebp)
8010292a:	75 23                	jne    8010294f <iderw+0xc5>
    idestart(b);
8010292c:	83 ec 0c             	sub    $0xc,%esp
8010292f:	ff 75 08             	push   0x8(%ebp)
80102932:	e8 5c fd ff ff       	call   80102693 <idestart>
80102937:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010293a:	eb 13                	jmp    8010294f <iderw+0xc5>
    sleep(b, &idelock);
8010293c:	83 ec 08             	sub    $0x8,%esp
8010293f:	68 e0 21 11 80       	push   $0x801121e0
80102944:	ff 75 08             	push   0x8(%ebp)
80102947:	e8 1b 24 00 00       	call   80104d67 <sleep>
8010294c:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010294f:	8b 45 08             	mov    0x8(%ebp),%eax
80102952:	8b 00                	mov    (%eax),%eax
80102954:	83 e0 06             	and    $0x6,%eax
80102957:	83 f8 02             	cmp    $0x2,%eax
8010295a:	75 e0                	jne    8010293c <iderw+0xb2>
  }

  release(&idelock);
8010295c:	83 ec 0c             	sub    $0xc,%esp
8010295f:	68 e0 21 11 80       	push   $0x801121e0
80102964:	e8 0f 2b 00 00       	call   80105478 <release>
80102969:	83 c4 10             	add    $0x10,%esp
}
8010296c:	90                   	nop
8010296d:	c9                   	leave  
8010296e:	c3                   	ret    

8010296f <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
8010296f:	55                   	push   %ebp
80102970:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102972:	a1 1c 22 11 80       	mov    0x8011221c,%eax
80102977:	8b 55 08             	mov    0x8(%ebp),%edx
8010297a:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010297c:	a1 1c 22 11 80       	mov    0x8011221c,%eax
80102981:	8b 40 10             	mov    0x10(%eax),%eax
}
80102984:	5d                   	pop    %ebp
80102985:	c3                   	ret    

80102986 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102986:	55                   	push   %ebp
80102987:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102989:	a1 1c 22 11 80       	mov    0x8011221c,%eax
8010298e:	8b 55 08             	mov    0x8(%ebp),%edx
80102991:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102993:	a1 1c 22 11 80       	mov    0x8011221c,%eax
80102998:	8b 55 0c             	mov    0xc(%ebp),%edx
8010299b:	89 50 10             	mov    %edx,0x10(%eax)
}
8010299e:	90                   	nop
8010299f:	5d                   	pop    %ebp
801029a0:	c3                   	ret    

801029a1 <ioapicinit>:

void
ioapicinit(void)
{
801029a1:	55                   	push   %ebp
801029a2:	89 e5                	mov    %esp,%ebp
801029a4:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
801029a7:	a1 40 29 11 80       	mov    0x80112940,%eax
801029ac:	85 c0                	test   %eax,%eax
801029ae:	0f 84 a0 00 00 00    	je     80102a54 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029b4:	c7 05 1c 22 11 80 00 	movl   $0xfec00000,0x8011221c
801029bb:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029be:	6a 01                	push   $0x1
801029c0:	e8 aa ff ff ff       	call   8010296f <ioapicread>
801029c5:	83 c4 04             	add    $0x4,%esp
801029c8:	c1 e8 10             	shr    $0x10,%eax
801029cb:	25 ff 00 00 00       	and    $0xff,%eax
801029d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029d3:	6a 00                	push   $0x0
801029d5:	e8 95 ff ff ff       	call   8010296f <ioapicread>
801029da:	83 c4 04             	add    $0x4,%esp
801029dd:	c1 e8 18             	shr    $0x18,%eax
801029e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029e3:	0f b6 05 48 29 11 80 	movzbl 0x80112948,%eax
801029ea:	0f b6 c0             	movzbl %al,%eax
801029ed:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801029f0:	74 10                	je     80102a02 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029f2:	83 ec 0c             	sub    $0xc,%esp
801029f5:	68 10 94 10 80       	push   $0x80109410
801029fa:	e8 c7 d9 ff ff       	call   801003c6 <cprintf>
801029ff:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a09:	eb 3f                	jmp    80102a4a <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a0e:	83 c0 20             	add    $0x20,%eax
80102a11:	0d 00 00 01 00       	or     $0x10000,%eax
80102a16:	89 c2                	mov    %eax,%edx
80102a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a1b:	83 c0 08             	add    $0x8,%eax
80102a1e:	01 c0                	add    %eax,%eax
80102a20:	83 ec 08             	sub    $0x8,%esp
80102a23:	52                   	push   %edx
80102a24:	50                   	push   %eax
80102a25:	e8 5c ff ff ff       	call   80102986 <ioapicwrite>
80102a2a:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a30:	83 c0 08             	add    $0x8,%eax
80102a33:	01 c0                	add    %eax,%eax
80102a35:	83 c0 01             	add    $0x1,%eax
80102a38:	83 ec 08             	sub    $0x8,%esp
80102a3b:	6a 00                	push   $0x0
80102a3d:	50                   	push   %eax
80102a3e:	e8 43 ff ff ff       	call   80102986 <ioapicwrite>
80102a43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102a46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a50:	7e b9                	jle    80102a0b <ioapicinit+0x6a>
80102a52:	eb 01                	jmp    80102a55 <ioapicinit+0xb4>
    return;
80102a54:	90                   	nop
  }
}
80102a55:	c9                   	leave  
80102a56:	c3                   	ret    

80102a57 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a57:	55                   	push   %ebp
80102a58:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a5a:	a1 40 29 11 80       	mov    0x80112940,%eax
80102a5f:	85 c0                	test   %eax,%eax
80102a61:	74 39                	je     80102a9c <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a63:	8b 45 08             	mov    0x8(%ebp),%eax
80102a66:	83 c0 20             	add    $0x20,%eax
80102a69:	89 c2                	mov    %eax,%edx
80102a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6e:	83 c0 08             	add    $0x8,%eax
80102a71:	01 c0                	add    %eax,%eax
80102a73:	52                   	push   %edx
80102a74:	50                   	push   %eax
80102a75:	e8 0c ff ff ff       	call   80102986 <ioapicwrite>
80102a7a:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a80:	c1 e0 18             	shl    $0x18,%eax
80102a83:	89 c2                	mov    %eax,%edx
80102a85:	8b 45 08             	mov    0x8(%ebp),%eax
80102a88:	83 c0 08             	add    $0x8,%eax
80102a8b:	01 c0                	add    %eax,%eax
80102a8d:	83 c0 01             	add    $0x1,%eax
80102a90:	52                   	push   %edx
80102a91:	50                   	push   %eax
80102a92:	e8 ef fe ff ff       	call   80102986 <ioapicwrite>
80102a97:	83 c4 08             	add    $0x8,%esp
80102a9a:	eb 01                	jmp    80102a9d <ioapicenable+0x46>
    return;
80102a9c:	90                   	nop
}
80102a9d:	c9                   	leave  
80102a9e:	c3                   	ret    

80102a9f <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102a9f:	55                   	push   %ebp
80102aa0:	89 e5                	mov    %esp,%ebp
80102aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa5:	05 00 00 00 80       	add    $0x80000000,%eax
80102aaa:	5d                   	pop    %ebp
80102aab:	c3                   	ret    

80102aac <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102aac:	55                   	push   %ebp
80102aad:	89 e5                	mov    %esp,%ebp
80102aaf:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102ab2:	83 ec 08             	sub    $0x8,%esp
80102ab5:	68 42 94 10 80       	push   $0x80109442
80102aba:	68 20 22 11 80       	push   $0x80112220
80102abf:	e8 2b 29 00 00       	call   801053ef <initlock>
80102ac4:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ac7:	c7 05 54 22 11 80 00 	movl   $0x0,0x80112254
80102ace:	00 00 00 
  freerange(vstart, vend);
80102ad1:	83 ec 08             	sub    $0x8,%esp
80102ad4:	ff 75 0c             	push   0xc(%ebp)
80102ad7:	ff 75 08             	push   0x8(%ebp)
80102ada:	e8 2a 00 00 00       	call   80102b09 <freerange>
80102adf:	83 c4 10             	add    $0x10,%esp
}
80102ae2:	90                   	nop
80102ae3:	c9                   	leave  
80102ae4:	c3                   	ret    

80102ae5 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ae5:	55                   	push   %ebp
80102ae6:	89 e5                	mov    %esp,%ebp
80102ae8:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102aeb:	83 ec 08             	sub    $0x8,%esp
80102aee:	ff 75 0c             	push   0xc(%ebp)
80102af1:	ff 75 08             	push   0x8(%ebp)
80102af4:	e8 10 00 00 00       	call   80102b09 <freerange>
80102af9:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102afc:	c7 05 54 22 11 80 01 	movl   $0x1,0x80112254
80102b03:	00 00 00 
}
80102b06:	90                   	nop
80102b07:	c9                   	leave  
80102b08:	c3                   	ret    

80102b09 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b09:	55                   	push   %ebp
80102b0a:	89 e5                	mov    %esp,%ebp
80102b0c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b12:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b1f:	eb 15                	jmp    80102b36 <freerange+0x2d>
    kfree(p);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	ff 75 f4             	push   -0xc(%ebp)
80102b27:	e8 1b 00 00 00       	call   80102b47 <kfree>
80102b2c:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b2f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b39:	05 00 10 00 00       	add    $0x1000,%eax
80102b3e:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102b41:	73 de                	jae    80102b21 <freerange+0x18>
}
80102b43:	90                   	nop
80102b44:	90                   	nop
80102b45:	c9                   	leave  
80102b46:	c3                   	ret    

80102b47 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b47:	55                   	push   %ebp
80102b48:	89 e5                	mov    %esp,%ebp
80102b4a:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if ((uint)v % PGSIZE) {
80102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
80102b50:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b55:	85 c0                	test   %eax,%eax
80102b57:	74 10                	je     80102b69 <kfree+0x22>
    cprintf("1\n");
80102b59:	83 ec 0c             	sub    $0xc,%esp
80102b5c:	68 47 94 10 80       	push   $0x80109447
80102b61:	e8 60 d8 ff ff       	call   801003c6 <cprintf>
80102b66:	83 c4 10             	add    $0x10,%esp
  }
  if (v < end) {
80102b69:	81 7d 08 80 33 15 80 	cmpl   $0x80153380,0x8(%ebp)
80102b70:	73 10                	jae    80102b82 <kfree+0x3b>
    cprintf("2\n");
80102b72:	83 ec 0c             	sub    $0xc,%esp
80102b75:	68 4a 94 10 80       	push   $0x8010944a
80102b7a:	e8 47 d8 ff ff       	call   801003c6 <cprintf>
80102b7f:	83 c4 10             	add    $0x10,%esp
  }
  if (v2p(v) >= PHYSTOP) {
80102b82:	83 ec 0c             	sub    $0xc,%esp
80102b85:	ff 75 08             	push   0x8(%ebp)
80102b88:	e8 12 ff ff ff       	call   80102a9f <v2p>
80102b8d:	83 c4 10             	add    $0x10,%esp
80102b90:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b95:	76 10                	jbe    80102ba7 <kfree+0x60>
    cprintf("3\n");    
80102b97:	83 ec 0c             	sub    $0xc,%esp
80102b9a:	68 4d 94 10 80       	push   $0x8010944d
80102b9f:	e8 22 d8 ff ff       	call   801003c6 <cprintf>
80102ba4:	83 c4 10             	add    $0x10,%esp
  }

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80102baa:	25 ff 0f 00 00       	and    $0xfff,%eax
80102baf:	85 c0                	test   %eax,%eax
80102bb1:	75 1e                	jne    80102bd1 <kfree+0x8a>
80102bb3:	81 7d 08 80 33 15 80 	cmpl   $0x80153380,0x8(%ebp)
80102bba:	72 15                	jb     80102bd1 <kfree+0x8a>
80102bbc:	83 ec 0c             	sub    $0xc,%esp
80102bbf:	ff 75 08             	push   0x8(%ebp)
80102bc2:	e8 d8 fe ff ff       	call   80102a9f <v2p>
80102bc7:	83 c4 10             	add    $0x10,%esp
80102bca:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102bcf:	76 0d                	jbe    80102bde <kfree+0x97>
    panic("kfree");
80102bd1:	83 ec 0c             	sub    $0xc,%esp
80102bd4:	68 50 94 10 80       	push   $0x80109450
80102bd9:	e8 9d d9 ff ff       	call   8010057b <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bde:	83 ec 04             	sub    $0x4,%esp
80102be1:	68 00 10 00 00       	push   $0x1000
80102be6:	6a 01                	push   $0x1
80102be8:	ff 75 08             	push   0x8(%ebp)
80102beb:	e8 84 2a 00 00       	call   80105674 <memset>
80102bf0:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102bf3:	a1 54 22 11 80       	mov    0x80112254,%eax
80102bf8:	85 c0                	test   %eax,%eax
80102bfa:	74 10                	je     80102c0c <kfree+0xc5>
    acquire(&kmem.lock);
80102bfc:	83 ec 0c             	sub    $0xc,%esp
80102bff:	68 20 22 11 80       	push   $0x80112220
80102c04:	e8 08 28 00 00       	call   80105411 <acquire>
80102c09:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c12:	8b 15 58 22 11 80    	mov    0x80112258,%edx
80102c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c1b:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c20:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c25:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c2a:	85 c0                	test   %eax,%eax
80102c2c:	74 10                	je     80102c3e <kfree+0xf7>
    release(&kmem.lock);
80102c2e:	83 ec 0c             	sub    $0xc,%esp
80102c31:	68 20 22 11 80       	push   $0x80112220
80102c36:	e8 3d 28 00 00       	call   80105478 <release>
80102c3b:	83 c4 10             	add    $0x10,%esp
}
80102c3e:	90                   	nop
80102c3f:	c9                   	leave  
80102c40:	c3                   	ret    

80102c41 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c41:	55                   	push   %ebp
80102c42:	89 e5                	mov    %esp,%ebp
80102c44:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c47:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c4c:	85 c0                	test   %eax,%eax
80102c4e:	74 10                	je     80102c60 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c50:	83 ec 0c             	sub    $0xc,%esp
80102c53:	68 20 22 11 80       	push   $0x80112220
80102c58:	e8 b4 27 00 00       	call   80105411 <acquire>
80102c5d:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c60:	a1 58 22 11 80       	mov    0x80112258,%eax
80102c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c6c:	74 0a                	je     80102c78 <kalloc+0x37>
    kmem.freelist = r->next;
80102c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c71:	8b 00                	mov    (%eax),%eax
80102c73:	a3 58 22 11 80       	mov    %eax,0x80112258
  if(kmem.use_lock)
80102c78:	a1 54 22 11 80       	mov    0x80112254,%eax
80102c7d:	85 c0                	test   %eax,%eax
80102c7f:	74 10                	je     80102c91 <kalloc+0x50>
    release(&kmem.lock);
80102c81:	83 ec 0c             	sub    $0xc,%esp
80102c84:	68 20 22 11 80       	push   $0x80112220
80102c89:	e8 ea 27 00 00       	call   80105478 <release>
80102c8e:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c94:	c9                   	leave  
80102c95:	c3                   	ret    

80102c96 <inb>:
{
80102c96:	55                   	push   %ebp
80102c97:	89 e5                	mov    %esp,%ebp
80102c99:	83 ec 14             	sub    $0x14,%esp
80102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c9f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ca3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ca7:	89 c2                	mov    %eax,%edx
80102ca9:	ec                   	in     (%dx),%al
80102caa:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cad:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102cb1:	c9                   	leave  
80102cb2:	c3                   	ret    

80102cb3 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102cb3:	55                   	push   %ebp
80102cb4:	89 e5                	mov    %esp,%ebp
80102cb6:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102cb9:	6a 64                	push   $0x64
80102cbb:	e8 d6 ff ff ff       	call   80102c96 <inb>
80102cc0:	83 c4 04             	add    $0x4,%esp
80102cc3:	0f b6 c0             	movzbl %al,%eax
80102cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ccc:	83 e0 01             	and    $0x1,%eax
80102ccf:	85 c0                	test   %eax,%eax
80102cd1:	75 0a                	jne    80102cdd <kbdgetc+0x2a>
    return -1;
80102cd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cd8:	e9 23 01 00 00       	jmp    80102e00 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102cdd:	6a 60                	push   $0x60
80102cdf:	e8 b2 ff ff ff       	call   80102c96 <inb>
80102ce4:	83 c4 04             	add    $0x4,%esp
80102ce7:	0f b6 c0             	movzbl %al,%eax
80102cea:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ced:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cf4:	75 17                	jne    80102d0d <kbdgetc+0x5a>
    shift |= E0ESC;
80102cf6:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102cfb:	83 c8 40             	or     $0x40,%eax
80102cfe:	a3 5c 22 11 80       	mov    %eax,0x8011225c
    return 0;
80102d03:	b8 00 00 00 00       	mov    $0x0,%eax
80102d08:	e9 f3 00 00 00       	jmp    80102e00 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d10:	25 80 00 00 00       	and    $0x80,%eax
80102d15:	85 c0                	test   %eax,%eax
80102d17:	74 45                	je     80102d5e <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d19:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d1e:	83 e0 40             	and    $0x40,%eax
80102d21:	85 c0                	test   %eax,%eax
80102d23:	75 08                	jne    80102d2d <kbdgetc+0x7a>
80102d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d28:	83 e0 7f             	and    $0x7f,%eax
80102d2b:	eb 03                	jmp    80102d30 <kbdgetc+0x7d>
80102d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d33:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d36:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d3b:	0f b6 00             	movzbl (%eax),%eax
80102d3e:	83 c8 40             	or     $0x40,%eax
80102d41:	0f b6 c0             	movzbl %al,%eax
80102d44:	f7 d0                	not    %eax
80102d46:	89 c2                	mov    %eax,%edx
80102d48:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d4d:	21 d0                	and    %edx,%eax
80102d4f:	a3 5c 22 11 80       	mov    %eax,0x8011225c
    return 0;
80102d54:	b8 00 00 00 00       	mov    $0x0,%eax
80102d59:	e9 a2 00 00 00       	jmp    80102e00 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d5e:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d63:	83 e0 40             	and    $0x40,%eax
80102d66:	85 c0                	test   %eax,%eax
80102d68:	74 14                	je     80102d7e <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d6a:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d71:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d76:	83 e0 bf             	and    $0xffffffbf,%eax
80102d79:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  }

  shift |= shiftcode[data];
80102d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d81:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102d86:	0f b6 00             	movzbl (%eax),%eax
80102d89:	0f b6 d0             	movzbl %al,%edx
80102d8c:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102d91:	09 d0                	or     %edx,%eax
80102d93:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  shift ^= togglecode[data];
80102d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d9b:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102da0:	0f b6 00             	movzbl (%eax),%eax
80102da3:	0f b6 d0             	movzbl %al,%edx
80102da6:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102dab:	31 d0                	xor    %edx,%eax
80102dad:	a3 5c 22 11 80       	mov    %eax,0x8011225c
  c = charcode[shift & (CTL | SHIFT)][data];
80102db2:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102db7:	83 e0 03             	and    $0x3,%eax
80102dba:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dc4:	01 d0                	add    %edx,%eax
80102dc6:	0f b6 00             	movzbl (%eax),%eax
80102dc9:	0f b6 c0             	movzbl %al,%eax
80102dcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102dcf:	a1 5c 22 11 80       	mov    0x8011225c,%eax
80102dd4:	83 e0 08             	and    $0x8,%eax
80102dd7:	85 c0                	test   %eax,%eax
80102dd9:	74 22                	je     80102dfd <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102ddb:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ddf:	76 0c                	jbe    80102ded <kbdgetc+0x13a>
80102de1:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102de5:	77 06                	ja     80102ded <kbdgetc+0x13a>
      c += 'A' - 'a';
80102de7:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102deb:	eb 10                	jmp    80102dfd <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102ded:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102df1:	76 0a                	jbe    80102dfd <kbdgetc+0x14a>
80102df3:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102df7:	77 04                	ja     80102dfd <kbdgetc+0x14a>
      c += 'a' - 'A';
80102df9:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e00:	c9                   	leave  
80102e01:	c3                   	ret    

80102e02 <kbdintr>:

void
kbdintr(void)
{
80102e02:	55                   	push   %ebp
80102e03:	89 e5                	mov    %esp,%ebp
80102e05:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e08:	83 ec 0c             	sub    $0xc,%esp
80102e0b:	68 b3 2c 10 80       	push   $0x80102cb3
80102e10:	e8 eb d9 ff ff       	call   80100800 <consoleintr>
80102e15:	83 c4 10             	add    $0x10,%esp
}
80102e18:	90                   	nop
80102e19:	c9                   	leave  
80102e1a:	c3                   	ret    

80102e1b <inb>:
{
80102e1b:	55                   	push   %ebp
80102e1c:	89 e5                	mov    %esp,%ebp
80102e1e:	83 ec 14             	sub    $0x14,%esp
80102e21:	8b 45 08             	mov    0x8(%ebp),%eax
80102e24:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e28:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e2c:	89 c2                	mov    %eax,%edx
80102e2e:	ec                   	in     (%dx),%al
80102e2f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e32:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e36:	c9                   	leave  
80102e37:	c3                   	ret    

80102e38 <outb>:
{
80102e38:	55                   	push   %ebp
80102e39:	89 e5                	mov    %esp,%ebp
80102e3b:	83 ec 08             	sub    $0x8,%esp
80102e3e:	8b 45 08             	mov    0x8(%ebp),%eax
80102e41:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e48:	89 d0                	mov    %edx,%eax
80102e4a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e4d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e51:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e55:	ee                   	out    %al,(%dx)
}
80102e56:	90                   	nop
80102e57:	c9                   	leave  
80102e58:	c3                   	ret    

80102e59 <readeflags>:
{
80102e59:	55                   	push   %ebp
80102e5a:	89 e5                	mov    %esp,%ebp
80102e5c:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e5f:	9c                   	pushf  
80102e60:	58                   	pop    %eax
80102e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e67:	c9                   	leave  
80102e68:	c3                   	ret    

80102e69 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e69:	55                   	push   %ebp
80102e6a:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e6c:	8b 15 60 22 11 80    	mov    0x80112260,%edx
80102e72:	8b 45 08             	mov    0x8(%ebp),%eax
80102e75:	c1 e0 02             	shl    $0x2,%eax
80102e78:	01 c2                	add    %eax,%edx
80102e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e7d:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e7f:	a1 60 22 11 80       	mov    0x80112260,%eax
80102e84:	83 c0 20             	add    $0x20,%eax
80102e87:	8b 00                	mov    (%eax),%eax
}
80102e89:	90                   	nop
80102e8a:	5d                   	pop    %ebp
80102e8b:	c3                   	ret    

80102e8c <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e8c:	55                   	push   %ebp
80102e8d:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e8f:	a1 60 22 11 80       	mov    0x80112260,%eax
80102e94:	85 c0                	test   %eax,%eax
80102e96:	0f 84 0c 01 00 00    	je     80102fa8 <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e9c:	68 3f 01 00 00       	push   $0x13f
80102ea1:	6a 3c                	push   $0x3c
80102ea3:	e8 c1 ff ff ff       	call   80102e69 <lapicw>
80102ea8:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102eab:	6a 0b                	push   $0xb
80102ead:	68 f8 00 00 00       	push   $0xf8
80102eb2:	e8 b2 ff ff ff       	call   80102e69 <lapicw>
80102eb7:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102eba:	68 20 00 02 00       	push   $0x20020
80102ebf:	68 c8 00 00 00       	push   $0xc8
80102ec4:	e8 a0 ff ff ff       	call   80102e69 <lapicw>
80102ec9:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102ecc:	68 80 96 98 00       	push   $0x989680
80102ed1:	68 e0 00 00 00       	push   $0xe0
80102ed6:	e8 8e ff ff ff       	call   80102e69 <lapicw>
80102edb:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102ede:	68 00 00 01 00       	push   $0x10000
80102ee3:	68 d4 00 00 00       	push   $0xd4
80102ee8:	e8 7c ff ff ff       	call   80102e69 <lapicw>
80102eed:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102ef0:	68 00 00 01 00       	push   $0x10000
80102ef5:	68 d8 00 00 00       	push   $0xd8
80102efa:	e8 6a ff ff ff       	call   80102e69 <lapicw>
80102eff:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f02:	a1 60 22 11 80       	mov    0x80112260,%eax
80102f07:	83 c0 30             	add    $0x30,%eax
80102f0a:	8b 00                	mov    (%eax),%eax
80102f0c:	c1 e8 10             	shr    $0x10,%eax
80102f0f:	25 fc 00 00 00       	and    $0xfc,%eax
80102f14:	85 c0                	test   %eax,%eax
80102f16:	74 12                	je     80102f2a <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102f18:	68 00 00 01 00       	push   $0x10000
80102f1d:	68 d0 00 00 00       	push   $0xd0
80102f22:	e8 42 ff ff ff       	call   80102e69 <lapicw>
80102f27:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f2a:	6a 33                	push   $0x33
80102f2c:	68 dc 00 00 00       	push   $0xdc
80102f31:	e8 33 ff ff ff       	call   80102e69 <lapicw>
80102f36:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f39:	6a 00                	push   $0x0
80102f3b:	68 a0 00 00 00       	push   $0xa0
80102f40:	e8 24 ff ff ff       	call   80102e69 <lapicw>
80102f45:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f48:	6a 00                	push   $0x0
80102f4a:	68 a0 00 00 00       	push   $0xa0
80102f4f:	e8 15 ff ff ff       	call   80102e69 <lapicw>
80102f54:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f57:	6a 00                	push   $0x0
80102f59:	6a 2c                	push   $0x2c
80102f5b:	e8 09 ff ff ff       	call   80102e69 <lapicw>
80102f60:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f63:	6a 00                	push   $0x0
80102f65:	68 c4 00 00 00       	push   $0xc4
80102f6a:	e8 fa fe ff ff       	call   80102e69 <lapicw>
80102f6f:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f72:	68 00 85 08 00       	push   $0x88500
80102f77:	68 c0 00 00 00       	push   $0xc0
80102f7c:	e8 e8 fe ff ff       	call   80102e69 <lapicw>
80102f81:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f84:	90                   	nop
80102f85:	a1 60 22 11 80       	mov    0x80112260,%eax
80102f8a:	05 00 03 00 00       	add    $0x300,%eax
80102f8f:	8b 00                	mov    (%eax),%eax
80102f91:	25 00 10 00 00       	and    $0x1000,%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	75 eb                	jne    80102f85 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f9a:	6a 00                	push   $0x0
80102f9c:	6a 20                	push   $0x20
80102f9e:	e8 c6 fe ff ff       	call   80102e69 <lapicw>
80102fa3:	83 c4 08             	add    $0x8,%esp
80102fa6:	eb 01                	jmp    80102fa9 <lapicinit+0x11d>
    return;
80102fa8:	90                   	nop
}
80102fa9:	c9                   	leave  
80102faa:	c3                   	ret    

80102fab <cpunum>:

int
cpunum(void)
{
80102fab:	55                   	push   %ebp
80102fac:	89 e5                	mov    %esp,%ebp
80102fae:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102fb1:	e8 a3 fe ff ff       	call   80102e59 <readeflags>
80102fb6:	25 00 02 00 00       	and    $0x200,%eax
80102fbb:	85 c0                	test   %eax,%eax
80102fbd:	74 26                	je     80102fe5 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102fbf:	a1 64 22 11 80       	mov    0x80112264,%eax
80102fc4:	8d 50 01             	lea    0x1(%eax),%edx
80102fc7:	89 15 64 22 11 80    	mov    %edx,0x80112264
80102fcd:	85 c0                	test   %eax,%eax
80102fcf:	75 14                	jne    80102fe5 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102fd1:	8b 45 04             	mov    0x4(%ebp),%eax
80102fd4:	83 ec 08             	sub    $0x8,%esp
80102fd7:	50                   	push   %eax
80102fd8:	68 58 94 10 80       	push   $0x80109458
80102fdd:	e8 e4 d3 ff ff       	call   801003c6 <cprintf>
80102fe2:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102fe5:	a1 60 22 11 80       	mov    0x80112260,%eax
80102fea:	85 c0                	test   %eax,%eax
80102fec:	74 0f                	je     80102ffd <cpunum+0x52>
    return lapic[ID]>>24;
80102fee:	a1 60 22 11 80       	mov    0x80112260,%eax
80102ff3:	83 c0 20             	add    $0x20,%eax
80102ff6:	8b 00                	mov    (%eax),%eax
80102ff8:	c1 e8 18             	shr    $0x18,%eax
80102ffb:	eb 05                	jmp    80103002 <cpunum+0x57>
  return 0;
80102ffd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103002:	c9                   	leave  
80103003:	c3                   	ret    

80103004 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103004:	55                   	push   %ebp
80103005:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103007:	a1 60 22 11 80       	mov    0x80112260,%eax
8010300c:	85 c0                	test   %eax,%eax
8010300e:	74 0c                	je     8010301c <lapiceoi+0x18>
    lapicw(EOI, 0);
80103010:	6a 00                	push   $0x0
80103012:	6a 2c                	push   $0x2c
80103014:	e8 50 fe ff ff       	call   80102e69 <lapicw>
80103019:	83 c4 08             	add    $0x8,%esp
}
8010301c:	90                   	nop
8010301d:	c9                   	leave  
8010301e:	c3                   	ret    

8010301f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010301f:	55                   	push   %ebp
80103020:	89 e5                	mov    %esp,%ebp
}
80103022:	90                   	nop
80103023:	5d                   	pop    %ebp
80103024:	c3                   	ret    

80103025 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103025:	55                   	push   %ebp
80103026:	89 e5                	mov    %esp,%ebp
80103028:	83 ec 14             	sub    $0x14,%esp
8010302b:	8b 45 08             	mov    0x8(%ebp),%eax
8010302e:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103031:	6a 0f                	push   $0xf
80103033:	6a 70                	push   $0x70
80103035:	e8 fe fd ff ff       	call   80102e38 <outb>
8010303a:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010303d:	6a 0a                	push   $0xa
8010303f:	6a 71                	push   $0x71
80103041:	e8 f2 fd ff ff       	call   80102e38 <outb>
80103046:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103049:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103050:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103053:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103058:	8b 45 0c             	mov    0xc(%ebp),%eax
8010305b:	c1 e8 04             	shr    $0x4,%eax
8010305e:	89 c2                	mov    %eax,%edx
80103060:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103063:	83 c0 02             	add    $0x2,%eax
80103066:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103069:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010306d:	c1 e0 18             	shl    $0x18,%eax
80103070:	50                   	push   %eax
80103071:	68 c4 00 00 00       	push   $0xc4
80103076:	e8 ee fd ff ff       	call   80102e69 <lapicw>
8010307b:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010307e:	68 00 c5 00 00       	push   $0xc500
80103083:	68 c0 00 00 00       	push   $0xc0
80103088:	e8 dc fd ff ff       	call   80102e69 <lapicw>
8010308d:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103090:	68 c8 00 00 00       	push   $0xc8
80103095:	e8 85 ff ff ff       	call   8010301f <microdelay>
8010309a:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010309d:	68 00 85 00 00       	push   $0x8500
801030a2:	68 c0 00 00 00       	push   $0xc0
801030a7:	e8 bd fd ff ff       	call   80102e69 <lapicw>
801030ac:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801030af:	6a 64                	push   $0x64
801030b1:	e8 69 ff ff ff       	call   8010301f <microdelay>
801030b6:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801030c0:	eb 3d                	jmp    801030ff <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
801030c2:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030c6:	c1 e0 18             	shl    $0x18,%eax
801030c9:	50                   	push   %eax
801030ca:	68 c4 00 00 00       	push   $0xc4
801030cf:	e8 95 fd ff ff       	call   80102e69 <lapicw>
801030d4:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801030d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801030da:	c1 e8 0c             	shr    $0xc,%eax
801030dd:	80 cc 06             	or     $0x6,%ah
801030e0:	50                   	push   %eax
801030e1:	68 c0 00 00 00       	push   $0xc0
801030e6:	e8 7e fd ff ff       	call   80102e69 <lapicw>
801030eb:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030ee:	68 c8 00 00 00       	push   $0xc8
801030f3:	e8 27 ff ff ff       	call   8010301f <microdelay>
801030f8:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
801030fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030ff:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103103:	7e bd                	jle    801030c2 <lapicstartap+0x9d>
  }
}
80103105:	90                   	nop
80103106:	90                   	nop
80103107:	c9                   	leave  
80103108:	c3                   	ret    

80103109 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103109:	55                   	push   %ebp
8010310a:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010310c:	8b 45 08             	mov    0x8(%ebp),%eax
8010310f:	0f b6 c0             	movzbl %al,%eax
80103112:	50                   	push   %eax
80103113:	6a 70                	push   $0x70
80103115:	e8 1e fd ff ff       	call   80102e38 <outb>
8010311a:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010311d:	68 c8 00 00 00       	push   $0xc8
80103122:	e8 f8 fe ff ff       	call   8010301f <microdelay>
80103127:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010312a:	6a 71                	push   $0x71
8010312c:	e8 ea fc ff ff       	call   80102e1b <inb>
80103131:	83 c4 04             	add    $0x4,%esp
80103134:	0f b6 c0             	movzbl %al,%eax
}
80103137:	c9                   	leave  
80103138:	c3                   	ret    

80103139 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103139:	55                   	push   %ebp
8010313a:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010313c:	6a 00                	push   $0x0
8010313e:	e8 c6 ff ff ff       	call   80103109 <cmos_read>
80103143:	83 c4 04             	add    $0x4,%esp
80103146:	8b 55 08             	mov    0x8(%ebp),%edx
80103149:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010314b:	6a 02                	push   $0x2
8010314d:	e8 b7 ff ff ff       	call   80103109 <cmos_read>
80103152:	83 c4 04             	add    $0x4,%esp
80103155:	8b 55 08             	mov    0x8(%ebp),%edx
80103158:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
8010315b:	6a 04                	push   $0x4
8010315d:	e8 a7 ff ff ff       	call   80103109 <cmos_read>
80103162:	83 c4 04             	add    $0x4,%esp
80103165:	8b 55 08             	mov    0x8(%ebp),%edx
80103168:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
8010316b:	6a 07                	push   $0x7
8010316d:	e8 97 ff ff ff       	call   80103109 <cmos_read>
80103172:	83 c4 04             	add    $0x4,%esp
80103175:	8b 55 08             	mov    0x8(%ebp),%edx
80103178:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
8010317b:	6a 08                	push   $0x8
8010317d:	e8 87 ff ff ff       	call   80103109 <cmos_read>
80103182:	83 c4 04             	add    $0x4,%esp
80103185:	8b 55 08             	mov    0x8(%ebp),%edx
80103188:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010318b:	6a 09                	push   $0x9
8010318d:	e8 77 ff ff ff       	call   80103109 <cmos_read>
80103192:	83 c4 04             	add    $0x4,%esp
80103195:	8b 55 08             	mov    0x8(%ebp),%edx
80103198:	89 42 14             	mov    %eax,0x14(%edx)
}
8010319b:	90                   	nop
8010319c:	c9                   	leave  
8010319d:	c3                   	ret    

8010319e <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010319e:	55                   	push   %ebp
8010319f:	89 e5                	mov    %esp,%ebp
801031a1:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031a4:	6a 0b                	push   $0xb
801031a6:	e8 5e ff ff ff       	call   80103109 <cmos_read>
801031ab:	83 c4 04             	add    $0x4,%esp
801031ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031b4:	83 e0 04             	and    $0x4,%eax
801031b7:	85 c0                	test   %eax,%eax
801031b9:	0f 94 c0             	sete   %al
801031bc:	0f b6 c0             	movzbl %al,%eax
801031bf:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801031c2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031c5:	50                   	push   %eax
801031c6:	e8 6e ff ff ff       	call   80103139 <fill_rtcdate>
801031cb:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801031ce:	6a 0a                	push   $0xa
801031d0:	e8 34 ff ff ff       	call   80103109 <cmos_read>
801031d5:	83 c4 04             	add    $0x4,%esp
801031d8:	25 80 00 00 00       	and    $0x80,%eax
801031dd:	85 c0                	test   %eax,%eax
801031df:	75 27                	jne    80103208 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801031e1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031e4:	50                   	push   %eax
801031e5:	e8 4f ff ff ff       	call   80103139 <fill_rtcdate>
801031ea:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031ed:	83 ec 04             	sub    $0x4,%esp
801031f0:	6a 18                	push   $0x18
801031f2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031f5:	50                   	push   %eax
801031f6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031f9:	50                   	push   %eax
801031fa:	e8 dc 24 00 00       	call   801056db <memcmp>
801031ff:	83 c4 10             	add    $0x10,%esp
80103202:	85 c0                	test   %eax,%eax
80103204:	74 05                	je     8010320b <cmostime+0x6d>
80103206:	eb ba                	jmp    801031c2 <cmostime+0x24>
        continue;
80103208:	90                   	nop
    fill_rtcdate(&t1);
80103209:	eb b7                	jmp    801031c2 <cmostime+0x24>
      break;
8010320b:	90                   	nop
  }

  // convert
  if (bcd) {
8010320c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103210:	0f 84 b4 00 00 00    	je     801032ca <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103216:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103219:	c1 e8 04             	shr    $0x4,%eax
8010321c:	89 c2                	mov    %eax,%edx
8010321e:	89 d0                	mov    %edx,%eax
80103220:	c1 e0 02             	shl    $0x2,%eax
80103223:	01 d0                	add    %edx,%eax
80103225:	01 c0                	add    %eax,%eax
80103227:	89 c2                	mov    %eax,%edx
80103229:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010322c:	83 e0 0f             	and    $0xf,%eax
8010322f:	01 d0                	add    %edx,%eax
80103231:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103234:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103237:	c1 e8 04             	shr    $0x4,%eax
8010323a:	89 c2                	mov    %eax,%edx
8010323c:	89 d0                	mov    %edx,%eax
8010323e:	c1 e0 02             	shl    $0x2,%eax
80103241:	01 d0                	add    %edx,%eax
80103243:	01 c0                	add    %eax,%eax
80103245:	89 c2                	mov    %eax,%edx
80103247:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010324a:	83 e0 0f             	and    $0xf,%eax
8010324d:	01 d0                	add    %edx,%eax
8010324f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103252:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103255:	c1 e8 04             	shr    $0x4,%eax
80103258:	89 c2                	mov    %eax,%edx
8010325a:	89 d0                	mov    %edx,%eax
8010325c:	c1 e0 02             	shl    $0x2,%eax
8010325f:	01 d0                	add    %edx,%eax
80103261:	01 c0                	add    %eax,%eax
80103263:	89 c2                	mov    %eax,%edx
80103265:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103268:	83 e0 0f             	and    $0xf,%eax
8010326b:	01 d0                	add    %edx,%eax
8010326d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103273:	c1 e8 04             	shr    $0x4,%eax
80103276:	89 c2                	mov    %eax,%edx
80103278:	89 d0                	mov    %edx,%eax
8010327a:	c1 e0 02             	shl    $0x2,%eax
8010327d:	01 d0                	add    %edx,%eax
8010327f:	01 c0                	add    %eax,%eax
80103281:	89 c2                	mov    %eax,%edx
80103283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103286:	83 e0 0f             	and    $0xf,%eax
80103289:	01 d0                	add    %edx,%eax
8010328b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103291:	c1 e8 04             	shr    $0x4,%eax
80103294:	89 c2                	mov    %eax,%edx
80103296:	89 d0                	mov    %edx,%eax
80103298:	c1 e0 02             	shl    $0x2,%eax
8010329b:	01 d0                	add    %edx,%eax
8010329d:	01 c0                	add    %eax,%eax
8010329f:	89 c2                	mov    %eax,%edx
801032a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032a4:	83 e0 0f             	and    $0xf,%eax
801032a7:	01 d0                	add    %edx,%eax
801032a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032af:	c1 e8 04             	shr    $0x4,%eax
801032b2:	89 c2                	mov    %eax,%edx
801032b4:	89 d0                	mov    %edx,%eax
801032b6:	c1 e0 02             	shl    $0x2,%eax
801032b9:	01 d0                	add    %edx,%eax
801032bb:	01 c0                	add    %eax,%eax
801032bd:	89 c2                	mov    %eax,%edx
801032bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032c2:	83 e0 0f             	and    $0xf,%eax
801032c5:	01 d0                	add    %edx,%eax
801032c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801032ca:	8b 45 08             	mov    0x8(%ebp),%eax
801032cd:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032d0:	89 10                	mov    %edx,(%eax)
801032d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032d5:	89 50 04             	mov    %edx,0x4(%eax)
801032d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032db:	89 50 08             	mov    %edx,0x8(%eax)
801032de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032e1:	89 50 0c             	mov    %edx,0xc(%eax)
801032e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032e7:	89 50 10             	mov    %edx,0x10(%eax)
801032ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032ed:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032f0:	8b 45 08             	mov    0x8(%ebp),%eax
801032f3:	8b 40 14             	mov    0x14(%eax),%eax
801032f6:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032fc:	8b 45 08             	mov    0x8(%ebp),%eax
801032ff:	89 50 14             	mov    %edx,0x14(%eax)
}
80103302:	90                   	nop
80103303:	c9                   	leave  
80103304:	c3                   	ret    

80103305 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
80103305:	55                   	push   %ebp
80103306:	89 e5                	mov    %esp,%ebp
80103308:	83 ec 18             	sub    $0x18,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010330b:	83 ec 08             	sub    $0x8,%esp
8010330e:	68 84 94 10 80       	push   $0x80109484
80103313:	68 80 22 11 80       	push   $0x80112280
80103318:	e8 d2 20 00 00       	call   801053ef <initlock>
8010331d:	83 c4 10             	add    $0x10,%esp
  readsb(ROOTDEV, &sb);
80103320:	83 ec 08             	sub    $0x8,%esp
80103323:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103326:	50                   	push   %eax
80103327:	6a 01                	push   $0x1
80103329:	e8 64 e0 ff ff       	call   80101392 <readsb>
8010332e:	83 c4 10             	add    $0x10,%esp
  log.start = sb.size - sb.nlog;
80103331:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103334:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103337:	29 d0                	sub    %edx,%eax
80103339:	a3 b4 22 11 80       	mov    %eax,0x801122b4
  log.size = sb.nlog;
8010333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103341:	a3 b8 22 11 80       	mov    %eax,0x801122b8
  log.dev = ROOTDEV;
80103346:	c7 05 c4 22 11 80 01 	movl   $0x1,0x801122c4
8010334d:	00 00 00 
  recover_from_log();
80103350:	e8 b3 01 00 00       	call   80103508 <recover_from_log>
}
80103355:	90                   	nop
80103356:	c9                   	leave  
80103357:	c3                   	ret    

80103358 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103358:	55                   	push   %ebp
80103359:	89 e5                	mov    %esp,%ebp
8010335b:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010335e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103365:	e9 95 00 00 00       	jmp    801033ff <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010336a:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
80103370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103373:	01 d0                	add    %edx,%eax
80103375:	83 c0 01             	add    $0x1,%eax
80103378:	89 c2                	mov    %eax,%edx
8010337a:	a1 c4 22 11 80       	mov    0x801122c4,%eax
8010337f:	83 ec 08             	sub    $0x8,%esp
80103382:	52                   	push   %edx
80103383:	50                   	push   %eax
80103384:	e8 2e ce ff ff       	call   801001b7 <bread>
80103389:	83 c4 10             	add    $0x10,%esp
8010338c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010338f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103392:	83 c0 10             	add    $0x10,%eax
80103395:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
8010339c:	89 c2                	mov    %eax,%edx
8010339e:	a1 c4 22 11 80       	mov    0x801122c4,%eax
801033a3:	83 ec 08             	sub    $0x8,%esp
801033a6:	52                   	push   %edx
801033a7:	50                   	push   %eax
801033a8:	e8 0a ce ff ff       	call   801001b7 <bread>
801033ad:	83 c4 10             	add    $0x10,%esp
801033b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033b6:	8d 50 18             	lea    0x18(%eax),%edx
801033b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033bc:	83 c0 18             	add    $0x18,%eax
801033bf:	83 ec 04             	sub    $0x4,%esp
801033c2:	68 00 02 00 00       	push   $0x200
801033c7:	52                   	push   %edx
801033c8:	50                   	push   %eax
801033c9:	e8 65 23 00 00       	call   80105733 <memmove>
801033ce:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801033d1:	83 ec 0c             	sub    $0xc,%esp
801033d4:	ff 75 ec             	push   -0x14(%ebp)
801033d7:	e8 14 ce ff ff       	call   801001f0 <bwrite>
801033dc:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801033df:	83 ec 0c             	sub    $0xc,%esp
801033e2:	ff 75 f0             	push   -0x10(%ebp)
801033e5:	e8 45 ce ff ff       	call   8010022f <brelse>
801033ea:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033ed:	83 ec 0c             	sub    $0xc,%esp
801033f0:	ff 75 ec             	push   -0x14(%ebp)
801033f3:	e8 37 ce ff ff       	call   8010022f <brelse>
801033f8:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801033fb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033ff:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103404:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103407:	0f 8c 5d ff ff ff    	jl     8010336a <install_trans+0x12>
  }
}
8010340d:	90                   	nop
8010340e:	90                   	nop
8010340f:	c9                   	leave  
80103410:	c3                   	ret    

80103411 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103411:	55                   	push   %ebp
80103412:	89 e5                	mov    %esp,%ebp
80103414:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103417:	a1 b4 22 11 80       	mov    0x801122b4,%eax
8010341c:	89 c2                	mov    %eax,%edx
8010341e:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103423:	83 ec 08             	sub    $0x8,%esp
80103426:	52                   	push   %edx
80103427:	50                   	push   %eax
80103428:	e8 8a cd ff ff       	call   801001b7 <bread>
8010342d:	83 c4 10             	add    $0x10,%esp
80103430:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103433:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103436:	83 c0 18             	add    $0x18,%eax
80103439:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010343c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010343f:	8b 00                	mov    (%eax),%eax
80103441:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  for (i = 0; i < log.lh.n; i++) {
80103446:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010344d:	eb 1b                	jmp    8010346a <read_head+0x59>
    log.lh.sector[i] = lh->sector[i];
8010344f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103452:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103455:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103459:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010345c:	83 c2 10             	add    $0x10,%edx
8010345f:	89 04 95 8c 22 11 80 	mov    %eax,-0x7feedd74(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103466:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010346a:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010346f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103472:	7c db                	jl     8010344f <read_head+0x3e>
  }
  brelse(buf);
80103474:	83 ec 0c             	sub    $0xc,%esp
80103477:	ff 75 f0             	push   -0x10(%ebp)
8010347a:	e8 b0 cd ff ff       	call   8010022f <brelse>
8010347f:	83 c4 10             	add    $0x10,%esp
}
80103482:	90                   	nop
80103483:	c9                   	leave  
80103484:	c3                   	ret    

80103485 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103485:	55                   	push   %ebp
80103486:	89 e5                	mov    %esp,%ebp
80103488:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010348b:	a1 b4 22 11 80       	mov    0x801122b4,%eax
80103490:	89 c2                	mov    %eax,%edx
80103492:	a1 c4 22 11 80       	mov    0x801122c4,%eax
80103497:	83 ec 08             	sub    $0x8,%esp
8010349a:	52                   	push   %edx
8010349b:	50                   	push   %eax
8010349c:	e8 16 cd ff ff       	call   801001b7 <bread>
801034a1:	83 c4 10             	add    $0x10,%esp
801034a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034aa:	83 c0 18             	add    $0x18,%eax
801034ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034b0:	8b 15 c8 22 11 80    	mov    0x801122c8,%edx
801034b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034b9:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801034c2:	eb 1b                	jmp    801034df <write_head+0x5a>
    hb->sector[i] = log.lh.sector[i];
801034c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034c7:	83 c0 10             	add    $0x10,%eax
801034ca:	8b 0c 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%ecx
801034d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801034d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034d7:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034df:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801034e4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801034e7:	7c db                	jl     801034c4 <write_head+0x3f>
  }
  bwrite(buf);
801034e9:	83 ec 0c             	sub    $0xc,%esp
801034ec:	ff 75 f0             	push   -0x10(%ebp)
801034ef:	e8 fc cc ff ff       	call   801001f0 <bwrite>
801034f4:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034f7:	83 ec 0c             	sub    $0xc,%esp
801034fa:	ff 75 f0             	push   -0x10(%ebp)
801034fd:	e8 2d cd ff ff       	call   8010022f <brelse>
80103502:	83 c4 10             	add    $0x10,%esp
}
80103505:	90                   	nop
80103506:	c9                   	leave  
80103507:	c3                   	ret    

80103508 <recover_from_log>:

static void
recover_from_log(void)
{
80103508:	55                   	push   %ebp
80103509:	89 e5                	mov    %esp,%ebp
8010350b:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010350e:	e8 fe fe ff ff       	call   80103411 <read_head>
  install_trans(); // if committed, copy from log to disk
80103513:	e8 40 fe ff ff       	call   80103358 <install_trans>
  log.lh.n = 0;
80103518:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
8010351f:	00 00 00 
  write_head(); // clear the log
80103522:	e8 5e ff ff ff       	call   80103485 <write_head>
}
80103527:	90                   	nop
80103528:	c9                   	leave  
80103529:	c3                   	ret    

8010352a <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010352a:	55                   	push   %ebp
8010352b:	89 e5                	mov    %esp,%ebp
8010352d:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	68 80 22 11 80       	push   $0x80112280
80103538:	e8 d4 1e 00 00       	call   80105411 <acquire>
8010353d:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103540:	a1 c0 22 11 80       	mov    0x801122c0,%eax
80103545:	85 c0                	test   %eax,%eax
80103547:	74 17                	je     80103560 <begin_op+0x36>
      sleep(&log, &log.lock);
80103549:	83 ec 08             	sub    $0x8,%esp
8010354c:	68 80 22 11 80       	push   $0x80112280
80103551:	68 80 22 11 80       	push   $0x80112280
80103556:	e8 0c 18 00 00       	call   80104d67 <sleep>
8010355b:	83 c4 10             	add    $0x10,%esp
8010355e:	eb e0                	jmp    80103540 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103560:	8b 0d c8 22 11 80    	mov    0x801122c8,%ecx
80103566:	a1 bc 22 11 80       	mov    0x801122bc,%eax
8010356b:	8d 50 01             	lea    0x1(%eax),%edx
8010356e:	89 d0                	mov    %edx,%eax
80103570:	c1 e0 02             	shl    $0x2,%eax
80103573:	01 d0                	add    %edx,%eax
80103575:	01 c0                	add    %eax,%eax
80103577:	01 c8                	add    %ecx,%eax
80103579:	83 f8 1e             	cmp    $0x1e,%eax
8010357c:	7e 17                	jle    80103595 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010357e:	83 ec 08             	sub    $0x8,%esp
80103581:	68 80 22 11 80       	push   $0x80112280
80103586:	68 80 22 11 80       	push   $0x80112280
8010358b:	e8 d7 17 00 00       	call   80104d67 <sleep>
80103590:	83 c4 10             	add    $0x10,%esp
80103593:	eb ab                	jmp    80103540 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103595:	a1 bc 22 11 80       	mov    0x801122bc,%eax
8010359a:	83 c0 01             	add    $0x1,%eax
8010359d:	a3 bc 22 11 80       	mov    %eax,0x801122bc
      release(&log.lock);
801035a2:	83 ec 0c             	sub    $0xc,%esp
801035a5:	68 80 22 11 80       	push   $0x80112280
801035aa:	e8 c9 1e 00 00       	call   80105478 <release>
801035af:	83 c4 10             	add    $0x10,%esp
      break;
801035b2:	90                   	nop
    }
  }
}
801035b3:	90                   	nop
801035b4:	c9                   	leave  
801035b5:	c3                   	ret    

801035b6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035b6:	55                   	push   %ebp
801035b7:	89 e5                	mov    %esp,%ebp
801035b9:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801035bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801035c3:	83 ec 0c             	sub    $0xc,%esp
801035c6:	68 80 22 11 80       	push   $0x80112280
801035cb:	e8 41 1e 00 00       	call   80105411 <acquire>
801035d0:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035d3:	a1 bc 22 11 80       	mov    0x801122bc,%eax
801035d8:	83 e8 01             	sub    $0x1,%eax
801035db:	a3 bc 22 11 80       	mov    %eax,0x801122bc
  if(log.committing)
801035e0:	a1 c0 22 11 80       	mov    0x801122c0,%eax
801035e5:	85 c0                	test   %eax,%eax
801035e7:	74 0d                	je     801035f6 <end_op+0x40>
    panic("log.committing");
801035e9:	83 ec 0c             	sub    $0xc,%esp
801035ec:	68 88 94 10 80       	push   $0x80109488
801035f1:	e8 85 cf ff ff       	call   8010057b <panic>
  if(log.outstanding == 0){
801035f6:	a1 bc 22 11 80       	mov    0x801122bc,%eax
801035fb:	85 c0                	test   %eax,%eax
801035fd:	75 13                	jne    80103612 <end_op+0x5c>
    do_commit = 1;
801035ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103606:	c7 05 c0 22 11 80 01 	movl   $0x1,0x801122c0
8010360d:	00 00 00 
80103610:	eb 10                	jmp    80103622 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103612:	83 ec 0c             	sub    $0xc,%esp
80103615:	68 80 22 11 80       	push   $0x80112280
8010361a:	e8 37 18 00 00       	call   80104e56 <wakeup>
8010361f:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103622:	83 ec 0c             	sub    $0xc,%esp
80103625:	68 80 22 11 80       	push   $0x80112280
8010362a:	e8 49 1e 00 00       	call   80105478 <release>
8010362f:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103636:	74 3f                	je     80103677 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103638:	e8 f6 00 00 00       	call   80103733 <commit>
    acquire(&log.lock);
8010363d:	83 ec 0c             	sub    $0xc,%esp
80103640:	68 80 22 11 80       	push   $0x80112280
80103645:	e8 c7 1d 00 00       	call   80105411 <acquire>
8010364a:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010364d:	c7 05 c0 22 11 80 00 	movl   $0x0,0x801122c0
80103654:	00 00 00 
    wakeup(&log);
80103657:	83 ec 0c             	sub    $0xc,%esp
8010365a:	68 80 22 11 80       	push   $0x80112280
8010365f:	e8 f2 17 00 00       	call   80104e56 <wakeup>
80103664:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103667:	83 ec 0c             	sub    $0xc,%esp
8010366a:	68 80 22 11 80       	push   $0x80112280
8010366f:	e8 04 1e 00 00       	call   80105478 <release>
80103674:	83 c4 10             	add    $0x10,%esp
  }
}
80103677:	90                   	nop
80103678:	c9                   	leave  
80103679:	c3                   	ret    

8010367a <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010367a:	55                   	push   %ebp
8010367b:	89 e5                	mov    %esp,%ebp
8010367d:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103680:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103687:	e9 95 00 00 00       	jmp    80103721 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010368c:	8b 15 b4 22 11 80    	mov    0x801122b4,%edx
80103692:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103695:	01 d0                	add    %edx,%eax
80103697:	83 c0 01             	add    $0x1,%eax
8010369a:	89 c2                	mov    %eax,%edx
8010369c:	a1 c4 22 11 80       	mov    0x801122c4,%eax
801036a1:	83 ec 08             	sub    $0x8,%esp
801036a4:	52                   	push   %edx
801036a5:	50                   	push   %eax
801036a6:	e8 0c cb ff ff       	call   801001b7 <bread>
801036ab:	83 c4 10             	add    $0x10,%esp
801036ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
801036b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b4:	83 c0 10             	add    $0x10,%eax
801036b7:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
801036be:	89 c2                	mov    %eax,%edx
801036c0:	a1 c4 22 11 80       	mov    0x801122c4,%eax
801036c5:	83 ec 08             	sub    $0x8,%esp
801036c8:	52                   	push   %edx
801036c9:	50                   	push   %eax
801036ca:	e8 e8 ca ff ff       	call   801001b7 <bread>
801036cf:	83 c4 10             	add    $0x10,%esp
801036d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801036d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036d8:	8d 50 18             	lea    0x18(%eax),%edx
801036db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036de:	83 c0 18             	add    $0x18,%eax
801036e1:	83 ec 04             	sub    $0x4,%esp
801036e4:	68 00 02 00 00       	push   $0x200
801036e9:	52                   	push   %edx
801036ea:	50                   	push   %eax
801036eb:	e8 43 20 00 00       	call   80105733 <memmove>
801036f0:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036f3:	83 ec 0c             	sub    $0xc,%esp
801036f6:	ff 75 f0             	push   -0x10(%ebp)
801036f9:	e8 f2 ca ff ff       	call   801001f0 <bwrite>
801036fe:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103701:	83 ec 0c             	sub    $0xc,%esp
80103704:	ff 75 ec             	push   -0x14(%ebp)
80103707:	e8 23 cb ff ff       	call   8010022f <brelse>
8010370c:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010370f:	83 ec 0c             	sub    $0xc,%esp
80103712:	ff 75 f0             	push   -0x10(%ebp)
80103715:	e8 15 cb ff ff       	call   8010022f <brelse>
8010371a:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010371d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103721:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103726:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103729:	0f 8c 5d ff ff ff    	jl     8010368c <write_log+0x12>
  }
}
8010372f:	90                   	nop
80103730:	90                   	nop
80103731:	c9                   	leave  
80103732:	c3                   	ret    

80103733 <commit>:

static void
commit()
{
80103733:	55                   	push   %ebp
80103734:	89 e5                	mov    %esp,%ebp
80103736:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103739:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010373e:	85 c0                	test   %eax,%eax
80103740:	7e 1e                	jle    80103760 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103742:	e8 33 ff ff ff       	call   8010367a <write_log>
    write_head();    // Write header to disk -- the real commit
80103747:	e8 39 fd ff ff       	call   80103485 <write_head>
    install_trans(); // Now install writes to home locations
8010374c:	e8 07 fc ff ff       	call   80103358 <install_trans>
    log.lh.n = 0; 
80103751:	c7 05 c8 22 11 80 00 	movl   $0x0,0x801122c8
80103758:	00 00 00 
    write_head();    // Erase the transaction from the log
8010375b:	e8 25 fd ff ff       	call   80103485 <write_head>
  }
}
80103760:	90                   	nop
80103761:	c9                   	leave  
80103762:	c3                   	ret    

80103763 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103763:	55                   	push   %ebp
80103764:	89 e5                	mov    %esp,%ebp
80103766:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103769:	a1 c8 22 11 80       	mov    0x801122c8,%eax
8010376e:	83 f8 1d             	cmp    $0x1d,%eax
80103771:	7f 12                	jg     80103785 <log_write+0x22>
80103773:	a1 c8 22 11 80       	mov    0x801122c8,%eax
80103778:	8b 15 b8 22 11 80    	mov    0x801122b8,%edx
8010377e:	83 ea 01             	sub    $0x1,%edx
80103781:	39 d0                	cmp    %edx,%eax
80103783:	7c 0d                	jl     80103792 <log_write+0x2f>
    panic("too big a transaction");
80103785:	83 ec 0c             	sub    $0xc,%esp
80103788:	68 97 94 10 80       	push   $0x80109497
8010378d:	e8 e9 cd ff ff       	call   8010057b <panic>
  if (log.outstanding < 1)
80103792:	a1 bc 22 11 80       	mov    0x801122bc,%eax
80103797:	85 c0                	test   %eax,%eax
80103799:	7f 0d                	jg     801037a8 <log_write+0x45>
    panic("log_write outside of trans");
8010379b:	83 ec 0c             	sub    $0xc,%esp
8010379e:	68 ad 94 10 80       	push   $0x801094ad
801037a3:	e8 d3 cd ff ff       	call   8010057b <panic>

  for (i = 0; i < log.lh.n; i++) {
801037a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037af:	eb 1d                	jmp    801037ce <log_write+0x6b>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
801037b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037b4:	83 c0 10             	add    $0x10,%eax
801037b7:	8b 04 85 8c 22 11 80 	mov    -0x7feedd74(,%eax,4),%eax
801037be:	89 c2                	mov    %eax,%edx
801037c0:	8b 45 08             	mov    0x8(%ebp),%eax
801037c3:	8b 40 08             	mov    0x8(%eax),%eax
801037c6:	39 c2                	cmp    %eax,%edx
801037c8:	74 10                	je     801037da <log_write+0x77>
  for (i = 0; i < log.lh.n; i++) {
801037ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037ce:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801037d3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801037d6:	7c d9                	jl     801037b1 <log_write+0x4e>
801037d8:	eb 01                	jmp    801037db <log_write+0x78>
      break;
801037da:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
801037db:	8b 45 08             	mov    0x8(%ebp),%eax
801037de:	8b 40 08             	mov    0x8(%eax),%eax
801037e1:	89 c2                	mov    %eax,%edx
801037e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037e6:	83 c0 10             	add    $0x10,%eax
801037e9:	89 14 85 8c 22 11 80 	mov    %edx,-0x7feedd74(,%eax,4)
  if (i == log.lh.n)
801037f0:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801037f5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801037f8:	75 0d                	jne    80103807 <log_write+0xa4>
    log.lh.n++;
801037fa:	a1 c8 22 11 80       	mov    0x801122c8,%eax
801037ff:	83 c0 01             	add    $0x1,%eax
80103802:	a3 c8 22 11 80       	mov    %eax,0x801122c8
  b->flags |= B_DIRTY; // prevent eviction
80103807:	8b 45 08             	mov    0x8(%ebp),%eax
8010380a:	8b 00                	mov    (%eax),%eax
8010380c:	83 c8 04             	or     $0x4,%eax
8010380f:	89 c2                	mov    %eax,%edx
80103811:	8b 45 08             	mov    0x8(%ebp),%eax
80103814:	89 10                	mov    %edx,(%eax)
}
80103816:	90                   	nop
80103817:	c9                   	leave  
80103818:	c3                   	ret    

80103819 <v2p>:
80103819:	55                   	push   %ebp
8010381a:	89 e5                	mov    %esp,%ebp
8010381c:	8b 45 08             	mov    0x8(%ebp),%eax
8010381f:	05 00 00 00 80       	add    $0x80000000,%eax
80103824:	5d                   	pop    %ebp
80103825:	c3                   	ret    

80103826 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103826:	55                   	push   %ebp
80103827:	89 e5                	mov    %esp,%ebp
80103829:	8b 45 08             	mov    0x8(%ebp),%eax
8010382c:	05 00 00 00 80       	add    $0x80000000,%eax
80103831:	5d                   	pop    %ebp
80103832:	c3                   	ret    

80103833 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103833:	55                   	push   %ebp
80103834:	89 e5                	mov    %esp,%ebp
80103836:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103839:	8b 55 08             	mov    0x8(%ebp),%edx
8010383c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010383f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103842:	f0 87 02             	lock xchg %eax,(%edx)
80103845:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103848:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010384b:	c9                   	leave  
8010384c:	c3                   	ret    

8010384d <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010384d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103851:	83 e4 f0             	and    $0xfffffff0,%esp
80103854:	ff 71 fc             	push   -0x4(%ecx)
80103857:	55                   	push   %ebp
80103858:	89 e5                	mov    %esp,%ebp
8010385a:	51                   	push   %ecx
8010385b:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010385e:	83 ec 08             	sub    $0x8,%esp
80103861:	68 00 00 40 80       	push   $0x80400000
80103866:	68 80 33 15 80       	push   $0x80153380
8010386b:	e8 3c f2 ff ff       	call   80102aac <kinit1>
80103870:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103873:	e8 0a 4d 00 00       	call   80108582 <kvmalloc>
  mpinit();        // collect info about this machine
80103878:	e8 44 04 00 00       	call   80103cc1 <mpinit>
  lapicinit();
8010387d:	e8 0a f6 ff ff       	call   80102e8c <lapicinit>
  seginit();       // set up segments
80103882:	e8 a4 46 00 00       	call   80107f2b <seginit>
  cprintf("\ncpu%d: welcome to xv6\nstarting xv6\n\n", cpu->id);
80103887:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010388d:	0f b6 00             	movzbl (%eax),%eax
80103890:	0f b6 c0             	movzbl %al,%eax
80103893:	83 ec 08             	sub    $0x8,%esp
80103896:	50                   	push   %eax
80103897:	68 c8 94 10 80       	push   $0x801094c8
8010389c:	e8 25 cb ff ff       	call   801003c6 <cprintf>
801038a1:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
801038a4:	e8 94 06 00 00       	call   80103f3d <picinit>
  ioapicinit();    // another interrupt controller
801038a9:	e8 f3 f0 ff ff       	call   801029a1 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801038ae:	e8 5f d2 ff ff       	call   80100b12 <consoleinit>
  uartinit();      // serial port
801038b3:	e8 be 39 00 00       	call   80107276 <uartinit>
  pinit();         // process table
801038b8:	e8 7d 0b 00 00       	call   8010443a <pinit>
  sharetableinit();    // initialize the share table
801038bd:	e8 e0 54 00 00       	call   80108da2 <sharetableinit>
  tvinit();        // trap vectors
801038c2:	e8 ed 33 00 00       	call   80106cb4 <tvinit>
  binit();         // buffer cache
801038c7:	e8 68 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038cc:	e8 b2 d6 ff ff       	call   80100f83 <fileinit>
  iinit();         // inode cache
801038d1:	e8 8b dd ff ff       	call   80101661 <iinit>
  ideinit();       // disk
801038d6:	e8 0a ed ff ff       	call   801025e5 <ideinit>
  if(!ismp)
801038db:	a1 40 29 11 80       	mov    0x80112940,%eax
801038e0:	85 c0                	test   %eax,%eax
801038e2:	75 05                	jne    801038e9 <main+0x9c>
    timerinit();   // uniprocessor timer
801038e4:	e8 28 33 00 00       	call   80106c11 <timerinit>
  startothers();   // start other processors
801038e9:	e8 7f 00 00 00       	call   8010396d <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038ee:	83 ec 08             	sub    $0x8,%esp
801038f1:	68 00 00 00 8e       	push   $0x8e000000
801038f6:	68 00 00 40 80       	push   $0x80400000
801038fb:	e8 e5 f1 ff ff       	call   80102ae5 <kinit2>
80103900:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103903:	e8 a5 0c 00 00       	call   801045ad <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103908:	e8 1a 00 00 00       	call   80103927 <mpmain>

8010390d <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010390d:	55                   	push   %ebp
8010390e:	89 e5                	mov    %esp,%ebp
80103910:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103913:	e8 82 4c 00 00       	call   8010859a <switchkvm>
  seginit();
80103918:	e8 0e 46 00 00       	call   80107f2b <seginit>
  lapicinit();
8010391d:	e8 6a f5 ff ff       	call   80102e8c <lapicinit>
  mpmain();
80103922:	e8 00 00 00 00       	call   80103927 <mpmain>

80103927 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103927:	55                   	push   %ebp
80103928:	89 e5                	mov    %esp,%ebp
8010392a:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010392d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103933:	0f b6 00             	movzbl (%eax),%eax
80103936:	0f b6 c0             	movzbl %al,%eax
80103939:	83 ec 08             	sub    $0x8,%esp
8010393c:	50                   	push   %eax
8010393d:	68 ee 94 10 80       	push   $0x801094ee
80103942:	e8 7f ca ff ff       	call   801003c6 <cprintf>
80103947:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010394a:	e8 db 34 00 00       	call   80106e2a <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
8010394f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103955:	05 a8 00 00 00       	add    $0xa8,%eax
8010395a:	83 ec 08             	sub    $0x8,%esp
8010395d:	6a 01                	push   $0x1
8010395f:	50                   	push   %eax
80103960:	e8 ce fe ff ff       	call   80103833 <xchg>
80103965:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103968:	e8 2a 12 00 00       	call   80104b97 <scheduler>

8010396d <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010396d:	55                   	push   %ebp
8010396e:	89 e5                	mov    %esp,%ebp
80103970:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103973:	68 00 70 00 00       	push   $0x7000
80103978:	e8 a9 fe ff ff       	call   80103826 <p2v>
8010397d:	83 c4 04             	add    $0x4,%esp
80103980:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103983:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103988:	83 ec 04             	sub    $0x4,%esp
8010398b:	50                   	push   %eax
8010398c:	68 2c c5 10 80       	push   $0x8010c52c
80103991:	ff 75 f0             	push   -0x10(%ebp)
80103994:	e8 9a 1d 00 00       	call   80105733 <memmove>
80103999:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
8010399c:	c7 45 f4 60 23 11 80 	movl   $0x80112360,-0xc(%ebp)
801039a3:	e9 8e 00 00 00       	jmp    80103a36 <startothers+0xc9>
    if(c == cpus+cpunum())  // We've started already.
801039a8:	e8 fe f5 ff ff       	call   80102fab <cpunum>
801039ad:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801039b3:	05 60 23 11 80       	add    $0x80112360,%eax
801039b8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801039bb:	74 71                	je     80103a2e <startothers+0xc1>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801039bd:	e8 7f f2 ff ff       	call   80102c41 <kalloc>
801039c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801039c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039c8:	83 e8 04             	sub    $0x4,%eax
801039cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801039ce:	81 c2 00 10 00 00    	add    $0x1000,%edx
801039d4:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801039d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039d9:	83 e8 08             	sub    $0x8,%eax
801039dc:	c7 00 0d 39 10 80    	movl   $0x8010390d,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801039e2:	83 ec 0c             	sub    $0xc,%esp
801039e5:	68 00 b0 10 80       	push   $0x8010b000
801039ea:	e8 2a fe ff ff       	call   80103819 <v2p>
801039ef:	83 c4 10             	add    $0x10,%esp
801039f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801039f5:	83 ea 0c             	sub    $0xc,%edx
801039f8:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->id, v2p(code));
801039fa:	83 ec 0c             	sub    $0xc,%esp
801039fd:	ff 75 f0             	push   -0x10(%ebp)
80103a00:	e8 14 fe ff ff       	call   80103819 <v2p>
80103a05:	83 c4 10             	add    $0x10,%esp
80103a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a0b:	0f b6 12             	movzbl (%edx),%edx
80103a0e:	0f b6 d2             	movzbl %dl,%edx
80103a11:	83 ec 08             	sub    $0x8,%esp
80103a14:	50                   	push   %eax
80103a15:	52                   	push   %edx
80103a16:	e8 0a f6 ff ff       	call   80103025 <lapicstartap>
80103a1b:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a1e:	90                   	nop
80103a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a22:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a28:	85 c0                	test   %eax,%eax
80103a2a:	74 f3                	je     80103a1f <startothers+0xb2>
80103a2c:	eb 01                	jmp    80103a2f <startothers+0xc2>
      continue;
80103a2e:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103a2f:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a36:	a1 44 29 11 80       	mov    0x80112944,%eax
80103a3b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a41:	05 60 23 11 80       	add    $0x80112360,%eax
80103a46:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a49:	0f 82 59 ff ff ff    	jb     801039a8 <startothers+0x3b>
      ;
  }
}
80103a4f:	90                   	nop
80103a50:	90                   	nop
80103a51:	c9                   	leave  
80103a52:	c3                   	ret    

80103a53 <p2v>:
80103a53:	55                   	push   %ebp
80103a54:	89 e5                	mov    %esp,%ebp
80103a56:	8b 45 08             	mov    0x8(%ebp),%eax
80103a59:	05 00 00 00 80       	add    $0x80000000,%eax
80103a5e:	5d                   	pop    %ebp
80103a5f:	c3                   	ret    

80103a60 <inb>:
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 14             	sub    $0x14,%esp
80103a66:	8b 45 08             	mov    0x8(%ebp),%eax
80103a69:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a6d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a71:	89 c2                	mov    %eax,%edx
80103a73:	ec                   	in     (%dx),%al
80103a74:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a77:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a7b:	c9                   	leave  
80103a7c:	c3                   	ret    

80103a7d <outb>:
{
80103a7d:	55                   	push   %ebp
80103a7e:	89 e5                	mov    %esp,%ebp
80103a80:	83 ec 08             	sub    $0x8,%esp
80103a83:	8b 45 08             	mov    0x8(%ebp),%eax
80103a86:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a89:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103a8d:	89 d0                	mov    %edx,%eax
80103a8f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a92:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a96:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a9a:	ee                   	out    %al,(%dx)
}
80103a9b:	90                   	nop
80103a9c:	c9                   	leave  
80103a9d:	c3                   	ret    

80103a9e <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a9e:	55                   	push   %ebp
80103a9f:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103aa1:	a1 4c 29 11 80       	mov    0x8011294c,%eax
80103aa6:	2d 60 23 11 80       	sub    $0x80112360,%eax
80103aab:	c1 f8 02             	sar    $0x2,%eax
80103aae:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103ab4:	5d                   	pop    %ebp
80103ab5:	c3                   	ret    

80103ab6 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103ab6:	55                   	push   %ebp
80103ab7:	89 e5                	mov    %esp,%ebp
80103ab9:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103abc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ac3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103aca:	eb 15                	jmp    80103ae1 <sum+0x2b>
    sum += addr[i];
80103acc:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103acf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ad2:	01 d0                	add    %edx,%eax
80103ad4:	0f b6 00             	movzbl (%eax),%eax
80103ad7:	0f b6 c0             	movzbl %al,%eax
80103ada:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103add:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103ae4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103ae7:	7c e3                	jl     80103acc <sum+0x16>
  return sum;
80103ae9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103aec:	c9                   	leave  
80103aed:	c3                   	ret    

80103aee <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103aee:	55                   	push   %ebp
80103aef:	89 e5                	mov    %esp,%ebp
80103af1:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103af4:	ff 75 08             	push   0x8(%ebp)
80103af7:	e8 57 ff ff ff       	call   80103a53 <p2v>
80103afc:	83 c4 04             	add    $0x4,%esp
80103aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b02:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b08:	01 d0                	add    %edx,%eax
80103b0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b13:	eb 36                	jmp    80103b4b <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b15:	83 ec 04             	sub    $0x4,%esp
80103b18:	6a 04                	push   $0x4
80103b1a:	68 00 95 10 80       	push   $0x80109500
80103b1f:	ff 75 f4             	push   -0xc(%ebp)
80103b22:	e8 b4 1b 00 00       	call   801056db <memcmp>
80103b27:	83 c4 10             	add    $0x10,%esp
80103b2a:	85 c0                	test   %eax,%eax
80103b2c:	75 19                	jne    80103b47 <mpsearch1+0x59>
80103b2e:	83 ec 08             	sub    $0x8,%esp
80103b31:	6a 10                	push   $0x10
80103b33:	ff 75 f4             	push   -0xc(%ebp)
80103b36:	e8 7b ff ff ff       	call   80103ab6 <sum>
80103b3b:	83 c4 10             	add    $0x10,%esp
80103b3e:	84 c0                	test   %al,%al
80103b40:	75 05                	jne    80103b47 <mpsearch1+0x59>
      return (struct mp*)p;
80103b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b45:	eb 11                	jmp    80103b58 <mpsearch1+0x6a>
  for(p = addr; p < e; p += sizeof(struct mp))
80103b47:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b51:	72 c2                	jb     80103b15 <mpsearch1+0x27>
  return 0;
80103b53:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b58:	c9                   	leave  
80103b59:	c3                   	ret    

80103b5a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b5a:	55                   	push   %ebp
80103b5b:	89 e5                	mov    %esp,%ebp
80103b5d:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b60:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b6a:	83 c0 0f             	add    $0xf,%eax
80103b6d:	0f b6 00             	movzbl (%eax),%eax
80103b70:	0f b6 c0             	movzbl %al,%eax
80103b73:	c1 e0 08             	shl    $0x8,%eax
80103b76:	89 c2                	mov    %eax,%edx
80103b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b7b:	83 c0 0e             	add    $0xe,%eax
80103b7e:	0f b6 00             	movzbl (%eax),%eax
80103b81:	0f b6 c0             	movzbl %al,%eax
80103b84:	09 d0                	or     %edx,%eax
80103b86:	c1 e0 04             	shl    $0x4,%eax
80103b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b90:	74 21                	je     80103bb3 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b92:	83 ec 08             	sub    $0x8,%esp
80103b95:	68 00 04 00 00       	push   $0x400
80103b9a:	ff 75 f0             	push   -0x10(%ebp)
80103b9d:	e8 4c ff ff ff       	call   80103aee <mpsearch1>
80103ba2:	83 c4 10             	add    $0x10,%esp
80103ba5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ba8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bac:	74 51                	je     80103bff <mpsearch+0xa5>
      return mp;
80103bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bb1:	eb 61                	jmp    80103c14 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb6:	83 c0 14             	add    $0x14,%eax
80103bb9:	0f b6 00             	movzbl (%eax),%eax
80103bbc:	0f b6 c0             	movzbl %al,%eax
80103bbf:	c1 e0 08             	shl    $0x8,%eax
80103bc2:	89 c2                	mov    %eax,%edx
80103bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bc7:	83 c0 13             	add    $0x13,%eax
80103bca:	0f b6 00             	movzbl (%eax),%eax
80103bcd:	0f b6 c0             	movzbl %al,%eax
80103bd0:	09 d0                	or     %edx,%eax
80103bd2:	c1 e0 0a             	shl    $0xa,%eax
80103bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bdb:	2d 00 04 00 00       	sub    $0x400,%eax
80103be0:	83 ec 08             	sub    $0x8,%esp
80103be3:	68 00 04 00 00       	push   $0x400
80103be8:	50                   	push   %eax
80103be9:	e8 00 ff ff ff       	call   80103aee <mpsearch1>
80103bee:	83 c4 10             	add    $0x10,%esp
80103bf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bf4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bf8:	74 05                	je     80103bff <mpsearch+0xa5>
      return mp;
80103bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bfd:	eb 15                	jmp    80103c14 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103bff:	83 ec 08             	sub    $0x8,%esp
80103c02:	68 00 00 01 00       	push   $0x10000
80103c07:	68 00 00 0f 00       	push   $0xf0000
80103c0c:	e8 dd fe ff ff       	call   80103aee <mpsearch1>
80103c11:	83 c4 10             	add    $0x10,%esp
}
80103c14:	c9                   	leave  
80103c15:	c3                   	ret    

80103c16 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c16:	55                   	push   %ebp
80103c17:	89 e5                	mov    %esp,%ebp
80103c19:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c1c:	e8 39 ff ff ff       	call   80103b5a <mpsearch>
80103c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c28:	74 0a                	je     80103c34 <mpconfig+0x1e>
80103c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2d:	8b 40 04             	mov    0x4(%eax),%eax
80103c30:	85 c0                	test   %eax,%eax
80103c32:	75 0a                	jne    80103c3e <mpconfig+0x28>
    return 0;
80103c34:	b8 00 00 00 00       	mov    $0x0,%eax
80103c39:	e9 81 00 00 00       	jmp    80103cbf <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c41:	8b 40 04             	mov    0x4(%eax),%eax
80103c44:	83 ec 0c             	sub    $0xc,%esp
80103c47:	50                   	push   %eax
80103c48:	e8 06 fe ff ff       	call   80103a53 <p2v>
80103c4d:	83 c4 10             	add    $0x10,%esp
80103c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c53:	83 ec 04             	sub    $0x4,%esp
80103c56:	6a 04                	push   $0x4
80103c58:	68 05 95 10 80       	push   $0x80109505
80103c5d:	ff 75 f0             	push   -0x10(%ebp)
80103c60:	e8 76 1a 00 00       	call   801056db <memcmp>
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	85 c0                	test   %eax,%eax
80103c6a:	74 07                	je     80103c73 <mpconfig+0x5d>
    return 0;
80103c6c:	b8 00 00 00 00       	mov    $0x0,%eax
80103c71:	eb 4c                	jmp    80103cbf <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c76:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c7a:	3c 01                	cmp    $0x1,%al
80103c7c:	74 12                	je     80103c90 <mpconfig+0x7a>
80103c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c81:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c85:	3c 04                	cmp    $0x4,%al
80103c87:	74 07                	je     80103c90 <mpconfig+0x7a>
    return 0;
80103c89:	b8 00 00 00 00       	mov    $0x0,%eax
80103c8e:	eb 2f                	jmp    80103cbf <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c93:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c97:	0f b7 c0             	movzwl %ax,%eax
80103c9a:	83 ec 08             	sub    $0x8,%esp
80103c9d:	50                   	push   %eax
80103c9e:	ff 75 f0             	push   -0x10(%ebp)
80103ca1:	e8 10 fe ff ff       	call   80103ab6 <sum>
80103ca6:	83 c4 10             	add    $0x10,%esp
80103ca9:	84 c0                	test   %al,%al
80103cab:	74 07                	je     80103cb4 <mpconfig+0x9e>
    return 0;
80103cad:	b8 00 00 00 00       	mov    $0x0,%eax
80103cb2:	eb 0b                	jmp    80103cbf <mpconfig+0xa9>
  *pmp = mp;
80103cb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103cb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cba:	89 10                	mov    %edx,(%eax)
  return conf;
80103cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103cbf:	c9                   	leave  
80103cc0:	c3                   	ret    

80103cc1 <mpinit>:

void
mpinit(void)
{
80103cc1:	55                   	push   %ebp
80103cc2:	89 e5                	mov    %esp,%ebp
80103cc4:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103cc7:	c7 05 4c 29 11 80 60 	movl   $0x80112360,0x8011294c
80103cce:	23 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103cd1:	83 ec 0c             	sub    $0xc,%esp
80103cd4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103cd7:	50                   	push   %eax
80103cd8:	e8 39 ff ff ff       	call   80103c16 <mpconfig>
80103cdd:	83 c4 10             	add    $0x10,%esp
80103ce0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103ce3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103ce7:	0f 84 ba 01 00 00    	je     80103ea7 <mpinit+0x1e6>
    return;
  ismp = 1;
80103ced:	c7 05 40 29 11 80 01 	movl   $0x1,0x80112940
80103cf4:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cfa:	8b 40 24             	mov    0x24(%eax),%eax
80103cfd:	a3 60 22 11 80       	mov    %eax,0x80112260
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d05:	83 c0 2c             	add    $0x2c,%eax
80103d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d0e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d12:	0f b7 d0             	movzwl %ax,%edx
80103d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d18:	01 d0                	add    %edx,%eax
80103d1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d1d:	e9 16 01 00 00       	jmp    80103e38 <mpinit+0x177>
    switch(*p){
80103d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d25:	0f b6 00             	movzbl (%eax),%eax
80103d28:	0f b6 c0             	movzbl %al,%eax
80103d2b:	83 f8 04             	cmp    $0x4,%eax
80103d2e:	0f 8f e0 00 00 00    	jg     80103e14 <mpinit+0x153>
80103d34:	83 f8 03             	cmp    $0x3,%eax
80103d37:	0f 8d d1 00 00 00    	jge    80103e0e <mpinit+0x14d>
80103d3d:	83 f8 02             	cmp    $0x2,%eax
80103d40:	0f 84 b0 00 00 00    	je     80103df6 <mpinit+0x135>
80103d46:	83 f8 02             	cmp    $0x2,%eax
80103d49:	0f 8f c5 00 00 00    	jg     80103e14 <mpinit+0x153>
80103d4f:	85 c0                	test   %eax,%eax
80103d51:	74 0e                	je     80103d61 <mpinit+0xa0>
80103d53:	83 f8 01             	cmp    $0x1,%eax
80103d56:	0f 84 b2 00 00 00    	je     80103e0e <mpinit+0x14d>
80103d5c:	e9 b3 00 00 00       	jmp    80103e14 <mpinit+0x153>
    case MPPROC:
      proc = (struct mpproc*)p;
80103d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu != proc->apicid){
80103d67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d6a:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d6e:	0f b6 d0             	movzbl %al,%edx
80103d71:	a1 44 29 11 80       	mov    0x80112944,%eax
80103d76:	39 c2                	cmp    %eax,%edx
80103d78:	74 2b                	je     80103da5 <mpinit+0xe4>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d7d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d81:	0f b6 d0             	movzbl %al,%edx
80103d84:	a1 44 29 11 80       	mov    0x80112944,%eax
80103d89:	83 ec 04             	sub    $0x4,%esp
80103d8c:	52                   	push   %edx
80103d8d:	50                   	push   %eax
80103d8e:	68 0a 95 10 80       	push   $0x8010950a
80103d93:	e8 2e c6 ff ff       	call   801003c6 <cprintf>
80103d98:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d9b:	c7 05 40 29 11 80 00 	movl   $0x0,0x80112940
80103da2:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103da8:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103dac:	0f b6 c0             	movzbl %al,%eax
80103daf:	83 e0 02             	and    $0x2,%eax
80103db2:	85 c0                	test   %eax,%eax
80103db4:	74 15                	je     80103dcb <mpinit+0x10a>
        bcpu = &cpus[ncpu];
80103db6:	a1 44 29 11 80       	mov    0x80112944,%eax
80103dbb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103dc1:	05 60 23 11 80       	add    $0x80112360,%eax
80103dc6:	a3 4c 29 11 80       	mov    %eax,0x8011294c
      cpus[ncpu].id = ncpu;
80103dcb:	8b 15 44 29 11 80    	mov    0x80112944,%edx
80103dd1:	a1 44 29 11 80       	mov    0x80112944,%eax
80103dd6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103ddc:	05 60 23 11 80       	add    $0x80112360,%eax
80103de1:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103de3:	a1 44 29 11 80       	mov    0x80112944,%eax
80103de8:	83 c0 01             	add    $0x1,%eax
80103deb:	a3 44 29 11 80       	mov    %eax,0x80112944
      p += sizeof(struct mpproc);
80103df0:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103df4:	eb 42                	jmp    80103e38 <mpinit+0x177>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      ioapicid = ioapic->apicno;
80103dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103dff:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e03:	a2 48 29 11 80       	mov    %al,0x80112948
      p += sizeof(struct mpioapic);
80103e08:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e0c:	eb 2a                	jmp    80103e38 <mpinit+0x177>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e0e:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e12:	eb 24                	jmp    80103e38 <mpinit+0x177>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e17:	0f b6 00             	movzbl (%eax),%eax
80103e1a:	0f b6 c0             	movzbl %al,%eax
80103e1d:	83 ec 08             	sub    $0x8,%esp
80103e20:	50                   	push   %eax
80103e21:	68 28 95 10 80       	push   $0x80109528
80103e26:	e8 9b c5 ff ff       	call   801003c6 <cprintf>
80103e2b:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e2e:	c7 05 40 29 11 80 00 	movl   $0x0,0x80112940
80103e35:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e3b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e3e:	0f 82 de fe ff ff    	jb     80103d22 <mpinit+0x61>
    }
  }
  if(!ismp){
80103e44:	a1 40 29 11 80       	mov    0x80112940,%eax
80103e49:	85 c0                	test   %eax,%eax
80103e4b:	75 1d                	jne    80103e6a <mpinit+0x1a9>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e4d:	c7 05 44 29 11 80 01 	movl   $0x1,0x80112944
80103e54:	00 00 00 
    lapic = 0;
80103e57:	c7 05 60 22 11 80 00 	movl   $0x0,0x80112260
80103e5e:	00 00 00 
    ioapicid = 0;
80103e61:	c6 05 48 29 11 80 00 	movb   $0x0,0x80112948
    return;
80103e68:	eb 3e                	jmp    80103ea8 <mpinit+0x1e7>
  }

  if(mp->imcrp){
80103e6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e6d:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e71:	84 c0                	test   %al,%al
80103e73:	74 33                	je     80103ea8 <mpinit+0x1e7>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e75:	83 ec 08             	sub    $0x8,%esp
80103e78:	6a 70                	push   $0x70
80103e7a:	6a 22                	push   $0x22
80103e7c:	e8 fc fb ff ff       	call   80103a7d <outb>
80103e81:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e84:	83 ec 0c             	sub    $0xc,%esp
80103e87:	6a 23                	push   $0x23
80103e89:	e8 d2 fb ff ff       	call   80103a60 <inb>
80103e8e:	83 c4 10             	add    $0x10,%esp
80103e91:	83 c8 01             	or     $0x1,%eax
80103e94:	0f b6 c0             	movzbl %al,%eax
80103e97:	83 ec 08             	sub    $0x8,%esp
80103e9a:	50                   	push   %eax
80103e9b:	6a 23                	push   $0x23
80103e9d:	e8 db fb ff ff       	call   80103a7d <outb>
80103ea2:	83 c4 10             	add    $0x10,%esp
80103ea5:	eb 01                	jmp    80103ea8 <mpinit+0x1e7>
    return;
80103ea7:	90                   	nop
  }
}
80103ea8:	c9                   	leave  
80103ea9:	c3                   	ret    

80103eaa <outb>:
{
80103eaa:	55                   	push   %ebp
80103eab:	89 e5                	mov    %esp,%ebp
80103ead:	83 ec 08             	sub    $0x8,%esp
80103eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eb6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103eba:	89 d0                	mov    %edx,%eax
80103ebc:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103ebf:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103ec3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103ec7:	ee                   	out    %al,(%dx)
}
80103ec8:	90                   	nop
80103ec9:	c9                   	leave  
80103eca:	c3                   	ret    

80103ecb <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103ecb:	55                   	push   %ebp
80103ecc:	89 e5                	mov    %esp,%ebp
80103ece:	83 ec 04             	sub    $0x4,%esp
80103ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103ed8:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103edc:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103ee2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ee6:	0f b6 c0             	movzbl %al,%eax
80103ee9:	50                   	push   %eax
80103eea:	6a 21                	push   $0x21
80103eec:	e8 b9 ff ff ff       	call   80103eaa <outb>
80103ef1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103ef4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103ef8:	66 c1 e8 08          	shr    $0x8,%ax
80103efc:	0f b6 c0             	movzbl %al,%eax
80103eff:	50                   	push   %eax
80103f00:	68 a1 00 00 00       	push   $0xa1
80103f05:	e8 a0 ff ff ff       	call   80103eaa <outb>
80103f0a:	83 c4 08             	add    $0x8,%esp
}
80103f0d:	90                   	nop
80103f0e:	c9                   	leave  
80103f0f:	c3                   	ret    

80103f10 <picenable>:

void
picenable(int irq)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	ba 01 00 00 00       	mov    $0x1,%edx
80103f1b:	89 c1                	mov    %eax,%ecx
80103f1d:	d3 e2                	shl    %cl,%edx
80103f1f:	89 d0                	mov    %edx,%eax
80103f21:	f7 d0                	not    %eax
80103f23:	89 c2                	mov    %eax,%edx
80103f25:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f2c:	21 d0                	and    %edx,%eax
80103f2e:	0f b7 c0             	movzwl %ax,%eax
80103f31:	50                   	push   %eax
80103f32:	e8 94 ff ff ff       	call   80103ecb <picsetmask>
80103f37:	83 c4 04             	add    $0x4,%esp
}
80103f3a:	90                   	nop
80103f3b:	c9                   	leave  
80103f3c:	c3                   	ret    

80103f3d <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103f3d:	55                   	push   %ebp
80103f3e:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103f40:	68 ff 00 00 00       	push   $0xff
80103f45:	6a 21                	push   $0x21
80103f47:	e8 5e ff ff ff       	call   80103eaa <outb>
80103f4c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103f4f:	68 ff 00 00 00       	push   $0xff
80103f54:	68 a1 00 00 00       	push   $0xa1
80103f59:	e8 4c ff ff ff       	call   80103eaa <outb>
80103f5e:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f61:	6a 11                	push   $0x11
80103f63:	6a 20                	push   $0x20
80103f65:	e8 40 ff ff ff       	call   80103eaa <outb>
80103f6a:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f6d:	6a 20                	push   $0x20
80103f6f:	6a 21                	push   $0x21
80103f71:	e8 34 ff ff ff       	call   80103eaa <outb>
80103f76:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f79:	6a 04                	push   $0x4
80103f7b:	6a 21                	push   $0x21
80103f7d:	e8 28 ff ff ff       	call   80103eaa <outb>
80103f82:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f85:	6a 03                	push   $0x3
80103f87:	6a 21                	push   $0x21
80103f89:	e8 1c ff ff ff       	call   80103eaa <outb>
80103f8e:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f91:	6a 11                	push   $0x11
80103f93:	68 a0 00 00 00       	push   $0xa0
80103f98:	e8 0d ff ff ff       	call   80103eaa <outb>
80103f9d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103fa0:	6a 28                	push   $0x28
80103fa2:	68 a1 00 00 00       	push   $0xa1
80103fa7:	e8 fe fe ff ff       	call   80103eaa <outb>
80103fac:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103faf:	6a 02                	push   $0x2
80103fb1:	68 a1 00 00 00       	push   $0xa1
80103fb6:	e8 ef fe ff ff       	call   80103eaa <outb>
80103fbb:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103fbe:	6a 03                	push   $0x3
80103fc0:	68 a1 00 00 00       	push   $0xa1
80103fc5:	e8 e0 fe ff ff       	call   80103eaa <outb>
80103fca:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103fcd:	6a 68                	push   $0x68
80103fcf:	6a 20                	push   $0x20
80103fd1:	e8 d4 fe ff ff       	call   80103eaa <outb>
80103fd6:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103fd9:	6a 0a                	push   $0xa
80103fdb:	6a 20                	push   $0x20
80103fdd:	e8 c8 fe ff ff       	call   80103eaa <outb>
80103fe2:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103fe5:	6a 68                	push   $0x68
80103fe7:	68 a0 00 00 00       	push   $0xa0
80103fec:	e8 b9 fe ff ff       	call   80103eaa <outb>
80103ff1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103ff4:	6a 0a                	push   $0xa
80103ff6:	68 a0 00 00 00       	push   $0xa0
80103ffb:	e8 aa fe ff ff       	call   80103eaa <outb>
80104000:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104003:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
8010400a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010400e:	74 13                	je     80104023 <picinit+0xe6>
    picsetmask(irqmask);
80104010:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104017:	0f b7 c0             	movzwl %ax,%eax
8010401a:	50                   	push   %eax
8010401b:	e8 ab fe ff ff       	call   80103ecb <picsetmask>
80104020:	83 c4 04             	add    $0x4,%esp
}
80104023:	90                   	nop
80104024:	c9                   	leave  
80104025:	c3                   	ret    

80104026 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104026:	55                   	push   %ebp
80104027:	89 e5                	mov    %esp,%ebp
80104029:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010402c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104033:	8b 45 0c             	mov    0xc(%ebp),%eax
80104036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010403c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010403f:	8b 10                	mov    (%eax),%edx
80104041:	8b 45 08             	mov    0x8(%ebp),%eax
80104044:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104046:	e8 56 cf ff ff       	call   80100fa1 <filealloc>
8010404b:	8b 55 08             	mov    0x8(%ebp),%edx
8010404e:	89 02                	mov    %eax,(%edx)
80104050:	8b 45 08             	mov    0x8(%ebp),%eax
80104053:	8b 00                	mov    (%eax),%eax
80104055:	85 c0                	test   %eax,%eax
80104057:	0f 84 c8 00 00 00    	je     80104125 <pipealloc+0xff>
8010405d:	e8 3f cf ff ff       	call   80100fa1 <filealloc>
80104062:	8b 55 0c             	mov    0xc(%ebp),%edx
80104065:	89 02                	mov    %eax,(%edx)
80104067:	8b 45 0c             	mov    0xc(%ebp),%eax
8010406a:	8b 00                	mov    (%eax),%eax
8010406c:	85 c0                	test   %eax,%eax
8010406e:	0f 84 b1 00 00 00    	je     80104125 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104074:	e8 c8 eb ff ff       	call   80102c41 <kalloc>
80104079:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010407c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104080:	0f 84 a2 00 00 00    	je     80104128 <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
80104086:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104089:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104090:	00 00 00 
  p->writeopen = 1;
80104093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104096:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010409d:	00 00 00 
  p->nwrite = 0;
801040a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801040aa:	00 00 00 
  p->nread = 0;
801040ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b0:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801040b7:	00 00 00 
  initlock(&p->lock, "pipe");
801040ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bd:	83 ec 08             	sub    $0x8,%esp
801040c0:	68 48 95 10 80       	push   $0x80109548
801040c5:	50                   	push   %eax
801040c6:	e8 24 13 00 00       	call   801053ef <initlock>
801040cb:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801040ce:	8b 45 08             	mov    0x8(%ebp),%eax
801040d1:	8b 00                	mov    (%eax),%eax
801040d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801040d9:	8b 45 08             	mov    0x8(%ebp),%eax
801040dc:	8b 00                	mov    (%eax),%eax
801040de:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801040e2:	8b 45 08             	mov    0x8(%ebp),%eax
801040e5:	8b 00                	mov    (%eax),%eax
801040e7:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801040eb:	8b 45 08             	mov    0x8(%ebp),%eax
801040ee:	8b 00                	mov    (%eax),%eax
801040f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040f3:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f9:	8b 00                	mov    (%eax),%eax
801040fb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104101:	8b 45 0c             	mov    0xc(%ebp),%eax
80104104:	8b 00                	mov    (%eax),%eax
80104106:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010410a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010410d:	8b 00                	mov    (%eax),%eax
8010410f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104113:	8b 45 0c             	mov    0xc(%ebp),%eax
80104116:	8b 00                	mov    (%eax),%eax
80104118:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010411b:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010411e:	b8 00 00 00 00       	mov    $0x0,%eax
80104123:	eb 51                	jmp    80104176 <pipealloc+0x150>
    goto bad;
80104125:	90                   	nop
80104126:	eb 01                	jmp    80104129 <pipealloc+0x103>
    goto bad;
80104128:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80104129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010412d:	74 0e                	je     8010413d <pipealloc+0x117>
    kfree((char*)p);
8010412f:	83 ec 0c             	sub    $0xc,%esp
80104132:	ff 75 f4             	push   -0xc(%ebp)
80104135:	e8 0d ea ff ff       	call   80102b47 <kfree>
8010413a:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010413d:	8b 45 08             	mov    0x8(%ebp),%eax
80104140:	8b 00                	mov    (%eax),%eax
80104142:	85 c0                	test   %eax,%eax
80104144:	74 11                	je     80104157 <pipealloc+0x131>
    fileclose(*f0);
80104146:	8b 45 08             	mov    0x8(%ebp),%eax
80104149:	8b 00                	mov    (%eax),%eax
8010414b:	83 ec 0c             	sub    $0xc,%esp
8010414e:	50                   	push   %eax
8010414f:	e8 0b cf ff ff       	call   8010105f <fileclose>
80104154:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104157:	8b 45 0c             	mov    0xc(%ebp),%eax
8010415a:	8b 00                	mov    (%eax),%eax
8010415c:	85 c0                	test   %eax,%eax
8010415e:	74 11                	je     80104171 <pipealloc+0x14b>
    fileclose(*f1);
80104160:	8b 45 0c             	mov    0xc(%ebp),%eax
80104163:	8b 00                	mov    (%eax),%eax
80104165:	83 ec 0c             	sub    $0xc,%esp
80104168:	50                   	push   %eax
80104169:	e8 f1 ce ff ff       	call   8010105f <fileclose>
8010416e:	83 c4 10             	add    $0x10,%esp
  return -1;
80104171:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104176:	c9                   	leave  
80104177:	c3                   	ret    

80104178 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104178:	55                   	push   %ebp
80104179:	89 e5                	mov    %esp,%ebp
8010417b:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010417e:	8b 45 08             	mov    0x8(%ebp),%eax
80104181:	83 ec 0c             	sub    $0xc,%esp
80104184:	50                   	push   %eax
80104185:	e8 87 12 00 00       	call   80105411 <acquire>
8010418a:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010418d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104191:	74 23                	je     801041b6 <pipeclose+0x3e>
    p->writeopen = 0;
80104193:	8b 45 08             	mov    0x8(%ebp),%eax
80104196:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010419d:	00 00 00 
    wakeup(&p->nread);
801041a0:	8b 45 08             	mov    0x8(%ebp),%eax
801041a3:	05 34 02 00 00       	add    $0x234,%eax
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	50                   	push   %eax
801041ac:	e8 a5 0c 00 00       	call   80104e56 <wakeup>
801041b1:	83 c4 10             	add    $0x10,%esp
801041b4:	eb 21                	jmp    801041d7 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801041b6:	8b 45 08             	mov    0x8(%ebp),%eax
801041b9:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801041c0:	00 00 00 
    wakeup(&p->nwrite);
801041c3:	8b 45 08             	mov    0x8(%ebp),%eax
801041c6:	05 38 02 00 00       	add    $0x238,%eax
801041cb:	83 ec 0c             	sub    $0xc,%esp
801041ce:	50                   	push   %eax
801041cf:	e8 82 0c 00 00       	call   80104e56 <wakeup>
801041d4:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801041d7:	8b 45 08             	mov    0x8(%ebp),%eax
801041da:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041e0:	85 c0                	test   %eax,%eax
801041e2:	75 2c                	jne    80104210 <pipeclose+0x98>
801041e4:	8b 45 08             	mov    0x8(%ebp),%eax
801041e7:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801041ed:	85 c0                	test   %eax,%eax
801041ef:	75 1f                	jne    80104210 <pipeclose+0x98>
    release(&p->lock);
801041f1:	8b 45 08             	mov    0x8(%ebp),%eax
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	50                   	push   %eax
801041f8:	e8 7b 12 00 00       	call   80105478 <release>
801041fd:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104200:	83 ec 0c             	sub    $0xc,%esp
80104203:	ff 75 08             	push   0x8(%ebp)
80104206:	e8 3c e9 ff ff       	call   80102b47 <kfree>
8010420b:	83 c4 10             	add    $0x10,%esp
8010420e:	eb 10                	jmp    80104220 <pipeclose+0xa8>
  } else
    release(&p->lock);
80104210:	8b 45 08             	mov    0x8(%ebp),%eax
80104213:	83 ec 0c             	sub    $0xc,%esp
80104216:	50                   	push   %eax
80104217:	e8 5c 12 00 00       	call   80105478 <release>
8010421c:	83 c4 10             	add    $0x10,%esp
}
8010421f:	90                   	nop
80104220:	90                   	nop
80104221:	c9                   	leave  
80104222:	c3                   	ret    

80104223 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104223:	55                   	push   %ebp
80104224:	89 e5                	mov    %esp,%ebp
80104226:	53                   	push   %ebx
80104227:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010422a:	8b 45 08             	mov    0x8(%ebp),%eax
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	50                   	push   %eax
80104231:	e8 db 11 00 00       	call   80105411 <acquire>
80104236:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104239:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104240:	e9 ae 00 00 00       	jmp    801042f3 <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104245:	8b 45 08             	mov    0x8(%ebp),%eax
80104248:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010424e:	85 c0                	test   %eax,%eax
80104250:	74 0d                	je     8010425f <pipewrite+0x3c>
80104252:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104258:	8b 40 24             	mov    0x24(%eax),%eax
8010425b:	85 c0                	test   %eax,%eax
8010425d:	74 19                	je     80104278 <pipewrite+0x55>
        release(&p->lock);
8010425f:	8b 45 08             	mov    0x8(%ebp),%eax
80104262:	83 ec 0c             	sub    $0xc,%esp
80104265:	50                   	push   %eax
80104266:	e8 0d 12 00 00       	call   80105478 <release>
8010426b:	83 c4 10             	add    $0x10,%esp
        return -1;
8010426e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104273:	e9 a9 00 00 00       	jmp    80104321 <pipewrite+0xfe>
      }
      wakeup(&p->nread);
80104278:	8b 45 08             	mov    0x8(%ebp),%eax
8010427b:	05 34 02 00 00       	add    $0x234,%eax
80104280:	83 ec 0c             	sub    $0xc,%esp
80104283:	50                   	push   %eax
80104284:	e8 cd 0b 00 00       	call   80104e56 <wakeup>
80104289:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010428c:	8b 45 08             	mov    0x8(%ebp),%eax
8010428f:	8b 55 08             	mov    0x8(%ebp),%edx
80104292:	81 c2 38 02 00 00    	add    $0x238,%edx
80104298:	83 ec 08             	sub    $0x8,%esp
8010429b:	50                   	push   %eax
8010429c:	52                   	push   %edx
8010429d:	e8 c5 0a 00 00       	call   80104d67 <sleep>
801042a2:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801042a5:	8b 45 08             	mov    0x8(%ebp),%eax
801042a8:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801042ae:	8b 45 08             	mov    0x8(%ebp),%eax
801042b1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042b7:	05 00 02 00 00       	add    $0x200,%eax
801042bc:	39 c2                	cmp    %eax,%edx
801042be:	74 85                	je     80104245 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801042c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801042c6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801042c9:	8b 45 08             	mov    0x8(%ebp),%eax
801042cc:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042d2:	8d 48 01             	lea    0x1(%eax),%ecx
801042d5:	8b 55 08             	mov    0x8(%ebp),%edx
801042d8:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801042de:	25 ff 01 00 00       	and    $0x1ff,%eax
801042e3:	89 c1                	mov    %eax,%ecx
801042e5:	0f b6 13             	movzbl (%ebx),%edx
801042e8:	8b 45 08             	mov    0x8(%ebp),%eax
801042eb:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
801042ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801042f9:	7c aa                	jl     801042a5 <pipewrite+0x82>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042fb:	8b 45 08             	mov    0x8(%ebp),%eax
801042fe:	05 34 02 00 00       	add    $0x234,%eax
80104303:	83 ec 0c             	sub    $0xc,%esp
80104306:	50                   	push   %eax
80104307:	e8 4a 0b 00 00       	call   80104e56 <wakeup>
8010430c:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010430f:	8b 45 08             	mov    0x8(%ebp),%eax
80104312:	83 ec 0c             	sub    $0xc,%esp
80104315:	50                   	push   %eax
80104316:	e8 5d 11 00 00       	call   80105478 <release>
8010431b:	83 c4 10             	add    $0x10,%esp
  return n;
8010431e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104321:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104324:	c9                   	leave  
80104325:	c3                   	ret    

80104326 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104326:	55                   	push   %ebp
80104327:	89 e5                	mov    %esp,%ebp
80104329:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010432c:	8b 45 08             	mov    0x8(%ebp),%eax
8010432f:	83 ec 0c             	sub    $0xc,%esp
80104332:	50                   	push   %eax
80104333:	e8 d9 10 00 00       	call   80105411 <acquire>
80104338:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010433b:	eb 3f                	jmp    8010437c <piperead+0x56>
    if(proc->killed){
8010433d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104343:	8b 40 24             	mov    0x24(%eax),%eax
80104346:	85 c0                	test   %eax,%eax
80104348:	74 19                	je     80104363 <piperead+0x3d>
      release(&p->lock);
8010434a:	8b 45 08             	mov    0x8(%ebp),%eax
8010434d:	83 ec 0c             	sub    $0xc,%esp
80104350:	50                   	push   %eax
80104351:	e8 22 11 00 00       	call   80105478 <release>
80104356:	83 c4 10             	add    $0x10,%esp
      return -1;
80104359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010435e:	e9 be 00 00 00       	jmp    80104421 <piperead+0xfb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104363:	8b 45 08             	mov    0x8(%ebp),%eax
80104366:	8b 55 08             	mov    0x8(%ebp),%edx
80104369:	81 c2 34 02 00 00    	add    $0x234,%edx
8010436f:	83 ec 08             	sub    $0x8,%esp
80104372:	50                   	push   %eax
80104373:	52                   	push   %edx
80104374:	e8 ee 09 00 00       	call   80104d67 <sleep>
80104379:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010437c:	8b 45 08             	mov    0x8(%ebp),%eax
8010437f:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104385:	8b 45 08             	mov    0x8(%ebp),%eax
80104388:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010438e:	39 c2                	cmp    %eax,%edx
80104390:	75 0d                	jne    8010439f <piperead+0x79>
80104392:	8b 45 08             	mov    0x8(%ebp),%eax
80104395:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010439b:	85 c0                	test   %eax,%eax
8010439d:	75 9e                	jne    8010433d <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010439f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801043a6:	eb 48                	jmp    801043f0 <piperead+0xca>
    if(p->nread == p->nwrite)
801043a8:	8b 45 08             	mov    0x8(%ebp),%eax
801043ab:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043b1:	8b 45 08             	mov    0x8(%ebp),%eax
801043b4:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043ba:	39 c2                	cmp    %eax,%edx
801043bc:	74 3c                	je     801043fa <piperead+0xd4>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801043be:	8b 45 08             	mov    0x8(%ebp),%eax
801043c1:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801043c7:	8d 48 01             	lea    0x1(%eax),%ecx
801043ca:	8b 55 08             	mov    0x8(%ebp),%edx
801043cd:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801043d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801043d8:	89 c1                	mov    %eax,%ecx
801043da:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801043e0:	01 c2                	add    %eax,%edx
801043e2:	8b 45 08             	mov    0x8(%ebp),%eax
801043e5:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
801043ea:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801043ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f3:	3b 45 10             	cmp    0x10(%ebp),%eax
801043f6:	7c b0                	jl     801043a8 <piperead+0x82>
801043f8:	eb 01                	jmp    801043fb <piperead+0xd5>
      break;
801043fa:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043fb:	8b 45 08             	mov    0x8(%ebp),%eax
801043fe:	05 38 02 00 00       	add    $0x238,%eax
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	50                   	push   %eax
80104407:	e8 4a 0a 00 00       	call   80104e56 <wakeup>
8010440c:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010440f:	8b 45 08             	mov    0x8(%ebp),%eax
80104412:	83 ec 0c             	sub    $0xc,%esp
80104415:	50                   	push   %eax
80104416:	e8 5d 10 00 00       	call   80105478 <release>
8010441b:	83 c4 10             	add    $0x10,%esp
  return i;
8010441e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104421:	c9                   	leave  
80104422:	c3                   	ret    

80104423 <readeflags>:
{
80104423:	55                   	push   %ebp
80104424:	89 e5                	mov    %esp,%ebp
80104426:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104429:	9c                   	pushf  
8010442a:	58                   	pop    %eax
8010442b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010442e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104431:	c9                   	leave  
80104432:	c3                   	ret    

80104433 <sti>:
{
80104433:	55                   	push   %ebp
80104434:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104436:	fb                   	sti    
}
80104437:	90                   	nop
80104438:	5d                   	pop    %ebp
80104439:	c3                   	ret    

8010443a <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010443a:	55                   	push   %ebp
8010443b:	89 e5                	mov    %esp,%ebp
8010443d:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104440:	83 ec 08             	sub    $0x8,%esp
80104443:	68 50 95 10 80       	push   $0x80109550
80104448:	68 60 29 11 80       	push   $0x80112960
8010444d:	e8 9d 0f 00 00       	call   801053ef <initlock>
80104452:	83 c4 10             	add    $0x10,%esp
}
80104455:	90                   	nop
80104456:	c9                   	leave  
80104457:	c3                   	ret    

80104458 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104458:	55                   	push   %ebp
80104459:	89 e5                	mov    %esp,%ebp
8010445b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010445e:	83 ec 0c             	sub    $0xc,%esp
80104461:	68 60 29 11 80       	push   $0x80112960
80104466:	e8 a6 0f 00 00       	call   80105411 <acquire>
8010446b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010446e:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104475:	eb 11                	jmp    80104488 <allocproc+0x30>
    if(p->state == UNUSED)
80104477:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447a:	8b 40 0c             	mov    0xc(%eax),%eax
8010447d:	85 c0                	test   %eax,%eax
8010447f:	74 2a                	je     801044ab <allocproc+0x53>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104481:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104488:	81 7d f4 94 5a 11 80 	cmpl   $0x80115a94,-0xc(%ebp)
8010448f:	72 e6                	jb     80104477 <allocproc+0x1f>
      goto found;
  release(&ptable.lock);
80104491:	83 ec 0c             	sub    $0xc,%esp
80104494:	68 60 29 11 80       	push   $0x80112960
80104499:	e8 da 0f 00 00       	call   80105478 <release>
8010449e:	83 c4 10             	add    $0x10,%esp
  return 0;
801044a1:	b8 00 00 00 00       	mov    $0x0,%eax
801044a6:	e9 00 01 00 00       	jmp    801045ab <allocproc+0x153>
      goto found;
801044ab:	90                   	nop

found:
  p->state = EMBRYO;
801044ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044af:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801044b6:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801044bb:	8d 50 01             	lea    0x1(%eax),%edx
801044be:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801044c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c7:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
801044ca:	83 ec 0c             	sub    $0xc,%esp
801044cd:	68 60 29 11 80       	push   $0x80112960
801044d2:	e8 a1 0f 00 00       	call   80105478 <release>
801044d7:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801044da:	e8 62 e7 ff ff       	call   80102c41 <kalloc>
801044df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044e2:	89 42 08             	mov    %eax,0x8(%edx)
801044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e8:	8b 40 08             	mov    0x8(%eax),%eax
801044eb:	85 c0                	test   %eax,%eax
801044ed:	75 14                	jne    80104503 <allocproc+0xab>
    p->state = UNUSED;
801044ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801044f9:	b8 00 00 00 00       	mov    $0x0,%eax
801044fe:	e9 a8 00 00 00       	jmp    801045ab <allocproc+0x153>
  }
  sp = p->kstack + KSTACKSIZE;
80104503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104506:	8b 40 08             	mov    0x8(%eax),%eax
80104509:	05 00 10 00 00       	add    $0x1000,%eax
8010450e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104511:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104515:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104518:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010451b:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010451e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104522:	ba 6e 6c 10 80       	mov    $0x80106c6e,%edx
80104527:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010452a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010452c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104533:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104536:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010453f:	83 ec 04             	sub    $0x4,%esp
80104542:	6a 14                	push   $0x14
80104544:	6a 00                	push   $0x0
80104546:	50                   	push   %eax
80104547:	e8 28 11 00 00       	call   80105674 <memset>
8010454c:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104552:	8b 40 1c             	mov    0x1c(%eax),%eax
80104555:	ba 36 4d 10 80       	mov    $0x80104d36,%edx
8010455a:	89 50 10             	mov    %edx,0x10(%eax)

  p->handlers[SIGKILL] = (sighandler_t) -1;
8010455d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104560:	c7 40 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%eax)
  p->handlers[SIGFPE] = (sighandler_t) -1;
80104567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456a:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
80104571:	ff ff ff 
  p->handlers[SIGSEGV] = (sighandler_t) -1;
80104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104577:	c7 80 b4 00 00 00 ff 	movl   $0xffffffff,0xb4(%eax)
8010457e:	ff ff ff 
  p->restorer_addr = -1;
80104581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104584:	c7 80 b8 00 00 00 ff 	movl   $0xffffffff,0xb8(%eax)
8010458b:	ff ff ff 
  p->actualsz = 0;
8010458e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104591:	c7 80 c0 00 00 00 00 	movl   $0x0,0xc0(%eax)
80104598:	00 00 00 
  p->shared = 0;
8010459b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459e:	c7 80 bc 00 00 00 00 	movl   $0x0,0xbc(%eax)
801045a5:	00 00 00 

  return p;
801045a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801045ab:	c9                   	leave  
801045ac:	c3                   	ret    

801045ad <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801045ad:	55                   	push   %ebp
801045ae:	89 e5                	mov    %esp,%ebp
801045b0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801045b3:	e8 a0 fe ff ff       	call   80104458 <allocproc>
801045b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045be:	a3 94 5a 11 80       	mov    %eax,0x80115a94
  if((p->pgdir = setupkvm()) == 0)
801045c3:	e8 08 3f 00 00       	call   801084d0 <setupkvm>
801045c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045cb:	89 42 04             	mov    %eax,0x4(%edx)
801045ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d1:	8b 40 04             	mov    0x4(%eax),%eax
801045d4:	85 c0                	test   %eax,%eax
801045d6:	75 0d                	jne    801045e5 <userinit+0x38>
    panic("userinit: out of memory?");
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	68 57 95 10 80       	push   $0x80109557
801045e0:	e8 96 bf ff ff       	call   8010057b <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801045e5:	ba 2c 00 00 00       	mov    $0x2c,%edx
801045ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ed:	8b 40 04             	mov    0x4(%eax),%eax
801045f0:	83 ec 04             	sub    $0x4,%esp
801045f3:	52                   	push   %edx
801045f4:	68 00 c5 10 80       	push   $0x8010c500
801045f9:	50                   	push   %eax
801045fa:	e8 2c 41 00 00       	call   8010872b <inituvm>
801045ff:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104602:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104605:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010460b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460e:	8b 40 18             	mov    0x18(%eax),%eax
80104611:	83 ec 04             	sub    $0x4,%esp
80104614:	6a 4c                	push   $0x4c
80104616:	6a 00                	push   $0x0
80104618:	50                   	push   %eax
80104619:	e8 56 10 00 00       	call   80105674 <memset>
8010461e:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104624:	8b 40 18             	mov    0x18(%eax),%eax
80104627:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010462d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104630:	8b 40 18             	mov    0x18(%eax),%eax
80104633:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463c:	8b 50 18             	mov    0x18(%eax),%edx
8010463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104642:	8b 40 18             	mov    0x18(%eax),%eax
80104645:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104649:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010464d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104650:	8b 50 18             	mov    0x18(%eax),%edx
80104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104656:	8b 40 18             	mov    0x18(%eax),%eax
80104659:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010465d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104661:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104664:	8b 40 18             	mov    0x18(%eax),%eax
80104667:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010466e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104671:	8b 40 18             	mov    0x18(%eax),%eax
80104674:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010467b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467e:	8b 40 18             	mov    0x18(%eax),%eax
80104681:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104688:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468b:	83 c0 6c             	add    $0x6c,%eax
8010468e:	83 ec 04             	sub    $0x4,%esp
80104691:	6a 10                	push   $0x10
80104693:	68 70 95 10 80       	push   $0x80109570
80104698:	50                   	push   %eax
80104699:	e8 d9 11 00 00       	call   80105877 <safestrcpy>
8010469e:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801046a1:	83 ec 0c             	sub    $0xc,%esp
801046a4:	68 79 95 10 80       	push   $0x80109579
801046a9:	e8 31 de ff ff       	call   801024df <namei>
801046ae:	83 c4 10             	add    $0x10,%esp
801046b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046b4:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801046b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ba:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
801046c1:	90                   	nop
801046c2:	c9                   	leave  
801046c3:	c3                   	ret    

801046c4 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801046ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d0:	8b 00                	mov    (%eax),%eax
801046d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801046d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801046d9:	7e 31                	jle    8010470c <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801046db:	8b 55 08             	mov    0x8(%ebp),%edx
801046de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e1:	01 c2                	add    %eax,%edx
801046e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e9:	8b 40 04             	mov    0x4(%eax),%eax
801046ec:	83 ec 04             	sub    $0x4,%esp
801046ef:	52                   	push   %edx
801046f0:	ff 75 f4             	push   -0xc(%ebp)
801046f3:	50                   	push   %eax
801046f4:	e8 7f 41 00 00       	call   80108878 <allocuvm>
801046f9:	83 c4 10             	add    $0x10,%esp
801046fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801046ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104703:	75 3e                	jne    80104743 <growproc+0x7f>
      return -1;
80104705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010470a:	eb 68                	jmp    80104774 <growproc+0xb0>
  } else if(n < 0){
8010470c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104710:	79 31                	jns    80104743 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104712:	8b 55 08             	mov    0x8(%ebp),%edx
80104715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104718:	01 c2                	add    %eax,%edx
8010471a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104720:	8b 40 04             	mov    0x4(%eax),%eax
80104723:	83 ec 04             	sub    $0x4,%esp
80104726:	52                   	push   %edx
80104727:	ff 75 f4             	push   -0xc(%ebp)
8010472a:	50                   	push   %eax
8010472b:	e8 0f 42 00 00       	call   8010893f <deallocuvm>
80104730:	83 c4 10             	add    $0x10,%esp
80104733:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010473a:	75 07                	jne    80104743 <growproc+0x7f>
      return -1;
8010473c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104741:	eb 31                	jmp    80104774 <growproc+0xb0>
  }
  proc->sz = sz;
80104743:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104749:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010474c:	89 10                	mov    %edx,(%eax)
  proc->actualsz = sz;
8010474e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104754:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104757:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  switchuvm(proc);
8010475d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104763:	83 ec 0c             	sub    $0xc,%esp
80104766:	50                   	push   %eax
80104767:	e8 4b 3e 00 00       	call   801085b7 <switchuvm>
8010476c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010476f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104774:	c9                   	leave  
80104775:	c3                   	ret    

80104776 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104776:	55                   	push   %ebp
80104777:	89 e5                	mov    %esp,%ebp
80104779:	57                   	push   %edi
8010477a:	56                   	push   %esi
8010477b:	53                   	push   %ebx
8010477c:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010477f:	e8 d4 fc ff ff       	call   80104458 <allocproc>
80104784:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104787:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010478b:	75 0a                	jne    80104797 <fork+0x21>
    return -1;
8010478d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104792:	e9 64 01 00 00       	jmp    801048fb <fork+0x185>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104797:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010479d:	8b 10                	mov    (%eax),%edx
8010479f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a5:	8b 40 04             	mov    0x4(%eax),%eax
801047a8:	83 ec 08             	sub    $0x8,%esp
801047ab:	52                   	push   %edx
801047ac:	50                   	push   %eax
801047ad:	e8 2b 43 00 00       	call   80108add <copyuvm>
801047b2:	83 c4 10             	add    $0x10,%esp
801047b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801047b8:	89 42 04             	mov    %eax,0x4(%edx)
801047bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047be:	8b 40 04             	mov    0x4(%eax),%eax
801047c1:	85 c0                	test   %eax,%eax
801047c3:	75 30                	jne    801047f5 <fork+0x7f>
    kfree(np->kstack);
801047c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c8:	8b 40 08             	mov    0x8(%eax),%eax
801047cb:	83 ec 0c             	sub    $0xc,%esp
801047ce:	50                   	push   %eax
801047cf:	e8 73 e3 ff ff       	call   80102b47 <kfree>
801047d4:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801047d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801047e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801047eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047f0:	e9 06 01 00 00       	jmp    801048fb <fork+0x185>
  }
  np->sz = proc->sz;
801047f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fb:	8b 10                	mov    (%eax),%edx
801047fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104800:	89 10                	mov    %edx,(%eax)
  // np->actualsz = np->sz;
  np->parent = proc;
80104802:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104809:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010480c:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010480f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104815:	8b 48 18             	mov    0x18(%eax),%ecx
80104818:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481b:	8b 40 18             	mov    0x18(%eax),%eax
8010481e:	89 c2                	mov    %eax,%edx
80104820:	89 cb                	mov    %ecx,%ebx
80104822:	b8 13 00 00 00       	mov    $0x13,%eax
80104827:	89 d7                	mov    %edx,%edi
80104829:	89 de                	mov    %ebx,%esi
8010482b:	89 c1                	mov    %eax,%ecx
8010482d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010482f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104832:	8b 40 18             	mov    0x18(%eax),%eax
80104835:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010483c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104843:	eb 41                	jmp    80104886 <fork+0x110>
    if(proc->ofile[i])
80104845:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010484b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010484e:	83 c2 08             	add    $0x8,%edx
80104851:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104855:	85 c0                	test   %eax,%eax
80104857:	74 29                	je     80104882 <fork+0x10c>
      np->ofile[i] = filedup(proc->ofile[i]);
80104859:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010485f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104862:	83 c2 08             	add    $0x8,%edx
80104865:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104869:	83 ec 0c             	sub    $0xc,%esp
8010486c:	50                   	push   %eax
8010486d:	e8 9c c7 ff ff       	call   8010100e <filedup>
80104872:	83 c4 10             	add    $0x10,%esp
80104875:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104878:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010487b:	83 c1 08             	add    $0x8,%ecx
8010487e:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104882:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104886:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010488a:	7e b9                	jle    80104845 <fork+0xcf>
  np->cwd = idup(proc->cwd);
8010488c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104892:	8b 40 68             	mov    0x68(%eax),%eax
80104895:	83 ec 0c             	sub    $0xc,%esp
80104898:	50                   	push   %eax
80104899:	e8 5c d0 ff ff       	call   801018fa <idup>
8010489e:	83 c4 10             	add    $0x10,%esp
801048a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801048a4:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801048a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ad:	8d 50 6c             	lea    0x6c(%eax),%edx
801048b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048b3:	83 c0 6c             	add    $0x6c,%eax
801048b6:	83 ec 04             	sub    $0x4,%esp
801048b9:	6a 10                	push   $0x10
801048bb:	52                   	push   %edx
801048bc:	50                   	push   %eax
801048bd:	e8 b5 0f 00 00       	call   80105877 <safestrcpy>
801048c2:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
801048c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048c8:	8b 40 10             	mov    0x10(%eax),%eax
801048cb:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801048ce:	83 ec 0c             	sub    $0xc,%esp
801048d1:	68 60 29 11 80       	push   $0x80112960
801048d6:	e8 36 0b 00 00       	call   80105411 <acquire>
801048db:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
801048de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048e1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	68 60 29 11 80       	push   $0x80112960
801048f0:	e8 83 0b 00 00       	call   80105478 <release>
801048f5:	83 c4 10             	add    $0x10,%esp
  
  return pid;
801048f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801048fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048fe:	5b                   	pop    %ebx
801048ff:	5e                   	pop    %esi
80104900:	5f                   	pop    %edi
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret    

80104903 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104903:	55                   	push   %ebp
80104904:	89 e5                	mov    %esp,%ebp
80104906:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104909:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104910:	a1 94 5a 11 80       	mov    0x80115a94,%eax
80104915:	39 c2                	cmp    %eax,%edx
80104917:	75 0d                	jne    80104926 <exit+0x23>
    panic("init exiting");
80104919:	83 ec 0c             	sub    $0xc,%esp
8010491c:	68 7b 95 10 80       	push   $0x8010957b
80104921:	e8 55 bc ff ff       	call   8010057b <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104926:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010492d:	eb 48                	jmp    80104977 <exit+0x74>
    if(proc->ofile[fd]){
8010492f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104935:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104938:	83 c2 08             	add    $0x8,%edx
8010493b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010493f:	85 c0                	test   %eax,%eax
80104941:	74 30                	je     80104973 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104943:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104949:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010494c:	83 c2 08             	add    $0x8,%edx
8010494f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104953:	83 ec 0c             	sub    $0xc,%esp
80104956:	50                   	push   %eax
80104957:	e8 03 c7 ff ff       	call   8010105f <fileclose>
8010495c:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
8010495f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104965:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104968:	83 c2 08             	add    $0x8,%edx
8010496b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104972:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104973:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104977:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010497b:	7e b2                	jle    8010492f <exit+0x2c>
    }
  }

  begin_op();
8010497d:	e8 a8 eb ff ff       	call   8010352a <begin_op>
  iput(proc->cwd);
80104982:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104988:	8b 40 68             	mov    0x68(%eax),%eax
8010498b:	83 ec 0c             	sub    $0xc,%esp
8010498e:	50                   	push   %eax
8010498f:	e8 6a d1 ff ff       	call   80101afe <iput>
80104994:	83 c4 10             	add    $0x10,%esp
  end_op();
80104997:	e8 1a ec ff ff       	call   801035b6 <end_op>
  proc->cwd = 0;
8010499c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801049a9:	83 ec 0c             	sub    $0xc,%esp
801049ac:	68 60 29 11 80       	push   $0x80112960
801049b1:	e8 5b 0a 00 00       	call   80105411 <acquire>
801049b6:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801049b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049bf:	8b 40 14             	mov    0x14(%eax),%eax
801049c2:	83 ec 0c             	sub    $0xc,%esp
801049c5:	50                   	push   %eax
801049c6:	e8 48 04 00 00       	call   80104e13 <wakeup1>
801049cb:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049ce:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
801049d5:	eb 3f                	jmp    80104a16 <exit+0x113>
    if(p->parent == proc){
801049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049da:	8b 50 14             	mov    0x14(%eax),%edx
801049dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e3:	39 c2                	cmp    %eax,%edx
801049e5:	75 28                	jne    80104a0f <exit+0x10c>
      p->parent = initproc;
801049e7:	8b 15 94 5a 11 80    	mov    0x80115a94,%edx
801049ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f0:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801049f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f6:	8b 40 0c             	mov    0xc(%eax),%eax
801049f9:	83 f8 05             	cmp    $0x5,%eax
801049fc:	75 11                	jne    80104a0f <exit+0x10c>
        wakeup1(initproc);
801049fe:	a1 94 5a 11 80       	mov    0x80115a94,%eax
80104a03:	83 ec 0c             	sub    $0xc,%esp
80104a06:	50                   	push   %eax
80104a07:	e8 07 04 00 00       	call   80104e13 <wakeup1>
80104a0c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a0f:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104a16:	81 7d f4 94 5a 11 80 	cmpl   $0x80115a94,-0xc(%ebp)
80104a1d:	72 b8                	jb     801049d7 <exit+0xd4>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104a1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a25:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104a2c:	e8 0e 02 00 00       	call   80104c3f <sched>
  panic("zombie exit");
80104a31:	83 ec 0c             	sub    $0xc,%esp
80104a34:	68 88 95 10 80       	push   $0x80109588
80104a39:	e8 3d bb ff ff       	call   8010057b <panic>

80104a3e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104a3e:	55                   	push   %ebp
80104a3f:	89 e5                	mov    %esp,%ebp
80104a41:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	68 60 29 11 80       	push   $0x80112960
80104a4c:	e8 c0 09 00 00       	call   80105411 <acquire>
80104a51:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104a54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a5b:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104a62:	e9 db 00 00 00       	jmp    80104b42 <wait+0x104>
      if(p->parent != proc)
80104a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a6a:	8b 50 14             	mov    0x14(%eax),%edx
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	39 c2                	cmp    %eax,%edx
80104a75:	0f 85 bf 00 00 00    	jne    80104b3a <wait+0xfc>
        continue;
      havekids = 1;
80104a7b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a85:	8b 40 0c             	mov    0xc(%eax),%eax
80104a88:	83 f8 05             	cmp    $0x5,%eax
80104a8b:	0f 85 aa 00 00 00    	jne    80104b3b <wait+0xfd>
        // Found one.
        pid = p->pid;
80104a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a94:	8b 40 10             	mov    0x10(%eax),%eax
80104a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a9d:	8b 40 08             	mov    0x8(%eax),%eax
80104aa0:	83 ec 0c             	sub    $0xc,%esp
80104aa3:	50                   	push   %eax
80104aa4:	e8 9e e0 ff ff       	call   80102b47 <kfree>
80104aa9:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aaf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        if (p->shared == 0) { // clean the memory space iff it is not shared
80104ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab9:	8b 80 bc 00 00 00    	mov    0xbc(%eax),%eax
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	75 14                	jne    80104ad7 <wait+0x99>
          freevm(p->pgdir);
80104ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac6:	8b 40 04             	mov    0x4(%eax),%eax
80104ac9:	83 ec 0c             	sub    $0xc,%esp
80104acc:	50                   	push   %eax
80104acd:	e8 2a 3f 00 00       	call   801089fc <freevm>
80104ad2:	83 c4 10             	add    $0x10,%esp
80104ad5:	eb 1f                	jmp    80104af6 <wait+0xb8>
        }
        else {
          // check whether the process need to clean the memory or not
          cowfreevm(p->pgdir);
80104ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ada:	8b 40 04             	mov    0x4(%eax),%eax
80104add:	83 ec 0c             	sub    $0xc,%esp
80104ae0:	50                   	push   %eax
80104ae1:	e8 a7 46 00 00       	call   8010918d <cowfreevm>
80104ae6:	83 c4 10             	add    $0x10,%esp
          p->shared = 0;
80104ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aec:	c7 80 bc 00 00 00 00 	movl   $0x0,0xbc(%eax)
80104af3:	00 00 00 
        }
        p->state = UNUSED;
80104af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b03:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b17:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1e:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104b25:	83 ec 0c             	sub    $0xc,%esp
80104b28:	68 60 29 11 80       	push   $0x80112960
80104b2d:	e8 46 09 00 00       	call   80105478 <release>
80104b32:	83 c4 10             	add    $0x10,%esp
        return pid;
80104b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b38:	eb 5b                	jmp    80104b95 <wait+0x157>
        continue;
80104b3a:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b3b:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104b42:	81 7d f4 94 5a 11 80 	cmpl   $0x80115a94,-0xc(%ebp)
80104b49:	0f 82 18 ff ff ff    	jb     80104a67 <wait+0x29>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104b4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b53:	74 0d                	je     80104b62 <wait+0x124>
80104b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5b:	8b 40 24             	mov    0x24(%eax),%eax
80104b5e:	85 c0                	test   %eax,%eax
80104b60:	74 17                	je     80104b79 <wait+0x13b>
      release(&ptable.lock);
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	68 60 29 11 80       	push   $0x80112960
80104b6a:	e8 09 09 00 00       	call   80105478 <release>
80104b6f:	83 c4 10             	add    $0x10,%esp
      return -1;
80104b72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b77:	eb 1c                	jmp    80104b95 <wait+0x157>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104b79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b7f:	83 ec 08             	sub    $0x8,%esp
80104b82:	68 60 29 11 80       	push   $0x80112960
80104b87:	50                   	push   %eax
80104b88:	e8 da 01 00 00       	call   80104d67 <sleep>
80104b8d:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b90:	e9 bf fe ff ff       	jmp    80104a54 <wait+0x16>
  }
}
80104b95:	c9                   	leave  
80104b96:	c3                   	ret    

80104b97 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104b97:	55                   	push   %ebp
80104b98:	89 e5                	mov    %esp,%ebp
80104b9a:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104b9d:	e8 91 f8 ff ff       	call   80104433 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ba2:	83 ec 0c             	sub    $0xc,%esp
80104ba5:	68 60 29 11 80       	push   $0x80112960
80104baa:	e8 62 08 00 00       	call   80105411 <acquire>
80104baf:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb2:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104bb9:	eb 66                	jmp    80104c21 <scheduler+0x8a>
      if(p->state != RUNNABLE)
80104bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbe:	8b 40 0c             	mov    0xc(%eax),%eax
80104bc1:	83 f8 03             	cmp    $0x3,%eax
80104bc4:	75 53                	jne    80104c19 <scheduler+0x82>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc9:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104bcf:	83 ec 0c             	sub    $0xc,%esp
80104bd2:	ff 75 f4             	push   -0xc(%ebp)
80104bd5:	e8 dd 39 00 00       	call   801085b7 <switchuvm>
80104bda:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be0:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104be7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bed:	8b 40 1c             	mov    0x1c(%eax),%eax
80104bf0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104bf7:	83 c2 04             	add    $0x4,%edx
80104bfa:	83 ec 08             	sub    $0x8,%esp
80104bfd:	50                   	push   %eax
80104bfe:	52                   	push   %edx
80104bff:	e8 e4 0c 00 00       	call   801058e8 <swtch>
80104c04:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104c07:	e8 8e 39 00 00       	call   8010859a <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104c0c:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104c13:	00 00 00 00 
80104c17:	eb 01                	jmp    80104c1a <scheduler+0x83>
        continue;
80104c19:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c1a:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104c21:	81 7d f4 94 5a 11 80 	cmpl   $0x80115a94,-0xc(%ebp)
80104c28:	72 91                	jb     80104bbb <scheduler+0x24>
    }
    release(&ptable.lock);
80104c2a:	83 ec 0c             	sub    $0xc,%esp
80104c2d:	68 60 29 11 80       	push   $0x80112960
80104c32:	e8 41 08 00 00       	call   80105478 <release>
80104c37:	83 c4 10             	add    $0x10,%esp
    sti();
80104c3a:	e9 5e ff ff ff       	jmp    80104b9d <scheduler+0x6>

80104c3f <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104c3f:	55                   	push   %ebp
80104c40:	89 e5                	mov    %esp,%ebp
80104c42:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104c45:	83 ec 0c             	sub    $0xc,%esp
80104c48:	68 60 29 11 80       	push   $0x80112960
80104c4d:	e8 f3 08 00 00       	call   80105545 <holding>
80104c52:	83 c4 10             	add    $0x10,%esp
80104c55:	85 c0                	test   %eax,%eax
80104c57:	75 0d                	jne    80104c66 <sched+0x27>
    panic("sched ptable.lock");
80104c59:	83 ec 0c             	sub    $0xc,%esp
80104c5c:	68 94 95 10 80       	push   $0x80109594
80104c61:	e8 15 b9 ff ff       	call   8010057b <panic>
  if(cpu->ncli != 1)
80104c66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c6c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c72:	83 f8 01             	cmp    $0x1,%eax
80104c75:	74 0d                	je     80104c84 <sched+0x45>
    panic("sched locks");
80104c77:	83 ec 0c             	sub    $0xc,%esp
80104c7a:	68 a6 95 10 80       	push   $0x801095a6
80104c7f:	e8 f7 b8 ff ff       	call   8010057b <panic>
  if(proc->state == RUNNING)
80104c84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c8a:	8b 40 0c             	mov    0xc(%eax),%eax
80104c8d:	83 f8 04             	cmp    $0x4,%eax
80104c90:	75 0d                	jne    80104c9f <sched+0x60>
    panic("sched running");
80104c92:	83 ec 0c             	sub    $0xc,%esp
80104c95:	68 b2 95 10 80       	push   $0x801095b2
80104c9a:	e8 dc b8 ff ff       	call   8010057b <panic>
  if(readeflags()&FL_IF)
80104c9f:	e8 7f f7 ff ff       	call   80104423 <readeflags>
80104ca4:	25 00 02 00 00       	and    $0x200,%eax
80104ca9:	85 c0                	test   %eax,%eax
80104cab:	74 0d                	je     80104cba <sched+0x7b>
    panic("sched interruptible");
80104cad:	83 ec 0c             	sub    $0xc,%esp
80104cb0:	68 c0 95 10 80       	push   $0x801095c0
80104cb5:	e8 c1 b8 ff ff       	call   8010057b <panic>
  intena = cpu->intena;
80104cba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cc0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104cc9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ccf:	8b 40 04             	mov    0x4(%eax),%eax
80104cd2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104cd9:	83 c2 1c             	add    $0x1c,%edx
80104cdc:	83 ec 08             	sub    $0x8,%esp
80104cdf:	50                   	push   %eax
80104ce0:	52                   	push   %edx
80104ce1:	e8 02 0c 00 00       	call   801058e8 <swtch>
80104ce6:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104ce9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cf2:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104cf8:	90                   	nop
80104cf9:	c9                   	leave  
80104cfa:	c3                   	ret    

80104cfb <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104cfb:	55                   	push   %ebp
80104cfc:	89 e5                	mov    %esp,%ebp
80104cfe:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104d01:	83 ec 0c             	sub    $0xc,%esp
80104d04:	68 60 29 11 80       	push   $0x80112960
80104d09:	e8 03 07 00 00       	call   80105411 <acquire>
80104d0e:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104d11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104d1e:	e8 1c ff ff ff       	call   80104c3f <sched>
  release(&ptable.lock);
80104d23:	83 ec 0c             	sub    $0xc,%esp
80104d26:	68 60 29 11 80       	push   $0x80112960
80104d2b:	e8 48 07 00 00       	call   80105478 <release>
80104d30:	83 c4 10             	add    $0x10,%esp
}
80104d33:	90                   	nop
80104d34:	c9                   	leave  
80104d35:	c3                   	ret    

80104d36 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d36:	55                   	push   %ebp
80104d37:	89 e5                	mov    %esp,%ebp
80104d39:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d3c:	83 ec 0c             	sub    $0xc,%esp
80104d3f:	68 60 29 11 80       	push   $0x80112960
80104d44:	e8 2f 07 00 00       	call   80105478 <release>
80104d49:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104d4c:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104d51:	85 c0                	test   %eax,%eax
80104d53:	74 0f                	je     80104d64 <forkret+0x2e>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104d55:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104d5c:	00 00 00 
    initlog();
80104d5f:	e8 a1 e5 ff ff       	call   80103305 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104d64:	90                   	nop
80104d65:	c9                   	leave  
80104d66:	c3                   	ret    

80104d67 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104d67:	55                   	push   %ebp
80104d68:	89 e5                	mov    %esp,%ebp
80104d6a:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104d6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d73:	85 c0                	test   %eax,%eax
80104d75:	75 0d                	jne    80104d84 <sleep+0x1d>
    panic("sleep");
80104d77:	83 ec 0c             	sub    $0xc,%esp
80104d7a:	68 d4 95 10 80       	push   $0x801095d4
80104d7f:	e8 f7 b7 ff ff       	call   8010057b <panic>

  if(lk == 0)
80104d84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104d88:	75 0d                	jne    80104d97 <sleep+0x30>
    panic("sleep without lk");
80104d8a:	83 ec 0c             	sub    $0xc,%esp
80104d8d:	68 da 95 10 80       	push   $0x801095da
80104d92:	e8 e4 b7 ff ff       	call   8010057b <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104d97:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104d9e:	74 1e                	je     80104dbe <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	68 60 29 11 80       	push   $0x80112960
80104da8:	e8 64 06 00 00       	call   80105411 <acquire>
80104dad:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	ff 75 0c             	push   0xc(%ebp)
80104db6:	e8 bd 06 00 00       	call   80105478 <release>
80104dbb:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104dbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc4:	8b 55 08             	mov    0x8(%ebp),%edx
80104dc7:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104dca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd0:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104dd7:	e8 63 fe ff ff       	call   80104c3f <sched>

  // Tidy up.
  proc->chan = 0;
80104ddc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104de9:	81 7d 0c 60 29 11 80 	cmpl   $0x80112960,0xc(%ebp)
80104df0:	74 1e                	je     80104e10 <sleep+0xa9>
    release(&ptable.lock);
80104df2:	83 ec 0c             	sub    $0xc,%esp
80104df5:	68 60 29 11 80       	push   $0x80112960
80104dfa:	e8 79 06 00 00       	call   80105478 <release>
80104dff:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104e02:	83 ec 0c             	sub    $0xc,%esp
80104e05:	ff 75 0c             	push   0xc(%ebp)
80104e08:	e8 04 06 00 00       	call   80105411 <acquire>
80104e0d:	83 c4 10             	add    $0x10,%esp
  }
}
80104e10:	90                   	nop
80104e11:	c9                   	leave  
80104e12:	c3                   	ret    

80104e13 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104e13:	55                   	push   %ebp
80104e14:	89 e5                	mov    %esp,%ebp
80104e16:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e19:	c7 45 fc 94 29 11 80 	movl   $0x80112994,-0x4(%ebp)
80104e20:	eb 27                	jmp    80104e49 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e25:	8b 40 0c             	mov    0xc(%eax),%eax
80104e28:	83 f8 02             	cmp    $0x2,%eax
80104e2b:	75 15                	jne    80104e42 <wakeup1+0x2f>
80104e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e30:	8b 40 20             	mov    0x20(%eax),%eax
80104e33:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e36:	75 0a                	jne    80104e42 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e3b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e42:	81 45 fc c4 00 00 00 	addl   $0xc4,-0x4(%ebp)
80104e49:	81 7d fc 94 5a 11 80 	cmpl   $0x80115a94,-0x4(%ebp)
80104e50:	72 d0                	jb     80104e22 <wakeup1+0xf>
}
80104e52:	90                   	nop
80104e53:	90                   	nop
80104e54:	c9                   	leave  
80104e55:	c3                   	ret    

80104e56 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104e56:	55                   	push   %ebp
80104e57:	89 e5                	mov    %esp,%ebp
80104e59:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104e5c:	83 ec 0c             	sub    $0xc,%esp
80104e5f:	68 60 29 11 80       	push   $0x80112960
80104e64:	e8 a8 05 00 00       	call   80105411 <acquire>
80104e69:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104e6c:	83 ec 0c             	sub    $0xc,%esp
80104e6f:	ff 75 08             	push   0x8(%ebp)
80104e72:	e8 9c ff ff ff       	call   80104e13 <wakeup1>
80104e77:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104e7a:	83 ec 0c             	sub    $0xc,%esp
80104e7d:	68 60 29 11 80       	push   $0x80112960
80104e82:	e8 f1 05 00 00       	call   80105478 <release>
80104e87:	83 c4 10             	add    $0x10,%esp
}
80104e8a:	90                   	nop
80104e8b:	c9                   	leave  
80104e8c:	c3                   	ret    

80104e8d <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104e8d:	55                   	push   %ebp
80104e8e:	89 e5                	mov    %esp,%ebp
80104e90:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104e93:	83 ec 0c             	sub    $0xc,%esp
80104e96:	68 60 29 11 80       	push   $0x80112960
80104e9b:	e8 71 05 00 00       	call   80105411 <acquire>
80104ea0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ea3:	c7 45 f4 94 29 11 80 	movl   $0x80112994,-0xc(%ebp)
80104eaa:	eb 48                	jmp    80104ef4 <kill+0x67>
    if(p->pid == pid){
80104eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eaf:	8b 40 10             	mov    0x10(%eax),%eax
80104eb2:	39 45 08             	cmp    %eax,0x8(%ebp)
80104eb5:	75 36                	jne    80104eed <kill+0x60>
      p->killed = 1;
80104eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eba:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ec7:	83 f8 02             	cmp    $0x2,%eax
80104eca:	75 0a                	jne    80104ed6 <kill+0x49>
        p->state = RUNNABLE;
80104ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ecf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104ed6:	83 ec 0c             	sub    $0xc,%esp
80104ed9:	68 60 29 11 80       	push   $0x80112960
80104ede:	e8 95 05 00 00       	call   80105478 <release>
80104ee3:	83 c4 10             	add    $0x10,%esp
      return 0;
80104ee6:	b8 00 00 00 00       	mov    $0x0,%eax
80104eeb:	eb 25                	jmp    80104f12 <kill+0x85>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eed:	81 45 f4 c4 00 00 00 	addl   $0xc4,-0xc(%ebp)
80104ef4:	81 7d f4 94 5a 11 80 	cmpl   $0x80115a94,-0xc(%ebp)
80104efb:	72 af                	jb     80104eac <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104efd:	83 ec 0c             	sub    $0xc,%esp
80104f00:	68 60 29 11 80       	push   $0x80112960
80104f05:	e8 6e 05 00 00       	call   80105478 <release>
80104f0a:	83 c4 10             	add    $0x10,%esp
  return -1;
80104f0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f12:	c9                   	leave  
80104f13:	c3                   	ret    

80104f14 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f1a:	c7 45 f0 94 29 11 80 	movl   $0x80112994,-0x10(%ebp)
80104f21:	e9 da 00 00 00       	jmp    80105000 <procdump+0xec>
    if(p->state == UNUSED)
80104f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f29:	8b 40 0c             	mov    0xc(%eax),%eax
80104f2c:	85 c0                	test   %eax,%eax
80104f2e:	0f 84 c4 00 00 00    	je     80104ff8 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f37:	8b 40 0c             	mov    0xc(%eax),%eax
80104f3a:	83 f8 05             	cmp    $0x5,%eax
80104f3d:	77 23                	ja     80104f62 <procdump+0x4e>
80104f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f42:	8b 40 0c             	mov    0xc(%eax),%eax
80104f45:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104f4c:	85 c0                	test   %eax,%eax
80104f4e:	74 12                	je     80104f62 <procdump+0x4e>
      state = states[p->state];
80104f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f53:	8b 40 0c             	mov    0xc(%eax),%eax
80104f56:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80104f5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f60:	eb 07                	jmp    80104f69 <procdump+0x55>
    else
      state = "???";
80104f62:	c7 45 ec eb 95 10 80 	movl   $0x801095eb,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f6c:	8d 50 6c             	lea    0x6c(%eax),%edx
80104f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f72:	8b 40 10             	mov    0x10(%eax),%eax
80104f75:	52                   	push   %edx
80104f76:	ff 75 ec             	push   -0x14(%ebp)
80104f79:	50                   	push   %eax
80104f7a:	68 ef 95 10 80       	push   $0x801095ef
80104f7f:	e8 42 b4 ff ff       	call   801003c6 <cprintf>
80104f84:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f8a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f8d:	83 f8 02             	cmp    $0x2,%eax
80104f90:	75 54                	jne    80104fe6 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f95:	8b 40 1c             	mov    0x1c(%eax),%eax
80104f98:	8b 40 0c             	mov    0xc(%eax),%eax
80104f9b:	83 c0 08             	add    $0x8,%eax
80104f9e:	89 c2                	mov    %eax,%edx
80104fa0:	83 ec 08             	sub    $0x8,%esp
80104fa3:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104fa6:	50                   	push   %eax
80104fa7:	52                   	push   %edx
80104fa8:	e8 1d 05 00 00       	call   801054ca <getcallerpcs>
80104fad:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104fb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104fb7:	eb 1c                	jmp    80104fd5 <procdump+0xc1>
        cprintf(" %p", pc[i]);
80104fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbc:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	50                   	push   %eax
80104fc4:	68 f8 95 10 80       	push   $0x801095f8
80104fc9:	e8 f8 b3 ff ff       	call   801003c6 <cprintf>
80104fce:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104fd1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104fd5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104fd9:	7f 0b                	jg     80104fe6 <procdump+0xd2>
80104fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fde:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104fe2:	85 c0                	test   %eax,%eax
80104fe4:	75 d3                	jne    80104fb9 <procdump+0xa5>
    }
    cprintf("\n");
80104fe6:	83 ec 0c             	sub    $0xc,%esp
80104fe9:	68 fc 95 10 80       	push   $0x801095fc
80104fee:	e8 d3 b3 ff ff       	call   801003c6 <cprintf>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	eb 01                	jmp    80104ff9 <procdump+0xe5>
      continue;
80104ff8:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ff9:	81 45 f0 c4 00 00 00 	addl   $0xc4,-0x10(%ebp)
80105000:	81 7d f0 94 5a 11 80 	cmpl   $0x80115a94,-0x10(%ebp)
80105007:	0f 82 19 ff ff ff    	jb     80104f26 <procdump+0x12>
  }
}
8010500d:	90                   	nop
8010500e:	90                   	nop
8010500f:	c9                   	leave  
80105010:	c3                   	ret    

80105011 <signal_deliver>:

void signal_deliver(int signum, siginfo_t info)
{
80105011:	55                   	push   %ebp
80105012:	89 e5                	mov    %esp,%ebp
80105014:	83 ec 10             	sub    $0x10,%esp
  uint old_eip = proc->tf->eip;
80105017:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010501d:	8b 40 18             	mov    0x18(%eax),%eax
80105020:	8b 40 38             	mov    0x38(%eax),%eax
80105023:	89 45 fc             	mov    %eax,-0x4(%ebp)
  // cprintf("tf->eip: %d\n", old_eip);

  *((uint*)(proc->tf->esp - 4))  = (uint) old_eip;    // real return address
80105026:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010502c:	8b 40 18             	mov    0x18(%eax),%eax
8010502f:	8b 40 44             	mov    0x44(%eax),%eax
80105032:	83 e8 04             	sub    $0x4,%eax
80105035:	89 c2                	mov    %eax,%edx
80105037:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010503a:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 8))  = proc->tf->eax;     // eax
8010503c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105042:	8b 40 18             	mov    0x18(%eax),%eax
80105045:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010504c:	8b 52 18             	mov    0x18(%edx),%edx
8010504f:	8b 52 44             	mov    0x44(%edx),%edx
80105052:	83 ea 08             	sub    $0x8,%edx
80105055:	8b 40 1c             	mov    0x1c(%eax),%eax
80105058:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 12)) = proc->tf->ecx;     // ecx
8010505a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105060:	8b 40 18             	mov    0x18(%eax),%eax
80105063:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010506a:	8b 52 18             	mov    0x18(%edx),%edx
8010506d:	8b 52 44             	mov    0x44(%edx),%edx
80105070:	83 ea 0c             	sub    $0xc,%edx
80105073:	8b 40 18             	mov    0x18(%eax),%eax
80105076:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 16)) = proc->tf->edx;     // edx
80105078:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010507e:	8b 40 18             	mov    0x18(%eax),%eax
80105081:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105088:	8b 52 18             	mov    0x18(%edx),%edx
8010508b:	8b 52 44             	mov    0x44(%edx),%edx
8010508e:	83 ea 10             	sub    $0x10,%edx
80105091:	8b 40 14             	mov    0x14(%eax),%eax
80105094:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 20)) = info.type;     // push info.type
80105096:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010509c:	8b 40 18             	mov    0x18(%eax),%eax
8010509f:	8b 40 44             	mov    0x44(%eax),%eax
801050a2:	83 e8 14             	sub    $0x14,%eax
801050a5:	89 c2                	mov    %eax,%edx
801050a7:	8b 45 10             	mov    0x10(%ebp),%eax
801050aa:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 24)) = info.addr;     // push info.addr
801050ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050b2:	8b 40 18             	mov    0x18(%eax),%eax
801050b5:	8b 40 44             	mov    0x44(%eax),%eax
801050b8:	83 e8 18             	sub    $0x18,%eax
801050bb:	89 c2                	mov    %eax,%edx
801050bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801050c0:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 28)) = (uint) signum;     // signal number
801050c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c8:	8b 40 18             	mov    0x18(%eax),%eax
801050cb:	8b 40 44             	mov    0x44(%eax),%eax
801050ce:	83 e8 1c             	sub    $0x1c,%eax
801050d1:	89 c2                	mov    %eax,%edx
801050d3:	8b 45 08             	mov    0x8(%ebp),%eax
801050d6:	89 02                	mov    %eax,(%edx)
  *((uint*)(proc->tf->esp - 32)) = proc->restorer_addr; // address of restorer
801050d8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050de:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050e5:	8b 52 18             	mov    0x18(%edx),%edx
801050e8:	8b 52 44             	mov    0x44(%edx),%edx
801050eb:	83 ea 20             	sub    $0x20,%edx
801050ee:	8b 80 b8 00 00 00    	mov    0xb8(%eax),%eax
801050f4:	89 02                	mov    %eax,(%edx)
  proc->tf->esp -= 32;
801050f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050fc:	8b 40 18             	mov    0x18(%eax),%eax
801050ff:	8b 50 44             	mov    0x44(%eax),%edx
80105102:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105108:	8b 40 18             	mov    0x18(%eax),%eax
8010510b:	83 ea 20             	sub    $0x20,%edx
8010510e:	89 50 44             	mov    %edx,0x44(%eax)
  proc->tf->eip = (uint) proc->handlers[signum];
80105111:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105117:	8b 55 08             	mov    0x8(%ebp),%edx
8010511a:	83 c2 1c             	add    $0x1c,%edx
8010511d:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80105121:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105127:	8b 40 18             	mov    0x18(%eax),%eax
8010512a:	89 50 38             	mov    %edx,0x38(%eax)
}
8010512d:	90                   	nop
8010512e:	c9                   	leave  
8010512f:	c3                   	ret    

80105130 <signal_register_handler>:

sighandler_t signal_register_handler(int signum, sighandler_t handler)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 18             	sub    $0x18,%esp
	if (!proc)
80105136:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513c:	85 c0                	test   %eax,%eax
8010513e:	75 07                	jne    80105147 <signal_register_handler+0x17>
		return (sighandler_t) -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105145:	eb 5d                	jmp    801051a4 <signal_register_handler+0x74>

	sighandler_t previous = proc->handlers[signum];
80105147:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514d:	8b 55 08             	mov    0x8(%ebp),%edx
80105150:	83 c2 1c             	add    $0x1c,%edx
80105153:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105157:	89 45 f4             	mov    %eax,-0xc(%ebp)

  cprintf("In register handler, signum: %d\n", signum);
8010515a:	83 ec 08             	sub    $0x8,%esp
8010515d:	ff 75 08             	push   0x8(%ebp)
80105160:	68 00 96 10 80       	push   $0x80109600
80105165:	e8 5c b2 ff ff       	call   801003c6 <cprintf>
8010516a:	83 c4 10             	add    $0x10,%esp

	proc->handlers[signum] = handler;
8010516d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105173:	8b 55 08             	mov    0x8(%ebp),%edx
80105176:	8d 4a 1c             	lea    0x1c(%edx),%ecx
80105179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010517c:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
  cprintf("handler addr: %d\n", proc->handlers[signum]);
80105180:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105186:	8b 55 08             	mov    0x8(%ebp),%edx
80105189:	83 c2 1c             	add    $0x1c,%edx
8010518c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105190:	83 ec 08             	sub    $0x8,%esp
80105193:	50                   	push   %eax
80105194:	68 21 96 10 80       	push   $0x80109621
80105199:	e8 28 b2 ff ff       	call   801003c6 <cprintf>
8010519e:	83 c4 10             	add    $0x10,%esp

	return previous;
801051a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801051a4:	c9                   	leave  
801051a5:	c3                   	ret    

801051a6 <cowfork>:

int
cowfork(void)
{
801051a6:	55                   	push   %ebp
801051a7:	89 e5                	mov    %esp,%ebp
801051a9:	57                   	push   %edi
801051aa:	56                   	push   %esi
801051ab:	53                   	push   %ebx
801051ac:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801051af:	e8 a4 f2 ff ff       	call   80104458 <allocproc>
801051b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801051b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801051bb:	75 0a                	jne    801051c7 <cowfork+0x21>
    return -1;
801051bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c2:	e9 81 01 00 00       	jmp    80105348 <cowfork+0x1a2>

  // Copy process state from p.
  if((np->pgdir = cowmapuvm(proc->pgdir, proc->sz)) == 0){
801051c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051cd:	8b 10                	mov    (%eax),%edx
801051cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051d5:	8b 40 04             	mov    0x4(%eax),%eax
801051d8:	83 ec 08             	sub    $0x8,%esp
801051db:	52                   	push   %edx
801051dc:	50                   	push   %eax
801051dd:	e8 de 3b 00 00       	call   80108dc0 <cowmapuvm>
801051e2:	83 c4 10             	add    $0x10,%esp
801051e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
801051e8:	89 42 04             	mov    %eax,0x4(%edx)
801051eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051ee:	8b 40 04             	mov    0x4(%eax),%eax
801051f1:	85 c0                	test   %eax,%eax
801051f3:	75 30                	jne    80105225 <cowfork+0x7f>
    kfree(np->kstack);
801051f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051f8:	8b 40 08             	mov    0x8(%eax),%eax
801051fb:	83 ec 0c             	sub    $0xc,%esp
801051fe:	50                   	push   %eax
801051ff:	e8 43 d9 ff ff       	call   80102b47 <kfree>
80105204:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80105207:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010520a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80105211:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105214:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010521b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105220:	e9 23 01 00 00       	jmp    80105348 <cowfork+0x1a2>
  }
  np->sz = proc->sz;
80105225:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522b:	8b 10                	mov    (%eax),%edx
8010522d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105230:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80105232:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105239:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010523c:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010523f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105245:	8b 48 18             	mov    0x18(%eax),%ecx
80105248:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010524b:	8b 40 18             	mov    0x18(%eax),%eax
8010524e:	89 c2                	mov    %eax,%edx
80105250:	89 cb                	mov    %ecx,%ebx
80105252:	b8 13 00 00 00       	mov    $0x13,%eax
80105257:	89 d7                	mov    %edx,%edi
80105259:	89 de                	mov    %ebx,%esi
8010525b:	89 c1                	mov    %eax,%ecx
8010525d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010525f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105262:	8b 40 18             	mov    0x18(%eax),%eax
80105265:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  // set the shared flag to 1
  proc->shared = 1;
8010526c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105272:	c7 80 bc 00 00 00 01 	movl   $0x1,0xbc(%eax)
80105279:	00 00 00 
  np->shared = 1;
8010527c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010527f:	c7 80 bc 00 00 00 01 	movl   $0x1,0xbc(%eax)
80105286:	00 00 00 

  for(i = 0; i < NOFILE; i++)
80105289:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80105290:	eb 41                	jmp    801052d3 <cowfork+0x12d>
    if(proc->ofile[i])
80105292:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105298:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010529b:	83 c2 08             	add    $0x8,%edx
8010529e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801052a2:	85 c0                	test   %eax,%eax
801052a4:	74 29                	je     801052cf <cowfork+0x129>
      np->ofile[i] = filedup(proc->ofile[i]);
801052a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801052af:	83 c2 08             	add    $0x8,%edx
801052b2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801052b6:	83 ec 0c             	sub    $0xc,%esp
801052b9:	50                   	push   %eax
801052ba:	e8 4f bd ff ff       	call   8010100e <filedup>
801052bf:	83 c4 10             	add    $0x10,%esp
801052c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
801052c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801052c8:	83 c1 08             	add    $0x8,%ecx
801052cb:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801052cf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801052d3:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801052d7:	7e b9                	jle    80105292 <cowfork+0xec>
  np->cwd = idup(proc->cwd);
801052d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052df:	8b 40 68             	mov    0x68(%eax),%eax
801052e2:	83 ec 0c             	sub    $0xc,%esp
801052e5:	50                   	push   %eax
801052e6:	e8 0f c6 ff ff       	call   801018fa <idup>
801052eb:	83 c4 10             	add    $0x10,%esp
801052ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
801052f1:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
801052f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052fa:	8d 50 6c             	lea    0x6c(%eax),%edx
801052fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105300:	83 c0 6c             	add    $0x6c,%eax
80105303:	83 ec 04             	sub    $0x4,%esp
80105306:	6a 10                	push   $0x10
80105308:	52                   	push   %edx
80105309:	50                   	push   %eax
8010530a:	e8 68 05 00 00       	call   80105877 <safestrcpy>
8010530f:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80105312:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105315:	8b 40 10             	mov    0x10(%eax),%eax
80105318:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
8010531b:	83 ec 0c             	sub    $0xc,%esp
8010531e:	68 60 29 11 80       	push   $0x80112960
80105323:	e8 e9 00 00 00       	call   80105411 <acquire>
80105328:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010532b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010532e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	68 60 29 11 80       	push   $0x80112960
8010533d:	e8 36 01 00 00       	call   80105478 <release>
80105342:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80105345:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80105348:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010534b:	5b                   	pop    %ebx
8010534c:	5e                   	pop    %esi
8010534d:	5f                   	pop    %edi
8010534e:	5d                   	pop    %ebp
8010534f:	c3                   	ret    

80105350 <dgrowproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
dgrowproc(int n)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80105356:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010535c:	8b 00                	mov    (%eax),%eax
8010535e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80105361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105365:	7e 27                	jle    8010538e <dgrowproc+0x3e>
    if((sz = dchangesize(sz, sz + n)) == 0)
80105367:	8b 55 08             	mov    0x8(%ebp),%edx
8010536a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536d:	01 d0                	add    %edx,%eax
8010536f:	83 ec 08             	sub    $0x8,%esp
80105372:	50                   	push   %eax
80105373:	ff 75 f4             	push   -0xc(%ebp)
80105376:	e8 b2 3e 00 00       	call   8010922d <dchangesize>
8010537b:	83 c4 10             	add    $0x10,%esp
8010537e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105385:	75 1e                	jne    801053a5 <dgrowproc+0x55>
      return -1;
80105387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538c:	eb 27                	jmp    801053b5 <dgrowproc+0x65>
  } 
  else {
    cprintf("Could not use dsbrk with inpositive size!\n");
8010538e:	83 ec 0c             	sub    $0xc,%esp
80105391:	68 34 96 10 80       	push   $0x80109634
80105396:	e8 2b b0 ff ff       	call   801003c6 <cprintf>
8010539b:	83 c4 10             	add    $0x10,%esp
    return -1;
8010539e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053a3:	eb 10                	jmp    801053b5 <dgrowproc+0x65>
  }
  proc->sz = sz;
801053a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ae:	89 10                	mov    %edx,(%eax)
  return 0;
801053b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    

801053b7 <readeflags>:
{
801053b7:	55                   	push   %ebp
801053b8:	89 e5                	mov    %esp,%ebp
801053ba:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801053bd:	9c                   	pushf  
801053be:	58                   	pop    %eax
801053bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801053c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053c5:	c9                   	leave  
801053c6:	c3                   	ret    

801053c7 <cli>:
{
801053c7:	55                   	push   %ebp
801053c8:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801053ca:	fa                   	cli    
}
801053cb:	90                   	nop
801053cc:	5d                   	pop    %ebp
801053cd:	c3                   	ret    

801053ce <sti>:
{
801053ce:	55                   	push   %ebp
801053cf:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801053d1:	fb                   	sti    
}
801053d2:	90                   	nop
801053d3:	5d                   	pop    %ebp
801053d4:	c3                   	ret    

801053d5 <xchg>:
{
801053d5:	55                   	push   %ebp
801053d6:	89 e5                	mov    %esp,%ebp
801053d8:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
801053db:	8b 55 08             	mov    0x8(%ebp),%edx
801053de:	8b 45 0c             	mov    0xc(%ebp),%eax
801053e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053e4:	f0 87 02             	lock xchg %eax,(%edx)
801053e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801053ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053ed:	c9                   	leave  
801053ee:	c3                   	ret    

801053ef <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801053ef:	55                   	push   %ebp
801053f0:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801053f2:	8b 45 08             	mov    0x8(%ebp),%eax
801053f5:	8b 55 0c             	mov    0xc(%ebp),%edx
801053f8:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801053fb:	8b 45 08             	mov    0x8(%ebp),%eax
801053fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105404:	8b 45 08             	mov    0x8(%ebp),%eax
80105407:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010540e:	90                   	nop
8010540f:	5d                   	pop    %ebp
80105410:	c3                   	ret    

80105411 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105411:	55                   	push   %ebp
80105412:	89 e5                	mov    %esp,%ebp
80105414:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105417:	e8 53 01 00 00       	call   8010556f <pushcli>
  if(holding(lk))
8010541c:	8b 45 08             	mov    0x8(%ebp),%eax
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	50                   	push   %eax
80105423:	e8 1d 01 00 00       	call   80105545 <holding>
80105428:	83 c4 10             	add    $0x10,%esp
8010542b:	85 c0                	test   %eax,%eax
8010542d:	74 0d                	je     8010543c <acquire+0x2b>
    panic("acquire");
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	68 89 96 10 80       	push   $0x80109689
80105437:	e8 3f b1 ff ff       	call   8010057b <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010543c:	90                   	nop
8010543d:	8b 45 08             	mov    0x8(%ebp),%eax
80105440:	83 ec 08             	sub    $0x8,%esp
80105443:	6a 01                	push   $0x1
80105445:	50                   	push   %eax
80105446:	e8 8a ff ff ff       	call   801053d5 <xchg>
8010544b:	83 c4 10             	add    $0x10,%esp
8010544e:	85 c0                	test   %eax,%eax
80105450:	75 eb                	jne    8010543d <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105452:	8b 45 08             	mov    0x8(%ebp),%eax
80105455:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010545c:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010545f:	8b 45 08             	mov    0x8(%ebp),%eax
80105462:	83 c0 0c             	add    $0xc,%eax
80105465:	83 ec 08             	sub    $0x8,%esp
80105468:	50                   	push   %eax
80105469:	8d 45 08             	lea    0x8(%ebp),%eax
8010546c:	50                   	push   %eax
8010546d:	e8 58 00 00 00       	call   801054ca <getcallerpcs>
80105472:	83 c4 10             	add    $0x10,%esp
}
80105475:	90                   	nop
80105476:	c9                   	leave  
80105477:	c3                   	ret    

80105478 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105478:	55                   	push   %ebp
80105479:	89 e5                	mov    %esp,%ebp
8010547b:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010547e:	83 ec 0c             	sub    $0xc,%esp
80105481:	ff 75 08             	push   0x8(%ebp)
80105484:	e8 bc 00 00 00       	call   80105545 <holding>
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	85 c0                	test   %eax,%eax
8010548e:	75 0d                	jne    8010549d <release+0x25>
    panic("release");
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	68 91 96 10 80       	push   $0x80109691
80105498:	e8 de b0 ff ff       	call   8010057b <panic>

  lk->pcs[0] = 0;
8010549d:	8b 45 08             	mov    0x8(%ebp),%eax
801054a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801054a7:	8b 45 08             	mov    0x8(%ebp),%eax
801054aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801054b1:	8b 45 08             	mov    0x8(%ebp),%eax
801054b4:	83 ec 08             	sub    $0x8,%esp
801054b7:	6a 00                	push   $0x0
801054b9:	50                   	push   %eax
801054ba:	e8 16 ff ff ff       	call   801053d5 <xchg>
801054bf:	83 c4 10             	add    $0x10,%esp

  popcli();
801054c2:	e8 ec 00 00 00       	call   801055b3 <popcli>
}
801054c7:	90                   	nop
801054c8:	c9                   	leave  
801054c9:	c3                   	ret    

801054ca <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801054ca:	55                   	push   %ebp
801054cb:	89 e5                	mov    %esp,%ebp
801054cd:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801054d0:	8b 45 08             	mov    0x8(%ebp),%eax
801054d3:	83 e8 08             	sub    $0x8,%eax
801054d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801054d9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801054e0:	eb 38                	jmp    8010551a <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801054e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801054e6:	74 53                	je     8010553b <getcallerpcs+0x71>
801054e8:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801054ef:	76 4a                	jbe    8010553b <getcallerpcs+0x71>
801054f1:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801054f5:	74 44                	je     8010553b <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801054f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801054fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105501:	8b 45 0c             	mov    0xc(%ebp),%eax
80105504:	01 c2                	add    %eax,%edx
80105506:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105509:	8b 40 04             	mov    0x4(%eax),%eax
8010550c:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010550e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105511:	8b 00                	mov    (%eax),%eax
80105513:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105516:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010551a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010551e:	7e c2                	jle    801054e2 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105520:	eb 19                	jmp    8010553b <getcallerpcs+0x71>
    pcs[i] = 0;
80105522:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105525:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010552c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010552f:	01 d0                	add    %edx,%eax
80105531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105537:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010553b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010553f:	7e e1                	jle    80105522 <getcallerpcs+0x58>
}
80105541:	90                   	nop
80105542:	90                   	nop
80105543:	c9                   	leave  
80105544:	c3                   	ret    

80105545 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105545:	55                   	push   %ebp
80105546:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105548:	8b 45 08             	mov    0x8(%ebp),%eax
8010554b:	8b 00                	mov    (%eax),%eax
8010554d:	85 c0                	test   %eax,%eax
8010554f:	74 17                	je     80105568 <holding+0x23>
80105551:	8b 45 08             	mov    0x8(%ebp),%eax
80105554:	8b 50 08             	mov    0x8(%eax),%edx
80105557:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010555d:	39 c2                	cmp    %eax,%edx
8010555f:	75 07                	jne    80105568 <holding+0x23>
80105561:	b8 01 00 00 00       	mov    $0x1,%eax
80105566:	eb 05                	jmp    8010556d <holding+0x28>
80105568:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010556d:	5d                   	pop    %ebp
8010556e:	c3                   	ret    

8010556f <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010556f:	55                   	push   %ebp
80105570:	89 e5                	mov    %esp,%ebp
80105572:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105575:	e8 3d fe ff ff       	call   801053b7 <readeflags>
8010557a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010557d:	e8 45 fe ff ff       	call   801053c7 <cli>
  if(cpu->ncli++ == 0)
80105582:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105588:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010558e:	8d 4a 01             	lea    0x1(%edx),%ecx
80105591:	89 88 ac 00 00 00    	mov    %ecx,0xac(%eax)
80105597:	85 d2                	test   %edx,%edx
80105599:	75 15                	jne    801055b0 <pushcli+0x41>
    cpu->intena = eflags & FL_IF;
8010559b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801055a4:	81 e2 00 02 00 00    	and    $0x200,%edx
801055aa:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801055b0:	90                   	nop
801055b1:	c9                   	leave  
801055b2:	c3                   	ret    

801055b3 <popcli>:

void
popcli(void)
{
801055b3:	55                   	push   %ebp
801055b4:	89 e5                	mov    %esp,%ebp
801055b6:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801055b9:	e8 f9 fd ff ff       	call   801053b7 <readeflags>
801055be:	25 00 02 00 00       	and    $0x200,%eax
801055c3:	85 c0                	test   %eax,%eax
801055c5:	74 0d                	je     801055d4 <popcli+0x21>
    panic("popcli - interruptible");
801055c7:	83 ec 0c             	sub    $0xc,%esp
801055ca:	68 99 96 10 80       	push   $0x80109699
801055cf:	e8 a7 af ff ff       	call   8010057b <panic>
  if(--cpu->ncli < 0)
801055d4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055da:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801055e0:	83 ea 01             	sub    $0x1,%edx
801055e3:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801055e9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055ef:	85 c0                	test   %eax,%eax
801055f1:	79 0d                	jns    80105600 <popcli+0x4d>
    panic("popcli");
801055f3:	83 ec 0c             	sub    $0xc,%esp
801055f6:	68 b0 96 10 80       	push   $0x801096b0
801055fb:	e8 7b af ff ff       	call   8010057b <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105600:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105606:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010560c:	85 c0                	test   %eax,%eax
8010560e:	75 15                	jne    80105625 <popcli+0x72>
80105610:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105616:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010561c:	85 c0                	test   %eax,%eax
8010561e:	74 05                	je     80105625 <popcli+0x72>
    sti();
80105620:	e8 a9 fd ff ff       	call   801053ce <sti>
}
80105625:	90                   	nop
80105626:	c9                   	leave  
80105627:	c3                   	ret    

80105628 <stosb>:
{
80105628:	55                   	push   %ebp
80105629:	89 e5                	mov    %esp,%ebp
8010562b:	57                   	push   %edi
8010562c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010562d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105630:	8b 55 10             	mov    0x10(%ebp),%edx
80105633:	8b 45 0c             	mov    0xc(%ebp),%eax
80105636:	89 cb                	mov    %ecx,%ebx
80105638:	89 df                	mov    %ebx,%edi
8010563a:	89 d1                	mov    %edx,%ecx
8010563c:	fc                   	cld    
8010563d:	f3 aa                	rep stos %al,%es:(%edi)
8010563f:	89 ca                	mov    %ecx,%edx
80105641:	89 fb                	mov    %edi,%ebx
80105643:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105646:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105649:	90                   	nop
8010564a:	5b                   	pop    %ebx
8010564b:	5f                   	pop    %edi
8010564c:	5d                   	pop    %ebp
8010564d:	c3                   	ret    

8010564e <stosl>:
{
8010564e:	55                   	push   %ebp
8010564f:	89 e5                	mov    %esp,%ebp
80105651:	57                   	push   %edi
80105652:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105653:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105656:	8b 55 10             	mov    0x10(%ebp),%edx
80105659:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565c:	89 cb                	mov    %ecx,%ebx
8010565e:	89 df                	mov    %ebx,%edi
80105660:	89 d1                	mov    %edx,%ecx
80105662:	fc                   	cld    
80105663:	f3 ab                	rep stos %eax,%es:(%edi)
80105665:	89 ca                	mov    %ecx,%edx
80105667:	89 fb                	mov    %edi,%ebx
80105669:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010566c:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010566f:	90                   	nop
80105670:	5b                   	pop    %ebx
80105671:	5f                   	pop    %edi
80105672:	5d                   	pop    %ebp
80105673:	c3                   	ret    

80105674 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105674:	55                   	push   %ebp
80105675:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105677:	8b 45 08             	mov    0x8(%ebp),%eax
8010567a:	83 e0 03             	and    $0x3,%eax
8010567d:	85 c0                	test   %eax,%eax
8010567f:	75 43                	jne    801056c4 <memset+0x50>
80105681:	8b 45 10             	mov    0x10(%ebp),%eax
80105684:	83 e0 03             	and    $0x3,%eax
80105687:	85 c0                	test   %eax,%eax
80105689:	75 39                	jne    801056c4 <memset+0x50>
    c &= 0xFF;
8010568b:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105692:	8b 45 10             	mov    0x10(%ebp),%eax
80105695:	c1 e8 02             	shr    $0x2,%eax
80105698:	89 c2                	mov    %eax,%edx
8010569a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010569d:	c1 e0 18             	shl    $0x18,%eax
801056a0:	89 c1                	mov    %eax,%ecx
801056a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a5:	c1 e0 10             	shl    $0x10,%eax
801056a8:	09 c1                	or     %eax,%ecx
801056aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ad:	c1 e0 08             	shl    $0x8,%eax
801056b0:	09 c8                	or     %ecx,%eax
801056b2:	0b 45 0c             	or     0xc(%ebp),%eax
801056b5:	52                   	push   %edx
801056b6:	50                   	push   %eax
801056b7:	ff 75 08             	push   0x8(%ebp)
801056ba:	e8 8f ff ff ff       	call   8010564e <stosl>
801056bf:	83 c4 0c             	add    $0xc,%esp
801056c2:	eb 12                	jmp    801056d6 <memset+0x62>
  } else
    stosb(dst, c, n);
801056c4:	8b 45 10             	mov    0x10(%ebp),%eax
801056c7:	50                   	push   %eax
801056c8:	ff 75 0c             	push   0xc(%ebp)
801056cb:	ff 75 08             	push   0x8(%ebp)
801056ce:	e8 55 ff ff ff       	call   80105628 <stosb>
801056d3:	83 c4 0c             	add    $0xc,%esp
  return dst;
801056d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801056d9:	c9                   	leave  
801056da:	c3                   	ret    

801056db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801056db:	55                   	push   %ebp
801056dc:	89 e5                	mov    %esp,%ebp
801056de:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801056e1:	8b 45 08             	mov    0x8(%ebp),%eax
801056e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801056e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801056ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801056ed:	eb 30                	jmp    8010571f <memcmp+0x44>
    if(*s1 != *s2)
801056ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056f2:	0f b6 10             	movzbl (%eax),%edx
801056f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056f8:	0f b6 00             	movzbl (%eax),%eax
801056fb:	38 c2                	cmp    %al,%dl
801056fd:	74 18                	je     80105717 <memcmp+0x3c>
      return *s1 - *s2;
801056ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105702:	0f b6 00             	movzbl (%eax),%eax
80105705:	0f b6 d0             	movzbl %al,%edx
80105708:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010570b:	0f b6 00             	movzbl (%eax),%eax
8010570e:	0f b6 c8             	movzbl %al,%ecx
80105711:	89 d0                	mov    %edx,%eax
80105713:	29 c8                	sub    %ecx,%eax
80105715:	eb 1a                	jmp    80105731 <memcmp+0x56>
    s1++, s2++;
80105717:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010571b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
8010571f:	8b 45 10             	mov    0x10(%ebp),%eax
80105722:	8d 50 ff             	lea    -0x1(%eax),%edx
80105725:	89 55 10             	mov    %edx,0x10(%ebp)
80105728:	85 c0                	test   %eax,%eax
8010572a:	75 c3                	jne    801056ef <memcmp+0x14>
  }

  return 0;
8010572c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105731:	c9                   	leave  
80105732:	c3                   	ret    

80105733 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105733:	55                   	push   %ebp
80105734:	89 e5                	mov    %esp,%ebp
80105736:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105739:	8b 45 0c             	mov    0xc(%ebp),%eax
8010573c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010573f:	8b 45 08             	mov    0x8(%ebp),%eax
80105742:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105745:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105748:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010574b:	73 54                	jae    801057a1 <memmove+0x6e>
8010574d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105750:	8b 45 10             	mov    0x10(%ebp),%eax
80105753:	01 d0                	add    %edx,%eax
80105755:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105758:	73 47                	jae    801057a1 <memmove+0x6e>
    s += n;
8010575a:	8b 45 10             	mov    0x10(%ebp),%eax
8010575d:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105760:	8b 45 10             	mov    0x10(%ebp),%eax
80105763:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105766:	eb 13                	jmp    8010577b <memmove+0x48>
      *--d = *--s;
80105768:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010576c:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105770:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105773:	0f b6 10             	movzbl (%eax),%edx
80105776:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105779:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010577b:	8b 45 10             	mov    0x10(%ebp),%eax
8010577e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105781:	89 55 10             	mov    %edx,0x10(%ebp)
80105784:	85 c0                	test   %eax,%eax
80105786:	75 e0                	jne    80105768 <memmove+0x35>
  if(s < d && s + n > d){
80105788:	eb 24                	jmp    801057ae <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
8010578a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010578d:	8d 42 01             	lea    0x1(%edx),%eax
80105790:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105793:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105796:	8d 48 01             	lea    0x1(%eax),%ecx
80105799:	89 4d f8             	mov    %ecx,-0x8(%ebp)
8010579c:	0f b6 12             	movzbl (%edx),%edx
8010579f:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801057a1:	8b 45 10             	mov    0x10(%ebp),%eax
801057a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801057a7:	89 55 10             	mov    %edx,0x10(%ebp)
801057aa:	85 c0                	test   %eax,%eax
801057ac:	75 dc                	jne    8010578a <memmove+0x57>

  return dst;
801057ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
801057b1:	c9                   	leave  
801057b2:	c3                   	ret    

801057b3 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801057b3:	55                   	push   %ebp
801057b4:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801057b6:	ff 75 10             	push   0x10(%ebp)
801057b9:	ff 75 0c             	push   0xc(%ebp)
801057bc:	ff 75 08             	push   0x8(%ebp)
801057bf:	e8 6f ff ff ff       	call   80105733 <memmove>
801057c4:	83 c4 0c             	add    $0xc,%esp
}
801057c7:	c9                   	leave  
801057c8:	c3                   	ret    

801057c9 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801057c9:	55                   	push   %ebp
801057ca:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801057cc:	eb 0c                	jmp    801057da <strncmp+0x11>
    n--, p++, q++;
801057ce:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801057d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801057d6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801057da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057de:	74 1a                	je     801057fa <strncmp+0x31>
801057e0:	8b 45 08             	mov    0x8(%ebp),%eax
801057e3:	0f b6 00             	movzbl (%eax),%eax
801057e6:	84 c0                	test   %al,%al
801057e8:	74 10                	je     801057fa <strncmp+0x31>
801057ea:	8b 45 08             	mov    0x8(%ebp),%eax
801057ed:	0f b6 10             	movzbl (%eax),%edx
801057f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801057f3:	0f b6 00             	movzbl (%eax),%eax
801057f6:	38 c2                	cmp    %al,%dl
801057f8:	74 d4                	je     801057ce <strncmp+0x5>
  if(n == 0)
801057fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057fe:	75 07                	jne    80105807 <strncmp+0x3e>
    return 0;
80105800:	b8 00 00 00 00       	mov    $0x0,%eax
80105805:	eb 16                	jmp    8010581d <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105807:	8b 45 08             	mov    0x8(%ebp),%eax
8010580a:	0f b6 00             	movzbl (%eax),%eax
8010580d:	0f b6 d0             	movzbl %al,%edx
80105810:	8b 45 0c             	mov    0xc(%ebp),%eax
80105813:	0f b6 00             	movzbl (%eax),%eax
80105816:	0f b6 c8             	movzbl %al,%ecx
80105819:	89 d0                	mov    %edx,%eax
8010581b:	29 c8                	sub    %ecx,%eax
}
8010581d:	5d                   	pop    %ebp
8010581e:	c3                   	ret    

8010581f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010581f:	55                   	push   %ebp
80105820:	89 e5                	mov    %esp,%ebp
80105822:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105825:	8b 45 08             	mov    0x8(%ebp),%eax
80105828:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010582b:	90                   	nop
8010582c:	8b 45 10             	mov    0x10(%ebp),%eax
8010582f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105832:	89 55 10             	mov    %edx,0x10(%ebp)
80105835:	85 c0                	test   %eax,%eax
80105837:	7e 2c                	jle    80105865 <strncpy+0x46>
80105839:	8b 55 0c             	mov    0xc(%ebp),%edx
8010583c:	8d 42 01             	lea    0x1(%edx),%eax
8010583f:	89 45 0c             	mov    %eax,0xc(%ebp)
80105842:	8b 45 08             	mov    0x8(%ebp),%eax
80105845:	8d 48 01             	lea    0x1(%eax),%ecx
80105848:	89 4d 08             	mov    %ecx,0x8(%ebp)
8010584b:	0f b6 12             	movzbl (%edx),%edx
8010584e:	88 10                	mov    %dl,(%eax)
80105850:	0f b6 00             	movzbl (%eax),%eax
80105853:	84 c0                	test   %al,%al
80105855:	75 d5                	jne    8010582c <strncpy+0xd>
    ;
  while(n-- > 0)
80105857:	eb 0c                	jmp    80105865 <strncpy+0x46>
    *s++ = 0;
80105859:	8b 45 08             	mov    0x8(%ebp),%eax
8010585c:	8d 50 01             	lea    0x1(%eax),%edx
8010585f:	89 55 08             	mov    %edx,0x8(%ebp)
80105862:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80105865:	8b 45 10             	mov    0x10(%ebp),%eax
80105868:	8d 50 ff             	lea    -0x1(%eax),%edx
8010586b:	89 55 10             	mov    %edx,0x10(%ebp)
8010586e:	85 c0                	test   %eax,%eax
80105870:	7f e7                	jg     80105859 <strncpy+0x3a>
  return os;
80105872:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    

80105877 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105877:	55                   	push   %ebp
80105878:	89 e5                	mov    %esp,%ebp
8010587a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010587d:	8b 45 08             	mov    0x8(%ebp),%eax
80105880:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105883:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105887:	7f 05                	jg     8010588e <safestrcpy+0x17>
    return os;
80105889:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010588c:	eb 31                	jmp    801058bf <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010588e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105892:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105896:	7e 1e                	jle    801058b6 <safestrcpy+0x3f>
80105898:	8b 55 0c             	mov    0xc(%ebp),%edx
8010589b:	8d 42 01             	lea    0x1(%edx),%eax
8010589e:	89 45 0c             	mov    %eax,0xc(%ebp)
801058a1:	8b 45 08             	mov    0x8(%ebp),%eax
801058a4:	8d 48 01             	lea    0x1(%eax),%ecx
801058a7:	89 4d 08             	mov    %ecx,0x8(%ebp)
801058aa:	0f b6 12             	movzbl (%edx),%edx
801058ad:	88 10                	mov    %dl,(%eax)
801058af:	0f b6 00             	movzbl (%eax),%eax
801058b2:	84 c0                	test   %al,%al
801058b4:	75 d8                	jne    8010588e <safestrcpy+0x17>
    ;
  *s = 0;
801058b6:	8b 45 08             	mov    0x8(%ebp),%eax
801058b9:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801058bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058bf:	c9                   	leave  
801058c0:	c3                   	ret    

801058c1 <strlen>:

int
strlen(const char *s)
{
801058c1:	55                   	push   %ebp
801058c2:	89 e5                	mov    %esp,%ebp
801058c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801058c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801058ce:	eb 04                	jmp    801058d4 <strlen+0x13>
801058d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801058d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058d7:	8b 45 08             	mov    0x8(%ebp),%eax
801058da:	01 d0                	add    %edx,%eax
801058dc:	0f b6 00             	movzbl (%eax),%eax
801058df:	84 c0                	test   %al,%al
801058e1:	75 ed                	jne    801058d0 <strlen+0xf>
    ;
  return n;
801058e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801058e6:	c9                   	leave  
801058e7:	c3                   	ret    

801058e8 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801058e8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801058ec:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801058f0:	55                   	push   %ebp
  pushl %ebx
801058f1:	53                   	push   %ebx
  pushl %esi
801058f2:	56                   	push   %esi
  pushl %edi
801058f3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801058f4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801058f6:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801058f8:	5f                   	pop    %edi
  popl %esi
801058f9:	5e                   	pop    %esi
  popl %ebx
801058fa:	5b                   	pop    %ebx
  popl %ebp
801058fb:	5d                   	pop    %ebp
  ret
801058fc:	c3                   	ret    

801058fd <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801058fd:	55                   	push   %ebp
801058fe:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105900:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105906:	8b 00                	mov    (%eax),%eax
80105908:	39 45 08             	cmp    %eax,0x8(%ebp)
8010590b:	73 12                	jae    8010591f <fetchint+0x22>
8010590d:	8b 45 08             	mov    0x8(%ebp),%eax
80105910:	8d 50 04             	lea    0x4(%eax),%edx
80105913:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105919:	8b 00                	mov    (%eax),%eax
8010591b:	39 c2                	cmp    %eax,%edx
8010591d:	76 07                	jbe    80105926 <fetchint+0x29>
    return -1;
8010591f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105924:	eb 0f                	jmp    80105935 <fetchint+0x38>
  *ip = *(int*)(addr);
80105926:	8b 45 08             	mov    0x8(%ebp),%eax
80105929:	8b 10                	mov    (%eax),%edx
8010592b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010592e:	89 10                	mov    %edx,(%eax)
  return 0;
80105930:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105935:	5d                   	pop    %ebp
80105936:	c3                   	ret    

80105937 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105937:	55                   	push   %ebp
80105938:	89 e5                	mov    %esp,%ebp
8010593a:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010593d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105943:	8b 00                	mov    (%eax),%eax
80105945:	39 45 08             	cmp    %eax,0x8(%ebp)
80105948:	72 07                	jb     80105951 <fetchstr+0x1a>
    return -1;
8010594a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594f:	eb 44                	jmp    80105995 <fetchstr+0x5e>
  *pp = (char*)addr;
80105951:	8b 55 08             	mov    0x8(%ebp),%edx
80105954:	8b 45 0c             	mov    0xc(%ebp),%eax
80105957:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105959:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010595f:	8b 00                	mov    (%eax),%eax
80105961:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105964:	8b 45 0c             	mov    0xc(%ebp),%eax
80105967:	8b 00                	mov    (%eax),%eax
80105969:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010596c:	eb 1a                	jmp    80105988 <fetchstr+0x51>
    if(*s == 0)
8010596e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105971:	0f b6 00             	movzbl (%eax),%eax
80105974:	84 c0                	test   %al,%al
80105976:	75 0c                	jne    80105984 <fetchstr+0x4d>
      return s - *pp;
80105978:	8b 45 0c             	mov    0xc(%ebp),%eax
8010597b:	8b 10                	mov    (%eax),%edx
8010597d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105980:	29 d0                	sub    %edx,%eax
80105982:	eb 11                	jmp    80105995 <fetchstr+0x5e>
  for(s = *pp; s < ep; s++)
80105984:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105988:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010598b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010598e:	72 de                	jb     8010596e <fetchstr+0x37>
  return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    

80105997 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105997:	55                   	push   %ebp
80105998:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010599a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059a0:	8b 40 18             	mov    0x18(%eax),%eax
801059a3:	8b 50 44             	mov    0x44(%eax),%edx
801059a6:	8b 45 08             	mov    0x8(%ebp),%eax
801059a9:	c1 e0 02             	shl    $0x2,%eax
801059ac:	01 d0                	add    %edx,%eax
801059ae:	83 c0 04             	add    $0x4,%eax
801059b1:	ff 75 0c             	push   0xc(%ebp)
801059b4:	50                   	push   %eax
801059b5:	e8 43 ff ff ff       	call   801058fd <fetchint>
801059ba:	83 c4 08             	add    $0x8,%esp
}
801059bd:	c9                   	leave  
801059be:	c3                   	ret    

801059bf <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801059bf:	55                   	push   %ebp
801059c0:	89 e5                	mov    %esp,%ebp
801059c2:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
801059c5:	8d 45 fc             	lea    -0x4(%ebp),%eax
801059c8:	50                   	push   %eax
801059c9:	ff 75 08             	push   0x8(%ebp)
801059cc:	e8 c6 ff ff ff       	call   80105997 <argint>
801059d1:	83 c4 08             	add    $0x8,%esp
801059d4:	85 c0                	test   %eax,%eax
801059d6:	79 07                	jns    801059df <argptr+0x20>
    return -1;
801059d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059dd:	eb 3b                	jmp    80105a1a <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801059df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059e5:	8b 00                	mov    (%eax),%eax
801059e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059ea:	39 d0                	cmp    %edx,%eax
801059ec:	76 16                	jbe    80105a04 <argptr+0x45>
801059ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059f1:	89 c2                	mov    %eax,%edx
801059f3:	8b 45 10             	mov    0x10(%ebp),%eax
801059f6:	01 c2                	add    %eax,%edx
801059f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059fe:	8b 00                	mov    (%eax),%eax
80105a00:	39 c2                	cmp    %eax,%edx
80105a02:	76 07                	jbe    80105a0b <argptr+0x4c>
    return -1;
80105a04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a09:	eb 0f                	jmp    80105a1a <argptr+0x5b>
  *pp = (char*)i;
80105a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a0e:	89 c2                	mov    %eax,%edx
80105a10:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a13:	89 10                	mov    %edx,(%eax)
  return 0;
80105a15:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    

80105a1c <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105a1c:	55                   	push   %ebp
80105a1d:	89 e5                	mov    %esp,%ebp
80105a1f:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105a22:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105a25:	50                   	push   %eax
80105a26:	ff 75 08             	push   0x8(%ebp)
80105a29:	e8 69 ff ff ff       	call   80105997 <argint>
80105a2e:	83 c4 08             	add    $0x8,%esp
80105a31:	85 c0                	test   %eax,%eax
80105a33:	79 07                	jns    80105a3c <argstr+0x20>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3a:	eb 0f                	jmp    80105a4b <argstr+0x2f>
  return fetchstr(addr, pp);
80105a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a3f:	ff 75 0c             	push   0xc(%ebp)
80105a42:	50                   	push   %eax
80105a43:	e8 ef fe ff ff       	call   80105937 <fetchstr>
80105a48:	83 c4 08             	add    $0x8,%esp
}
80105a4b:	c9                   	leave  
80105a4c:	c3                   	ret    

80105a4d <syscall>:

};

void
syscall(void)
{
80105a4d:	55                   	push   %ebp
80105a4e:	89 e5                	mov    %esp,%ebp
80105a50:	83 ec 18             	sub    $0x18,%esp
  int num;

  num = proc->tf->eax;
80105a53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a59:	8b 40 18             	mov    0x18(%eax),%eax
80105a5c:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a66:	7e 32                	jle    80105a9a <syscall+0x4d>
80105a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6b:	83 f8 1b             	cmp    $0x1b,%eax
80105a6e:	77 2a                	ja     80105a9a <syscall+0x4d>
80105a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a73:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a7a:	85 c0                	test   %eax,%eax
80105a7c:	74 1c                	je     80105a9a <syscall+0x4d>
    proc->tf->eax = syscalls[num]();
80105a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a81:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105a88:	ff d0                	call   *%eax
80105a8a:	89 c2                	mov    %eax,%edx
80105a8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a92:	8b 40 18             	mov    0x18(%eax),%eax
80105a95:	89 50 1c             	mov    %edx,0x1c(%eax)
80105a98:	eb 35                	jmp    80105acf <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105a9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aa0:	8d 50 6c             	lea    0x6c(%eax),%edx
80105aa3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105aa9:	8b 40 10             	mov    0x10(%eax),%eax
80105aac:	ff 75 f4             	push   -0xc(%ebp)
80105aaf:	52                   	push   %edx
80105ab0:	50                   	push   %eax
80105ab1:	68 b7 96 10 80       	push   $0x801096b7
80105ab6:	e8 0b a9 ff ff       	call   801003c6 <cprintf>
80105abb:	83 c4 10             	add    $0x10,%esp
    proc->tf->eax = -1;
80105abe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ac4:	8b 40 18             	mov    0x18(%eax),%eax
80105ac7:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105ace:	90                   	nop
80105acf:	90                   	nop
80105ad0:	c9                   	leave  
80105ad1:	c3                   	ret    

80105ad2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105ad2:	55                   	push   %ebp
80105ad3:	89 e5                	mov    %esp,%ebp
80105ad5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105ad8:	83 ec 08             	sub    $0x8,%esp
80105adb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ade:	50                   	push   %eax
80105adf:	ff 75 08             	push   0x8(%ebp)
80105ae2:	e8 b0 fe ff ff       	call   80105997 <argint>
80105ae7:	83 c4 10             	add    $0x10,%esp
80105aea:	85 c0                	test   %eax,%eax
80105aec:	79 07                	jns    80105af5 <argfd+0x23>
    return -1;
80105aee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105af3:	eb 50                	jmp    80105b45 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af8:	85 c0                	test   %eax,%eax
80105afa:	78 21                	js     80105b1d <argfd+0x4b>
80105afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aff:	83 f8 0f             	cmp    $0xf,%eax
80105b02:	7f 19                	jg     80105b1d <argfd+0x4b>
80105b04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b0d:	83 c2 08             	add    $0x8,%edx
80105b10:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b1b:	75 07                	jne    80105b24 <argfd+0x52>
    return -1;
80105b1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b22:	eb 21                	jmp    80105b45 <argfd+0x73>
  if(pfd)
80105b24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105b28:	74 08                	je     80105b32 <argfd+0x60>
    *pfd = fd;
80105b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b30:	89 10                	mov    %edx,(%eax)
  if(pf)
80105b32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b36:	74 08                	je     80105b40 <argfd+0x6e>
    *pf = f;
80105b38:	8b 45 10             	mov    0x10(%ebp),%eax
80105b3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b3e:	89 10                	mov    %edx,(%eax)
  return 0;
80105b40:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b45:	c9                   	leave  
80105b46:	c3                   	ret    

80105b47 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105b47:	55                   	push   %ebp
80105b48:	89 e5                	mov    %esp,%ebp
80105b4a:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105b4d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b54:	eb 30                	jmp    80105b86 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105b56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b5f:	83 c2 08             	add    $0x8,%edx
80105b62:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105b66:	85 c0                	test   %eax,%eax
80105b68:	75 18                	jne    80105b82 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105b6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b70:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b73:	8d 4a 08             	lea    0x8(%edx),%ecx
80105b76:	8b 55 08             	mov    0x8(%ebp),%edx
80105b79:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105b7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b80:	eb 0f                	jmp    80105b91 <fdalloc+0x4a>
  for(fd = 0; fd < NOFILE; fd++){
80105b82:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105b86:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105b8a:	7e ca                	jle    80105b56 <fdalloc+0xf>
    }
  }
  return -1;
80105b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b91:	c9                   	leave  
80105b92:	c3                   	ret    

80105b93 <sys_dup>:

int
sys_dup(void)
{
80105b93:	55                   	push   %ebp
80105b94:	89 e5                	mov    %esp,%ebp
80105b96:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105b99:	83 ec 04             	sub    $0x4,%esp
80105b9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b9f:	50                   	push   %eax
80105ba0:	6a 00                	push   $0x0
80105ba2:	6a 00                	push   $0x0
80105ba4:	e8 29 ff ff ff       	call   80105ad2 <argfd>
80105ba9:	83 c4 10             	add    $0x10,%esp
80105bac:	85 c0                	test   %eax,%eax
80105bae:	79 07                	jns    80105bb7 <sys_dup+0x24>
    return -1;
80105bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb5:	eb 31                	jmp    80105be8 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bba:	83 ec 0c             	sub    $0xc,%esp
80105bbd:	50                   	push   %eax
80105bbe:	e8 84 ff ff ff       	call   80105b47 <fdalloc>
80105bc3:	83 c4 10             	add    $0x10,%esp
80105bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bcd:	79 07                	jns    80105bd6 <sys_dup+0x43>
    return -1;
80105bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd4:	eb 12                	jmp    80105be8 <sys_dup+0x55>
  filedup(f);
80105bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd9:	83 ec 0c             	sub    $0xc,%esp
80105bdc:	50                   	push   %eax
80105bdd:	e8 2c b4 ff ff       	call   8010100e <filedup>
80105be2:	83 c4 10             	add    $0x10,%esp
  return fd;
80105be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105be8:	c9                   	leave  
80105be9:	c3                   	ret    

80105bea <sys_read>:

int
sys_read(void)
{
80105bea:	55                   	push   %ebp
80105beb:	89 e5                	mov    %esp,%ebp
80105bed:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105bf0:	83 ec 04             	sub    $0x4,%esp
80105bf3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf6:	50                   	push   %eax
80105bf7:	6a 00                	push   $0x0
80105bf9:	6a 00                	push   $0x0
80105bfb:	e8 d2 fe ff ff       	call   80105ad2 <argfd>
80105c00:	83 c4 10             	add    $0x10,%esp
80105c03:	85 c0                	test   %eax,%eax
80105c05:	78 2e                	js     80105c35 <sys_read+0x4b>
80105c07:	83 ec 08             	sub    $0x8,%esp
80105c0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c0d:	50                   	push   %eax
80105c0e:	6a 02                	push   $0x2
80105c10:	e8 82 fd ff ff       	call   80105997 <argint>
80105c15:	83 c4 10             	add    $0x10,%esp
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	78 19                	js     80105c35 <sys_read+0x4b>
80105c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1f:	83 ec 04             	sub    $0x4,%esp
80105c22:	50                   	push   %eax
80105c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c26:	50                   	push   %eax
80105c27:	6a 01                	push   $0x1
80105c29:	e8 91 fd ff ff       	call   801059bf <argptr>
80105c2e:	83 c4 10             	add    $0x10,%esp
80105c31:	85 c0                	test   %eax,%eax
80105c33:	79 07                	jns    80105c3c <sys_read+0x52>
    return -1;
80105c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3a:	eb 17                	jmp    80105c53 <sys_read+0x69>
  return fileread(f, p, n);
80105c3c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105c3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c45:	83 ec 04             	sub    $0x4,%esp
80105c48:	51                   	push   %ecx
80105c49:	52                   	push   %edx
80105c4a:	50                   	push   %eax
80105c4b:	e8 4e b5 ff ff       	call   8010119e <fileread>
80105c50:	83 c4 10             	add    $0x10,%esp
}
80105c53:	c9                   	leave  
80105c54:	c3                   	ret    

80105c55 <sys_write>:

int
sys_write(void)
{
80105c55:	55                   	push   %ebp
80105c56:	89 e5                	mov    %esp,%ebp
80105c58:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105c5b:	83 ec 04             	sub    $0x4,%esp
80105c5e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c61:	50                   	push   %eax
80105c62:	6a 00                	push   $0x0
80105c64:	6a 00                	push   $0x0
80105c66:	e8 67 fe ff ff       	call   80105ad2 <argfd>
80105c6b:	83 c4 10             	add    $0x10,%esp
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	78 2e                	js     80105ca0 <sys_write+0x4b>
80105c72:	83 ec 08             	sub    $0x8,%esp
80105c75:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c78:	50                   	push   %eax
80105c79:	6a 02                	push   $0x2
80105c7b:	e8 17 fd ff ff       	call   80105997 <argint>
80105c80:	83 c4 10             	add    $0x10,%esp
80105c83:	85 c0                	test   %eax,%eax
80105c85:	78 19                	js     80105ca0 <sys_write+0x4b>
80105c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c8a:	83 ec 04             	sub    $0x4,%esp
80105c8d:	50                   	push   %eax
80105c8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c91:	50                   	push   %eax
80105c92:	6a 01                	push   $0x1
80105c94:	e8 26 fd ff ff       	call   801059bf <argptr>
80105c99:	83 c4 10             	add    $0x10,%esp
80105c9c:	85 c0                	test   %eax,%eax
80105c9e:	79 07                	jns    80105ca7 <sys_write+0x52>
    return -1;
80105ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca5:	eb 17                	jmp    80105cbe <sys_write+0x69>
  return filewrite(f, p, n);
80105ca7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb0:	83 ec 04             	sub    $0x4,%esp
80105cb3:	51                   	push   %ecx
80105cb4:	52                   	push   %edx
80105cb5:	50                   	push   %eax
80105cb6:	e8 9b b5 ff ff       	call   80101256 <filewrite>
80105cbb:	83 c4 10             	add    $0x10,%esp
}
80105cbe:	c9                   	leave  
80105cbf:	c3                   	ret    

80105cc0 <sys_close>:

int
sys_close(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105cc6:	83 ec 04             	sub    $0x4,%esp
80105cc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ccc:	50                   	push   %eax
80105ccd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd0:	50                   	push   %eax
80105cd1:	6a 00                	push   $0x0
80105cd3:	e8 fa fd ff ff       	call   80105ad2 <argfd>
80105cd8:	83 c4 10             	add    $0x10,%esp
80105cdb:	85 c0                	test   %eax,%eax
80105cdd:	79 07                	jns    80105ce6 <sys_close+0x26>
    return -1;
80105cdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce4:	eb 28                	jmp    80105d0e <sys_close+0x4e>
  proc->ofile[fd] = 0;
80105ce6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cec:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cef:	83 c2 08             	add    $0x8,%edx
80105cf2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105cf9:	00 
  fileclose(f);
80105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	50                   	push   %eax
80105d01:	e8 59 b3 ff ff       	call   8010105f <fileclose>
80105d06:	83 c4 10             	add    $0x10,%esp
  return 0;
80105d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d0e:	c9                   	leave  
80105d0f:	c3                   	ret    

80105d10 <sys_fstat>:

int
sys_fstat(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105d16:	83 ec 04             	sub    $0x4,%esp
80105d19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d1c:	50                   	push   %eax
80105d1d:	6a 00                	push   $0x0
80105d1f:	6a 00                	push   $0x0
80105d21:	e8 ac fd ff ff       	call   80105ad2 <argfd>
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	78 17                	js     80105d44 <sys_fstat+0x34>
80105d2d:	83 ec 04             	sub    $0x4,%esp
80105d30:	6a 14                	push   $0x14
80105d32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d35:	50                   	push   %eax
80105d36:	6a 01                	push   $0x1
80105d38:	e8 82 fc ff ff       	call   801059bf <argptr>
80105d3d:	83 c4 10             	add    $0x10,%esp
80105d40:	85 c0                	test   %eax,%eax
80105d42:	79 07                	jns    80105d4b <sys_fstat+0x3b>
    return -1;
80105d44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d49:	eb 13                	jmp    80105d5e <sys_fstat+0x4e>
  return filestat(f, st);
80105d4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d51:	83 ec 08             	sub    $0x8,%esp
80105d54:	52                   	push   %edx
80105d55:	50                   	push   %eax
80105d56:	e8 ec b3 ff ff       	call   80101147 <filestat>
80105d5b:	83 c4 10             	add    $0x10,%esp
}
80105d5e:	c9                   	leave  
80105d5f:	c3                   	ret    

80105d60 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105d66:	83 ec 08             	sub    $0x8,%esp
80105d69:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105d6c:	50                   	push   %eax
80105d6d:	6a 00                	push   $0x0
80105d6f:	e8 a8 fc ff ff       	call   80105a1c <argstr>
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	85 c0                	test   %eax,%eax
80105d79:	78 15                	js     80105d90 <sys_link+0x30>
80105d7b:	83 ec 08             	sub    $0x8,%esp
80105d7e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105d81:	50                   	push   %eax
80105d82:	6a 01                	push   $0x1
80105d84:	e8 93 fc ff ff       	call   80105a1c <argstr>
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	85 c0                	test   %eax,%eax
80105d8e:	79 0a                	jns    80105d9a <sys_link+0x3a>
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d95:	e9 68 01 00 00       	jmp    80105f02 <sys_link+0x1a2>

  begin_op();
80105d9a:	e8 8b d7 ff ff       	call   8010352a <begin_op>
  if((ip = namei(old)) == 0){
80105d9f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105da2:	83 ec 0c             	sub    $0xc,%esp
80105da5:	50                   	push   %eax
80105da6:	e8 34 c7 ff ff       	call   801024df <namei>
80105dab:	83 c4 10             	add    $0x10,%esp
80105dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105db1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105db5:	75 0f                	jne    80105dc6 <sys_link+0x66>
    end_op();
80105db7:	e8 fa d7 ff ff       	call   801035b6 <end_op>
    return -1;
80105dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dc1:	e9 3c 01 00 00       	jmp    80105f02 <sys_link+0x1a2>
  }

  ilock(ip);
80105dc6:	83 ec 0c             	sub    $0xc,%esp
80105dc9:	ff 75 f4             	push   -0xc(%ebp)
80105dcc:	e8 63 bb ff ff       	call   80101934 <ilock>
80105dd1:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ddb:	66 83 f8 01          	cmp    $0x1,%ax
80105ddf:	75 1d                	jne    80105dfe <sys_link+0x9e>
    iunlockput(ip);
80105de1:	83 ec 0c             	sub    $0xc,%esp
80105de4:	ff 75 f4             	push   -0xc(%ebp)
80105de7:	e8 02 be ff ff       	call   80101bee <iunlockput>
80105dec:	83 c4 10             	add    $0x10,%esp
    end_op();
80105def:	e8 c2 d7 ff ff       	call   801035b6 <end_op>
    return -1;
80105df4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105df9:	e9 04 01 00 00       	jmp    80105f02 <sys_link+0x1a2>
  }

  ip->nlink++;
80105dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e01:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e05:	83 c0 01             	add    $0x1,%eax
80105e08:	89 c2                	mov    %eax,%edx
80105e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105e11:	83 ec 0c             	sub    $0xc,%esp
80105e14:	ff 75 f4             	push   -0xc(%ebp)
80105e17:	e8 44 b9 ff ff       	call   80101760 <iupdate>
80105e1c:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105e1f:	83 ec 0c             	sub    $0xc,%esp
80105e22:	ff 75 f4             	push   -0xc(%ebp)
80105e25:	e8 62 bc ff ff       	call   80101a8c <iunlock>
80105e2a:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105e2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e30:	83 ec 08             	sub    $0x8,%esp
80105e33:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105e36:	52                   	push   %edx
80105e37:	50                   	push   %eax
80105e38:	e8 be c6 ff ff       	call   801024fb <nameiparent>
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e47:	74 71                	je     80105eba <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105e49:	83 ec 0c             	sub    $0xc,%esp
80105e4c:	ff 75 f0             	push   -0x10(%ebp)
80105e4f:	e8 e0 ba ff ff       	call   80101934 <ilock>
80105e54:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5a:	8b 10                	mov    (%eax),%edx
80105e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e5f:	8b 00                	mov    (%eax),%eax
80105e61:	39 c2                	cmp    %eax,%edx
80105e63:	75 1d                	jne    80105e82 <sys_link+0x122>
80105e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e68:	8b 40 04             	mov    0x4(%eax),%eax
80105e6b:	83 ec 04             	sub    $0x4,%esp
80105e6e:	50                   	push   %eax
80105e6f:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105e72:	50                   	push   %eax
80105e73:	ff 75 f0             	push   -0x10(%ebp)
80105e76:	e8 cc c3 ff ff       	call   80102247 <dirlink>
80105e7b:	83 c4 10             	add    $0x10,%esp
80105e7e:	85 c0                	test   %eax,%eax
80105e80:	79 10                	jns    80105e92 <sys_link+0x132>
    iunlockput(dp);
80105e82:	83 ec 0c             	sub    $0xc,%esp
80105e85:	ff 75 f0             	push   -0x10(%ebp)
80105e88:	e8 61 bd ff ff       	call   80101bee <iunlockput>
80105e8d:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105e90:	eb 29                	jmp    80105ebb <sys_link+0x15b>
  }
  iunlockput(dp);
80105e92:	83 ec 0c             	sub    $0xc,%esp
80105e95:	ff 75 f0             	push   -0x10(%ebp)
80105e98:	e8 51 bd ff ff       	call   80101bee <iunlockput>
80105e9d:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	ff 75 f4             	push   -0xc(%ebp)
80105ea6:	e8 53 bc ff ff       	call   80101afe <iput>
80105eab:	83 c4 10             	add    $0x10,%esp

  end_op();
80105eae:	e8 03 d7 ff ff       	call   801035b6 <end_op>

  return 0;
80105eb3:	b8 00 00 00 00       	mov    $0x0,%eax
80105eb8:	eb 48                	jmp    80105f02 <sys_link+0x1a2>
    goto bad;
80105eba:	90                   	nop

bad:
  ilock(ip);
80105ebb:	83 ec 0c             	sub    $0xc,%esp
80105ebe:	ff 75 f4             	push   -0xc(%ebp)
80105ec1:	e8 6e ba ff ff       	call   80101934 <ilock>
80105ec6:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecc:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ed0:	83 e8 01             	sub    $0x1,%eax
80105ed3:	89 c2                	mov    %eax,%edx
80105ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed8:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105edc:	83 ec 0c             	sub    $0xc,%esp
80105edf:	ff 75 f4             	push   -0xc(%ebp)
80105ee2:	e8 79 b8 ff ff       	call   80101760 <iupdate>
80105ee7:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105eea:	83 ec 0c             	sub    $0xc,%esp
80105eed:	ff 75 f4             	push   -0xc(%ebp)
80105ef0:	e8 f9 bc ff ff       	call   80101bee <iunlockput>
80105ef5:	83 c4 10             	add    $0x10,%esp
  end_op();
80105ef8:	e8 b9 d6 ff ff       	call   801035b6 <end_op>
  return -1;
80105efd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f02:	c9                   	leave  
80105f03:	c3                   	ret    

80105f04 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105f04:	55                   	push   %ebp
80105f05:	89 e5                	mov    %esp,%ebp
80105f07:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f0a:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105f11:	eb 40                	jmp    80105f53 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f16:	6a 10                	push   $0x10
80105f18:	50                   	push   %eax
80105f19:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f1c:	50                   	push   %eax
80105f1d:	ff 75 08             	push   0x8(%ebp)
80105f20:	e8 72 bf ff ff       	call   80101e97 <readi>
80105f25:	83 c4 10             	add    $0x10,%esp
80105f28:	83 f8 10             	cmp    $0x10,%eax
80105f2b:	74 0d                	je     80105f3a <isdirempty+0x36>
      panic("isdirempty: readi");
80105f2d:	83 ec 0c             	sub    $0xc,%esp
80105f30:	68 d3 96 10 80       	push   $0x801096d3
80105f35:	e8 41 a6 ff ff       	call   8010057b <panic>
    if(de.inum != 0)
80105f3a:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105f3e:	66 85 c0             	test   %ax,%ax
80105f41:	74 07                	je     80105f4a <isdirempty+0x46>
      return 0;
80105f43:	b8 00 00 00 00       	mov    $0x0,%eax
80105f48:	eb 1b                	jmp    80105f65 <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f4d:	83 c0 10             	add    $0x10,%eax
80105f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f53:	8b 45 08             	mov    0x8(%ebp),%eax
80105f56:	8b 50 18             	mov    0x18(%eax),%edx
80105f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f5c:	39 c2                	cmp    %eax,%edx
80105f5e:	77 b3                	ja     80105f13 <isdirempty+0xf>
  }
  return 1;
80105f60:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f65:	c9                   	leave  
80105f66:	c3                   	ret    

80105f67 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105f67:	55                   	push   %ebp
80105f68:	89 e5                	mov    %esp,%ebp
80105f6a:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105f6d:	83 ec 08             	sub    $0x8,%esp
80105f70:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105f73:	50                   	push   %eax
80105f74:	6a 00                	push   $0x0
80105f76:	e8 a1 fa ff ff       	call   80105a1c <argstr>
80105f7b:	83 c4 10             	add    $0x10,%esp
80105f7e:	85 c0                	test   %eax,%eax
80105f80:	79 0a                	jns    80105f8c <sys_unlink+0x25>
    return -1;
80105f82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f87:	e9 bf 01 00 00       	jmp    8010614b <sys_unlink+0x1e4>

  begin_op();
80105f8c:	e8 99 d5 ff ff       	call   8010352a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105f91:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105f94:	83 ec 08             	sub    $0x8,%esp
80105f97:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105f9a:	52                   	push   %edx
80105f9b:	50                   	push   %eax
80105f9c:	e8 5a c5 ff ff       	call   801024fb <nameiparent>
80105fa1:	83 c4 10             	add    $0x10,%esp
80105fa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fab:	75 0f                	jne    80105fbc <sys_unlink+0x55>
    end_op();
80105fad:	e8 04 d6 ff ff       	call   801035b6 <end_op>
    return -1;
80105fb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb7:	e9 8f 01 00 00       	jmp    8010614b <sys_unlink+0x1e4>
  }

  ilock(dp);
80105fbc:	83 ec 0c             	sub    $0xc,%esp
80105fbf:	ff 75 f4             	push   -0xc(%ebp)
80105fc2:	e8 6d b9 ff ff       	call   80101934 <ilock>
80105fc7:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105fca:	83 ec 08             	sub    $0x8,%esp
80105fcd:	68 e5 96 10 80       	push   $0x801096e5
80105fd2:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105fd5:	50                   	push   %eax
80105fd6:	e8 97 c1 ff ff       	call   80102172 <namecmp>
80105fdb:	83 c4 10             	add    $0x10,%esp
80105fde:	85 c0                	test   %eax,%eax
80105fe0:	0f 84 49 01 00 00    	je     8010612f <sys_unlink+0x1c8>
80105fe6:	83 ec 08             	sub    $0x8,%esp
80105fe9:	68 e7 96 10 80       	push   $0x801096e7
80105fee:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ff1:	50                   	push   %eax
80105ff2:	e8 7b c1 ff ff       	call   80102172 <namecmp>
80105ff7:	83 c4 10             	add    $0x10,%esp
80105ffa:	85 c0                	test   %eax,%eax
80105ffc:	0f 84 2d 01 00 00    	je     8010612f <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106002:	83 ec 04             	sub    $0x4,%esp
80106005:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106008:	50                   	push   %eax
80106009:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010600c:	50                   	push   %eax
8010600d:	ff 75 f4             	push   -0xc(%ebp)
80106010:	e8 78 c1 ff ff       	call   8010218d <dirlookup>
80106015:	83 c4 10             	add    $0x10,%esp
80106018:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010601b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010601f:	0f 84 0d 01 00 00    	je     80106132 <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80106025:	83 ec 0c             	sub    $0xc,%esp
80106028:	ff 75 f0             	push   -0x10(%ebp)
8010602b:	e8 04 b9 ff ff       	call   80101934 <ilock>
80106030:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106033:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106036:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010603a:	66 85 c0             	test   %ax,%ax
8010603d:	7f 0d                	jg     8010604c <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
8010603f:	83 ec 0c             	sub    $0xc,%esp
80106042:	68 ea 96 10 80       	push   $0x801096ea
80106047:	e8 2f a5 ff ff       	call   8010057b <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010604c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106053:	66 83 f8 01          	cmp    $0x1,%ax
80106057:	75 25                	jne    8010607e <sys_unlink+0x117>
80106059:	83 ec 0c             	sub    $0xc,%esp
8010605c:	ff 75 f0             	push   -0x10(%ebp)
8010605f:	e8 a0 fe ff ff       	call   80105f04 <isdirempty>
80106064:	83 c4 10             	add    $0x10,%esp
80106067:	85 c0                	test   %eax,%eax
80106069:	75 13                	jne    8010607e <sys_unlink+0x117>
    iunlockput(ip);
8010606b:	83 ec 0c             	sub    $0xc,%esp
8010606e:	ff 75 f0             	push   -0x10(%ebp)
80106071:	e8 78 bb ff ff       	call   80101bee <iunlockput>
80106076:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106079:	e9 b5 00 00 00       	jmp    80106133 <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
8010607e:	83 ec 04             	sub    $0x4,%esp
80106081:	6a 10                	push   $0x10
80106083:	6a 00                	push   $0x0
80106085:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106088:	50                   	push   %eax
80106089:	e8 e6 f5 ff ff       	call   80105674 <memset>
8010608e:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106091:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106094:	6a 10                	push   $0x10
80106096:	50                   	push   %eax
80106097:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010609a:	50                   	push   %eax
8010609b:	ff 75 f4             	push   -0xc(%ebp)
8010609e:	e8 49 bf ff ff       	call   80101fec <writei>
801060a3:	83 c4 10             	add    $0x10,%esp
801060a6:	83 f8 10             	cmp    $0x10,%eax
801060a9:	74 0d                	je     801060b8 <sys_unlink+0x151>
    panic("unlink: writei");
801060ab:	83 ec 0c             	sub    $0xc,%esp
801060ae:	68 fc 96 10 80       	push   $0x801096fc
801060b3:	e8 c3 a4 ff ff       	call   8010057b <panic>
  if(ip->type == T_DIR){
801060b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060bb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801060bf:	66 83 f8 01          	cmp    $0x1,%ax
801060c3:	75 21                	jne    801060e6 <sys_unlink+0x17f>
    dp->nlink--;
801060c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c8:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060cc:	83 e8 01             	sub    $0x1,%eax
801060cf:	89 c2                	mov    %eax,%edx
801060d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d4:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801060d8:	83 ec 0c             	sub    $0xc,%esp
801060db:	ff 75 f4             	push   -0xc(%ebp)
801060de:	e8 7d b6 ff ff       	call   80101760 <iupdate>
801060e3:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801060e6:	83 ec 0c             	sub    $0xc,%esp
801060e9:	ff 75 f4             	push   -0xc(%ebp)
801060ec:	e8 fd ba ff ff       	call   80101bee <iunlockput>
801060f1:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801060f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801060fb:	83 e8 01             	sub    $0x1,%eax
801060fe:	89 c2                	mov    %eax,%edx
80106100:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106103:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106107:	83 ec 0c             	sub    $0xc,%esp
8010610a:	ff 75 f0             	push   -0x10(%ebp)
8010610d:	e8 4e b6 ff ff       	call   80101760 <iupdate>
80106112:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106115:	83 ec 0c             	sub    $0xc,%esp
80106118:	ff 75 f0             	push   -0x10(%ebp)
8010611b:	e8 ce ba ff ff       	call   80101bee <iunlockput>
80106120:	83 c4 10             	add    $0x10,%esp

  end_op();
80106123:	e8 8e d4 ff ff       	call   801035b6 <end_op>

  return 0;
80106128:	b8 00 00 00 00       	mov    $0x0,%eax
8010612d:	eb 1c                	jmp    8010614b <sys_unlink+0x1e4>
    goto bad;
8010612f:	90                   	nop
80106130:	eb 01                	jmp    80106133 <sys_unlink+0x1cc>
    goto bad;
80106132:	90                   	nop

bad:
  iunlockput(dp);
80106133:	83 ec 0c             	sub    $0xc,%esp
80106136:	ff 75 f4             	push   -0xc(%ebp)
80106139:	e8 b0 ba ff ff       	call   80101bee <iunlockput>
8010613e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106141:	e8 70 d4 ff ff       	call   801035b6 <end_op>
  return -1;
80106146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010614b:	c9                   	leave  
8010614c:	c3                   	ret    

8010614d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010614d:	55                   	push   %ebp
8010614e:	89 e5                	mov    %esp,%ebp
80106150:	83 ec 38             	sub    $0x38,%esp
80106153:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106156:	8b 55 10             	mov    0x10(%ebp),%edx
80106159:	8b 45 14             	mov    0x14(%ebp),%eax
8010615c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106160:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106164:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106168:	83 ec 08             	sub    $0x8,%esp
8010616b:	8d 45 de             	lea    -0x22(%ebp),%eax
8010616e:	50                   	push   %eax
8010616f:	ff 75 08             	push   0x8(%ebp)
80106172:	e8 84 c3 ff ff       	call   801024fb <nameiparent>
80106177:	83 c4 10             	add    $0x10,%esp
8010617a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010617d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106181:	75 0a                	jne    8010618d <create+0x40>
    return 0;
80106183:	b8 00 00 00 00       	mov    $0x0,%eax
80106188:	e9 90 01 00 00       	jmp    8010631d <create+0x1d0>
  ilock(dp);
8010618d:	83 ec 0c             	sub    $0xc,%esp
80106190:	ff 75 f4             	push   -0xc(%ebp)
80106193:	e8 9c b7 ff ff       	call   80101934 <ilock>
80106198:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010619b:	83 ec 04             	sub    $0x4,%esp
8010619e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061a1:	50                   	push   %eax
801061a2:	8d 45 de             	lea    -0x22(%ebp),%eax
801061a5:	50                   	push   %eax
801061a6:	ff 75 f4             	push   -0xc(%ebp)
801061a9:	e8 df bf ff ff       	call   8010218d <dirlookup>
801061ae:	83 c4 10             	add    $0x10,%esp
801061b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061b8:	74 50                	je     8010620a <create+0xbd>
    iunlockput(dp);
801061ba:	83 ec 0c             	sub    $0xc,%esp
801061bd:	ff 75 f4             	push   -0xc(%ebp)
801061c0:	e8 29 ba ff ff       	call   80101bee <iunlockput>
801061c5:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
801061c8:	83 ec 0c             	sub    $0xc,%esp
801061cb:	ff 75 f0             	push   -0x10(%ebp)
801061ce:	e8 61 b7 ff ff       	call   80101934 <ilock>
801061d3:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801061d6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801061db:	75 15                	jne    801061f2 <create+0xa5>
801061dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061e0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061e4:	66 83 f8 02          	cmp    $0x2,%ax
801061e8:	75 08                	jne    801061f2 <create+0xa5>
      return ip;
801061ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ed:	e9 2b 01 00 00       	jmp    8010631d <create+0x1d0>
    iunlockput(ip);
801061f2:	83 ec 0c             	sub    $0xc,%esp
801061f5:	ff 75 f0             	push   -0x10(%ebp)
801061f8:	e8 f1 b9 ff ff       	call   80101bee <iunlockput>
801061fd:	83 c4 10             	add    $0x10,%esp
    return 0;
80106200:	b8 00 00 00 00       	mov    $0x0,%eax
80106205:	e9 13 01 00 00       	jmp    8010631d <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010620a:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010620e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106211:	8b 00                	mov    (%eax),%eax
80106213:	83 ec 08             	sub    $0x8,%esp
80106216:	52                   	push   %edx
80106217:	50                   	push   %eax
80106218:	e8 62 b4 ff ff       	call   8010167f <ialloc>
8010621d:	83 c4 10             	add    $0x10,%esp
80106220:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106223:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106227:	75 0d                	jne    80106236 <create+0xe9>
    panic("create: ialloc");
80106229:	83 ec 0c             	sub    $0xc,%esp
8010622c:	68 0b 97 10 80       	push   $0x8010970b
80106231:	e8 45 a3 ff ff       	call   8010057b <panic>

  ilock(ip);
80106236:	83 ec 0c             	sub    $0xc,%esp
80106239:	ff 75 f0             	push   -0x10(%ebp)
8010623c:	e8 f3 b6 ff ff       	call   80101934 <ilock>
80106241:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106244:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106247:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010624b:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010624f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106252:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106256:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
8010625a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010625d:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106263:	83 ec 0c             	sub    $0xc,%esp
80106266:	ff 75 f0             	push   -0x10(%ebp)
80106269:	e8 f2 b4 ff ff       	call   80101760 <iupdate>
8010626e:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106271:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106276:	75 6a                	jne    801062e2 <create+0x195>
    dp->nlink++;  // for ".."
80106278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010627f:	83 c0 01             	add    $0x1,%eax
80106282:	89 c2                	mov    %eax,%edx
80106284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106287:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010628b:	83 ec 0c             	sub    $0xc,%esp
8010628e:	ff 75 f4             	push   -0xc(%ebp)
80106291:	e8 ca b4 ff ff       	call   80101760 <iupdate>
80106296:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106299:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010629c:	8b 40 04             	mov    0x4(%eax),%eax
8010629f:	83 ec 04             	sub    $0x4,%esp
801062a2:	50                   	push   %eax
801062a3:	68 e5 96 10 80       	push   $0x801096e5
801062a8:	ff 75 f0             	push   -0x10(%ebp)
801062ab:	e8 97 bf ff ff       	call   80102247 <dirlink>
801062b0:	83 c4 10             	add    $0x10,%esp
801062b3:	85 c0                	test   %eax,%eax
801062b5:	78 1e                	js     801062d5 <create+0x188>
801062b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ba:	8b 40 04             	mov    0x4(%eax),%eax
801062bd:	83 ec 04             	sub    $0x4,%esp
801062c0:	50                   	push   %eax
801062c1:	68 e7 96 10 80       	push   $0x801096e7
801062c6:	ff 75 f0             	push   -0x10(%ebp)
801062c9:	e8 79 bf ff ff       	call   80102247 <dirlink>
801062ce:	83 c4 10             	add    $0x10,%esp
801062d1:	85 c0                	test   %eax,%eax
801062d3:	79 0d                	jns    801062e2 <create+0x195>
      panic("create dots");
801062d5:	83 ec 0c             	sub    $0xc,%esp
801062d8:	68 1a 97 10 80       	push   $0x8010971a
801062dd:	e8 99 a2 ff ff       	call   8010057b <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801062e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e5:	8b 40 04             	mov    0x4(%eax),%eax
801062e8:	83 ec 04             	sub    $0x4,%esp
801062eb:	50                   	push   %eax
801062ec:	8d 45 de             	lea    -0x22(%ebp),%eax
801062ef:	50                   	push   %eax
801062f0:	ff 75 f4             	push   -0xc(%ebp)
801062f3:	e8 4f bf ff ff       	call   80102247 <dirlink>
801062f8:	83 c4 10             	add    $0x10,%esp
801062fb:	85 c0                	test   %eax,%eax
801062fd:	79 0d                	jns    8010630c <create+0x1bf>
    panic("create: dirlink");
801062ff:	83 ec 0c             	sub    $0xc,%esp
80106302:	68 26 97 10 80       	push   $0x80109726
80106307:	e8 6f a2 ff ff       	call   8010057b <panic>

  iunlockput(dp);
8010630c:	83 ec 0c             	sub    $0xc,%esp
8010630f:	ff 75 f4             	push   -0xc(%ebp)
80106312:	e8 d7 b8 ff ff       	call   80101bee <iunlockput>
80106317:	83 c4 10             	add    $0x10,%esp

  return ip;
8010631a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010631d:	c9                   	leave  
8010631e:	c3                   	ret    

8010631f <sys_open>:

int
sys_open(void)
{
8010631f:	55                   	push   %ebp
80106320:	89 e5                	mov    %esp,%ebp
80106322:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106325:	83 ec 08             	sub    $0x8,%esp
80106328:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010632b:	50                   	push   %eax
8010632c:	6a 00                	push   $0x0
8010632e:	e8 e9 f6 ff ff       	call   80105a1c <argstr>
80106333:	83 c4 10             	add    $0x10,%esp
80106336:	85 c0                	test   %eax,%eax
80106338:	78 15                	js     8010634f <sys_open+0x30>
8010633a:	83 ec 08             	sub    $0x8,%esp
8010633d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106340:	50                   	push   %eax
80106341:	6a 01                	push   $0x1
80106343:	e8 4f f6 ff ff       	call   80105997 <argint>
80106348:	83 c4 10             	add    $0x10,%esp
8010634b:	85 c0                	test   %eax,%eax
8010634d:	79 0a                	jns    80106359 <sys_open+0x3a>
    return -1;
8010634f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106354:	e9 61 01 00 00       	jmp    801064ba <sys_open+0x19b>

  begin_op();
80106359:	e8 cc d1 ff ff       	call   8010352a <begin_op>

  if(omode & O_CREATE){
8010635e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106361:	25 00 02 00 00       	and    $0x200,%eax
80106366:	85 c0                	test   %eax,%eax
80106368:	74 2a                	je     80106394 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
8010636a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010636d:	6a 00                	push   $0x0
8010636f:	6a 00                	push   $0x0
80106371:	6a 02                	push   $0x2
80106373:	50                   	push   %eax
80106374:	e8 d4 fd ff ff       	call   8010614d <create>
80106379:	83 c4 10             	add    $0x10,%esp
8010637c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010637f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106383:	75 75                	jne    801063fa <sys_open+0xdb>
      end_op();
80106385:	e8 2c d2 ff ff       	call   801035b6 <end_op>
      return -1;
8010638a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010638f:	e9 26 01 00 00       	jmp    801064ba <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80106394:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106397:	83 ec 0c             	sub    $0xc,%esp
8010639a:	50                   	push   %eax
8010639b:	e8 3f c1 ff ff       	call   801024df <namei>
801063a0:	83 c4 10             	add    $0x10,%esp
801063a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063aa:	75 0f                	jne    801063bb <sys_open+0x9c>
      end_op();
801063ac:	e8 05 d2 ff ff       	call   801035b6 <end_op>
      return -1;
801063b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063b6:	e9 ff 00 00 00       	jmp    801064ba <sys_open+0x19b>
    }
    ilock(ip);
801063bb:	83 ec 0c             	sub    $0xc,%esp
801063be:	ff 75 f4             	push   -0xc(%ebp)
801063c1:	e8 6e b5 ff ff       	call   80101934 <ilock>
801063c6:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801063c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063cc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063d0:	66 83 f8 01          	cmp    $0x1,%ax
801063d4:	75 24                	jne    801063fa <sys_open+0xdb>
801063d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063d9:	85 c0                	test   %eax,%eax
801063db:	74 1d                	je     801063fa <sys_open+0xdb>
      iunlockput(ip);
801063dd:	83 ec 0c             	sub    $0xc,%esp
801063e0:	ff 75 f4             	push   -0xc(%ebp)
801063e3:	e8 06 b8 ff ff       	call   80101bee <iunlockput>
801063e8:	83 c4 10             	add    $0x10,%esp
      end_op();
801063eb:	e8 c6 d1 ff ff       	call   801035b6 <end_op>
      return -1;
801063f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063f5:	e9 c0 00 00 00       	jmp    801064ba <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801063fa:	e8 a2 ab ff ff       	call   80100fa1 <filealloc>
801063ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106402:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106406:	74 17                	je     8010641f <sys_open+0x100>
80106408:	83 ec 0c             	sub    $0xc,%esp
8010640b:	ff 75 f0             	push   -0x10(%ebp)
8010640e:	e8 34 f7 ff ff       	call   80105b47 <fdalloc>
80106413:	83 c4 10             	add    $0x10,%esp
80106416:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010641d:	79 2e                	jns    8010644d <sys_open+0x12e>
    if(f)
8010641f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106423:	74 0e                	je     80106433 <sys_open+0x114>
      fileclose(f);
80106425:	83 ec 0c             	sub    $0xc,%esp
80106428:	ff 75 f0             	push   -0x10(%ebp)
8010642b:	e8 2f ac ff ff       	call   8010105f <fileclose>
80106430:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106433:	83 ec 0c             	sub    $0xc,%esp
80106436:	ff 75 f4             	push   -0xc(%ebp)
80106439:	e8 b0 b7 ff ff       	call   80101bee <iunlockput>
8010643e:	83 c4 10             	add    $0x10,%esp
    end_op();
80106441:	e8 70 d1 ff ff       	call   801035b6 <end_op>
    return -1;
80106446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644b:	eb 6d                	jmp    801064ba <sys_open+0x19b>
  }
  iunlock(ip);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	ff 75 f4             	push   -0xc(%ebp)
80106453:	e8 34 b6 ff ff       	call   80101a8c <iunlock>
80106458:	83 c4 10             	add    $0x10,%esp
  end_op();
8010645b:	e8 56 d1 ff ff       	call   801035b6 <end_op>

  f->type = FD_INODE;
80106460:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106463:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106469:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010646f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106475:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010647c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010647f:	83 e0 01             	and    $0x1,%eax
80106482:	85 c0                	test   %eax,%eax
80106484:	0f 94 c0             	sete   %al
80106487:	89 c2                	mov    %eax,%edx
80106489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010648c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010648f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106492:	83 e0 01             	and    $0x1,%eax
80106495:	85 c0                	test   %eax,%eax
80106497:	75 0a                	jne    801064a3 <sys_open+0x184>
80106499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010649c:	83 e0 02             	and    $0x2,%eax
8010649f:	85 c0                	test   %eax,%eax
801064a1:	74 07                	je     801064aa <sys_open+0x18b>
801064a3:	b8 01 00 00 00       	mov    $0x1,%eax
801064a8:	eb 05                	jmp    801064af <sys_open+0x190>
801064aa:	b8 00 00 00 00       	mov    $0x0,%eax
801064af:	89 c2                	mov    %eax,%edx
801064b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b4:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801064b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801064ba:	c9                   	leave  
801064bb:	c3                   	ret    

801064bc <sys_mkdir>:

int
sys_mkdir(void)
{
801064bc:	55                   	push   %ebp
801064bd:	89 e5                	mov    %esp,%ebp
801064bf:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801064c2:	e8 63 d0 ff ff       	call   8010352a <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801064c7:	83 ec 08             	sub    $0x8,%esp
801064ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064cd:	50                   	push   %eax
801064ce:	6a 00                	push   $0x0
801064d0:	e8 47 f5 ff ff       	call   80105a1c <argstr>
801064d5:	83 c4 10             	add    $0x10,%esp
801064d8:	85 c0                	test   %eax,%eax
801064da:	78 1b                	js     801064f7 <sys_mkdir+0x3b>
801064dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064df:	6a 00                	push   $0x0
801064e1:	6a 00                	push   $0x0
801064e3:	6a 01                	push   $0x1
801064e5:	50                   	push   %eax
801064e6:	e8 62 fc ff ff       	call   8010614d <create>
801064eb:	83 c4 10             	add    $0x10,%esp
801064ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064f5:	75 0c                	jne    80106503 <sys_mkdir+0x47>
    end_op();
801064f7:	e8 ba d0 ff ff       	call   801035b6 <end_op>
    return -1;
801064fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106501:	eb 18                	jmp    8010651b <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106503:	83 ec 0c             	sub    $0xc,%esp
80106506:	ff 75 f4             	push   -0xc(%ebp)
80106509:	e8 e0 b6 ff ff       	call   80101bee <iunlockput>
8010650e:	83 c4 10             	add    $0x10,%esp
  end_op();
80106511:	e8 a0 d0 ff ff       	call   801035b6 <end_op>
  return 0;
80106516:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010651b:	c9                   	leave  
8010651c:	c3                   	ret    

8010651d <sys_mknod>:

int
sys_mknod(void)
{
8010651d:	55                   	push   %ebp
8010651e:	89 e5                	mov    %esp,%ebp
80106520:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106523:	e8 02 d0 ff ff       	call   8010352a <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80106528:	83 ec 08             	sub    $0x8,%esp
8010652b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010652e:	50                   	push   %eax
8010652f:	6a 00                	push   $0x0
80106531:	e8 e6 f4 ff ff       	call   80105a1c <argstr>
80106536:	83 c4 10             	add    $0x10,%esp
80106539:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010653c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106540:	78 4f                	js     80106591 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80106542:	83 ec 08             	sub    $0x8,%esp
80106545:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106548:	50                   	push   %eax
80106549:	6a 01                	push   $0x1
8010654b:	e8 47 f4 ff ff       	call   80105997 <argint>
80106550:	83 c4 10             	add    $0x10,%esp
  if((len=argstr(0, &path)) < 0 ||
80106553:	85 c0                	test   %eax,%eax
80106555:	78 3a                	js     80106591 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
80106557:	83 ec 08             	sub    $0x8,%esp
8010655a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010655d:	50                   	push   %eax
8010655e:	6a 02                	push   $0x2
80106560:	e8 32 f4 ff ff       	call   80105997 <argint>
80106565:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80106568:	85 c0                	test   %eax,%eax
8010656a:	78 25                	js     80106591 <sys_mknod+0x74>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010656c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010656f:	0f bf c8             	movswl %ax,%ecx
80106572:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106575:	0f bf d0             	movswl %ax,%edx
80106578:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010657b:	51                   	push   %ecx
8010657c:	52                   	push   %edx
8010657d:	6a 03                	push   $0x3
8010657f:	50                   	push   %eax
80106580:	e8 c8 fb ff ff       	call   8010614d <create>
80106585:	83 c4 10             	add    $0x10,%esp
80106588:	89 45 f0             	mov    %eax,-0x10(%ebp)
     argint(2, &minor) < 0 ||
8010658b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010658f:	75 0c                	jne    8010659d <sys_mknod+0x80>
    end_op();
80106591:	e8 20 d0 ff ff       	call   801035b6 <end_op>
    return -1;
80106596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010659b:	eb 18                	jmp    801065b5 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010659d:	83 ec 0c             	sub    $0xc,%esp
801065a0:	ff 75 f0             	push   -0x10(%ebp)
801065a3:	e8 46 b6 ff ff       	call   80101bee <iunlockput>
801065a8:	83 c4 10             	add    $0x10,%esp
  end_op();
801065ab:	e8 06 d0 ff ff       	call   801035b6 <end_op>
  return 0;
801065b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801065b5:	c9                   	leave  
801065b6:	c3                   	ret    

801065b7 <sys_chdir>:

int
sys_chdir(void)
{
801065b7:	55                   	push   %ebp
801065b8:	89 e5                	mov    %esp,%ebp
801065ba:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065bd:	e8 68 cf ff ff       	call   8010352a <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801065c2:	83 ec 08             	sub    $0x8,%esp
801065c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065c8:	50                   	push   %eax
801065c9:	6a 00                	push   $0x0
801065cb:	e8 4c f4 ff ff       	call   80105a1c <argstr>
801065d0:	83 c4 10             	add    $0x10,%esp
801065d3:	85 c0                	test   %eax,%eax
801065d5:	78 18                	js     801065ef <sys_chdir+0x38>
801065d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065da:	83 ec 0c             	sub    $0xc,%esp
801065dd:	50                   	push   %eax
801065de:	e8 fc be ff ff       	call   801024df <namei>
801065e3:	83 c4 10             	add    $0x10,%esp
801065e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801065e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065ed:	75 0c                	jne    801065fb <sys_chdir+0x44>
    end_op();
801065ef:	e8 c2 cf ff ff       	call   801035b6 <end_op>
    return -1;
801065f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065f9:	eb 6e                	jmp    80106669 <sys_chdir+0xb2>
  }
  ilock(ip);
801065fb:	83 ec 0c             	sub    $0xc,%esp
801065fe:	ff 75 f4             	push   -0xc(%ebp)
80106601:	e8 2e b3 ff ff       	call   80101934 <ilock>
80106606:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80106609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106610:	66 83 f8 01          	cmp    $0x1,%ax
80106614:	74 1a                	je     80106630 <sys_chdir+0x79>
    iunlockput(ip);
80106616:	83 ec 0c             	sub    $0xc,%esp
80106619:	ff 75 f4             	push   -0xc(%ebp)
8010661c:	e8 cd b5 ff ff       	call   80101bee <iunlockput>
80106621:	83 c4 10             	add    $0x10,%esp
    end_op();
80106624:	e8 8d cf ff ff       	call   801035b6 <end_op>
    return -1;
80106629:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010662e:	eb 39                	jmp    80106669 <sys_chdir+0xb2>
  }
  iunlock(ip);
80106630:	83 ec 0c             	sub    $0xc,%esp
80106633:	ff 75 f4             	push   -0xc(%ebp)
80106636:	e8 51 b4 ff ff       	call   80101a8c <iunlock>
8010663b:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010663e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106644:	8b 40 68             	mov    0x68(%eax),%eax
80106647:	83 ec 0c             	sub    $0xc,%esp
8010664a:	50                   	push   %eax
8010664b:	e8 ae b4 ff ff       	call   80101afe <iput>
80106650:	83 c4 10             	add    $0x10,%esp
  end_op();
80106653:	e8 5e cf ff ff       	call   801035b6 <end_op>
  proc->cwd = ip;
80106658:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010665e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106661:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106664:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106669:	c9                   	leave  
8010666a:	c3                   	ret    

8010666b <sys_exec>:

int
sys_exec(void)
{
8010666b:	55                   	push   %ebp
8010666c:	89 e5                	mov    %esp,%ebp
8010666e:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106674:	83 ec 08             	sub    $0x8,%esp
80106677:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010667a:	50                   	push   %eax
8010667b:	6a 00                	push   $0x0
8010667d:	e8 9a f3 ff ff       	call   80105a1c <argstr>
80106682:	83 c4 10             	add    $0x10,%esp
80106685:	85 c0                	test   %eax,%eax
80106687:	78 18                	js     801066a1 <sys_exec+0x36>
80106689:	83 ec 08             	sub    $0x8,%esp
8010668c:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106692:	50                   	push   %eax
80106693:	6a 01                	push   $0x1
80106695:	e8 fd f2 ff ff       	call   80105997 <argint>
8010669a:	83 c4 10             	add    $0x10,%esp
8010669d:	85 c0                	test   %eax,%eax
8010669f:	79 0a                	jns    801066ab <sys_exec+0x40>
    return -1;
801066a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a6:	e9 c6 00 00 00       	jmp    80106771 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801066ab:	83 ec 04             	sub    $0x4,%esp
801066ae:	68 80 00 00 00       	push   $0x80
801066b3:	6a 00                	push   $0x0
801066b5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801066bb:	50                   	push   %eax
801066bc:	e8 b3 ef ff ff       	call   80105674 <memset>
801066c1:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801066c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801066cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ce:	83 f8 1f             	cmp    $0x1f,%eax
801066d1:	76 0a                	jbe    801066dd <sys_exec+0x72>
      return -1;
801066d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066d8:	e9 94 00 00 00       	jmp    80106771 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801066dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e0:	c1 e0 02             	shl    $0x2,%eax
801066e3:	89 c2                	mov    %eax,%edx
801066e5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801066eb:	01 c2                	add    %eax,%edx
801066ed:	83 ec 08             	sub    $0x8,%esp
801066f0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801066f6:	50                   	push   %eax
801066f7:	52                   	push   %edx
801066f8:	e8 00 f2 ff ff       	call   801058fd <fetchint>
801066fd:	83 c4 10             	add    $0x10,%esp
80106700:	85 c0                	test   %eax,%eax
80106702:	79 07                	jns    8010670b <sys_exec+0xa0>
      return -1;
80106704:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106709:	eb 66                	jmp    80106771 <sys_exec+0x106>
    if(uarg == 0){
8010670b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106711:	85 c0                	test   %eax,%eax
80106713:	75 27                	jne    8010673c <sys_exec+0xd1>
      argv[i] = 0;
80106715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106718:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010671f:	00 00 00 00 
      break;
80106723:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106724:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106727:	83 ec 08             	sub    $0x8,%esp
8010672a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106730:	52                   	push   %edx
80106731:	50                   	push   %eax
80106732:	e8 48 a4 ff ff       	call   80100b7f <exec>
80106737:	83 c4 10             	add    $0x10,%esp
8010673a:	eb 35                	jmp    80106771 <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
8010673c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106745:	c1 e0 02             	shl    $0x2,%eax
80106748:	01 c2                	add    %eax,%edx
8010674a:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106750:	83 ec 08             	sub    $0x8,%esp
80106753:	52                   	push   %edx
80106754:	50                   	push   %eax
80106755:	e8 dd f1 ff ff       	call   80105937 <fetchstr>
8010675a:	83 c4 10             	add    $0x10,%esp
8010675d:	85 c0                	test   %eax,%eax
8010675f:	79 07                	jns    80106768 <sys_exec+0xfd>
      return -1;
80106761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106766:	eb 09                	jmp    80106771 <sys_exec+0x106>
  for(i=0;; i++){
80106768:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
8010676c:	e9 5a ff ff ff       	jmp    801066cb <sys_exec+0x60>
}
80106771:	c9                   	leave  
80106772:	c3                   	ret    

80106773 <sys_pipe>:

int
sys_pipe(void)
{
80106773:	55                   	push   %ebp
80106774:	89 e5                	mov    %esp,%ebp
80106776:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106779:	83 ec 04             	sub    $0x4,%esp
8010677c:	6a 08                	push   $0x8
8010677e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106781:	50                   	push   %eax
80106782:	6a 00                	push   $0x0
80106784:	e8 36 f2 ff ff       	call   801059bf <argptr>
80106789:	83 c4 10             	add    $0x10,%esp
8010678c:	85 c0                	test   %eax,%eax
8010678e:	79 0a                	jns    8010679a <sys_pipe+0x27>
    return -1;
80106790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106795:	e9 af 00 00 00       	jmp    80106849 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
8010679a:	83 ec 08             	sub    $0x8,%esp
8010679d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801067a0:	50                   	push   %eax
801067a1:	8d 45 e8             	lea    -0x18(%ebp),%eax
801067a4:	50                   	push   %eax
801067a5:	e8 7c d8 ff ff       	call   80104026 <pipealloc>
801067aa:	83 c4 10             	add    $0x10,%esp
801067ad:	85 c0                	test   %eax,%eax
801067af:	79 0a                	jns    801067bb <sys_pipe+0x48>
    return -1;
801067b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b6:	e9 8e 00 00 00       	jmp    80106849 <sys_pipe+0xd6>
  fd0 = -1;
801067bb:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801067c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801067c5:	83 ec 0c             	sub    $0xc,%esp
801067c8:	50                   	push   %eax
801067c9:	e8 79 f3 ff ff       	call   80105b47 <fdalloc>
801067ce:	83 c4 10             	add    $0x10,%esp
801067d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067d8:	78 18                	js     801067f2 <sys_pipe+0x7f>
801067da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067dd:	83 ec 0c             	sub    $0xc,%esp
801067e0:	50                   	push   %eax
801067e1:	e8 61 f3 ff ff       	call   80105b47 <fdalloc>
801067e6:	83 c4 10             	add    $0x10,%esp
801067e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067f0:	79 3f                	jns    80106831 <sys_pipe+0xbe>
    if(fd0 >= 0)
801067f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067f6:	78 14                	js     8010680c <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801067f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106801:	83 c2 08             	add    $0x8,%edx
80106804:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010680b:	00 
    fileclose(rf);
8010680c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010680f:	83 ec 0c             	sub    $0xc,%esp
80106812:	50                   	push   %eax
80106813:	e8 47 a8 ff ff       	call   8010105f <fileclose>
80106818:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010681b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010681e:	83 ec 0c             	sub    $0xc,%esp
80106821:	50                   	push   %eax
80106822:	e8 38 a8 ff ff       	call   8010105f <fileclose>
80106827:	83 c4 10             	add    $0x10,%esp
    return -1;
8010682a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010682f:	eb 18                	jmp    80106849 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106831:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106834:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106837:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106839:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010683c:	8d 50 04             	lea    0x4(%eax),%edx
8010683f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106842:	89 02                	mov    %eax,(%edx)
  return 0;
80106844:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106849:	c9                   	leave  
8010684a:	c3                   	ret    

8010684b <outw>:
{
8010684b:	55                   	push   %ebp
8010684c:	89 e5                	mov    %esp,%ebp
8010684e:	83 ec 08             	sub    $0x8,%esp
80106851:	8b 55 08             	mov    0x8(%ebp),%edx
80106854:	8b 45 0c             	mov    0xc(%ebp),%eax
80106857:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010685b:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010685f:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106863:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106867:	66 ef                	out    %ax,(%dx)
}
80106869:	90                   	nop
8010686a:	c9                   	leave  
8010686b:	c3                   	ret    

8010686c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010686c:	55                   	push   %ebp
8010686d:	89 e5                	mov    %esp,%ebp
8010686f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106872:	e8 ff de ff ff       	call   80104776 <fork>
}
80106877:	c9                   	leave  
80106878:	c3                   	ret    

80106879 <sys_exit>:

int
sys_exit(void)
{
80106879:	55                   	push   %ebp
8010687a:	89 e5                	mov    %esp,%ebp
8010687c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010687f:	e8 7f e0 ff ff       	call   80104903 <exit>
  return 0;  // not reached
80106884:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106889:	c9                   	leave  
8010688a:	c3                   	ret    

8010688b <sys_wait>:

int
sys_wait(void)
{
8010688b:	55                   	push   %ebp
8010688c:	89 e5                	mov    %esp,%ebp
8010688e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106891:	e8 a8 e1 ff ff       	call   80104a3e <wait>
}
80106896:	c9                   	leave  
80106897:	c3                   	ret    

80106898 <sys_kill>:

int
sys_kill(void)
{
80106898:	55                   	push   %ebp
80106899:	89 e5                	mov    %esp,%ebp
8010689b:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010689e:	83 ec 08             	sub    $0x8,%esp
801068a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068a4:	50                   	push   %eax
801068a5:	6a 00                	push   $0x0
801068a7:	e8 eb f0 ff ff       	call   80105997 <argint>
801068ac:	83 c4 10             	add    $0x10,%esp
801068af:	85 c0                	test   %eax,%eax
801068b1:	79 07                	jns    801068ba <sys_kill+0x22>
    return -1;
801068b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b8:	eb 0f                	jmp    801068c9 <sys_kill+0x31>
  return kill(pid);
801068ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bd:	83 ec 0c             	sub    $0xc,%esp
801068c0:	50                   	push   %eax
801068c1:	e8 c7 e5 ff ff       	call   80104e8d <kill>
801068c6:	83 c4 10             	add    $0x10,%esp
}
801068c9:	c9                   	leave  
801068ca:	c3                   	ret    

801068cb <sys_getpid>:

int
sys_getpid(void)
{
801068cb:	55                   	push   %ebp
801068cc:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801068ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068d4:	8b 40 10             	mov    0x10(%eax),%eax
}
801068d7:	5d                   	pop    %ebp
801068d8:	c3                   	ret    

801068d9 <sys_sbrk>:

int
sys_sbrk(void)
{
801068d9:	55                   	push   %ebp
801068da:	89 e5                	mov    %esp,%ebp
801068dc:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801068df:	83 ec 08             	sub    $0x8,%esp
801068e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068e5:	50                   	push   %eax
801068e6:	6a 00                	push   $0x0
801068e8:	e8 aa f0 ff ff       	call   80105997 <argint>
801068ed:	83 c4 10             	add    $0x10,%esp
801068f0:	85 c0                	test   %eax,%eax
801068f2:	79 07                	jns    801068fb <sys_sbrk+0x22>
    return -1;
801068f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068f9:	eb 28                	jmp    80106923 <sys_sbrk+0x4a>
  addr = proc->sz;
801068fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106901:	8b 00                	mov    (%eax),%eax
80106903:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106906:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106909:	83 ec 0c             	sub    $0xc,%esp
8010690c:	50                   	push   %eax
8010690d:	e8 b2 dd ff ff       	call   801046c4 <growproc>
80106912:	83 c4 10             	add    $0x10,%esp
80106915:	85 c0                	test   %eax,%eax
80106917:	79 07                	jns    80106920 <sys_sbrk+0x47>
    return -1;
80106919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010691e:	eb 03                	jmp    80106923 <sys_sbrk+0x4a>
  return addr;
80106920:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106923:	c9                   	leave  
80106924:	c3                   	ret    

80106925 <sys_sleep>:

int
sys_sleep(void)
{
80106925:	55                   	push   %ebp
80106926:	89 e5                	mov    %esp,%ebp
80106928:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010692b:	83 ec 08             	sub    $0x8,%esp
8010692e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106931:	50                   	push   %eax
80106932:	6a 00                	push   $0x0
80106934:	e8 5e f0 ff ff       	call   80105997 <argint>
80106939:	83 c4 10             	add    $0x10,%esp
8010693c:	85 c0                	test   %eax,%eax
8010693e:	79 07                	jns    80106947 <sys_sleep+0x22>
    return -1;
80106940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106945:	eb 77                	jmp    801069be <sys_sleep+0x99>
  acquire(&tickslock);
80106947:	83 ec 0c             	sub    $0xc,%esp
8010694a:	68 a0 62 11 80       	push   $0x801162a0
8010694f:	e8 bd ea ff ff       	call   80105411 <acquire>
80106954:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106957:	a1 d4 62 11 80       	mov    0x801162d4,%eax
8010695c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010695f:	eb 39                	jmp    8010699a <sys_sleep+0x75>
    if(proc->killed){
80106961:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106967:	8b 40 24             	mov    0x24(%eax),%eax
8010696a:	85 c0                	test   %eax,%eax
8010696c:	74 17                	je     80106985 <sys_sleep+0x60>
      release(&tickslock);
8010696e:	83 ec 0c             	sub    $0xc,%esp
80106971:	68 a0 62 11 80       	push   $0x801162a0
80106976:	e8 fd ea ff ff       	call   80105478 <release>
8010697b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010697e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106983:	eb 39                	jmp    801069be <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
80106985:	83 ec 08             	sub    $0x8,%esp
80106988:	68 a0 62 11 80       	push   $0x801162a0
8010698d:	68 d4 62 11 80       	push   $0x801162d4
80106992:	e8 d0 e3 ff ff       	call   80104d67 <sleep>
80106997:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
8010699a:	a1 d4 62 11 80       	mov    0x801162d4,%eax
8010699f:	2b 45 f4             	sub    -0xc(%ebp),%eax
801069a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801069a5:	39 d0                	cmp    %edx,%eax
801069a7:	72 b8                	jb     80106961 <sys_sleep+0x3c>
  }
  release(&tickslock);
801069a9:	83 ec 0c             	sub    $0xc,%esp
801069ac:	68 a0 62 11 80       	push   $0x801162a0
801069b1:	e8 c2 ea ff ff       	call   80105478 <release>
801069b6:	83 c4 10             	add    $0x10,%esp
  return 0;
801069b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069be:	c9                   	leave  
801069bf:	c3                   	ret    

801069c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
801069c6:	83 ec 0c             	sub    $0xc,%esp
801069c9:	68 a0 62 11 80       	push   $0x801162a0
801069ce:	e8 3e ea ff ff       	call   80105411 <acquire>
801069d3:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
801069d6:	a1 d4 62 11 80       	mov    0x801162d4,%eax
801069db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801069de:	83 ec 0c             	sub    $0xc,%esp
801069e1:	68 a0 62 11 80       	push   $0x801162a0
801069e6:	e8 8d ea ff ff       	call   80105478 <release>
801069eb:	83 c4 10             	add    $0x10,%esp
  return xticks;
801069ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801069f1:	c9                   	leave  
801069f2:	c3                   	ret    

801069f3 <sys_halt>:
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
801069f3:	55                   	push   %ebp
801069f4:	89 e5                	mov    %esp,%ebp
801069f6:	83 ec 10             	sub    $0x10,%esp
  char *p = "Shutdown";
801069f9:	c7 45 fc 36 97 10 80 	movl   $0x80109736,-0x4(%ebp)
  for( ; *p; p++)
80106a00:	eb 16                	jmp    80106a18 <sys_halt+0x25>
    outw(0xB004, 0x2000);
80106a02:	68 00 20 00 00       	push   $0x2000
80106a07:	68 04 b0 00 00       	push   $0xb004
80106a0c:	e8 3a fe ff ff       	call   8010684b <outw>
80106a11:	83 c4 08             	add    $0x8,%esp
  for( ; *p; p++)
80106a14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106a1b:	0f b6 00             	movzbl (%eax),%eax
80106a1e:	84 c0                	test   %al,%al
80106a20:	75 e0                	jne    80106a02 <sys_halt+0xf>
  return 0;
80106a22:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a27:	c9                   	leave  
80106a28:	c3                   	ret    

80106a29 <sys_signal_register>:

int sys_signal_register(void)
{
80106a29:	55                   	push   %ebp
80106a2a:	89 e5                	mov    %esp,%ebp
80106a2c:	83 ec 18             	sub    $0x18,%esp
    uint signum;
    sighandler_t handler;
    int n;

    if (argint(0, &n) < 0)
80106a2f:	83 ec 08             	sub    $0x8,%esp
80106a32:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a35:	50                   	push   %eax
80106a36:	6a 00                	push   $0x0
80106a38:	e8 5a ef ff ff       	call   80105997 <argint>
80106a3d:	83 c4 10             	add    $0x10,%esp
80106a40:	85 c0                	test   %eax,%eax
80106a42:	79 07                	jns    80106a4b <sys_signal_register+0x22>
      return -1;
80106a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a49:	eb 3a                	jmp    80106a85 <sys_signal_register+0x5c>
    signum = (uint) n;
80106a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (argint(1, &n) < 0)
80106a51:	83 ec 08             	sub    $0x8,%esp
80106a54:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a57:	50                   	push   %eax
80106a58:	6a 01                	push   $0x1
80106a5a:	e8 38 ef ff ff       	call   80105997 <argint>
80106a5f:	83 c4 10             	add    $0x10,%esp
80106a62:	85 c0                	test   %eax,%eax
80106a64:	79 07                	jns    80106a6d <sys_signal_register+0x44>
      return -1;
80106a66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a6b:	eb 18                	jmp    80106a85 <sys_signal_register+0x5c>
    handler = (sighandler_t) n;
80106a6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106a70:	89 45 f0             	mov    %eax,-0x10(%ebp)

    return (int) signal_register_handler(signum, handler);
80106a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a76:	83 ec 08             	sub    $0x8,%esp
80106a79:	ff 75 f0             	push   -0x10(%ebp)
80106a7c:	50                   	push   %eax
80106a7d:	e8 ae e6 ff ff       	call   80105130 <signal_register_handler>
80106a82:	83 c4 10             	add    $0x10,%esp
}
80106a85:	c9                   	leave  
80106a86:	c3                   	ret    

80106a87 <sys_signal_restorer>:

int sys_signal_restorer(void)
{
80106a87:	55                   	push   %ebp
80106a88:	89 e5                	mov    %esp,%ebp
80106a8a:	83 ec 18             	sub    $0x18,%esp
    int restorer_addr;
    if (argint(0, &restorer_addr) < 0)
80106a8d:	83 ec 08             	sub    $0x8,%esp
80106a90:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a93:	50                   	push   %eax
80106a94:	6a 00                	push   $0x0
80106a96:	e8 fc ee ff ff       	call   80105997 <argint>
80106a9b:	83 c4 10             	add    $0x10,%esp
80106a9e:	85 c0                	test   %eax,%eax
80106aa0:	79 07                	jns    80106aa9 <sys_signal_restorer+0x22>
      return -1;
80106aa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa7:	eb 14                	jmp    80106abd <sys_signal_restorer+0x36>

    proc->restorer_addr = (uint) restorer_addr;
80106aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106aac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ab2:	89 90 b8 00 00 00    	mov    %edx,0xb8(%eax)
    
    return 0;
80106ab8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106abd:	c9                   	leave  
80106abe:	c3                   	ret    

80106abf <sys_mprotect>:

int sys_mprotect(void)
{
80106abf:	55                   	push   %ebp
80106ac0:	89 e5                	mov    %esp,%ebp
80106ac2:	83 ec 18             	sub    $0x18,%esp
  cprintf("In mprotect system call.\n");
80106ac5:	83 ec 0c             	sub    $0xc,%esp
80106ac8:	68 3f 97 10 80       	push   $0x8010973f
80106acd:	e8 f4 98 ff ff       	call   801003c6 <cprintf>
80106ad2:	83 c4 10             	add    $0x10,%esp
  int addr;
  int len;
  int prot;

  if (argint(0, &addr) < 0)
80106ad5:	83 ec 08             	sub    $0x8,%esp
80106ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106adb:	50                   	push   %eax
80106adc:	6a 00                	push   $0x0
80106ade:	e8 b4 ee ff ff       	call   80105997 <argint>
80106ae3:	83 c4 10             	add    $0x10,%esp
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	79 07                	jns    80106af1 <sys_mprotect+0x32>
    return -1;
80106aea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aef:	eb 7f                	jmp    80106b70 <sys_mprotect+0xb1>
  if (argint(1, &len) < 0)
80106af1:	83 ec 08             	sub    $0x8,%esp
80106af4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106af7:	50                   	push   %eax
80106af8:	6a 01                	push   $0x1
80106afa:	e8 98 ee ff ff       	call   80105997 <argint>
80106aff:	83 c4 10             	add    $0x10,%esp
80106b02:	85 c0                	test   %eax,%eax
80106b04:	79 07                	jns    80106b0d <sys_mprotect+0x4e>
    return -1;
80106b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b0b:	eb 63                	jmp    80106b70 <sys_mprotect+0xb1>
  if (argint(2, &prot) < 0)
80106b0d:	83 ec 08             	sub    $0x8,%esp
80106b10:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b13:	50                   	push   %eax
80106b14:	6a 02                	push   $0x2
80106b16:	e8 7c ee ff ff       	call   80105997 <argint>
80106b1b:	83 c4 10             	add    $0x10,%esp
80106b1e:	85 c0                	test   %eax,%eax
80106b20:	79 07                	jns    80106b29 <sys_mprotect+0x6a>
    return -1;
80106b22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b27:	eb 47                	jmp    80106b70 <sys_mprotect+0xb1>

  if (prot > 0x003 || prot == 0x002) // invalid input for protection level
80106b29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b2c:	83 f8 03             	cmp    $0x3,%eax
80106b2f:	7f 08                	jg     80106b39 <sys_mprotect+0x7a>
80106b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b34:	83 f8 02             	cmp    $0x2,%eax
80106b37:	75 07                	jne    80106b40 <sys_mprotect+0x81>
    return -1;
80106b39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b3e:	eb 30                	jmp    80106b70 <sys_mprotect+0xb1>
  cprintf("addr: %d\nlen: %d\nprot: %d\n", addr, len, prot);
80106b40:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106b43:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b49:	51                   	push   %ecx
80106b4a:	52                   	push   %edx
80106b4b:	50                   	push   %eax
80106b4c:	68 59 97 10 80       	push   $0x80109759
80106b51:	e8 70 98 ff ff       	call   801003c6 <cprintf>
80106b56:	83 c4 10             	add    $0x10,%esp

  return mprotect(addr, len, prot);
80106b59:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106b5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b62:	83 ec 04             	sub    $0x4,%esp
80106b65:	51                   	push   %ecx
80106b66:	52                   	push   %edx
80106b67:	50                   	push   %eax
80106b68:	e8 83 21 00 00       	call   80108cf0 <mprotect>
80106b6d:	83 c4 10             	add    $0x10,%esp
}
80106b70:	c9                   	leave  
80106b71:	c3                   	ret    

80106b72 <sys_cowfork>:

int
sys_cowfork(void)
{
80106b72:	55                   	push   %ebp
80106b73:	89 e5                	mov    %esp,%ebp
80106b75:	83 ec 08             	sub    $0x8,%esp
  return cowfork();
80106b78:	e8 29 e6 ff ff       	call   801051a6 <cowfork>
}
80106b7d:	c9                   	leave  
80106b7e:	c3                   	ret    

80106b7f <sys_dsbrk>:

int
sys_dsbrk(void)
{
80106b7f:	55                   	push   %ebp
80106b80:	89 e5                	mov    %esp,%ebp
80106b82:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;
  
  if (proc->actualsz == 0) {
80106b85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b8b:	8b 80 c0 00 00 00    	mov    0xc0(%eax),%eax
80106b91:	85 c0                	test   %eax,%eax
80106b93:	75 15                	jne    80106baa <sys_dsbrk+0x2b>
    // cprintf("original proc size: %d\n", proc->sz);
    // cprintf("actual proc size: %d\n", proc->actualsz);
    proc->actualsz = proc->sz;
80106b95:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80106b9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ba2:	8b 12                	mov    (%edx),%edx
80106ba4:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
  }
  
  if(argint(0, &n) < 0)
80106baa:	83 ec 08             	sub    $0x8,%esp
80106bad:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bb0:	50                   	push   %eax
80106bb1:	6a 00                	push   $0x0
80106bb3:	e8 df ed ff ff       	call   80105997 <argint>
80106bb8:	83 c4 10             	add    $0x10,%esp
80106bbb:	85 c0                	test   %eax,%eax
80106bbd:	79 07                	jns    80106bc6 <sys_dsbrk+0x47>
    return -1;
80106bbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc4:	eb 28                	jmp    80106bee <sys_dsbrk+0x6f>
  addr = proc->sz;
80106bc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bcc:	8b 00                	mov    (%eax),%eax
80106bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(dgrowproc(n) < 0)
80106bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bd4:	83 ec 0c             	sub    $0xc,%esp
80106bd7:	50                   	push   %eax
80106bd8:	e8 73 e7 ff ff       	call   80105350 <dgrowproc>
80106bdd:	83 c4 10             	add    $0x10,%esp
80106be0:	85 c0                	test   %eax,%eax
80106be2:	79 07                	jns    80106beb <sys_dsbrk+0x6c>
    return -1;
80106be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106be9:	eb 03                	jmp    80106bee <sys_dsbrk+0x6f>
  
  // cprintf("proc size: %d\n", proc->sz);
  return addr;
80106beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106bee:	c9                   	leave  
80106bef:	c3                   	ret    

80106bf0 <outb>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	83 ec 08             	sub    $0x8,%esp
80106bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bfc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106c00:	89 d0                	mov    %edx,%eax
80106c02:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106c05:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106c09:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106c0d:	ee                   	out    %al,(%dx)
}
80106c0e:	90                   	nop
80106c0f:	c9                   	leave  
80106c10:	c3                   	ret    

80106c11 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106c11:	55                   	push   %ebp
80106c12:	89 e5                	mov    %esp,%ebp
80106c14:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106c17:	6a 34                	push   $0x34
80106c19:	6a 43                	push   $0x43
80106c1b:	e8 d0 ff ff ff       	call   80106bf0 <outb>
80106c20:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106c23:	68 9c 00 00 00       	push   $0x9c
80106c28:	6a 40                	push   $0x40
80106c2a:	e8 c1 ff ff ff       	call   80106bf0 <outb>
80106c2f:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106c32:	6a 2e                	push   $0x2e
80106c34:	6a 40                	push   $0x40
80106c36:	e8 b5 ff ff ff       	call   80106bf0 <outb>
80106c3b:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106c3e:	83 ec 0c             	sub    $0xc,%esp
80106c41:	6a 00                	push   $0x0
80106c43:	e8 c8 d2 ff ff       	call   80103f10 <picenable>
80106c48:	83 c4 10             	add    $0x10,%esp
}
80106c4b:	90                   	nop
80106c4c:	c9                   	leave  
80106c4d:	c3                   	ret    

80106c4e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106c4e:	1e                   	push   %ds
  pushl %es
80106c4f:	06                   	push   %es
  pushl %fs
80106c50:	0f a0                	push   %fs
  pushl %gs
80106c52:	0f a8                	push   %gs
  pushal
80106c54:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106c55:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106c59:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106c5b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106c5d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106c61:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106c63:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106c65:	54                   	push   %esp
  call trap
80106c66:	e8 d7 01 00 00       	call   80106e42 <trap>
  addl $4, %esp
80106c6b:	83 c4 04             	add    $0x4,%esp

80106c6e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106c6e:	61                   	popa   
  popl %gs
80106c6f:	0f a9                	pop    %gs
  popl %fs
80106c71:	0f a1                	pop    %fs
  popl %es
80106c73:	07                   	pop    %es
  popl %ds
80106c74:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106c75:	83 c4 08             	add    $0x8,%esp
  iret
80106c78:	cf                   	iret   

80106c79 <lidt>:
{
80106c79:	55                   	push   %ebp
80106c7a:	89 e5                	mov    %esp,%ebp
80106c7c:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106c7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c82:	83 e8 01             	sub    $0x1,%eax
80106c85:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106c89:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106c90:	8b 45 08             	mov    0x8(%ebp),%eax
80106c93:	c1 e8 10             	shr    $0x10,%eax
80106c96:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106c9a:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106c9d:	0f 01 18             	lidtl  (%eax)
}
80106ca0:	90                   	nop
80106ca1:	c9                   	leave  
80106ca2:	c3                   	ret    

80106ca3 <rcr2>:

static inline uint
rcr2(void)
{
80106ca3:	55                   	push   %ebp
80106ca4:	89 e5                	mov    %esp,%ebp
80106ca6:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106ca9:	0f 20 d0             	mov    %cr2,%eax
80106cac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106cb2:	c9                   	leave  
80106cb3:	c3                   	ret    

80106cb4 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106cb4:	55                   	push   %ebp
80106cb5:	89 e5                	mov    %esp,%ebp
80106cb7:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106cba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106cc1:	e9 c3 00 00 00       	jmp    80106d89 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cc9:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106cd0:	89 c2                	mov    %eax,%edx
80106cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cd5:	66 89 14 c5 a0 5a 11 	mov    %dx,-0x7feea560(,%eax,8)
80106cdc:	80 
80106cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ce0:	66 c7 04 c5 a2 5a 11 	movw   $0x8,-0x7feea55e(,%eax,8)
80106ce7:	80 08 00 
80106cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ced:	0f b6 14 c5 a4 5a 11 	movzbl -0x7feea55c(,%eax,8),%edx
80106cf4:	80 
80106cf5:	83 e2 e0             	and    $0xffffffe0,%edx
80106cf8:	88 14 c5 a4 5a 11 80 	mov    %dl,-0x7feea55c(,%eax,8)
80106cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d02:	0f b6 14 c5 a4 5a 11 	movzbl -0x7feea55c(,%eax,8),%edx
80106d09:	80 
80106d0a:	83 e2 1f             	and    $0x1f,%edx
80106d0d:	88 14 c5 a4 5a 11 80 	mov    %dl,-0x7feea55c(,%eax,8)
80106d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d17:	0f b6 14 c5 a5 5a 11 	movzbl -0x7feea55b(,%eax,8),%edx
80106d1e:	80 
80106d1f:	83 e2 f0             	and    $0xfffffff0,%edx
80106d22:	83 ca 0e             	or     $0xe,%edx
80106d25:	88 14 c5 a5 5a 11 80 	mov    %dl,-0x7feea55b(,%eax,8)
80106d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d2f:	0f b6 14 c5 a5 5a 11 	movzbl -0x7feea55b(,%eax,8),%edx
80106d36:	80 
80106d37:	83 e2 ef             	and    $0xffffffef,%edx
80106d3a:	88 14 c5 a5 5a 11 80 	mov    %dl,-0x7feea55b(,%eax,8)
80106d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d44:	0f b6 14 c5 a5 5a 11 	movzbl -0x7feea55b(,%eax,8),%edx
80106d4b:	80 
80106d4c:	83 e2 9f             	and    $0xffffff9f,%edx
80106d4f:	88 14 c5 a5 5a 11 80 	mov    %dl,-0x7feea55b(,%eax,8)
80106d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d59:	0f b6 14 c5 a5 5a 11 	movzbl -0x7feea55b(,%eax,8),%edx
80106d60:	80 
80106d61:	83 ca 80             	or     $0xffffff80,%edx
80106d64:	88 14 c5 a5 5a 11 80 	mov    %dl,-0x7feea55b(,%eax,8)
80106d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d6e:	8b 04 85 b0 c0 10 80 	mov    -0x7fef3f50(,%eax,4),%eax
80106d75:	c1 e8 10             	shr    $0x10,%eax
80106d78:	89 c2                	mov    %eax,%edx
80106d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d7d:	66 89 14 c5 a6 5a 11 	mov    %dx,-0x7feea55a(,%eax,8)
80106d84:	80 
  for(i = 0; i < 256; i++)
80106d85:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106d89:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106d90:	0f 8e 30 ff ff ff    	jle    80106cc6 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106d96:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106d9b:	66 a3 a0 5c 11 80    	mov    %ax,0x80115ca0
80106da1:	66 c7 05 a2 5c 11 80 	movw   $0x8,0x80115ca2
80106da8:	08 00 
80106daa:	0f b6 05 a4 5c 11 80 	movzbl 0x80115ca4,%eax
80106db1:	83 e0 e0             	and    $0xffffffe0,%eax
80106db4:	a2 a4 5c 11 80       	mov    %al,0x80115ca4
80106db9:	0f b6 05 a4 5c 11 80 	movzbl 0x80115ca4,%eax
80106dc0:	83 e0 1f             	and    $0x1f,%eax
80106dc3:	a2 a4 5c 11 80       	mov    %al,0x80115ca4
80106dc8:	0f b6 05 a5 5c 11 80 	movzbl 0x80115ca5,%eax
80106dcf:	83 c8 0f             	or     $0xf,%eax
80106dd2:	a2 a5 5c 11 80       	mov    %al,0x80115ca5
80106dd7:	0f b6 05 a5 5c 11 80 	movzbl 0x80115ca5,%eax
80106dde:	83 e0 ef             	and    $0xffffffef,%eax
80106de1:	a2 a5 5c 11 80       	mov    %al,0x80115ca5
80106de6:	0f b6 05 a5 5c 11 80 	movzbl 0x80115ca5,%eax
80106ded:	83 c8 60             	or     $0x60,%eax
80106df0:	a2 a5 5c 11 80       	mov    %al,0x80115ca5
80106df5:	0f b6 05 a5 5c 11 80 	movzbl 0x80115ca5,%eax
80106dfc:	83 c8 80             	or     $0xffffff80,%eax
80106dff:	a2 a5 5c 11 80       	mov    %al,0x80115ca5
80106e04:	a1 b0 c1 10 80       	mov    0x8010c1b0,%eax
80106e09:	c1 e8 10             	shr    $0x10,%eax
80106e0c:	66 a3 a6 5c 11 80    	mov    %ax,0x80115ca6
  
  initlock(&tickslock, "time");
80106e12:	83 ec 08             	sub    $0x8,%esp
80106e15:	68 74 97 10 80       	push   $0x80109774
80106e1a:	68 a0 62 11 80       	push   $0x801162a0
80106e1f:	e8 cb e5 ff ff       	call   801053ef <initlock>
80106e24:	83 c4 10             	add    $0x10,%esp
}
80106e27:	90                   	nop
80106e28:	c9                   	leave  
80106e29:	c3                   	ret    

80106e2a <idtinit>:

void
idtinit(void)
{
80106e2a:	55                   	push   %ebp
80106e2b:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80106e2d:	68 00 08 00 00       	push   $0x800
80106e32:	68 a0 5a 11 80       	push   $0x80115aa0
80106e37:	e8 3d fe ff ff       	call   80106c79 <lidt>
80106e3c:	83 c4 08             	add    $0x8,%esp
}
80106e3f:	90                   	nop
80106e40:	c9                   	leave  
80106e41:	c3                   	ret    

80106e42 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106e42:	55                   	push   %ebp
80106e43:	89 e5                	mov    %esp,%ebp
80106e45:	57                   	push   %edi
80106e46:	56                   	push   %esi
80106e47:	53                   	push   %ebx
80106e48:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e4e:	8b 40 30             	mov    0x30(%eax),%eax
80106e51:	83 f8 40             	cmp    $0x40,%eax
80106e54:	75 3e                	jne    80106e94 <trap+0x52>
    if(proc->killed)
80106e56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e5c:	8b 40 24             	mov    0x24(%eax),%eax
80106e5f:	85 c0                	test   %eax,%eax
80106e61:	74 05                	je     80106e68 <trap+0x26>
      exit();
80106e63:	e8 9b da ff ff       	call   80104903 <exit>
    proc->tf = tf;
80106e68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e6e:	8b 55 08             	mov    0x8(%ebp),%edx
80106e71:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106e74:	e8 d4 eb ff ff       	call   80105a4d <syscall>
    if(proc->killed)
80106e79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e7f:	8b 40 24             	mov    0x24(%eax),%eax
80106e82:	85 c0                	test   %eax,%eax
80106e84:	0f 84 a5 03 00 00    	je     8010722f <trap+0x3ed>
      exit();
80106e8a:	e8 74 da ff ff       	call   80104903 <exit>
    return;
80106e8f:	e9 9b 03 00 00       	jmp    8010722f <trap+0x3ed>
  }

  switch(tf->trapno){
80106e94:	8b 45 08             	mov    0x8(%ebp),%eax
80106e97:	8b 40 30             	mov    0x30(%eax),%eax
80106e9a:	83 f8 3f             	cmp    $0x3f,%eax
80106e9d:	0f 87 49 02 00 00    	ja     801070ec <trap+0x2aa>
80106ea3:	8b 04 85 2c 98 10 80 	mov    -0x7fef67d4(,%eax,4),%eax
80106eaa:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106eac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106eb2:	0f b6 00             	movzbl (%eax),%eax
80106eb5:	84 c0                	test   %al,%al
80106eb7:	75 3d                	jne    80106ef6 <trap+0xb4>
      acquire(&tickslock);
80106eb9:	83 ec 0c             	sub    $0xc,%esp
80106ebc:	68 a0 62 11 80       	push   $0x801162a0
80106ec1:	e8 4b e5 ff ff       	call   80105411 <acquire>
80106ec6:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106ec9:	a1 d4 62 11 80       	mov    0x801162d4,%eax
80106ece:	83 c0 01             	add    $0x1,%eax
80106ed1:	a3 d4 62 11 80       	mov    %eax,0x801162d4
      wakeup(&ticks);
80106ed6:	83 ec 0c             	sub    $0xc,%esp
80106ed9:	68 d4 62 11 80       	push   $0x801162d4
80106ede:	e8 73 df ff ff       	call   80104e56 <wakeup>
80106ee3:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106ee6:	83 ec 0c             	sub    $0xc,%esp
80106ee9:	68 a0 62 11 80       	push   $0x801162a0
80106eee:	e8 85 e5 ff ff       	call   80105478 <release>
80106ef3:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106ef6:	e8 09 c1 ff ff       	call   80103004 <lapiceoi>
    break;
80106efb:	e9 a9 02 00 00       	jmp    801071a9 <trap+0x367>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106f00:	e8 b0 b8 ff ff       	call   801027b5 <ideintr>
    lapiceoi();
80106f05:	e8 fa c0 ff ff       	call   80103004 <lapiceoi>
    break;
80106f0a:	e9 9a 02 00 00       	jmp    801071a9 <trap+0x367>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106f0f:	e8 ee be ff ff       	call   80102e02 <kbdintr>
    lapiceoi();
80106f14:	e8 eb c0 ff ff       	call   80103004 <lapiceoi>
    break;
80106f19:	e9 8b 02 00 00       	jmp    801071a9 <trap+0x367>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106f1e:	e8 ef 04 00 00       	call   80107412 <uartintr>
    lapiceoi();
80106f23:	e8 dc c0 ff ff       	call   80103004 <lapiceoi>
    break;
80106f28:	e9 7c 02 00 00       	jmp    801071a9 <trap+0x367>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f2d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f30:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106f33:	8b 45 08             	mov    0x8(%ebp),%eax
80106f36:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f3a:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106f3d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106f43:	0f b6 00             	movzbl (%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106f46:	0f b6 c0             	movzbl %al,%eax
80106f49:	51                   	push   %ecx
80106f4a:	52                   	push   %edx
80106f4b:	50                   	push   %eax
80106f4c:	68 7c 97 10 80       	push   $0x8010977c
80106f51:	e8 70 94 ff ff       	call   801003c6 <cprintf>
80106f56:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106f59:	e8 a6 c0 ff ff       	call   80103004 <lapiceoi>
    break;
80106f5e:	e9 46 02 00 00       	jmp    801071a9 <trap+0x367>
   
  case T_DIVIDE:
    if (proc->handlers[SIGFPE] != (sighandler_t) -1) {
80106f63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f69:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106f6f:	83 f8 ff             	cmp    $0xffffffff,%eax
80106f72:	74 26                	je     80106f9a <trap+0x158>
      siginfo_t info;
      info.addr = 0;
80106f74:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
      info.type = 0;
80106f7b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
      signal_deliver(SIGFPE, info);
80106f82:	83 ec 04             	sub    $0x4,%esp
80106f85:	ff 75 dc             	push   -0x24(%ebp)
80106f88:	ff 75 d8             	push   -0x28(%ebp)
80106f8b:	6a 01                	push   $0x1
80106f8d:	e8 7f e0 ff ff       	call   80105011 <signal_deliver>
80106f92:	83 c4 10             	add    $0x10,%esp
      break;
80106f95:	e9 0f 02 00 00       	jmp    801071a9 <trap+0x367>
    }

  case T_PGFLT:
    if (proc->handlers[SIGSEGV] != (sighandler_t) -1) {
80106f9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fa0:	8b 80 b4 00 00 00    	mov    0xb4(%eax),%eax
80106fa6:	83 f8 ff             	cmp    $0xffffffff,%eax
80106fa9:	74 6d                	je     80107018 <trap+0x1d6>
      siginfo_t info;
      info.addr = rcr2(); // get the error access address
80106fab:	e8 f3 fc ff ff       	call   80106ca3 <rcr2>
80106fb0:	89 45 d0             	mov    %eax,-0x30(%ebp)

      uint temp = tf->err;
80106fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80106fb6:	8b 40 34             	mov    0x34(%eax),%eax
80106fb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cprintf("err num: 0x%x\n", temp);
80106fbc:	83 ec 08             	sub    $0x8,%esp
80106fbf:	ff 75 e4             	push   -0x1c(%ebp)
80106fc2:	68 a0 97 10 80       	push   $0x801097a0
80106fc7:	e8 fa 93 ff ff       	call   801003c6 <cprintf>
80106fcc:	83 c4 10             	add    $0x10,%esp
      // make sure it is not a Supervisory process
      if (temp >= 0x4) {
80106fcf:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
80106fd3:	76 43                	jbe    80107018 <trap+0x1d6>
        if (temp == 0x4 || temp == 0x6) {
80106fd5:	83 7d e4 04          	cmpl   $0x4,-0x1c(%ebp)
80106fd9:	74 06                	je     80106fe1 <trap+0x19f>
80106fdb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
80106fdf:	75 09                	jne    80106fea <trap+0x1a8>
          info.type = PROT_NONE;
80106fe1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80106fe8:	eb 16                	jmp    80107000 <trap+0x1be>
        }
        else if (temp == 0x7) {
80106fea:	83 7d e4 07          	cmpl   $0x7,-0x1c(%ebp)
80106fee:	75 09                	jne    80106ff9 <trap+0x1b7>
          info.type = PROT_READ;
80106ff0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
80106ff7:	eb 07                	jmp    80107000 <trap+0x1be>
        }
        else {
          info.type = PROT_WRITE; 
80106ff9:	c7 45 d4 03 00 00 00 	movl   $0x3,-0x2c(%ebp)
        }
   
        signal_deliver(SIGSEGV, info);
80107000:	83 ec 04             	sub    $0x4,%esp
80107003:	ff 75 d4             	push   -0x2c(%ebp)
80107006:	ff 75 d0             	push   -0x30(%ebp)
80107009:	6a 0e                	push   $0xe
8010700b:	e8 01 e0 ff ff       	call   80105011 <signal_deliver>
80107010:	83 c4 10             	add    $0x10,%esp
80107013:	e9 91 01 00 00       	jmp    801071a9 <trap+0x367>
        break;
      }
    }

    // for share part
    if (proc->shared == 1 && cowcopyuvm() != 0) {
80107018:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010701e:	8b 80 bc 00 00 00    	mov    0xbc(%eax),%eax
80107024:	83 f8 01             	cmp    $0x1,%eax
80107027:	75 0d                	jne    80107036 <trap+0x1f4>
80107029:	e8 fb 1e 00 00       	call   80108f29 <cowcopyuvm>
8010702e:	85 c0                	test   %eax,%eax
80107030:	0f 85 72 01 00 00    	jne    801071a8 <trap+0x366>
      break;
    }


    // for the demand heap allocation
    uint addr = rcr2(); 
80107036:	e8 68 fc ff ff       	call   80106ca3 <rcr2>
8010703b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    // judge if the err address is in the heap space
    if (addr > tf->ebp && addr < proc->sz && proc->actualsz != proc->sz) {
8010703e:	8b 45 08             	mov    0x8(%ebp),%eax
80107041:	8b 40 08             	mov    0x8(%eax),%eax
80107044:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80107047:	0f 86 9f 00 00 00    	jbe    801070ec <trap+0x2aa>
8010704d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107053:	8b 00                	mov    (%eax),%eax
80107055:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80107058:	0f 83 8e 00 00 00    	jae    801070ec <trap+0x2aa>
8010705e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107064:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
8010706a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107070:	8b 00                	mov    (%eax),%eax
80107072:	39 c2                	cmp    %eax,%edx
80107074:	74 76                	je     801070ec <trap+0x2aa>
      // cprintf("proc size: %d\n", proc->sz);
      // cprintf("proc actual size: %d\n", proc->actualsz);
      // cprintf("error addr: %d\n", rcr2());
      proc->actualsz = allocuvm(proc->pgdir, proc->actualsz, addr + 1);
80107076:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107079:	8d 48 01             	lea    0x1(%eax),%ecx
8010707c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107082:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
80107088:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010708e:	8b 40 04             	mov    0x4(%eax),%eax
80107091:	83 ec 04             	sub    $0x4,%esp
80107094:	51                   	push   %ecx
80107095:	52                   	push   %edx
80107096:	50                   	push   %eax
80107097:	e8 dc 17 00 00       	call   80108878 <allocuvm>
8010709c:	83 c4 10             	add    $0x10,%esp
8010709f:	89 c2                	mov    %eax,%edx
801070a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070a7:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
      if (proc->actualsz == proc->sz) {
801070ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070b3:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
801070b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070bf:	8b 00                	mov    (%eax),%eax
801070c1:	39 c2                	cmp    %eax,%edx
801070c3:	75 10                	jne    801070d5 <trap+0x293>
        proc->actualsz = 0;
801070c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070cb:	c7 80 c0 00 00 00 00 	movl   $0x0,0xc0(%eax)
801070d2:	00 00 00 
      }
      switchuvm(proc);
801070d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070db:	83 ec 0c             	sub    $0xc,%esp
801070de:	50                   	push   %eax
801070df:	e8 d3 14 00 00       	call   801085b7 <switchuvm>
801070e4:	83 c4 10             	add    $0x10,%esp
      break;
801070e7:	e9 bd 00 00 00       	jmp    801071a9 <trap+0x367>
    }

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801070ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f2:	85 c0                	test   %eax,%eax
801070f4:	74 11                	je     80107107 <trap+0x2c5>
801070f6:	8b 45 08             	mov    0x8(%ebp),%eax
801070f9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070fd:	0f b7 c0             	movzwl %ax,%eax
80107100:	83 e0 03             	and    $0x3,%eax
80107103:	85 c0                	test   %eax,%eax
80107105:	75 3f                	jne    80107146 <trap+0x304>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107107:	e8 97 fb ff ff       	call   80106ca3 <rcr2>
8010710c:	8b 55 08             	mov    0x8(%ebp),%edx
8010710f:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107112:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107119:	0f b6 12             	movzbl (%edx),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010711c:	0f b6 ca             	movzbl %dl,%ecx
8010711f:	8b 55 08             	mov    0x8(%ebp),%edx
80107122:	8b 52 30             	mov    0x30(%edx),%edx
80107125:	83 ec 0c             	sub    $0xc,%esp
80107128:	50                   	push   %eax
80107129:	53                   	push   %ebx
8010712a:	51                   	push   %ecx
8010712b:	52                   	push   %edx
8010712c:	68 b0 97 10 80       	push   $0x801097b0
80107131:	e8 90 92 ff ff       	call   801003c6 <cprintf>
80107136:	83 c4 20             	add    $0x20,%esp
      panic("trap");
80107139:	83 ec 0c             	sub    $0xc,%esp
8010713c:	68 e2 97 10 80       	push   $0x801097e2
80107141:	e8 35 94 ff ff       	call   8010057b <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107146:	e8 58 fb ff ff       	call   80106ca3 <rcr2>
8010714b:	89 c2                	mov    %eax,%edx
8010714d:	8b 45 08             	mov    0x8(%ebp),%eax
80107150:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107153:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107159:	0f b6 00             	movzbl (%eax),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010715c:	0f b6 f0             	movzbl %al,%esi
8010715f:	8b 45 08             	mov    0x8(%ebp),%eax
80107162:	8b 58 34             	mov    0x34(%eax),%ebx
80107165:	8b 45 08             	mov    0x8(%ebp),%eax
80107168:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010716b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107171:	83 c0 6c             	add    $0x6c,%eax
80107174:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107177:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010717d:	8b 40 10             	mov    0x10(%eax),%eax
80107180:	52                   	push   %edx
80107181:	57                   	push   %edi
80107182:	56                   	push   %esi
80107183:	53                   	push   %ebx
80107184:	51                   	push   %ecx
80107185:	ff 75 c4             	push   -0x3c(%ebp)
80107188:	50                   	push   %eax
80107189:	68 e8 97 10 80       	push   $0x801097e8
8010718e:	e8 33 92 ff ff       	call   801003c6 <cprintf>
80107193:	83 c4 20             	add    $0x20,%esp
            rcr2());
    proc->killed = 1;
80107196:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010719c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801071a3:	eb 04                	jmp    801071a9 <trap+0x367>
    break;
801071a5:	90                   	nop
801071a6:	eb 01                	jmp    801071a9 <trap+0x367>
      break;
801071a8:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801071a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071af:	85 c0                	test   %eax,%eax
801071b1:	74 24                	je     801071d7 <trap+0x395>
801071b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071b9:	8b 40 24             	mov    0x24(%eax),%eax
801071bc:	85 c0                	test   %eax,%eax
801071be:	74 17                	je     801071d7 <trap+0x395>
801071c0:	8b 45 08             	mov    0x8(%ebp),%eax
801071c3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071c7:	0f b7 c0             	movzwl %ax,%eax
801071ca:	83 e0 03             	and    $0x3,%eax
801071cd:	83 f8 03             	cmp    $0x3,%eax
801071d0:	75 05                	jne    801071d7 <trap+0x395>
    exit();
801071d2:	e8 2c d7 ff ff       	call   80104903 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801071d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071dd:	85 c0                	test   %eax,%eax
801071df:	74 1e                	je     801071ff <trap+0x3bd>
801071e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071e7:	8b 40 0c             	mov    0xc(%eax),%eax
801071ea:	83 f8 04             	cmp    $0x4,%eax
801071ed:	75 10                	jne    801071ff <trap+0x3bd>
801071ef:	8b 45 08             	mov    0x8(%ebp),%eax
801071f2:	8b 40 30             	mov    0x30(%eax),%eax
801071f5:	83 f8 20             	cmp    $0x20,%eax
801071f8:	75 05                	jne    801071ff <trap+0x3bd>
    yield();
801071fa:	e8 fc da ff ff       	call   80104cfb <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801071ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107205:	85 c0                	test   %eax,%eax
80107207:	74 27                	je     80107230 <trap+0x3ee>
80107209:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010720f:	8b 40 24             	mov    0x24(%eax),%eax
80107212:	85 c0                	test   %eax,%eax
80107214:	74 1a                	je     80107230 <trap+0x3ee>
80107216:	8b 45 08             	mov    0x8(%ebp),%eax
80107219:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010721d:	0f b7 c0             	movzwl %ax,%eax
80107220:	83 e0 03             	and    $0x3,%eax
80107223:	83 f8 03             	cmp    $0x3,%eax
80107226:	75 08                	jne    80107230 <trap+0x3ee>
    exit();
80107228:	e8 d6 d6 ff ff       	call   80104903 <exit>
8010722d:	eb 01                	jmp    80107230 <trap+0x3ee>
    return;
8010722f:	90                   	nop
}
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107233:	5b                   	pop    %ebx
80107234:	5e                   	pop    %esi
80107235:	5f                   	pop    %edi
80107236:	5d                   	pop    %ebp
80107237:	c3                   	ret    

80107238 <inb>:
{
80107238:	55                   	push   %ebp
80107239:	89 e5                	mov    %esp,%ebp
8010723b:	83 ec 14             	sub    $0x14,%esp
8010723e:	8b 45 08             	mov    0x8(%ebp),%eax
80107241:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107245:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107249:	89 c2                	mov    %eax,%edx
8010724b:	ec                   	in     (%dx),%al
8010724c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010724f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107253:	c9                   	leave  
80107254:	c3                   	ret    

80107255 <outb>:
{
80107255:	55                   	push   %ebp
80107256:	89 e5                	mov    %esp,%ebp
80107258:	83 ec 08             	sub    $0x8,%esp
8010725b:	8b 45 08             	mov    0x8(%ebp),%eax
8010725e:	8b 55 0c             	mov    0xc(%ebp),%edx
80107261:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107265:	89 d0                	mov    %edx,%eax
80107267:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010726a:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010726e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107272:	ee                   	out    %al,(%dx)
}
80107273:	90                   	nop
80107274:	c9                   	leave  
80107275:	c3                   	ret    

80107276 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107276:	55                   	push   %ebp
80107277:	89 e5                	mov    %esp,%ebp
80107279:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010727c:	6a 00                	push   $0x0
8010727e:	68 fa 03 00 00       	push   $0x3fa
80107283:	e8 cd ff ff ff       	call   80107255 <outb>
80107288:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010728b:	68 80 00 00 00       	push   $0x80
80107290:	68 fb 03 00 00       	push   $0x3fb
80107295:	e8 bb ff ff ff       	call   80107255 <outb>
8010729a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010729d:	6a 0c                	push   $0xc
8010729f:	68 f8 03 00 00       	push   $0x3f8
801072a4:	e8 ac ff ff ff       	call   80107255 <outb>
801072a9:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801072ac:	6a 00                	push   $0x0
801072ae:	68 f9 03 00 00       	push   $0x3f9
801072b3:	e8 9d ff ff ff       	call   80107255 <outb>
801072b8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801072bb:	6a 03                	push   $0x3
801072bd:	68 fb 03 00 00       	push   $0x3fb
801072c2:	e8 8e ff ff ff       	call   80107255 <outb>
801072c7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801072ca:	6a 00                	push   $0x0
801072cc:	68 fc 03 00 00       	push   $0x3fc
801072d1:	e8 7f ff ff ff       	call   80107255 <outb>
801072d6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801072d9:	6a 01                	push   $0x1
801072db:	68 f9 03 00 00       	push   $0x3f9
801072e0:	e8 70 ff ff ff       	call   80107255 <outb>
801072e5:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801072e8:	68 fd 03 00 00       	push   $0x3fd
801072ed:	e8 46 ff ff ff       	call   80107238 <inb>
801072f2:	83 c4 04             	add    $0x4,%esp
801072f5:	3c ff                	cmp    $0xff,%al
801072f7:	74 6e                	je     80107367 <uartinit+0xf1>
    return;
  uart = 1;
801072f9:	c7 05 d8 62 11 80 01 	movl   $0x1,0x801162d8
80107300:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107303:	68 fa 03 00 00       	push   $0x3fa
80107308:	e8 2b ff ff ff       	call   80107238 <inb>
8010730d:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107310:	68 f8 03 00 00       	push   $0x3f8
80107315:	e8 1e ff ff ff       	call   80107238 <inb>
8010731a:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010731d:	83 ec 0c             	sub    $0xc,%esp
80107320:	6a 04                	push   $0x4
80107322:	e8 e9 cb ff ff       	call   80103f10 <picenable>
80107327:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010732a:	83 ec 08             	sub    $0x8,%esp
8010732d:	6a 00                	push   $0x0
8010732f:	6a 04                	push   $0x4
80107331:	e8 21 b7 ff ff       	call   80102a57 <ioapicenable>
80107336:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107339:	c7 45 f4 2c 99 10 80 	movl   $0x8010992c,-0xc(%ebp)
80107340:	eb 19                	jmp    8010735b <uartinit+0xe5>
    uartputc(*p);
80107342:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107345:	0f b6 00             	movzbl (%eax),%eax
80107348:	0f be c0             	movsbl %al,%eax
8010734b:	83 ec 0c             	sub    $0xc,%esp
8010734e:	50                   	push   %eax
8010734f:	e8 16 00 00 00       	call   8010736a <uartputc>
80107354:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107357:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010735b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010735e:	0f b6 00             	movzbl (%eax),%eax
80107361:	84 c0                	test   %al,%al
80107363:	75 dd                	jne    80107342 <uartinit+0xcc>
80107365:	eb 01                	jmp    80107368 <uartinit+0xf2>
    return;
80107367:	90                   	nop
}
80107368:	c9                   	leave  
80107369:	c3                   	ret    

8010736a <uartputc>:

void
uartputc(int c)
{
8010736a:	55                   	push   %ebp
8010736b:	89 e5                	mov    %esp,%ebp
8010736d:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107370:	a1 d8 62 11 80       	mov    0x801162d8,%eax
80107375:	85 c0                	test   %eax,%eax
80107377:	74 53                	je     801073cc <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107379:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107380:	eb 11                	jmp    80107393 <uartputc+0x29>
    microdelay(10);
80107382:	83 ec 0c             	sub    $0xc,%esp
80107385:	6a 0a                	push   $0xa
80107387:	e8 93 bc ff ff       	call   8010301f <microdelay>
8010738c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010738f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107393:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107397:	7f 1a                	jg     801073b3 <uartputc+0x49>
80107399:	83 ec 0c             	sub    $0xc,%esp
8010739c:	68 fd 03 00 00       	push   $0x3fd
801073a1:	e8 92 fe ff ff       	call   80107238 <inb>
801073a6:	83 c4 10             	add    $0x10,%esp
801073a9:	0f b6 c0             	movzbl %al,%eax
801073ac:	83 e0 20             	and    $0x20,%eax
801073af:	85 c0                	test   %eax,%eax
801073b1:	74 cf                	je     80107382 <uartputc+0x18>
  outb(COM1+0, c);
801073b3:	8b 45 08             	mov    0x8(%ebp),%eax
801073b6:	0f b6 c0             	movzbl %al,%eax
801073b9:	83 ec 08             	sub    $0x8,%esp
801073bc:	50                   	push   %eax
801073bd:	68 f8 03 00 00       	push   $0x3f8
801073c2:	e8 8e fe ff ff       	call   80107255 <outb>
801073c7:	83 c4 10             	add    $0x10,%esp
801073ca:	eb 01                	jmp    801073cd <uartputc+0x63>
    return;
801073cc:	90                   	nop
}
801073cd:	c9                   	leave  
801073ce:	c3                   	ret    

801073cf <uartgetc>:

static int
uartgetc(void)
{
801073cf:	55                   	push   %ebp
801073d0:	89 e5                	mov    %esp,%ebp
  if(!uart)
801073d2:	a1 d8 62 11 80       	mov    0x801162d8,%eax
801073d7:	85 c0                	test   %eax,%eax
801073d9:	75 07                	jne    801073e2 <uartgetc+0x13>
    return -1;
801073db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073e0:	eb 2e                	jmp    80107410 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801073e2:	68 fd 03 00 00       	push   $0x3fd
801073e7:	e8 4c fe ff ff       	call   80107238 <inb>
801073ec:	83 c4 04             	add    $0x4,%esp
801073ef:	0f b6 c0             	movzbl %al,%eax
801073f2:	83 e0 01             	and    $0x1,%eax
801073f5:	85 c0                	test   %eax,%eax
801073f7:	75 07                	jne    80107400 <uartgetc+0x31>
    return -1;
801073f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073fe:	eb 10                	jmp    80107410 <uartgetc+0x41>
  return inb(COM1+0);
80107400:	68 f8 03 00 00       	push   $0x3f8
80107405:	e8 2e fe ff ff       	call   80107238 <inb>
8010740a:	83 c4 04             	add    $0x4,%esp
8010740d:	0f b6 c0             	movzbl %al,%eax
}
80107410:	c9                   	leave  
80107411:	c3                   	ret    

80107412 <uartintr>:

void
uartintr(void)
{
80107412:	55                   	push   %ebp
80107413:	89 e5                	mov    %esp,%ebp
80107415:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107418:	83 ec 0c             	sub    $0xc,%esp
8010741b:	68 cf 73 10 80       	push   $0x801073cf
80107420:	e8 db 93 ff ff       	call   80100800 <consoleintr>
80107425:	83 c4 10             	add    $0x10,%esp
}
80107428:	90                   	nop
80107429:	c9                   	leave  
8010742a:	c3                   	ret    

8010742b <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010742b:	6a 00                	push   $0x0
  pushl $0
8010742d:	6a 00                	push   $0x0
  jmp alltraps
8010742f:	e9 1a f8 ff ff       	jmp    80106c4e <alltraps>

80107434 <vector1>:
.globl vector1
vector1:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $1
80107436:	6a 01                	push   $0x1
  jmp alltraps
80107438:	e9 11 f8 ff ff       	jmp    80106c4e <alltraps>

8010743d <vector2>:
.globl vector2
vector2:
  pushl $0
8010743d:	6a 00                	push   $0x0
  pushl $2
8010743f:	6a 02                	push   $0x2
  jmp alltraps
80107441:	e9 08 f8 ff ff       	jmp    80106c4e <alltraps>

80107446 <vector3>:
.globl vector3
vector3:
  pushl $0
80107446:	6a 00                	push   $0x0
  pushl $3
80107448:	6a 03                	push   $0x3
  jmp alltraps
8010744a:	e9 ff f7 ff ff       	jmp    80106c4e <alltraps>

8010744f <vector4>:
.globl vector4
vector4:
  pushl $0
8010744f:	6a 00                	push   $0x0
  pushl $4
80107451:	6a 04                	push   $0x4
  jmp alltraps
80107453:	e9 f6 f7 ff ff       	jmp    80106c4e <alltraps>

80107458 <vector5>:
.globl vector5
vector5:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $5
8010745a:	6a 05                	push   $0x5
  jmp alltraps
8010745c:	e9 ed f7 ff ff       	jmp    80106c4e <alltraps>

80107461 <vector6>:
.globl vector6
vector6:
  pushl $0
80107461:	6a 00                	push   $0x0
  pushl $6
80107463:	6a 06                	push   $0x6
  jmp alltraps
80107465:	e9 e4 f7 ff ff       	jmp    80106c4e <alltraps>

8010746a <vector7>:
.globl vector7
vector7:
  pushl $0
8010746a:	6a 00                	push   $0x0
  pushl $7
8010746c:	6a 07                	push   $0x7
  jmp alltraps
8010746e:	e9 db f7 ff ff       	jmp    80106c4e <alltraps>

80107473 <vector8>:
.globl vector8
vector8:
  pushl $8
80107473:	6a 08                	push   $0x8
  jmp alltraps
80107475:	e9 d4 f7 ff ff       	jmp    80106c4e <alltraps>

8010747a <vector9>:
.globl vector9
vector9:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $9
8010747c:	6a 09                	push   $0x9
  jmp alltraps
8010747e:	e9 cb f7 ff ff       	jmp    80106c4e <alltraps>

80107483 <vector10>:
.globl vector10
vector10:
  pushl $10
80107483:	6a 0a                	push   $0xa
  jmp alltraps
80107485:	e9 c4 f7 ff ff       	jmp    80106c4e <alltraps>

8010748a <vector11>:
.globl vector11
vector11:
  pushl $11
8010748a:	6a 0b                	push   $0xb
  jmp alltraps
8010748c:	e9 bd f7 ff ff       	jmp    80106c4e <alltraps>

80107491 <vector12>:
.globl vector12
vector12:
  pushl $12
80107491:	6a 0c                	push   $0xc
  jmp alltraps
80107493:	e9 b6 f7 ff ff       	jmp    80106c4e <alltraps>

80107498 <vector13>:
.globl vector13
vector13:
  pushl $13
80107498:	6a 0d                	push   $0xd
  jmp alltraps
8010749a:	e9 af f7 ff ff       	jmp    80106c4e <alltraps>

8010749f <vector14>:
.globl vector14
vector14:
  pushl $14
8010749f:	6a 0e                	push   $0xe
  jmp alltraps
801074a1:	e9 a8 f7 ff ff       	jmp    80106c4e <alltraps>

801074a6 <vector15>:
.globl vector15
vector15:
  pushl $0
801074a6:	6a 00                	push   $0x0
  pushl $15
801074a8:	6a 0f                	push   $0xf
  jmp alltraps
801074aa:	e9 9f f7 ff ff       	jmp    80106c4e <alltraps>

801074af <vector16>:
.globl vector16
vector16:
  pushl $0
801074af:	6a 00                	push   $0x0
  pushl $16
801074b1:	6a 10                	push   $0x10
  jmp alltraps
801074b3:	e9 96 f7 ff ff       	jmp    80106c4e <alltraps>

801074b8 <vector17>:
.globl vector17
vector17:
  pushl $17
801074b8:	6a 11                	push   $0x11
  jmp alltraps
801074ba:	e9 8f f7 ff ff       	jmp    80106c4e <alltraps>

801074bf <vector18>:
.globl vector18
vector18:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $18
801074c1:	6a 12                	push   $0x12
  jmp alltraps
801074c3:	e9 86 f7 ff ff       	jmp    80106c4e <alltraps>

801074c8 <vector19>:
.globl vector19
vector19:
  pushl $0
801074c8:	6a 00                	push   $0x0
  pushl $19
801074ca:	6a 13                	push   $0x13
  jmp alltraps
801074cc:	e9 7d f7 ff ff       	jmp    80106c4e <alltraps>

801074d1 <vector20>:
.globl vector20
vector20:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $20
801074d3:	6a 14                	push   $0x14
  jmp alltraps
801074d5:	e9 74 f7 ff ff       	jmp    80106c4e <alltraps>

801074da <vector21>:
.globl vector21
vector21:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $21
801074dc:	6a 15                	push   $0x15
  jmp alltraps
801074de:	e9 6b f7 ff ff       	jmp    80106c4e <alltraps>

801074e3 <vector22>:
.globl vector22
vector22:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $22
801074e5:	6a 16                	push   $0x16
  jmp alltraps
801074e7:	e9 62 f7 ff ff       	jmp    80106c4e <alltraps>

801074ec <vector23>:
.globl vector23
vector23:
  pushl $0
801074ec:	6a 00                	push   $0x0
  pushl $23
801074ee:	6a 17                	push   $0x17
  jmp alltraps
801074f0:	e9 59 f7 ff ff       	jmp    80106c4e <alltraps>

801074f5 <vector24>:
.globl vector24
vector24:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $24
801074f7:	6a 18                	push   $0x18
  jmp alltraps
801074f9:	e9 50 f7 ff ff       	jmp    80106c4e <alltraps>

801074fe <vector25>:
.globl vector25
vector25:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $25
80107500:	6a 19                	push   $0x19
  jmp alltraps
80107502:	e9 47 f7 ff ff       	jmp    80106c4e <alltraps>

80107507 <vector26>:
.globl vector26
vector26:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $26
80107509:	6a 1a                	push   $0x1a
  jmp alltraps
8010750b:	e9 3e f7 ff ff       	jmp    80106c4e <alltraps>

80107510 <vector27>:
.globl vector27
vector27:
  pushl $0
80107510:	6a 00                	push   $0x0
  pushl $27
80107512:	6a 1b                	push   $0x1b
  jmp alltraps
80107514:	e9 35 f7 ff ff       	jmp    80106c4e <alltraps>

80107519 <vector28>:
.globl vector28
vector28:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $28
8010751b:	6a 1c                	push   $0x1c
  jmp alltraps
8010751d:	e9 2c f7 ff ff       	jmp    80106c4e <alltraps>

80107522 <vector29>:
.globl vector29
vector29:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $29
80107524:	6a 1d                	push   $0x1d
  jmp alltraps
80107526:	e9 23 f7 ff ff       	jmp    80106c4e <alltraps>

8010752b <vector30>:
.globl vector30
vector30:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $30
8010752d:	6a 1e                	push   $0x1e
  jmp alltraps
8010752f:	e9 1a f7 ff ff       	jmp    80106c4e <alltraps>

80107534 <vector31>:
.globl vector31
vector31:
  pushl $0
80107534:	6a 00                	push   $0x0
  pushl $31
80107536:	6a 1f                	push   $0x1f
  jmp alltraps
80107538:	e9 11 f7 ff ff       	jmp    80106c4e <alltraps>

8010753d <vector32>:
.globl vector32
vector32:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $32
8010753f:	6a 20                	push   $0x20
  jmp alltraps
80107541:	e9 08 f7 ff ff       	jmp    80106c4e <alltraps>

80107546 <vector33>:
.globl vector33
vector33:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $33
80107548:	6a 21                	push   $0x21
  jmp alltraps
8010754a:	e9 ff f6 ff ff       	jmp    80106c4e <alltraps>

8010754f <vector34>:
.globl vector34
vector34:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $34
80107551:	6a 22                	push   $0x22
  jmp alltraps
80107553:	e9 f6 f6 ff ff       	jmp    80106c4e <alltraps>

80107558 <vector35>:
.globl vector35
vector35:
  pushl $0
80107558:	6a 00                	push   $0x0
  pushl $35
8010755a:	6a 23                	push   $0x23
  jmp alltraps
8010755c:	e9 ed f6 ff ff       	jmp    80106c4e <alltraps>

80107561 <vector36>:
.globl vector36
vector36:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $36
80107563:	6a 24                	push   $0x24
  jmp alltraps
80107565:	e9 e4 f6 ff ff       	jmp    80106c4e <alltraps>

8010756a <vector37>:
.globl vector37
vector37:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $37
8010756c:	6a 25                	push   $0x25
  jmp alltraps
8010756e:	e9 db f6 ff ff       	jmp    80106c4e <alltraps>

80107573 <vector38>:
.globl vector38
vector38:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $38
80107575:	6a 26                	push   $0x26
  jmp alltraps
80107577:	e9 d2 f6 ff ff       	jmp    80106c4e <alltraps>

8010757c <vector39>:
.globl vector39
vector39:
  pushl $0
8010757c:	6a 00                	push   $0x0
  pushl $39
8010757e:	6a 27                	push   $0x27
  jmp alltraps
80107580:	e9 c9 f6 ff ff       	jmp    80106c4e <alltraps>

80107585 <vector40>:
.globl vector40
vector40:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $40
80107587:	6a 28                	push   $0x28
  jmp alltraps
80107589:	e9 c0 f6 ff ff       	jmp    80106c4e <alltraps>

8010758e <vector41>:
.globl vector41
vector41:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $41
80107590:	6a 29                	push   $0x29
  jmp alltraps
80107592:	e9 b7 f6 ff ff       	jmp    80106c4e <alltraps>

80107597 <vector42>:
.globl vector42
vector42:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $42
80107599:	6a 2a                	push   $0x2a
  jmp alltraps
8010759b:	e9 ae f6 ff ff       	jmp    80106c4e <alltraps>

801075a0 <vector43>:
.globl vector43
vector43:
  pushl $0
801075a0:	6a 00                	push   $0x0
  pushl $43
801075a2:	6a 2b                	push   $0x2b
  jmp alltraps
801075a4:	e9 a5 f6 ff ff       	jmp    80106c4e <alltraps>

801075a9 <vector44>:
.globl vector44
vector44:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $44
801075ab:	6a 2c                	push   $0x2c
  jmp alltraps
801075ad:	e9 9c f6 ff ff       	jmp    80106c4e <alltraps>

801075b2 <vector45>:
.globl vector45
vector45:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $45
801075b4:	6a 2d                	push   $0x2d
  jmp alltraps
801075b6:	e9 93 f6 ff ff       	jmp    80106c4e <alltraps>

801075bb <vector46>:
.globl vector46
vector46:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $46
801075bd:	6a 2e                	push   $0x2e
  jmp alltraps
801075bf:	e9 8a f6 ff ff       	jmp    80106c4e <alltraps>

801075c4 <vector47>:
.globl vector47
vector47:
  pushl $0
801075c4:	6a 00                	push   $0x0
  pushl $47
801075c6:	6a 2f                	push   $0x2f
  jmp alltraps
801075c8:	e9 81 f6 ff ff       	jmp    80106c4e <alltraps>

801075cd <vector48>:
.globl vector48
vector48:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $48
801075cf:	6a 30                	push   $0x30
  jmp alltraps
801075d1:	e9 78 f6 ff ff       	jmp    80106c4e <alltraps>

801075d6 <vector49>:
.globl vector49
vector49:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $49
801075d8:	6a 31                	push   $0x31
  jmp alltraps
801075da:	e9 6f f6 ff ff       	jmp    80106c4e <alltraps>

801075df <vector50>:
.globl vector50
vector50:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $50
801075e1:	6a 32                	push   $0x32
  jmp alltraps
801075e3:	e9 66 f6 ff ff       	jmp    80106c4e <alltraps>

801075e8 <vector51>:
.globl vector51
vector51:
  pushl $0
801075e8:	6a 00                	push   $0x0
  pushl $51
801075ea:	6a 33                	push   $0x33
  jmp alltraps
801075ec:	e9 5d f6 ff ff       	jmp    80106c4e <alltraps>

801075f1 <vector52>:
.globl vector52
vector52:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $52
801075f3:	6a 34                	push   $0x34
  jmp alltraps
801075f5:	e9 54 f6 ff ff       	jmp    80106c4e <alltraps>

801075fa <vector53>:
.globl vector53
vector53:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $53
801075fc:	6a 35                	push   $0x35
  jmp alltraps
801075fe:	e9 4b f6 ff ff       	jmp    80106c4e <alltraps>

80107603 <vector54>:
.globl vector54
vector54:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $54
80107605:	6a 36                	push   $0x36
  jmp alltraps
80107607:	e9 42 f6 ff ff       	jmp    80106c4e <alltraps>

8010760c <vector55>:
.globl vector55
vector55:
  pushl $0
8010760c:	6a 00                	push   $0x0
  pushl $55
8010760e:	6a 37                	push   $0x37
  jmp alltraps
80107610:	e9 39 f6 ff ff       	jmp    80106c4e <alltraps>

80107615 <vector56>:
.globl vector56
vector56:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $56
80107617:	6a 38                	push   $0x38
  jmp alltraps
80107619:	e9 30 f6 ff ff       	jmp    80106c4e <alltraps>

8010761e <vector57>:
.globl vector57
vector57:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $57
80107620:	6a 39                	push   $0x39
  jmp alltraps
80107622:	e9 27 f6 ff ff       	jmp    80106c4e <alltraps>

80107627 <vector58>:
.globl vector58
vector58:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $58
80107629:	6a 3a                	push   $0x3a
  jmp alltraps
8010762b:	e9 1e f6 ff ff       	jmp    80106c4e <alltraps>

80107630 <vector59>:
.globl vector59
vector59:
  pushl $0
80107630:	6a 00                	push   $0x0
  pushl $59
80107632:	6a 3b                	push   $0x3b
  jmp alltraps
80107634:	e9 15 f6 ff ff       	jmp    80106c4e <alltraps>

80107639 <vector60>:
.globl vector60
vector60:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $60
8010763b:	6a 3c                	push   $0x3c
  jmp alltraps
8010763d:	e9 0c f6 ff ff       	jmp    80106c4e <alltraps>

80107642 <vector61>:
.globl vector61
vector61:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $61
80107644:	6a 3d                	push   $0x3d
  jmp alltraps
80107646:	e9 03 f6 ff ff       	jmp    80106c4e <alltraps>

8010764b <vector62>:
.globl vector62
vector62:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $62
8010764d:	6a 3e                	push   $0x3e
  jmp alltraps
8010764f:	e9 fa f5 ff ff       	jmp    80106c4e <alltraps>

80107654 <vector63>:
.globl vector63
vector63:
  pushl $0
80107654:	6a 00                	push   $0x0
  pushl $63
80107656:	6a 3f                	push   $0x3f
  jmp alltraps
80107658:	e9 f1 f5 ff ff       	jmp    80106c4e <alltraps>

8010765d <vector64>:
.globl vector64
vector64:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $64
8010765f:	6a 40                	push   $0x40
  jmp alltraps
80107661:	e9 e8 f5 ff ff       	jmp    80106c4e <alltraps>

80107666 <vector65>:
.globl vector65
vector65:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $65
80107668:	6a 41                	push   $0x41
  jmp alltraps
8010766a:	e9 df f5 ff ff       	jmp    80106c4e <alltraps>

8010766f <vector66>:
.globl vector66
vector66:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $66
80107671:	6a 42                	push   $0x42
  jmp alltraps
80107673:	e9 d6 f5 ff ff       	jmp    80106c4e <alltraps>

80107678 <vector67>:
.globl vector67
vector67:
  pushl $0
80107678:	6a 00                	push   $0x0
  pushl $67
8010767a:	6a 43                	push   $0x43
  jmp alltraps
8010767c:	e9 cd f5 ff ff       	jmp    80106c4e <alltraps>

80107681 <vector68>:
.globl vector68
vector68:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $68
80107683:	6a 44                	push   $0x44
  jmp alltraps
80107685:	e9 c4 f5 ff ff       	jmp    80106c4e <alltraps>

8010768a <vector69>:
.globl vector69
vector69:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $69
8010768c:	6a 45                	push   $0x45
  jmp alltraps
8010768e:	e9 bb f5 ff ff       	jmp    80106c4e <alltraps>

80107693 <vector70>:
.globl vector70
vector70:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $70
80107695:	6a 46                	push   $0x46
  jmp alltraps
80107697:	e9 b2 f5 ff ff       	jmp    80106c4e <alltraps>

8010769c <vector71>:
.globl vector71
vector71:
  pushl $0
8010769c:	6a 00                	push   $0x0
  pushl $71
8010769e:	6a 47                	push   $0x47
  jmp alltraps
801076a0:	e9 a9 f5 ff ff       	jmp    80106c4e <alltraps>

801076a5 <vector72>:
.globl vector72
vector72:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $72
801076a7:	6a 48                	push   $0x48
  jmp alltraps
801076a9:	e9 a0 f5 ff ff       	jmp    80106c4e <alltraps>

801076ae <vector73>:
.globl vector73
vector73:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $73
801076b0:	6a 49                	push   $0x49
  jmp alltraps
801076b2:	e9 97 f5 ff ff       	jmp    80106c4e <alltraps>

801076b7 <vector74>:
.globl vector74
vector74:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $74
801076b9:	6a 4a                	push   $0x4a
  jmp alltraps
801076bb:	e9 8e f5 ff ff       	jmp    80106c4e <alltraps>

801076c0 <vector75>:
.globl vector75
vector75:
  pushl $0
801076c0:	6a 00                	push   $0x0
  pushl $75
801076c2:	6a 4b                	push   $0x4b
  jmp alltraps
801076c4:	e9 85 f5 ff ff       	jmp    80106c4e <alltraps>

801076c9 <vector76>:
.globl vector76
vector76:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $76
801076cb:	6a 4c                	push   $0x4c
  jmp alltraps
801076cd:	e9 7c f5 ff ff       	jmp    80106c4e <alltraps>

801076d2 <vector77>:
.globl vector77
vector77:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $77
801076d4:	6a 4d                	push   $0x4d
  jmp alltraps
801076d6:	e9 73 f5 ff ff       	jmp    80106c4e <alltraps>

801076db <vector78>:
.globl vector78
vector78:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $78
801076dd:	6a 4e                	push   $0x4e
  jmp alltraps
801076df:	e9 6a f5 ff ff       	jmp    80106c4e <alltraps>

801076e4 <vector79>:
.globl vector79
vector79:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $79
801076e6:	6a 4f                	push   $0x4f
  jmp alltraps
801076e8:	e9 61 f5 ff ff       	jmp    80106c4e <alltraps>

801076ed <vector80>:
.globl vector80
vector80:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $80
801076ef:	6a 50                	push   $0x50
  jmp alltraps
801076f1:	e9 58 f5 ff ff       	jmp    80106c4e <alltraps>

801076f6 <vector81>:
.globl vector81
vector81:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $81
801076f8:	6a 51                	push   $0x51
  jmp alltraps
801076fa:	e9 4f f5 ff ff       	jmp    80106c4e <alltraps>

801076ff <vector82>:
.globl vector82
vector82:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $82
80107701:	6a 52                	push   $0x52
  jmp alltraps
80107703:	e9 46 f5 ff ff       	jmp    80106c4e <alltraps>

80107708 <vector83>:
.globl vector83
vector83:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $83
8010770a:	6a 53                	push   $0x53
  jmp alltraps
8010770c:	e9 3d f5 ff ff       	jmp    80106c4e <alltraps>

80107711 <vector84>:
.globl vector84
vector84:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $84
80107713:	6a 54                	push   $0x54
  jmp alltraps
80107715:	e9 34 f5 ff ff       	jmp    80106c4e <alltraps>

8010771a <vector85>:
.globl vector85
vector85:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $85
8010771c:	6a 55                	push   $0x55
  jmp alltraps
8010771e:	e9 2b f5 ff ff       	jmp    80106c4e <alltraps>

80107723 <vector86>:
.globl vector86
vector86:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $86
80107725:	6a 56                	push   $0x56
  jmp alltraps
80107727:	e9 22 f5 ff ff       	jmp    80106c4e <alltraps>

8010772c <vector87>:
.globl vector87
vector87:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $87
8010772e:	6a 57                	push   $0x57
  jmp alltraps
80107730:	e9 19 f5 ff ff       	jmp    80106c4e <alltraps>

80107735 <vector88>:
.globl vector88
vector88:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $88
80107737:	6a 58                	push   $0x58
  jmp alltraps
80107739:	e9 10 f5 ff ff       	jmp    80106c4e <alltraps>

8010773e <vector89>:
.globl vector89
vector89:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $89
80107740:	6a 59                	push   $0x59
  jmp alltraps
80107742:	e9 07 f5 ff ff       	jmp    80106c4e <alltraps>

80107747 <vector90>:
.globl vector90
vector90:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $90
80107749:	6a 5a                	push   $0x5a
  jmp alltraps
8010774b:	e9 fe f4 ff ff       	jmp    80106c4e <alltraps>

80107750 <vector91>:
.globl vector91
vector91:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $91
80107752:	6a 5b                	push   $0x5b
  jmp alltraps
80107754:	e9 f5 f4 ff ff       	jmp    80106c4e <alltraps>

80107759 <vector92>:
.globl vector92
vector92:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $92
8010775b:	6a 5c                	push   $0x5c
  jmp alltraps
8010775d:	e9 ec f4 ff ff       	jmp    80106c4e <alltraps>

80107762 <vector93>:
.globl vector93
vector93:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $93
80107764:	6a 5d                	push   $0x5d
  jmp alltraps
80107766:	e9 e3 f4 ff ff       	jmp    80106c4e <alltraps>

8010776b <vector94>:
.globl vector94
vector94:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $94
8010776d:	6a 5e                	push   $0x5e
  jmp alltraps
8010776f:	e9 da f4 ff ff       	jmp    80106c4e <alltraps>

80107774 <vector95>:
.globl vector95
vector95:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $95
80107776:	6a 5f                	push   $0x5f
  jmp alltraps
80107778:	e9 d1 f4 ff ff       	jmp    80106c4e <alltraps>

8010777d <vector96>:
.globl vector96
vector96:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $96
8010777f:	6a 60                	push   $0x60
  jmp alltraps
80107781:	e9 c8 f4 ff ff       	jmp    80106c4e <alltraps>

80107786 <vector97>:
.globl vector97
vector97:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $97
80107788:	6a 61                	push   $0x61
  jmp alltraps
8010778a:	e9 bf f4 ff ff       	jmp    80106c4e <alltraps>

8010778f <vector98>:
.globl vector98
vector98:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $98
80107791:	6a 62                	push   $0x62
  jmp alltraps
80107793:	e9 b6 f4 ff ff       	jmp    80106c4e <alltraps>

80107798 <vector99>:
.globl vector99
vector99:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $99
8010779a:	6a 63                	push   $0x63
  jmp alltraps
8010779c:	e9 ad f4 ff ff       	jmp    80106c4e <alltraps>

801077a1 <vector100>:
.globl vector100
vector100:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $100
801077a3:	6a 64                	push   $0x64
  jmp alltraps
801077a5:	e9 a4 f4 ff ff       	jmp    80106c4e <alltraps>

801077aa <vector101>:
.globl vector101
vector101:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $101
801077ac:	6a 65                	push   $0x65
  jmp alltraps
801077ae:	e9 9b f4 ff ff       	jmp    80106c4e <alltraps>

801077b3 <vector102>:
.globl vector102
vector102:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $102
801077b5:	6a 66                	push   $0x66
  jmp alltraps
801077b7:	e9 92 f4 ff ff       	jmp    80106c4e <alltraps>

801077bc <vector103>:
.globl vector103
vector103:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $103
801077be:	6a 67                	push   $0x67
  jmp alltraps
801077c0:	e9 89 f4 ff ff       	jmp    80106c4e <alltraps>

801077c5 <vector104>:
.globl vector104
vector104:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $104
801077c7:	6a 68                	push   $0x68
  jmp alltraps
801077c9:	e9 80 f4 ff ff       	jmp    80106c4e <alltraps>

801077ce <vector105>:
.globl vector105
vector105:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $105
801077d0:	6a 69                	push   $0x69
  jmp alltraps
801077d2:	e9 77 f4 ff ff       	jmp    80106c4e <alltraps>

801077d7 <vector106>:
.globl vector106
vector106:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $106
801077d9:	6a 6a                	push   $0x6a
  jmp alltraps
801077db:	e9 6e f4 ff ff       	jmp    80106c4e <alltraps>

801077e0 <vector107>:
.globl vector107
vector107:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $107
801077e2:	6a 6b                	push   $0x6b
  jmp alltraps
801077e4:	e9 65 f4 ff ff       	jmp    80106c4e <alltraps>

801077e9 <vector108>:
.globl vector108
vector108:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $108
801077eb:	6a 6c                	push   $0x6c
  jmp alltraps
801077ed:	e9 5c f4 ff ff       	jmp    80106c4e <alltraps>

801077f2 <vector109>:
.globl vector109
vector109:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $109
801077f4:	6a 6d                	push   $0x6d
  jmp alltraps
801077f6:	e9 53 f4 ff ff       	jmp    80106c4e <alltraps>

801077fb <vector110>:
.globl vector110
vector110:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $110
801077fd:	6a 6e                	push   $0x6e
  jmp alltraps
801077ff:	e9 4a f4 ff ff       	jmp    80106c4e <alltraps>

80107804 <vector111>:
.globl vector111
vector111:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $111
80107806:	6a 6f                	push   $0x6f
  jmp alltraps
80107808:	e9 41 f4 ff ff       	jmp    80106c4e <alltraps>

8010780d <vector112>:
.globl vector112
vector112:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $112
8010780f:	6a 70                	push   $0x70
  jmp alltraps
80107811:	e9 38 f4 ff ff       	jmp    80106c4e <alltraps>

80107816 <vector113>:
.globl vector113
vector113:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $113
80107818:	6a 71                	push   $0x71
  jmp alltraps
8010781a:	e9 2f f4 ff ff       	jmp    80106c4e <alltraps>

8010781f <vector114>:
.globl vector114
vector114:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $114
80107821:	6a 72                	push   $0x72
  jmp alltraps
80107823:	e9 26 f4 ff ff       	jmp    80106c4e <alltraps>

80107828 <vector115>:
.globl vector115
vector115:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $115
8010782a:	6a 73                	push   $0x73
  jmp alltraps
8010782c:	e9 1d f4 ff ff       	jmp    80106c4e <alltraps>

80107831 <vector116>:
.globl vector116
vector116:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $116
80107833:	6a 74                	push   $0x74
  jmp alltraps
80107835:	e9 14 f4 ff ff       	jmp    80106c4e <alltraps>

8010783a <vector117>:
.globl vector117
vector117:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $117
8010783c:	6a 75                	push   $0x75
  jmp alltraps
8010783e:	e9 0b f4 ff ff       	jmp    80106c4e <alltraps>

80107843 <vector118>:
.globl vector118
vector118:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $118
80107845:	6a 76                	push   $0x76
  jmp alltraps
80107847:	e9 02 f4 ff ff       	jmp    80106c4e <alltraps>

8010784c <vector119>:
.globl vector119
vector119:
  pushl $0
8010784c:	6a 00                	push   $0x0
  pushl $119
8010784e:	6a 77                	push   $0x77
  jmp alltraps
80107850:	e9 f9 f3 ff ff       	jmp    80106c4e <alltraps>

80107855 <vector120>:
.globl vector120
vector120:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $120
80107857:	6a 78                	push   $0x78
  jmp alltraps
80107859:	e9 f0 f3 ff ff       	jmp    80106c4e <alltraps>

8010785e <vector121>:
.globl vector121
vector121:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $121
80107860:	6a 79                	push   $0x79
  jmp alltraps
80107862:	e9 e7 f3 ff ff       	jmp    80106c4e <alltraps>

80107867 <vector122>:
.globl vector122
vector122:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $122
80107869:	6a 7a                	push   $0x7a
  jmp alltraps
8010786b:	e9 de f3 ff ff       	jmp    80106c4e <alltraps>

80107870 <vector123>:
.globl vector123
vector123:
  pushl $0
80107870:	6a 00                	push   $0x0
  pushl $123
80107872:	6a 7b                	push   $0x7b
  jmp alltraps
80107874:	e9 d5 f3 ff ff       	jmp    80106c4e <alltraps>

80107879 <vector124>:
.globl vector124
vector124:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $124
8010787b:	6a 7c                	push   $0x7c
  jmp alltraps
8010787d:	e9 cc f3 ff ff       	jmp    80106c4e <alltraps>

80107882 <vector125>:
.globl vector125
vector125:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $125
80107884:	6a 7d                	push   $0x7d
  jmp alltraps
80107886:	e9 c3 f3 ff ff       	jmp    80106c4e <alltraps>

8010788b <vector126>:
.globl vector126
vector126:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $126
8010788d:	6a 7e                	push   $0x7e
  jmp alltraps
8010788f:	e9 ba f3 ff ff       	jmp    80106c4e <alltraps>

80107894 <vector127>:
.globl vector127
vector127:
  pushl $0
80107894:	6a 00                	push   $0x0
  pushl $127
80107896:	6a 7f                	push   $0x7f
  jmp alltraps
80107898:	e9 b1 f3 ff ff       	jmp    80106c4e <alltraps>

8010789d <vector128>:
.globl vector128
vector128:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $128
8010789f:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801078a4:	e9 a5 f3 ff ff       	jmp    80106c4e <alltraps>

801078a9 <vector129>:
.globl vector129
vector129:
  pushl $0
801078a9:	6a 00                	push   $0x0
  pushl $129
801078ab:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801078b0:	e9 99 f3 ff ff       	jmp    80106c4e <alltraps>

801078b5 <vector130>:
.globl vector130
vector130:
  pushl $0
801078b5:	6a 00                	push   $0x0
  pushl $130
801078b7:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801078bc:	e9 8d f3 ff ff       	jmp    80106c4e <alltraps>

801078c1 <vector131>:
.globl vector131
vector131:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $131
801078c3:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801078c8:	e9 81 f3 ff ff       	jmp    80106c4e <alltraps>

801078cd <vector132>:
.globl vector132
vector132:
  pushl $0
801078cd:	6a 00                	push   $0x0
  pushl $132
801078cf:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801078d4:	e9 75 f3 ff ff       	jmp    80106c4e <alltraps>

801078d9 <vector133>:
.globl vector133
vector133:
  pushl $0
801078d9:	6a 00                	push   $0x0
  pushl $133
801078db:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801078e0:	e9 69 f3 ff ff       	jmp    80106c4e <alltraps>

801078e5 <vector134>:
.globl vector134
vector134:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $134
801078e7:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801078ec:	e9 5d f3 ff ff       	jmp    80106c4e <alltraps>

801078f1 <vector135>:
.globl vector135
vector135:
  pushl $0
801078f1:	6a 00                	push   $0x0
  pushl $135
801078f3:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801078f8:	e9 51 f3 ff ff       	jmp    80106c4e <alltraps>

801078fd <vector136>:
.globl vector136
vector136:
  pushl $0
801078fd:	6a 00                	push   $0x0
  pushl $136
801078ff:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107904:	e9 45 f3 ff ff       	jmp    80106c4e <alltraps>

80107909 <vector137>:
.globl vector137
vector137:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $137
8010790b:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107910:	e9 39 f3 ff ff       	jmp    80106c4e <alltraps>

80107915 <vector138>:
.globl vector138
vector138:
  pushl $0
80107915:	6a 00                	push   $0x0
  pushl $138
80107917:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010791c:	e9 2d f3 ff ff       	jmp    80106c4e <alltraps>

80107921 <vector139>:
.globl vector139
vector139:
  pushl $0
80107921:	6a 00                	push   $0x0
  pushl $139
80107923:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107928:	e9 21 f3 ff ff       	jmp    80106c4e <alltraps>

8010792d <vector140>:
.globl vector140
vector140:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $140
8010792f:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107934:	e9 15 f3 ff ff       	jmp    80106c4e <alltraps>

80107939 <vector141>:
.globl vector141
vector141:
  pushl $0
80107939:	6a 00                	push   $0x0
  pushl $141
8010793b:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107940:	e9 09 f3 ff ff       	jmp    80106c4e <alltraps>

80107945 <vector142>:
.globl vector142
vector142:
  pushl $0
80107945:	6a 00                	push   $0x0
  pushl $142
80107947:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010794c:	e9 fd f2 ff ff       	jmp    80106c4e <alltraps>

80107951 <vector143>:
.globl vector143
vector143:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $143
80107953:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107958:	e9 f1 f2 ff ff       	jmp    80106c4e <alltraps>

8010795d <vector144>:
.globl vector144
vector144:
  pushl $0
8010795d:	6a 00                	push   $0x0
  pushl $144
8010795f:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107964:	e9 e5 f2 ff ff       	jmp    80106c4e <alltraps>

80107969 <vector145>:
.globl vector145
vector145:
  pushl $0
80107969:	6a 00                	push   $0x0
  pushl $145
8010796b:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107970:	e9 d9 f2 ff ff       	jmp    80106c4e <alltraps>

80107975 <vector146>:
.globl vector146
vector146:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $146
80107977:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010797c:	e9 cd f2 ff ff       	jmp    80106c4e <alltraps>

80107981 <vector147>:
.globl vector147
vector147:
  pushl $0
80107981:	6a 00                	push   $0x0
  pushl $147
80107983:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107988:	e9 c1 f2 ff ff       	jmp    80106c4e <alltraps>

8010798d <vector148>:
.globl vector148
vector148:
  pushl $0
8010798d:	6a 00                	push   $0x0
  pushl $148
8010798f:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107994:	e9 b5 f2 ff ff       	jmp    80106c4e <alltraps>

80107999 <vector149>:
.globl vector149
vector149:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $149
8010799b:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801079a0:	e9 a9 f2 ff ff       	jmp    80106c4e <alltraps>

801079a5 <vector150>:
.globl vector150
vector150:
  pushl $0
801079a5:	6a 00                	push   $0x0
  pushl $150
801079a7:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801079ac:	e9 9d f2 ff ff       	jmp    80106c4e <alltraps>

801079b1 <vector151>:
.globl vector151
vector151:
  pushl $0
801079b1:	6a 00                	push   $0x0
  pushl $151
801079b3:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801079b8:	e9 91 f2 ff ff       	jmp    80106c4e <alltraps>

801079bd <vector152>:
.globl vector152
vector152:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $152
801079bf:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801079c4:	e9 85 f2 ff ff       	jmp    80106c4e <alltraps>

801079c9 <vector153>:
.globl vector153
vector153:
  pushl $0
801079c9:	6a 00                	push   $0x0
  pushl $153
801079cb:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801079d0:	e9 79 f2 ff ff       	jmp    80106c4e <alltraps>

801079d5 <vector154>:
.globl vector154
vector154:
  pushl $0
801079d5:	6a 00                	push   $0x0
  pushl $154
801079d7:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801079dc:	e9 6d f2 ff ff       	jmp    80106c4e <alltraps>

801079e1 <vector155>:
.globl vector155
vector155:
  pushl $0
801079e1:	6a 00                	push   $0x0
  pushl $155
801079e3:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801079e8:	e9 61 f2 ff ff       	jmp    80106c4e <alltraps>

801079ed <vector156>:
.globl vector156
vector156:
  pushl $0
801079ed:	6a 00                	push   $0x0
  pushl $156
801079ef:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801079f4:	e9 55 f2 ff ff       	jmp    80106c4e <alltraps>

801079f9 <vector157>:
.globl vector157
vector157:
  pushl $0
801079f9:	6a 00                	push   $0x0
  pushl $157
801079fb:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107a00:	e9 49 f2 ff ff       	jmp    80106c4e <alltraps>

80107a05 <vector158>:
.globl vector158
vector158:
  pushl $0
80107a05:	6a 00                	push   $0x0
  pushl $158
80107a07:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107a0c:	e9 3d f2 ff ff       	jmp    80106c4e <alltraps>

80107a11 <vector159>:
.globl vector159
vector159:
  pushl $0
80107a11:	6a 00                	push   $0x0
  pushl $159
80107a13:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107a18:	e9 31 f2 ff ff       	jmp    80106c4e <alltraps>

80107a1d <vector160>:
.globl vector160
vector160:
  pushl $0
80107a1d:	6a 00                	push   $0x0
  pushl $160
80107a1f:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107a24:	e9 25 f2 ff ff       	jmp    80106c4e <alltraps>

80107a29 <vector161>:
.globl vector161
vector161:
  pushl $0
80107a29:	6a 00                	push   $0x0
  pushl $161
80107a2b:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107a30:	e9 19 f2 ff ff       	jmp    80106c4e <alltraps>

80107a35 <vector162>:
.globl vector162
vector162:
  pushl $0
80107a35:	6a 00                	push   $0x0
  pushl $162
80107a37:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a3c:	e9 0d f2 ff ff       	jmp    80106c4e <alltraps>

80107a41 <vector163>:
.globl vector163
vector163:
  pushl $0
80107a41:	6a 00                	push   $0x0
  pushl $163
80107a43:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a48:	e9 01 f2 ff ff       	jmp    80106c4e <alltraps>

80107a4d <vector164>:
.globl vector164
vector164:
  pushl $0
80107a4d:	6a 00                	push   $0x0
  pushl $164
80107a4f:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a54:	e9 f5 f1 ff ff       	jmp    80106c4e <alltraps>

80107a59 <vector165>:
.globl vector165
vector165:
  pushl $0
80107a59:	6a 00                	push   $0x0
  pushl $165
80107a5b:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a60:	e9 e9 f1 ff ff       	jmp    80106c4e <alltraps>

80107a65 <vector166>:
.globl vector166
vector166:
  pushl $0
80107a65:	6a 00                	push   $0x0
  pushl $166
80107a67:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a6c:	e9 dd f1 ff ff       	jmp    80106c4e <alltraps>

80107a71 <vector167>:
.globl vector167
vector167:
  pushl $0
80107a71:	6a 00                	push   $0x0
  pushl $167
80107a73:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107a78:	e9 d1 f1 ff ff       	jmp    80106c4e <alltraps>

80107a7d <vector168>:
.globl vector168
vector168:
  pushl $0
80107a7d:	6a 00                	push   $0x0
  pushl $168
80107a7f:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107a84:	e9 c5 f1 ff ff       	jmp    80106c4e <alltraps>

80107a89 <vector169>:
.globl vector169
vector169:
  pushl $0
80107a89:	6a 00                	push   $0x0
  pushl $169
80107a8b:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107a90:	e9 b9 f1 ff ff       	jmp    80106c4e <alltraps>

80107a95 <vector170>:
.globl vector170
vector170:
  pushl $0
80107a95:	6a 00                	push   $0x0
  pushl $170
80107a97:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107a9c:	e9 ad f1 ff ff       	jmp    80106c4e <alltraps>

80107aa1 <vector171>:
.globl vector171
vector171:
  pushl $0
80107aa1:	6a 00                	push   $0x0
  pushl $171
80107aa3:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107aa8:	e9 a1 f1 ff ff       	jmp    80106c4e <alltraps>

80107aad <vector172>:
.globl vector172
vector172:
  pushl $0
80107aad:	6a 00                	push   $0x0
  pushl $172
80107aaf:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107ab4:	e9 95 f1 ff ff       	jmp    80106c4e <alltraps>

80107ab9 <vector173>:
.globl vector173
vector173:
  pushl $0
80107ab9:	6a 00                	push   $0x0
  pushl $173
80107abb:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107ac0:	e9 89 f1 ff ff       	jmp    80106c4e <alltraps>

80107ac5 <vector174>:
.globl vector174
vector174:
  pushl $0
80107ac5:	6a 00                	push   $0x0
  pushl $174
80107ac7:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107acc:	e9 7d f1 ff ff       	jmp    80106c4e <alltraps>

80107ad1 <vector175>:
.globl vector175
vector175:
  pushl $0
80107ad1:	6a 00                	push   $0x0
  pushl $175
80107ad3:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107ad8:	e9 71 f1 ff ff       	jmp    80106c4e <alltraps>

80107add <vector176>:
.globl vector176
vector176:
  pushl $0
80107add:	6a 00                	push   $0x0
  pushl $176
80107adf:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107ae4:	e9 65 f1 ff ff       	jmp    80106c4e <alltraps>

80107ae9 <vector177>:
.globl vector177
vector177:
  pushl $0
80107ae9:	6a 00                	push   $0x0
  pushl $177
80107aeb:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107af0:	e9 59 f1 ff ff       	jmp    80106c4e <alltraps>

80107af5 <vector178>:
.globl vector178
vector178:
  pushl $0
80107af5:	6a 00                	push   $0x0
  pushl $178
80107af7:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107afc:	e9 4d f1 ff ff       	jmp    80106c4e <alltraps>

80107b01 <vector179>:
.globl vector179
vector179:
  pushl $0
80107b01:	6a 00                	push   $0x0
  pushl $179
80107b03:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107b08:	e9 41 f1 ff ff       	jmp    80106c4e <alltraps>

80107b0d <vector180>:
.globl vector180
vector180:
  pushl $0
80107b0d:	6a 00                	push   $0x0
  pushl $180
80107b0f:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107b14:	e9 35 f1 ff ff       	jmp    80106c4e <alltraps>

80107b19 <vector181>:
.globl vector181
vector181:
  pushl $0
80107b19:	6a 00                	push   $0x0
  pushl $181
80107b1b:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107b20:	e9 29 f1 ff ff       	jmp    80106c4e <alltraps>

80107b25 <vector182>:
.globl vector182
vector182:
  pushl $0
80107b25:	6a 00                	push   $0x0
  pushl $182
80107b27:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b2c:	e9 1d f1 ff ff       	jmp    80106c4e <alltraps>

80107b31 <vector183>:
.globl vector183
vector183:
  pushl $0
80107b31:	6a 00                	push   $0x0
  pushl $183
80107b33:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b38:	e9 11 f1 ff ff       	jmp    80106c4e <alltraps>

80107b3d <vector184>:
.globl vector184
vector184:
  pushl $0
80107b3d:	6a 00                	push   $0x0
  pushl $184
80107b3f:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b44:	e9 05 f1 ff ff       	jmp    80106c4e <alltraps>

80107b49 <vector185>:
.globl vector185
vector185:
  pushl $0
80107b49:	6a 00                	push   $0x0
  pushl $185
80107b4b:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b50:	e9 f9 f0 ff ff       	jmp    80106c4e <alltraps>

80107b55 <vector186>:
.globl vector186
vector186:
  pushl $0
80107b55:	6a 00                	push   $0x0
  pushl $186
80107b57:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b5c:	e9 ed f0 ff ff       	jmp    80106c4e <alltraps>

80107b61 <vector187>:
.globl vector187
vector187:
  pushl $0
80107b61:	6a 00                	push   $0x0
  pushl $187
80107b63:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b68:	e9 e1 f0 ff ff       	jmp    80106c4e <alltraps>

80107b6d <vector188>:
.globl vector188
vector188:
  pushl $0
80107b6d:	6a 00                	push   $0x0
  pushl $188
80107b6f:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b74:	e9 d5 f0 ff ff       	jmp    80106c4e <alltraps>

80107b79 <vector189>:
.globl vector189
vector189:
  pushl $0
80107b79:	6a 00                	push   $0x0
  pushl $189
80107b7b:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107b80:	e9 c9 f0 ff ff       	jmp    80106c4e <alltraps>

80107b85 <vector190>:
.globl vector190
vector190:
  pushl $0
80107b85:	6a 00                	push   $0x0
  pushl $190
80107b87:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107b8c:	e9 bd f0 ff ff       	jmp    80106c4e <alltraps>

80107b91 <vector191>:
.globl vector191
vector191:
  pushl $0
80107b91:	6a 00                	push   $0x0
  pushl $191
80107b93:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107b98:	e9 b1 f0 ff ff       	jmp    80106c4e <alltraps>

80107b9d <vector192>:
.globl vector192
vector192:
  pushl $0
80107b9d:	6a 00                	push   $0x0
  pushl $192
80107b9f:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107ba4:	e9 a5 f0 ff ff       	jmp    80106c4e <alltraps>

80107ba9 <vector193>:
.globl vector193
vector193:
  pushl $0
80107ba9:	6a 00                	push   $0x0
  pushl $193
80107bab:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107bb0:	e9 99 f0 ff ff       	jmp    80106c4e <alltraps>

80107bb5 <vector194>:
.globl vector194
vector194:
  pushl $0
80107bb5:	6a 00                	push   $0x0
  pushl $194
80107bb7:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107bbc:	e9 8d f0 ff ff       	jmp    80106c4e <alltraps>

80107bc1 <vector195>:
.globl vector195
vector195:
  pushl $0
80107bc1:	6a 00                	push   $0x0
  pushl $195
80107bc3:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107bc8:	e9 81 f0 ff ff       	jmp    80106c4e <alltraps>

80107bcd <vector196>:
.globl vector196
vector196:
  pushl $0
80107bcd:	6a 00                	push   $0x0
  pushl $196
80107bcf:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107bd4:	e9 75 f0 ff ff       	jmp    80106c4e <alltraps>

80107bd9 <vector197>:
.globl vector197
vector197:
  pushl $0
80107bd9:	6a 00                	push   $0x0
  pushl $197
80107bdb:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107be0:	e9 69 f0 ff ff       	jmp    80106c4e <alltraps>

80107be5 <vector198>:
.globl vector198
vector198:
  pushl $0
80107be5:	6a 00                	push   $0x0
  pushl $198
80107be7:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107bec:	e9 5d f0 ff ff       	jmp    80106c4e <alltraps>

80107bf1 <vector199>:
.globl vector199
vector199:
  pushl $0
80107bf1:	6a 00                	push   $0x0
  pushl $199
80107bf3:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107bf8:	e9 51 f0 ff ff       	jmp    80106c4e <alltraps>

80107bfd <vector200>:
.globl vector200
vector200:
  pushl $0
80107bfd:	6a 00                	push   $0x0
  pushl $200
80107bff:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107c04:	e9 45 f0 ff ff       	jmp    80106c4e <alltraps>

80107c09 <vector201>:
.globl vector201
vector201:
  pushl $0
80107c09:	6a 00                	push   $0x0
  pushl $201
80107c0b:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107c10:	e9 39 f0 ff ff       	jmp    80106c4e <alltraps>

80107c15 <vector202>:
.globl vector202
vector202:
  pushl $0
80107c15:	6a 00                	push   $0x0
  pushl $202
80107c17:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107c1c:	e9 2d f0 ff ff       	jmp    80106c4e <alltraps>

80107c21 <vector203>:
.globl vector203
vector203:
  pushl $0
80107c21:	6a 00                	push   $0x0
  pushl $203
80107c23:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c28:	e9 21 f0 ff ff       	jmp    80106c4e <alltraps>

80107c2d <vector204>:
.globl vector204
vector204:
  pushl $0
80107c2d:	6a 00                	push   $0x0
  pushl $204
80107c2f:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107c34:	e9 15 f0 ff ff       	jmp    80106c4e <alltraps>

80107c39 <vector205>:
.globl vector205
vector205:
  pushl $0
80107c39:	6a 00                	push   $0x0
  pushl $205
80107c3b:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c40:	e9 09 f0 ff ff       	jmp    80106c4e <alltraps>

80107c45 <vector206>:
.globl vector206
vector206:
  pushl $0
80107c45:	6a 00                	push   $0x0
  pushl $206
80107c47:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c4c:	e9 fd ef ff ff       	jmp    80106c4e <alltraps>

80107c51 <vector207>:
.globl vector207
vector207:
  pushl $0
80107c51:	6a 00                	push   $0x0
  pushl $207
80107c53:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c58:	e9 f1 ef ff ff       	jmp    80106c4e <alltraps>

80107c5d <vector208>:
.globl vector208
vector208:
  pushl $0
80107c5d:	6a 00                	push   $0x0
  pushl $208
80107c5f:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c64:	e9 e5 ef ff ff       	jmp    80106c4e <alltraps>

80107c69 <vector209>:
.globl vector209
vector209:
  pushl $0
80107c69:	6a 00                	push   $0x0
  pushl $209
80107c6b:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c70:	e9 d9 ef ff ff       	jmp    80106c4e <alltraps>

80107c75 <vector210>:
.globl vector210
vector210:
  pushl $0
80107c75:	6a 00                	push   $0x0
  pushl $210
80107c77:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107c7c:	e9 cd ef ff ff       	jmp    80106c4e <alltraps>

80107c81 <vector211>:
.globl vector211
vector211:
  pushl $0
80107c81:	6a 00                	push   $0x0
  pushl $211
80107c83:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107c88:	e9 c1 ef ff ff       	jmp    80106c4e <alltraps>

80107c8d <vector212>:
.globl vector212
vector212:
  pushl $0
80107c8d:	6a 00                	push   $0x0
  pushl $212
80107c8f:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107c94:	e9 b5 ef ff ff       	jmp    80106c4e <alltraps>

80107c99 <vector213>:
.globl vector213
vector213:
  pushl $0
80107c99:	6a 00                	push   $0x0
  pushl $213
80107c9b:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107ca0:	e9 a9 ef ff ff       	jmp    80106c4e <alltraps>

80107ca5 <vector214>:
.globl vector214
vector214:
  pushl $0
80107ca5:	6a 00                	push   $0x0
  pushl $214
80107ca7:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107cac:	e9 9d ef ff ff       	jmp    80106c4e <alltraps>

80107cb1 <vector215>:
.globl vector215
vector215:
  pushl $0
80107cb1:	6a 00                	push   $0x0
  pushl $215
80107cb3:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107cb8:	e9 91 ef ff ff       	jmp    80106c4e <alltraps>

80107cbd <vector216>:
.globl vector216
vector216:
  pushl $0
80107cbd:	6a 00                	push   $0x0
  pushl $216
80107cbf:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107cc4:	e9 85 ef ff ff       	jmp    80106c4e <alltraps>

80107cc9 <vector217>:
.globl vector217
vector217:
  pushl $0
80107cc9:	6a 00                	push   $0x0
  pushl $217
80107ccb:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107cd0:	e9 79 ef ff ff       	jmp    80106c4e <alltraps>

80107cd5 <vector218>:
.globl vector218
vector218:
  pushl $0
80107cd5:	6a 00                	push   $0x0
  pushl $218
80107cd7:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107cdc:	e9 6d ef ff ff       	jmp    80106c4e <alltraps>

80107ce1 <vector219>:
.globl vector219
vector219:
  pushl $0
80107ce1:	6a 00                	push   $0x0
  pushl $219
80107ce3:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107ce8:	e9 61 ef ff ff       	jmp    80106c4e <alltraps>

80107ced <vector220>:
.globl vector220
vector220:
  pushl $0
80107ced:	6a 00                	push   $0x0
  pushl $220
80107cef:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107cf4:	e9 55 ef ff ff       	jmp    80106c4e <alltraps>

80107cf9 <vector221>:
.globl vector221
vector221:
  pushl $0
80107cf9:	6a 00                	push   $0x0
  pushl $221
80107cfb:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107d00:	e9 49 ef ff ff       	jmp    80106c4e <alltraps>

80107d05 <vector222>:
.globl vector222
vector222:
  pushl $0
80107d05:	6a 00                	push   $0x0
  pushl $222
80107d07:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107d0c:	e9 3d ef ff ff       	jmp    80106c4e <alltraps>

80107d11 <vector223>:
.globl vector223
vector223:
  pushl $0
80107d11:	6a 00                	push   $0x0
  pushl $223
80107d13:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107d18:	e9 31 ef ff ff       	jmp    80106c4e <alltraps>

80107d1d <vector224>:
.globl vector224
vector224:
  pushl $0
80107d1d:	6a 00                	push   $0x0
  pushl $224
80107d1f:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107d24:	e9 25 ef ff ff       	jmp    80106c4e <alltraps>

80107d29 <vector225>:
.globl vector225
vector225:
  pushl $0
80107d29:	6a 00                	push   $0x0
  pushl $225
80107d2b:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107d30:	e9 19 ef ff ff       	jmp    80106c4e <alltraps>

80107d35 <vector226>:
.globl vector226
vector226:
  pushl $0
80107d35:	6a 00                	push   $0x0
  pushl $226
80107d37:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d3c:	e9 0d ef ff ff       	jmp    80106c4e <alltraps>

80107d41 <vector227>:
.globl vector227
vector227:
  pushl $0
80107d41:	6a 00                	push   $0x0
  pushl $227
80107d43:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d48:	e9 01 ef ff ff       	jmp    80106c4e <alltraps>

80107d4d <vector228>:
.globl vector228
vector228:
  pushl $0
80107d4d:	6a 00                	push   $0x0
  pushl $228
80107d4f:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d54:	e9 f5 ee ff ff       	jmp    80106c4e <alltraps>

80107d59 <vector229>:
.globl vector229
vector229:
  pushl $0
80107d59:	6a 00                	push   $0x0
  pushl $229
80107d5b:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d60:	e9 e9 ee ff ff       	jmp    80106c4e <alltraps>

80107d65 <vector230>:
.globl vector230
vector230:
  pushl $0
80107d65:	6a 00                	push   $0x0
  pushl $230
80107d67:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d6c:	e9 dd ee ff ff       	jmp    80106c4e <alltraps>

80107d71 <vector231>:
.globl vector231
vector231:
  pushl $0
80107d71:	6a 00                	push   $0x0
  pushl $231
80107d73:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107d78:	e9 d1 ee ff ff       	jmp    80106c4e <alltraps>

80107d7d <vector232>:
.globl vector232
vector232:
  pushl $0
80107d7d:	6a 00                	push   $0x0
  pushl $232
80107d7f:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107d84:	e9 c5 ee ff ff       	jmp    80106c4e <alltraps>

80107d89 <vector233>:
.globl vector233
vector233:
  pushl $0
80107d89:	6a 00                	push   $0x0
  pushl $233
80107d8b:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107d90:	e9 b9 ee ff ff       	jmp    80106c4e <alltraps>

80107d95 <vector234>:
.globl vector234
vector234:
  pushl $0
80107d95:	6a 00                	push   $0x0
  pushl $234
80107d97:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107d9c:	e9 ad ee ff ff       	jmp    80106c4e <alltraps>

80107da1 <vector235>:
.globl vector235
vector235:
  pushl $0
80107da1:	6a 00                	push   $0x0
  pushl $235
80107da3:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107da8:	e9 a1 ee ff ff       	jmp    80106c4e <alltraps>

80107dad <vector236>:
.globl vector236
vector236:
  pushl $0
80107dad:	6a 00                	push   $0x0
  pushl $236
80107daf:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107db4:	e9 95 ee ff ff       	jmp    80106c4e <alltraps>

80107db9 <vector237>:
.globl vector237
vector237:
  pushl $0
80107db9:	6a 00                	push   $0x0
  pushl $237
80107dbb:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107dc0:	e9 89 ee ff ff       	jmp    80106c4e <alltraps>

80107dc5 <vector238>:
.globl vector238
vector238:
  pushl $0
80107dc5:	6a 00                	push   $0x0
  pushl $238
80107dc7:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107dcc:	e9 7d ee ff ff       	jmp    80106c4e <alltraps>

80107dd1 <vector239>:
.globl vector239
vector239:
  pushl $0
80107dd1:	6a 00                	push   $0x0
  pushl $239
80107dd3:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107dd8:	e9 71 ee ff ff       	jmp    80106c4e <alltraps>

80107ddd <vector240>:
.globl vector240
vector240:
  pushl $0
80107ddd:	6a 00                	push   $0x0
  pushl $240
80107ddf:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107de4:	e9 65 ee ff ff       	jmp    80106c4e <alltraps>

80107de9 <vector241>:
.globl vector241
vector241:
  pushl $0
80107de9:	6a 00                	push   $0x0
  pushl $241
80107deb:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107df0:	e9 59 ee ff ff       	jmp    80106c4e <alltraps>

80107df5 <vector242>:
.globl vector242
vector242:
  pushl $0
80107df5:	6a 00                	push   $0x0
  pushl $242
80107df7:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107dfc:	e9 4d ee ff ff       	jmp    80106c4e <alltraps>

80107e01 <vector243>:
.globl vector243
vector243:
  pushl $0
80107e01:	6a 00                	push   $0x0
  pushl $243
80107e03:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107e08:	e9 41 ee ff ff       	jmp    80106c4e <alltraps>

80107e0d <vector244>:
.globl vector244
vector244:
  pushl $0
80107e0d:	6a 00                	push   $0x0
  pushl $244
80107e0f:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107e14:	e9 35 ee ff ff       	jmp    80106c4e <alltraps>

80107e19 <vector245>:
.globl vector245
vector245:
  pushl $0
80107e19:	6a 00                	push   $0x0
  pushl $245
80107e1b:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107e20:	e9 29 ee ff ff       	jmp    80106c4e <alltraps>

80107e25 <vector246>:
.globl vector246
vector246:
  pushl $0
80107e25:	6a 00                	push   $0x0
  pushl $246
80107e27:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e2c:	e9 1d ee ff ff       	jmp    80106c4e <alltraps>

80107e31 <vector247>:
.globl vector247
vector247:
  pushl $0
80107e31:	6a 00                	push   $0x0
  pushl $247
80107e33:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e38:	e9 11 ee ff ff       	jmp    80106c4e <alltraps>

80107e3d <vector248>:
.globl vector248
vector248:
  pushl $0
80107e3d:	6a 00                	push   $0x0
  pushl $248
80107e3f:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e44:	e9 05 ee ff ff       	jmp    80106c4e <alltraps>

80107e49 <vector249>:
.globl vector249
vector249:
  pushl $0
80107e49:	6a 00                	push   $0x0
  pushl $249
80107e4b:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e50:	e9 f9 ed ff ff       	jmp    80106c4e <alltraps>

80107e55 <vector250>:
.globl vector250
vector250:
  pushl $0
80107e55:	6a 00                	push   $0x0
  pushl $250
80107e57:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e5c:	e9 ed ed ff ff       	jmp    80106c4e <alltraps>

80107e61 <vector251>:
.globl vector251
vector251:
  pushl $0
80107e61:	6a 00                	push   $0x0
  pushl $251
80107e63:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e68:	e9 e1 ed ff ff       	jmp    80106c4e <alltraps>

80107e6d <vector252>:
.globl vector252
vector252:
  pushl $0
80107e6d:	6a 00                	push   $0x0
  pushl $252
80107e6f:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e74:	e9 d5 ed ff ff       	jmp    80106c4e <alltraps>

80107e79 <vector253>:
.globl vector253
vector253:
  pushl $0
80107e79:	6a 00                	push   $0x0
  pushl $253
80107e7b:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107e80:	e9 c9 ed ff ff       	jmp    80106c4e <alltraps>

80107e85 <vector254>:
.globl vector254
vector254:
  pushl $0
80107e85:	6a 00                	push   $0x0
  pushl $254
80107e87:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107e8c:	e9 bd ed ff ff       	jmp    80106c4e <alltraps>

80107e91 <vector255>:
.globl vector255
vector255:
  pushl $0
80107e91:	6a 00                	push   $0x0
  pushl $255
80107e93:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107e98:	e9 b1 ed ff ff       	jmp    80106c4e <alltraps>

80107e9d <lgdt>:
{
80107e9d:	55                   	push   %ebp
80107e9e:	89 e5                	mov    %esp,%ebp
80107ea0:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ea6:	83 e8 01             	sub    $0x1,%eax
80107ea9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ead:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107eb4:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb7:	c1 e8 10             	shr    $0x10,%eax
80107eba:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107ebe:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ec1:	0f 01 10             	lgdtl  (%eax)
}
80107ec4:	90                   	nop
80107ec5:	c9                   	leave  
80107ec6:	c3                   	ret    

80107ec7 <ltr>:
{
80107ec7:	55                   	push   %ebp
80107ec8:	89 e5                	mov    %esp,%ebp
80107eca:	83 ec 04             	sub    $0x4,%esp
80107ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107ed4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107ed8:	0f 00 d8             	ltr    %ax
}
80107edb:	90                   	nop
80107edc:	c9                   	leave  
80107edd:	c3                   	ret    

80107ede <loadgs>:
{
80107ede:	55                   	push   %ebp
80107edf:	89 e5                	mov    %esp,%ebp
80107ee1:	83 ec 04             	sub    $0x4,%esp
80107ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107eeb:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107eef:	8e e8                	mov    %eax,%gs
}
80107ef1:	90                   	nop
80107ef2:	c9                   	leave  
80107ef3:	c3                   	ret    

80107ef4 <rcr2>:
{
80107ef4:	55                   	push   %ebp
80107ef5:	89 e5                	mov    %esp,%ebp
80107ef7:	83 ec 10             	sub    $0x10,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107efa:	0f 20 d0             	mov    %cr2,%eax
80107efd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107f03:	c9                   	leave  
80107f04:	c3                   	ret    

80107f05 <lcr3>:

static inline void
lcr3(uint val) 
{
80107f05:	55                   	push   %ebp
80107f06:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f08:	8b 45 08             	mov    0x8(%ebp),%eax
80107f0b:	0f 22 d8             	mov    %eax,%cr3
}
80107f0e:	90                   	nop
80107f0f:	5d                   	pop    %ebp
80107f10:	c3                   	ret    

80107f11 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107f11:	55                   	push   %ebp
80107f12:	89 e5                	mov    %esp,%ebp
80107f14:	8b 45 08             	mov    0x8(%ebp),%eax
80107f17:	05 00 00 00 80       	add    $0x80000000,%eax
80107f1c:	5d                   	pop    %ebp
80107f1d:	c3                   	ret    

80107f1e <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107f1e:	55                   	push   %ebp
80107f1f:	89 e5                	mov    %esp,%ebp
80107f21:	8b 45 08             	mov    0x8(%ebp),%eax
80107f24:	05 00 00 00 80       	add    $0x80000000,%eax
80107f29:	5d                   	pop    %ebp
80107f2a:	c3                   	ret    

80107f2b <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107f2b:	55                   	push   %ebp
80107f2c:	89 e5                	mov    %esp,%ebp
80107f2e:	53                   	push   %ebx
80107f2f:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107f32:	e8 74 b0 ff ff       	call   80102fab <cpunum>
80107f37:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107f3d:	05 60 23 11 80       	add    $0x80112360,%eax
80107f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f48:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f51:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5a:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f61:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f65:	83 e2 f0             	and    $0xfffffff0,%edx
80107f68:	83 ca 0a             	or     $0xa,%edx
80107f6b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f71:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f75:	83 ca 10             	or     $0x10,%edx
80107f78:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f82:	83 e2 9f             	and    $0xffffff9f,%edx
80107f85:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f8b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f8f:	83 ca 80             	or     $0xffffff80,%edx
80107f92:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f98:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107f9c:	83 ca 0f             	or     $0xf,%edx
80107f9f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fa9:	83 e2 ef             	and    $0xffffffef,%edx
80107fac:	88 50 7e             	mov    %dl,0x7e(%eax)
80107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fb6:	83 e2 df             	and    $0xffffffdf,%edx
80107fb9:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbf:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fc3:	83 ca 40             	or     $0x40,%edx
80107fc6:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcc:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fd0:	83 ca 80             	or     $0xffffff80,%edx
80107fd3:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd9:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe0:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107fe7:	ff ff 
80107fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fec:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107ff3:	00 00 
80107ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff8:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108002:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108009:	83 e2 f0             	and    $0xfffffff0,%edx
8010800c:	83 ca 02             	or     $0x2,%edx
8010800f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108018:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010801f:	83 ca 10             	or     $0x10,%edx
80108022:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108032:	83 e2 9f             	and    $0xffffff9f,%edx
80108035:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010803b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108045:	83 ca 80             	or     $0xffffff80,%edx
80108048:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010804e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108051:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108058:	83 ca 0f             	or     $0xf,%edx
8010805b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108064:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010806b:	83 e2 ef             	and    $0xffffffef,%edx
8010806e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108077:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010807e:	83 e2 df             	and    $0xffffffdf,%edx
80108081:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108091:	83 ca 40             	or     $0x40,%edx
80108094:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010809a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080a4:	83 ca 80             	or     $0xffffff80,%edx
801080a7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b0:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801080b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ba:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801080c1:	ff ff 
801080c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c6:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801080cd:	00 00 
801080cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d2:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801080d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dc:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080e3:	83 e2 f0             	and    $0xfffffff0,%edx
801080e6:	83 ca 0a             	or     $0xa,%edx
801080e9:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801080ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080f9:	83 ca 10             	or     $0x10,%edx
801080fc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108105:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010810c:	83 ca 60             	or     $0x60,%edx
8010810f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108118:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010811f:	83 ca 80             	or     $0xffffff80,%edx
80108122:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108132:	83 ca 0f             	or     $0xf,%edx
80108135:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010813b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108145:	83 e2 ef             	and    $0xffffffef,%edx
80108148:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010814e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108151:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108158:	83 e2 df             	and    $0xffffffdf,%edx
8010815b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108164:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010816b:	83 ca 40             	or     $0x40,%edx
8010816e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108177:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010817e:	83 ca 80             	or     $0xffffff80,%edx
80108181:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818a:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108194:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010819b:	ff ff 
8010819d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a0:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801081a7:	00 00 
801081a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ac:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801081b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b6:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081bd:	83 e2 f0             	and    $0xfffffff0,%edx
801081c0:	83 ca 02             	or     $0x2,%edx
801081c3:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081d3:	83 ca 10             	or     $0x10,%edx
801081d6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081df:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081e6:	83 ca 60             	or     $0x60,%edx
801081e9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081f9:	83 ca 80             	or     $0xffffff80,%edx
801081fc:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108205:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010820c:	83 ca 0f             	or     $0xf,%edx
8010820f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108218:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010821f:	83 e2 ef             	and    $0xffffffef,%edx
80108222:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108232:	83 e2 df             	and    $0xffffffdf,%edx
80108235:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010823b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108245:	83 ca 40             	or     $0x40,%edx
80108248:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010824e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108251:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108258:	83 ca 80             	or     $0xffffff80,%edx
8010825b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108264:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010826b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826e:	05 b4 00 00 00       	add    $0xb4,%eax
80108273:	89 c3                	mov    %eax,%ebx
80108275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108278:	05 b4 00 00 00       	add    $0xb4,%eax
8010827d:	c1 e8 10             	shr    $0x10,%eax
80108280:	89 c2                	mov    %eax,%edx
80108282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108285:	05 b4 00 00 00       	add    $0xb4,%eax
8010828a:	c1 e8 18             	shr    $0x18,%eax
8010828d:	89 c1                	mov    %eax,%ecx
8010828f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108292:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108299:	00 00 
8010829b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829e:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801082a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a8:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801082ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b1:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082b8:	83 e2 f0             	and    $0xfffffff0,%edx
801082bb:	83 ca 02             	or     $0x2,%edx
801082be:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c7:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082ce:	83 ca 10             	or     $0x10,%edx
801082d1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082da:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082e1:	83 e2 9f             	and    $0xffffff9f,%edx
801082e4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ed:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801082f4:	83 ca 80             	or     $0xffffff80,%edx
801082f7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801082fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108300:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108307:	83 e2 f0             	and    $0xfffffff0,%edx
8010830a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108313:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010831a:	83 e2 ef             	and    $0xffffffef,%edx
8010831d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108326:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010832d:	83 e2 df             	and    $0xffffffdf,%edx
80108330:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108336:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108339:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108340:	83 ca 40             	or     $0x40,%edx
80108343:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108353:	83 ca 80             	or     $0xffffff80,%edx
80108356:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010835c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835f:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108365:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108368:	83 c0 70             	add    $0x70,%eax
8010836b:	83 ec 08             	sub    $0x8,%esp
8010836e:	6a 38                	push   $0x38
80108370:	50                   	push   %eax
80108371:	e8 27 fb ff ff       	call   80107e9d <lgdt>
80108376:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108379:	83 ec 0c             	sub    $0xc,%esp
8010837c:	6a 18                	push   $0x18
8010837e:	e8 5b fb ff ff       	call   80107ede <loadgs>
80108383:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108389:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010838f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108396:	00 00 00 00 
}
8010839a:	90                   	nop
8010839b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010839e:	c9                   	leave  
8010839f:	c3                   	ret    

801083a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801083a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801083a9:	c1 e8 16             	shr    $0x16,%eax
801083ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801083b3:	8b 45 08             	mov    0x8(%ebp),%eax
801083b6:	01 d0                	add    %edx,%eax
801083b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801083bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083be:	8b 00                	mov    (%eax),%eax
801083c0:	83 e0 01             	and    $0x1,%eax
801083c3:	85 c0                	test   %eax,%eax
801083c5:	74 18                	je     801083df <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801083c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083ca:	8b 00                	mov    (%eax),%eax
801083cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083d1:	50                   	push   %eax
801083d2:	e8 47 fb ff ff       	call   80107f1e <p2v>
801083d7:	83 c4 04             	add    $0x4,%esp
801083da:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083dd:	eb 48                	jmp    80108427 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801083df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801083e3:	74 0e                	je     801083f3 <walkpgdir+0x53>
801083e5:	e8 57 a8 ff ff       	call   80102c41 <kalloc>
801083ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801083f1:	75 07                	jne    801083fa <walkpgdir+0x5a>
      return 0;
801083f3:	b8 00 00 00 00       	mov    $0x0,%eax
801083f8:	eb 44                	jmp    8010843e <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801083fa:	83 ec 04             	sub    $0x4,%esp
801083fd:	68 00 10 00 00       	push   $0x1000
80108402:	6a 00                	push   $0x0
80108404:	ff 75 f4             	push   -0xc(%ebp)
80108407:	e8 68 d2 ff ff       	call   80105674 <memset>
8010840c:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010840f:	83 ec 0c             	sub    $0xc,%esp
80108412:	ff 75 f4             	push   -0xc(%ebp)
80108415:	e8 f7 fa ff ff       	call   80107f11 <v2p>
8010841a:	83 c4 10             	add    $0x10,%esp
8010841d:	83 c8 07             	or     $0x7,%eax
80108420:	89 c2                	mov    %eax,%edx
80108422:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108425:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108427:	8b 45 0c             	mov    0xc(%ebp),%eax
8010842a:	c1 e8 0c             	shr    $0xc,%eax
8010842d:	25 ff 03 00 00       	and    $0x3ff,%eax
80108432:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843c:	01 d0                	add    %edx,%eax
}
8010843e:	c9                   	leave  
8010843f:	c3                   	ret    

80108440 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108440:	55                   	push   %ebp
80108441:	89 e5                	mov    %esp,%ebp
80108443:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108446:	8b 45 0c             	mov    0xc(%ebp),%eax
80108449:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010844e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108451:	8b 55 0c             	mov    0xc(%ebp),%edx
80108454:	8b 45 10             	mov    0x10(%ebp),%eax
80108457:	01 d0                	add    %edx,%eax
80108459:	83 e8 01             	sub    $0x1,%eax
8010845c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108461:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108464:	83 ec 04             	sub    $0x4,%esp
80108467:	6a 01                	push   $0x1
80108469:	ff 75 f4             	push   -0xc(%ebp)
8010846c:	ff 75 08             	push   0x8(%ebp)
8010846f:	e8 2c ff ff ff       	call   801083a0 <walkpgdir>
80108474:	83 c4 10             	add    $0x10,%esp
80108477:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010847a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010847e:	75 07                	jne    80108487 <mappages+0x47>
      return -1;
80108480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108485:	eb 47                	jmp    801084ce <mappages+0x8e>
    if(*pte & PTE_P)
80108487:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010848a:	8b 00                	mov    (%eax),%eax
8010848c:	83 e0 01             	and    $0x1,%eax
8010848f:	85 c0                	test   %eax,%eax
80108491:	74 0d                	je     801084a0 <mappages+0x60>
      panic("remap");
80108493:	83 ec 0c             	sub    $0xc,%esp
80108496:	68 34 99 10 80       	push   $0x80109934
8010849b:	e8 db 80 ff ff       	call   8010057b <panic>
    *pte = pa | perm | PTE_P;
801084a0:	8b 45 18             	mov    0x18(%ebp),%eax
801084a3:	0b 45 14             	or     0x14(%ebp),%eax
801084a6:	83 c8 01             	or     $0x1,%eax
801084a9:	89 c2                	mov    %eax,%edx
801084ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ae:	89 10                	mov    %edx,(%eax)
    if(a == last)
801084b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801084b6:	74 10                	je     801084c8 <mappages+0x88>
      break;
    a += PGSIZE;
801084b8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801084bf:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801084c6:	eb 9c                	jmp    80108464 <mappages+0x24>
      break;
801084c8:	90                   	nop
  }
  return 0;
801084c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801084ce:	c9                   	leave  
801084cf:	c3                   	ret    

801084d0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801084d0:	55                   	push   %ebp
801084d1:	89 e5                	mov    %esp,%ebp
801084d3:	53                   	push   %ebx
801084d4:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801084d7:	e8 65 a7 ff ff       	call   80102c41 <kalloc>
801084dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801084df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084e3:	75 0a                	jne    801084ef <setupkvm+0x1f>
    return 0;
801084e5:	b8 00 00 00 00       	mov    $0x0,%eax
801084ea:	e9 8e 00 00 00       	jmp    8010857d <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801084ef:	83 ec 04             	sub    $0x4,%esp
801084f2:	68 00 10 00 00       	push   $0x1000
801084f7:	6a 00                	push   $0x0
801084f9:	ff 75 f0             	push   -0x10(%ebp)
801084fc:	e8 73 d1 ff ff       	call   80105674 <memset>
80108501:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108504:	83 ec 0c             	sub    $0xc,%esp
80108507:	68 00 00 00 0e       	push   $0xe000000
8010850c:	e8 0d fa ff ff       	call   80107f1e <p2v>
80108511:	83 c4 10             	add    $0x10,%esp
80108514:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108519:	76 0d                	jbe    80108528 <setupkvm+0x58>
    panic("PHYSTOP too high");
8010851b:	83 ec 0c             	sub    $0xc,%esp
8010851e:	68 3a 99 10 80       	push   $0x8010993a
80108523:	e8 53 80 ff ff       	call   8010057b <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108528:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
8010852f:	eb 40                	jmp    80108571 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108534:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010853a:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010853d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108540:	8b 58 08             	mov    0x8(%eax),%ebx
80108543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108546:	8b 40 04             	mov    0x4(%eax),%eax
80108549:	29 c3                	sub    %eax,%ebx
8010854b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010854e:	8b 00                	mov    (%eax),%eax
80108550:	83 ec 0c             	sub    $0xc,%esp
80108553:	51                   	push   %ecx
80108554:	52                   	push   %edx
80108555:	53                   	push   %ebx
80108556:	50                   	push   %eax
80108557:	ff 75 f0             	push   -0x10(%ebp)
8010855a:	e8 e1 fe ff ff       	call   80108440 <mappages>
8010855f:	83 c4 20             	add    $0x20,%esp
80108562:	85 c0                	test   %eax,%eax
80108564:	79 07                	jns    8010856d <setupkvm+0x9d>
      return 0;
80108566:	b8 00 00 00 00       	mov    $0x0,%eax
8010856b:	eb 10                	jmp    8010857d <setupkvm+0xad>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010856d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108571:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
80108578:	72 b7                	jb     80108531 <setupkvm+0x61>
  return pgdir;
8010857a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010857d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108580:	c9                   	leave  
80108581:	c3                   	ret    

80108582 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108582:	55                   	push   %ebp
80108583:	89 e5                	mov    %esp,%ebp
80108585:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108588:	e8 43 ff ff ff       	call   801084d0 <setupkvm>
8010858d:	a3 e0 62 11 80       	mov    %eax,0x801162e0
  switchkvm();
80108592:	e8 03 00 00 00       	call   8010859a <switchkvm>
}
80108597:	90                   	nop
80108598:	c9                   	leave  
80108599:	c3                   	ret    

8010859a <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010859a:	55                   	push   %ebp
8010859b:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010859d:	a1 e0 62 11 80       	mov    0x801162e0,%eax
801085a2:	50                   	push   %eax
801085a3:	e8 69 f9 ff ff       	call   80107f11 <v2p>
801085a8:	83 c4 04             	add    $0x4,%esp
801085ab:	50                   	push   %eax
801085ac:	e8 54 f9 ff ff       	call   80107f05 <lcr3>
801085b1:	83 c4 04             	add    $0x4,%esp
}
801085b4:	90                   	nop
801085b5:	c9                   	leave  
801085b6:	c3                   	ret    

801085b7 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801085b7:	55                   	push   %ebp
801085b8:	89 e5                	mov    %esp,%ebp
801085ba:	56                   	push   %esi
801085bb:	53                   	push   %ebx
  pushcli();
801085bc:	e8 ae cf ff ff       	call   8010556f <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801085c1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085c7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085ce:	83 c2 08             	add    $0x8,%edx
801085d1:	89 d6                	mov    %edx,%esi
801085d3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085da:	83 c2 08             	add    $0x8,%edx
801085dd:	c1 ea 10             	shr    $0x10,%edx
801085e0:	89 d3                	mov    %edx,%ebx
801085e2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085e9:	83 c2 08             	add    $0x8,%edx
801085ec:	c1 ea 18             	shr    $0x18,%edx
801085ef:	89 d1                	mov    %edx,%ecx
801085f1:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801085f8:	67 00 
801085fa:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108601:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108607:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010860e:	83 e2 f0             	and    $0xfffffff0,%edx
80108611:	83 ca 09             	or     $0x9,%edx
80108614:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010861a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108621:	83 ca 10             	or     $0x10,%edx
80108624:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010862a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108631:	83 e2 9f             	and    $0xffffff9f,%edx
80108634:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010863a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108641:	83 ca 80             	or     $0xffffff80,%edx
80108644:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010864a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108651:	83 e2 f0             	and    $0xfffffff0,%edx
80108654:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010865a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108661:	83 e2 ef             	and    $0xffffffef,%edx
80108664:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010866a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108671:	83 e2 df             	and    $0xffffffdf,%edx
80108674:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010867a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108681:	83 ca 40             	or     $0x40,%edx
80108684:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010868a:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108691:	83 e2 7f             	and    $0x7f,%edx
80108694:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010869a:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801086a0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086a6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086ad:	83 e2 ef             	and    $0xffffffef,%edx
801086b0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801086b6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086bc:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801086c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801086c8:	8b 40 08             	mov    0x8(%eax),%eax
801086cb:	89 c2                	mov    %eax,%edx
801086cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086d3:	81 c2 00 10 00 00    	add    $0x1000,%edx
801086d9:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801086dc:	83 ec 0c             	sub    $0xc,%esp
801086df:	6a 30                	push   $0x30
801086e1:	e8 e1 f7 ff ff       	call   80107ec7 <ltr>
801086e6:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801086e9:	8b 45 08             	mov    0x8(%ebp),%eax
801086ec:	8b 40 04             	mov    0x4(%eax),%eax
801086ef:	85 c0                	test   %eax,%eax
801086f1:	75 0d                	jne    80108700 <switchuvm+0x149>
    panic("switchuvm: no pgdir");
801086f3:	83 ec 0c             	sub    $0xc,%esp
801086f6:	68 4b 99 10 80       	push   $0x8010994b
801086fb:	e8 7b 7e ff ff       	call   8010057b <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108700:	8b 45 08             	mov    0x8(%ebp),%eax
80108703:	8b 40 04             	mov    0x4(%eax),%eax
80108706:	83 ec 0c             	sub    $0xc,%esp
80108709:	50                   	push   %eax
8010870a:	e8 02 f8 ff ff       	call   80107f11 <v2p>
8010870f:	83 c4 10             	add    $0x10,%esp
80108712:	83 ec 0c             	sub    $0xc,%esp
80108715:	50                   	push   %eax
80108716:	e8 ea f7 ff ff       	call   80107f05 <lcr3>
8010871b:	83 c4 10             	add    $0x10,%esp
  popcli();
8010871e:	e8 90 ce ff ff       	call   801055b3 <popcli>
}
80108723:	90                   	nop
80108724:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108727:	5b                   	pop    %ebx
80108728:	5e                   	pop    %esi
80108729:	5d                   	pop    %ebp
8010872a:	c3                   	ret    

8010872b <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010872b:	55                   	push   %ebp
8010872c:	89 e5                	mov    %esp,%ebp
8010872e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108731:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108738:	76 0d                	jbe    80108747 <inituvm+0x1c>
    panic("inituvm: more than a page");
8010873a:	83 ec 0c             	sub    $0xc,%esp
8010873d:	68 5f 99 10 80       	push   $0x8010995f
80108742:	e8 34 7e ff ff       	call   8010057b <panic>
  mem = kalloc();
80108747:	e8 f5 a4 ff ff       	call   80102c41 <kalloc>
8010874c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010874f:	83 ec 04             	sub    $0x4,%esp
80108752:	68 00 10 00 00       	push   $0x1000
80108757:	6a 00                	push   $0x0
80108759:	ff 75 f4             	push   -0xc(%ebp)
8010875c:	e8 13 cf ff ff       	call   80105674 <memset>
80108761:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108764:	83 ec 0c             	sub    $0xc,%esp
80108767:	ff 75 f4             	push   -0xc(%ebp)
8010876a:	e8 a2 f7 ff ff       	call   80107f11 <v2p>
8010876f:	83 c4 10             	add    $0x10,%esp
80108772:	83 ec 0c             	sub    $0xc,%esp
80108775:	6a 06                	push   $0x6
80108777:	50                   	push   %eax
80108778:	68 00 10 00 00       	push   $0x1000
8010877d:	6a 00                	push   $0x0
8010877f:	ff 75 08             	push   0x8(%ebp)
80108782:	e8 b9 fc ff ff       	call   80108440 <mappages>
80108787:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010878a:	83 ec 04             	sub    $0x4,%esp
8010878d:	ff 75 10             	push   0x10(%ebp)
80108790:	ff 75 0c             	push   0xc(%ebp)
80108793:	ff 75 f4             	push   -0xc(%ebp)
80108796:	e8 98 cf ff ff       	call   80105733 <memmove>
8010879b:	83 c4 10             	add    $0x10,%esp
}
8010879e:	90                   	nop
8010879f:	c9                   	leave  
801087a0:	c3                   	ret    

801087a1 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801087a1:	55                   	push   %ebp
801087a2:	89 e5                	mov    %esp,%ebp
801087a4:	53                   	push   %ebx
801087a5:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801087a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801087ab:	25 ff 0f 00 00       	and    $0xfff,%eax
801087b0:	85 c0                	test   %eax,%eax
801087b2:	74 0d                	je     801087c1 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801087b4:	83 ec 0c             	sub    $0xc,%esp
801087b7:	68 7c 99 10 80       	push   $0x8010997c
801087bc:	e8 ba 7d ff ff       	call   8010057b <panic>
  for(i = 0; i < sz; i += PGSIZE){
801087c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087c8:	e9 95 00 00 00       	jmp    80108862 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801087cd:	8b 55 0c             	mov    0xc(%ebp),%edx
801087d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d3:	01 d0                	add    %edx,%eax
801087d5:	83 ec 04             	sub    $0x4,%esp
801087d8:	6a 00                	push   $0x0
801087da:	50                   	push   %eax
801087db:	ff 75 08             	push   0x8(%ebp)
801087de:	e8 bd fb ff ff       	call   801083a0 <walkpgdir>
801087e3:	83 c4 10             	add    $0x10,%esp
801087e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801087e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801087ed:	75 0d                	jne    801087fc <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801087ef:	83 ec 0c             	sub    $0xc,%esp
801087f2:	68 9f 99 10 80       	push   $0x8010999f
801087f7:	e8 7f 7d ff ff       	call   8010057b <panic>
    pa = PTE_ADDR(*pte);
801087fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087ff:	8b 00                	mov    (%eax),%eax
80108801:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108806:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108809:	8b 45 18             	mov    0x18(%ebp),%eax
8010880c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010880f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108814:	77 0b                	ja     80108821 <loaduvm+0x80>
      n = sz - i;
80108816:	8b 45 18             	mov    0x18(%ebp),%eax
80108819:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010881c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010881f:	eb 07                	jmp    80108828 <loaduvm+0x87>
    else
      n = PGSIZE;
80108821:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108828:	8b 55 14             	mov    0x14(%ebp),%edx
8010882b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010882e:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108831:	83 ec 0c             	sub    $0xc,%esp
80108834:	ff 75 e8             	push   -0x18(%ebp)
80108837:	e8 e2 f6 ff ff       	call   80107f1e <p2v>
8010883c:	83 c4 10             	add    $0x10,%esp
8010883f:	ff 75 f0             	push   -0x10(%ebp)
80108842:	53                   	push   %ebx
80108843:	50                   	push   %eax
80108844:	ff 75 10             	push   0x10(%ebp)
80108847:	e8 4b 96 ff ff       	call   80101e97 <readi>
8010884c:	83 c4 10             	add    $0x10,%esp
8010884f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
80108852:	74 07                	je     8010885b <loaduvm+0xba>
      return -1;
80108854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108859:	eb 18                	jmp    80108873 <loaduvm+0xd2>
  for(i = 0; i < sz; i += PGSIZE){
8010885b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108865:	3b 45 18             	cmp    0x18(%ebp),%eax
80108868:	0f 82 5f ff ff ff    	jb     801087cd <loaduvm+0x2c>
  }
  return 0;
8010886e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108876:	c9                   	leave  
80108877:	c3                   	ret    

80108878 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108878:	55                   	push   %ebp
80108879:	89 e5                	mov    %esp,%ebp
8010887b:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010887e:	8b 45 10             	mov    0x10(%ebp),%eax
80108881:	85 c0                	test   %eax,%eax
80108883:	79 0a                	jns    8010888f <allocuvm+0x17>
    return 0;
80108885:	b8 00 00 00 00       	mov    $0x0,%eax
8010888a:	e9 ae 00 00 00       	jmp    8010893d <allocuvm+0xc5>
  if(newsz < oldsz)
8010888f:	8b 45 10             	mov    0x10(%ebp),%eax
80108892:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108895:	73 08                	jae    8010889f <allocuvm+0x27>
    return oldsz;
80108897:	8b 45 0c             	mov    0xc(%ebp),%eax
8010889a:	e9 9e 00 00 00       	jmp    8010893d <allocuvm+0xc5>

  a = PGROUNDUP(oldsz);
8010889f:	8b 45 0c             	mov    0xc(%ebp),%eax
801088a2:	05 ff 0f 00 00       	add    $0xfff,%eax
801088a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801088af:	eb 7d                	jmp    8010892e <allocuvm+0xb6>
    mem = kalloc();
801088b1:	e8 8b a3 ff ff       	call   80102c41 <kalloc>
801088b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801088b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801088bd:	75 2b                	jne    801088ea <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801088bf:	83 ec 0c             	sub    $0xc,%esp
801088c2:	68 bd 99 10 80       	push   $0x801099bd
801088c7:	e8 fa 7a ff ff       	call   801003c6 <cprintf>
801088cc:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801088cf:	83 ec 04             	sub    $0x4,%esp
801088d2:	ff 75 0c             	push   0xc(%ebp)
801088d5:	ff 75 10             	push   0x10(%ebp)
801088d8:	ff 75 08             	push   0x8(%ebp)
801088db:	e8 5f 00 00 00       	call   8010893f <deallocuvm>
801088e0:	83 c4 10             	add    $0x10,%esp
      return 0;
801088e3:	b8 00 00 00 00       	mov    $0x0,%eax
801088e8:	eb 53                	jmp    8010893d <allocuvm+0xc5>
    }
    memset(mem, 0, PGSIZE);
801088ea:	83 ec 04             	sub    $0x4,%esp
801088ed:	68 00 10 00 00       	push   $0x1000
801088f2:	6a 00                	push   $0x0
801088f4:	ff 75 f0             	push   -0x10(%ebp)
801088f7:	e8 78 cd ff ff       	call   80105674 <memset>
801088fc:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801088ff:	83 ec 0c             	sub    $0xc,%esp
80108902:	ff 75 f0             	push   -0x10(%ebp)
80108905:	e8 07 f6 ff ff       	call   80107f11 <v2p>
8010890a:	83 c4 10             	add    $0x10,%esp
8010890d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108910:	83 ec 0c             	sub    $0xc,%esp
80108913:	6a 06                	push   $0x6
80108915:	50                   	push   %eax
80108916:	68 00 10 00 00       	push   $0x1000
8010891b:	52                   	push   %edx
8010891c:	ff 75 08             	push   0x8(%ebp)
8010891f:	e8 1c fb ff ff       	call   80108440 <mappages>
80108924:	83 c4 20             	add    $0x20,%esp
  for(; a < newsz; a += PGSIZE){
80108927:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010892e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108931:	3b 45 10             	cmp    0x10(%ebp),%eax
80108934:	0f 82 77 ff ff ff    	jb     801088b1 <allocuvm+0x39>
  }
  return newsz;
8010893a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010893d:	c9                   	leave  
8010893e:	c3                   	ret    

8010893f <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010893f:	55                   	push   %ebp
80108940:	89 e5                	mov    %esp,%ebp
80108942:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108945:	8b 45 10             	mov    0x10(%ebp),%eax
80108948:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010894b:	72 08                	jb     80108955 <deallocuvm+0x16>
    return oldsz;
8010894d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108950:	e9 a5 00 00 00       	jmp    801089fa <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108955:	8b 45 10             	mov    0x10(%ebp),%eax
80108958:	05 ff 0f 00 00       	add    $0xfff,%eax
8010895d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < oldsz; a += PGSIZE){
80108965:	e9 81 00 00 00       	jmp    801089eb <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010896a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010896d:	83 ec 04             	sub    $0x4,%esp
80108970:	6a 00                	push   $0x0
80108972:	50                   	push   %eax
80108973:	ff 75 08             	push   0x8(%ebp)
80108976:	e8 25 fa ff ff       	call   801083a0 <walkpgdir>
8010897b:	83 c4 10             	add    $0x10,%esp
8010897e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108981:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108985:	75 09                	jne    80108990 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108987:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010898e:	eb 54                	jmp    801089e4 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108990:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108993:	8b 00                	mov    (%eax),%eax
80108995:	83 e0 01             	and    $0x1,%eax
80108998:	85 c0                	test   %eax,%eax
8010899a:	74 48                	je     801089e4 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
8010899c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010899f:	8b 00                	mov    (%eax),%eax
801089a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801089a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089ad:	75 0d                	jne    801089bc <deallocuvm+0x7d>
        panic("kfree");
801089af:	83 ec 0c             	sub    $0xc,%esp
801089b2:	68 d5 99 10 80       	push   $0x801099d5
801089b7:	e8 bf 7b ff ff       	call   8010057b <panic>
      char *v = p2v(pa);
801089bc:	83 ec 0c             	sub    $0xc,%esp
801089bf:	ff 75 ec             	push   -0x14(%ebp)
801089c2:	e8 57 f5 ff ff       	call   80107f1e <p2v>
801089c7:	83 c4 10             	add    $0x10,%esp
801089ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801089cd:	83 ec 0c             	sub    $0xc,%esp
801089d0:	ff 75 e8             	push   -0x18(%ebp)
801089d3:	e8 6f a1 ff ff       	call   80102b47 <kfree>
801089d8:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801089db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a < oldsz; a += PGSIZE){
801089e4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089f1:	0f 82 73 ff ff ff    	jb     8010896a <deallocuvm+0x2b>
    }
  }
  return newsz;
801089f7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089fa:	c9                   	leave  
801089fb:	c3                   	ret    

801089fc <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801089fc:	55                   	push   %ebp
801089fd:	89 e5                	mov    %esp,%ebp
801089ff:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108a02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a06:	75 0d                	jne    80108a15 <freevm+0x19>
    panic("freevm: no pgdir");
80108a08:	83 ec 0c             	sub    $0xc,%esp
80108a0b:	68 db 99 10 80       	push   $0x801099db
80108a10:	e8 66 7b ff ff       	call   8010057b <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a15:	83 ec 04             	sub    $0x4,%esp
80108a18:	6a 00                	push   $0x0
80108a1a:	68 00 00 00 80       	push   $0x80000000
80108a1f:	ff 75 08             	push   0x8(%ebp)
80108a22:	e8 18 ff ff ff       	call   8010893f <deallocuvm>
80108a27:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108a2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a31:	eb 4f                	jmp    80108a82 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a3d:	8b 45 08             	mov    0x8(%ebp),%eax
80108a40:	01 d0                	add    %edx,%eax
80108a42:	8b 00                	mov    (%eax),%eax
80108a44:	83 e0 01             	and    $0x1,%eax
80108a47:	85 c0                	test   %eax,%eax
80108a49:	74 33                	je     80108a7e <freevm+0x82>
      char *v = p2v(PTE_ADDR(pgdir[i]));
80108a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a4e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a55:	8b 45 08             	mov    0x8(%ebp),%eax
80108a58:	01 d0                	add    %edx,%eax
80108a5a:	8b 00                	mov    (%eax),%eax
80108a5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a61:	83 ec 0c             	sub    $0xc,%esp
80108a64:	50                   	push   %eax
80108a65:	e8 b4 f4 ff ff       	call   80107f1e <p2v>
80108a6a:	83 c4 10             	add    $0x10,%esp
80108a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108a70:	83 ec 0c             	sub    $0xc,%esp
80108a73:	ff 75 f0             	push   -0x10(%ebp)
80108a76:	e8 cc a0 ff ff       	call   80102b47 <kfree>
80108a7b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108a7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108a82:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108a89:	76 a8                	jbe    80108a33 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108a8b:	83 ec 0c             	sub    $0xc,%esp
80108a8e:	ff 75 08             	push   0x8(%ebp)
80108a91:	e8 b1 a0 ff ff       	call   80102b47 <kfree>
80108a96:	83 c4 10             	add    $0x10,%esp
}
80108a99:	90                   	nop
80108a9a:	c9                   	leave  
80108a9b:	c3                   	ret    

80108a9c <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a9c:	55                   	push   %ebp
80108a9d:	89 e5                	mov    %esp,%ebp
80108a9f:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108aa2:	83 ec 04             	sub    $0x4,%esp
80108aa5:	6a 00                	push   $0x0
80108aa7:	ff 75 0c             	push   0xc(%ebp)
80108aaa:	ff 75 08             	push   0x8(%ebp)
80108aad:	e8 ee f8 ff ff       	call   801083a0 <walkpgdir>
80108ab2:	83 c4 10             	add    $0x10,%esp
80108ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108abc:	75 0d                	jne    80108acb <clearpteu+0x2f>
    panic("clearpteu");
80108abe:	83 ec 0c             	sub    $0xc,%esp
80108ac1:	68 ec 99 10 80       	push   $0x801099ec
80108ac6:	e8 b0 7a ff ff       	call   8010057b <panic>
  *pte &= ~PTE_U;
80108acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ace:	8b 00                	mov    (%eax),%eax
80108ad0:	83 e0 fb             	and    $0xfffffffb,%eax
80108ad3:	89 c2                	mov    %eax,%edx
80108ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad8:	89 10                	mov    %edx,(%eax)
}
80108ada:	90                   	nop
80108adb:	c9                   	leave  
80108adc:	c3                   	ret    

80108add <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108add:	55                   	push   %ebp
80108ade:	89 e5                	mov    %esp,%ebp
80108ae0:	53                   	push   %ebx
80108ae1:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108ae4:	e8 e7 f9 ff ff       	call   801084d0 <setupkvm>
80108ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108aec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108af0:	75 0a                	jne    80108afc <copyuvm+0x1f>
    return 0;
80108af2:	b8 00 00 00 00       	mov    $0x0,%eax
80108af7:	e9 f6 00 00 00       	jmp    80108bf2 <copyuvm+0x115>
  for(i = 0; i < sz; i += PGSIZE){
80108afc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b03:	e9 c2 00 00 00       	jmp    80108bca <copyuvm+0xed>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0b:	83 ec 04             	sub    $0x4,%esp
80108b0e:	6a 00                	push   $0x0
80108b10:	50                   	push   %eax
80108b11:	ff 75 08             	push   0x8(%ebp)
80108b14:	e8 87 f8 ff ff       	call   801083a0 <walkpgdir>
80108b19:	83 c4 10             	add    $0x10,%esp
80108b1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b23:	75 0d                	jne    80108b32 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108b25:	83 ec 0c             	sub    $0xc,%esp
80108b28:	68 f6 99 10 80       	push   $0x801099f6
80108b2d:	e8 49 7a ff ff       	call   8010057b <panic>
    if(!(*pte & PTE_P))
80108b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b35:	8b 00                	mov    (%eax),%eax
80108b37:	83 e0 01             	and    $0x1,%eax
80108b3a:	85 c0                	test   %eax,%eax
80108b3c:	75 0d                	jne    80108b4b <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108b3e:	83 ec 0c             	sub    $0xc,%esp
80108b41:	68 10 9a 10 80       	push   $0x80109a10
80108b46:	e8 30 7a ff ff       	call   8010057b <panic>
    pa = PTE_ADDR(*pte);
80108b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b4e:	8b 00                	mov    (%eax),%eax
80108b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b55:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b5b:	8b 00                	mov    (%eax),%eax
80108b5d:	25 ff 0f 00 00       	and    $0xfff,%eax
80108b62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108b65:	e8 d7 a0 ff ff       	call   80102c41 <kalloc>
80108b6a:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108b6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108b71:	74 68                	je     80108bdb <copyuvm+0xfe>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108b73:	83 ec 0c             	sub    $0xc,%esp
80108b76:	ff 75 e8             	push   -0x18(%ebp)
80108b79:	e8 a0 f3 ff ff       	call   80107f1e <p2v>
80108b7e:	83 c4 10             	add    $0x10,%esp
80108b81:	83 ec 04             	sub    $0x4,%esp
80108b84:	68 00 10 00 00       	push   $0x1000
80108b89:	50                   	push   %eax
80108b8a:	ff 75 e0             	push   -0x20(%ebp)
80108b8d:	e8 a1 cb ff ff       	call   80105733 <memmove>
80108b92:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108b95:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108b98:	83 ec 0c             	sub    $0xc,%esp
80108b9b:	ff 75 e0             	push   -0x20(%ebp)
80108b9e:	e8 6e f3 ff ff       	call   80107f11 <v2p>
80108ba3:	83 c4 10             	add    $0x10,%esp
80108ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108ba9:	83 ec 0c             	sub    $0xc,%esp
80108bac:	53                   	push   %ebx
80108bad:	50                   	push   %eax
80108bae:	68 00 10 00 00       	push   $0x1000
80108bb3:	52                   	push   %edx
80108bb4:	ff 75 f0             	push   -0x10(%ebp)
80108bb7:	e8 84 f8 ff ff       	call   80108440 <mappages>
80108bbc:	83 c4 20             	add    $0x20,%esp
80108bbf:	85 c0                	test   %eax,%eax
80108bc1:	78 1b                	js     80108bde <copyuvm+0x101>
  for(i = 0; i < sz; i += PGSIZE){
80108bc3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bcd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108bd0:	0f 82 32 ff ff ff    	jb     80108b08 <copyuvm+0x2b>
      goto bad;
  }

  // lcr3(v2p(proc->pgdir)); // flush the TLB  
  return d;
80108bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bd9:	eb 17                	jmp    80108bf2 <copyuvm+0x115>
      goto bad;
80108bdb:	90                   	nop
80108bdc:	eb 01                	jmp    80108bdf <copyuvm+0x102>
      goto bad;
80108bde:	90                   	nop

bad:
  freevm(d);
80108bdf:	83 ec 0c             	sub    $0xc,%esp
80108be2:	ff 75 f0             	push   -0x10(%ebp)
80108be5:	e8 12 fe ff ff       	call   801089fc <freevm>
80108bea:	83 c4 10             	add    $0x10,%esp
  return 0;
80108bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108bf5:	c9                   	leave  
80108bf6:	c3                   	ret    

80108bf7 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108bf7:	55                   	push   %ebp
80108bf8:	89 e5                	mov    %esp,%ebp
80108bfa:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108bfd:	83 ec 04             	sub    $0x4,%esp
80108c00:	6a 00                	push   $0x0
80108c02:	ff 75 0c             	push   0xc(%ebp)
80108c05:	ff 75 08             	push   0x8(%ebp)
80108c08:	e8 93 f7 ff ff       	call   801083a0 <walkpgdir>
80108c0d:	83 c4 10             	add    $0x10,%esp
80108c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c16:	8b 00                	mov    (%eax),%eax
80108c18:	83 e0 01             	and    $0x1,%eax
80108c1b:	85 c0                	test   %eax,%eax
80108c1d:	75 07                	jne    80108c26 <uva2ka+0x2f>
    return 0;
80108c1f:	b8 00 00 00 00       	mov    $0x0,%eax
80108c24:	eb 2a                	jmp    80108c50 <uva2ka+0x59>
  if((*pte & PTE_U) == 0)
80108c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c29:	8b 00                	mov    (%eax),%eax
80108c2b:	83 e0 04             	and    $0x4,%eax
80108c2e:	85 c0                	test   %eax,%eax
80108c30:	75 07                	jne    80108c39 <uva2ka+0x42>
    return 0;
80108c32:	b8 00 00 00 00       	mov    $0x0,%eax
80108c37:	eb 17                	jmp    80108c50 <uva2ka+0x59>
  return (char*)p2v(PTE_ADDR(*pte));
80108c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c3c:	8b 00                	mov    (%eax),%eax
80108c3e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c43:	83 ec 0c             	sub    $0xc,%esp
80108c46:	50                   	push   %eax
80108c47:	e8 d2 f2 ff ff       	call   80107f1e <p2v>
80108c4c:	83 c4 10             	add    $0x10,%esp
80108c4f:	90                   	nop
}
80108c50:	c9                   	leave  
80108c51:	c3                   	ret    

80108c52 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108c52:	55                   	push   %ebp
80108c53:	89 e5                	mov    %esp,%ebp
80108c55:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108c58:	8b 45 10             	mov    0x10(%ebp),%eax
80108c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108c5e:	eb 7f                	jmp    80108cdf <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108c60:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c68:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c6e:	83 ec 08             	sub    $0x8,%esp
80108c71:	50                   	push   %eax
80108c72:	ff 75 08             	push   0x8(%ebp)
80108c75:	e8 7d ff ff ff       	call   80108bf7 <uva2ka>
80108c7a:	83 c4 10             	add    $0x10,%esp
80108c7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108c80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108c84:	75 07                	jne    80108c8d <copyout+0x3b>
      return -1;
80108c86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108c8b:	eb 61                	jmp    80108cee <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c90:	2b 45 0c             	sub    0xc(%ebp),%eax
80108c93:	05 00 10 00 00       	add    $0x1000,%eax
80108c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c9e:	3b 45 14             	cmp    0x14(%ebp),%eax
80108ca1:	76 06                	jbe    80108ca9 <copyout+0x57>
      n = len;
80108ca3:	8b 45 14             	mov    0x14(%ebp),%eax
80108ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cac:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108caf:	89 c2                	mov    %eax,%edx
80108cb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cb4:	01 d0                	add    %edx,%eax
80108cb6:	83 ec 04             	sub    $0x4,%esp
80108cb9:	ff 75 f0             	push   -0x10(%ebp)
80108cbc:	ff 75 f4             	push   -0xc(%ebp)
80108cbf:	50                   	push   %eax
80108cc0:	e8 6e ca ff ff       	call   80105733 <memmove>
80108cc5:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ccb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cd7:	05 00 10 00 00       	add    $0x1000,%eax
80108cdc:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108cdf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108ce3:	0f 85 77 ff ff ff    	jne    80108c60 <copyout+0xe>
  }
  return 0;
80108ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cee:	c9                   	leave  
80108cef:	c3                   	ret    

80108cf0 <mprotect>:
//PAGEBREAK!
// Blank page.

int
mprotect(int addr, int len, int prot)
{
80108cf0:	55                   	push   %ebp
80108cf1:	89 e5                	mov    %esp,%ebp
80108cf3:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  int i;
  for (i  = 0; i < len; ++i) {
80108cf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108cfd:	eb 73                	jmp    80108d72 <mprotect+0x82>
    pte = walkpgdir(proc->pgdir, (void*) addr + i, 0);
80108cff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108d02:	8b 45 08             	mov    0x8(%ebp),%eax
80108d05:	01 d0                	add    %edx,%eax
80108d07:	89 c2                	mov    %eax,%edx
80108d09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108d0f:	8b 40 04             	mov    0x4(%eax),%eax
80108d12:	83 ec 04             	sub    $0x4,%esp
80108d15:	6a 00                	push   $0x0
80108d17:	52                   	push   %edx
80108d18:	50                   	push   %eax
80108d19:	e8 82 f6 ff ff       	call   801083a0 <walkpgdir>
80108d1e:	83 c4 10             	add    $0x10,%esp
80108d21:	89 45 f0             	mov    %eax,-0x10(%ebp)

    cprintf("before change, content: %d\n", *pte);
80108d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d27:	8b 00                	mov    (%eax),%eax
80108d29:	83 ec 08             	sub    $0x8,%esp
80108d2c:	50                   	push   %eax
80108d2d:	68 2a 9a 10 80       	push   $0x80109a2a
80108d32:	e8 8f 76 ff ff       	call   801003c6 <cprintf>
80108d37:	83 c4 10             	add    $0x10,%esp
    *pte &= 0xFFFFFFFC; // disable the last two bits;
80108d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d3d:	8b 00                	mov    (%eax),%eax
80108d3f:	83 e0 fc             	and    $0xfffffffc,%eax
80108d42:	89 c2                	mov    %eax,%edx
80108d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d47:	89 10                	mov    %edx,(%eax)
    *pte |= prot; // set the corresponding permission
80108d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d4c:	8b 10                	mov    (%eax),%edx
80108d4e:	8b 45 10             	mov    0x10(%ebp),%eax
80108d51:	09 c2                	or     %eax,%edx
80108d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d56:	89 10                	mov    %edx,(%eax)
    cprintf("after change, content: %d\n", *pte);
80108d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d5b:	8b 00                	mov    (%eax),%eax
80108d5d:	83 ec 08             	sub    $0x8,%esp
80108d60:	50                   	push   %eax
80108d61:	68 46 9a 10 80       	push   $0x80109a46
80108d66:	e8 5b 76 ff ff       	call   801003c6 <cprintf>
80108d6b:	83 c4 10             	add    $0x10,%esp
  for (i  = 0; i < len; ++i) {
80108d6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d75:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d78:	7c 85                	jl     80108cff <mprotect+0xf>
  }

  lcr3(v2p(proc->pgdir)); // flush the TLB
80108d7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108d80:	8b 40 04             	mov    0x4(%eax),%eax
80108d83:	83 ec 0c             	sub    $0xc,%esp
80108d86:	50                   	push   %eax
80108d87:	e8 85 f1 ff ff       	call   80107f11 <v2p>
80108d8c:	83 c4 10             	add    $0x10,%esp
80108d8f:	83 ec 0c             	sub    $0xc,%esp
80108d92:	50                   	push   %eax
80108d93:	e8 6d f1 ff ff       	call   80107f05 <lcr3>
80108d98:	83 c4 10             	add    $0x10,%esp
  return 0;
80108d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108da0:	c9                   	leave  
80108da1:	c3                   	ret    

80108da2 <sharetableinit>:
struct spinlock tablelock; // lock for share table

// share table initialize function
void
sharetableinit(void)
{
80108da2:	55                   	push   %ebp
80108da3:	89 e5                	mov    %esp,%ebp
80108da5:	83 ec 08             	sub    $0x8,%esp
  initlock(&tablelock, "sharetable");
80108da8:	83 ec 08             	sub    $0x8,%esp
80108dab:	68 61 9a 10 80       	push   $0x80109a61
80108db0:	68 40 23 15 80       	push   $0x80152340
80108db5:	e8 35 c6 ff ff       	call   801053ef <initlock>
80108dba:	83 c4 10             	add    $0x10,%esp
  // cprintf("share table init done\n");
}
80108dbd:	90                   	nop
80108dbe:	c9                   	leave  
80108dbf:	c3                   	ret    

80108dc0 <cowmapuvm>:

// Given a parent process's page table, remap
// it for a COW child.
pde_t*
cowmapuvm(pde_t *pgdir, uint sz)
{
80108dc0:	55                   	push   %ebp
80108dc1:	89 e5                	mov    %esp,%ebp
80108dc3:	83 ec 28             	sub    $0x28,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  int index;

  if((d = setupkvm()) == 0)
80108dc6:	e8 05 f7 ff ff       	call   801084d0 <setupkvm>
80108dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108dce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108dd2:	75 0a                	jne    80108dde <cowmapuvm+0x1e>
    return 0;
80108dd4:	b8 00 00 00 00       	mov    $0x0,%eax
80108dd9:	e9 49 01 00 00       	jmp    80108f27 <cowmapuvm+0x167>
  acquire(&tablelock);
80108dde:	83 ec 0c             	sub    $0xc,%esp
80108de1:	68 40 23 15 80       	push   $0x80152340
80108de6:	e8 26 c6 ff ff       	call   80105411 <acquire>
80108deb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE){
80108dee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108df5:	e9 d7 00 00 00       	jmp    80108ed1 <cowmapuvm+0x111>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dfd:	83 ec 04             	sub    $0x4,%esp
80108e00:	6a 00                	push   $0x0
80108e02:	50                   	push   %eax
80108e03:	ff 75 08             	push   0x8(%ebp)
80108e06:	e8 95 f5 ff ff       	call   801083a0 <walkpgdir>
80108e0b:	83 c4 10             	add    $0x10,%esp
80108e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108e11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108e15:	75 0d                	jne    80108e24 <cowmapuvm+0x64>
      panic("copyuvm: pte should exist");
80108e17:	83 ec 0c             	sub    $0xc,%esp
80108e1a:	68 f6 99 10 80       	push   $0x801099f6
80108e1f:	e8 57 77 ff ff       	call   8010057b <panic>
    if(!(*pte & PTE_P))
80108e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e27:	8b 00                	mov    (%eax),%eax
80108e29:	83 e0 01             	and    $0x1,%eax
80108e2c:	85 c0                	test   %eax,%eax
80108e2e:	75 0d                	jne    80108e3d <cowmapuvm+0x7d>
      panic("copyuvm: page not present");
80108e30:	83 ec 0c             	sub    $0xc,%esp
80108e33:	68 10 9a 10 80       	push   $0x80109a10
80108e38:	e8 3e 77 ff ff       	call   8010057b <panic>
    *pte &= ~PTE_W; // disable the Writable bit
80108e3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e40:	8b 00                	mov    (%eax),%eax
80108e42:	83 e0 fd             	and    $0xfffffffd,%eax
80108e45:	89 c2                	mov    %eax,%edx
80108e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e4a:	89 10                	mov    %edx,(%eax)
    pa = PTE_ADDR(*pte);
80108e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e4f:	8b 00                	mov    (%eax),%eax
80108e51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e56:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e5c:	8b 00                	mov    (%eax),%eax
80108e5e:	25 ff 0f 00 00       	and    $0xfff,%eax
80108e63:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    // instead of create new pages, remap the pages for cow child
    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80108e66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e6c:	83 ec 0c             	sub    $0xc,%esp
80108e6f:	52                   	push   %edx
80108e70:	ff 75 e8             	push   -0x18(%ebp)
80108e73:	68 00 10 00 00       	push   $0x1000
80108e78:	50                   	push   %eax
80108e79:	ff 75 f0             	push   -0x10(%ebp)
80108e7c:	e8 bf f5 ff ff       	call   80108440 <mappages>
80108e81:	83 c4 20             	add    $0x20,%esp
80108e84:	85 c0                	test   %eax,%eax
80108e86:	0f 88 87 00 00 00    	js     80108f13 <cowmapuvm+0x153>
      goto bad;

    index = (pa >> 12) & 0xFFFFF; // get the physical page num
80108e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e8f:	c1 e8 0c             	shr    $0xc,%eax
80108e92:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (shareTable[index].count == 0) {
80108e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e98:	8b 04 85 40 63 11 80 	mov    -0x7fee9cc0(,%eax,4),%eax
80108e9f:	85 c0                	test   %eax,%eax
80108ea1:	75 10                	jne    80108eb3 <cowmapuvm+0xf3>
      shareTable[index].count = 2; // now is shared, totally 2 processes
80108ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ea6:	c7 04 85 40 63 11 80 	movl   $0x2,-0x7fee9cc0(,%eax,4)
80108ead:	02 00 00 00 
80108eb1:	eb 17                	jmp    80108eca <cowmapuvm+0x10a>
    }
    else {
      ++shareTable[index].count; // increase the share count
80108eb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108eb6:	8b 04 85 40 63 11 80 	mov    -0x7fee9cc0(,%eax,4),%eax
80108ebd:	8d 50 01             	lea    0x1(%eax),%edx
80108ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108ec3:	89 14 85 40 63 11 80 	mov    %edx,-0x7fee9cc0(,%eax,4)
  for(i = 0; i < sz; i += PGSIZE){
80108eca:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ed7:	0f 82 1d ff ff ff    	jb     80108dfa <cowmapuvm+0x3a>
    }
    
    // cprintf("pid: %d index: %d count: %d\n", proc->pid, index, shareTable[index].count);
  }
  release(&tablelock);
80108edd:	83 ec 0c             	sub    $0xc,%esp
80108ee0:	68 40 23 15 80       	push   $0x80152340
80108ee5:	e8 8e c5 ff ff       	call   80105478 <release>
80108eea:	83 c4 10             	add    $0x10,%esp
  lcr3(v2p(proc->pgdir)); // flush the TLB  
80108eed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108ef3:	8b 40 04             	mov    0x4(%eax),%eax
80108ef6:	83 ec 0c             	sub    $0xc,%esp
80108ef9:	50                   	push   %eax
80108efa:	e8 12 f0 ff ff       	call   80107f11 <v2p>
80108eff:	83 c4 10             	add    $0x10,%esp
80108f02:	83 ec 0c             	sub    $0xc,%esp
80108f05:	50                   	push   %eax
80108f06:	e8 fa ef ff ff       	call   80107f05 <lcr3>
80108f0b:	83 c4 10             	add    $0x10,%esp
  return d;
80108f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f11:	eb 14                	jmp    80108f27 <cowmapuvm+0x167>
      goto bad;
80108f13:	90                   	nop

bad:
  freevm(d);
80108f14:	83 ec 0c             	sub    $0xc,%esp
80108f17:	ff 75 f0             	push   -0x10(%ebp)
80108f1a:	e8 dd fa ff ff       	call   801089fc <freevm>
80108f1f:	83 c4 10             	add    $0x10,%esp
  return 0;
80108f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f27:	c9                   	leave  
80108f28:	c3                   	ret    

80108f29 <cowcopyuvm>:

int
cowcopyuvm(void)
{
80108f29:	55                   	push   %ebp
80108f2a:	89 e5                	mov    %esp,%ebp
80108f2c:	83 ec 28             	sub    $0x28,%esp
  int index;
  uint addr;
  pte_t *pte;
  char *mem;

  addr = rcr2();
80108f2f:	e8 c0 ef ff ff       	call   80107ef4 <rcr2>
80108f34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  pte = walkpgdir(proc->pgdir, (void *) addr, 0);
80108f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108f3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108f40:	8b 40 04             	mov    0x4(%eax),%eax
80108f43:	83 ec 04             	sub    $0x4,%esp
80108f46:	6a 00                	push   $0x0
80108f48:	52                   	push   %edx
80108f49:	50                   	push   %eax
80108f4a:	e8 51 f4 ff ff       	call   801083a0 <walkpgdir>
80108f4f:	83 c4 10             	add    $0x10,%esp
80108f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  pa = PTE_ADDR(*pte);
80108f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f58:	8b 00                	mov    (%eax),%eax
80108f5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  index = (pa >> 12) & 0xFFFFF; // get the physical page num
80108f62:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f65:	c1 e8 0c             	shr    $0xc,%eax
80108f68:	89 45 e8             	mov    %eax,-0x18(%ebp)

  // check if the address is in this process's user space
  if (addr < proc->sz) {
80108f6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108f71:	8b 00                	mov    (%eax),%eax
80108f73:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80108f76:	0f 83 e3 00 00 00    	jae    8010905f <cowcopyuvm+0x136>
    acquire(&tablelock);
80108f7c:	83 ec 0c             	sub    $0xc,%esp
80108f7f:	68 40 23 15 80       	push   $0x80152340
80108f84:	e8 88 c4 ff ff       	call   80105411 <acquire>
80108f89:	83 c4 10             	add    $0x10,%esp

    // if there are still multiple processes using this space
    if (shareTable[index].count > 1) {
80108f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108f8f:	8b 04 85 40 63 11 80 	mov    -0x7fee9cc0(,%eax,4),%eax
80108f96:	83 f8 01             	cmp    $0x1,%eax
80108f99:	7e 7d                	jle    80109018 <cowcopyuvm+0xef>
      if((mem = kalloc()) == 0) // allcoate a new page in physical memory
80108f9b:	e8 a1 9c ff ff       	call   80102c41 <kalloc>
80108fa0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108fa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80108fa7:	0f 84 b5 00 00 00    	je     80109062 <cowcopyuvm+0x139>
        goto bad;
      memmove(mem, (char*)p2v(pa), PGSIZE);
80108fad:	83 ec 0c             	sub    $0xc,%esp
80108fb0:	ff 75 ec             	push   -0x14(%ebp)
80108fb3:	e8 66 ef ff ff       	call   80107f1e <p2v>
80108fb8:	83 c4 10             	add    $0x10,%esp
80108fbb:	83 ec 04             	sub    $0x4,%esp
80108fbe:	68 00 10 00 00       	push   $0x1000
80108fc3:	50                   	push   %eax
80108fc4:	ff 75 e4             	push   -0x1c(%ebp)
80108fc7:	e8 67 c7 ff ff       	call   80105733 <memmove>
80108fcc:	83 c4 10             	add    $0x10,%esp
      *pte &= 0xFFF; // reset the first 20 bits of the entry
80108fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fd2:	8b 00                	mov    (%eax),%eax
80108fd4:	25 ff 0f 00 00       	and    $0xfff,%eax
80108fd9:	89 c2                	mov    %eax,%edx
80108fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108fde:	89 10                	mov    %edx,(%eax)
      *pte |= v2p(mem) | PTE_W; // insert the new physical page num and set to writable
80108fe0:	83 ec 0c             	sub    $0xc,%esp
80108fe3:	ff 75 e4             	push   -0x1c(%ebp)
80108fe6:	e8 26 ef ff ff       	call   80107f11 <v2p>
80108feb:	83 c4 10             	add    $0x10,%esp
80108fee:	83 c8 02             	or     $0x2,%eax
80108ff1:	89 c2                	mov    %eax,%edx
80108ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ff6:	8b 00                	mov    (%eax),%eax
80108ff8:	09 c2                	or     %eax,%edx
80108ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ffd:	89 10                	mov    %edx,(%eax)

      --shareTable[index].count; // decrease the share count
80108fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109002:	8b 04 85 40 63 11 80 	mov    -0x7fee9cc0(,%eax,4),%eax
80109009:	8d 50 ff             	lea    -0x1(%eax),%edx
8010900c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010900f:	89 14 85 40 63 11 80 	mov    %edx,-0x7fee9cc0(,%eax,4)
80109016:	eb 0f                	jmp    80109027 <cowcopyuvm+0xfe>
    }
    // if there is only one process using this space
    else {
      *pte |= PTE_W; // just enable the Writable bit for this process
80109018:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010901b:	8b 00                	mov    (%eax),%eax
8010901d:	83 c8 02             	or     $0x2,%eax
80109020:	89 c2                	mov    %eax,%edx
80109022:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109025:	89 10                	mov    %edx,(%eax)
    }

    release(&tablelock);
80109027:	83 ec 0c             	sub    $0xc,%esp
8010902a:	68 40 23 15 80       	push   $0x80152340
8010902f:	e8 44 c4 ff ff       	call   80105478 <release>
80109034:	83 c4 10             	add    $0x10,%esp
    lcr3(v2p(proc->pgdir)); // flush the TLB
80109037:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010903d:	8b 40 04             	mov    0x4(%eax),%eax
80109040:	83 ec 0c             	sub    $0xc,%esp
80109043:	50                   	push   %eax
80109044:	e8 c8 ee ff ff       	call   80107f11 <v2p>
80109049:	83 c4 10             	add    $0x10,%esp
8010904c:	83 ec 0c             	sub    $0xc,%esp
8010904f:	50                   	push   %eax
80109050:	e8 b0 ee ff ff       	call   80107f05 <lcr3>
80109055:	83 c4 10             	add    $0x10,%esp
    return 1;
80109058:	b8 01 00 00 00       	mov    $0x1,%eax
8010905d:	eb 09                	jmp    80109068 <cowcopyuvm+0x13f>
  }

bad:
8010905f:	90                   	nop
80109060:	eb 01                	jmp    80109063 <cowcopyuvm+0x13a>
        goto bad;
80109062:	90                   	nop
  return 0;
80109063:	b8 00 00 00 00       	mov    $0x0,%eax
} 
80109068:	c9                   	leave  
80109069:	c3                   	ret    

8010906a <cowdeallocuvm>:

int
cowdeallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010906a:	55                   	push   %ebp
8010906b:	89 e5                	mov    %esp,%ebp
8010906d:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;
  int index;

  if(newsz >= oldsz)
80109070:	8b 45 10             	mov    0x10(%ebp),%eax
80109073:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109076:	72 08                	jb     80109080 <cowdeallocuvm+0x16>
    return oldsz;
80109078:	8b 45 0c             	mov    0xc(%ebp),%eax
8010907b:	e9 0b 01 00 00       	jmp    8010918b <cowdeallocuvm+0x121>

  a = PGROUNDUP(newsz);
80109080:	8b 45 10             	mov    0x10(%ebp),%eax
80109083:	05 ff 0f 00 00       	add    $0xfff,%eax
80109088:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010908d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&tablelock);
80109090:	83 ec 0c             	sub    $0xc,%esp
80109093:	68 40 23 15 80       	push   $0x80152340
80109098:	e8 74 c3 ff ff       	call   80105411 <acquire>
8010909d:	83 c4 10             	add    $0x10,%esp
  for(; a < oldsz; a += PGSIZE){
801090a0:	e9 c7 00 00 00       	jmp    8010916c <cowdeallocuvm+0x102>
    pte = walkpgdir(pgdir, (char*)a, 0);
801090a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801090a8:	83 ec 04             	sub    $0x4,%esp
801090ab:	6a 00                	push   $0x0
801090ad:	50                   	push   %eax
801090ae:	ff 75 08             	push   0x8(%ebp)
801090b1:	e8 ea f2 ff ff       	call   801083a0 <walkpgdir>
801090b6:	83 c4 10             	add    $0x10,%esp
801090b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801090bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801090c0:	75 0c                	jne    801090ce <cowdeallocuvm+0x64>
      a += (NPTENTRIES - 1) * PGSIZE;
801090c2:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801090c9:	e9 97 00 00 00       	jmp    80109165 <cowdeallocuvm+0xfb>
    else if((*pte & PTE_P) != 0){
801090ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090d1:	8b 00                	mov    (%eax),%eax
801090d3:	83 e0 01             	and    $0x1,%eax
801090d6:	85 c0                	test   %eax,%eax
801090d8:	0f 84 87 00 00 00    	je     80109165 <cowdeallocuvm+0xfb>
      pa = PTE_ADDR(*pte);
801090de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801090e1:	8b 00                	mov    (%eax),%eax
801090e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801090e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
      index = (pa >> 12) & 0xFFFFF; // get the physical page num
801090eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801090ee:	c1 e8 0c             	shr    $0xc,%eax
801090f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(pa == 0)
801090f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801090f8:	75 0d                	jne    80109107 <cowdeallocuvm+0x9d>
        panic("kfree");
801090fa:	83 ec 0c             	sub    $0xc,%esp
801090fd:	68 d5 99 10 80       	push   $0x801099d5
80109102:	e8 74 74 ff ff       	call   8010057b <panic>
      // if there are more than one process sharing the space, decrease the counter
      if (shareTable[index].count > 1) {
80109107:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010910a:	8b 04 85 40 63 11 80 	mov    -0x7fee9cc0(,%eax,4),%eax
80109111:	83 f8 01             	cmp    $0x1,%eax
80109114:	7e 19                	jle    8010912f <cowdeallocuvm+0xc5>
        --shareTable[index].count;
80109116:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109119:	8b 04 85 40 63 11 80 	mov    -0x7fee9cc0(,%eax,4),%eax
80109120:	8d 50 ff             	lea    -0x1(%eax),%edx
80109123:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109126:	89 14 85 40 63 11 80 	mov    %edx,-0x7fee9cc0(,%eax,4)
8010912d:	eb 2d                	jmp    8010915c <cowdeallocuvm+0xf2>
      }
      // if the memory space is only used by this process, free it
      else {
        char *v = p2v(pa);
8010912f:	83 ec 0c             	sub    $0xc,%esp
80109132:	ff 75 ec             	push   -0x14(%ebp)
80109135:	e8 e4 ed ff ff       	call   80107f1e <p2v>
8010913a:	83 c4 10             	add    $0x10,%esp
8010913d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(v);
80109140:	83 ec 0c             	sub    $0xc,%esp
80109143:	ff 75 e4             	push   -0x1c(%ebp)
80109146:	e8 fc 99 ff ff       	call   80102b47 <kfree>
8010914b:	83 c4 10             	add    $0x10,%esp
        shareTable[index].count = 0;
8010914e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109151:	c7 04 85 40 63 11 80 	movl   $0x0,-0x7fee9cc0(,%eax,4)
80109158:	00 00 00 00 
      }
      *pte = 0;
8010915c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010915f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a < oldsz; a += PGSIZE){
80109165:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010916c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010916f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109172:	0f 82 2d ff ff ff    	jb     801090a5 <cowdeallocuvm+0x3b>
    }
  }
  release(&tablelock);
80109178:	83 ec 0c             	sub    $0xc,%esp
8010917b:	68 40 23 15 80       	push   $0x80152340
80109180:	e8 f3 c2 ff ff       	call   80105478 <release>
80109185:	83 c4 10             	add    $0x10,%esp
  return newsz;
80109188:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010918b:	c9                   	leave  
8010918c:	c3                   	ret    

8010918d <cowfreevm>:

void
cowfreevm(pde_t *pgdir)
{
8010918d:	55                   	push   %ebp
8010918e:	89 e5                	mov    %esp,%ebp
80109190:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109197:	75 0d                	jne    801091a6 <cowfreevm+0x19>
    panic("freevm: no pgdir");
80109199:	83 ec 0c             	sub    $0xc,%esp
8010919c:	68 db 99 10 80       	push   $0x801099db
801091a1:	e8 d5 73 ff ff       	call   8010057b <panic>
  cowdeallocuvm(pgdir, KERNBASE, 0);
801091a6:	83 ec 04             	sub    $0x4,%esp
801091a9:	6a 00                	push   $0x0
801091ab:	68 00 00 00 80       	push   $0x80000000
801091b0:	ff 75 08             	push   0x8(%ebp)
801091b3:	e8 b2 fe ff ff       	call   8010906a <cowdeallocuvm>
801091b8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801091bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801091c2:	eb 4f                	jmp    80109213 <cowfreevm+0x86>
    if(pgdir[i] & PTE_P){
801091c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801091ce:	8b 45 08             	mov    0x8(%ebp),%eax
801091d1:	01 d0                	add    %edx,%eax
801091d3:	8b 00                	mov    (%eax),%eax
801091d5:	83 e0 01             	and    $0x1,%eax
801091d8:	85 c0                	test   %eax,%eax
801091da:	74 33                	je     8010920f <cowfreevm+0x82>
      char *v = p2v(PTE_ADDR(pgdir[i]));
801091dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801091e6:	8b 45 08             	mov    0x8(%ebp),%eax
801091e9:	01 d0                	add    %edx,%eax
801091eb:	8b 00                	mov    (%eax),%eax
801091ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801091f2:	83 ec 0c             	sub    $0xc,%esp
801091f5:	50                   	push   %eax
801091f6:	e8 23 ed ff ff       	call   80107f1e <p2v>
801091fb:	83 c4 10             	add    $0x10,%esp
801091fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109201:	83 ec 0c             	sub    $0xc,%esp
80109204:	ff 75 f0             	push   -0x10(%ebp)
80109207:	e8 3b 99 ff ff       	call   80102b47 <kfree>
8010920c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010920f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109213:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010921a:	76 a8                	jbe    801091c4 <cowfreevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010921c:	83 ec 0c             	sub    $0xc,%esp
8010921f:	ff 75 08             	push   0x8(%ebp)
80109222:	e8 20 99 ff ff       	call   80102b47 <kfree>
80109227:	83 c4 10             	add    $0x10,%esp
}
8010922a:	90                   	nop
8010922b:	c9                   	leave  
8010922c:	c3                   	ret    

8010922d <dchangesize>:

// Calculate the new size for growing process from oldsz to
// newsz, which need not be page aligned. Returns new size or 0 on error.
int
dchangesize(uint oldsz, uint newsz)
{
8010922d:	55                   	push   %ebp
8010922e:	89 e5                	mov    %esp,%ebp
80109230:	83 ec 10             	sub    $0x10,%esp
  uint a;

  if(newsz >= KERNBASE)
80109233:	8b 45 0c             	mov    0xc(%ebp),%eax
80109236:	85 c0                	test   %eax,%eax
80109238:	79 07                	jns    80109241 <dchangesize+0x14>
    return 0;
8010923a:	b8 00 00 00 00       	mov    $0x0,%eax
8010923f:	eb 31                	jmp    80109272 <dchangesize+0x45>
  if(newsz < oldsz)
80109241:	8b 45 0c             	mov    0xc(%ebp),%eax
80109244:	3b 45 08             	cmp    0x8(%ebp),%eax
80109247:	73 05                	jae    8010924e <dchangesize+0x21>
    return oldsz;
80109249:	8b 45 08             	mov    0x8(%ebp),%eax
8010924c:	eb 24                	jmp    80109272 <dchangesize+0x45>

  a = PGROUNDUP(oldsz);
8010924e:	8b 45 08             	mov    0x8(%ebp),%eax
80109251:	05 ff 0f 00 00       	add    $0xfff,%eax
80109256:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010925b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(; a < newsz; a += PGSIZE){}
8010925e:	eb 07                	jmp    80109267 <dchangesize+0x3a>
80109260:	81 45 fc 00 10 00 00 	addl   $0x1000,-0x4(%ebp)
80109267:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010926a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010926d:	72 f1                	jb     80109260 <dchangesize+0x33>
  return newsz;
8010926f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
80109272:	c9                   	leave  
80109273:	c3                   	ret    
