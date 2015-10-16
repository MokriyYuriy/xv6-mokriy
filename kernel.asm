
kernel:     формат файла elf32-i386


Дизассемблирование раздела .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 2c 38 10 80       	mov    $0x8010382c,%eax
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
8010003d:	68 94 84 10 80       	push   $0x80108494
80100042:	68 80 c6 10 80       	push   $0x8010c680
80100047:	e8 19 4f 00 00       	call   80104f65 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 05 11 80 84 	movl   $0x80110584,0x80110590
80100056:	05 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 05 11 80 84 	movl   $0x80110584,0x80110594
80100060:	05 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 05 11 80    	mov    0x80110594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 05 11 80       	mov    0x80110594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 05 11 80       	mov    %eax,0x80110594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801000ad:	72 bd                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000af:	c9                   	leave  
801000b0:	c3                   	ret    

801000b1 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b1:	55                   	push   %ebp
801000b2:	89 e5                	mov    %esp,%ebp
801000b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b7:	83 ec 0c             	sub    $0xc,%esp
801000ba:	68 80 c6 10 80       	push   $0x8010c680
801000bf:	e8 c2 4e 00 00       	call   80104f86 <acquire>
801000c4:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c7:	a1 94 05 11 80       	mov    0x80110594,%eax
801000cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000cf:	eb 67                	jmp    80100138 <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d4:	8b 40 04             	mov    0x4(%eax),%eax
801000d7:	3b 45 08             	cmp    0x8(%ebp),%eax
801000da:	75 53                	jne    8010012f <bget+0x7e>
801000dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000df:	8b 40 08             	mov    0x8(%eax),%eax
801000e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e5:	75 48                	jne    8010012f <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ea:	8b 00                	mov    (%eax),%eax
801000ec:	83 e0 01             	and    $0x1,%eax
801000ef:	85 c0                	test   %eax,%eax
801000f1:	75 27                	jne    8010011a <bget+0x69>
        b->flags |= B_BUSY;
801000f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f6:	8b 00                	mov    (%eax),%eax
801000f8:	83 c8 01             	or     $0x1,%eax
801000fb:	89 c2                	mov    %eax,%edx
801000fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100100:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100102:	83 ec 0c             	sub    $0xc,%esp
80100105:	68 80 c6 10 80       	push   $0x8010c680
8010010a:	e8 dd 4e 00 00       	call   80104fec <release>
8010010f:	83 c4 10             	add    $0x10,%esp
        return b;
80100112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100115:	e9 98 00 00 00       	jmp    801001b2 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011a:	83 ec 08             	sub    $0x8,%esp
8010011d:	68 80 c6 10 80       	push   $0x8010c680
80100122:	ff 75 f4             	pushl  -0xc(%ebp)
80100125:	e8 6c 4b 00 00       	call   80104c96 <sleep>
8010012a:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012d:	eb 98                	jmp    801000c7 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010012f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100132:	8b 40 10             	mov    0x10(%eax),%eax
80100135:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100138:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
8010013f:	75 90                	jne    801000d1 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100141:	a1 90 05 11 80       	mov    0x80110590,%eax
80100146:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100149:	eb 51                	jmp    8010019c <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010014e:	8b 00                	mov    (%eax),%eax
80100150:	83 e0 01             	and    $0x1,%eax
80100153:	85 c0                	test   %eax,%eax
80100155:	75 3c                	jne    80100193 <bget+0xe2>
80100157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015a:	8b 00                	mov    (%eax),%eax
8010015c:	83 e0 04             	and    $0x4,%eax
8010015f:	85 c0                	test   %eax,%eax
80100161:	75 30                	jne    80100193 <bget+0xe2>
      b->dev = dev;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 08             	mov    0x8(%ebp),%edx
80100169:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	8b 55 0c             	mov    0xc(%ebp),%edx
80100172:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100175:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100178:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
8010017e:	83 ec 0c             	sub    $0xc,%esp
80100181:	68 80 c6 10 80       	push   $0x8010c680
80100186:	e8 61 4e 00 00       	call   80104fec <release>
8010018b:	83 c4 10             	add    $0x10,%esp
      return b;
8010018e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100191:	eb 1f                	jmp    801001b2 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100196:	8b 40 0c             	mov    0xc(%eax),%eax
80100199:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019c:	81 7d f4 84 05 11 80 	cmpl   $0x80110584,-0xc(%ebp)
801001a3:	75 a6                	jne    8010014b <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a5:	83 ec 0c             	sub    $0xc,%esp
801001a8:	68 9b 84 10 80       	push   $0x8010849b
801001ad:	e8 aa 03 00 00       	call   8010055c <panic>
}
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    

801001b4 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001ba:	83 ec 08             	sub    $0x8,%esp
801001bd:	ff 75 0c             	pushl  0xc(%ebp)
801001c0:	ff 75 08             	pushl  0x8(%ebp)
801001c3:	e8 e9 fe ff ff       	call   801000b1 <bget>
801001c8:	83 c4 10             	add    $0x10,%esp
801001cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d1:	8b 00                	mov    (%eax),%eax
801001d3:	83 e0 02             	and    $0x2,%eax
801001d6:	85 c0                	test   %eax,%eax
801001d8:	75 0e                	jne    801001e8 <bread+0x34>
    iderw(b);
801001da:	83 ec 0c             	sub    $0xc,%esp
801001dd:	ff 75 f4             	pushl  -0xc(%ebp)
801001e0:	e8 df 26 00 00       	call   801028c4 <iderw>
801001e5:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001eb:	c9                   	leave  
801001ec:	c3                   	ret    

801001ed <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ed:	55                   	push   %ebp
801001ee:	89 e5                	mov    %esp,%ebp
801001f0:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f3:	8b 45 08             	mov    0x8(%ebp),%eax
801001f6:	8b 00                	mov    (%eax),%eax
801001f8:	83 e0 01             	and    $0x1,%eax
801001fb:	85 c0                	test   %eax,%eax
801001fd:	75 0d                	jne    8010020c <bwrite+0x1f>
    panic("bwrite");
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	68 ac 84 10 80       	push   $0x801084ac
80100207:	e8 50 03 00 00       	call   8010055c <panic>
  b->flags |= B_DIRTY;
8010020c:	8b 45 08             	mov    0x8(%ebp),%eax
8010020f:	8b 00                	mov    (%eax),%eax
80100211:	83 c8 04             	or     $0x4,%eax
80100214:	89 c2                	mov    %eax,%edx
80100216:	8b 45 08             	mov    0x8(%ebp),%eax
80100219:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	ff 75 08             	pushl  0x8(%ebp)
80100221:	e8 9e 26 00 00       	call   801028c4 <iderw>
80100226:	83 c4 10             	add    $0x10,%esp
}
80100229:	c9                   	leave  
8010022a:	c3                   	ret    

8010022b <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022b:	55                   	push   %ebp
8010022c:	89 e5                	mov    %esp,%ebp
8010022e:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100231:	8b 45 08             	mov    0x8(%ebp),%eax
80100234:	8b 00                	mov    (%eax),%eax
80100236:	83 e0 01             	and    $0x1,%eax
80100239:	85 c0                	test   %eax,%eax
8010023b:	75 0d                	jne    8010024a <brelse+0x1f>
    panic("brelse");
8010023d:	83 ec 0c             	sub    $0xc,%esp
80100240:	68 b3 84 10 80       	push   $0x801084b3
80100245:	e8 12 03 00 00       	call   8010055c <panic>

  acquire(&bcache.lock);
8010024a:	83 ec 0c             	sub    $0xc,%esp
8010024d:	68 80 c6 10 80       	push   $0x8010c680
80100252:	e8 2f 4d 00 00       	call   80104f86 <acquire>
80100257:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025a:	8b 45 08             	mov    0x8(%ebp),%eax
8010025d:	8b 40 10             	mov    0x10(%eax),%eax
80100260:	8b 55 08             	mov    0x8(%ebp),%edx
80100263:	8b 52 0c             	mov    0xc(%edx),%edx
80100266:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100269:	8b 45 08             	mov    0x8(%ebp),%eax
8010026c:	8b 40 0c             	mov    0xc(%eax),%eax
8010026f:	8b 55 08             	mov    0x8(%ebp),%edx
80100272:	8b 52 10             	mov    0x10(%edx),%edx
80100275:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
80100278:	8b 15 94 05 11 80    	mov    0x80110594,%edx
8010027e:	8b 45 08             	mov    0x8(%ebp),%eax
80100281:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100284:	8b 45 08             	mov    0x8(%ebp),%eax
80100287:	c7 40 0c 84 05 11 80 	movl   $0x80110584,0xc(%eax)
  bcache.head.next->prev = b;
8010028e:	a1 94 05 11 80       	mov    0x80110594,%eax
80100293:	8b 55 08             	mov    0x8(%ebp),%edx
80100296:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100299:	8b 45 08             	mov    0x8(%ebp),%eax
8010029c:	a3 94 05 11 80       	mov    %eax,0x80110594

  b->flags &= ~B_BUSY;
801002a1:	8b 45 08             	mov    0x8(%ebp),%eax
801002a4:	8b 00                	mov    (%eax),%eax
801002a6:	83 e0 fe             	and    $0xfffffffe,%eax
801002a9:	89 c2                	mov    %eax,%edx
801002ab:	8b 45 08             	mov    0x8(%ebp),%eax
801002ae:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b0:	83 ec 0c             	sub    $0xc,%esp
801002b3:	ff 75 08             	pushl  0x8(%ebp)
801002b6:	e8 c4 4a 00 00       	call   80104d7f <wakeup>
801002bb:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002be:	83 ec 0c             	sub    $0xc,%esp
801002c1:	68 80 c6 10 80       	push   $0x8010c680
801002c6:	e8 21 4d 00 00       	call   80104fec <release>
801002cb:	83 c4 10             	add    $0x10,%esp
}
801002ce:	c9                   	leave  
801002cf:	c3                   	ret    

801002d0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d0:	55                   	push   %ebp
801002d1:	89 e5                	mov    %esp,%ebp
801002d3:	83 ec 14             	sub    $0x14,%esp
801002d6:	8b 45 08             	mov    0x8(%ebp),%eax
801002d9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e1:	89 c2                	mov    %eax,%edx
801002e3:	ec                   	in     (%dx),%al
801002e4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002e7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002eb:	c9                   	leave  
801002ec:	c3                   	ret    

801002ed <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002ed:	55                   	push   %ebp
801002ee:	89 e5                	mov    %esp,%ebp
801002f0:	83 ec 08             	sub    $0x8,%esp
801002f3:	8b 55 08             	mov    0x8(%ebp),%edx
801002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002f9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002fd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100300:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100304:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100308:	ee                   	out    %al,(%dx)
}
80100309:	c9                   	leave  
8010030a:	c3                   	ret    

8010030b <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010030b:	55                   	push   %ebp
8010030c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010030e:	fa                   	cli    
}
8010030f:	5d                   	pop    %ebp
80100310:	c3                   	ret    

80100311 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100311:	55                   	push   %ebp
80100312:	89 e5                	mov    %esp,%ebp
80100314:	53                   	push   %ebx
80100315:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010031c:	74 1c                	je     8010033a <printint+0x29>
8010031e:	8b 45 08             	mov    0x8(%ebp),%eax
80100321:	c1 e8 1f             	shr    $0x1f,%eax
80100324:	0f b6 c0             	movzbl %al,%eax
80100327:	89 45 10             	mov    %eax,0x10(%ebp)
8010032a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010032e:	74 0a                	je     8010033a <printint+0x29>
    x = -xx;
80100330:	8b 45 08             	mov    0x8(%ebp),%eax
80100333:	f7 d8                	neg    %eax
80100335:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100338:	eb 06                	jmp    80100340 <printint+0x2f>
  else
    x = xx;
8010033a:	8b 45 08             	mov    0x8(%ebp),%eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100347:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010034a:	8d 41 01             	lea    0x1(%ecx),%eax
8010034d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100350:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100356:	ba 00 00 00 00       	mov    $0x0,%edx
8010035b:	f7 f3                	div    %ebx
8010035d:	89 d0                	mov    %edx,%eax
8010035f:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
80100366:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010036a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100370:	ba 00 00 00 00       	mov    $0x0,%edx
80100375:	f7 f3                	div    %ebx
80100377:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010037a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010037e:	75 c7                	jne    80100347 <printint+0x36>

  if(sign)
80100380:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100384:	74 0e                	je     80100394 <printint+0x83>
    buf[i++] = '-';
80100386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100389:	8d 50 01             	lea    0x1(%eax),%edx
8010038c:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010038f:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100394:	eb 1a                	jmp    801003b0 <printint+0x9f>
    consputc(buf[i]);
80100396:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100399:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010039c:	01 d0                	add    %edx,%eax
8010039e:	0f b6 00             	movzbl (%eax),%eax
801003a1:	0f be c0             	movsbl %al,%eax
801003a4:	83 ec 0c             	sub    $0xc,%esp
801003a7:	50                   	push   %eax
801003a8:	e8 be 03 00 00       	call   8010076b <consputc>
801003ad:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003b8:	79 dc                	jns    80100396 <printint+0x85>
    consputc(buf[i]);
}
801003ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003bd:	c9                   	leave  
801003be:	c3                   	ret    

801003bf <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003bf:	55                   	push   %ebp
801003c0:	89 e5                	mov    %esp,%ebp
801003c2:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003c5:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d1:	74 10                	je     801003e3 <cprintf+0x24>
    acquire(&cons.lock);
801003d3:	83 ec 0c             	sub    $0xc,%esp
801003d6:	68 e0 b5 10 80       	push   $0x8010b5e0
801003db:	e8 a6 4b 00 00       	call   80104f86 <acquire>
801003e0:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003e3:	8b 45 08             	mov    0x8(%ebp),%eax
801003e6:	85 c0                	test   %eax,%eax
801003e8:	75 0d                	jne    801003f7 <cprintf+0x38>
    panic("null fmt");
801003ea:	83 ec 0c             	sub    $0xc,%esp
801003ed:	68 ba 84 10 80       	push   $0x801084ba
801003f2:	e8 65 01 00 00       	call   8010055c <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003f7:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100404:	e9 1b 01 00 00       	jmp    80100524 <cprintf+0x165>
    if(c != '%'){
80100409:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
8010040d:	74 13                	je     80100422 <cprintf+0x63>
      consputc(c);
8010040f:	83 ec 0c             	sub    $0xc,%esp
80100412:	ff 75 e4             	pushl  -0x1c(%ebp)
80100415:	e8 51 03 00 00       	call   8010076b <consputc>
8010041a:	83 c4 10             	add    $0x10,%esp
      continue;
8010041d:	e9 fe 00 00 00       	jmp    80100520 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
80100422:	8b 55 08             	mov    0x8(%ebp),%edx
80100425:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042c:	01 d0                	add    %edx,%eax
8010042e:	0f b6 00             	movzbl (%eax),%eax
80100431:	0f be c0             	movsbl %al,%eax
80100434:	25 ff 00 00 00       	and    $0xff,%eax
80100439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100440:	75 05                	jne    80100447 <cprintf+0x88>
      break;
80100442:	e9 fd 00 00 00       	jmp    80100544 <cprintf+0x185>
    switch(c){
80100447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044a:	83 f8 70             	cmp    $0x70,%eax
8010044d:	74 47                	je     80100496 <cprintf+0xd7>
8010044f:	83 f8 70             	cmp    $0x70,%eax
80100452:	7f 13                	jg     80100467 <cprintf+0xa8>
80100454:	83 f8 25             	cmp    $0x25,%eax
80100457:	0f 84 98 00 00 00    	je     801004f5 <cprintf+0x136>
8010045d:	83 f8 64             	cmp    $0x64,%eax
80100460:	74 14                	je     80100476 <cprintf+0xb7>
80100462:	e9 9d 00 00 00       	jmp    80100504 <cprintf+0x145>
80100467:	83 f8 73             	cmp    $0x73,%eax
8010046a:	74 47                	je     801004b3 <cprintf+0xf4>
8010046c:	83 f8 78             	cmp    $0x78,%eax
8010046f:	74 25                	je     80100496 <cprintf+0xd7>
80100471:	e9 8e 00 00 00       	jmp    80100504 <cprintf+0x145>
    case 'd':
      printint(*argp++, 10, 1);
80100476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100479:	8d 50 04             	lea    0x4(%eax),%edx
8010047c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010047f:	8b 00                	mov    (%eax),%eax
80100481:	83 ec 04             	sub    $0x4,%esp
80100484:	6a 01                	push   $0x1
80100486:	6a 0a                	push   $0xa
80100488:	50                   	push   %eax
80100489:	e8 83 fe ff ff       	call   80100311 <printint>
8010048e:	83 c4 10             	add    $0x10,%esp
      break;
80100491:	e9 8a 00 00 00       	jmp    80100520 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8d 50 04             	lea    0x4(%eax),%edx
8010049c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049f:	8b 00                	mov    (%eax),%eax
801004a1:	83 ec 04             	sub    $0x4,%esp
801004a4:	6a 00                	push   $0x0
801004a6:	6a 10                	push   $0x10
801004a8:	50                   	push   %eax
801004a9:	e8 63 fe ff ff       	call   80100311 <printint>
801004ae:	83 c4 10             	add    $0x10,%esp
      break;
801004b1:	eb 6d                	jmp    80100520 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b6:	8d 50 04             	lea    0x4(%eax),%edx
801004b9:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004bc:	8b 00                	mov    (%eax),%eax
801004be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004c5:	75 07                	jne    801004ce <cprintf+0x10f>
        s = "(null)";
801004c7:	c7 45 ec c3 84 10 80 	movl   $0x801084c3,-0x14(%ebp)
      for(; *s; s++)
801004ce:	eb 19                	jmp    801004e9 <cprintf+0x12a>
        consputc(*s);
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	0f be c0             	movsbl %al,%eax
801004d9:	83 ec 0c             	sub    $0xc,%esp
801004dc:	50                   	push   %eax
801004dd:	e8 89 02 00 00       	call   8010076b <consputc>
801004e2:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ec:	0f b6 00             	movzbl (%eax),%eax
801004ef:	84 c0                	test   %al,%al
801004f1:	75 dd                	jne    801004d0 <cprintf+0x111>
        consputc(*s);
      break;
801004f3:	eb 2b                	jmp    80100520 <cprintf+0x161>
    case '%':
      consputc('%');
801004f5:	83 ec 0c             	sub    $0xc,%esp
801004f8:	6a 25                	push   $0x25
801004fa:	e8 6c 02 00 00       	call   8010076b <consputc>
801004ff:	83 c4 10             	add    $0x10,%esp
      break;
80100502:	eb 1c                	jmp    80100520 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100504:	83 ec 0c             	sub    $0xc,%esp
80100507:	6a 25                	push   $0x25
80100509:	e8 5d 02 00 00       	call   8010076b <consputc>
8010050e:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100511:	83 ec 0c             	sub    $0xc,%esp
80100514:	ff 75 e4             	pushl  -0x1c(%ebp)
80100517:	e8 4f 02 00 00       	call   8010076b <consputc>
8010051c:	83 c4 10             	add    $0x10,%esp
      break;
8010051f:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100520:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100524:	8b 55 08             	mov    0x8(%ebp),%edx
80100527:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010052a:	01 d0                	add    %edx,%eax
8010052c:	0f b6 00             	movzbl (%eax),%eax
8010052f:	0f be c0             	movsbl %al,%eax
80100532:	25 ff 00 00 00       	and    $0xff,%eax
80100537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010053a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010053e:	0f 85 c5 fe ff ff    	jne    80100409 <cprintf+0x4a>
      consputc(c);
      break;
    }
  }

  if(locking)
80100544:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100548:	74 10                	je     8010055a <cprintf+0x19b>
    release(&cons.lock);
8010054a:	83 ec 0c             	sub    $0xc,%esp
8010054d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100552:	e8 95 4a 00 00       	call   80104fec <release>
80100557:	83 c4 10             	add    $0x10,%esp
}
8010055a:	c9                   	leave  
8010055b:	c3                   	ret    

8010055c <panic>:

void
panic(char *s)
{
8010055c:	55                   	push   %ebp
8010055d:	89 e5                	mov    %esp,%ebp
8010055f:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100562:	e8 a4 fd ff ff       	call   8010030b <cli>
  cons.locking = 0;
80100567:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
8010056e:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100571:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100577:	0f b6 00             	movzbl (%eax),%eax
8010057a:	0f b6 c0             	movzbl %al,%eax
8010057d:	83 ec 08             	sub    $0x8,%esp
80100580:	50                   	push   %eax
80100581:	68 ca 84 10 80       	push   $0x801084ca
80100586:	e8 34 fe ff ff       	call   801003bf <cprintf>
8010058b:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
8010058e:	8b 45 08             	mov    0x8(%ebp),%eax
80100591:	83 ec 0c             	sub    $0xc,%esp
80100594:	50                   	push   %eax
80100595:	e8 25 fe ff ff       	call   801003bf <cprintf>
8010059a:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
8010059d:	83 ec 0c             	sub    $0xc,%esp
801005a0:	68 d9 84 10 80       	push   $0x801084d9
801005a5:	e8 15 fe ff ff       	call   801003bf <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005ad:	83 ec 08             	sub    $0x8,%esp
801005b0:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005b3:	50                   	push   %eax
801005b4:	8d 45 08             	lea    0x8(%ebp),%eax
801005b7:	50                   	push   %eax
801005b8:	e8 80 4a 00 00       	call   8010503d <getcallerpcs>
801005bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005c7:	eb 1c                	jmp    801005e5 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005cc:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005d0:	83 ec 08             	sub    $0x8,%esp
801005d3:	50                   	push   %eax
801005d4:	68 db 84 10 80       	push   $0x801084db
801005d9:	e8 e1 fd ff ff       	call   801003bf <cprintf>
801005de:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005e5:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005e9:	7e de                	jle    801005c9 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005eb:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005f2:	00 00 00 
  for(;;)
    ;
801005f5:	eb fe                	jmp    801005f5 <panic+0x99>

801005f7 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005f7:	55                   	push   %ebp
801005f8:	89 e5                	mov    %esp,%ebp
801005fa:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005fd:	6a 0e                	push   $0xe
801005ff:	68 d4 03 00 00       	push   $0x3d4
80100604:	e8 e4 fc ff ff       	call   801002ed <outb>
80100609:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010060c:	68 d5 03 00 00       	push   $0x3d5
80100611:	e8 ba fc ff ff       	call   801002d0 <inb>
80100616:	83 c4 04             	add    $0x4,%esp
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	c1 e0 08             	shl    $0x8,%eax
8010061f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100622:	6a 0f                	push   $0xf
80100624:	68 d4 03 00 00       	push   $0x3d4
80100629:	e8 bf fc ff ff       	call   801002ed <outb>
8010062e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100631:	68 d5 03 00 00       	push   $0x3d5
80100636:	e8 95 fc ff ff       	call   801002d0 <inb>
8010063b:	83 c4 04             	add    $0x4,%esp
8010063e:	0f b6 c0             	movzbl %al,%eax
80100641:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100644:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100648:	75 30                	jne    8010067a <cgaputc+0x83>
    pos += 80 - pos%80;
8010064a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010064d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100652:	89 c8                	mov    %ecx,%eax
80100654:	f7 ea                	imul   %edx
80100656:	c1 fa 05             	sar    $0x5,%edx
80100659:	89 c8                	mov    %ecx,%eax
8010065b:	c1 f8 1f             	sar    $0x1f,%eax
8010065e:	29 c2                	sub    %eax,%edx
80100660:	89 d0                	mov    %edx,%eax
80100662:	c1 e0 02             	shl    $0x2,%eax
80100665:	01 d0                	add    %edx,%eax
80100667:	c1 e0 04             	shl    $0x4,%eax
8010066a:	29 c1                	sub    %eax,%ecx
8010066c:	89 ca                	mov    %ecx,%edx
8010066e:	b8 50 00 00 00       	mov    $0x50,%eax
80100673:	29 d0                	sub    %edx,%eax
80100675:	01 45 f4             	add    %eax,-0xc(%ebp)
80100678:	eb 34                	jmp    801006ae <cgaputc+0xb7>
  else if(c == BACKSPACE){
8010067a:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100681:	75 0c                	jne    8010068f <cgaputc+0x98>
    if(pos > 0) --pos;
80100683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100687:	7e 25                	jle    801006ae <cgaputc+0xb7>
80100689:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010068d:	eb 1f                	jmp    801006ae <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068f:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100698:	8d 50 01             	lea    0x1(%eax),%edx
8010069b:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069e:	01 c0                	add    %eax,%eax
801006a0:	01 c8                	add    %ecx,%eax
801006a2:	8b 55 08             	mov    0x8(%ebp),%edx
801006a5:	0f b6 d2             	movzbl %dl,%edx
801006a8:	80 ce 07             	or     $0x7,%dh
801006ab:	66 89 10             	mov    %dx,(%eax)
  
  if((pos/80) >= 24){  // Scroll up.
801006ae:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006b5:	7e 4c                	jle    80100703 <cgaputc+0x10c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006b7:	a1 00 90 10 80       	mov    0x80109000,%eax
801006bc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006c2:	a1 00 90 10 80       	mov    0x80109000,%eax
801006c7:	83 ec 04             	sub    $0x4,%esp
801006ca:	68 60 0e 00 00       	push   $0xe60
801006cf:	52                   	push   %edx
801006d0:	50                   	push   %eax
801006d1:	e8 cb 4b 00 00       	call   801052a1 <memmove>
801006d6:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006d9:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006dd:	b8 80 07 00 00       	mov    $0x780,%eax
801006e2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006e5:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006e8:	a1 00 90 10 80       	mov    0x80109000,%eax
801006ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006f0:	01 c9                	add    %ecx,%ecx
801006f2:	01 c8                	add    %ecx,%eax
801006f4:	83 ec 04             	sub    $0x4,%esp
801006f7:	52                   	push   %edx
801006f8:	6a 00                	push   $0x0
801006fa:	50                   	push   %eax
801006fb:	e8 e2 4a 00 00       	call   801051e2 <memset>
80100700:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100703:	83 ec 08             	sub    $0x8,%esp
80100706:	6a 0e                	push   $0xe
80100708:	68 d4 03 00 00       	push   $0x3d4
8010070d:	e8 db fb ff ff       	call   801002ed <outb>
80100712:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
80100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100718:	c1 f8 08             	sar    $0x8,%eax
8010071b:	0f b6 c0             	movzbl %al,%eax
8010071e:	83 ec 08             	sub    $0x8,%esp
80100721:	50                   	push   %eax
80100722:	68 d5 03 00 00       	push   $0x3d5
80100727:	e8 c1 fb ff ff       	call   801002ed <outb>
8010072c:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
8010072f:	83 ec 08             	sub    $0x8,%esp
80100732:	6a 0f                	push   $0xf
80100734:	68 d4 03 00 00       	push   $0x3d4
80100739:	e8 af fb ff ff       	call   801002ed <outb>
8010073e:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100744:	0f b6 c0             	movzbl %al,%eax
80100747:	83 ec 08             	sub    $0x8,%esp
8010074a:	50                   	push   %eax
8010074b:	68 d5 03 00 00       	push   $0x3d5
80100750:	e8 98 fb ff ff       	call   801002ed <outb>
80100755:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
80100758:	a1 00 90 10 80       	mov    0x80109000,%eax
8010075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100760:	01 d2                	add    %edx,%edx
80100762:	01 d0                	add    %edx,%eax
80100764:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100769:	c9                   	leave  
8010076a:	c3                   	ret    

8010076b <consputc>:

void
consputc(int c)
{
8010076b:	55                   	push   %ebp
8010076c:	89 e5                	mov    %esp,%ebp
8010076e:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100771:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100776:	85 c0                	test   %eax,%eax
80100778:	74 07                	je     80100781 <consputc+0x16>
    cli();
8010077a:	e8 8c fb ff ff       	call   8010030b <cli>
    for(;;)
      ;
8010077f:	eb fe                	jmp    8010077f <consputc+0x14>
  }

  if(c == BACKSPACE){
80100781:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100788:	75 29                	jne    801007b3 <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010078a:	83 ec 0c             	sub    $0xc,%esp
8010078d:	6a 08                	push   $0x8
8010078f:	e8 93 63 00 00       	call   80106b27 <uartputc>
80100794:	83 c4 10             	add    $0x10,%esp
80100797:	83 ec 0c             	sub    $0xc,%esp
8010079a:	6a 20                	push   $0x20
8010079c:	e8 86 63 00 00       	call   80106b27 <uartputc>
801007a1:	83 c4 10             	add    $0x10,%esp
801007a4:	83 ec 0c             	sub    $0xc,%esp
801007a7:	6a 08                	push   $0x8
801007a9:	e8 79 63 00 00       	call   80106b27 <uartputc>
801007ae:	83 c4 10             	add    $0x10,%esp
801007b1:	eb 0e                	jmp    801007c1 <consputc+0x56>
  } else
    uartputc(c);
801007b3:	83 ec 0c             	sub    $0xc,%esp
801007b6:	ff 75 08             	pushl  0x8(%ebp)
801007b9:	e8 69 63 00 00       	call   80106b27 <uartputc>
801007be:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007c1:	83 ec 0c             	sub    $0xc,%esp
801007c4:	ff 75 08             	pushl  0x8(%ebp)
801007c7:	e8 2b fe ff ff       	call   801005f7 <cgaputc>
801007cc:	83 c4 10             	add    $0x10,%esp
}
801007cf:	c9                   	leave  
801007d0:	c3                   	ret    

801007d1 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d1:	55                   	push   %ebp
801007d2:	89 e5                	mov    %esp,%ebp
801007d4:	83 ec 18             	sub    $0x18,%esp
  int c;

  acquire(&input.lock);
801007d7:	83 ec 0c             	sub    $0xc,%esp
801007da:	68 c0 07 11 80       	push   $0x801107c0
801007df:	e8 a2 47 00 00       	call   80104f86 <acquire>
801007e4:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
801007e7:	e9 43 01 00 00       	jmp    8010092f <consoleintr+0x15e>
    switch(c){
801007ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007ef:	83 f8 10             	cmp    $0x10,%eax
801007f2:	74 1e                	je     80100812 <consoleintr+0x41>
801007f4:	83 f8 10             	cmp    $0x10,%eax
801007f7:	7f 0a                	jg     80100803 <consoleintr+0x32>
801007f9:	83 f8 08             	cmp    $0x8,%eax
801007fc:	74 67                	je     80100865 <consoleintr+0x94>
801007fe:	e9 93 00 00 00       	jmp    80100896 <consoleintr+0xc5>
80100803:	83 f8 15             	cmp    $0x15,%eax
80100806:	74 31                	je     80100839 <consoleintr+0x68>
80100808:	83 f8 7f             	cmp    $0x7f,%eax
8010080b:	74 58                	je     80100865 <consoleintr+0x94>
8010080d:	e9 84 00 00 00       	jmp    80100896 <consoleintr+0xc5>
    case C('P'):  // Process listing.
      procdump();
80100812:	e8 22 46 00 00       	call   80104e39 <procdump>
      break;
80100817:	e9 13 01 00 00       	jmp    8010092f <consoleintr+0x15e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010081c:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100821:	83 e8 01             	sub    $0x1,%eax
80100824:	a3 7c 08 11 80       	mov    %eax,0x8011087c
        consputc(BACKSPACE);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 00 01 00 00       	push   $0x100
80100831:	e8 35 ff ff ff       	call   8010076b <consputc>
80100836:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100839:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
8010083f:	a1 78 08 11 80       	mov    0x80110878,%eax
80100844:	39 c2                	cmp    %eax,%edx
80100846:	74 18                	je     80100860 <consoleintr+0x8f>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100848:	a1 7c 08 11 80       	mov    0x8011087c,%eax
8010084d:	83 e8 01             	sub    $0x1,%eax
80100850:	83 e0 7f             	and    $0x7f,%eax
80100853:	05 c0 07 11 80       	add    $0x801107c0,%eax
80100858:	0f b6 40 34          	movzbl 0x34(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010085c:	3c 0a                	cmp    $0xa,%al
8010085e:	75 bc                	jne    8010081c <consoleintr+0x4b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100860:	e9 ca 00 00 00       	jmp    8010092f <consoleintr+0x15e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100865:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
8010086b:	a1 78 08 11 80       	mov    0x80110878,%eax
80100870:	39 c2                	cmp    %eax,%edx
80100872:	74 1d                	je     80100891 <consoleintr+0xc0>
        input.e--;
80100874:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100879:	83 e8 01             	sub    $0x1,%eax
8010087c:	a3 7c 08 11 80       	mov    %eax,0x8011087c
        consputc(BACKSPACE);
80100881:	83 ec 0c             	sub    $0xc,%esp
80100884:	68 00 01 00 00       	push   $0x100
80100889:	e8 dd fe ff ff       	call   8010076b <consputc>
8010088e:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100891:	e9 99 00 00 00       	jmp    8010092f <consoleintr+0x15e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100896:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010089a:	0f 84 8e 00 00 00    	je     8010092e <consoleintr+0x15d>
801008a0:	8b 15 7c 08 11 80    	mov    0x8011087c,%edx
801008a6:	a1 74 08 11 80       	mov    0x80110874,%eax
801008ab:	29 c2                	sub    %eax,%edx
801008ad:	89 d0                	mov    %edx,%eax
801008af:	83 f8 7f             	cmp    $0x7f,%eax
801008b2:	77 7a                	ja     8010092e <consoleintr+0x15d>
        c = (c == '\r') ? '\n' : c;
801008b4:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
801008b8:	74 05                	je     801008bf <consoleintr+0xee>
801008ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bd:	eb 05                	jmp    801008c4 <consoleintr+0xf3>
801008bf:	b8 0a 00 00 00       	mov    $0xa,%eax
801008c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008c7:	a1 7c 08 11 80       	mov    0x8011087c,%eax
801008cc:	8d 50 01             	lea    0x1(%eax),%edx
801008cf:	89 15 7c 08 11 80    	mov    %edx,0x8011087c
801008d5:	83 e0 7f             	and    $0x7f,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008dd:	89 c1                	mov    %eax,%ecx
801008df:	8d 82 c0 07 11 80    	lea    -0x7feef840(%edx),%eax
801008e5:	88 48 34             	mov    %cl,0x34(%eax)
        consputc(c);
801008e8:	83 ec 0c             	sub    $0xc,%esp
801008eb:	ff 75 f4             	pushl  -0xc(%ebp)
801008ee:	e8 78 fe ff ff       	call   8010076b <consputc>
801008f3:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008fa:	74 18                	je     80100914 <consoleintr+0x143>
801008fc:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80100900:	74 12                	je     80100914 <consoleintr+0x143>
80100902:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100907:	8b 15 74 08 11 80    	mov    0x80110874,%edx
8010090d:	83 ea 80             	sub    $0xffffff80,%edx
80100910:	39 d0                	cmp    %edx,%eax
80100912:	75 1a                	jne    8010092e <consoleintr+0x15d>
          input.w = input.e;
80100914:	a1 7c 08 11 80       	mov    0x8011087c,%eax
80100919:	a3 78 08 11 80       	mov    %eax,0x80110878
          wakeup(&input.r);
8010091e:	83 ec 0c             	sub    $0xc,%esp
80100921:	68 74 08 11 80       	push   $0x80110874
80100926:	e8 54 44 00 00       	call   80104d7f <wakeup>
8010092b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010092e:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
8010092f:	8b 45 08             	mov    0x8(%ebp),%eax
80100932:	ff d0                	call   *%eax
80100934:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010093b:	0f 89 ab fe ff ff    	jns    801007ec <consoleintr+0x1b>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100941:	83 ec 0c             	sub    $0xc,%esp
80100944:	68 c0 07 11 80       	push   $0x801107c0
80100949:	e8 9e 46 00 00       	call   80104fec <release>
8010094e:	83 c4 10             	add    $0x10,%esp
}
80100951:	c9                   	leave  
80100952:	c3                   	ret    

80100953 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100953:	55                   	push   %ebp
80100954:	89 e5                	mov    %esp,%ebp
80100956:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100959:	83 ec 0c             	sub    $0xc,%esp
8010095c:	ff 75 08             	pushl  0x8(%ebp)
8010095f:	e8 22 11 00 00       	call   80101a86 <iunlock>
80100964:	83 c4 10             	add    $0x10,%esp
  target = n;
80100967:	8b 45 10             	mov    0x10(%ebp),%eax
8010096a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
8010096d:	83 ec 0c             	sub    $0xc,%esp
80100970:	68 c0 07 11 80       	push   $0x801107c0
80100975:	e8 0c 46 00 00       	call   80104f86 <acquire>
8010097a:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
8010097d:	e9 b4 00 00 00       	jmp    80100a36 <consoleread+0xe3>
    while(input.r == input.w){
80100982:	eb 4a                	jmp    801009ce <consoleread+0x7b>
      if(proc->killed){
80100984:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010098a:	8b 40 24             	mov    0x24(%eax),%eax
8010098d:	85 c0                	test   %eax,%eax
8010098f:	74 28                	je     801009b9 <consoleread+0x66>
        release(&input.lock);
80100991:	83 ec 0c             	sub    $0xc,%esp
80100994:	68 c0 07 11 80       	push   $0x801107c0
80100999:	e8 4e 46 00 00       	call   80104fec <release>
8010099e:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009a1:	83 ec 0c             	sub    $0xc,%esp
801009a4:	ff 75 08             	pushl  0x8(%ebp)
801009a7:	e8 7d 0f 00 00       	call   80101929 <ilock>
801009ac:	83 c4 10             	add    $0x10,%esp
        return -1;
801009af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009b4:	e9 af 00 00 00       	jmp    80100a68 <consoleread+0x115>
      }
      sleep(&input.r, &input.lock);
801009b9:	83 ec 08             	sub    $0x8,%esp
801009bc:	68 c0 07 11 80       	push   $0x801107c0
801009c1:	68 74 08 11 80       	push   $0x80110874
801009c6:	e8 cb 42 00 00       	call   80104c96 <sleep>
801009cb:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
801009ce:	8b 15 74 08 11 80    	mov    0x80110874,%edx
801009d4:	a1 78 08 11 80       	mov    0x80110878,%eax
801009d9:	39 c2                	cmp    %eax,%edx
801009db:	74 a7                	je     80100984 <consoleread+0x31>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009dd:	a1 74 08 11 80       	mov    0x80110874,%eax
801009e2:	8d 50 01             	lea    0x1(%eax),%edx
801009e5:	89 15 74 08 11 80    	mov    %edx,0x80110874
801009eb:	83 e0 7f             	and    $0x7f,%eax
801009ee:	05 c0 07 11 80       	add    $0x801107c0,%eax
801009f3:	0f b6 40 34          	movzbl 0x34(%eax),%eax
801009f7:	0f be c0             	movsbl %al,%eax
801009fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009fd:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a01:	75 19                	jne    80100a1c <consoleread+0xc9>
      if(n < target){
80100a03:	8b 45 10             	mov    0x10(%ebp),%eax
80100a06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a09:	73 0f                	jae    80100a1a <consoleread+0xc7>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a0b:	a1 74 08 11 80       	mov    0x80110874,%eax
80100a10:	83 e8 01             	sub    $0x1,%eax
80100a13:	a3 74 08 11 80       	mov    %eax,0x80110874
      }
      break;
80100a18:	eb 26                	jmp    80100a40 <consoleread+0xed>
80100a1a:	eb 24                	jmp    80100a40 <consoleread+0xed>
    }
    *dst++ = c;
80100a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a1f:	8d 50 01             	lea    0x1(%eax),%edx
80100a22:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a25:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a28:	88 10                	mov    %dl,(%eax)
    --n;
80100a2a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a2e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a32:	75 02                	jne    80100a36 <consoleread+0xe3>
      break;
80100a34:	eb 0a                	jmp    80100a40 <consoleread+0xed>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
80100a36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a3a:	0f 8f 42 ff ff ff    	jg     80100982 <consoleread+0x2f>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
80100a40:	83 ec 0c             	sub    $0xc,%esp
80100a43:	68 c0 07 11 80       	push   $0x801107c0
80100a48:	e8 9f 45 00 00       	call   80104fec <release>
80100a4d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a50:	83 ec 0c             	sub    $0xc,%esp
80100a53:	ff 75 08             	pushl  0x8(%ebp)
80100a56:	e8 ce 0e 00 00       	call   80101929 <ilock>
80100a5b:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a5e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a64:	29 c2                	sub    %eax,%edx
80100a66:	89 d0                	mov    %edx,%eax
}
80100a68:	c9                   	leave  
80100a69:	c3                   	ret    

80100a6a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a6a:	55                   	push   %ebp
80100a6b:	89 e5                	mov    %esp,%ebp
80100a6d:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100a70:	83 ec 0c             	sub    $0xc,%esp
80100a73:	ff 75 08             	pushl  0x8(%ebp)
80100a76:	e8 0b 10 00 00       	call   80101a86 <iunlock>
80100a7b:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100a7e:	83 ec 0c             	sub    $0xc,%esp
80100a81:	68 e0 b5 10 80       	push   $0x8010b5e0
80100a86:	e8 fb 44 00 00       	call   80104f86 <acquire>
80100a8b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a95:	eb 21                	jmp    80100ab8 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a9d:	01 d0                	add    %edx,%eax
80100a9f:	0f b6 00             	movzbl (%eax),%eax
80100aa2:	0f be c0             	movsbl %al,%eax
80100aa5:	0f b6 c0             	movzbl %al,%eax
80100aa8:	83 ec 0c             	sub    $0xc,%esp
80100aab:	50                   	push   %eax
80100aac:	e8 ba fc ff ff       	call   8010076b <consputc>
80100ab1:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100ab4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100abb:	3b 45 10             	cmp    0x10(%ebp),%eax
80100abe:	7c d7                	jl     80100a97 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ac0:	83 ec 0c             	sub    $0xc,%esp
80100ac3:	68 e0 b5 10 80       	push   $0x8010b5e0
80100ac8:	e8 1f 45 00 00       	call   80104fec <release>
80100acd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	ff 75 08             	pushl  0x8(%ebp)
80100ad6:	e8 4e 0e 00 00       	call   80101929 <ilock>
80100adb:	83 c4 10             	add    $0x10,%esp

  return n;
80100ade:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ae1:	c9                   	leave  
80100ae2:	c3                   	ret    

80100ae3 <consoleinit>:

void
consoleinit(void)
{
80100ae3:	55                   	push   %ebp
80100ae4:	89 e5                	mov    %esp,%ebp
80100ae6:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100ae9:	83 ec 08             	sub    $0x8,%esp
80100aec:	68 df 84 10 80       	push   $0x801084df
80100af1:	68 e0 b5 10 80       	push   $0x8010b5e0
80100af6:	e8 6a 44 00 00       	call   80104f65 <initlock>
80100afb:	83 c4 10             	add    $0x10,%esp
  initlock(&input.lock, "input");
80100afe:	83 ec 08             	sub    $0x8,%esp
80100b01:	68 e7 84 10 80       	push   $0x801084e7
80100b06:	68 c0 07 11 80       	push   $0x801107c0
80100b0b:	e8 55 44 00 00       	call   80104f65 <initlock>
80100b10:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b13:	c7 05 4c 12 11 80 6a 	movl   $0x80100a6a,0x8011124c
80100b1a:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b1d:	c7 05 48 12 11 80 53 	movl   $0x80100953,0x80111248
80100b24:	09 10 80 
  cons.locking = 1;
80100b27:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100b2e:	00 00 00 

  picenable(IRQ_KBD);
80100b31:	83 ec 0c             	sub    $0xc,%esp
80100b34:	6a 01                	push   $0x1
80100b36:	e8 86 33 00 00       	call   80103ec1 <picenable>
80100b3b:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b3e:	83 ec 08             	sub    $0x8,%esp
80100b41:	6a 00                	push   $0x0
80100b43:	6a 01                	push   $0x1
80100b45:	e8 43 1f 00 00       	call   80102a8d <ioapicenable>
80100b4a:	83 c4 10             	add    $0x10,%esp
}
80100b4d:	c9                   	leave  
80100b4e:	c3                   	ret    

80100b4f <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b4f:	55                   	push   %ebp
80100b50:	89 e5                	mov    %esp,%ebp
80100b52:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b58:	e8 90 29 00 00       	call   801034ed <begin_op>
  if((ip = namei(path)) == 0){
80100b5d:	83 ec 0c             	sub    $0xc,%esp
80100b60:	ff 75 08             	pushl  0x8(%ebp)
80100b63:	e8 7c 19 00 00       	call   801024e4 <namei>
80100b68:	83 c4 10             	add    $0x10,%esp
80100b6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b6e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b72:	75 0f                	jne    80100b83 <exec+0x34>
    end_op();
80100b74:	e8 02 2a 00 00       	call   8010357b <end_op>
    return -1;
80100b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b7e:	e9 b9 03 00 00       	jmp    80100f3c <exec+0x3ed>
  }
  ilock(ip);
80100b83:	83 ec 0c             	sub    $0xc,%esp
80100b86:	ff 75 d8             	pushl  -0x28(%ebp)
80100b89:	e8 9b 0d 00 00       	call   80101929 <ilock>
80100b8e:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100b91:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b98:	6a 34                	push   $0x34
80100b9a:	6a 00                	push   $0x0
80100b9c:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ba2:	50                   	push   %eax
80100ba3:	ff 75 d8             	pushl  -0x28(%ebp)
80100ba6:	e8 e6 12 00 00       	call   80101e91 <readi>
80100bab:	83 c4 10             	add    $0x10,%esp
80100bae:	83 f8 33             	cmp    $0x33,%eax
80100bb1:	77 05                	ja     80100bb8 <exec+0x69>
    goto bad;
80100bb3:	e9 52 03 00 00       	jmp    80100f0a <exec+0x3bb>
  if(elf.magic != ELF_MAGIC)
80100bb8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbe:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100bc3:	74 05                	je     80100bca <exec+0x7b>
    goto bad;
80100bc5:	e9 40 03 00 00       	jmp    80100f0a <exec+0x3bb>

  if((pgdir = setupkvm()) == 0)
80100bca:	e8 a8 70 00 00       	call   80107c77 <setupkvm>
80100bcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bd2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bd6:	75 05                	jne    80100bdd <exec+0x8e>
    goto bad;
80100bd8:	e9 2d 03 00 00       	jmp    80100f0a <exec+0x3bb>

  // Load program into memory.
  sz = 0;
80100bdd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100beb:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100bf1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100bf4:	e9 ae 00 00 00       	jmp    80100ca7 <exec+0x158>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	50                   	push   %eax
80100bff:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c05:	50                   	push   %eax
80100c06:	ff 75 d8             	pushl  -0x28(%ebp)
80100c09:	e8 83 12 00 00       	call   80101e91 <readi>
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 20             	cmp    $0x20,%eax
80100c14:	74 05                	je     80100c1b <exec+0xcc>
      goto bad;
80100c16:	e9 ef 02 00 00       	jmp    80100f0a <exec+0x3bb>
    if(ph.type != ELF_PROG_LOAD)
80100c1b:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c21:	83 f8 01             	cmp    $0x1,%eax
80100c24:	74 02                	je     80100c28 <exec+0xd9>
      continue;
80100c26:	eb 72                	jmp    80100c9a <exec+0x14b>
    if(ph.memsz < ph.filesz)
80100c28:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c2e:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c34:	39 c2                	cmp    %eax,%edx
80100c36:	73 05                	jae    80100c3d <exec+0xee>
      goto bad;
80100c38:	e9 cd 02 00 00       	jmp    80100f0a <exec+0x3bb>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c3d:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c43:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c49:	01 d0                	add    %edx,%eax
80100c4b:	83 ec 04             	sub    $0x4,%esp
80100c4e:	50                   	push   %eax
80100c4f:	ff 75 e0             	pushl  -0x20(%ebp)
80100c52:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c55:	e8 c0 73 00 00       	call   8010801a <allocuvm>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c60:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c64:	75 05                	jne    80100c6b <exec+0x11c>
      goto bad;
80100c66:	e9 9f 02 00 00       	jmp    80100f0a <exec+0x3bb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c6b:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c71:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c77:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c7d:	83 ec 0c             	sub    $0xc,%esp
80100c80:	52                   	push   %edx
80100c81:	50                   	push   %eax
80100c82:	ff 75 d8             	pushl  -0x28(%ebp)
80100c85:	51                   	push   %ecx
80100c86:	ff 75 d4             	pushl  -0x2c(%ebp)
80100c89:	e8 b5 72 00 00       	call   80107f43 <loaduvm>
80100c8e:	83 c4 20             	add    $0x20,%esp
80100c91:	85 c0                	test   %eax,%eax
80100c93:	79 05                	jns    80100c9a <exec+0x14b>
      goto bad;
80100c95:	e9 70 02 00 00       	jmp    80100f0a <exec+0x3bb>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c9a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca1:	83 c0 20             	add    $0x20,%eax
80100ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ca7:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cae:	0f b7 c0             	movzwl %ax,%eax
80100cb1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cb4:	0f 8f 3f ff ff ff    	jg     80100bf9 <exec+0xaa>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100cba:	83 ec 0c             	sub    $0xc,%esp
80100cbd:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc0:	e8 21 0f 00 00       	call   80101be6 <iunlockput>
80100cc5:	83 c4 10             	add    $0x10,%esp
  end_op();
80100cc8:	e8 ae 28 00 00       	call   8010357b <end_op>
  ip = 0;
80100ccd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd7:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ce1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce7:	05 00 20 00 00       	add    $0x2000,%eax
80100cec:	83 ec 04             	sub    $0x4,%esp
80100cef:	50                   	push   %eax
80100cf0:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf3:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf6:	e8 1f 73 00 00       	call   8010801a <allocuvm>
80100cfb:	83 c4 10             	add    $0x10,%esp
80100cfe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d01:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d05:	75 05                	jne    80100d0c <exec+0x1bd>
    goto bad;
80100d07:	e9 fe 01 00 00       	jmp    80100f0a <exec+0x3bb>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0f:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d14:	83 ec 08             	sub    $0x8,%esp
80100d17:	50                   	push   %eax
80100d18:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d1b:	e8 1f 75 00 00       	call   8010823f <clearpteu>
80100d20:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d26:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d30:	e9 98 00 00 00       	jmp    80100dcd <exec+0x27e>
    if(argc >= MAXARG)
80100d35:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d39:	76 05                	jbe    80100d40 <exec+0x1f1>
      goto bad;
80100d3b:	e9 ca 01 00 00       	jmp    80100f0a <exec+0x3bb>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4d:	01 d0                	add    %edx,%eax
80100d4f:	8b 00                	mov    (%eax),%eax
80100d51:	83 ec 0c             	sub    $0xc,%esp
80100d54:	50                   	push   %eax
80100d55:	e8 d7 46 00 00       	call   80105431 <strlen>
80100d5a:	83 c4 10             	add    $0x10,%esp
80100d5d:	89 c2                	mov    %eax,%edx
80100d5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d62:	29 d0                	sub    %edx,%eax
80100d64:	83 e8 01             	sub    $0x1,%eax
80100d67:	83 e0 fc             	and    $0xfffffffc,%eax
80100d6a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d77:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d7a:	01 d0                	add    %edx,%eax
80100d7c:	8b 00                	mov    (%eax),%eax
80100d7e:	83 ec 0c             	sub    $0xc,%esp
80100d81:	50                   	push   %eax
80100d82:	e8 aa 46 00 00       	call   80105431 <strlen>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	83 c0 01             	add    $0x1,%eax
80100d8d:	89 c1                	mov    %eax,%ecx
80100d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d99:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d9c:	01 d0                	add    %edx,%eax
80100d9e:	8b 00                	mov    (%eax),%eax
80100da0:	51                   	push   %ecx
80100da1:	50                   	push   %eax
80100da2:	ff 75 dc             	pushl  -0x24(%ebp)
80100da5:	ff 75 d4             	pushl  -0x2c(%ebp)
80100da8:	e8 48 76 00 00       	call   801083f5 <copyout>
80100dad:	83 c4 10             	add    $0x10,%esp
80100db0:	85 c0                	test   %eax,%eax
80100db2:	79 05                	jns    80100db9 <exec+0x26a>
      goto bad;
80100db4:	e9 51 01 00 00       	jmp    80100f0a <exec+0x3bb>
    ustack[3+argc] = sp;
80100db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dbc:	8d 50 03             	lea    0x3(%eax),%edx
80100dbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dc2:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dda:	01 d0                	add    %edx,%eax
80100ddc:	8b 00                	mov    (%eax),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	0f 85 4f ff ff ff    	jne    80100d35 <exec+0x1e6>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de9:	83 c0 03             	add    $0x3,%eax
80100dec:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100df3:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100df7:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100dfe:	ff ff ff 
  ustack[1] = argc;
80100e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e04:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	83 c0 01             	add    $0x1,%eax
80100e10:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1a:	29 d0                	sub    %edx,%eax
80100e1c:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e25:	83 c0 04             	add    $0x4,%eax
80100e28:	c1 e0 02             	shl    $0x2,%eax
80100e2b:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e31:	83 c0 04             	add    $0x4,%eax
80100e34:	c1 e0 02             	shl    $0x2,%eax
80100e37:	50                   	push   %eax
80100e38:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e3e:	50                   	push   %eax
80100e3f:	ff 75 dc             	pushl  -0x24(%ebp)
80100e42:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e45:	e8 ab 75 00 00       	call   801083f5 <copyout>
80100e4a:	83 c4 10             	add    $0x10,%esp
80100e4d:	85 c0                	test   %eax,%eax
80100e4f:	79 05                	jns    80100e56 <exec+0x307>
    goto bad;
80100e51:	e9 b4 00 00 00       	jmp    80100f0a <exec+0x3bb>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e56:	8b 45 08             	mov    0x8(%ebp),%eax
80100e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e62:	eb 17                	jmp    80100e7b <exec+0x32c>
    if(*s == '/')
80100e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e67:	0f b6 00             	movzbl (%eax),%eax
80100e6a:	3c 2f                	cmp    $0x2f,%al
80100e6c:	75 09                	jne    80100e77 <exec+0x328>
      last = s+1;
80100e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e71:	83 c0 01             	add    $0x1,%eax
80100e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7e:	0f b6 00             	movzbl (%eax),%eax
80100e81:	84 c0                	test   %al,%al
80100e83:	75 df                	jne    80100e64 <exec+0x315>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8b:	83 c0 6c             	add    $0x6c,%eax
80100e8e:	83 ec 04             	sub    $0x4,%esp
80100e91:	6a 10                	push   $0x10
80100e93:	ff 75 f0             	pushl  -0x10(%ebp)
80100e96:	50                   	push   %eax
80100e97:	e8 4b 45 00 00       	call   801053e7 <safestrcpy>
80100e9c:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ea5:	8b 40 04             	mov    0x4(%eax),%eax
80100ea8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100eab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100eb4:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ebd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ec0:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ec2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec8:	8b 40 18             	mov    0x18(%eax),%eax
80100ecb:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100ed1:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ed4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eda:	8b 40 18             	mov    0x18(%eax),%eax
80100edd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ee0:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ee3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ee9:	83 ec 0c             	sub    $0xc,%esp
80100eec:	50                   	push   %eax
80100eed:	e8 6a 6e 00 00       	call   80107d5c <switchuvm>
80100ef2:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
80100ef8:	ff 75 d0             	pushl  -0x30(%ebp)
80100efb:	e8 a0 72 00 00       	call   801081a0 <freevm>
80100f00:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f03:	b8 00 00 00 00       	mov    $0x0,%eax
80100f08:	eb 32                	jmp    80100f3c <exec+0x3ed>

 bad:
  if(pgdir)
80100f0a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f0e:	74 0e                	je     80100f1e <exec+0x3cf>
    freevm(pgdir);
80100f10:	83 ec 0c             	sub    $0xc,%esp
80100f13:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f16:	e8 85 72 00 00       	call   801081a0 <freevm>
80100f1b:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f1e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f22:	74 13                	je     80100f37 <exec+0x3e8>
    iunlockput(ip);
80100f24:	83 ec 0c             	sub    $0xc,%esp
80100f27:	ff 75 d8             	pushl  -0x28(%ebp)
80100f2a:	e8 b7 0c 00 00       	call   80101be6 <iunlockput>
80100f2f:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f32:	e8 44 26 00 00       	call   8010357b <end_op>
  }
  return -1;
80100f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f3c:	c9                   	leave  
80100f3d:	c3                   	ret    

80100f3e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f3e:	55                   	push   %ebp
80100f3f:	89 e5                	mov    %esp,%ebp
80100f41:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100f44:	83 ec 08             	sub    $0x8,%esp
80100f47:	68 ed 84 10 80       	push   $0x801084ed
80100f4c:	68 80 08 11 80       	push   $0x80110880
80100f51:	e8 0f 40 00 00       	call   80104f65 <initlock>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	c9                   	leave  
80100f5a:	c3                   	ret    

80100f5b <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f5b:	55                   	push   %ebp
80100f5c:	89 e5                	mov    %esp,%ebp
80100f5e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f61:	83 ec 0c             	sub    $0xc,%esp
80100f64:	68 80 08 11 80       	push   $0x80110880
80100f69:	e8 18 40 00 00       	call   80104f86 <acquire>
80100f6e:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f71:	c7 45 f4 b4 08 11 80 	movl   $0x801108b4,-0xc(%ebp)
80100f78:	eb 2d                	jmp    80100fa7 <filealloc+0x4c>
    if(f->ref == 0){
80100f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7d:	8b 40 04             	mov    0x4(%eax),%eax
80100f80:	85 c0                	test   %eax,%eax
80100f82:	75 1f                	jne    80100fa3 <filealloc+0x48>
      f->ref = 1;
80100f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f87:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f8e:	83 ec 0c             	sub    $0xc,%esp
80100f91:	68 80 08 11 80       	push   $0x80110880
80100f96:	e8 51 40 00 00       	call   80104fec <release>
80100f9b:	83 c4 10             	add    $0x10,%esp
      return f;
80100f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa1:	eb 22                	jmp    80100fc5 <filealloc+0x6a>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa3:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fa7:	81 7d f4 14 12 11 80 	cmpl   $0x80111214,-0xc(%ebp)
80100fae:	72 ca                	jb     80100f7a <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
80100fb3:	68 80 08 11 80       	push   $0x80110880
80100fb8:	e8 2f 40 00 00       	call   80104fec <release>
80100fbd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fc5:	c9                   	leave  
80100fc6:	c3                   	ret    

80100fc7 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc7:	55                   	push   %ebp
80100fc8:	89 e5                	mov    %esp,%ebp
80100fca:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80100fcd:	83 ec 0c             	sub    $0xc,%esp
80100fd0:	68 80 08 11 80       	push   $0x80110880
80100fd5:	e8 ac 3f 00 00       	call   80104f86 <acquire>
80100fda:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80100fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe0:	8b 40 04             	mov    0x4(%eax),%eax
80100fe3:	85 c0                	test   %eax,%eax
80100fe5:	7f 0d                	jg     80100ff4 <filedup+0x2d>
    panic("filedup");
80100fe7:	83 ec 0c             	sub    $0xc,%esp
80100fea:	68 f4 84 10 80       	push   $0x801084f4
80100fef:	e8 68 f5 ff ff       	call   8010055c <panic>
  f->ref++;
80100ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff7:	8b 40 04             	mov    0x4(%eax),%eax
80100ffa:	8d 50 01             	lea    0x1(%eax),%edx
80100ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80101000:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101003:	83 ec 0c             	sub    $0xc,%esp
80101006:	68 80 08 11 80       	push   $0x80110880
8010100b:	e8 dc 3f 00 00       	call   80104fec <release>
80101010:	83 c4 10             	add    $0x10,%esp
  return f;
80101013:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101016:	c9                   	leave  
80101017:	c3                   	ret    

80101018 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101018:	55                   	push   %ebp
80101019:	89 e5                	mov    %esp,%ebp
8010101b:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
8010101e:	83 ec 0c             	sub    $0xc,%esp
80101021:	68 80 08 11 80       	push   $0x80110880
80101026:	e8 5b 3f 00 00       	call   80104f86 <acquire>
8010102b:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010102e:	8b 45 08             	mov    0x8(%ebp),%eax
80101031:	8b 40 04             	mov    0x4(%eax),%eax
80101034:	85 c0                	test   %eax,%eax
80101036:	7f 0d                	jg     80101045 <fileclose+0x2d>
    panic("fileclose");
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	68 fc 84 10 80       	push   $0x801084fc
80101040:	e8 17 f5 ff ff       	call   8010055c <panic>
  if(--f->ref > 0){
80101045:	8b 45 08             	mov    0x8(%ebp),%eax
80101048:	8b 40 04             	mov    0x4(%eax),%eax
8010104b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010104e:	8b 45 08             	mov    0x8(%ebp),%eax
80101051:	89 50 04             	mov    %edx,0x4(%eax)
80101054:	8b 45 08             	mov    0x8(%ebp),%eax
80101057:	8b 40 04             	mov    0x4(%eax),%eax
8010105a:	85 c0                	test   %eax,%eax
8010105c:	7e 15                	jle    80101073 <fileclose+0x5b>
    release(&ftable.lock);
8010105e:	83 ec 0c             	sub    $0xc,%esp
80101061:	68 80 08 11 80       	push   $0x80110880
80101066:	e8 81 3f 00 00       	call   80104fec <release>
8010106b:	83 c4 10             	add    $0x10,%esp
8010106e:	e9 8b 00 00 00       	jmp    801010fe <fileclose+0xe6>
    return;
  }
  ff = *f;
80101073:	8b 45 08             	mov    0x8(%ebp),%eax
80101076:	8b 10                	mov    (%eax),%edx
80101078:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010107b:	8b 50 04             	mov    0x4(%eax),%edx
8010107e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101081:	8b 50 08             	mov    0x8(%eax),%edx
80101084:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101087:	8b 50 0c             	mov    0xc(%eax),%edx
8010108a:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010108d:	8b 50 10             	mov    0x10(%eax),%edx
80101090:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101093:	8b 40 14             	mov    0x14(%eax),%eax
80101096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101099:	8b 45 08             	mov    0x8(%ebp),%eax
8010109c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010a3:	8b 45 08             	mov    0x8(%ebp),%eax
801010a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010ac:	83 ec 0c             	sub    $0xc,%esp
801010af:	68 80 08 11 80       	push   $0x80110880
801010b4:	e8 33 3f 00 00       	call   80104fec <release>
801010b9:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801010bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bf:	83 f8 01             	cmp    $0x1,%eax
801010c2:	75 19                	jne    801010dd <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801010c4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010c8:	0f be d0             	movsbl %al,%edx
801010cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010ce:	83 ec 08             	sub    $0x8,%esp
801010d1:	52                   	push   %edx
801010d2:	50                   	push   %eax
801010d3:	e8 50 30 00 00       	call   80104128 <pipeclose>
801010d8:	83 c4 10             	add    $0x10,%esp
801010db:	eb 21                	jmp    801010fe <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801010dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e0:	83 f8 02             	cmp    $0x2,%eax
801010e3:	75 19                	jne    801010fe <fileclose+0xe6>
    begin_op();
801010e5:	e8 03 24 00 00       	call   801034ed <begin_op>
    iput(ff.ip);
801010ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010ed:	83 ec 0c             	sub    $0xc,%esp
801010f0:	50                   	push   %eax
801010f1:	e8 01 0a 00 00       	call   80101af7 <iput>
801010f6:	83 c4 10             	add    $0x10,%esp
    end_op();
801010f9:	e8 7d 24 00 00       	call   8010357b <end_op>
  }
}
801010fe:	c9                   	leave  
801010ff:	c3                   	ret    

80101100 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
80101106:	8b 45 08             	mov    0x8(%ebp),%eax
80101109:	8b 00                	mov    (%eax),%eax
8010110b:	83 f8 02             	cmp    $0x2,%eax
8010110e:	75 40                	jne    80101150 <filestat+0x50>
    ilock(f->ip);
80101110:	8b 45 08             	mov    0x8(%ebp),%eax
80101113:	8b 40 10             	mov    0x10(%eax),%eax
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	50                   	push   %eax
8010111a:	e8 0a 08 00 00       	call   80101929 <ilock>
8010111f:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101122:	8b 45 08             	mov    0x8(%ebp),%eax
80101125:	8b 40 10             	mov    0x10(%eax),%eax
80101128:	83 ec 08             	sub    $0x8,%esp
8010112b:	ff 75 0c             	pushl  0xc(%ebp)
8010112e:	50                   	push   %eax
8010112f:	e8 18 0d 00 00       	call   80101e4c <stati>
80101134:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101137:	8b 45 08             	mov    0x8(%ebp),%eax
8010113a:	8b 40 10             	mov    0x10(%eax),%eax
8010113d:	83 ec 0c             	sub    $0xc,%esp
80101140:	50                   	push   %eax
80101141:	e8 40 09 00 00       	call   80101a86 <iunlock>
80101146:	83 c4 10             	add    $0x10,%esp
    return 0;
80101149:	b8 00 00 00 00       	mov    $0x0,%eax
8010114e:	eb 05                	jmp    80101155 <filestat+0x55>
  }
  return -1;
80101150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101155:	c9                   	leave  
80101156:	c3                   	ret    

80101157 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101157:	55                   	push   %ebp
80101158:	89 e5                	mov    %esp,%ebp
8010115a:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010115d:	8b 45 08             	mov    0x8(%ebp),%eax
80101160:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101164:	84 c0                	test   %al,%al
80101166:	75 0a                	jne    80101172 <fileread+0x1b>
    return -1;
80101168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010116d:	e9 9b 00 00 00       	jmp    8010120d <fileread+0xb6>
  if(f->type == FD_PIPE)
80101172:	8b 45 08             	mov    0x8(%ebp),%eax
80101175:	8b 00                	mov    (%eax),%eax
80101177:	83 f8 01             	cmp    $0x1,%eax
8010117a:	75 1a                	jne    80101196 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010117c:	8b 45 08             	mov    0x8(%ebp),%eax
8010117f:	8b 40 0c             	mov    0xc(%eax),%eax
80101182:	83 ec 04             	sub    $0x4,%esp
80101185:	ff 75 10             	pushl  0x10(%ebp)
80101188:	ff 75 0c             	pushl  0xc(%ebp)
8010118b:	50                   	push   %eax
8010118c:	e8 44 31 00 00       	call   801042d5 <piperead>
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	eb 77                	jmp    8010120d <fileread+0xb6>
  if(f->type == FD_INODE){
80101196:	8b 45 08             	mov    0x8(%ebp),%eax
80101199:	8b 00                	mov    (%eax),%eax
8010119b:	83 f8 02             	cmp    $0x2,%eax
8010119e:	75 60                	jne    80101200 <fileread+0xa9>
    ilock(f->ip);
801011a0:	8b 45 08             	mov    0x8(%ebp),%eax
801011a3:	8b 40 10             	mov    0x10(%eax),%eax
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	50                   	push   %eax
801011aa:	e8 7a 07 00 00       	call   80101929 <ilock>
801011af:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 50 14             	mov    0x14(%eax),%edx
801011bb:	8b 45 08             	mov    0x8(%ebp),%eax
801011be:	8b 40 10             	mov    0x10(%eax),%eax
801011c1:	51                   	push   %ecx
801011c2:	52                   	push   %edx
801011c3:	ff 75 0c             	pushl  0xc(%ebp)
801011c6:	50                   	push   %eax
801011c7:	e8 c5 0c 00 00       	call   80101e91 <readi>
801011cc:	83 c4 10             	add    $0x10,%esp
801011cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011d6:	7e 11                	jle    801011e9 <fileread+0x92>
      f->off += r;
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	8b 50 14             	mov    0x14(%eax),%edx
801011de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011e1:	01 c2                	add    %eax,%edx
801011e3:	8b 45 08             	mov    0x8(%ebp),%eax
801011e6:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011e9:	8b 45 08             	mov    0x8(%ebp),%eax
801011ec:	8b 40 10             	mov    0x10(%eax),%eax
801011ef:	83 ec 0c             	sub    $0xc,%esp
801011f2:	50                   	push   %eax
801011f3:	e8 8e 08 00 00       	call   80101a86 <iunlock>
801011f8:	83 c4 10             	add    $0x10,%esp
    return r;
801011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fe:	eb 0d                	jmp    8010120d <fileread+0xb6>
  }
  panic("fileread");
80101200:	83 ec 0c             	sub    $0xc,%esp
80101203:	68 06 85 10 80       	push   $0x80108506
80101208:	e8 4f f3 ff ff       	call   8010055c <panic>
}
8010120d:	c9                   	leave  
8010120e:	c3                   	ret    

8010120f <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010120f:	55                   	push   %ebp
80101210:	89 e5                	mov    %esp,%ebp
80101212:	53                   	push   %ebx
80101213:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101216:	8b 45 08             	mov    0x8(%ebp),%eax
80101219:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010121d:	84 c0                	test   %al,%al
8010121f:	75 0a                	jne    8010122b <filewrite+0x1c>
    return -1;
80101221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101226:	e9 1a 01 00 00       	jmp    80101345 <filewrite+0x136>
  if(f->type == FD_PIPE)
8010122b:	8b 45 08             	mov    0x8(%ebp),%eax
8010122e:	8b 00                	mov    (%eax),%eax
80101230:	83 f8 01             	cmp    $0x1,%eax
80101233:	75 1d                	jne    80101252 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101235:	8b 45 08             	mov    0x8(%ebp),%eax
80101238:	8b 40 0c             	mov    0xc(%eax),%eax
8010123b:	83 ec 04             	sub    $0x4,%esp
8010123e:	ff 75 10             	pushl  0x10(%ebp)
80101241:	ff 75 0c             	pushl  0xc(%ebp)
80101244:	50                   	push   %eax
80101245:	e8 87 2f 00 00       	call   801041d1 <pipewrite>
8010124a:	83 c4 10             	add    $0x10,%esp
8010124d:	e9 f3 00 00 00       	jmp    80101345 <filewrite+0x136>
  if(f->type == FD_INODE){
80101252:	8b 45 08             	mov    0x8(%ebp),%eax
80101255:	8b 00                	mov    (%eax),%eax
80101257:	83 f8 02             	cmp    $0x2,%eax
8010125a:	0f 85 d8 00 00 00    	jne    80101338 <filewrite+0x129>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101260:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010126e:	e9 a5 00 00 00       	jmp    80101318 <filewrite+0x109>
      int n1 = n - i;
80101273:	8b 45 10             	mov    0x10(%ebp),%eax
80101276:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101279:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010127c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010127f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101282:	7e 06                	jle    8010128a <filewrite+0x7b>
        n1 = max;
80101284:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101287:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010128a:	e8 5e 22 00 00       	call   801034ed <begin_op>
      ilock(f->ip);
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 40 10             	mov    0x10(%eax),%eax
80101295:	83 ec 0c             	sub    $0xc,%esp
80101298:	50                   	push   %eax
80101299:	e8 8b 06 00 00       	call   80101929 <ilock>
8010129e:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012a4:	8b 45 08             	mov    0x8(%ebp),%eax
801012a7:	8b 50 14             	mov    0x14(%eax),%edx
801012aa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801012b0:	01 c3                	add    %eax,%ebx
801012b2:	8b 45 08             	mov    0x8(%ebp),%eax
801012b5:	8b 40 10             	mov    0x10(%eax),%eax
801012b8:	51                   	push   %ecx
801012b9:	52                   	push   %edx
801012ba:	53                   	push   %ebx
801012bb:	50                   	push   %eax
801012bc:	e8 2a 0d 00 00       	call   80101feb <writei>
801012c1:	83 c4 10             	add    $0x10,%esp
801012c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012cb:	7e 11                	jle    801012de <filewrite+0xcf>
        f->off += r;
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	8b 50 14             	mov    0x14(%eax),%edx
801012d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012d6:	01 c2                	add    %eax,%edx
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012de:	8b 45 08             	mov    0x8(%ebp),%eax
801012e1:	8b 40 10             	mov    0x10(%eax),%eax
801012e4:	83 ec 0c             	sub    $0xc,%esp
801012e7:	50                   	push   %eax
801012e8:	e8 99 07 00 00       	call   80101a86 <iunlock>
801012ed:	83 c4 10             	add    $0x10,%esp
      end_op();
801012f0:	e8 86 22 00 00       	call   8010357b <end_op>

      if(r < 0)
801012f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012f9:	79 02                	jns    801012fd <filewrite+0xee>
        break;
801012fb:	eb 27                	jmp    80101324 <filewrite+0x115>
      if(r != n1)
801012fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101303:	74 0d                	je     80101312 <filewrite+0x103>
        panic("short filewrite");
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	68 0f 85 10 80       	push   $0x8010850f
8010130d:	e8 4a f2 ff ff       	call   8010055c <panic>
      i += r;
80101312:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101315:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010131b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010131e:	0f 8c 4f ff ff ff    	jl     80101273 <filewrite+0x64>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101324:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101327:	3b 45 10             	cmp    0x10(%ebp),%eax
8010132a:	75 05                	jne    80101331 <filewrite+0x122>
8010132c:	8b 45 10             	mov    0x10(%ebp),%eax
8010132f:	eb 14                	jmp    80101345 <filewrite+0x136>
80101331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101336:	eb 0d                	jmp    80101345 <filewrite+0x136>
  }
  panic("filewrite");
80101338:	83 ec 0c             	sub    $0xc,%esp
8010133b:	68 1f 85 10 80       	push   $0x8010851f
80101340:	e8 17 f2 ff ff       	call   8010055c <panic>
}
80101345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101348:	c9                   	leave  
80101349:	c3                   	ret    

8010134a <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010134a:	55                   	push   %ebp
8010134b:	89 e5                	mov    %esp,%ebp
8010134d:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101350:	8b 45 08             	mov    0x8(%ebp),%eax
80101353:	83 ec 08             	sub    $0x8,%esp
80101356:	6a 01                	push   $0x1
80101358:	50                   	push   %eax
80101359:	e8 56 ee ff ff       	call   801001b4 <bread>
8010135e:	83 c4 10             	add    $0x10,%esp
80101361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101367:	83 c0 18             	add    $0x18,%eax
8010136a:	83 ec 04             	sub    $0x4,%esp
8010136d:	6a 1c                	push   $0x1c
8010136f:	50                   	push   %eax
80101370:	ff 75 0c             	pushl  0xc(%ebp)
80101373:	e8 29 3f 00 00       	call   801052a1 <memmove>
80101378:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010137b:	83 ec 0c             	sub    $0xc,%esp
8010137e:	ff 75 f4             	pushl  -0xc(%ebp)
80101381:	e8 a5 ee ff ff       	call   8010022b <brelse>
80101386:	83 c4 10             	add    $0x10,%esp
}
80101389:	c9                   	leave  
8010138a:	c3                   	ret    

8010138b <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010138b:	55                   	push   %ebp
8010138c:	89 e5                	mov    %esp,%ebp
8010138e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101391:	8b 55 0c             	mov    0xc(%ebp),%edx
80101394:	8b 45 08             	mov    0x8(%ebp),%eax
80101397:	83 ec 08             	sub    $0x8,%esp
8010139a:	52                   	push   %edx
8010139b:	50                   	push   %eax
8010139c:	e8 13 ee ff ff       	call   801001b4 <bread>
801013a1:	83 c4 10             	add    $0x10,%esp
801013a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013aa:	83 c0 18             	add    $0x18,%eax
801013ad:	83 ec 04             	sub    $0x4,%esp
801013b0:	68 00 02 00 00       	push   $0x200
801013b5:	6a 00                	push   $0x0
801013b7:	50                   	push   %eax
801013b8:	e8 25 3e 00 00       	call   801051e2 <memset>
801013bd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801013c0:	83 ec 0c             	sub    $0xc,%esp
801013c3:	ff 75 f4             	pushl  -0xc(%ebp)
801013c6:	e8 59 23 00 00       	call   80103724 <log_write>
801013cb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013ce:	83 ec 0c             	sub    $0xc,%esp
801013d1:	ff 75 f4             	pushl  -0xc(%ebp)
801013d4:	e8 52 ee ff ff       	call   8010022b <brelse>
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	c9                   	leave  
801013dd:	c3                   	ret    

801013de <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013de:	55                   	push   %ebp
801013df:	89 e5                	mov    %esp,%ebp
801013e1:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013f2:	e9 13 01 00 00       	jmp    8010150a <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013fa:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101400:	85 c0                	test   %eax,%eax
80101402:	0f 48 c2             	cmovs  %edx,%eax
80101405:	c1 f8 0c             	sar    $0xc,%eax
80101408:	89 c2                	mov    %eax,%edx
8010140a:	a1 d8 12 11 80       	mov    0x801112d8,%eax
8010140f:	01 d0                	add    %edx,%eax
80101411:	83 ec 08             	sub    $0x8,%esp
80101414:	50                   	push   %eax
80101415:	ff 75 08             	pushl  0x8(%ebp)
80101418:	e8 97 ed ff ff       	call   801001b4 <bread>
8010141d:	83 c4 10             	add    $0x10,%esp
80101420:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101423:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010142a:	e9 a6 00 00 00       	jmp    801014d5 <balloc+0xf7>
      m = 1 << (bi % 8);
8010142f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101432:	99                   	cltd   
80101433:	c1 ea 1d             	shr    $0x1d,%edx
80101436:	01 d0                	add    %edx,%eax
80101438:	83 e0 07             	and    $0x7,%eax
8010143b:	29 d0                	sub    %edx,%eax
8010143d:	ba 01 00 00 00       	mov    $0x1,%edx
80101442:	89 c1                	mov    %eax,%ecx
80101444:	d3 e2                	shl    %cl,%edx
80101446:	89 d0                	mov    %edx,%eax
80101448:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144e:	8d 50 07             	lea    0x7(%eax),%edx
80101451:	85 c0                	test   %eax,%eax
80101453:	0f 48 c2             	cmovs  %edx,%eax
80101456:	c1 f8 03             	sar    $0x3,%eax
80101459:	89 c2                	mov    %eax,%edx
8010145b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010145e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101463:	0f b6 c0             	movzbl %al,%eax
80101466:	23 45 e8             	and    -0x18(%ebp),%eax
80101469:	85 c0                	test   %eax,%eax
8010146b:	75 64                	jne    801014d1 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101470:	8d 50 07             	lea    0x7(%eax),%edx
80101473:	85 c0                	test   %eax,%eax
80101475:	0f 48 c2             	cmovs  %edx,%eax
80101478:	c1 f8 03             	sar    $0x3,%eax
8010147b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010147e:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101483:	89 d1                	mov    %edx,%ecx
80101485:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101488:	09 ca                	or     %ecx,%edx
8010148a:	89 d1                	mov    %edx,%ecx
8010148c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010148f:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101493:	83 ec 0c             	sub    $0xc,%esp
80101496:	ff 75 ec             	pushl  -0x14(%ebp)
80101499:	e8 86 22 00 00       	call   80103724 <log_write>
8010149e:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	ff 75 ec             	pushl  -0x14(%ebp)
801014a7:	e8 7f ed ff ff       	call   8010022b <brelse>
801014ac:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
801014af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b5:	01 c2                	add    %eax,%edx
801014b7:	8b 45 08             	mov    0x8(%ebp),%eax
801014ba:	83 ec 08             	sub    $0x8,%esp
801014bd:	52                   	push   %edx
801014be:	50                   	push   %eax
801014bf:	e8 c7 fe ff ff       	call   8010138b <bzero>
801014c4:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801014c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014cd:	01 d0                	add    %edx,%eax
801014cf:	eb 56                	jmp    80101527 <balloc+0x149>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014d5:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014dc:	7f 17                	jg     801014f5 <balloc+0x117>
801014de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e4:	01 d0                	add    %edx,%eax
801014e6:	89 c2                	mov    %eax,%edx
801014e8:	a1 c0 12 11 80       	mov    0x801112c0,%eax
801014ed:	39 c2                	cmp    %eax,%edx
801014ef:	0f 82 3a ff ff ff    	jb     8010142f <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014f5:	83 ec 0c             	sub    $0xc,%esp
801014f8:	ff 75 ec             	pushl  -0x14(%ebp)
801014fb:	e8 2b ed ff ff       	call   8010022b <brelse>
80101500:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101503:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010150a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010150d:	a1 c0 12 11 80       	mov    0x801112c0,%eax
80101512:	39 c2                	cmp    %eax,%edx
80101514:	0f 82 dd fe ff ff    	jb     801013f7 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010151a:	83 ec 0c             	sub    $0xc,%esp
8010151d:	68 2c 85 10 80       	push   $0x8010852c
80101522:	e8 35 f0 ff ff       	call   8010055c <panic>
}
80101527:	c9                   	leave  
80101528:	c3                   	ret    

80101529 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101529:	55                   	push   %ebp
8010152a:	89 e5                	mov    %esp,%ebp
8010152c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010152f:	83 ec 08             	sub    $0x8,%esp
80101532:	68 c0 12 11 80       	push   $0x801112c0
80101537:	ff 75 08             	pushl  0x8(%ebp)
8010153a:	e8 0b fe ff ff       	call   8010134a <readsb>
8010153f:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101542:	8b 45 0c             	mov    0xc(%ebp),%eax
80101545:	c1 e8 0c             	shr    $0xc,%eax
80101548:	89 c2                	mov    %eax,%edx
8010154a:	a1 d8 12 11 80       	mov    0x801112d8,%eax
8010154f:	01 c2                	add    %eax,%edx
80101551:	8b 45 08             	mov    0x8(%ebp),%eax
80101554:	83 ec 08             	sub    $0x8,%esp
80101557:	52                   	push   %edx
80101558:	50                   	push   %eax
80101559:	e8 56 ec ff ff       	call   801001b4 <bread>
8010155e:	83 c4 10             	add    $0x10,%esp
80101561:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101564:	8b 45 0c             	mov    0xc(%ebp),%eax
80101567:	25 ff 0f 00 00       	and    $0xfff,%eax
8010156c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101572:	99                   	cltd   
80101573:	c1 ea 1d             	shr    $0x1d,%edx
80101576:	01 d0                	add    %edx,%eax
80101578:	83 e0 07             	and    $0x7,%eax
8010157b:	29 d0                	sub    %edx,%eax
8010157d:	ba 01 00 00 00       	mov    $0x1,%edx
80101582:	89 c1                	mov    %eax,%ecx
80101584:	d3 e2                	shl    %cl,%edx
80101586:	89 d0                	mov    %edx,%eax
80101588:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010158b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158e:	8d 50 07             	lea    0x7(%eax),%edx
80101591:	85 c0                	test   %eax,%eax
80101593:	0f 48 c2             	cmovs  %edx,%eax
80101596:	c1 f8 03             	sar    $0x3,%eax
80101599:	89 c2                	mov    %eax,%edx
8010159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159e:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015a3:	0f b6 c0             	movzbl %al,%eax
801015a6:	23 45 ec             	and    -0x14(%ebp),%eax
801015a9:	85 c0                	test   %eax,%eax
801015ab:	75 0d                	jne    801015ba <bfree+0x91>
    panic("freeing free block");
801015ad:	83 ec 0c             	sub    $0xc,%esp
801015b0:	68 42 85 10 80       	push   $0x80108542
801015b5:	e8 a2 ef ff ff       	call   8010055c <panic>
  bp->data[bi/8] &= ~m;
801015ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015bd:	8d 50 07             	lea    0x7(%eax),%edx
801015c0:	85 c0                	test   %eax,%eax
801015c2:	0f 48 c2             	cmovs  %edx,%eax
801015c5:	c1 f8 03             	sar    $0x3,%eax
801015c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015cb:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015d0:	89 d1                	mov    %edx,%ecx
801015d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801015d5:	f7 d2                	not    %edx
801015d7:	21 ca                	and    %ecx,%edx
801015d9:	89 d1                	mov    %edx,%ecx
801015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015de:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015e2:	83 ec 0c             	sub    $0xc,%esp
801015e5:	ff 75 f4             	pushl  -0xc(%ebp)
801015e8:	e8 37 21 00 00       	call   80103724 <log_write>
801015ed:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015f0:	83 ec 0c             	sub    $0xc,%esp
801015f3:	ff 75 f4             	pushl  -0xc(%ebp)
801015f6:	e8 30 ec ff ff       	call   8010022b <brelse>
801015fb:	83 c4 10             	add    $0x10,%esp
}
801015fe:	c9                   	leave  
801015ff:	c3                   	ret    

80101600 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101609:	83 ec 08             	sub    $0x8,%esp
8010160c:	68 55 85 10 80       	push   $0x80108555
80101611:	68 00 13 11 80       	push   $0x80111300
80101616:	e8 4a 39 00 00       	call   80104f65 <initlock>
8010161b:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010161e:	83 ec 08             	sub    $0x8,%esp
80101621:	68 c0 12 11 80       	push   $0x801112c0
80101626:	ff 75 08             	pushl  0x8(%ebp)
80101629:	e8 1c fd ff ff       	call   8010134a <readsb>
8010162e:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101631:	a1 d8 12 11 80       	mov    0x801112d8,%eax
80101636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101639:	8b 3d d4 12 11 80    	mov    0x801112d4,%edi
8010163f:	8b 35 d0 12 11 80    	mov    0x801112d0,%esi
80101645:	8b 1d cc 12 11 80    	mov    0x801112cc,%ebx
8010164b:	8b 0d c8 12 11 80    	mov    0x801112c8,%ecx
80101651:	8b 15 c4 12 11 80    	mov    0x801112c4,%edx
80101657:	a1 c0 12 11 80       	mov    0x801112c0,%eax
8010165c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010165f:	57                   	push   %edi
80101660:	56                   	push   %esi
80101661:	53                   	push   %ebx
80101662:	51                   	push   %ecx
80101663:	52                   	push   %edx
80101664:	50                   	push   %eax
80101665:	68 5c 85 10 80       	push   $0x8010855c
8010166a:	e8 50 ed ff ff       	call   801003bf <cprintf>
8010166f:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101672:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101675:	5b                   	pop    %ebx
80101676:	5e                   	pop    %esi
80101677:	5f                   	pop    %edi
80101678:	5d                   	pop    %ebp
80101679:	c3                   	ret    

8010167a <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010167a:	55                   	push   %ebp
8010167b:	89 e5                	mov    %esp,%ebp
8010167d:	83 ec 28             	sub    $0x28,%esp
80101680:	8b 45 0c             	mov    0xc(%ebp),%eax
80101683:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101687:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010168e:	e9 9e 00 00 00       	jmp    80101731 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101693:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101696:	c1 e8 03             	shr    $0x3,%eax
80101699:	89 c2                	mov    %eax,%edx
8010169b:	a1 d4 12 11 80       	mov    0x801112d4,%eax
801016a0:	01 d0                	add    %edx,%eax
801016a2:	83 ec 08             	sub    $0x8,%esp
801016a5:	50                   	push   %eax
801016a6:	ff 75 08             	pushl  0x8(%ebp)
801016a9:	e8 06 eb ff ff       	call   801001b4 <bread>
801016ae:	83 c4 10             	add    $0x10,%esp
801016b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b7:	8d 50 18             	lea    0x18(%eax),%edx
801016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016bd:	83 e0 07             	and    $0x7,%eax
801016c0:	c1 e0 06             	shl    $0x6,%eax
801016c3:	01 d0                	add    %edx,%eax
801016c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016cb:	0f b7 00             	movzwl (%eax),%eax
801016ce:	66 85 c0             	test   %ax,%ax
801016d1:	75 4c                	jne    8010171f <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801016d3:	83 ec 04             	sub    $0x4,%esp
801016d6:	6a 40                	push   $0x40
801016d8:	6a 00                	push   $0x0
801016da:	ff 75 ec             	pushl  -0x14(%ebp)
801016dd:	e8 00 3b 00 00       	call   801051e2 <memset>
801016e2:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801016e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016e8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801016ec:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801016ef:	83 ec 0c             	sub    $0xc,%esp
801016f2:	ff 75 f0             	pushl  -0x10(%ebp)
801016f5:	e8 2a 20 00 00       	call   80103724 <log_write>
801016fa:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801016fd:	83 ec 0c             	sub    $0xc,%esp
80101700:	ff 75 f0             	pushl  -0x10(%ebp)
80101703:	e8 23 eb ff ff       	call   8010022b <brelse>
80101708:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010170e:	83 ec 08             	sub    $0x8,%esp
80101711:	50                   	push   %eax
80101712:	ff 75 08             	pushl  0x8(%ebp)
80101715:	e8 f6 00 00 00       	call   80101810 <iget>
8010171a:	83 c4 10             	add    $0x10,%esp
8010171d:	eb 2f                	jmp    8010174e <ialloc+0xd4>
    }
    brelse(bp);
8010171f:	83 ec 0c             	sub    $0xc,%esp
80101722:	ff 75 f0             	pushl  -0x10(%ebp)
80101725:	e8 01 eb ff ff       	call   8010022b <brelse>
8010172a:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010172d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101731:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101734:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80101739:	39 c2                	cmp    %eax,%edx
8010173b:	0f 82 52 ff ff ff    	jb     80101693 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101741:	83 ec 0c             	sub    $0xc,%esp
80101744:	68 af 85 10 80       	push   $0x801085af
80101749:	e8 0e ee ff ff       	call   8010055c <panic>
}
8010174e:	c9                   	leave  
8010174f:	c3                   	ret    

80101750 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101756:	8b 45 08             	mov    0x8(%ebp),%eax
80101759:	8b 40 04             	mov    0x4(%eax),%eax
8010175c:	c1 e8 03             	shr    $0x3,%eax
8010175f:	89 c2                	mov    %eax,%edx
80101761:	a1 d4 12 11 80       	mov    0x801112d4,%eax
80101766:	01 c2                	add    %eax,%edx
80101768:	8b 45 08             	mov    0x8(%ebp),%eax
8010176b:	8b 00                	mov    (%eax),%eax
8010176d:	83 ec 08             	sub    $0x8,%esp
80101770:	52                   	push   %edx
80101771:	50                   	push   %eax
80101772:	e8 3d ea ff ff       	call   801001b4 <bread>
80101777:	83 c4 10             	add    $0x10,%esp
8010177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101780:	8d 50 18             	lea    0x18(%eax),%edx
80101783:	8b 45 08             	mov    0x8(%ebp),%eax
80101786:	8b 40 04             	mov    0x4(%eax),%eax
80101789:	83 e0 07             	and    $0x7,%eax
8010178c:	c1 e0 06             	shl    $0x6,%eax
8010178f:	01 d0                	add    %edx,%eax
80101791:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101794:	8b 45 08             	mov    0x8(%ebp),%eax
80101797:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010179b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179e:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017a1:	8b 45 08             	mov    0x8(%ebp),%eax
801017a4:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017ab:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017af:	8b 45 08             	mov    0x8(%ebp),%eax
801017b2:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017b9:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017bd:	8b 45 08             	mov    0x8(%ebp),%eax
801017c0:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c7:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017cb:	8b 45 08             	mov    0x8(%ebp),%eax
801017ce:	8b 50 18             	mov    0x18(%eax),%edx
801017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d4:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d7:	8b 45 08             	mov    0x8(%ebp),%eax
801017da:	8d 50 1c             	lea    0x1c(%eax),%edx
801017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e0:	83 c0 0c             	add    $0xc,%eax
801017e3:	83 ec 04             	sub    $0x4,%esp
801017e6:	6a 34                	push   $0x34
801017e8:	52                   	push   %edx
801017e9:	50                   	push   %eax
801017ea:	e8 b2 3a 00 00       	call   801052a1 <memmove>
801017ef:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801017f2:	83 ec 0c             	sub    $0xc,%esp
801017f5:	ff 75 f4             	pushl  -0xc(%ebp)
801017f8:	e8 27 1f 00 00       	call   80103724 <log_write>
801017fd:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101800:	83 ec 0c             	sub    $0xc,%esp
80101803:	ff 75 f4             	pushl  -0xc(%ebp)
80101806:	e8 20 ea ff ff       	call   8010022b <brelse>
8010180b:	83 c4 10             	add    $0x10,%esp
}
8010180e:	c9                   	leave  
8010180f:	c3                   	ret    

80101810 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	68 00 13 11 80       	push   $0x80111300
8010181e:	e8 63 37 00 00       	call   80104f86 <acquire>
80101823:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101826:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010182d:	c7 45 f4 34 13 11 80 	movl   $0x80111334,-0xc(%ebp)
80101834:	eb 5d                	jmp    80101893 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101839:	8b 40 08             	mov    0x8(%eax),%eax
8010183c:	85 c0                	test   %eax,%eax
8010183e:	7e 39                	jle    80101879 <iget+0x69>
80101840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101843:	8b 00                	mov    (%eax),%eax
80101845:	3b 45 08             	cmp    0x8(%ebp),%eax
80101848:	75 2f                	jne    80101879 <iget+0x69>
8010184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184d:	8b 40 04             	mov    0x4(%eax),%eax
80101850:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101853:	75 24                	jne    80101879 <iget+0x69>
      ip->ref++;
80101855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101858:	8b 40 08             	mov    0x8(%eax),%eax
8010185b:	8d 50 01             	lea    0x1(%eax),%edx
8010185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101861:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101864:	83 ec 0c             	sub    $0xc,%esp
80101867:	68 00 13 11 80       	push   $0x80111300
8010186c:	e8 7b 37 00 00       	call   80104fec <release>
80101871:	83 c4 10             	add    $0x10,%esp
      return ip;
80101874:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101877:	eb 74                	jmp    801018ed <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010187d:	75 10                	jne    8010188f <iget+0x7f>
8010187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101882:	8b 40 08             	mov    0x8(%eax),%eax
80101885:	85 c0                	test   %eax,%eax
80101887:	75 06                	jne    8010188f <iget+0x7f>
      empty = ip;
80101889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010188f:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101893:	81 7d f4 d4 22 11 80 	cmpl   $0x801122d4,-0xc(%ebp)
8010189a:	72 9a                	jb     80101836 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010189c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018a0:	75 0d                	jne    801018af <iget+0x9f>
    panic("iget: no inodes");
801018a2:	83 ec 0c             	sub    $0xc,%esp
801018a5:	68 c1 85 10 80       	push   $0x801085c1
801018aa:	e8 ad ec ff ff       	call   8010055c <panic>

  ip = empty;
801018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b8:	8b 55 08             	mov    0x8(%ebp),%edx
801018bb:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801018c3:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c9:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801018d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801018da:	83 ec 0c             	sub    $0xc,%esp
801018dd:	68 00 13 11 80       	push   $0x80111300
801018e2:	e8 05 37 00 00       	call   80104fec <release>
801018e7:	83 c4 10             	add    $0x10,%esp

  return ip;
801018ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801018ed:	c9                   	leave  
801018ee:	c3                   	ret    

801018ef <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018ef:	55                   	push   %ebp
801018f0:	89 e5                	mov    %esp,%ebp
801018f2:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801018f5:	83 ec 0c             	sub    $0xc,%esp
801018f8:	68 00 13 11 80       	push   $0x80111300
801018fd:	e8 84 36 00 00       	call   80104f86 <acquire>
80101902:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101905:	8b 45 08             	mov    0x8(%ebp),%eax
80101908:	8b 40 08             	mov    0x8(%eax),%eax
8010190b:	8d 50 01             	lea    0x1(%eax),%edx
8010190e:	8b 45 08             	mov    0x8(%ebp),%eax
80101911:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101914:	83 ec 0c             	sub    $0xc,%esp
80101917:	68 00 13 11 80       	push   $0x80111300
8010191c:	e8 cb 36 00 00       	call   80104fec <release>
80101921:	83 c4 10             	add    $0x10,%esp
  return ip;
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101927:	c9                   	leave  
80101928:	c3                   	ret    

80101929 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101929:	55                   	push   %ebp
8010192a:	89 e5                	mov    %esp,%ebp
8010192c:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010192f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101933:	74 0a                	je     8010193f <ilock+0x16>
80101935:	8b 45 08             	mov    0x8(%ebp),%eax
80101938:	8b 40 08             	mov    0x8(%eax),%eax
8010193b:	85 c0                	test   %eax,%eax
8010193d:	7f 0d                	jg     8010194c <ilock+0x23>
    panic("ilock");
8010193f:	83 ec 0c             	sub    $0xc,%esp
80101942:	68 d1 85 10 80       	push   $0x801085d1
80101947:	e8 10 ec ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
8010194c:	83 ec 0c             	sub    $0xc,%esp
8010194f:	68 00 13 11 80       	push   $0x80111300
80101954:	e8 2d 36 00 00       	call   80104f86 <acquire>
80101959:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
8010195c:	eb 13                	jmp    80101971 <ilock+0x48>
    sleep(ip, &icache.lock);
8010195e:	83 ec 08             	sub    $0x8,%esp
80101961:	68 00 13 11 80       	push   $0x80111300
80101966:	ff 75 08             	pushl  0x8(%ebp)
80101969:	e8 28 33 00 00       	call   80104c96 <sleep>
8010196e:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101971:	8b 45 08             	mov    0x8(%ebp),%eax
80101974:	8b 40 0c             	mov    0xc(%eax),%eax
80101977:	83 e0 01             	and    $0x1,%eax
8010197a:	85 c0                	test   %eax,%eax
8010197c:	75 e0                	jne    8010195e <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
8010197e:	8b 45 08             	mov    0x8(%ebp),%eax
80101981:	8b 40 0c             	mov    0xc(%eax),%eax
80101984:	83 c8 01             	or     $0x1,%eax
80101987:	89 c2                	mov    %eax,%edx
80101989:	8b 45 08             	mov    0x8(%ebp),%eax
8010198c:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
8010198f:	83 ec 0c             	sub    $0xc,%esp
80101992:	68 00 13 11 80       	push   $0x80111300
80101997:	e8 50 36 00 00       	call   80104fec <release>
8010199c:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
8010199f:	8b 45 08             	mov    0x8(%ebp),%eax
801019a2:	8b 40 0c             	mov    0xc(%eax),%eax
801019a5:	83 e0 02             	and    $0x2,%eax
801019a8:	85 c0                	test   %eax,%eax
801019aa:	0f 85 d4 00 00 00    	jne    80101a84 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019b0:	8b 45 08             	mov    0x8(%ebp),%eax
801019b3:	8b 40 04             	mov    0x4(%eax),%eax
801019b6:	c1 e8 03             	shr    $0x3,%eax
801019b9:	89 c2                	mov    %eax,%edx
801019bb:	a1 d4 12 11 80       	mov    0x801112d4,%eax
801019c0:	01 c2                	add    %eax,%edx
801019c2:	8b 45 08             	mov    0x8(%ebp),%eax
801019c5:	8b 00                	mov    (%eax),%eax
801019c7:	83 ec 08             	sub    $0x8,%esp
801019ca:	52                   	push   %edx
801019cb:	50                   	push   %eax
801019cc:	e8 e3 e7 ff ff       	call   801001b4 <bread>
801019d1:	83 c4 10             	add    $0x10,%esp
801019d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019da:	8d 50 18             	lea    0x18(%eax),%edx
801019dd:	8b 45 08             	mov    0x8(%ebp),%eax
801019e0:	8b 40 04             	mov    0x4(%eax),%eax
801019e3:	83 e0 07             	and    $0x7,%eax
801019e6:	c1 e0 06             	shl    $0x6,%eax
801019e9:	01 d0                	add    %edx,%eax
801019eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f1:	0f b7 10             	movzwl (%eax),%edx
801019f4:	8b 45 08             	mov    0x8(%ebp),%eax
801019f7:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
801019fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019fe:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a02:	8b 45 08             	mov    0x8(%ebp),%eax
80101a05:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a0c:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a10:	8b 45 08             	mov    0x8(%ebp),%eax
80101a13:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1a:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a21:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a28:	8b 50 08             	mov    0x8(%eax),%edx
80101a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2e:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a34:	8d 50 0c             	lea    0xc(%eax),%edx
80101a37:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3a:	83 c0 1c             	add    $0x1c,%eax
80101a3d:	83 ec 04             	sub    $0x4,%esp
80101a40:	6a 34                	push   $0x34
80101a42:	52                   	push   %edx
80101a43:	50                   	push   %eax
80101a44:	e8 58 38 00 00       	call   801052a1 <memmove>
80101a49:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101a4c:	83 ec 0c             	sub    $0xc,%esp
80101a4f:	ff 75 f4             	pushl  -0xc(%ebp)
80101a52:	e8 d4 e7 ff ff       	call   8010022b <brelse>
80101a57:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	8b 40 0c             	mov    0xc(%eax),%eax
80101a60:	83 c8 02             	or     $0x2,%eax
80101a63:	89 c2                	mov    %eax,%edx
80101a65:	8b 45 08             	mov    0x8(%ebp),%eax
80101a68:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101a72:	66 85 c0             	test   %ax,%ax
80101a75:	75 0d                	jne    80101a84 <ilock+0x15b>
      panic("ilock: no type");
80101a77:	83 ec 0c             	sub    $0xc,%esp
80101a7a:	68 d7 85 10 80       	push   $0x801085d7
80101a7f:	e8 d8 ea ff ff       	call   8010055c <panic>
  }
}
80101a84:	c9                   	leave  
80101a85:	c3                   	ret    

80101a86 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a86:	55                   	push   %ebp
80101a87:	89 e5                	mov    %esp,%ebp
80101a89:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101a8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a90:	74 17                	je     80101aa9 <iunlock+0x23>
80101a92:	8b 45 08             	mov    0x8(%ebp),%eax
80101a95:	8b 40 0c             	mov    0xc(%eax),%eax
80101a98:	83 e0 01             	and    $0x1,%eax
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 0a                	je     80101aa9 <iunlock+0x23>
80101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa2:	8b 40 08             	mov    0x8(%eax),%eax
80101aa5:	85 c0                	test   %eax,%eax
80101aa7:	7f 0d                	jg     80101ab6 <iunlock+0x30>
    panic("iunlock");
80101aa9:	83 ec 0c             	sub    $0xc,%esp
80101aac:	68 e6 85 10 80       	push   $0x801085e6
80101ab1:	e8 a6 ea ff ff       	call   8010055c <panic>

  acquire(&icache.lock);
80101ab6:	83 ec 0c             	sub    $0xc,%esp
80101ab9:	68 00 13 11 80       	push   $0x80111300
80101abe:	e8 c3 34 00 00       	call   80104f86 <acquire>
80101ac3:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac9:	8b 40 0c             	mov    0xc(%eax),%eax
80101acc:	83 e0 fe             	and    $0xfffffffe,%eax
80101acf:	89 c2                	mov    %eax,%edx
80101ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad4:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101ad7:	83 ec 0c             	sub    $0xc,%esp
80101ada:	ff 75 08             	pushl  0x8(%ebp)
80101add:	e8 9d 32 00 00       	call   80104d7f <wakeup>
80101ae2:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ae5:	83 ec 0c             	sub    $0xc,%esp
80101ae8:	68 00 13 11 80       	push   $0x80111300
80101aed:	e8 fa 34 00 00       	call   80104fec <release>
80101af2:	83 c4 10             	add    $0x10,%esp
}
80101af5:	c9                   	leave  
80101af6:	c3                   	ret    

80101af7 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101af7:	55                   	push   %ebp
80101af8:	89 e5                	mov    %esp,%ebp
80101afa:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101afd:	83 ec 0c             	sub    $0xc,%esp
80101b00:	68 00 13 11 80       	push   $0x80111300
80101b05:	e8 7c 34 00 00       	call   80104f86 <acquire>
80101b0a:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b10:	8b 40 08             	mov    0x8(%eax),%eax
80101b13:	83 f8 01             	cmp    $0x1,%eax
80101b16:	0f 85 a9 00 00 00    	jne    80101bc5 <iput+0xce>
80101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b22:	83 e0 02             	and    $0x2,%eax
80101b25:	85 c0                	test   %eax,%eax
80101b27:	0f 84 98 00 00 00    	je     80101bc5 <iput+0xce>
80101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b30:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b34:	66 85 c0             	test   %ax,%ax
80101b37:	0f 85 88 00 00 00    	jne    80101bc5 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b40:	8b 40 0c             	mov    0xc(%eax),%eax
80101b43:	83 e0 01             	and    $0x1,%eax
80101b46:	85 c0                	test   %eax,%eax
80101b48:	74 0d                	je     80101b57 <iput+0x60>
      panic("iput busy");
80101b4a:	83 ec 0c             	sub    $0xc,%esp
80101b4d:	68 ee 85 10 80       	push   $0x801085ee
80101b52:	e8 05 ea ff ff       	call   8010055c <panic>
    ip->flags |= I_BUSY;
80101b57:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5a:	8b 40 0c             	mov    0xc(%eax),%eax
80101b5d:	83 c8 01             	or     $0x1,%eax
80101b60:	89 c2                	mov    %eax,%edx
80101b62:	8b 45 08             	mov    0x8(%ebp),%eax
80101b65:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101b68:	83 ec 0c             	sub    $0xc,%esp
80101b6b:	68 00 13 11 80       	push   $0x80111300
80101b70:	e8 77 34 00 00       	call   80104fec <release>
80101b75:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101b78:	83 ec 0c             	sub    $0xc,%esp
80101b7b:	ff 75 08             	pushl  0x8(%ebp)
80101b7e:	e8 a6 01 00 00       	call   80101d29 <itrunc>
80101b83:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101b86:	8b 45 08             	mov    0x8(%ebp),%eax
80101b89:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101b8f:	83 ec 0c             	sub    $0xc,%esp
80101b92:	ff 75 08             	pushl  0x8(%ebp)
80101b95:	e8 b6 fb ff ff       	call   80101750 <iupdate>
80101b9a:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101b9d:	83 ec 0c             	sub    $0xc,%esp
80101ba0:	68 00 13 11 80       	push   $0x80111300
80101ba5:	e8 dc 33 00 00       	call   80104f86 <acquire>
80101baa:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101bb7:	83 ec 0c             	sub    $0xc,%esp
80101bba:	ff 75 08             	pushl  0x8(%ebp)
80101bbd:	e8 bd 31 00 00       	call   80104d7f <wakeup>
80101bc2:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	8b 40 08             	mov    0x8(%eax),%eax
80101bcb:	8d 50 ff             	lea    -0x1(%eax),%edx
80101bce:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd1:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101bd4:	83 ec 0c             	sub    $0xc,%esp
80101bd7:	68 00 13 11 80       	push   $0x80111300
80101bdc:	e8 0b 34 00 00       	call   80104fec <release>
80101be1:	83 c4 10             	add    $0x10,%esp
}
80101be4:	c9                   	leave  
80101be5:	c3                   	ret    

80101be6 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101be6:	55                   	push   %ebp
80101be7:	89 e5                	mov    %esp,%ebp
80101be9:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101bec:	83 ec 0c             	sub    $0xc,%esp
80101bef:	ff 75 08             	pushl  0x8(%ebp)
80101bf2:	e8 8f fe ff ff       	call   80101a86 <iunlock>
80101bf7:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101bfa:	83 ec 0c             	sub    $0xc,%esp
80101bfd:	ff 75 08             	pushl  0x8(%ebp)
80101c00:	e8 f2 fe ff ff       	call   80101af7 <iput>
80101c05:	83 c4 10             	add    $0x10,%esp
}
80101c08:	c9                   	leave  
80101c09:	c3                   	ret    

80101c0a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c0a:	55                   	push   %ebp
80101c0b:	89 e5                	mov    %esp,%ebp
80101c0d:	53                   	push   %ebx
80101c0e:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c11:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c15:	77 42                	ja     80101c59 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101c17:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c1d:	83 c2 04             	add    $0x4,%edx
80101c20:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c2b:	75 24                	jne    80101c51 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c30:	8b 00                	mov    (%eax),%eax
80101c32:	83 ec 0c             	sub    $0xc,%esp
80101c35:	50                   	push   %eax
80101c36:	e8 a3 f7 ff ff       	call   801013de <balloc>
80101c3b:	83 c4 10             	add    $0x10,%esp
80101c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c41:	8b 45 08             	mov    0x8(%ebp),%eax
80101c44:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c47:	8d 4a 04             	lea    0x4(%edx),%ecx
80101c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c4d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c54:	e9 cb 00 00 00       	jmp    80101d24 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101c59:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101c5d:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101c61:	0f 87 b0 00 00 00    	ja     80101d17 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101c67:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6a:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c74:	75 1d                	jne    80101c93 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101c76:	8b 45 08             	mov    0x8(%ebp),%eax
80101c79:	8b 00                	mov    (%eax),%eax
80101c7b:	83 ec 0c             	sub    $0xc,%esp
80101c7e:	50                   	push   %eax
80101c7f:	e8 5a f7 ff ff       	call   801013de <balloc>
80101c84:	83 c4 10             	add    $0x10,%esp
80101c87:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c90:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	8b 00                	mov    (%eax),%eax
80101c98:	83 ec 08             	sub    $0x8,%esp
80101c9b:	ff 75 f4             	pushl  -0xc(%ebp)
80101c9e:	50                   	push   %eax
80101c9f:	e8 10 e5 ff ff       	call   801001b4 <bread>
80101ca4:	83 c4 10             	add    $0x10,%esp
80101ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cad:	83 c0 18             	add    $0x18,%eax
80101cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cc0:	01 d0                	add    %edx,%eax
80101cc2:	8b 00                	mov    (%eax),%eax
80101cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ccb:	75 37                	jne    80101d04 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cd0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cda:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce0:	8b 00                	mov    (%eax),%eax
80101ce2:	83 ec 0c             	sub    $0xc,%esp
80101ce5:	50                   	push   %eax
80101ce6:	e8 f3 f6 ff ff       	call   801013de <balloc>
80101ceb:	83 c4 10             	add    $0x10,%esp
80101cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cf4:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101cf6:	83 ec 0c             	sub    $0xc,%esp
80101cf9:	ff 75 f0             	pushl  -0x10(%ebp)
80101cfc:	e8 23 1a 00 00       	call   80103724 <log_write>
80101d01:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d04:	83 ec 0c             	sub    $0xc,%esp
80101d07:	ff 75 f0             	pushl  -0x10(%ebp)
80101d0a:	e8 1c e5 ff ff       	call   8010022b <brelse>
80101d0f:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d15:	eb 0d                	jmp    80101d24 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101d17:	83 ec 0c             	sub    $0xc,%esp
80101d1a:	68 f8 85 10 80       	push   $0x801085f8
80101d1f:	e8 38 e8 ff ff       	call   8010055c <panic>
}
80101d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d27:	c9                   	leave  
80101d28:	c3                   	ret    

80101d29 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d29:	55                   	push   %ebp
80101d2a:	89 e5                	mov    %esp,%ebp
80101d2c:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d36:	eb 45                	jmp    80101d7d <itrunc+0x54>
    if(ip->addrs[i]){
80101d38:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d3e:	83 c2 04             	add    $0x4,%edx
80101d41:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 30                	je     80101d79 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101d49:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d4f:	83 c2 04             	add    $0x4,%edx
80101d52:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d56:	8b 55 08             	mov    0x8(%ebp),%edx
80101d59:	8b 12                	mov    (%edx),%edx
80101d5b:	83 ec 08             	sub    $0x8,%esp
80101d5e:	50                   	push   %eax
80101d5f:	52                   	push   %edx
80101d60:	e8 c4 f7 ff ff       	call   80101529 <bfree>
80101d65:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101d68:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d6e:	83 c2 04             	add    $0x4,%edx
80101d71:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101d78:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101d7d:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101d81:	7e b5                	jle    80101d38 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101d83:	8b 45 08             	mov    0x8(%ebp),%eax
80101d86:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d89:	85 c0                	test   %eax,%eax
80101d8b:	0f 84 a1 00 00 00    	je     80101e32 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101d91:	8b 45 08             	mov    0x8(%ebp),%eax
80101d94:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d97:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9a:	8b 00                	mov    (%eax),%eax
80101d9c:	83 ec 08             	sub    $0x8,%esp
80101d9f:	52                   	push   %edx
80101da0:	50                   	push   %eax
80101da1:	e8 0e e4 ff ff       	call   801001b4 <bread>
80101da6:	83 c4 10             	add    $0x10,%esp
80101da9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101daf:	83 c0 18             	add    $0x18,%eax
80101db2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101db5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101dbc:	eb 3c                	jmp    80101dfa <itrunc+0xd1>
      if(a[j])
80101dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101dcb:	01 d0                	add    %edx,%eax
80101dcd:	8b 00                	mov    (%eax),%eax
80101dcf:	85 c0                	test   %eax,%eax
80101dd1:	74 23                	je     80101df6 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ddd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101de0:	01 d0                	add    %edx,%eax
80101de2:	8b 00                	mov    (%eax),%eax
80101de4:	8b 55 08             	mov    0x8(%ebp),%edx
80101de7:	8b 12                	mov    (%edx),%edx
80101de9:	83 ec 08             	sub    $0x8,%esp
80101dec:	50                   	push   %eax
80101ded:	52                   	push   %edx
80101dee:	e8 36 f7 ff ff       	call   80101529 <bfree>
80101df3:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101df6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101dfd:	83 f8 7f             	cmp    $0x7f,%eax
80101e00:	76 bc                	jbe    80101dbe <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101e02:	83 ec 0c             	sub    $0xc,%esp
80101e05:	ff 75 ec             	pushl  -0x14(%ebp)
80101e08:	e8 1e e4 ff ff       	call   8010022b <brelse>
80101e0d:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e10:	8b 45 08             	mov    0x8(%ebp),%eax
80101e13:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e16:	8b 55 08             	mov    0x8(%ebp),%edx
80101e19:	8b 12                	mov    (%edx),%edx
80101e1b:	83 ec 08             	sub    $0x8,%esp
80101e1e:	50                   	push   %eax
80101e1f:	52                   	push   %edx
80101e20:	e8 04 f7 ff ff       	call   80101529 <bfree>
80101e25:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e32:	8b 45 08             	mov    0x8(%ebp),%eax
80101e35:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	ff 75 08             	pushl  0x8(%ebp)
80101e42:	e8 09 f9 ff ff       	call   80101750 <iupdate>
80101e47:	83 c4 10             	add    $0x10,%esp
}
80101e4a:	c9                   	leave  
80101e4b:	c3                   	ret    

80101e4c <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101e4c:	55                   	push   %ebp
80101e4d:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e52:	8b 00                	mov    (%eax),%eax
80101e54:	89 c2                	mov    %eax,%edx
80101e56:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e59:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101e5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e5f:	8b 50 04             	mov    0x4(%eax),%edx
80101e62:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e65:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101e68:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6b:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e72:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101e75:	8b 45 08             	mov    0x8(%ebp),%eax
80101e78:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e7f:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101e83:	8b 45 08             	mov    0x8(%ebp),%eax
80101e86:	8b 50 18             	mov    0x18(%eax),%edx
80101e89:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8c:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e8f:	5d                   	pop    %ebp
80101e90:	c3                   	ret    

80101e91 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101e91:	55                   	push   %ebp
80101e92:	89 e5                	mov    %esp,%ebp
80101e94:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e97:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101e9e:	66 83 f8 03          	cmp    $0x3,%ax
80101ea2:	75 5c                	jne    80101f00 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ea4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea7:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eab:	66 85 c0             	test   %ax,%ax
80101eae:	78 20                	js     80101ed0 <readi+0x3f>
80101eb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101eb7:	66 83 f8 09          	cmp    $0x9,%ax
80101ebb:	7f 13                	jg     80101ed0 <readi+0x3f>
80101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ec4:	98                   	cwtl   
80101ec5:	8b 04 c5 40 12 11 80 	mov    -0x7feeedc0(,%eax,8),%eax
80101ecc:	85 c0                	test   %eax,%eax
80101ece:	75 0a                	jne    80101eda <readi+0x49>
      return -1;
80101ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed5:	e9 0f 01 00 00       	jmp    80101fe9 <readi+0x158>
    return devsw[ip->major].read(ip, dst, n);
80101eda:	8b 45 08             	mov    0x8(%ebp),%eax
80101edd:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ee1:	98                   	cwtl   
80101ee2:	8b 04 c5 40 12 11 80 	mov    -0x7feeedc0(,%eax,8),%eax
80101ee9:	8b 55 14             	mov    0x14(%ebp),%edx
80101eec:	83 ec 04             	sub    $0x4,%esp
80101eef:	52                   	push   %edx
80101ef0:	ff 75 0c             	pushl  0xc(%ebp)
80101ef3:	ff 75 08             	pushl  0x8(%ebp)
80101ef6:	ff d0                	call   *%eax
80101ef8:	83 c4 10             	add    $0x10,%esp
80101efb:	e9 e9 00 00 00       	jmp    80101fe9 <readi+0x158>
  }

  if(off > ip->size || off + n < off)
80101f00:	8b 45 08             	mov    0x8(%ebp),%eax
80101f03:	8b 40 18             	mov    0x18(%eax),%eax
80101f06:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f09:	72 0d                	jb     80101f18 <readi+0x87>
80101f0b:	8b 55 10             	mov    0x10(%ebp),%edx
80101f0e:	8b 45 14             	mov    0x14(%ebp),%eax
80101f11:	01 d0                	add    %edx,%eax
80101f13:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f16:	73 0a                	jae    80101f22 <readi+0x91>
    return -1;
80101f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f1d:	e9 c7 00 00 00       	jmp    80101fe9 <readi+0x158>
  if(off + n > ip->size)
80101f22:	8b 55 10             	mov    0x10(%ebp),%edx
80101f25:	8b 45 14             	mov    0x14(%ebp),%eax
80101f28:	01 c2                	add    %eax,%edx
80101f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2d:	8b 40 18             	mov    0x18(%eax),%eax
80101f30:	39 c2                	cmp    %eax,%edx
80101f32:	76 0c                	jbe    80101f40 <readi+0xaf>
    n = ip->size - off;
80101f34:	8b 45 08             	mov    0x8(%ebp),%eax
80101f37:	8b 40 18             	mov    0x18(%eax),%eax
80101f3a:	2b 45 10             	sub    0x10(%ebp),%eax
80101f3d:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f47:	e9 8e 00 00 00       	jmp    80101fda <readi+0x149>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f4c:	8b 45 10             	mov    0x10(%ebp),%eax
80101f4f:	c1 e8 09             	shr    $0x9,%eax
80101f52:	83 ec 08             	sub    $0x8,%esp
80101f55:	50                   	push   %eax
80101f56:	ff 75 08             	pushl  0x8(%ebp)
80101f59:	e8 ac fc ff ff       	call   80101c0a <bmap>
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	89 c2                	mov    %eax,%edx
80101f63:	8b 45 08             	mov    0x8(%ebp),%eax
80101f66:	8b 00                	mov    (%eax),%eax
80101f68:	83 ec 08             	sub    $0x8,%esp
80101f6b:	52                   	push   %edx
80101f6c:	50                   	push   %eax
80101f6d:	e8 42 e2 ff ff       	call   801001b4 <bread>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f78:	8b 45 10             	mov    0x10(%ebp),%eax
80101f7b:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f80:	ba 00 02 00 00       	mov    $0x200,%edx
80101f85:	29 c2                	sub    %eax,%edx
80101f87:	8b 45 14             	mov    0x14(%ebp),%eax
80101f8a:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101f8d:	39 c2                	cmp    %eax,%edx
80101f8f:	0f 46 c2             	cmovbe %edx,%eax
80101f92:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f95:	8b 45 10             	mov    0x10(%ebp),%eax
80101f98:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f9d:	8d 50 10             	lea    0x10(%eax),%edx
80101fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fa3:	01 d0                	add    %edx,%eax
80101fa5:	83 c0 08             	add    $0x8,%eax
80101fa8:	83 ec 04             	sub    $0x4,%esp
80101fab:	ff 75 ec             	pushl  -0x14(%ebp)
80101fae:	50                   	push   %eax
80101faf:	ff 75 0c             	pushl  0xc(%ebp)
80101fb2:	e8 ea 32 00 00       	call   801052a1 <memmove>
80101fb7:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	ff 75 f0             	pushl  -0x10(%ebp)
80101fc0:	e8 66 e2 ff ff       	call   8010022b <brelse>
80101fc5:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fcb:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd1:	01 45 10             	add    %eax,0x10(%ebp)
80101fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd7:	01 45 0c             	add    %eax,0xc(%ebp)
80101fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fdd:	3b 45 14             	cmp    0x14(%ebp),%eax
80101fe0:	0f 82 66 ff ff ff    	jb     80101f4c <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101fe6:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101fe9:	c9                   	leave  
80101fea:	c3                   	ret    

80101feb <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101feb:	55                   	push   %ebp
80101fec:	89 e5                	mov    %esp,%ebp
80101fee:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ff8:	66 83 f8 03          	cmp    $0x3,%ax
80101ffc:	75 5c                	jne    8010205a <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80102001:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102005:	66 85 c0             	test   %ax,%ax
80102008:	78 20                	js     8010202a <writei+0x3f>
8010200a:	8b 45 08             	mov    0x8(%ebp),%eax
8010200d:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102011:	66 83 f8 09          	cmp    $0x9,%ax
80102015:	7f 13                	jg     8010202a <writei+0x3f>
80102017:	8b 45 08             	mov    0x8(%ebp),%eax
8010201a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010201e:	98                   	cwtl   
8010201f:	8b 04 c5 44 12 11 80 	mov    -0x7feeedbc(,%eax,8),%eax
80102026:	85 c0                	test   %eax,%eax
80102028:	75 0a                	jne    80102034 <writei+0x49>
      return -1;
8010202a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010202f:	e9 40 01 00 00       	jmp    80102174 <writei+0x189>
    return devsw[ip->major].write(ip, src, n);
80102034:	8b 45 08             	mov    0x8(%ebp),%eax
80102037:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010203b:	98                   	cwtl   
8010203c:	8b 04 c5 44 12 11 80 	mov    -0x7feeedbc(,%eax,8),%eax
80102043:	8b 55 14             	mov    0x14(%ebp),%edx
80102046:	83 ec 04             	sub    $0x4,%esp
80102049:	52                   	push   %edx
8010204a:	ff 75 0c             	pushl  0xc(%ebp)
8010204d:	ff 75 08             	pushl  0x8(%ebp)
80102050:	ff d0                	call   *%eax
80102052:	83 c4 10             	add    $0x10,%esp
80102055:	e9 1a 01 00 00       	jmp    80102174 <writei+0x189>
  }

  if(off > ip->size || off + n < off)
8010205a:	8b 45 08             	mov    0x8(%ebp),%eax
8010205d:	8b 40 18             	mov    0x18(%eax),%eax
80102060:	3b 45 10             	cmp    0x10(%ebp),%eax
80102063:	72 0d                	jb     80102072 <writei+0x87>
80102065:	8b 55 10             	mov    0x10(%ebp),%edx
80102068:	8b 45 14             	mov    0x14(%ebp),%eax
8010206b:	01 d0                	add    %edx,%eax
8010206d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102070:	73 0a                	jae    8010207c <writei+0x91>
    return -1;
80102072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102077:	e9 f8 00 00 00       	jmp    80102174 <writei+0x189>
  if(off + n > MAXFILE*BSIZE)
8010207c:	8b 55 10             	mov    0x10(%ebp),%edx
8010207f:	8b 45 14             	mov    0x14(%ebp),%eax
80102082:	01 d0                	add    %edx,%eax
80102084:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102089:	76 0a                	jbe    80102095 <writei+0xaa>
    return -1;
8010208b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102090:	e9 df 00 00 00       	jmp    80102174 <writei+0x189>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010209c:	e9 9c 00 00 00       	jmp    8010213d <writei+0x152>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020a1:	8b 45 10             	mov    0x10(%ebp),%eax
801020a4:	c1 e8 09             	shr    $0x9,%eax
801020a7:	83 ec 08             	sub    $0x8,%esp
801020aa:	50                   	push   %eax
801020ab:	ff 75 08             	pushl  0x8(%ebp)
801020ae:	e8 57 fb ff ff       	call   80101c0a <bmap>
801020b3:	83 c4 10             	add    $0x10,%esp
801020b6:	89 c2                	mov    %eax,%edx
801020b8:	8b 45 08             	mov    0x8(%ebp),%eax
801020bb:	8b 00                	mov    (%eax),%eax
801020bd:	83 ec 08             	sub    $0x8,%esp
801020c0:	52                   	push   %edx
801020c1:	50                   	push   %eax
801020c2:	e8 ed e0 ff ff       	call   801001b4 <bread>
801020c7:	83 c4 10             	add    $0x10,%esp
801020ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020cd:	8b 45 10             	mov    0x10(%ebp),%eax
801020d0:	25 ff 01 00 00       	and    $0x1ff,%eax
801020d5:	ba 00 02 00 00       	mov    $0x200,%edx
801020da:	29 c2                	sub    %eax,%edx
801020dc:	8b 45 14             	mov    0x14(%ebp),%eax
801020df:	2b 45 f4             	sub    -0xc(%ebp),%eax
801020e2:	39 c2                	cmp    %eax,%edx
801020e4:	0f 46 c2             	cmovbe %edx,%eax
801020e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801020ea:	8b 45 10             	mov    0x10(%ebp),%eax
801020ed:	25 ff 01 00 00       	and    $0x1ff,%eax
801020f2:	8d 50 10             	lea    0x10(%eax),%edx
801020f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801020f8:	01 d0                	add    %edx,%eax
801020fa:	83 c0 08             	add    $0x8,%eax
801020fd:	83 ec 04             	sub    $0x4,%esp
80102100:	ff 75 ec             	pushl  -0x14(%ebp)
80102103:	ff 75 0c             	pushl  0xc(%ebp)
80102106:	50                   	push   %eax
80102107:	e8 95 31 00 00       	call   801052a1 <memmove>
8010210c:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010210f:	83 ec 0c             	sub    $0xc,%esp
80102112:	ff 75 f0             	pushl  -0x10(%ebp)
80102115:	e8 0a 16 00 00       	call   80103724 <log_write>
8010211a:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010211d:	83 ec 0c             	sub    $0xc,%esp
80102120:	ff 75 f0             	pushl  -0x10(%ebp)
80102123:	e8 03 e1 ff ff       	call   8010022b <brelse>
80102128:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010212b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010212e:	01 45 f4             	add    %eax,-0xc(%ebp)
80102131:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102134:	01 45 10             	add    %eax,0x10(%ebp)
80102137:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010213a:	01 45 0c             	add    %eax,0xc(%ebp)
8010213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102140:	3b 45 14             	cmp    0x14(%ebp),%eax
80102143:	0f 82 58 ff ff ff    	jb     801020a1 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102149:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010214d:	74 22                	je     80102171 <writei+0x186>
8010214f:	8b 45 08             	mov    0x8(%ebp),%eax
80102152:	8b 40 18             	mov    0x18(%eax),%eax
80102155:	3b 45 10             	cmp    0x10(%ebp),%eax
80102158:	73 17                	jae    80102171 <writei+0x186>
    ip->size = off;
8010215a:	8b 45 08             	mov    0x8(%ebp),%eax
8010215d:	8b 55 10             	mov    0x10(%ebp),%edx
80102160:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102163:	83 ec 0c             	sub    $0xc,%esp
80102166:	ff 75 08             	pushl  0x8(%ebp)
80102169:	e8 e2 f5 ff ff       	call   80101750 <iupdate>
8010216e:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102171:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102174:	c9                   	leave  
80102175:	c3                   	ret    

80102176 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102176:	55                   	push   %ebp
80102177:	89 e5                	mov    %esp,%ebp
80102179:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010217c:	83 ec 04             	sub    $0x4,%esp
8010217f:	6a 0e                	push   $0xe
80102181:	ff 75 0c             	pushl  0xc(%ebp)
80102184:	ff 75 08             	pushl  0x8(%ebp)
80102187:	e8 ad 31 00 00       	call   80105339 <strncmp>
8010218c:	83 c4 10             	add    $0x10,%esp
}
8010218f:	c9                   	leave  
80102190:	c3                   	ret    

80102191 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102191:	55                   	push   %ebp
80102192:	89 e5                	mov    %esp,%ebp
80102194:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102197:	8b 45 08             	mov    0x8(%ebp),%eax
8010219a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010219e:	66 83 f8 01          	cmp    $0x1,%ax
801021a2:	74 0d                	je     801021b1 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021a4:	83 ec 0c             	sub    $0xc,%esp
801021a7:	68 0b 86 10 80       	push   $0x8010860b
801021ac:	e8 ab e3 ff ff       	call   8010055c <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801021b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021b8:	eb 7c                	jmp    80102236 <dirlookup+0xa5>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021ba:	6a 10                	push   $0x10
801021bc:	ff 75 f4             	pushl  -0xc(%ebp)
801021bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021c2:	50                   	push   %eax
801021c3:	ff 75 08             	pushl  0x8(%ebp)
801021c6:	e8 c6 fc ff ff       	call   80101e91 <readi>
801021cb:	83 c4 10             	add    $0x10,%esp
801021ce:	83 f8 10             	cmp    $0x10,%eax
801021d1:	74 0d                	je     801021e0 <dirlookup+0x4f>
      panic("dirlink read");
801021d3:	83 ec 0c             	sub    $0xc,%esp
801021d6:	68 1d 86 10 80       	push   $0x8010861d
801021db:	e8 7c e3 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
801021e0:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021e4:	66 85 c0             	test   %ax,%ax
801021e7:	75 02                	jne    801021eb <dirlookup+0x5a>
      continue;
801021e9:	eb 47                	jmp    80102232 <dirlookup+0xa1>
    if(namecmp(name, de.name) == 0){
801021eb:	83 ec 08             	sub    $0x8,%esp
801021ee:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f1:	83 c0 02             	add    $0x2,%eax
801021f4:	50                   	push   %eax
801021f5:	ff 75 0c             	pushl  0xc(%ebp)
801021f8:	e8 79 ff ff ff       	call   80102176 <namecmp>
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 c0                	test   %eax,%eax
80102202:	75 2e                	jne    80102232 <dirlookup+0xa1>
      // entry matches path element
      if(poff)
80102204:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102208:	74 08                	je     80102212 <dirlookup+0x81>
        *poff = off;
8010220a:	8b 45 10             	mov    0x10(%ebp),%eax
8010220d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102210:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102212:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102216:	0f b7 c0             	movzwl %ax,%eax
80102219:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010221c:	8b 45 08             	mov    0x8(%ebp),%eax
8010221f:	8b 00                	mov    (%eax),%eax
80102221:	83 ec 08             	sub    $0x8,%esp
80102224:	ff 75 f0             	pushl  -0x10(%ebp)
80102227:	50                   	push   %eax
80102228:	e8 e3 f5 ff ff       	call   80101810 <iget>
8010222d:	83 c4 10             	add    $0x10,%esp
80102230:	eb 18                	jmp    8010224a <dirlookup+0xb9>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102232:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102236:	8b 45 08             	mov    0x8(%ebp),%eax
80102239:	8b 40 18             	mov    0x18(%eax),%eax
8010223c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010223f:	0f 87 75 ff ff ff    	ja     801021ba <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102245:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010224a:	c9                   	leave  
8010224b:	c3                   	ret    

8010224c <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010224c:	55                   	push   %ebp
8010224d:	89 e5                	mov    %esp,%ebp
8010224f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102252:	83 ec 04             	sub    $0x4,%esp
80102255:	6a 00                	push   $0x0
80102257:	ff 75 0c             	pushl  0xc(%ebp)
8010225a:	ff 75 08             	pushl  0x8(%ebp)
8010225d:	e8 2f ff ff ff       	call   80102191 <dirlookup>
80102262:	83 c4 10             	add    $0x10,%esp
80102265:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102268:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010226c:	74 18                	je     80102286 <dirlink+0x3a>
    iput(ip);
8010226e:	83 ec 0c             	sub    $0xc,%esp
80102271:	ff 75 f0             	pushl  -0x10(%ebp)
80102274:	e8 7e f8 ff ff       	call   80101af7 <iput>
80102279:	83 c4 10             	add    $0x10,%esp
    return -1;
8010227c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102281:	e9 9b 00 00 00       	jmp    80102321 <dirlink+0xd5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102286:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010228d:	eb 3b                	jmp    801022ca <dirlink+0x7e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102292:	6a 10                	push   $0x10
80102294:	50                   	push   %eax
80102295:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102298:	50                   	push   %eax
80102299:	ff 75 08             	pushl  0x8(%ebp)
8010229c:	e8 f0 fb ff ff       	call   80101e91 <readi>
801022a1:	83 c4 10             	add    $0x10,%esp
801022a4:	83 f8 10             	cmp    $0x10,%eax
801022a7:	74 0d                	je     801022b6 <dirlink+0x6a>
      panic("dirlink read");
801022a9:	83 ec 0c             	sub    $0xc,%esp
801022ac:	68 1d 86 10 80       	push   $0x8010861d
801022b1:	e8 a6 e2 ff ff       	call   8010055c <panic>
    if(de.inum == 0)
801022b6:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022ba:	66 85 c0             	test   %ax,%ax
801022bd:	75 02                	jne    801022c1 <dirlink+0x75>
      break;
801022bf:	eb 16                	jmp    801022d7 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c4:	83 c0 10             	add    $0x10,%eax
801022c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801022ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022cd:	8b 45 08             	mov    0x8(%ebp),%eax
801022d0:	8b 40 18             	mov    0x18(%eax),%eax
801022d3:	39 c2                	cmp    %eax,%edx
801022d5:	72 b8                	jb     8010228f <dirlink+0x43>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801022d7:	83 ec 04             	sub    $0x4,%esp
801022da:	6a 0e                	push   $0xe
801022dc:	ff 75 0c             	pushl  0xc(%ebp)
801022df:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022e2:	83 c0 02             	add    $0x2,%eax
801022e5:	50                   	push   %eax
801022e6:	e8 a4 30 00 00       	call   8010538f <strncpy>
801022eb:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801022ee:	8b 45 10             	mov    0x10(%ebp),%eax
801022f1:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f8:	6a 10                	push   $0x10
801022fa:	50                   	push   %eax
801022fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022fe:	50                   	push   %eax
801022ff:	ff 75 08             	pushl  0x8(%ebp)
80102302:	e8 e4 fc ff ff       	call   80101feb <writei>
80102307:	83 c4 10             	add    $0x10,%esp
8010230a:	83 f8 10             	cmp    $0x10,%eax
8010230d:	74 0d                	je     8010231c <dirlink+0xd0>
    panic("dirlink");
8010230f:	83 ec 0c             	sub    $0xc,%esp
80102312:	68 2a 86 10 80       	push   $0x8010862a
80102317:	e8 40 e2 ff ff       	call   8010055c <panic>
  
  return 0;
8010231c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102321:	c9                   	leave  
80102322:	c3                   	ret    

80102323 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102323:	55                   	push   %ebp
80102324:	89 e5                	mov    %esp,%ebp
80102326:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102329:	eb 04                	jmp    8010232f <skipelem+0xc>
    path++;
8010232b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010232f:	8b 45 08             	mov    0x8(%ebp),%eax
80102332:	0f b6 00             	movzbl (%eax),%eax
80102335:	3c 2f                	cmp    $0x2f,%al
80102337:	74 f2                	je     8010232b <skipelem+0x8>
    path++;
  if(*path == 0)
80102339:	8b 45 08             	mov    0x8(%ebp),%eax
8010233c:	0f b6 00             	movzbl (%eax),%eax
8010233f:	84 c0                	test   %al,%al
80102341:	75 07                	jne    8010234a <skipelem+0x27>
    return 0;
80102343:	b8 00 00 00 00       	mov    $0x0,%eax
80102348:	eb 7b                	jmp    801023c5 <skipelem+0xa2>
  s = path;
8010234a:	8b 45 08             	mov    0x8(%ebp),%eax
8010234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102350:	eb 04                	jmp    80102356 <skipelem+0x33>
    path++;
80102352:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102356:	8b 45 08             	mov    0x8(%ebp),%eax
80102359:	0f b6 00             	movzbl (%eax),%eax
8010235c:	3c 2f                	cmp    $0x2f,%al
8010235e:	74 0a                	je     8010236a <skipelem+0x47>
80102360:	8b 45 08             	mov    0x8(%ebp),%eax
80102363:	0f b6 00             	movzbl (%eax),%eax
80102366:	84 c0                	test   %al,%al
80102368:	75 e8                	jne    80102352 <skipelem+0x2f>
    path++;
  len = path - s;
8010236a:	8b 55 08             	mov    0x8(%ebp),%edx
8010236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102370:	29 c2                	sub    %eax,%edx
80102372:	89 d0                	mov    %edx,%eax
80102374:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102377:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010237b:	7e 15                	jle    80102392 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010237d:	83 ec 04             	sub    $0x4,%esp
80102380:	6a 0e                	push   $0xe
80102382:	ff 75 f4             	pushl  -0xc(%ebp)
80102385:	ff 75 0c             	pushl  0xc(%ebp)
80102388:	e8 14 2f 00 00       	call   801052a1 <memmove>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb 20                	jmp    801023b2 <skipelem+0x8f>
  else {
    memmove(name, s, len);
80102392:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102395:	83 ec 04             	sub    $0x4,%esp
80102398:	50                   	push   %eax
80102399:	ff 75 f4             	pushl  -0xc(%ebp)
8010239c:	ff 75 0c             	pushl  0xc(%ebp)
8010239f:	e8 fd 2e 00 00       	call   801052a1 <memmove>
801023a4:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801023ad:	01 d0                	add    %edx,%eax
801023af:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801023b2:	eb 04                	jmp    801023b8 <skipelem+0x95>
    path++;
801023b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801023b8:	8b 45 08             	mov    0x8(%ebp),%eax
801023bb:	0f b6 00             	movzbl (%eax),%eax
801023be:	3c 2f                	cmp    $0x2f,%al
801023c0:	74 f2                	je     801023b4 <skipelem+0x91>
    path++;
  return path;
801023c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
801023c5:	c9                   	leave  
801023c6:	c3                   	ret    

801023c7 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801023c7:	55                   	push   %ebp
801023c8:	89 e5                	mov    %esp,%ebp
801023ca:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801023cd:	8b 45 08             	mov    0x8(%ebp),%eax
801023d0:	0f b6 00             	movzbl (%eax),%eax
801023d3:	3c 2f                	cmp    $0x2f,%al
801023d5:	75 14                	jne    801023eb <namex+0x24>
    ip = iget(ROOTDEV, ROOTINO);
801023d7:	83 ec 08             	sub    $0x8,%esp
801023da:	6a 01                	push   $0x1
801023dc:	6a 01                	push   $0x1
801023de:	e8 2d f4 ff ff       	call   80101810 <iget>
801023e3:	83 c4 10             	add    $0x10,%esp
801023e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023e9:	eb 18                	jmp    80102403 <namex+0x3c>
  else
    ip = idup(proc->cwd);
801023eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801023f1:	8b 40 68             	mov    0x68(%eax),%eax
801023f4:	83 ec 0c             	sub    $0xc,%esp
801023f7:	50                   	push   %eax
801023f8:	e8 f2 f4 ff ff       	call   801018ef <idup>
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102403:	e9 9e 00 00 00       	jmp    801024a6 <namex+0xdf>
    ilock(ip);
80102408:	83 ec 0c             	sub    $0xc,%esp
8010240b:	ff 75 f4             	pushl  -0xc(%ebp)
8010240e:	e8 16 f5 ff ff       	call   80101929 <ilock>
80102413:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
80102416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102419:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010241d:	66 83 f8 01          	cmp    $0x1,%ax
80102421:	74 18                	je     8010243b <namex+0x74>
      iunlockput(ip);
80102423:	83 ec 0c             	sub    $0xc,%esp
80102426:	ff 75 f4             	pushl  -0xc(%ebp)
80102429:	e8 b8 f7 ff ff       	call   80101be6 <iunlockput>
8010242e:	83 c4 10             	add    $0x10,%esp
      return 0;
80102431:	b8 00 00 00 00       	mov    $0x0,%eax
80102436:	e9 a7 00 00 00       	jmp    801024e2 <namex+0x11b>
    }
    if(nameiparent && *path == '\0'){
8010243b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010243f:	74 20                	je     80102461 <namex+0x9a>
80102441:	8b 45 08             	mov    0x8(%ebp),%eax
80102444:	0f b6 00             	movzbl (%eax),%eax
80102447:	84 c0                	test   %al,%al
80102449:	75 16                	jne    80102461 <namex+0x9a>
      // Stop one level early.
      iunlock(ip);
8010244b:	83 ec 0c             	sub    $0xc,%esp
8010244e:	ff 75 f4             	pushl  -0xc(%ebp)
80102451:	e8 30 f6 ff ff       	call   80101a86 <iunlock>
80102456:	83 c4 10             	add    $0x10,%esp
      return ip;
80102459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245c:	e9 81 00 00 00       	jmp    801024e2 <namex+0x11b>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102461:	83 ec 04             	sub    $0x4,%esp
80102464:	6a 00                	push   $0x0
80102466:	ff 75 10             	pushl  0x10(%ebp)
80102469:	ff 75 f4             	pushl  -0xc(%ebp)
8010246c:	e8 20 fd ff ff       	call   80102191 <dirlookup>
80102471:	83 c4 10             	add    $0x10,%esp
80102474:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010247b:	75 15                	jne    80102492 <namex+0xcb>
      iunlockput(ip);
8010247d:	83 ec 0c             	sub    $0xc,%esp
80102480:	ff 75 f4             	pushl  -0xc(%ebp)
80102483:	e8 5e f7 ff ff       	call   80101be6 <iunlockput>
80102488:	83 c4 10             	add    $0x10,%esp
      return 0;
8010248b:	b8 00 00 00 00       	mov    $0x0,%eax
80102490:	eb 50                	jmp    801024e2 <namex+0x11b>
    }
    iunlockput(ip);
80102492:	83 ec 0c             	sub    $0xc,%esp
80102495:	ff 75 f4             	pushl  -0xc(%ebp)
80102498:	e8 49 f7 ff ff       	call   80101be6 <iunlockput>
8010249d:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801024a6:	83 ec 08             	sub    $0x8,%esp
801024a9:	ff 75 10             	pushl  0x10(%ebp)
801024ac:	ff 75 08             	pushl  0x8(%ebp)
801024af:	e8 6f fe ff ff       	call   80102323 <skipelem>
801024b4:	83 c4 10             	add    $0x10,%esp
801024b7:	89 45 08             	mov    %eax,0x8(%ebp)
801024ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024be:	0f 85 44 ff ff ff    	jne    80102408 <namex+0x41>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801024c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801024c8:	74 15                	je     801024df <namex+0x118>
    iput(ip);
801024ca:	83 ec 0c             	sub    $0xc,%esp
801024cd:	ff 75 f4             	pushl  -0xc(%ebp)
801024d0:	e8 22 f6 ff ff       	call   80101af7 <iput>
801024d5:	83 c4 10             	add    $0x10,%esp
    return 0;
801024d8:	b8 00 00 00 00       	mov    $0x0,%eax
801024dd:	eb 03                	jmp    801024e2 <namex+0x11b>
  }
  return ip;
801024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801024e2:	c9                   	leave  
801024e3:	c3                   	ret    

801024e4 <namei>:

struct inode*
namei(char *path)
{
801024e4:	55                   	push   %ebp
801024e5:	89 e5                	mov    %esp,%ebp
801024e7:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801024ea:	83 ec 04             	sub    $0x4,%esp
801024ed:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024f0:	50                   	push   %eax
801024f1:	6a 00                	push   $0x0
801024f3:	ff 75 08             	pushl  0x8(%ebp)
801024f6:	e8 cc fe ff ff       	call   801023c7 <namex>
801024fb:	83 c4 10             	add    $0x10,%esp
}
801024fe:	c9                   	leave  
801024ff:	c3                   	ret    

80102500 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80102506:	83 ec 04             	sub    $0x4,%esp
80102509:	ff 75 0c             	pushl  0xc(%ebp)
8010250c:	6a 01                	push   $0x1
8010250e:	ff 75 08             	pushl  0x8(%ebp)
80102511:	e8 b1 fe ff ff       	call   801023c7 <namex>
80102516:	83 c4 10             	add    $0x10,%esp
}
80102519:	c9                   	leave  
8010251a:	c3                   	ret    

8010251b <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
8010251b:	55                   	push   %ebp
8010251c:	89 e5                	mov    %esp,%ebp
8010251e:	83 ec 14             	sub    $0x14,%esp
80102521:	8b 45 08             	mov    0x8(%ebp),%eax
80102524:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102528:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010252c:	89 c2                	mov    %eax,%edx
8010252e:	ec                   	in     (%dx),%al
8010252f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102532:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102536:	c9                   	leave  
80102537:	c3                   	ret    

80102538 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102538:	55                   	push   %ebp
80102539:	89 e5                	mov    %esp,%ebp
8010253b:	57                   	push   %edi
8010253c:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010253d:	8b 55 08             	mov    0x8(%ebp),%edx
80102540:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102543:	8b 45 10             	mov    0x10(%ebp),%eax
80102546:	89 cb                	mov    %ecx,%ebx
80102548:	89 df                	mov    %ebx,%edi
8010254a:	89 c1                	mov    %eax,%ecx
8010254c:	fc                   	cld    
8010254d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010254f:	89 c8                	mov    %ecx,%eax
80102551:	89 fb                	mov    %edi,%ebx
80102553:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102556:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102559:	5b                   	pop    %ebx
8010255a:	5f                   	pop    %edi
8010255b:	5d                   	pop    %ebp
8010255c:	c3                   	ret    

8010255d <outb>:

static inline void
outb(ushort port, uchar data)
{
8010255d:	55                   	push   %ebp
8010255e:	89 e5                	mov    %esp,%ebp
80102560:	83 ec 08             	sub    $0x8,%esp
80102563:	8b 55 08             	mov    0x8(%ebp),%edx
80102566:	8b 45 0c             	mov    0xc(%ebp),%eax
80102569:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010256d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102570:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102574:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102578:	ee                   	out    %al,(%dx)
}
80102579:	c9                   	leave  
8010257a:	c3                   	ret    

8010257b <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010257b:	55                   	push   %ebp
8010257c:	89 e5                	mov    %esp,%ebp
8010257e:	56                   	push   %esi
8010257f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102580:	8b 55 08             	mov    0x8(%ebp),%edx
80102583:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102586:	8b 45 10             	mov    0x10(%ebp),%eax
80102589:	89 cb                	mov    %ecx,%ebx
8010258b:	89 de                	mov    %ebx,%esi
8010258d:	89 c1                	mov    %eax,%ecx
8010258f:	fc                   	cld    
80102590:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102592:	89 c8                	mov    %ecx,%eax
80102594:	89 f3                	mov    %esi,%ebx
80102596:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102599:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
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
801025ac:	e8 6a ff ff ff       	call   8010251b <inb>
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
801025ee:	68 32 86 10 80       	push   $0x80108632
801025f3:	68 20 b6 10 80       	push   $0x8010b620
801025f8:	e8 68 29 00 00       	call   80104f65 <initlock>
801025fd:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102600:	83 ec 0c             	sub    $0xc,%esp
80102603:	6a 0e                	push   $0xe
80102605:	e8 b7 18 00 00       	call   80103ec1 <picenable>
8010260a:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
8010260d:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80102612:	83 e8 01             	sub    $0x1,%eax
80102615:	83 ec 08             	sub    $0x8,%esp
80102618:	50                   	push   %eax
80102619:	6a 0e                	push   $0xe
8010261b:	e8 6d 04 00 00       	call   80102a8d <ioapicenable>
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
8010263d:	e8 1b ff ff ff       	call   8010255d <outb>
80102642:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102645:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010264c:	eb 24                	jmp    80102672 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
8010264e:	83 ec 0c             	sub    $0xc,%esp
80102651:	68 f7 01 00 00       	push   $0x1f7
80102656:	e8 c0 fe ff ff       	call   8010251b <inb>
8010265b:	83 c4 10             	add    $0x10,%esp
8010265e:	84 c0                	test   %al,%al
80102660:	74 0c                	je     8010266e <ideinit+0x89>
      havedisk1 = 1;
80102662:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
80102669:	00 00 00 
      break;
8010266c:	eb 0d                	jmp    8010267b <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
8010266e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102672:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102679:	7e d3                	jle    8010264e <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
8010267b:	83 ec 08             	sub    $0x8,%esp
8010267e:	68 e0 00 00 00       	push   $0xe0
80102683:	68 f6 01 00 00       	push   $0x1f6
80102688:	e8 d0 fe ff ff       	call   8010255d <outb>
8010268d:	83 c4 10             	add    $0x10,%esp
}
80102690:	c9                   	leave  
80102691:	c3                   	ret    

80102692 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102692:	55                   	push   %ebp
80102693:	89 e5                	mov    %esp,%ebp
80102695:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102698:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010269c:	75 0d                	jne    801026ab <idestart+0x19>
    panic("idestart");
8010269e:	83 ec 0c             	sub    $0xc,%esp
801026a1:	68 36 86 10 80       	push   $0x80108636
801026a6:	e8 b1 de ff ff       	call   8010055c <panic>
  if(b->blockno >= FSSIZE)
801026ab:	8b 45 08             	mov    0x8(%ebp),%eax
801026ae:	8b 40 08             	mov    0x8(%eax),%eax
801026b1:	3d e7 03 00 00       	cmp    $0x3e7,%eax
801026b6:	76 0d                	jbe    801026c5 <idestart+0x33>
    panic("incorrect blockno");
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	68 3f 86 10 80       	push   $0x8010863f
801026c0:	e8 97 de ff ff       	call   8010055c <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801026c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801026cc:	8b 45 08             	mov    0x8(%ebp),%eax
801026cf:	8b 50 08             	mov    0x8(%eax),%edx
801026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026d5:	0f af c2             	imul   %edx,%eax
801026d8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026db:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026df:	7e 0d                	jle    801026ee <idestart+0x5c>
801026e1:	83 ec 0c             	sub    $0xc,%esp
801026e4:	68 36 86 10 80       	push   $0x80108636
801026e9:	e8 6e de ff ff       	call   8010055c <panic>
  
  idewait(0);
801026ee:	83 ec 0c             	sub    $0xc,%esp
801026f1:	6a 00                	push   $0x0
801026f3:	e8 a8 fe ff ff       	call   801025a0 <idewait>
801026f8:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801026fb:	83 ec 08             	sub    $0x8,%esp
801026fe:	6a 00                	push   $0x0
80102700:	68 f6 03 00 00       	push   $0x3f6
80102705:	e8 53 fe ff ff       	call   8010255d <outb>
8010270a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
8010270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102710:	0f b6 c0             	movzbl %al,%eax
80102713:	83 ec 08             	sub    $0x8,%esp
80102716:	50                   	push   %eax
80102717:	68 f2 01 00 00       	push   $0x1f2
8010271c:	e8 3c fe ff ff       	call   8010255d <outb>
80102721:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102724:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102727:	0f b6 c0             	movzbl %al,%eax
8010272a:	83 ec 08             	sub    $0x8,%esp
8010272d:	50                   	push   %eax
8010272e:	68 f3 01 00 00       	push   $0x1f3
80102733:	e8 25 fe ff ff       	call   8010255d <outb>
80102738:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
8010273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010273e:	c1 f8 08             	sar    $0x8,%eax
80102741:	0f b6 c0             	movzbl %al,%eax
80102744:	83 ec 08             	sub    $0x8,%esp
80102747:	50                   	push   %eax
80102748:	68 f4 01 00 00       	push   $0x1f4
8010274d:	e8 0b fe ff ff       	call   8010255d <outb>
80102752:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102758:	c1 f8 10             	sar    $0x10,%eax
8010275b:	0f b6 c0             	movzbl %al,%eax
8010275e:	83 ec 08             	sub    $0x8,%esp
80102761:	50                   	push   %eax
80102762:	68 f5 01 00 00       	push   $0x1f5
80102767:	e8 f1 fd ff ff       	call   8010255d <outb>
8010276c:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010276f:	8b 45 08             	mov    0x8(%ebp),%eax
80102772:	8b 40 04             	mov    0x4(%eax),%eax
80102775:	83 e0 01             	and    $0x1,%eax
80102778:	c1 e0 04             	shl    $0x4,%eax
8010277b:	89 c2                	mov    %eax,%edx
8010277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102780:	c1 f8 18             	sar    $0x18,%eax
80102783:	83 e0 0f             	and    $0xf,%eax
80102786:	09 d0                	or     %edx,%eax
80102788:	83 c8 e0             	or     $0xffffffe0,%eax
8010278b:	0f b6 c0             	movzbl %al,%eax
8010278e:	83 ec 08             	sub    $0x8,%esp
80102791:	50                   	push   %eax
80102792:	68 f6 01 00 00       	push   $0x1f6
80102797:	e8 c1 fd ff ff       	call   8010255d <outb>
8010279c:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
8010279f:	8b 45 08             	mov    0x8(%ebp),%eax
801027a2:	8b 00                	mov    (%eax),%eax
801027a4:	83 e0 04             	and    $0x4,%eax
801027a7:	85 c0                	test   %eax,%eax
801027a9:	74 30                	je     801027db <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801027ab:	83 ec 08             	sub    $0x8,%esp
801027ae:	6a 30                	push   $0x30
801027b0:	68 f7 01 00 00       	push   $0x1f7
801027b5:	e8 a3 fd ff ff       	call   8010255d <outb>
801027ba:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801027bd:	8b 45 08             	mov    0x8(%ebp),%eax
801027c0:	83 c0 18             	add    $0x18,%eax
801027c3:	83 ec 04             	sub    $0x4,%esp
801027c6:	68 80 00 00 00       	push   $0x80
801027cb:	50                   	push   %eax
801027cc:	68 f0 01 00 00       	push   $0x1f0
801027d1:	e8 a5 fd ff ff       	call   8010257b <outsl>
801027d6:	83 c4 10             	add    $0x10,%esp
801027d9:	eb 12                	jmp    801027ed <idestart+0x15b>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801027db:	83 ec 08             	sub    $0x8,%esp
801027de:	6a 20                	push   $0x20
801027e0:	68 f7 01 00 00       	push   $0x1f7
801027e5:	e8 73 fd ff ff       	call   8010255d <outb>
801027ea:	83 c4 10             	add    $0x10,%esp
  }
}
801027ed:	c9                   	leave  
801027ee:	c3                   	ret    

801027ef <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027ef:	55                   	push   %ebp
801027f0:	89 e5                	mov    %esp,%ebp
801027f2:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027f5:	83 ec 0c             	sub    $0xc,%esp
801027f8:	68 20 b6 10 80       	push   $0x8010b620
801027fd:	e8 84 27 00 00       	call   80104f86 <acquire>
80102802:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102805:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010280a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102811:	75 15                	jne    80102828 <ideintr+0x39>
    release(&idelock);
80102813:	83 ec 0c             	sub    $0xc,%esp
80102816:	68 20 b6 10 80       	push   $0x8010b620
8010281b:	e8 cc 27 00 00       	call   80104fec <release>
80102820:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102823:	e9 9a 00 00 00       	jmp    801028c2 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282b:	8b 40 14             	mov    0x14(%eax),%eax
8010282e:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	8b 00                	mov    (%eax),%eax
80102838:	83 e0 04             	and    $0x4,%eax
8010283b:	85 c0                	test   %eax,%eax
8010283d:	75 2d                	jne    8010286c <ideintr+0x7d>
8010283f:	83 ec 0c             	sub    $0xc,%esp
80102842:	6a 01                	push   $0x1
80102844:	e8 57 fd ff ff       	call   801025a0 <idewait>
80102849:	83 c4 10             	add    $0x10,%esp
8010284c:	85 c0                	test   %eax,%eax
8010284e:	78 1c                	js     8010286c <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102853:	83 c0 18             	add    $0x18,%eax
80102856:	83 ec 04             	sub    $0x4,%esp
80102859:	68 80 00 00 00       	push   $0x80
8010285e:	50                   	push   %eax
8010285f:	68 f0 01 00 00       	push   $0x1f0
80102864:	e8 cf fc ff ff       	call   80102538 <insl>
80102869:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010286f:	8b 00                	mov    (%eax),%eax
80102871:	83 c8 02             	or     $0x2,%eax
80102874:	89 c2                	mov    %eax,%edx
80102876:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102879:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010287e:	8b 00                	mov    (%eax),%eax
80102880:	83 e0 fb             	and    $0xfffffffb,%eax
80102883:	89 c2                	mov    %eax,%edx
80102885:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102888:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010288a:	83 ec 0c             	sub    $0xc,%esp
8010288d:	ff 75 f4             	pushl  -0xc(%ebp)
80102890:	e8 ea 24 00 00       	call   80104d7f <wakeup>
80102895:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102898:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010289d:	85 c0                	test   %eax,%eax
8010289f:	74 11                	je     801028b2 <ideintr+0xc3>
    idestart(idequeue);
801028a1:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801028a6:	83 ec 0c             	sub    $0xc,%esp
801028a9:	50                   	push   %eax
801028aa:	e8 e3 fd ff ff       	call   80102692 <idestart>
801028af:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801028b2:	83 ec 0c             	sub    $0xc,%esp
801028b5:	68 20 b6 10 80       	push   $0x8010b620
801028ba:	e8 2d 27 00 00       	call   80104fec <release>
801028bf:	83 c4 10             	add    $0x10,%esp
}
801028c2:	c9                   	leave  
801028c3:	c3                   	ret    

801028c4 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801028c4:	55                   	push   %ebp
801028c5:	89 e5                	mov    %esp,%ebp
801028c7:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801028ca:	8b 45 08             	mov    0x8(%ebp),%eax
801028cd:	8b 00                	mov    (%eax),%eax
801028cf:	83 e0 01             	and    $0x1,%eax
801028d2:	85 c0                	test   %eax,%eax
801028d4:	75 0d                	jne    801028e3 <iderw+0x1f>
    panic("iderw: buf not busy");
801028d6:	83 ec 0c             	sub    $0xc,%esp
801028d9:	68 51 86 10 80       	push   $0x80108651
801028de:	e8 79 dc ff ff       	call   8010055c <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028e3:	8b 45 08             	mov    0x8(%ebp),%eax
801028e6:	8b 00                	mov    (%eax),%eax
801028e8:	83 e0 06             	and    $0x6,%eax
801028eb:	83 f8 02             	cmp    $0x2,%eax
801028ee:	75 0d                	jne    801028fd <iderw+0x39>
    panic("iderw: nothing to do");
801028f0:	83 ec 0c             	sub    $0xc,%esp
801028f3:	68 65 86 10 80       	push   $0x80108665
801028f8:	e8 5f dc ff ff       	call   8010055c <panic>
  if(b->dev != 0 && !havedisk1)
801028fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102900:	8b 40 04             	mov    0x4(%eax),%eax
80102903:	85 c0                	test   %eax,%eax
80102905:	74 16                	je     8010291d <iderw+0x59>
80102907:	a1 58 b6 10 80       	mov    0x8010b658,%eax
8010290c:	85 c0                	test   %eax,%eax
8010290e:	75 0d                	jne    8010291d <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102910:	83 ec 0c             	sub    $0xc,%esp
80102913:	68 7a 86 10 80       	push   $0x8010867a
80102918:	e8 3f dc ff ff       	call   8010055c <panic>

  acquire(&idelock);  //DOC:acquire-lock
8010291d:	83 ec 0c             	sub    $0xc,%esp
80102920:	68 20 b6 10 80       	push   $0x8010b620
80102925:	e8 5c 26 00 00       	call   80104f86 <acquire>
8010292a:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
8010292d:	8b 45 08             	mov    0x8(%ebp),%eax
80102930:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102937:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
8010293e:	eb 0b                	jmp    8010294b <iderw+0x87>
80102940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102943:	8b 00                	mov    (%eax),%eax
80102945:	83 c0 14             	add    $0x14,%eax
80102948:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294e:	8b 00                	mov    (%eax),%eax
80102950:	85 c0                	test   %eax,%eax
80102952:	75 ec                	jne    80102940 <iderw+0x7c>
    ;
  *pp = b;
80102954:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102957:	8b 55 08             	mov    0x8(%ebp),%edx
8010295a:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010295c:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102961:	3b 45 08             	cmp    0x8(%ebp),%eax
80102964:	75 0e                	jne    80102974 <iderw+0xb0>
    idestart(b);
80102966:	83 ec 0c             	sub    $0xc,%esp
80102969:	ff 75 08             	pushl  0x8(%ebp)
8010296c:	e8 21 fd ff ff       	call   80102692 <idestart>
80102971:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102974:	eb 13                	jmp    80102989 <iderw+0xc5>
    sleep(b, &idelock);
80102976:	83 ec 08             	sub    $0x8,%esp
80102979:	68 20 b6 10 80       	push   $0x8010b620
8010297e:	ff 75 08             	pushl  0x8(%ebp)
80102981:	e8 10 23 00 00       	call   80104c96 <sleep>
80102986:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102989:	8b 45 08             	mov    0x8(%ebp),%eax
8010298c:	8b 00                	mov    (%eax),%eax
8010298e:	83 e0 06             	and    $0x6,%eax
80102991:	83 f8 02             	cmp    $0x2,%eax
80102994:	75 e0                	jne    80102976 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102996:	83 ec 0c             	sub    $0xc,%esp
80102999:	68 20 b6 10 80       	push   $0x8010b620
8010299e:	e8 49 26 00 00       	call   80104fec <release>
801029a3:	83 c4 10             	add    $0x10,%esp
}
801029a6:	c9                   	leave  
801029a7:	c3                   	ret    

801029a8 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801029a8:	55                   	push   %ebp
801029a9:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029ab:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029b0:	8b 55 08             	mov    0x8(%ebp),%edx
801029b3:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801029b5:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029ba:	8b 40 10             	mov    0x10(%eax),%eax
}
801029bd:	5d                   	pop    %ebp
801029be:	c3                   	ret    

801029bf <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801029bf:	55                   	push   %ebp
801029c0:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801029c2:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029c7:	8b 55 08             	mov    0x8(%ebp),%edx
801029ca:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801029cc:	a1 d4 22 11 80       	mov    0x801122d4,%eax
801029d1:	8b 55 0c             	mov    0xc(%ebp),%edx
801029d4:	89 50 10             	mov    %edx,0x10(%eax)
}
801029d7:	5d                   	pop    %ebp
801029d8:	c3                   	ret    

801029d9 <ioapicinit>:

void
ioapicinit(void)
{
801029d9:	55                   	push   %ebp
801029da:	89 e5                	mov    %esp,%ebp
801029dc:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
801029df:	a1 44 24 11 80       	mov    0x80112444,%eax
801029e4:	85 c0                	test   %eax,%eax
801029e6:	75 05                	jne    801029ed <ioapicinit+0x14>
    return;
801029e8:	e9 9e 00 00 00       	jmp    80102a8b <ioapicinit+0xb2>

  ioapic = (volatile struct ioapic*)IOAPIC;
801029ed:	c7 05 d4 22 11 80 00 	movl   $0xfec00000,0x801122d4
801029f4:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029f7:	6a 01                	push   $0x1
801029f9:	e8 aa ff ff ff       	call   801029a8 <ioapicread>
801029fe:	83 c4 04             	add    $0x4,%esp
80102a01:	c1 e8 10             	shr    $0x10,%eax
80102a04:	25 ff 00 00 00       	and    $0xff,%eax
80102a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a0c:	6a 00                	push   $0x0
80102a0e:	e8 95 ff ff ff       	call   801029a8 <ioapicread>
80102a13:	83 c4 04             	add    $0x4,%esp
80102a16:	c1 e8 18             	shr    $0x18,%eax
80102a19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a1c:	0f b6 05 40 24 11 80 	movzbl 0x80112440,%eax
80102a23:	0f b6 c0             	movzbl %al,%eax
80102a26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102a29:	74 10                	je     80102a3b <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a2b:	83 ec 0c             	sub    $0xc,%esp
80102a2e:	68 98 86 10 80       	push   $0x80108698
80102a33:	e8 87 d9 ff ff       	call   801003bf <cprintf>
80102a38:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a42:	eb 3f                	jmp    80102a83 <ioapicinit+0xaa>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a47:	83 c0 20             	add    $0x20,%eax
80102a4a:	0d 00 00 01 00       	or     $0x10000,%eax
80102a4f:	89 c2                	mov    %eax,%edx
80102a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a54:	83 c0 08             	add    $0x8,%eax
80102a57:	01 c0                	add    %eax,%eax
80102a59:	83 ec 08             	sub    $0x8,%esp
80102a5c:	52                   	push   %edx
80102a5d:	50                   	push   %eax
80102a5e:	e8 5c ff ff ff       	call   801029bf <ioapicwrite>
80102a63:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a69:	83 c0 08             	add    $0x8,%eax
80102a6c:	01 c0                	add    %eax,%eax
80102a6e:	83 c0 01             	add    $0x1,%eax
80102a71:	83 ec 08             	sub    $0x8,%esp
80102a74:	6a 00                	push   $0x0
80102a76:	50                   	push   %eax
80102a77:	e8 43 ff ff ff       	call   801029bf <ioapicwrite>
80102a7c:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a86:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a89:	7e b9                	jle    80102a44 <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a8b:	c9                   	leave  
80102a8c:	c3                   	ret    

80102a8d <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a8d:	55                   	push   %ebp
80102a8e:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102a90:	a1 44 24 11 80       	mov    0x80112444,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	75 02                	jne    80102a9b <ioapicenable+0xe>
    return;
80102a99:	eb 37                	jmp    80102ad2 <ioapicenable+0x45>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9e:	83 c0 20             	add    $0x20,%eax
80102aa1:	89 c2                	mov    %eax,%edx
80102aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa6:	83 c0 08             	add    $0x8,%eax
80102aa9:	01 c0                	add    %eax,%eax
80102aab:	52                   	push   %edx
80102aac:	50                   	push   %eax
80102aad:	e8 0d ff ff ff       	call   801029bf <ioapicwrite>
80102ab2:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ab8:	c1 e0 18             	shl    $0x18,%eax
80102abb:	89 c2                	mov    %eax,%edx
80102abd:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac0:	83 c0 08             	add    $0x8,%eax
80102ac3:	01 c0                	add    %eax,%eax
80102ac5:	83 c0 01             	add    $0x1,%eax
80102ac8:	52                   	push   %edx
80102ac9:	50                   	push   %eax
80102aca:	e8 f0 fe ff ff       	call   801029bf <ioapicwrite>
80102acf:	83 c4 08             	add    $0x8,%esp
}
80102ad2:	c9                   	leave  
80102ad3:	c3                   	ret    

80102ad4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102ad4:	55                   	push   %ebp
80102ad5:	89 e5                	mov    %esp,%ebp
80102ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80102ada:	05 00 00 00 80       	add    $0x80000000,%eax
80102adf:	5d                   	pop    %ebp
80102ae0:	c3                   	ret    

80102ae1 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102ae1:	55                   	push   %ebp
80102ae2:	89 e5                	mov    %esp,%ebp
80102ae4:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102ae7:	83 ec 08             	sub    $0x8,%esp
80102aea:	68 ca 86 10 80       	push   $0x801086ca
80102aef:	68 e0 22 11 80       	push   $0x801122e0
80102af4:	e8 6c 24 00 00       	call   80104f65 <initlock>
80102af9:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102afc:	c7 05 14 23 11 80 00 	movl   $0x0,0x80112314
80102b03:	00 00 00 
  freerange(vstart, vend);
80102b06:	83 ec 08             	sub    $0x8,%esp
80102b09:	ff 75 0c             	pushl  0xc(%ebp)
80102b0c:	ff 75 08             	pushl  0x8(%ebp)
80102b0f:	e8 28 00 00 00       	call   80102b3c <freerange>
80102b14:	83 c4 10             	add    $0x10,%esp
}
80102b17:	c9                   	leave  
80102b18:	c3                   	ret    

80102b19 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b19:	55                   	push   %ebp
80102b1a:	89 e5                	mov    %esp,%ebp
80102b1c:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b1f:	83 ec 08             	sub    $0x8,%esp
80102b22:	ff 75 0c             	pushl  0xc(%ebp)
80102b25:	ff 75 08             	pushl  0x8(%ebp)
80102b28:	e8 0f 00 00 00       	call   80102b3c <freerange>
80102b2d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b30:	c7 05 14 23 11 80 01 	movl   $0x1,0x80112314
80102b37:	00 00 00 
}
80102b3a:	c9                   	leave  
80102b3b:	c3                   	ret    

80102b3c <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b3c:	55                   	push   %ebp
80102b3d:	89 e5                	mov    %esp,%ebp
80102b3f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102b42:	8b 45 08             	mov    0x8(%ebp),%eax
80102b45:	05 ff 0f 00 00       	add    $0xfff,%eax
80102b4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b52:	eb 15                	jmp    80102b69 <freerange+0x2d>
    kfree(p);
80102b54:	83 ec 0c             	sub    $0xc,%esp
80102b57:	ff 75 f4             	pushl  -0xc(%ebp)
80102b5a:	e8 19 00 00 00       	call   80102b78 <kfree>
80102b5f:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b6c:	05 00 10 00 00       	add    $0x1000,%eax
80102b71:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b74:	76 de                	jbe    80102b54 <freerange+0x18>
    kfree(p);
}
80102b76:	c9                   	leave  
80102b77:	c3                   	ret    

80102b78 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b78:	55                   	push   %ebp
80102b79:	89 e5                	mov    %esp,%ebp
80102b7b:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102b7e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b81:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b86:	85 c0                	test   %eax,%eax
80102b88:	75 1b                	jne    80102ba5 <kfree+0x2d>
80102b8a:	81 7d 08 5c 52 11 80 	cmpl   $0x8011525c,0x8(%ebp)
80102b91:	72 12                	jb     80102ba5 <kfree+0x2d>
80102b93:	ff 75 08             	pushl  0x8(%ebp)
80102b96:	e8 39 ff ff ff       	call   80102ad4 <v2p>
80102b9b:	83 c4 04             	add    $0x4,%esp
80102b9e:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ba3:	76 0d                	jbe    80102bb2 <kfree+0x3a>
    panic("kfree");
80102ba5:	83 ec 0c             	sub    $0xc,%esp
80102ba8:	68 cf 86 10 80       	push   $0x801086cf
80102bad:	e8 aa d9 ff ff       	call   8010055c <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102bb2:	83 ec 04             	sub    $0x4,%esp
80102bb5:	68 00 10 00 00       	push   $0x1000
80102bba:	6a 01                	push   $0x1
80102bbc:	ff 75 08             	pushl  0x8(%ebp)
80102bbf:	e8 1e 26 00 00       	call   801051e2 <memset>
80102bc4:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102bc7:	a1 14 23 11 80       	mov    0x80112314,%eax
80102bcc:	85 c0                	test   %eax,%eax
80102bce:	74 10                	je     80102be0 <kfree+0x68>
    acquire(&kmem.lock);
80102bd0:	83 ec 0c             	sub    $0xc,%esp
80102bd3:	68 e0 22 11 80       	push   $0x801122e0
80102bd8:	e8 a9 23 00 00       	call   80104f86 <acquire>
80102bdd:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102be0:	8b 45 08             	mov    0x8(%ebp),%eax
80102be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102be6:	8b 15 18 23 11 80    	mov    0x80112318,%edx
80102bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bef:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf4:	a3 18 23 11 80       	mov    %eax,0x80112318
  if(kmem.use_lock)
80102bf9:	a1 14 23 11 80       	mov    0x80112314,%eax
80102bfe:	85 c0                	test   %eax,%eax
80102c00:	74 10                	je     80102c12 <kfree+0x9a>
    release(&kmem.lock);
80102c02:	83 ec 0c             	sub    $0xc,%esp
80102c05:	68 e0 22 11 80       	push   $0x801122e0
80102c0a:	e8 dd 23 00 00       	call   80104fec <release>
80102c0f:	83 c4 10             	add    $0x10,%esp
}
80102c12:	c9                   	leave  
80102c13:	c3                   	ret    

80102c14 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c14:	55                   	push   %ebp
80102c15:	89 e5                	mov    %esp,%ebp
80102c17:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c1a:	a1 14 23 11 80       	mov    0x80112314,%eax
80102c1f:	85 c0                	test   %eax,%eax
80102c21:	74 10                	je     80102c33 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c23:	83 ec 0c             	sub    $0xc,%esp
80102c26:	68 e0 22 11 80       	push   $0x801122e0
80102c2b:	e8 56 23 00 00       	call   80104f86 <acquire>
80102c30:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102c33:	a1 18 23 11 80       	mov    0x80112318,%eax
80102c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102c3f:	74 0a                	je     80102c4b <kalloc+0x37>
    kmem.freelist = r->next;
80102c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c44:	8b 00                	mov    (%eax),%eax
80102c46:	a3 18 23 11 80       	mov    %eax,0x80112318
  if(kmem.use_lock)
80102c4b:	a1 14 23 11 80       	mov    0x80112314,%eax
80102c50:	85 c0                	test   %eax,%eax
80102c52:	74 10                	je     80102c64 <kalloc+0x50>
    release(&kmem.lock);
80102c54:	83 ec 0c             	sub    $0xc,%esp
80102c57:	68 e0 22 11 80       	push   $0x801122e0
80102c5c:	e8 8b 23 00 00       	call   80104fec <release>
80102c61:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102c67:	c9                   	leave  
80102c68:	c3                   	ret    

80102c69 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102c69:	55                   	push   %ebp
80102c6a:	89 e5                	mov    %esp,%ebp
80102c6c:	83 ec 14             	sub    $0x14,%esp
80102c6f:	8b 45 08             	mov    0x8(%ebp),%eax
80102c72:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c76:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c7a:	89 c2                	mov    %eax,%edx
80102c7c:	ec                   	in     (%dx),%al
80102c7d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c80:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c84:	c9                   	leave  
80102c85:	c3                   	ret    

80102c86 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c86:	55                   	push   %ebp
80102c87:	89 e5                	mov    %esp,%ebp
80102c89:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c8c:	6a 64                	push   $0x64
80102c8e:	e8 d6 ff ff ff       	call   80102c69 <inb>
80102c93:	83 c4 04             	add    $0x4,%esp
80102c96:	0f b6 c0             	movzbl %al,%eax
80102c99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c9f:	83 e0 01             	and    $0x1,%eax
80102ca2:	85 c0                	test   %eax,%eax
80102ca4:	75 0a                	jne    80102cb0 <kbdgetc+0x2a>
    return -1;
80102ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cab:	e9 23 01 00 00       	jmp    80102dd3 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102cb0:	6a 60                	push   $0x60
80102cb2:	e8 b2 ff ff ff       	call   80102c69 <inb>
80102cb7:	83 c4 04             	add    $0x4,%esp
80102cba:	0f b6 c0             	movzbl %al,%eax
80102cbd:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102cc0:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102cc7:	75 17                	jne    80102ce0 <kbdgetc+0x5a>
    shift |= E0ESC;
80102cc9:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cce:	83 c8 40             	or     $0x40,%eax
80102cd1:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102cd6:	b8 00 00 00 00       	mov    $0x0,%eax
80102cdb:	e9 f3 00 00 00       	jmp    80102dd3 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ce3:	25 80 00 00 00       	and    $0x80,%eax
80102ce8:	85 c0                	test   %eax,%eax
80102cea:	74 45                	je     80102d31 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102cec:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cf1:	83 e0 40             	and    $0x40,%eax
80102cf4:	85 c0                	test   %eax,%eax
80102cf6:	75 08                	jne    80102d00 <kbdgetc+0x7a>
80102cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cfb:	83 e0 7f             	and    $0x7f,%eax
80102cfe:	eb 03                	jmp    80102d03 <kbdgetc+0x7d>
80102d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d09:	05 40 90 10 80       	add    $0x80109040,%eax
80102d0e:	0f b6 00             	movzbl (%eax),%eax
80102d11:	83 c8 40             	or     $0x40,%eax
80102d14:	0f b6 c0             	movzbl %al,%eax
80102d17:	f7 d0                	not    %eax
80102d19:	89 c2                	mov    %eax,%edx
80102d1b:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d20:	21 d0                	and    %edx,%eax
80102d22:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102d27:	b8 00 00 00 00       	mov    $0x0,%eax
80102d2c:	e9 a2 00 00 00       	jmp    80102dd3 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102d31:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d36:	83 e0 40             	and    $0x40,%eax
80102d39:	85 c0                	test   %eax,%eax
80102d3b:	74 14                	je     80102d51 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102d3d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102d44:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d49:	83 e0 bf             	and    $0xffffffbf,%eax
80102d4c:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d54:	05 40 90 10 80       	add    $0x80109040,%eax
80102d59:	0f b6 00             	movzbl (%eax),%eax
80102d5c:	0f b6 d0             	movzbl %al,%edx
80102d5f:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d64:	09 d0                	or     %edx,%eax
80102d66:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d6e:	05 40 91 10 80       	add    $0x80109140,%eax
80102d73:	0f b6 00             	movzbl (%eax),%eax
80102d76:	0f b6 d0             	movzbl %al,%edx
80102d79:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d7e:	31 d0                	xor    %edx,%eax
80102d80:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d85:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d8a:	83 e0 03             	and    $0x3,%eax
80102d8d:	8b 14 85 40 95 10 80 	mov    -0x7fef6ac0(,%eax,4),%edx
80102d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d97:	01 d0                	add    %edx,%eax
80102d99:	0f b6 00             	movzbl (%eax),%eax
80102d9c:	0f b6 c0             	movzbl %al,%eax
80102d9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102da2:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102da7:	83 e0 08             	and    $0x8,%eax
80102daa:	85 c0                	test   %eax,%eax
80102dac:	74 22                	je     80102dd0 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102dae:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102db2:	76 0c                	jbe    80102dc0 <kbdgetc+0x13a>
80102db4:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102db8:	77 06                	ja     80102dc0 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102dba:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102dbe:	eb 10                	jmp    80102dd0 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102dc0:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102dc4:	76 0a                	jbe    80102dd0 <kbdgetc+0x14a>
80102dc6:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102dca:	77 04                	ja     80102dd0 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102dcc:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102dd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102dd3:	c9                   	leave  
80102dd4:	c3                   	ret    

80102dd5 <kbdintr>:

void
kbdintr(void)
{
80102dd5:	55                   	push   %ebp
80102dd6:	89 e5                	mov    %esp,%ebp
80102dd8:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ddb:	83 ec 0c             	sub    $0xc,%esp
80102dde:	68 86 2c 10 80       	push   $0x80102c86
80102de3:	e8 e9 d9 ff ff       	call   801007d1 <consoleintr>
80102de8:	83 c4 10             	add    $0x10,%esp
}
80102deb:	c9                   	leave  
80102dec:	c3                   	ret    

80102ded <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102ded:	55                   	push   %ebp
80102dee:	89 e5                	mov    %esp,%ebp
80102df0:	83 ec 14             	sub    $0x14,%esp
80102df3:	8b 45 08             	mov    0x8(%ebp),%eax
80102df6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dfa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102dfe:	89 c2                	mov    %eax,%edx
80102e00:	ec                   	in     (%dx),%al
80102e01:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e04:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e08:	c9                   	leave  
80102e09:	c3                   	ret    

80102e0a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102e0a:	55                   	push   %ebp
80102e0b:	89 e5                	mov    %esp,%ebp
80102e0d:	83 ec 08             	sub    $0x8,%esp
80102e10:	8b 55 08             	mov    0x8(%ebp),%edx
80102e13:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e16:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102e1a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e1d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102e21:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102e25:	ee                   	out    %al,(%dx)
}
80102e26:	c9                   	leave  
80102e27:	c3                   	ret    

80102e28 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102e28:	55                   	push   %ebp
80102e29:	89 e5                	mov    %esp,%ebp
80102e2b:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102e2e:	9c                   	pushf  
80102e2f:	58                   	pop    %eax
80102e30:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102e36:	c9                   	leave  
80102e37:	c3                   	ret    

80102e38 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102e38:	55                   	push   %ebp
80102e39:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102e3b:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102e40:	8b 55 08             	mov    0x8(%ebp),%edx
80102e43:	c1 e2 02             	shl    $0x2,%edx
80102e46:	01 c2                	add    %eax,%edx
80102e48:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e4b:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102e4d:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102e52:	83 c0 20             	add    $0x20,%eax
80102e55:	8b 00                	mov    (%eax),%eax
}
80102e57:	5d                   	pop    %ebp
80102e58:	c3                   	ret    

80102e59 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102e59:	55                   	push   %ebp
80102e5a:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102e5c:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102e61:	85 c0                	test   %eax,%eax
80102e63:	75 05                	jne    80102e6a <lapicinit+0x11>
    return;
80102e65:	e9 09 01 00 00       	jmp    80102f73 <lapicinit+0x11a>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102e6a:	68 3f 01 00 00       	push   $0x13f
80102e6f:	6a 3c                	push   $0x3c
80102e71:	e8 c2 ff ff ff       	call   80102e38 <lapicw>
80102e76:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102e79:	6a 0b                	push   $0xb
80102e7b:	68 f8 00 00 00       	push   $0xf8
80102e80:	e8 b3 ff ff ff       	call   80102e38 <lapicw>
80102e85:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e88:	68 20 00 02 00       	push   $0x20020
80102e8d:	68 c8 00 00 00       	push   $0xc8
80102e92:	e8 a1 ff ff ff       	call   80102e38 <lapicw>
80102e97:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102e9a:	68 80 96 98 00       	push   $0x989680
80102e9f:	68 e0 00 00 00       	push   $0xe0
80102ea4:	e8 8f ff ff ff       	call   80102e38 <lapicw>
80102ea9:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102eac:	68 00 00 01 00       	push   $0x10000
80102eb1:	68 d4 00 00 00       	push   $0xd4
80102eb6:	e8 7d ff ff ff       	call   80102e38 <lapicw>
80102ebb:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102ebe:	68 00 00 01 00       	push   $0x10000
80102ec3:	68 d8 00 00 00       	push   $0xd8
80102ec8:	e8 6b ff ff ff       	call   80102e38 <lapicw>
80102ecd:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ed0:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102ed5:	83 c0 30             	add    $0x30,%eax
80102ed8:	8b 00                	mov    (%eax),%eax
80102eda:	c1 e8 10             	shr    $0x10,%eax
80102edd:	0f b6 c0             	movzbl %al,%eax
80102ee0:	83 f8 03             	cmp    $0x3,%eax
80102ee3:	76 12                	jbe    80102ef7 <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102ee5:	68 00 00 01 00       	push   $0x10000
80102eea:	68 d0 00 00 00       	push   $0xd0
80102eef:	e8 44 ff ff ff       	call   80102e38 <lapicw>
80102ef4:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ef7:	6a 33                	push   $0x33
80102ef9:	68 dc 00 00 00       	push   $0xdc
80102efe:	e8 35 ff ff ff       	call   80102e38 <lapicw>
80102f03:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f06:	6a 00                	push   $0x0
80102f08:	68 a0 00 00 00       	push   $0xa0
80102f0d:	e8 26 ff ff ff       	call   80102e38 <lapicw>
80102f12:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f15:	6a 00                	push   $0x0
80102f17:	68 a0 00 00 00       	push   $0xa0
80102f1c:	e8 17 ff ff ff       	call   80102e38 <lapicw>
80102f21:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102f24:	6a 00                	push   $0x0
80102f26:	6a 2c                	push   $0x2c
80102f28:	e8 0b ff ff ff       	call   80102e38 <lapicw>
80102f2d:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102f30:	6a 00                	push   $0x0
80102f32:	68 c4 00 00 00       	push   $0xc4
80102f37:	e8 fc fe ff ff       	call   80102e38 <lapicw>
80102f3c:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102f3f:	68 00 85 08 00       	push   $0x88500
80102f44:	68 c0 00 00 00       	push   $0xc0
80102f49:	e8 ea fe ff ff       	call   80102e38 <lapicw>
80102f4e:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102f51:	90                   	nop
80102f52:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102f57:	05 00 03 00 00       	add    $0x300,%eax
80102f5c:	8b 00                	mov    (%eax),%eax
80102f5e:	25 00 10 00 00       	and    $0x1000,%eax
80102f63:	85 c0                	test   %eax,%eax
80102f65:	75 eb                	jne    80102f52 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f67:	6a 00                	push   $0x0
80102f69:	6a 20                	push   $0x20
80102f6b:	e8 c8 fe ff ff       	call   80102e38 <lapicw>
80102f70:	83 c4 08             	add    $0x8,%esp
}
80102f73:	c9                   	leave  
80102f74:	c3                   	ret    

80102f75 <cpunum>:

int
cpunum(void)
{
80102f75:	55                   	push   %ebp
80102f76:	89 e5                	mov    %esp,%ebp
80102f78:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102f7b:	e8 a8 fe ff ff       	call   80102e28 <readeflags>
80102f80:	25 00 02 00 00       	and    $0x200,%eax
80102f85:	85 c0                	test   %eax,%eax
80102f87:	74 26                	je     80102faf <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80102f89:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102f8e:	8d 50 01             	lea    0x1(%eax),%edx
80102f91:	89 15 60 b6 10 80    	mov    %edx,0x8010b660
80102f97:	85 c0                	test   %eax,%eax
80102f99:	75 14                	jne    80102faf <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80102f9b:	8b 45 04             	mov    0x4(%ebp),%eax
80102f9e:	83 ec 08             	sub    $0x8,%esp
80102fa1:	50                   	push   %eax
80102fa2:	68 d8 86 10 80       	push   $0x801086d8
80102fa7:	e8 13 d4 ff ff       	call   801003bf <cprintf>
80102fac:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80102faf:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102fb4:	85 c0                	test   %eax,%eax
80102fb6:	74 0f                	je     80102fc7 <cpunum+0x52>
    return lapic[ID]>>24;
80102fb8:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102fbd:	83 c0 20             	add    $0x20,%eax
80102fc0:	8b 00                	mov    (%eax),%eax
80102fc2:	c1 e8 18             	shr    $0x18,%eax
80102fc5:	eb 05                	jmp    80102fcc <cpunum+0x57>
  return 0;
80102fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102fcc:	c9                   	leave  
80102fcd:	c3                   	ret    

80102fce <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102fce:	55                   	push   %ebp
80102fcf:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fd1:	a1 1c 23 11 80       	mov    0x8011231c,%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	74 0c                	je     80102fe6 <lapiceoi+0x18>
    lapicw(EOI, 0);
80102fda:	6a 00                	push   $0x0
80102fdc:	6a 2c                	push   $0x2c
80102fde:	e8 55 fe ff ff       	call   80102e38 <lapicw>
80102fe3:	83 c4 08             	add    $0x8,%esp
}
80102fe6:	c9                   	leave  
80102fe7:	c3                   	ret    

80102fe8 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fe8:	55                   	push   %ebp
80102fe9:	89 e5                	mov    %esp,%ebp
}
80102feb:	5d                   	pop    %ebp
80102fec:	c3                   	ret    

80102fed <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fed:	55                   	push   %ebp
80102fee:	89 e5                	mov    %esp,%ebp
80102ff0:	83 ec 14             	sub    $0x14,%esp
80102ff3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ff6:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102ff9:	6a 0f                	push   $0xf
80102ffb:	6a 70                	push   $0x70
80102ffd:	e8 08 fe ff ff       	call   80102e0a <outb>
80103002:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103005:	6a 0a                	push   $0xa
80103007:	6a 71                	push   $0x71
80103009:	e8 fc fd ff ff       	call   80102e0a <outb>
8010300e:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103011:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103018:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010301b:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103020:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103023:	83 c0 02             	add    $0x2,%eax
80103026:	8b 55 0c             	mov    0xc(%ebp),%edx
80103029:	c1 ea 04             	shr    $0x4,%edx
8010302c:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
8010302f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103033:	c1 e0 18             	shl    $0x18,%eax
80103036:	50                   	push   %eax
80103037:	68 c4 00 00 00       	push   $0xc4
8010303c:	e8 f7 fd ff ff       	call   80102e38 <lapicw>
80103041:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80103044:	68 00 c5 00 00       	push   $0xc500
80103049:	68 c0 00 00 00       	push   $0xc0
8010304e:	e8 e5 fd ff ff       	call   80102e38 <lapicw>
80103053:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103056:	68 c8 00 00 00       	push   $0xc8
8010305b:	e8 88 ff ff ff       	call   80102fe8 <microdelay>
80103060:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
80103063:	68 00 85 00 00       	push   $0x8500
80103068:	68 c0 00 00 00       	push   $0xc0
8010306d:	e8 c6 fd ff ff       	call   80102e38 <lapicw>
80103072:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103075:	6a 64                	push   $0x64
80103077:	e8 6c ff ff ff       	call   80102fe8 <microdelay>
8010307c:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010307f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103086:	eb 3d                	jmp    801030c5 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103088:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010308c:	c1 e0 18             	shl    $0x18,%eax
8010308f:	50                   	push   %eax
80103090:	68 c4 00 00 00       	push   $0xc4
80103095:	e8 9e fd ff ff       	call   80102e38 <lapicw>
8010309a:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010309d:	8b 45 0c             	mov    0xc(%ebp),%eax
801030a0:	c1 e8 0c             	shr    $0xc,%eax
801030a3:	80 cc 06             	or     $0x6,%ah
801030a6:	50                   	push   %eax
801030a7:	68 c0 00 00 00       	push   $0xc0
801030ac:	e8 87 fd ff ff       	call   80102e38 <lapicw>
801030b1:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801030b4:	68 c8 00 00 00       	push   $0xc8
801030b9:	e8 2a ff ff ff       	call   80102fe8 <microdelay>
801030be:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801030c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801030c5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801030c9:	7e bd                	jle    80103088 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801030cb:	c9                   	leave  
801030cc:	c3                   	ret    

801030cd <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801030cd:	55                   	push   %ebp
801030ce:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801030d0:	8b 45 08             	mov    0x8(%ebp),%eax
801030d3:	0f b6 c0             	movzbl %al,%eax
801030d6:	50                   	push   %eax
801030d7:	6a 70                	push   $0x70
801030d9:	e8 2c fd ff ff       	call   80102e0a <outb>
801030de:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030e1:	68 c8 00 00 00       	push   $0xc8
801030e6:	e8 fd fe ff ff       	call   80102fe8 <microdelay>
801030eb:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801030ee:	6a 71                	push   $0x71
801030f0:	e8 f8 fc ff ff       	call   80102ded <inb>
801030f5:	83 c4 04             	add    $0x4,%esp
801030f8:	0f b6 c0             	movzbl %al,%eax
}
801030fb:	c9                   	leave  
801030fc:	c3                   	ret    

801030fd <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801030fd:	55                   	push   %ebp
801030fe:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103100:	6a 00                	push   $0x0
80103102:	e8 c6 ff ff ff       	call   801030cd <cmos_read>
80103107:	83 c4 04             	add    $0x4,%esp
8010310a:	89 c2                	mov    %eax,%edx
8010310c:	8b 45 08             	mov    0x8(%ebp),%eax
8010310f:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103111:	6a 02                	push   $0x2
80103113:	e8 b5 ff ff ff       	call   801030cd <cmos_read>
80103118:	83 c4 04             	add    $0x4,%esp
8010311b:	89 c2                	mov    %eax,%edx
8010311d:	8b 45 08             	mov    0x8(%ebp),%eax
80103120:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
80103123:	6a 04                	push   $0x4
80103125:	e8 a3 ff ff ff       	call   801030cd <cmos_read>
8010312a:	83 c4 04             	add    $0x4,%esp
8010312d:	89 c2                	mov    %eax,%edx
8010312f:	8b 45 08             	mov    0x8(%ebp),%eax
80103132:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103135:	6a 07                	push   $0x7
80103137:	e8 91 ff ff ff       	call   801030cd <cmos_read>
8010313c:	83 c4 04             	add    $0x4,%esp
8010313f:	89 c2                	mov    %eax,%edx
80103141:	8b 45 08             	mov    0x8(%ebp),%eax
80103144:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103147:	6a 08                	push   $0x8
80103149:	e8 7f ff ff ff       	call   801030cd <cmos_read>
8010314e:	83 c4 04             	add    $0x4,%esp
80103151:	89 c2                	mov    %eax,%edx
80103153:	8b 45 08             	mov    0x8(%ebp),%eax
80103156:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103159:	6a 09                	push   $0x9
8010315b:	e8 6d ff ff ff       	call   801030cd <cmos_read>
80103160:	83 c4 04             	add    $0x4,%esp
80103163:	89 c2                	mov    %eax,%edx
80103165:	8b 45 08             	mov    0x8(%ebp),%eax
80103168:	89 50 14             	mov    %edx,0x14(%eax)
}
8010316b:	c9                   	leave  
8010316c:	c3                   	ret    

8010316d <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010316d:	55                   	push   %ebp
8010316e:	89 e5                	mov    %esp,%ebp
80103170:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103173:	6a 0b                	push   $0xb
80103175:	e8 53 ff ff ff       	call   801030cd <cmos_read>
8010317a:	83 c4 04             	add    $0x4,%esp
8010317d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103183:	83 e0 04             	and    $0x4,%eax
80103186:	85 c0                	test   %eax,%eax
80103188:	0f 94 c0             	sete   %al
8010318b:	0f b6 c0             	movzbl %al,%eax
8010318e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103191:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103194:	50                   	push   %eax
80103195:	e8 63 ff ff ff       	call   801030fd <fill_rtcdate>
8010319a:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010319d:	6a 0a                	push   $0xa
8010319f:	e8 29 ff ff ff       	call   801030cd <cmos_read>
801031a4:	83 c4 04             	add    $0x4,%esp
801031a7:	25 80 00 00 00       	and    $0x80,%eax
801031ac:	85 c0                	test   %eax,%eax
801031ae:	74 02                	je     801031b2 <cmostime+0x45>
        continue;
801031b0:	eb 32                	jmp    801031e4 <cmostime+0x77>
    fill_rtcdate(&t2);
801031b2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031b5:	50                   	push   %eax
801031b6:	e8 42 ff ff ff       	call   801030fd <fill_rtcdate>
801031bb:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801031be:	83 ec 04             	sub    $0x4,%esp
801031c1:	6a 18                	push   $0x18
801031c3:	8d 45 c0             	lea    -0x40(%ebp),%eax
801031c6:	50                   	push   %eax
801031c7:	8d 45 d8             	lea    -0x28(%ebp),%eax
801031ca:	50                   	push   %eax
801031cb:	e8 79 20 00 00       	call   80105249 <memcmp>
801031d0:	83 c4 10             	add    $0x10,%esp
801031d3:	85 c0                	test   %eax,%eax
801031d5:	75 0d                	jne    801031e4 <cmostime+0x77>
      break;
801031d7:	90                   	nop
  }

  // convert
  if (bcd) {
801031d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801031dc:	0f 84 b8 00 00 00    	je     8010329a <cmostime+0x12d>
801031e2:	eb 02                	jmp    801031e6 <cmostime+0x79>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801031e4:	eb ab                	jmp    80103191 <cmostime+0x24>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031e9:	c1 e8 04             	shr    $0x4,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	89 d0                	mov    %edx,%eax
801031f0:	c1 e0 02             	shl    $0x2,%eax
801031f3:	01 d0                	add    %edx,%eax
801031f5:	01 c0                	add    %eax,%eax
801031f7:	89 c2                	mov    %eax,%edx
801031f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031fc:	83 e0 0f             	and    $0xf,%eax
801031ff:	01 d0                	add    %edx,%eax
80103201:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103204:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103207:	c1 e8 04             	shr    $0x4,%eax
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	89 d0                	mov    %edx,%eax
8010320e:	c1 e0 02             	shl    $0x2,%eax
80103211:	01 d0                	add    %edx,%eax
80103213:	01 c0                	add    %eax,%eax
80103215:	89 c2                	mov    %eax,%edx
80103217:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010321a:	83 e0 0f             	and    $0xf,%eax
8010321d:	01 d0                	add    %edx,%eax
8010321f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103222:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103225:	c1 e8 04             	shr    $0x4,%eax
80103228:	89 c2                	mov    %eax,%edx
8010322a:	89 d0                	mov    %edx,%eax
8010322c:	c1 e0 02             	shl    $0x2,%eax
8010322f:	01 d0                	add    %edx,%eax
80103231:	01 c0                	add    %eax,%eax
80103233:	89 c2                	mov    %eax,%edx
80103235:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103238:	83 e0 0f             	and    $0xf,%eax
8010323b:	01 d0                	add    %edx,%eax
8010323d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103243:	c1 e8 04             	shr    $0x4,%eax
80103246:	89 c2                	mov    %eax,%edx
80103248:	89 d0                	mov    %edx,%eax
8010324a:	c1 e0 02             	shl    $0x2,%eax
8010324d:	01 d0                	add    %edx,%eax
8010324f:	01 c0                	add    %eax,%eax
80103251:	89 c2                	mov    %eax,%edx
80103253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103256:	83 e0 0f             	and    $0xf,%eax
80103259:	01 d0                	add    %edx,%eax
8010325b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
8010325e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103261:	c1 e8 04             	shr    $0x4,%eax
80103264:	89 c2                	mov    %eax,%edx
80103266:	89 d0                	mov    %edx,%eax
80103268:	c1 e0 02             	shl    $0x2,%eax
8010326b:	01 d0                	add    %edx,%eax
8010326d:	01 c0                	add    %eax,%eax
8010326f:	89 c2                	mov    %eax,%edx
80103271:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103274:	83 e0 0f             	and    $0xf,%eax
80103277:	01 d0                	add    %edx,%eax
80103279:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010327c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010327f:	c1 e8 04             	shr    $0x4,%eax
80103282:	89 c2                	mov    %eax,%edx
80103284:	89 d0                	mov    %edx,%eax
80103286:	c1 e0 02             	shl    $0x2,%eax
80103289:	01 d0                	add    %edx,%eax
8010328b:	01 c0                	add    %eax,%eax
8010328d:	89 c2                	mov    %eax,%edx
8010328f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103292:	83 e0 0f             	and    $0xf,%eax
80103295:	01 d0                	add    %edx,%eax
80103297:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010329a:	8b 45 08             	mov    0x8(%ebp),%eax
8010329d:	8b 55 d8             	mov    -0x28(%ebp),%edx
801032a0:	89 10                	mov    %edx,(%eax)
801032a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801032a5:	89 50 04             	mov    %edx,0x4(%eax)
801032a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
801032ab:	89 50 08             	mov    %edx,0x8(%eax)
801032ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032b1:	89 50 0c             	mov    %edx,0xc(%eax)
801032b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
801032b7:	89 50 10             	mov    %edx,0x10(%eax)
801032ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
801032bd:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801032c0:	8b 45 08             	mov    0x8(%ebp),%eax
801032c3:	8b 40 14             	mov    0x14(%eax),%eax
801032c6:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801032cc:	8b 45 08             	mov    0x8(%ebp),%eax
801032cf:	89 50 14             	mov    %edx,0x14(%eax)
}
801032d2:	c9                   	leave  
801032d3:	c3                   	ret    

801032d4 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801032d4:	55                   	push   %ebp
801032d5:	89 e5                	mov    %esp,%ebp
801032d7:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801032da:	83 ec 08             	sub    $0x8,%esp
801032dd:	68 04 87 10 80       	push   $0x80108704
801032e2:	68 40 23 11 80       	push   $0x80112340
801032e7:	e8 79 1c 00 00       	call   80104f65 <initlock>
801032ec:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801032ef:	83 ec 08             	sub    $0x8,%esp
801032f2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032f5:	50                   	push   %eax
801032f6:	ff 75 08             	pushl  0x8(%ebp)
801032f9:	e8 4c e0 ff ff       	call   8010134a <readsb>
801032fe:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103301:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103304:	a3 74 23 11 80       	mov    %eax,0x80112374
  log.size = sb.nlog;
80103309:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010330c:	a3 78 23 11 80       	mov    %eax,0x80112378
  log.dev = dev;
80103311:	8b 45 08             	mov    0x8(%ebp),%eax
80103314:	a3 84 23 11 80       	mov    %eax,0x80112384
  recover_from_log();
80103319:	e8 ae 01 00 00       	call   801034cc <recover_from_log>
}
8010331e:	c9                   	leave  
8010331f:	c3                   	ret    

80103320 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010332d:	e9 95 00 00 00       	jmp    801033c7 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103332:	8b 15 74 23 11 80    	mov    0x80112374,%edx
80103338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010333b:	01 d0                	add    %edx,%eax
8010333d:	83 c0 01             	add    $0x1,%eax
80103340:	89 c2                	mov    %eax,%edx
80103342:	a1 84 23 11 80       	mov    0x80112384,%eax
80103347:	83 ec 08             	sub    $0x8,%esp
8010334a:	52                   	push   %edx
8010334b:	50                   	push   %eax
8010334c:	e8 63 ce ff ff       	call   801001b4 <bread>
80103351:	83 c4 10             	add    $0x10,%esp
80103354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103357:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010335a:	83 c0 10             	add    $0x10,%eax
8010335d:	8b 04 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%eax
80103364:	89 c2                	mov    %eax,%edx
80103366:	a1 84 23 11 80       	mov    0x80112384,%eax
8010336b:	83 ec 08             	sub    $0x8,%esp
8010336e:	52                   	push   %edx
8010336f:	50                   	push   %eax
80103370:	e8 3f ce ff ff       	call   801001b4 <bread>
80103375:	83 c4 10             	add    $0x10,%esp
80103378:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010337e:	8d 50 18             	lea    0x18(%eax),%edx
80103381:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103384:	83 c0 18             	add    $0x18,%eax
80103387:	83 ec 04             	sub    $0x4,%esp
8010338a:	68 00 02 00 00       	push   $0x200
8010338f:	52                   	push   %edx
80103390:	50                   	push   %eax
80103391:	e8 0b 1f 00 00       	call   801052a1 <memmove>
80103396:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103399:	83 ec 0c             	sub    $0xc,%esp
8010339c:	ff 75 ec             	pushl  -0x14(%ebp)
8010339f:	e8 49 ce ff ff       	call   801001ed <bwrite>
801033a4:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801033a7:	83 ec 0c             	sub    $0xc,%esp
801033aa:	ff 75 f0             	pushl  -0x10(%ebp)
801033ad:	e8 79 ce ff ff       	call   8010022b <brelse>
801033b2:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801033b5:	83 ec 0c             	sub    $0xc,%esp
801033b8:	ff 75 ec             	pushl  -0x14(%ebp)
801033bb:	e8 6b ce ff ff       	call   8010022b <brelse>
801033c0:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033c3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033c7:	a1 88 23 11 80       	mov    0x80112388,%eax
801033cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033cf:	0f 8f 5d ff ff ff    	jg     80103332 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801033d5:	c9                   	leave  
801033d6:	c3                   	ret    

801033d7 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801033d7:	55                   	push   %ebp
801033d8:	89 e5                	mov    %esp,%ebp
801033da:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801033dd:	a1 74 23 11 80       	mov    0x80112374,%eax
801033e2:	89 c2                	mov    %eax,%edx
801033e4:	a1 84 23 11 80       	mov    0x80112384,%eax
801033e9:	83 ec 08             	sub    $0x8,%esp
801033ec:	52                   	push   %edx
801033ed:	50                   	push   %eax
801033ee:	e8 c1 cd ff ff       	call   801001b4 <bread>
801033f3:	83 c4 10             	add    $0x10,%esp
801033f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801033f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033fc:	83 c0 18             	add    $0x18,%eax
801033ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103402:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103405:	8b 00                	mov    (%eax),%eax
80103407:	a3 88 23 11 80       	mov    %eax,0x80112388
  for (i = 0; i < log.lh.n; i++) {
8010340c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103413:	eb 1b                	jmp    80103430 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103415:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103418:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010341b:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010341f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103422:	83 c2 10             	add    $0x10,%edx
80103425:	89 04 95 4c 23 11 80 	mov    %eax,-0x7feedcb4(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010342c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103430:	a1 88 23 11 80       	mov    0x80112388,%eax
80103435:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103438:	7f db                	jg     80103415 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
8010343a:	83 ec 0c             	sub    $0xc,%esp
8010343d:	ff 75 f0             	pushl  -0x10(%ebp)
80103440:	e8 e6 cd ff ff       	call   8010022b <brelse>
80103445:	83 c4 10             	add    $0x10,%esp
}
80103448:	c9                   	leave  
80103449:	c3                   	ret    

8010344a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010344a:	55                   	push   %ebp
8010344b:	89 e5                	mov    %esp,%ebp
8010344d:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103450:	a1 74 23 11 80       	mov    0x80112374,%eax
80103455:	89 c2                	mov    %eax,%edx
80103457:	a1 84 23 11 80       	mov    0x80112384,%eax
8010345c:	83 ec 08             	sub    $0x8,%esp
8010345f:	52                   	push   %edx
80103460:	50                   	push   %eax
80103461:	e8 4e cd ff ff       	call   801001b4 <bread>
80103466:	83 c4 10             	add    $0x10,%esp
80103469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010346c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010346f:	83 c0 18             	add    $0x18,%eax
80103472:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103475:	8b 15 88 23 11 80    	mov    0x80112388,%edx
8010347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347e:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103480:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103487:	eb 1b                	jmp    801034a4 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010348c:	83 c0 10             	add    $0x10,%eax
8010348f:	8b 0c 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%ecx
80103496:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103499:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010349c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801034a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034a4:	a1 88 23 11 80       	mov    0x80112388,%eax
801034a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034ac:	7f db                	jg     80103489 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801034ae:	83 ec 0c             	sub    $0xc,%esp
801034b1:	ff 75 f0             	pushl  -0x10(%ebp)
801034b4:	e8 34 cd ff ff       	call   801001ed <bwrite>
801034b9:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801034bc:	83 ec 0c             	sub    $0xc,%esp
801034bf:	ff 75 f0             	pushl  -0x10(%ebp)
801034c2:	e8 64 cd ff ff       	call   8010022b <brelse>
801034c7:	83 c4 10             	add    $0x10,%esp
}
801034ca:	c9                   	leave  
801034cb:	c3                   	ret    

801034cc <recover_from_log>:

static void
recover_from_log(void)
{
801034cc:	55                   	push   %ebp
801034cd:	89 e5                	mov    %esp,%ebp
801034cf:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801034d2:	e8 00 ff ff ff       	call   801033d7 <read_head>
  install_trans(); // if committed, copy from log to disk
801034d7:	e8 44 fe ff ff       	call   80103320 <install_trans>
  log.lh.n = 0;
801034dc:	c7 05 88 23 11 80 00 	movl   $0x0,0x80112388
801034e3:	00 00 00 
  write_head(); // clear the log
801034e6:	e8 5f ff ff ff       	call   8010344a <write_head>
}
801034eb:	c9                   	leave  
801034ec:	c3                   	ret    

801034ed <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801034ed:	55                   	push   %ebp
801034ee:	89 e5                	mov    %esp,%ebp
801034f0:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801034f3:	83 ec 0c             	sub    $0xc,%esp
801034f6:	68 40 23 11 80       	push   $0x80112340
801034fb:	e8 86 1a 00 00       	call   80104f86 <acquire>
80103500:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103503:	a1 80 23 11 80       	mov    0x80112380,%eax
80103508:	85 c0                	test   %eax,%eax
8010350a:	74 17                	je     80103523 <begin_op+0x36>
      sleep(&log, &log.lock);
8010350c:	83 ec 08             	sub    $0x8,%esp
8010350f:	68 40 23 11 80       	push   $0x80112340
80103514:	68 40 23 11 80       	push   $0x80112340
80103519:	e8 78 17 00 00       	call   80104c96 <sleep>
8010351e:	83 c4 10             	add    $0x10,%esp
80103521:	eb 54                	jmp    80103577 <begin_op+0x8a>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103523:	8b 0d 88 23 11 80    	mov    0x80112388,%ecx
80103529:	a1 7c 23 11 80       	mov    0x8011237c,%eax
8010352e:	8d 50 01             	lea    0x1(%eax),%edx
80103531:	89 d0                	mov    %edx,%eax
80103533:	c1 e0 02             	shl    $0x2,%eax
80103536:	01 d0                	add    %edx,%eax
80103538:	01 c0                	add    %eax,%eax
8010353a:	01 c8                	add    %ecx,%eax
8010353c:	83 f8 1e             	cmp    $0x1e,%eax
8010353f:	7e 17                	jle    80103558 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103541:	83 ec 08             	sub    $0x8,%esp
80103544:	68 40 23 11 80       	push   $0x80112340
80103549:	68 40 23 11 80       	push   $0x80112340
8010354e:	e8 43 17 00 00       	call   80104c96 <sleep>
80103553:	83 c4 10             	add    $0x10,%esp
80103556:	eb 1f                	jmp    80103577 <begin_op+0x8a>
    } else {
      log.outstanding += 1;
80103558:	a1 7c 23 11 80       	mov    0x8011237c,%eax
8010355d:	83 c0 01             	add    $0x1,%eax
80103560:	a3 7c 23 11 80       	mov    %eax,0x8011237c
      release(&log.lock);
80103565:	83 ec 0c             	sub    $0xc,%esp
80103568:	68 40 23 11 80       	push   $0x80112340
8010356d:	e8 7a 1a 00 00       	call   80104fec <release>
80103572:	83 c4 10             	add    $0x10,%esp
      break;
80103575:	eb 02                	jmp    80103579 <begin_op+0x8c>
    }
  }
80103577:	eb 8a                	jmp    80103503 <begin_op+0x16>
}
80103579:	c9                   	leave  
8010357a:	c3                   	ret    

8010357b <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010357b:	55                   	push   %ebp
8010357c:	89 e5                	mov    %esp,%ebp
8010357e:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103581:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103588:	83 ec 0c             	sub    $0xc,%esp
8010358b:	68 40 23 11 80       	push   $0x80112340
80103590:	e8 f1 19 00 00       	call   80104f86 <acquire>
80103595:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103598:	a1 7c 23 11 80       	mov    0x8011237c,%eax
8010359d:	83 e8 01             	sub    $0x1,%eax
801035a0:	a3 7c 23 11 80       	mov    %eax,0x8011237c
  if(log.committing)
801035a5:	a1 80 23 11 80       	mov    0x80112380,%eax
801035aa:	85 c0                	test   %eax,%eax
801035ac:	74 0d                	je     801035bb <end_op+0x40>
    panic("log.committing");
801035ae:	83 ec 0c             	sub    $0xc,%esp
801035b1:	68 08 87 10 80       	push   $0x80108708
801035b6:	e8 a1 cf ff ff       	call   8010055c <panic>
  if(log.outstanding == 0){
801035bb:	a1 7c 23 11 80       	mov    0x8011237c,%eax
801035c0:	85 c0                	test   %eax,%eax
801035c2:	75 13                	jne    801035d7 <end_op+0x5c>
    do_commit = 1;
801035c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801035cb:	c7 05 80 23 11 80 01 	movl   $0x1,0x80112380
801035d2:	00 00 00 
801035d5:	eb 10                	jmp    801035e7 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801035d7:	83 ec 0c             	sub    $0xc,%esp
801035da:	68 40 23 11 80       	push   $0x80112340
801035df:	e8 9b 17 00 00       	call   80104d7f <wakeup>
801035e4:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801035e7:	83 ec 0c             	sub    $0xc,%esp
801035ea:	68 40 23 11 80       	push   $0x80112340
801035ef:	e8 f8 19 00 00       	call   80104fec <release>
801035f4:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801035f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801035fb:	74 3f                	je     8010363c <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801035fd:	e8 f3 00 00 00       	call   801036f5 <commit>
    acquire(&log.lock);
80103602:	83 ec 0c             	sub    $0xc,%esp
80103605:	68 40 23 11 80       	push   $0x80112340
8010360a:	e8 77 19 00 00       	call   80104f86 <acquire>
8010360f:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103612:	c7 05 80 23 11 80 00 	movl   $0x0,0x80112380
80103619:	00 00 00 
    wakeup(&log);
8010361c:	83 ec 0c             	sub    $0xc,%esp
8010361f:	68 40 23 11 80       	push   $0x80112340
80103624:	e8 56 17 00 00       	call   80104d7f <wakeup>
80103629:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010362c:	83 ec 0c             	sub    $0xc,%esp
8010362f:	68 40 23 11 80       	push   $0x80112340
80103634:	e8 b3 19 00 00       	call   80104fec <release>
80103639:	83 c4 10             	add    $0x10,%esp
  }
}
8010363c:	c9                   	leave  
8010363d:	c3                   	ret    

8010363e <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010363e:	55                   	push   %ebp
8010363f:	89 e5                	mov    %esp,%ebp
80103641:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103644:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010364b:	e9 95 00 00 00       	jmp    801036e5 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103650:	8b 15 74 23 11 80    	mov    0x80112374,%edx
80103656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103659:	01 d0                	add    %edx,%eax
8010365b:	83 c0 01             	add    $0x1,%eax
8010365e:	89 c2                	mov    %eax,%edx
80103660:	a1 84 23 11 80       	mov    0x80112384,%eax
80103665:	83 ec 08             	sub    $0x8,%esp
80103668:	52                   	push   %edx
80103669:	50                   	push   %eax
8010366a:	e8 45 cb ff ff       	call   801001b4 <bread>
8010366f:	83 c4 10             	add    $0x10,%esp
80103672:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103675:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103678:	83 c0 10             	add    $0x10,%eax
8010367b:	8b 04 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%eax
80103682:	89 c2                	mov    %eax,%edx
80103684:	a1 84 23 11 80       	mov    0x80112384,%eax
80103689:	83 ec 08             	sub    $0x8,%esp
8010368c:	52                   	push   %edx
8010368d:	50                   	push   %eax
8010368e:	e8 21 cb ff ff       	call   801001b4 <bread>
80103693:	83 c4 10             	add    $0x10,%esp
80103696:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103699:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010369c:	8d 50 18             	lea    0x18(%eax),%edx
8010369f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036a2:	83 c0 18             	add    $0x18,%eax
801036a5:	83 ec 04             	sub    $0x4,%esp
801036a8:	68 00 02 00 00       	push   $0x200
801036ad:	52                   	push   %edx
801036ae:	50                   	push   %eax
801036af:	e8 ed 1b 00 00       	call   801052a1 <memmove>
801036b4:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801036b7:	83 ec 0c             	sub    $0xc,%esp
801036ba:	ff 75 f0             	pushl  -0x10(%ebp)
801036bd:	e8 2b cb ff ff       	call   801001ed <bwrite>
801036c2:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801036c5:	83 ec 0c             	sub    $0xc,%esp
801036c8:	ff 75 ec             	pushl  -0x14(%ebp)
801036cb:	e8 5b cb ff ff       	call   8010022b <brelse>
801036d0:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	ff 75 f0             	pushl  -0x10(%ebp)
801036d9:	e8 4d cb ff ff       	call   8010022b <brelse>
801036de:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036e5:	a1 88 23 11 80       	mov    0x80112388,%eax
801036ea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036ed:	0f 8f 5d ff ff ff    	jg     80103650 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801036f3:	c9                   	leave  
801036f4:	c3                   	ret    

801036f5 <commit>:

static void
commit()
{
801036f5:	55                   	push   %ebp
801036f6:	89 e5                	mov    %esp,%ebp
801036f8:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801036fb:	a1 88 23 11 80       	mov    0x80112388,%eax
80103700:	85 c0                	test   %eax,%eax
80103702:	7e 1e                	jle    80103722 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103704:	e8 35 ff ff ff       	call   8010363e <write_log>
    write_head();    // Write header to disk -- the real commit
80103709:	e8 3c fd ff ff       	call   8010344a <write_head>
    install_trans(); // Now install writes to home locations
8010370e:	e8 0d fc ff ff       	call   80103320 <install_trans>
    log.lh.n = 0; 
80103713:	c7 05 88 23 11 80 00 	movl   $0x0,0x80112388
8010371a:	00 00 00 
    write_head();    // Erase the transaction from the log
8010371d:	e8 28 fd ff ff       	call   8010344a <write_head>
  }
}
80103722:	c9                   	leave  
80103723:	c3                   	ret    

80103724 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103724:	55                   	push   %ebp
80103725:	89 e5                	mov    %esp,%ebp
80103727:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010372a:	a1 88 23 11 80       	mov    0x80112388,%eax
8010372f:	83 f8 1d             	cmp    $0x1d,%eax
80103732:	7f 12                	jg     80103746 <log_write+0x22>
80103734:	a1 88 23 11 80       	mov    0x80112388,%eax
80103739:	8b 15 78 23 11 80    	mov    0x80112378,%edx
8010373f:	83 ea 01             	sub    $0x1,%edx
80103742:	39 d0                	cmp    %edx,%eax
80103744:	7c 0d                	jl     80103753 <log_write+0x2f>
    panic("too big a transaction");
80103746:	83 ec 0c             	sub    $0xc,%esp
80103749:	68 17 87 10 80       	push   $0x80108717
8010374e:	e8 09 ce ff ff       	call   8010055c <panic>
  if (log.outstanding < 1)
80103753:	a1 7c 23 11 80       	mov    0x8011237c,%eax
80103758:	85 c0                	test   %eax,%eax
8010375a:	7f 0d                	jg     80103769 <log_write+0x45>
    panic("log_write outside of trans");
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	68 2d 87 10 80       	push   $0x8010872d
80103764:	e8 f3 cd ff ff       	call   8010055c <panic>

  acquire(&log.lock);
80103769:	83 ec 0c             	sub    $0xc,%esp
8010376c:	68 40 23 11 80       	push   $0x80112340
80103771:	e8 10 18 00 00       	call   80104f86 <acquire>
80103776:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103780:	eb 1f                	jmp    801037a1 <log_write+0x7d>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103785:	83 c0 10             	add    $0x10,%eax
80103788:	8b 04 85 4c 23 11 80 	mov    -0x7feedcb4(,%eax,4),%eax
8010378f:	89 c2                	mov    %eax,%edx
80103791:	8b 45 08             	mov    0x8(%ebp),%eax
80103794:	8b 40 08             	mov    0x8(%eax),%eax
80103797:	39 c2                	cmp    %eax,%edx
80103799:	75 02                	jne    8010379d <log_write+0x79>
      break;
8010379b:	eb 0e                	jmp    801037ab <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010379d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037a1:	a1 88 23 11 80       	mov    0x80112388,%eax
801037a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037a9:	7f d7                	jg     80103782 <log_write+0x5e>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
801037ab:	8b 45 08             	mov    0x8(%ebp),%eax
801037ae:	8b 40 08             	mov    0x8(%eax),%eax
801037b1:	89 c2                	mov    %eax,%edx
801037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037b6:	83 c0 10             	add    $0x10,%eax
801037b9:	89 14 85 4c 23 11 80 	mov    %edx,-0x7feedcb4(,%eax,4)
  if (i == log.lh.n)
801037c0:	a1 88 23 11 80       	mov    0x80112388,%eax
801037c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037c8:	75 0d                	jne    801037d7 <log_write+0xb3>
    log.lh.n++;
801037ca:	a1 88 23 11 80       	mov    0x80112388,%eax
801037cf:	83 c0 01             	add    $0x1,%eax
801037d2:	a3 88 23 11 80       	mov    %eax,0x80112388
  b->flags |= B_DIRTY; // prevent eviction
801037d7:	8b 45 08             	mov    0x8(%ebp),%eax
801037da:	8b 00                	mov    (%eax),%eax
801037dc:	83 c8 04             	or     $0x4,%eax
801037df:	89 c2                	mov    %eax,%edx
801037e1:	8b 45 08             	mov    0x8(%ebp),%eax
801037e4:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801037e6:	83 ec 0c             	sub    $0xc,%esp
801037e9:	68 40 23 11 80       	push   $0x80112340
801037ee:	e8 f9 17 00 00       	call   80104fec <release>
801037f3:	83 c4 10             	add    $0x10,%esp
}
801037f6:	c9                   	leave  
801037f7:	c3                   	ret    

801037f8 <v2p>:
801037f8:	55                   	push   %ebp
801037f9:	89 e5                	mov    %esp,%ebp
801037fb:	8b 45 08             	mov    0x8(%ebp),%eax
801037fe:	05 00 00 00 80       	add    $0x80000000,%eax
80103803:	5d                   	pop    %ebp
80103804:	c3                   	ret    

80103805 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103805:	55                   	push   %ebp
80103806:	89 e5                	mov    %esp,%ebp
80103808:	8b 45 08             	mov    0x8(%ebp),%eax
8010380b:	05 00 00 00 80       	add    $0x80000000,%eax
80103810:	5d                   	pop    %ebp
80103811:	c3                   	ret    

80103812 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103812:	55                   	push   %ebp
80103813:	89 e5                	mov    %esp,%ebp
80103815:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103818:	8b 55 08             	mov    0x8(%ebp),%edx
8010381b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010381e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103821:	f0 87 02             	lock xchg %eax,(%edx)
80103824:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103827:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010382a:	c9                   	leave  
8010382b:	c3                   	ret    

8010382c <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010382c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103830:	83 e4 f0             	and    $0xfffffff0,%esp
80103833:	ff 71 fc             	pushl  -0x4(%ecx)
80103836:	55                   	push   %ebp
80103837:	89 e5                	mov    %esp,%ebp
80103839:	51                   	push   %ecx
8010383a:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010383d:	83 ec 08             	sub    $0x8,%esp
80103840:	68 00 00 40 80       	push   $0x80400000
80103845:	68 5c 52 11 80       	push   $0x8011525c
8010384a:	e8 92 f2 ff ff       	call   80102ae1 <kinit1>
8010384f:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103852:	e8 d2 44 00 00       	call   80107d29 <kvmalloc>
  mpinit();        // collect info about this machine
80103857:	e8 40 04 00 00       	call   80103c9c <mpinit>
  lapicinit();
8010385c:	e8 f8 f5 ff ff       	call   80102e59 <lapicinit>
  seginit();       // set up segments
80103861:	e8 6b 3e 00 00       	call   801076d1 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103866:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010386c:	0f b6 00             	movzbl (%eax),%eax
8010386f:	0f b6 c0             	movzbl %al,%eax
80103872:	83 ec 08             	sub    $0x8,%esp
80103875:	50                   	push   %eax
80103876:	68 48 87 10 80       	push   $0x80108748
8010387b:	e8 3f cb ff ff       	call   801003bf <cprintf>
80103880:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103883:	e8 65 06 00 00       	call   80103eed <picinit>
  ioapicinit();    // another interrupt controller
80103888:	e8 4c f1 ff ff       	call   801029d9 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010388d:	e8 51 d2 ff ff       	call   80100ae3 <consoleinit>
  uartinit();      // serial port
80103892:	e8 9d 31 00 00       	call   80106a34 <uartinit>
  pinit();         // process table
80103897:	e8 50 0b 00 00       	call   801043ec <pinit>
  tvinit();        // trap vectors
8010389c:	e8 62 2d 00 00       	call   80106603 <tvinit>
  binit();         // buffer cache
801038a1:	e8 8e c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801038a6:	e8 93 d6 ff ff       	call   80100f3e <fileinit>
  ideinit();       // disk
801038ab:	e8 35 ed ff ff       	call   801025e5 <ideinit>
  if(!ismp)
801038b0:	a1 44 24 11 80       	mov    0x80112444,%eax
801038b5:	85 c0                	test   %eax,%eax
801038b7:	75 05                	jne    801038be <main+0x92>
    timerinit();   // uniprocessor timer
801038b9:	e8 a4 2c 00 00       	call   80106562 <timerinit>
  startothers();   // start other processors
801038be:	e8 7f 00 00 00       	call   80103942 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801038c3:	83 ec 08             	sub    $0x8,%esp
801038c6:	68 00 00 00 8e       	push   $0x8e000000
801038cb:	68 00 00 40 80       	push   $0x80400000
801038d0:	e8 44 f2 ff ff       	call   80102b19 <kinit2>
801038d5:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801038d8:	e8 31 0c 00 00       	call   8010450e <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801038dd:	e8 1a 00 00 00       	call   801038fc <mpmain>

801038e2 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801038e2:	55                   	push   %ebp
801038e3:	89 e5                	mov    %esp,%ebp
801038e5:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801038e8:	e8 53 44 00 00       	call   80107d40 <switchkvm>
  seginit();
801038ed:	e8 df 3d 00 00       	call   801076d1 <seginit>
  lapicinit();
801038f2:	e8 62 f5 ff ff       	call   80102e59 <lapicinit>
  mpmain();
801038f7:	e8 00 00 00 00       	call   801038fc <mpmain>

801038fc <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801038fc:	55                   	push   %ebp
801038fd:	89 e5                	mov    %esp,%ebp
801038ff:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103902:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103908:	0f b6 00             	movzbl (%eax),%eax
8010390b:	0f b6 c0             	movzbl %al,%eax
8010390e:	83 ec 08             	sub    $0x8,%esp
80103911:	50                   	push   %eax
80103912:	68 5f 87 10 80       	push   $0x8010875f
80103917:	e8 a3 ca ff ff       	call   801003bf <cprintf>
8010391c:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
8010391f:	e8 54 2e 00 00       	call   80106778 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103924:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010392a:	05 a8 00 00 00       	add    $0xa8,%eax
8010392f:	83 ec 08             	sub    $0x8,%esp
80103932:	6a 01                	push   $0x1
80103934:	50                   	push   %eax
80103935:	e8 d8 fe ff ff       	call   80103812 <xchg>
8010393a:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
8010393d:	e8 76 11 00 00       	call   80104ab8 <scheduler>

80103942 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103942:	55                   	push   %ebp
80103943:	89 e5                	mov    %esp,%ebp
80103945:	53                   	push   %ebx
80103946:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103949:	68 00 70 00 00       	push   $0x7000
8010394e:	e8 b2 fe ff ff       	call   80103805 <p2v>
80103953:	83 c4 04             	add    $0x4,%esp
80103956:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103959:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010395e:	83 ec 04             	sub    $0x4,%esp
80103961:	50                   	push   %eax
80103962:	68 2c b5 10 80       	push   $0x8010b52c
80103967:	ff 75 f0             	pushl  -0x10(%ebp)
8010396a:	e8 32 19 00 00       	call   801052a1 <memmove>
8010396f:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103972:	c7 45 f4 80 24 11 80 	movl   $0x80112480,-0xc(%ebp)
80103979:	e9 8f 00 00 00       	jmp    80103a0d <startothers+0xcb>
    if(c == cpus+cpunum())  // We've started already.
8010397e:	e8 f2 f5 ff ff       	call   80102f75 <cpunum>
80103983:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103989:	05 80 24 11 80       	add    $0x80112480,%eax
8010398e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103991:	75 02                	jne    80103995 <startothers+0x53>
      continue;
80103993:	eb 71                	jmp    80103a06 <startothers+0xc4>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103995:	e8 7a f2 ff ff       	call   80102c14 <kalloc>
8010399a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010399d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a0:	83 e8 04             	sub    $0x4,%eax
801039a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801039a6:	81 c2 00 10 00 00    	add    $0x1000,%edx
801039ac:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801039ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039b1:	83 e8 08             	sub    $0x8,%eax
801039b4:	c7 00 e2 38 10 80    	movl   $0x801038e2,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801039ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039bd:	8d 58 f4             	lea    -0xc(%eax),%ebx
801039c0:	83 ec 0c             	sub    $0xc,%esp
801039c3:	68 00 a0 10 80       	push   $0x8010a000
801039c8:	e8 2b fe ff ff       	call   801037f8 <v2p>
801039cd:	83 c4 10             	add    $0x10,%esp
801039d0:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801039d2:	83 ec 0c             	sub    $0xc,%esp
801039d5:	ff 75 f0             	pushl  -0x10(%ebp)
801039d8:	e8 1b fe ff ff       	call   801037f8 <v2p>
801039dd:	83 c4 10             	add    $0x10,%esp
801039e0:	89 c2                	mov    %eax,%edx
801039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e5:	0f b6 00             	movzbl (%eax),%eax
801039e8:	0f b6 c0             	movzbl %al,%eax
801039eb:	83 ec 08             	sub    $0x8,%esp
801039ee:	52                   	push   %edx
801039ef:	50                   	push   %eax
801039f0:	e8 f8 f5 ff ff       	call   80102fed <lapicstartap>
801039f5:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801039f8:	90                   	nop
801039f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039fc:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a02:	85 c0                	test   %eax,%eax
80103a04:	74 f3                	je     801039f9 <startothers+0xb7>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103a06:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a0d:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103a12:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a18:	05 80 24 11 80       	add    $0x80112480,%eax
80103a1d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a20:	0f 87 58 ff ff ff    	ja     8010397e <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a29:	c9                   	leave  
80103a2a:	c3                   	ret    

80103a2b <p2v>:
80103a2b:	55                   	push   %ebp
80103a2c:	89 e5                	mov    %esp,%ebp
80103a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a31:	05 00 00 00 80       	add    $0x80000000,%eax
80103a36:	5d                   	pop    %ebp
80103a37:	c3                   	ret    

80103a38 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103a38:	55                   	push   %ebp
80103a39:	89 e5                	mov    %esp,%ebp
80103a3b:	83 ec 14             	sub    $0x14,%esp
80103a3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a41:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a45:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103a49:	89 c2                	mov    %eax,%edx
80103a4b:	ec                   	in     (%dx),%al
80103a4c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103a4f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103a53:	c9                   	leave  
80103a54:	c3                   	ret    

80103a55 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a55:	55                   	push   %ebp
80103a56:	89 e5                	mov    %esp,%ebp
80103a58:	83 ec 08             	sub    $0x8,%esp
80103a5b:	8b 55 08             	mov    0x8(%ebp),%edx
80103a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a61:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a65:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a68:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a6c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a70:	ee                   	out    %al,(%dx)
}
80103a71:	c9                   	leave  
80103a72:	c3                   	ret    

80103a73 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103a73:	55                   	push   %ebp
80103a74:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103a76:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103a7b:	89 c2                	mov    %eax,%edx
80103a7d:	b8 80 24 11 80       	mov    $0x80112480,%eax
80103a82:	29 c2                	sub    %eax,%edx
80103a84:	89 d0                	mov    %edx,%eax
80103a86:	c1 f8 02             	sar    $0x2,%eax
80103a89:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103a8f:	5d                   	pop    %ebp
80103a90:	c3                   	ret    

80103a91 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103a91:	55                   	push   %ebp
80103a92:	89 e5                	mov    %esp,%ebp
80103a94:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103a97:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103aa5:	eb 15                	jmp    80103abc <sum+0x2b>
    sum += addr[i];
80103aa7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80103aad:	01 d0                	add    %edx,%eax
80103aaf:	0f b6 00             	movzbl (%eax),%eax
80103ab2:	0f b6 c0             	movzbl %al,%eax
80103ab5:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103ab8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103abc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103abf:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103ac2:	7c e3                	jl     80103aa7 <sum+0x16>
    sum += addr[i];
  return sum;
80103ac4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103ac7:	c9                   	leave  
80103ac8:	c3                   	ret    

80103ac9 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103ac9:	55                   	push   %ebp
80103aca:	89 e5                	mov    %esp,%ebp
80103acc:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103acf:	ff 75 08             	pushl  0x8(%ebp)
80103ad2:	e8 54 ff ff ff       	call   80103a2b <p2v>
80103ad7:	83 c4 04             	add    $0x4,%esp
80103ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103add:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae3:	01 d0                	add    %edx,%eax
80103ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aee:	eb 36                	jmp    80103b26 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	6a 04                	push   $0x4
80103af5:	68 70 87 10 80       	push   $0x80108770
80103afa:	ff 75 f4             	pushl  -0xc(%ebp)
80103afd:	e8 47 17 00 00       	call   80105249 <memcmp>
80103b02:	83 c4 10             	add    $0x10,%esp
80103b05:	85 c0                	test   %eax,%eax
80103b07:	75 19                	jne    80103b22 <mpsearch1+0x59>
80103b09:	83 ec 08             	sub    $0x8,%esp
80103b0c:	6a 10                	push   $0x10
80103b0e:	ff 75 f4             	pushl  -0xc(%ebp)
80103b11:	e8 7b ff ff ff       	call   80103a91 <sum>
80103b16:	83 c4 10             	add    $0x10,%esp
80103b19:	84 c0                	test   %al,%al
80103b1b:	75 05                	jne    80103b22 <mpsearch1+0x59>
      return (struct mp*)p;
80103b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b20:	eb 11                	jmp    80103b33 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103b22:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b29:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103b2c:	72 c2                	jb     80103af0 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103b2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103b33:	c9                   	leave  
80103b34:	c3                   	ret    

80103b35 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103b35:	55                   	push   %ebp
80103b36:	89 e5                	mov    %esp,%ebp
80103b38:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103b3b:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b45:	83 c0 0f             	add    $0xf,%eax
80103b48:	0f b6 00             	movzbl (%eax),%eax
80103b4b:	0f b6 c0             	movzbl %al,%eax
80103b4e:	c1 e0 08             	shl    $0x8,%eax
80103b51:	89 c2                	mov    %eax,%edx
80103b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b56:	83 c0 0e             	add    $0xe,%eax
80103b59:	0f b6 00             	movzbl (%eax),%eax
80103b5c:	0f b6 c0             	movzbl %al,%eax
80103b5f:	09 d0                	or     %edx,%eax
80103b61:	c1 e0 04             	shl    $0x4,%eax
80103b64:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103b67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103b6b:	74 21                	je     80103b8e <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103b6d:	83 ec 08             	sub    $0x8,%esp
80103b70:	68 00 04 00 00       	push   $0x400
80103b75:	ff 75 f0             	pushl  -0x10(%ebp)
80103b78:	e8 4c ff ff ff       	call   80103ac9 <mpsearch1>
80103b7d:	83 c4 10             	add    $0x10,%esp
80103b80:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b87:	74 51                	je     80103bda <mpsearch+0xa5>
      return mp;
80103b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b8c:	eb 61                	jmp    80103bef <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b91:	83 c0 14             	add    $0x14,%eax
80103b94:	0f b6 00             	movzbl (%eax),%eax
80103b97:	0f b6 c0             	movzbl %al,%eax
80103b9a:	c1 e0 08             	shl    $0x8,%eax
80103b9d:	89 c2                	mov    %eax,%edx
80103b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba2:	83 c0 13             	add    $0x13,%eax
80103ba5:	0f b6 00             	movzbl (%eax),%eax
80103ba8:	0f b6 c0             	movzbl %al,%eax
80103bab:	09 d0                	or     %edx,%eax
80103bad:	c1 e0 0a             	shl    $0xa,%eax
80103bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bb6:	2d 00 04 00 00       	sub    $0x400,%eax
80103bbb:	83 ec 08             	sub    $0x8,%esp
80103bbe:	68 00 04 00 00       	push   $0x400
80103bc3:	50                   	push   %eax
80103bc4:	e8 00 ff ff ff       	call   80103ac9 <mpsearch1>
80103bc9:	83 c4 10             	add    $0x10,%esp
80103bcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103bcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103bd3:	74 05                	je     80103bda <mpsearch+0xa5>
      return mp;
80103bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bd8:	eb 15                	jmp    80103bef <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103bda:	83 ec 08             	sub    $0x8,%esp
80103bdd:	68 00 00 01 00       	push   $0x10000
80103be2:	68 00 00 0f 00       	push   $0xf0000
80103be7:	e8 dd fe ff ff       	call   80103ac9 <mpsearch1>
80103bec:	83 c4 10             	add    $0x10,%esp
}
80103bef:	c9                   	leave  
80103bf0:	c3                   	ret    

80103bf1 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103bf1:	55                   	push   %ebp
80103bf2:	89 e5                	mov    %esp,%ebp
80103bf4:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bf7:	e8 39 ff ff ff       	call   80103b35 <mpsearch>
80103bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c03:	74 0a                	je     80103c0f <mpconfig+0x1e>
80103c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c08:	8b 40 04             	mov    0x4(%eax),%eax
80103c0b:	85 c0                	test   %eax,%eax
80103c0d:	75 0a                	jne    80103c19 <mpconfig+0x28>
    return 0;
80103c0f:	b8 00 00 00 00       	mov    $0x0,%eax
80103c14:	e9 81 00 00 00       	jmp    80103c9a <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1c:	8b 40 04             	mov    0x4(%eax),%eax
80103c1f:	83 ec 0c             	sub    $0xc,%esp
80103c22:	50                   	push   %eax
80103c23:	e8 03 fe ff ff       	call   80103a2b <p2v>
80103c28:	83 c4 10             	add    $0x10,%esp
80103c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103c2e:	83 ec 04             	sub    $0x4,%esp
80103c31:	6a 04                	push   $0x4
80103c33:	68 75 87 10 80       	push   $0x80108775
80103c38:	ff 75 f0             	pushl  -0x10(%ebp)
80103c3b:	e8 09 16 00 00       	call   80105249 <memcmp>
80103c40:	83 c4 10             	add    $0x10,%esp
80103c43:	85 c0                	test   %eax,%eax
80103c45:	74 07                	je     80103c4e <mpconfig+0x5d>
    return 0;
80103c47:	b8 00 00 00 00       	mov    $0x0,%eax
80103c4c:	eb 4c                	jmp    80103c9a <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c51:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c55:	3c 01                	cmp    $0x1,%al
80103c57:	74 12                	je     80103c6b <mpconfig+0x7a>
80103c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c5c:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103c60:	3c 04                	cmp    $0x4,%al
80103c62:	74 07                	je     80103c6b <mpconfig+0x7a>
    return 0;
80103c64:	b8 00 00 00 00       	mov    $0x0,%eax
80103c69:	eb 2f                	jmp    80103c9a <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c6e:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c72:	0f b7 c0             	movzwl %ax,%eax
80103c75:	83 ec 08             	sub    $0x8,%esp
80103c78:	50                   	push   %eax
80103c79:	ff 75 f0             	pushl  -0x10(%ebp)
80103c7c:	e8 10 fe ff ff       	call   80103a91 <sum>
80103c81:	83 c4 10             	add    $0x10,%esp
80103c84:	84 c0                	test   %al,%al
80103c86:	74 07                	je     80103c8f <mpconfig+0x9e>
    return 0;
80103c88:	b8 00 00 00 00       	mov    $0x0,%eax
80103c8d:	eb 0b                	jmp    80103c9a <mpconfig+0xa9>
  *pmp = mp;
80103c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80103c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103c95:	89 10                	mov    %edx,(%eax)
  return conf;
80103c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103c9a:	c9                   	leave  
80103c9b:	c3                   	ret    

80103c9c <mpinit>:

void
mpinit(void)
{
80103c9c:	55                   	push   %ebp
80103c9d:	89 e5                	mov    %esp,%ebp
80103c9f:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103ca2:	c7 05 64 b6 10 80 80 	movl   $0x80112480,0x8010b664
80103ca9:	24 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103cac:	83 ec 0c             	sub    $0xc,%esp
80103caf:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103cb2:	50                   	push   %eax
80103cb3:	e8 39 ff ff ff       	call   80103bf1 <mpconfig>
80103cb8:	83 c4 10             	add    $0x10,%esp
80103cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103cbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103cc2:	75 05                	jne    80103cc9 <mpinit+0x2d>
    return;
80103cc4:	e9 94 01 00 00       	jmp    80103e5d <mpinit+0x1c1>
  ismp = 1;
80103cc9:	c7 05 44 24 11 80 01 	movl   $0x1,0x80112444
80103cd0:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd6:	8b 40 24             	mov    0x24(%eax),%eax
80103cd9:	a3 1c 23 11 80       	mov    %eax,0x8011231c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce1:	83 c0 2c             	add    $0x2c,%eax
80103ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cea:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cee:	0f b7 d0             	movzwl %ax,%edx
80103cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf4:	01 d0                	add    %edx,%eax
80103cf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cf9:	e9 f2 00 00 00       	jmp    80103df0 <mpinit+0x154>
    switch(*p){
80103cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d01:	0f b6 00             	movzbl (%eax),%eax
80103d04:	0f b6 c0             	movzbl %al,%eax
80103d07:	83 f8 04             	cmp    $0x4,%eax
80103d0a:	0f 87 bc 00 00 00    	ja     80103dcc <mpinit+0x130>
80103d10:	8b 04 85 b8 87 10 80 	mov    -0x7fef7848(,%eax,4),%eax
80103d17:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d22:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d26:	0f b6 d0             	movzbl %al,%edx
80103d29:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d2e:	39 c2                	cmp    %eax,%edx
80103d30:	74 2b                	je     80103d5d <mpinit+0xc1>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103d32:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d35:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103d39:	0f b6 d0             	movzbl %al,%edx
80103d3c:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d41:	83 ec 04             	sub    $0x4,%esp
80103d44:	52                   	push   %edx
80103d45:	50                   	push   %eax
80103d46:	68 7a 87 10 80       	push   $0x8010877a
80103d4b:	e8 6f c6 ff ff       	call   801003bf <cprintf>
80103d50:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103d53:	c7 05 44 24 11 80 00 	movl   $0x0,0x80112444
80103d5a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103d60:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103d64:	0f b6 c0             	movzbl %al,%eax
80103d67:	83 e0 02             	and    $0x2,%eax
80103d6a:	85 c0                	test   %eax,%eax
80103d6c:	74 15                	je     80103d83 <mpinit+0xe7>
        bcpu = &cpus[ncpu];
80103d6e:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d73:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d79:	05 80 24 11 80       	add    $0x80112480,%eax
80103d7e:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103d83:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103d88:	8b 15 60 2a 11 80    	mov    0x80112a60,%edx
80103d8e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d94:	05 80 24 11 80       	add    $0x80112480,%eax
80103d99:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103d9b:	a1 60 2a 11 80       	mov    0x80112a60,%eax
80103da0:	83 c0 01             	add    $0x1,%eax
80103da3:	a3 60 2a 11 80       	mov    %eax,0x80112a60
      p += sizeof(struct mpproc);
80103da8:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103dac:	eb 42                	jmp    80103df0 <mpinit+0x154>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103db1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103db7:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dbb:	a2 40 24 11 80       	mov    %al,0x80112440
      p += sizeof(struct mpioapic);
80103dc0:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dc4:	eb 2a                	jmp    80103df0 <mpinit+0x154>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103dc6:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103dca:	eb 24                	jmp    80103df0 <mpinit+0x154>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dcf:	0f b6 00             	movzbl (%eax),%eax
80103dd2:	0f b6 c0             	movzbl %al,%eax
80103dd5:	83 ec 08             	sub    $0x8,%esp
80103dd8:	50                   	push   %eax
80103dd9:	68 98 87 10 80       	push   $0x80108798
80103dde:	e8 dc c5 ff ff       	call   801003bf <cprintf>
80103de3:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103de6:	c7 05 44 24 11 80 00 	movl   $0x0,0x80112444
80103ded:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103df3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103df6:	0f 82 02 ff ff ff    	jb     80103cfe <mpinit+0x62>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103dfc:	a1 44 24 11 80       	mov    0x80112444,%eax
80103e01:	85 c0                	test   %eax,%eax
80103e03:	75 1d                	jne    80103e22 <mpinit+0x186>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103e05:	c7 05 60 2a 11 80 01 	movl   $0x1,0x80112a60
80103e0c:	00 00 00 
    lapic = 0;
80103e0f:	c7 05 1c 23 11 80 00 	movl   $0x0,0x8011231c
80103e16:	00 00 00 
    ioapicid = 0;
80103e19:	c6 05 40 24 11 80 00 	movb   $0x0,0x80112440
    return;
80103e20:	eb 3b                	jmp    80103e5d <mpinit+0x1c1>
  }

  if(mp->imcrp){
80103e22:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103e25:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103e29:	84 c0                	test   %al,%al
80103e2b:	74 30                	je     80103e5d <mpinit+0x1c1>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103e2d:	83 ec 08             	sub    $0x8,%esp
80103e30:	6a 70                	push   $0x70
80103e32:	6a 22                	push   $0x22
80103e34:	e8 1c fc ff ff       	call   80103a55 <outb>
80103e39:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103e3c:	83 ec 0c             	sub    $0xc,%esp
80103e3f:	6a 23                	push   $0x23
80103e41:	e8 f2 fb ff ff       	call   80103a38 <inb>
80103e46:	83 c4 10             	add    $0x10,%esp
80103e49:	83 c8 01             	or     $0x1,%eax
80103e4c:	0f b6 c0             	movzbl %al,%eax
80103e4f:	83 ec 08             	sub    $0x8,%esp
80103e52:	50                   	push   %eax
80103e53:	6a 23                	push   $0x23
80103e55:	e8 fb fb ff ff       	call   80103a55 <outb>
80103e5a:	83 c4 10             	add    $0x10,%esp
  }
}
80103e5d:	c9                   	leave  
80103e5e:	c3                   	ret    

80103e5f <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103e5f:	55                   	push   %ebp
80103e60:	89 e5                	mov    %esp,%ebp
80103e62:	83 ec 08             	sub    $0x8,%esp
80103e65:	8b 55 08             	mov    0x8(%ebp),%edx
80103e68:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e6b:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e6f:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e72:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e76:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e7a:	ee                   	out    %al,(%dx)
}
80103e7b:	c9                   	leave  
80103e7c:	c3                   	ret    

80103e7d <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103e7d:	55                   	push   %ebp
80103e7e:	89 e5                	mov    %esp,%ebp
80103e80:	83 ec 04             	sub    $0x4,%esp
80103e83:	8b 45 08             	mov    0x8(%ebp),%eax
80103e86:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103e8a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e8e:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103e94:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103e98:	0f b6 c0             	movzbl %al,%eax
80103e9b:	50                   	push   %eax
80103e9c:	6a 21                	push   $0x21
80103e9e:	e8 bc ff ff ff       	call   80103e5f <outb>
80103ea3:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103ea6:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103eaa:	66 c1 e8 08          	shr    $0x8,%ax
80103eae:	0f b6 c0             	movzbl %al,%eax
80103eb1:	50                   	push   %eax
80103eb2:	68 a1 00 00 00       	push   $0xa1
80103eb7:	e8 a3 ff ff ff       	call   80103e5f <outb>
80103ebc:	83 c4 08             	add    $0x8,%esp
}
80103ebf:	c9                   	leave  
80103ec0:	c3                   	ret    

80103ec1 <picenable>:

void
picenable(int irq)
{
80103ec1:	55                   	push   %ebp
80103ec2:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec7:	ba 01 00 00 00       	mov    $0x1,%edx
80103ecc:	89 c1                	mov    %eax,%ecx
80103ece:	d3 e2                	shl    %cl,%edx
80103ed0:	89 d0                	mov    %edx,%eax
80103ed2:	f7 d0                	not    %eax
80103ed4:	89 c2                	mov    %eax,%edx
80103ed6:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103edd:	21 d0                	and    %edx,%eax
80103edf:	0f b7 c0             	movzwl %ax,%eax
80103ee2:	50                   	push   %eax
80103ee3:	e8 95 ff ff ff       	call   80103e7d <picsetmask>
80103ee8:	83 c4 04             	add    $0x4,%esp
}
80103eeb:	c9                   	leave  
80103eec:	c3                   	ret    

80103eed <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103eed:	55                   	push   %ebp
80103eee:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ef0:	68 ff 00 00 00       	push   $0xff
80103ef5:	6a 21                	push   $0x21
80103ef7:	e8 63 ff ff ff       	call   80103e5f <outb>
80103efc:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103eff:	68 ff 00 00 00       	push   $0xff
80103f04:	68 a1 00 00 00       	push   $0xa1
80103f09:	e8 51 ff ff ff       	call   80103e5f <outb>
80103f0e:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103f11:	6a 11                	push   $0x11
80103f13:	6a 20                	push   $0x20
80103f15:	e8 45 ff ff ff       	call   80103e5f <outb>
80103f1a:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103f1d:	6a 20                	push   $0x20
80103f1f:	6a 21                	push   $0x21
80103f21:	e8 39 ff ff ff       	call   80103e5f <outb>
80103f26:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103f29:	6a 04                	push   $0x4
80103f2b:	6a 21                	push   $0x21
80103f2d:	e8 2d ff ff ff       	call   80103e5f <outb>
80103f32:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103f35:	6a 03                	push   $0x3
80103f37:	6a 21                	push   $0x21
80103f39:	e8 21 ff ff ff       	call   80103e5f <outb>
80103f3e:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103f41:	6a 11                	push   $0x11
80103f43:	68 a0 00 00 00       	push   $0xa0
80103f48:	e8 12 ff ff ff       	call   80103e5f <outb>
80103f4d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103f50:	6a 28                	push   $0x28
80103f52:	68 a1 00 00 00       	push   $0xa1
80103f57:	e8 03 ff ff ff       	call   80103e5f <outb>
80103f5c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103f5f:	6a 02                	push   $0x2
80103f61:	68 a1 00 00 00       	push   $0xa1
80103f66:	e8 f4 fe ff ff       	call   80103e5f <outb>
80103f6b:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103f6e:	6a 03                	push   $0x3
80103f70:	68 a1 00 00 00       	push   $0xa1
80103f75:	e8 e5 fe ff ff       	call   80103e5f <outb>
80103f7a:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103f7d:	6a 68                	push   $0x68
80103f7f:	6a 20                	push   $0x20
80103f81:	e8 d9 fe ff ff       	call   80103e5f <outb>
80103f86:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103f89:	6a 0a                	push   $0xa
80103f8b:	6a 20                	push   $0x20
80103f8d:	e8 cd fe ff ff       	call   80103e5f <outb>
80103f92:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80103f95:	6a 68                	push   $0x68
80103f97:	68 a0 00 00 00       	push   $0xa0
80103f9c:	e8 be fe ff ff       	call   80103e5f <outb>
80103fa1:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80103fa4:	6a 0a                	push   $0xa
80103fa6:	68 a0 00 00 00       	push   $0xa0
80103fab:	e8 af fe ff ff       	call   80103e5f <outb>
80103fb0:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80103fb3:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103fba:	66 83 f8 ff          	cmp    $0xffff,%ax
80103fbe:	74 13                	je     80103fd3 <picinit+0xe6>
    picsetmask(irqmask);
80103fc0:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103fc7:	0f b7 c0             	movzwl %ax,%eax
80103fca:	50                   	push   %eax
80103fcb:	e8 ad fe ff ff       	call   80103e7d <picsetmask>
80103fd0:	83 c4 04             	add    $0x4,%esp
}
80103fd3:	c9                   	leave  
80103fd4:	c3                   	ret    

80103fd5 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103fd5:	55                   	push   %ebp
80103fd6:	89 e5                	mov    %esp,%ebp
80103fd8:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80103fdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fe5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fee:	8b 10                	mov    (%eax),%edx
80103ff0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff3:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103ff5:	e8 61 cf ff ff       	call   80100f5b <filealloc>
80103ffa:	89 c2                	mov    %eax,%edx
80103ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fff:	89 10                	mov    %edx,(%eax)
80104001:	8b 45 08             	mov    0x8(%ebp),%eax
80104004:	8b 00                	mov    (%eax),%eax
80104006:	85 c0                	test   %eax,%eax
80104008:	0f 84 cb 00 00 00    	je     801040d9 <pipealloc+0x104>
8010400e:	e8 48 cf ff ff       	call   80100f5b <filealloc>
80104013:	89 c2                	mov    %eax,%edx
80104015:	8b 45 0c             	mov    0xc(%ebp),%eax
80104018:	89 10                	mov    %edx,(%eax)
8010401a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401d:	8b 00                	mov    (%eax),%eax
8010401f:	85 c0                	test   %eax,%eax
80104021:	0f 84 b2 00 00 00    	je     801040d9 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104027:	e8 e8 eb ff ff       	call   80102c14 <kalloc>
8010402c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010402f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104033:	75 05                	jne    8010403a <pipealloc+0x65>
    goto bad;
80104035:	e9 9f 00 00 00       	jmp    801040d9 <pipealloc+0x104>
  p->readopen = 1;
8010403a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010403d:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104044:	00 00 00 
  p->writeopen = 1;
80104047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404a:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80104051:	00 00 00 
  p->nwrite = 0;
80104054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104057:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010405e:	00 00 00 
  p->nread = 0;
80104061:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104064:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010406b:	00 00 00 
  initlock(&p->lock, "pipe");
8010406e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104071:	83 ec 08             	sub    $0x8,%esp
80104074:	68 cc 87 10 80       	push   $0x801087cc
80104079:	50                   	push   %eax
8010407a:	e8 e6 0e 00 00       	call   80104f65 <initlock>
8010407f:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104082:	8b 45 08             	mov    0x8(%ebp),%eax
80104085:	8b 00                	mov    (%eax),%eax
80104087:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010408d:	8b 45 08             	mov    0x8(%ebp),%eax
80104090:	8b 00                	mov    (%eax),%eax
80104092:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104096:	8b 45 08             	mov    0x8(%ebp),%eax
80104099:	8b 00                	mov    (%eax),%eax
8010409b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010409f:	8b 45 08             	mov    0x8(%ebp),%eax
801040a2:	8b 00                	mov    (%eax),%eax
801040a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a7:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801040aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ad:	8b 00                	mov    (%eax),%eax
801040af:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801040b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040b8:	8b 00                	mov    (%eax),%eax
801040ba:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801040be:	8b 45 0c             	mov    0xc(%ebp),%eax
801040c1:	8b 00                	mov    (%eax),%eax
801040c3:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801040c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ca:	8b 00                	mov    (%eax),%eax
801040cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040cf:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801040d2:	b8 00 00 00 00       	mov    $0x0,%eax
801040d7:	eb 4d                	jmp    80104126 <pipealloc+0x151>

//PAGEBREAK: 20
 bad:
  if(p)
801040d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040dd:	74 0e                	je     801040ed <pipealloc+0x118>
    kfree((char*)p);
801040df:	83 ec 0c             	sub    $0xc,%esp
801040e2:	ff 75 f4             	pushl  -0xc(%ebp)
801040e5:	e8 8e ea ff ff       	call   80102b78 <kfree>
801040ea:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801040ed:	8b 45 08             	mov    0x8(%ebp),%eax
801040f0:	8b 00                	mov    (%eax),%eax
801040f2:	85 c0                	test   %eax,%eax
801040f4:	74 11                	je     80104107 <pipealloc+0x132>
    fileclose(*f0);
801040f6:	8b 45 08             	mov    0x8(%ebp),%eax
801040f9:	8b 00                	mov    (%eax),%eax
801040fb:	83 ec 0c             	sub    $0xc,%esp
801040fe:	50                   	push   %eax
801040ff:	e8 14 cf ff ff       	call   80101018 <fileclose>
80104104:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104107:	8b 45 0c             	mov    0xc(%ebp),%eax
8010410a:	8b 00                	mov    (%eax),%eax
8010410c:	85 c0                	test   %eax,%eax
8010410e:	74 11                	je     80104121 <pipealloc+0x14c>
    fileclose(*f1);
80104110:	8b 45 0c             	mov    0xc(%ebp),%eax
80104113:	8b 00                	mov    (%eax),%eax
80104115:	83 ec 0c             	sub    $0xc,%esp
80104118:	50                   	push   %eax
80104119:	e8 fa ce ff ff       	call   80101018 <fileclose>
8010411e:	83 c4 10             	add    $0x10,%esp
  return -1;
80104121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104126:	c9                   	leave  
80104127:	c3                   	ret    

80104128 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104128:	55                   	push   %ebp
80104129:	89 e5                	mov    %esp,%ebp
8010412b:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010412e:	8b 45 08             	mov    0x8(%ebp),%eax
80104131:	83 ec 0c             	sub    $0xc,%esp
80104134:	50                   	push   %eax
80104135:	e8 4c 0e 00 00       	call   80104f86 <acquire>
8010413a:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010413d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104141:	74 23                	je     80104166 <pipeclose+0x3e>
    p->writeopen = 0;
80104143:	8b 45 08             	mov    0x8(%ebp),%eax
80104146:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010414d:	00 00 00 
    wakeup(&p->nread);
80104150:	8b 45 08             	mov    0x8(%ebp),%eax
80104153:	05 34 02 00 00       	add    $0x234,%eax
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	50                   	push   %eax
8010415c:	e8 1e 0c 00 00       	call   80104d7f <wakeup>
80104161:	83 c4 10             	add    $0x10,%esp
80104164:	eb 21                	jmp    80104187 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104166:	8b 45 08             	mov    0x8(%ebp),%eax
80104169:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104170:	00 00 00 
    wakeup(&p->nwrite);
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
80104176:	05 38 02 00 00       	add    $0x238,%eax
8010417b:	83 ec 0c             	sub    $0xc,%esp
8010417e:	50                   	push   %eax
8010417f:	e8 fb 0b 00 00       	call   80104d7f <wakeup>
80104184:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104187:	8b 45 08             	mov    0x8(%ebp),%eax
8010418a:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104190:	85 c0                	test   %eax,%eax
80104192:	75 2c                	jne    801041c0 <pipeclose+0x98>
80104194:	8b 45 08             	mov    0x8(%ebp),%eax
80104197:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010419d:	85 c0                	test   %eax,%eax
8010419f:	75 1f                	jne    801041c0 <pipeclose+0x98>
    release(&p->lock);
801041a1:	8b 45 08             	mov    0x8(%ebp),%eax
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	50                   	push   %eax
801041a8:	e8 3f 0e 00 00       	call   80104fec <release>
801041ad:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801041b0:	83 ec 0c             	sub    $0xc,%esp
801041b3:	ff 75 08             	pushl  0x8(%ebp)
801041b6:	e8 bd e9 ff ff       	call   80102b78 <kfree>
801041bb:	83 c4 10             	add    $0x10,%esp
801041be:	eb 0f                	jmp    801041cf <pipeclose+0xa7>
  } else
    release(&p->lock);
801041c0:	8b 45 08             	mov    0x8(%ebp),%eax
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	50                   	push   %eax
801041c7:	e8 20 0e 00 00       	call   80104fec <release>
801041cc:	83 c4 10             	add    $0x10,%esp
}
801041cf:	c9                   	leave  
801041d0:	c3                   	ret    

801041d1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801041d1:	55                   	push   %ebp
801041d2:	89 e5                	mov    %esp,%ebp
801041d4:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801041d7:	8b 45 08             	mov    0x8(%ebp),%eax
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	50                   	push   %eax
801041de:	e8 a3 0d 00 00       	call   80104f86 <acquire>
801041e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801041e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801041ed:	e9 af 00 00 00       	jmp    801042a1 <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041f2:	eb 60                	jmp    80104254 <pipewrite+0x83>
      if(p->readopen == 0 || proc->killed){
801041f4:	8b 45 08             	mov    0x8(%ebp),%eax
801041f7:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801041fd:	85 c0                	test   %eax,%eax
801041ff:	74 0d                	je     8010420e <pipewrite+0x3d>
80104201:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104207:	8b 40 24             	mov    0x24(%eax),%eax
8010420a:	85 c0                	test   %eax,%eax
8010420c:	74 19                	je     80104227 <pipewrite+0x56>
        release(&p->lock);
8010420e:	8b 45 08             	mov    0x8(%ebp),%eax
80104211:	83 ec 0c             	sub    $0xc,%esp
80104214:	50                   	push   %eax
80104215:	e8 d2 0d 00 00       	call   80104fec <release>
8010421a:	83 c4 10             	add    $0x10,%esp
        return -1;
8010421d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104222:	e9 ac 00 00 00       	jmp    801042d3 <pipewrite+0x102>
      }
      wakeup(&p->nread);
80104227:	8b 45 08             	mov    0x8(%ebp),%eax
8010422a:	05 34 02 00 00       	add    $0x234,%eax
8010422f:	83 ec 0c             	sub    $0xc,%esp
80104232:	50                   	push   %eax
80104233:	e8 47 0b 00 00       	call   80104d7f <wakeup>
80104238:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010423b:	8b 45 08             	mov    0x8(%ebp),%eax
8010423e:	8b 55 08             	mov    0x8(%ebp),%edx
80104241:	81 c2 38 02 00 00    	add    $0x238,%edx
80104247:	83 ec 08             	sub    $0x8,%esp
8010424a:	50                   	push   %eax
8010424b:	52                   	push   %edx
8010424c:	e8 45 0a 00 00       	call   80104c96 <sleep>
80104251:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104254:	8b 45 08             	mov    0x8(%ebp),%eax
80104257:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
8010425d:	8b 45 08             	mov    0x8(%ebp),%eax
80104260:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104266:	05 00 02 00 00       	add    $0x200,%eax
8010426b:	39 c2                	cmp    %eax,%edx
8010426d:	74 85                	je     801041f4 <pipewrite+0x23>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010426f:	8b 45 08             	mov    0x8(%ebp),%eax
80104272:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104278:	8d 48 01             	lea    0x1(%eax),%ecx
8010427b:	8b 55 08             	mov    0x8(%ebp),%edx
8010427e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104284:	25 ff 01 00 00       	and    $0x1ff,%eax
80104289:	89 c1                	mov    %eax,%ecx
8010428b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010428e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104291:	01 d0                	add    %edx,%eax
80104293:	0f b6 10             	movzbl (%eax),%edx
80104296:	8b 45 08             	mov    0x8(%ebp),%eax
80104299:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010429d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a4:	3b 45 10             	cmp    0x10(%ebp),%eax
801042a7:	0f 8c 45 ff ff ff    	jl     801041f2 <pipewrite+0x21>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801042ad:	8b 45 08             	mov    0x8(%ebp),%eax
801042b0:	05 34 02 00 00       	add    $0x234,%eax
801042b5:	83 ec 0c             	sub    $0xc,%esp
801042b8:	50                   	push   %eax
801042b9:	e8 c1 0a 00 00       	call   80104d7f <wakeup>
801042be:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801042c1:	8b 45 08             	mov    0x8(%ebp),%eax
801042c4:	83 ec 0c             	sub    $0xc,%esp
801042c7:	50                   	push   %eax
801042c8:	e8 1f 0d 00 00       	call   80104fec <release>
801042cd:	83 c4 10             	add    $0x10,%esp
  return n;
801042d0:	8b 45 10             	mov    0x10(%ebp),%eax
}
801042d3:	c9                   	leave  
801042d4:	c3                   	ret    

801042d5 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801042d5:	55                   	push   %ebp
801042d6:	89 e5                	mov    %esp,%ebp
801042d8:	53                   	push   %ebx
801042d9:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801042dc:	8b 45 08             	mov    0x8(%ebp),%eax
801042df:	83 ec 0c             	sub    $0xc,%esp
801042e2:	50                   	push   %eax
801042e3:	e8 9e 0c 00 00       	call   80104f86 <acquire>
801042e8:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801042eb:	eb 3f                	jmp    8010432c <piperead+0x57>
    if(proc->killed){
801042ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042f3:	8b 40 24             	mov    0x24(%eax),%eax
801042f6:	85 c0                	test   %eax,%eax
801042f8:	74 19                	je     80104313 <piperead+0x3e>
      release(&p->lock);
801042fa:	8b 45 08             	mov    0x8(%ebp),%eax
801042fd:	83 ec 0c             	sub    $0xc,%esp
80104300:	50                   	push   %eax
80104301:	e8 e6 0c 00 00       	call   80104fec <release>
80104306:	83 c4 10             	add    $0x10,%esp
      return -1;
80104309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010430e:	e9 be 00 00 00       	jmp    801043d1 <piperead+0xfc>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104313:	8b 45 08             	mov    0x8(%ebp),%eax
80104316:	8b 55 08             	mov    0x8(%ebp),%edx
80104319:	81 c2 34 02 00 00    	add    $0x234,%edx
8010431f:	83 ec 08             	sub    $0x8,%esp
80104322:	50                   	push   %eax
80104323:	52                   	push   %edx
80104324:	e8 6d 09 00 00       	call   80104c96 <sleep>
80104329:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010432c:	8b 45 08             	mov    0x8(%ebp),%eax
8010432f:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104335:	8b 45 08             	mov    0x8(%ebp),%eax
80104338:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010433e:	39 c2                	cmp    %eax,%edx
80104340:	75 0d                	jne    8010434f <piperead+0x7a>
80104342:	8b 45 08             	mov    0x8(%ebp),%eax
80104345:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010434b:	85 c0                	test   %eax,%eax
8010434d:	75 9e                	jne    801042ed <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010434f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104356:	eb 4b                	jmp    801043a3 <piperead+0xce>
    if(p->nread == p->nwrite)
80104358:	8b 45 08             	mov    0x8(%ebp),%eax
8010435b:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104361:	8b 45 08             	mov    0x8(%ebp),%eax
80104364:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010436a:	39 c2                	cmp    %eax,%edx
8010436c:	75 02                	jne    80104370 <piperead+0x9b>
      break;
8010436e:	eb 3b                	jmp    801043ab <piperead+0xd6>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104370:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104373:	8b 45 0c             	mov    0xc(%ebp),%eax
80104376:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104379:	8b 45 08             	mov    0x8(%ebp),%eax
8010437c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104382:	8d 48 01             	lea    0x1(%eax),%ecx
80104385:	8b 55 08             	mov    0x8(%ebp),%edx
80104388:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
8010438e:	25 ff 01 00 00       	and    $0x1ff,%eax
80104393:	89 c2                	mov    %eax,%edx
80104395:	8b 45 08             	mov    0x8(%ebp),%eax
80104398:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
8010439d:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010439f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a6:	3b 45 10             	cmp    0x10(%ebp),%eax
801043a9:	7c ad                	jl     80104358 <piperead+0x83>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801043ab:	8b 45 08             	mov    0x8(%ebp),%eax
801043ae:	05 38 02 00 00       	add    $0x238,%eax
801043b3:	83 ec 0c             	sub    $0xc,%esp
801043b6:	50                   	push   %eax
801043b7:	e8 c3 09 00 00       	call   80104d7f <wakeup>
801043bc:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043bf:	8b 45 08             	mov    0x8(%ebp),%eax
801043c2:	83 ec 0c             	sub    $0xc,%esp
801043c5:	50                   	push   %eax
801043c6:	e8 21 0c 00 00       	call   80104fec <release>
801043cb:	83 c4 10             	add    $0x10,%esp
  return i;
801043ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801043d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d4:	c9                   	leave  
801043d5:	c3                   	ret    

801043d6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801043d6:	55                   	push   %ebp
801043d7:	89 e5                	mov    %esp,%ebp
801043d9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043dc:	9c                   	pushf  
801043dd:	58                   	pop    %eax
801043de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801043e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801043e4:	c9                   	leave  
801043e5:	c3                   	ret    

801043e6 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801043e6:	55                   	push   %ebp
801043e7:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801043e9:	fb                   	sti    
}
801043ea:	5d                   	pop    %ebp
801043eb:	c3                   	ret    

801043ec <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801043ec:	55                   	push   %ebp
801043ed:	89 e5                	mov    %esp,%ebp
801043ef:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801043f2:	83 ec 08             	sub    $0x8,%esp
801043f5:	68 d1 87 10 80       	push   $0x801087d1
801043fa:	68 80 2a 11 80       	push   $0x80112a80
801043ff:	e8 61 0b 00 00       	call   80104f65 <initlock>
80104404:	83 c4 10             	add    $0x10,%esp
}
80104407:	c9                   	leave  
80104408:	c3                   	ret    

80104409 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104409:	55                   	push   %ebp
8010440a:	89 e5                	mov    %esp,%ebp
8010440c:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010440f:	83 ec 0c             	sub    $0xc,%esp
80104412:	68 80 2a 11 80       	push   $0x80112a80
80104417:	e8 6a 0b 00 00       	call   80104f86 <acquire>
8010441c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441f:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80104426:	eb 56                	jmp    8010447e <allocproc+0x75>
    if(p->state == UNUSED)
80104428:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442b:	8b 40 0c             	mov    0xc(%eax),%eax
8010442e:	85 c0                	test   %eax,%eax
80104430:	75 48                	jne    8010447a <allocproc+0x71>
      goto found;
80104432:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104436:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010443d:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104442:	8d 50 01             	lea    0x1(%eax),%edx
80104445:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
8010444b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010444e:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104451:	83 ec 0c             	sub    $0xc,%esp
80104454:	68 80 2a 11 80       	push   $0x80112a80
80104459:	e8 8e 0b 00 00       	call   80104fec <release>
8010445e:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104461:	e8 ae e7 ff ff       	call   80102c14 <kalloc>
80104466:	89 c2                	mov    %eax,%edx
80104468:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010446b:	89 50 08             	mov    %edx,0x8(%eax)
8010446e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104471:	8b 40 08             	mov    0x8(%eax),%eax
80104474:	85 c0                	test   %eax,%eax
80104476:	75 37                	jne    801044af <allocproc+0xa6>
80104478:	eb 24                	jmp    8010449e <allocproc+0x95>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010447a:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010447e:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104485:	72 a1                	jb     80104428 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104487:	83 ec 0c             	sub    $0xc,%esp
8010448a:	68 80 2a 11 80       	push   $0x80112a80
8010448f:	e8 58 0b 00 00       	call   80104fec <release>
80104494:	83 c4 10             	add    $0x10,%esp
  return 0;
80104497:	b8 00 00 00 00       	mov    $0x0,%eax
8010449c:	eb 6e                	jmp    8010450c <allocproc+0x103>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010449e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801044a8:	b8 00 00 00 00       	mov    $0x0,%eax
801044ad:	eb 5d                	jmp    8010450c <allocproc+0x103>
  }
  sp = p->kstack + KSTACKSIZE;
801044af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b2:	8b 40 08             	mov    0x8(%eax),%eax
801044b5:	05 00 10 00 00       	add    $0x1000,%eax
801044ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801044bd:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044c7:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801044ca:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801044ce:	ba be 65 10 80       	mov    $0x801065be,%edx
801044d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044d6:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801044d8:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801044dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044df:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044e2:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e8:	8b 40 1c             	mov    0x1c(%eax),%eax
801044eb:	83 ec 04             	sub    $0x4,%esp
801044ee:	6a 14                	push   $0x14
801044f0:	6a 00                	push   $0x0
801044f2:	50                   	push   %eax
801044f3:	e8 ea 0c 00 00       	call   801051e2 <memset>
801044f8:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801044fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044fe:	8b 40 1c             	mov    0x1c(%eax),%eax
80104501:	ba 51 4c 10 80       	mov    $0x80104c51,%edx
80104506:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104509:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010450c:	c9                   	leave  
8010450d:	c3                   	ret    

8010450e <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010450e:	55                   	push   %ebp
8010450f:	89 e5                	mov    %esp,%ebp
80104511:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104514:	e8 f0 fe ff ff       	call   80104409 <allocproc>
80104519:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010451c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451f:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->pgdir = setupkvm()) == 0)
80104524:	e8 4e 37 00 00       	call   80107c77 <setupkvm>
80104529:	89 c2                	mov    %eax,%edx
8010452b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010452e:	89 50 04             	mov    %edx,0x4(%eax)
80104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104534:	8b 40 04             	mov    0x4(%eax),%eax
80104537:	85 c0                	test   %eax,%eax
80104539:	75 0d                	jne    80104548 <userinit+0x3a>
    panic("userinit: out of memory?");
8010453b:	83 ec 0c             	sub    $0xc,%esp
8010453e:	68 d8 87 10 80       	push   $0x801087d8
80104543:	e8 14 c0 ff ff       	call   8010055c <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104548:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010454d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104550:	8b 40 04             	mov    0x4(%eax),%eax
80104553:	83 ec 04             	sub    $0x4,%esp
80104556:	52                   	push   %edx
80104557:	68 00 b5 10 80       	push   $0x8010b500
8010455c:	50                   	push   %eax
8010455d:	e8 6c 39 00 00       	call   80107ece <inituvm>
80104562:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104568:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104571:	8b 40 18             	mov    0x18(%eax),%eax
80104574:	83 ec 04             	sub    $0x4,%esp
80104577:	6a 4c                	push   $0x4c
80104579:	6a 00                	push   $0x0
8010457b:	50                   	push   %eax
8010457c:	e8 61 0c 00 00       	call   801051e2 <memset>
80104581:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104587:	8b 40 18             	mov    0x18(%eax),%eax
8010458a:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104593:	8b 40 18             	mov    0x18(%eax),%eax
80104596:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010459c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459f:	8b 40 18             	mov    0x18(%eax),%eax
801045a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045a5:	8b 52 18             	mov    0x18(%edx),%edx
801045a8:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045ac:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801045b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b3:	8b 40 18             	mov    0x18(%eax),%eax
801045b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045b9:	8b 52 18             	mov    0x18(%edx),%edx
801045bc:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801045c0:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801045c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c7:	8b 40 18             	mov    0x18(%eax),%eax
801045ca:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801045d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d4:	8b 40 18             	mov    0x18(%eax),%eax
801045d7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801045de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e1:	8b 40 18             	mov    0x18(%eax),%eax
801045e4:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801045eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ee:	83 c0 6c             	add    $0x6c,%eax
801045f1:	83 ec 04             	sub    $0x4,%esp
801045f4:	6a 10                	push   $0x10
801045f6:	68 f1 87 10 80       	push   $0x801087f1
801045fb:	50                   	push   %eax
801045fc:	e8 e6 0d 00 00       	call   801053e7 <safestrcpy>
80104601:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	68 fa 87 10 80       	push   $0x801087fa
8010460c:	e8 d3 de ff ff       	call   801024e4 <namei>
80104611:	83 c4 10             	add    $0x10,%esp
80104614:	89 c2                	mov    %eax,%edx
80104616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104619:	89 50 68             	mov    %edx,0x68(%eax)

  p->state = RUNNABLE;
8010461c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104626:	c9                   	leave  
80104627:	c3                   	ret    

80104628 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104628:	55                   	push   %ebp
80104629:	89 e5                	mov    %esp,%ebp
8010462b:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010462e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104634:	8b 00                	mov    (%eax),%eax
80104636:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104639:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010463d:	7e 31                	jle    80104670 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010463f:	8b 55 08             	mov    0x8(%ebp),%edx
80104642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104645:	01 c2                	add    %eax,%edx
80104647:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010464d:	8b 40 04             	mov    0x4(%eax),%eax
80104650:	83 ec 04             	sub    $0x4,%esp
80104653:	52                   	push   %edx
80104654:	ff 75 f4             	pushl  -0xc(%ebp)
80104657:	50                   	push   %eax
80104658:	e8 bd 39 00 00       	call   8010801a <allocuvm>
8010465d:	83 c4 10             	add    $0x10,%esp
80104660:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104667:	75 3e                	jne    801046a7 <growproc+0x7f>
      return -1;
80104669:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010466e:	eb 59                	jmp    801046c9 <growproc+0xa1>
  } else if(n < 0){
80104670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104674:	79 31                	jns    801046a7 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104676:	8b 55 08             	mov    0x8(%ebp),%edx
80104679:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467c:	01 c2                	add    %eax,%edx
8010467e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104684:	8b 40 04             	mov    0x4(%eax),%eax
80104687:	83 ec 04             	sub    $0x4,%esp
8010468a:	52                   	push   %edx
8010468b:	ff 75 f4             	pushl  -0xc(%ebp)
8010468e:	50                   	push   %eax
8010468f:	e8 4f 3a 00 00       	call   801080e3 <deallocuvm>
80104694:	83 c4 10             	add    $0x10,%esp
80104697:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010469a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010469e:	75 07                	jne    801046a7 <growproc+0x7f>
      return -1;
801046a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a5:	eb 22                	jmp    801046c9 <growproc+0xa1>
  }
  proc->sz = sz;
801046a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046b0:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801046b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	50                   	push   %eax
801046bc:	e8 9b 36 00 00       	call   80107d5c <switchuvm>
801046c1:	83 c4 10             	add    $0x10,%esp
  return 0;
801046c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046c9:	c9                   	leave  
801046ca:	c3                   	ret    

801046cb <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801046cb:	55                   	push   %ebp
801046cc:	89 e5                	mov    %esp,%ebp
801046ce:	57                   	push   %edi
801046cf:	56                   	push   %esi
801046d0:	53                   	push   %ebx
801046d1:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801046d4:	e8 30 fd ff ff       	call   80104409 <allocproc>
801046d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801046dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801046e0:	75 0a                	jne    801046ec <fork+0x21>
    return -1;
801046e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046e7:	e9 68 01 00 00       	jmp    80104854 <fork+0x189>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801046ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f2:	8b 10                	mov    (%eax),%edx
801046f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fa:	8b 40 04             	mov    0x4(%eax),%eax
801046fd:	83 ec 08             	sub    $0x8,%esp
80104700:	52                   	push   %edx
80104701:	50                   	push   %eax
80104702:	e8 78 3b 00 00       	call   8010827f <copyuvm>
80104707:	83 c4 10             	add    $0x10,%esp
8010470a:	89 c2                	mov    %eax,%edx
8010470c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010470f:	89 50 04             	mov    %edx,0x4(%eax)
80104712:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104715:	8b 40 04             	mov    0x4(%eax),%eax
80104718:	85 c0                	test   %eax,%eax
8010471a:	75 30                	jne    8010474c <fork+0x81>
    kfree(np->kstack);
8010471c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010471f:	8b 40 08             	mov    0x8(%eax),%eax
80104722:	83 ec 0c             	sub    $0xc,%esp
80104725:	50                   	push   %eax
80104726:	e8 4d e4 ff ff       	call   80102b78 <kfree>
8010472b:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010472e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104731:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80104738:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010473b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104742:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104747:	e9 08 01 00 00       	jmp    80104854 <fork+0x189>
  }
  np->sz = proc->sz;
8010474c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104752:	8b 10                	mov    (%eax),%edx
80104754:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104757:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104759:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104760:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104763:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104766:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104769:	8b 50 18             	mov    0x18(%eax),%edx
8010476c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104772:	8b 40 18             	mov    0x18(%eax),%eax
80104775:	89 c3                	mov    %eax,%ebx
80104777:	b8 13 00 00 00       	mov    $0x13,%eax
8010477c:	89 d7                	mov    %edx,%edi
8010477e:	89 de                	mov    %ebx,%esi
80104780:	89 c1                	mov    %eax,%ecx
80104782:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104784:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104787:	8b 40 18             	mov    0x18(%eax),%eax
8010478a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104791:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104798:	eb 43                	jmp    801047dd <fork+0x112>
    if(proc->ofile[i])
8010479a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047a3:	83 c2 08             	add    $0x8,%edx
801047a6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047aa:	85 c0                	test   %eax,%eax
801047ac:	74 2b                	je     801047d9 <fork+0x10e>
      np->ofile[i] = filedup(proc->ofile[i]);
801047ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047b7:	83 c2 08             	add    $0x8,%edx
801047ba:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801047be:	83 ec 0c             	sub    $0xc,%esp
801047c1:	50                   	push   %eax
801047c2:	e8 00 c8 ff ff       	call   80100fc7 <filedup>
801047c7:	83 c4 10             	add    $0x10,%esp
801047ca:	89 c1                	mov    %eax,%ecx
801047cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801047d2:	83 c2 08             	add    $0x8,%edx
801047d5:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801047d9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801047dd:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801047e1:	7e b7                	jle    8010479a <fork+0xcf>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
801047e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e9:	8b 40 68             	mov    0x68(%eax),%eax
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	50                   	push   %eax
801047f0:	e8 fa d0 ff ff       	call   801018ef <idup>
801047f5:	83 c4 10             	add    $0x10,%esp
801047f8:	89 c2                	mov    %eax,%edx
801047fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047fd:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104800:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104806:	8d 50 6c             	lea    0x6c(%eax),%edx
80104809:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010480c:	83 c0 6c             	add    $0x6c,%eax
8010480f:	83 ec 04             	sub    $0x4,%esp
80104812:	6a 10                	push   $0x10
80104814:	52                   	push   %edx
80104815:	50                   	push   %eax
80104816:	e8 cc 0b 00 00       	call   801053e7 <safestrcpy>
8010481b:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
8010481e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104821:	8b 40 10             	mov    0x10(%eax),%eax
80104824:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104827:	83 ec 0c             	sub    $0xc,%esp
8010482a:	68 80 2a 11 80       	push   $0x80112a80
8010482f:	e8 52 07 00 00       	call   80104f86 <acquire>
80104834:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104837:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010483a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104841:	83 ec 0c             	sub    $0xc,%esp
80104844:	68 80 2a 11 80       	push   $0x80112a80
80104849:	e8 9e 07 00 00       	call   80104fec <release>
8010484e:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104851:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104854:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104857:	5b                   	pop    %ebx
80104858:	5e                   	pop    %esi
80104859:	5f                   	pop    %edi
8010485a:	5d                   	pop    %ebp
8010485b:	c3                   	ret    

8010485c <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010485c:	55                   	push   %ebp
8010485d:	89 e5                	mov    %esp,%ebp
8010485f:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104862:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104869:	a1 68 b6 10 80       	mov    0x8010b668,%eax
8010486e:	39 c2                	cmp    %eax,%edx
80104870:	75 0d                	jne    8010487f <exit+0x23>
    panic("init exiting");
80104872:	83 ec 0c             	sub    $0xc,%esp
80104875:	68 fc 87 10 80       	push   $0x801087fc
8010487a:	e8 dd bc ff ff       	call   8010055c <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010487f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104886:	eb 48                	jmp    801048d0 <exit+0x74>
    if(proc->ofile[fd]){
80104888:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104891:	83 c2 08             	add    $0x8,%edx
80104894:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104898:	85 c0                	test   %eax,%eax
8010489a:	74 30                	je     801048cc <exit+0x70>
      fileclose(proc->ofile[fd]);
8010489c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048a5:	83 c2 08             	add    $0x8,%edx
801048a8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048ac:	83 ec 0c             	sub    $0xc,%esp
801048af:	50                   	push   %eax
801048b0:	e8 63 c7 ff ff       	call   80101018 <fileclose>
801048b5:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801048b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048be:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048c1:	83 c2 08             	add    $0x8,%edx
801048c4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048cb:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048d0:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048d4:	7e b2                	jle    80104888 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048d6:	e8 12 ec ff ff       	call   801034ed <begin_op>
  iput(proc->cwd);
801048db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e1:	8b 40 68             	mov    0x68(%eax),%eax
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	50                   	push   %eax
801048e8:	e8 0a d2 ff ff       	call   80101af7 <iput>
801048ed:	83 c4 10             	add    $0x10,%esp
  end_op();
801048f0:	e8 86 ec ff ff       	call   8010357b <end_op>
  proc->cwd = 0;
801048f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fb:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104902:	83 ec 0c             	sub    $0xc,%esp
80104905:	68 80 2a 11 80       	push   $0x80112a80
8010490a:	e8 77 06 00 00       	call   80104f86 <acquire>
8010490f:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104912:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104918:	8b 40 14             	mov    0x14(%eax),%eax
8010491b:	83 ec 0c             	sub    $0xc,%esp
8010491e:	50                   	push   %eax
8010491f:	e8 1d 04 00 00       	call   80104d41 <wakeup1>
80104924:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104927:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
8010492e:	eb 3c                	jmp    8010496c <exit+0x110>
    if(p->parent == proc){
80104930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104933:	8b 50 14             	mov    0x14(%eax),%edx
80104936:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010493c:	39 c2                	cmp    %eax,%edx
8010493e:	75 28                	jne    80104968 <exit+0x10c>
      p->parent = initproc;
80104940:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
80104946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104949:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010494c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010494f:	8b 40 0c             	mov    0xc(%eax),%eax
80104952:	83 f8 05             	cmp    $0x5,%eax
80104955:	75 11                	jne    80104968 <exit+0x10c>
        wakeup1(initproc);
80104957:	a1 68 b6 10 80       	mov    0x8010b668,%eax
8010495c:	83 ec 0c             	sub    $0xc,%esp
8010495f:	50                   	push   %eax
80104960:	e8 dc 03 00 00       	call   80104d41 <wakeup1>
80104965:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104968:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010496c:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104973:	72 bb                	jb     80104930 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104975:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497b:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104982:	e8 d5 01 00 00       	call   80104b5c <sched>
  panic("zombie exit");
80104987:	83 ec 0c             	sub    $0xc,%esp
8010498a:	68 09 88 10 80       	push   $0x80108809
8010498f:	e8 c8 bb ff ff       	call   8010055c <panic>

80104994 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
8010499a:	83 ec 0c             	sub    $0xc,%esp
8010499d:	68 80 2a 11 80       	push   $0x80112a80
801049a2:	e8 df 05 00 00       	call   80104f86 <acquire>
801049a7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801049aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b1:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
801049b8:	e9 a6 00 00 00       	jmp    80104a63 <wait+0xcf>
      if(p->parent != proc)
801049bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c0:	8b 50 14             	mov    0x14(%eax),%edx
801049c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c9:	39 c2                	cmp    %eax,%edx
801049cb:	74 05                	je     801049d2 <wait+0x3e>
        continue;
801049cd:	e9 8d 00 00 00       	jmp    80104a5f <wait+0xcb>
      havekids = 1;
801049d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049dc:	8b 40 0c             	mov    0xc(%eax),%eax
801049df:	83 f8 05             	cmp    $0x5,%eax
801049e2:	75 7b                	jne    80104a5f <wait+0xcb>
        // Found one.
        pid = p->pid;
801049e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e7:	8b 40 10             	mov    0x10(%eax),%eax
801049ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801049ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f0:	8b 40 08             	mov    0x8(%eax),%eax
801049f3:	83 ec 0c             	sub    $0xc,%esp
801049f6:	50                   	push   %eax
801049f7:	e8 7c e1 ff ff       	call   80102b78 <kfree>
801049fc:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
801049ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0c:	8b 40 04             	mov    0x4(%eax),%eax
80104a0f:	83 ec 0c             	sub    $0xc,%esp
80104a12:	50                   	push   %eax
80104a13:	e8 88 37 00 00       	call   801081a0 <freevm>
80104a18:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a28:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a32:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a43:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	68 80 2a 11 80       	push   $0x80112a80
80104a52:	e8 95 05 00 00       	call   80104fec <release>
80104a57:	83 c4 10             	add    $0x10,%esp
        return pid;
80104a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a5d:	eb 57                	jmp    80104ab6 <wait+0x122>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a5f:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a63:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104a6a:	0f 82 4d ff ff ff    	jb     801049bd <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a74:	74 0d                	je     80104a83 <wait+0xef>
80104a76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7c:	8b 40 24             	mov    0x24(%eax),%eax
80104a7f:	85 c0                	test   %eax,%eax
80104a81:	74 17                	je     80104a9a <wait+0x106>
      release(&ptable.lock);
80104a83:	83 ec 0c             	sub    $0xc,%esp
80104a86:	68 80 2a 11 80       	push   $0x80112a80
80104a8b:	e8 5c 05 00 00       	call   80104fec <release>
80104a90:	83 c4 10             	add    $0x10,%esp
      return -1;
80104a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a98:	eb 1c                	jmp    80104ab6 <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aa0:	83 ec 08             	sub    $0x8,%esp
80104aa3:	68 80 2a 11 80       	push   $0x80112a80
80104aa8:	50                   	push   %eax
80104aa9:	e8 e8 01 00 00       	call   80104c96 <sleep>
80104aae:	83 c4 10             	add    $0x10,%esp
  }
80104ab1:	e9 f4 fe ff ff       	jmp    801049aa <wait+0x16>
}
80104ab6:	c9                   	leave  
80104ab7:	c3                   	ret    

80104ab8 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104ab8:	55                   	push   %ebp
80104ab9:	89 e5                	mov    %esp,%ebp
80104abb:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104abe:	e8 23 f9 ff ff       	call   801043e6 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104ac3:	83 ec 0c             	sub    $0xc,%esp
80104ac6:	68 80 2a 11 80       	push   $0x80112a80
80104acb:	e8 b6 04 00 00       	call   80104f86 <acquire>
80104ad0:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ad3:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80104ada:	eb 62                	jmp    80104b3e <scheduler+0x86>
      if(p->state != RUNNABLE)
80104adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104adf:	8b 40 0c             	mov    0xc(%eax),%eax
80104ae2:	83 f8 03             	cmp    $0x3,%eax
80104ae5:	74 02                	je     80104ae9 <scheduler+0x31>
        continue;
80104ae7:	eb 51                	jmp    80104b3a <scheduler+0x82>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aec:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104af2:	83 ec 0c             	sub    $0xc,%esp
80104af5:	ff 75 f4             	pushl  -0xc(%ebp)
80104af8:	e8 5f 32 00 00       	call   80107d5c <switchuvm>
80104afd:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b03:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104b0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b10:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b13:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b1a:	83 c2 04             	add    $0x4,%edx
80104b1d:	83 ec 08             	sub    $0x8,%esp
80104b20:	50                   	push   %eax
80104b21:	52                   	push   %edx
80104b22:	e8 31 09 00 00       	call   80105458 <swtch>
80104b27:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104b2a:	e8 11 32 00 00       	call   80107d40 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104b2f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104b36:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b3a:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b3e:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104b45:	72 95                	jb     80104adc <scheduler+0x24>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104b47:	83 ec 0c             	sub    $0xc,%esp
80104b4a:	68 80 2a 11 80       	push   $0x80112a80
80104b4f:	e8 98 04 00 00       	call   80104fec <release>
80104b54:	83 c4 10             	add    $0x10,%esp

  }
80104b57:	e9 62 ff ff ff       	jmp    80104abe <scheduler+0x6>

80104b5c <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104b5c:	55                   	push   %ebp
80104b5d:	89 e5                	mov    %esp,%ebp
80104b5f:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	68 80 2a 11 80       	push   $0x80112a80
80104b6a:	e8 47 05 00 00       	call   801050b6 <holding>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	75 0d                	jne    80104b83 <sched+0x27>
    panic("sched ptable.lock");
80104b76:	83 ec 0c             	sub    $0xc,%esp
80104b79:	68 15 88 10 80       	push   $0x80108815
80104b7e:	e8 d9 b9 ff ff       	call   8010055c <panic>
  if(cpu->ncli != 1)
80104b83:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104b89:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104b8f:	83 f8 01             	cmp    $0x1,%eax
80104b92:	74 0d                	je     80104ba1 <sched+0x45>
    panic("sched locks");
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	68 27 88 10 80       	push   $0x80108827
80104b9c:	e8 bb b9 ff ff       	call   8010055c <panic>
  if(proc->state == RUNNING)
80104ba1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ba7:	8b 40 0c             	mov    0xc(%eax),%eax
80104baa:	83 f8 04             	cmp    $0x4,%eax
80104bad:	75 0d                	jne    80104bbc <sched+0x60>
    panic("sched running");
80104baf:	83 ec 0c             	sub    $0xc,%esp
80104bb2:	68 33 88 10 80       	push   $0x80108833
80104bb7:	e8 a0 b9 ff ff       	call   8010055c <panic>
  if(readeflags()&FL_IF)
80104bbc:	e8 15 f8 ff ff       	call   801043d6 <readeflags>
80104bc1:	25 00 02 00 00       	and    $0x200,%eax
80104bc6:	85 c0                	test   %eax,%eax
80104bc8:	74 0d                	je     80104bd7 <sched+0x7b>
    panic("sched interruptible");
80104bca:	83 ec 0c             	sub    $0xc,%esp
80104bcd:	68 41 88 10 80       	push   $0x80108841
80104bd2:	e8 85 b9 ff ff       	call   8010055c <panic>
  intena = cpu->intena;
80104bd7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bdd:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104be6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104bec:	8b 40 04             	mov    0x4(%eax),%eax
80104bef:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104bf6:	83 c2 1c             	add    $0x1c,%edx
80104bf9:	83 ec 08             	sub    $0x8,%esp
80104bfc:	50                   	push   %eax
80104bfd:	52                   	push   %edx
80104bfe:	e8 55 08 00 00       	call   80105458 <swtch>
80104c03:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104c06:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c0f:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    

80104c17 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104c17:	55                   	push   %ebp
80104c18:	89 e5                	mov    %esp,%ebp
80104c1a:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104c1d:	83 ec 0c             	sub    $0xc,%esp
80104c20:	68 80 2a 11 80       	push   $0x80112a80
80104c25:	e8 5c 03 00 00       	call   80104f86 <acquire>
80104c2a:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104c2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c33:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104c3a:	e8 1d ff ff ff       	call   80104b5c <sched>
  release(&ptable.lock);
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	68 80 2a 11 80       	push   $0x80112a80
80104c47:	e8 a0 03 00 00       	call   80104fec <release>
80104c4c:	83 c4 10             	add    $0x10,%esp
}
80104c4f:	c9                   	leave  
80104c50:	c3                   	ret    

80104c51 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104c51:	55                   	push   %ebp
80104c52:	89 e5                	mov    %esp,%ebp
80104c54:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104c57:	83 ec 0c             	sub    $0xc,%esp
80104c5a:	68 80 2a 11 80       	push   $0x80112a80
80104c5f:	e8 88 03 00 00       	call   80104fec <release>
80104c64:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104c67:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104c6c:	85 c0                	test   %eax,%eax
80104c6e:	74 24                	je     80104c94 <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104c70:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104c77:	00 00 00 
    iinit(ROOTDEV);
80104c7a:	83 ec 0c             	sub    $0xc,%esp
80104c7d:	6a 01                	push   $0x1
80104c7f:	e8 7c c9 ff ff       	call   80101600 <iinit>
80104c84:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104c87:	83 ec 0c             	sub    $0xc,%esp
80104c8a:	6a 01                	push   $0x1
80104c8c:	e8 43 e6 ff ff       	call   801032d4 <initlog>
80104c91:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104c94:	c9                   	leave  
80104c95:	c3                   	ret    

80104c96 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104c96:	55                   	push   %ebp
80104c97:	89 e5                	mov    %esp,%ebp
80104c99:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104c9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	75 0d                	jne    80104cb3 <sleep+0x1d>
    panic("sleep");
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	68 55 88 10 80       	push   $0x80108855
80104cae:	e8 a9 b8 ff ff       	call   8010055c <panic>

  if(lk == 0)
80104cb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104cb7:	75 0d                	jne    80104cc6 <sleep+0x30>
    panic("sleep without lk");
80104cb9:	83 ec 0c             	sub    $0xc,%esp
80104cbc:	68 5b 88 10 80       	push   $0x8010885b
80104cc1:	e8 96 b8 ff ff       	call   8010055c <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104cc6:	81 7d 0c 80 2a 11 80 	cmpl   $0x80112a80,0xc(%ebp)
80104ccd:	74 1e                	je     80104ced <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	68 80 2a 11 80       	push   $0x80112a80
80104cd7:	e8 aa 02 00 00       	call   80104f86 <acquire>
80104cdc:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104cdf:	83 ec 0c             	sub    $0xc,%esp
80104ce2:	ff 75 0c             	pushl  0xc(%ebp)
80104ce5:	e8 02 03 00 00       	call   80104fec <release>
80104cea:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104ced:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf3:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf6:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104cf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cff:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104d06:	e8 51 fe ff ff       	call   80104b5c <sched>

  // Tidy up.
  proc->chan = 0;
80104d0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d11:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104d18:	81 7d 0c 80 2a 11 80 	cmpl   $0x80112a80,0xc(%ebp)
80104d1f:	74 1e                	je     80104d3f <sleep+0xa9>
    release(&ptable.lock);
80104d21:	83 ec 0c             	sub    $0xc,%esp
80104d24:	68 80 2a 11 80       	push   $0x80112a80
80104d29:	e8 be 02 00 00       	call   80104fec <release>
80104d2e:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104d31:	83 ec 0c             	sub    $0xc,%esp
80104d34:	ff 75 0c             	pushl  0xc(%ebp)
80104d37:	e8 4a 02 00 00       	call   80104f86 <acquire>
80104d3c:	83 c4 10             	add    $0x10,%esp
  }
}
80104d3f:	c9                   	leave  
80104d40:	c3                   	ret    

80104d41 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104d41:	55                   	push   %ebp
80104d42:	89 e5                	mov    %esp,%ebp
80104d44:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d47:	c7 45 fc b4 2a 11 80 	movl   $0x80112ab4,-0x4(%ebp)
80104d4e:	eb 24                	jmp    80104d74 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d53:	8b 40 0c             	mov    0xc(%eax),%eax
80104d56:	83 f8 02             	cmp    $0x2,%eax
80104d59:	75 15                	jne    80104d70 <wakeup1+0x2f>
80104d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d5e:	8b 40 20             	mov    0x20(%eax),%eax
80104d61:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d64:	75 0a                	jne    80104d70 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104d66:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104d69:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d70:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104d74:	81 7d fc b4 49 11 80 	cmpl   $0x801149b4,-0x4(%ebp)
80104d7b:	72 d3                	jb     80104d50 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
80104d7d:	c9                   	leave  
80104d7e:	c3                   	ret    

80104d7f <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d7f:	55                   	push   %ebp
80104d80:	89 e5                	mov    %esp,%ebp
80104d82:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104d85:	83 ec 0c             	sub    $0xc,%esp
80104d88:	68 80 2a 11 80       	push   $0x80112a80
80104d8d:	e8 f4 01 00 00       	call   80104f86 <acquire>
80104d92:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104d95:	83 ec 0c             	sub    $0xc,%esp
80104d98:	ff 75 08             	pushl  0x8(%ebp)
80104d9b:	e8 a1 ff ff ff       	call   80104d41 <wakeup1>
80104da0:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104da3:	83 ec 0c             	sub    $0xc,%esp
80104da6:	68 80 2a 11 80       	push   $0x80112a80
80104dab:	e8 3c 02 00 00       	call   80104fec <release>
80104db0:	83 c4 10             	add    $0x10,%esp
}
80104db3:	c9                   	leave  
80104db4:	c3                   	ret    

80104db5 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104db5:	55                   	push   %ebp
80104db6:	89 e5                	mov    %esp,%ebp
80104db8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104dbb:	83 ec 0c             	sub    $0xc,%esp
80104dbe:	68 80 2a 11 80       	push   $0x80112a80
80104dc3:	e8 be 01 00 00       	call   80104f86 <acquire>
80104dc8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dcb:	c7 45 f4 b4 2a 11 80 	movl   $0x80112ab4,-0xc(%ebp)
80104dd2:	eb 45                	jmp    80104e19 <kill+0x64>
    if(p->pid == pid){
80104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd7:	8b 40 10             	mov    0x10(%eax),%eax
80104dda:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ddd:	75 36                	jne    80104e15 <kill+0x60>
      p->killed = 1;
80104ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dec:	8b 40 0c             	mov    0xc(%eax),%eax
80104def:	83 f8 02             	cmp    $0x2,%eax
80104df2:	75 0a                	jne    80104dfe <kill+0x49>
        p->state = RUNNABLE;
80104df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104dfe:	83 ec 0c             	sub    $0xc,%esp
80104e01:	68 80 2a 11 80       	push   $0x80112a80
80104e06:	e8 e1 01 00 00       	call   80104fec <release>
80104e0b:	83 c4 10             	add    $0x10,%esp
      return 0;
80104e0e:	b8 00 00 00 00       	mov    $0x0,%eax
80104e13:	eb 22                	jmp    80104e37 <kill+0x82>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e15:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104e19:	81 7d f4 b4 49 11 80 	cmpl   $0x801149b4,-0xc(%ebp)
80104e20:	72 b2                	jb     80104dd4 <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104e22:	83 ec 0c             	sub    $0xc,%esp
80104e25:	68 80 2a 11 80       	push   $0x80112a80
80104e2a:	e8 bd 01 00 00       	call   80104fec <release>
80104e2f:	83 c4 10             	add    $0x10,%esp
  return -1;
80104e32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e37:	c9                   	leave  
80104e38:	c3                   	ret    

80104e39 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104e39:	55                   	push   %ebp
80104e3a:	89 e5                	mov    %esp,%ebp
80104e3c:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e3f:	c7 45 f0 b4 2a 11 80 	movl   $0x80112ab4,-0x10(%ebp)
80104e46:	e9 d5 00 00 00       	jmp    80104f20 <procdump+0xe7>
    if(p->state == UNUSED)
80104e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e4e:	8b 40 0c             	mov    0xc(%eax),%eax
80104e51:	85 c0                	test   %eax,%eax
80104e53:	75 05                	jne    80104e5a <procdump+0x21>
      continue;
80104e55:	e9 c2 00 00 00       	jmp    80104f1c <procdump+0xe3>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e5d:	8b 40 0c             	mov    0xc(%eax),%eax
80104e60:	83 f8 05             	cmp    $0x5,%eax
80104e63:	77 23                	ja     80104e88 <procdump+0x4f>
80104e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e68:	8b 40 0c             	mov    0xc(%eax),%eax
80104e6b:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e72:	85 c0                	test   %eax,%eax
80104e74:	74 12                	je     80104e88 <procdump+0x4f>
      state = states[p->state];
80104e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e79:	8b 40 0c             	mov    0xc(%eax),%eax
80104e7c:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104e83:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e86:	eb 07                	jmp    80104e8f <procdump+0x56>
    else
      state = "???";
80104e88:	c7 45 ec 6c 88 10 80 	movl   $0x8010886c,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e92:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e98:	8b 40 10             	mov    0x10(%eax),%eax
80104e9b:	52                   	push   %edx
80104e9c:	ff 75 ec             	pushl  -0x14(%ebp)
80104e9f:	50                   	push   %eax
80104ea0:	68 70 88 10 80       	push   $0x80108870
80104ea5:	e8 15 b5 ff ff       	call   801003bf <cprintf>
80104eaa:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eb0:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb3:	83 f8 02             	cmp    $0x2,%eax
80104eb6:	75 54                	jne    80104f0c <procdump+0xd3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ebb:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ebe:	8b 40 0c             	mov    0xc(%eax),%eax
80104ec1:	83 c0 08             	add    $0x8,%eax
80104ec4:	89 c2                	mov    %eax,%edx
80104ec6:	83 ec 08             	sub    $0x8,%esp
80104ec9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ecc:	50                   	push   %eax
80104ecd:	52                   	push   %edx
80104ece:	e8 6a 01 00 00       	call   8010503d <getcallerpcs>
80104ed3:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104ed6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104edd:	eb 1c                	jmp    80104efb <procdump+0xc2>
        cprintf(" %p", pc[i]);
80104edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee2:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ee6:	83 ec 08             	sub    $0x8,%esp
80104ee9:	50                   	push   %eax
80104eea:	68 79 88 10 80       	push   $0x80108879
80104eef:	e8 cb b4 ff ff       	call   801003bf <cprintf>
80104ef4:	83 c4 10             	add    $0x10,%esp
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104ef7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104efb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104eff:	7f 0b                	jg     80104f0c <procdump+0xd3>
80104f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f04:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104f08:	85 c0                	test   %eax,%eax
80104f0a:	75 d3                	jne    80104edf <procdump+0xa6>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104f0c:	83 ec 0c             	sub    $0xc,%esp
80104f0f:	68 7d 88 10 80       	push   $0x8010887d
80104f14:	e8 a6 b4 ff ff       	call   801003bf <cprintf>
80104f19:	83 c4 10             	add    $0x10,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f1c:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
80104f20:	81 7d f0 b4 49 11 80 	cmpl   $0x801149b4,-0x10(%ebp)
80104f27:	0f 82 1e ff ff ff    	jb     80104e4b <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104f2d:	c9                   	leave  
80104f2e:	c3                   	ret    

80104f2f <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f2f:	55                   	push   %ebp
80104f30:	89 e5                	mov    %esp,%ebp
80104f32:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f35:	9c                   	pushf  
80104f36:	58                   	pop    %eax
80104f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f3d:	c9                   	leave  
80104f3e:	c3                   	ret    

80104f3f <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f3f:	55                   	push   %ebp
80104f40:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f42:	fa                   	cli    
}
80104f43:	5d                   	pop    %ebp
80104f44:	c3                   	ret    

80104f45 <sti>:

static inline void
sti(void)
{
80104f45:	55                   	push   %ebp
80104f46:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f48:	fb                   	sti    
}
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    

80104f4b <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f4b:	55                   	push   %ebp
80104f4c:	89 e5                	mov    %esp,%ebp
80104f4e:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f51:	8b 55 08             	mov    0x8(%ebp),%edx
80104f54:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f57:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f5a:	f0 87 02             	lock xchg %eax,(%edx)
80104f5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f63:	c9                   	leave  
80104f64:	c3                   	ret    

80104f65 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f65:	55                   	push   %ebp
80104f66:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f68:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f6e:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f71:	8b 45 08             	mov    0x8(%ebp),%eax
80104f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f84:	5d                   	pop    %ebp
80104f85:	c3                   	ret    

80104f86 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f86:	55                   	push   %ebp
80104f87:	89 e5                	mov    %esp,%ebp
80104f89:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f8c:	e8 4f 01 00 00       	call   801050e0 <pushcli>
  if(holding(lk))
80104f91:	8b 45 08             	mov    0x8(%ebp),%eax
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	50                   	push   %eax
80104f98:	e8 19 01 00 00       	call   801050b6 <holding>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	74 0d                	je     80104fb1 <acquire+0x2b>
    panic("acquire");
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	68 a9 88 10 80       	push   $0x801088a9
80104fac:	e8 ab b5 ff ff       	call   8010055c <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104fb1:	90                   	nop
80104fb2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb5:	83 ec 08             	sub    $0x8,%esp
80104fb8:	6a 01                	push   $0x1
80104fba:	50                   	push   %eax
80104fbb:	e8 8b ff ff ff       	call   80104f4b <xchg>
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	85 c0                	test   %eax,%eax
80104fc5:	75 eb                	jne    80104fb2 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104fc7:	8b 45 08             	mov    0x8(%ebp),%eax
80104fca:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fd1:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104fd4:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd7:	83 c0 0c             	add    $0xc,%eax
80104fda:	83 ec 08             	sub    $0x8,%esp
80104fdd:	50                   	push   %eax
80104fde:	8d 45 08             	lea    0x8(%ebp),%eax
80104fe1:	50                   	push   %eax
80104fe2:	e8 56 00 00 00       	call   8010503d <getcallerpcs>
80104fe7:	83 c4 10             	add    $0x10,%esp
}
80104fea:	c9                   	leave  
80104feb:	c3                   	ret    

80104fec <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fec:	55                   	push   %ebp
80104fed:	89 e5                	mov    %esp,%ebp
80104fef:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80104ff2:	83 ec 0c             	sub    $0xc,%esp
80104ff5:	ff 75 08             	pushl  0x8(%ebp)
80104ff8:	e8 b9 00 00 00       	call   801050b6 <holding>
80104ffd:	83 c4 10             	add    $0x10,%esp
80105000:	85 c0                	test   %eax,%eax
80105002:	75 0d                	jne    80105011 <release+0x25>
    panic("release");
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	68 b1 88 10 80       	push   $0x801088b1
8010500c:	e8 4b b5 ff ff       	call   8010055c <panic>

  lk->pcs[0] = 0;
80105011:	8b 45 08             	mov    0x8(%ebp),%eax
80105014:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010501b:	8b 45 08             	mov    0x8(%ebp),%eax
8010501e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105025:	8b 45 08             	mov    0x8(%ebp),%eax
80105028:	83 ec 08             	sub    $0x8,%esp
8010502b:	6a 00                	push   $0x0
8010502d:	50                   	push   %eax
8010502e:	e8 18 ff ff ff       	call   80104f4b <xchg>
80105033:	83 c4 10             	add    $0x10,%esp

  popcli();
80105036:	e8 e9 00 00 00       	call   80105124 <popcli>
}
8010503b:	c9                   	leave  
8010503c:	c3                   	ret    

8010503d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010503d:	55                   	push   %ebp
8010503e:	89 e5                	mov    %esp,%ebp
80105040:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105043:	8b 45 08             	mov    0x8(%ebp),%eax
80105046:	83 e8 08             	sub    $0x8,%eax
80105049:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010504c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105053:	eb 38                	jmp    8010508d <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105055:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105059:	74 38                	je     80105093 <getcallerpcs+0x56>
8010505b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105062:	76 2f                	jbe    80105093 <getcallerpcs+0x56>
80105064:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105068:	74 29                	je     80105093 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010506a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010506d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105074:	8b 45 0c             	mov    0xc(%ebp),%eax
80105077:	01 c2                	add    %eax,%edx
80105079:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010507c:	8b 40 04             	mov    0x4(%eax),%eax
8010507f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105081:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105084:	8b 00                	mov    (%eax),%eax
80105086:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105089:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010508d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105091:	7e c2                	jle    80105055 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105093:	eb 19                	jmp    801050ae <getcallerpcs+0x71>
    pcs[i] = 0;
80105095:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105098:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010509f:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a2:	01 d0                	add    %edx,%eax
801050a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801050aa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801050ae:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050b2:	7e e1                	jle    80105095 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801050b4:	c9                   	leave  
801050b5:	c3                   	ret    

801050b6 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801050b6:	55                   	push   %ebp
801050b7:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801050b9:	8b 45 08             	mov    0x8(%ebp),%eax
801050bc:	8b 00                	mov    (%eax),%eax
801050be:	85 c0                	test   %eax,%eax
801050c0:	74 17                	je     801050d9 <holding+0x23>
801050c2:	8b 45 08             	mov    0x8(%ebp),%eax
801050c5:	8b 50 08             	mov    0x8(%eax),%edx
801050c8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050ce:	39 c2                	cmp    %eax,%edx
801050d0:	75 07                	jne    801050d9 <holding+0x23>
801050d2:	b8 01 00 00 00       	mov    $0x1,%eax
801050d7:	eb 05                	jmp    801050de <holding+0x28>
801050d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050de:	5d                   	pop    %ebp
801050df:	c3                   	ret    

801050e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801050e6:	e8 44 fe ff ff       	call   80104f2f <readeflags>
801050eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801050ee:	e8 4c fe ff ff       	call   80104f3f <cli>
  if(cpu->ncli++ == 0)
801050f3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801050fa:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105100:	8d 48 01             	lea    0x1(%eax),%ecx
80105103:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105109:	85 c0                	test   %eax,%eax
8010510b:	75 15                	jne    80105122 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
8010510d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105113:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105116:	81 e2 00 02 00 00    	and    $0x200,%edx
8010511c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105122:	c9                   	leave  
80105123:	c3                   	ret    

80105124 <popcli>:

void
popcli(void)
{
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010512a:	e8 00 fe ff ff       	call   80104f2f <readeflags>
8010512f:	25 00 02 00 00       	and    $0x200,%eax
80105134:	85 c0                	test   %eax,%eax
80105136:	74 0d                	je     80105145 <popcli+0x21>
    panic("popcli - interruptible");
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	68 b9 88 10 80       	push   $0x801088b9
80105140:	e8 17 b4 ff ff       	call   8010055c <panic>
  if(--cpu->ncli < 0)
80105145:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010514b:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105151:	83 ea 01             	sub    $0x1,%edx
80105154:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010515a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105160:	85 c0                	test   %eax,%eax
80105162:	79 0d                	jns    80105171 <popcli+0x4d>
    panic("popcli");
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	68 d0 88 10 80       	push   $0x801088d0
8010516c:	e8 eb b3 ff ff       	call   8010055c <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105171:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105177:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010517d:	85 c0                	test   %eax,%eax
8010517f:	75 15                	jne    80105196 <popcli+0x72>
80105181:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105187:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010518d:	85 c0                	test   %eax,%eax
8010518f:	74 05                	je     80105196 <popcli+0x72>
    sti();
80105191:	e8 af fd ff ff       	call   80104f45 <sti>
}
80105196:	c9                   	leave  
80105197:	c3                   	ret    

80105198 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80105198:	55                   	push   %ebp
80105199:	89 e5                	mov    %esp,%ebp
8010519b:	57                   	push   %edi
8010519c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010519d:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051a0:	8b 55 10             	mov    0x10(%ebp),%edx
801051a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801051a6:	89 cb                	mov    %ecx,%ebx
801051a8:	89 df                	mov    %ebx,%edi
801051aa:	89 d1                	mov    %edx,%ecx
801051ac:	fc                   	cld    
801051ad:	f3 aa                	rep stos %al,%es:(%edi)
801051af:	89 ca                	mov    %ecx,%edx
801051b1:	89 fb                	mov    %edi,%ebx
801051b3:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051b6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051b9:	5b                   	pop    %ebx
801051ba:	5f                   	pop    %edi
801051bb:	5d                   	pop    %ebp
801051bc:	c3                   	ret    

801051bd <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801051bd:	55                   	push   %ebp
801051be:	89 e5                	mov    %esp,%ebp
801051c0:	57                   	push   %edi
801051c1:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051c5:	8b 55 10             	mov    0x10(%ebp),%edx
801051c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801051cb:	89 cb                	mov    %ecx,%ebx
801051cd:	89 df                	mov    %ebx,%edi
801051cf:	89 d1                	mov    %edx,%ecx
801051d1:	fc                   	cld    
801051d2:	f3 ab                	rep stos %eax,%es:(%edi)
801051d4:	89 ca                	mov    %ecx,%edx
801051d6:	89 fb                	mov    %edi,%ebx
801051d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051de:	5b                   	pop    %ebx
801051df:	5f                   	pop    %edi
801051e0:	5d                   	pop    %ebp
801051e1:	c3                   	ret    

801051e2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051e2:	55                   	push   %ebp
801051e3:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801051e5:	8b 45 08             	mov    0x8(%ebp),%eax
801051e8:	83 e0 03             	and    $0x3,%eax
801051eb:	85 c0                	test   %eax,%eax
801051ed:	75 43                	jne    80105232 <memset+0x50>
801051ef:	8b 45 10             	mov    0x10(%ebp),%eax
801051f2:	83 e0 03             	and    $0x3,%eax
801051f5:	85 c0                	test   %eax,%eax
801051f7:	75 39                	jne    80105232 <memset+0x50>
    c &= 0xFF;
801051f9:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105200:	8b 45 10             	mov    0x10(%ebp),%eax
80105203:	c1 e8 02             	shr    $0x2,%eax
80105206:	89 c1                	mov    %eax,%ecx
80105208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520b:	c1 e0 18             	shl    $0x18,%eax
8010520e:	89 c2                	mov    %eax,%edx
80105210:	8b 45 0c             	mov    0xc(%ebp),%eax
80105213:	c1 e0 10             	shl    $0x10,%eax
80105216:	09 c2                	or     %eax,%edx
80105218:	8b 45 0c             	mov    0xc(%ebp),%eax
8010521b:	c1 e0 08             	shl    $0x8,%eax
8010521e:	09 d0                	or     %edx,%eax
80105220:	0b 45 0c             	or     0xc(%ebp),%eax
80105223:	51                   	push   %ecx
80105224:	50                   	push   %eax
80105225:	ff 75 08             	pushl  0x8(%ebp)
80105228:	e8 90 ff ff ff       	call   801051bd <stosl>
8010522d:	83 c4 0c             	add    $0xc,%esp
80105230:	eb 12                	jmp    80105244 <memset+0x62>
  } else
    stosb(dst, c, n);
80105232:	8b 45 10             	mov    0x10(%ebp),%eax
80105235:	50                   	push   %eax
80105236:	ff 75 0c             	pushl  0xc(%ebp)
80105239:	ff 75 08             	pushl  0x8(%ebp)
8010523c:	e8 57 ff ff ff       	call   80105198 <stosb>
80105241:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105244:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105247:	c9                   	leave  
80105248:	c3                   	ret    

80105249 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105249:	55                   	push   %ebp
8010524a:	89 e5                	mov    %esp,%ebp
8010524c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010524f:	8b 45 08             	mov    0x8(%ebp),%eax
80105252:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105255:	8b 45 0c             	mov    0xc(%ebp),%eax
80105258:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010525b:	eb 30                	jmp    8010528d <memcmp+0x44>
    if(*s1 != *s2)
8010525d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105260:	0f b6 10             	movzbl (%eax),%edx
80105263:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105266:	0f b6 00             	movzbl (%eax),%eax
80105269:	38 c2                	cmp    %al,%dl
8010526b:	74 18                	je     80105285 <memcmp+0x3c>
      return *s1 - *s2;
8010526d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105270:	0f b6 00             	movzbl (%eax),%eax
80105273:	0f b6 d0             	movzbl %al,%edx
80105276:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105279:	0f b6 00             	movzbl (%eax),%eax
8010527c:	0f b6 c0             	movzbl %al,%eax
8010527f:	29 c2                	sub    %eax,%edx
80105281:	89 d0                	mov    %edx,%eax
80105283:	eb 1a                	jmp    8010529f <memcmp+0x56>
    s1++, s2++;
80105285:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105289:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010528d:	8b 45 10             	mov    0x10(%ebp),%eax
80105290:	8d 50 ff             	lea    -0x1(%eax),%edx
80105293:	89 55 10             	mov    %edx,0x10(%ebp)
80105296:	85 c0                	test   %eax,%eax
80105298:	75 c3                	jne    8010525d <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010529a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010529f:	c9                   	leave  
801052a0:	c3                   	ret    

801052a1 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052a1:	55                   	push   %ebp
801052a2:	89 e5                	mov    %esp,%ebp
801052a4:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801052a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801052aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801052ad:	8b 45 08             	mov    0x8(%ebp),%eax
801052b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052b9:	73 3d                	jae    801052f8 <memmove+0x57>
801052bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052be:	8b 45 10             	mov    0x10(%ebp),%eax
801052c1:	01 d0                	add    %edx,%eax
801052c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052c6:	76 30                	jbe    801052f8 <memmove+0x57>
    s += n;
801052c8:	8b 45 10             	mov    0x10(%ebp),%eax
801052cb:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801052ce:	8b 45 10             	mov    0x10(%ebp),%eax
801052d1:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801052d4:	eb 13                	jmp    801052e9 <memmove+0x48>
      *--d = *--s;
801052d6:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052da:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052e1:	0f b6 10             	movzbl (%eax),%edx
801052e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052e7:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052e9:	8b 45 10             	mov    0x10(%ebp),%eax
801052ec:	8d 50 ff             	lea    -0x1(%eax),%edx
801052ef:	89 55 10             	mov    %edx,0x10(%ebp)
801052f2:	85 c0                	test   %eax,%eax
801052f4:	75 e0                	jne    801052d6 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801052f6:	eb 26                	jmp    8010531e <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801052f8:	eb 17                	jmp    80105311 <memmove+0x70>
      *d++ = *s++;
801052fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052fd:	8d 50 01             	lea    0x1(%eax),%edx
80105300:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105303:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105306:	8d 4a 01             	lea    0x1(%edx),%ecx
80105309:	89 4d fc             	mov    %ecx,-0x4(%ebp)
8010530c:	0f b6 12             	movzbl (%edx),%edx
8010530f:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105311:	8b 45 10             	mov    0x10(%ebp),%eax
80105314:	8d 50 ff             	lea    -0x1(%eax),%edx
80105317:	89 55 10             	mov    %edx,0x10(%ebp)
8010531a:	85 c0                	test   %eax,%eax
8010531c:	75 dc                	jne    801052fa <memmove+0x59>
      *d++ = *s++;

  return dst;
8010531e:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105321:	c9                   	leave  
80105322:	c3                   	ret    

80105323 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105323:	55                   	push   %ebp
80105324:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105326:	ff 75 10             	pushl  0x10(%ebp)
80105329:	ff 75 0c             	pushl  0xc(%ebp)
8010532c:	ff 75 08             	pushl  0x8(%ebp)
8010532f:	e8 6d ff ff ff       	call   801052a1 <memmove>
80105334:	83 c4 0c             	add    $0xc,%esp
}
80105337:	c9                   	leave  
80105338:	c3                   	ret    

80105339 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105339:	55                   	push   %ebp
8010533a:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010533c:	eb 0c                	jmp    8010534a <strncmp+0x11>
    n--, p++, q++;
8010533e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105342:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105346:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010534a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010534e:	74 1a                	je     8010536a <strncmp+0x31>
80105350:	8b 45 08             	mov    0x8(%ebp),%eax
80105353:	0f b6 00             	movzbl (%eax),%eax
80105356:	84 c0                	test   %al,%al
80105358:	74 10                	je     8010536a <strncmp+0x31>
8010535a:	8b 45 08             	mov    0x8(%ebp),%eax
8010535d:	0f b6 10             	movzbl (%eax),%edx
80105360:	8b 45 0c             	mov    0xc(%ebp),%eax
80105363:	0f b6 00             	movzbl (%eax),%eax
80105366:	38 c2                	cmp    %al,%dl
80105368:	74 d4                	je     8010533e <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010536a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010536e:	75 07                	jne    80105377 <strncmp+0x3e>
    return 0;
80105370:	b8 00 00 00 00       	mov    $0x0,%eax
80105375:	eb 16                	jmp    8010538d <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105377:	8b 45 08             	mov    0x8(%ebp),%eax
8010537a:	0f b6 00             	movzbl (%eax),%eax
8010537d:	0f b6 d0             	movzbl %al,%edx
80105380:	8b 45 0c             	mov    0xc(%ebp),%eax
80105383:	0f b6 00             	movzbl (%eax),%eax
80105386:	0f b6 c0             	movzbl %al,%eax
80105389:	29 c2                	sub    %eax,%edx
8010538b:	89 d0                	mov    %edx,%eax
}
8010538d:	5d                   	pop    %ebp
8010538e:	c3                   	ret    

8010538f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010538f:	55                   	push   %ebp
80105390:	89 e5                	mov    %esp,%ebp
80105392:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105395:	8b 45 08             	mov    0x8(%ebp),%eax
80105398:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010539b:	90                   	nop
8010539c:	8b 45 10             	mov    0x10(%ebp),%eax
8010539f:	8d 50 ff             	lea    -0x1(%eax),%edx
801053a2:	89 55 10             	mov    %edx,0x10(%ebp)
801053a5:	85 c0                	test   %eax,%eax
801053a7:	7e 1e                	jle    801053c7 <strncpy+0x38>
801053a9:	8b 45 08             	mov    0x8(%ebp),%eax
801053ac:	8d 50 01             	lea    0x1(%eax),%edx
801053af:	89 55 08             	mov    %edx,0x8(%ebp)
801053b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801053b5:	8d 4a 01             	lea    0x1(%edx),%ecx
801053b8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801053bb:	0f b6 12             	movzbl (%edx),%edx
801053be:	88 10                	mov    %dl,(%eax)
801053c0:	0f b6 00             	movzbl (%eax),%eax
801053c3:	84 c0                	test   %al,%al
801053c5:	75 d5                	jne    8010539c <strncpy+0xd>
    ;
  while(n-- > 0)
801053c7:	eb 0c                	jmp    801053d5 <strncpy+0x46>
    *s++ = 0;
801053c9:	8b 45 08             	mov    0x8(%ebp),%eax
801053cc:	8d 50 01             	lea    0x1(%eax),%edx
801053cf:	89 55 08             	mov    %edx,0x8(%ebp)
801053d2:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053d5:	8b 45 10             	mov    0x10(%ebp),%eax
801053d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801053db:	89 55 10             	mov    %edx,0x10(%ebp)
801053de:	85 c0                	test   %eax,%eax
801053e0:	7f e7                	jg     801053c9 <strncpy+0x3a>
    *s++ = 0;
  return os;
801053e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801053e5:	c9                   	leave  
801053e6:	c3                   	ret    

801053e7 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801053e7:	55                   	push   %ebp
801053e8:	89 e5                	mov    %esp,%ebp
801053ea:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053ed:	8b 45 08             	mov    0x8(%ebp),%eax
801053f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801053f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053f7:	7f 05                	jg     801053fe <safestrcpy+0x17>
    return os;
801053f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fc:	eb 31                	jmp    8010542f <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801053fe:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105402:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105406:	7e 1e                	jle    80105426 <safestrcpy+0x3f>
80105408:	8b 45 08             	mov    0x8(%ebp),%eax
8010540b:	8d 50 01             	lea    0x1(%eax),%edx
8010540e:	89 55 08             	mov    %edx,0x8(%ebp)
80105411:	8b 55 0c             	mov    0xc(%ebp),%edx
80105414:	8d 4a 01             	lea    0x1(%edx),%ecx
80105417:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010541a:	0f b6 12             	movzbl (%edx),%edx
8010541d:	88 10                	mov    %dl,(%eax)
8010541f:	0f b6 00             	movzbl (%eax),%eax
80105422:	84 c0                	test   %al,%al
80105424:	75 d8                	jne    801053fe <safestrcpy+0x17>
    ;
  *s = 0;
80105426:	8b 45 08             	mov    0x8(%ebp),%eax
80105429:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010542c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010542f:	c9                   	leave  
80105430:	c3                   	ret    

80105431 <strlen>:

int
strlen(const char *s)
{
80105431:	55                   	push   %ebp
80105432:	89 e5                	mov    %esp,%ebp
80105434:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010543e:	eb 04                	jmp    80105444 <strlen+0x13>
80105440:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105444:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105447:	8b 45 08             	mov    0x8(%ebp),%eax
8010544a:	01 d0                	add    %edx,%eax
8010544c:	0f b6 00             	movzbl (%eax),%eax
8010544f:	84 c0                	test   %al,%al
80105451:	75 ed                	jne    80105440 <strlen+0xf>
    ;
  return n;
80105453:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105456:	c9                   	leave  
80105457:	c3                   	ret    

80105458 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105458:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010545c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105460:	55                   	push   %ebp
  pushl %ebx
80105461:	53                   	push   %ebx
  pushl %esi
80105462:	56                   	push   %esi
  pushl %edi
80105463:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105464:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105466:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105468:	5f                   	pop    %edi
  popl %esi
80105469:	5e                   	pop    %esi
  popl %ebx
8010546a:	5b                   	pop    %ebx
  popl %ebp
8010546b:	5d                   	pop    %ebp
  ret
8010546c:	c3                   	ret    

8010546d <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010546d:	55                   	push   %ebp
8010546e:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105470:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105476:	8b 00                	mov    (%eax),%eax
80105478:	3b 45 08             	cmp    0x8(%ebp),%eax
8010547b:	76 12                	jbe    8010548f <fetchint+0x22>
8010547d:	8b 45 08             	mov    0x8(%ebp),%eax
80105480:	8d 50 04             	lea    0x4(%eax),%edx
80105483:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105489:	8b 00                	mov    (%eax),%eax
8010548b:	39 c2                	cmp    %eax,%edx
8010548d:	76 07                	jbe    80105496 <fetchint+0x29>
    return -1;
8010548f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105494:	eb 0f                	jmp    801054a5 <fetchint+0x38>
  *ip = *(int*)(addr);
80105496:	8b 45 08             	mov    0x8(%ebp),%eax
80105499:	8b 10                	mov    (%eax),%edx
8010549b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010549e:	89 10                	mov    %edx,(%eax)
  return 0;
801054a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054a5:	5d                   	pop    %ebp
801054a6:	c3                   	ret    

801054a7 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801054a7:	55                   	push   %ebp
801054a8:	89 e5                	mov    %esp,%ebp
801054aa:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801054ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b3:	8b 00                	mov    (%eax),%eax
801054b5:	3b 45 08             	cmp    0x8(%ebp),%eax
801054b8:	77 07                	ja     801054c1 <fetchstr+0x1a>
    return -1;
801054ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054bf:	eb 46                	jmp    80105507 <fetchstr+0x60>
  *pp = (char*)addr;
801054c1:	8b 55 08             	mov    0x8(%ebp),%edx
801054c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801054c7:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801054c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054cf:	8b 00                	mov    (%eax),%eax
801054d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801054d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801054d7:	8b 00                	mov    (%eax),%eax
801054d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
801054dc:	eb 1c                	jmp    801054fa <fetchstr+0x53>
    if(*s == 0)
801054de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054e1:	0f b6 00             	movzbl (%eax),%eax
801054e4:	84 c0                	test   %al,%al
801054e6:	75 0e                	jne    801054f6 <fetchstr+0x4f>
      return s - *pp;
801054e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ee:	8b 00                	mov    (%eax),%eax
801054f0:	29 c2                	sub    %eax,%edx
801054f2:	89 d0                	mov    %edx,%eax
801054f4:	eb 11                	jmp    80105507 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801054f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801054fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105500:	72 dc                	jb     801054de <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105502:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105507:	c9                   	leave  
80105508:	c3                   	ret    

80105509 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105509:	55                   	push   %ebp
8010550a:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010550c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105512:	8b 40 18             	mov    0x18(%eax),%eax
80105515:	8b 40 44             	mov    0x44(%eax),%eax
80105518:	8b 55 08             	mov    0x8(%ebp),%edx
8010551b:	c1 e2 02             	shl    $0x2,%edx
8010551e:	01 d0                	add    %edx,%eax
80105520:	83 c0 04             	add    $0x4,%eax
80105523:	ff 75 0c             	pushl  0xc(%ebp)
80105526:	50                   	push   %eax
80105527:	e8 41 ff ff ff       	call   8010546d <fetchint>
8010552c:	83 c4 08             	add    $0x8,%esp
}
8010552f:	c9                   	leave  
80105530:	c3                   	ret    

80105531 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105531:	55                   	push   %ebp
80105532:	89 e5                	mov    %esp,%ebp
80105534:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105537:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010553a:	50                   	push   %eax
8010553b:	ff 75 08             	pushl  0x8(%ebp)
8010553e:	e8 c6 ff ff ff       	call   80105509 <argint>
80105543:	83 c4 08             	add    $0x8,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	79 07                	jns    80105551 <argptr+0x20>
    return -1;
8010554a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554f:	eb 3d                	jmp    8010558e <argptr+0x5d>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105551:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105554:	89 c2                	mov    %eax,%edx
80105556:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010555c:	8b 00                	mov    (%eax),%eax
8010555e:	39 c2                	cmp    %eax,%edx
80105560:	73 16                	jae    80105578 <argptr+0x47>
80105562:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105565:	89 c2                	mov    %eax,%edx
80105567:	8b 45 10             	mov    0x10(%ebp),%eax
8010556a:	01 c2                	add    %eax,%edx
8010556c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105572:	8b 00                	mov    (%eax),%eax
80105574:	39 c2                	cmp    %eax,%edx
80105576:	76 07                	jbe    8010557f <argptr+0x4e>
    return -1;
80105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557d:	eb 0f                	jmp    8010558e <argptr+0x5d>
  *pp = (char*)i;
8010557f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105582:	89 c2                	mov    %eax,%edx
80105584:	8b 45 0c             	mov    0xc(%ebp),%eax
80105587:	89 10                	mov    %edx,(%eax)
  return 0;
80105589:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010558e:	c9                   	leave  
8010558f:	c3                   	ret    

80105590 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105596:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105599:	50                   	push   %eax
8010559a:	ff 75 08             	pushl  0x8(%ebp)
8010559d:	e8 67 ff ff ff       	call   80105509 <argint>
801055a2:	83 c4 08             	add    $0x8,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	79 07                	jns    801055b0 <argstr+0x20>
    return -1;
801055a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ae:	eb 0f                	jmp    801055bf <argstr+0x2f>
  return fetchstr(addr, pp);
801055b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b3:	ff 75 0c             	pushl  0xc(%ebp)
801055b6:	50                   	push   %eax
801055b7:	e8 eb fe ff ff       	call   801054a7 <fetchstr>
801055bc:	83 c4 08             	add    $0x8,%esp
}
801055bf:	c9                   	leave  
801055c0:	c3                   	ret    

801055c1 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801055c1:	55                   	push   %ebp
801055c2:	89 e5                	mov    %esp,%ebp
801055c4:	53                   	push   %ebx
801055c5:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801055c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ce:	8b 40 18             	mov    0x18(%eax),%eax
801055d1:	8b 40 1c             	mov    0x1c(%eax),%eax
801055d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801055d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055db:	7e 30                	jle    8010560d <syscall+0x4c>
801055dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e0:	83 f8 15             	cmp    $0x15,%eax
801055e3:	77 28                	ja     8010560d <syscall+0x4c>
801055e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e8:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801055ef:	85 c0                	test   %eax,%eax
801055f1:	74 1a                	je     8010560d <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801055f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055f9:	8b 58 18             	mov    0x18(%eax),%ebx
801055fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055ff:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105606:	ff d0                	call   *%eax
80105608:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010560b:	eb 34                	jmp    80105641 <syscall+0x80>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
8010560d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105613:	8d 50 6c             	lea    0x6c(%eax),%edx
80105616:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010561c:	8b 40 10             	mov    0x10(%eax),%eax
8010561f:	ff 75 f4             	pushl  -0xc(%ebp)
80105622:	52                   	push   %edx
80105623:	50                   	push   %eax
80105624:	68 d7 88 10 80       	push   $0x801088d7
80105629:	e8 91 ad ff ff       	call   801003bf <cprintf>
8010562e:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105631:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105637:	8b 40 18             	mov    0x18(%eax),%eax
8010563a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105644:	c9                   	leave  
80105645:	c3                   	ret    

80105646 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105646:	55                   	push   %ebp
80105647:	89 e5                	mov    %esp,%ebp
80105649:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010564c:	83 ec 08             	sub    $0x8,%esp
8010564f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105652:	50                   	push   %eax
80105653:	ff 75 08             	pushl  0x8(%ebp)
80105656:	e8 ae fe ff ff       	call   80105509 <argint>
8010565b:	83 c4 10             	add    $0x10,%esp
8010565e:	85 c0                	test   %eax,%eax
80105660:	79 07                	jns    80105669 <argfd+0x23>
    return -1;
80105662:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105667:	eb 50                	jmp    801056b9 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105669:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010566c:	85 c0                	test   %eax,%eax
8010566e:	78 21                	js     80105691 <argfd+0x4b>
80105670:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105673:	83 f8 0f             	cmp    $0xf,%eax
80105676:	7f 19                	jg     80105691 <argfd+0x4b>
80105678:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010567e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105681:	83 c2 08             	add    $0x8,%edx
80105684:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105688:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010568b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010568f:	75 07                	jne    80105698 <argfd+0x52>
    return -1;
80105691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105696:	eb 21                	jmp    801056b9 <argfd+0x73>
  if(pfd)
80105698:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010569c:	74 08                	je     801056a6 <argfd+0x60>
    *pfd = fd;
8010569e:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a4:	89 10                	mov    %edx,(%eax)
  if(pf)
801056a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801056aa:	74 08                	je     801056b4 <argfd+0x6e>
    *pf = f;
801056ac:	8b 45 10             	mov    0x10(%ebp),%eax
801056af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b2:	89 10                	mov    %edx,(%eax)
  return 0;
801056b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056b9:	c9                   	leave  
801056ba:	c3                   	ret    

801056bb <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801056bb:	55                   	push   %ebp
801056bc:	89 e5                	mov    %esp,%ebp
801056be:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056c1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801056c8:	eb 30                	jmp    801056fa <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801056ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056d3:	83 c2 08             	add    $0x8,%edx
801056d6:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801056da:	85 c0                	test   %eax,%eax
801056dc:	75 18                	jne    801056f6 <fdalloc+0x3b>
      proc->ofile[fd] = f;
801056de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056e7:	8d 4a 08             	lea    0x8(%edx),%ecx
801056ea:	8b 55 08             	mov    0x8(%ebp),%edx
801056ed:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801056f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056f4:	eb 0f                	jmp    80105705 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801056f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801056fa:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801056fe:	7e ca                	jle    801056ca <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105705:	c9                   	leave  
80105706:	c3                   	ret    

80105707 <sys_dup>:

int
sys_dup(void)
{
80105707:	55                   	push   %ebp
80105708:	89 e5                	mov    %esp,%ebp
8010570a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010570d:	83 ec 04             	sub    $0x4,%esp
80105710:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105713:	50                   	push   %eax
80105714:	6a 00                	push   $0x0
80105716:	6a 00                	push   $0x0
80105718:	e8 29 ff ff ff       	call   80105646 <argfd>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	79 07                	jns    8010572b <sys_dup+0x24>
    return -1;
80105724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105729:	eb 31                	jmp    8010575c <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010572b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010572e:	83 ec 0c             	sub    $0xc,%esp
80105731:	50                   	push   %eax
80105732:	e8 84 ff ff ff       	call   801056bb <fdalloc>
80105737:	83 c4 10             	add    $0x10,%esp
8010573a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010573d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105741:	79 07                	jns    8010574a <sys_dup+0x43>
    return -1;
80105743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105748:	eb 12                	jmp    8010575c <sys_dup+0x55>
  filedup(f);
8010574a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010574d:	83 ec 0c             	sub    $0xc,%esp
80105750:	50                   	push   %eax
80105751:	e8 71 b8 ff ff       	call   80100fc7 <filedup>
80105756:	83 c4 10             	add    $0x10,%esp
  return fd;
80105759:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010575c:	c9                   	leave  
8010575d:	c3                   	ret    

8010575e <sys_read>:

int
sys_read(void)
{
8010575e:	55                   	push   %ebp
8010575f:	89 e5                	mov    %esp,%ebp
80105761:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105764:	83 ec 04             	sub    $0x4,%esp
80105767:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010576a:	50                   	push   %eax
8010576b:	6a 00                	push   $0x0
8010576d:	6a 00                	push   $0x0
8010576f:	e8 d2 fe ff ff       	call   80105646 <argfd>
80105774:	83 c4 10             	add    $0x10,%esp
80105777:	85 c0                	test   %eax,%eax
80105779:	78 2e                	js     801057a9 <sys_read+0x4b>
8010577b:	83 ec 08             	sub    $0x8,%esp
8010577e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105781:	50                   	push   %eax
80105782:	6a 02                	push   $0x2
80105784:	e8 80 fd ff ff       	call   80105509 <argint>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	85 c0                	test   %eax,%eax
8010578e:	78 19                	js     801057a9 <sys_read+0x4b>
80105790:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105793:	83 ec 04             	sub    $0x4,%esp
80105796:	50                   	push   %eax
80105797:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579a:	50                   	push   %eax
8010579b:	6a 01                	push   $0x1
8010579d:	e8 8f fd ff ff       	call   80105531 <argptr>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	79 07                	jns    801057b0 <sys_read+0x52>
    return -1;
801057a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ae:	eb 17                	jmp    801057c7 <sys_read+0x69>
  return fileread(f, p, n);
801057b0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801057b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801057b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b9:	83 ec 04             	sub    $0x4,%esp
801057bc:	51                   	push   %ecx
801057bd:	52                   	push   %edx
801057be:	50                   	push   %eax
801057bf:	e8 93 b9 ff ff       	call   80101157 <fileread>
801057c4:	83 c4 10             	add    $0x10,%esp
}
801057c7:	c9                   	leave  
801057c8:	c3                   	ret    

801057c9 <sys_write>:

int
sys_write(void)
{
801057c9:	55                   	push   %ebp
801057ca:	89 e5                	mov    %esp,%ebp
801057cc:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057cf:	83 ec 04             	sub    $0x4,%esp
801057d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057d5:	50                   	push   %eax
801057d6:	6a 00                	push   $0x0
801057d8:	6a 00                	push   $0x0
801057da:	e8 67 fe ff ff       	call   80105646 <argfd>
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	85 c0                	test   %eax,%eax
801057e4:	78 2e                	js     80105814 <sys_write+0x4b>
801057e6:	83 ec 08             	sub    $0x8,%esp
801057e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057ec:	50                   	push   %eax
801057ed:	6a 02                	push   $0x2
801057ef:	e8 15 fd ff ff       	call   80105509 <argint>
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	85 c0                	test   %eax,%eax
801057f9:	78 19                	js     80105814 <sys_write+0x4b>
801057fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057fe:	83 ec 04             	sub    $0x4,%esp
80105801:	50                   	push   %eax
80105802:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105805:	50                   	push   %eax
80105806:	6a 01                	push   $0x1
80105808:	e8 24 fd ff ff       	call   80105531 <argptr>
8010580d:	83 c4 10             	add    $0x10,%esp
80105810:	85 c0                	test   %eax,%eax
80105812:	79 07                	jns    8010581b <sys_write+0x52>
    return -1;
80105814:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105819:	eb 17                	jmp    80105832 <sys_write+0x69>
  return filewrite(f, p, n);
8010581b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010581e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105824:	83 ec 04             	sub    $0x4,%esp
80105827:	51                   	push   %ecx
80105828:	52                   	push   %edx
80105829:	50                   	push   %eax
8010582a:	e8 e0 b9 ff ff       	call   8010120f <filewrite>
8010582f:	83 c4 10             	add    $0x10,%esp
}
80105832:	c9                   	leave  
80105833:	c3                   	ret    

80105834 <sys_close>:

int
sys_close(void)
{
80105834:	55                   	push   %ebp
80105835:	89 e5                	mov    %esp,%ebp
80105837:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010583a:	83 ec 04             	sub    $0x4,%esp
8010583d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105840:	50                   	push   %eax
80105841:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105844:	50                   	push   %eax
80105845:	6a 00                	push   $0x0
80105847:	e8 fa fd ff ff       	call   80105646 <argfd>
8010584c:	83 c4 10             	add    $0x10,%esp
8010584f:	85 c0                	test   %eax,%eax
80105851:	79 07                	jns    8010585a <sys_close+0x26>
    return -1;
80105853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105858:	eb 28                	jmp    80105882 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010585a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105860:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105863:	83 c2 08             	add    $0x8,%edx
80105866:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010586d:	00 
  fileclose(f);
8010586e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105871:	83 ec 0c             	sub    $0xc,%esp
80105874:	50                   	push   %eax
80105875:	e8 9e b7 ff ff       	call   80101018 <fileclose>
8010587a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010587d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105882:	c9                   	leave  
80105883:	c3                   	ret    

80105884 <sys_fstat>:

int
sys_fstat(void)
{
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010588a:	83 ec 04             	sub    $0x4,%esp
8010588d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105890:	50                   	push   %eax
80105891:	6a 00                	push   $0x0
80105893:	6a 00                	push   $0x0
80105895:	e8 ac fd ff ff       	call   80105646 <argfd>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	85 c0                	test   %eax,%eax
8010589f:	78 17                	js     801058b8 <sys_fstat+0x34>
801058a1:	83 ec 04             	sub    $0x4,%esp
801058a4:	6a 14                	push   $0x14
801058a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a9:	50                   	push   %eax
801058aa:	6a 01                	push   $0x1
801058ac:	e8 80 fc ff ff       	call   80105531 <argptr>
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	85 c0                	test   %eax,%eax
801058b6:	79 07                	jns    801058bf <sys_fstat+0x3b>
    return -1;
801058b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bd:	eb 13                	jmp    801058d2 <sys_fstat+0x4e>
  return filestat(f, st);
801058bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801058c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c5:	83 ec 08             	sub    $0x8,%esp
801058c8:	52                   	push   %edx
801058c9:	50                   	push   %eax
801058ca:	e8 31 b8 ff ff       	call   80101100 <filestat>
801058cf:	83 c4 10             	add    $0x10,%esp
}
801058d2:	c9                   	leave  
801058d3:	c3                   	ret    

801058d4 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801058da:	83 ec 08             	sub    $0x8,%esp
801058dd:	8d 45 d8             	lea    -0x28(%ebp),%eax
801058e0:	50                   	push   %eax
801058e1:	6a 00                	push   $0x0
801058e3:	e8 a8 fc ff ff       	call   80105590 <argstr>
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	85 c0                	test   %eax,%eax
801058ed:	78 15                	js     80105904 <sys_link+0x30>
801058ef:	83 ec 08             	sub    $0x8,%esp
801058f2:	8d 45 dc             	lea    -0x24(%ebp),%eax
801058f5:	50                   	push   %eax
801058f6:	6a 01                	push   $0x1
801058f8:	e8 93 fc ff ff       	call   80105590 <argstr>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	79 0a                	jns    8010590e <sys_link+0x3a>
    return -1;
80105904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105909:	e9 69 01 00 00       	jmp    80105a77 <sys_link+0x1a3>

  begin_op();
8010590e:	e8 da db ff ff       	call   801034ed <begin_op>
  if((ip = namei(old)) == 0){
80105913:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105916:	83 ec 0c             	sub    $0xc,%esp
80105919:	50                   	push   %eax
8010591a:	e8 c5 cb ff ff       	call   801024e4 <namei>
8010591f:	83 c4 10             	add    $0x10,%esp
80105922:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105929:	75 0f                	jne    8010593a <sys_link+0x66>
    end_op();
8010592b:	e8 4b dc ff ff       	call   8010357b <end_op>
    return -1;
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105935:	e9 3d 01 00 00       	jmp    80105a77 <sys_link+0x1a3>
  }

  ilock(ip);
8010593a:	83 ec 0c             	sub    $0xc,%esp
8010593d:	ff 75 f4             	pushl  -0xc(%ebp)
80105940:	e8 e4 bf ff ff       	call   80101929 <ilock>
80105945:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010594f:	66 83 f8 01          	cmp    $0x1,%ax
80105953:	75 1d                	jne    80105972 <sys_link+0x9e>
    iunlockput(ip);
80105955:	83 ec 0c             	sub    $0xc,%esp
80105958:	ff 75 f4             	pushl  -0xc(%ebp)
8010595b:	e8 86 c2 ff ff       	call   80101be6 <iunlockput>
80105960:	83 c4 10             	add    $0x10,%esp
    end_op();
80105963:	e8 13 dc ff ff       	call   8010357b <end_op>
    return -1;
80105968:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010596d:	e9 05 01 00 00       	jmp    80105a77 <sys_link+0x1a3>
  }

  ip->nlink++;
80105972:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105975:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105979:	83 c0 01             	add    $0x1,%eax
8010597c:	89 c2                	mov    %eax,%edx
8010597e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105981:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105985:	83 ec 0c             	sub    $0xc,%esp
80105988:	ff 75 f4             	pushl  -0xc(%ebp)
8010598b:	e8 c0 bd ff ff       	call   80101750 <iupdate>
80105990:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105993:	83 ec 0c             	sub    $0xc,%esp
80105996:	ff 75 f4             	pushl  -0xc(%ebp)
80105999:	e8 e8 c0 ff ff       	call   80101a86 <iunlock>
8010599e:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801059a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059a4:	83 ec 08             	sub    $0x8,%esp
801059a7:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801059aa:	52                   	push   %edx
801059ab:	50                   	push   %eax
801059ac:	e8 4f cb ff ff       	call   80102500 <nameiparent>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801059bb:	75 02                	jne    801059bf <sys_link+0xeb>
    goto bad;
801059bd:	eb 71                	jmp    80105a30 <sys_link+0x15c>
  ilock(dp);
801059bf:	83 ec 0c             	sub    $0xc,%esp
801059c2:	ff 75 f0             	pushl  -0x10(%ebp)
801059c5:	e8 5f bf ff ff       	call   80101929 <ilock>
801059ca:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d0:	8b 10                	mov    (%eax),%edx
801059d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d5:	8b 00                	mov    (%eax),%eax
801059d7:	39 c2                	cmp    %eax,%edx
801059d9:	75 1d                	jne    801059f8 <sys_link+0x124>
801059db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059de:	8b 40 04             	mov    0x4(%eax),%eax
801059e1:	83 ec 04             	sub    $0x4,%esp
801059e4:	50                   	push   %eax
801059e5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801059e8:	50                   	push   %eax
801059e9:	ff 75 f0             	pushl  -0x10(%ebp)
801059ec:	e8 5b c8 ff ff       	call   8010224c <dirlink>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	79 10                	jns    80105a08 <sys_link+0x134>
    iunlockput(dp);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 f0             	pushl  -0x10(%ebp)
801059fe:	e8 e3 c1 ff ff       	call   80101be6 <iunlockput>
80105a03:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105a06:	eb 28                	jmp    80105a30 <sys_link+0x15c>
  }
  iunlockput(dp);
80105a08:	83 ec 0c             	sub    $0xc,%esp
80105a0b:	ff 75 f0             	pushl  -0x10(%ebp)
80105a0e:	e8 d3 c1 ff ff       	call   80101be6 <iunlockput>
80105a13:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105a16:	83 ec 0c             	sub    $0xc,%esp
80105a19:	ff 75 f4             	pushl  -0xc(%ebp)
80105a1c:	e8 d6 c0 ff ff       	call   80101af7 <iput>
80105a21:	83 c4 10             	add    $0x10,%esp

  end_op();
80105a24:	e8 52 db ff ff       	call   8010357b <end_op>

  return 0;
80105a29:	b8 00 00 00 00       	mov    $0x0,%eax
80105a2e:	eb 47                	jmp    80105a77 <sys_link+0x1a3>

bad:
  ilock(ip);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	ff 75 f4             	pushl  -0xc(%ebp)
80105a36:	e8 ee be ff ff       	call   80101929 <ilock>
80105a3b:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a41:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a45:	83 e8 01             	sub    $0x1,%eax
80105a48:	89 c2                	mov    %eax,%edx
80105a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4d:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a51:	83 ec 0c             	sub    $0xc,%esp
80105a54:	ff 75 f4             	pushl  -0xc(%ebp)
80105a57:	e8 f4 bc ff ff       	call   80101750 <iupdate>
80105a5c:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	ff 75 f4             	pushl  -0xc(%ebp)
80105a65:	e8 7c c1 ff ff       	call   80101be6 <iunlockput>
80105a6a:	83 c4 10             	add    $0x10,%esp
  end_op();
80105a6d:	e8 09 db ff ff       	call   8010357b <end_op>
  return -1;
80105a72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a77:	c9                   	leave  
80105a78:	c3                   	ret    

80105a79 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105a79:	55                   	push   %ebp
80105a7a:	89 e5                	mov    %esp,%ebp
80105a7c:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a7f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105a86:	eb 40                	jmp    80105ac8 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8b:	6a 10                	push   $0x10
80105a8d:	50                   	push   %eax
80105a8e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a91:	50                   	push   %eax
80105a92:	ff 75 08             	pushl  0x8(%ebp)
80105a95:	e8 f7 c3 ff ff       	call   80101e91 <readi>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	83 f8 10             	cmp    $0x10,%eax
80105aa0:	74 0d                	je     80105aaf <isdirempty+0x36>
      panic("isdirempty: readi");
80105aa2:	83 ec 0c             	sub    $0xc,%esp
80105aa5:	68 f3 88 10 80       	push   $0x801088f3
80105aaa:	e8 ad aa ff ff       	call   8010055c <panic>
    if(de.inum != 0)
80105aaf:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105ab3:	66 85 c0             	test   %ax,%ax
80105ab6:	74 07                	je     80105abf <isdirempty+0x46>
      return 0;
80105ab8:	b8 00 00 00 00       	mov    $0x0,%eax
80105abd:	eb 1b                	jmp    80105ada <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac2:	83 c0 10             	add    $0x10,%eax
80105ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ac8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105acb:	8b 45 08             	mov    0x8(%ebp),%eax
80105ace:	8b 40 18             	mov    0x18(%eax),%eax
80105ad1:	39 c2                	cmp    %eax,%edx
80105ad3:	72 b3                	jb     80105a88 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105ad5:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ada:	c9                   	leave  
80105adb:	c3                   	ret    

80105adc <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105adc:	55                   	push   %ebp
80105add:	89 e5                	mov    %esp,%ebp
80105adf:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105ae2:	83 ec 08             	sub    $0x8,%esp
80105ae5:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105ae8:	50                   	push   %eax
80105ae9:	6a 00                	push   $0x0
80105aeb:	e8 a0 fa ff ff       	call   80105590 <argstr>
80105af0:	83 c4 10             	add    $0x10,%esp
80105af3:	85 c0                	test   %eax,%eax
80105af5:	79 0a                	jns    80105b01 <sys_unlink+0x25>
    return -1;
80105af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afc:	e9 bc 01 00 00       	jmp    80105cbd <sys_unlink+0x1e1>

  begin_op();
80105b01:	e8 e7 d9 ff ff       	call   801034ed <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b06:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b09:	83 ec 08             	sub    $0x8,%esp
80105b0c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b0f:	52                   	push   %edx
80105b10:	50                   	push   %eax
80105b11:	e8 ea c9 ff ff       	call   80102500 <nameiparent>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b20:	75 0f                	jne    80105b31 <sys_unlink+0x55>
    end_op();
80105b22:	e8 54 da ff ff       	call   8010357b <end_op>
    return -1;
80105b27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2c:	e9 8c 01 00 00       	jmp    80105cbd <sys_unlink+0x1e1>
  }

  ilock(dp);
80105b31:	83 ec 0c             	sub    $0xc,%esp
80105b34:	ff 75 f4             	pushl  -0xc(%ebp)
80105b37:	e8 ed bd ff ff       	call   80101929 <ilock>
80105b3c:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b3f:	83 ec 08             	sub    $0x8,%esp
80105b42:	68 05 89 10 80       	push   $0x80108905
80105b47:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b4a:	50                   	push   %eax
80105b4b:	e8 26 c6 ff ff       	call   80102176 <namecmp>
80105b50:	83 c4 10             	add    $0x10,%esp
80105b53:	85 c0                	test   %eax,%eax
80105b55:	0f 84 4a 01 00 00    	je     80105ca5 <sys_unlink+0x1c9>
80105b5b:	83 ec 08             	sub    $0x8,%esp
80105b5e:	68 07 89 10 80       	push   $0x80108907
80105b63:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b66:	50                   	push   %eax
80105b67:	e8 0a c6 ff ff       	call   80102176 <namecmp>
80105b6c:	83 c4 10             	add    $0x10,%esp
80105b6f:	85 c0                	test   %eax,%eax
80105b71:	0f 84 2e 01 00 00    	je     80105ca5 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b77:	83 ec 04             	sub    $0x4,%esp
80105b7a:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105b7d:	50                   	push   %eax
80105b7e:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105b81:	50                   	push   %eax
80105b82:	ff 75 f4             	pushl  -0xc(%ebp)
80105b85:	e8 07 c6 ff ff       	call   80102191 <dirlookup>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b94:	75 05                	jne    80105b9b <sys_unlink+0xbf>
    goto bad;
80105b96:	e9 0a 01 00 00       	jmp    80105ca5 <sys_unlink+0x1c9>
  ilock(ip);
80105b9b:	83 ec 0c             	sub    $0xc,%esp
80105b9e:	ff 75 f0             	pushl  -0x10(%ebp)
80105ba1:	e8 83 bd ff ff       	call   80101929 <ilock>
80105ba6:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bac:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105bb0:	66 85 c0             	test   %ax,%ax
80105bb3:	7f 0d                	jg     80105bc2 <sys_unlink+0xe6>
    panic("unlink: nlink < 1");
80105bb5:	83 ec 0c             	sub    $0xc,%esp
80105bb8:	68 0a 89 10 80       	push   $0x8010890a
80105bbd:	e8 9a a9 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105bc9:	66 83 f8 01          	cmp    $0x1,%ax
80105bcd:	75 25                	jne    80105bf4 <sys_unlink+0x118>
80105bcf:	83 ec 0c             	sub    $0xc,%esp
80105bd2:	ff 75 f0             	pushl  -0x10(%ebp)
80105bd5:	e8 9f fe ff ff       	call   80105a79 <isdirempty>
80105bda:	83 c4 10             	add    $0x10,%esp
80105bdd:	85 c0                	test   %eax,%eax
80105bdf:	75 13                	jne    80105bf4 <sys_unlink+0x118>
    iunlockput(ip);
80105be1:	83 ec 0c             	sub    $0xc,%esp
80105be4:	ff 75 f0             	pushl  -0x10(%ebp)
80105be7:	e8 fa bf ff ff       	call   80101be6 <iunlockput>
80105bec:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105bef:	e9 b1 00 00 00       	jmp    80105ca5 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80105bf4:	83 ec 04             	sub    $0x4,%esp
80105bf7:	6a 10                	push   $0x10
80105bf9:	6a 00                	push   $0x0
80105bfb:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bfe:	50                   	push   %eax
80105bff:	e8 de f5 ff ff       	call   801051e2 <memset>
80105c04:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c07:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105c0a:	6a 10                	push   $0x10
80105c0c:	50                   	push   %eax
80105c0d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c10:	50                   	push   %eax
80105c11:	ff 75 f4             	pushl  -0xc(%ebp)
80105c14:	e8 d2 c3 ff ff       	call   80101feb <writei>
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	83 f8 10             	cmp    $0x10,%eax
80105c1f:	74 0d                	je     80105c2e <sys_unlink+0x152>
    panic("unlink: writei");
80105c21:	83 ec 0c             	sub    $0xc,%esp
80105c24:	68 1c 89 10 80       	push   $0x8010891c
80105c29:	e8 2e a9 ff ff       	call   8010055c <panic>
  if(ip->type == T_DIR){
80105c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c31:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c35:	66 83 f8 01          	cmp    $0x1,%ax
80105c39:	75 21                	jne    80105c5c <sys_unlink+0x180>
    dp->nlink--;
80105c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c42:	83 e8 01             	sub    $0x1,%eax
80105c45:	89 c2                	mov    %eax,%edx
80105c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105c4e:	83 ec 0c             	sub    $0xc,%esp
80105c51:	ff 75 f4             	pushl  -0xc(%ebp)
80105c54:	e8 f7 ba ff ff       	call   80101750 <iupdate>
80105c59:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105c5c:	83 ec 0c             	sub    $0xc,%esp
80105c5f:	ff 75 f4             	pushl  -0xc(%ebp)
80105c62:	e8 7f bf ff ff       	call   80101be6 <iunlockput>
80105c67:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c71:	83 e8 01             	sub    $0x1,%eax
80105c74:	89 c2                	mov    %eax,%edx
80105c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c79:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105c7d:	83 ec 0c             	sub    $0xc,%esp
80105c80:	ff 75 f0             	pushl  -0x10(%ebp)
80105c83:	e8 c8 ba ff ff       	call   80101750 <iupdate>
80105c88:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105c8b:	83 ec 0c             	sub    $0xc,%esp
80105c8e:	ff 75 f0             	pushl  -0x10(%ebp)
80105c91:	e8 50 bf ff ff       	call   80101be6 <iunlockput>
80105c96:	83 c4 10             	add    $0x10,%esp

  end_op();
80105c99:	e8 dd d8 ff ff       	call   8010357b <end_op>

  return 0;
80105c9e:	b8 00 00 00 00       	mov    $0x0,%eax
80105ca3:	eb 18                	jmp    80105cbd <sys_unlink+0x1e1>

bad:
  iunlockput(dp);
80105ca5:	83 ec 0c             	sub    $0xc,%esp
80105ca8:	ff 75 f4             	pushl  -0xc(%ebp)
80105cab:	e8 36 bf ff ff       	call   80101be6 <iunlockput>
80105cb0:	83 c4 10             	add    $0x10,%esp
  end_op();
80105cb3:	e8 c3 d8 ff ff       	call   8010357b <end_op>
  return -1;
80105cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cbd:	c9                   	leave  
80105cbe:	c3                   	ret    

80105cbf <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105cbf:	55                   	push   %ebp
80105cc0:	89 e5                	mov    %esp,%ebp
80105cc2:	83 ec 38             	sub    $0x38,%esp
80105cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105cc8:	8b 55 10             	mov    0x10(%ebp),%edx
80105ccb:	8b 45 14             	mov    0x14(%ebp),%eax
80105cce:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105cd2:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105cd6:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105cda:	83 ec 08             	sub    $0x8,%esp
80105cdd:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ce0:	50                   	push   %eax
80105ce1:	ff 75 08             	pushl  0x8(%ebp)
80105ce4:	e8 17 c8 ff ff       	call   80102500 <nameiparent>
80105ce9:	83 c4 10             	add    $0x10,%esp
80105cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cf3:	75 0a                	jne    80105cff <create+0x40>
    return 0;
80105cf5:	b8 00 00 00 00       	mov    $0x0,%eax
80105cfa:	e9 90 01 00 00       	jmp    80105e8f <create+0x1d0>
  ilock(dp);
80105cff:	83 ec 0c             	sub    $0xc,%esp
80105d02:	ff 75 f4             	pushl  -0xc(%ebp)
80105d05:	e8 1f bc ff ff       	call   80101929 <ilock>
80105d0a:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d0d:	83 ec 04             	sub    $0x4,%esp
80105d10:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d13:	50                   	push   %eax
80105d14:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d17:	50                   	push   %eax
80105d18:	ff 75 f4             	pushl  -0xc(%ebp)
80105d1b:	e8 71 c4 ff ff       	call   80102191 <dirlookup>
80105d20:	83 c4 10             	add    $0x10,%esp
80105d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d2a:	74 50                	je     80105d7c <create+0xbd>
    iunlockput(dp);
80105d2c:	83 ec 0c             	sub    $0xc,%esp
80105d2f:	ff 75 f4             	pushl  -0xc(%ebp)
80105d32:	e8 af be ff ff       	call   80101be6 <iunlockput>
80105d37:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105d3a:	83 ec 0c             	sub    $0xc,%esp
80105d3d:	ff 75 f0             	pushl  -0x10(%ebp)
80105d40:	e8 e4 bb ff ff       	call   80101929 <ilock>
80105d45:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105d48:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d4d:	75 15                	jne    80105d64 <create+0xa5>
80105d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d52:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d56:	66 83 f8 02          	cmp    $0x2,%ax
80105d5a:	75 08                	jne    80105d64 <create+0xa5>
      return ip;
80105d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5f:	e9 2b 01 00 00       	jmp    80105e8f <create+0x1d0>
    iunlockput(ip);
80105d64:	83 ec 0c             	sub    $0xc,%esp
80105d67:	ff 75 f0             	pushl  -0x10(%ebp)
80105d6a:	e8 77 be ff ff       	call   80101be6 <iunlockput>
80105d6f:	83 c4 10             	add    $0x10,%esp
    return 0;
80105d72:	b8 00 00 00 00       	mov    $0x0,%eax
80105d77:	e9 13 01 00 00       	jmp    80105e8f <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105d7c:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d83:	8b 00                	mov    (%eax),%eax
80105d85:	83 ec 08             	sub    $0x8,%esp
80105d88:	52                   	push   %edx
80105d89:	50                   	push   %eax
80105d8a:	e8 eb b8 ff ff       	call   8010167a <ialloc>
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105d95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d99:	75 0d                	jne    80105da8 <create+0xe9>
    panic("create: ialloc");
80105d9b:	83 ec 0c             	sub    $0xc,%esp
80105d9e:	68 2b 89 10 80       	push   $0x8010892b
80105da3:	e8 b4 a7 ff ff       	call   8010055c <panic>

  ilock(ip);
80105da8:	83 ec 0c             	sub    $0xc,%esp
80105dab:	ff 75 f0             	pushl  -0x10(%ebp)
80105dae:	e8 76 bb ff ff       	call   80101929 <ilock>
80105db3:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db9:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105dbd:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc4:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105dc8:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcf:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105dd5:	83 ec 0c             	sub    $0xc,%esp
80105dd8:	ff 75 f0             	pushl  -0x10(%ebp)
80105ddb:	e8 70 b9 ff ff       	call   80101750 <iupdate>
80105de0:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105de3:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105de8:	75 6a                	jne    80105e54 <create+0x195>
    dp->nlink++;  // for ".."
80105dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ded:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105df1:	83 c0 01             	add    $0x1,%eax
80105df4:	89 c2                	mov    %eax,%edx
80105df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df9:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105dfd:	83 ec 0c             	sub    $0xc,%esp
80105e00:	ff 75 f4             	pushl  -0xc(%ebp)
80105e03:	e8 48 b9 ff ff       	call   80101750 <iupdate>
80105e08:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0e:	8b 40 04             	mov    0x4(%eax),%eax
80105e11:	83 ec 04             	sub    $0x4,%esp
80105e14:	50                   	push   %eax
80105e15:	68 05 89 10 80       	push   $0x80108905
80105e1a:	ff 75 f0             	pushl  -0x10(%ebp)
80105e1d:	e8 2a c4 ff ff       	call   8010224c <dirlink>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	78 1e                	js     80105e47 <create+0x188>
80105e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e2c:	8b 40 04             	mov    0x4(%eax),%eax
80105e2f:	83 ec 04             	sub    $0x4,%esp
80105e32:	50                   	push   %eax
80105e33:	68 07 89 10 80       	push   $0x80108907
80105e38:	ff 75 f0             	pushl  -0x10(%ebp)
80105e3b:	e8 0c c4 ff ff       	call   8010224c <dirlink>
80105e40:	83 c4 10             	add    $0x10,%esp
80105e43:	85 c0                	test   %eax,%eax
80105e45:	79 0d                	jns    80105e54 <create+0x195>
      panic("create dots");
80105e47:	83 ec 0c             	sub    $0xc,%esp
80105e4a:	68 3a 89 10 80       	push   $0x8010893a
80105e4f:	e8 08 a7 ff ff       	call   8010055c <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e57:	8b 40 04             	mov    0x4(%eax),%eax
80105e5a:	83 ec 04             	sub    $0x4,%esp
80105e5d:	50                   	push   %eax
80105e5e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e61:	50                   	push   %eax
80105e62:	ff 75 f4             	pushl  -0xc(%ebp)
80105e65:	e8 e2 c3 ff ff       	call   8010224c <dirlink>
80105e6a:	83 c4 10             	add    $0x10,%esp
80105e6d:	85 c0                	test   %eax,%eax
80105e6f:	79 0d                	jns    80105e7e <create+0x1bf>
    panic("create: dirlink");
80105e71:	83 ec 0c             	sub    $0xc,%esp
80105e74:	68 46 89 10 80       	push   $0x80108946
80105e79:	e8 de a6 ff ff       	call   8010055c <panic>

  iunlockput(dp);
80105e7e:	83 ec 0c             	sub    $0xc,%esp
80105e81:	ff 75 f4             	pushl  -0xc(%ebp)
80105e84:	e8 5d bd ff ff       	call   80101be6 <iunlockput>
80105e89:	83 c4 10             	add    $0x10,%esp

  return ip;
80105e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e8f:	c9                   	leave  
80105e90:	c3                   	ret    

80105e91 <sys_open>:

int
sys_open(void)
{
80105e91:	55                   	push   %ebp
80105e92:	89 e5                	mov    %esp,%ebp
80105e94:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e97:	83 ec 08             	sub    $0x8,%esp
80105e9a:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e9d:	50                   	push   %eax
80105e9e:	6a 00                	push   $0x0
80105ea0:	e8 eb f6 ff ff       	call   80105590 <argstr>
80105ea5:	83 c4 10             	add    $0x10,%esp
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	78 15                	js     80105ec1 <sys_open+0x30>
80105eac:	83 ec 08             	sub    $0x8,%esp
80105eaf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105eb2:	50                   	push   %eax
80105eb3:	6a 01                	push   $0x1
80105eb5:	e8 4f f6 ff ff       	call   80105509 <argint>
80105eba:	83 c4 10             	add    $0x10,%esp
80105ebd:	85 c0                	test   %eax,%eax
80105ebf:	79 0a                	jns    80105ecb <sys_open+0x3a>
    return -1;
80105ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ec6:	e9 61 01 00 00       	jmp    8010602c <sys_open+0x19b>

  begin_op();
80105ecb:	e8 1d d6 ff ff       	call   801034ed <begin_op>

  if(omode & O_CREATE){
80105ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ed3:	25 00 02 00 00       	and    $0x200,%eax
80105ed8:	85 c0                	test   %eax,%eax
80105eda:	74 2a                	je     80105f06 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80105edc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105edf:	6a 00                	push   $0x0
80105ee1:	6a 00                	push   $0x0
80105ee3:	6a 02                	push   $0x2
80105ee5:	50                   	push   %eax
80105ee6:	e8 d4 fd ff ff       	call   80105cbf <create>
80105eeb:	83 c4 10             	add    $0x10,%esp
80105eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ef5:	75 75                	jne    80105f6c <sys_open+0xdb>
      end_op();
80105ef7:	e8 7f d6 ff ff       	call   8010357b <end_op>
      return -1;
80105efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f01:	e9 26 01 00 00       	jmp    8010602c <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80105f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f09:	83 ec 0c             	sub    $0xc,%esp
80105f0c:	50                   	push   %eax
80105f0d:	e8 d2 c5 ff ff       	call   801024e4 <namei>
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f1c:	75 0f                	jne    80105f2d <sys_open+0x9c>
      end_op();
80105f1e:	e8 58 d6 ff ff       	call   8010357b <end_op>
      return -1;
80105f23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f28:	e9 ff 00 00 00       	jmp    8010602c <sys_open+0x19b>
    }
    ilock(ip);
80105f2d:	83 ec 0c             	sub    $0xc,%esp
80105f30:	ff 75 f4             	pushl  -0xc(%ebp)
80105f33:	e8 f1 b9 ff ff       	call   80101929 <ilock>
80105f38:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f42:	66 83 f8 01          	cmp    $0x1,%ax
80105f46:	75 24                	jne    80105f6c <sys_open+0xdb>
80105f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f4b:	85 c0                	test   %eax,%eax
80105f4d:	74 1d                	je     80105f6c <sys_open+0xdb>
      iunlockput(ip);
80105f4f:	83 ec 0c             	sub    $0xc,%esp
80105f52:	ff 75 f4             	pushl  -0xc(%ebp)
80105f55:	e8 8c bc ff ff       	call   80101be6 <iunlockput>
80105f5a:	83 c4 10             	add    $0x10,%esp
      end_op();
80105f5d:	e8 19 d6 ff ff       	call   8010357b <end_op>
      return -1;
80105f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f67:	e9 c0 00 00 00       	jmp    8010602c <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f6c:	e8 ea af ff ff       	call   80100f5b <filealloc>
80105f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f78:	74 17                	je     80105f91 <sys_open+0x100>
80105f7a:	83 ec 0c             	sub    $0xc,%esp
80105f7d:	ff 75 f0             	pushl  -0x10(%ebp)
80105f80:	e8 36 f7 ff ff       	call   801056bb <fdalloc>
80105f85:	83 c4 10             	add    $0x10,%esp
80105f88:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105f8f:	79 2e                	jns    80105fbf <sys_open+0x12e>
    if(f)
80105f91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f95:	74 0e                	je     80105fa5 <sys_open+0x114>
      fileclose(f);
80105f97:	83 ec 0c             	sub    $0xc,%esp
80105f9a:	ff 75 f0             	pushl  -0x10(%ebp)
80105f9d:	e8 76 b0 ff ff       	call   80101018 <fileclose>
80105fa2:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105fa5:	83 ec 0c             	sub    $0xc,%esp
80105fa8:	ff 75 f4             	pushl  -0xc(%ebp)
80105fab:	e8 36 bc ff ff       	call   80101be6 <iunlockput>
80105fb0:	83 c4 10             	add    $0x10,%esp
    end_op();
80105fb3:	e8 c3 d5 ff ff       	call   8010357b <end_op>
    return -1;
80105fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fbd:	eb 6d                	jmp    8010602c <sys_open+0x19b>
  }
  iunlock(ip);
80105fbf:	83 ec 0c             	sub    $0xc,%esp
80105fc2:	ff 75 f4             	pushl  -0xc(%ebp)
80105fc5:	e8 bc ba ff ff       	call   80101a86 <iunlock>
80105fca:	83 c4 10             	add    $0x10,%esp
  end_op();
80105fcd:	e8 a9 d5 ff ff       	call   8010357b <end_op>

  f->type = FD_INODE;
80105fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fd5:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fe1:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff1:	83 e0 01             	and    $0x1,%eax
80105ff4:	85 c0                	test   %eax,%eax
80105ff6:	0f 94 c0             	sete   %al
80105ff9:	89 c2                	mov    %eax,%edx
80105ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ffe:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106004:	83 e0 01             	and    $0x1,%eax
80106007:	85 c0                	test   %eax,%eax
80106009:	75 0a                	jne    80106015 <sys_open+0x184>
8010600b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010600e:	83 e0 02             	and    $0x2,%eax
80106011:	85 c0                	test   %eax,%eax
80106013:	74 07                	je     8010601c <sys_open+0x18b>
80106015:	b8 01 00 00 00       	mov    $0x1,%eax
8010601a:	eb 05                	jmp    80106021 <sys_open+0x190>
8010601c:	b8 00 00 00 00       	mov    $0x0,%eax
80106021:	89 c2                	mov    %eax,%edx
80106023:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106026:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106029:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010602c:	c9                   	leave  
8010602d:	c3                   	ret    

8010602e <sys_mkdir>:

int
sys_mkdir(void)
{
8010602e:	55                   	push   %ebp
8010602f:	89 e5                	mov    %esp,%ebp
80106031:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106034:	e8 b4 d4 ff ff       	call   801034ed <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106039:	83 ec 08             	sub    $0x8,%esp
8010603c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010603f:	50                   	push   %eax
80106040:	6a 00                	push   $0x0
80106042:	e8 49 f5 ff ff       	call   80105590 <argstr>
80106047:	83 c4 10             	add    $0x10,%esp
8010604a:	85 c0                	test   %eax,%eax
8010604c:	78 1b                	js     80106069 <sys_mkdir+0x3b>
8010604e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106051:	6a 00                	push   $0x0
80106053:	6a 00                	push   $0x0
80106055:	6a 01                	push   $0x1
80106057:	50                   	push   %eax
80106058:	e8 62 fc ff ff       	call   80105cbf <create>
8010605d:	83 c4 10             	add    $0x10,%esp
80106060:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106067:	75 0c                	jne    80106075 <sys_mkdir+0x47>
    end_op();
80106069:	e8 0d d5 ff ff       	call   8010357b <end_op>
    return -1;
8010606e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106073:	eb 18                	jmp    8010608d <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106075:	83 ec 0c             	sub    $0xc,%esp
80106078:	ff 75 f4             	pushl  -0xc(%ebp)
8010607b:	e8 66 bb ff ff       	call   80101be6 <iunlockput>
80106080:	83 c4 10             	add    $0x10,%esp
  end_op();
80106083:	e8 f3 d4 ff ff       	call   8010357b <end_op>
  return 0;
80106088:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010608d:	c9                   	leave  
8010608e:	c3                   	ret    

8010608f <sys_mknod>:

int
sys_mknod(void)
{
8010608f:	55                   	push   %ebp
80106090:	89 e5                	mov    %esp,%ebp
80106092:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106095:	e8 53 d4 ff ff       	call   801034ed <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010609a:	83 ec 08             	sub    $0x8,%esp
8010609d:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060a0:	50                   	push   %eax
801060a1:	6a 00                	push   $0x0
801060a3:	e8 e8 f4 ff ff       	call   80105590 <argstr>
801060a8:	83 c4 10             	add    $0x10,%esp
801060ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b2:	78 4f                	js     80106103 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801060b4:	83 ec 08             	sub    $0x8,%esp
801060b7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060ba:	50                   	push   %eax
801060bb:	6a 01                	push   $0x1
801060bd:	e8 47 f4 ff ff       	call   80105509 <argint>
801060c2:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801060c5:	85 c0                	test   %eax,%eax
801060c7:	78 3a                	js     80106103 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060c9:	83 ec 08             	sub    $0x8,%esp
801060cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060cf:	50                   	push   %eax
801060d0:	6a 02                	push   $0x2
801060d2:	e8 32 f4 ff ff       	call   80105509 <argint>
801060d7:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801060da:	85 c0                	test   %eax,%eax
801060dc:	78 25                	js     80106103 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801060de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060e1:	0f bf c8             	movswl %ax,%ecx
801060e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060e7:	0f bf d0             	movswl %ax,%edx
801060ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801060ed:	51                   	push   %ecx
801060ee:	52                   	push   %edx
801060ef:	6a 03                	push   $0x3
801060f1:	50                   	push   %eax
801060f2:	e8 c8 fb ff ff       	call   80105cbf <create>
801060f7:	83 c4 10             	add    $0x10,%esp
801060fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106101:	75 0c                	jne    8010610f <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80106103:	e8 73 d4 ff ff       	call   8010357b <end_op>
    return -1;
80106108:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610d:	eb 18                	jmp    80106127 <sys_mknod+0x98>
  }
  iunlockput(ip);
8010610f:	83 ec 0c             	sub    $0xc,%esp
80106112:	ff 75 f0             	pushl  -0x10(%ebp)
80106115:	e8 cc ba ff ff       	call   80101be6 <iunlockput>
8010611a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010611d:	e8 59 d4 ff ff       	call   8010357b <end_op>
  return 0;
80106122:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106127:	c9                   	leave  
80106128:	c3                   	ret    

80106129 <sys_chdir>:

int
sys_chdir(void)
{
80106129:	55                   	push   %ebp
8010612a:	89 e5                	mov    %esp,%ebp
8010612c:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010612f:	e8 b9 d3 ff ff       	call   801034ed <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106134:	83 ec 08             	sub    $0x8,%esp
80106137:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010613a:	50                   	push   %eax
8010613b:	6a 00                	push   $0x0
8010613d:	e8 4e f4 ff ff       	call   80105590 <argstr>
80106142:	83 c4 10             	add    $0x10,%esp
80106145:	85 c0                	test   %eax,%eax
80106147:	78 18                	js     80106161 <sys_chdir+0x38>
80106149:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	50                   	push   %eax
80106150:	e8 8f c3 ff ff       	call   801024e4 <namei>
80106155:	83 c4 10             	add    $0x10,%esp
80106158:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010615b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010615f:	75 0c                	jne    8010616d <sys_chdir+0x44>
    end_op();
80106161:	e8 15 d4 ff ff       	call   8010357b <end_op>
    return -1;
80106166:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616b:	eb 6e                	jmp    801061db <sys_chdir+0xb2>
  }
  ilock(ip);
8010616d:	83 ec 0c             	sub    $0xc,%esp
80106170:	ff 75 f4             	pushl  -0xc(%ebp)
80106173:	e8 b1 b7 ff ff       	call   80101929 <ilock>
80106178:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010617b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010617e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106182:	66 83 f8 01          	cmp    $0x1,%ax
80106186:	74 1a                	je     801061a2 <sys_chdir+0x79>
    iunlockput(ip);
80106188:	83 ec 0c             	sub    $0xc,%esp
8010618b:	ff 75 f4             	pushl  -0xc(%ebp)
8010618e:	e8 53 ba ff ff       	call   80101be6 <iunlockput>
80106193:	83 c4 10             	add    $0x10,%esp
    end_op();
80106196:	e8 e0 d3 ff ff       	call   8010357b <end_op>
    return -1;
8010619b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061a0:	eb 39                	jmp    801061db <sys_chdir+0xb2>
  }
  iunlock(ip);
801061a2:	83 ec 0c             	sub    $0xc,%esp
801061a5:	ff 75 f4             	pushl  -0xc(%ebp)
801061a8:	e8 d9 b8 ff ff       	call   80101a86 <iunlock>
801061ad:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801061b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061b6:	8b 40 68             	mov    0x68(%eax),%eax
801061b9:	83 ec 0c             	sub    $0xc,%esp
801061bc:	50                   	push   %eax
801061bd:	e8 35 b9 ff ff       	call   80101af7 <iput>
801061c2:	83 c4 10             	add    $0x10,%esp
  end_op();
801061c5:	e8 b1 d3 ff ff       	call   8010357b <end_op>
  proc->cwd = ip;
801061ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801061d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061d3:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801061d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061db:	c9                   	leave  
801061dc:	c3                   	ret    

801061dd <sys_exec>:

int
sys_exec(void)
{
801061dd:	55                   	push   %ebp
801061de:	89 e5                	mov    %esp,%ebp
801061e0:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061e6:	83 ec 08             	sub    $0x8,%esp
801061e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ec:	50                   	push   %eax
801061ed:	6a 00                	push   $0x0
801061ef:	e8 9c f3 ff ff       	call   80105590 <argstr>
801061f4:	83 c4 10             	add    $0x10,%esp
801061f7:	85 c0                	test   %eax,%eax
801061f9:	78 18                	js     80106213 <sys_exec+0x36>
801061fb:	83 ec 08             	sub    $0x8,%esp
801061fe:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106204:	50                   	push   %eax
80106205:	6a 01                	push   $0x1
80106207:	e8 fd f2 ff ff       	call   80105509 <argint>
8010620c:	83 c4 10             	add    $0x10,%esp
8010620f:	85 c0                	test   %eax,%eax
80106211:	79 0a                	jns    8010621d <sys_exec+0x40>
    return -1;
80106213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106218:	e9 c6 00 00 00       	jmp    801062e3 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
8010621d:	83 ec 04             	sub    $0x4,%esp
80106220:	68 80 00 00 00       	push   $0x80
80106225:	6a 00                	push   $0x0
80106227:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010622d:	50                   	push   %eax
8010622e:	e8 af ef ff ff       	call   801051e2 <memset>
80106233:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106236:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010623d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106240:	83 f8 1f             	cmp    $0x1f,%eax
80106243:	76 0a                	jbe    8010624f <sys_exec+0x72>
      return -1;
80106245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624a:	e9 94 00 00 00       	jmp    801062e3 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010624f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106252:	c1 e0 02             	shl    $0x2,%eax
80106255:	89 c2                	mov    %eax,%edx
80106257:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010625d:	01 c2                	add    %eax,%edx
8010625f:	83 ec 08             	sub    $0x8,%esp
80106262:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106268:	50                   	push   %eax
80106269:	52                   	push   %edx
8010626a:	e8 fe f1 ff ff       	call   8010546d <fetchint>
8010626f:	83 c4 10             	add    $0x10,%esp
80106272:	85 c0                	test   %eax,%eax
80106274:	79 07                	jns    8010627d <sys_exec+0xa0>
      return -1;
80106276:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627b:	eb 66                	jmp    801062e3 <sys_exec+0x106>
    if(uarg == 0){
8010627d:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106283:	85 c0                	test   %eax,%eax
80106285:	75 27                	jne    801062ae <sys_exec+0xd1>
      argv[i] = 0;
80106287:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010628a:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106291:	00 00 00 00 
      break;
80106295:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106296:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106299:	83 ec 08             	sub    $0x8,%esp
8010629c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801062a2:	52                   	push   %edx
801062a3:	50                   	push   %eax
801062a4:	e8 a6 a8 ff ff       	call   80100b4f <exec>
801062a9:	83 c4 10             	add    $0x10,%esp
801062ac:	eb 35                	jmp    801062e3 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801062ae:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801062b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062b7:	c1 e2 02             	shl    $0x2,%edx
801062ba:	01 c2                	add    %eax,%edx
801062bc:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062c2:	83 ec 08             	sub    $0x8,%esp
801062c5:	52                   	push   %edx
801062c6:	50                   	push   %eax
801062c7:	e8 db f1 ff ff       	call   801054a7 <fetchstr>
801062cc:	83 c4 10             	add    $0x10,%esp
801062cf:	85 c0                	test   %eax,%eax
801062d1:	79 07                	jns    801062da <sys_exec+0xfd>
      return -1;
801062d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d8:	eb 09                	jmp    801062e3 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801062da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801062de:	e9 5a ff ff ff       	jmp    8010623d <sys_exec+0x60>
  return exec(path, argv);
}
801062e3:	c9                   	leave  
801062e4:	c3                   	ret    

801062e5 <sys_pipe>:

int
sys_pipe(void)
{
801062e5:	55                   	push   %ebp
801062e6:	89 e5                	mov    %esp,%ebp
801062e8:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062eb:	83 ec 04             	sub    $0x4,%esp
801062ee:	6a 08                	push   $0x8
801062f0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062f3:	50                   	push   %eax
801062f4:	6a 00                	push   $0x0
801062f6:	e8 36 f2 ff ff       	call   80105531 <argptr>
801062fb:	83 c4 10             	add    $0x10,%esp
801062fe:	85 c0                	test   %eax,%eax
80106300:	79 0a                	jns    8010630c <sys_pipe+0x27>
    return -1;
80106302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106307:	e9 af 00 00 00       	jmp    801063bb <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
8010630c:	83 ec 08             	sub    $0x8,%esp
8010630f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106312:	50                   	push   %eax
80106313:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106316:	50                   	push   %eax
80106317:	e8 b9 dc ff ff       	call   80103fd5 <pipealloc>
8010631c:	83 c4 10             	add    $0x10,%esp
8010631f:	85 c0                	test   %eax,%eax
80106321:	79 0a                	jns    8010632d <sys_pipe+0x48>
    return -1;
80106323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106328:	e9 8e 00 00 00       	jmp    801063bb <sys_pipe+0xd6>
  fd0 = -1;
8010632d:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106334:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106337:	83 ec 0c             	sub    $0xc,%esp
8010633a:	50                   	push   %eax
8010633b:	e8 7b f3 ff ff       	call   801056bb <fdalloc>
80106340:	83 c4 10             	add    $0x10,%esp
80106343:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010634a:	78 18                	js     80106364 <sys_pipe+0x7f>
8010634c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010634f:	83 ec 0c             	sub    $0xc,%esp
80106352:	50                   	push   %eax
80106353:	e8 63 f3 ff ff       	call   801056bb <fdalloc>
80106358:	83 c4 10             	add    $0x10,%esp
8010635b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010635e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106362:	79 3f                	jns    801063a3 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106364:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106368:	78 14                	js     8010637e <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
8010636a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106370:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106373:	83 c2 08             	add    $0x8,%edx
80106376:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010637d:	00 
    fileclose(rf);
8010637e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106381:	83 ec 0c             	sub    $0xc,%esp
80106384:	50                   	push   %eax
80106385:	e8 8e ac ff ff       	call   80101018 <fileclose>
8010638a:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
8010638d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106390:	83 ec 0c             	sub    $0xc,%esp
80106393:	50                   	push   %eax
80106394:	e8 7f ac ff ff       	call   80101018 <fileclose>
80106399:	83 c4 10             	add    $0x10,%esp
    return -1;
8010639c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a1:	eb 18                	jmp    801063bb <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801063a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063a9:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801063ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063ae:	8d 50 04             	lea    0x4(%eax),%edx
801063b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b4:	89 02                	mov    %eax,(%edx)
  return 0;
801063b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063bb:	c9                   	leave  
801063bc:	c3                   	ret    

801063bd <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063bd:	55                   	push   %ebp
801063be:	89 e5                	mov    %esp,%ebp
801063c0:	83 ec 08             	sub    $0x8,%esp
  return fork();
801063c3:	e8 03 e3 ff ff       	call   801046cb <fork>
}
801063c8:	c9                   	leave  
801063c9:	c3                   	ret    

801063ca <sys_exit>:

int
sys_exit(void)
{
801063ca:	55                   	push   %ebp
801063cb:	89 e5                	mov    %esp,%ebp
801063cd:	83 ec 08             	sub    $0x8,%esp
  exit();
801063d0:	e8 87 e4 ff ff       	call   8010485c <exit>
  return 0;  // not reached
801063d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063da:	c9                   	leave  
801063db:	c3                   	ret    

801063dc <sys_wait>:

int
sys_wait(void)
{
801063dc:	55                   	push   %ebp
801063dd:	89 e5                	mov    %esp,%ebp
801063df:	83 ec 08             	sub    $0x8,%esp
  return wait();
801063e2:	e8 ad e5 ff ff       	call   80104994 <wait>
}
801063e7:	c9                   	leave  
801063e8:	c3                   	ret    

801063e9 <sys_kill>:

int
sys_kill(void)
{
801063e9:	55                   	push   %ebp
801063ea:	89 e5                	mov    %esp,%ebp
801063ec:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063ef:	83 ec 08             	sub    $0x8,%esp
801063f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063f5:	50                   	push   %eax
801063f6:	6a 00                	push   $0x0
801063f8:	e8 0c f1 ff ff       	call   80105509 <argint>
801063fd:	83 c4 10             	add    $0x10,%esp
80106400:	85 c0                	test   %eax,%eax
80106402:	79 07                	jns    8010640b <sys_kill+0x22>
    return -1;
80106404:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106409:	eb 0f                	jmp    8010641a <sys_kill+0x31>
  return kill(pid);
8010640b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640e:	83 ec 0c             	sub    $0xc,%esp
80106411:	50                   	push   %eax
80106412:	e8 9e e9 ff ff       	call   80104db5 <kill>
80106417:	83 c4 10             	add    $0x10,%esp
}
8010641a:	c9                   	leave  
8010641b:	c3                   	ret    

8010641c <sys_getpid>:

int
sys_getpid(void)
{
8010641c:	55                   	push   %ebp
8010641d:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010641f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106425:	8b 40 10             	mov    0x10(%eax),%eax
}
80106428:	5d                   	pop    %ebp
80106429:	c3                   	ret    

8010642a <sys_sbrk>:

int
sys_sbrk(void)
{
8010642a:	55                   	push   %ebp
8010642b:	89 e5                	mov    %esp,%ebp
8010642d:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106430:	83 ec 08             	sub    $0x8,%esp
80106433:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106436:	50                   	push   %eax
80106437:	6a 00                	push   $0x0
80106439:	e8 cb f0 ff ff       	call   80105509 <argint>
8010643e:	83 c4 10             	add    $0x10,%esp
80106441:	85 c0                	test   %eax,%eax
80106443:	79 07                	jns    8010644c <sys_sbrk+0x22>
    return -1;
80106445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644a:	eb 28                	jmp    80106474 <sys_sbrk+0x4a>
  addr = proc->sz;
8010644c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106452:	8b 00                	mov    (%eax),%eax
80106454:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106457:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010645a:	83 ec 0c             	sub    $0xc,%esp
8010645d:	50                   	push   %eax
8010645e:	e8 c5 e1 ff ff       	call   80104628 <growproc>
80106463:	83 c4 10             	add    $0x10,%esp
80106466:	85 c0                	test   %eax,%eax
80106468:	79 07                	jns    80106471 <sys_sbrk+0x47>
    return -1;
8010646a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010646f:	eb 03                	jmp    80106474 <sys_sbrk+0x4a>
  return addr;
80106471:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106474:	c9                   	leave  
80106475:	c3                   	ret    

80106476 <sys_sleep>:

int
sys_sleep(void)
{
80106476:	55                   	push   %ebp
80106477:	89 e5                	mov    %esp,%ebp
80106479:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010647c:	83 ec 08             	sub    $0x8,%esp
8010647f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106482:	50                   	push   %eax
80106483:	6a 00                	push   $0x0
80106485:	e8 7f f0 ff ff       	call   80105509 <argint>
8010648a:	83 c4 10             	add    $0x10,%esp
8010648d:	85 c0                	test   %eax,%eax
8010648f:	79 07                	jns    80106498 <sys_sleep+0x22>
    return -1;
80106491:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106496:	eb 77                	jmp    8010650f <sys_sleep+0x99>
  acquire(&tickslock);
80106498:	83 ec 0c             	sub    $0xc,%esp
8010649b:	68 c0 49 11 80       	push   $0x801149c0
801064a0:	e8 e1 ea ff ff       	call   80104f86 <acquire>
801064a5:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064a8:	a1 00 52 11 80       	mov    0x80115200,%eax
801064ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801064b0:	eb 39                	jmp    801064eb <sys_sleep+0x75>
    if(proc->killed){
801064b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064b8:	8b 40 24             	mov    0x24(%eax),%eax
801064bb:	85 c0                	test   %eax,%eax
801064bd:	74 17                	je     801064d6 <sys_sleep+0x60>
      release(&tickslock);
801064bf:	83 ec 0c             	sub    $0xc,%esp
801064c2:	68 c0 49 11 80       	push   $0x801149c0
801064c7:	e8 20 eb ff ff       	call   80104fec <release>
801064cc:	83 c4 10             	add    $0x10,%esp
      return -1;
801064cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064d4:	eb 39                	jmp    8010650f <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
801064d6:	83 ec 08             	sub    $0x8,%esp
801064d9:	68 c0 49 11 80       	push   $0x801149c0
801064de:	68 00 52 11 80       	push   $0x80115200
801064e3:	e8 ae e7 ff ff       	call   80104c96 <sleep>
801064e8:	83 c4 10             	add    $0x10,%esp
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064eb:	a1 00 52 11 80       	mov    0x80115200,%eax
801064f0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801064f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064f6:	39 d0                	cmp    %edx,%eax
801064f8:	72 b8                	jb     801064b2 <sys_sleep+0x3c>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801064fa:	83 ec 0c             	sub    $0xc,%esp
801064fd:	68 c0 49 11 80       	push   $0x801149c0
80106502:	e8 e5 ea ff ff       	call   80104fec <release>
80106507:	83 c4 10             	add    $0x10,%esp
  return 0;
8010650a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010650f:	c9                   	leave  
80106510:	c3                   	ret    

80106511 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106511:	55                   	push   %ebp
80106512:	89 e5                	mov    %esp,%ebp
80106514:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
80106517:	83 ec 0c             	sub    $0xc,%esp
8010651a:	68 c0 49 11 80       	push   $0x801149c0
8010651f:	e8 62 ea ff ff       	call   80104f86 <acquire>
80106524:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
80106527:	a1 00 52 11 80       	mov    0x80115200,%eax
8010652c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010652f:	83 ec 0c             	sub    $0xc,%esp
80106532:	68 c0 49 11 80       	push   $0x801149c0
80106537:	e8 b0 ea ff ff       	call   80104fec <release>
8010653c:	83 c4 10             	add    $0x10,%esp
  return xticks;
8010653f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106542:	c9                   	leave  
80106543:	c3                   	ret    

80106544 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106544:	55                   	push   %ebp
80106545:	89 e5                	mov    %esp,%ebp
80106547:	83 ec 08             	sub    $0x8,%esp
8010654a:	8b 55 08             	mov    0x8(%ebp),%edx
8010654d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106550:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106554:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106557:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010655b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010655f:	ee                   	out    %al,(%dx)
}
80106560:	c9                   	leave  
80106561:	c3                   	ret    

80106562 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106562:	55                   	push   %ebp
80106563:	89 e5                	mov    %esp,%ebp
80106565:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106568:	6a 34                	push   $0x34
8010656a:	6a 43                	push   $0x43
8010656c:	e8 d3 ff ff ff       	call   80106544 <outb>
80106571:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106574:	68 9c 00 00 00       	push   $0x9c
80106579:	6a 40                	push   $0x40
8010657b:	e8 c4 ff ff ff       	call   80106544 <outb>
80106580:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106583:	6a 2e                	push   $0x2e
80106585:	6a 40                	push   $0x40
80106587:	e8 b8 ff ff ff       	call   80106544 <outb>
8010658c:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010658f:	83 ec 0c             	sub    $0xc,%esp
80106592:	6a 00                	push   $0x0
80106594:	e8 28 d9 ff ff       	call   80103ec1 <picenable>
80106599:	83 c4 10             	add    $0x10,%esp
}
8010659c:	c9                   	leave  
8010659d:	c3                   	ret    

8010659e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010659e:	1e                   	push   %ds
  pushl %es
8010659f:	06                   	push   %es
  pushl %fs
801065a0:	0f a0                	push   %fs
  pushl %gs
801065a2:	0f a8                	push   %gs
  pushal
801065a4:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801065a5:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065a9:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065ab:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801065ad:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801065b1:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801065b3:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801065b5:	54                   	push   %esp
  call trap
801065b6:	e8 d4 01 00 00       	call   8010678f <trap>
  addl $4, %esp
801065bb:	83 c4 04             	add    $0x4,%esp

801065be <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065be:	61                   	popa   
  popl %gs
801065bf:	0f a9                	pop    %gs
  popl %fs
801065c1:	0f a1                	pop    %fs
  popl %es
801065c3:	07                   	pop    %es
  popl %ds
801065c4:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065c5:	83 c4 08             	add    $0x8,%esp
  iret
801065c8:	cf                   	iret   

801065c9 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801065c9:	55                   	push   %ebp
801065ca:	89 e5                	mov    %esp,%ebp
801065cc:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801065cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801065d2:	83 e8 01             	sub    $0x1,%eax
801065d5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065d9:	8b 45 08             	mov    0x8(%ebp),%eax
801065dc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065e0:	8b 45 08             	mov    0x8(%ebp),%eax
801065e3:	c1 e8 10             	shr    $0x10,%eax
801065e6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801065ea:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065ed:	0f 01 18             	lidtl  (%eax)
}
801065f0:	c9                   	leave  
801065f1:	c3                   	ret    

801065f2 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801065f2:	55                   	push   %ebp
801065f3:	89 e5                	mov    %esp,%ebp
801065f5:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801065f8:	0f 20 d0             	mov    %cr2,%eax
801065fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801065fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106601:	c9                   	leave  
80106602:	c3                   	ret    

80106603 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106603:	55                   	push   %ebp
80106604:	89 e5                	mov    %esp,%ebp
80106606:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106609:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106610:	e9 c3 00 00 00       	jmp    801066d8 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106618:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
8010661f:	89 c2                	mov    %eax,%edx
80106621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106624:	66 89 14 c5 00 4a 11 	mov    %dx,-0x7feeb600(,%eax,8)
8010662b:	80 
8010662c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010662f:	66 c7 04 c5 02 4a 11 	movw   $0x8,-0x7feeb5fe(,%eax,8)
80106636:	80 08 00 
80106639:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010663c:	0f b6 14 c5 04 4a 11 	movzbl -0x7feeb5fc(,%eax,8),%edx
80106643:	80 
80106644:	83 e2 e0             	and    $0xffffffe0,%edx
80106647:	88 14 c5 04 4a 11 80 	mov    %dl,-0x7feeb5fc(,%eax,8)
8010664e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106651:	0f b6 14 c5 04 4a 11 	movzbl -0x7feeb5fc(,%eax,8),%edx
80106658:	80 
80106659:	83 e2 1f             	and    $0x1f,%edx
8010665c:	88 14 c5 04 4a 11 80 	mov    %dl,-0x7feeb5fc(,%eax,8)
80106663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106666:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
8010666d:	80 
8010666e:	83 e2 f0             	and    $0xfffffff0,%edx
80106671:	83 ca 0e             	or     $0xe,%edx
80106674:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
8010667b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667e:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
80106685:	80 
80106686:	83 e2 ef             	and    $0xffffffef,%edx
80106689:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
80106690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106693:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
8010669a:	80 
8010669b:	83 e2 9f             	and    $0xffffff9f,%edx
8010669e:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
801066a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a8:	0f b6 14 c5 05 4a 11 	movzbl -0x7feeb5fb(,%eax,8),%edx
801066af:	80 
801066b0:	83 ca 80             	or     $0xffffff80,%edx
801066b3:	88 14 c5 05 4a 11 80 	mov    %dl,-0x7feeb5fb(,%eax,8)
801066ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066bd:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
801066c4:	c1 e8 10             	shr    $0x10,%eax
801066c7:	89 c2                	mov    %eax,%edx
801066c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066cc:	66 89 14 c5 06 4a 11 	mov    %dx,-0x7feeb5fa(,%eax,8)
801066d3:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801066d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066d8:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801066df:	0f 8e 30 ff ff ff    	jle    80106615 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801066e5:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801066ea:	66 a3 00 4c 11 80    	mov    %ax,0x80114c00
801066f0:	66 c7 05 02 4c 11 80 	movw   $0x8,0x80114c02
801066f7:	08 00 
801066f9:	0f b6 05 04 4c 11 80 	movzbl 0x80114c04,%eax
80106700:	83 e0 e0             	and    $0xffffffe0,%eax
80106703:	a2 04 4c 11 80       	mov    %al,0x80114c04
80106708:	0f b6 05 04 4c 11 80 	movzbl 0x80114c04,%eax
8010670f:	83 e0 1f             	and    $0x1f,%eax
80106712:	a2 04 4c 11 80       	mov    %al,0x80114c04
80106717:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
8010671e:	83 c8 0f             	or     $0xf,%eax
80106721:	a2 05 4c 11 80       	mov    %al,0x80114c05
80106726:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
8010672d:	83 e0 ef             	and    $0xffffffef,%eax
80106730:	a2 05 4c 11 80       	mov    %al,0x80114c05
80106735:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
8010673c:	83 c8 60             	or     $0x60,%eax
8010673f:	a2 05 4c 11 80       	mov    %al,0x80114c05
80106744:	0f b6 05 05 4c 11 80 	movzbl 0x80114c05,%eax
8010674b:	83 c8 80             	or     $0xffffff80,%eax
8010674e:	a2 05 4c 11 80       	mov    %al,0x80114c05
80106753:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106758:	c1 e8 10             	shr    $0x10,%eax
8010675b:	66 a3 06 4c 11 80    	mov    %ax,0x80114c06
  
  initlock(&tickslock, "time");
80106761:	83 ec 08             	sub    $0x8,%esp
80106764:	68 58 89 10 80       	push   $0x80108958
80106769:	68 c0 49 11 80       	push   $0x801149c0
8010676e:	e8 f2 e7 ff ff       	call   80104f65 <initlock>
80106773:	83 c4 10             	add    $0x10,%esp
}
80106776:	c9                   	leave  
80106777:	c3                   	ret    

80106778 <idtinit>:

void
idtinit(void)
{
80106778:	55                   	push   %ebp
80106779:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010677b:	68 00 08 00 00       	push   $0x800
80106780:	68 00 4a 11 80       	push   $0x80114a00
80106785:	e8 3f fe ff ff       	call   801065c9 <lidt>
8010678a:	83 c4 08             	add    $0x8,%esp
}
8010678d:	c9                   	leave  
8010678e:	c3                   	ret    

8010678f <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010678f:	55                   	push   %ebp
80106790:	89 e5                	mov    %esp,%ebp
80106792:	57                   	push   %edi
80106793:	56                   	push   %esi
80106794:	53                   	push   %ebx
80106795:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80106798:	8b 45 08             	mov    0x8(%ebp),%eax
8010679b:	8b 40 30             	mov    0x30(%eax),%eax
8010679e:	83 f8 40             	cmp    $0x40,%eax
801067a1:	75 3f                	jne    801067e2 <trap+0x53>
    if(proc->killed)
801067a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067a9:	8b 40 24             	mov    0x24(%eax),%eax
801067ac:	85 c0                	test   %eax,%eax
801067ae:	74 05                	je     801067b5 <trap+0x26>
      exit();
801067b0:	e8 a7 e0 ff ff       	call   8010485c <exit>
    proc->tf = tf;
801067b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067bb:	8b 55 08             	mov    0x8(%ebp),%edx
801067be:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801067c1:	e8 fb ed ff ff       	call   801055c1 <syscall>
    if(proc->killed)
801067c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067cc:	8b 40 24             	mov    0x24(%eax),%eax
801067cf:	85 c0                	test   %eax,%eax
801067d1:	74 0a                	je     801067dd <trap+0x4e>
      exit();
801067d3:	e8 84 e0 ff ff       	call   8010485c <exit>
    return;
801067d8:	e9 14 02 00 00       	jmp    801069f1 <trap+0x262>
801067dd:	e9 0f 02 00 00       	jmp    801069f1 <trap+0x262>
  }

  switch(tf->trapno){
801067e2:	8b 45 08             	mov    0x8(%ebp),%eax
801067e5:	8b 40 30             	mov    0x30(%eax),%eax
801067e8:	83 e8 20             	sub    $0x20,%eax
801067eb:	83 f8 1f             	cmp    $0x1f,%eax
801067ee:	0f 87 c0 00 00 00    	ja     801068b4 <trap+0x125>
801067f4:	8b 04 85 00 8a 10 80 	mov    -0x7fef7600(,%eax,4),%eax
801067fb:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801067fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106803:	0f b6 00             	movzbl (%eax),%eax
80106806:	84 c0                	test   %al,%al
80106808:	75 3d                	jne    80106847 <trap+0xb8>
      acquire(&tickslock);
8010680a:	83 ec 0c             	sub    $0xc,%esp
8010680d:	68 c0 49 11 80       	push   $0x801149c0
80106812:	e8 6f e7 ff ff       	call   80104f86 <acquire>
80106817:	83 c4 10             	add    $0x10,%esp
      ticks++;
8010681a:	a1 00 52 11 80       	mov    0x80115200,%eax
8010681f:	83 c0 01             	add    $0x1,%eax
80106822:	a3 00 52 11 80       	mov    %eax,0x80115200
      wakeup(&ticks);
80106827:	83 ec 0c             	sub    $0xc,%esp
8010682a:	68 00 52 11 80       	push   $0x80115200
8010682f:	e8 4b e5 ff ff       	call   80104d7f <wakeup>
80106834:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106837:	83 ec 0c             	sub    $0xc,%esp
8010683a:	68 c0 49 11 80       	push   $0x801149c0
8010683f:	e8 a8 e7 ff ff       	call   80104fec <release>
80106844:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106847:	e8 82 c7 ff ff       	call   80102fce <lapiceoi>
    break;
8010684c:	e9 1c 01 00 00       	jmp    8010696d <trap+0x1de>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106851:	e8 99 bf ff ff       	call   801027ef <ideintr>
    lapiceoi();
80106856:	e8 73 c7 ff ff       	call   80102fce <lapiceoi>
    break;
8010685b:	e9 0d 01 00 00       	jmp    8010696d <trap+0x1de>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106860:	e8 70 c5 ff ff       	call   80102dd5 <kbdintr>
    lapiceoi();
80106865:	e8 64 c7 ff ff       	call   80102fce <lapiceoi>
    break;
8010686a:	e9 fe 00 00 00       	jmp    8010696d <trap+0x1de>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010686f:	e8 5a 03 00 00       	call   80106bce <uartintr>
    lapiceoi();
80106874:	e8 55 c7 ff ff       	call   80102fce <lapiceoi>
    break;
80106879:	e9 ef 00 00 00       	jmp    8010696d <trap+0x1de>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010687e:	8b 45 08             	mov    0x8(%ebp),%eax
80106881:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80106884:	8b 45 08             	mov    0x8(%ebp),%eax
80106887:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010688b:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010688e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106894:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106897:	0f b6 c0             	movzbl %al,%eax
8010689a:	51                   	push   %ecx
8010689b:	52                   	push   %edx
8010689c:	50                   	push   %eax
8010689d:	68 60 89 10 80       	push   $0x80108960
801068a2:	e8 18 9b ff ff       	call   801003bf <cprintf>
801068a7:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801068aa:	e8 1f c7 ff ff       	call   80102fce <lapiceoi>
    break;
801068af:	e9 b9 00 00 00       	jmp    8010696d <trap+0x1de>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801068b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068ba:	85 c0                	test   %eax,%eax
801068bc:	74 11                	je     801068cf <trap+0x140>
801068be:	8b 45 08             	mov    0x8(%ebp),%eax
801068c1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801068c5:	0f b7 c0             	movzwl %ax,%eax
801068c8:	83 e0 03             	and    $0x3,%eax
801068cb:	85 c0                	test   %eax,%eax
801068cd:	75 40                	jne    8010690f <trap+0x180>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068cf:	e8 1e fd ff ff       	call   801065f2 <rcr2>
801068d4:	89 c3                	mov    %eax,%ebx
801068d6:	8b 45 08             	mov    0x8(%ebp),%eax
801068d9:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801068dc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801068e2:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068e5:	0f b6 d0             	movzbl %al,%edx
801068e8:	8b 45 08             	mov    0x8(%ebp),%eax
801068eb:	8b 40 30             	mov    0x30(%eax),%eax
801068ee:	83 ec 0c             	sub    $0xc,%esp
801068f1:	53                   	push   %ebx
801068f2:	51                   	push   %ecx
801068f3:	52                   	push   %edx
801068f4:	50                   	push   %eax
801068f5:	68 84 89 10 80       	push   $0x80108984
801068fa:	e8 c0 9a ff ff       	call   801003bf <cprintf>
801068ff:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106902:	83 ec 0c             	sub    $0xc,%esp
80106905:	68 b6 89 10 80       	push   $0x801089b6
8010690a:	e8 4d 9c ff ff       	call   8010055c <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010690f:	e8 de fc ff ff       	call   801065f2 <rcr2>
80106914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106917:	8b 45 08             	mov    0x8(%ebp),%eax
8010691a:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010691d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106923:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106926:	0f b6 d8             	movzbl %al,%ebx
80106929:	8b 45 08             	mov    0x8(%ebp),%eax
8010692c:	8b 48 34             	mov    0x34(%eax),%ecx
8010692f:	8b 45 08             	mov    0x8(%ebp),%eax
80106932:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106935:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010693b:	8d 78 6c             	lea    0x6c(%eax),%edi
8010693e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106944:	8b 40 10             	mov    0x10(%eax),%eax
80106947:	ff 75 e4             	pushl  -0x1c(%ebp)
8010694a:	56                   	push   %esi
8010694b:	53                   	push   %ebx
8010694c:	51                   	push   %ecx
8010694d:	52                   	push   %edx
8010694e:	57                   	push   %edi
8010694f:	50                   	push   %eax
80106950:	68 bc 89 10 80       	push   $0x801089bc
80106955:	e8 65 9a ff ff       	call   801003bf <cprintf>
8010695a:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010695d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106963:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010696a:	eb 01                	jmp    8010696d <trap+0x1de>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010696c:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010696d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106973:	85 c0                	test   %eax,%eax
80106975:	74 24                	je     8010699b <trap+0x20c>
80106977:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010697d:	8b 40 24             	mov    0x24(%eax),%eax
80106980:	85 c0                	test   %eax,%eax
80106982:	74 17                	je     8010699b <trap+0x20c>
80106984:	8b 45 08             	mov    0x8(%ebp),%eax
80106987:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010698b:	0f b7 c0             	movzwl %ax,%eax
8010698e:	83 e0 03             	and    $0x3,%eax
80106991:	83 f8 03             	cmp    $0x3,%eax
80106994:	75 05                	jne    8010699b <trap+0x20c>
    exit();
80106996:	e8 c1 de ff ff       	call   8010485c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010699b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a1:	85 c0                	test   %eax,%eax
801069a3:	74 1e                	je     801069c3 <trap+0x234>
801069a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069ab:	8b 40 0c             	mov    0xc(%eax),%eax
801069ae:	83 f8 04             	cmp    $0x4,%eax
801069b1:	75 10                	jne    801069c3 <trap+0x234>
801069b3:	8b 45 08             	mov    0x8(%ebp),%eax
801069b6:	8b 40 30             	mov    0x30(%eax),%eax
801069b9:	83 f8 20             	cmp    $0x20,%eax
801069bc:	75 05                	jne    801069c3 <trap+0x234>
    yield();
801069be:	e8 54 e2 ff ff       	call   80104c17 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801069c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c9:	85 c0                	test   %eax,%eax
801069cb:	74 24                	je     801069f1 <trap+0x262>
801069cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069d3:	8b 40 24             	mov    0x24(%eax),%eax
801069d6:	85 c0                	test   %eax,%eax
801069d8:	74 17                	je     801069f1 <trap+0x262>
801069da:	8b 45 08             	mov    0x8(%ebp),%eax
801069dd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069e1:	0f b7 c0             	movzwl %ax,%eax
801069e4:	83 e0 03             	and    $0x3,%eax
801069e7:	83 f8 03             	cmp    $0x3,%eax
801069ea:	75 05                	jne    801069f1 <trap+0x262>
    exit();
801069ec:	e8 6b de ff ff       	call   8010485c <exit>
}
801069f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f4:	5b                   	pop    %ebx
801069f5:	5e                   	pop    %esi
801069f6:	5f                   	pop    %edi
801069f7:	5d                   	pop    %ebp
801069f8:	c3                   	ret    

801069f9 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801069f9:	55                   	push   %ebp
801069fa:	89 e5                	mov    %esp,%ebp
801069fc:	83 ec 14             	sub    $0x14,%esp
801069ff:	8b 45 08             	mov    0x8(%ebp),%eax
80106a02:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a06:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106a0a:	89 c2                	mov    %eax,%edx
80106a0c:	ec                   	in     (%dx),%al
80106a0d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106a10:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106a14:	c9                   	leave  
80106a15:	c3                   	ret    

80106a16 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106a16:	55                   	push   %ebp
80106a17:	89 e5                	mov    %esp,%ebp
80106a19:	83 ec 08             	sub    $0x8,%esp
80106a1c:	8b 55 08             	mov    0x8(%ebp),%edx
80106a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a22:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106a26:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106a29:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106a2d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106a31:	ee                   	out    %al,(%dx)
}
80106a32:	c9                   	leave  
80106a33:	c3                   	ret    

80106a34 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106a34:	55                   	push   %ebp
80106a35:	89 e5                	mov    %esp,%ebp
80106a37:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106a3a:	6a 00                	push   $0x0
80106a3c:	68 fa 03 00 00       	push   $0x3fa
80106a41:	e8 d0 ff ff ff       	call   80106a16 <outb>
80106a46:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106a49:	68 80 00 00 00       	push   $0x80
80106a4e:	68 fb 03 00 00       	push   $0x3fb
80106a53:	e8 be ff ff ff       	call   80106a16 <outb>
80106a58:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106a5b:	6a 0c                	push   $0xc
80106a5d:	68 f8 03 00 00       	push   $0x3f8
80106a62:	e8 af ff ff ff       	call   80106a16 <outb>
80106a67:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106a6a:	6a 00                	push   $0x0
80106a6c:	68 f9 03 00 00       	push   $0x3f9
80106a71:	e8 a0 ff ff ff       	call   80106a16 <outb>
80106a76:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106a79:	6a 03                	push   $0x3
80106a7b:	68 fb 03 00 00       	push   $0x3fb
80106a80:	e8 91 ff ff ff       	call   80106a16 <outb>
80106a85:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106a88:	6a 00                	push   $0x0
80106a8a:	68 fc 03 00 00       	push   $0x3fc
80106a8f:	e8 82 ff ff ff       	call   80106a16 <outb>
80106a94:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a97:	6a 01                	push   $0x1
80106a99:	68 f9 03 00 00       	push   $0x3f9
80106a9e:	e8 73 ff ff ff       	call   80106a16 <outb>
80106aa3:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106aa6:	68 fd 03 00 00       	push   $0x3fd
80106aab:	e8 49 ff ff ff       	call   801069f9 <inb>
80106ab0:	83 c4 04             	add    $0x4,%esp
80106ab3:	3c ff                	cmp    $0xff,%al
80106ab5:	75 02                	jne    80106ab9 <uartinit+0x85>
    return;
80106ab7:	eb 6c                	jmp    80106b25 <uartinit+0xf1>
  uart = 1;
80106ab9:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106ac0:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106ac3:	68 fa 03 00 00       	push   $0x3fa
80106ac8:	e8 2c ff ff ff       	call   801069f9 <inb>
80106acd:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106ad0:	68 f8 03 00 00       	push   $0x3f8
80106ad5:	e8 1f ff ff ff       	call   801069f9 <inb>
80106ada:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106add:	83 ec 0c             	sub    $0xc,%esp
80106ae0:	6a 04                	push   $0x4
80106ae2:	e8 da d3 ff ff       	call   80103ec1 <picenable>
80106ae7:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106aea:	83 ec 08             	sub    $0x8,%esp
80106aed:	6a 00                	push   $0x0
80106aef:	6a 04                	push   $0x4
80106af1:	e8 97 bf ff ff       	call   80102a8d <ioapicenable>
80106af6:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106af9:	c7 45 f4 80 8a 10 80 	movl   $0x80108a80,-0xc(%ebp)
80106b00:	eb 19                	jmp    80106b1b <uartinit+0xe7>
    uartputc(*p);
80106b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b05:	0f b6 00             	movzbl (%eax),%eax
80106b08:	0f be c0             	movsbl %al,%eax
80106b0b:	83 ec 0c             	sub    $0xc,%esp
80106b0e:	50                   	push   %eax
80106b0f:	e8 13 00 00 00       	call   80106b27 <uartputc>
80106b14:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106b17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b1e:	0f b6 00             	movzbl (%eax),%eax
80106b21:	84 c0                	test   %al,%al
80106b23:	75 dd                	jne    80106b02 <uartinit+0xce>
    uartputc(*p);
}
80106b25:	c9                   	leave  
80106b26:	c3                   	ret    

80106b27 <uartputc>:

void
uartputc(int c)
{
80106b27:	55                   	push   %ebp
80106b28:	89 e5                	mov    %esp,%ebp
80106b2a:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106b2d:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106b32:	85 c0                	test   %eax,%eax
80106b34:	75 02                	jne    80106b38 <uartputc+0x11>
    return;
80106b36:	eb 51                	jmp    80106b89 <uartputc+0x62>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106b3f:	eb 11                	jmp    80106b52 <uartputc+0x2b>
    microdelay(10);
80106b41:	83 ec 0c             	sub    $0xc,%esp
80106b44:	6a 0a                	push   $0xa
80106b46:	e8 9d c4 ff ff       	call   80102fe8 <microdelay>
80106b4b:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106b4e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106b52:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106b56:	7f 1a                	jg     80106b72 <uartputc+0x4b>
80106b58:	83 ec 0c             	sub    $0xc,%esp
80106b5b:	68 fd 03 00 00       	push   $0x3fd
80106b60:	e8 94 fe ff ff       	call   801069f9 <inb>
80106b65:	83 c4 10             	add    $0x10,%esp
80106b68:	0f b6 c0             	movzbl %al,%eax
80106b6b:	83 e0 20             	and    $0x20,%eax
80106b6e:	85 c0                	test   %eax,%eax
80106b70:	74 cf                	je     80106b41 <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
80106b72:	8b 45 08             	mov    0x8(%ebp),%eax
80106b75:	0f b6 c0             	movzbl %al,%eax
80106b78:	83 ec 08             	sub    $0x8,%esp
80106b7b:	50                   	push   %eax
80106b7c:	68 f8 03 00 00       	push   $0x3f8
80106b81:	e8 90 fe ff ff       	call   80106a16 <outb>
80106b86:	83 c4 10             	add    $0x10,%esp
}
80106b89:	c9                   	leave  
80106b8a:	c3                   	ret    

80106b8b <uartgetc>:

static int
uartgetc(void)
{
80106b8b:	55                   	push   %ebp
80106b8c:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106b8e:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106b93:	85 c0                	test   %eax,%eax
80106b95:	75 07                	jne    80106b9e <uartgetc+0x13>
    return -1;
80106b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b9c:	eb 2e                	jmp    80106bcc <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106b9e:	68 fd 03 00 00       	push   $0x3fd
80106ba3:	e8 51 fe ff ff       	call   801069f9 <inb>
80106ba8:	83 c4 04             	add    $0x4,%esp
80106bab:	0f b6 c0             	movzbl %al,%eax
80106bae:	83 e0 01             	and    $0x1,%eax
80106bb1:	85 c0                	test   %eax,%eax
80106bb3:	75 07                	jne    80106bbc <uartgetc+0x31>
    return -1;
80106bb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bba:	eb 10                	jmp    80106bcc <uartgetc+0x41>
  return inb(COM1+0);
80106bbc:	68 f8 03 00 00       	push   $0x3f8
80106bc1:	e8 33 fe ff ff       	call   801069f9 <inb>
80106bc6:	83 c4 04             	add    $0x4,%esp
80106bc9:	0f b6 c0             	movzbl %al,%eax
}
80106bcc:	c9                   	leave  
80106bcd:	c3                   	ret    

80106bce <uartintr>:

void
uartintr(void)
{
80106bce:	55                   	push   %ebp
80106bcf:	89 e5                	mov    %esp,%ebp
80106bd1:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106bd4:	83 ec 0c             	sub    $0xc,%esp
80106bd7:	68 8b 6b 10 80       	push   $0x80106b8b
80106bdc:	e8 f0 9b ff ff       	call   801007d1 <consoleintr>
80106be1:	83 c4 10             	add    $0x10,%esp
}
80106be4:	c9                   	leave  
80106be5:	c3                   	ret    

80106be6 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $0
80106be8:	6a 00                	push   $0x0
  jmp alltraps
80106bea:	e9 af f9 ff ff       	jmp    8010659e <alltraps>

80106bef <vector1>:
.globl vector1
vector1:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $1
80106bf1:	6a 01                	push   $0x1
  jmp alltraps
80106bf3:	e9 a6 f9 ff ff       	jmp    8010659e <alltraps>

80106bf8 <vector2>:
.globl vector2
vector2:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $2
80106bfa:	6a 02                	push   $0x2
  jmp alltraps
80106bfc:	e9 9d f9 ff ff       	jmp    8010659e <alltraps>

80106c01 <vector3>:
.globl vector3
vector3:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $3
80106c03:	6a 03                	push   $0x3
  jmp alltraps
80106c05:	e9 94 f9 ff ff       	jmp    8010659e <alltraps>

80106c0a <vector4>:
.globl vector4
vector4:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $4
80106c0c:	6a 04                	push   $0x4
  jmp alltraps
80106c0e:	e9 8b f9 ff ff       	jmp    8010659e <alltraps>

80106c13 <vector5>:
.globl vector5
vector5:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $5
80106c15:	6a 05                	push   $0x5
  jmp alltraps
80106c17:	e9 82 f9 ff ff       	jmp    8010659e <alltraps>

80106c1c <vector6>:
.globl vector6
vector6:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $6
80106c1e:	6a 06                	push   $0x6
  jmp alltraps
80106c20:	e9 79 f9 ff ff       	jmp    8010659e <alltraps>

80106c25 <vector7>:
.globl vector7
vector7:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $7
80106c27:	6a 07                	push   $0x7
  jmp alltraps
80106c29:	e9 70 f9 ff ff       	jmp    8010659e <alltraps>

80106c2e <vector8>:
.globl vector8
vector8:
  pushl $8
80106c2e:	6a 08                	push   $0x8
  jmp alltraps
80106c30:	e9 69 f9 ff ff       	jmp    8010659e <alltraps>

80106c35 <vector9>:
.globl vector9
vector9:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $9
80106c37:	6a 09                	push   $0x9
  jmp alltraps
80106c39:	e9 60 f9 ff ff       	jmp    8010659e <alltraps>

80106c3e <vector10>:
.globl vector10
vector10:
  pushl $10
80106c3e:	6a 0a                	push   $0xa
  jmp alltraps
80106c40:	e9 59 f9 ff ff       	jmp    8010659e <alltraps>

80106c45 <vector11>:
.globl vector11
vector11:
  pushl $11
80106c45:	6a 0b                	push   $0xb
  jmp alltraps
80106c47:	e9 52 f9 ff ff       	jmp    8010659e <alltraps>

80106c4c <vector12>:
.globl vector12
vector12:
  pushl $12
80106c4c:	6a 0c                	push   $0xc
  jmp alltraps
80106c4e:	e9 4b f9 ff ff       	jmp    8010659e <alltraps>

80106c53 <vector13>:
.globl vector13
vector13:
  pushl $13
80106c53:	6a 0d                	push   $0xd
  jmp alltraps
80106c55:	e9 44 f9 ff ff       	jmp    8010659e <alltraps>

80106c5a <vector14>:
.globl vector14
vector14:
  pushl $14
80106c5a:	6a 0e                	push   $0xe
  jmp alltraps
80106c5c:	e9 3d f9 ff ff       	jmp    8010659e <alltraps>

80106c61 <vector15>:
.globl vector15
vector15:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $15
80106c63:	6a 0f                	push   $0xf
  jmp alltraps
80106c65:	e9 34 f9 ff ff       	jmp    8010659e <alltraps>

80106c6a <vector16>:
.globl vector16
vector16:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $16
80106c6c:	6a 10                	push   $0x10
  jmp alltraps
80106c6e:	e9 2b f9 ff ff       	jmp    8010659e <alltraps>

80106c73 <vector17>:
.globl vector17
vector17:
  pushl $17
80106c73:	6a 11                	push   $0x11
  jmp alltraps
80106c75:	e9 24 f9 ff ff       	jmp    8010659e <alltraps>

80106c7a <vector18>:
.globl vector18
vector18:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $18
80106c7c:	6a 12                	push   $0x12
  jmp alltraps
80106c7e:	e9 1b f9 ff ff       	jmp    8010659e <alltraps>

80106c83 <vector19>:
.globl vector19
vector19:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $19
80106c85:	6a 13                	push   $0x13
  jmp alltraps
80106c87:	e9 12 f9 ff ff       	jmp    8010659e <alltraps>

80106c8c <vector20>:
.globl vector20
vector20:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $20
80106c8e:	6a 14                	push   $0x14
  jmp alltraps
80106c90:	e9 09 f9 ff ff       	jmp    8010659e <alltraps>

80106c95 <vector21>:
.globl vector21
vector21:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $21
80106c97:	6a 15                	push   $0x15
  jmp alltraps
80106c99:	e9 00 f9 ff ff       	jmp    8010659e <alltraps>

80106c9e <vector22>:
.globl vector22
vector22:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $22
80106ca0:	6a 16                	push   $0x16
  jmp alltraps
80106ca2:	e9 f7 f8 ff ff       	jmp    8010659e <alltraps>

80106ca7 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $23
80106ca9:	6a 17                	push   $0x17
  jmp alltraps
80106cab:	e9 ee f8 ff ff       	jmp    8010659e <alltraps>

80106cb0 <vector24>:
.globl vector24
vector24:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $24
80106cb2:	6a 18                	push   $0x18
  jmp alltraps
80106cb4:	e9 e5 f8 ff ff       	jmp    8010659e <alltraps>

80106cb9 <vector25>:
.globl vector25
vector25:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $25
80106cbb:	6a 19                	push   $0x19
  jmp alltraps
80106cbd:	e9 dc f8 ff ff       	jmp    8010659e <alltraps>

80106cc2 <vector26>:
.globl vector26
vector26:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $26
80106cc4:	6a 1a                	push   $0x1a
  jmp alltraps
80106cc6:	e9 d3 f8 ff ff       	jmp    8010659e <alltraps>

80106ccb <vector27>:
.globl vector27
vector27:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $27
80106ccd:	6a 1b                	push   $0x1b
  jmp alltraps
80106ccf:	e9 ca f8 ff ff       	jmp    8010659e <alltraps>

80106cd4 <vector28>:
.globl vector28
vector28:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $28
80106cd6:	6a 1c                	push   $0x1c
  jmp alltraps
80106cd8:	e9 c1 f8 ff ff       	jmp    8010659e <alltraps>

80106cdd <vector29>:
.globl vector29
vector29:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $29
80106cdf:	6a 1d                	push   $0x1d
  jmp alltraps
80106ce1:	e9 b8 f8 ff ff       	jmp    8010659e <alltraps>

80106ce6 <vector30>:
.globl vector30
vector30:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $30
80106ce8:	6a 1e                	push   $0x1e
  jmp alltraps
80106cea:	e9 af f8 ff ff       	jmp    8010659e <alltraps>

80106cef <vector31>:
.globl vector31
vector31:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $31
80106cf1:	6a 1f                	push   $0x1f
  jmp alltraps
80106cf3:	e9 a6 f8 ff ff       	jmp    8010659e <alltraps>

80106cf8 <vector32>:
.globl vector32
vector32:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $32
80106cfa:	6a 20                	push   $0x20
  jmp alltraps
80106cfc:	e9 9d f8 ff ff       	jmp    8010659e <alltraps>

80106d01 <vector33>:
.globl vector33
vector33:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $33
80106d03:	6a 21                	push   $0x21
  jmp alltraps
80106d05:	e9 94 f8 ff ff       	jmp    8010659e <alltraps>

80106d0a <vector34>:
.globl vector34
vector34:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $34
80106d0c:	6a 22                	push   $0x22
  jmp alltraps
80106d0e:	e9 8b f8 ff ff       	jmp    8010659e <alltraps>

80106d13 <vector35>:
.globl vector35
vector35:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $35
80106d15:	6a 23                	push   $0x23
  jmp alltraps
80106d17:	e9 82 f8 ff ff       	jmp    8010659e <alltraps>

80106d1c <vector36>:
.globl vector36
vector36:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $36
80106d1e:	6a 24                	push   $0x24
  jmp alltraps
80106d20:	e9 79 f8 ff ff       	jmp    8010659e <alltraps>

80106d25 <vector37>:
.globl vector37
vector37:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $37
80106d27:	6a 25                	push   $0x25
  jmp alltraps
80106d29:	e9 70 f8 ff ff       	jmp    8010659e <alltraps>

80106d2e <vector38>:
.globl vector38
vector38:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $38
80106d30:	6a 26                	push   $0x26
  jmp alltraps
80106d32:	e9 67 f8 ff ff       	jmp    8010659e <alltraps>

80106d37 <vector39>:
.globl vector39
vector39:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $39
80106d39:	6a 27                	push   $0x27
  jmp alltraps
80106d3b:	e9 5e f8 ff ff       	jmp    8010659e <alltraps>

80106d40 <vector40>:
.globl vector40
vector40:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $40
80106d42:	6a 28                	push   $0x28
  jmp alltraps
80106d44:	e9 55 f8 ff ff       	jmp    8010659e <alltraps>

80106d49 <vector41>:
.globl vector41
vector41:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $41
80106d4b:	6a 29                	push   $0x29
  jmp alltraps
80106d4d:	e9 4c f8 ff ff       	jmp    8010659e <alltraps>

80106d52 <vector42>:
.globl vector42
vector42:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $42
80106d54:	6a 2a                	push   $0x2a
  jmp alltraps
80106d56:	e9 43 f8 ff ff       	jmp    8010659e <alltraps>

80106d5b <vector43>:
.globl vector43
vector43:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $43
80106d5d:	6a 2b                	push   $0x2b
  jmp alltraps
80106d5f:	e9 3a f8 ff ff       	jmp    8010659e <alltraps>

80106d64 <vector44>:
.globl vector44
vector44:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $44
80106d66:	6a 2c                	push   $0x2c
  jmp alltraps
80106d68:	e9 31 f8 ff ff       	jmp    8010659e <alltraps>

80106d6d <vector45>:
.globl vector45
vector45:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $45
80106d6f:	6a 2d                	push   $0x2d
  jmp alltraps
80106d71:	e9 28 f8 ff ff       	jmp    8010659e <alltraps>

80106d76 <vector46>:
.globl vector46
vector46:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $46
80106d78:	6a 2e                	push   $0x2e
  jmp alltraps
80106d7a:	e9 1f f8 ff ff       	jmp    8010659e <alltraps>

80106d7f <vector47>:
.globl vector47
vector47:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $47
80106d81:	6a 2f                	push   $0x2f
  jmp alltraps
80106d83:	e9 16 f8 ff ff       	jmp    8010659e <alltraps>

80106d88 <vector48>:
.globl vector48
vector48:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $48
80106d8a:	6a 30                	push   $0x30
  jmp alltraps
80106d8c:	e9 0d f8 ff ff       	jmp    8010659e <alltraps>

80106d91 <vector49>:
.globl vector49
vector49:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $49
80106d93:	6a 31                	push   $0x31
  jmp alltraps
80106d95:	e9 04 f8 ff ff       	jmp    8010659e <alltraps>

80106d9a <vector50>:
.globl vector50
vector50:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $50
80106d9c:	6a 32                	push   $0x32
  jmp alltraps
80106d9e:	e9 fb f7 ff ff       	jmp    8010659e <alltraps>

80106da3 <vector51>:
.globl vector51
vector51:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $51
80106da5:	6a 33                	push   $0x33
  jmp alltraps
80106da7:	e9 f2 f7 ff ff       	jmp    8010659e <alltraps>

80106dac <vector52>:
.globl vector52
vector52:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $52
80106dae:	6a 34                	push   $0x34
  jmp alltraps
80106db0:	e9 e9 f7 ff ff       	jmp    8010659e <alltraps>

80106db5 <vector53>:
.globl vector53
vector53:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $53
80106db7:	6a 35                	push   $0x35
  jmp alltraps
80106db9:	e9 e0 f7 ff ff       	jmp    8010659e <alltraps>

80106dbe <vector54>:
.globl vector54
vector54:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $54
80106dc0:	6a 36                	push   $0x36
  jmp alltraps
80106dc2:	e9 d7 f7 ff ff       	jmp    8010659e <alltraps>

80106dc7 <vector55>:
.globl vector55
vector55:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $55
80106dc9:	6a 37                	push   $0x37
  jmp alltraps
80106dcb:	e9 ce f7 ff ff       	jmp    8010659e <alltraps>

80106dd0 <vector56>:
.globl vector56
vector56:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $56
80106dd2:	6a 38                	push   $0x38
  jmp alltraps
80106dd4:	e9 c5 f7 ff ff       	jmp    8010659e <alltraps>

80106dd9 <vector57>:
.globl vector57
vector57:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $57
80106ddb:	6a 39                	push   $0x39
  jmp alltraps
80106ddd:	e9 bc f7 ff ff       	jmp    8010659e <alltraps>

80106de2 <vector58>:
.globl vector58
vector58:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $58
80106de4:	6a 3a                	push   $0x3a
  jmp alltraps
80106de6:	e9 b3 f7 ff ff       	jmp    8010659e <alltraps>

80106deb <vector59>:
.globl vector59
vector59:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $59
80106ded:	6a 3b                	push   $0x3b
  jmp alltraps
80106def:	e9 aa f7 ff ff       	jmp    8010659e <alltraps>

80106df4 <vector60>:
.globl vector60
vector60:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $60
80106df6:	6a 3c                	push   $0x3c
  jmp alltraps
80106df8:	e9 a1 f7 ff ff       	jmp    8010659e <alltraps>

80106dfd <vector61>:
.globl vector61
vector61:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $61
80106dff:	6a 3d                	push   $0x3d
  jmp alltraps
80106e01:	e9 98 f7 ff ff       	jmp    8010659e <alltraps>

80106e06 <vector62>:
.globl vector62
vector62:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $62
80106e08:	6a 3e                	push   $0x3e
  jmp alltraps
80106e0a:	e9 8f f7 ff ff       	jmp    8010659e <alltraps>

80106e0f <vector63>:
.globl vector63
vector63:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $63
80106e11:	6a 3f                	push   $0x3f
  jmp alltraps
80106e13:	e9 86 f7 ff ff       	jmp    8010659e <alltraps>

80106e18 <vector64>:
.globl vector64
vector64:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $64
80106e1a:	6a 40                	push   $0x40
  jmp alltraps
80106e1c:	e9 7d f7 ff ff       	jmp    8010659e <alltraps>

80106e21 <vector65>:
.globl vector65
vector65:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $65
80106e23:	6a 41                	push   $0x41
  jmp alltraps
80106e25:	e9 74 f7 ff ff       	jmp    8010659e <alltraps>

80106e2a <vector66>:
.globl vector66
vector66:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $66
80106e2c:	6a 42                	push   $0x42
  jmp alltraps
80106e2e:	e9 6b f7 ff ff       	jmp    8010659e <alltraps>

80106e33 <vector67>:
.globl vector67
vector67:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $67
80106e35:	6a 43                	push   $0x43
  jmp alltraps
80106e37:	e9 62 f7 ff ff       	jmp    8010659e <alltraps>

80106e3c <vector68>:
.globl vector68
vector68:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $68
80106e3e:	6a 44                	push   $0x44
  jmp alltraps
80106e40:	e9 59 f7 ff ff       	jmp    8010659e <alltraps>

80106e45 <vector69>:
.globl vector69
vector69:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $69
80106e47:	6a 45                	push   $0x45
  jmp alltraps
80106e49:	e9 50 f7 ff ff       	jmp    8010659e <alltraps>

80106e4e <vector70>:
.globl vector70
vector70:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $70
80106e50:	6a 46                	push   $0x46
  jmp alltraps
80106e52:	e9 47 f7 ff ff       	jmp    8010659e <alltraps>

80106e57 <vector71>:
.globl vector71
vector71:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $71
80106e59:	6a 47                	push   $0x47
  jmp alltraps
80106e5b:	e9 3e f7 ff ff       	jmp    8010659e <alltraps>

80106e60 <vector72>:
.globl vector72
vector72:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $72
80106e62:	6a 48                	push   $0x48
  jmp alltraps
80106e64:	e9 35 f7 ff ff       	jmp    8010659e <alltraps>

80106e69 <vector73>:
.globl vector73
vector73:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $73
80106e6b:	6a 49                	push   $0x49
  jmp alltraps
80106e6d:	e9 2c f7 ff ff       	jmp    8010659e <alltraps>

80106e72 <vector74>:
.globl vector74
vector74:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $74
80106e74:	6a 4a                	push   $0x4a
  jmp alltraps
80106e76:	e9 23 f7 ff ff       	jmp    8010659e <alltraps>

80106e7b <vector75>:
.globl vector75
vector75:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $75
80106e7d:	6a 4b                	push   $0x4b
  jmp alltraps
80106e7f:	e9 1a f7 ff ff       	jmp    8010659e <alltraps>

80106e84 <vector76>:
.globl vector76
vector76:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $76
80106e86:	6a 4c                	push   $0x4c
  jmp alltraps
80106e88:	e9 11 f7 ff ff       	jmp    8010659e <alltraps>

80106e8d <vector77>:
.globl vector77
vector77:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $77
80106e8f:	6a 4d                	push   $0x4d
  jmp alltraps
80106e91:	e9 08 f7 ff ff       	jmp    8010659e <alltraps>

80106e96 <vector78>:
.globl vector78
vector78:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $78
80106e98:	6a 4e                	push   $0x4e
  jmp alltraps
80106e9a:	e9 ff f6 ff ff       	jmp    8010659e <alltraps>

80106e9f <vector79>:
.globl vector79
vector79:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $79
80106ea1:	6a 4f                	push   $0x4f
  jmp alltraps
80106ea3:	e9 f6 f6 ff ff       	jmp    8010659e <alltraps>

80106ea8 <vector80>:
.globl vector80
vector80:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $80
80106eaa:	6a 50                	push   $0x50
  jmp alltraps
80106eac:	e9 ed f6 ff ff       	jmp    8010659e <alltraps>

80106eb1 <vector81>:
.globl vector81
vector81:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $81
80106eb3:	6a 51                	push   $0x51
  jmp alltraps
80106eb5:	e9 e4 f6 ff ff       	jmp    8010659e <alltraps>

80106eba <vector82>:
.globl vector82
vector82:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $82
80106ebc:	6a 52                	push   $0x52
  jmp alltraps
80106ebe:	e9 db f6 ff ff       	jmp    8010659e <alltraps>

80106ec3 <vector83>:
.globl vector83
vector83:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $83
80106ec5:	6a 53                	push   $0x53
  jmp alltraps
80106ec7:	e9 d2 f6 ff ff       	jmp    8010659e <alltraps>

80106ecc <vector84>:
.globl vector84
vector84:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $84
80106ece:	6a 54                	push   $0x54
  jmp alltraps
80106ed0:	e9 c9 f6 ff ff       	jmp    8010659e <alltraps>

80106ed5 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $85
80106ed7:	6a 55                	push   $0x55
  jmp alltraps
80106ed9:	e9 c0 f6 ff ff       	jmp    8010659e <alltraps>

80106ede <vector86>:
.globl vector86
vector86:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $86
80106ee0:	6a 56                	push   $0x56
  jmp alltraps
80106ee2:	e9 b7 f6 ff ff       	jmp    8010659e <alltraps>

80106ee7 <vector87>:
.globl vector87
vector87:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $87
80106ee9:	6a 57                	push   $0x57
  jmp alltraps
80106eeb:	e9 ae f6 ff ff       	jmp    8010659e <alltraps>

80106ef0 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $88
80106ef2:	6a 58                	push   $0x58
  jmp alltraps
80106ef4:	e9 a5 f6 ff ff       	jmp    8010659e <alltraps>

80106ef9 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $89
80106efb:	6a 59                	push   $0x59
  jmp alltraps
80106efd:	e9 9c f6 ff ff       	jmp    8010659e <alltraps>

80106f02 <vector90>:
.globl vector90
vector90:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $90
80106f04:	6a 5a                	push   $0x5a
  jmp alltraps
80106f06:	e9 93 f6 ff ff       	jmp    8010659e <alltraps>

80106f0b <vector91>:
.globl vector91
vector91:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $91
80106f0d:	6a 5b                	push   $0x5b
  jmp alltraps
80106f0f:	e9 8a f6 ff ff       	jmp    8010659e <alltraps>

80106f14 <vector92>:
.globl vector92
vector92:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $92
80106f16:	6a 5c                	push   $0x5c
  jmp alltraps
80106f18:	e9 81 f6 ff ff       	jmp    8010659e <alltraps>

80106f1d <vector93>:
.globl vector93
vector93:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $93
80106f1f:	6a 5d                	push   $0x5d
  jmp alltraps
80106f21:	e9 78 f6 ff ff       	jmp    8010659e <alltraps>

80106f26 <vector94>:
.globl vector94
vector94:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $94
80106f28:	6a 5e                	push   $0x5e
  jmp alltraps
80106f2a:	e9 6f f6 ff ff       	jmp    8010659e <alltraps>

80106f2f <vector95>:
.globl vector95
vector95:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $95
80106f31:	6a 5f                	push   $0x5f
  jmp alltraps
80106f33:	e9 66 f6 ff ff       	jmp    8010659e <alltraps>

80106f38 <vector96>:
.globl vector96
vector96:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $96
80106f3a:	6a 60                	push   $0x60
  jmp alltraps
80106f3c:	e9 5d f6 ff ff       	jmp    8010659e <alltraps>

80106f41 <vector97>:
.globl vector97
vector97:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $97
80106f43:	6a 61                	push   $0x61
  jmp alltraps
80106f45:	e9 54 f6 ff ff       	jmp    8010659e <alltraps>

80106f4a <vector98>:
.globl vector98
vector98:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $98
80106f4c:	6a 62                	push   $0x62
  jmp alltraps
80106f4e:	e9 4b f6 ff ff       	jmp    8010659e <alltraps>

80106f53 <vector99>:
.globl vector99
vector99:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $99
80106f55:	6a 63                	push   $0x63
  jmp alltraps
80106f57:	e9 42 f6 ff ff       	jmp    8010659e <alltraps>

80106f5c <vector100>:
.globl vector100
vector100:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $100
80106f5e:	6a 64                	push   $0x64
  jmp alltraps
80106f60:	e9 39 f6 ff ff       	jmp    8010659e <alltraps>

80106f65 <vector101>:
.globl vector101
vector101:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $101
80106f67:	6a 65                	push   $0x65
  jmp alltraps
80106f69:	e9 30 f6 ff ff       	jmp    8010659e <alltraps>

80106f6e <vector102>:
.globl vector102
vector102:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $102
80106f70:	6a 66                	push   $0x66
  jmp alltraps
80106f72:	e9 27 f6 ff ff       	jmp    8010659e <alltraps>

80106f77 <vector103>:
.globl vector103
vector103:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $103
80106f79:	6a 67                	push   $0x67
  jmp alltraps
80106f7b:	e9 1e f6 ff ff       	jmp    8010659e <alltraps>

80106f80 <vector104>:
.globl vector104
vector104:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $104
80106f82:	6a 68                	push   $0x68
  jmp alltraps
80106f84:	e9 15 f6 ff ff       	jmp    8010659e <alltraps>

80106f89 <vector105>:
.globl vector105
vector105:
  pushl $0
80106f89:	6a 00                	push   $0x0
  pushl $105
80106f8b:	6a 69                	push   $0x69
  jmp alltraps
80106f8d:	e9 0c f6 ff ff       	jmp    8010659e <alltraps>

80106f92 <vector106>:
.globl vector106
vector106:
  pushl $0
80106f92:	6a 00                	push   $0x0
  pushl $106
80106f94:	6a 6a                	push   $0x6a
  jmp alltraps
80106f96:	e9 03 f6 ff ff       	jmp    8010659e <alltraps>

80106f9b <vector107>:
.globl vector107
vector107:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $107
80106f9d:	6a 6b                	push   $0x6b
  jmp alltraps
80106f9f:	e9 fa f5 ff ff       	jmp    8010659e <alltraps>

80106fa4 <vector108>:
.globl vector108
vector108:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $108
80106fa6:	6a 6c                	push   $0x6c
  jmp alltraps
80106fa8:	e9 f1 f5 ff ff       	jmp    8010659e <alltraps>

80106fad <vector109>:
.globl vector109
vector109:
  pushl $0
80106fad:	6a 00                	push   $0x0
  pushl $109
80106faf:	6a 6d                	push   $0x6d
  jmp alltraps
80106fb1:	e9 e8 f5 ff ff       	jmp    8010659e <alltraps>

80106fb6 <vector110>:
.globl vector110
vector110:
  pushl $0
80106fb6:	6a 00                	push   $0x0
  pushl $110
80106fb8:	6a 6e                	push   $0x6e
  jmp alltraps
80106fba:	e9 df f5 ff ff       	jmp    8010659e <alltraps>

80106fbf <vector111>:
.globl vector111
vector111:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $111
80106fc1:	6a 6f                	push   $0x6f
  jmp alltraps
80106fc3:	e9 d6 f5 ff ff       	jmp    8010659e <alltraps>

80106fc8 <vector112>:
.globl vector112
vector112:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $112
80106fca:	6a 70                	push   $0x70
  jmp alltraps
80106fcc:	e9 cd f5 ff ff       	jmp    8010659e <alltraps>

80106fd1 <vector113>:
.globl vector113
vector113:
  pushl $0
80106fd1:	6a 00                	push   $0x0
  pushl $113
80106fd3:	6a 71                	push   $0x71
  jmp alltraps
80106fd5:	e9 c4 f5 ff ff       	jmp    8010659e <alltraps>

80106fda <vector114>:
.globl vector114
vector114:
  pushl $0
80106fda:	6a 00                	push   $0x0
  pushl $114
80106fdc:	6a 72                	push   $0x72
  jmp alltraps
80106fde:	e9 bb f5 ff ff       	jmp    8010659e <alltraps>

80106fe3 <vector115>:
.globl vector115
vector115:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $115
80106fe5:	6a 73                	push   $0x73
  jmp alltraps
80106fe7:	e9 b2 f5 ff ff       	jmp    8010659e <alltraps>

80106fec <vector116>:
.globl vector116
vector116:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $116
80106fee:	6a 74                	push   $0x74
  jmp alltraps
80106ff0:	e9 a9 f5 ff ff       	jmp    8010659e <alltraps>

80106ff5 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ff5:	6a 00                	push   $0x0
  pushl $117
80106ff7:	6a 75                	push   $0x75
  jmp alltraps
80106ff9:	e9 a0 f5 ff ff       	jmp    8010659e <alltraps>

80106ffe <vector118>:
.globl vector118
vector118:
  pushl $0
80106ffe:	6a 00                	push   $0x0
  pushl $118
80107000:	6a 76                	push   $0x76
  jmp alltraps
80107002:	e9 97 f5 ff ff       	jmp    8010659e <alltraps>

80107007 <vector119>:
.globl vector119
vector119:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $119
80107009:	6a 77                	push   $0x77
  jmp alltraps
8010700b:	e9 8e f5 ff ff       	jmp    8010659e <alltraps>

80107010 <vector120>:
.globl vector120
vector120:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $120
80107012:	6a 78                	push   $0x78
  jmp alltraps
80107014:	e9 85 f5 ff ff       	jmp    8010659e <alltraps>

80107019 <vector121>:
.globl vector121
vector121:
  pushl $0
80107019:	6a 00                	push   $0x0
  pushl $121
8010701b:	6a 79                	push   $0x79
  jmp alltraps
8010701d:	e9 7c f5 ff ff       	jmp    8010659e <alltraps>

80107022 <vector122>:
.globl vector122
vector122:
  pushl $0
80107022:	6a 00                	push   $0x0
  pushl $122
80107024:	6a 7a                	push   $0x7a
  jmp alltraps
80107026:	e9 73 f5 ff ff       	jmp    8010659e <alltraps>

8010702b <vector123>:
.globl vector123
vector123:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $123
8010702d:	6a 7b                	push   $0x7b
  jmp alltraps
8010702f:	e9 6a f5 ff ff       	jmp    8010659e <alltraps>

80107034 <vector124>:
.globl vector124
vector124:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $124
80107036:	6a 7c                	push   $0x7c
  jmp alltraps
80107038:	e9 61 f5 ff ff       	jmp    8010659e <alltraps>

8010703d <vector125>:
.globl vector125
vector125:
  pushl $0
8010703d:	6a 00                	push   $0x0
  pushl $125
8010703f:	6a 7d                	push   $0x7d
  jmp alltraps
80107041:	e9 58 f5 ff ff       	jmp    8010659e <alltraps>

80107046 <vector126>:
.globl vector126
vector126:
  pushl $0
80107046:	6a 00                	push   $0x0
  pushl $126
80107048:	6a 7e                	push   $0x7e
  jmp alltraps
8010704a:	e9 4f f5 ff ff       	jmp    8010659e <alltraps>

8010704f <vector127>:
.globl vector127
vector127:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $127
80107051:	6a 7f                	push   $0x7f
  jmp alltraps
80107053:	e9 46 f5 ff ff       	jmp    8010659e <alltraps>

80107058 <vector128>:
.globl vector128
vector128:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $128
8010705a:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010705f:	e9 3a f5 ff ff       	jmp    8010659e <alltraps>

80107064 <vector129>:
.globl vector129
vector129:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $129
80107066:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010706b:	e9 2e f5 ff ff       	jmp    8010659e <alltraps>

80107070 <vector130>:
.globl vector130
vector130:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $130
80107072:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107077:	e9 22 f5 ff ff       	jmp    8010659e <alltraps>

8010707c <vector131>:
.globl vector131
vector131:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $131
8010707e:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107083:	e9 16 f5 ff ff       	jmp    8010659e <alltraps>

80107088 <vector132>:
.globl vector132
vector132:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $132
8010708a:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010708f:	e9 0a f5 ff ff       	jmp    8010659e <alltraps>

80107094 <vector133>:
.globl vector133
vector133:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $133
80107096:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010709b:	e9 fe f4 ff ff       	jmp    8010659e <alltraps>

801070a0 <vector134>:
.globl vector134
vector134:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $134
801070a2:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801070a7:	e9 f2 f4 ff ff       	jmp    8010659e <alltraps>

801070ac <vector135>:
.globl vector135
vector135:
  pushl $0
801070ac:	6a 00                	push   $0x0
  pushl $135
801070ae:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801070b3:	e9 e6 f4 ff ff       	jmp    8010659e <alltraps>

801070b8 <vector136>:
.globl vector136
vector136:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $136
801070ba:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801070bf:	e9 da f4 ff ff       	jmp    8010659e <alltraps>

801070c4 <vector137>:
.globl vector137
vector137:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $137
801070c6:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801070cb:	e9 ce f4 ff ff       	jmp    8010659e <alltraps>

801070d0 <vector138>:
.globl vector138
vector138:
  pushl $0
801070d0:	6a 00                	push   $0x0
  pushl $138
801070d2:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801070d7:	e9 c2 f4 ff ff       	jmp    8010659e <alltraps>

801070dc <vector139>:
.globl vector139
vector139:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $139
801070de:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801070e3:	e9 b6 f4 ff ff       	jmp    8010659e <alltraps>

801070e8 <vector140>:
.globl vector140
vector140:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $140
801070ea:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801070ef:	e9 aa f4 ff ff       	jmp    8010659e <alltraps>

801070f4 <vector141>:
.globl vector141
vector141:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $141
801070f6:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801070fb:	e9 9e f4 ff ff       	jmp    8010659e <alltraps>

80107100 <vector142>:
.globl vector142
vector142:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $142
80107102:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107107:	e9 92 f4 ff ff       	jmp    8010659e <alltraps>

8010710c <vector143>:
.globl vector143
vector143:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $143
8010710e:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107113:	e9 86 f4 ff ff       	jmp    8010659e <alltraps>

80107118 <vector144>:
.globl vector144
vector144:
  pushl $0
80107118:	6a 00                	push   $0x0
  pushl $144
8010711a:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010711f:	e9 7a f4 ff ff       	jmp    8010659e <alltraps>

80107124 <vector145>:
.globl vector145
vector145:
  pushl $0
80107124:	6a 00                	push   $0x0
  pushl $145
80107126:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010712b:	e9 6e f4 ff ff       	jmp    8010659e <alltraps>

80107130 <vector146>:
.globl vector146
vector146:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $146
80107132:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107137:	e9 62 f4 ff ff       	jmp    8010659e <alltraps>

8010713c <vector147>:
.globl vector147
vector147:
  pushl $0
8010713c:	6a 00                	push   $0x0
  pushl $147
8010713e:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107143:	e9 56 f4 ff ff       	jmp    8010659e <alltraps>

80107148 <vector148>:
.globl vector148
vector148:
  pushl $0
80107148:	6a 00                	push   $0x0
  pushl $148
8010714a:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010714f:	e9 4a f4 ff ff       	jmp    8010659e <alltraps>

80107154 <vector149>:
.globl vector149
vector149:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $149
80107156:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010715b:	e9 3e f4 ff ff       	jmp    8010659e <alltraps>

80107160 <vector150>:
.globl vector150
vector150:
  pushl $0
80107160:	6a 00                	push   $0x0
  pushl $150
80107162:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107167:	e9 32 f4 ff ff       	jmp    8010659e <alltraps>

8010716c <vector151>:
.globl vector151
vector151:
  pushl $0
8010716c:	6a 00                	push   $0x0
  pushl $151
8010716e:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107173:	e9 26 f4 ff ff       	jmp    8010659e <alltraps>

80107178 <vector152>:
.globl vector152
vector152:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $152
8010717a:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010717f:	e9 1a f4 ff ff       	jmp    8010659e <alltraps>

80107184 <vector153>:
.globl vector153
vector153:
  pushl $0
80107184:	6a 00                	push   $0x0
  pushl $153
80107186:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010718b:	e9 0e f4 ff ff       	jmp    8010659e <alltraps>

80107190 <vector154>:
.globl vector154
vector154:
  pushl $0
80107190:	6a 00                	push   $0x0
  pushl $154
80107192:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107197:	e9 02 f4 ff ff       	jmp    8010659e <alltraps>

8010719c <vector155>:
.globl vector155
vector155:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $155
8010719e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801071a3:	e9 f6 f3 ff ff       	jmp    8010659e <alltraps>

801071a8 <vector156>:
.globl vector156
vector156:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $156
801071aa:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801071af:	e9 ea f3 ff ff       	jmp    8010659e <alltraps>

801071b4 <vector157>:
.globl vector157
vector157:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $157
801071b6:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801071bb:	e9 de f3 ff ff       	jmp    8010659e <alltraps>

801071c0 <vector158>:
.globl vector158
vector158:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $158
801071c2:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801071c7:	e9 d2 f3 ff ff       	jmp    8010659e <alltraps>

801071cc <vector159>:
.globl vector159
vector159:
  pushl $0
801071cc:	6a 00                	push   $0x0
  pushl $159
801071ce:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801071d3:	e9 c6 f3 ff ff       	jmp    8010659e <alltraps>

801071d8 <vector160>:
.globl vector160
vector160:
  pushl $0
801071d8:	6a 00                	push   $0x0
  pushl $160
801071da:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801071df:	e9 ba f3 ff ff       	jmp    8010659e <alltraps>

801071e4 <vector161>:
.globl vector161
vector161:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $161
801071e6:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801071eb:	e9 ae f3 ff ff       	jmp    8010659e <alltraps>

801071f0 <vector162>:
.globl vector162
vector162:
  pushl $0
801071f0:	6a 00                	push   $0x0
  pushl $162
801071f2:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801071f7:	e9 a2 f3 ff ff       	jmp    8010659e <alltraps>

801071fc <vector163>:
.globl vector163
vector163:
  pushl $0
801071fc:	6a 00                	push   $0x0
  pushl $163
801071fe:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107203:	e9 96 f3 ff ff       	jmp    8010659e <alltraps>

80107208 <vector164>:
.globl vector164
vector164:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $164
8010720a:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010720f:	e9 8a f3 ff ff       	jmp    8010659e <alltraps>

80107214 <vector165>:
.globl vector165
vector165:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $165
80107216:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010721b:	e9 7e f3 ff ff       	jmp    8010659e <alltraps>

80107220 <vector166>:
.globl vector166
vector166:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $166
80107222:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107227:	e9 72 f3 ff ff       	jmp    8010659e <alltraps>

8010722c <vector167>:
.globl vector167
vector167:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $167
8010722e:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107233:	e9 66 f3 ff ff       	jmp    8010659e <alltraps>

80107238 <vector168>:
.globl vector168
vector168:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $168
8010723a:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010723f:	e9 5a f3 ff ff       	jmp    8010659e <alltraps>

80107244 <vector169>:
.globl vector169
vector169:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $169
80107246:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010724b:	e9 4e f3 ff ff       	jmp    8010659e <alltraps>

80107250 <vector170>:
.globl vector170
vector170:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $170
80107252:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107257:	e9 42 f3 ff ff       	jmp    8010659e <alltraps>

8010725c <vector171>:
.globl vector171
vector171:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $171
8010725e:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107263:	e9 36 f3 ff ff       	jmp    8010659e <alltraps>

80107268 <vector172>:
.globl vector172
vector172:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $172
8010726a:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010726f:	e9 2a f3 ff ff       	jmp    8010659e <alltraps>

80107274 <vector173>:
.globl vector173
vector173:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $173
80107276:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010727b:	e9 1e f3 ff ff       	jmp    8010659e <alltraps>

80107280 <vector174>:
.globl vector174
vector174:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $174
80107282:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107287:	e9 12 f3 ff ff       	jmp    8010659e <alltraps>

8010728c <vector175>:
.globl vector175
vector175:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $175
8010728e:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107293:	e9 06 f3 ff ff       	jmp    8010659e <alltraps>

80107298 <vector176>:
.globl vector176
vector176:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $176
8010729a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010729f:	e9 fa f2 ff ff       	jmp    8010659e <alltraps>

801072a4 <vector177>:
.globl vector177
vector177:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $177
801072a6:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801072ab:	e9 ee f2 ff ff       	jmp    8010659e <alltraps>

801072b0 <vector178>:
.globl vector178
vector178:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $178
801072b2:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801072b7:	e9 e2 f2 ff ff       	jmp    8010659e <alltraps>

801072bc <vector179>:
.globl vector179
vector179:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $179
801072be:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801072c3:	e9 d6 f2 ff ff       	jmp    8010659e <alltraps>

801072c8 <vector180>:
.globl vector180
vector180:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $180
801072ca:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801072cf:	e9 ca f2 ff ff       	jmp    8010659e <alltraps>

801072d4 <vector181>:
.globl vector181
vector181:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $181
801072d6:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801072db:	e9 be f2 ff ff       	jmp    8010659e <alltraps>

801072e0 <vector182>:
.globl vector182
vector182:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $182
801072e2:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801072e7:	e9 b2 f2 ff ff       	jmp    8010659e <alltraps>

801072ec <vector183>:
.globl vector183
vector183:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $183
801072ee:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801072f3:	e9 a6 f2 ff ff       	jmp    8010659e <alltraps>

801072f8 <vector184>:
.globl vector184
vector184:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $184
801072fa:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801072ff:	e9 9a f2 ff ff       	jmp    8010659e <alltraps>

80107304 <vector185>:
.globl vector185
vector185:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $185
80107306:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010730b:	e9 8e f2 ff ff       	jmp    8010659e <alltraps>

80107310 <vector186>:
.globl vector186
vector186:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $186
80107312:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107317:	e9 82 f2 ff ff       	jmp    8010659e <alltraps>

8010731c <vector187>:
.globl vector187
vector187:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $187
8010731e:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107323:	e9 76 f2 ff ff       	jmp    8010659e <alltraps>

80107328 <vector188>:
.globl vector188
vector188:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $188
8010732a:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010732f:	e9 6a f2 ff ff       	jmp    8010659e <alltraps>

80107334 <vector189>:
.globl vector189
vector189:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $189
80107336:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010733b:	e9 5e f2 ff ff       	jmp    8010659e <alltraps>

80107340 <vector190>:
.globl vector190
vector190:
  pushl $0
80107340:	6a 00                	push   $0x0
  pushl $190
80107342:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107347:	e9 52 f2 ff ff       	jmp    8010659e <alltraps>

8010734c <vector191>:
.globl vector191
vector191:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $191
8010734e:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107353:	e9 46 f2 ff ff       	jmp    8010659e <alltraps>

80107358 <vector192>:
.globl vector192
vector192:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $192
8010735a:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010735f:	e9 3a f2 ff ff       	jmp    8010659e <alltraps>

80107364 <vector193>:
.globl vector193
vector193:
  pushl $0
80107364:	6a 00                	push   $0x0
  pushl $193
80107366:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010736b:	e9 2e f2 ff ff       	jmp    8010659e <alltraps>

80107370 <vector194>:
.globl vector194
vector194:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $194
80107372:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107377:	e9 22 f2 ff ff       	jmp    8010659e <alltraps>

8010737c <vector195>:
.globl vector195
vector195:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $195
8010737e:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107383:	e9 16 f2 ff ff       	jmp    8010659e <alltraps>

80107388 <vector196>:
.globl vector196
vector196:
  pushl $0
80107388:	6a 00                	push   $0x0
  pushl $196
8010738a:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010738f:	e9 0a f2 ff ff       	jmp    8010659e <alltraps>

80107394 <vector197>:
.globl vector197
vector197:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $197
80107396:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010739b:	e9 fe f1 ff ff       	jmp    8010659e <alltraps>

801073a0 <vector198>:
.globl vector198
vector198:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $198
801073a2:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801073a7:	e9 f2 f1 ff ff       	jmp    8010659e <alltraps>

801073ac <vector199>:
.globl vector199
vector199:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $199
801073ae:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801073b3:	e9 e6 f1 ff ff       	jmp    8010659e <alltraps>

801073b8 <vector200>:
.globl vector200
vector200:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $200
801073ba:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801073bf:	e9 da f1 ff ff       	jmp    8010659e <alltraps>

801073c4 <vector201>:
.globl vector201
vector201:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $201
801073c6:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801073cb:	e9 ce f1 ff ff       	jmp    8010659e <alltraps>

801073d0 <vector202>:
.globl vector202
vector202:
  pushl $0
801073d0:	6a 00                	push   $0x0
  pushl $202
801073d2:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801073d7:	e9 c2 f1 ff ff       	jmp    8010659e <alltraps>

801073dc <vector203>:
.globl vector203
vector203:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $203
801073de:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801073e3:	e9 b6 f1 ff ff       	jmp    8010659e <alltraps>

801073e8 <vector204>:
.globl vector204
vector204:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $204
801073ea:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801073ef:	e9 aa f1 ff ff       	jmp    8010659e <alltraps>

801073f4 <vector205>:
.globl vector205
vector205:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $205
801073f6:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801073fb:	e9 9e f1 ff ff       	jmp    8010659e <alltraps>

80107400 <vector206>:
.globl vector206
vector206:
  pushl $0
80107400:	6a 00                	push   $0x0
  pushl $206
80107402:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107407:	e9 92 f1 ff ff       	jmp    8010659e <alltraps>

8010740c <vector207>:
.globl vector207
vector207:
  pushl $0
8010740c:	6a 00                	push   $0x0
  pushl $207
8010740e:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107413:	e9 86 f1 ff ff       	jmp    8010659e <alltraps>

80107418 <vector208>:
.globl vector208
vector208:
  pushl $0
80107418:	6a 00                	push   $0x0
  pushl $208
8010741a:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010741f:	e9 7a f1 ff ff       	jmp    8010659e <alltraps>

80107424 <vector209>:
.globl vector209
vector209:
  pushl $0
80107424:	6a 00                	push   $0x0
  pushl $209
80107426:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010742b:	e9 6e f1 ff ff       	jmp    8010659e <alltraps>

80107430 <vector210>:
.globl vector210
vector210:
  pushl $0
80107430:	6a 00                	push   $0x0
  pushl $210
80107432:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107437:	e9 62 f1 ff ff       	jmp    8010659e <alltraps>

8010743c <vector211>:
.globl vector211
vector211:
  pushl $0
8010743c:	6a 00                	push   $0x0
  pushl $211
8010743e:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107443:	e9 56 f1 ff ff       	jmp    8010659e <alltraps>

80107448 <vector212>:
.globl vector212
vector212:
  pushl $0
80107448:	6a 00                	push   $0x0
  pushl $212
8010744a:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010744f:	e9 4a f1 ff ff       	jmp    8010659e <alltraps>

80107454 <vector213>:
.globl vector213
vector213:
  pushl $0
80107454:	6a 00                	push   $0x0
  pushl $213
80107456:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010745b:	e9 3e f1 ff ff       	jmp    8010659e <alltraps>

80107460 <vector214>:
.globl vector214
vector214:
  pushl $0
80107460:	6a 00                	push   $0x0
  pushl $214
80107462:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107467:	e9 32 f1 ff ff       	jmp    8010659e <alltraps>

8010746c <vector215>:
.globl vector215
vector215:
  pushl $0
8010746c:	6a 00                	push   $0x0
  pushl $215
8010746e:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107473:	e9 26 f1 ff ff       	jmp    8010659e <alltraps>

80107478 <vector216>:
.globl vector216
vector216:
  pushl $0
80107478:	6a 00                	push   $0x0
  pushl $216
8010747a:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010747f:	e9 1a f1 ff ff       	jmp    8010659e <alltraps>

80107484 <vector217>:
.globl vector217
vector217:
  pushl $0
80107484:	6a 00                	push   $0x0
  pushl $217
80107486:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010748b:	e9 0e f1 ff ff       	jmp    8010659e <alltraps>

80107490 <vector218>:
.globl vector218
vector218:
  pushl $0
80107490:	6a 00                	push   $0x0
  pushl $218
80107492:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107497:	e9 02 f1 ff ff       	jmp    8010659e <alltraps>

8010749c <vector219>:
.globl vector219
vector219:
  pushl $0
8010749c:	6a 00                	push   $0x0
  pushl $219
8010749e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801074a3:	e9 f6 f0 ff ff       	jmp    8010659e <alltraps>

801074a8 <vector220>:
.globl vector220
vector220:
  pushl $0
801074a8:	6a 00                	push   $0x0
  pushl $220
801074aa:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801074af:	e9 ea f0 ff ff       	jmp    8010659e <alltraps>

801074b4 <vector221>:
.globl vector221
vector221:
  pushl $0
801074b4:	6a 00                	push   $0x0
  pushl $221
801074b6:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801074bb:	e9 de f0 ff ff       	jmp    8010659e <alltraps>

801074c0 <vector222>:
.globl vector222
vector222:
  pushl $0
801074c0:	6a 00                	push   $0x0
  pushl $222
801074c2:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801074c7:	e9 d2 f0 ff ff       	jmp    8010659e <alltraps>

801074cc <vector223>:
.globl vector223
vector223:
  pushl $0
801074cc:	6a 00                	push   $0x0
  pushl $223
801074ce:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801074d3:	e9 c6 f0 ff ff       	jmp    8010659e <alltraps>

801074d8 <vector224>:
.globl vector224
vector224:
  pushl $0
801074d8:	6a 00                	push   $0x0
  pushl $224
801074da:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801074df:	e9 ba f0 ff ff       	jmp    8010659e <alltraps>

801074e4 <vector225>:
.globl vector225
vector225:
  pushl $0
801074e4:	6a 00                	push   $0x0
  pushl $225
801074e6:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801074eb:	e9 ae f0 ff ff       	jmp    8010659e <alltraps>

801074f0 <vector226>:
.globl vector226
vector226:
  pushl $0
801074f0:	6a 00                	push   $0x0
  pushl $226
801074f2:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801074f7:	e9 a2 f0 ff ff       	jmp    8010659e <alltraps>

801074fc <vector227>:
.globl vector227
vector227:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $227
801074fe:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107503:	e9 96 f0 ff ff       	jmp    8010659e <alltraps>

80107508 <vector228>:
.globl vector228
vector228:
  pushl $0
80107508:	6a 00                	push   $0x0
  pushl $228
8010750a:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010750f:	e9 8a f0 ff ff       	jmp    8010659e <alltraps>

80107514 <vector229>:
.globl vector229
vector229:
  pushl $0
80107514:	6a 00                	push   $0x0
  pushl $229
80107516:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010751b:	e9 7e f0 ff ff       	jmp    8010659e <alltraps>

80107520 <vector230>:
.globl vector230
vector230:
  pushl $0
80107520:	6a 00                	push   $0x0
  pushl $230
80107522:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107527:	e9 72 f0 ff ff       	jmp    8010659e <alltraps>

8010752c <vector231>:
.globl vector231
vector231:
  pushl $0
8010752c:	6a 00                	push   $0x0
  pushl $231
8010752e:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107533:	e9 66 f0 ff ff       	jmp    8010659e <alltraps>

80107538 <vector232>:
.globl vector232
vector232:
  pushl $0
80107538:	6a 00                	push   $0x0
  pushl $232
8010753a:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010753f:	e9 5a f0 ff ff       	jmp    8010659e <alltraps>

80107544 <vector233>:
.globl vector233
vector233:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $233
80107546:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010754b:	e9 4e f0 ff ff       	jmp    8010659e <alltraps>

80107550 <vector234>:
.globl vector234
vector234:
  pushl $0
80107550:	6a 00                	push   $0x0
  pushl $234
80107552:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107557:	e9 42 f0 ff ff       	jmp    8010659e <alltraps>

8010755c <vector235>:
.globl vector235
vector235:
  pushl $0
8010755c:	6a 00                	push   $0x0
  pushl $235
8010755e:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107563:	e9 36 f0 ff ff       	jmp    8010659e <alltraps>

80107568 <vector236>:
.globl vector236
vector236:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $236
8010756a:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010756f:	e9 2a f0 ff ff       	jmp    8010659e <alltraps>

80107574 <vector237>:
.globl vector237
vector237:
  pushl $0
80107574:	6a 00                	push   $0x0
  pushl $237
80107576:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010757b:	e9 1e f0 ff ff       	jmp    8010659e <alltraps>

80107580 <vector238>:
.globl vector238
vector238:
  pushl $0
80107580:	6a 00                	push   $0x0
  pushl $238
80107582:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107587:	e9 12 f0 ff ff       	jmp    8010659e <alltraps>

8010758c <vector239>:
.globl vector239
vector239:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $239
8010758e:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107593:	e9 06 f0 ff ff       	jmp    8010659e <alltraps>

80107598 <vector240>:
.globl vector240
vector240:
  pushl $0
80107598:	6a 00                	push   $0x0
  pushl $240
8010759a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010759f:	e9 fa ef ff ff       	jmp    8010659e <alltraps>

801075a4 <vector241>:
.globl vector241
vector241:
  pushl $0
801075a4:	6a 00                	push   $0x0
  pushl $241
801075a6:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801075ab:	e9 ee ef ff ff       	jmp    8010659e <alltraps>

801075b0 <vector242>:
.globl vector242
vector242:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $242
801075b2:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801075b7:	e9 e2 ef ff ff       	jmp    8010659e <alltraps>

801075bc <vector243>:
.globl vector243
vector243:
  pushl $0
801075bc:	6a 00                	push   $0x0
  pushl $243
801075be:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801075c3:	e9 d6 ef ff ff       	jmp    8010659e <alltraps>

801075c8 <vector244>:
.globl vector244
vector244:
  pushl $0
801075c8:	6a 00                	push   $0x0
  pushl $244
801075ca:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801075cf:	e9 ca ef ff ff       	jmp    8010659e <alltraps>

801075d4 <vector245>:
.globl vector245
vector245:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $245
801075d6:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801075db:	e9 be ef ff ff       	jmp    8010659e <alltraps>

801075e0 <vector246>:
.globl vector246
vector246:
  pushl $0
801075e0:	6a 00                	push   $0x0
  pushl $246
801075e2:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801075e7:	e9 b2 ef ff ff       	jmp    8010659e <alltraps>

801075ec <vector247>:
.globl vector247
vector247:
  pushl $0
801075ec:	6a 00                	push   $0x0
  pushl $247
801075ee:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801075f3:	e9 a6 ef ff ff       	jmp    8010659e <alltraps>

801075f8 <vector248>:
.globl vector248
vector248:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $248
801075fa:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801075ff:	e9 9a ef ff ff       	jmp    8010659e <alltraps>

80107604 <vector249>:
.globl vector249
vector249:
  pushl $0
80107604:	6a 00                	push   $0x0
  pushl $249
80107606:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010760b:	e9 8e ef ff ff       	jmp    8010659e <alltraps>

80107610 <vector250>:
.globl vector250
vector250:
  pushl $0
80107610:	6a 00                	push   $0x0
  pushl $250
80107612:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107617:	e9 82 ef ff ff       	jmp    8010659e <alltraps>

8010761c <vector251>:
.globl vector251
vector251:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $251
8010761e:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107623:	e9 76 ef ff ff       	jmp    8010659e <alltraps>

80107628 <vector252>:
.globl vector252
vector252:
  pushl $0
80107628:	6a 00                	push   $0x0
  pushl $252
8010762a:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010762f:	e9 6a ef ff ff       	jmp    8010659e <alltraps>

80107634 <vector253>:
.globl vector253
vector253:
  pushl $0
80107634:	6a 00                	push   $0x0
  pushl $253
80107636:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010763b:	e9 5e ef ff ff       	jmp    8010659e <alltraps>

80107640 <vector254>:
.globl vector254
vector254:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $254
80107642:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107647:	e9 52 ef ff ff       	jmp    8010659e <alltraps>

8010764c <vector255>:
.globl vector255
vector255:
  pushl $0
8010764c:	6a 00                	push   $0x0
  pushl $255
8010764e:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107653:	e9 46 ef ff ff       	jmp    8010659e <alltraps>

80107658 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107658:	55                   	push   %ebp
80107659:	89 e5                	mov    %esp,%ebp
8010765b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010765e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107661:	83 e8 01             	sub    $0x1,%eax
80107664:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107668:	8b 45 08             	mov    0x8(%ebp),%eax
8010766b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010766f:	8b 45 08             	mov    0x8(%ebp),%eax
80107672:	c1 e8 10             	shr    $0x10,%eax
80107675:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107679:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010767c:	0f 01 10             	lgdtl  (%eax)
}
8010767f:	c9                   	leave  
80107680:	c3                   	ret    

80107681 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107681:	55                   	push   %ebp
80107682:	89 e5                	mov    %esp,%ebp
80107684:	83 ec 04             	sub    $0x4,%esp
80107687:	8b 45 08             	mov    0x8(%ebp),%eax
8010768a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010768e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107692:	0f 00 d8             	ltr    %ax
}
80107695:	c9                   	leave  
80107696:	c3                   	ret    

80107697 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107697:	55                   	push   %ebp
80107698:	89 e5                	mov    %esp,%ebp
8010769a:	83 ec 04             	sub    $0x4,%esp
8010769d:	8b 45 08             	mov    0x8(%ebp),%eax
801076a0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801076a4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801076a8:	8e e8                	mov    %eax,%gs
}
801076aa:	c9                   	leave  
801076ab:	c3                   	ret    

801076ac <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801076ac:	55                   	push   %ebp
801076ad:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801076af:	8b 45 08             	mov    0x8(%ebp),%eax
801076b2:	0f 22 d8             	mov    %eax,%cr3
}
801076b5:	5d                   	pop    %ebp
801076b6:	c3                   	ret    

801076b7 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801076b7:	55                   	push   %ebp
801076b8:	89 e5                	mov    %esp,%ebp
801076ba:	8b 45 08             	mov    0x8(%ebp),%eax
801076bd:	05 00 00 00 80       	add    $0x80000000,%eax
801076c2:	5d                   	pop    %ebp
801076c3:	c3                   	ret    

801076c4 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801076c4:	55                   	push   %ebp
801076c5:	89 e5                	mov    %esp,%ebp
801076c7:	8b 45 08             	mov    0x8(%ebp),%eax
801076ca:	05 00 00 00 80       	add    $0x80000000,%eax
801076cf:	5d                   	pop    %ebp
801076d0:	c3                   	ret    

801076d1 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801076d1:	55                   	push   %ebp
801076d2:	89 e5                	mov    %esp,%ebp
801076d4:	53                   	push   %ebx
801076d5:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801076d8:	e8 98 b8 ff ff       	call   80102f75 <cpunum>
801076dd:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801076e3:	05 80 24 11 80       	add    $0x80112480,%eax
801076e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ee:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801076f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f7:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801076fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107700:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107707:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010770b:	83 e2 f0             	and    $0xfffffff0,%edx
8010770e:	83 ca 0a             	or     $0xa,%edx
80107711:	88 50 7d             	mov    %dl,0x7d(%eax)
80107714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107717:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010771b:	83 ca 10             	or     $0x10,%edx
8010771e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107721:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107724:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107728:	83 e2 9f             	and    $0xffffff9f,%edx
8010772b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010772e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107731:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107735:	83 ca 80             	or     $0xffffff80,%edx
80107738:	88 50 7d             	mov    %dl,0x7d(%eax)
8010773b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107742:	83 ca 0f             	or     $0xf,%edx
80107745:	88 50 7e             	mov    %dl,0x7e(%eax)
80107748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010774f:	83 e2 ef             	and    $0xffffffef,%edx
80107752:	88 50 7e             	mov    %dl,0x7e(%eax)
80107755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107758:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010775c:	83 e2 df             	and    $0xffffffdf,%edx
8010775f:	88 50 7e             	mov    %dl,0x7e(%eax)
80107762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107765:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107769:	83 ca 40             	or     $0x40,%edx
8010776c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010776f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107772:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107776:	83 ca 80             	or     $0xffffff80,%edx
80107779:	88 50 7e             	mov    %dl,0x7e(%eax)
8010777c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010777f:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107786:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010778d:	ff ff 
8010778f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107792:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107799:	00 00 
8010779b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010779e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077af:	83 e2 f0             	and    $0xfffffff0,%edx
801077b2:	83 ca 02             	or     $0x2,%edx
801077b5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077be:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077c5:	83 ca 10             	or     $0x10,%edx
801077c8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077d8:	83 e2 9f             	and    $0xffffff9f,%edx
801077db:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801077eb:	83 ca 80             	or     $0xffffff80,%edx
801077ee:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801077f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801077fe:	83 ca 0f             	or     $0xf,%edx
80107801:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107811:	83 e2 ef             	and    $0xffffffef,%edx
80107814:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010781a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010781d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107824:	83 e2 df             	and    $0xffffffdf,%edx
80107827:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010782d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107830:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107837:	83 ca 40             	or     $0x40,%edx
8010783a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107843:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010784a:	83 ca 80             	or     $0xffffff80,%edx
8010784d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107856:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010785d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107860:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107867:	ff ff 
80107869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786c:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107873:	00 00 
80107875:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107878:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010787f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107882:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107889:	83 e2 f0             	and    $0xfffffff0,%edx
8010788c:	83 ca 0a             	or     $0xa,%edx
8010788f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107898:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010789f:	83 ca 10             	or     $0x10,%edx
801078a2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ab:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078b2:	83 ca 60             	or     $0x60,%edx
801078b5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078be:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801078c5:	83 ca 80             	or     $0xffffff80,%edx
801078c8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801078ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078d8:	83 ca 0f             	or     $0xf,%edx
801078db:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078eb:	83 e2 ef             	and    $0xffffffef,%edx
801078ee:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801078f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f7:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801078fe:	83 e2 df             	and    $0xffffffdf,%edx
80107901:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010790a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107911:	83 ca 40             	or     $0x40,%edx
80107914:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010791a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107924:	83 ca 80             	or     $0xffffff80,%edx
80107927:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010792d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107930:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107937:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793a:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107941:	ff ff 
80107943:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107946:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010794d:	00 00 
8010794f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107952:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107963:	83 e2 f0             	and    $0xfffffff0,%edx
80107966:	83 ca 02             	or     $0x2,%edx
80107969:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010796f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107972:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107979:	83 ca 10             	or     $0x10,%edx
8010797c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107985:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010798c:	83 ca 60             	or     $0x60,%edx
8010798f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107995:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107998:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010799f:	83 ca 80             	or     $0xffffff80,%edx
801079a2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801079a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ab:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079b2:	83 ca 0f             	or     $0xf,%edx
801079b5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079be:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079c5:	83 e2 ef             	and    $0xffffffef,%edx
801079c8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079d8:	83 e2 df             	and    $0xffffffdf,%edx
801079db:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079eb:	83 ca 40             	or     $0x40,%edx
801079ee:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801079f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f7:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801079fe:	83 ca 80             	or     $0xffffff80,%edx
80107a01:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a14:	05 b4 00 00 00       	add    $0xb4,%eax
80107a19:	89 c3                	mov    %eax,%ebx
80107a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a1e:	05 b4 00 00 00       	add    $0xb4,%eax
80107a23:	c1 e8 10             	shr    $0x10,%eax
80107a26:	89 c2                	mov    %eax,%edx
80107a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2b:	05 b4 00 00 00       	add    $0xb4,%eax
80107a30:	c1 e8 18             	shr    $0x18,%eax
80107a33:	89 c1                	mov    %eax,%ecx
80107a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a38:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107a3f:	00 00 
80107a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a44:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4e:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a57:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a5e:	83 e2 f0             	and    $0xfffffff0,%edx
80107a61:	83 ca 02             	or     $0x2,%edx
80107a64:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a74:	83 ca 10             	or     $0x10,%edx
80107a77:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a80:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a87:	83 e2 9f             	and    $0xffffff9f,%edx
80107a8a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a93:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107a9a:	83 ca 80             	or     $0xffffff80,%edx
80107a9d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107aad:	83 e2 f0             	and    $0xfffffff0,%edx
80107ab0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ac0:	83 e2 ef             	and    $0xffffffef,%edx
80107ac3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ad3:	83 e2 df             	and    $0xffffffdf,%edx
80107ad6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adf:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107ae6:	83 ca 40             	or     $0x40,%edx
80107ae9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af2:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107af9:	83 ca 80             	or     $0xffffff80,%edx
80107afc:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b05:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0e:	83 c0 70             	add    $0x70,%eax
80107b11:	83 ec 08             	sub    $0x8,%esp
80107b14:	6a 38                	push   $0x38
80107b16:	50                   	push   %eax
80107b17:	e8 3c fb ff ff       	call   80107658 <lgdt>
80107b1c:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107b1f:	83 ec 0c             	sub    $0xc,%esp
80107b22:	6a 18                	push   $0x18
80107b24:	e8 6e fb ff ff       	call   80107697 <loadgs>
80107b29:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2f:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107b35:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107b3c:	00 00 00 00 
}
80107b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107b43:	c9                   	leave  
80107b44:	c3                   	ret    

80107b45 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b45:	55                   	push   %ebp
80107b46:	89 e5                	mov    %esp,%ebp
80107b48:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b4e:	c1 e8 16             	shr    $0x16,%eax
80107b51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b58:	8b 45 08             	mov    0x8(%ebp),%eax
80107b5b:	01 d0                	add    %edx,%eax
80107b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b63:	8b 00                	mov    (%eax),%eax
80107b65:	83 e0 01             	and    $0x1,%eax
80107b68:	85 c0                	test   %eax,%eax
80107b6a:	74 18                	je     80107b84 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b6f:	8b 00                	mov    (%eax),%eax
80107b71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b76:	50                   	push   %eax
80107b77:	e8 48 fb ff ff       	call   801076c4 <p2v>
80107b7c:	83 c4 04             	add    $0x4,%esp
80107b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b82:	eb 48                	jmp    80107bcc <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b88:	74 0e                	je     80107b98 <walkpgdir+0x53>
80107b8a:	e8 85 b0 ff ff       	call   80102c14 <kalloc>
80107b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b96:	75 07                	jne    80107b9f <walkpgdir+0x5a>
      return 0;
80107b98:	b8 00 00 00 00       	mov    $0x0,%eax
80107b9d:	eb 44                	jmp    80107be3 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b9f:	83 ec 04             	sub    $0x4,%esp
80107ba2:	68 00 10 00 00       	push   $0x1000
80107ba7:	6a 00                	push   $0x0
80107ba9:	ff 75 f4             	pushl  -0xc(%ebp)
80107bac:	e8 31 d6 ff ff       	call   801051e2 <memset>
80107bb1:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107bb4:	83 ec 0c             	sub    $0xc,%esp
80107bb7:	ff 75 f4             	pushl  -0xc(%ebp)
80107bba:	e8 f8 fa ff ff       	call   801076b7 <v2p>
80107bbf:	83 c4 10             	add    $0x10,%esp
80107bc2:	83 c8 07             	or     $0x7,%eax
80107bc5:	89 c2                	mov    %eax,%edx
80107bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bca:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bcf:	c1 e8 0c             	shr    $0xc,%eax
80107bd2:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be1:	01 d0                	add    %edx,%eax
}
80107be3:	c9                   	leave  
80107be4:	c3                   	ret    

80107be5 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107be5:	55                   	push   %ebp
80107be6:	89 e5                	mov    %esp,%ebp
80107be8:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107beb:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bf9:	8b 45 10             	mov    0x10(%ebp),%eax
80107bfc:	01 d0                	add    %edx,%eax
80107bfe:	83 e8 01             	sub    $0x1,%eax
80107c01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c09:	83 ec 04             	sub    $0x4,%esp
80107c0c:	6a 01                	push   $0x1
80107c0e:	ff 75 f4             	pushl  -0xc(%ebp)
80107c11:	ff 75 08             	pushl  0x8(%ebp)
80107c14:	e8 2c ff ff ff       	call   80107b45 <walkpgdir>
80107c19:	83 c4 10             	add    $0x10,%esp
80107c1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c1f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c23:	75 07                	jne    80107c2c <mappages+0x47>
      return -1;
80107c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c2a:	eb 49                	jmp    80107c75 <mappages+0x90>
    if(*pte & PTE_P)
80107c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c2f:	8b 00                	mov    (%eax),%eax
80107c31:	83 e0 01             	and    $0x1,%eax
80107c34:	85 c0                	test   %eax,%eax
80107c36:	74 0d                	je     80107c45 <mappages+0x60>
      panic("remap");
80107c38:	83 ec 0c             	sub    $0xc,%esp
80107c3b:	68 88 8a 10 80       	push   $0x80108a88
80107c40:	e8 17 89 ff ff       	call   8010055c <panic>
    *pte = pa | perm | PTE_P;
80107c45:	8b 45 18             	mov    0x18(%ebp),%eax
80107c48:	0b 45 14             	or     0x14(%ebp),%eax
80107c4b:	83 c8 01             	or     $0x1,%eax
80107c4e:	89 c2                	mov    %eax,%edx
80107c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c53:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c58:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c5b:	75 08                	jne    80107c65 <mappages+0x80>
      break;
80107c5d:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c5e:	b8 00 00 00 00       	mov    $0x0,%eax
80107c63:	eb 10                	jmp    80107c75 <mappages+0x90>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
80107c65:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c6c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c73:	eb 94                	jmp    80107c09 <mappages+0x24>
  return 0;
}
80107c75:	c9                   	leave  
80107c76:	c3                   	ret    

80107c77 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c77:	55                   	push   %ebp
80107c78:	89 e5                	mov    %esp,%ebp
80107c7a:	53                   	push   %ebx
80107c7b:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c7e:	e8 91 af ff ff       	call   80102c14 <kalloc>
80107c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c8a:	75 0a                	jne    80107c96 <setupkvm+0x1f>
    return 0;
80107c8c:	b8 00 00 00 00       	mov    $0x0,%eax
80107c91:	e9 8e 00 00 00       	jmp    80107d24 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80107c96:	83 ec 04             	sub    $0x4,%esp
80107c99:	68 00 10 00 00       	push   $0x1000
80107c9e:	6a 00                	push   $0x0
80107ca0:	ff 75 f0             	pushl  -0x10(%ebp)
80107ca3:	e8 3a d5 ff ff       	call   801051e2 <memset>
80107ca8:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107cab:	83 ec 0c             	sub    $0xc,%esp
80107cae:	68 00 00 00 0e       	push   $0xe000000
80107cb3:	e8 0c fa ff ff       	call   801076c4 <p2v>
80107cb8:	83 c4 10             	add    $0x10,%esp
80107cbb:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107cc0:	76 0d                	jbe    80107ccf <setupkvm+0x58>
    panic("PHYSTOP too high");
80107cc2:	83 ec 0c             	sub    $0xc,%esp
80107cc5:	68 8e 8a 10 80       	push   $0x80108a8e
80107cca:	e8 8d 88 ff ff       	call   8010055c <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ccf:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107cd6:	eb 40                	jmp    80107d18 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdb:	8b 48 0c             	mov    0xc(%eax),%ecx
80107cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce1:	8b 50 04             	mov    0x4(%eax),%edx
80107ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce7:	8b 58 08             	mov    0x8(%eax),%ebx
80107cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ced:	8b 40 04             	mov    0x4(%eax),%eax
80107cf0:	29 c3                	sub    %eax,%ebx
80107cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf5:	8b 00                	mov    (%eax),%eax
80107cf7:	83 ec 0c             	sub    $0xc,%esp
80107cfa:	51                   	push   %ecx
80107cfb:	52                   	push   %edx
80107cfc:	53                   	push   %ebx
80107cfd:	50                   	push   %eax
80107cfe:	ff 75 f0             	pushl  -0x10(%ebp)
80107d01:	e8 df fe ff ff       	call   80107be5 <mappages>
80107d06:	83 c4 20             	add    $0x20,%esp
80107d09:	85 c0                	test   %eax,%eax
80107d0b:	79 07                	jns    80107d14 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107d0d:	b8 00 00 00 00       	mov    $0x0,%eax
80107d12:	eb 10                	jmp    80107d24 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d14:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107d18:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107d1f:	72 b7                	jb     80107cd8 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107d24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107d27:	c9                   	leave  
80107d28:	c3                   	ret    

80107d29 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107d29:	55                   	push   %ebp
80107d2a:	89 e5                	mov    %esp,%ebp
80107d2c:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d2f:	e8 43 ff ff ff       	call   80107c77 <setupkvm>
80107d34:	a3 58 52 11 80       	mov    %eax,0x80115258
  switchkvm();
80107d39:	e8 02 00 00 00       	call   80107d40 <switchkvm>
}
80107d3e:	c9                   	leave  
80107d3f:	c3                   	ret    

80107d40 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107d43:	a1 58 52 11 80       	mov    0x80115258,%eax
80107d48:	50                   	push   %eax
80107d49:	e8 69 f9 ff ff       	call   801076b7 <v2p>
80107d4e:	83 c4 04             	add    $0x4,%esp
80107d51:	50                   	push   %eax
80107d52:	e8 55 f9 ff ff       	call   801076ac <lcr3>
80107d57:	83 c4 04             	add    $0x4,%esp
}
80107d5a:	c9                   	leave  
80107d5b:	c3                   	ret    

80107d5c <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d5c:	55                   	push   %ebp
80107d5d:	89 e5                	mov    %esp,%ebp
80107d5f:	56                   	push   %esi
80107d60:	53                   	push   %ebx
  pushcli();
80107d61:	e8 7a d3 ff ff       	call   801050e0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107d66:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107d6c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d73:	83 c2 08             	add    $0x8,%edx
80107d76:	89 d6                	mov    %edx,%esi
80107d78:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d7f:	83 c2 08             	add    $0x8,%edx
80107d82:	c1 ea 10             	shr    $0x10,%edx
80107d85:	89 d3                	mov    %edx,%ebx
80107d87:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107d8e:	83 c2 08             	add    $0x8,%edx
80107d91:	c1 ea 18             	shr    $0x18,%edx
80107d94:	89 d1                	mov    %edx,%ecx
80107d96:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107d9d:	67 00 
80107d9f:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80107da6:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107dac:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107db3:	83 e2 f0             	and    $0xfffffff0,%edx
80107db6:	83 ca 09             	or     $0x9,%edx
80107db9:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107dbf:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107dc6:	83 ca 10             	or     $0x10,%edx
80107dc9:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107dcf:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107dd6:	83 e2 9f             	and    $0xffffff9f,%edx
80107dd9:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ddf:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107de6:	83 ca 80             	or     $0xffffff80,%edx
80107de9:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107def:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107df6:	83 e2 f0             	and    $0xfffffff0,%edx
80107df9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107dff:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e06:	83 e2 ef             	and    $0xffffffef,%edx
80107e09:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e0f:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e16:	83 e2 df             	and    $0xffffffdf,%edx
80107e19:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e1f:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e26:	83 ca 40             	or     $0x40,%edx
80107e29:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e2f:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80107e36:	83 e2 7f             	and    $0x7f,%edx
80107e39:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107e3f:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107e45:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e4b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107e52:	83 e2 ef             	and    $0xffffffef,%edx
80107e55:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107e5b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e61:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107e67:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e6d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107e74:	8b 52 08             	mov    0x8(%edx),%edx
80107e77:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e7d:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107e80:	83 ec 0c             	sub    $0xc,%esp
80107e83:	6a 30                	push   $0x30
80107e85:	e8 f7 f7 ff ff       	call   80107681 <ltr>
80107e8a:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80107e8d:	8b 45 08             	mov    0x8(%ebp),%eax
80107e90:	8b 40 04             	mov    0x4(%eax),%eax
80107e93:	85 c0                	test   %eax,%eax
80107e95:	75 0d                	jne    80107ea4 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80107e97:	83 ec 0c             	sub    $0xc,%esp
80107e9a:	68 9f 8a 10 80       	push   $0x80108a9f
80107e9f:	e8 b8 86 ff ff       	call   8010055c <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107ea4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ea7:	8b 40 04             	mov    0x4(%eax),%eax
80107eaa:	83 ec 0c             	sub    $0xc,%esp
80107ead:	50                   	push   %eax
80107eae:	e8 04 f8 ff ff       	call   801076b7 <v2p>
80107eb3:	83 c4 10             	add    $0x10,%esp
80107eb6:	83 ec 0c             	sub    $0xc,%esp
80107eb9:	50                   	push   %eax
80107eba:	e8 ed f7 ff ff       	call   801076ac <lcr3>
80107ebf:	83 c4 10             	add    $0x10,%esp
  popcli();
80107ec2:	e8 5d d2 ff ff       	call   80105124 <popcli>
}
80107ec7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107eca:	5b                   	pop    %ebx
80107ecb:	5e                   	pop    %esi
80107ecc:	5d                   	pop    %ebp
80107ecd:	c3                   	ret    

80107ece <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ece:	55                   	push   %ebp
80107ecf:	89 e5                	mov    %esp,%ebp
80107ed1:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107ed4:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107edb:	76 0d                	jbe    80107eea <inituvm+0x1c>
    panic("inituvm: more than a page");
80107edd:	83 ec 0c             	sub    $0xc,%esp
80107ee0:	68 b3 8a 10 80       	push   $0x80108ab3
80107ee5:	e8 72 86 ff ff       	call   8010055c <panic>
  mem = kalloc();
80107eea:	e8 25 ad ff ff       	call   80102c14 <kalloc>
80107eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107ef2:	83 ec 04             	sub    $0x4,%esp
80107ef5:	68 00 10 00 00       	push   $0x1000
80107efa:	6a 00                	push   $0x0
80107efc:	ff 75 f4             	pushl  -0xc(%ebp)
80107eff:	e8 de d2 ff ff       	call   801051e2 <memset>
80107f04:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107f07:	83 ec 0c             	sub    $0xc,%esp
80107f0a:	ff 75 f4             	pushl  -0xc(%ebp)
80107f0d:	e8 a5 f7 ff ff       	call   801076b7 <v2p>
80107f12:	83 c4 10             	add    $0x10,%esp
80107f15:	83 ec 0c             	sub    $0xc,%esp
80107f18:	6a 06                	push   $0x6
80107f1a:	50                   	push   %eax
80107f1b:	68 00 10 00 00       	push   $0x1000
80107f20:	6a 00                	push   $0x0
80107f22:	ff 75 08             	pushl  0x8(%ebp)
80107f25:	e8 bb fc ff ff       	call   80107be5 <mappages>
80107f2a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80107f2d:	83 ec 04             	sub    $0x4,%esp
80107f30:	ff 75 10             	pushl  0x10(%ebp)
80107f33:	ff 75 0c             	pushl  0xc(%ebp)
80107f36:	ff 75 f4             	pushl  -0xc(%ebp)
80107f39:	e8 63 d3 ff ff       	call   801052a1 <memmove>
80107f3e:	83 c4 10             	add    $0x10,%esp
}
80107f41:	c9                   	leave  
80107f42:	c3                   	ret    

80107f43 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f43:	55                   	push   %ebp
80107f44:	89 e5                	mov    %esp,%ebp
80107f46:	53                   	push   %ebx
80107f47:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f4d:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f52:	85 c0                	test   %eax,%eax
80107f54:	74 0d                	je     80107f63 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80107f56:	83 ec 0c             	sub    $0xc,%esp
80107f59:	68 d0 8a 10 80       	push   $0x80108ad0
80107f5e:	e8 f9 85 ff ff       	call   8010055c <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f6a:	e9 95 00 00 00       	jmp    80108004 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f75:	01 d0                	add    %edx,%eax
80107f77:	83 ec 04             	sub    $0x4,%esp
80107f7a:	6a 00                	push   $0x0
80107f7c:	50                   	push   %eax
80107f7d:	ff 75 08             	pushl  0x8(%ebp)
80107f80:	e8 c0 fb ff ff       	call   80107b45 <walkpgdir>
80107f85:	83 c4 10             	add    $0x10,%esp
80107f88:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f8f:	75 0d                	jne    80107f9e <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80107f91:	83 ec 0c             	sub    $0xc,%esp
80107f94:	68 f3 8a 10 80       	push   $0x80108af3
80107f99:	e8 be 85 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
80107f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fa1:	8b 00                	mov    (%eax),%eax
80107fa3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107fab:	8b 45 18             	mov    0x18(%ebp),%eax
80107fae:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107fb1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107fb6:	77 0b                	ja     80107fc3 <loaduvm+0x80>
      n = sz - i;
80107fb8:	8b 45 18             	mov    0x18(%ebp),%eax
80107fbb:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107fbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fc1:	eb 07                	jmp    80107fca <loaduvm+0x87>
    else
      n = PGSIZE;
80107fc3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107fca:	8b 55 14             	mov    0x14(%ebp),%edx
80107fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107fd3:	83 ec 0c             	sub    $0xc,%esp
80107fd6:	ff 75 e8             	pushl  -0x18(%ebp)
80107fd9:	e8 e6 f6 ff ff       	call   801076c4 <p2v>
80107fde:	83 c4 10             	add    $0x10,%esp
80107fe1:	ff 75 f0             	pushl  -0x10(%ebp)
80107fe4:	53                   	push   %ebx
80107fe5:	50                   	push   %eax
80107fe6:	ff 75 10             	pushl  0x10(%ebp)
80107fe9:	e8 a3 9e ff ff       	call   80101e91 <readi>
80107fee:	83 c4 10             	add    $0x10,%esp
80107ff1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107ff4:	74 07                	je     80107ffd <loaduvm+0xba>
      return -1;
80107ff6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ffb:	eb 18                	jmp    80108015 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107ffd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108007:	3b 45 18             	cmp    0x18(%ebp),%eax
8010800a:	0f 82 5f ff ff ff    	jb     80107f6f <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108010:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108018:	c9                   	leave  
80108019:	c3                   	ret    

8010801a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010801a:	55                   	push   %ebp
8010801b:	89 e5                	mov    %esp,%ebp
8010801d:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108020:	8b 45 10             	mov    0x10(%ebp),%eax
80108023:	85 c0                	test   %eax,%eax
80108025:	79 0a                	jns    80108031 <allocuvm+0x17>
    return 0;
80108027:	b8 00 00 00 00       	mov    $0x0,%eax
8010802c:	e9 b0 00 00 00       	jmp    801080e1 <allocuvm+0xc7>
  if(newsz < oldsz)
80108031:	8b 45 10             	mov    0x10(%ebp),%eax
80108034:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108037:	73 08                	jae    80108041 <allocuvm+0x27>
    return oldsz;
80108039:	8b 45 0c             	mov    0xc(%ebp),%eax
8010803c:	e9 a0 00 00 00       	jmp    801080e1 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108041:	8b 45 0c             	mov    0xc(%ebp),%eax
80108044:	05 ff 0f 00 00       	add    $0xfff,%eax
80108049:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010804e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108051:	eb 7f                	jmp    801080d2 <allocuvm+0xb8>
    mem = kalloc();
80108053:	e8 bc ab ff ff       	call   80102c14 <kalloc>
80108058:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010805b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010805f:	75 2b                	jne    8010808c <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108061:	83 ec 0c             	sub    $0xc,%esp
80108064:	68 11 8b 10 80       	push   $0x80108b11
80108069:	e8 51 83 ff ff       	call   801003bf <cprintf>
8010806e:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108071:	83 ec 04             	sub    $0x4,%esp
80108074:	ff 75 0c             	pushl  0xc(%ebp)
80108077:	ff 75 10             	pushl  0x10(%ebp)
8010807a:	ff 75 08             	pushl  0x8(%ebp)
8010807d:	e8 61 00 00 00       	call   801080e3 <deallocuvm>
80108082:	83 c4 10             	add    $0x10,%esp
      return 0;
80108085:	b8 00 00 00 00       	mov    $0x0,%eax
8010808a:	eb 55                	jmp    801080e1 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
8010808c:	83 ec 04             	sub    $0x4,%esp
8010808f:	68 00 10 00 00       	push   $0x1000
80108094:	6a 00                	push   $0x0
80108096:	ff 75 f0             	pushl  -0x10(%ebp)
80108099:	e8 44 d1 ff ff       	call   801051e2 <memset>
8010809e:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801080a1:	83 ec 0c             	sub    $0xc,%esp
801080a4:	ff 75 f0             	pushl  -0x10(%ebp)
801080a7:	e8 0b f6 ff ff       	call   801076b7 <v2p>
801080ac:	83 c4 10             	add    $0x10,%esp
801080af:	89 c2                	mov    %eax,%edx
801080b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b4:	83 ec 0c             	sub    $0xc,%esp
801080b7:	6a 06                	push   $0x6
801080b9:	52                   	push   %edx
801080ba:	68 00 10 00 00       	push   $0x1000
801080bf:	50                   	push   %eax
801080c0:	ff 75 08             	pushl  0x8(%ebp)
801080c3:	e8 1d fb ff ff       	call   80107be5 <mappages>
801080c8:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801080cb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d5:	3b 45 10             	cmp    0x10(%ebp),%eax
801080d8:	0f 82 75 ff ff ff    	jb     80108053 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801080de:	8b 45 10             	mov    0x10(%ebp),%eax
}
801080e1:	c9                   	leave  
801080e2:	c3                   	ret    

801080e3 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080e3:	55                   	push   %ebp
801080e4:	89 e5                	mov    %esp,%ebp
801080e6:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801080e9:	8b 45 10             	mov    0x10(%ebp),%eax
801080ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080ef:	72 08                	jb     801080f9 <deallocuvm+0x16>
    return oldsz;
801080f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801080f4:	e9 a5 00 00 00       	jmp    8010819e <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801080f9:	8b 45 10             	mov    0x10(%ebp),%eax
801080fc:	05 ff 0f 00 00       	add    $0xfff,%eax
80108101:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108109:	e9 81 00 00 00       	jmp    8010818f <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010810e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108111:	83 ec 04             	sub    $0x4,%esp
80108114:	6a 00                	push   $0x0
80108116:	50                   	push   %eax
80108117:	ff 75 08             	pushl  0x8(%ebp)
8010811a:	e8 26 fa ff ff       	call   80107b45 <walkpgdir>
8010811f:	83 c4 10             	add    $0x10,%esp
80108122:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108125:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108129:	75 09                	jne    80108134 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
8010812b:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108132:	eb 54                	jmp    80108188 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108134:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108137:	8b 00                	mov    (%eax),%eax
80108139:	83 e0 01             	and    $0x1,%eax
8010813c:	85 c0                	test   %eax,%eax
8010813e:	74 48                	je     80108188 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108140:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108143:	8b 00                	mov    (%eax),%eax
80108145:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010814a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
8010814d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108151:	75 0d                	jne    80108160 <deallocuvm+0x7d>
        panic("kfree");
80108153:	83 ec 0c             	sub    $0xc,%esp
80108156:	68 29 8b 10 80       	push   $0x80108b29
8010815b:	e8 fc 83 ff ff       	call   8010055c <panic>
      char *v = p2v(pa);
80108160:	83 ec 0c             	sub    $0xc,%esp
80108163:	ff 75 ec             	pushl  -0x14(%ebp)
80108166:	e8 59 f5 ff ff       	call   801076c4 <p2v>
8010816b:	83 c4 10             	add    $0x10,%esp
8010816e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108171:	83 ec 0c             	sub    $0xc,%esp
80108174:	ff 75 e8             	pushl  -0x18(%ebp)
80108177:	e8 fc a9 ff ff       	call   80102b78 <kfree>
8010817c:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010817f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108182:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108188:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010818f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108192:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108195:	0f 82 73 ff ff ff    	jb     8010810e <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010819b:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010819e:	c9                   	leave  
8010819f:	c3                   	ret    

801081a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801081a0:	55                   	push   %ebp
801081a1:	89 e5                	mov    %esp,%ebp
801081a3:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801081a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801081aa:	75 0d                	jne    801081b9 <freevm+0x19>
    panic("freevm: no pgdir");
801081ac:	83 ec 0c             	sub    $0xc,%esp
801081af:	68 2f 8b 10 80       	push   $0x80108b2f
801081b4:	e8 a3 83 ff ff       	call   8010055c <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801081b9:	83 ec 04             	sub    $0x4,%esp
801081bc:	6a 00                	push   $0x0
801081be:	68 00 00 00 80       	push   $0x80000000
801081c3:	ff 75 08             	pushl  0x8(%ebp)
801081c6:	e8 18 ff ff ff       	call   801080e3 <deallocuvm>
801081cb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801081ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801081d5:	eb 4f                	jmp    80108226 <freevm+0x86>
    if(pgdir[i] & PTE_P){
801081d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081e1:	8b 45 08             	mov    0x8(%ebp),%eax
801081e4:	01 d0                	add    %edx,%eax
801081e6:	8b 00                	mov    (%eax),%eax
801081e8:	83 e0 01             	and    $0x1,%eax
801081eb:	85 c0                	test   %eax,%eax
801081ed:	74 33                	je     80108222 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801081ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801081f9:	8b 45 08             	mov    0x8(%ebp),%eax
801081fc:	01 d0                	add    %edx,%eax
801081fe:	8b 00                	mov    (%eax),%eax
80108200:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108205:	83 ec 0c             	sub    $0xc,%esp
80108208:	50                   	push   %eax
80108209:	e8 b6 f4 ff ff       	call   801076c4 <p2v>
8010820e:	83 c4 10             	add    $0x10,%esp
80108211:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108214:	83 ec 0c             	sub    $0xc,%esp
80108217:	ff 75 f0             	pushl  -0x10(%ebp)
8010821a:	e8 59 a9 ff ff       	call   80102b78 <kfree>
8010821f:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108222:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108226:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010822d:	76 a8                	jbe    801081d7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010822f:	83 ec 0c             	sub    $0xc,%esp
80108232:	ff 75 08             	pushl  0x8(%ebp)
80108235:	e8 3e a9 ff ff       	call   80102b78 <kfree>
8010823a:	83 c4 10             	add    $0x10,%esp
}
8010823d:	c9                   	leave  
8010823e:	c3                   	ret    

8010823f <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010823f:	55                   	push   %ebp
80108240:	89 e5                	mov    %esp,%ebp
80108242:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108245:	83 ec 04             	sub    $0x4,%esp
80108248:	6a 00                	push   $0x0
8010824a:	ff 75 0c             	pushl  0xc(%ebp)
8010824d:	ff 75 08             	pushl  0x8(%ebp)
80108250:	e8 f0 f8 ff ff       	call   80107b45 <walkpgdir>
80108255:	83 c4 10             	add    $0x10,%esp
80108258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010825b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010825f:	75 0d                	jne    8010826e <clearpteu+0x2f>
    panic("clearpteu");
80108261:	83 ec 0c             	sub    $0xc,%esp
80108264:	68 40 8b 10 80       	push   $0x80108b40
80108269:	e8 ee 82 ff ff       	call   8010055c <panic>
  *pte &= ~PTE_U;
8010826e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108271:	8b 00                	mov    (%eax),%eax
80108273:	83 e0 fb             	and    $0xfffffffb,%eax
80108276:	89 c2                	mov    %eax,%edx
80108278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827b:	89 10                	mov    %edx,(%eax)
}
8010827d:	c9                   	leave  
8010827e:	c3                   	ret    

8010827f <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010827f:	55                   	push   %ebp
80108280:	89 e5                	mov    %esp,%ebp
80108282:	53                   	push   %ebx
80108283:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108286:	e8 ec f9 ff ff       	call   80107c77 <setupkvm>
8010828b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010828e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108292:	75 0a                	jne    8010829e <copyuvm+0x1f>
    return 0;
80108294:	b8 00 00 00 00       	mov    $0x0,%eax
80108299:	e9 f8 00 00 00       	jmp    80108396 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010829e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082a5:	e9 c8 00 00 00       	jmp    80108372 <copyuvm+0xf3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801082aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ad:	83 ec 04             	sub    $0x4,%esp
801082b0:	6a 00                	push   $0x0
801082b2:	50                   	push   %eax
801082b3:	ff 75 08             	pushl  0x8(%ebp)
801082b6:	e8 8a f8 ff ff       	call   80107b45 <walkpgdir>
801082bb:	83 c4 10             	add    $0x10,%esp
801082be:	89 45 ec             	mov    %eax,-0x14(%ebp)
801082c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801082c5:	75 0d                	jne    801082d4 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
801082c7:	83 ec 0c             	sub    $0xc,%esp
801082ca:	68 4a 8b 10 80       	push   $0x80108b4a
801082cf:	e8 88 82 ff ff       	call   8010055c <panic>
    if(!(*pte & PTE_P))
801082d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082d7:	8b 00                	mov    (%eax),%eax
801082d9:	83 e0 01             	and    $0x1,%eax
801082dc:	85 c0                	test   %eax,%eax
801082de:	75 0d                	jne    801082ed <copyuvm+0x6e>
      panic("copyuvm: page not present");
801082e0:	83 ec 0c             	sub    $0xc,%esp
801082e3:	68 64 8b 10 80       	push   $0x80108b64
801082e8:	e8 6f 82 ff ff       	call   8010055c <panic>
    pa = PTE_ADDR(*pte);
801082ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082f0:	8b 00                	mov    (%eax),%eax
801082f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801082fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801082fd:	8b 00                	mov    (%eax),%eax
801082ff:	25 ff 0f 00 00       	and    $0xfff,%eax
80108304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108307:	e8 08 a9 ff ff       	call   80102c14 <kalloc>
8010830c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010830f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108313:	75 02                	jne    80108317 <copyuvm+0x98>
      goto bad;
80108315:	eb 6c                	jmp    80108383 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108317:	83 ec 0c             	sub    $0xc,%esp
8010831a:	ff 75 e8             	pushl  -0x18(%ebp)
8010831d:	e8 a2 f3 ff ff       	call   801076c4 <p2v>
80108322:	83 c4 10             	add    $0x10,%esp
80108325:	83 ec 04             	sub    $0x4,%esp
80108328:	68 00 10 00 00       	push   $0x1000
8010832d:	50                   	push   %eax
8010832e:	ff 75 e0             	pushl  -0x20(%ebp)
80108331:	e8 6b cf ff ff       	call   801052a1 <memmove>
80108336:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108339:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010833c:	83 ec 0c             	sub    $0xc,%esp
8010833f:	ff 75 e0             	pushl  -0x20(%ebp)
80108342:	e8 70 f3 ff ff       	call   801076b7 <v2p>
80108347:	83 c4 10             	add    $0x10,%esp
8010834a:	89 c2                	mov    %eax,%edx
8010834c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834f:	83 ec 0c             	sub    $0xc,%esp
80108352:	53                   	push   %ebx
80108353:	52                   	push   %edx
80108354:	68 00 10 00 00       	push   $0x1000
80108359:	50                   	push   %eax
8010835a:	ff 75 f0             	pushl  -0x10(%ebp)
8010835d:	e8 83 f8 ff ff       	call   80107be5 <mappages>
80108362:	83 c4 20             	add    $0x20,%esp
80108365:	85 c0                	test   %eax,%eax
80108367:	79 02                	jns    8010836b <copyuvm+0xec>
      goto bad;
80108369:	eb 18                	jmp    80108383 <copyuvm+0x104>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010836b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108375:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108378:	0f 82 2c ff ff ff    	jb     801082aa <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010837e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108381:	eb 13                	jmp    80108396 <copyuvm+0x117>

bad:
  freevm(d);
80108383:	83 ec 0c             	sub    $0xc,%esp
80108386:	ff 75 f0             	pushl  -0x10(%ebp)
80108389:	e8 12 fe ff ff       	call   801081a0 <freevm>
8010838e:	83 c4 10             	add    $0x10,%esp
  return 0;
80108391:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108396:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108399:	c9                   	leave  
8010839a:	c3                   	ret    

8010839b <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010839b:	55                   	push   %ebp
8010839c:	89 e5                	mov    %esp,%ebp
8010839e:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801083a1:	83 ec 04             	sub    $0x4,%esp
801083a4:	6a 00                	push   $0x0
801083a6:	ff 75 0c             	pushl  0xc(%ebp)
801083a9:	ff 75 08             	pushl  0x8(%ebp)
801083ac:	e8 94 f7 ff ff       	call   80107b45 <walkpgdir>
801083b1:	83 c4 10             	add    $0x10,%esp
801083b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801083b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ba:	8b 00                	mov    (%eax),%eax
801083bc:	83 e0 01             	and    $0x1,%eax
801083bf:	85 c0                	test   %eax,%eax
801083c1:	75 07                	jne    801083ca <uva2ka+0x2f>
    return 0;
801083c3:	b8 00 00 00 00       	mov    $0x0,%eax
801083c8:	eb 29                	jmp    801083f3 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801083ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083cd:	8b 00                	mov    (%eax),%eax
801083cf:	83 e0 04             	and    $0x4,%eax
801083d2:	85 c0                	test   %eax,%eax
801083d4:	75 07                	jne    801083dd <uva2ka+0x42>
    return 0;
801083d6:	b8 00 00 00 00       	mov    $0x0,%eax
801083db:	eb 16                	jmp    801083f3 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
801083dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e0:	8b 00                	mov    (%eax),%eax
801083e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083e7:	83 ec 0c             	sub    $0xc,%esp
801083ea:	50                   	push   %eax
801083eb:	e8 d4 f2 ff ff       	call   801076c4 <p2v>
801083f0:	83 c4 10             	add    $0x10,%esp
}
801083f3:	c9                   	leave  
801083f4:	c3                   	ret    

801083f5 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801083f5:	55                   	push   %ebp
801083f6:	89 e5                	mov    %esp,%ebp
801083f8:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801083fb:	8b 45 10             	mov    0x10(%ebp),%eax
801083fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108401:	eb 7f                	jmp    80108482 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108403:	8b 45 0c             	mov    0xc(%ebp),%eax
80108406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010840b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010840e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108411:	83 ec 08             	sub    $0x8,%esp
80108414:	50                   	push   %eax
80108415:	ff 75 08             	pushl  0x8(%ebp)
80108418:	e8 7e ff ff ff       	call   8010839b <uva2ka>
8010841d:	83 c4 10             	add    $0x10,%esp
80108420:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108423:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108427:	75 07                	jne    80108430 <copyout+0x3b>
      return -1;
80108429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010842e:	eb 61                	jmp    80108491 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108430:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108433:	2b 45 0c             	sub    0xc(%ebp),%eax
80108436:	05 00 10 00 00       	add    $0x1000,%eax
8010843b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010843e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108441:	3b 45 14             	cmp    0x14(%ebp),%eax
80108444:	76 06                	jbe    8010844c <copyout+0x57>
      n = len;
80108446:	8b 45 14             	mov    0x14(%ebp),%eax
80108449:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010844c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010844f:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108452:	89 c2                	mov    %eax,%edx
80108454:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108457:	01 d0                	add    %edx,%eax
80108459:	83 ec 04             	sub    $0x4,%esp
8010845c:	ff 75 f0             	pushl  -0x10(%ebp)
8010845f:	ff 75 f4             	pushl  -0xc(%ebp)
80108462:	50                   	push   %eax
80108463:	e8 39 ce ff ff       	call   801052a1 <memmove>
80108468:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010846b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010846e:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108474:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108477:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010847a:	05 00 10 00 00       	add    $0x1000,%eax
8010847f:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108482:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108486:	0f 85 77 ff ff ff    	jne    80108403 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010848c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108491:	c9                   	leave  
80108492:	c3                   	ret    
